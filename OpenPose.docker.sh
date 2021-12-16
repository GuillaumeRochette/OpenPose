#! /bin/bash
set -e

video=$(realpath $1)
video_dir=$(dirname $video)

poses_tar=$(realpath $2)
poses_dir=$(dirname $poses_tar)
mkdir -p $poses_dir

cmd="video=$video && \
poses_tar=$poses_tar && "
cmd+='tmp_name=$(basename $poses_tar | cut -d. -f1) && \
mkdir -p /tmp/$tmp_name && \
cd $OPENPOSE_ROOT && \
./build/examples/openpose/openpose.bin \
  --video $video \
  --write_json /tmp/$tmp_name \
  --model_pose BODY_25 \
  --scale_number 4 \
  --scale_gap 0.25 \
  --hand \
  --hand_scale_number 6 \
  --hand_scale_range 0.4 \
  --face \
  --display 0 \
  --render_pose 0 && \
cd /tmp && \
n_frames=$(ffprobe -v error -select_streams v:0 -count_frames -show_entries stream=nb_read_frames -print_format default=nokey=1:noprint_wrappers=1 $video) && \
n_files=$(ls $tmp_name | wc -l) && \
if [[ "$n_frames" == "$n_files" ]]; then tar -cJf $poses_tar $tmp_name && exit 0; else exit 1; fi'

echo $cmd

exec docker run \
    --gpus all \
    -v $video_dir:$video_dir \
    -v $poses_dir:$poses_dir \
    --user $(id -u):$(id -g) \
    guillaumerochette/openpose:latest \
    /bin/bash -c "$cmd"
