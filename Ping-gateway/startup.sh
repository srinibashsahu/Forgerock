#!/bin/sh

# Load variables from env.properties into environment
if [ -f /opt/config/env.properties ]; then
  set -a   . /opt/config/env.properties
  set +a
fi

# Optionally: print for debug
# echo "JVM_OPTS=$JVM_OPTS"
# echo "JSSE_OPTS=$JSSE_OPTS"
# echo "FRAM_URL=$FRAM_URL"

# Now run your actual application, e.g.
exec java $JVM_OPTS $JSSE_OPTS -jar /opt/app/your-app.jar
