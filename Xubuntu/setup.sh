MyID=`whoami`


######################################################################################################
#添加软件源
######################################################################################################

sudo add-apt-repository ppa:gophers/go          #golang
sudo add-apt-repository ppa:fcitx-team/nightly  #fcitx
sudo apt-get update


######################################################################################################
#安装设置软件
######################################################################################################

sudo apt-get -y install virtualbox
sudo apt-get -y install gnome-tweak-tool        #set font etc...
sudo apt-get -y install ia32-libs               #32bit support
sudo apt-get -y install python
sudo apt-get -y install golang-stable
sudo apt-get -y install git-core
sudo apt-get -y install git
sudo apt-get -y install mercurial
sudo apt-get -y install cmake
sudo apt-get -y install icedtea-netx
sudo apt-get -y install vlc
sudo apt-get -y install keepassx 
sudo apt-get -y install ubuntu-restricted-extras
sudo apt-get -y install goldendict

#fcitx
sudo apt-get -y remove ibus
sudo apt-get -y remove ibus-pinyin
sudo apt-get -y remove ibus-sunpinyin
sudo apt-get -y install fcitx
sudo apt-get -y install fcitx-sunpinyin

#gedit
gsettings set org.gnome.gedit.preferences.encodings auto-detected "['UTF-8', 'GB18030', 'GB2312', 'GBK', 'BIG5', 'CURRENT', 'UTF-16']"
gsettings set org.gnome.gedit.preferences.encodings shown-in-menu "['UTF-8', 'GB18030', 'GB2312', 'GBK', 'BIG5', 'CURRENT', 'UTF-16']"

#nautilus
#echo "(gtk_accel_path \"<Actions>/ShellActions/Up\" \"BackSpace\")" >> ~/.config/nautilus/accels
#nautilus -q


######################################################################################################
#安装设置Vim
######################################################################################################

#echo "function gvim () { (/usr/bin/gvim -f "$@" &) }" >> ~/.bashrc
#安装Vim依赖的软件
sudo apt-get -y install libncurses5-dev \
    libgnome2-dev \
    libgnomeui-dev \
    libgtk2.0-dev \
    libatk1.0-dev \
    libbonoboui2-dev \
    libcairo2-dev \
    libx11-dev \
    libxpm-dev \
    libxt-dev \
    python-dev \
    ruby-dev \
    mercurial \
    exuberant-ctags \
    cscope \
    wmctrl

#卸载老版本的Vim
sudo apt-get -y remove vim \
    vim-runtime \
    gvim \
    vim-tiny \
    vim-common \
    vim-gui-common

#下载Vim源码并编译
cd ~
hg clone https://code.google.com/p/vim/
cd vim
./configure --with-features=huge \
    --enable-rubyinterp \
    --enable-pythoninterp \
    --enable-perlinterp \
    --enable-gui=gnome2 \
    --enable-cscope \
    --prefix=/usr \
    --with-x \
    --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu/
make VIMRUNTIMEDIR=/usr/share/vim/vim73
sudo make install

#创建快捷方式
sudo cp ~/.vim/settings/gvim.desktop /usr/share/applications/gvim.desktop

#vimrc
ln -s ~/.vim/settings/.vimrc ~/.vimrc

#安装插件
#vundle
git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
#ycm
sudo apt-get -y install clang libclang-dev
#gocode
go get -u github.com/nsf/gocode
cd $GOPATH/src/github.com/nsf/gocode/vim
./update.sh
gocode set propose-builtins true

#下载插件
vim +BundleInstall +qall

#ycm
cd ~/.vim/bundle/YouCompleteMe
./install.sh --clang-completer

#gocode
echo '
export GOROOT=/usr/lib/go
export GOPATH=~/go
export GOBIN=$GOROOT/bin
export PATH=$PATH:$GOBIN' >> ~/.profile
source ~/.profile

sudo go get -u github.com/nsf/gocode
cd $GOPATH/src/github.com/nsf/gocode/vim
./pathogen_update.sh
gocode set propose-builtins true

#PowerLine
mkdir ~/.fonts
cp -r ~/.vim/bundle/powerline-fonts/* ~/.fonts
fc-cache -vf ~/.fonts


#创建系统tags
ctags -I __THROW -I __attribute_pure__ -I __nonnull -I __attribute__ --file-scope=yes --langmap=c:+.h --languages=c,c++ --links=yes --c-kinds=+p --c++-kinds=+p --fields=+iaS --extra=+q  -f ~/.vim/capptags  /usr/include/*
ctags -I __THROW -I __attribute_pure__ -I __nonnull -I __attribute__ --file-scope=yes --langmap=c:+.h --languages=c,c++ --links=yes --c-kinds=+p --c++-kinds=+p --fields=+iaS --extra=+q  -f ~/.vim/nettags  /usr/include/netinet/* /usr/include/arpa/*
ctags -I __THROW -I __attribute_pure__ -I __nonnull -I __attribute__ --file-scope=yes --langmap=c:+.h --languages=c,c++ --links=yes --c-kinds=+p --c++-kinds=+p --fields=+iaS --extra=+q  -f ~/.vim/drivertags  /usr/src/linux-headers-$(uname -r)/include/linux/*

#清理不用的软件包
sudo apt-get autoremove
