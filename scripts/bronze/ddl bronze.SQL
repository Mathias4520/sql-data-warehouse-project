/*
================================================================================
DDL Script: Create Bronze Tables
================================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables
    if they already exist.
    Run this script to re-define the DDL structure of 'bronze' Tables
================================================================================
*/

create database DataWarehouse;

use DataWarehouse;

create schema bronze;
go
create schema silver;
go
create schema gold;
go

-- DDL Create Table
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_material_status NVARCHAR(50),
    cst_gndr NVARCHAR(50),
    cst_create_date DATE
);

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
    prd_id INT,
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE
);

IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

IF OBJECT_ID('bronze.erp_CUST_AZ12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_CUST_AZ12;
CREATE TABLE bronze.erp_CUST_AZ12 (
    CID NVARCHAR(50),
    BDATE DATE,
    GEN NVARCHAR(50),
);

IF OBJECT_ID('bronze.erp_LOC_A101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_LOC_A101;
CREATE TABLE bronze.erp_LOC_A101 (
    CID NVARCHAR(50),
    CNTRY NVARCHAR(50)
);

IF OBJECT_ID('bronze.erp_PX_CAT_G1V2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_PX_CAT_G1V2;
CREATE TABLE bronze.erp_PX_CAT_G1V2 (
    ID NVARCHAR(50),
    CAT NVARCHAR(50),
    SUBCAT NVARCHAR(50),
    MAINTENANCE NVARCHAR(50)
);

/*
================================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
================================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
================================================================================
*/

EXEC bronze.load_bronze

CREATE OR ALTER PROCEDURE bronze.load_bronze as 
BEGIN
    DECLARE @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
    BEGIN TRY
        set @batch_start_time = getdate();
        print '======================';
        print 'Loading Bronze Layer';
        print '======================';

        print '----------------------';
        print 'Loading CRM Tables';
        print '----------------------';
        
        set @start_time = GETDATE();
        print '>> Truncating Table: bronze.crm_cust_info';
        Truncate table bronze.crm_cust_info;

        print '>> Inserting Data Into: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\dustm\OneDrive\Desktop\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK 
        );
        set @end_time = GETDATE();
        print '>>> Load Duration: ' + cast(datediff(second,@start_time, @end_time) as nvarchar) + ' Seconds';
        print '>>> ---------------';

        set @start_time = GETDATE();
        print '>> Truncating Table: bronze.crm_prd_info';
        Truncate table bronze.crm_prd_info;

        print '>> Inserting Data Into: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\dustm\OneDrive\Desktop\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK 
        );
        set @end_time = GETDATE();
        print '>>> Load Duration: ' + cast(datediff(second,@start_time, @end_time) as nvarchar) + ' Seconds';
        print '>>> ---------------';

        set @start_time = GETDATE();
        print '>> Truncating Table: bronze.crm_sales_details';
        Truncate table bronze.crm_sales_details;

        print '>> Inserting Data Into: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\dustm\OneDrive\Desktop\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK 
        );
        set @end_time = GETDATE();
        print '>>> Load Duration: ' + cast(datediff(second,@start_time, @end_time) as nvarchar) + ' Seconds';
        print '>>> ---------------';

        print '----------------------';
        print 'Loading ERP Tables';
        print '----------------------';

        set @start_time = GETDATE();
        print '>> Truncating Table: bronze.erp_CUST_AZ12';
        Truncate table bronze.erp_CUST_AZ12;

        print '>> Inserting Data Into: bronze.erp_CUST_AZ12';
        BULK INSERT bronze.erp_CUST_AZ12
        FROM 'C:\Users\dustm\OneDrive\Desktop\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK 
        );
        set @end_time = GETDATE();
        print '>>> Load Duration: ' + cast(datediff(second,@start_time, @end_time) as nvarchar) + ' Seconds';
        print '>>> ---------------';


        set @start_time = GETDATE();
        print '>> Truncating Table: bronze.erp_LOC_A101';
        Truncate table bronze.erp_LOC_A101;

        print '>> Inserting Data Into: bronze.erp_LOC_A101';
        BULK INSERT bronze.erp_LOC_A101
        FROM 'C:\Users\dustm\OneDrive\Desktop\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK 
        );
        set @end_time = GETDATE();
        print '>>> Load Duration: ' + cast(datediff(second,@start_time, @end_time) as nvarchar) + ' Seconds';
        print '>>> ---------------';


        set @start_time = GETDATE();
        print '>> Truncating Table: bronze.erp_PX_CAT_G1V2';
        Truncate table bronze.erp_PX_CAT_G1V2;

        print '>> Inserting Data Into: bronze.erp_PX_CAT_G1V2';
        BULK INSERT bronze.erp_PX_CAT_G1V2
        FROM 'C:\Users\dustm\OneDrive\Desktop\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK 
        );
        set @end_time = GETDATE();
        print '>>> Load Duration: ' + cast(datediff(second,@start_time, @end_time) as nvarchar) + ' Seconds';
        print '>>> ---------------';

        set @batch_end_time = getdate()
        print '============================================='
        print ' Loading Bronze Layer is Completed';
        print ' - Total Load Duration: ' + cast(datediff(second, @batch_start_time, @batch_end_time) as Nvarchar) + ' seconds';
        print '============================================='
    end try
    begin catch
        print '============================================='
        print 'Error occured during loading bronze layer'
        print 'Error Message' + ERROR_MESSAGE();
        print 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
        print 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
        print '============================================='
    end catch 
END
