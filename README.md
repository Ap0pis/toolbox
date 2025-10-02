Su Windows (PowerShell): 

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\setup_win.ps1

oppure

iex (iwr -UseBasicParsing https://raw.githubusercontent.com/Ap0pis/toolbox/main/setup_win.ps1)


Su Linux CLI:

bash -c "$(curl -fsSL https://raw.githubusercontent.com/Ap0pis/toolbox/main/setup.sh)"

oppure

bash -c "$(wget -qO- https://raw.githubusercontent.com/Ap0pis/toolbox/main/setup-toolbox.sh)"


