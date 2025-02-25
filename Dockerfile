FROM python:3.9.4-alpine3.12
COPY requirements.txt dht22mqtt.py ./
RUN apk add gcc musl-dev && \
    pip3 install -r requirements.txt --no-cache-dir && \
    apk del gcc musl-dev && \
    rm -rf /var/lib/apk/lists/* && \
    mkdir log && chmod 777 log/
CMD [ "python3", "-u", "dht22mqtt.py" ]
