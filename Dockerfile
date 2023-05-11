FROM ubuntu:jammy

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL zh_CN.UTF-8
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN.UTF-8

RUN apt-get update && apt-get install -y ca-certificates && \
    sed -i "s/http:\/\/archive.ubuntu.com/https:\/\/mirrors.ustc.edu.cn/g" /etc/apt/sources.list && \
    sed -i "s/http:\/\/security.ubuntu.com/https:\/\/mirrors.ustc.edu.cn/g" /etc/apt/sources.list && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y fonts-dejavu-core fonts-freefont-ttf fonts-indic fonts-kacst-one fonts-khmeros-core fonts-lao fonts-liberation fonts-liberation2 fonts-lklug-sinhala fonts-noto-cjk fonts-noto-color-emoji fonts-opensymbol fonts-sil-abyssinica fonts-sil-padauk fonts-thai-tlwg fonts-tibetan-machine fonts-ubuntu xfonts-intl-chinese language-selector-common locales && \
    apt-get -y install python2 xvfb x11vnc xdotool wget curl tar supervisor net-tools fluxbox gnupg2 xz-utils && \
    wget -O - https://dl.winehq.org/wine-builds/winehq.key | apt-key add -  && \
    echo 'deb https://dl.winehq.org/wine-builds/ubuntu/ jammy main' |tee /etc/apt/sources.list.d/winehq.list && \
    apt-get update && apt-get -y install winehq-stable && \
    mkdir /opt/wine-stable/share/wine/mono && curl https://dl.winehq.org/wine/wine-mono/7.4.0/wine-mono-7.4.0-x86.tar.xz -o /tmp/mono.tar.xz && tar -xJvf /tmp/mono.tar.xz -C /opt/wine-stable/share/wine/mono && rm -f /tmp/mono.tar.xz &&\
    mkdir /opt/wine-stable/share/wine/gecko && \
    curl -o /opt/wine-stable/share/wine/gecko/wine-gecko-2.47.4-x86.msi https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86.msi && curl -o /opt/wine-stable/share/wine/gecko/wine-gecko-2.47.4-x86_64.msi https://dl.winehq.org/wine/wine-gecko/2.47.4/wine-gecko-2.47.4-x86_64.msi && \
    apt-get -y full-upgrade && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /root/

RUN wget -O - https://github.com/novnc/noVNC/archive/v1.4.0.tar.gz | tar -xzv -C /opt/ && mv /opt/noVNC-1.4.0 /opt/novnc && ln -s /opt/novnc/vnc_lite.html /opt/novnc/index.html && \
    wget -O - https://github.com/novnc/websockify/archive/v0.11.0.tar.gz | tar -xzv -C /opt/ && mv /opt/websockify-0.11.0 /opt/novnc/utils/websockify

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV WINEPREFIX /root/wine32
ENV WINEARCH win32
ENV DISPLAY :0
ENV SCREEN_RESOLUTION 1440x900x24

EXPOSE 8080

CMD ["/usr/bin/supervisord"]

