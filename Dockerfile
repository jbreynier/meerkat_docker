FROM ubuntu:14.04
LABEL maintainer="jbreynier@uchicago.edu"

ENV PERL_MM_USE_DEFAULT=1

RUN apt-get update && \
    apt-get install -y build-essential \
    cmake libexpat1-dev wget git \
    r-base r-base-dev r-recommended && \
    cpan App::cpanminus && \
    cpanm Bio::DB::Fasta && \
    apt-get clean

# Install BWA 0.6.2
RUN cd /usr/local/ && \
    wget http://downloads.sourceforge.net/project/bio-bwa/bwa-0.6.2.tar.bz2 && \
    bunzip2 bwa-0.6.2.tar.bz2 && \
    tar xvf bwa-0.6.2.tar && \
    cd bwa-0.6.2 && \
    make

# Install Blast legacy version 2.2.24
RUN cd /usr/local/ && \
    wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/legacy.NOTSUPPORTED/2.2.24/blast-2.2.24-x64-linux.tar.gz && \
    tar -xzf blast-2.2.24-x64-linux.tar.gz

# Install Samtools 0.1.19
RUN cd /usr/local && \
    wget https://sourceforge.net/projects/samtools/files/samtools/0.1.19/samtools-0.1.19.tar.bz2 && \
    bunzip2 samtools-0.1.19.tar.bz2 && \
    tar xvf samtools-0.1.19.tar && \
    cd samtools-0.1.19 && \
    make

# Install Blat and gfServer
RUN mkdir /usr/local/blat && \
    cd /usr/local/blat/ && \
    wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/blat/blat && \
    chmod ugo+rwx blat && \
    wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/blat/gfClient && \
    chmod ugo+rwx gfClient

# Install Primer3
RUN cd /usr/local/ && \
    wget --tries=30 --waitretry=5 --retry-connrefused https://sourceforge.net/projects/primer3/files/primer3/2.2.0-alpha/primer3-2.2.0-alpha.tar.gz && \
    tar -xzf primer3-2.2.0-alpha.tar.gz && \
    cd primer3-2.2.0-alpha/src && \
    make all

ENV GIT_SSL_NO_VERIFY=1

# Install Meerkat from GitHub
RUN cd /usr/local/ && \
    git clone https://github.com/guru-yang/Meerkat.git

# Build mybamtools
RUN cd /usr/local/Meerkat/src/ && \
    tar -xjf mybamtools.tbz && \
    cd mybamtools && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make

# Build bamreader
RUN cd /usr/local/Meerkat/src/ && \
    tar -xjf bamreader.tbz && \
    cd bamreader && \
    sed -i '/BTROOT = /c\BTROOT = /usr/local/Meerkat/src/mybamtools'  Makefile && \
    sed -i 's/-lbamtools -lbamtools-utils/-lbamtools -lbamtools-utils -lz/'  Makefile && \
    make && \
    mv ./bamreader ../../bin/

ENV LD_LIBRARY_PATH=/usr/local/Meerkat/src/mybamtools/lib

# Build dre
RUN cd /usr/local/Meerkat/src/ && \
    tar xjvf dre.tbz && \
    cd dre && \
    sed -i '/BTROOT = /c\BTROOT = /usr/local/Meerkat/src/mybamtools'  Makefile && \
    sed -i 's/-lbamtools -lbamtools-utils/-lbamtools -lbamtools-utils -lz/'  Makefile && \
    make && \
    mv ./dre ../../bin/

# Build sclus:
RUN cd /usr/local/Meerkat/src/ && \
    tar xjvf sclus.tbz && \
    cd sclus && \
    make && \
    mv ./sclus ../../bin/