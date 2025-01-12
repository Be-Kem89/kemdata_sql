<div align="center">
  <img src="https://github.com/Ngoc-Bich89/Bank-report/blob/main/nganhangdientu1_1671442163137.jpg" alt="Banking Report" width="60%" />
</div>

<h1 align="center" style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; font-size: 36px; color: #2C3E50;">
  Banking Report
</h1>

<p align="center">
  <a href="https://github.com/Ngoc-Bich89/Bank-report/graphs/contributors">
    <img src="https://img.shields.io/github/contributors/phucnguyen140502/Monthly-Business-Ranking-Report?style=for-the-badge&color=2ECC71&logo=github&logoColor=white" alt="Contributors">
  </a>
  <a href="https://github.com/Ngoc-Bich89/Bank-report/graphs/traffic">
    <img src="https://img.shields.io/github/forks/phucnguyen140502/Monthly-Business-Ranking-Report?style=for-the-badge&color=3498DB&logo=github&logoColor=white" alt="Trafic">
  </a>
  <a href="https://github.com/Ngoc-Bich89/Bank-report/issues">
    <img src="https://img.shields.io/github/issues/phucnguyen140502/Monthly-Business-Ranking-Report?style=for-the-badge&color=E74C3C&logo=github&logoColor=white" alt="Issues">
  </a>
</p>

---

<p align="center" style="margin: 20px 0;">
  <strong>Tools & Platforms Used</strong>
</p>

<p align="center">
  <a href="https://code.visualstudio.com/">
    <img src="https://img.shields.io/badge/Visual_Studio_Code-007ACC?style=for-the-badge&logo=visual-studio-code&logoColor=white" alt="Visual Studio Code">
  </a>
  <a href="https://www.microsoft.com/en-us/microsoft-365/excel">
    <img src="https://img.shields.io/badge/Excel-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white" alt="Excel">
  </a>
  <a href="https://dbeaver.io/">
    <img src="https://img.shields.io/badge/DBeaver-5D6A7D?style=for-the-badge&logo=dbeaver&logoColor=white" alt="DBeaver CE">
  </a>
  <a href="https://github.com/">
    <img src="https://img.shields.io/badge/GIT-E44C30?style=for-the-badge&logo=git&logoColor=white" alt="GIT">
  </a>
</p>

<p align="center">
  <a href="https://github.com/search?q=Object+Oriented+Programming+language%3APython&type=repositories&l=Python&p=1">
    <img src="https://img.shields.io/badge/Python-306998?style=for-the-badge&logo=python&logoColor=white" alt="Python">
  </a>
  <a href="https://www.postgresql.org/">
    <img src="https://img.shields.io/badge/PostgreSQL-336791?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL">
  </a>
</p>

<p align="center">
  <img src="https://img.shields.io/static/v1?label=Project&message=Open%20Source&color=6AB04A&style=for-the-badge&logo=github&logoColor=white" alt="Open Source Project" />
</p>


- **OBJECTIVES 🎯:**
    
    The Board of Directors wants to understand the business performance of the company and its nationwide network, as well as evaluate the competency of Area Sales Managers.
    
- **FLOWCHART**
    
    ![FLOWCHART.drawio.png](https://github.com/Ngoc-Bich89/Bank-report/blob/main/FLOWCHART.drawio.png)
    
- **DATA COLLECTION:**
    1. **File fact_kpi_month_raw_data:** Source data on card debt balances by customer as of the end of each month.
    2. **File fact_txn_month_raw_data:** Source data of transactions recorded in the general ledger.
    3. **File kpi_asm_data:** Data source on monthly business revenue by ASM (Area Sales Manager).
    
    - **Import CSV data:** 🗒️
        
        ![image.png](https://github.com/Ngoc-Bich89/Bank-report/blob/main/chart/csv%20data.png)
        
    

- **Table:** 📔
    
    ![image.png](https://github.com/Ngoc-Bich89/Bank-report/blob/main/chart/fact_kpi_month_raw_data.png)
    
    *fact_kpi_month_raw_data*
    
    ![image.png](https://github.com/Ngoc-Bich89/Bank-report/blob/main/chart/fact_txn_month_raw_data.png)
    
    *fact_txn_month_raw_data*
    
    ![image.png](https://github.com/Ngoc-Bich89/Bank-report/blob/main/chart/kpi_asm_data.png)
    
    *kpi_asm_data*

- **DATA MODELING AND ETL 📔:** 
    
    Use **PLSQL Programming** to write a **Stored Procedure.**.
    
    Develop a Stored Procedure with an input parameter for the report month in the format `'YYYYMM'`. The procedure should:
    
    1. Retrieve data from the three input tables:
        - `fact_txn_month_raw_data`,
        - `fact_kpi_month_raw_data`,
        - and `fact_kpi_month_raw_data`.
    2. Combine this data with existing `dim` and `fact` tables through data processing steps to populate the target tables:
        - `report_tong_hop` (Bank Business Report)
        - and `asm_report` (ASM Report).
      
    Built Dim Table
  
    ![image.png](https://github.com/Ngoc-Bich89/Bank-report/blob/main/chart/code_account.png)
    
    *code_account*
    
    ![image.png](https://github.com/Ngoc-Bich89/Bank-report/blob/main/chart/ma_khu_vuc.png)
    
    *ma_khu_vuc*

After that, build additional physical tables as intermediate steps to lead to the final report.

    ![image.png](https://github.com/Ngoc-Bich89/Bank-report/blob/main/chart/report_asm.jpg)
    *report_asm*
    
    ![image.png](https://github.com/Ngoc-Bich89/Bank-report/blob/main/chart/report_tong_hop.jpg)
    *report_tong_hop*
    
- **DATA VISUALIZATION🖼️:** 
See details in the **Embedded Demo with Power BI**: [Visual Chart](https://app.powerbi.com/view?r=eyJrIjoiMzMxZjAwZWYtYWNmMC00MGNhLWEyOTktODI5ZDYwYjcxZmUxIiwidCI6IjZhYzJhZDA2LTY5MmMtNDY2My1iN2FmLWE5ZmYyYTg2NmQwYyIsImMiOjEwfQ%3D%3D)

1. Use **Power BI** to connect to the database via **Direct Query**. [Visual Chart](https://app.powerbi.com/view?r=eyJrIjoiMzMxZjAwZWYtYWNmMC00MGNhLWEyOTktODI5ZDYwYjcxZmUxIiwidCI6IjZhYzJhZDA2LTY5MmMtNDY2My1iN2FmLWE5ZmYyYTg2NmQwYyIsImMiOjEwfQ%3D%3D)
2. Visualize and analyze the **business performance of regions** and assess the **capabilities of personnel (ASM)** as of **March 2023**.

    **BUSINESS BANKING REPOPRT**: (refer to the Embedded Demo with Power BI above).

    **ASM REPORT**:

![image](https://github.com/Ngoc-Bich89/Bank-report/blob/main/chart/Financial_Report.jpg?raw=true)
Overview of Revenue, Expenses, and Profit by Region Across Months
![image](https://github.com/Ngoc-Bich89/Bank-report/blob/main/chart/Revenue%26Expense.jpg?raw=true)
Details of Revenue and Expense Components by Region
![image](https://github.com/Ngoc-Bich89/Bank-report/blob/main/chart/Sale_Report.jpg?raw=true)
Report on the Evaluation of Employee Performance Effectiveness
