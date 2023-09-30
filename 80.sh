#!/bin/bash

sudo apt-get update 
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

sudo apt-get autoclean
sudo apt-get autoremove
systemctl daemon reload

sudo apt install fail2ban -y

sudo systemctl start fail2ban
sudo systemctl enable fail2ban

sudo apt install iptables -y

iptables -A INPUT -p icmp -j DROP
sudo iptables-save > /etc/iptables.rules
echo "[Unit]" | sudo tee /etc/systemd/system/iptables-restore.service
echo "Description=Restore iptables rules" | sudo tee -a /etc/systemd/system/iptables-restore.service
echo "" | sudo tee -a /etc/systemd/system/iptables-restore.service
echo "[Service]" | sudo tee -a /etc/systemd/system/iptables-restore.service
echo "ExecStart=/sbin/iptables-restore /etc/iptables.rules" | sudo tee -a /etc/systemd/system/iptables-restore.service
echo "Type=oneshot" | sudo tee -a /etc/systemd/system/iptables-restore.service
echo "RemainAfterExit=yes" | sudo tee -a /etc/systemd/system/iptables-restore.service
echo "" | sudo tee -a /etc/systemd/system/iptables-restore.service
echo "[Install]" | sudo tee -a /etc/systemd/system/iptables-restore.service
echo "WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/iptables-restore.service
sudo systemctl enable iptables-restore.service
sudo systemctl start iptables-restore.service

sudo apt-get install apt-listchanges -y

wget http://ftp.tw.debian.org/debian/pool/main/a/apt-listbugs/apt-listbugs_0.1.40_all.deb
sudo dpkg -i apt-listbugs_0.1.40_all.deb
sudo apt-get -f install -y
sudo dpkg -i apt-listbugs_0.1.40_all.deb
sudo apt-get install -y libpam-tmpdir

sudo bash -c 'echo "# Disable ICMP Redirect Acceptance" >> /etc/sysctl.d/99-custom-sysctl.conf'
sudo bash -c 'echo "net.ipv4.conf.all.accept_redirects=0" >> /etc/sysctl.d/99-custom-sysctl.conf'
sudo bash -c 'echo "net.ipv4.conf.all.log_martians=1" >> /etc/sysctl.d/99-custom-sysctl.conf'
sudo bash -c 'echo "net.ipv4.conf.all.rp_filter=1" >> /etc/sysctl.d/99-custom-sysctl.conf'
sudo bash -c 'echo "net.ipv4.conf.all.send_redirects=0" >> /etc/sysctl.d/99-custom-sysctl.conf'
sudo bash -c 'echo "net.ipv4.conf.default.accept_redirects=0" >> /etc/sysctl.d/99-custom-sysctl.conf'
sudo bash -c 'echo "net.ipv4.conf.default.log_martians=1" >> /etc/sysctl.d/99-custom-sysctl.conf'
sudo bash -c 'echo "net.ipv6.conf.all.accept_redirects=0" >> /etc/sysctl.d/99-custom-sysctl.conf'
sudo bash -c 'echo "net.ipv6.conf.default.accept_redirects=0" >> /etc/sysctl.d/99-custom-sysctl.conf'
sudo sh -c 'echo "net.core.bpf_jit_harden=2" >> /etc/sysctl.d/99-custom-sysctl.conf'
sudo sh -c 'echo "net.core.bpf_jit_harden=2" >> /etc/sysctl.d/99-custom-sysctl.conf'
echo "kernel.perf_event_paranoid = 3" | sudo tee -a /etc/sysctl.conf
echo "kernel.perf_event_paranoid = 3" | sudo tee /etc/sysctl.d/99-custom.conf
echo "kernel.sysrq = 0" | sudo tee -a /etc/sysctl.conf
echo "kernel.unprivileged_bpf_disabled = 1" | sudo tee -a /etc/sysctl.conf

echo "kernel.sysrq = 0" | sudo tee /etc/sysctl.d/99-custom.conf
echo "kernel.unprivileged_bpf_disabled = 1" | sudo tee -a /etc/sysctl.d/99-custom.conf
echo "fs.protected_fifos = 2" | sudo tee -a /etc/sysctl.conf
echo "fs.protected_fifos = 2" | sudo tee /etc/sysctl.d/99-protected-fifos.conf
echo "fs.suid_dumpable = 0" | sudo tee -a /etc/sysctl.conf
echo "fs.suid_dumpable = 0" | sudo tee /etc/sysctl.d/99-suid-dumpable.conf

sudo sysctl --system
sudo sysctl -p

sudo apt-get install -y libpam-tmpdir


cp /etc/ssh/sshd_config /root/sshd_config
systemctl daemon reload

echo -e "* hard core 0\n* soft core 0" | sudo tee -a /etc/security/limits.conf

cat <<EOL | sudo tee /etc/systemd/system/systemd-ask-password-wall.service > /dev/null
[Unit]
Description=Wall Handling of Password Requests

[Service]
User=root
Group=root
EOL

sudo systemctl daemon-reload

rm /etc/ssh/sshd_config
sudo bash -c "cat > /etc/ssh/sshd_config << 'EOF'
LogLevel VERBOSE
MaxSessions 1
PasswordAuthentication no
KbdInteractiveAuthentication no
UsePAM yes
AllowAgentForwarding no
AllowTcpForwarding no
PrintMotd no
TCPKeepAlive no
Compression no
ClientAliveCountMax 0
AcceptEnv LANG LC_*
Subsystem       sftp    /usr/lib/openssh/sftp-server
X11Forwarding no
IgnoreRhosts yes
UseDNS no
PermitEmptyPasswords no
MaxAuthTries 3
PubkeyAuthentication yes
PasswordAuthentication no
PermitRootLogin no
Protocol 2
Banner /etc/sshbanner
Port 1822
AllowUsers ubuntu
AllowGroups ubuntu
EOF
"

sudo systemctl daemon-reload
sudo systemctl restart sshd

sudo chown root:root /boot/grub/grub.cfg
sudo chmod 400 /boot/grub/grub.cfg
sudo chown root:root /etc/crontab
sudo chmod 600 /etc/crontab
sudo chown root:root /etc/ssh/sshd_config
sudo chmod 600 /etc/ssh/sshd_config
sudo chown -R root:root /etc/cron.d /etc/cron.daily /etc/cron.hourly /etc/cron.weekly /etc/cron.monthly
sudo chmod -R 700 /etc/cron.d /etc/cron.daily /etc/cron.hourly /etc/cron.weekly /etc/cron.monthly

sudo apt-get install grub-efi-amd64 grub-efi-amd64-bin
apt full-upgrade
apt-get dist-upgrade

apt install lynis -y
