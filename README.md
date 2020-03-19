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

### S2I scripts
#### Create the builder images
Builder images are created via *make*. A corresponding *Makefile* is included.
There are two scripts responsible to build enterprise container.

| Container                    | Script                 |
|------------------------------|------------------------|
| sakuli-s2i                   | build-sakuli-base.sh   |
| sakuli-s2i-remote-connection | build-sakuli-remote.sh |

Once the images have finished building, the command *s2i usage sakuli-s2i* respectively 
*s2i usage sakuli-s2i-remote-connection* will print out the help info that was defined in the *usage* script.

#### Testing the builder image
The builder images can be tested using the following commands:
```
IMAGE_NAME=sakuli-s2i-candidate test/run
```
respectively
```
IMAGE_NAME=sakuli-s2i-remote-connection test/run
```

The builder image can also be tested by using the `make test IMAGE_NAME=<IMAGE_NAME>` command since a *Makefile* is included.

#### Creating the application image
The image combines the builder image with your test source code, which is executed using the sakuli2 docker image,
packed using the *assemble* script, and run using the *run* script.
The following sample command will create the image containing a sample test:
```
s2i build test/test-app sakuli-s2i sakuli-s2i-candidate
---> Building and installing test image from source...
```
Using the logic defined in the *assemble* script, s2i will now create an image using the builder image as a base and
including the source code from the test/test-app directory.

#### Running the application image
Running the image is as simple as invoking the docker run command:
```
docker run -d -p 6901:6901 sakuli-s2i-candidate
```
The test, which consists of a simple check for [sakuli.io](https://sakuli.io), should now be accessible at
[http://localhost:6901](http://localhost:6901?password=vncpassword).

#### Releasing the image
After the build scripts have finished and the image has been prepared for release, releasing the image can be done
using the `release` stage in the make file.
_Note: Before you release, make sure that the sakuli version is correctly set in the shell script_
```shell script
sh release.sh
```


# Installing the image on a customers cluster
## Creating a docker secret and importing the image
In order to connect to docker hub during a OpenShift image import, it is required to create a `docker-registry` secret
containing the credentials to access the _taconsol_ docker repository so that the image can be imported as follows.
It is also important to link the image to the `builder` service account before importing the image.
```shell script
oc create secret docker-registry dockerhub-sakuli-secret \
    --docker-server=docker.io \
    --docker-username=<docker-username> \
    --docker-password=<docker-password> \
    --docker-email=unused

oc secrets link builder dockerhub-sakuli-secret

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
