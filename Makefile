SHELL := /bin/sh

# ==============================================================================
# PROJECT CONFIGURATION
# ==============================================================================

PACKAGE ?= commandloom

SOURCE_DIR ?= src
TEST_DIR ?= tests
EXAMPLE_CONFIG ?= examples/loom.yaml
DIST_DIR ?= dist

PYTHON ?= python3
VENV ?= .venv
VENV_PYTHON := $(VENV)/bin/python
VENV_PIP := $(VENV)/bin/pip

# Python used for project commands after the environment is created.
TOOL_PYTHON ?= $(VENV_PYTHON)

# ==============================================================================
# DEVELOPMENT TOOLS
# ==============================================================================

# Test runner
TEST_RUNNER ?= $(TOOL_PYTHON) -m pytest
TEST_ARGS ?= $(TEST_DIR)

# Coverage runner
COVERAGE_RUNNER ?= $(TOOL_PYTHON) -m pytest
COVERAGE_ARGS ?= --cov=$(PACKAGE) --cov-report=term-missing --cov-report=html $(TEST_DIR)

# Linter
LINTER ?= $(TOOL_PYTHON) -m ruff check
LINT_ARGS ?= $(SOURCE_DIR) $(TEST_DIR)

# Automatic lint fixes
LINT_FIXER ?= $(TOOL_PYTHON) -m ruff check --fix
LINT_FIX_ARGS ?= $(SOURCE_DIR) $(TEST_DIR)

# Formatter
FORMATTER ?= $(TOOL_PYTHON) -m ruff format
FORMAT_ARGS ?= $(SOURCE_DIR) $(TEST_DIR)

# Formatting validation
FORMAT_CHECKER ?= $(TOOL_PYTHON) -m ruff format --check
FORMAT_CHECK_ARGS ?= $(SOURCE_DIR) $(TEST_DIR)

# Static type checker
TYPE_CHECKER ?= $(TOOL_PYTHON) -m mypy
TYPE_CHECK_ARGS ?= $(SOURCE_DIR)

# Package builder
PACKAGE_BUILDER ?= $(TOOL_PYTHON) -m build
PACKAGE_BUILD_ARGS ?=

# Distribution validator
PACKAGE_CHECKER ?= $(TOOL_PYTHON) -m twine check
PACKAGE_CHECK_ARGS ?= $(DIST_DIR)/*

# Package publisher
PACKAGE_PUBLISHER ?= $(TOOL_PYTHON) -m twine upload
PACKAGE_PUBLISH_ARGS ?= $(DIST_DIR)/*

# TestPyPI publisher
TEST_PACKAGE_PUBLISHER ?= $(TOOL_PYTHON) -m twine upload --repository testpypi
TEST_PACKAGE_PUBLISH_ARGS ?= $(DIST_DIR)/*

# Application runner
APP_RUNNER ?= $(TOOL_PYTHON) -m $(PACKAGE)

.DEFAULT_GOAL := help

# ==============================================================================
# HELP
# ==============================================================================

.PHONY: help
help:
	@printf '%s\n' \
		'CommandLoom development commands:' \
		'' \
		'  make setup          Create the virtual environment and install dependencies' \
		'  make install        Install the package in editable mode' \
		'  make install-dev    Install the package with development dependencies' \
		'  make run            Display the CommandLoom CLI help' \
		'  make list           List configured CommandLoom tasks' \
		'  make example        List tasks from the example configuration' \
		'  make test           Run the test suite' \
		'  make coverage       Run tests with coverage reporting' \
		'  make lint           Run static analysis' \
		'  make lint-fix       Apply automatic lint fixes' \
		'  make format         Format source and test files' \
		'  make format-check   Verify formatting without modifying files' \
		'  make typecheck      Run static type checking' \
		'  make check          Run all validation commands' \
		'  make build          Build source and wheel distributions' \
		'  make package-check  Validate generated distributions' \
		'  make publish-test   Upload distributions to TestPyPI' \
		'  make publish        Upload distributions to PyPI' \
		'  make clean          Remove generated files and caches'

# ==============================================================================
# ENVIRONMENT
# ==============================================================================

.PHONY: setup
setup: $(VENV)/bin/activate

$(VENV)/bin/activate:
	$(PYTHON) -m venv $(VENV)
	$(VENV_PYTHON) -m pip install --upgrade pip
	$(VENV_PYTHON) -m pip install -e ".[dev]"

.PHONY: install
install:
	$(TOOL_PYTHON) -m pip install -e .

.PHONY: install-dev
install-dev:
	$(TOOL_PYTHON) -m pip install -e ".[dev]"

# ==============================================================================
# APPLICATION
# ==============================================================================

.PHONY: run
run:
	$(APP_RUNNER) --help

.PHONY: list
list:
	$(APP_RUNNER) list

.PHONY: example
example:
	$(APP_RUNNER) --config $(EXAMPLE_CONFIG) list

# ==============================================================================
# TESTING
# ==============================================================================

.PHONY: test
test:
	$(TEST_RUNNER) $(TEST_ARGS)

.PHONY: coverage
coverage:
	$(COVERAGE_RUNNER) $(COVERAGE_ARGS)

# ==============================================================================
# CODE QUALITY
# ==============================================================================

.PHONY: lint
lint:
	$(LINTER) $(LINT_ARGS)

.PHONY: lint-fix
lint-fix:
	$(LINT_FIXER) $(LINT_FIX_ARGS)

.PHONY: format
format:
	$(FORMATTER) $(FORMAT_ARGS)

.PHONY: format-check
format-check:
	$(FORMAT_CHECKER) $(FORMAT_CHECK_ARGS)

.PHONY: typecheck
typecheck:
	$(TYPE_CHECKER) $(TYPE_CHECK_ARGS)

.PHONY: check
check: format-check lint typecheck test

# ==============================================================================
# PACKAGING
# ==============================================================================

.PHONY: build
build: clean
	$(PACKAGE_BUILDER) $(PACKAGE_BUILD_ARGS)

.PHONY: package-check
package-check: build
	$(PACKAGE_CHECKER) $(PACKAGE_CHECK_ARGS)

.PHONY: publish-test
publish-test: package-check
	$(TEST_PACKAGE_PUBLISHER) $(TEST_PACKAGE_PUBLISH_ARGS)

.PHONY: publish
publish: package-check
	$(PACKAGE_PUBLISHER) $(PACKAGE_PUBLISH_ARGS)

# ==============================================================================
# CLEANUP
# ==============================================================================

.PHONY: clean
clean:
	rm -rf \
		$(DIST_DIR) \
		build \
		htmlcov \
		.pytest_cache \
		.mypy_cache \
		.ruff_cache \
		.coverage
	find . -type d -name '__pycache__' -prune -exec rm -rf {} +
	find . -type d -name '*.egg-info' -prune -exec rm -rf {} +
	find . -type f -name '*.pyc' -delete
