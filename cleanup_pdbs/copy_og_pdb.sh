#!/bin/bash

# Loop through each file in the current directory
for file in *.pdb; do
    # Extract the filename without extension
    filename=$(basename "$file" .pdb)
    
    # Construct the destination directory name
    destination_dir="${filename}_cp"
    
    # Check if the destination directory exists, if not, create it
    if [ ! -d "$destination_dir" ]; then
       # mkdir "$destination_dir"
       echo "This directory doesn't exist $destination_dir"
    fi
    # Match filename to the other circular perm filenames
    new_filename="${filename}_last_0_lines_moved_to_beginning.txt"
    # Copy the file to the destination directory
    cp "$file" "$destination_dir/$new_filename"
done

