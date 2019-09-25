const express = require('express');

const app = express();

app.get("/", (req, res) => {
    res.send('<h1>My Node App is listening on port 80</h1>');
});

app.listen(80, () => {
    console.log('My Node App is listening on port 80');
});