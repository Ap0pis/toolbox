#!/bin/bash
# Lista i file nella cartella corrente con le righe 2-4 per ciascuno

# Directory da ciclare
dir="$PWD"

# Check if the target is not a directory
if [ ! -d "$dir" ]; then
  echo "Non trova la directory: $dir"
  exit 1
fi

# Colore rosso
RED='\033[0;31m'
NC='\033[0m' # No Color (reset)

# Loop through files in the target directory
for file in "$dir"/*; do
  if [ -f "$file" ] && [ -r "$file" ]; then
    filename=$(basename "$file")
    echo -e "${RED}${filename}${NC}"
    sed -n '2,4p' "$file"
    echo
  fi
done
