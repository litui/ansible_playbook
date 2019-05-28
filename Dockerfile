FROM gliderlabs/alpine:3.9
ARG VERSION=2.8.0

RUN \
  apk-install \
    curl \
    openssh-client \
    python \
    py-boto \
    py2-dateutil \
    py2-httplib2 \
    py2-jinja2 \
    py2-paramiko \
    py2-pip \
    py2-setuptools \
    py2-yaml \
    py2-crypto \
    tar && \
  pip install --upgrade pip python-keyczar && \
  rm -rf /var/cache/apk/*

RUN mkdir /etc/ansible/ /ansible
RUN echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts

RUN \
  curl -fsSL https://releases.ansible.com/ansible/ansible-${VERSION}.tar.gz -o ansible.tar.gz && \
  tar -xzf ansible.tar.gz -C ansible --strip-components 1 && \
  rm -fr ansible.tar.gz /ansible/docs /ansible/examples /ansible/packaging

RUN mkdir -p /ansible/playbooks
WORKDIR /ansible/playbooks

ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
ENV ANSIBLE_SSH_PIPELINING True
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib

ENTRYPOINT ["ansible-playbook"]
