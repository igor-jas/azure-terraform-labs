FROM ubuntu:22.04

RUN apt-get update && apt-get install -y openssh-server && \
    mkdir /var/run/sshd

RUN echo 'root:capstone123' | chpasswd

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]