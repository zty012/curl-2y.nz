#!/usr/bin/env bash
# https://github.com/zty012/curl-2y.nz
set -e

. /etc/os-release

if [ ! -t 0 ]; then
  tput cuu 3
  tput el
fi

echo
echo "$(tput setaf 4)curl 2y.nz$(tput sgr0)"
echo "$(tput setaf 6)$PRETTY_NAME $BUILD_ID$(tput sgr0)"

features=()
if [ "$ID" = "debian" ]; then
  features+=("mirrors")
elif [ "$ID" = "arch" ]; then
  features+=("mirrors" "archlinuxcn" "chaotic-aur" "paru")
fi

echo
for i in "${!features[@]}"; do
  echo "$(tput setaf 3)[$((i + 1))]$(tput sgr0) ${features[i]}"
done
echo -n "Select a feature: "
read -r feature_index

if ! [[ "$feature_index" =~ ^[1-9][0-9]*$ ]] || [ "$feature_index" -lt 1 ] || [ "$feature_index" -gt "${#features[@]}" ]; then
  echo "$(tput setaf 1)Invalid selection.$(tput sgr0)"
  exit 1
fi

selected_feature="${features[$((feature_index - 1))]}"
tput cuu 1
tput el
echo "$(tput setaf 2)Selected: $selected_feature$(tput sgr0)"
echo

if [ "$selected_feature" = "mirrors" ]; then
  # debian
  if [ "$ID" = "debian" ]; then
    if [ -f /etc/apt/sources.list.d/debian.sources ]; then
      echo "Using deb822 format."
      cat <<EOF | sudo tee /etc/apt/sources.list.d/debian.sources
Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/debian
Suites: $VERSION_CODENAME $VERSION_CODENAME-updates $VERSION_CODENAME-backports
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: https://security.debian.org/debian-security
Suites: $VERSION_CODENAME-security
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
EOF
    else
      echo "Using traditional format."
      cat <<EOF | sudo tee /etc/apt/sources.list
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ $VERSION_CODENAME main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ $VERSION_CODENAME-updates main contrib non-free non-free-firmware
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ $VERSION_CODENAME-backports main contrib non-free non-free-firmware
deb https://security.debian.org/debian-security $VERSION_CODENAME-security main contrib non-free non-free-firmware
EOF
    fi
  elif [ "$ID" = "arch" ]; then
    cat <<EOF | sudo tee /etc/pacman.d/mirrorlist
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\\$arch
Server = https://mirrors.shanghaitech.edu.cn/archlinux/\$repo/os/\\$arch
Server = https://mirrors.aliyun.com/archlinux/\$repo/os/\\$arch
Server = https://mirrors.bfsu.edu.cn/archlinux/\$repo/os/\\$arch
Server = https://mirrors.cqu.edu.cn/archlinux/\$repo/os/\\$arch
Server = https://mirrors.hit.edu.cn/archlinux/\$repo/os/\\$arch
Server = https://mirrors.hust.edu.cn/archlinux/\$repo/os/\\$arch
Server = https://mirrors.jcut.edu.cn/archlinux/\$repo/os/\\$arch
Server = https://mirrors.jlu.edu.cn/archlinux/\$repo/os/\\$arch
Server = https://mirrors.jxust.edu.cn/archlinux/\$repo/os/\\$arch
Server = https://mirrors.neusoft.edu.cn/archlinux/\$repo/os/\\$arch
Server = https://mirrors.nju.edu.cn/archlinux/\$repo/os/\\$arch
Server = https://mirrors.njupt.edu.cn/archlinux/\$repo/os/\\$arch
Server = https://mirror.nyist.edu.cn/archlinux/\$repo/os/\\$arch
Server = https://mirrors.qlu.edu.cn/archlinux/\$repo/os/\\$arch
Server = https://mirrors.qvq.net.cn/archlinux/\$repo/os/\\$arch
Server = https://mirror.redrock.team/archlinux/\$repo/os/\\$arch
Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux/\$repo/os/\\$arch
Server = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\\$arch
Server = https://mirrors.wsyu.edu.cn/archlinux/\$repo/os/\\$arch
Server = https://mirrors.xjtu.edu.cn/archlinux/\$repo/os/\\$arch
EOF
  fi
elif [ "$selected_feature" = "archlinuxcn" ]; then
  cat <<EOF | sudo tee /etc/pacman.d/archlinuxcn-mirrorlist
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch
Server = https://mirrors.aliyun.com/archlinuxcn/\$arch
Server = https://mirrors.bfsu.edu.cn/archlinuxcn/\$arch
Server = https://mirrors.cloud.tencent.com/archlinuxcn/\$arch
Server = https://mirrors.cernet.edu.cn/archlinuxcn/\$arch
Server = https://mirrors.pku.edu.cn/archlinuxcn/\$arch
Server = https://mirrors.163.com/archlinux-cn/\$arch
Server = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch
Server = https://mirrors.hit.edu.cn/archlinuxcn/\$arch
Server = https://mirrors.jlu.edu.cn/archlinuxcn/\$arch
Server = https://mirrors.zju.edu.cn/archlinuxcn/\$arch
Server = https://mirrors.cqu.edu.cn/archlinuxcn/\$arch
Server = https://mirrors.cqupt.edu.cn/archlinuxcn/\$arch
Server = https://mirror.sjtu.edu.cn/archlinux-cn/\$arch
Server = https://mirrors.nju.edu.cn/archlinuxcn/\$arch
Server = https://mirrors.sustech.edu.cn/archlinuxcn/\$arch
Server = https://mirrors.hust.edu.cn/archlinuxcn/\$arch
Server = https://mirrors.wsyu.edu.cn/archlinuxcn/\$arch
Server = https://mirror.bjtu.edu.cn/archlinuxcn/\$arch
Server = https://mirror.lzu.edu.cn/archlinuxcn/\$arch
Server = https://mirrors.xjtu.edu.cn/archlinuxcn/\$arch
Server = https://mirror.nyist.edu.cn/archlinuxcn/\$arch
Server = https://mirrors.shanghaitech.edu.cn/archlinuxcn/\$arch
Server = https://mirror.iscas.ac.cn/archlinuxcn/\$arch
Server = https://mirrors.cicku.me/archlinuxcn/\$arch
Server = https://archlinux.ccns.ncku.edu.tw/archlinuxcn/\$arch
Server = https://mirror.twds.com.tw/archlinuxcn/\$arch
Server = https://mirrors.xtom.hk/archlinuxcn/\$arch
Server = https://mirrors.xtom.sg/archlinuxcn/\$arch
Server = https://mirrors.xtom.us/archlinuxcn/\$arch
Server = https://mirrors.xtom.nl/archlinuxcn/\$arch
Server = https://mirrors.xtom.de/archlinuxcn/\$arch
Server = https://mirrors.xtom.jp/archlinuxcn/\$arch
Server = https://mirrors.xtom.au/archlinuxcn/\$arch
Server = https://mirrors.ocf.berkeley.edu/archlinuxcn/\$arch
EOF
  cat <<EOF | sudo tee -a /etc/pacman.conf
[archlinuxcn]
Include = /etc/pacman.d/archlinuxcn-mirrorlist
EOF
elif [ "$selected_feature" = "chaotic-aur" ]; then
  sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
  sudo pacman-key --lsign-key 3056513887B78AEB
  sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
  sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
  cat <<EOF | sudo tee -a /etc/pacman.conf
[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist
EOF
elif [ "$selected_feature" = "paru" ]; then
  sudo pacman -S --needed paru || {
    sudo pacman -S --needed base-devel
    cd /tmp
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
  }
  sudo sed -i 's/#SkipReview/SkipReview/' /etc/paru.conf
else
  echo "$(tput setaf 1)Feature not implemented yet.$(tput sgr0)"
  exit 1
fi

echo "$(tput setaf 2)Done.$(tput sgr0)"
