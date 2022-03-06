#!/bin/bash


# Check if this package has been run before - in progress
function check_if_first_run() {
  flag="~/flag.txt"

  if [[ flag ]]
  then
    echo "Only installing new packages."
    check_installed_packages
    install_needed_packages
    xargs -a install_packages.txt sudo apt install -y

    rm ~/installed_packages.txt
    rm ~/installed.txt

  fi
}

# Check for existing packages on system to see what needs to be installed.
function check_installed_packages() {
  file1="~/installed_packages.txt"
  file2="~/installed.txt"
  apt list --installed >> $file1
  sed -i '/Listing.../d' ./$file1
  awk -F '/' '{print $1}' $file1 > $file2
  rm $file1
}

function install_needed_packages() {
  filename="~/installed.txt"
  packages="kali-packages-list.txt"

  grep -f "$filename" -vFx "$packages" >> ~/install_packages.txt
}


function install_programs() {
  cd ~/
  # Update and Upgrade system.
  echo "Running a full system upgrade"
  sudo apt update && sudo apt upgrade -y

  # Installing requested packages
  echo "Installing requested packages from the install_packages.txt file."
  sleep 10
  xargs -a install_packages.txt sudo apt install -y
  echo "Finished installing required packages"
  sleep 10

  # Download and install oh-my-zsh.
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "Now Installing Sublime Text Editor"

  # Add sublime text repo and install Sublime Text.
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - # Add sublime text repo key
  sudo apt install apt-transport-https
  echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list  # Add sublime text repo
  sudo apt update && sudo apt install sublime-text -y

  # Install bpytop
  echo "Installing bpytop python package"
  sudo python3.9 -m pip install bpytop --upgrade

  # Install Kite AI for coding
  echo "Installing Kite AI plugin"
  bash -c "$(wget -q -O - https://linux.kite.com/dls/linux/current)"
}

function install_pentest_tools() {
	# Install CrackMapExec.
	sudo python3.9 -m pip install pipx
	sudo python3.9 -m pipx ensurepath
	sudo python3.9 -m pipx install crackmapexec

	# Make pentest directory and download tools from GitHub.
	mkdir ~/pentest
	cd ~/pentest
	wget https://gist.github.com/HarmJ0y/184f9822b195c52dd50c379ed3117993/raw/e5e30c942adb2347917563ef0dafa7054882535a/PowerView-3.0-tricks.ps1
	git clone https://github.com/SecureAuthCorp/impacket.git && cd impacket
	python3.9 -m pip install -r requirements.txt
	sudo python3.9 ./setup.sh install
	cd ..
	git clone https://github.com/CiscoCXSecurity/enum4linux.git
  git clone https://github.com/payloadbox/command-injection-payload-list.git
	git clone https://github.com/Gr1mmie/Practical-Ethical-Hacking-Resources.git
  git clone https://github.com/aboul3la/Sublist3r.git
	git clone https://github.com/rebootuser/LinEnum.git
	git clone https://github.com/AonCyberLabs/Windows-Exploit-Suggester.git
	git clone https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite.git
	git clone https://github.com/ArmisSecurity/urgent11-detector.git
	git clone https://github.com/m0nad/Diamorphine.git
	git clone https://github.com/nopernik/SSHPry2.0.git
	git clone https://github.com/skeeto/endlessh.git
	git clone https://github.com/JohnTroony/php-webshells.git
	git clone https://github.com/kgretzky/evilginx2.git
	git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git
	git clone https://github.com/411Hall/JAWS.git
	git clone https://github.com/PowerShellMafia/PowerSploit.git
	git clone https://github.com/rasta-mouse/Watson.git
	git clone https://github.com/rasta-mouse/Sherlock.git
	git clone https://github.com/internetwache/GitTools.git
	git clone https://github.com/gentilkiwi/mimikatz.git
	git clone https://github.com/BloodHoundAD/BloodHound.git
	git clone https://github.com/stufus/egresscheck-framework.git
	git clone https://github.com/TryCatchHCF/PacketWhisper.git
	git clone https://github.com/r3motecontrol/Ghostpack-CompiledBinaries.git
	git clone https://github.com/tegal1337/CiLocks.git
	git clone https://github.com/michaelpoznecki/zerologon.git
	cd zerologon && cp nrpc.py ~/pentest/impacket/impacket/dcerpc/v5/nrpc.py
	cd ..
	git clone https://github.com/epinna/tplmap.git
	git clone https://github.com/ict/creddump7.git
	git clone https://github.com/IvanGlinkin/AutoSUID.git
	git clone https://github.com/Neo23x0/Loki.git
	python3 -m pip install -r ~/pentest/Loki/requirements.txt
	git clone https://github.com/Neo23x0/Fenrir.git
	python3 -m pip install -r ~/pentest/Fenrir/requirements.txt
	git clone https://github.com/Neo23x0/yarGen.git
	python3 -m pip install -r ~/pentest/yarGen/requirements.txt
	git clone https://github.com/InQuest/awesome-yara.git
	python3 -m pip install -r ~/pentest/awesome-yara/requirements.txt

  # Download Complete Seclists Wordlists.
  cd /usr/share/wordlists
  sudo git clone https://github.com/danielmiessler/SecLists.git

  cd ~/pentest
	# Install evil-winrm
	sudo gem install evil-winrm


}


function config_system() {
  # Set Python3.9 as default
  echo "Setting Python3.9 as default"
  sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.9 2

  # Set up Vundle for VIM
  echo "Setting up VIM plugins"
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  vim +PluginInstall +qall

  # Customize zsh
  echo "Now customizing zsh install"
  git clone https://github.com/powerline/fonts.git # Meslo LG DZ for Powerline font
  cd fonts
  ./install.sh # Install fonts
  cd ~/
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting # Install syntax highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions # Install autosuggestions
  git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions # Install Additional completion definitions for zsh
  git clone https://github.com/zsh-users/zsh-history-substring-search ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search # Install implementation of the Fish shell's history search feature

  # Setup git identity
  git config --global user.email "tylermhiggins@outlook.com"
  git config --global user.name "Tyler Higgins"

  gitlab_ssh_check
}

function gitlab_ssh_check() {
  # Checking gitlab ssh connection
  echo "Have you added the current ssh key to gitlab y/n: "
  read response
  if [ $response == 'y' ] || [ $response == 'Y' ]
  then
    echo "Testing ssh connection..."
    ssh -T git@gitlab.com

    echo "Did you get a message with your username after the connection test? y/n"
    read check
    if [ $check == 'y' ] || [ $check == 'Y' ]
    then
      echo "Now pulling down dotfiles."
      git clone git@gitlab.com:Ic3M2n-Tech/dotfiles.git
      cd dotfiles
      ./.make.sh
      cd ~/

      # Pull down TryHackMe repo
      echo "Now pulling down TryHackMe Room Repo."
      cd ~/Documents
      git clone git@gitlab.com:Ic3M2n-Tech/tryhackme.git
    else
      exit 0
    fi
  else
    exit 0
  fi
}



# Running package check and compairing installed packages to the packages currently installed on the system.
 echo "Now checking for the packages installed on this system and compairing them to the packages you want to install."
 check_installed_packages
 install_needed_packages

# Installing packages and pulling dotfiles from gitlab
 install_programs
 config_system

# Install tools for pentesting
 install_pentest_tools

 echo "Final System Update and Upgrade with autoremove"
 sleep 15
 cd ~
 sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

 mkdir ~/.config/terminator
 cp ~/setup-scripts/config ~/.config/terminator/

# check_if_first_run
