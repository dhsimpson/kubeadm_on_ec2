const express = require('express');
const app = express();
const port = 12345;
const addrFrom = '0.0.0.0';

app.get("/", async(req,res) => {
    res.send("hello who called me? : " + req.get('host'))
})

app.get("/hello", async(req,res) => {
    res.send("hello who called me? : " + req.get('host'))
})

app.listen(port, addrFrom, () => {
    console.log('Ingress Api is listening on port'+port);
});