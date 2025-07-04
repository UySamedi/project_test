# 🛍️ Product CRUD App

A full-stack CRUD application for managing products using **Node.js**, **Express**, **MySQL**, and **Flutter** with **Provider** for state management.

---

## 📁 Project Structure

---

## 🚀 Getting Started

### 🔧 Backend Setup

1. **Navigate to the backend folder:**
   ```bash
   
   cd backend
2. **- Create a .env file in the backend directory with the following content:**
   ```bash
    DB_HOST=127.0.0.1
    DB_PORT=3306
    DB_DATABASE=productdb
    DB_USER=root
    DB_PASSWORD=root
    PORT=3000
3. **Install dependencies:**
   ```bash

   npm install
4. **Start the server:**
   ```bash

   npm start
5. **Set up the MySQL database:**
   ```bash

    CREATE DATABASE ProductDB;
    USE ProductDB;
    
    CREATE TABLE PRODUCTS (
        PRODUCTID INT AUTO_INCREMENT PRIMARY KEY,
        PRODUCTNAME VARCHAR(100) NOT NULL,
        PRICE DECIMAL(10, 2) NOT NULL,
        STOCK INT NOT NULL
    );
6. **View products:**
   ```bash

   SELECT * FROM productdb.products;

### 🔧 frontend Setup
1. **Navigate to the frontend folder:**
   ```bash
   
   cd frontend
2. **Get packages:**
   ```bash
   
   flutter pub get
3. **Run the app:**
   ```bash
     flutter run
### 🌐 API Base URL
**The Flutter app connects to the backend at:**
   ```bash
   http://10.0.2.2:3000



   
   
