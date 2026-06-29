git add .
git commit -m "$(date)"
sudo nixos-rebuild switch --flake /etc/nixos/#BBM
