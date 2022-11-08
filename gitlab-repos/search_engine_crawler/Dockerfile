FROM python:3.6-alpine

WORKDIR /app

COPY requirements.txt /app

RUN pip install -r requirements.txt

COPY ./crawler /app

ENV MONGO mongodb
ENV MONGO_PORT 27017
ENV RMQ_HOST rabbitmq
ENV RMQ_QUEUE queue
ENV RMQ_USERNAME rabbit_user0
ENV RMQ_PASSWORD rabbit_pass0
ENV CHECK_INTERVAL 30
ENV EXCLUDE_URLS='.*github.com'
ENV CRAWLER_URL='https://vitkhab.github.io/search_engine_test_site/'

ENTRYPOINT python -u crawler.py ${CRAWLER_URL}
