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

    # Extract lines only beginning with ATOM.
        grep '^ATOM' temp2.pdb > "$output_dir/$(basename "$file" .pdb)_cleanup.pdb"
    
    # Cleanup temporary files
        rm temp.pdb
        rm temp2.pdb

        echo "Cleanup completed for $file"
    fi
done

echo "All cleanup operations completed."
