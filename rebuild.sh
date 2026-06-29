GREEN='\x1b[1;32m'
RED='\x1b[1;31m'
NC='\x1b[0m'

cd /etc/nixos || {
    echo -e "${RED}[Failed to change directory to /etc/nixos]${NC}"
    exit 1
}

echo -e "${GREEN}[Rebuilding NixOS configuration]${NC}"

git add .

if git diff --staged --quiet; then
    echo "No new changes to commit."
else
    git commit -m "Auto-commit: $(date)" > /dev/null
    echo -e "${GREEN}[Committed current configuration]${NC}"
fi

if sudo nixos-rebuild switch --flake /etc/nixos/\#BBM; then
    echo -e "${GREEN}[System rebuilt successfully]${NC}"
else
    echo -e "${RED}[System rebuild failed]${NC}"
    exit 1 
fi
