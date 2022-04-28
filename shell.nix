with import <nixpkgs> {};
ruby.withPackages (ps: with ps; [ rake buildar flog flay roodi ])
