FROM debian:latest
MAINTAINER James Swineson "jamesswineson@gmail.com"

RUN dpkg --add-architecture i386 \
 	&&apt-get update -y && apt-get install -y \
		lib32gcc1 \
		lib32stdc++6 \
		libcurl4-gnutls-dev:i386 \
		wget \
		tar \
 	&& apt-get clean \
 	&& rm -rf /var/lib/apt/lists/*
	 
RUN mkdir -p /usr/local/src/steamcmd \
	&& wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz -O /tmp/steamcmd.tar.gz \
	&& tar -xvzf /tmp/steamcmd.tar.gz -C /usr/local/src/steamcmd
	
RUN mkdir -p /usr/local/src/dst_server \
	&& /usr/local/src/steamcmd/steamcmd.sh +login anonymous +force_install_dir /usr/local/src/dst_server +app_update 343050 validate +quit \
	&& mkdir -p /data

COPY ./start_server.sh /data
RUN chmod a+x /data/start_server.sh

ENV DST_INSTALLATION_DIR=/usr/local/src/dst_server/ \
	DST_DATA_DIR=/data \
	DST_PORT=10999
	
ENTRYPOINT [ "/data/start_server.sh" ]
CMD [ "dst_server" ]
EXPOSE 10999/udp