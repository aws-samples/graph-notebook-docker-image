# graph_notebook
Self Hosted Jupyter Notebook for Neptune

if you run this docker image in a non-ec2, you need set NOTEBOOK_PASSWORD, for example the password of notebook & lab is "helloworld":
```shell
docker run \
--env GRAPH_NOTEBOOK_AUTH_MODE="DEFAULT" \
--env GRAPH_NOTEBOOK_HOST="neptune.ckt7ssvjxxh.neptune.cn-northwest-1.amazonaws.com.cn" \
--env GRAPH_NOTEBOOK_PORT="8182" \
--env NEPTUNE_LOAD_FROM_S3_ROLE_ARN="" \
--env AWS_REGION="cn-northwest-1" \
--env NOTEBOOK_PORT="8888" \
--env LAB_PORT="8889" \
--env GRAPH_NOTEBOOK_SSL="True" \
--env NOTEBOOK_PASSWORD="helloworld" \
-p 8888:8888 \
-p 8889:8889 \
-d graph_notebook:latest
```
then when you login jupyter lab use this password, you need click "Build" to to build "graph_notebook_widgets"(mabye need reload page when build finish), and click "Enable" in the Extension Manager. after you do that, you can open , write this command       ```%load_ext graph_notebook.magics```  in the first cell of the notebook. you can use Extension command like   ```%status```  after you run this cell.
