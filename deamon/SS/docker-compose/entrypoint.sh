#!/bin/sh -e

if [ -n "$@" ]; then
  exec "$@"
fi

# Legacy compatible:
if [ -z "$NGROK_PORT" ]; then
  if [ -n "$HTTPS_PORT" ]; then
    NGROK_PORT="$HTTPS_PORT"
  elif [ -n "$HTTPS_PORT" ]; then
    NGROK_PORT="$HTTP_PORT"
  elif [ -n "$APP_PORT" ]; then
    NGROK_PORT="$APP_PORT"
  fi
fi


ARGS="ngrok "

if [ -z "$SERVERADDR" ]; then
    echo "You need to fill in the server address for ngrok, but server_addr(SERVERADDR) is null"
    echo "Sign up for an authentication token at https://ngrok.com"
    exit 1
fi
echo "server_addr: $SERVERADDR" >> /ngrok.yml

# Set the protocol.
if [ "$NGROK_PROTOCOL" = "TCP" ]; then
  ARGS="$ARGS -proto=tcp"
elif [ "$NGROK_PROTOCOL" = "http" ]; then
  ARGS="$ARGS -proto=http"
elif [ "$NGROK_PROTOCOL" = "https" ]; then
  ARGS="$ARGS -proto=https"
fi

# Set the TLS binding flag
if [ -n "$NGROK_BINDTLS" ]; then
  ARGS="$ARGS -bind-tls=$NGROK_BINDTLS "
fi

# Set the authorization token.
if [ -n "$NGROK_AUTH" ]; then
  echo "authtoken: $NGROK_AUTH" >> ~/.ngrok/ngrok.yml
fi

# Set the subdomain or hostname, depending on which is set
# if [ -n "$NGROK_HOSTNAME" ] && [ -n "$NGROK_AUTH" ]; then
#   ARGS="$ARGS -hostname=$NGROK_HOSTNAME "
# el
if [ -n "$NGROK_SUBDOMAIN" ]; then
  ARGS="$ARGS -subdomain=$NGROK_SUBDOMAIN "
else
  NGROK_SUBDOMAIN="jay"
  ARGS="$ARGS -subdomain=jay "
fi

# Set the remote-addr if specified
if [ -n "$NGROK_REMOTE_ADDR" ]; then
  ARGS="$ARGS -remote-addr=$NGROK_REMOTE_ADDR "
fi

# Set a custom region
if [ -n "$NGROK_REGION" ]; then
  ARGS="$ARGS -region=$NGROK_REGION "
fi

if [ -n "$NGROK_HEADER" ]; then
  ARGS="$ARGS -host-header=$NGROK_HEADER "
fi

if [ -n "$NGROK_USERNAME" ] && [ -n "$NGROK_PASSWORD" ] && [ -n "$NGROK_AUTH" ]; then
  ARGS="$ARGS -auth=$NGROK_USERNAME:$NGROK_PASSWORD "
elif [ -n "$NGROK_USERNAME" ] || [ -n "$NGROK_PASSWORD" ]; then
  if [ -z "$NGROK_AUTH" ]; then
    echo "You must specify a username, password, and Ngrok authentication token to use the custom HTTP authentication."
    echo "Sign up for an authentication token at https://ngrok.com"
    exit 1
  fi
fi

if [ -n "$NGROK_DEBUG" ]; then
    ARGS="$ARGS -log stdout"
fi


if [ -n "$HTTP_AUTH" ]; then
  ARGS="$ARGS -httpauth=$HTTP_AUTH "
fi

ARGS="$ARGS -config=/ngrok.yml"

# Set the port.
if [ -z "$NGROK_PORT" ]; then
  ARGS="$ARGS 7001"
else
  ARGS="$ARGS $NGROK_PORT"
fi

echo "SUCCESS!!! URL is https://$NGROK_SUBDOMAIN.ngrok.llovex.com  or http://$NGROK_SUBDOMAIN.ngrok.llovex.com"
set -x
exec $ARGS 