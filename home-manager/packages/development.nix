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

    (pkgs.buildFHSEnv {
      name = "alr";
      targetPkgs = pkgs: with pkgs; [
        alire
        git
        gnumake
        pkg-config
        binutils
        gcc
        stdenv.cc.cc.lib
        glibc
        glibc.dev
        gmp
        gmp.dev
        zstd
        openssl
        openssl.dev
        zlib
        zlib.dev
        ncurses
      ];
      runScript = "alr";
    })

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

    # OCaml
    ocaml
    ocamlformat
    dune
    opam

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
    #sqlx-cli
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
