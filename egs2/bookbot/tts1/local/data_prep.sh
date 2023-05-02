#!/bin/bash
data_dir=$1
output_dir=$2

# if [ $# != 2 ]; then
#     echo "Usage: $0 <db_root> <data_dir>"
#     echo "e.g.: $0 /path/to/kss data/train"
#     exit 1
# fi
set -euo pipefail

# check directory existence
[ ! -e "${data_dir}" ] && mkdir -p "${data_dir}"

# Set the path to the output directory

# Set the percentage of data to use for testing
test_percent=20

# Create the output directories
mkdir -p $output_dir/train
mkdir -p $output_dir/test

# Get a list of all the audio files and their corresponding transcripts
audio_files=( $(find $data_dir -type f -name "*.wav" | sort) )
transcripts=( $(find $data_dir -type f -name "*.lab" | sort) )

# Check that the number of audio files and transcripts match
if [ ${#audio_files[@]} -ne ${#transcripts[@]} ]; then
    echo "Error: Number of audio files and transcripts do not match"
    exit 1
fi

# Get the number of audio files
num_audio_files=${#audio_files[@]}

# Calculate the number of audio files to use for testing
num_test=$(($num_audio_files * $test_percent / 100))

# Shuffle the audio files and transcripts in unison
shuf -e "${audio_files[@]}" "${transcripts[@]}" --output-zip "${output_dir}/shuffle.zip"

# Split the shuffled files into training and test sets
zip_file="${output_dir}/shuffle.zip"
train_zip="${output_dir}/train/shuffle.zip"
test_zip="${output_dir}/test/shuffle.zip"
unzip -p $zip_file | head -n -$num_test | zip -q $train_zip -@
unzip -p $zip_file | tail -n $num_test | zip -q $test_zip -@

# Extract the audio files and transcripts from the training and test sets
unzip -p $train_zip | grep -e ".wav$" > $output_dir/train/wav.scp
unzip -p $train_zip | grep -e ".lab$" > $output_dir/train/text
unzip -p $test_zip | grep -e ".wav$" > $output_dir/test/wav.scp
unzip -p $test_zip | grep -e ".lab$" > $output_dir/test/text

# Create the spk2utt and utt2spk files for the training and test sets
utils/utt2spk_to_spk2utt.pl $output_dir/train/utt2spk > $output_dir/train/spk2utt
utils/utt2spk_to_spk2utt.pl $output_dir/test/utt2spk > $output_dir/test/spk2utt