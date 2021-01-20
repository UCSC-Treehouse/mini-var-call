FROM ubuntu:14.04
MAINTAINER holly beale

RUN apt-get update && apt-get install -y --no-install-recommends \
  wget \
  git \
  unzip \
  build-essential \
  zlib1g-dev \
  cmake \
  samtools \
  software-properties-common \
  && rm -rf /var/lib/apt/lists/*

# Install JDK
RUN add-apt-repository ppa:openjdk-r/ppa -y
RUN apt-get update && apt-get install -y --no-install-recommends \
  openjdk-8-jdk \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install snpEff
RUN wget -nv http://sourceforge.net/projects/snpeff/files/snpEff_v4_3r_core.zip \
  && unzip snpEff_v4_3r_core.zip && rm snpEff_v4_3r_core.zip
RUN java -jar ./snpEff/snpEff.jar download GRCh38.86

# Install freebayes
RUN wget -nv http://clavius.bc.edu/~erik/freebayes/freebayes-5d5b8ac0.tar.gz \
  && tar xzvf freebayes-5d5b8ac0.tar.gz && rm freebayes-5d5b8ac0.tar.gz
WORKDIR /app/freebayes
RUN make

WORKDIR /app
ADD . /app

ENTRYPOINT ["/bin/bash", "run.sh"]
