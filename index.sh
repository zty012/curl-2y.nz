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
  features+=("mirrors")
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
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.shanghaitech.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.aliyun.com/archlinux/\$repo/os/\$arch
Server = https://mirrors.bfsu.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.cqu.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.hit.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.hust.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.jcut.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.jlu.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.jxust.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.neusoft.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.nju.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.njupt.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirror.nyist.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.qlu.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.qvq.net.cn/archlinux/\$repo/os/\$arch
Server = https://mirror.redrock.team/archlinux/\$repo/os/\$arch
Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.ustc.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.wsyu.edu.cn/archlinux/\$repo/os/\$arch
Server = https://mirrors.xjtu.edu.cn/archlinux/\$repo/os/\$arch
EOF
  fi
elif [ "$selected_feature" = "archlinuxcn" ]; then
  echo wip
elif [ "$selected_feature" = "paru" ]; then
  echo wip
elif [ "$selected_feature" = "chaotic-aur" ]; then
  echo wip
else
  echo "$(tput setaf 1)Feature not implemented yet.$(tput sgr0)"
  exit 1
fi

echo "$(tput setaf 2)Done.$(tput sgr0)"
