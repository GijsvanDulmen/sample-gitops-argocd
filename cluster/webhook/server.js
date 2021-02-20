const express = require('express');
const app = express();
const fetch = require('node-fetch');

const bodyParser = require('body-parser');

// for ArgoCD certificate
process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

const handle = (req, res) => {
    let headers = {
        'Content-Type': 'application/json'
    };

    Object.keys(req.headers).forEach(key => {
        if ( key.startsWith("x-github") || key.startsWith("x-hub") ) {
            headers[key] = req.headers[key];
        }
    });

    fetch('https://argocd.'+process.env.HOSTIP+'.nip.io/api/webhook', {
        method: 'post',
        body: JSON.stringify(req.body),
        headers: headers,
    }).then(res => {
        console.log(res);
    });

    res.send("OK");
};

app.get('/webhook', (req, res) => handle(req, res));

var jsonParser = bodyParser.json();
app.post('/webhook', jsonParser, (req, res) => handle(req, res));
app.listen(8123, () => console.log("Started"));