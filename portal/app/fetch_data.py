import os
import django
from sqlalchemy import create_engine
import pandas as pd
from app.models import OITM, ORTT, OITW, OWHS, OCRD, OINV, INV1, OQUT, QUT1, ORDR, RDR1, ORIN, RIN1

# Configuración de Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'portal.settings')  
django.setup()

# Conexión a la base de datos SQL Server
def connect_to_sql_server():
    connection_string = (
        'mssql+pyodbc://practica_ti:pti.2025@SERVIDORPRUEBA/Anwo_Produccion?driver=ODBC+Driver+17+for+SQL+Server'
    )
    engine = create_engine(connection_string)
    return engine

# Función para obtener datos de SAP
def fetch_data(query):
    engine = connect_to_sql_server()
    try:
        df = pd.read_sql(query, engine)
        return df
    except Exception as e:
        print(f"Error al ejecutar la consulta: {e}")
        return pd.DataFrame()  # Devuelve un DataFrame vacío en caso de error

# Función para guardar datos en la base de datos de Django
def save_data_to_django(model, df):
    for index, row in df.iterrows():
        try:
            if model == OITM:
                OITM.objects.update_or_create(
                    Itemcode=row['ItemCode'],
                    defaults={'ItemName': row['ItemName']}
                )
            elif model == ORTT:
                ORTT.objects.update_or_create(
                    Currency=row['Currency'],
                    defaults={'RateDate': row['RateDate'], 'Rate': row['Rate']}
                )
            elif model == OITW:
                item = OITM.objects.get(Itemcode=row['ItemCode'])
                OITW.objects.update_or_create(
                    Itemcode=item,
                    defaults={'OnHand': row['OnHand']}
                )
            elif model == OWHS:
                item = OITM.objects.get(Itemcode=row['ItemCode'])
                OWHS.objects.update_or_create(
                    WhsCode=row['WhsCode'],
                    defaults={'Itemcode': item, 'OnHand': row['OnHand']}
                )
            elif model == OCRD:
                OCRD.objects.update_or_create(
                    CardCode=row['CardCode'],
                    defaults={'CardName': row['CardName'], 'CardType': row['CardType'], 'validFor': row['validFor']}
                )
            elif model == OINV:
                customer = OCRD.objects.get(CardCode=row['CardCode'])
                OINV.objects.update_or_create(
                    DocNum=row['DocNum'],
                    defaults={
                        'DocTotal': row['DocTotal'],
                        'VatSum': row['VatSum'],
                        'CardCode': customer,
                        'DocDate': row['DocDate'],
                        'DiscPrcnt': row['DiscPrcnt'],
                        'ObjType': row['ObjType'],
                        'OCRD_CardCode': customer
                    }
                )
            elif model == INV1:
                invoice = OINV.objects.get(DocNum=row['DocNum'])
                INV1.objects.update_or_create(
                    DocEntry=row['DocEntry'],
                    defaults={
                        'Itemcode': row['Itemcode'],
                        'Quantity': row['Quantity'],
                        'LineTotal': row['LineTotal'],
                        'GrossBuyPr': row['GrossBuyPr'],
                        'BaseEntry': row['BaseEntry'],
                        'BaseType': row['BaseType'],
                        'TrgetEntry': row['TrgetEntry'],
                        'DoCnum': invoice,
                        'OITM_ItemCode': OITM.objects.get(Itemcode=row['Itemcode'])
                    }
                )
            elif model == OQUT:
                OQUT.objects.update_or_create(
                    DocEntry=row['DocEntry'],
                    defaults={
                        'DocTotal': row['DocTotal'],
                        'VatSum': row['VatSum'],
                        'CardCode': row['CardCode'],
                        'DocDate': row['DocDate'],
                        'DiscPrcnt': row['DiscPrcnt'],
                        'ObjType': row['ObjType'],
                        'OCRD_CardCode': OCRD.objects.get(CardCode=row['CardCode'])
                    }
                )
            elif model == QUT1:
                quote = OQUT.objects.get(DocEntry=row['DocEntry'])
                QUT1.objects.update_or_create(
                    DocEntry=row['DocEntry'],
                    defaults={
                        'Itemcode': row['Itemcode'],
                        'Quantity': row['Quantity'],
                        'LineTotal': row['LineTotal'],
                        'GrossBuyPr': row['GrossBuyPr'],
                        'BaseEntry': row['BaseEntry'],
                        'BaseType': row['BaseType'],
                        'TrgetEntry': row['TrgetEntry'],
                        'OQUT_DocEntry': quote,
                        'OITM_ItemCode': OITM.objects.get(Itemcode=row['Itemcode'])
                    }
                )
            elif model == ORDR:
                ORDR.objects.update_or_create(
                    DocEntry=row['DocEntry'],
                    defaults={
                        'DocTotal': row['DocTotal'],
                        'VatSum': row['VatSum'],
                        'CardCode': row['CardCode'],
                        'DocDate': row['DocDate'],
                        'DiscPrcnt': row['DiscPrcnt'],
                        'ObjType': row['ObjType'],
                        'OCRD_CardCode': OCRD.objects.get(CardCode=row['CardCode'])
                    }
                )
            elif model == RDR1:
                order = ORDR.objects.get(DocEntry=row['DocEntry'])
                RDR1.objects.update_or_create(
                    DocEntry=row['DocEntry'],
                    defaults={
                        'Itemcode': row['Itemcode'],
                        'Quantity': row['Quantity'],
                        'LineTotal': row['LineTotal'],
                        'GrossBuyPr': row['GrossBuyPr'],
                        'BaseEntry': row['BaseEntry'],
                        'BaseType': row['BaseType'],
                        'TrgetEntry': row['TrgetEntry'],
                        'ORDR_DocEntry': order,
                        'OITM_ItemCode': OITM.objects.get(Itemcode=row['Itemcode'])
                    }
                )
            elif model == ORIN:
                ORIN.objects.update_or_create(
                    DocEntry=row['DocEntry'],
                    defaults={
                        'DocTotal': row['DocTotal'],
                        'VatSum': row['VatSum'],
                        'CardCode': row['CardCode'],
                        'DocDate': row['DocDate'],
                        'DiscPrcnt': row['DiscPrcnt'],
                        'ObjType': row['ObjType'],
                        'OCRD_CardCode': OCRD.objects.get(CardCode=row['CardCode'])
                    }
                )
            elif model == RIN1:
                credit_note = ORIN.objects.get(DocEntry=row['DocEntry'])
                RIN1.objects.update_or_create(
                    DocEntry=row['DocEntry'],
                    defaults={
                        'Itemcode': row['Itemcode'],
                        'Quantity': row['Quantity'],
                        'LineTotal': row['LineTotal'],
                        'GrossBuyPr': row['GrossBuyPr'],
                        'BaseEntry': row['BaseEntry'],
                        'BaseType': row['BaseType'],
                        'TrgetEntry': row['TrgetEntry'],
                        'ORIN_DocEntry': credit_note,
                        'OITM_ItemCode': OITM.objects.get(Itemcode=row['Itemcode'])
                    }
                )
        except Exception as e:
            print(f"Error al guardar en Django para {model.__name__}: {e}")

# Función principal
def main():
    queries = {
        OITM: "SELECT ItemCode, ItemName FROM dbo.app_oitm",
        ORTT: "SELECT RateDate, Currency, Rate FROM dbo.app_ortt",
        OITW: "SELECT ItemCode, OnHand FROM dbo.app_oitw",
        OWHS: "SELECT WhsCode, ItemCode, OnHand FROM dbo.app_owhs",
        OCRD: "SELECT CardCode, CardName, CardType, validFor FROM dbo.app_ocrd",
        OINV: "SELECT DocNum, DocTotal, VatSum, CardCode, DocDate, DiscPrcnt, ObjType FROM dbo.app_oinv",
        INV1: "SELECT DocEntry, Itemcode, Quantity, LineTotal, GrossBuyPr, BaseEntry, BaseType, TrgetEntry, DocNum FROM dbo.app_inv1",
        OQUT: "SELECT DocEntry, DocTotal, VatSum, CardCode, DocDate, DiscPrcnt, ObjType FROM dbo.app_oqut",
        QUT1: "SELECT DocEntry, Itemcode, Quantity, LineTotal, GrossBuyPr, BaseEntry, BaseType, TrgetEntry FROM dbo.app_qut1",
        ORDR: "SELECT DocEntry, DocTotal, VatSum, CardCode, DocDate, DiscPrcnt, ObjType FROM dbo.app_ordr",
        RDR1: "SELECT DocEntry, Itemcode, Quantity, LineTotal, GrossBuyPr, BaseEntry, BaseType, TrgetEntry FROM dbo.app_rdr1",
        ORIN: "SELECT DocEntry, DocTotal, VatSum, CardCode, DocDate, DiscPrcnt, ObjType FROM dbo.app_orin",
        RIN1: "SELECT DocEntry, Itemcode, Quantity, LineTotal, GrossBuyPr, BaseEntry, BaseType, TrgetEntry FROM dbo.app_rin1"
    }

    for model, query in queries.items():
        try:
            df = fetch_data(query)
            save_data_to_django(model, df)
        except Exception as e:
            print(f"Error al procesar {model.__name__}: {e}")

if __name__ == "__main__":
    main()