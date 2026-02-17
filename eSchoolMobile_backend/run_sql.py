import os
import django
from django.db import connection

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'monecole_ws.settings')
django.setup()

def execute_sql_file(filename):
    with open(filename, 'r') as f:
        sql = f.read()

    # Split by semicolon but ignore inside quotes
    # For simplicity, we'll split by ";\n" or just run as one block if supported
    # Some MySQL drivers allow multi-statements, some don't.
    # PyMySQL usually doesn't by default unless enabled.
    # We will split carefully.
    
    statements = sql.split(';')
    
    with connection.cursor() as cursor:
        for statement in statements:
            stmt = statement.strip()
            if stmt:
                try:
                    cursor.execute(stmt)
                except Exception as e:
                    print(f"Error executing statement: {stmt[:50]}...")
                    print(f"Error detail: {e}")

if __name__ == "__main__":
    execute_sql_file('setup_test_users.sql')
    print("SQL execution finished.")
