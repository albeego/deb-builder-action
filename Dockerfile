FROM ubuntu:18.04
RUN apt-get update
RUN apt-get install -y \
	build-essential \
	software-properties-common
RUN yes "" | add-apt-repository ppa:git-core/ppa && apt update && yes "y" | apt install -y git
RUN apt install -y crossbuild-essential-arm64 debhelper
RUN DEBIAN_FRONTEND=noninteractive apt-get install \
	devscripts \
	build-essential \
	lintian -y
COPY entrypoint.sh /entrypoint.sh
RUN dpkg --add-architecture arm64
RUN apt-get install build-essential crossbuild-essential-arm64
ENTRYPOINT ["/entrypoint.sh"]