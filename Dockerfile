FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntunoble

LABEL maintainer="hypnotoad08"
ENV TITLE=OpenAudible
ENV OA_VERSION=4.6.1

RUN \
  sed -i 's|</applications>|  <application title="OpenAudible" type="normal">\n    <maximized>no</maximized>\n  </application>\n</applications>|' /etc/xdg/openbox/rc.xml && \
  echo "**** update packages ****" && \
    apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install software-properties-common -y && \
    apt-get install -y ca-certificates && \
    apt-get install -y libswt-webkit-gtk-4-jni && \
    apt-get install -y --no-install-recommends \
      wget \
      thunar && \
  echo "**** installing OpenAudible ****" && \
    wget -q https://github.com/openaudible/openaudible/releases/download/v${OA_VERSION}/OpenAudible_${OA_VERSION}_x86_64.sh && \
    sh ./OpenAudible_${OA_VERSION}_x86_64.sh -q && \
    rm OpenAudible_${OA_VERSION}_x86_64.sh && \
  echo "**** cleanup ****" && \
    rm -rf \
      /tmp/* \
      /var/lib/apt/lists/* \
      /var/tmp/*

COPY /root /

EXPOSE 3000 3001

VOLUME /config
