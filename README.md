# DataEngineer_AWS_Snowflake_DBT_Project

## 📌 Overview
This repository contains a modern data engineering pipeline built with:
- **AWS** for cloud infrastructure
- **Snowflake** as the data warehouse
- **dbt (Data Build Tool)** for data transformation and modeling

The goal is to demonstrate scalable ELT practices, including clean data modeling, historical tracking with snapshots, and analytics‑ready fact and dimension tables.

---

## 📂 Project Structure
- `my_project/` → dbt project containing models, snapshots, and configurations
- `sampledata/` → example datasets used for testing and development

---
## 🏗️ Architecture

### Data Flow
```
Source Data (CSV) → AWS S3 → Snowflake (Staging) → Bronze Layer → Silver Layer → Gold Layer
                                                           ↓              ↓           ↓
                                                      Raw Tables    Cleaned Data   Analytics
```

### Technology Stack

- **Cloud Data Warehouse**: Snowflake
- **Transformation Layer**: dbt (Data Build Tool)
- **Cloud Storage**: AWS S3 (implied)
- **Version Control**: Git
- **Python**: 3.12+
- **Key dbt Features**:
  - Incremental models
  - Snapshots (SCD Type 2)
  - Custom macros
  - Jinja templating
  - Testing and documentation

## 📊 Data Model

### Medallion Architecture

#### 🥉 Bronze Layer (Raw Data)
Raw data ingested from staging with minimal transformations:
- `bronze_bookings` - Raw booking transactions
- `bronze_hosts` - Raw host information
- `bronze_listings` - Raw property listings

#### 🥈 Silver Layer (Cleaned Data)
Cleaned and standardized data:
- `silver_bookings` - Validated booking records
- `silver_hosts` - Enhanced host profiles with quality metrics
- `silver_listings` - Standardized listing information with price categorization

#### 🥇 Gold Layer (Analytics-Ready)
Business-ready datasets optimized for analytics:
- `obt` (One Big Table) - Denormalized fact table joining bookings, listings, and hosts
- `fact` - Fact table for dimensional modeling
- Ephemeral models for intermediate transformations

### Snapshots (SCD Type 2)
Slowly Changing Dimensions to track historical changes:
- `dim_bookings` - Historical booking changes
- `dim_hosts` - Historical host profile changes
- `dim_listings` - Historical listing changes

## 📂 Project Structure - `my_project/` → dbt project containing models, snapshots, and configurations - `sampledata/` → example datasets used for testing and development

## 🚀 Getting Started

### Prerequisites

1. **Snowflake Account (will create one if doesn't exist)**

2. **Python Environment**
   - Python 3.12 or higher
   - pip or uv package manager

3. **AWS Account (will create one if doesn't exist) ** (for S3 storage)

### Installation

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd AWS_DBT_Snowflake
   ```

2. **Create Virtual Environment**
   ```bash
   python -m venv .venv
   .venv\Scripts\Activate.ps1  # Windows PowerShell
   # or
   source .venv/bin/activate    # Linux/Mac
   ```

3. **Install Dependencies**
   ```bash
   pip install -r requirements.txt
   # or using pyproject.toml
   pip install -e .
   ```

   **Core Dependencies:**
   - `dbt-core>=1.11.2`
   - `dbt-snowflake>=1.11.0`
   - `sqlfmt>=0.0.3`

4. **Configure Snowflake Connection**
   
   Create `~/.dbt/profiles.yml`:
   ```yaml
   aws_dbt_snowflake_project:
     outputs:
       dev:
         account: <your-account-identifier>
         database: AIRBNB
         password: <your-password>
         role: ACCOUNTADMIN
         schema: dbt_schema
         threads: 4
         type: snowflake
         user: <your-username>
         warehouse: COMPUTE_WH
     target: dev
   ```

5. **Set Up Snowflake Database**
   
   Run the DDL scripts to create tables:
   ```bash
   # Execute DDL/ddl.sql in Snowflake to create staging tables
   ```

6. **Load Source Data**
   
   Load CSV files from `SourceData/` to Snowflake staging schema:
   - `bookings.csv` → `AIRBNB.STAGING.BOOKINGS`
   - `hosts.csv` → `AIRBNB.STAGING.HOSTS`
   - `listings.csv` → `AIRBNB.STAGING.LISTINGS`

## 🔧 Usage

### Running dbt Commands

1. **Test Connection**
   ```bash
   cd aws_dbt_snowflake_project
   dbt debug
   ```

2. **Install Dependencies**
   ```bash
   dbt deps
   ```

3. **Run All Models**
   ```bash
   dbt run
   ```

4. **Run Specific Layer**
   ```bash
   dbt run --select bronze.*      # Run bronze models only
   dbt run --select silver.*      # Run silver models only
   dbt run --select gold.*        # Run gold models only
   ```

5. **Run Tests**
   ```bash
   dbt test
   ```

6. **Run Snapshots**
   ```bash
   dbt snapshot
   ```

7. **Generate Documentation**
   ```bash
   dbt docs generate
   dbt docs serve
   ```

8. **Build Everything**
   ```bash
   dbt build  # Runs models, tests, and snapshots
   ```

## 🎯 Key Features

### 1. Incremental Loading
Bronze and silver models use incremental materialization to process only new/changed data:
```sql
{{ config(materialized='incremental') }}
{% if is_incremental() %}
    WHERE CREATED_AT > (SELECT COALESCE(MAX(CREATED_AT), '1900-01-01') FROM {{ this }})
{% endif %}
```

### 2. Custom Macros
Reusable business logic:
- **`tag()` macro**: Categorizes prices into 'low', 'medium', 'high'
  ```sql
  {{ tag('CAST(PRICE_PER_NIGHT AS INT)') }} AS PRICE_PER_NIGHT_TAG
  ```

### 3. Dynamic SQL Generation
The OBT (One Big Table) model uses Jinja loops for maintainable joins:
```sql
{% set configs = [...] %}
SELECT {% for config in configs %}...{% endfor %}
```

### 4. Slowly Changing Dimensions
Track historical changes with timestamp-based snapshots:
- Valid from/to dates automatically maintained
- Historical data preserved for point-in-time analysis

### 5. Schema Organization
Automatic schema separation by layer:
- Bronze models → `AIRBNB.BRONZE.*`
- Silver models → `AIRBNB.SILVER.*`
- Gold models → `AIRBNB.GOLD.*`

## 📈 Data Quality

### Testing Strategy
- Source data validation tests
- Unique key constraints
- Not null checks
- Referential integrity tests
- Custom business rule tests

### Data Lineage
dbt automatically tracks data lineage, showing:
- Upstream dependencies
- Downstream impacts
- Model relationships
- Source to consumption flow

## 🔐 Security & Best Practices

1. **Credentials Management**
   - Never commit `profiles.yml` with credentials
   - Use environment variables for sensitive data
   - Implement role-based access control (RBAC) in Snowflake

2. **Code Quality**
   - SQL formatting with `sqlfmt`
   - Version control with Git
   - Code reviews for model changes

3. **Performance Optimization**
   - Incremental models for large datasets
   - Ephemeral models for intermediate transformations
   - Appropriate clustering keys in Snowflake

## 📚 Additional Resources

- **dbt Documentation**: https://docs.getdbt.com/
- **Snowflake Documentation**: https://docs.snowflake.com/
- **dbt Best Practices**: https://docs.getdbt.com/guides/best-practices

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is part of a data engineering portfolio demonstration.

## 👤 Author

Shiva Shreya Basupally
shreyareddybasu@gmail.com

## 🐛 Troubleshooting

### Common Issues

1. **Connection Error**
   - Verify Snowflake credentials in `profiles.yml`
   - Check network connectivity
   - Ensure warehouse is running

2. **Compilation Error**
   - Run `dbt debug` to check configuration
   - Verify model dependencies
   - Check Jinja syntax

3. **Incremental Load Issues**
   - Run `dbt run --full-refresh` to rebuild from scratch
   - Verify source data timestamps

## 📊 Future Enhancements

- [ ] Add data quality dashboards
- [ ] Implement CI/CD pipeline
- [ ] Add more complex business metrics
- [ ] Integrate with BI tools (Tableau/Power BI)
- [ ] Add alerting and monitoring
- [ ] Implement data masking for PII
- [ ] Add more comprehensive testing suite
