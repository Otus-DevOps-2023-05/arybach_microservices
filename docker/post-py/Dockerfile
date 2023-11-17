FROM python:3.6.0-alpine

# Install build dependencies
RUN apk add --no-cache --virtual .build-deps gcc musl-dev libffi-dev openssl-dev make

WORKDIR /app

ADD . /app

# Install Python dependencies
RUN pip install -v -r /app/requirements.txt

# Remove build dependencies if no longer needed
RUN apk del .build-deps

# Use environment variables for database host and name
ENV POST_DATABASE_HOST=${POST_DATABASE_HOST} POST_DATABASE=${POST_DATABASE}

CMD ["python3", "post_app.py"]
