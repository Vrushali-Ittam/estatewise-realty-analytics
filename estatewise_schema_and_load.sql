-- =====================================================================
-- ESTATEWISE REALTY ANALYTICS PROJECT
-- Schema creation + CSV load script (MySQL Workbench)
-- Prepared by: Aishwarya Mate
-- =====================================================================

DROP DATABASE IF EXISTS estatewise_realty;
CREATE DATABASE estatewise_realty;
USE estatewise_realty;

-- ---------------------------------------------------------------------
-- 1. PROPERTIES TABLE (property master)
-- ---------------------------------------------------------------------
CREATE TABLE properties (
    property_id        VARCHAR(10)     PRIMARY KEY,
    project_name        VARCHAR(100)    NOT NULL,
    builder             VARCHAR(100)    NOT NULL,
    city                VARCHAR(50)     NOT NULL,
    locality            VARCHAR(50)     NOT NULL,
    property_type       VARCHAR(30)     NOT NULL,
    bhk                 INT             NOT NULL,
    area_sqft           INT             NOT NULL,
    price_per_sqft      INT             NOT NULL,
    base_price          BIGINT          NOT NULL,
    floor_number        INT             DEFAULT 0,
    total_floors        INT             DEFAULT 0,
    possession_status   VARCHAR(30)     NOT NULL,
    amenities_score      INT             NOT NULL,
    year_built           INT             NOT NULL
);

-- ---------------------------------------------------------------------
-- 2. PROPERTY_BOOKINGS TABLE (sale/booking transactions)
-- ---------------------------------------------------------------------
CREATE TABLE property_bookings (
    transaction_id      VARCHAR(10)     PRIMARY KEY,
    booking_date         DATE            NOT NULL,
    property_id          VARCHAR(10)     NOT NULL,
    buyer_id             VARCHAR(10)     NOT NULL,
    buyer_name           VARCHAR(100)    NOT NULL,
    buyer_city           VARCHAR(50),
    agent_name           VARCHAR(100),
    sales_channel        VARCHAR(30),
    base_price            BIGINT          NOT NULL,
    discount_pct          INT             DEFAULT 0,
    discount_amount      BIGINT          DEFAULT 0,
    sale_price            BIGINT          NOT NULL,
    payment_mode          VARCHAR(30),
    loan_amount           BIGINT          DEFAULT 0,
    down_payment          BIGINT          DEFAULT 0,
    CONSTRAINT fk_booking_property FOREIGN KEY (property_id) REFERENCES properties(property_id)
);

-- Helpful indexes for the analysis tasks
CREATE INDEX idx_booking_date ON property_bookings(booking_date);
CREATE INDEX idx_booking_agent ON property_bookings(agent_name);
CREATE INDEX idx_properties_city ON properties(city);

-- =====================================================================
-- LOADING THE CSV FILES (choose ONE method)
-- =====================================================================

-- ---------------------------------------------------------------------
-- METHOD A (Recommended for students): Table Data Import Wizard
-- In MySQL Workbench:
--   1. Run the CREATE TABLE statements above first (or let the wizard
--      create the table for you, then verify data types).
--   2. Navigator panel -> right-click "estatewise_realty" -> Table Data
--      Import Wizard.
--   3. Browse to properties.csv -> Next -> choose "Use existing table:
--      properties" -> map columns (they match automatically since the
--      CSV headers equal the column names) -> Next -> Finish.
--   4. Repeat the wizard for property_bookings.csv -> existing table
--      "property_bookings".
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- METHOD B: LOAD DATA INFILE (faster, needs local_infile enabled and
-- file placed in MySQL's secure-file-priv directory, or use LOAD DATA
-- LOCAL INFILE from the file's actual path on your machine)
-- ---------------------------------------------------------------------

-- SET GLOBAL local_infile = 1;

-- LOAD DATA LOCAL INFILE 'properties.csv'
-- INTO TABLE properties
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 ROWS
-- (property_id, project_name, builder, city, locality, property_type, bhk,
--  area_sqft, price_per_sqft, base_price, floor_number, total_floors,
--  possession_status, amenities_score, year_built);

-- LOAD DATA LOCAL INFILE 'property_bookings.csv'
-- INTO TABLE property_bookings
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n'
-- IGNORE 1 ROWS
-- (transaction_id, booking_date, property_id, buyer_id, buyer_name, buyer_city,
--  agent_name, sales_channel, base_price, discount_pct, discount_amount,
--  sale_price, payment_mode, loan_amount, down_payment);

-- =====================================================================
-- QUICK VALIDATION AFTER LOADING
-- =====================================================================
-- SELECT COUNT(*) AS property_count FROM properties;              -- expect 140
-- SELECT COUNT(*) AS booking_count FROM property_bookings;        -- expect 2600
-- SELECT MIN(booking_date), MAX(booking_date) FROM property_bookings; -- 2024-01-01 to 2025-12-28
