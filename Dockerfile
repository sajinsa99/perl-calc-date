FROM alpine:latest

# install tools

RUN apk update --quiet --no-progress && apk upgrade --quiet --no-progress && apk add --quiet --no-progress --no-cache bash wget curl tar

# set CET timezone
RUN apk add --quiet --no-progress --no-cache tzdata && cp -vf /usr/share/zoneinfo/CET /etc/localtime && echo CET > /etc/timezone && date && apk del --quiet --no-progress --no-cache tzdata

# install prerequisites for compiling perl
RUN apk add --quiet --no-progress --no-cache expat-dev \
	gcc \
	libc-dev \
	make \
	musl-dev \
	openssl-dev \
	zlib-dev

# download, compile and install perl, the one coming from alpine distribution, is bugged using diagnostics perl module
ENV PERL_VERSION=5.36.0 \
	PERL_MM_USE_DEFAULT=1
RUN cd /tmp ;\
	wget --no-proxy --no-check-certificate -nv https://www.cpan.org/src/5.0/perl-$PERL_VERSION.tar.gz ;\
	tar -xzf perl-$PERL_VERSION.tar.gz
RUN cd /tmp/perl-$PERL_VERSION ;\
	./Configure -des > /tmp/configure-perl.log 2>&1
RUN cd /tmp/perl-$PERL_VERSION ;\
	make > /tmp/make-perl.log 2>&1
RUN cd /tmp/perl-$PERL_VERSION ;\
	make install > /tmp/make-install-perl.log 2>&1
RUN cd /tmp ;\
	curl -L https://cpanmin.us | perl - App::cpanminus  > /tmp/cpanminus.log 2>&1 ;\
	cpanm -n App::cpanoutdated > /tmp/install-cpanoutdated.log 2>&1
RUN cd /tmp ;\
	cpan-outdated -p | cpanm > /tmp/cpan-outdated.log 2>&1

RUN cd /tmp ; cpanm -n DateTime > /tmp/DateTime.log 2>&1

# remove prerequisites for perl, not needed anymore
RUN apk del --quiet --no-progress --no-cache expat-dev \
	gcc \
	libc-dev \
	make \
	musl-dev \
	openssl-dev \
	zlib-dev

# some cleans + Cleanup apk cache to save space
RUN rm -f /tmp/*.* ;\
  rm -rf /tmp/* ;\
  rm -rf /var/cache/apk/*

ADD perl-calc-date.pl /root/

WORKDIR /root
