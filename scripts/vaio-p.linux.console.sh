echo "Changing the console font..."
sudo sed -i 's/CODESET=.*/CODESET="lat15"/' /etc/default/console-setup
sudo sed -i 's/FONTFACE=.*/FONTFACE="Terminus"/' /etc/default/console-setup
sudo sed -i 's/FONTSIZE=.*/FONTSIZE="16x32"/' /etc/default/console-setup

echo "Disabling Caps Lock..."
sudo sed -i 's/XKBOPTIONS=.*/XKBOPTIONS="ctrl:nocaps"/' /etc/default/keyboard
