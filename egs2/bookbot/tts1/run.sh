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
    --train_config conf/train_jets.yaml \
    --inference_model latest.pth \
    --train_set train_nodev \
    --valid_set train_dev \
    --test_sets "train_dev test" \
    --srctexts "data/train_nodev/text"\
    --g2p bookbot_g2p