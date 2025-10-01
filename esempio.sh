#!/bin/bash
#tentativo di confronto tra stringhe
echo scrivi ciao
read string 
if [[ "$string" == "ciao" ]]; then echo bravo
else echo due palle, non funziona
fi
