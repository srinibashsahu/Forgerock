set +H
set -E
set -o pipefail +e

# global variables
podindx=$(echo "${HOSTNAME}" | grep -Eo '[0-9]+$')
path_setupLog_AM="${AM_HOME}/setup.log"
path_setupLog_DS="${DS_HOME}/setup.log"
path_setupLog_ID="${ID_HOME}/setup.log"
path_setupLog_IG="${IG_HOME}/setup.log"

function installPython() {
  echo "installing Python"
  apt-get install -y python3
  echo "done";
  echo "making python default"
  update-alternatives --install /usr/bin/python python /usr/bin/python3 2
  echo "done";
}

function removePython() {
  echo "removing Python"
  apt-get remove -y python3
  echo "done";
  echo "cleaning up packages"
  apt-get -y clean
  apt-get -y autoremove
  echo "done";
}