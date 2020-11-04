# Sakuli Docker change log

All notable changes to this project will be documented in this file.

## Upcoming Release

- migrate set-env and add-path [(#15)](https://github.com/sakuli/sakuli-openshift-s2i/issues/15)

## v2.4.0-1

- Container does not sync sakuli project - just test suite [(#66)](https://github.com/sakuli/sakuli-docker/issues/66)
- [fixed missing release script](https://github.com/sakuli/sakuli-openshift-s2i/commit/a6770b42)

## v2.4.0

- [moved chmod to dockerfile](https://github.com/sakuli/sakuli-openshift-s2i/commit/5ad79e04)

## v2.3.0-2

- Remmina Connection Error [(#8)](https://github.com/sakuli/sakuli-openshift-s2i/issues/8)

## v2.3.0-1

- permission denied, mkdir '/headless/sakuli_test_suite/sakuli' [(#6)](https://github.com/sakuli/sakuli-openshift-s2i/issues/6)

## v2.3.0

- [Fixed test suite group](https://github.com/sakuli/sakuli-openshift-s2i/commit/ccdc09a2ee3e506716c10ade8029fc935037bdcd)
- [Corrected docker user group](https://github.com/sakuli/sakuli-openshift-s2i/commit/366bfc1c)

## v2.2.0

- [Add execute flag to script](https://github.com/sakuli/sakuli-openshift-s2i/commit/ffef2553) 
- [removed BUILDER_IMAGE_KIND -> convention is ImageStreamTag now](https://github.com/sakuli/sakuli-openshift-s2i/commit/d412fdf0) 

## v2.1.3

Initial Version
- Build sakuli containers with s2i on OpenShift