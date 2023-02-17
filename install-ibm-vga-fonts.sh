#https://int10h.org/oldschool-pc-fonts/download/

#We don't need the Ac fonts. Mx (ttf + bitmap) work very well so far.

cd ~/Downloads
mkdir oldschool-pc-font-pack
cd oldschool-pc-font-pack
wget https://int10h.org/oldschool-pc-fonts/download/oldschool_pc_font_pack_v2.2_linux.zip
unzip oldschool_pc_font_pack_v2.2_linux.zip
cp "ttf - Mx (mixed outline+bitmap)/Mx437_IBM_VGA_9x16.ttf" ~/.local/share/fonts/
