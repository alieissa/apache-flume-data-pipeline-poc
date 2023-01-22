# TODO Move to docker-compose.yaml
FROM ubuntu:22.04

RUN apt update \
  && apt install -y wget curl telnet openjdk-18-jre maven

RUN wget https://dlcdn.apache.org/flume/1.11.0/apache-flume-1.11.0-bin.tar.gz \
  && tar -xzf apache-flume-1.11.0-bin.tar.gz

ENV PATH=$PATH:/apache-flume-1.11.0-bin/bin

RUN mkdir /app
COPY ./app /app

RUN mv /app/pom.xml /apache-flume-1.11.0-bin/
WORKDIR /apache-flume-1.11.0-bin
RUN mvn process-sources

ENTRYPOINT [ "flume-ng", "agent" , "-n", "agent", "-f", "/app/agent.conf",  "--conf", "/app" ]
