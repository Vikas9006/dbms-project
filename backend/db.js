const { Client } = require('pg');

// login credentials for db
let username = 'team';
let host = 'localhost';
let database = 'project';
let password = 'team';
let port = 5432;


const client = new Client({
  user: username,
  host: host,
  database: database,
  password: password,
  port: port
});

const connectToDB = () => {
    client.connect((err) => {
        if (err)
          console.error('connection error', err.stack);
        else
          console.log(`Banking database connected at http://localhost:${port}`);
    });
};

module.exports = {client ,connectToDB};