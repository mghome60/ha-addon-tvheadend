#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: generic
# Set up a relevant name in container env
# ==============================================================================

HAA_NAME=${HAA_NAME:-$(hostname -s| sed 's/.*-//')}
echo -n ${HAA_NAME} >/run/s6/container_environment/HAA_NAME

exit 0
