# orcarice

Ansible provisioning — Arch Linux, desktop orca + laptop.

## Structure

```
orcarice/
├── inventory/
├── roles/
│   ├── packages/
│   ├── boot/
│   ├── gpu/
│   ├── display-manager/
│   ├── services/
│   ├── docker/
│   └── hetzner/
├── dotfiles/
│   ├── sway/
│   ├── waybar/          # TODO
│   ├── i3status-rust/
│   ├── rofi/
│   ├── foot/
│   ├── nvim/
│   ├── zsh/             # TODO
│   ├── wlogout/         # TODO
│   ├── btop/            # TODO
│   ├── fastfetch/       # TODO
│   ├── cava/            # TODO
│   ├── ncmpcpp/         # TODO
│   ├── mpd/             # TODO
│   ├── git/             # TODO
│   ├── gtk-3.0/         # TODO
│   ├── gtk-4.0/         # TODO
│   ├── qt5ct/           # TODO
│   ├── qt6ct/           # TODO
│   └── bin/             # TODO (start-sway)
└── playbooks/
```

## Symlinks

Ansible crée les symlinks : `~/ansible/dotfiles/<outil>/ → ~/.config/<outil>/`

## Machines

| Host | IP | AUR |
|---|---|---|
| orca | desktop | yay |
| orca-laptop | 192.168.43.181 | yay |

## Backlog

- [ ] Créer `inventory/hosts.yml`
- [ ] Créer `group_vars/all.yml`
- [ ] Role `dotfiles` — création des symlinks
- [ ] Role `packages` — liste pacman + AUR
- [ ] Role `boot` — systemd-boot, mkinitcpio, fstab
- [ ] Role `gpu` — amdgpu + NVIDIA PRIME, modprobe
- [ ] Role `display-manager` — ly, PAM
- [ ] Role `services` — units, drop-in networkd, RGB off
- [ ] Role `docker` — br_netfilter
- [ ] Role `hetzner` — user unit mount
- [ ] Ajouter dotfiles manquants (zsh, btop, fastfetch, git, gtk, qt, wlogout, ncmpcpp, mpd, cava, bin/)
