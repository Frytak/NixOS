GREEN='\x1b[1;32m'
RED='\x1b[1;31m'
NC='\x1b[0m'

cd /etc/nixos || {
    echo -e "${RED}[Failed to change directory to /etc/nixos]${NC}"
    exit 1
}

git add .

if git diff --staged --quiet; then
    echo "No new changes to commit."
else
    git commit -m "Auto-commit: $(date)" > /dev/null
    echo -e "${GREEN}[Committed current configuration]${NC}"
fi

echo -e "${GREEN}[Rebuilding NixOS configuration]${NC}"

if nh os switch . -H ${1}; then
    echo -e "${GREEN}[System rebuilt successfully]${NC}"
else
    echo -e "${RED}[System rebuild failed]${NC}"
    exit 1 
fi
