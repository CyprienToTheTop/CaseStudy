# I used here a debian as docker base image, because I use a WSL Debian 12 usually on my laptop than runs on Windows
# I acknowledge that in a production env, it's better to use a lighter OS such as Alpine that contains less content,
# and therefore less vulnerabilities and exposure
FROM debian:latest
ARG UID
ARG GID
#updating the OS and install curl and jq that are used in the script after
RUN apt-get update --yes && apt-get upgrade --yes && apt-get install curl jq --yes

# create the non root user, change owner of the scripts folder, switch to nonroot user and copy the scripts
RUN groupadd --gid $GID nonroot
RUN useradd -u $UID -r -g nonroot nonroot
WORKDIR /scripts
RUN chown -R nonroot:nonroot /scripts
USER nonroot
COPY scripts/*.sh .

# the entrypoint will call /scripts/urlRetriever.sh $@ (all args)
ENTRYPOINT [ "bash","/scripts/entrypoint.sh"]