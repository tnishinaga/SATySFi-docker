FROM ocaml/opam:debian-9_ocaml-4.06.0

USER root
RUN apt update && \
    apt install -y build-essential autoconf git m4 unzip wget ca-cacert ca-certificates --no-install-recommends && \
    apt clean 

USER opam

WORKDIR /home/opam/opam-repository
RUN git pull && eval `opam config env` && opam update

# current upstream of these libraries are broken.
# see https://github.com/gfngfn/SATySFi/issues/46
RUN opam pin add -y jbuilder 1.0+beta17 && opam pin add -y camlimages 4.2.6

RUN mkdir -p /home/opam/.satysfi/dist/fonts && \
    wget http://mirrors.ctan.org/fonts/junicode/fonts/Junicode.ttf -P /home/opam/.satysfi/dist/fonts && \
    wget http://mirrors.ctan.org/fonts/junicode/fonts/Junicode-Italic.ttf -P /home/opam/.satysfi/dist/fonts && \
    wget https://oscdl.ipa.go.jp/IPAexfont/IPAexfont00301.zip -P /tmp && \
    unzip -d /tmp /tmp/IPAexfont00301.zip && \
    mv /tmp/IPAexfont00301/ipaexg.ttf /tmp/IPAexfont00301/ipaexm.ttf /home/opam/.satysfi/dist/fonts
    
RUN git clone https://github.com/gfngfn/SATySFi /home/opam/SATySFi

WORKDIR /home/opam/SATySFi

RUN git submodule update --init --recursive && \
    opam pin add -y satysfi .
