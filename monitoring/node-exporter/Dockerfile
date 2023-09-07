FROM prom/node-exporter:v0.15.2

# Default command to run the exporter with specific flags
CMD ["--path.procfs=/host/proc", "--path.sysfs=/host/sys", "--collector.filesystem.ignored-mount-points=^/(sys|proc|dev|host|etc)($|/)"]
