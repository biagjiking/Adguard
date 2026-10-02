# AdGuard Home on Render (DNS-over-HTTPS setup)
#
# Render setup:
#   - Runtime: Docker, paid (always-on) instance
#   - Persistent disk mounted at: /data
#   - Environment variable: PORT=3000
#
# Config and data both live under /data so one disk keeps everything.

FROM adguard/adguardhome:latest

# Web interface / DoH port (must match the PORT env var on Render)
EXPOSE 3000

# Create the data folder on the mounted disk, then start AdGuard Home.
# -c : config file location
# -w : work dir (blocklists, query logs, stats)
# -h/-p : web interface address and port
CMD ["sh", "-c", "mkdir -p /data/work && exec /opt/adguardhome/AdGuardHome --no-check-update -c /data/AdGuardHome.yaml -w /data/work -h 0.0.0.0 -p 3000"]
