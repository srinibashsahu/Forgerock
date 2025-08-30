echo "creating required folders"
mkdir -p ${DS_APP} ${DS_INSTANCE} ${DS_SCRIPTS} ${path_tmp}
echo "done";
echo "";

echo "loading '${MIDSHIPS_SCRIPTS}/midshipscore.sh'";
if [ -f "${MIDSHIPS_SCRIPTS}/midshipscore.sh" ]; then
  source "${MIDSHIPS_SCRIPTS}/midshipscore.sh"
  echo "done";
else
  echo "Warning: '${MIDSHIPS_SCRIPTS}/midshipscore.sh' not found"
  exit 1
fi

echo "initializing required tools"
microdnf install -y unzip procps gettext
echo "done";
echo "installing OpenSSL tools";
microdnf install -y openssl
echo "done";

echo "checking for java";
echo "java home set to: ${JAVA_HOME}";
java -version;
checkForBashErrors "$?";
echo "done";

if [ -n "${downloadpath_ds}" ] && [ -n "${path_tmp}" ] && [ -d "${filename_ds}" ]; then
  echo "downloading OpenDJ from ${downloadpath_ds}";
  curl -k ${downloadpath_ds} -o ${path_tmp}/${filename_ds}
  echo "done";
else
  echo "Warning: downloadpath_ds not set or path_tmp not set or path_tmp not a directory";
  exit 1
fi

echo "using existing user and group";
id "${username}"
echo "done";

updateUlimits "${username}" "${usergroup}"

echo "copying OpenDJ setup files"
if [ -f "${path_tmp}/${filename_ds}" ]; then
  unzip -q ${path_tmp}/${filename_ds} -d ${DS_HOME}
  if [ $? -eq 0 ]; then
    echo "done";
  else
    echo "Error: Failed to unzip ${path_tmp}/${filename_ds}";
    exit 1
  fi
else
  echo "Warning: ${path_tmp}/${filename_ds} not found";
  exit 1
fi

echo "backing up DS binaries incase needed for upgrade later";
mv ${path_tmp}/${filename_ds} ${DS_HOME}/
if [ -f "${DS_HOME}/${filename_ds}" ]; then
  echo "done";
else
  echo "Error: Failed to backup ${path_tmp}/${filename_ds}";
  exit 1
fi

echo "creating setup files folder"
mv -f ${DS_HOME}/opendj ${DS_HOME}/setupFiles
echo "files in ${DS_HOME}/setupFiles:"
ls -1 ${DS_HOME}/setupFiles
echo "done";

echo "setting permissions"
chown -R ${username}:${usergroup} ${DS_HOME} ${JAVA_CACERTS} ${DS_SCRIPTS} ${path_tmp}
chmod -R u=rwx,g=rx,o=r ${DS_HOME}/setupFiles ${JAVA_CACERTS}
ls -ltra  ${JAVA_CACERTS}
echo "done";

echo "cleaning up temporary files"
rm -rf ${path_tmp}
echo "done";