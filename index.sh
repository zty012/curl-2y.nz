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

echo "WIP..."
exit

features=()
if [ "$ID" = "debian" ]; then
  features+=("bootstrap")
elif [ "$ID" = "arch" ]; then
  features+=("archlinuxcn" "paru" "chaotic-aur")
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
