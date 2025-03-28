from rest_framework import serializers
from .models import (
    OITM, ORTT, OITW, OWHS, Series, OCRD, INV1, OINV, OQUT, ORDR, RIN1, QUT1, ORIN, RDR1, 
    Presupuesto_B1, HLD1, Modulos, DetalleModulo, Perfiles, Empleados, Estado, Rel_Perfiles_Modulos
)

class ModulosSerializer(serializers.HyperlinkedModelSerializer): 
    class Meta:
        model = Modulos
        fields = ('id_modulo', 'nombre')

class DetalleModuloSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = DetalleModulo
        fields = ('id_modulo', 'descripcion', 'acceso')

class PerfilesSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Perfiles
        fields = ('id_perfil', 'nombre', 'descripcion')

class EmpleadosSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Empleados
        fields = ('id_empleado', 'nombre', 'apellido', 'departamento', 'cargo', 'id_perfil')

class EstadoSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Estado
        fields = ('id_estado', 'nombre')

class RelPerfilesModulosSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Rel_Perfiles_Modulos
        fields = ('track_id', 'id_detalle_mod', 'name', 'parent_id', 'order', 'id_perfil', 'estado')

class OITMSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = OITM
        fields = ('ItemCode', 'ItemName', 'ItmsGrpCod', 'validFor')


class ORTTSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = ORTT
        fields = ('RateDate', 'Currency', 'Rate')


class OITWSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = OITW
        fields = ('ItemCode', 'ItemCode', 'WhsCode', 'OnHand')


class OWHSSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = OWHS
        fields = ('WhsCode', 'ItemCode', 'OnHand')


class SeriesSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Series
        fields = ('ObjectCode', 'Series', 'SeriesName')


class OCRDSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = OCRD
        fields = ('CardCode', 'CardName', 'CardType', 'validFor', 'LicTradNum', 'E_Mail')


class OINVSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = OINV
        fields = (
            'DocEntry', 'DocNum', 'DocType', 'DocDueDate', 'DocTotal', 'VatSum',
            'CardCode', 'DocDate', 'DiscPrcnt', 'ObjType', 'Series')


class INV1Serializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = INV1
        fields = (
            'id', 'DocEntry', 'LineNum', 'TargetType', 'TrgetEntry', 'BaseRef', 'BaseType',
            'BaseEntry', 'BaseLine', 'LineStatus', 'ItemCode', 'Dscription', 'Quantity',
            'ShipDate', 'OpenQty', 'Price', 'Currency', 'Rate', 'DiscPrcnt', 'LineTotal',
            'TotalFrgn', 'OpenSum', 'OpenSumFC', 'VendorNum', 'SerialNum', 'WhsCode',
            'SlpCode', 'Commission', 'TreeType', 'AcctCode', 'TaxStatus', 'GrossBuyPr',
            'PriceBefDi', 'DocDate', 'Flags', 'OpenCreQty', 'UseBaseUn', 'SubCatNum',
            'BaseCard', 'TotalSumSy', 'OpenSumSys', 'InvntSttus', 'OcrCode', 'Project',
            'CodeBars', 'VatPrcnt', 'VatGroup'
        )


class OQUTSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = OQUT
        fields = (
             'DocEntry', 'DocNum', 'DocType', 'DocDueDate', 'DocTotal', 'VatSum',
            'CardCode', 'DocDate', 'DiscPrcnt', 'ObjType', 'Series'
        )


class QUT1Serializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = QUT1
        fields = (
            'id', 'DocEntry', 'LineNum', 'TargetType', 'TrgetEntry', 'BaseRef', 'BaseType',
            'BaseEntry', 'BaseLine', 'LineStatus', 'ItemCode', 'Dscription', 'Quantity',
            'ShipDate', 'OpenQty', 'Price', 'Currency', 'Rate', 'DiscPrcnt', 'LineTotal',
            'TotalFrgn', 'OpenSum', 'OpenSumFC', 'VendorNum', 'SerialNum', 'WhsCode',
            'SlpCode', 'Commission', 'TreeType', 'AcctCode', 'TaxStatus', 'GrossBuyPr',
            'PriceBefDi', 'DocDate', 'Flags', 'OpenCreQty', 'UseBaseUn', 'SubCatNum',
            'BaseCard', 'TotalSumSy', 'OpenSumSys', 'InvntSttus', 'OcrCode', 'Project',
            'CodeBars', 'VatPrcnt', 'VatGroup'
        )


class ORDRSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = ORDR
        fields = (
            'DocEntry', 'DocNum', 'DocType', 'DocDueDate', 'DocTotal', 'VatSum',
            'CardCode', 'DocDate', 'DiscPrcnt', 'ObjType', 'Series'
        )


class RDR1Serializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = RDR1
        fields = (
           'id', 'DocEntry', 'LineNum', 'TargetType', 'TrgetEntry', 'BaseRef', 'BaseType',
            'BaseEntry', 'BaseLine', 'LineStatus', 'ItemCode', 'Dscription', 'Quantity',
            'ShipDate', 'OpenQty', 'Price', 'Currency', 'Rate', 'DiscPrcnt', 'LineTotal',
            'TotalFrgn', 'OpenSum', 'OpenSumFC', 'VendorNum', 'SerialNum', 'WhsCode',
            'SlpCode', 'Commission', 'TreeType', 'AcctCode', 'TaxStatus', 'GrossBuyPr',
            'PriceBefDi', 'DocDate', 'Flags', 'OpenCreQty', 'UseBaseUn', 'SubCatNum',
            'BaseCard', 'TotalSumSy', 'OpenSumSys', 'InvntSttus', 'OcrCode', 'Project',
            'CodeBars', 'VatPrcnt', 'VatGroup')


class ORINSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = ORIN
        fields = (
             'DocEntry', 'DocNum', 'DocType', 'DocDueDate', 'DocTotal', 'VatSum',
            'CardCode', 'DocDate', 'DiscPrcnt', 'ObjType', 'Series')
        

class RIN1Serializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = RIN1
        fields = (
           'id', 'DocEntry', 'LineNum', 'TargetType', 'TrgetEntry', 'BaseRef', 'BaseType',
            'BaseEntry', 'BaseLine', 'LineStatus', 'ItemCode', 'Dscription', 'Quantity',
            'ShipDate', 'OpenQty', 'Price', 'Currency', 'Rate', 'DiscPrcnt', 'LineTotal',
            'TotalFrgn', 'OpenSum', 'OpenSumFC', 'VendorNum', 'SerialNum', 'WhsCode',
            'SlpCode', 'Commission', 'TreeType', 'AcctCode', 'TaxStatus', 'GrossBuyPr',
            'PriceBefDi', 'DocDate', 'Flags', 'OpenCreQty', 'UseBaseUn', 'SubCatNum',
            'BaseCard', 'TotalSumSy', 'OpenSumSys', 'InvntSttus', 'OcrCode', 'Project',
            'CodeBars', 'VatPrcnt', 'VatGroup'
        )


class PresupuestoB1Serializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Presupuesto_B1
        fields = (
            'SUCURSAL', 'LINEA', 'anio', 'Enero', 'Febrero', 'Marzo', 'Abril',
            'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre',
            'Noviembre', 'Diciembre'
        )


class HLD1Serializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = HLD1
        fields = ('StrDate', 'Rmrks')
