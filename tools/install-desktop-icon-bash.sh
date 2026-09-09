#!/bin/bash
set -e

root_dir=$(cd "$(dirname "$0")/.." && pwd -P)
bin_dir="$HOME/.local/bin"

for command in wechat-devtools wechat-devtools-cli wechatide; do
    if [ ! -x "$root_dir/bin/$command" ]; then
        echo "$root_dir/bin/$command is not executable" >&2
        exit 1
    fi
    if [ -e "$bin_dir/$command" ] && [ ! -L "$bin_dir/$command" ]; then
        echo "$bin_dir/$command exists and is not a symlink" >&2
        exit 1
    fi
done

for size in "64" "128" "256" "512"; do
    echo "size: $size"
    install -Dm644 "$root_dir/res/icons/${size}x${size}.png" "${HOME}/.local/share/icons/hicolor/${size}x${size}/wechat-devtools.png"
done

# svg
svg_path="${HOME}/.local/share/icons/hicolor/scalable/wechat-devtools.svg"
install -Dm644 "$root_dir/res/icons/wechat-devtools.svg" "$svg_path"

# desktop
template_path="$root_dir/res/template.desktop"
install -Dm644 "$template_path" "$HOME/.local/share/applications/wechat-devtools.desktop"
sed -i 's#dir#'$root_dir'#g' "$HOME/.local/share/applications/wechat-devtools.desktop"

# Use the source build for both the application launcher and CLI commands.
desktop_file="$HOME/.local/share/applications/wechat-devtools.desktop"
sed -i -e 's#^Exec=\(.*\)$#Exec="\1" %U#' \
    -e 's#^MimeType=x-scheme-handler/wechatide$#MimeType=x-scheme-handler/wechatide;#' "$desktop_file"
mkdir -p "$bin_dir"
for command in wechat-devtools wechat-devtools-cli wechatide; do
    ln -sfn "$root_dir/bin/$command" "$bin_dir/$command"
done
if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$HOME/.local/share/applications"
fi
