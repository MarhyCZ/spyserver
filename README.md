# SpyServer

Docker build for Airspy SDR radio SpyServer package

## How to run

App can either use default config file spyserver.config or you can specify your own using environment variable. For example:

Just use default PORT 5555 in your spyserver.config file.

```env
CONFIG="https://gist.githubusercontent.com/MarhyCZ/xxxx....
```

```yaml
services:
  spyserver:
    image: ghcr.io/marhycz/spyserver:main
    devices:
      - /dev/bus/usb:/dev/bus/usb
    ports:
      - 5555:5555
```
