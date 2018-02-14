FROM ocaml/opam:debian-9_ocaml-4.05.0

USER root
RUN apt update && \
    apt install -y build-essential autoconf git m4 unzip wget ca-cacert ca-certificates --no-install-recommends && \
    apt clean 

USER opam

WORKDIR /home/opam/opam-repository
RUN git pull && opam update

RUN mkdir -p ~/.satysfi/dist/fonts && \
    wget https://github.com/google/fonts/raw/master/apache/opensans/OpenSans-Regular.ttf -P ~/.satysfi/dist/fonts && \
    wget https://github.com/google/fonts/raw/master/ofl/crimsontext/CrimsonText-Regular.ttf -P ~/.satysfi/dist/fonts && \
    wget https://github.com/google/fonts/raw/master/ofl/crimsontext/CrimsonText-Italic.ttf -P ~/.satysfi/dist/fonts && \
    wget https://oscdl.ipa.go.jp/IPAexfont/IPAexfont00301.zip -P /tmp && \
    unzip -d /tmp /tmp/IPAexfont00301.zip && \
    mv /tmp/IPAexfont00301/ipaexg.ttf /tmp/IPAexfont00301/ipaexm.ttf ~/.satysfi/dist/fonts
    
RUN git clone https://github.com/pandaman64/SATySFi /home/opam/SATySFi -b use-free-font

WORKDIR /home/opam/SATySFi

RUN git submodule update --init --recursive && \
    opam pin add -y satysfi . && \
    opam install satysfi
