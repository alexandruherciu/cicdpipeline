from flask import Flask           # import flask
from flask import request
import subprocess
import shlex
import urllib.parse

app = Flask(__name__)             # create an app instance

@app.route("/")                   # at the end point /
def hello():                      # call method hello
    return "Hello World"         # which returns "hello world"

@app.route("/intense")                   # at the end point /
def cpustress():                      # call method cpustress
        print('Started executing cpu stress test for 60s')
        command = 'stress -c 1 -t 60'
        command = shlex.split(command)
        process = subprocess.Popen(command, stdout = subprocess.PIPE)
        return "running a cpu stress test for 60s"
@app.route("/healthz")            # pod health check for /healthz 
def healthz():                    # 
    return "OK"                   # which returns "OK" and expecting a 200

@app.route("/test")               # at the end point /test 
def test():                       # call method hello
    return "Success"              # which returns "success"

if __name__ == "__main__":        # on running python app.py
    app.run(host="0.0.0.0",port='8181')                     # run the flask app on all interfaces on port 8181
