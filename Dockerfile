FROM python:3.12-slim
RUN useradd -u 1001 python
WORKDIR /home/python
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc python3-dev libpcre2-dev \
        libexpat1 && \
    rm -rf /var/lib/apt/lists/*
COPY payment.ini payment.py rabbitmq.py requirements.txt ./
RUN pip install -r requirements.txt && \
    apt-get purge -y --auto-remove gcc python3-dev libpcre2-dev && \
    rm -rf /var/lib/apt/lists/*
    # libexpat1 stays: it is a runtime dep of uwsgi.
    # Explicitly listed packages are NOT removed by --auto-remove.
ENTRYPOINT ["uwsgi", "--ini", "payment.ini"]
