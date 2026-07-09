#!/bin/bash

# Start Apache HTTPD in the foreground
echo "Starting Apache HTTP Server..."
exec /usr/sbin/httpd -DFOREGROUND
