const express = require('express');
const router = express.Router();
const client = require('../db').client;
const fetchuser = require('../middleware/fetchUser');
// const { body, validationResult } = require('express-validator');


// ROUTE 1: Get all the accounts
router.get('/fetchallaccounts', (req, res) => {
    let query = 'SELECT * FROM account;';
    console.log(client.user);
    client.query(query, (err, resq) => {
        if (err)
            console.error(err.stack);
        else {
            console.log(fetchuser);
            res.setHeader('Content-Type', 'application/json');
            // Add this header only if you want to allow cross-origin requests
            res.setHeader('Access-Control-Allow-Origin', '*');

            // Send the JSON response
            res.statusCode = 200;
            res.end(JSON.stringify(resq.rows));
        }
    });
});

// ROUTE 2: Get all the accounts
router.get('/useraccounts/:id', (req, res) => {
    let userid = req.params.id;
    let query = 'SELECT a.* FROM account a, holds h, customer c WHERE a.account_number = h.account_number AND c.aadhar_number = h.aadhar_number;';
    console.log(client.user);
    client.query(query, (err, resq) => {
        if (err)
            console.error(err.stack);
        else {
            // console.log(fetchuser);
            res.setHeader('Content-Type', 'application/json');
            // Add this header only if you want to allow cross-origin requests
            res.setHeader('Access-Control-Allow-Origin', '*');

            // Send the JSON response
            res.statusCode = 200;
            res.end(JSON.stringify(resq.rows));
        }
    });
});


module.exports = router;