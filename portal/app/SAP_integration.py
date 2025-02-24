import requests
import urllib3
import os

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

BASE_URL = "https://192.9.200.112:50000/b1s/v1"

def login():
    #Autentica en SAP B1 y obtiene el token de sesión.
    url = f"{BASE_URL}/Login"
    headers = {'Content-Type': 'application/json'}
    data = {
        "CompanyDB": "Anwo_Produccion",
        "UserName": os.getenv("SAP_USER", "manager2"),
        "Password": os.getenv("SAP_PASS", "m2025")
    }
    try:
        response = requests.post(url, json=data, headers=headers, verify=False, timeout=10)
        response.raise_for_status()
        session_id = response.json().get("SessionId")
        if not session_id:
            print("Error: No se recibió SessionId.")
            return None
        return session_id
    except requests.exceptions.RequestException as e:
        print("Error en la autenticación:", e)
        return None
#si inicia sesión 


def obtener_datos_oitm(session_id):
    #Obtiene los datos de OITM desde SAP B1.
    url = f"{BASE_URL}/Items?$select=ItemCode, ItemName, ItemsGroupCode"

    headers = {
        'Content-Type': 'application/json',
        'Cookie': f'B1SESSION={session_id}'
    }
    try:
        response = requests.get(url, headers=headers, verify=False, timeout=10)
        response.raise_for_status()
        return response.json().get("value", [])
    except requests.exceptions.HTTPError as e:
        print(f"Error HTTP: {e}")
        print("Código de estado:", response.status_code)
        print("Respuesta completa:", response.text)
        return None
    except requests.exceptions.RequestException as e:
        print("Error en la solicitud:", e)
        return None

# Ejecutar las funciones
session_token = login()
if session_token:
    items = obtener_datos_oitm(session_token)
    if items:
        for item in items:
            print(item)
    else:
        print("No se encontraron datos en OITM.")
else:
    print("No se pudo iniciar sesión en SAP B1.")
