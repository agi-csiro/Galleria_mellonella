#!/bin/bash

# Configuration variables
THREADS=${THREADS:-4}  # Number of threads to use, default to 4 if not specified.
NANO=${NANO:-"/path/to/nano_reads.fastq"}  # Path to nanopore reads.
PREFIX=${PREFIX:-"pre"}  # Prefix for output files.
JUNCTION_MINIMUM_SUPPORT=${JMS:-1000}  # Minimum support for junctions, default 1000.
KMER_SIZE=${KMER_SIZE:-16}  # K-mer size for assembly, default 16.
COVERAGE_CUTOFF=${COVERAGE_CUTOFF:-1}  # Coverage cutoff, default 1.

# Ensure Smartdenovo is available in your PATH.
# If not globally available, you may need to load it or adjust your PATH accordingly.
# Example: export PATH=$PATH:/path/to/smartdenovo

echo "Starting Smartdenovo assembly on $(date)"

# Generate the makefile with Smartdenovo
smartdenovo.pl -t ${THREADS} \
               -p ${PREFIX} \
               -e dmo \
               -J ${JUNCTION_MINIMUM_SUPPORT} \
               -k ${KMER_SIZE} \
               -c ${COVERAGE_CUTOFF} \
               ${NANO} > ${PREFIX}.mak

# Ensure 'make' is available in your PATH.
# Example for adjusting PATH: export PATH=$PATH:/usr/bin

# Execute the makefile to perform the assembly
make -f ${PREFIX}.mak

echo "Assembly completed on $(date)"
