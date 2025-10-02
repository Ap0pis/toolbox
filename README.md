Su Windows (PowerShell): 

  Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
  .\setup_win.ps1

oppure

  iex (iwr -UseBasicParsing https://raw.githubusercontent.com/Ap0pis/toolbox/main/setup_win.ps1)


Su Linux CLI:

  curl -fsSL https://raw.githubusercontent.com/Ap0pis/toolbox/main/setup.sh | bash 


