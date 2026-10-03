# Setup
## Docker compose backup
retrieve a backup from the NAS and put it in ~/Documents
```shell
user@hostname:~/Documents/homelab$ pwd
/home/<user>/Documents/homelab
```

## SSH
```shell
sudo apt update
sudo apt install openssh-server -y
sudo systemctl enable ssh
```
Last instruction forces auto start of the service
## Docker
```shell
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
# add user to docker group
sudo usermod -aG docker <user>
# log out and reconnect
sudo systemctl start docker
# to verify:
sudo docker run hello-world
```
## Docker compose
```shell
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

## Disable sleep when closing lid
- Open the /etc/systemd/logind.conf file in a text editor as root, for example, `sudoedit /etc/systemd/logind.conf`
- If HandleLidSwitch is not set to ignore then change it: `HandleLidSwitch=ignore`
- Restart the systemd daemon (be aware that this will log you off) with this command: `sudo service systemd-logind restart`
- It might freeze, just long press the power button...

## Mount NAS
- `sudo apt install cifs-utils`
- add the mount to /etc/fstab:
```shell
sudo nano /etc/fstab
//NAS-IP/home /mnt/nas/<shared-storage> cifs credentials=/home/<user>/Documents/homelab/.smbcredentials,uid=1000,gid=1000,vers=3.0,nofail
```
- `sudo mount -a`

## Adguard home
Edit systemd resolv conf:
```shell
sudo sed -i "s/#DNSStubListener=yes/DNSStubListener=no/" /etc/systemd/resolved.conf
systemctl daemon-reload
sudo systemctl restart systemd-resolved
```

## Backup
Setup the automatic backup cron:
```shell
crontab -e
```
Add the following task to the crontab file:
`0 1 * * * sh ~/Documents/homelab/backup_script.sh`

## Cockpit
Install Cockpit to monitor system upgrades
```
sudo apt update
sudo apt install cockpit
sudo systemctl enable --now cockpit.socket
```
