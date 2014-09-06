CONF_FILE=parsesetup_cfg.py

encrypt_cfg:
	openssl cast5-cbc -e -in ${CONF_FILE} -out ${CONF_FILE}.cast5
decrypt_cfg:
	openssl cast5-cbc -d -in ${CONF_FILE}.cast5 -out ${CONF_FILE}
