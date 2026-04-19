const mysql = require('mysql2/promise');
require('dotenv').config();

const pool = mysql.createPool({
  host:     process.env.DB_HOST     || 'localhost',
  port:     process.env.DB_PORT     || 3306,
  user:     process.env.DB_USER     || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME     || 'lgv_db',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Test connection on startup
pool.getConnection()
  .then(conn => {
    console.log('✅  MySQL connected successfully to database:', process.env.DB_NAME || 'lgv_db');
    conn.release();
  })
  .catch(err => {
    console.error('❌  MySQL connection FAILED:', err.message);
    console.error('    Check DB_HOST, DB_USER, DB_PASSWORD, DB_NAME in lgv-backend/.env');
  });

module.exports = pool;
