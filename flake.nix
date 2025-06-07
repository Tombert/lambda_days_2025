{
    description = "Presentation for Lambda Days.";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        flake-utils.url = "github:numtide/flake-utils";
    };

    outputs = { self, nixpkgs, flake-utils}: 
        with flake-utils.lib; eachSystem allSystems (system:
            let
                pkgs = import nixpkgs {
                    inherit system;
                };
            in rec
                { 
                    devShell = pkgs.mkShell {
                        buildInputs = [
                            pkgs.texlive.combined.scheme-full pkgs.pandoc
                        ];
                    };

                    defaultPackage = pkgs.stdenv.mkDerivation rec {
                                name = "Presentation Build";
                                src = self; 
                                phases = ["unpackPhase" "buildPhase" "installPhase"];
                                preBuild = ''
                                    echo "Current directory:"
                                    pwd
                                    echo "Listing files:"
                                    ls
                                    exit 64
                                '';
                                buildInputs = [
                                    pkgs.texlive.combined.scheme-full pkgs.pandoc
                                ];

                                buildPhase = ''


					pandoc -t beamer --highlight-style=breezeDark -V classoption=handout -V theme:Warsaw ./presentation.md -o slides_no_pause.pdf
					pandoc -t beamer --highlight-style=breezeDark -V theme:Warsaw ./presentation.md -o slides.pdf 
                                '';

                                installPhase = ''
                                    mkdir -p $out
                                    cp slides.pdf $out
                                    cp slides_no_pause.pdf $out
                                '';
                     };
         });
}
