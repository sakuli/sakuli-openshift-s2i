# Creating a basic S2I builder images

This repository contains an S2I setup process for any Sakuli based docker container. This does not only allow to add
S2I support easily for various enterprise container, but also for custom Sakuli docker images used in customer projects.

Currently available S2I enterprise container:
* `taconsol/sakuli-s2i`: Default Sakuli container with S2I functionality
* `taconsol/sakuli-s2i-remote-connection`: Sakuli container providing RDP with S2I functionality

## Getting started

### Files and Directories
| File                   | Required? | Description                                                  |
|------------------------|-----------|--------------------------------------------------------------|
| Dockerfile             | Yes       | Defines the base builder image                               |
| s2i/bin/assemble       | Yes       | Script that builds the application                           |
| s2i/bin/usage          | No        | Script that prints the usage of the builder                  |
| s2i/bin/run            | Yes       | Script that runs the application                             |
| s2i/bin/save-artifacts | No        | Script for incremental builds that saves the built artifacts |
| test/run               | No        | Test script for the builder image                            |
| test/test-app          | Yes       | Test application source code                                 |

#### Dockerfile
*Dockerfile* that installs the s2i scripts into the created image. All required software to execute Sakuli test cases 
is delivered by the base images. 

#### S2I binary
You can download the S2I binary for your platform from [GitHub](https://github.com/openshift/source-to-image/releases)

# Installing the image on a customers cluster
## Creating a docker secret and importing the image
In order to connect to docker hub during a OpenShift image import, it is required to create a `docker-registry` secret
containing the credentials to access the _taconsol_ docker repository so that the image can be imported as follows.
It is also important to link the image to the `builder` service account before importing the image.
```shell script
oc import-image sakuli-s2i \
    --from=docker.io/taconsol/sakuli-s2i \
    --confirm \
    --scheduled=true \
    --all=true
```

## Applying infrastructure
To setup an s2i build in an OpenShift cluster, various Objects are required. A predefined template can be found in the
[s2i-build-template.yml](s2i-build-template.yml).

# Troubleshooting

## `pulling image error : ...`

**Affected OpenShift versions:** 3.10, 3.11

So far, this error occured on 3.10 and 3.11 clusters when trying to pull our s2i image from our private Dockerhub repo.
A workaround to solve this issue was to use `reference-policy=local` on the sakuli-s2i image stream.

```bash
oc import-image sakuli-s2i \
    --from=docker.io/taconsol/sakuli-s2i \
    --confirm \
    --scheduled=true \
    --all \
    --reference-policy=local
```
