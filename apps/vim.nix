with import <nixpkgs> {};

vim-full.customize {
    # Specifies the vim binary name.
    # E.g. set this to "my-vim" and you need to type "my-vim" to open this vim
    # This allows to have multiple vim packages installed (e.g. with a different set of plugins)
    name = "vim";
    vimrcConfig.customRC = ''
        set tabstop=4
        set shiftwidth=4
        syntax enable
    '';
}
