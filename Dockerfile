FROM python:3.12-slim
RUN useradd -u 1001 python
WORKDIR /home/python
# Install build tools needed to compile uwsgi from source
# Cleaned up after pip install to keep image size small
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc python3-dev libpcre3-dev && \
    rm -rf /var/lib/apt/lists/*
COPY payment.ini payment.py rabbitmq.py requirements.txt ./
RUN pip install -r requirements.txt && \
    apt-get purge -y --auto-remove gcc python3-dev libpcre3-dev
ENTRYPOINT ["uwsgi", "--ini", "payment.ini"]
