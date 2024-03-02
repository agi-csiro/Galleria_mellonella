#!/bin/bash

# Configuration variables - set these according to your environment or use environment variables if preferred.
BASEDIR=${GUPPY_BASEDIR:-"/path/to/guppy"}  # Guppy software base directory. Ensure Guppy is installed and this path is correctly set.
INPUT_DIR=${INPUT_DIR:-"./fast5_pass/"}  # Directory containing input fast5 files.
OUTPUT_DIR=${OUTPUT_DIR:-"./basecalled_SUP/"}  # Directory where output files will be saved.
CONFIG_FILE=${CONFIG_FILE:-"dna_r10.4.1_e8.2_400bps_modbases_5mc_cg_sup_prom.cfg"}  # Guppy configuration file.
GPU_DEVICES=${GPU_DEVICES:-"cuda:0"}  # GPU device IDs. Use "auto" or specify devices like "0" or "0,1" for multi-GPU setups.
GPU_RUNNERS_PER_DEVICE=${GPU_RUNNERS_PER_DEVICE:-6}
CHUNK_SIZE=${CHUNK_SIZE:-1000}

echo "Starting basecalling on $(date)"

# Ensure Guppy software is available in your PATH. You may need to load the software or adjust your PATH accordingly.
# Example: export PATH=$PATH:/path/to/guppy/bin

# Running Guppy basecaller with specified parameters.
${BASEDIR}/bin/guppy_basecaller \
    -i ${INPUT_DIR} \
    -s ${OUTPUT_DIR} \
    -c ${BASEDIR}/data/${CONFIG_FILE} \
    --bam_out \
    --gpu_runners_per_device ${GPU_RUNNERS_PER_DEVICE} \
    --chunk_size ${CHUNK_SIZE} \
    --device ${GPU_DEVICES}

echo "Basecalling finished on $(date)"

# Combining all .fastq files from the output directory into one file.
cat ${OUTPUT_DIR}/pass/*.fastq > combined_pass.fastq

echo "Script completed on $(date)"
