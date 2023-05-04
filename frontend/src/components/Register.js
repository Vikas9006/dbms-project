import React, { useState } from 'react';

const Register = () => {
    const [formData, setFormData] = useState({ aadhar_number: '',
                                                cust_name : '',
                                                cust_address: '',
                                                pan_number: '',
                                                income: '',
                                                password: '' });
    const url = 'http://localhost:5000/api/auth/register';
    const handleSubmit = (e) => {
        e.preventDefault();
        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(formData)
        })
            .then(response => response.json())
            .then(data => console.log(data))
            .catch(error => console.error(error));
        console.log("ho chuka");
    };

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData(prevState => ({ ...prevState, [name]: value }));
    };

    return (
        <form onSubmit={handleSubmit}>
            <label>
                Aadhar number
                <input type="text" name="aadhar_number" value={formData.aadhar_number} onChange={handleChange} />
            </label>
            <label>
                Name
                <input type="text" name="cust_name" value={formData.cust_name} onChange={handleChange} />
            </label>
            <label>
                Address
                <input type="text" name="cust_address" value={formData.address} onChange={handleChange} />
            </label>
            <label>
                Pan nuber
                <input type="text" name="pan_number" value={formData.pan_number} onChange={handleChange} />
            </label>
            <label>
                Income
                <input type="text" name="income" value={formData.income} onChange={handleChange} />
            </label>
            <label>
                Password
                <input type="password" name="password" value={formData.password} onChange={handleChange} />
            </label>
            <button type="submit">Submit</button>
        </form>
    );
};

export default Register;
