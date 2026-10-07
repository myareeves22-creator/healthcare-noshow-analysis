import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

#1. load the dataset
df = pd.read_csv('healthcare_dataset.csv')

#2. clean colum headers
df.columns = df.columns.str.lower().str.replace(' ', '_')

#3. Calculate length of stay
df['date_of_admission'] = pd.to_datetime(df['date_of_admission'])
df['discharge_date'] = pd.to_datetime(df['discharge_date'])
df['length_of_stay'] = (df['discharge_date'] - df['date_of_admission']).dt.days

#4. Print metrics to console
print("--- DATASET SUMMARY ---")
print(f"Total Patients: {len(df)}")
print(f"Average Stay: {df['length_of_stay'].mean():.1f} days")

#5. Genrate & Save Chart
plt.figure(figsize=(10, 5))
sns.set_theme(style="whitegrid")
sns.barplot(data=df, x='insurance_provider' , y='billing_amount' , estimator=np.mean, errorbar=None, palette='Blues')
plt.title('Average billing ($) by Insurance Provider' , fontsize=14, fontweight='bold')
plt.tight_layout()
plt.savefig('billing_by_insurance.png' , dpi=300)
plt.show()