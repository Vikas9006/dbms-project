import { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import Table from 'react-bootstrap/Table';

function UserAccounts() {
    const [accounts, setAccounts] = useState([]);
    const { userId } = useParams();
    const url = 'http://localhost:5000/api/accounts';
    console.log('User id = ', userId);
    useEffect(() => {
        fetch(`${url}/useraccounts/${userId}`)
            .then(response => response.json())
            .then(data => setAccounts(data))
            .catch(error => console.error(error));
    }, [userId]);

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
                {accounts.map((row) => (
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

export default UserAccounts;
