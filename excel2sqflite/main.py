import pandas as pd
import sqlite3

# Read Excel file
excel_file = 'e.xlsx'
titles_df = pd.read_excel(excel_file, sheet_name='titles')
contents_df = pd.read_excel(excel_file, sheet_name='contents')

# Select only the columns that match the table schema
titles_df = titles_df[['id', 'order', 'name', 'freq']]
contents_df = contents_df.rename(columns={'order_title_id': 'order', 'chk2': 'hokm'})
contents_df = contents_df[['id', 'titleId', 'order', 'body', 'count', 'source', 'hokm', 'fadl', 'search']]

# Connect to SQLite database (or create it)
conn = sqlite3.connect('Al-Azkar.db')
cursor = conn.cursor()

# Create 'titles' table
cursor.execute('''
CREATE TABLE IF NOT EXISTS titles (
    id INTEGER NOT NULL PRIMARY KEY,
    "order" INTEGER NOT NULL,
    name TEXT,
    freq TEXT
);
''')

# Create 'contents' table
cursor.execute('''
CREATE TABLE IF NOT EXISTS contents (
    id INTEGER NOT NULL PRIMARY KEY,
    titleId INTEGER NOT NULL,
    "order" INTEGER NOT NULL,
    body TEXT NOT NULL,
    count INTEGER NOT NULL,
    source TEXT,
    hokm TEXT,
    fadl TEXT,
    search TEXT,
    FOREIGN KEY(titleId) REFERENCES titles(id)
);
''')

conn.commit()

# Insert data into 'titles' table
titles_df.to_sql('titles', conn, if_exists='append', index=False)

# Insert data into 'contents' table
contents_df.to_sql('contents', conn, if_exists='append', index=False)

conn.commit()
conn.close()
