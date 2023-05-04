import React, { useState, useEffect } from 'react';
import Table from 'react-bootstrap/Table';

function Fetchaccounts() {
    const [data, setData] = useState([]);
    const url = 'http://localhost:5000/api/accounts/fetchallaccounts';
    useEffect( () => {
        async function fetchData() {
            const response = await fetch(url);
            const json = await response.json();
            console.log(json);
            setData(json);
        }

        fetchData();
    }, []);

    return (
        <Table striped bordered hover>
            <thead>
                <tr>
                    <th>Account No</th>
                    <th>Branch ID</th>
                    <th>Is open</th>
                    <th>Balance</th>
                </tr>
            </thead>
            <tbody>
                {data.map((row) => (
                    <tr key={row.account_number}>
                        <td>{row.account_number}</td>
                        <td>{row.branch_id}</td>
                        <td>{row.isopen = row.isopen ? "true" : "false"}</td>
                        <td>{row.balance}</td>
                    </tr>
                ))}
            </tbody>
        </Table>
    );
}

export default Fetchaccounts;
