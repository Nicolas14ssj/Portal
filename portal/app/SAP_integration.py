import requests
import urllib3

# Desactivar advertencias de certificados
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Credenciales y URL
url = 'https://192.9.200.112:50000/b1s/v1/Login'
headers = {
    'Content-Type': 'application/json'
}
data = {
    "CompanyDB": "Anwo_Produccion",  # Base de datos
    "UserName": "manager2",
    "Password": "m2025"
}

# Realiza la solicitud de autenticación
response = requests.post(url, json=data, headers=headers, verify=False)

if response.status_code == 200:
    print("Login exitoso")
    token = response.json()['SessionId']
    print("Token de sesión:", token)
else:
    print("Error en la autenticación:", response.status_code, response.text)
    exit()  # Salir si la autenticación falla

# Usar el token de sesión para realizar otras solicitudes
# En este caso, el encabezado de autorización debe incluir el token como Bearer
headers = {
    'Content-Type': 'application/json',
    'Authorization': f'Bearer {token}'  # Usando Bearer
}

# Obtener datos de OITM
oitm_url = 'https://192.9.200.112:50000/b1s/v1/OITM'
response = requests.get(oitm_url, headers=headers, verify=False)

if response.status_code == 200:
    data = response.json()
    for item in data['value']:
        print(item)  
else:
    print("Error al obtener datos de OITM:", response.status_code, response.text)