OpenPose
===
---
### Requirements

- If you have a GPU (which is recommended), its CUDA Compute Capability must be >= 5.0 and <=8.0, otherwise this might not work.

### Install

1. Install Docker and follow post-installation steps: https://docs.docker.com/engine/install/
2. Install NVIDIA Docker: https://github.com/NVIDIA/nvidia-docker

### Run

- OpenPose:

```bash
bash OpenPose.docker.sh /path/to/input/video.mp4 /path/to/poses_2d.tar.xz
```
- For a directory of images:

```bash
bash BODY_135.docker.sh /path/to/input/video.mp4 /path/to/poses_2d.tar.xz
```
