-- ============================================================
-- SUPPLY CHAIN ANALYTICS — Schema Creation
-- ============================================================

-- Enable foreign key enforcement in SQLite
PRAGMA foreign_keys = ON;

-- ─── DIMENSION: DATE ────────────────────────────────────────
CREATE TABLE IF NOT EXISTS dim_date (
    date_id       INTEGER PRIMARY KEY,
    order_date    TEXT NOT NULL,
    year          INTEGER,
    quarter       INTEGER,
    month_num     INTEGER,
    month_name    TEXT,
    week          INTEGER,
    day_of_week   TEXT,
    is_weekend    INTEGER   -- 0 = weekday, 1 = weekend
);

-- ─── DIMENSION: CUSTOMER ────────────────────────────────────
CREATE TABLE IF NOT EXISTS dim_customer (
    customer_id       INTEGER PRIMARY KEY,
    customer_segment  TEXT,
    customer_city     TEXT,
    customer_state    TEXT,
    customer_country  TEXT
);

-- ─── DIMENSION: PRODUCT ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS dim_product (
    product_card_id   INTEGER PRIMARY KEY,
    product_name      TEXT,
    category_name     TEXT,
    department_name   TEXT,
    product_price     REAL
);

-- ─── DIMENSION: GEOGRAPHY ───────────────────────────────────
CREATE TABLE IF NOT EXISTS dim_geo (
    geo_id          INTEGER PRIMARY KEY,
    market          TEXT,
    order_region    TEXT,
    order_country   TEXT,
    order_city      TEXT,
    order_state     TEXT
);

-- ─── FACT TABLE: ORDERS ─────────────────────────────────────
-- This is the center of the star. Every metric lives here.
CREATE TABLE IF NOT EXISTS fact_orders (
    order_id                    INTEGER,
    order_item_id               INTEGER,
    customer_id                 INTEGER,
    product_card_id             INTEGER,
    order_date                  TEXT,
    ship_date                   TEXT,
    shipping_mode               TEXT,
    order_item_quantity         INTEGER,
    sales_per_customer          REAL,
    order_profit_per_order      REAL,
    order_item_total            REAL,
    days_for_shipping_real      INTEGER,
    days_for_shipment_scheduled INTEGER,
    delay_days                  INTEGER,
    late_delivery_risk          INTEGER,  -- 0 or 1
    delivery_status             TEXT,
    market                      TEXT,
    order_region                TEXT,
    order_country               TEXT,

    PRIMARY KEY (order_id, order_item_id),

    FOREIGN KEY (customer_id)
        REFERENCES dim_customer(customer_id),
    FOREIGN KEY (product_card_id)
        REFERENCES dim_product(product_card_id)
);