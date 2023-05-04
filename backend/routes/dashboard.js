const express = require('express');
const router = express.Router();
const client = require('../db').client;
const fetchuser = require('../middleware/fetchUser');
// const { body, validationResult } = require('express-validator');


const isauthenticated = (req, res, next) => {
    console.log('cookies', req.cookies);
    console.log('cookies user', req.cookies.user);
    if (req.cookies.user) {
        console.log(`logged in with ${req.cookies.user.name}`);
        next();
    }
    else
        console.log('not logged in');
};

// ROUTE 1: Get all the accounts
router.get('/info', fetchuser, (req, res) => {
    res.json({message : 'working'});
});

module.exports = router;