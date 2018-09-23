FROM nvidia/cuda:8.0-runtime-centos7

RUN yum install -y perl wget xauth xkeyboard-config tigervnc-server pciutils xterm expect

## install dcv
RUN wget https://d1uj6qtbmh3dt5.cloudfront.net/server/nice-dcv-2017.1-5870-el7.tgz
RUN wget http://mirror.centos.org/centos/7/os/x86_64/Packages/pcsc-lite-libs-1.8.8-7.el7.x86_64.rpm

RUN tar zxvf nice-dcv-2017.1-5870-el7.tgz

## localinstall pcsc-lite-libs
RUN yum localinstall -y pcsc-lite-libs-1.8.8-7.el7.x86_64.rpm

## localinstall nice-dcv-server
RUN cd nice-dcv-2017.1-5870-el7 && \
    yum localinstall -y nice-dcv-server-2017.1.5870-1.el7.x86_64.rpm  nice-xdcv-2017.1.170-1.el7.x86_64.rpm

## localinstall nice-dcv-server	
RUN cd nice-dcv-2017.1-5870-el7 && \
     yum localinstall -y  nice-dcv-gl-2017.1.366-1.el7.x86_64.rpm \
	 nice-dcv-gltest-2017.1.198-1.el7.x86_64.rpm
	 
## enable dcvserver
RUN chkconfig dcvserver on && systemctl list-unit-files
RUN echo 402@sjgs | passwd --stdin root		 

RUN groupadd viewer && \
    useradd -m -r viewer  -g viewer

RUN echo viewertest | passwd --stdin viewer

RUN rm -rf nice-dcv-2017.1-5870-el7.tgz && \
    rm -rf nice-dcv-2017.1-5870-el7 && \
    rm -rf pcsc-lite-libs-1.8.8-7.el7.x86_64.rpm && \
    yum clean all -y 
	
RUN echo "default start vncserver ...... " > /vncserver.log

ADD ./xstartup /tmp/xstartup
ADD ./vncservers  /etc/sysconfig/vncservers
ADD ./license.lic /usr/share/dcv/license/license.lic
ADD ./dcv.conf /etc/dcv/dcv.conf
ADD ./init_commond.exp /init_commond.exp
ADD ./start.sh /start.sh
RUN chmod +x /start.sh
RUN chmod +x /init_commond.exp

EXPOSE 5901 5902 5903 5904 5905  8443

ENTRYPOINT  ["/start.sh"]
CMD ["/usr/sbin/init"]


