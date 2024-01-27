# spyserver/Dockerfile
FROM debian:bookworm-slim AS build

WORKDIR /src

# Install dependencies
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  build-essential \
  cmake \
  git \
  curl \
  libusb-1.0-0-dev \
  ca-certificates \
  pkg-config

# Airspy Mini Driver
WORKDIR /src/
RUN git clone https://github.com/airspy/airspyone_host.git
WORKDIR /src/airspyone_host
RUN mkdir build && cd build && cmake ../ -DINSTALL_UDEV_RULES=ON && make -j`nproc` && make install -j`nproc` && ldconfig

# SpyServer
WORKDIR /src/spyserver
RUN curl -L -o spyserver.tgz https://airspy.com/downloads/spyserver-arm64.tgz
RUN tar xvfz spyserver.tgz

FROM debian:bookworm-slim AS runtime

# Airspy libs/binaries
COPY --from=build /usr/local /usr/local
RUN ldconfig

WORKDIR /app
COPY --from=build /src/spyserver /app/
RUN chmod +x spyserver
COPY entrypoint.sh /app/entrypoint.sh

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  curl \
  librtlsdr0

EXPOSE 5555

ENTRYPOINT ["sh", "entrypoint.sh"]
CMD ["./spyserver"]