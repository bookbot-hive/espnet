#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
# set -e
# set -u
# set -o pipefail

./tts.sh \
    --stage 1 \
    --ngpu 1 \
    --tts_task gan_tts \
    --fs 44100\
    --fmin 0 \
    --fmax null \
    --n_fft 1024 \
    --n_shift 256 \
    --win_length null \
    --train_config conf/train_small_jets.yaml \
    --inference_model latest.pth \
    --train_set train_nodev \
    --valid_set train_dev \
    --test_sets "train_dev test" \
    --srctexts "data/train_nodev/text"\
    --g2p bookbot_g2p
    
# num_iter: none
# batch_bins: 10 mil
# 50_batch speed = ~9 mins
# mem_usage = high (38)

# num_iter: 1000
# batch_bins: 2 mil
# 50_batch speed = ~2.5 mins
# mem_usage = low (12)