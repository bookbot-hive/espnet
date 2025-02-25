#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

log() {
    local fname=${BASH_SOURCE[1]##*/}
    echo -e "$(date '+%Y-%m-%dT%H:%M:%S') (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $*"
}
SECONDS=0

stage=1
stop_stage=100

log "$0 $*"
. utils/parse_options.sh

. ./db.sh
. ./path.sh
. ./cmd.sh

if [ $# -ne 0 ]; then
    log "Error: No positional arguments are required."
    exit 2
fi

if [ -z "${bookbot}" ]; then
    log "Fill the value of 'bookbot' of db.sh"
    exit 1
fi

train_set="train_nodev"
train_dev="train_dev"
test_percentage=${1:-0.2}
ndev_utt=${2:-200}

if [ ${stage} -le 1 ] && [ ${stop_stage} -ge 1 ]; then
    log "stage 1: Data preparation"
    
    python3 local/data_prep.py ${bookbot} ${test_percentage}

    
    for x in test train; do
        # sort data
        for f in text wav.scp utt2spk; do
            sort data/${x}/${f} -o data/${x}/${f}
        done
        # create spk2utt file
        utils/utt2spk_to_spk2utt.pl data/${x}/utt2spk > "data/${x}/spk2utt"
    done

    # make a dev set
    utils/subset_data_dir.sh --first data/train "${ndev_utt}" "data/${train_dev}"
    n=$(($(wc -l < data/train/text) - ndev_utt))
    utils/subset_data_dir.sh --last data/train "${n}" "data/${train_set}"
fi

log "Successfully finished. [elapsed=${SECONDS}s]"