ARG FROM=ubuntu:latest

FROM ${FROM}

RUN apt-get update && apt-get install -y \
    curl\
    debootstrap \
    grub-efi-amd64-bin \
    grub-pc-bin \
    mtools \
    squashfs-tools \
    xorriso \
    && rm -rf /var/lib/apt/lists/*

COPY files/ /builder/

RUN curl -L https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_amd64 -o /bin/yq \
    && chmod +x /bin/yq

CMD /bin/bash /builder/build.sh
