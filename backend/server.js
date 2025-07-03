const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

const mysql = require('mysql2/promise');

// Database configuration
const dbConfig = {
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_DATABASE,
    port: process.env.DB_PORT
};

let connection;

async function connectDB() {
    try {
        connection = await mysql.createConnection(dbConfig);
        console.log('Connected to MySQL');
    } catch (err) {
        console.error('Database connection error:', err);
    }
}

connectDB();

// GET all products
app.get('/products', async (req, res) => {
    try {
        const [rows] = await connection.execute('SELECT * FROM PRODUCTS');
        res.json(rows);
    } catch (err) {
        console.error('Error in /products:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// GET product by ID
app.get('/products/:id', async (req, res) => {
    try {
        const [rows] = await connection.execute('SELECT * FROM PRODUCTS WHERE PRODUCTID = ?', [req.params.id]);
        if (rows.length === 0) {
            return res.status(404).json({ error: 'Product not found' });
        }
        res.json(rows[0]);
    } catch (err) {
        console.error('Error in /products/:id:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// POST new product
app.post('/products', async (req, res) => {
    const { productName, price, stock } = req.body;
    if (!productName || price <= 0 || stock < 0) {
        return res.status(400).json({ error: 'Invalid input' });
    }
    try {
        const [result] = await connection.execute(
            'INSERT INTO PRODUCTS (PRODUCTNAME, PRICE, STOCK) VALUES (?, ?, ?)',
            [productName, price, stock]
        );
        res.status(201).json({ id: result.insertId, productName, price, stock });
    } catch (err) {
        console.error('Error in /products POST:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// PUT update product
app.put('/products/:id', async (req, res) => {
    const { productName, price, stock } = req.body;
    if (!productName || price <= 0 || stock < 0) {
        return res.status(400).json({ error: 'Invalid input' });
    }
    try {
        const [result] = await connection.execute(
            'UPDATE PRODUCTS SET PRODUCTNAME = ?, PRICE = ?, STOCK = ? WHERE PRODUCTID = ?',
            [productName, price, stock, req.params.id]
        );
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Product not found' });
        }
        res.json({ id: parseInt(req.params.id), productName, price, stock });
    } catch (err) {
        console.error('Error in /products/:id PUT:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// DELETE product
app.delete('/products/:id', async (req, res) => {
    try {
        const [result] = await connection.execute('DELETE FROM PRODUCTS WHERE PRODUCTID = ?', [req.params.id]);
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Product not found' });
        }
        res.status(204).send();
    } catch (err) {
        console.error('Error in /products/:id DELETE:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));