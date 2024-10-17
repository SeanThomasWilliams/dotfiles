#!/bin/bash

cert_count=0
bundle="ca-bundle.pem"

# Use a here document for the awk script to handle quoting easily and pass the filename
cat > /tmp/parse.awk << 'AWK_SCRIPT'
/-----BEGIN CERTIFICATE-----/ {
    in_cert = 1; cert = ""; cert = cert $0 "\n"; next;
}

/-----END CERTIFICATE-----/ {
    cert = cert $0 "\n";
    in_cert = 0;

    # Write the certificate to a temporary file
    tmpfile = "/tmp/cert_" ++cert_count ".pem";
    print cert > tmpfile;
    close(tmpfile);

    # Use openssl to get the subject and extract the Common Name (CN)
    cmd = "openssl x509 -noout -subject -in " tmpfile;
    cmd | getline subject;
    close(cmd);

    print("Subject: " subject) > "/dev/stderr"

    # Extract CN from the subject using awk's regex
    if (match(subject, /CN ?= ?([^,]+)/, arr)) {
        cn = arr[1];
    } else {
        cn = "unknown_cn_" cert_count;
    }

    # Sanitize CN to make it a valid filename
    gsub(/[^a-zA-Z0-9_-]/, "_", cn);

    # Write the certificate to a file named after the CN
    outfilename = cn ".crt";
    print "Writing certificate to " outfilename > "/dev/stderr";
    print cert > outfilename;
    close(outfilename);

    # Clean up temp file
    system("rm -f " tmpfile);

    # Increment cert count
    cert_count++;
}

in_cert == 1 {
    cert = cert $0 "\n";
}

END {
    print "Parsed " cert_count " certificates from " FILENAME > "/dev/stderr";
}

AWK_SCRIPT

awk -f /tmp/parse.awk "$bundle"

rm-f /tmp/parse.awk
