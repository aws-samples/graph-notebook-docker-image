#!/bin/bash

# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

##### Ininition Enviroment #####
yum install -y wget curl tar gzip which
cd ~
wget https://repo.anaconda.com/archive/Anaconda3-2019.07-Linux-x86_64.sh -O ~/Anaconda3-2019.07-Linux-x86_64.sh
mkdir ~/.conda/
echo "yes" | bash Anaconda3-2019.07-Linux-x86_64.sh -b -p ~/anaconda3

echo "export PATH=/root/anaconda3/bin:$PATH" >> ~/.bashrc

if [ `curl -s 169.254.169.254/latest/meta-data/services/partition/` == 'aws-cn' ];
    then
        pipargs=' -i https://pypi.tuna.tsinghua.edu.cn/simple '
elif [ `curl -s 169.254.169.254/latest/meta-data/services/partition/` == 'aws' ];
    then
        pipargs=''
else
    echo "Unable to determine region！";
    pipargs=''
fi

##### Install NodeJs #####
curl --silent --location https://rpm.nodesource.com/setup_12.x | bash -
yum install -y nodejs
npm install -g opencollective

##### Copy To Home Directory #####
source ~/.bashrc
echo "y" | conda create -n JupyterSystemEnv python=3.7
source activate JupyterSystemEnv

# pin specific versions of required dependencies
pip install rdflib==5.0.0

# install the package
pip install graph-notebook

# install and enable the visualization widget
jupyter nbextension install --py --sys-prefix graph_notebook.widgets
jupyter nbextension enable  --py --sys-prefix graph_notebook.widgets

# copy static html resources
python -m graph_notebook.static_resources.install
python -m graph_notebook.nbextensions.install

# copy premade starter notebooks
python -m graph_notebook.notebooks.install --destination ~/notebook/destination/dir

source ~/anaconda3/bin/deactivate
