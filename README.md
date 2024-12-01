# Repository description

This repository aims to propose an answer to a Case Study.

## Part 1

the script that answers the Part 1 can be found in scripts/urlRetriever.sh
I chose bash because that is the langage I'm the most comfortable with, even though manipulating json chains with bash is not the easiest choice.
I think that would go with Python for that


## Part 2

### DockerFile
There is the Dockerfile file at the root of project
the non root user is "nonroot"
To build the docker image, run the command as below (preferably on Linux env)

``` sh
export HOST_UID=$(id -u)
export HOST_GID=$(id -g)

docker build --build-arg UID=$HOST_UID --build-arg GID=$HOST_GID -t urlretriever .
```

To execute it, example below
``` sh
docker run -it urlretriever -u "https://arstechnica.com/" -u "https://stackoverflow.com/" -o stdout
```

### Kubernetes

see [manifest.yaml](manifest.yaml) file, I used a job because this I know that after execution of script, the pod will die

## Part 3

I'm more comfortable with GitHub Actions, this is what I use daily in my current job

see [.github/workflows/build-deploy-kubernetes.yaml](build-deploy-kubernetes.yaml) file

## Part 4
See folder Part4 for the scripts
and execution proof in executions_proofs folder