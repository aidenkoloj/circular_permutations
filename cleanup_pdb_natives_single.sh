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

# Extract lines only beginning with ATOM.
grep '^ATOM' temp2.pdb > "$(basename "$1" .pdb)_cleanup.pdb"
rm temp.pdb
rm temp2.pdb
echo "Done."

