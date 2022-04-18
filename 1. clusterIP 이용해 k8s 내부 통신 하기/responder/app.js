const express = require('express');
const app = express();
const port = 11111;
const addrFrom = '0.0.0.0';

app.get("/", (req,res) => {
    res.send("Hello i'm responder!!")
})
app.listen(port, addrFrom, () => {
    console.log('Broker API is listening on port'+port);
});