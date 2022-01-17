# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

FROM amazonlinux:latest
USER root
COPY ./install.sh /root/install.sh
COPY ./service.sh /root/service.sh
RUN chmod 755 /root/install.sh && chmod 755 /root/service.sh
RUN yum install -y wget curl tar gzip which
RUN /root/install.sh
ENTRYPOINT [ "bash","-c","/root/service.sh" ]