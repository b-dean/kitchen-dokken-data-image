# Copied from kitchen-dokken
# https://github.com/test-kitchen/kitchen-dokken/blob/50b51c7f83e78b7bb3aa288b1a7a5eb73e2f229b/lib/kitchen/helpers.rb#L60-L89

FROM almalinux:9
MAINTAINER Sean OMeara "sean@sean.io"
ENV LANG en_US.UTF-8

RUN dnf -y install tar rsync openssh-server passwd git
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''

# uncomment to debug cert issues
# RUN echo 'root:dokkendokkendokken' | chpasswd
# RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN mkdir -p /root/.ssh/
COPY authorized_keys /root/.ssh/authorized_keys
RUN chmod 700 /root/.ssh/
RUN chmod 600  /root/.ssh/authorized_keys

EXPOSE 22
CMD [ "/usr/sbin/sshd", "-D", "-p", "22", "-o", "UseDNS=no", "-o", "MaxAuthTries=60", "-o", "UsePAM=no" ]

# kitchen-dokken should be making this volume at container creation, but they're not.
VOLUME /opt/kitchen

VOLUME /opt/verifier