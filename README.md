# stock_broking_dms

**Name:** PRATIK YASHWANT JADHAV 

## Tool Used: PostgreSQL 


## 📌 Introduction

The Stock Broking Database System is a PostgreSQL-based project designed to simulate real-world stock market operations. It manages stock listings, price tracking, client information, trading transactions, and audit logging.

The system focuses on maintaining data integrity, automating financial calculations, and ensuring complete traceability of transactions using triggers and JSONB-based audit logs. It demonstrates practical implementation of relational database concepts used in modern trading platforms.



## 🎯 Objectives

- Design a relational database for stock broking operations  
- Ensure data integrity using primary keys, foreign keys, and constraints  
- Automate financial calculations using generated columns 
- Implement trigger-based audit logging for tracking all changes  
- Maintain accurate and consistent transaction records  
- Improve query performance using indexing
- Simulate real-world stock trading system behavior  





## 🖥️ System Requirements

### 💻 Hardware Requirements

- Processor: Minimum Intel i3 or equivalent  
- RAM: Minimum 4 GB (8 GB recommended)  
- Storage: At least 1 GB free disk space  
- System Type: 64-bit system recommended  

---

### 🧰 Software Requirements

- Database: PostgreSQL (version 12 or above)  
- Query Tool: pgAdmin / DBeaver / psql  
- Operating System: Windows / Linux / macOS  
- Version Control (Optional): Git & GitHub  
- Text Editor / IDE: VS Code / Notepad++ / any SQL editor  

---

### 🌐 Additional Tools (Optional)

- Draw.io (for ER diagram)  
- Microsoft Word / Google Docs (for documentation)  
- Microsoft PowerPoint (for presentation)  




## 🗄️  Database Name

The database used in this project is:

**`stock_broking`**

This database is designed to manage all stock broking operations including stock details, price tracking, client information, transactions, and audit logging.

It acts as the central container for all related tables and ensures structured data storage and efficient data management.




## 🚀  Features

- 🔗 **Relational Database Design**  
  Uses well-structured tables with primary and foreign key relationships to maintain data consistency.

- ⚙️ **Generated Columns**  
  Automatically calculates important values like `total_amount` and `traded_value`, reducing manual errors.

- 📜 **Trigger-Based Audit Logging**  
  Tracks all INSERT, UPDATE, and DELETE operations using triggers and stores them in `audit_logs`.

- 🧾 **JSONB Data Storage**  
  Stores old and new data in JSONB format for flexible and efficient audit tracking.

- ⚡ **Performance Optimization**  
  Uses indexing on key columns such as `client_id` and `stock_id` to improve query performance.



## 🧩  Database Schema

The database schema consists of five main tables designed to manage stock broking operations efficiently.

---

### 📦 1. stocks_details
Stores master data of all listed stocks/companies.

**Key Columns:**
- `stock_id` (Primary Key)
- `symbol`
- `company_name`
- `exchange_name`
- `market_cap`
- `status`

---

### 📈 2. stocks_prices
Stores time-based stock price data including OHLC values.

**Key Columns:**
- `price_id` (Primary Key)
- `stock_id` (Foreign Key)
- `stock_price`
- `stock_volume`
- `open_price`, `close_price`, `high_price`, `low_price`
- `traded_value` (Generated Column)

---

### 👤 3. client_details
Stores client information and KYC details.

**Key Columns:**
- `client_id` (Primary Key)
- `first_name`, `last_name`
- `pan_number` (Unique)
- `uid_number` (Unique)
- `kyc_details`
- `mobile_number`

---

### 🔄 4. transactions_details
Stores all buy and sell transactions.

**Key Columns:**
- `transaction_id` (Primary Key)
- `client_id` (Foreign Key)
- `stock_id` (Foreign Key)
- `transaction_type` (BUY/SELL)
- `order_type` (MARKET/LIMIT)
- `status`
- `quantity`, `stock_price`
- `total_amount` (Generated Column)

---

### 📜 5. audit_logs
Stores logs of all database changes using triggers.

**Key Columns:**
- `log_id` (Primary Key)
- `client_id` (Foreign Key)
- `action` (INSERT/UPDATE/DELETE)
- `old_data`, `new_data` (JSONB)
- `ip_address`, `device_info`, `browser_info`
- `created_at`

---

### 🔗 Relationships

- One stock → Many price records (`stocks_details → stocks_prices`)
- One client → Many transactions (`client_details → transactions_details`)
- One stock → Many transactions (`stocks_details → transactions_details`)
- One transaction → Many audit logs (`transactions_details → audit_logs`)


## ⚙️  Trigger Implementation

A trigger is implemented in this project to automatically track all changes made to the `transactions_details` table.

---

### 📌 Purpose

The trigger ensures that every **INSERT, UPDATE, and DELETE** operation performed on transactions is automatically recorded in the `audit_logs` table.

This provides:
- Data traceability  
- Security and monitoring  
- Easy debugging and auditing  

---

### 🔄 Trigger Function

A PL/pgSQL function (`audit_trigger_fun`) is created to handle different types of operations:

- **INSERT** → Stores new data in JSONB format  
- **UPDATE** → Stores both old and new data  
- **DELETE** → Stores old data only  

The function uses:
- `TG_OP` → To identify operation type  
- `NEW` → New row data  
- `OLD` → Previous row data  

---





### ⚡ Trigger Definition

The trigger is defined as:

```sql
CREATE TRIGGER audit_trigger
AFTER INSERT OR UPDATE OR DELETE
ON transactions_details
FOR EACH ROW
EXECUTE FUNCTION audit_trigger_fun();



## 📜  Audit Logs

The `audit_logs` table is used to track and store all changes made to the `transactions_details` table.

---

### 📌 Purpose

The audit logging system ensures that every database operation is recorded for:

- Data security  
- Change tracking  
- Debugging  
- Compliance and auditing  

---







### 🧩 Table Description

The `audit_logs` table captures detailed information about each operation:

**Key Columns:**
- `log_id` (Primary Key)  
- `client_id` → Identifies the user performing the action  
- `action` → Type of operation (INSERT, UPDATE, DELETE)  
- `table_name` → Name of the affected table  
- `record_id` → ID of the affected record  
- `old_data` → Data before change (JSONB)  
- `new_data` → Data after change (JSONB)  
- `ip_address` → User IP address  
- `device_info` → Device used  
- `browser_info` → Browser used  
- `created_at` → Timestamp of the action  

---

### ⚙️ How It Works

- The audit logs are automatically populated using a trigger  
- No manual insertion is required  
- Each database operation creates a new log entry  

---

### 🔄 Operation Handling

- **INSERT** → Stores only `new_data`  
- **UPDATE** → Stores both `old_data` and `new_data`  
- **DELETE** → Stores only `old_data`  

---

### 🧾 JSONB Usage

The table uses JSONB format to store complete row data:

- Flexible and efficient storage  
- Allows storing structured data  
- Useful for tracking full record history  

---

### 🔁 Workflow

1. A transaction is created, updated, or deleted  
2. The trigger executes automatically  
3. The function captures the change  
4. A log entry is inserted into `audit_logs`  

---





### 🎯 Benefits

- Complete history of all changes  
- Improved system transparency  
- Helps in debugging and issue tracking  
- Supports auditing and compliance requirements  

---

### 💡 Summary

The audit_logs table provides a reliable mechanism to monitor and record all database changes, ensuring data integrity and traceability across the system.




## Overview





Designed a scalable stock trading database system in PostgreSQL featuring transaction management, audit logging with JSONB, and automated calculations using generated columns. The system simulates a real-world trading environment with a focus on data integrity, automation, and traceability.


## 🚀 Features

* Relational database design using foreign keys
* Generated columns for automatic calculations
* Trigger-based audit logging (INSERT, UPDATE, DELETE)
* JSONB storage for tracking old and new data
* Indexing for performance optimization
* Use of BIGINT and DECIMAL for scalability and accuracy

---

## 🔗  Relationships

The database is designed using relational concepts where tables are connected using foreign keys to maintain data integrity and consistency.

---

### 📦 stocks_details → 📈 stocks_prices
- **Type:** One-to-Many (1:N)  
- **Relation:** One stock can have multiple price records  

**Foreign Key:**
```sql
stocks_prices.stock_id → stocks_details.stock_id


## 🧩  Simplified ER Structure

The following represents a simplified Entity-Relationship (ER) structure of the database:

[stocks_details]
    stock_id (PK)
        │
        │ 1:N
        ▼
[stocks_prices]
    price_id (PK)
    stock_id (FK)

--------------------------------------------------

[client_details]
    client_id (PK)
        │
        │ 1:N
        ▼
[transactions_details]
    transaction_id (PK)
    client_id (FK)
    stock_id (FK)
        │
        │ 1:N (via trigger logging)
        ▼
[audit_logs]
    log_id (PK)
    client_id (FK)
    record_id


---

### 🔗 Relationship Overview

- One **stock** can have many **price records**  
- One **client** can perform many **transactions**  
- One **stock** can be involved in many **transactions**  
- One **transaction** can generate multiple **audit logs**  

---

### 📌 Notes

- Primary Keys (PK) uniquely identify records  
- Foreign Keys (FK) establish relationships between tables  
- Audit logs are generated automatically using triggers  

---

### 💡 Summary

The ER structure follows a normalized relational design where master tables (`stocks_details`, `client_details`) are connected to transactional and log tables, ensuring data consistency and scalability.


## 📊  Output

The system successfully manages stock broking operations by storing and processing data across multiple tables.


---

#### 📦 stocks_details
- Stores company and stock information  
- Example: RELIANCE, TCS, HDFCBANK


---

#### 📈 stocks_prices
- Displays stock price data with OHLC values  
- Automatically calculates `traded_value`  

---

#### 👤 client_details
- Stores registered client information with KYC details  

---

#### 🔄 transactions_details
- Records BUY and SELL transactions  
- Automatically calculates `total_amount`  

---

#### 📜 audit_logs
- Tracks all INSERT, UPDATE, DELETE operations  
- Stores old and new data in JSONB format  

---

### ⚙️ System Behavior

- Data is inserted successfully into all tables  
- Calculated fields (`total_amount`, `traded_value`) are auto-generated  
- Trigger automatically logs all transaction changes  
- Relationships between tables are maintained correctly  

---

### 🎯 Result

The database system works efficiently by:
- Maintaining accurate records  
- Automating calculations  
- Ensuring data integrity  
- Providing full audit tracking  

---







##  Screenshots


<img width="1704" height="492" alt="image" src="https://github.com/user-attachments/assets/fe4b5070-5bb9-4b5e-b0c9-10d1475c4cfb" />
<img width="1846" height="298" alt="image" src="https://github.com/user-attachments/assets/0fd7645a-5beb-40f2-bfed-3d348d67b554" />

<img width="1457" height="681" alt="image" src="https://github.com/user-attachments/assets/608a3fcc-6753-4ea3-af0b-7c96f3d723aa" />
<img width="1713" height="262" alt="image" src="https://github.com/user-attachments/assets/43b230dc-9ac1-49a1-b7a5-a95975beaa8b" />

<img width="1558" height="541" alt="image" src="https://github.com/user-attachments/assets/6c6970e7-cae4-4bbf-82dd-f385f3590537" />
<img width="1736" height="274" alt="image" src="https://github.com/user-attachments/assets/0e45895b-2c87-4788-bf36-edc24773a4db" />

<img width="1213" height="722" alt="image" src="https://github.com/user-attachments/assets/01a45a70-854d-4983-a5fa-96363d949546" />
<img width="1854" height="230" alt="image" src="https://github.com/user-attachments/assets/d90b18ea-f17a-446f-a06c-eb1c2e3a889c" />

<img width="1398" height="632" alt="image" src="https://github.com/user-attachments/assets/724c7681-6736-4f35-be16-01c6c30da28a" />
<img width="1819" height="512" alt="image" src="https://github.com/user-attachments/assets/b23e742a-bd81-477a-a48c-52a8ea7ba075" />
<img width="817" height="541" alt="image" src="https://github.com/user-attachments/assets/9bba0358-d326-4b8c-b06c-39ef83afe47c" />



## 🎯  Conclusion

The Stock Broking Database System successfully demonstrates the design and implementation of a real-world trading database using PostgreSQL.

The project effectively manages stock data, client information, transactions, and audit logs while ensuring data integrity through constraints and relationships.

Key features such as generated columns enable automatic calculation of financial values, and trigger-based audit logging ensures complete traceability of all operations.

The system is scalable, efficient, and structured, making it suitable for handling large datasets and real-time trading scenarios.

Overall, this project highlights strong understanding of relational database design, PostgreSQL features, and practical implementation of a financial system.
