#!/usr/bin/env bash

show_msg () {
    echo -e '\e[32m'$1'\e[0m'
}

install_update(){
		sudo apt -y update && sudo apt -y upgrade
		sudo apt install -y net-tools htop python3-pip p7zip-full unzip tcpdump tor git jq wget curl awscli openssl cmake g++
}

install_zsh(){
		# Trap SIGINT so broken sqlmap runs can be cancelled
		trap cancel SIGINT

		echo -e "$GREEN""\n[+] install zsh. \n""$RESET"
		sudo apt install -y zsh
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
		git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
		git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
		autoload -U compinit && compinit
}

install_fonts(){
		show_msg "\nInstall Fonts"

		sudo apt install -y fonts-firacode fonts-powerline fonts-font-awesome fonts-roboto
		[[ -d ~/.local/share/fonts ]] || mkdir -p ~/.local/share/fonts

		curl -sLko ~/.local/share/fonts/"MesloLGS NF Regular.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
		curl -sLko ~/.local/share/fonts/"MesloLGS NF Bold.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
		curl -sLko ~/.local/share/fonts/"MesloLGS NF Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
		curl -sLko ~/.local/share/fonts/"MesloLGS NF Bold Italic.ttf" "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
		curl -sLko ~/.local/share/fonts/"Fura Mono Regular Nerd Font Complete.otf" "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraMono/Regular/complete/Fura%20Mono%20Regular%20Nerd%20Font%20Complete.otf"
		curl -sLko CascadiaCode.zip "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/CascadiaCode.zip"
		unzip CascadiaCode.zip -d ~/.local/share/fonts
		rm CascadiaCode.zip

		curl -s https://api.github.com/repos/source-foundry/Hack/releases/latest | grep -E 'browser_download_url' | grep -E 'ttf.tar.gz' | cut -d '"' -f 4 | wget -qi -
		tar -xzf Hack*ttf.tar.gz -C ~/.local/share/fonts/ --strip-components=1
		rm Hack*ttf.tar.gz
}

install_lsd(){
		mkdir -p "$HOME"/tools/lsd && cd "$HOME"/tools/lsd
		curl -s https://api.github.com/repos/Peltoche/lsd/releases/latest | grep -E 'browser_download_url' | grep -E 'x86_64-unknown-linux-gnu.tar.gz' | cut -d '"' -f 4 | wget -qi -
		tar -xzf lsd*x86_64-unknown-linux-gnu.tar.gz --strip-components=1
		sudo mv lsd /usr/local/bin/
		cd - && rm -rf "$HOME"/tools/lsd
}

install_bat(){
		mkdir -p "$HOME"/tools/bat && cd "$HOME"/tools/bat
		curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | grep -E 'browser_download_url' | grep -E 'x86_64-unknown-linux-gnu.tar.gz' | cut -d '"' -f 4 | wget -qi -
		tar -xzf bat*x86_64-unknown-linux-gnu.tar.gz --strip-components=1
		sudo mv bat /usr/local/bin/
		cd - && rm -rf "$HOME"/tools/bat
}

install_fzf(){
		mkdir -p "$HOME"/tools/fzf && cd "$HOME"/tools/fzf
		curl -s https://api.github.com/repos/junegunn/fzf/releases/latest | grep -E 'browser_download_url' | grep -E 'linux_amd64.tar.gz' | cut -d '"' -f 4 | wget -qi -
		tar -xzf fzf*linux_amd64.tar.gz
		sudo mv fzf /usr/local/bin/
		cd - && rm -rf "$HOME"/tools/fzf
}

install_fd(){
		mkdir -p "$HOME"/tools/fd && cd "$HOME"/tools/fd
		curl -s https://api.github.com/repos/sharkdp/fd/releases/latest | grep -E 'browser_download_url' | grep -E 'x86_64-unknown-linux-gnu.tar.gz' | cut -d '"' -f 4 | wget -qi -
		tar -xzf fd*x86_64-unknown-linux-gnu.tar.gz --strip-components=1
		sudo mv fd /usr/local/bin/
		cd - && rm -rf "$HOME"/tools/fd
}

link_my_rc(){
		# zsh
		if [[ -L "$HOME"/.zshrc ]] ; then
			show_msg "\nzshrc already linked" 
		else
            show_msg "\nLinking zshrc"
			mv -f "$HOME"/.zshrc "$HOME"/.zshrc-old
			ln -sfv "$HOME"/dotfiles/.zshrc "$HOME"/.zshrc
		fi

		# p10k
		if [[ -L "$HOME"/.p10k.zsh ]] ; then
			show_msg "\np10k.zsh already linked" 
		else
            show_msg "\nLinking p10k.zsh"
			mv -f "$HOME"/.p10k.zsh "$HOME"/.p10k.zsh-old
			ln -sfv "$HOME"/dotfiles/.p10k.zsh "$HOME"/.p10k.zsh
		fi

		## .fzf.zsh //Not Needed aleady sourced in zshrc file
		#if [[ -L "$HOME"/.fzf.zsh ]] ; then
		#	show_msg "\nfzf.zsh already linked" 
		#else
        #    show_msg "\nLinking fzf.zsh"
		#	mv -f "$HOME"/.fzf.zsh "$HOME"/.fzf.zsh-old
		#	ln -sfv "$HOME"/dotfiles/.fzf.zsh "$HOME"/.fzf.zsh
		#fi

		# .fzf.bash //Not Needed aleady sourced in zshrc file
		#if [[ -L "$HOME"/.fzf.bash ]] ; then
		#	show_msg "\nfzf.bash already linked" 
		#else
        #    show_msg "\nLinking fzf.bash"
		#	mv -f "$HOME"/.fzf.bash "$HOME"/.fzf.bash-old
		#	ln -sfv "$HOME"/dotfiles/.fzf.bash "$HOME"/.fzf.bash
		#fi

		if [[ -L "$HOME"/.config/htop/htoprc ]] ; then
			show_msg "\nhtoprc already linked" 
		else
            show_msg "\nLinking htoprc"
			mv -f "$HOME"/.config/htop/htoprc "$HOME"/.config/htop/htoprc-old
			ln -sfv "$HOME"/dotfiles/.config/htop/htoprc "$HOME"/.config/htop/htoprc
		fi

		if [[ -L "$HOME"/.config/parcellite/parcelliterc ]] ; then
			show_msg "\nparcelliterc already linked" 
		else
            show_msg "\nLinking parcelliterc"
			mv -f "$HOME"/.config/parcellite/parcelliterc "$HOME"/.config/parcellite/parcelliterc-old
			ln -sfv "$HOME"/dotfiles/.config/parcellite/parcelliterc "$HOME"/.config/parcellite/parcelliterc
		fi

		# KDE shortcut
		if [[ -L "$HOME"/.config/kglobalshortcutsrc ]] ; then
			show_msg "\nconfig/kglobalshortcutsrc already linked" 
		else
            show_msg "\nLinking config/kglobalshortcutsrc"
			mv -f "$HOME"/.config/kglobalshortcutsrc "$HOME"/.config/kglobalshortcutsrc-old
			ln -sfv "$HOME"/dotfiles/.config/kglobalshortcutsrc "$HOME"/.config/kglobalshortcutsrc
		fi

		# Dolphin
		if [[ -L "$HOME"/.config/dolphinrc ]] ; then
			show_msg "\nconfig/dolphinrc already linked" 
		else
            show_msg "\nLinking config/dolphinrc"
			mv -f "$HOME"/.config/dolphinrc "$HOME"/.config/dolphinrc-old
			ln -sfv "$HOME"/dotfiles/.config/dolphinrc "$HOME"/.config/dolphinrc
		fi

		# terminator
		if [[ -L "$HOME"/.config/terminator ]] ; then
			show_msg "\nconfig/terminator already linked" 
		else
            show_msg "\nLinking config/terminator"
			mv -f "$HOME"/.config/terminator "$HOME"/.config/terminator-old
			ln -sfv "$HOME"/dotfiles/.config/terminator "$HOME"/.config/terminator
		fi

		# flameshot
		if [[ -L "$HOME"/.config/Dharkael/flameshot.ini ]] ; then
			show_msg "\nconfig/Dharkael/flameshot.ini already linked" 
		else
            show_msg "\nLinking config/Dharkael/flameshot.ini"
			mv -f "$HOME"/.config/Dharkael/flameshot.ini "$HOME"/.config/Dharkael/flameshot.ini-old
			ln -sfv "$HOME"/dotfiles/.config/Dharkael/flameshot.ini "$HOME"/.config/Dharkael/flameshot.ini
		fi
}

                read -p "install All (y/n)?" choice
				case "$choice" in
				y|Y ) install_update ; install_zsh ; install_fonts ; install_lsd ; install_bat ; install_fzf ; install_fd ; link_my_rc ;;
				n|N ) show_msg "\nSkipped install All !";;
				esac

				read -p "Update (y/n)?" choice
				case "$choice" in
				y|Y ) install_update;;
				n|N ) show_msg "\nSkipped Update !";;
				esac

                read -p "install ZSH (y/n)?" choice
				case "$choice" in
				y|Y ) install_zsh;;
				n|N ) show_msg "\nSkipped ZSH !";;
				esac

                read -p "install Fonts (y/n)?" choice
				case "$choice" in
				y|Y ) install_fonts;;
				n|N ) show_msg "\nSkipped Fonts !";;
				esac

                read -p "install LSD (y/n)?" choice
				case "$choice" in
				y|Y ) install_lsd;;
				n|N ) show_msg "\nSkipped LSD !";;
				esac

                read -p "install BAT (y/n)?" choice
				case "$choice" in
				y|Y ) install_bat;;
				n|N ) show_msg "\nSkipped BAT !";;
				esac

                read -p "install FZF (y/n)?" choice
				case "$choice" in
				y|Y ) install_fzf;;
				n|N ) show_msg "\nSkipped FZF !";;
				esac

                read -p "install FD (y/n)?" choice
				case "$choice" in
				y|Y ) install_fd;;
				n|N ) show_msg "\nSkipped FD !";;
				esac

                read -p "Link my rc files (y/n)?" choice
				case "$choice" in
				y|Y ) link_my_rc;;
				n|N ) show_msg "\nSkipped Link my rc files !";;
				esac