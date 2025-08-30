import os
import pandas as pd
from db_connection import create_connection

# Folder where SQL files are stored
QUERY_FOLDER = "queries"
OUTPUT_FILE = "output.xlsx"

def run_queries():
    conn = create_connection()
    writer = pd.ExcelWriter(OUTPUT_FILE, engine='xlsxwriter')

    for file_name in os.listdir(QUERY_FOLDER):
        if file_name.endswith(".sql"):
            query_path = os.path.join(QUERY_FOLDER, file_name)

            # Read the SQL query from file
            with open(query_path, "r", encoding="utf-8") as f:
                query = f.read()

            # Run the query
            df = pd.read_sql(query, conn)

            # Sheet name = file name without extension
            sheet_name = os.path.splitext(file_name)[0][:31]  # Excel sheet name max length is 31
            df.to_excel(writer, sheet_name=sheet_name, index=False)

            print(f"✅ Saved results of {file_name} to sheet: {sheet_name}")

    writer.close()
    conn.close()

if __name__ == "__main__":
    run_queries()

