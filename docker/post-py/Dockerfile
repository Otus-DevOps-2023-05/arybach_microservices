FROM python:3.6.0-alpine

# Install build dependencies
RUN apk add --no-cache --virtual .build-deps gcc musl-dev libffi-dev openssl-dev make

WORKDIR /app

ADD . /app

# Install Python dependencies
RUN pip install -v -r /app/requirements.txt

# Remove build dependencies if no longer needed
RUN apk del .build-deps

ENV POST_DATABASE_HOST=post_db POST_DATABASE=posts

CMD ["python3", "post_app.py"]
