#!/bin/bash


# Script to loop through a directory containing .pdb files and for each file generate a cleanup version saved in a new outdir "cleanup_pdbs"
# Check if the output directory exists, if not, create it
output_dir="cleanup_pdbs"
if [ ! -d "$output_dir" ]; then
    mkdir "$output_dir"
fi

# Loop through all files ending with .pdb in the current directory
for file in *.pdb; do
    # Check if the file exists and is a regular file
    if [ ! -f "$file" ]; then
        echo "Error: File '$file' does not exist or is not a regular file."
        continue
    fi
    output_file="$output_dir/$(basename "$file" .pdb)_cleanup.pdb"
    if [ -e "$output_file" ]; then
        echo "Output file already exists: $output_file"
    else
    # Use pdbtools to clean up some of the file
        pdb_head -1000000000 "$file" > temp.pdb

    # Use pdbtools to select only one chain 
        pdb_selchain -A temp.pdb  > temp2.pdb
    # This if statement block deals with the situation in which there is no chain listed in the pdb file. In this case, temp2 would be empty so we should use the first temp.pdb to create the cleanup.pdb
        if [ -s "temp2.pdb" ]; then
            echo "File is not empty"
            #grep '^ATOM' temp2.pdb > "$(basename "$file" .pdb)_cleanup.pdb"
            grep '^ATOM' temp2.pdb > "$output_file"
        else
            echo "File is empty"
            #grep '^ATOM' temp.pdb > "$(basename "$file" .pdb)_cleanup.pdb"
            grep '^ATOM' temp.pdb > "$output_file"
        fi
    # Cleanup temporary files
    rm temp.pdb
    rm temp2.pdb

    echo "Cleanup completed for $file"
    fi
done

echo "All cleanup operations completed."
