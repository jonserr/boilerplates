# Script Shebang and Header Templates

Reusable starter templates for Slurm `sbatch`, Bash, Python, and R scripts. 
Each template has a shebang, compact file header, and starter lines.

## Slurm sbatch

### Script header template: `my_job.sbatch`

```bash
#!/usr/bin/env bash
# Purpose: One-line description of the scheduled job, expected inputs, and outputs.
# Usage: sbatch my_job.sbatch
# Inputs: - INPUT_PATH: /path/to/input
# Outputs: - OUTPUT_DIR: /path/to/output
# Environment: - ENV_VAR_NAME: Optional environment variable description.
# Author: Jonathan Serrano
# Created: June 20, 2026
# Version: 1.0.0

#SBATCH --job-name=job_name
#SBATCH --partition=partition_name
#SBATCH --account=account_name
#SBATCH --qos=qos_name
#SBATCH --time=00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --output=logs/%x_%j.out
#SBATCH --error=logs/%x_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=user@example.com
#SBATCH --chdir=/path/to/working_directory
#SBATCH --export=NONE

set -Eeuo pipefail

mkdir -p logs

echo "Job started: $(date)"
echo "Job ID: ${SLURM_JOB_ID:-NA}"
echo "Job name: ${SLURM_JOB_NAME:-NA}"
echo "Node list: ${SLURM_JOB_NODELIST:-NA}"
echo "Working directory: $(pwd)"

# module purge
# module load module_name/version
# source /path/to/venv/bin/activate
```

## Bash

### Script header template: `my_script.sh`

```bash
#!/usr/bin/env bash
# Purpose: One-line description of what this script does.
# Usage: ./my_script.sh --input /path/to/input --output /path/to/output
# Inputs: - --input: Input file or directory.
# Outputs: - --output: Output file or directory.
# Environment: - ENV_VAR_NAME: Optional environment variable description.
# Author: Jonathan Serrano
# Created: June 20, 2026
# Version: 1.0.0

set -Eeuo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
script_name="$(basename "$0")"

# INPUT_PATH="${1:-}"
# OUTPUT_DIR="${2:-}"
```

## Python

### Script header template: `my_script.py`

```python
#!/usr/bin/env python3
"""One-line summary of the script.

Purpose:
    One-line description of what this script does.

Usage:
    python3 my_script.py --input /path/to/input --output /path/to/output

Inputs:
    --input: Input file or directory.

Outputs:
    --output: Output file or directory.

Environment:
    ENV_VAR_NAME: Optional environment variable description.
"""

from __future__ import annotations

import argparse
from pathlib import Path


__author__ = "Jonathan Serrano"
__version__ = "1.0.0"
__date__ = "June 20, 2026"


# parser = argparse.ArgumentParser(description="One-line description.")
# parser.add_argument(
#     "--input", required=True, type=Path, help="Input file or directory."
# )
# parser.add_argument(
#     "--output", required=True, type=Path, help="Output file or directory."
# )
# args = parser.parse_args()
```

## R

### Script header template: `my_script.R`

```r
#!/usr/bin/env Rscript
# Purpose: One-line description of this script
# Usage: Rscript my_script.R --input /path/to/input --output /path/to/output
# Inputs: - --input: Input file or directory.
# Outputs: - --output: Output file or directory.
# Environment: - ENV_VAR_NAME: Optional environment variable description.
# Author: Jonathan Serrano
# Created: June 20, 2026
# Version: 1.0.0

options(stringsAsFactors = FALSE)
options(warn = 1)

args <- commandArgs(trailingOnly = TRUE)

# INPUT_PATH <- args[[1]]
# OUTPUT_DIR <- args[[2]]

#' One-line function description.
#'
#' @param INPUT_PATH Character scalar. Input file or directory.
#' @param OUTPUT_DIR Character scalar. Output file or directory.
#'
#' @return Invisibly returns 0 on success.
```
