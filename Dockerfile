FROM ocaml/opam:debian-9-ocaml-4.07

USER root
RUN apt update && \
    apt install -y build-essential autoconf git m4 unzip wget ca-cacert ca-certificates ruby --no-install-recommends && \
    apt clean 

USER opam

WORKDIR /home/opam/opam-repository
RUN git pull && eval `opam config env` && opam repository add satysfi-external https://github.com/gfngfn/satysfi-external-repo.git && opam update

RUN mkdir -p /home/opam/.satysfi/dist/fonts && \
    wget http://mirrors.ctan.org/fonts/junicode/fonts/Junicode.ttf -P /home/opam/.satysfi/dist/fonts && \
    wget http://mirrors.ctan.org/fonts/junicode/fonts/Junicode-Italic.ttf -P /home/opam/.satysfi/dist/fonts && \
    wget https://oscdl.ipa.go.jp/IPAexfont/IPAexfont00301.zip -P /tmp && \
    unzip -d /tmp /tmp/IPAexfont00301.zip && \
    mv /tmp/IPAexfont00301/ipaexg.ttf /tmp/IPAexfont00301/ipaexm.ttf /home/opam/.satysfi/dist/fonts

RUN git clone https://github.com/gfngfn/SATySFi /home/opam/SATySFi

WORKDIR /home/opam/SATySFi

RUN opam pin add -y satysfi .

# workaround for https://github.com/gfngfn/SATySFi/issues/38
RUN cp -r /home/opam/.opam/4.07/share/satysfi/dist/ ~/.satysfi/
