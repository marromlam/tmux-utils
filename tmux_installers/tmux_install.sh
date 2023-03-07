## setup _________________________________

TMUX_VER=2.3
LIBEVENT_VER=2.1.8-stable
LIBCURSES_VER=6.1
TEMP_COMPILE=~/tmux-temp-compile
COMMON_INSTALL_PREFIX=/home3/marcos.romero/meh
SYMLINK=/home3/marcos.romero/.local/bin/tmux


PATH=/usr/local/sbin:/usr/local/bin:/usr/sue/bin:/usr/lib64/qt-3.3/bin:/usr/bin:/home3/marcos.romero/bin:/usr/sbin:/home3/marcos.romero/.linuxbrew/opt/fzf/bin:/home3/marcos.romero/.dotfiles/scripts:
rm -rf $COMMON_INSTALL_PREFIX/*
rm -rf $TEMP_COMPILE/*

## _______________________________________

echo
echo ">>> Creating and using temporary dir ${TEMP_COMPILE} for downloading and compiling libevent and tmux ..."
echo

mkdir ${TEMP_COMPILE}
cd ${TEMP_COMPILE}

echo
echo ">>> Downloading the releases ..."
echo

curl -OL https://github.com/tmux/tmux/releases/download/${TMUX_VER}/tmux-${TMUX_VER}.tar.gz
curl -OL https://ftp.gnu.org/pub/gnu/ncurses/ncurses-${LIBCURSES_VER}.tar.gz
curl -OL https://github.com/libevent/libevent/releases/download/release-${LIBEVENT_VER}/libevent-${LIBEVENT_VER}.tar.gz

echo
echo ">>> Extracting tmux ${TMUX_VER} and libevent ${LIBEVENT_VER} ..."
echo

tar xzf tmux-${TMUX_VER}.tar.gz
tar xzf libevent-${LIBEVENT_VER}.tar.gz
tar xzf ncurses-${LIBCURSES_VER}.tar.gz

echo
echo ">>> Compiling libevent ..."
echo

cd libevent-${LIBEVENT_VER}
./configure --prefix=${COMMON_INSTALL_PREFIX}
make
make install
cd ..


echo
echo ">>> Compiling ncurses ..."
echo

cd ncurses-${LIBCURSES_VER}
./configure --prefix=${COMMON_INSTALL_PREFIX} CFLAGS="-I${COMMON_INSTALL_PREFIX}/include" LDFLAGS="-L${COMMON_INSTALL_PREFIX}/lib"
make -j
make -j install
cd ..

echo
echo ">>> Compiling tmux ..."
echo

cd tmux-${TMUX_VER}
# LDFLAGS="-L${COMMON_INSTALL_PREFIX}/lib" CPPFLAGS="-I${COMMON_INSTALL_PREFIX}/include" LIBS="-lresolv"
./configure --prefix=${COMMON_INSTALL_PREFIX} CFLAGS="-I${COMMON_INSTALL_PREFIX}/include -I${COMMON_INSTALL_PREFIX}/include/ncurses" LDFLAGS="-L${COMMON_INSTALL_PREFIX}/lib"
make
echo
echo ">>> Installing tmux in ${COMMON_INSTALL_PREFIX}/bin ..."
echo

make -j install

echo
echo ">>> Symlink to it from ${SYMLINK} ..."
ln -sf ${COMMON_INSTALL_PREFIX}/bin/tmux ${SYMLINK}

echo
echo ">>> Cleaning up by removing the temporary dir ${TEMP_COMPILE} ..."
echo

# cd ..
# rm -rf ${TEMP_COMPILE}
