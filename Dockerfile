# AdGuard Home on Render (DNS-over-HTTPS setup)
#
# Render setup:
#   - Runtime: Docker, paid (always-on) instance
#   - Persistent disk mounted at: /data
#   - Environment variable: PORT=3000
#
# Config and data both live under /data so one disk keeps everything.

FROM adguard/adguardhome:latest

# The official binary carries file capabilities that Render's sandbox
# rejects ("exec ...: operation not permitted"). A plain copy drops them.
RUN cp /opt/adguardhome/AdGuardHome /opt/adguardhome/AdGuardHome-nocap \
 && chmod 755 /opt/adguardhome/AdGuardHome-nocap

# Web interface / DoH port (must match the PORT env var on Render)
EXPOSE 3000

# ENTRYPOINT (not CMD): the base image already defines an ENTRYPOINT, and a CMD
# would only be appended to it as arguments, so we replace it here.
# Create the data folder on the mounted disk, then start AdGuard Home.
# -c : config file location
# -w : work dir (blocklists, query logs, stats)
# -h/-p : web interface address and port
ENTRYPOINT ["sh", "-c", "mkdir -p /data/work && exec /opt/adguardhome/AdGuardHome-nocap --no-check-update -c /data/AdGuardHome.yaml -w /data/work -h 0.0.0.0 -p 3000"]
