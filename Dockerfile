FROM kalilinux/kali-rolling:latest AS core

LABEL website="https://github.com/andreaswachs/kali-docker"
LABEL description="Kali Linux with XFCE Desktop via VNC and noVNC in browser."

# Install kali packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get -y install tightvncserver dbus dbus-x11 novnc net-tools

FROM core AS base

# Install kali desktop
ARG KALI_DESKTOP=xfce
RUN apt-get -y install kali-desktop-${KALI_DESKTOP}

FROM base AS desktop

ARG KALI_METAPACKAGE=core
# This decides which version of the container is installed
RUN [ "${KALI_METAPACKAGE}" != "top10"] && apt-get -y install kali-linux-${KALI_METAPACKAGE} || apt-get -y install kali-tools-top10
RUN apt-get clean

ENV USER root
ENV VNCEXPOSE 0
ENV VNCPORT 5900
ENV VNCPWD changeme
ENV VNCDISPLAY 1920x1080
ENV VNCDEPTH 16
ENV NOVNCPORT 8080

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD [ "/entrypoint.sh" ]
