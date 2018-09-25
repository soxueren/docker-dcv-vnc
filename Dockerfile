FROM nvidia/cuda:8.0-runtime-ubuntu16.04

## install tools
RUN apt-get install -y perl wget xauth xkeyboard-config tigervnc-server pciutils xterm expect

## download dcv  pcsc-lite-libs dkms

## localinstall pcsc-lite-libs

## localinstall nice-dcv-server

## add viewer user
RUN groupadd viewer && \
    useradd -m -r viewer  -g viewer
	
## clean cache


RUN echo "default start vncserver ......... " > /vncserver.log

ADD ./xstartup /tmp/xstartup
ADD ./vncservers  /etc/sysconfig/vncservers
ADD ./license.lic /usr/share/dcv/license/license.lic
ADD ./dcv.conf /etc/dcv/dcv.conf
ADD ./init_commond.exp /init_commond.exp
ADD ./start.sh /start.sh

RUN chmod +x /start.sh
RUN chmod +x /init_commond.exp
RUN chmod +x /tmp/xstartup

EXPOSE 5901 5902 5903 5904 5905  8443

ENTRYPOINT  ["/start.sh"]
CMD ["/usr/sbin/init"]
