# Format disk
sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb
sudo mount -o discard,defaults /dev/sdb /mnt/sdb/
sudo chmod a+w /mnt/sdb/
sudo cp /etc/fstab /etc/fstab.backup
echo UUID=`sudo blkid -s UUID -o value /dev/sdb` /mnt/sdb/ ext4 discard,defaults,nofail  2 | sudo tee -a /etc/fstab

# Install docker
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
sudo systemctl start docker
sudo systemctl enable docker

# Install nexus
chown -R 200 /mnt/sdb
docker run -d -p 80:8081 --name nexus -v /mnt/sdb:/sonatype-work sonatype/nexus