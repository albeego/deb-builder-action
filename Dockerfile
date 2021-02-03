FROM ubuntu:20.04
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	build-essential \
	software-properties-common
RUN yes "" | add-apt-repository ppa:git-core/ppa && apt-get update && yes "y" | apt-get install -y git
RUN apt-get install -y crossbuild-essential-arm64 debhelper
RUN DEBIAN_FRONTEND=noninteractive apt-get install \
	devscripts \
	lintian -y
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]