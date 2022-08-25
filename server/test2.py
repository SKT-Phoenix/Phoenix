from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():    
    return 'Hello, World!'

if __name__ == '__main__':
    
    # ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLS)
    # ssl_context.load_cert_chain(certfile='flask.crt', keyfile='private.key', password='phoenix')
    
    app.debug = True
    app.run(host='0.0.0.0', port=3000)
        