FROM    https://quay.io/brianredbeard/corebox:latest

MAINTAINER "Brian Harrington" <brian.harrington@coreos.com> @brianredbeard

ADD assets/stretcd.sh /bin/
 


CMD ["/bin/stretcd.sh"]
