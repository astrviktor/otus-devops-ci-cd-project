FROM python:3.6.0-alpine

RUN apk update && apk add git

WORKDIR /app
RUN git clone https://github.com/express42/search_engine_crawler.git .

RUN apk --no-cache --update add build-base &&\
    pip install --no-cache --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r /app/requirements.txt && \
    apk del build-base

#ENV POST_DATABASE_HOST post_db
#ENV POST_DATABASE posts
#
#* `MONGO` - адрес `mongodb`-хоста
#* `MONGO_PORT` - порт для подключения к `mongodb`-хосту
#* `RMQ_HOST` - адрес `rabbitmq`-хоста
#* `RMQ_QUEUE` - имя очереди `rabbitmq`
#* `RMQ_USERNAME` - пользователь для подключения к `rabbitmq`-серверу
#* `RMQ_PASSWORD` - пароль пользователя
#* `CHECK_INTERVAL` - минимальное время между повторными проверками одного и того же `url`
#* `EXCLUDE_URLS` - адреса которые будут исключены из обхода записанные через запятую в формате простых регулярных выражений.

#
ENV MONGO mongodb
ENV MONGO_PORT 27017
ENV RMQ_HOST rabbitmq
ENV RMQ_QUEUE queue
ENV RMQ_USERNAME rabbit_user
ENV RMQ_PASSWORD passw0rd
ENV CHECK_INTERVAL 30
ENV EXCLUDE_URLS='.*github.com'
ENV CRAWLER_URL='https://vitkhab.github.io/search_engine_test_site/'

WORKDIR /app/crawler
ENTRYPOINT python -u crawler.py ${CRAWLER_URL}
#ENTRYPOINT [ "gunicorn", "ui:app", "-b", "0.0.0.0" ]

#ENTRYPOINT ["python", "-u", "crawler.py", "${CRAWLER_URL}"]

