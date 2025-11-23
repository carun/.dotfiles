# Setup

```
git clone https://github.com/carun/.dotfiles && cd .dotfiles && ./install.sh
```

# Misc

## Map copilot key to right control on Asus Vivobook14

```
$ sudo apt install keyd
$ sudo cat /etc/keyd/default.conf
[ids]
0001:0001:09b4e68d

[main]
leftmeta+leftshift+f23 = rightcontrol
```

