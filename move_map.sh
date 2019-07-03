#!bin/bash

TMP_FOLDER="tmp"

# Moves the tiff and the tfw files to the desired folder

read -p  "What is the name of the lane you want to save the map too (ex : MAN1)"  dest_folder

mv "$TMP_FOLDER/*" dest_folder
# Rename all the files with the right lane
for file in "${dest_folder[@]}"; do 
    mv file "${file/TMP/$dest_folder}"
done 


