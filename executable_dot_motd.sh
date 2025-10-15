FIGLET_FONT="/Users/briankaplan/.config/phm-vga.flf"
if [[ $TERM_PROGRAM == "vscode" ]]; then
  FIGLET_FONT="banner3"
fi
figlet -C utf8 -f $FIGLET_FONT -k -W -w 100 -c "Software Deployed" | lolcat -t -S 19880623
echo "\n\t\t$(uptime)"  | lolcat -t -S 9999
