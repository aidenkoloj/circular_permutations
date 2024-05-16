# Script to generate all circular permutations of an input protein sequence given as a cleaned up pdb file.  
# Same script as pdb_cp_natives.py except this take ONE USER DEFINED INPUT FILE. No looping through a dir

import os

# Define a function that keeps track of how many lines in a .txt or .pdb file correspond to 
# the same residue. Some residues may have more or less atoms, and therefore more or less ATOM lines.
# INPUT = file path
# OUTPUT = dictionary of residue numbers and number of lines in .txt for a given residue

def count_numbers(file_path):
    number_count = {} # dictionary
    with open(file_path, 'r') as file:
        for line in file:
            # Split the line by spaces
            parts = line.split()
            # Find the index of "A" in the line: We are looking for the column that has chain A
		# After this A should come the residues number of the line
            try:
                index = parts.index("A")
            except ValueError:
                continue  # Skip the line if "A" is not found
            # Check if there is a number after "A"
            if index < len(parts) - 1:
                number = parts[index + 1]
                # Check if the number is numeric
                if number.isdigit():
                    number = int(number)
                    # Update the count in the dictionary
                    number_count[number] = number_count.get(number, 0) + 1
    return number_count

# Add values is a function that takes the dictionary containing info of how many lines there are for a
# given residue number (i.e. for residue 40 there could be 8 atoms, res 20, 7 atoms. etc. This function# Adds the number of atoms for each residue to generate the number of lines that need to be moved to 
# create circular permutations 
# INPUT = dictionary from count_numbers function
# OUTPUT = list of lines for circular permutations to be made 
def add_values(dictionary):
    result_list = []
    total = 0
    values = list(dictionary.values())[::-1]
    #for value in dictionary.values():
    for value in values:
        #print(value)
        #print(total)
        total += value
        result_list.append(total)
    return result_list

# Move_lines to beginning takes a file as input (.txt), calls count_numers and add_values and
# using the output list from add_values, makes new circular permutations
# INPUT = file path
# OUTPUT = .txt files for every circular permutation of the original file

def move_lines_to_beginning(file_path, outdir):
    result = count_numbers(file_path) # call count_numbers to generate dictionary
    new_list = add_values(result)# call add_values to generate list used for move_lines_to_beginning
    with open(file_path, 'r') as f:
        lines = f.readlines()
    total_lines = len(lines)
    # Iterate through each line of the input file
    for i in range(0, len(new_list)):
        # Get the last n lines of the file, where n is the current iteration
        j = new_list[i]
        last_n_lines = ''.join(lines[-j:])
        q = total_lines -j
        first_n_lines = ''.join(lines[:q])
        # Create a new file with the last n lines moved to the beginning
        cwd = os.getcwd()
        output_file = os.path.join(outdir, f"{file_path[:-4]}_last_{j}_lines_moved_to_beginning.txt")
        #output_file = os.path.join(cwd, file_path[:-4], f"{file_path[:-4]}_last_{j}_lines_moved_to_beginning.txt")
        print("Generated output file: ", output_file)
        with open(output_file, 'w') as f_out:
        #with open(f"{file1[:-4]}_last_{j}_lines_moved_to_beginning.txt", 'w') as f_out:
            f_out.write(last_n_lines)
            f_out.write(first_n_lines)

# Take an input file and generate all CPs

file1 = input("Enter the path of the text file: ")
# Define new output dir based on input filename
new_directory = file1[:-4] + "_cp"
# Make new dir
os.mkdir(new_directory) 
# Call move lines function on new file
move_lines_to_beginning(file1, new_directory)
