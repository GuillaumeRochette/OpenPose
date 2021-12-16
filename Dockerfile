FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

RUN apt-get -y update && \
    apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
RUN apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    htop \
    ffmpeg \
    freeglut3 \
    freeglut3-dev \
    glew-utils \
    libglew-dev \
    libatlas-base-dev \
    libboost-all-dev \
    libgoogle-glog-dev \
    libatlas-base-dev \
    libeigen3-dev \
    libsuitesparse-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    libhdf5-serial-dev \
    libleveldb-dev \
    liblmdb-dev \
    libprotobuf-dev \
    libsnappy-dev \
    libx11-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libxrandr-dev \
    libxi-dev \
    libxmu-dev \
    libblas-dev \
    libxinerama-dev \
    libxcursor-dev \
    libglm-dev \
    llvm-6.0 \
    mesa-common-dev \
    mesa-utils \
    nano \
    ocl-icd-opencl-dev \
    pciutils \
    protobuf-compiler \
    python-dev \
    python-numpy \
    python-setuptools \
    python3-dev \
    python3-matplotlib \
    python3-numpy \
    python3-pip \
    python3-setuptools \
    python3-scipy \
    software-properties-common \
    unzip \
    libopencv-dev \
    libviennacl-dev \
    libcanberra-gtk-module \
    xorg-dev
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install numpy protobuf opencv-python
RUN apt-get autoremove -y && \
    apt-get autoclean -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/Kitware/CMake/releases/download/v3.16.0/cmake-3.16.0-Linux-x86_64.tar.gz && \
    tar xzf cmake-3.16.0-Linux-x86_64.tar.gz -C /opt && \
    rm cmake-3.16.0-Linux-x86_64.tar.gz
ENV PATH="/opt/cmake-3.16.0-Linux-x86_64/bin:${PATH}"

ENV OPENPOSE_ROOT=/opt/openpose
WORKDIR $OPENPOSE_ROOT

RUN git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose . && \
    git checkout 3d057691b219dddf264c6e412a4560ac8a12dedb && \
    git submodule update --init --recursive --remote

WORKDIR $OPENPOSE_ROOT/build

RUN cmake \
        -DBUILD_PYTHON=ON \
        -DDOWNLOAD_BODY_COCO_MODEL=ON \
        -DDOWNLOAD_BODY_MPI_MODEL=ON \
        .. && \
    make -j`nproc` && \
    make install

WORKDIR $OPENPOSE_ROOT
RUN mkdir -p models/pose/body_135 && \
    wget https://raw.githubusercontent.com/CMU-Perceptual-Computing-Lab/openpose_train/master/experimental_models/100_135AlmostSameBatchAllGPUs/body_135/pose_deploy.prototxt -P models/pose/body_135/ && \
    wget http://posefs1.perception.cs.cmu.edu/OpenPose/models/pose/100_135AlmostSameBatchAllGPUs/body_135/pose_iter_XXXXXX.caffemodel -P models/pose/body_135/
