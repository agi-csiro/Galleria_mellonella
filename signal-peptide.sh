#!/bin/bash

# Configuration
VIRTUAL_ENV_PATH="virtual_envs/signalp"  # Path to the virtual environment for SignalP
INPUT_FASTA="input_protein_sequences.faa"  # Default input FASTA file, changed to a more general name
OUTPUT_DIR="Signalp6_output"  # Output directory
ORGANISM_TYPE="eukarya"  # Organism type: archaea, bacteria, or eukarya
MODE="fast"  # Mode: 'fast' or 'sensitive'
WORKERS=32  # Number of workers

# Function to display help
display_help() {
  echo "Usage: $0 [options]"
  echo ""
  echo "   -v, --virtualenv  Path to the SignalP virtual environment (default: $VIRTUAL_ENV_PATH)"
  echo "   -i, --input       Input FASTA file (default: $INPUT_FASTA)"
  echo "   -o, --output      Output directory (default: $OUTPUT_DIR)"
  echo "   -org, --organism  Organism type (archaea, bacteria, eukarya) (default: $ORGANISM_TYPE)"
  echo "   -m, --mode        Prediction mode ('fast' or 'sensitive') (default: $MODE)"
  echo "   -w, --workers     Number of workers (default: $WORKERS)"
  echo "   -h, --help        Display this help message and exit"
  exit 0
}

# Parse command-line options
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -v|--virtualenv) VIRTUAL_ENV_PATH="$2"; shift 2 ;;
    -i|--input) INPUT_FASTA="$2"; shift 2 ;;
    -o|--output) OUTPUT_DIR="$2"; shift 2 ;;
    -org|--organism) ORGANISM_TYPE="$2"; shift 2 ;;
    -m|--mode) MODE="$2"; shift 2 ;;
    -w|--workers) WORKERS="$2"; shift 2 ;;
    -h|--help) display_help ;;
    *) echo "Unknown parameter passed: $1"; display_help ;;
  esac
done

echo "Running SignalP 6.0 with the following configuration:"
echo "Virtual Environment: $VIRTUAL_ENV_PATH"
echo "Input FASTA file: $INPUT_FASTA"
echo "Output directory: $OUTPUT_DIR"
echo "Organism type: $ORGANISM_TYPE"
echo "Mode: $MODE"
echo "Workers: $WORKERS"

# Activate virtual environment
source "$VIRTUAL_ENV_PATH/bin/activate"

# Run SignalP
signalp6 -fasta "$INPUT_FASTA" -od "$OUTPUT_DIR" -f none -org "$ORGANISM_TYPE" -m "$MODE" -wp "$WORKERS"

# Deactivate virtual environment
deactivate

echo "SignalP analysis completed."
