git add .
git commit -m "$(date)"
nixos-rebuild switch --flake /etc/nixos/#BBM
