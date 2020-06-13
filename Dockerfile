FROM python:3.6

RUN apt-get update && apt-get install -y stress

# Create app directory
WORKDIR /app

# Install app dependencies
COPY src/requirements.txt ./

RUN pip install -r requirements.txt

# Bundle app source
COPY src /app

EXPOSE 8181
CMD [ "python", "app.py" ]
