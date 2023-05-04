const { Pool } = require('pg');

// login credentials for db
let username = 'admin';
let host = 'localhost';
let database = 'project';
let password = 'admin';
let port = 5432;


const pool = new Pool({
  user: username,
  host: host,
  database: database,
  password: password,
  port: port
});

const connectToDB = () => {
    pool.connect((err) => {
        if (err)
          console.error('connection error', err.stack);
        else
          console.log(`Banking database connected with ${pool.user} at http://localhost:${port}`);
    });
};

module.exports = {client: pool ,connectToDB};