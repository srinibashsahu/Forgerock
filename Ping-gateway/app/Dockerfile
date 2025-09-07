FROM ig-image

USER root

# Create necessary directories with proper permissions
RUN mkdir -p "$IG_INSTANCE_DIR"/config \
    && mkdir -p "$IG_INSTANCE_DIR"/scripts \
    && mkdir -p /var/ig/scripts/groovy \
    && chown -R forgerock:root "$IG_INSTANCE_DIR" \
    && chown -R forgerock:root /var/ig \
    && chmod -R 755 "$IG_INSTANCE_DIR" \
    && chmod -R 755 /var/ig

# Copy configuration files with correct ownership
COPY --chown=forgerock:root config/. "$IG_INSTANCE_DIR"/config/
COPY --chown=forgerock:root scripts/. /var/ig/scripts/groovy/scripts/

# Fix script permissions
RUN chmod -R 755 "$IG_INSTANCE_DIR"/scripts

# Switch to forgerock user for security
USER forgerock

# Set working directory
WORKDIR $IG_INSTANCE_DIR

# CMD ["sh", "-c", "${INSTALL_DIR}/bin/start.sh ${IG_INSTANCE_DIR}"]