FROM    corebox:latest

MAINTAINER "Brian Harrington" <brian.harrington@coreos.com> @brianredbeard

ADD assets/base64 /bin/
ADD assets/help /bin/
ADD assets/stretcd.sh /bin/
 


CMD ["/bin/stretcd.sh"]
