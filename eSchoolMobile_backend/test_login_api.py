
import requests
import json

BASE_URL = "http://localhost:8000"

def test_login(type_user, email, password):
    url = f"{BASE_URL}/login"
    payload = {
        "email": email,
        "password": password,
        "type_user": type_user
    }
    print(f"Testing {type_user} login with {email}...")
    try:
        response = requests.post(url, json=payload, headers={'Content-Type': 'application/json'})
        if response.status_code == 200:
            print(f"[SUCCESS] {type_user} Login OK")
            print(response.json())
        else:
            print(f"[FAIL] {type_user} Login Failed: {response.status_code}")
            print(response.text)
    except Exception as e:
        print(f"[ERROR] Connection failed: {str(e)}")

if __name__ == "__main__":
    # Test credentials from seed_data.py
    test_login("Parent", "+243000000000", "123456")
    test_login("Teacher", "teacher@test.com", "123456")
    test_login("Administrative", "admin@test.com", "123456")
