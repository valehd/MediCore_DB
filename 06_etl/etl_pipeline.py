import os
import pandas as pd
from datetime import datetime
import pymysql

# Database Connection Configuration
DB_USER = os.environ.get("MEDICORE_DB_USER", "root")
DB_PASSWORD = os.environ.get("MEDICORE_DB_PASSWORD", "your_secret_password") 
DB_HOST = os.environ.get("MEDICORE_DB_HOST", "localhost")
DB_PORT = int(os.environ.get("MEDICORE_DB_PORT", 3306))
DB_NAME = os.environ.get("MEDICORE_DB_NAME", "medicore_db")


def run_etl():
    print("[ETL] Starting MediCore_DB Extraction Phase...")
    
    try:
        # =========================================================
        # 1. EXTRACT STEP (Using pure pymysql connection)
        # =========================================================
        conn = pymysql.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME,
            port=DB_PORT
        )
        
        query = """
            SELECT 
                p.patient_id,
                p.first_name,
                p.last_name,
                p.birth_date,
                p.national_id,
                a.admission_id,
                a.admission_date,
                a.discharge_date,
                a.diagnosis
            FROM admission a
            JOIN patient p ON a.patient_id = p.patient_id
            WHERE p.is_active = 1;
        """

        df_raw = pd.read_sql(query, conn)
        conn.close() 
        
        print(f"[EXTRACT] Successfully retrieved {len(df_raw)} records from MySQL.")
        
        # =========================================================
        # 2. TRANSFORM STEP
        # =========================================================
        print("[TRANSFORM] Processing and cleansing patient data...")
        df_transformed = df_raw.copy()
        
        # Healthcare Compliance: Anonymize sensitive National IDs (RUTs)
        df_transformed['national_id'] = df_transformed['national_id'].apply(
            lambda x: f"XX.XXX.XXX-{x[-1]}" if pd.notnull(x) and '-' in str(x) else "ANONYMOUS"
        )
        
        # Business Logic: Calculate exact Patient Age at the time of admission
        df_transformed['admission_date'] = pd.to_datetime(df_transformed['admission_date'])
        df_transformed['birth_date'] = pd.to_datetime(df_transformed['birth_date'])
        
        df_transformed['patient_age_at_admission'] = (
            df_transformed['admission_date'].dt.year - df_transformed['birth_date'].dt.year
        )
        
        # Business Logic: Calculate length of stay (Days)
        df_transformed['discharge_date'] = pd.to_datetime(df_transformed['discharge_date'])
        end_date = df_transformed['discharge_date'].fillna(datetime.now())
        df_transformed['length_of_stay_days'] = (end_date - df_transformed['admission_date']).dt.days
        
        # Clean columns for final data reporting layout
        df_transformed['full_name'] = df_transformed['first_name'] + " " + df_transformed['last_name']
        
        final_reporting_columns = [
            'admission_id', 'patient_id', 'full_name', 'patient_age_at_admission', 
            'national_id', 'admission_date', 'length_of_stay_days', 'diagnosis'
        ]
        df_final = df_transformed[final_reporting_columns]
        
        # =========================================================
        # 3. LOAD STEP
        # =========================================================
        print("[LOAD] Exporting data pipeline output...")
        
        output_dir = os.path.dirname(os.path.abspath(__file__))
        output_file = os.path.join(output_dir, "clinical_reporting_extract.csv")
        
        df_final.to_csv(output_file, index=False, encoding='utf-8')
        print(f"[LOAD] Pipeline complete! Report saved at: {output_file}")
        
    except Exception as e:
        print(f"[ERROR] ETL Pipeline failed: {str(e)}")

if __name__ == "__main__":
    run_etl()
