# Self Hosted Jupyter Notebook for Neptune

[Amazon Neptune](https://aws.amazon.com/neptune/) is a fast, reliable, fully managed graph database service that makes it easy to build and run applications that work with highly connected datasets. Whether you’re creating a new graph data model and queries, or exploring an existing graph dataset, it can be useful to have an interactive query environment that allows you to visualize the results. 

One of the ways to achieve this is to use Jupyter notebooks. You can refer to [Analyze Amazon Neptune Graphs using Amazon SageMaker Jupyter Notebooks](https://aws.amazon.com/blogs/database/analyze-amazon-neptune-graphs-using-amazon-sagemaker-jupyter-notebooks/) for steps to use an [Amazon SageMaker](https://aws.amazon.com/sagemaker/) hosted Jupyter notebook. If you want to deploy Jupyter notebooks locally in your on-premises or any other source environment, you can use the steps mentioned in this post to do so. This option also gives flexibility if you want to customize your notebook and its configurations as per your business needs.

We can use Docker containers to deploy a self-hosted Jupyter notebook. You can deploy the notebook using [Amazon Elastic Container Service](http://aws.amazon.com/ecs) (Amazon ECS) as described in this post, or you can deploy the notebook using [Amazon Elastic Kubernetes Service](https://aws.amazon.com/eks/) (Amazon EKS) or any other host like an [Amazon Elastic Compute Cloud](http://aws.amazon.com/ec2) (Amazon EC2) instance or on-premises server using similar steps. 

You can only create a Neptune DB cluster in [Amazon Virtual Private Cloud](http://aws.amazon.com/vpc) (Amazon VPC). Its endpoints are only accessible within that VPC. Therefore, if you’re deploying this Jupyter notebook outside the VPC of your Neptune cluster, you also need to establish connectivity via SSH tunnelling or a proxy (like Application Load Balancer, Network Load Balancer or [Amazon API Gateway](https://aws.amazon.com/api-gateway)), which is out of scope of this post.

Before we begin with the walkthrough, let’s understand the environment variables that we’re using:

- **GRAPH\_NOTEBOOK\_AUTH\_MODE** – This variable indicates the authentication mode. Possible values include DEFAULT and IAM. For this post, we use DEFAULT.
- **GRAPH\_NOTEBOOK\_HOST** – This variable is the [cluster endpoint](https://docs.aws.amazon.com/neptune/latest/userguide/feature-overview-endpoints.html) of your Neptune cluster.
- **GRAPH\_NOTEBOOK\_PORT** – This variable is the port of your Neptune cluster. For our post, we use 8182.
- **NEPTUNE\_LOAD\_FROM\_S3\_ROLE\_ARN** – This variable is needed if we plan to load data from [Amazon Simple Storage Service](http://aws.amazon.com/s3) (Amazon S3) into our Neptune cluster. For more information, refer to [Prerequisites: IAM Role and Amazon S3 Access](https://docs.aws.amazon.com/neptune/latest/userguide/bulk-load-tutorial-IAM.html). For our post, we leave it blank.
- **AWS\_REGION** – This variable indicates the Region where our Neptune cluster resides. For our post, we use us-east-1.
- **NOTEBOOK\_PORT** – This variable indicates the notebook’s port that we use while accessing the hosted Jupyter notebook. For our post, we use 8888.
- **LAB\_PORT** – This variable indicates the port of JupyterLab. For our post, we leave it blank.
- **GRAPH\_NOTEBOOK\_SSL** – This variable indicates if we should use SSL for communicating with Neptune. Neptune now enforces SSL connections to your database. You have the option to disable SSL in Regions, such as US East (N. Virginia) or Europe (London), where both SSL and non-SSL connections are supported.
- **NOTEBOOK\_PASSWORD** – This variable indicates the password that we use to access the hosted Jupyter notebook. If you’re hosting the notebook on an EC2 instance, if you leave this variable, the image assumes the default value (the EC2 instance ID).

## About the docker image
The container image available in this repository utilizes an [Amazon Linux container image](https://docs.aws.amazon.com/AmazonECR/latest/userguide/amazon_linux_container_image.html) as the base image with [Anaconda package](https://docs.anaconda.com/), Node.js, [Conda](https://conda.io/en/latest/), and Jupyter Notebooks. This also includes Jupyter notebook libraries for integration with Apache TinkerPop and RDF SPARQL. Depending on the configurations provided, a Jupyter notebook environment is automatically created.

[Build and deploy this image](https://docs.docker.com/get-started/part2/) with the following code:

``` 
docker build -t graph\_notebook . 

docker run \
--env GRAPH\_NOTEBOOK\_AUTH\_MODE="DEFAULT" \
--env GRAPH\_NOTEBOOK\_HOST="neptune.cluster-XXXXXXX.us-east-1.neptune.amazonaws.com" \
--env GRAPH\_NOTEBOOK\_PORT="8182" \
--env NEPTUNE\_LOAD\_FROM\_S3\_ROLE\_ARN="" \
--env AWS\_REGION="cn-northwest-1" \
--env NOTEBOOK\_PORT="8888" \
--env LAB\_PORT="8889" \
--env GRAPH\_NOTEBOOK\_SSL="True" 
--env NOTEBOOK\_PASSWORD="mypassword@123"\
-p 8888:8888 \
-d graph\_notebook:latest 
```

1. Browse to the URL of your machine (http://<Public IP>:< NOTEBOOK\_PORT>).
1. Log in using the password provided for variable NOTEBOOK\_PASSWORD.
1. In the Jupyter window, open the **Neptune** directory, and then the **Getting-Started** directory.

Now you can load data into the database, query it, and visualize the results using this Jupyter notebook. 

