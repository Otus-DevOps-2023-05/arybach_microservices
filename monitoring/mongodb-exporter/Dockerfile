FROM bitnami/mongodb-exporter:0.39.0

# Set environment variable if needed. It can be re-set in the compose file.
ENV MONGODB_URI=mongodb://post_db:27017/

EXPOSE 9216

# Default command to run the exporter with specific flags
CMD ["--collector.dbstats", "--collector.diagnosticdata", "--collector.topmetrics", "--web.listen-address=0.0.0.0:9216"]
