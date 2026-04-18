# 🛒 Ecommerce Management System Dashboard

A full-stack data analytics dashboard built with **PHP**, **MySQL**, **Chart.js**, and **Looker Studio** — featuring live data visualizations pulled directly from a relational database.

---

## 📸 Preview

> Dashboard live at: `http://localhost/ecommerce/index.html`  
> Looker Studio Report: [View Report](https://lookerstudio.google.com/reporting/211e9680-27dc-4ad5-a12a-d46d6a2f6933/page/sGtuF)

---

## 🧰 Tech Stack

| Layer | Technology |
|---|---|
| Database | MySQL (via XAMPP) |
| Backend API | PHP 8+ |
| Frontend | HTML, CSS, JavaScript |
| Charts | Chart.js |
| BI Report | Google Looker Studio |
| Server | Apache (XAMPP) |

---

## 📁 Project Structure

```
ecommerce/
│
├── index.html                   # Main dashboard UI
├── db.php                       # Database connection
│
├── total_revenue.php            # API → total revenue
├── monthly_revenue.php          # API → revenue by month
├── top_products.php             # API → top 5 products by sales
├── most_active_customer.php     # API → top 5 customers by orders
├── category_sales.php           # API → sales by category
│
└── Ecommerce_management_system.sql   # Full database schema + queries
```

---

## 🗄️ Database Schema

The database was built from a **20,000 row CSV dataset** and normalized into the following tables:

```
temp_orders       → raw import table (dropped after normalization)
Categories        → product categories
Customers         → unique customer records
Products          → product catalog with category FK
Orders            → order headers with customer FK
Order_Items       → line items with product FK
Payments          → payment records
Reviews           → customer product reviews
Cart              → shopping cart
Coupons           → discount codes
```

### Relationships
- `Products` → `Categories` (many-to-one)
- `Orders` → `Customers` (many-to-one)
- `Order_Items` → `Orders`, `Products` (many-to-one each)
- `Reviews` → `Customers`, `Products`

### Trigger
A trigger `update_stock_after_order` automatically decrements `stock_qty` in `Products` after every new `Order_Items` insert.

---

## 📊 Dashboard Features

- **Total Revenue** — sum of all order item sales
- **Monthly Revenue Chart** — line chart showing revenue trend over time
- **Top 5 Products** — horizontal bar chart by units sold
- **Category Sales** — doughnut chart by category
- **Most Active Customers** — ranked table with activity bars
- **Looker Studio Report** — embedded interactive report with filters

---

## 🚀 Setup Instructions

### Prerequisites
- [XAMPP](https://www.apachefriends.org/) installed
- MySQL running on port `4306` (or update `db.php` accordingly)

### Steps

**1. Clone the repository**
```bash
git clone https://github.com/YOUR_USERNAME/ecommerce-dashboard.git
```

**2. Move to XAMPP htdocs**
```bash
mv ecommerce-dashboard C:/xampp/htdocs/ecommerce
```

**3. Import the database**
- Open phpMyAdmin → `http://localhost/phpmyadmin`
- Create a new database called `ecommerce_management_system`
- Click **Import** → select `Ecommerce_management_system.sql` → click **Go**

**4. Configure the connection**

Open `db.php` and update if needed:
```php
$host     = "localhost";
$user     = "root";
$password = "";
$database = "ecommerce_management_system";
$port     = 4306; // change to 3306 if using default MySQL port
```

**5. Start Apache & MySQL in XAMPP, then visit:**
```
http://localhost/ecommerce/index.html
```

---

## 🔍 Sample SQL Queries

**Top selling products:**
```sql
SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM Order_Items oi
JOIN Products p ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 5;
```

**Monthly revenue:**
```sql
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
       SUM(oi.quantity * oi.unit_price) AS revenue
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;
```

**Most active customers:**
```sql
SELECT c.full_name, COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.full_name
ORDER BY total_orders DESC
LIMIT 5;
```

---

## 👤 Author

Made with 💜 — feel free to fork and star ⭐ if you found this useful!
