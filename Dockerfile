# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

FROM amazonlinux:latest

ENV NODE_VERSION=12.x

USER root

RUN yum update -y && \
    yum install wget curl tar gzip which  -y && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN curl --silent --location https://rpm.nodesource.com/setup_${NODE_VERSION} | bash - && \
    yum install nodejs -y && \
    npm install -g opencollective

COPY ./install.sh /root/install.sh

COPY ./service.sh /root/service.sh

RUN chmod 755 /root/install.sh && chmod 755 /root/service.sh

RUN /root/install.sh

ENTRYPOINT [ "bash","-c","/root/service.sh" ]