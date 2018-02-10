FROM ocaml/opam:debian-9_ocaml-4.05.0

USER root
RUN apt update && \
    apt install -y git autoconf wget --no-install-recommends && \
    apt clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

ENV USER opam
USER $USER
ENV SATYSFI_LIB_ROOT /home/$USER/.opam/4.05.0/lib-satysfi
RUN mkdir -p $SATYSFI_LIB_ROOT/dist/fonts && \
    wget https://dl.dafont.com/dl/?f=coolvetica -O /tmp/coolvetica.zip && \
    unzip -d /tmp /tmp/coolvetica.zip && \
    mv "/tmp/coolvetica rg.ttf" $SATYSFI_LIB_ROOT/dist/fonts/coolvetica.ttf && \
    wget https://github.com/google/fonts/raw/master/ofl/crimsontext/CrimsonText-Regular.ttf -P $SATYSFI_LIB_ROOT/dist/fonts && \
    wget https://github.com/google/fonts/raw/master/ofl/crimsontext/CrimsonText-Italic.ttf -P $SATYSFI_LIB_ROOT/dist/fonts && \
    wget https://oscdl.ipa.go.jp/IPAexfont/IPAexfont00301.zip -P /tmp && \
    unzip -d /tmp /tmp/IPAexfont00301.zip && \
    mv /tmp/IPAexfont00301/ipaexg.ttf /tmp/IPAexfont00301/ipaexm.ttf $SATYSFI_LIB_ROOT/dist/fonts
    
RUN git clone https://github.com/pandaman64/SATySFi /home/opam/SATySFi -b use-free-font

WORKDIR /home/opam/SATySFi

RUN git submodule update -i && \
    opam pin add -y satysfi .
