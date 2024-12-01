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

Regarding the scan, I used docker scout commands, I am not that familiar with it, in my current job, I more rely on the automated scan from GCP on the Google Artifact Registry Artifacts.
Here I can see that there are some vulnerabilities, but none of them with an available fix.
I recommand using a tool that will track the vulnerabilities and which will pop up a message when a fix become available on an artifact pushed on the registry

### Kubernetes

I set up a Minikube environment on my laptop, following https://gist.github.com/wholroyd/748e09ca0b78897750791172b2abb051
I pushed the image to a public repository of my own on Docker Hub 
I created a namespace casestudy where I deployed the pod, with already the args " args: ["-u https://arstechnica.com/ -o stdout"] "
see [manifest.yaml](manifest.yaml) file, 

## Part 3

I'm more comfortable with GitHub Actions, this is what I use daily in my current job

see [build-deploy-kubernetes.yaml](.github/workflows/build-deploy-kubernetes.yaml) file

## Part 4
See folder Part4 for the scripts
and execution proof in executions_proofs folder