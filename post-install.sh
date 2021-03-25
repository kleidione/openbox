#!/bin/bash 

# Atualiza repositórios:
pacman -Syy

# Define o idioma padrão do sistema:
sed -i '/en_US.U/,+1 s/^#//' /etc/locale.gen ; sed -i '/pt_BR/,+1 s/^#//' /etc/locale.gen ; echo LANG=pt_BR.UTF-8 > /etc/locale.conf ; locale-gen ; export LANG=pt_BR.UTF-8

# Define o idioma padrão do teclado:
loadkeys br-abnt ; echo -e "KEYMAP=br-abnt2\nFONT=Lat2-Terminus16\nFONT_MAP=" > /etc/vconsole.conf ; mkdir -p /etc/X11/xorg.conf.d ; echo -e 'Section "InputClass"\nIdentifier "Keyboard Defaults"\nMatchIsKeyboard "yes"\nOption "XkbLayout" "br"\nEndSection' | tee /etc/X11/xorg.conf.d/01-keyboard-layout.conf

# Define a hora local:
ln -sf /usr/share/zoneinfo/America/Belem /etc/localtime
sed -i '/NTP/,+1 s/^#//' /etc/systemd/timesyncd.conf ; systemctl enable systemd-timesyncd ; clear

# Habilita o uso do sudo a usuários do grupo wheel:
sed -i '/%wheel ALL=(ALL) ALL/s/^#//' /etc/sudoers

# Define senha para o usuário root:
clear ; echo " "  ; echo "Senha para o usuário ROOT" ;  passwd ; sleep 2

# Cria e define uma senha para o usuário padrão:
clear ; echo "Digite o nome de usuário:" ; read usrname
useradd -m -g users -G wheel,storage,power -s /bin/bash $usrname ; sleep 1 ; clear ; echo "Senha do usuário" ; passwd $usrname ; chsh -s /bin/zsh $usrname
clear ; sleep 2

# Define o nome do host (maquina):
echo "archlinux" > /etc/hostname

# Instala o Grub:
echo "Instalando o grub em /dev/sda..." ; sleep 2
grub-install --recheck /dev/sda ; grub-mkconfig -o /boot/grub/grub.cfg

# Instala o xorg + extras:
pacman -S --noconfirm xorg-server xorg-xinit xorg-xkill xorg-xrandr alsa alsa-lib alsa-utils alsa-oss mesa xf86-video-intel vulkan-intel intel-ucode ttf-dejavu ttf-liberation noto-fonts nerd-fonts-hack

# Instala o openbox + extras:
pacman -S --noconfirm openbox obconf polybar hsetroot rofi picom

# Instala aplicações:
pacman -S --noconfirm wget git curl p7zip file-roller ntfs-3g hdparm cups yad gvfs gvfs-mtp xdg-user-dirs xdg-utils polkit-gnome numlockx xfce4-terminal thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman pluma ristretto tumbler xfce4-settings xfce4-power-manager xfce4-screenshooter neofetch figlet cowsay gimp firefox-i18n-pt-br ttf-dejavu ttf-liberation noto-fonts vlc qbittorrent 

# Instala aplicação oficial telegram:
wget "https://telegram.org/dl/desktop/linux" -O telegram.tar.xz ; tar Jxf telegram.tar.xz -C /opt/ ; mv /opt/Telegram*/ /opt/telegram ; ln -sf /opt/telegram/Telegram /usr/bin/telegram ; echo -e '[Desktop Entry]\n Version=1.0\n Exec=/opt/telegram/Telegram\n Icon=Telegram\n Type=Application\n Categories=Application;Network;' | tee /usr/share/applications/telegram.desktop

# Habilita serviços:
systemctl enable NetworkManager
systemctl enable bluetooth.service
systemctl enable org.cups.cupsd
systemctl enable fstrim.timer

clear ; echo " " ; echo "Script finalizado. Pressione uma tecla para encerrar." ; read tecla
