FROM python:3.6-alpine

RUN apk update && apk add git

WORKDIR /app
RUN git clone https://github.com/express42/search_engine_ui.git .

RUN apk --no-cache --update add build-base &&\
    pip install --no-cache --no-cache-dir --upgrade pip setuptools && \
    pip install --no-cache-dir -r /app/requirements.txt && \
    apk del build-base


#WORKDIR /ui
#COPY requirements.txt /ui
#RUN pip install -r requirements.txt
#COPY ./ui /ui
ENV MONGO mongodb
ENV MONGO_PORT 27017
ENV FLASK_APP ui.py
EXPOSE 8000

WORKDIR /app/ui
ENTRYPOINT [ "gunicorn", "ui:app", "-b", "0.0.0.0" ]