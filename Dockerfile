FROM debian:buster
MAINTAINER Dennis Wagelaar [corilus.be]

# Steps done in one RUN layer:
# - Install packages
# - OpenSSH needs /var/run/sshd to run
# - Remove generic host keys, entrypoint generates unique keys
RUN apt-get update && \
    apt-get -y install rsyslog openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*key* && \
    mkdir -p /etc/rsyslog.d

COPY files/rsyslog.conf /etc/rsyslog.conf
COPY files/sftplog.conf /etc/rsyslog.d/sftplog.conf
COPY files/sshd_config /etc/ssh/sshd_config
COPY files/create-sftp-user /usr/local/bin/
COPY files/entrypoint /

EXPOSE 22

ENTRYPOINT ["/entrypoint"]
