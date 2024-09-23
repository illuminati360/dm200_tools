#!/bin/bash

if [ ! "${USER}" = "root" ]; then
    echo "This script need to do with sudo or root account."
    exit 1
fi

apt install -y python3-pip xz-utils pipx libglib2.0-dev cmake libgtk-3-dev ninja-build libjson-glib-dev libmagic-dev libsqlite3-dev gettext xorg-dev libglfw3-dev libgl1-mesa-dev libglu1-mesa-dev libmujs-dev libopenjp2-7-dev libjbig2dec0-dev libgumbo-dev freeglut3-dev libjpeg-dev
pipx install meson

# girara
wget https://pwmt.org/projects/girara/download/girara-0.4.4.tar.xz
tar xvf girara-0.4.4.tar.xz
cd girara-0.4.4
meson build
cd build
ninja
ninja install
cd ../../

# zathura
wget https://pwmt.org/projects/zathura/download/zathura-0.5.8.tar.xz
tar xvf zathura-0.5.8.tar.xz
cd zathura-0.5.8
meson build
cd build
ninja
ninja install
cd ../../

# mupdf
wget https://mupdf.com/downloads/archive/mupdf-1.24.9-source.tar.gz
tar zxvf mupdf-1.24.9.tar.gz
cd mupdf-1.24.9
make shared=no USE_SYSTEM_LIBS=no XCFLAGS=-fPIC prefix=/usr/local build=release install

# zathura-mupdf
wget https://pwmt.org/projects/zathura-pdf-mupdf/download/zathura-pdf-mupdf-0.4.4.tar.xz
tar zxvf zathura-pdf-mupdf-0.4.4.tar.xz
cd zathura-pdf-mupdf-0.4.4
meson build
cd build
ninja
ninja install
cd ../../

# config zathura to use fullscreen
mkdir -p ~/.config/zathura
cat << EOF > ~/.config/zathura/zathurarc
set window-width 1024
EOF

# to run zathura after startx
# DISPLAY=:0 zathura