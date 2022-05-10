const express = require('express');
const axios = require('axios');
const app = express();
const port = 12345;
const addrFrom = '0.0.0.0';

app.get("/", async(req,res) => {
    try{
        const respond = await axios.get("http://responder:11111");
        console.log(respond.data)
        res.send(respond.data)
    }catch(e) {
        console.log(e)
    }
})
app.listen(port, addrFrom, () => {
    console.log('Caller Api is listening on port'+port);
});