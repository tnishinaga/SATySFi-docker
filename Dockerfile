FROM ocaml/opam2:debian-9-ocaml-4.07

USER root
RUN apt update && \
    apt install -y build-essential autoconf git m4 unzip wget ca-cacert ca-certificates ruby --no-install-recommends && \
    apt clean 

USER opam

WORKDIR /home/opam/opam-repository
RUN git pull && eval `opam config env` && opam repository add satysfi-external https://github.com/gfngfn/satysfi-external-repo.git && opam update


RUN git clone https://github.com/gfngfn/SATySFi /home/opam/SATySFi

WORKDIR /home/opam/SATySFi

RUN opam pin add -y satysfi .

RUN ./download-fonts.sh

USER root
RUN ./install-libs.sh

USER opam
