dotfiles
========

My original dotfiles repo was pushed 7 years ago when I was running Arch Linux on an old 2013 Macbook. Since then, I had a long period of time where I was not doing any coding or development and have been using Windows.

Recently, I've had the opportunity to start coding again, and have been exploring the Windows Subsystem for Linux (WSL).

Specifically, my current setup uses Windows 10 with Arch Linux installed the under WSL [unoffical](https://github.com/yuk7/ArchWSL) running on Microsoft's [new open-source terminal](https://github.com/microsoft/terminal).

I set it up following along the instructions at [Hannu Hatikainen's blog](https://hannuhartikainen.fi/blog/arch-wsl/) steps 2-6. As `aurman` is no longer supported, I installed the `yay` aur helper, and I chose to make my default set up run `tmux` `vim` and `fish` shell. I'm using the plugin helpers `plug-vim`, `tpm` and `fisher` as these are the most straightforward plain-text options.

## Instructions:

Make sure `bashrc` is configured to `exec fish` at the top and that `fish` is installed
```bash
# Install Fisher
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
# Copy the fishfile to the config
cp dotfiles/fishfile ~/.config/fish/fishfile
# Load the plugins
fisher
```

```bash
# Install tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Soft link the tmux config
ln -s dotfiles/tmux.conf ~/.tmux.conf
```

```bash
# Install plug-vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \ 
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Soft link vimrc
ln -s dotfiles/vimrc ~/.vimrc
```

