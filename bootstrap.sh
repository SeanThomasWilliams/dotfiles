#!/usr/bin/env sh
sudo yum -y install zsh dstat git mlocate gcc subversion python-devel screen python-boto numpy python-setuptools gcc-c++ blas-devel lapack-devel
wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sudo sh
sudo chsh -s /bin/zsh $USER
git config --global user.name "Sean Thomas Williams"
git config --global user.email seanthomaswilliams@gmail.com
git pull --recurse-submodules . 
cp ~/dotfiles/.* ~
cp -r ~/dotfiles/.vim* ~
sudo easy_install scipy 
#sudo easy_install matplotlib 
#sudo easy_install ipython 
#sudo easy_install -U distribute 
#sudo easy_install nltk 
#sudo easy_install scikit-learn
sudo updatedb &
echo
echo "=========="
echo "GCC Version"
gcc --version
echo "=========="
echo "Java Version"
java -version
echo "=========="
echo "Python Version"
python --version
echo "== Done =="
#gpg -o ~/.boto -d .boto.gpg
