#!/bin/bash

# Default configuration
THREADS=4  # Default number of threads
SPECIES="diptera"  # Default species
INPUT_FILE="input_genome.fasta"  # Changed to a more general input file name

# Function to display help
display_help() {
  echo "Usage: $0 [options]"
  echo ""
  echo "   -t, --threads     Number of CPU threads to use (default: $THREADS)"
  echo "   -s, --species     Species for RepeatMasker (default: $SPECIES)"
  echo "   -i, --input       Input FASTA file for RepeatMasker (default: $INPUT_FILE)"
  echo "   -h, --help        Display this help message and exit"
  exit 0
}

# Parse command-line options
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -t|--threads) THREADS="$2"; shift 2 ;;
    -s|--species) SPECIES="$2"; shift 2 ;;
    -i|--input) INPUT_FILE="$2"; shift 2 ;;
    -h|--help) display_help ;;
    *) echo "Unknown parameter passed: $1"; display_help ;;
  esac
done

echo "Running RepeatMasker with the following parameters:"
echo "Threads: $THREADS"
echo "Species: $SPECIES"
echo "Input FASTA file: $INPUT_FILE"

# Set the number of threads for OpenMP
export OMP_NUM_THREADS=$THREADS

# Run RepeatMasker
RepeatMasker -pa $THREADS -species $SPECIES $INPUT_FILE

echo "RepeatMasker analysis completed."
