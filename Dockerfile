FROM puppet/puppet-agent
MAINTAINER peter@pouliot.net

RUN mkdir -p /etc/puppetlabs/code/modules/ipam
COPY . /etc/puppetlabs/code/modules/ipam/
COPY Puppetfile /etc/puppetlabs/code/environments/production/Puppetfile
COPY Dockerfile Dockerfile

RUN \
    apt-get update -y && apt-get install git curl software-properties-common -y \
    && gem install r10k \
    && cd /etc/puppetlabs/code/environments/production/ \
    && r10k puppetfile install --verbose DEBUG2 \
    && mkdir -p /var/lock/named /var/run/named \
    && puppet module list \
    && puppet module list --tree \
    && puppet apply --debug --trace --verbose --modulepath=/etc/puppetlabs/code/modules:/etc/puppetlabs/code/environments/production/modules /etc/puppetlabs/code/environments/production/modules/dns/tests/init.pp \
RUN \
    echo "**** Verifying that the BIND Configuration ****" \
    && /usr/sbin/named-checkconf
