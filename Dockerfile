FROM    corebox:latest

MAINTAINER "Brian Harrington" <brian.harrington@coreos.com> @brianredbeard

ADD assets/stretcd.sh /bin/
ADD assets/base64 /bin/
ADD assets/help /bin/
 


CMD ["/bin/stretcd.sh"]
