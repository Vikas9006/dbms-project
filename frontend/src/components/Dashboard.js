import { useState, useEffect } from 'react';

function UserDashboard() {
    const [userData, setUserData] = useState(null);
    const url = 'http://localhost:5000/api/dashboard/info';
    async function fetchUserData() {
        const response = await fetch(url);
        const data = await response.json();
        setUserData(data);
    }

    useEffect(() => {
        fetchUserData();
    }, []);

    return (
        <div className="user-dashboard">
            {userData ? (
                <div>
                    <p>User ID: {userData.id}</p>
                    <p>User Name: {userData.name}</p>
                </div>
            ) : (
                <p>Loading...</p>
            )}
        </div>
    );
}

export default UserDashboard;
