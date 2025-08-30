FROM eclipse-temurin:17-jdk-jammy

# Set environment variables
ENV FORGEROCK_HOME=/opt/forgerock \
    DS_HOME=/opt/forgerock/opendj \
    DEPLOYMENT_ID_PASSWORD=P@ssword123 \
    ROOT_USER_DN="cn=Directory Manager" \
    ROOT_USER_PASSWORD=P@ssword123 \
    MONITOR_USER_PASSWORD=P@ssword123 \
    HOSTNAME=localhost \
    LDAP_PORT=1389 \
    LDAPS_PORT=1636 \
    HTTPS_PORT=8443 \
    ADMIN_PORT=4444 \
    REPL_PORT=8989

WORKDIR $FORGEROCK_HOME

# Copy ForgeRock DS distribution zip (place it next to Dockerfile before building)
COPY DS-7.5.1.zip /tmp/DS-7.5.1.zip

# Unzip ForgeRock DS
RUN apt-get update && apt-get install -y unzip && \
    unzip /tmp/DS-7.5.1.zip -d $FORGEROCK_HOME && \
    rm /tmp/DS-7.5.1.zip

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
COPY ciam.ldif /ldif/ciam.ldif
RUN chmod +x /entrypoint.sh

EXPOSE 1389 1636 8443 4444 8989

ENTRYPOINT ["/entrypoint.sh"]
