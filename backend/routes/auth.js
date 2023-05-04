const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const client = require('../db').client;
const fetchuser = require('../middleware/fetchUser');
const session = require('express-session');

const JWT_SECRET = 'harryisagoodb$oy';

// ROUTE 1: Create a user using: POST "/api/auth/register". No login required
router.post('/register', async (req, res) => {
    // try {
    console.log(req.body);
    let find_query = `SELECT * FROM customer WHERE aadhar_number = ${req.body.aadhar_number};`;
    let numbers = null;
    client.query(find_query, (errf, resf) => {
        if (errf)
            res.status(401).send(errf.stack);
        else {
            console.log('in auth');
            console.log('rowcount = ', resf.rowCount);
            if (resf.rowCount === 0) {
                let insert_query = `INSERT INTO customer (Aadhar_number, cust_name, cust_address, pan_number, income) VALUES (${req.body.aadhar_number}, '${req.body.cust_name}', '${req.body.cust_address}', ${req.body.pan_number}, ${req.body.income});`;
                console.log(insert_query);
                console.log(req.body.aadhar_number);
                client.query(insert_query, (erri, resi) => {
                    if (erri) {
                        res.status(406).send(erri.stack);
                    }
                    else {
                        // console.log(authToken);
                        //     id: req.body.aadhar_number,
                        //     name: req.body.cust_name
                        // }, { maxAge: 900000, httpOnly: false, path: '/'});
                        // const sendurl = 'http://localhost:3000/dashboard';
                        /*
                        const data = {
                            user: {
                                id: req.body.aadhar_number
                            }
                        }
                        */
                        // const authtoken = jwt.sign(data, JWT_SECRET);
                        // res.json({ authtoken });
                        // return res.json({ authToken: authToken });
                        return res.status(200).json({ status: 'Insert ho gaya' });
                    }
                });
            }
            else
                res.status(409).json({status :'User already register with this aadhar number'});
        }
    });
    // return res.status(200).json({ status: 'Working fine' });
    // let user = await User.findOne({ email: req.body.email });
    //     if (user) {
    //         return res.status(400).json({ error: 'Sorry a user with this email already exists' });
    //     }
    //     const salt = await bcrypt.genSalt(10);
    //     const secPass = await bcrypt.hash(req.body.password, salt);
    //     user = await User.create({
    //         name: req.body.name,
    //         email: req.body.email,
    //         password: secPass,
    //     });
    //     const data = {
    //         user: {
    //             id: user.id
    //         }
    //     }
    //     const authToken = jwt.sign(data, JWT_SECRET);
    //     res.json({ authToken: authToken });
    // } catch (error) {
    //     console.log(error.message);
    //     res.status(500).send("Internal server error");
    // };
});

// ROUTE 2 : Login POST "/api/auth/login". No login required
router.get('/users/login/', fetchuser, async (req, res) => {
    res.status(200).send('sab changa si');
});



module.exports = router;