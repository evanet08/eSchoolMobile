import paramiko
import json

HOST = "87.106.23.108"
USER = "root"
PASSWORD = "BK3JfAk6"

def verify_api():
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    try:
        print(f"Connecting to {HOST}...")
        client.connect(HOST, username=USER, password=PASSWORD)
        
        # Test 1: Check Views File for getParentOperations
        print("\n--- 1. Checking specific View Logic ---")
        cmd = "grep 'def getParentOperations' /var/www/eschoolmobile/account_creation/views.py"
        stdin, stdout, stderr = client.exec_command(cmd)
        out = stdout.read().decode().strip()
        if out:
            print("[OK] getParentOperations found in views.py")
        else:
            print("[FAIL] getParentOperations NOT found!")

        # Test 2: Check URL Mapping
        print("\n--- 2. Checking URL Mapping ---")
        cmd = "grep 'parent_operations' /var/www/eschoolmobile/account_creation/urls.py"
        stdin, stdout, stderr = client.exec_command(cmd)
        out = stdout.read().decode().strip()
        print(out)

    finally:
        client.close()

if __name__ == "__main__":
    verify_api()
