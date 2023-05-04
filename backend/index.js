const connectToDB  = require('./db.js').connectToDB;
const cors = require('cors');
const express = require('express');
const flash = require('connect-flash');
const session = require('express-session');
const cookieParser = require('cookie-parser');

const app = express();
app.use(cors());
connectToDB();

const port = 5000;

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(session({
    secret: 'my_secret_key',
    resave: false,
    saveUninitialized: false
  }));
app.use(cookieParser());

app.use('/api/accounts/', require('./routes/accounts'));
app.use('/api/auth/', require('./routes/auth'));
app.use('/api/dashboard/', require('./routes/dashboard'));

app.listen(port, () => {
    console.log(`Banking server backend listening at http://localhost:${port}`);
})