FROM taconsol/sakuli:2.1.3

LABEL io.openshift.s2i.scripts-url=image:///opt/s2i
LABEL io.openshift.s2i.destination=/tmp
ENV SAKULI_TEST_SUITE /headless/sakuli_test_suite

USER root

COPY s2i/* /opt/s2i/
RUN chmod 775 /opt/s2i/* && \
    mkdir -p ${SAKULI_TEST_SUITE} && \
    chmod -R 775 ${SAKULI_TEST_SUITE} && \
    chgrp -R root ${SAKULI_TEST_SUITE}

USER 1000

ENTRYPOINT []
CMD ["/opt/sakuli/s2i/usage"]