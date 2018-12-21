var express = require('express');
var app = express();
var port = 3001;

app.get('/', (req, res) => res.sendFile(__dirname + '/index.html'));
app.get('/action_cable.js', (req, res) => res.sendFile(__dirname + '/action_cable.js'));

app.listen(port, () => console.log(`Example app listening on port ${port}!`));