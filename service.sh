# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

source /root/.bashrc
source activate JupyterSystemEnv
cd ~
if [[ ${GRAPH_NOTEBOOK_SSL} -eq "" ]]; then
    GRAPH_NOTEBOOK_SSL="True"
fi

python -m graph_notebook.configuration.generate_config --host "${GRAPH_NOTEBOOK_HOST}" --port "${GRAPH_NOTEBOOK_PORT}"  --auth_mode "${GRAPH_NOTEBOOK_AUTH_MODE}" --ssl "${GRAPH_NOTEBOOK_SSL}" --iam_credentials_provider "${GRAPH_NOTEBOOK_IAM_PROVIDER}" --load_from_s3_arn "${NEPTUNE_LOAD_FROM_S3_ROLE_ARN}" --aws_region "${AWS_REGION}"



##### Running The Notebook Service #####
mkdir ~/.jupyter
if [ ! ${NOTEBOOK_PASSWORD} ];
    then
        echo "c.NotebookApp.password='$(python -c "from notebook.auth import passwd; print(passwd('`curl -s 169.254.169.254/latest/meta-data/instance-id`'))")'" >> ~/.jupyter/jupyter_notebook_config.py
else
    echo "c.NotebookApp.password='$(python -c "from notebook.auth import passwd; print(passwd('${NOTEBOOK_PASSWORD}'))")'" >> ~/.jupyter/jupyter_notebook_config.py
fi
echo "c.NotebookApp.allow_remote_access = True" >> ~/.jupyter/jupyter_notebook_config.py

nohup jupyter notebook --ip='*' --port ${NOTEBOOK_PORT} ~/notebook/destination/dir --allow-root > jupyterserver.log &
nohup jupyter lab --ip='*' --port ${LAB_PORT} ~/notebook/destination/dir --allow-root > jupyterlab.log &
tail -f /dev/null