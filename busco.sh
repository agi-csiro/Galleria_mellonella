#!/bin/bash

# Default configuration
CORES=64  # Default number of CPU cores to use
INPUT_FILE="./input_genome.fasta"  # Default input file path
LINEAGE_PATH="/path/to/lineages/lineage_dataset"  # Default lineage dataset path
OUTPUT_FOLDER="./BUSCO_output"  # Default output folder name
MODE="genome"  # Default BUSCO mode

# Function to display help
display_help() {
  echo "Usage: $0 [options]"
  echo ""
  echo "   -c, --cores        Number of CPU cores to use (default: $CORES)"
  echo "   -i, --input        Path to the input FASTA file (default: $INPUT_FILE)"
  echo "   -l, --lineage      Path to the BUSCO lineage dataset (default: $LINEAGE_PATH)"
  echo "   -o, --output       Name of the output folder (default: $OUTPUT_FOLDER)"
  echo "   -m, --mode         BUSCO mode (genome, proteins, transcriptome) (default: $MODE)"
  echo "   -h, --help         Display this help message and exit"
  exit 0
}

# Parse command-line options
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -c|--cores) CORES="$2"; shift 2 ;;
    -i|--input) INPUT_FILE="$2"; shift 2 ;;
    -l|--lineage) LINEAGE_PATH="$2"; shift 2 ;;
    -o|--output) OUTPUT_FOLDER="$2"; shift 2 ;;
    -m|--mode) MODE="$2"; shift 2 ;;
    -h|--help) display_help ;;
    *) echo "Unknown parameter passed: $1"; display_help ;;
  esac
done

echo "Running BUSCO analysis with the following parameters:"
echo "Cores: $CORES"
echo "Input FASTA file: $INPUT_FILE"
echo "Lineage path: $LINEAGE_PATH"
echo "Output folder: $OUTPUT_FOLDER"
echo "Mode: $MODE"

# Run BUSCO
busco -f \
      -c "$CORES" \
      -m "$MODE" \
      -i "$INPUT_FILE" \
      -l "$LINEAGE_PATH" \
      -o "$OUTPUT_FOLDER"

echo "BUSCO analysis completed."
