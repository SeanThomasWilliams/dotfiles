#!/bin/bash

modutil -dbdir sql:.pki/nssdb/ -list

modutil -dbdir sql:.pki/nssdb/ -add "CAC Module" -libfile /usr/lib/x86_64-linux-gnu/opensc-pkcs11.so

modutil -dbdir sql:.pki/nssdb/ -list
