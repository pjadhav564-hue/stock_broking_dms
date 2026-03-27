
CREATE DATABASE stock_broking;

CREATE TABLE stocks_details (
    stock_id        BIGINT PRIMARY KEY,
    symbol          VARCHAR(50),
    company_name    VARCHAR(100) NOT NULL,
    company_cin     VARCHAR(50)  NOT NULL,
    exchange_name   VARCHAR(10)  CHECK (exchange_name IN ('BSE', 'NSE')),
    sector          VARCHAR(50),
    market_cap      DECIMAL(20,2) NOT NULL,
    date_of_listing DATE,
    isin            VARCHAR(50),
    status          VARCHAR(10)  CHECK (status IN ('ACTIVE', 'DELISTED'))
); 

select * from stocks_details;

INSERT INTO stocks_details 
VALUES
(100000000001, 'RELIANCE', 'Reliance Industries Ltd', 'L17110MH1973PLC019786', 'NSE', 'Energy', 1500000000000.00, DATE '2000-01-01', 'INE002A01018', 'ACTIVE'),

(100000000002, 'TCS', 'Tata Consultancy Services Ltd', 'L22210MH1995PLC084781', 'NSE', 'IT', 1200000000000.00, DATE '2004-08-25', 'INE467B01029', 'ACTIVE'),

(100000000003, 'HDFCBANK', 'HDFC Bank Ltd', 'L65920MH1994PLC080618', 'BSE', 'Banking', 900000000000.00, DATE '1995-05-01', 'INE040A01034', 'ACTIVE'),

(100000000004, 'INFY', 'Infosys Ltd', 'L85110KA1981PLC013115', 'NSE', 'IT', 800000000000.00, DATE '1993-06-14', 'INE009A01021', 'ACTIVE'),

(100000000005, 'ICICIBANK', 'ICICI Bank Ltd', 'L65190GJ1994PLC021012', 'BSE', 'Banking', 700000000000.00, DATE '1998-09-17', 'INE090A01021', 'ACTIVE');


---------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE stocks_prices (
    price_id        BIGINT PRIMARY KEY,
    stock_id        BIGINT NOT NULL,
    stock_price     DECIMAL(20,2) NOT NULL,
    stock_volume    BIGINT NOT NULL,
    recorded_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    open_price      DECIMAL(20,2),
    close_price     DECIMAL(20,2),
    high_price      DECIMAL(20,2),
    low_price       DECIMAL(20,2),
    traded_value    DECIMAL(20,2)
                    GENERATED ALWAYS AS (stock_price * stock_volume) STORED,
    FOREIGN KEY (stock_id) REFERENCES stocks_details (stock_id)
);

select * from Stocks_Prices;

INSERT INTO stocks_prices 
(price_id, stock_id, stock_price, stock_volume, recorded_at, open_price, close_price, high_price, low_price)
VALUES
(200000000001, 100000000001, 2500.50, 100000, CURRENT_TIMESTAMP, 2480.00, 2500.50, 2520.00, 2475.00),

(200000000002, 100000000002, 3500.75, 80000, CURRENT_TIMESTAMP, 3480.00, 3500.75, 3525.00, 3470.00),

(200000000003, 100000000003, 1600.20, 95000, CURRENT_TIMESTAMP, 1580.00, 1600.20, 1620.00, 1575.00),

(200000000004, 100000000004, 1450.60, 70000, CURRENT_TIMESTAMP, 1430.00, 1450.60, 1475.00, 1425.00),

(200000000005, 100000000005, 900.30, 120000, CURRENT_TIMESTAMP, 880.00, 900.30, 920.00, 870.00);


----------------------------------------------------------------------------------------------------------------------------------------------------

create table Client_details( Client_id bigint primary key,First_name  varchar(100) not null,Middle_name varchar(100),
Last_name varchar(100)not null,
PAN_Number varchar(10) unique not null,UID_Number varchar(12) unique not null,
KYC_details varchar(100),Client_Address text not null,Mobile_NUmber varchar(20) not null);

select * from Client_details;

INSERT INTO client_details
(client_id, first_name, middle_name, last_name, pan_number, uid_number, kyc_details, client_address, mobile_number)
VALUES
(300000000001, 'Rahul', 'K', 'Sharma', 'ABCDE1234F', '123456789012', 'VERIFIED', 'Mumbai, Maharashtra', '9876543210'),

(300000000002, 'Priya', NULL, 'Mehta', 'PQRSX5678L', '987654321098', 'VERIFIED', 'Pune, Maharashtra', '9123456780'),

(300000000003, 'Amit', 'R', 'Patil', 'LMNOP4321Z', '456789123456', 'PENDING', 'Nagpur, Maharashtra', '9988776655'),

(300000000004, 'Sneha', NULL, 'Joshi', 'ZXCVB6789K', '789123456789', 'VERIFIED', 'Nashik, Maharashtra', '9090909090'),

(300000000005, 'Vikas', 'S', 'Gupta', 'QWERT1234Y', '321654987012', 'VERIFIED', 'Delhi, India', '8888888888');

--------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE transactions_details (
    transaction_id   BIGSERIAL PRIMARY KEY,
    client_id        BIGINT NOT NULL,
    stock_id         BIGINT NOT NULL,

    transaction_type VARCHAR(10) NOT NULL
                     CHECK (transaction_type IN ('BUY', 'SELL')),

    status           VARCHAR(20) NOT NULL
                     CHECK (status IN ('COMPLETED', 'PENDING', 'FAILED')),

    order_type       VARCHAR(10) NOT NULL
                     CHECK (order_type IN ('MARKET', 'LIMIT')),

    brokerage        DECIMAL(20,2) NOT NULL,
    stock_price      DECIMAL(20,2) NOT NULL,
    tax_stt          DECIMAL(10,2) NOT NULL,

    quantity         BIGINT NOT NULL
                     CHECK (quantity > 0),

    total_amount     DECIMAL(20,2)
                     GENERATED ALWAYS AS (stock_price * quantity) STORED,

    transaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (client_id) REFERENCES client_details (client_id),
    FOREIGN KEY (stock_id)  REFERENCES stocks_details (stock_id)
);

select * from Transactions_details;


INSERT INTO transactions_details
(client_id, stock_id, transaction_type, status, order_type, brokerage, stock_price, tax_stt, quantity, transaction_time)
VALUES
(300000000001, 100000000001, 'BUY', 'COMPLETED', 'MARKET', 50.00, 2500.50, 25.00, 10, CURRENT_TIMESTAMP),

(300000000002, 100000000002, 'BUY', 'COMPLETED', 'LIMIT', 40.00, 3500.75, 30.00, 5, CURRENT_TIMESTAMP),

(300000000003, 100000000003, 'SELL', 'COMPLETED', 'MARKET', 30.00, 1600.20, 20.00, 8, CURRENT_TIMESTAMP),

(300000000004, 100000000004, 'BUY', 'PENDING', 'LIMIT', 20.00, 1450.60, 15.00, 6, CURRENT_TIMESTAMP),

(300000000005, 100000000005, 'SELL', 'FAILED', 'MARKET', 25.00, 900.30, 10.00, 12, CURRENT_TIMESTAMP);

-------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE audit_logs (
    log_id        BIGSERIAL PRIMARY KEY,

    client_id     BIGINT NOT NULL,

    action        VARCHAR(10) NOT NULL
                  CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),

    table_name    VARCHAR(50) NOT NULL,
    record_id     BIGINT NOT NULL,

    old_data      JSONB,
    new_data      JSONB,

    ip_address    VARCHAR(50) NOT NULL,
    device_info   VARCHAR(100),
    browser_info  VARCHAR(100),

    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (client_id) REFERENCES client_details (client_id)
);

select * from Audit_logs ;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION audit_trigger_fun()
RETURNS TRIGGER AS $$
BEGIN 

IF TG_OP = 'INSERT' THEN
INSERT INTO audit_logs (
    client_id, action, table_name, record_id, new_data, 
    ip_address, device_info, browser_info
)
VALUES (
    NEW.client_id, 'INSERT', TG_TABLE_NAME, NEW.transaction_id, to_jsonb(NEW),
    'SYSTEM', 'UNKNOWN_DEVICE', 'UNKNOWN_BROWSER'
);

RETURN NEW;

ELSIF TG_OP = 'UPDATE' THEN
INSERT INTO audit_logs (
    client_id, action, table_name, record_id, old_data, new_data,
    ip_address, device_info, browser_info
)
VALUES (
    NEW.client_id, 'UPDATE', TG_TABLE_NAME, NEW.transaction_id,
    to_jsonb(OLD), to_jsonb(NEW),
    'SYSTEM', 'UNKNOWN_DEVICE', 'UNKNOWN_BROWSER'
);

RETURN NEW;

ELSIF TG_OP = 'DELETE' THEN
INSERT INTO audit_logs (
    client_id, action, table_name, record_id, old_data,
    ip_address, device_info, browser_info
)
VALUES (
    OLD.client_id, 'DELETE', TG_TABLE_NAME, OLD.transaction_id,
    to_jsonb(OLD),
    'SYSTEM', 'UNKNOWN_DEVICE', 'UNKNOWN_BROWSER'
);

RETURN OLD;

END IF;

END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER audit_trigger
AFTER INSERT OR UPDATE OR DELETE
ON transactions_details
FOR EACH ROW
EXECUTE FUNCTION audit_trigger_fun();

-----------------------------------------------------------------------------------------------------------------------------------------------

CREATE INDEX idx_transactions_client 
ON transactions_details(client_id);

CREATE INDEX idx_transactions_stock 
ON transactions_details(stock_id);

CREATE INDEX idx_stock_prices_stock 
ON stocks_prices(stock_id);

----------------------------------------------------------------------------------------------------------------------------------------------------
