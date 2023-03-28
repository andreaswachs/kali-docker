FROM kalilinux/kali-rolling:latest

LABEL website="https://github.com/andreaswachs/kali-docker"
LABEL description="Kali Linux with XFCE Desktop via VNC and noVNC in browser."

# Install kali packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get -y install nano

RUN apt-get -y install tightvncserver dbus dbus-x11 novnc net-tools

# Install kali desktop
ARG KALI_DESKTOP=xfce
RUN apt-get -y install kali-desktop-${KALI_DESKTOP}

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

# Ensure the launch file exists
COPY launch.bin /launch.bin
RUN cat /launch.bin | base64 --decode > /usr/share/novnc/utils/launch.sh 
RUN chmod +x /usr/share/novnc/utils/launch.sh

# Entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
