# Resolve WSL DNS error with using VPN

Original answer: https://superuser.com/questions/1630487/no-internet-connection-ubuntu-wsl-while-vpn

1. Disable DNS autogen

Run

```bash
sudo nano /etc/wsl.conf
```

And comment this string (or just delete)

```bash
# [network]
# generateResolvConf = false
```

2. Run copy-dns script

Make exec as sudo

```bash
sudo chmod +x ~/.config/wsl/vpn-dns.sh
echo "$(whoami) ALL=(ALL) NOPASSWD: ~/.config/wsl/vpn-dns.sh" | sudo tee /etc/sudoers.d/010-$(whoami)-vpn-dns
```

Run

```bash
sudo /bin/vpn-dns.sh
```

3. Make executable at startup

```bash
echo "sudo ~/.config/wsl/vpn-dns.sh" | sudo tee /etc/profile.d/vpn-dns.sh
```
