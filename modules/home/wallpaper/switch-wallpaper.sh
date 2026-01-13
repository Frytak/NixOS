USER=$1
WALLPAPER=$2

hyprctl hyprpaper reload ,$WALLPAPER
echo "\"$WALLPAPER\"" > "/etc/nixos/users/$USER/current-wallpaper.nix"
