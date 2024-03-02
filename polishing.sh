#!/bin/bash
set -e

# Initialize variables
CORES=""
LONG_READS=""
R1=""
R2=""
DRAFT_GENOME=""
OUTPUT_FOLDER=""

# Help function
display_help() {
  echo "Usage: $0 -c <cores> -l <long_reads> -r1 <r1> -r2 <r2> -d <draft_genome> -o <output_folder>"
  echo "Flags:"
  echo "  -c <cores>       Number of CPU cores"
  echo "  -l <long_reads>  Path to long reads file"
  echo "  -r1 <r1>         Path to forward short reads file"
  echo "  -r2 <r2>         Path to reverse short reads file"
  echo "  -d <draft_genome> Path to draft genome file"
  echo "  -o <output_folder> Path to output folder"
  exit 0
}

# Define input flags
while [[ $# -gt 0 ]]; do
  case "$1" in
    -c)
      CORES="$2"
      shift
      shift
      ;;
    -l)
      LONG_READS="$2"
      shift
      shift
      ;;
    -r1)
      R1="$2"
      shift
      shift
      ;;
    -r2)
      R2="$2"
      shift
      shift
      ;;
    -d)
      DRAFT_GENOME="$2"
      shift
      shift
      ;;
    -o)
      OUTPUT_FOLDER="$2"
      shift
      shift
      ;;
    -h|--h|-help|--help)
      display_help
      ;;
    *)
      echo "Invalid option: $1" >&2
      display_help
      ;;
  esac
done

# Check that each required variable is not empty if [ -z "$CORES" ] || [ -z "$LONG_READS" ] || [ -z "$R1" ] || [ -z "$R2" ] || [ -z "$DRAFT_GENOME" ] || [ -z "$OUTPUT_FOLDER" ]; then
  echo "One or more required input variables are empty. Please provide values for all flags."
  display_help
  exit 1
fi

# Obtain absolute paths for input files and output folder LONG_READS=$(readlink -f "$LONG_READS") R1=$(readlink -f "$R1") R2=$(readlink -f "$R2") DRAFT_GENOME=$(readlink -f "$DRAFT_GENOME") OUTPUT_FOLDER=$(readlink -f "$OUTPUT_FOLDER")

# Print variable values
echo "CORES: $CORES"
echo "LONG_READS: $LONG_READS"
echo "R1: $R1"
echo "R2: $R2"
echo "DRAFT_GENOME: $DRAFT_GENOME"
echo "OUTPUT_FOLDER: $OUTPUT_FOLDER"

# Create and enter the output folder
mkdir -p "$OUTPUT_FOLDER"
cd "$OUTPUT_FOLDER"

# Load necessary modules
module load minimap2/2.25 samtools/1.12 gcc python racon/1.4.21 busco/5.2.2 masurca/4.0.9 module load bwa export NUMEXPR_MAX_THREADS=$CORES

# Concatenate forward and reverse short reads cat "$R1" "$R2" > combined_short_reads.fq short_reads="combined_short_reads.fq"


# Loop for Racon iterations with long reads for racon_iter in {1..3}; do
  success_flag=".success_LR${racon_iter}"
  if [[ -f "$success_flag" ]]; then
    echo "Skipping Racon LR round $racon_iter (already successful)"
  else
    echo "Step 0$racon_iter. Racon LR round $racon_iter"
    minimap2 -t $CORES -x map-ont $DRAFT_GENOME $LONG_READS > aln${racon_iter}.paf
    racon -u -t $CORES $LONG_READS aln${racon_iter}.paf $DRAFT_GENOME > Polished_LR${racon_iter}.fasta
    ls -lth
    touch "$success_flag"
  fi
done

# Loop for Racon iterations with short reads for racon_iter in {1..3}; do
  success_flag=".success_SR${racon_iter}"
  if [[ -f "$success_flag" ]]; then
    echo "Skipping Racon SR round $racon_iter (already successful)"
  else
    echo "Step 0$racon_iter. Racon SR round $racon_iter"
    minimap2 -t $CORES -x sr Polished_LR3.fasta $R1 > aln${racon_iter}.paf
    racon -u -t $CORES $R1 aln${racon_iter}.paf Polished_LR3.fasta > Polished_LR3-SR${racon_iter}.fasta
    ls -lth
    touch "$success_flag"
  fi
done

module load bwa

# Loop for Polca iterations
for polca_iter in {1..6}; do
  success_flag=".success_PP${polca_iter}"
  if [[ -f "$success_flag" ]]; then
    echo "Skipping Polca iteration $polca_iter (already successful)"
  else
    echo "Step 0$polca_iter. Run Polca"
    input_file="Polished_LR3-SR3.fasta"
    if [[ $polca_iter -gt 1 ]]; then
      for ((i=2; i<=polca_iter; i++)); do
        input_file="${input_file}.PolcaCorrected.fa"
      done
    fi
#   polca.sh -a "$input_file" -r '/scratch3/projects/hb-apgp/Gunjan/FACTORY/polishing/ill_R1.fq' -t "$CORES" -m 6G
    parallel --gnu -j 1 "polca.sh -a {1} -r '{2} {3}' -t {4} -m 6G" ::: $input_file ::: $R1 ::: $R2 ::: $CORES
    touch "$success_flag"
  fi
done


# Loop to rename Polca output files
for polca_iter in {1..3}; do
  input_file="Polished_LR3-SR3.fasta.PolcaCorrected.fa"
  new_file="Polished_LR3-SR3-PP${polca_iter}.fasta"
  
  for ((i=2; i<=polca_iter; i++)); do
    input_file="${input_file}.PolcaCorrected.fa"
  done
  
  if [[ -f "$input_file" ]]; then
    mv "$input_file" "$new_file"
  fi
done


echo "##################################################"
echo " Polishing successfully finished on $(date) "
echo "##################################################"
exit
