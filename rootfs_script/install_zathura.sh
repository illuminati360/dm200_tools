#!/bin/bash

cd /tmp

pipx install meson
pipx ensurepath
source ~/.bashrc

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
tar zxvf mupdf-1.24.9-source.tar.gz
cd mupdf-1.24.9-source
make shared=no USE_SYSTEM_LIBS=no XCFLAGS=-fPIC prefix=/usr/local build=release install

# zathura-mupdf
wget https://pwmt.org/projects/zathura-pdf-mupdf/download/zathura-pdf-mupdf-0.4.4.tar.xz
tar xvf zathura-pdf-mupdf-0.4.4.tar.xz
cd zathura-pdf-mupdf-0.4.4
meson build
cd build
ninja
ninja install
cd ../../

# config zathura to use fullscreen
mkdir -p /home/$USER_NAME/.config/zathura
cat << EOF > /home/$USER_NAME/.config/zathura/zathurarc
set window-width 1024
EOF

rm /tmp/install_zathura.sh
rm -r /tmp/girara*
rm -r /tmp/mupdf*
rm -r /tmp/zathura*