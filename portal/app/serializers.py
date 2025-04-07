from rest_framework import serializers
from .models import (
    OITM, ORTT, OITW, OWHS, Series, OCRD, INV1, OINV, OQUT, ORDR, RIN1, QUT1, ORIN, RDR1, 
    Presupuesto_B1, HLD1, Modulos, DetalleModulo, Perfiles, Detalle_usuarios,Usuarios, Estado, Rel_Perfiles_Modulos, OSLP)

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

class Detalle_usuariosSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Detalle_usuarios
        fields = ('USERID', 'USER_CODE', 'U_NAME', 'E_Mail', 'Branch', 'BranchName',
                  'Department', 'DepartmentName' )

class UsuariosSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Usuarios
        fields = ('USERID', 'USER_CODE', 'Branch', 'BranchName',
                  'Department', 'DepartmentName' )


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


class OSLPSerializer(serializers.ModelSerializer):
    class Meta:
        model = OSLP
        fields = ['SlpCode', 'SlpName', 'Memo', 'Commission', 'GroupCode', 'Locked',
                 'DataSource', 'UserSign', 'EmpID', 'Active', 'Telephone', 'Mobil',
                 'Fax', 'Email', 'DPPStatus', 'EncryptIV', 'U_CostoPersona']
        

# eliminar 
# class OUSRSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = OUSR
#         fields = [
#             'USERID', 'PASSWORD', 'PASSWORD1', 'PASSWORD2', 'INTERNAL_K', 'USER_CODE',
#             'U_NAME', 'GROUPS', 'PASSWORD4', 'ALLOWENCES', 'SUPERUSER', 'DISCOUNT',
#             'PASSWORD3', 'Info1File', 'Info1Field', 'Info2File', 'Info2Field', 'Info3File',
#             'Info3Field', 'Info4File', 'Info4Field', 'dType', 'E_Mail', 'PortNum',
#             'OutOfOffic', 'SendEMail', 'SendSMS', 'DfltsGroup', 'CashLimit', 'MaxCashSum',
#             'Fax', 'SendFax', 'Locked', 'Department', 'Branch', 'UserPrefs', 'Language',
#             'Charset', 'OpenCdt', 'CdtPrvDays', 'DsplyRates', 'AuImpRates', 'OpenDps',
#             'RcrFlag', 'CheckFiles', 'OpenCredit', 'CreditDay1', 'CreditDay2', 'WallPaper',
#             'WllPprDsp', 'AdvImagePr', 'ContactLog', 'LastWarned', 'AlertPolFr',
#             'ScreenLock', 'ShowNewMsg', 'Picture', 'Position', 'Address', 'Country',
#             'Tel1', 'Tel2', 'GENDER', 'Birthday', 'EnbMenuFlt', 'objType', 'logInstanc',
#             'userSign', 'createDate', 'userSign2', 'updateDate', 'OneLogPwd', 'lastLogin',
#             'LastPwds', 'LastPwds2', 'LastPwdSet', 'FailedLog', 'PwdNeverEx', 'SalesDisc',
#             'PurchDisc', 'LstLogoutD', 'LstLoginT', 'LstLogoutT', 'LstPwdChT',
#             'LstPwdChB', 'RclFlag', 'MobileUser', 'MobileIMEI', 'PrsWkCntEb',
#             'SnapShotId', 'STData', 'SupportUsr', 'NoSTPwdNum', 'DomainUser',
#             'CUSAgree', 'EmailSig', 'TPLId', 'DigCrtPath', 'ShowNewTsk', 'IntgrtEb',
#             'AllBrnchF', 'EvtNotify', 'IgnDtOwn', 'EnterAsTab', 'DotAsSep', 'MouseOnly',
#             'Color', 'SkinType', 'Font', 'FontSize', 'NaturalPer', 'DPPStatus',
#             'AutoAsnBPL', 'EncryptIV', 'HandleEDoc', 'ShowLicBal', 'LicBaHDate',
#             'U_modelo', 'U_GRUPO', 'U_Stecnico'
#         ]
