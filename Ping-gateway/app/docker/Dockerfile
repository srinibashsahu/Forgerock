FROM gcr.io/forgerock-io/java-21:latest

# Become root to install curl
USER root

# Install curl (assuming Debian/Ubuntu-based image)
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV INSTALL_DIR /opt/ig
ENV IG_INSTANCE_DIR /var/ig

# Copy files with correct ownership
COPY --chown=forgerock:root . "${INSTALL_DIR}"

# Setup IG directories and permissions
RUN mkdir -p "${IG_INSTANCE_DIR}" \
    && chown -R forgerock:root "${IG_INSTANCE_DIR}" "${INSTALL_DIR}" \
    && chmod -R g+rwx "${IG_INSTANCE_DIR}" "${INSTALL_DIR}"

# Switch back to non-root user
USER 11111

ENTRYPOINT ${INSTALL_DIR}/bin/start.sh ${IG_INSTANCE_DIR}
