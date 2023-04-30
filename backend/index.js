const {client ,connectToDB} = require('./db.js');
const cors = require('cors');
const express = require('express');
const Account = require('./routes/accounts');

const app = express();
app.use(cors());
connectToDB();

const port = 5000;

app.use(express.json());

app.use('/api/accounts/', require('./routes/accounts'));

app.listen(port, () => {
    console.log(`Banking server backend listening at http://localhost:${port}`);
})