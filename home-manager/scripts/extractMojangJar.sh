#!/usr/bin/env fish

# This script extracts a Java archive (.jar) and filters its contents.
#
# It keeps only the 'assets/' folder, the 'data/' folder, and the
# 'version.json' file from the top level of the archive. All other
# top-level files and folders are deleted.
#
# It then cleans up by removing all .class files and any resulting empty directories.
#
# Usage:
#   ./extract.sh path/to/yourfile.jar path/to/output_directory

# --- Argument Validation ---
if test (count $argv) -ne 2
    echo "Error: Incorrect number of arguments."
    echo "Usage: $0 <source_jar_file> <output_directory>"
    exit 1
end

# Resolve to an absolute path to ensure 'jar' can find it after 'cd'.
set source_jar (realpath $argv[1])
set output_dir $argv[2]

if not test -f "$source_jar"
    echo "Error: Source file '$source_jar' not found."
    exit 1
end

# --- Directory Preparation ---
# Create the main output directory if it doesn't already exist.
mkdir -p "$output_dir"

# Determine the name for the extraction folder from the JAR file name.
# e.g., /path/to/1.21.4.jar -> 1.21.4
set extract_folder_name (basename "$source_jar" .jar)
set extract_path "$output_dir/$extract_folder_name"

# Create a clean directory for extraction.
rm -rf "$extract_path"
mkdir -p "$extract_path"

# --- Extraction ---
# The 'jar xf' command extracts to the current directory.
# So, first we 'cd' into the target directory.
echo "Changing directory to $extract_path"
cd "$extract_path"

echo "Extracting $source_jar..."
# Use 'jar xf' to extract the archive into the current directory.
jar xf "$source_jar"

# --- Filtering and Cleaning ---
# We are already in the extraction path, so we can proceed with cleanup.

echo "Deleting all .class files from remaining folders..."
# Find and delete all files with the .class extension recursively.
find . -type f -name "*.class" -delete


echo "Filtering top-level files and directories..."
# Loop through all items in the top level of the extraction path.
for item in *
    # Check if the item is one of the ones we want to keep.
    # If it is NOT 'assets', AND NOT 'data', AND NOT 'version.json', then delete it.
    if test "$item" != "assets" -a "$item" != "data" -a "$item" != "version.json"
        echo "Deleting: $item"
        # Use rm -r to remove both files and directories.
        rm -r "$item"
    end
end

echo "Deleting all empty folders..."
# Find and delete all directories that are now empty.
# The -delete flag in 'find' will also remove nested empty directories.
find . -type d -empty -delete

echo "Extraction and cleanup complete."
echo "Output located at: $extract_path"

# It's good practice to return to the original directory.
cd - > /dev/null