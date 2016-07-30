# Original credit: https://github.com/jpetazzo/dockvpn

#Dockerfile for building openvpn on a raspberry pi

# Smallest base image
FROM hypriot/rpi-alpine-scratch

MAINTAINER Peter Lavelle <peter@solderintheveins.co.uk>

RUN echo "http://dl-4.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories && \
    echo "http://dl-4.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update openvpn iptables bash easy-rsa openvpn-auth-pam google-authenticator pamtester openssl && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    apk upgrade && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

# Needed by scripts
ENV OPENVPN /etc/openvpn
ENV EASYRSA /usr/share/easy-rsa
ENV EASYRSA_PKI $OPENVPN/pki
ENV EASYRSA_VARS_FILE $OPENVPN/vars

VOLUME ["/etc/openvpn"]

# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
EXPOSE 1194/udp

CMD ["ovpn_run"]

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

# Add support for OTP authentication using a PAM module
ADD ./otp/openvpn /etc/pam.d/
