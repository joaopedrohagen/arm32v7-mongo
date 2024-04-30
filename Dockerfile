FROM arm32v7/ubuntu:bionic

RUN apt-get update; \
    apt-get install --no-install-recommends ca-certificates curl gnupg wget jq -y

RUN groupadd -r mongodb; \
    useradd -r -g mongodb mongodb

RUN mkdir -p /data/db; \
    mkdir -p /tmp/mongo; \
    chown -R mongodb:mongodb /data/db

RUN wget -P /tmp/mongo https://github.com/ddcc/mongodb/releases/download/v3.2.22-2/mongodb-clients_3.2.22-2_armhf.deb; \
    wget -P /tmp/mongo https://github.com/ddcc/mongodb/releases/download/v3.2.22-2/mongodb-server_3.2.22-2_all.deb; \
    wget -P /tmp/mongo https://github.com/ddcc/mongodb/releases/download/v3.2.22-2/mongodb_3.2.22-2_armhf.deb; \
    wget -P /tmp/mongo https://github.com/ddcc/mongodb/releases/download/v3.2.22-2/mongodb-server-core_3.2.22-2_armhf.deb

VOLUME [ "/data/db" ]

RUN apt-get install libboost-chrono1.65.1 libboost-filesystem1.65.1 libboost-program-options1.65.1 \
    libboost-regex1.65.1 libboost-system1.65.1 libboost-thread1.65.1 libicu60 libpcrecpp0v5 \
    libsnappy1v5 libstemmer0d libyaml-cpp0.5v5 -y

RUN dpkg -i /tmp/mongo/mongodb-server-core_3.2.22-2_armhf.deb; \
    dpkg -i /tmp/mongo/mongodb-clients_3.2.22-2_armhf.deb; \
    dpkg -i /tmp/mongo/mongodb-server_3.2.22-2_all.deb; \
    dpkg -i /tmp/mongo/mongodb_3.2.22-2_armhf.deb; \
    service mongodb start

RUN rm -rf /tmp/mongo

EXPOSE 27017

CMD ["mongod"]
