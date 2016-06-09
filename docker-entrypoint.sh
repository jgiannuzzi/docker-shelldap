#!/bin/sh

# if command starts with an option, prepend shelldap
if [ "${1:0:1}" = '-' ]; then
  set -- shelldap "$@"
fi

exec "$@"
