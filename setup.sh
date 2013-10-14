#!/bin/bash

# http://wiki.ubuntu.org.cn/Shell%E7%BC%96%E7%A8%8B%E5%9F%BA%E7%A1%80

# {{{ 安装Dropbox
# 安装Git
#sudo apt-get -y install git

# 下载配置文件
mkdir ~/Dropbox
cd ~/Dropbox
git clone https://PeterHo@github.com/PeterHo/Settings.git

# 安装并启动Dropbox
#cd ~/Dropbox/Settings
#sudo dpkg -i dropbox_1.6.0_amd64.deb
#dropbox start -i
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
sudo add-apt-repository -y "deb https://linux.dropbox.com/ubuntu $(lsb_release -sc) main"
sudo apt-get update
sudo apt-get install -y dropbox
dropbox start
# }}}


# {{{ 全局变量
# Vim中文文档版本号
vimcdoc_version="1.9.0"

# }}}


# {{{ 安装软件
# 添加软件源
sudo add-apt-repository -y ppa:fcwu-tw/ppa
sudo apt-get update

=======
# Vim中文文档版本号
vimcdoc_version="1.9.0"

# {{{ 安装软件
# 添加软件源
# sudo add-apt-repository ppa:fcwu-tw/ppa
# sudo apt-get update


# Git
# sudo apt-get -y install git

# awesome
sudo apt-get -y install awesome awesome-extra

# C/C++编译开发环境
sudo apt-get -y install build-essential
sudo apt-get -y install cmake
sudo apt-get -y install clang libclang-dev 

# Vim
sudo apt-get -y install vim vim-gnome

# Vim依赖
sudo apt-get -y install exuberant-ctags
sudo apt-get -y install cscope
sudo apt-get -y install wmctrl


# }}}


# 等待直到Dropbox文件同步完成
#while :
#do
#	if [ ((dropbox status)) == "Idle" ]
#	then
#		break
#	fi
#	sleep 1
#done

# {{{ 配置软件
# awesome
mkdir -p ~/.config/awesome/
ln ~/Dropbox/Settings/awesome/rc.lua ~/.config/awesome/rc.lua
git clone https://github.com/mikar/awesome-themes.git ~/.config/awesome/themes


# Git
git config --global user.name "Peter Ho"
git config --global user.email "peterho1024@gmail.com"
git config --global core.editor gvim
git config --global merge.tool gvimdiff
 
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'


# Vim
mkdir ~/.vim
ln ~/Dropbox/Settings/Vim/.vimrc ~/.vimrc
ln -s ~/Dropbox/Settings/Vim/settings ~/.vim/settings
ln -s ~/Dropbox/Settings/Vim/colors ~/.vim/colors

tar -xzvf "${HOME}/Dropbox/Tools/vimcdoc-${vimcdoc_version}.tar.gz" -C ~/.vim/
/bin/bash "${HOME}/.vim/vimcdoc-${vimcdoc_version}/vimcdoc.sh" -i

# 安装插件
# vundle
git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

# 下载插件
vim +BundleInstall +qall

# 安装字体
mkdir ~/.fonts
cp -r ~/.vim/bundle/powerline-fonts/* ~/.fonts
fc-cache -vf ~/.fonts


# 修改终端模拟器的字体为 Source Code Pro For Powerline



# 五笔输入法



# }}}





#清理不用的软件包
sudo apt-get autoremove