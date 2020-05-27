FROM ubuntu

# This is required to prevent tzdata prompting for
# user input when it is installed as a dependency
# for singularity. This results in the timezone
# being set to UTC. Use "dpkg-reconfigure tzdata"
# to reset the timezone, if you care.
#
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt upgrade -y && \
    apt install -y default-jre git nodejs python3-pip vim wget zip \
                   build-essential cryptsetup-bin libssl-dev uuid-dev libgpgme11-dev squashfs-tools

ENV GO_VERSION=1.14.3
RUN wget https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_VERSION}.linux-amd64.tar.gz
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

ENV SINGULARITY_VERSION=3.5.1
RUN mkdir -p /usr/local/var/singularity/mnt && \
    mkdir -p $GOPATH/src/github.com/sylabs && \
    cd $GOPATH/src/github.com/sylabs && \
    wget https://github.com/sylabs/singularity/releases/download/v${SINGULARITY_VERSION}/singularity-${SINGULARITY_VERSION}.tar.gz && \
    tar -xzvf singularity-${SINGULARITY_VERSION}.tar.gz && \
    cd singularity && \
    ./mconfig -p /usr/local && \
    make -C builddir && \
    make -C builddir install

ADD clone-janis.sh /
ADD build-janis.sh /
