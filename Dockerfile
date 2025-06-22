FROM docker.io/fedora:42 AS base
RUN dnf update -y
FROM base AS buildbase
RUN dnf install -y cmake gcc ninja git alsa-lib-devel opus-devel libevdev-devel libgudev-devel libuuid-devel libcurl-devel expat-devel avahi-devel SDL2-devel libcec-devel libavcodec-free-devel

FROM buildbase AS build
COPY . /src
WORKDIR /src/build
RUN cmake .. -G Ninja -DCMAKE_BUILD_TYPE=RelWithDeb && ninja

FROM base AS final
WORKDIR /app
RUN dnf install -y libcec libavcodec-free SDL2 libglvnd-gles libevdev
COPY --from=build /src/build/libgamestream /app
COPY --from=build /src/build/moonlight /app/moonlight