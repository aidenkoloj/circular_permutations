#!/bin/bash 
#SBATCH -n 20 #Request tasks (cores)
#SBATCH -N 5 #Request 1 node
#SBATCH -t 0-12:00 #Request runtime of 30 minutes
#SBATCH -C centos7 #Request only Centos7 nodes
#SBATCH -p sched_mit_hill #Run on sched_engaging_default partition
#SBATCH --mem=5GB  #Request 5G of memory 
#SBATCH -e error_%j.txt #redirect errors to error_JOBID.txt
#SBATCH --mail-type=BEGIN,END #Mail when job starts and ends
#SBATCH --mail-user=aidenkzj@mit.edu #email recipient


# This script requires the database defined in the foldseek command to be in the same directory as this script

# Sbatch script to run foldseek on each file in each subdirectory

# Define a log file containing files that have been processed


log="log_run_foldseek_aligntype0.txt"

if [ -e "$log" ]; then
    echo "$log already exists. Appending to log"
else
    touch "$log"
    echo "Created $log"
fi



# Define parent dir as the working dir
parent_directory=$(pwd)
echo $parent_directory

# Loop through each subdirectory
for subdirectory in "$parent_directory"/*cp; do # loop through subdirectories ending in "cp"
    if [ -d "$subdirectory" ]; then  # Check if it's a directory
        echo "Processing files in directory: $subdirectory"
        # Loop through each file in the subdirectory
        for input_file in "$subdirectory"/*txt; do
            if [ -f "$input_file" ]; then  # Check if it's a regular file
                echo "Processing file: $file"
                
                # Need to get the explicit path name to an output dir for this to work. Still want to be able to create a foldseek_results folder in each folder.
# Define output dir for foldseek results within the subdirectory 
                output_dir="$subdirectory/foldseek_results_aligntype0"
 # Check if output directory already exists
                if [ ! -d "$output_dir" ]; then
                    echo "Output directory doesn't exist, creating: $output_dir"
                    mkdir -p "$output_dir"
                else
                    echo "Output directory already exists: $output_dir"
                fi
# Define path  of output file for foldseek and its name
                output_file="$output_dir/$(basename "${input_file%.txt}.aln1.m8")"
                echo "THIS IS THE OUTPUT FILE: $output_file"
                echo "THIS IS THE OUTPUT DIR: $output_dir"
# Before we run foldseek, let's check that the output file doesnt already exist (we may have already run foldseek in a previous sbatch job 
                if [ ! -f "$output_file" ]; then
                    echo "Output file doesn't exist, running foldseek command..."
		    foldseek easy-search "$input_file" AFproteome "$output_dir/$(basename "${input_file%.txt}.aln1.m8")" foldseek.tmp --alignment-type 0 --tmscore-threshold 0.0 -e 10 --format-output "query,target,mismatch,gapopen,pident,qstart,qend,qlen,tstart,tend,tlen,alnlen,evalue,qaln,taln,cigar,qseq,tseq"
                    current_time=$(date +"%Y-%m-%d %H:%M:%S")
                    echo -e "Foldseek output generated for: $output_file\t$current_time" >> "$log"
                else
                    echo "Output file already exists: $output_file, skipping foldseek command."
                fi
            fi
        done
    fi
done
