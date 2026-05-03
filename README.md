## Requirement

hyprland hyprpaper hyprlock hypridle hyprpolkitagent

swaync waybar cliphist pacman-contrib

pavucontrol

greetd-tuigreet-fork-bin (AUR)

## Font for waybar

"CodeNewRoman Nerd Font Propo" (otf-codenewroman-nerd)

## hyprpm

### Requirement

cmake, cpio, pkg-config, git, g++, gcc

### Install hyprexpo

```bash
hyprpm update
hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm enable hyprexpo
```

## wal

python-pywal

```bash
wal -i "/path/to/some/image" -n
```

## Chinese input method

fcitx5 fcitx5-gtk fcitx5-qt
fcitx5-rime rime-luna-pinyin rime-pinyin-zhwiki
fcitx5-configtool


## polycat (runcat for waybar)

https://github.com/zzimt/polycat

## Control HDR in waybar

If your monitor supports HDR, and you want to control it in waybar

- Replace your monitors config with `source = ~/.config/hypr/hdr_monitor.conf` in `hyprland.config`
- Use this script https://gist.github.com/OmmyZhang/8d2fa57df35c3eb2306633d1e2328025
