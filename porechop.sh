#!/bin/bash

# Configuration variables
INPUT_FILE=${INPUT_FILE:-"./Raw/nano_raw.fastq"}  # Path to the input FASTQ file.
OUTPUT_FILE=${OUTPUT_FILE:-"./Clean/nano.fq"}  # Path for the output cleaned FASTQ file.
FORMAT=${FORMAT:-"fastq"}  # Output format.
THREADS=${THREADS:-4}  # Number of threads to use.

echo "Starting Porechop on $(date)"

# Ensure Porechop is available in your PATH.
# If Porechop isn't globally available, you may need to load it or adjust your PATH.
# Example: export PATH=$PATH:/path/to/porechop

# Running Porechop with specified parameters.
porechop \
    -i ${INPUT_FILE} \
    -o ${OUTPUT_FILE} \
    --format ${FORMAT} \
    -t ${THREADS} \
    --discard_middle

echo "Porechop processing completed on $(date)"
