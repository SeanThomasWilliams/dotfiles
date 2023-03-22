#!/bin/bash

MODULE_PATH="/usr/lib/pkcs11/opensc-pkcs11.so"

modutil -dbdir sql:"$HOME/.pki/nssdb/" -list

modutil -dbdir sql:"$HOME/.pki/nssdb/" -add "CAC Module" -libfile "$MODULE_PATH"

modutil -dbdir sql:"$HOME/.pki/nssdb/" -list
