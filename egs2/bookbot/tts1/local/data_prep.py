import os
import shutil
import sys
import random

if __name__ == "__main__":
    # if len(sys.argv) != 3:
    #     print("Usage: python data_prep.py [data_dir]")
    #     sys.exit(1)
    data_dir = sys.argv[1]


    # Path to the directory where you want to create the Kaldi-like directory
    kaldi_dir = "./data"
    # Create directories required by Kaldi
    # set the percentage of files to be used for testing
    test_percentage = 0.2

    # get a list of audio files and shuffle them
    audio_files = [f for f in os.listdir(data_dir) if f.endswith(".wav")]
    random.shuffle(audio_files)

    # calculate the number of files to be used for testing
    num_test_files = int(len(audio_files) * test_percentage)

    # split the files into training and test sets
    train_files = audio_files[num_test_files:]
    test_files = audio_files[:num_test_files]
    # print("number of training audio: ", len(train_files))
    # print("number of testing audio: ", len(test_files))

    os.makedirs(os.path.join(kaldi_dir, "train"), exist_ok=True)
    os.makedirs(os.path.join(kaldi_dir, "test"), exist_ok=True)
    with open(os.path.join(kaldi_dir, "train", "wav.scp"), "w") as f_wav, \
        open(os.path.join(kaldi_dir, "train", "utt2spk"), "w") as f_utt2spk, \
        open(os.path.join(kaldi_dir, "train", "text"), "w") as f_text:
        
        for audio_file in train_files:
            # create the utterance and speaker IDs
            lab_file = audio_file[:-4] + ".lab"
            # Get the transcript
            with open(data_dir + lab_file, "r") as f:
                transcript = f.read().strip()

            utt_id = os.path.splitext(audio_file)[0].split("_")[1]
            spk_id = audio_file.split("_")[0]

            # write the wav.scp file
            audio_path = os.path.join(data_dir, audio_file)
            # f_wav.write(f"{utt_id} sox {audio_path} -t wav - |\n")
            f_wav.write(f"{utt_id} {audio_path}\n")
            # write the utt2spk file
            f_utt2spk.write(f"{utt_id} {spk_id}\n")
            # write the text file
            f_text.write(f"{utt_id} {transcript}\n")

    # write the test files
    with open(os.path.join(kaldi_dir, "test", "wav.scp"), "w") as f_wav, \
        open(os.path.join(kaldi_dir, "test", "utt2spk"), "w") as f_utt2spk, \
        open(os.path.join(kaldi_dir, "test", "text"), "w") as f_text:
        
        for audio_file in train_files:
            # create the utterance and speaker IDs
            lab_file = audio_file[:-4] + ".lab"
            # Get the transcript
            with open(data_dir + lab_file, "r") as f:
                transcript = f.read().strip()

            utt_id = os.path.splitext(audio_file)[0].split("_")[1]
            spk_id = audio_file.split("_")[0]

            # write the wav.scp file
            audio_path = os.path.join(data_dir, audio_file)
            # f_wav.write(f"{utt_id} sox {audio_path} -t wav - |\n")
            f_wav.write(f"{utt_id} {audio_path}\n")
            # write the utt2spk file
            f_utt2spk.write(f"{utt_id} {spk_id}\n")
            # write the text file
            f_text.write(f"{utt_id} {transcript}\n")
