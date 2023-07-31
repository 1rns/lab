{ stdenv, gcc, SDL2, ... }:

stdenv.mkDerivation rec {
  name = "SDL_bgi";
  version = "3.0.0";

  src = builtins.fetchTarball {
    url = "https://versaweb.dl.sourceforge.net/project/sdl-bgi/${name}-${version}.tar.gz";
    sha256 = "sha256:04ybrz38nq30nh3iyviq1jad8kq8512q2hmxmvrvxc5zy9i0xgad";
  };

  buildInputs = [ gcc SDL2 SDL2.dev ];

  buildPhase = ''
    cd src
    make
  '';

  installPhase = ''
    mkdir -p $out/usr/lib $out/usr/include/SDL2 $out/usr/share/man/man3
  	install -m 755 lib${name}.so $out/usr/lib/
  	install -m 644 SDL_bgi.h $out/usr/include/SDL2/
  	install graphics.h $out/usr/include
  	install ../doc/graphics.3.gz $out/usr/share/man/man3/
  '';
}
