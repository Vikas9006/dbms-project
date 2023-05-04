import DataTable from './components/DataTable';
import NavBar from './components/Navbar';
import React from 'react';
import { BrowserRouter, Router, Routes, Route, useLocation } from 'react-router-dom';
import NoPage from './components/NoPage';
import About from './components/About';
import Home from './components/Home';
import Register from './components/Register';
import UserDashboard from './components/Dashboard';
import UserAccounts from './components/UserAccounts';

function App() {
  // const location = useLocation();
  
  // Check if the location object exists before accessing its pathname property
  // const pathname = location ? location.pathname : '';
  return (
 <BrowserRouter>
      <NavBar />
      <Routes>
        {/* <Route path="/" element={<NavBar />}> */}
          {/* <Route index element={<Home />} /> */}
          <Route path="/about" element={<About />} />
          <Route path="/accounts/:userId" element={<UserAccounts />} />
          <Route path="/accounts" element={<DataTable />} />
          <Route path ="/register" element={<Register />} />
          <Route path ="/dashboard" element={<UserDashboard />}/>
          <Route path="*" element={<NoPage />} />
        {/* </Route> */}
      </Routes>
    </BrowserRouter>
  );
}

export default App;
