FROM alpine:3.18

RUN apk update
RUN apk add xfsprogs e2fsprogs ca-certificates fuse alpine-sdk automake autoconf libxml2-dev fuse-dev curl-dev

RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git
RUN cd s3fs-fuse && ./autogen.sh && ./configure --prefix=/usr
RUN cd s3fs-fuse && make && make install
RUN rm -rf s3fs-fuse

RUN rm -rf /var/cache/apk/*

RUN mkdir -p /lib64 && ln -s /lib/libc.musl-aarch64.so.1 /lib64/ld-linux-aarch64.so.2
RUN mkdir -p /etc/rexray /run/docker/plugins /var/lib/rexray/volumes
ADD rexray /usr/bin/rexray
ADD rexray.yml /etc/rexray/rexray.yml

ADD rexray.sh /rexray.sh
RUN chmod +x /rexray.sh && chmod +x /usr/bin/rexray

CMD [ "rexray", "start", "--nopid" ]
ENTRYPOINT [ "/rexray.sh" ]
