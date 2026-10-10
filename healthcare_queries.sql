-- ============================================================
-- HEALTHCARE OPERATIONS & REVENUE CYCLE SQL ANALYTICS
-- Dataset: 55,500+ Patient Records (healthcare_dataset.csv)
-- Skills: Aggregations, Date Calculations, CASE Statements, Window Functions
-- ============================================================

-- 1. Create a Clean Patient Admissions Table Schema
CREATE TABLE IF NOT EXISTS patient_admissions (
    Name TEXT,
    Age INT,
    Gender TEXT,
    Blood_Type TEXT,
    Medical_Condition TEXT,
    Date_of_Admission DATE,
    Doctor TEXT,
    Hospital TEXT,
    Insurance_Provider TEXT,
    Billing_Amount DECIMAL(10, 2),
    Room_Number INT,
    Admission_Type TEXT,
    Discharge_Date DATE,
    Medication TEXT,
    Test_Results TEXT
);

-- 2. Average Length of Stay (LOS) by admission type
SELECT 
    Admission_Type,
    COUNT(*) AS total_patients,
    ROUND(AVG(JULIANDAY(Discharge_Date) - JULIANDAY(Date_of_Admission)), 1) AS avg_length_of_stay_days
FROM patient_admissions
GROUP BY Admission_Type
ORDER BY avg_length_of_stay_days DESC;

-- 3. Insurance Provider Revenue Summary
SELECT 
    Insurance_Provider,
    COUNT(*) AS total_claims,
    ROUND(SUM(Billing_Amount), 2) AS total_revenue,
    ROUND(AVG(Billing_Amount), 2) AS avg_billing_per_patient
FROM patient_admissions
GROUP BY Insurance_Provider
ORDER BY total_revenue DESC;

-- 4. Advanced Window Function: Rank Payers by Revenue
SELECT 
    Insurance_Provider,
    ROUND(SUM(Billing_Amount), 2) AS total_billed,
    RANK() OVER (ORDER BY SUM(Billing_Amount) DESC) AS revenue_rank
FROM patient_admissions
GROUP BY Insurance_Provider;

-- 5. High-Cost Outlier Audit (Claims Over $45,000)
SELECT 
    Name,
    Medical_Condition,
    Admission_Type,
    Insurance_Provider,
    Billing_Amount,
    CASE 
        WHEN Billing_Amount > 40000 THEN 'High Cost'
        WHEN Billing_Amount BETWEEN 20000 AND 40000 THEN 'Moderate Cost'
        ELSE 'Standard Cost'
    END AS cost_category
FROM patient_admissions
WHERE Billing_Amount > 45000
ORDER BY Billing_Amount DESC
LIMIT 10;


