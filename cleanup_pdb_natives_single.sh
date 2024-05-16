## Script to trim down a user inputted pdb file to just the ATOM information which is sufficient for running fold seq.
# Use this script for cleaning up a single pdb file
# Takes a user defined pdb file as input
# i.e. bash cleanup_pdb_natives_single.sh 1a32.pdb




# Check if the file path is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <file.pdb>"
    exit 1
fi

# Check if the provided file exists and is a regular file
if [ ! -f "$1" ]; then
    echo "Error: File '$1' does not exist or is not a regular file."
    exit 1
fi

# Use pdbtools to clean up some of the file
pdb_head -1000000000 "$1" > temp.pdb

# Use pdbtools to select only one chain 
pdb_selchain -A temp.pdb  > temp2.pdb

# This if statement block deals with the situation in which there is no chain listed in the pdb file. In this case, temp2 would be empty so we should use the first temp.pdb to create the cleanup.pdb
if [ -s "temp2.pdb" ]; then
    echo "File is not empty"
    grep '^ATOM' temp2.pdb > "$(basename "$1" .pdb)_cleanup.pdb"
else
    echo "File is empty"
    grep '^ATOM' temp.pdb > "$(basename "$1" .pdb)_cleanup.pdb"
fi


# Extract lines only beginning with ATOM.
#grep '^ATOM' temp2.pdb > "$(basename "$1" .pdb)_cleanup.pdb"
rm temp.pdb
rm temp2.pdb
echo "Done."

