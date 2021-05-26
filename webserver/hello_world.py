from flask import Flask, render_template

app = Flask(__name__)

@app.route('/hello')
def helloIndex():
    return render_template("index.html")

@app.route('/test')
def test():
    return render_template("page2.html")

@app.route('/page')
def deploy():
    return render_template("page3.html")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port= 80)
