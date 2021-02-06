from flask import Flask
from flask import request
from flask import redirect
from flask import make_response
import os
import json

app = Flask(__name__)

@app.errorhandler(Exception)
def server_error(err):
	app.logger.error(err)
	errorCode = 500
	errorResponse = {
		"errorCode": 500,
		"errorMessage": "Internal Server Error"
		}
	errorString = str(err)
	if errorString[0:3].isdigit() == True:
		errorCode = errorString[0:3]
		errorResponse["errorCode"] = errorString[0:3]
		errorResponse["errorMessage"] = errorString[4:]
	return errorResponse, errorCode

all_http_methods = ['GET', 'HEAD', 'POST', 'PUT', 'DELETE', 'CONNECT', 'OPTIONS', 'TRACE', 'PATCH']
@app.route('/', defaults={'path': ''}, methods = all_http_methods )
@app.route('/<path:path>')
def catch_all(path):
	default_redirect = os.getenv('DEFAULT_REDIRECT')
	redirect_config_json = os.getenv('REDIRECT_CONFIG')
	redirect_config = json.loads(redirect_config_json)

	request_domain = request.host
	final_target = default_redirect

	requestor_ip = request.remote_addr

	if request_domain in redirect_config:
		final_target = redirect_config[request_domain]
		print('Request by ' + requestor_ip + ' for ' + request_domain + ' redirected to ' + final_target, flush=True)
	else:
		print('Request by ' + requestor_ip + ' for ' + request_domain + ' redirected to default URL ' + final_target, flush=True)

	return redirect(final_target, 301)