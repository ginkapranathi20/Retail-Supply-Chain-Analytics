# Retail Supply Chain & Warehousing Analytics

A group data analytics project focused on understanding purchase-order demand, supplier performance, warehouse operations, shipment delivery performance, and logistics resource utilization.

This project uses **MySQL, SQL, and Power BI** to analyze operational data from six related datasets, identify business patterns, and generate insights that can support better supply chain and warehousing decisions.

Completed collaboratively as part of the learning programme at **Innomatics Research Labs**.

## Table of Contents

- [Project Overview](#project-overview)
- [Business Scenario](#business-scenario)
- [Business Objectives](#business-objectives)
- [Dataset and Database](#dataset-and-database)
- [ER Diagram and Relationships](#er-diagram-and-relationships)
- [Tools and Technologies](#tools-and-technologies)
- [Key Analysis Areas](#key-analysis-areas)
- [Power BI Dashboard](#power-bi-dashboard)
- [Key Business Insights](#key-business-insights)
- [Business Recommendations](#business-recommendations)
- [Repository Structure](#repository-structure)
- [How to Run](#how-to-run)
- [Team Members](#team-members)
- [Acknowledgements](#acknowledgements)

## Project Overview

This project analyzes the operations of a retail supply chain business using six related datasets:

- Warehouses
- Suppliers
- Staff
- Vehicles
- Purchase Orders
- Shipments

Our project focuses on understanding purchasing activities, supplier contributions, warehouse ordering behavior, shipment performance, and logistics resource utilization.

We use MySQL for database creation, data management, SQL querying, and business analysis. Power BI is used to visualize key performance indicators and present findings through an interactive dashboard.

Our objective is to transform raw operational data into meaningful business insights that can help identify performance patterns and potential areas for improvement.

## Business Scenario

NorthPeak Retail Supply Co. is a retail supply chain business that manages product purchasing, multiple warehouses, suppliers, staff, vehicles, and shipments.

The company places purchase orders with different suppliers to meet product demand across its warehouses. Shipments are managed using assigned staff members and vehicles.

The business needs to understand its purchasing patterns, supplier contributions, warehouse ordering activities, shipment delivery performance, and logistics operations.

Our project uses SQL queries and Power BI visualizations to explore these activities, identify operational patterns, and support data-driven business decisions.

## Business Objectives

Our project focuses on five major business objectives.

### 1. Purchase Order Demand Analysis

- Analyze purchase-order volume across different product categories.
- Compare suppliers based on purchase-order count and purchase value.
- Examine purchase demand by supplier category.
- Analyze order quantity and spending across different priority levels.
- Identify monthly purchase-order trends.
- Identify suppliers with higher purchase-order contributions.

### 2. Warehouse Ordering Behavior

- Compare the number of purchase orders placed by each warehouse.
- Analyze total purchase value across warehouses.
- Examine regional differences in ordering activity.
- Compare ordering patterns across warehouse types.
- Calculate average order quantities across warehouses.
- Analyze monthly ordering trends.

### 3. Shipment Performance Analysis

- Analyze the distribution of delivered, delayed, damaged, and in-transit shipments.
- Compare suppliers based on shipment outcomes.
- Calculate average shipment transit duration.
- Identify warehouses with higher delayed shipment counts.
- Examine monthly shipment trends by status.
- Compare transit duration across shipment statuses.

### 4. Staff and Vehicle Performance

- Compare the number of shipments handled by staff members.
- Analyze shipment outcomes associated with staff members.
- Examine average transit duration for staff-handled shipments.
- Compare shipment usage across vehicle types.
- Evaluate average transit duration across vehicle types.
- Analyze delayed and damaged shipment counts by vehicle type.

### 5. Shipment Problems Analysis

- Identify shipment records with multiple delivery attempts.
- Analyze the distribution of shipments by attempt number.
- Examine shipment statuses among repeated-attempt records.
- Compare warehouses based on repeated-attempt shipments.
- Compare suppliers based on repeated-attempt shipments.
- Analyze missing arrival dates by shipment status.

## Dataset and Database

Our project uses six CSV datasets containing a total of **11,190 records**.

| Table | Records | Description |
|---|---:|---|
| warehouses | 30 | Warehouse details, location, type, capacity, and region |
| suppliers | 150 | Supplier details, category, location, and reliability |
| staff | 120 | Staff details, ratings, employment type, and status |
| vehicles | 90 | Vehicle details, type, fuel type, capacity, and status |
| purchase_orders | 5,000 | Purchase-order dates, suppliers, warehouses, categories, quantities, and costs |
| shipments | 5,800 | Shipment assignments, delivery status, dates, attempts, distance, and transit duration |
| **Total** | **11,190** | **Six related datasets** |

### Database Relationships

The six tables are connected using primary keys and foreign keys to support relational analysis.

## ER Diagram and Relationships

The Entity Relationship (ER) diagram represents our database structure and the relationships between the six tables.

| Relationship | Type | Description |
|---|---|---|
| Warehouses to Purchase Orders | 1:M | One warehouse can have multiple purchase orders |
| Suppliers to Purchase Orders | 1:M | One supplier can be associated with multiple purchase orders |
| Purchase Orders to Shipments | 1:M | One purchase order can have multiple shipment records |
| Staff to Shipments | 1:M | One staff member can handle multiple shipments |
| Vehicles to Shipments | 1:M | One vehicle can be used for multiple shipments |
| Warehouses to Vehicles | 1:M | One warehouse can be the depot for multiple vehicles |

### Primary and Foreign Keys

| Table | Primary Key | Foreign Keys |
|---|---|---|
| warehouses | warehouse_id | None |
| suppliers | supplier_id | None |
| staff | staff_id | None |
| vehicles | vehicle_id | depot_warehouse_id |
| purchase_orders | po_id | warehouse_id, supplier_id |
| shipments | shipment_id | po_id, staff_id, vehicle_id |

These relationships allow us to retrieve information from multiple tables using SQL JOIN operations.

## Tools and Technologies

- **MySQL:** Database creation, table management, data import, and analysis.
- **SQL:** Data retrieval, filtering, aggregation, grouping, joins, subqueries, and business analysis.
- **MySQL Workbench:** Database management and SQL query execution.
- **Power BI Desktop:** Dashboard creation, KPI visualization, and business reporting.
- **CSV:** Source format for the six datasets.
- **Microsoft PowerPoint:** Project presentation and explanation of findings.

## Key Analysis Areas

Our project covers the following business analysis areas.

### Purchase Order Demand Analysis

- Supplier-wise purchase-order analysis.
- Purchase demand by supplier category.
- Product category-wise order volume and spending.
- Order priority analysis.
- Monthly purchase-order trends.
- Top 10 suppliers by purchase value.

### Warehouse Ordering Behavior

- Warehouse-wise purchase-order counts.
- Warehouse-wise procurement spending.
- Regional ordering comparisons.
- Warehouse-type comparisons.
- Average order quantity analysis.
- Monthly warehouse ordering trends.

### Shipment Performance

- Shipment status distribution.
- Supplier-wise shipment outcomes.
- Average transit duration.
- Warehouse-wise delayed shipments.
- Monthly shipment trends.

### Staff and Vehicle Performance

- Staff-wise shipment assignments.
- Staff-wise shipment outcomes.
- Vehicle-type usage.
- Vehicle-wise transit duration.
- Delayed and damaged shipment analysis.

### Shipment Problems

- Repeated shipment attempts.
- Shipment status patterns across attempts.
- Warehouse-wise and supplier-wise repeated attempts.
- Missing arrival-date analysis.

## Power BI Dashboard

We developed an interactive Power BI dashboard to present important supply chain performance indicators.

The dashboard includes the following key performance indicators:

- Total Purchase Orders
- Total Purchase Value
- Total Shipments
- Delivered Shipments
- Damaged Shipments
- Delayed Shipments

The dashboard also includes visualizations to help understand shipment status distribution and purchase spending across product categories.

## Key Business Insights

Our SQL analysis identified several useful patterns:

- Manufacturers recorded the highest number of purchase orders among supplier categories.
- Grocery recorded the highest number of orders among product categories.
- Electronics recorded the highest purchase spending among product categories in the category analysis.
- Standard orders had the highest order count among the priority levels.
- Bulk orders contributed the highest purchase value among the priority levels.
- Supplier-wise analysis helps compare suppliers based on order volume and purchase value.
- Monthly analysis helps identify changes in purchasing activity over time.

These findings are based on the corresponding SQL query outputs. Detailed numerical results can be reviewed in the SQL analysis and project presentation.

## Business Recommendations

Based on our analysis, we recommend that the company consider the following actions:

- Monitor purchase-order demand across product categories to support better procurement planning.
- Compare supplier order volumes and purchase values when reviewing supplier performance.
- Review warehouses with unusually high or low ordering activity.
- Use monthly purchase trends to support purchasing and warehouse planning.
- Monitor shipment statuses and transit duration to identify delivery performance issues.
- Investigate suppliers and warehouses associated with higher delayed or damaged shipment counts.
- Review staff workload and shipment assignments for better resource planning.
- Evaluate vehicle utilization and maintenance information when planning transportation operations.
- Investigate shipments with repeated delivery attempts to understand possible delivery difficulties.
- Review missing arrival-date records to improve shipment data quality.

These recommendations represent possible improvement areas based on the available data.

## Repository Structure

```text
Retail_Supply_Chain_Analytics/
│
├── DataSets/
│   ├── warehouses.csv
│   ├── suppliers.csv
│   ├── staff.csv
│   ├── vehicles.csv
│   ├── purchase_orders.csv
│   └── shipments.csv
│
├── SQL_Queries/
│   └── project.sql
│
├── PowerBI/
│   └── Retail_Supply_chain_Analytics.pbix
│
├── Documentation/
│   ├── RETAIL SUPPLY CHAIN.docx
│   ├── Retail_Supply_Chain_Diagram.docx
│   ├── ER_Diagram.png
│   └── Retail_Supply_Chain_Diagram.mwb
│
├── Presentation/
│   └── retail supply chain analytics.pptx
│
└── README.md
```

## How to Run

1. Install MySQL Server and MySQL Workbench.
2. Download or clone this repository.
3. Open MySQL Workbench and connect to your MySQL server.
4. Open the `project.sql` file from the `SQL_Queries` folder.
5. Execute the database creation and table creation statements.
6. Import the six CSV datasets into their corresponding tables.
7. Execute the SQL analysis queries in the project script.
8. Review the query outputs and interpret the results.
9. Open the Power BI dashboard file from the `PowerBI` folder to explore the visualizations.

## Team Members

This project was completed collaboratively by the following three team members:

1. **Kalasikam Raga Priya**
2. **Sridevi Entha**
3. **Ginka Pranathi**

## Acknowledgements

We would like to thank **Innomatics Research Labs** for providing the learning opportunity, project guidance, and support throughout this project.

Working on this group project helped us improve our understanding of relational databases, SQL querying, data analysis, business problem-solving, and Power BI dashboard development.

---

**Project:** Retail Supply Chain & Warehousing Analytics  
**Project Type:** Group Data Analytics Project  
**Technologies:** MySQL, SQL, Power BI  
**Team Size:** 3 Members  
**Learning Programme:** Innomatics Research Labs