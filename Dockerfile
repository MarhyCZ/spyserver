# spyserver/Dockerfile
FROM alpine:latest AS build

WORKDIR /src

# Install dependencies
RUN apk add --no-cache \
  build-base \
  cmake \
  git \
  curl \
  libusb-dev 

# Airspy Mini Driver
WORKDIR /src/
RUN git clone https://github.com/airspy/airspyone_host.git
WORKDIR /src/airspyone_host
RUN mkdir build && cd build && cmake ../ -DINSTALL_UDEV_RULES=ON && make -j`nproc` && make install -j`nproc`

# SpyServer
WORKDIR /src
RUN curl -L -o spyserver.tgz https://airspy.com/downloads/spyserver-arm64.tgz
RUN tar xvfz spyserver.tgz

FROM alpine:latest AS runtime

# Airspy libs/binaries
COPY --from=build /usr/local /usr/local

WORKDIR /app
COPY --from=build /src/spyserver /app/
COPY entrypoint.sh /app/entrypoint.sh

RUN apk add --no-cache \
  curl

EXPOSE 5555

ENTRYPOINT ["sh", "entrypoint.sh"]
CMD ["spyserver"]