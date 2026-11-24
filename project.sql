
-- =====================================================
-- RETAIL SUPPLY CHAIN & WAREHOUSING ANALYTICS
-- Database: NorthPeak Retail Supply Co.
-- Tool: MySQL Workbench
-- =====================================================

-- 1. CREATE DATABASE
CREATE DATABASE IF NOT EXISTS retail_supply_chain;

USE retail_supply_chain;


-- 2. CREATE WAREHOUSES TABLE
CREATE TABLE IF NOT EXISTS warehouses (
    warehouse_id VARCHAR(10) PRIMARY KEY,
    warehouse_name VARCHAR(150),
    city VARCHAR(100),
    warehouse_type VARCHAR(50),
    storage_capacity_units INT,
    region VARCHAR(50),
    opened_date DATE
);


-- 3. CREATE SUPPLIERS TABLE
CREATE TABLE IF NOT EXISTS suppliers (
    supplier_id VARCHAR(10) PRIMARY KEY,
    supplier_name VARCHAR(150),
    city VARCHAR(100),
    supplier_category VARCHAR(50),
    reliability_rating DECIMAL(4,2),
    contract_since DATE
);


-- 4. CREATE STAFF TABLE
CREATE TABLE IF NOT EXISTS staff (
    staff_id VARCHAR(10) PRIMARY KEY,
    staff_name VARCHAR(150),
    hire_date DATE,
    rating DECIMAL(4,2),
    employment_type VARCHAR(50),
    is_active VARCHAR(10)
);


-- 5. CREATE VEHICLES TABLE
CREATE TABLE IF NOT EXISTS vehicles (
    vehicle_id VARCHAR(10) PRIMARY KEY,
    vehicle_type VARCHAR(100),
    fuel_type VARCHAR(50),
    max_payload_kg DECIMAL(10,2),
    depot_warehouse_id VARCHAR(10),
    last_service_date DATE,
    is_active VARCHAR(10),
    FOREIGN KEY (depot_warehouse_id)
        REFERENCES warehouses(warehouse_id)
);


-- 6. CREATE PURCHASE ORDERS TABLE
CREATE TABLE IF NOT EXISTS purchase_orders (
    po_id VARCHAR(15) PRIMARY KEY,
    warehouse_id VARCHAR(10),
    supplier_id VARCHAR(10),
    order_date DATE,
    product_category VARCHAR(100),
    order_priority VARCHAR(50),
    quantity_ordered INT,
    total_cost DECIMAL(15,2),
    FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(warehouse_id),
    FOREIGN KEY (supplier_id)
        REFERENCES suppliers(supplier_id)
);


-- 7. CREATE SHIPMENTS TABLE
CREATE TABLE IF NOT EXISTS shipments (
    shipment_id VARCHAR(15) PRIMARY KEY,
    po_id VARCHAR(15),
    staff_id VARCHAR(10),
    vehicle_id VARCHAR(10),
    dispatch_date DATE,
    arrival_date DATE,
    status VARCHAR(50),
    shipment_attempt INT,
    distance_km DECIMAL(10,2),
    transit_duration_hrs DECIMAL(10,2),
    FOREIGN KEY (po_id)
        REFERENCES purchase_orders(po_id),
    FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id),
    FOREIGN KEY (vehicle_id)
        REFERENCES vehicles(vehicle_id)
);


-- =====================================================
-- 8. VERIFY DATABASE AND TABLES
-- =====================================================

SELECT DATABASE() AS current_database;

SHOW TABLES;


-- =====================================================
-- 9. IMPORTED DATA VALIDATION
-- Run these after importing the six CSV files.
-- =====================================================

SELECT 'warehouses' AS table_name, COUNT(*) AS total_records
FROM warehouses
UNION ALL
SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL
SELECT 'staff', COUNT(*) FROM staff
UNION ALL
SELECT 'vehicles', COUNT(*) FROM vehicles
UNION ALL
SELECT 'purchase_orders', COUNT(*) FROM purchase_orders
UNION ALL
SELECT 'shipments', COUNT(*) FROM shipments;


-- =====================================================
-- 10. BASIC BUSINESS ANALYSIS
-- =====================================================

-- Total warehouses
SELECT COUNT(*) AS total_warehouses
FROM warehouses;

-- Total suppliers
SELECT COUNT(*) AS total_suppliers
FROM suppliers;

-- Total staff
SELECT COUNT(*) AS total_staff
FROM staff;

-- Total vehicles
SELECT COUNT(*) AS total_vehicles
FROM vehicles;

-- Total purchase orders
SELECT COUNT(*) AS total_purchase_orders
FROM purchase_orders;

-- Total shipments
SELECT COUNT(*) AS total_shipments
FROM shipments;

-- Total purchase order value
SELECT ROUND(SUM(total_cost), 2) AS total_order_value
FROM purchase_orders;

-- Average order quantity
SELECT ROUND(AVG(quantity_ordered), 2) AS average_order_quantity
FROM purchase_orders;

-- List product categories
SELECT DISTINCT product_category
FROM purchase_orders;

-- List vehicle types
SELECT DISTINCT vehicle_type
FROM vehicles;

-- Count active staff
SELECT COUNT(*) AS active_staff
FROM staff
WHERE LOWER(is_active) = 'yes';


-- =====================================================
-- 11. PURCHASE ORDER ANALYSIS
-- =====================================================

-- Supplier-wise order count and spending
SELECT
    s.supplier_id,
    s.supplier_name,
    COUNT(p.po_id) AS total_orders,
    ROUND(SUM(p.total_cost), 2) AS total_order_value
FROM suppliers s
LEFT JOIN purchase_orders p
    ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY total_order_value DESC;

-- Product category-wise spending
SELECT
    product_category,
    COUNT(*) AS total_orders,
    SUM(quantity_ordered) AS total_quantity,
    ROUND(SUM(total_cost), 2) AS total_cost
FROM purchase_orders
GROUP BY product_category
ORDER BY total_cost DESC;

-- Order priority analysis
SELECT
    order_priority,
    COUNT(*) AS total_orders,
    ROUND(AVG(total_cost), 2) AS average_order_cost
FROM purchase_orders
GROUP BY order_priority
ORDER BY total_orders DESC;

-- Monthly order trend
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS order_month,
    COUNT(*) AS total_orders,
    ROUND(SUM(total_cost), 2) AS total_cost
FROM purchase_orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month;


-- =====================================================
-- 12. WAREHOUSE ANALYSIS
-- =====================================================

-- Warehouse-wise order performance
SELECT
    w.warehouse_id,
    w.warehouse_name,
    w.region,
    COUNT(p.po_id) AS total_orders,
    COALESCE(ROUND(SUM(p.total_cost), 2), 0) AS total_order_value,
    ROUND(AVG(p.quantity_ordered), 2) AS avg_quantity
FROM warehouses w
LEFT JOIN purchase_orders p
    ON w.warehouse_id = p.warehouse_id
GROUP BY w.warehouse_id, w.warehouse_name, w.region
ORDER BY total_orders DESC;

-- Region-wise order value
SELECT
    w.region,
    COUNT(p.po_id) AS total_orders,
    ROUND(SUM(p.total_cost), 2) AS total_order_value
FROM warehouses w
LEFT JOIN purchase_orders p
    ON w.warehouse_id = p.warehouse_id
GROUP BY w.region
ORDER BY total_order_value DESC;

-- Warehouse capacity
SELECT
    warehouse_id,
    warehouse_name,
    storage_capacity_units,
    warehouse_type,
    region
FROM warehouses
ORDER BY storage_capacity_units DESC;


-- =====================================================
-- 13. SHIPMENT PERFORMANCE ANALYSIS
-- =====================================================

-- Shipment status distribution
SELECT
    status,
    COUNT(*) AS total_shipments,
    ROUND(
        COUNT(*) * 100.0 /
        NULLIF((SELECT COUNT(*) FROM shipments), 0),
        2
    ) AS percentage
FROM shipments
GROUP BY status
ORDER BY total_shipments DESC;

-- Average transit time by shipment status
SELECT
    status,
    COUNT(*) AS total_shipments,
    ROUND(AVG(transit_duration_hrs), 2) AS avg_transit_hours
FROM shipments
GROUP BY status
ORDER BY avg_transit_hours DESC;

-- Shipments with multiple attempts
SELECT
    shipment_id,
    po_id,
    shipment_attempt,
    status
FROM shipments
WHERE shipment_attempt > 1
ORDER BY shipment_attempt DESC;

-- Shipment distance and duration
SELECT
    shipment_id,
    distance_km,
    transit_duration_hrs,
    ROUND(
        distance_km / NULLIF(transit_duration_hrs, 0),
        2
    ) AS average_km_per_hour
FROM shipments
WHERE transit_duration_hrs > 0
ORDER BY average_km_per_hour DESC;


-- =====================================================
-- 14. STAFF PERFORMANCE ANALYSIS
-- =====================================================

SELECT
    st.staff_id,
    st.staff_name,
    st.employment_type,
    COUNT(sh.shipment_id) AS total_shipments,
    ROUND(AVG(sh.transit_duration_hrs), 2) AS avg_transit_hours
FROM staff st
LEFT JOIN shipments sh
    ON st.staff_id = sh.staff_id
GROUP BY st.staff_id, st.staff_name, st.employment_type
ORDER BY total_shipments DESC;


-- =====================================================
-- 15. VEHICLE PERFORMANCE ANALYSIS
-- =====================================================

SELECT
    v.vehicle_id,
    v.vehicle_type,
    v.fuel_type,
    COUNT(sh.shipment_id) AS total_shipments,
    ROUND(AVG(sh.distance_km), 2) AS avg_distance_km,
    ROUND(AVG(sh.transit_duration_hrs), 2) AS avg_transit_hours
FROM vehicles v
LEFT JOIN shipments sh
    ON v.vehicle_id = sh.vehicle_id
GROUP BY v.vehicle_id, v.vehicle_type, v.fuel_type
ORDER BY total_shipments DESC;

-- Vehicle type utilization
SELECT
    v.vehicle_type,
    COUNT(sh.shipment_id) AS total_shipments,
    ROUND(AVG(sh.distance_km), 2) AS avg_distance_km
FROM vehicles v
LEFT JOIN shipments sh
    ON v.vehicle_id = sh.vehicle_id
GROUP BY v.vehicle_type
ORDER BY total_shipments DESC;


-- =====================================================
-- 16. SUPPLIER RELIABILITY AND SHIPMENT ISSUES
-- =====================================================

SELECT
    s.supplier_id,
    s.supplier_name,
    s.reliability_rating,
    COUNT(sh.shipment_id) AS total_shipments,
    SUM(
        CASE
            WHEN LOWER(sh.status) LIKE '%damage%'
              OR LOWER(sh.status) LIKE '%delay%'
              OR LOWER(sh.status) LIKE '%fail%'
            THEN 1
            ELSE 0
        END
    ) AS potential_problem_shipments
FROM suppliers s
LEFT JOIN purchase_orders p
    ON s.supplier_id = p.supplier_id
LEFT JOIN shipments sh
    ON p.po_id = sh.po_id
GROUP BY s.supplier_id, s.supplier_name, s.reliability_rating
ORDER BY potential_problem_shipments DESC;


-- =====================================================
-- 17. PURCHASE ORDERS WITH SHIPMENT DETAILS
-- =====================================================

SELECT
    p.po_id,
    p.order_date,
    p.product_category,
    p.quantity_ordered,
    p.total_cost,
    w.warehouse_name,
    s.supplier_name,
    sh.shipment_id,
    sh.status,
    sh.dispatch_date,
    sh.arrival_date,
    sh.transit_duration_hrs
FROM purchase_orders p
JOIN warehouses w
    ON p.warehouse_id = w.warehouse_id
JOIN suppliers s
    ON p.supplier_id = s.supplier_id
LEFT JOIN shipments sh
    ON p.po_id = sh.po_id
ORDER BY p.order_date DESC;


-- =====================================================
-- 18. FINAL SUMMARY
-- =====================================================

SELECT
    (SELECT COUNT(*) FROM warehouses) AS warehouses,
    (SELECT COUNT(*) FROM suppliers) AS suppliers,
    (SELECT COUNT(*) FROM staff) AS staff_members,
    (SELECT COUNT(*) FROM vehicles) AS vehicles,
    (SELECT COUNT(*) FROM purchase_orders) AS purchase_orders,
    (SELECT COUNT(*) FROM shipments) AS shipments,
    (SELECT ROUND(SUM(total_cost), 2)
     FROM purchase_orders) AS total_order_value;
USE retail_supply_chain;

SELECT 'warehouses' AS table_name, COUNT(*) AS total_records
FROM warehouses
UNION ALL
SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL
SELECT 'staff', COUNT(*) FROM staff
UNION ALL
SELECT 'vehicles', COUNT(*) FROM vehicles
UNION ALL
SELECT 'purchase_orders', COUNT(*) FROM purchase_orders
UNION ALL
SELECT 'shipments', COUNT(*) FROM shipments;

USE retail_supply_chain;

SELECT
    s.supplier_id,
    s.supplier_name,
    COUNT(p.po_id) AS total_orders,
    ROUND(SUM(p.total_cost), 2) AS total_purchase_value
FROM suppliers s
LEFT JOIN purchase_orders p
    ON s.supplier_id = p.supplier_id
GROUP BY
    s.supplier_id,
    s.supplier_name
ORDER BY total_purchase_value DESC
LIMIT 10;

SELECT
    product_category,
    COUNT(*) AS total_orders,
    SUM(quantity_ordered) AS total_quantity,
    ROUND(SUM(total_cost), 2) AS total_spending
FROM purchase_orders
GROUP BY product_category
ORDER BY total_spending DESC;

USE retail_supply_chain;

SELECT
    status,
    COUNT(*) AS total_shipments,
    ROUND(AVG(transit_duration_hrs), 2)
        AS average_transit_hours,
    ROUND(AVG(distance_km), 2)
        AS average_distance_km
FROM shipments
GROUP BY status
ORDER BY total_shipments DESC;

USE retail_supply_chain;

SELECT
    w.warehouse_id,
    w.warehouse_name,
    COUNT(sh.shipment_id) AS total_shipments,
    SUM(
        CASE
            WHEN LOWER(sh.status) = 'damaged'
            THEN 1 ELSE 0
        END
    ) AS damaged_shipments,
    SUM(
        CASE
            WHEN LOWER(sh.status) = 'delayed'
            THEN 1 ELSE 0
        END
    ) AS delayed_shipments
FROM warehouses w
JOIN purchase_orders p
    ON w.warehouse_id = p.warehouse_id
JOIN shipments sh
    ON p.po_id = sh.po_id
GROUP BY
    w.warehouse_id,
    w.warehouse_name
ORDER BY
    damaged_shipments DESC,
    delayed_shipments DESC
LIMIT 10;

USE retail_supply_chain;

SELECT
    w.warehouse_id,
    w.warehouse_name,
    COUNT(sh.shipment_id) AS total_shipments,

    SUM(
        CASE WHEN LOWER(sh.status) = 'damaged'
        THEN 1 ELSE 0 END
    ) AS damaged_shipments,

    ROUND(
        100.0 * SUM(
            CASE WHEN LOWER(sh.status) = 'damaged'
            THEN 1 ELSE 0 END
        ) / NULLIF(COUNT(sh.shipment_id), 0),
        2
    ) AS damage_rate_pct,

    SUM(
        CASE WHEN LOWER(sh.status) = 'delayed'
        THEN 1 ELSE 0 END
    ) AS delayed_shipments,

    ROUND(
        100.0 * SUM(
            CASE WHEN LOWER(sh.status) = 'delayed'
            THEN 1 ELSE 0 END
        ) / NULLIF(COUNT(sh.shipment_id), 0),
        2
    ) AS delay_rate_pct

FROM warehouses w
JOIN purchase_orders p
    ON w.warehouse_id = p.warehouse_id
JOIN shipments sh
    ON p.po_id = sh.po_id

GROUP BY w.warehouse_id, w.warehouse_name
ORDER BY damage_rate_pct DESC
LIMIT 10;

USE retail_supply_chain;

SELECT
    v.vehicle_type,
    COUNT(sh.shipment_id) AS total_shipments,

    SUM(
        CASE WHEN LOWER(sh.status) = 'damaged'
        THEN 1 ELSE 0 END
    ) AS damaged_shipments,

    ROUND(
        100.0 * SUM(
            CASE WHEN LOWER(sh.status) = 'damaged'
            THEN 1 ELSE 0 END
        ) / NULLIF(COUNT(sh.shipment_id), 0),
        2
    ) AS damage_rate_pct,

    SUM(
        CASE WHEN LOWER(sh.status) = 'delayed'
        THEN 1 ELSE 0 END
    ) AS delayed_shipments,

    ROUND(AVG(sh.transit_duration_hrs), 2)
        AS average_transit_hours

FROM vehicles v
JOIN shipments sh
    ON v.vehicle_id = sh.vehicle_id

GROUP BY v.vehicle_type
ORDER BY damage_rate_pct DESC;

USE retail_supply_chain;

SELECT
    s.supplier_id,
    s.supplier_name,
    s.reliability_rating,
    COUNT(sh.shipment_id) AS total_shipments,

    SUM(
        CASE WHEN LOWER(sh.status) = 'damaged'
        THEN 1 ELSE 0 END
    ) AS damaged_shipments,

    SUM(
        CASE WHEN LOWER(sh.status) = 'delayed'
        THEN 1 ELSE 0 END
    ) AS delayed_shipments,

    ROUND(AVG(sh.transit_duration_hrs), 2)
        AS average_transit_hours

FROM suppliers s
JOIN purchase_orders p
    ON s.supplier_id = p.supplier_id
JOIN shipments sh
    ON p.po_id = sh.po_id

GROUP BY
    s.supplier_id,
    s.supplier_name,
    s.reliability_rating

ORDER BY damaged_shipments DESC
LIMIT 10;
