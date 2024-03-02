#!/bin/bash

# Configuration variables - set these according to your needs or use environment variables.
R1=${R1:-"/path/to/read1.fastq.gz"}  # Path to Read 1 input file.
R2=${R2:-"/path/to/read2.fastq.gz"}  # Path to Read 2 input file.
CORES=${CORES:-4}  # Number of cores to use.
CLIP_R1=${CLIP_R1:-16}  # Number of bases to remove from the start of Read 1.
CLIP_R2=${CLIP_R2:-14}  # Number of bases to remove from the start of Read 2.
THREE_PRIME_CLIP_R1=${THREE_PRIME_CLIP_R1:-6}  # Number of bases to remove from the end of Read 1.
THREE_PRIME_CLIP_R2=${THREE_PRIME_CLIP_R2:-6}  # Number of bases to remove from the end of Read 2.
LENGTH=${LENGTH:-120}  # Minimum length of reads to be kept.
OUTPUT_DIR=${OUTPUT_DIR:-"./cleaned_reads"}  # Directory where the output files will be saved.

echo "Starting Trim Galore on $(date)"

# Ensure Trim Galore is available in your PATH.
# If not globally available, you may need to load it or adjust your PATH accordingly.
# Example: export PATH=$PATH:/path/to/trim_galore

# Running Trim Galore with specified parameters.
trim_galore \
    --paired ${R1} ${R2} \
    --cores ${CORES} \
    --clip_R1 ${CLIP_R1} \
    --clip_R2 ${CLIP_R2} \
    --three_prime_clip_R1 ${THREE_PRIME_CLIP_R1} \
    --three_prime_clip_R2 ${THREE_PRIME_CLIP_R2} \
    --length ${LENGTH} \
    --output_dir ${OUTPUT_DIR}

echo "Trim Galore finished on $(date)"
