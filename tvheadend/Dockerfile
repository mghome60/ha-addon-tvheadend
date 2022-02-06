ARG BUILD_FROM=hassioaddons/debian-base:5.2.3
FROM ${BUILD_FROM}
ARG target_uid=1000
ARG debug=true

ARG BUILD_ARCH

# ARGS...

# FIX From Arg.
# env
# Allow longer shutdown
ENV S6_SERVICES_GRACETIME 119000
# Set for package install
ENV DEBIAN_FRONTEND "noninteractive" 
# FIXME? locales
#ENV LANG C.UTF-8
# TZ config at runtime
ENV DISABLE_HA_AUTHENTICATION true

#ENV DIRS /config/...
#ENV HAA_NAME ""
#ENV OPTIONS ""
#ENV USER ""
#ENV GROUP ""

COPY rootfs/ /

# General package installs
RUN apt-get update 

# HA Nginx Ingress support
RUN apt-get install -y --no-install-recommends \
        libnginx-mod-http-lua \
        luarocks \
        nginx \
    && luarocks install lua-resty-http 0.15-0 \
    && rm -r /etc/nginx

COPY rootfs-ingress/ /

# Supporting packages
RUN apt-get -y install --no-install-recommends \
	        rsync \
		git \
		nfs-common \
		bzip2 \
		tzdata 

RUN mkdir -p /sources && cd /sources && git clone -b "stable" https://github.com/deajan/osync && cd osync && bash install.sh --no-stats

# FIXME if arch arm ... hf?
#RUN echo deb [ allow-insecure=yes ] http://archive.raspberrypi.org/debian/ buster main >/etc/apt/sources.list.d/tvheadend.list
#RUN echo Package: * && echo Pin: origin archive.raspberrypi.org && echo Pin-Priority: 1 >/etc/apt/preferences.d/50archive.raspberrypi.org
RUN echo  deb http://ftp.uni-kl.de/debian-multimedia/ bullseye main non-free >/etc/apt/sources.list.d/debian-multimedia.list
#RUN echo Package: * && echo Pin: origin debian-multimedia.org && echo Pin-Priority: 1 >/etc/apt/preferences.d/50debian-multimedia.org


RUN apt-get update -oAcquire::AllowInsecureRepositories=true && apt-get --allow-unauthenticated -y install --no-install-recommends deb-multimedia-keyring
RUN  apt-get update
RUN apt-get -y install tvheadend
#RUN apt-get --allow-unauthenticated -y install --no-install-recommends tvheadend

RUN if [[ ! -z "${debug}" ]];then apt-get -y install vim less procps strace;fi

#Cleanup
RUN if [ -z "${debug}" -o "${debug}" = "false" ];then apt-get -y remove \
           git \
           wget && \
	apt-get clean -y && \
	apt-get -y autoremove && \
        rm -r /sources ;fi

VOLUME /data
VOLUME /share
VOLUME /backup
VOLUME /config
VOLUME /ssl
VOLUME /tmpfs

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="tvheadend" \
    io.hass.description="TV streaming server and digital video recorder." \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Phillip Camp <phillip.camp+ha<removeme>@gmail.com>" \
    org.label-schema.description="TV streaming server and digital video recorder." \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="tvheadend" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.usage="https://github.com/pssc/ha-addon-tvheadend/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/pssc/ha-addon-tvheadend" \
    org.label-schema.vendor="pssc"
#    org.label-schema.url="https://community.home-assistant.io/t/home-assistant-community-add-on-portainer/68836?u=frenck" \
