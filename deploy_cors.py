import paramiko
import time

HOST = "87.106.23.108"
USER = "root"
PASSWORD = "BK3JfAk6"

REMOTE_DIR = "/var/www/eschoolmobile"
LOCAL_SETTINGS = "eSchoolMobile_backend/monecole_ws/settings.py"
REMOTE_SETTINGS = f"{REMOTE_DIR}/monecole_ws/settings.py"
VENV_PIP = f"{REMOTE_DIR}/venv/bin/pip"

def deploy_cors():
    client = paramiko.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    try:
        print(f"Connecting to {HOST}...")
        client.connect(HOST, username=USER, password=PASSWORD)
        sftp = client.open_sftp()
        
        print("1. Uploading updated settings.py...")
        sftp.put(LOCAL_SETTINGS, REMOTE_SETTINGS)
        sftp.close()
        
        def run(cmd):
            print(f"> {cmd}")
            stdin, stdout, stderr = client.exec_command(cmd)
            out = stdout.read().decode().strip()
            err = stderr.read().decode().strip()
            if out: print("OUT:", out)
            if err: print("ERR:", err)
            return out
            
        print("\n2. Installing django-cors-headers on server...")
        run(f"{VENV_PIP} install django-cors-headers")
        
        print("\n3. Restarting Backend Server...")
        run("pkill -f 'monecole_ws.wsgi:application'")
        time.sleep(2)
        start_cmd = f"nohup {REMOTE_DIR}/venv/bin/gunicorn --workers 3 --bind 0.0.0.0:8000 monecole_ws.wsgi:application > {REMOTE_DIR}/gunicorn.log 2>&1 &"
        run(f"cd {REMOTE_DIR} && {start_cmd}")
        
        print("\nCORS Deployment Complete!")
        
    except Exception as e:
        print(f"FAILED: {e}")
    finally:
        client.close()

if __name__ == "__main__":
    deploy_cors()
