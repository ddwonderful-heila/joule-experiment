FROM jrei/systemd-ubuntu:focal as base

ARG DEBIAN_FRONTEND=noninteractive
ARG JOULE_COMMIT=17e27d900df5c760c05c3cd1e3fc701668bbb4cd
ARG TZ="America/New_York"

RUN apt-get update && \
    apt-get install git python3 python3-pip language-pack-en postgresql -y && \
    # Note - additional work to setup Github credentials may be needed if used as  \
    #   part of CICD process
    git clone https://github.com/wattsworth/joule.git && \
    cd joule && \
    git reset --hard ${JOULE_COMMIT} && \
    pip3 install --trusted-host pypi.python.org  -r requirements.txt && \
    python3 setup.py -q install

FROM base as joule

ENV LC_ALL="en_US.UTF-8"
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"

COPY scripts/generate_test_certs.sh /temp/
COPY scripts/ /scripts/
COPY resources/main.conf /etc/joule/main.conf
RUN chmod +x /scripts/wait-for-postgres.sh /scripts/entrypoint.sh && \
    cd /temp && \
    ./generate_test_certs.sh && \
    mkdir -p /etc/joule/module_configs && \
    mkdir -p /etc/joule/stream_configs && \
    mkdir -p /etc/joule/security && \
    mv node.* /etc/joule/security && \
    cd .. && \
    rm -rf temp

ENTRYPOINT ["./scripts/entrypoint.sh"]
#CMD ["/usr/local/bin/joule", "admin", "initialize", "--dsn", "joule:heila@localhost:5432/jouledb", "&&", "/usr/local/bin/joule", "admin", "initialize"]
#entrypoint ["bin/sh", "-c"]
#CMD ["/usr/local/bin/jouled"]
