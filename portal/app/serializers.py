from rest_framework import serializers
from .models import OITM, ORTT, OITW, OWHS, OCRD, INV1, OINV, OQUT, ORDR, RIN1, QUT1, ORIN, RDR1, Modulos, DetalleModulo, Perfiles, Empleados, Estado, Rel_Perfiles_Modulos

class ModulosSerializer(serializers.HyperlinkedModelSerializer): 
    class  Meta:
        model = Modulos
        field = ('id_modulo', 'nombre')


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
        fields = ('Itemcode', 'ItemName')


class ORTTSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = ORTT
        fields = ('RateDate', 'Currency', 'Rate')


class OITWSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = OITW
        fields = ('Itemcode', 'OnHand')


class OWHSSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = OWHS
        fields = ('WhsCode', 'Itemcode', 'OnHand')


class OCRDSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = OCRD
        fields = ('CardCode', 'CardName', 'CardType', 'validFor')


class OINVSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = OINV
        fields = ('DocNum', 'DocTotal', 'VatSum', 'CardCode', 'DocDate', 'DiscPrcnt', 'ObjType', 'OCRD_CardCode')


class INV1Serializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = INV1
        fields = ('DocEntry', 'Itemcode', 'Quantity', 'LineTotal', 'GrossBuyPr', 'BaseEntry', 'BaseType', 'TrgetEntry', 'DoCnum', 'OITM_ItemCode')


class OQUTSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = OQUT
        fields = ('DocTotal', 'VatSum', 'CardCode', 'DocDate', 'DiscPrcnt', 'DocEntry', 'ObjType', 'OCRD_CardCode')


class QUT1Serializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = QUT1
        fields = ('DocEntry', 'Itemcode', 'Quantity', 'LineTotal', 'GrossBuyPr', 'BaseEntry', 'BaseType', 'TrgetEntry', 'OQUT_DocEntry', 'OITM_ItemCode')


class ORDRSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = ORDR
        fields = ('DocTotal', 'VatSum', 'CardCode', 'DocDate', 'DiscPrcnt', 'DocEntry', 'ObjType', 'OCRD_CardCode')


class RDR1Serializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = RDR1
        fields = ('DocEntry', 'Itemcode', 'Quantity', 'LineTotal', 'GrossBuyPr', 'BaseEntry', 'BaseType', 'TrgetEntry', 'ORDR_DocEntry', 'OITM_ItemCode')


class ORINSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = ORIN
        fields = ('DocTotal', 'VatSum', 'CardCode', 'DocDate', 'DiscPrcnt', 'DocEntry', 'ObjType', 'OCRD_CardCode')


class RIN1Serializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = RIN1
        fields = ('DocEntry', 'Itemcode', 'Quantity', 'LineTotal', 'GrossBuyPr', 'BaseEntry', 'BaseType', 'TrgetEntry', 'ORIN_DocEntry', 'OITM_ItemCode')

