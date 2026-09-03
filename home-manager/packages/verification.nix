{ pkgs, ... }: {
  home.packages = with pkgs; [
    # SMT
    why3
    alt-ergo
    z3
    cvc5

    # C
    frama-c
    compcert

    # Jasmin
    jasmin-compiler
    easycrypt
  ];
}
