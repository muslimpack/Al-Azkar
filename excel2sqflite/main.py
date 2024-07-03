
import json
import sqlite3

import pandas as pd


def read_config(config_path):
    with open(config_path, 'r', encoding='utf-8') as f:
        config = json.load(f)
    return config

def ExcelColumnToNumber(column):
    number = 0
    for c in column:
        if 'A' <= c <= 'Z':
            number = number * 26 + (ord(c) - ord('A')) + 1
    return number - 1

def get_last_occurrence(columns, name):
  
    # result = next((col for col in reversed(columns) if col == name), None)
    index = next((len(columns) - i - 1 for i, col in enumerate(reversed(columns)) if col == name), None)

    # result = columns.index(name)
    print(f"get_column_index: {name} | {columns} | {index}")
    return index

def get_column_index(header, column_name, column_header):
    if column_header:
        col_idx = ExcelColumnToNumber(column_header)
        if col_idx < len(header) and header[col_idx] == column_name:
            return col_idx
        else:
            return None
    else:
        return get_last_occurrence(header, column_name)

def create_table(cursor, table_name, columns, constraints=[]):
    col_defs = [f'"{col["dbColName"]}" {col["dbType"]}' if col.get('dbColName') else f'"{col["csvColName"]}" {col["dbType"]}' for col in columns]
    constraints_str = ", ".join(constraints)
    sql = f'CREATE TABLE IF NOT EXISTS "{table_name}" ({", ".join(col_defs)} {", " + constraints_str if constraints else ""});'
    cursor.execute(sql)

def insert_data(cursor, table_name, columns, data):
    db_columns = [f'"{col["dbColName"]}"' if col.get('dbColName') else f'"{col["csvColName"]}"' for col in columns]
    placeholders = ', '.join(['?'] * len(db_columns))
    sql = f'INSERT INTO "{table_name}" ({", ".join(db_columns)}) VALUES ({placeholders})'
    cursor.executemany(sql, data)

def map_xlsx_to_db(config):
    xlsx_file_path = config['info']['csvFilePath']
    db_file_path = config['info']['dbFilePath']
    
    # Connect to SQLite DB
    conn = sqlite3.connect(db_file_path)
    cursor = conn.cursor()
    
    for mapping in config['mapping']:
        csv_sheet = mapping['csvSheet']
        db_table = mapping.get('dbTable', csv_sheet)
        columns = mapping['columns']
        constraints = mapping.get('dbConstraints', [])
        
        # Load sheet from XLSX with UTF-8 encoding
        df = pd.read_excel(xlsx_file_path, sheet_name=csv_sheet, engine='openpyxl')
        
        # Create table
        create_table(cursor, db_table, columns, constraints)
        
        # Prepare data for insertion
        header = df.columns
        data = []

        # Print headers and columns for debugging
        print(f"Headers: {header}")
        print(f"Columns: {columns}")

        for _, row in df.iterrows():
            row_data = []
            for col in columns:
                csv_col_name = col['csvColName']
                csv_col_header = col.get('csvColHeader', '')
                col_idx = get_column_index(header, csv_col_name, csv_col_header)
                if col_idx is not None and isinstance(col_idx, int):
                    row_data.append(row.iloc[col_idx])  # Use iloc to get value by integer index
                else:
                    row_data.append(None)  # Handle missing column gracefully
            print(f"Row Data: {row_data}")
            data.append(tuple(row_data))
        
        # Insert data into table
        insert_data(cursor, db_table, columns, data)
    
    conn.commit()
    conn.close()

if __name__ == '__main__':
    config_path = 'config.json'
    config = read_config(config_path)
    map_xlsx_to_db(config)
