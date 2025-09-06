FROM gcr.io/forgerock-io/java-21:latest

# Root to install OpenSSL
USER root

# Install curl and openssl
RUN apt-get update && \
    apt-get install -y curl openssl && \
    rm -rf /var/lib/apt/lists/*

# Set environment
ENV INSTALL_DIR=/opt/ig
ENV IG_INSTANCE_DIR=/var/ig
ENV SECRET_DIR=/opt/secrets

# Copy IG distribution and pre-configured files
COPY --chown=forgerock:root . "${INSTALL_DIR}"

# Create necessary directories
RUN mkdir -p "${IG_INSTANCE_DIR}" "${SECRET_DIR}" && \
    chown -R forgerock:root "${IG_INSTANCE_DIR}" "${INSTALL_DIR}" "${SECRET_DIR}" && \
    chmod -R g+rwx "${IG_INSTANCE_DIR}" "${INSTALL_DIR}" "${SECRET_DIR}"

# Add entrypoint script
COPY --chown=forgerock:root entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Use non-root user
USER 11111

ENTRYPOINT ["/entrypoint.sh"]
