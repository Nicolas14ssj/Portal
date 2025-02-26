import requests
import urllib3
import os
from django.core.management.base import BaseCommand
from ...models import (OITM, ORTT, OITW, OWHS, OCRD, OINV, INV1, OQUT, QUT1, ORDR, RDR1, ORIN, RIN1)

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

BASE_URL = "https://192.9.200.112:50000/b1s/v1"

class Command(BaseCommand):
    help = "Obtiene y actualiza datos desde SAP Business One"

    def handle(self, *args, **kwargs):
        self.stdout.write(self.style.SUCCESS("Ejecutando actualización desde SAP..."))
        
        session_id = login()
        if session_id:
            save_data(session_id)
            self.stdout.write(self.style.SUCCESS("Datos actualizados correctamente."))
        else:
            self.stdout.write(self.style.ERROR("Error al iniciar sesión en SAP."))

def login():
    #   Autentica en SAP B1 y obtiene el token de sesión.
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

def fetch_data(entity, fields, session_id):
    #Obtiene los datos de una entidad de SAP B1 Service Layer.
    url = f"{BASE_URL}/{entity}?$select={','.join(fields)}"
    headers = {
        'Content-Type': 'application/json',
        'Cookie': f'B1SESSION={session_id}'
    }
    try:
        response = requests.get(url, headers=headers, verify=False, timeout=10)
        response.raise_for_status()
        return response.json().get("value", [])
    except requests.exceptions.HTTPError as e:
        print(f"Error HTTP en {entity}: {e}")
        print("Código de estado:", response.status_code)
        print("Respuesta completa:", response.text)
        return []
    except requests.exceptions.RequestException as e:
        print(f"Error en la solicitud de {entity}:", e)
        return []

def save_data(session_id):
    #btiene y guarda datos en la base de datos Django.

    # OITM (Items)
    items = fetch_data("Items", ["ItemCode", "ItemName", "ItemsGroupCode"], session_id)
    for item in items:
        OITM.objects.update_or_create(
            Itemcode=item["ItemCode"],
            defaults={
                "ItemName": item["ItemName"],
                "ItmsGrpCod": item.get("ItemsGroupCode")
            }
        )

    # ORTT (ExchangeRates)
    rates = fetch_data("ExchangeRates", ["RateDate", "Currency", "Rate"], session_id)
    for rate in rates:
        ORTT.objects.update_or_create(
            RateDate=rate["RateDate"],
            Currency=rate["Currency"],
            defaults={"Rate": rate["Rate"]}
        )

    # OITW (ItemWarehouseInfo)
    stocks = fetch_data("ItemWarehouseInfo", ["ItemCode", "WarehouseCode", "InStock", "AvgPrice"], session_id)
    for stock in stocks:
        OITW.objects.update_or_create(
            Itemcode_id=stock["ItemCode"],
            WhsCode=stock["WarehouseCode"],
            defaults={"OnHand": stock["InStock"], "AvgPrice": stock["AvgPrice"]}
        )

    # OWHS (Warehouses)
    warehouses = fetch_data("Warehouses", ["WarehouseCode", "WarehouseName"], session_id)
    for whs in warehouses:
        OWHS.objects.update_or_create(
            WhsCode=whs["WarehouseCode"],
            defaults={"WhsName": whs["WarehouseName"]}
        )

    # OCRD (BusinessPartners)
    partners = fetch_data("BusinessPartners", ["CardCode", "CardName", "CardType", "ValidFor", "GroupCode"], session_id)
    for partner in partners:
        OCRD.objects.update_or_create(
            CardCode=partner["CardCode"],
            defaults={
                "CardName": partner["CardName"],
                "CardType": partner["CardType"],
                "validFor": partner["ValidFor"],
                "GroupCode": partner.get("GroupCode")
            }
        )

    # OINV (Invoices)
    invoices = fetch_data("Invoices", ["DocEntry", "DocTotal", "VatSum", "DocDate", "DiscPrcnt", "ObjType", "CardCode"], session_id)
    for inv in invoices:
        OINV.objects.update_or_create(
            DocNum=inv["DocEntry"],
            defaults={
                "DocTotal": inv["DocTotal"],
                "VatSum": inv["VatSum"],
                "DocDate": inv["DocDate"],
                "DiscPrcnt": inv.get("DiscPrcnt"),
                "ObjType": inv["ObjType"],
                "CardCode_id": inv["CardCode"]
            }
        )

    print("Datos de SAP sincronizados correctamente.")

class Command(BaseCommand):
    """Comando Django para sincronizar datos de SAP B1."""
    help = "Obtiene y actualiza los datos de SAP B1 en Django"

    def handle(self, *args, **kwargs):
        session_id = login()
        if session_id:
            save_data(session_id)
        else:
            print("No se pudo iniciar sesión en SAP B1.")
