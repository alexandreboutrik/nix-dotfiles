{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    # Toolchain & VCS
    git
    gh
    gnumake
    cmake
    ninja
    pkg-config
    man-pages
    tree-sitter

    # C / C++
    glibc.static
    llvm
    clang
    clang-tools

    # Rust
    cargo
    rustc
    rust-analyzer

    # Zig
    zig
    zls

    # Haskell
    ghc
    cabal-install
    haskell-language-server
    hlint

    # JVM
    jdk
    jdt-language-server
    maven
    scala

    # Go
    gopls

    # Python
    python3
    pyright

    # Lua
    lua

    # Web (Node, TS, JS Frameworks)
    nodejs_24
    yarn
    typescript
    typescript-language-server
    vue-language-server
    svelte-language-server

    # Misc Tools
    sqlx-cli
    shfmt
    android-tools
    # android-studio 
    # gradle
  ];

  programs = {
    go = {
      enable = true;
      env = {
        GOBIN = "${config.home.homeDirectory}/.go/bin";
        GOPATH = "${config.home.homeDirectory}/.go";
      };
    };
  };
}
