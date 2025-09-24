FROM python:3.12

RUN mkdir -p /home/app

WORKDIR  /home/app

COPY ./requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

COPY . /home/app

CMD [ "python3", "ETL.py" ]
