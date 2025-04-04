Here is the **complete, updated `README.md` file** with clear step-by-step instructions including both `dbt run` and `dbt build` workflows:

---

```markdown
# dbt Snowflake Data Pipeline

This repository implements a complete data pipeline using [dbt](https://docs.getdbt.com/) with Snowflake as the data warehouse. It processes raw data from the Jaffle Shop and Stripe into cleaned and aggregated models suitable for analytics and reporting.

The project uses a layered approach to data transformation:
- **Raw**: Mirrors the structure of the Snowflake raw tables.
- **Curated**: Cleans and standardizes raw data using dbt staging models.
- **Presentation**: Provides business-level metrics and aggregations.

---

## Project Structure

```
my_dbt_project/
├── models/
│   ├── raw/              # Pulls from Snowflake RAW database tables
│   ├── curated/          # Staging models for cleaning and standardizing
│   └── presentation/     # Aggregated business models
├── dbt_project.yml       # dbt project configuration
├── .gitignore
└── README.md
```

---

## Prerequisites

- Python 3.8+
- dbt installed via pip:

```bash
pip install dbt-snowflake
```

- Snowflake account and credentials
- Raw data preloaded into Snowflake:
  - `RAW.JAFFLE_SHOP.CUSTOMERS`
  - `RAW.JAFFLE_SHOP.ORDERS`
  - `RAW.STRIPE.PAYMENT`

---

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/curious-bigcat/my_dbt_project.git
cd my_dbt_project
```

### 2. Configure Your Snowflake Profile

Create or edit the file `~/.dbt/profiles.yml`:

```yaml
snowflakebs:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <your_account_id>
      user: <your_user>
      password: <your_password>
      role: <your_role>
      warehouse: transforming
      database: analytics
      schema: public
      threads: 4
```

> Replace placeholders with your Snowflake account information.

---

## Running the Pipeline

### Step-by-Step Development Workflow

Run only the models:

```bash
dbt run
```

Run tests (only if you've defined them in `schema.yml`):

```bash
dbt test
```

View compiled SQL and artifacts:

```bash
dbt compile
```

Generate and view documentation:

```bash
dbt docs generate
dbt docs serve
```

### Full Build (Models + Tests + Snapshots)

Run everything in dependency order:

```bash
dbt build
```

---

## Data Layer Breakdown

### Raw Layer

Pulls directly from Snowflake raw tables. These models are basic passthrough views.

- `raw_customers.sql` → `RAW.JAFFLE_SHOP.CUSTOMERS`
- `raw_orders.sql` → `RAW.JAFFLE_SHOP.ORDERS`
- `raw_payments.sql` → `RAW.STRIPE.PAYMENT`

### Curated Layer

- Deduplicates orders and payments using window functions
- Applies naming conventions and formats
- Adds derived fields like `order_year`, `payment_month`

Models:
- `stg_customers`
- `stg_orders`
- `stg_payments`

### Presentation Layer

Contains advanced analytics and metrics:
- `customer_order_summary`: Revenue and order count per customer
- `rfm_segmentation`: RFM-based customer segmentation
- `rolling_7day_revenue`: Rolling window revenue using `window functions`
- `anomalous_payments`: Outlier detection using z-score logic
- `first_vs_repeat_orders`: Behavioral segmentation of new vs returning customers

---

## Example Queries

```sql
-- View top revenue-generating customers
SELECT * FROM analytics.presentation.customer_order_summary
ORDER BY total_revenue DESC;

-- View anomalous payments flagged as outliers
SELECT * FROM analytics.presentation.anomalous_payments
WHERE anomaly_flag != 'Normal';
```

---

## Recommended Enhancements

- Add `sources.yml` to define Snowflake sources formally
- Add `schema.yml` files with tests like `not_null`, `unique`, `relationships`
- Create `snapshots` for historical tracking of changes
- Configure GitHub Actions or dbt Cloud for deployment automation

---

## License

This project is licensed under the MIT License.

---

## Maintainer

Maintained by [curious-bigcat](https://github.com/curious-bigcat).
```

---

Would you like me to:
- Save this as `README.md` in your local project?
- Commit and push it to GitHub for you?
- Also scaffold a `.gitignore`, `schema.yml`, or GitHub Actions CI next?
