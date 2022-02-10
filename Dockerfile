# sakuli-s2i
ARG BASE_IMAGE_VERSION=3.0.0
ARG BASE_IMAGE=sakuli
FROM taconsol/${BASE_IMAGE}:${BASE_IMAGE_VERSION}

LABEL maintainer="Sven Hettwer <Sven.Hettwer@consol.de>"

LABEL io.openshift.s2i.scripts-url=image:///opt/s2i \
      io.openshift.s2i.destination=/tmp

ENV SAKULI_TEST_SUITE /headless/sakuli_test_suite

USER root

COPY ./s2i/bin/* /opt/s2i/
RUN chmod 775 /opt/s2i/* && \
    mkdir -p ${SAKULI_TEST_SUITE} && \
    chmod -R 775 ${SAKULI_TEST_SUITE} ${HOME}/.config && \
    chgrp -R root ${SAKULI_TEST_SUITE} ${HOME}/.config

USER 1000

ENTRYPOINT []
CMD ["/opt/sakuli/s2i/usage"]
