#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

./tts.sh --stage 1 --stop-stage 1

./tts.sh \
    --stage 2 \
    --ngpu 4 \
    --fs 22050 \
    --n_fft 1024 \
    --n_shift 256 \
    --win_length null \
    --dumpdir dump/22k \
    --expdir exp/22k \
    --tts_task gan_tts \
    --feats_extract linear_spectrogram \
    --feats_normalize none \
    --train_config conf/tuning/train_jets.yaml \
    --inference_model latest.pth \
    --train_set train_nodev \
    --valid_set train_dev \
    --test_sets "train_dev test" \
    --srctexts "data/train_nodev/text"\


    