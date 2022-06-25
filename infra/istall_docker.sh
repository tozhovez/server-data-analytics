#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker root

sudo yum install gcc libffi-devel openssl-devel -y
sudo pip install -U docker-compose



add-apt-repository universe
add-apt-repository multiverse

sudo apt-get clean -y \
    && apt-get update -y \
    && apt-get upgrade -y



sudo apt-get install -y make build-essential \
    libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget \
    curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev \
    python-openssl git s3fs fuse ec2-api-tools \
    automake autotools-dev g++ libcurl4-openssl-dev \
    libfuse-dev libxml2-dev pkg-config \
    nfs-kernel-server nfs-common awscli \
    inotify-tools gzip

if [ ! -d ~/.pyenv] 
then
	git clone https://github.com/pyenv/pyenv.git ~/.pyenv
	echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
	echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
	echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc
	#echo `exec $SHELL`
	pyenv install 3.7.4 && pyenv global 3.7.4 && pyenv rehash
fi


#sudo apt-get dist-upgrade

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
sudo usermod -a -G tty $USER
sudo usermod -a -G dialout $USER
#
# Configure docker and serial sudo
#

#sudo chmod 666 /dev/ttyACM0
#sudo chmod 666 /dev/ttyACM1
sudo gpasswd --add ${USER} dialout
sudo chmod g+rwx "/home/$USER/.docker" -R
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R


#
# Install docker-compose
#
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version


#
# Login to github repo
#
docker login -u github-ci-token -p UPtaYiHB7aAtxfAypoQs registry.github.com


# rc.local permissions
sudo chmod +x /etc/rc.local

#
# s3fs :
# 1. Updating local repository and Installing required packages
#
if [ ! -d s3fs-fuse ] 
then

	git clone https://github.com/s3fs-fuse/s3fs-fuse.git
	cd s3fs-fuse \
		&& ./autogen.sh \
		&& ./configure \
 		&& make && make install
	cd ..
fi
#Installing pr-required dependency
python -m pip install --upgrade pip
python -m pip install awscli --user
#






