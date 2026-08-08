FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

LABEL maintainer="hypnotoad08"
ARG OA_VERSION=4.8.7
ENV TITLE="OpenAudible" \
    OA_VERSION="${OA_VERSION}" \
    SELKIES_ENCODER=jpeg \
    DEBIAN_FRONTEND=noninteractive

# keep everything in a single RUN to reduce layers and ensure cleanup happens in the same layer
RUN set -eux; \
    # add OpenAudible to openbox menu
    sed -i 's|</applications>|  <application title="OpenAudible" type="normal">\n    <maximized>no</maximized>\n  </application>\n</applications>|' /etc/xdg/openbox/rc.xml; \
    echo "**** update packages ****"; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      wget \
      thunar \
      firefox-esr \
      libwebkit2gtk-4.1-0; \
    echo "**** installing OpenAudible ${OA_VERSION} ****"; \
    wget -q -O /tmp/OpenAudible_${OA_VERSION}_x86_64.sh "https://github.com/openaudible/openaudible/releases/download/v${OA_VERSION}/OpenAudible_${OA_VERSION}_x86_64.sh"; \
    chmod +x /tmp/OpenAudible_${OA_VERSION}_x86_64.sh; \
    /tmp/OpenAudible_${OA_VERSION}_x86_64.sh -q; \
    rm -f /tmp/OpenAudible_${OA_VERSION}_x86_64.sh; \
    echo "**** cleanup ****"; \
    apt-get purge -y --auto-remove; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY /root /

EXPOSE 3000 3001

VOLUME /config
