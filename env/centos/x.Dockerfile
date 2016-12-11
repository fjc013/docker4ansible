FROM centos:centos7
MAINTAINER "fjc" frank.combopiano@gmail.com

ENV container docker

RUN yum -y update; yum clean all

RUN yum -y swap -- remove systemd-container systemd-container-libs -- install systemd systemd-libs dbus fsck.ext4

RUN systemctl mask dev-mqueue.mount dev-hugepages.mount \
    systemd-remount-fs.service sys-kernel-config.mount \
    sys-kernel-debug.mount sys-fs-fuse-connections.mount \
    display-manager.service graphical.target systemd-logind.service

RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs
RUN yum -y update; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum -y install openssh-server sudo openssh-clients
RUN sed -i 's/#PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config
#RUN ssh-keygen -q -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
#    ssh-keygen -q -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa && \
#    ssh-keygen -q -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519
#RUN echo 'root:docker.io' | chpasswd
#RUN systemctl enable sshd.service

# Modeled after mastering ansible Ubuntu Dockerfile

RUN mkdir /var/run/sshd

# Setup ansible user
RUN useradd ansible -s /bin/bash
RUN mkdir -p /home/ansible/.ssh/
RUN chmod 0700 /home/ansible/.ssh/
COPY ssh_config /home/ansible/.ssh/config
COPY ansible /home/ansible/.ssh/id_rsa
COPY ansible.pub /home/ansible/.ssh/id_rsa.pub
COPY ansible.pub /home/ansible/.ssh/authorized_keys
RUN chown -R ansible:ansible /home/ansible/
#
# added by fjc from class forum
RUN chmod 0600 /home/ansible/.ssh/config
RUN chmod 0600 /home/ansible/.ssh/id_rsa
RUN chmod 0600 /home/ansible/.ssh/id_rsa.pub
RUN chmod 0644 /home/ansible/.ssh/authorized_keys
#
RUN echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


# firewalld needs this .. and I needs my firewalld
COPY dbus.service /etc/systemd/system/dbus.service
RUN systemctl enable dbus.service

# Drop the shields
#RUN systemctl stop firewalld 
#RUN systemctl disable firewalld

RUN systemctl enable sshd.service

VOLUME [ "/sys/fs/cgroup" ]
VOLUME ["/run"]

EXPOSE 22

CMD ["/usr/sbin/init"]
