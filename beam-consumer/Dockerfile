FROM flink:1.16

RUN apt-get update -y && \
apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev libffi-dev liblzma-dev && \
wget https://www.python.org/ftp/python/3.8.10/Python-3.8.10.tgz && \
tar -xvf Python-3.8.10.tgz && \
cd Python-3.8.10 && \
./configure --without-tests --enable-shared && \
make -j6 && \
make install && \
ldconfig /usr/local/lib && \
cd .. && rm -f Python-3.8.10.tgz && rm -rf Python-3.8.10 && \
ln -s /usr/local/bin/python3 /usr/local/bin/python && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

RUN pip3 install -U pip && pip3 install "apache-flink>=1.16.0,<1.17.1"

USER flink
RUN mkdir /opt/flink/app
ADD run.py /opt/flink/app/run.py
