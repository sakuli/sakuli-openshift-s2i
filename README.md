# Creating a basic S2I builder image  

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
Create a *Dockerfile* that installs all of the necessary tools and libraries that are needed to build and run our 
sakuli 2 testcase.  This file will also handle copying the s2i scripts into the created image.

#### S2I scripts

#### Create the builder image
The following command will create a builder image named sakuli-s2i based on the Dockerfile of this repository.
```
docker build -t sakuli-s2i .
```
The builder image can also be created by using the *make* command since a *Makefile* is included.

Once the image has finished building, the command *s2i usage sakuli-s2i* will print out the help info that was defined
in the *usage* script.

#### Testing the builder image
The builder image can be tested using the following commands:
```
docker build -t sakuli-s2i-candidate .
IMAGE_NAME=sakuli-s2i-candidate test/run
```
The builder image can also be tested by using the *make test* command since a *Makefile* is included.

#### Creating the application image
The image combines the builder image with your test source code, which is served using the sakuli2 docker image,
compiled using the *assemble* script, and run using the *run* script.
The following command will create the image containing a sample test:
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

#### Build pipeline
To run the whole pipeline consisting of a build step, a test step covering the container consistency, build 
functionality and e2e tests and a pre-release step where the container image is tagged to be pushed to docker.io.
To run the pipeline, just start the `build.sh` script.
```shell script
sh build.sh
```

#### Releasing the image
After the build pipeline has been finished and the image has been prepared for release, releasing the image can be done
using the `release` script in the make file.  
_Note: Before you release, make sure that the sakuli version is correctly set in the makefile_
```shell script
make release
```
 