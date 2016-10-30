FROM ubuntu:14.04
MAINTAINER Jeff Geerling

# Install dependencies.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       software-properties-common \
    && rm -Rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean
# Install Ansible.
RUN apt-add-repository -y ppa:ansible/ansible \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       ansible \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean
# Install Git.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       git \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean
# Git Clone test tag version
RUN cd /opt && git clone --branch v3.4.1 https://github.com/willthames/ansible-lint.git \
    && cd /usr/local/bin \
    && printf '#!/bin/bash\n\nexport PYTHONPATH=$PYTHONPATH:/opt/ansible-lint/lib\n\n/opt/ansible-lint/bin/ansible-lint "$@"\n' > ansible-lint \
    && chmod +x ansible-lint

# Install Ansible inventory file
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts
