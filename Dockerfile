FROM python:3.9.6-alpine3.14

SHELL ["/bin/sh", "-o", "pipefail", "-c"]

COPY requirements.txt /

RUN set -eux \
   && apk add --no-cache \
      git=2.32.7-r0 \
      openssh-client-common=8.6_p1-r3 \
      openssh-client-default=8.6_p1-r3 \
      rsync=3.2.5-r0 \
      bash \
   && apk add --no-cache --virtual .build-deps \
      make=4.3-r0 \
      gcc=10.3.1_git20210424-r2\
      libc-dev=0.7.2-r3 \
      openssl-dev=1.1.1t-r2 \
      libffi-dev=3.3-r2 \
      python3-dev=3.9.17-r0 \
      postgresql-dev==13.12-r0 \
      musl-dev==1.2.2-r5 \
   && which pg_config \
   && pip install --no-cache-dir -r requirements.txt \
   && apk del .build-deps \
   && rm -rf ~/.cache/

ENV ANSIBLE_LOCAL_TEMP /tmp

RUN set -eux \
   && ln -sf /usr/local/bin/python3 /usr/bin/python3

COPY galaxy-requirements.txt /
RUN set -eux \
   && echo "[galaxy]" > ansible.cfg \
   && echo "server = https://old-galaxy.ansible.com/" >> ansible.cfg \
   && ansible-galaxy collection install -r galaxy-requirements.txt

WORKDIR /work

CMD ["ansible-playbook", "--help"]
