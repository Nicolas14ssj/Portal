from django.db import models
#from django.contrib.auth.models import AbstractUser
from django.db.models.signals import post_save
from django.dispatch import receiver


    
# modulos, perfiles, detalles de modulo, empleados, tipomenu, estado, rel_perfiles_modulos

class Modulos (models.Model): 
    id_modulo = models.CharField(primary_key = True, max_length =30)
    nombre = models.CharField(max_length =30)
    
    def __str__(self):
        return self.nombre
    

class DetalleModulo(models.Model): 
    id_modulo = models.ForeignKey(Modulos, on_delete=models.PROTECT, related_name='Idm')  
    descripcion = models.CharField(max_length =120)
    acceso  = models.CharField(max_length =60) # quienes deberían tener acseso al modulo 

    def __str__(self):
        return str(self.id_modulo)
    
    
    
class Perfiles(models.Model): 
    id_perfil = models.CharField(primary_key = True, max_length =30)
    nombre = models.CharField(max_length =30)
    descripcion = models.CharField(max_length =30)
    modulos = models.ManyToManyField(Modulos, related_name='perfiles')
   
    
    def __str__(self):
        return self.id_perfil

class Empleados (models.Model): 
    id_empleado = models.CharField(primary_key = True, max_length =60)
    nombre = models.CharField(max_length =60)
    apellido = models.CharField(max_length =60)
    departamento = models.CharField(max_length =30)
    perfil = models.ForeignKey(Perfiles, on_delete=models.PROTECT, related_name='empleados', default=1)  
    def __str__(self):
        return self.id_empleado 


class Estado (models.Model): 
    id_estado = models.CharField(primary_key = True, max_length =30)
    nombre = models.CharField(max_length =30, choices=(
        ('AUTORIZADO', 'autorizado'),
        ('LECTURA', 'lectura'),
        ('NO AUTORIZADO', 'no autorizado')),default='NO AUTORIZADO')

    def __str__(self):
        return f"{self.id_estado}, {self.nombre}" 
    

class Rel_Perfiles_Modulos (models.Model):
    track_id  = models.IntegerField(primary_key = True)
    id_detalle_mod = models.ForeignKey(DetalleModulo, on_delete=models.PROTECT, related_name='Iddm')
    name = models.CharField(max_length =120,)
    parent_id = models.IntegerField()
    order = models.IntegerField()
    id_perfil = models.ForeignKey(Perfiles,  on_delete=models.PROTECT, related_name='E', null=True, default=None)
    estado = models.ForeignKey(Estado,  on_delete=models.PROTECT, related_name='es', null=True, default=None)  

    
    def __str__(self):
        return str(self.track_id)
    



#MER
from django.db import models

class OITM(models.Model):  # Maestro de Artículos
    ItemCode = models.CharField(primary_key=True, max_length=50, db_column='ItemCode')  # Código del artículo
    ItemName = models.CharField(max_length=200, null=True, blank=True, db_column='ItemName')  # Nombre del artículo
    FrgnName = models.CharField(max_length=100, null=True, blank=True, db_column='FrgnName')  # Nombre extranjero
    ItmsGrpCod = models.SmallIntegerField(null=True, blank=True, db_column='ItmsGrpCod')  # Grupo de artículos
    CstGrpCode = models.SmallIntegerField(null=True, blank=True, db_column='CstGrpCode')  # Grupo de costo
    VatGourpSa = models.CharField(max_length=8, null=True, blank=True, db_column='VatGourpSa')  
    CodeBars = models.CharField(max_length=254, null=True, blank=True, db_column='CodeBars')  
    VATLiable = models.CharField(max_length=1, null=True, blank=True, db_column='VATLiable')  
    PrchseItem = models.CharField(max_length=1, null=True, blank=True, db_column='PrchseItem')  
    SellItem = models.CharField(max_length=1, null=True, blank=True, db_column='SellItem')  
    InvntItem = models.CharField(max_length=1, null=True, blank=True, db_column='InvntItem')  
    CardCode = models.CharField(max_length=15, null=True, blank=True, db_column='CardCode')  
    DscountCod = models.SmallIntegerField(null=True, blank=True, db_column='DscountCod')  
    
    SLen2Unit = models.SmallIntegerField(null=True, blank=True, db_column='SLen2Unit')
    SVolume = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='SVolume')
    SVolUnit = models.SmallIntegerField(null=True, blank=True, db_column='SVolUnit')
    SWeight1 = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='SWeight1')
    SWght1Unit = models.SmallIntegerField(null=True, blank=True, db_column='SWght1Unit')
    SWeight2 = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='SWeight2')
    SWght2Unit = models.SmallIntegerField(null=True, blank=True, db_column='SWght2Unit')

    BHeight1 = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='BHeight1')
    BHght1Unit = models.SmallIntegerField(null=True, blank=True, db_column='BHght1Unit')
    BHeight2 = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='BHeight2')
    BHght2Unit = models.SmallIntegerField(null=True, blank=True, db_column='BHght2Unit')
    BWidth1 = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='BWidth1')
    BWdth1Unit = models.SmallIntegerField(null=True, blank=True, db_column='BWdth1Unit')
    BWidth2 = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='BWidth2')
    BWdth2Unit = models.SmallIntegerField(null=True, blank=True, db_column='BWdth2Unit')
    BLength1 = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='BLength1')
    BLen1Unit = models.SmallIntegerField(null=True, blank=True, db_column='BLen1Unit')
    Blength2 = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='Blength2')
    BLen2Unit = models.SmallIntegerField(null=True, blank=True, db_column='BLen2Unit')

    FixCurrCms = models.CharField(max_length=3, null=True, blank=True, db_column='FixCurrCms')
    FirmCode = models.SmallIntegerField(null=True, blank=True, db_column='FirmCode')

    LstSalDate = models.DateTimeField(null=True, blank=True, db_column='LstSalDate')
    CreateDate = models.DateTimeField(null=True, blank=True, db_column='CreateDate')
    UpdateDate = models.DateTimeField(null=True, blank=True, db_column='UpdateDate')

    validFor = models.CharField(max_length=1, null=True, blank=True, db_column='validFor')
    validFrom = models.DateTimeField(null=True, blank=True, db_column='validFrom')
    validTo = models.DateTimeField(null=True, blank=True, db_column='validTo')
    frozenFor = models.CharField(max_length=1, null=True, blank=True, db_column='frozenFor')
    frozenFrom = models.DateTimeField(null=True, blank=True, db_column='frozenFrom')
    frozenTo = models.DateTimeField(null=True, blank=True, db_column='frozenTo')
    BlockOut = models.CharField(max_length=1, null=True, blank=True, db_column='BlockOut')
    
    # Query Groups (QryGroup1 - QryGroup64)
    for i in range(1, 65):  
        locals()[f'QryGroup{i}'] = models.BooleanField(default=False, db_column=f'QryGroup{i}')  

    EnAstSeri = models.CharField(max_length=1, null=True, blank=True, db_column='EnAstSeri')
    U_Masivo = models.CharField(max_length=1, null=True, blank=True, db_column='U_Masivo')
    U_NumEtiq = models.SmallIntegerField(null=True, blank=True, db_column='U_NumEtiq')
    U_Currency = models.CharField(max_length=3, null=True, blank=True, db_column='U_Currency')
    U_Origin = models.CharField(max_length=1, null=True, blank=True, db_column='U_Origin')
    U_FUCOSTO = models.DateTimeField(null=True, blank=True, db_column='U_FUCOSTO')
    U_VCOSTO = models.IntegerField(null=True, blank=True, db_column='U_VCOSTO')
    U_VcostoA = models.IntegerField(null=True, blank=True, db_column='U_VcostoA')
    U_TCostos = models.CharField(max_length=20, null=True, blank=True, db_column='U_TCostos')
    U_FULTCOSTO = models.DateTimeField(null=True, blank=True, db_column='U_FULTCOSTO')
    U_TamEtiq = models.CharField(max_length=1, null=True, blank=True, db_column='U_TamEtiq')
    U_Glosa = models.CharField(max_length=100, null=True, blank=True, db_column='U_Glosa')
    U_Tproducto = models.CharField(max_length=1, null=True, blank=True, db_column='U_Tproducto')
    U_Ubi_Primaria = models.CharField(max_length=20, null=True, blank=True, db_column='U_Ubi_Primaria')
    U_Ubi_secundaria = models.CharField(max_length=20, null=True, blank=True, db_column='U_Ubi_secundaria')
    U_Ubi_terciaria = models.CharField(max_length=20, null=True, blank=True, db_column='U_Ubi_terciaria')
    U_REV = models.CharField(max_length=1, null=True, blank=True, db_column='U_REV')

    class Meta:
        db_table = "app_oitm"
        managed = True  # Django administrará la tabla
        verbose_name = "Maestro de Artículos"
        verbose_name_plural = "Maestro de Artículos"

    def __str__(self):
        return self.ItemCode


    
    

class ORTT(models.Model):  # maestro de tipo de cambio
    RateDate = models.DateTimeField(primary_key=True, db_column='RateDate')  # FECHA DE TIPO DE CAMBIO
    Currency = models.CharField(max_length=3, db_column='Currency')  # CODIGO DE MONETA
    Rate = models.DecimalField(max_digits=19, decimal_places=6, db_column='Rate')    # TIPO DE CAMBIO
    
    def __str__(self):
        return self.Currency
    
    

class OITW(models.Model):  # STOCK x bodega
    Itemcode = models.ForeignKey(OITM, on_delete=models.PROTECT, related_name='n_items', db_column='Itemcode')  # NUMERO DE ARTICULO
    OnHand = models.IntegerField(db_column='OnHand')  # EN STOCK 
    WhsCode = models.CharField(max_length=120, db_column='WhsCode')
    AvgPrice =  models.DecimalField(max_digits=10, decimal_places=4, db_column='AvgPrice') # precio promedio
    

    def __str__(self):
        return str(self.Itemcode)
    
    

class OWHS(models.Model):  # maestro de BODEGA
    WhsCode = models.CharField(max_length=120, primary_key=True, db_column='WhsCode')  # CODIGO DE ALMACEN 
    Itemcode = models.ForeignKey(OITM, null=True, blank=True, on_delete=models.PROTECT, related_name='warehouse_items', db_column='Itemcode')  # NUMERO DE ARTICULO
    OnHand = models.IntegerField(null=True, blank=True, db_column='OnHand')  # EN STOCK 
    WhsName = models.CharField(max_length=120, db_column='WhsName')

    def __str__(self):
        return self.WhsCode
    
    class Meta:
        managed             = True  #quien administra la tabla es el modelo de django
        db_table            = 'OWHS' # le asignas un nombre a la base
        verbose_name        = 'Maestro de bodegas'
        verbose_name_plural = 'Maestro de bodegas'
    # en sap existen 3 tipos de negocios los leed que corresponden a algo no especifico, pueden ser clientes o proveedores y los ya mencionados


class OCRD(models.Model):  # maestro de socios de negocios  
    CardCode = models.CharField(max_length=120, primary_key=True, db_column='CardCode')  # CODIGO SN 
    CardName = models.CharField(max_length=120, db_column='CardName')  # NOMBRE SN  
    CardType = models.CharField(max_length=120, default='No especifico', db_column='CardType')  # Tipo de socio de necogio   
    validFor = models.CharField(max_length=120, null=True, blank=True, db_column='validFor')  # ACTIVO
    GroupCode = models.SmallIntegerField(null=True, blank=True, db_column='GroupCode')  # # CODIGO DE GRUPO  
    
    def __str__(self):
        return self.CardCode 
    
    
     
class OINV(models.Model):
    DocEntry = models.IntegerField(primary_key=True, db_column='DocEntry')
    DocNum = models.IntegerField(db_column='DocNum')
    DocTotal = models.DecimalField(max_digits=19, decimal_places=6, db_column='DocTotal')
    VatSum = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='VatSum')
    DocDate = models.DateTimeField(db_column='DocDate')
    DocDueDate = models.DateTimeField(null=True, blank=True, db_column='DocDueDate')
    CardCode = models.CharField(max_length=15, db_column='CardCode')
    CardName = models.CharField(max_length=100, db_column='CardName')
    DiscPrcnt = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='DiscPrcnt')
    Series = models.IntegerField(null=True, blank=True, db_column='Series')
    Indicator = models.CharField(max_length=2, null=True, blank=True, db_column='Indicator')
    ObjType = models.CharField(max_length=20, db_column='ObjType')
    OCRD_CardCode = models.ForeignKey("OCRD", on_delete=models.PROTECT, related_name='C', null=True, default=None, db_column='CardCode')
    
    def __str__(self):
        return str(self.DocEntry)

    
    
    
class INV1(models.Model):  # DETALLE del documento de venta
    DocEntry = models.IntegerField( primary_key=True, db_column='DocEntry')  # NUMERO INTERNO DE DOCUMENTO
    LineNum = models.IntegerField(primary_key=True, db_column='LineNum')  # NÚMERO DE LÍNEA
    TargetType = models.IntegerField(null=True, blank=True, db_column='TargetType')  # TIPO DE DOCUMENTO DE DESTINO
    TrgetEntry = models.IntegerField(null=True, blank=True, db_column='TrgetEntry')  # ID INTERNO DE DOCUMENTO DE DESTINO
    BaseRef = models.CharField(max_length=100, null=True, blank=True, db_column='BaseRef')  # REFERENCIA BASE
    BaseType = models.IntegerField(null=True, blank=True, db_column='BaseType')  # CLASE DE DOCUMENTO BASE
    BaseEntry = models.IntegerField(null=True, blank=True, db_column='BaseEntry')  # ID INTERNO DE DOCUMENTO BASE
    BaseLine = models.IntegerField(null=True, blank=True, db_column='BaseLine')  # NÚMERO DE LÍNEA DEL DOCUMENTO BASE
    LineStatus = models.CharField(max_length=1, null=True, blank=True, db_column='LineStatus')  # ESTADO DE LÍNEA
    ItemCode = models.CharField(max_length=50, db_column='ItemCode')  # NUMERO DE ARTICULO
    Dscription = models.CharField(max_length=254, null=True, blank=True, db_column='Dscription')  # DESCRIPCIÓN DEL ARTÍCULO
    Quantity = models.DecimalField(max_digits=19, decimal_places=6, db_column='Quantity')  # CANTIDAD
    ShipDate = models.DateTimeField(null=True, blank=True, db_column='ShipDate')  # FECHA DE ENTREGA
    OpenQty = models.DecimalField(max_digits=19, decimal_places=6, db_column='OpenQty')  # CANTIDAD ABIERTA
    Price = models.DecimalField(max_digits=19, decimal_places=6, db_column='Price')  # PRECIO UNITARIO
    Currency = models.CharField(max_length=3, null=True, blank=True, db_column='Currency')  # MONEDA
    Rate = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='Rate')  # TIPO DE CAMBIO
    DiscPrcnt = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='DiscPrcnt')  # % DE DESCUENTO PARA LA LÍNEA
    LineTotal = models.DecimalField(max_digits=19, decimal_places=6, db_column='LineTotal')  # TOTAL DE LÍNEA
    TotalFrgn = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='TotalFrgn')  # TOTAL EN MONEDA EXTRANJERA
    OpenSum = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenSum')  # SALDO ABIERTO
    OpenSumFC = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenSumFC')  # SALDO ABIERTO EN MONEDA EXTRANJERA
    VendorNum = models.CharField(max_length=50, null=True, blank=True, db_column='VendorNum')  # CÓDIGO DE PROVEEDOR
    SerialNum = models.CharField(max_length=50, null=True, blank=True, db_column='SerialNum')  # NÚMERO DE SERIE
    WhsCode = models.CharField(max_length=8, null=True, blank=True, db_column='WhsCode')  # CÓDIGO DE ALMACÉN
    SlpCode = models.IntegerField(null=True, blank=True, db_column='SlpCode')  # CÓDIGO DEL VENDEDOR
    Commission = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='Commission')  # COMISIÓN
    TreeType = models.CharField(max_length=1, null=True, blank=True, db_column='TreeType')  # TIPO DE ÁRBOL
    AcctCode = models.CharField(max_length=15, null=True, blank=True, db_column='AcctCode')  # CÓDIGO DE CUENTA
    TaxStatus = models.CharField(max_length=1, null=True, blank=True, db_column='TaxStatus')  # ESTADO DEL IMPUESTO
    GrossBuyPr = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='GrossBuyPr')  # PRECIO BRUTO DE COMPRA
    PriceBefDi = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='PriceBefDi')  # PRECIO ANTES DE DESCUENTO
    DocDate = models.DateTimeField(null=True, blank=True, db_column='DocDate')  # FECHA DEL DOCUMENTO
    Flags = models.IntegerField(null=True, blank=True, db_column='Flags')  # BANDERAS
    OpenCreQty = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenCreQty')  # CANTIDAD ABIERTA PARA CRÉDITO
    UseBaseUn = models.CharField(max_length=1, null=True, blank=True, db_column='UseBaseUn')  # USO DE UNIDAD BASE
    SubCatNum = models.IntegerField(null=True, blank=True, db_column='SubCatNum')  # SUBCATEGORÍA
    BaseCard = models.CharField(max_length=15, null=True, blank=True, db_column='BaseCard')  # CÓDIGO BASE
    TotalSumSy = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='TotalSumSy')  # TOTAL EN SISTEMA
    OpenSumSys = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenSumSys')  # SALDO ABIERTO EN SISTEMA
    InvntSttus = models.CharField(max_length=1, null=True, blank=True, db_column='InvntSttus')  # ESTADO DEL INVENTARIO
    OcrCode = models.CharField(max_length=8, null=True, blank=True, db_column='OcrCode')  # CÓDIGO DE CENTRO DE COSTO
    Project = models.CharField(max_length=20, null=True, blank=True, db_column='Project')  # PROYECTO ASOCIADO
    CodeBars = models.CharField(max_length=254, null=True, blank=True, db_column='CodeBars')  # CÓDIGO DE BARRAS
    VatPrcnt = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='VatPrcnt')  # PORCENTAJE DE IVA
    VatGroup = models.CharField(max_length=8, null=True, blank=True, db_column='VatGroup')  # GRUPO DE IVA
    
    # Relación con OINV (Documento de Venta)
    DoCnum = models.ForeignKey(OINV, on_delete=models.PROTECT, related_name='inv1_lines', null=True, default=None, db_column='DocEntry')
    
    # Relación con OITM (Artículos)
    OITM_ItemCode = models.ForeignKey(OITM, on_delete=models.PROTECT, related_name='oitm_inv1', null=True, default=None, db_column='ItemCode')
    
    def __str__(self):
        return f"DocEntry: {self.DocEntry}, ItemCode: {self.ItemCode}, LineNum: {self.LineNum}"

    


class OQUT(models.Model):  # COTIZACION (QUT1)
    DocTotal = models.DecimalField(max_digits=10, decimal_places=2, db_column='DocTotal')  # total factura
    VatSum = models.DecimalField(max_digits=10, decimal_places=2, db_column='VatSum')  # IMPUESTO TOTAL 
    CardCode = models.CharField(max_length=120, db_column='CardCode')  # CODIGO SN 
    DocDate = models.DateTimeField(db_column='DocDate')  # fecha de contabilizacion 
    DiscPrcnt = models.DecimalField(max_digits=10, decimal_places=2, db_column='DiscPrcnt')  # % DE DESCUENTO PARA DOCUMENTO 
    DocEntry = models.CharField(max_length=120, primary_key=True, default='0', db_column='DocEntry')  # NUMERO INTERNO DE DOCUMENTO 
    ObjType = models.CharField(max_length=50, db_column='ObjType')  # TIPO DE OBJETO 
    OCRD_CardCode = models.ForeignKey(OCRD,  on_delete=models.PROTECT, related_name='CI', null=True, default=None) 
           
      
    def __str__(self):
        return self.DocEntry
    
    
    
    
class QUT1(models.Model):  # DETALLE 
    DocEntry = models.IntegerField(primary_key=True, default='None', db_column='DocEntry')  # NÚMERO INTERNO DE DOCUMENTO 
    Itemcode = models.IntegerField(db_column='Itemcode')  # NÚMERO DE ARTÍCULO
    Quantity = models.IntegerField(db_column='Quantity')  # CANTIDAD
    LineTotal = models.IntegerField(db_column='LineTotal')  # TOTAL DE LÍNEAS
    GrossBuyPr = models.DecimalField(max_digits=10, decimal_places=2, db_column='GrossBuyPr')  # PRECIO DE COSTE INGRESO BRUTO
    BaseEntry = models.CharField(max_length=120, db_column='BaseEntry')  # ID INTERNO DE DOCUMENTO BASE
    BaseType = models.CharField(max_length=120, db_column='BaseType')  # CLASE DE DOCUMENTO BASE
    TrgetEntry = models.CharField(max_length=120, db_column='TrgetEntry')  # ID INTERNO DE DOCUMENTO DE DESTINO
    OQUT_DocEntry = models.ForeignKey(OQUT, on_delete=models.PROTECT, related_name='qut1_entries',  null=True, default=None)  # Cambiado a OQUT_DocEntry para evitar confusión
    OITM_ItemCode = models.ForeignKey(OITM,  on_delete=models.PROTECT, related_name='OE', null=True, default=None) 
    
    def __str__(self):
        return self.DocEntry



class ORDR(models.Model):  # PEDIDOS (RDR1)
    DocTotal = models.DecimalField(max_digits=10, decimal_places=2, db_column='DocTotal')  # total factura
    VatSum = models.DecimalField(max_digits=10, decimal_places=2,db_column='VatSum' )  # IMPUESTO TOTAL 
    CardCode = models.CharField(max_length=120, db_column='CardCode' )  # CODIGO SN 
    DocDate = models.DateTimeField(auto_now_add=False, db_column='DocDate')  # fecha de contabilizacion 
    DiscPrcnt = models.DecimalField(max_digits=10, decimal_places=2, db_column='DiscPrcnt')  # % DE DESCUENTO PARA DOCUMENTO 
    DocEntry = models.CharField(max_length=120, primary_key=True, db_column='DocEntry')  # NUMERO INTERNO DE DOCUMENTO 
    ObjType = models.CharField(max_length=120, db_column='ObjType')  # TIPO DE OBJETO 
    OCRD_CardCode = models.ForeignKey(OCRD,  on_delete=models.PROTECT, related_name='CO', null=True, default=None) 
           
             
    def __str__(self):
        return self.DocEntry
    
    

class RDR1(models.Model):  # DETALLE 
    DocEntry = models.IntegerField(primary_key=True, default='None')  # NUMERO INTERNO DE DOCUMENTO 
    Itemcode = models.IntegerField()  # NUMERO DE ARTICULO
    Quantity = models.IntegerField()  # CANTIDAD
    LineTotal = models.IntegerField()  # TOTAL DE LINEAS
    GrossBuyPr = models.DecimalField(max_digits=10, decimal_places=2)  # PRECIO DE COSTE INGRESO BRUTO
    BaseEntry = models.CharField(max_length=120)  # ID INTERNO DE DOCUMENTO BASE
    BaseType = models.CharField(max_length=120)  # CLASE DE DOCUMENTO BASE
    TrgetEntry = models.CharField(max_length=120)  # ID INTERNO DE DOCUMENTO DE DESTINO
    ORDR_DocEntry = models.ForeignKey(ORDR, on_delete=models.PROTECT, related_name='cno', null=True, default=None) 
    OITM_ItemCode = models.ForeignKey(OITM,  on_delete=models.PROTECT, related_name='OI', null=True, default=None)  
    
    def __str__(self):
        return self.DocEntry


    
class ORIN(models.Model):  # NOTA DE CREDITO (RIN1)
    DocEntry = models.IntegerField(primary_key=True, default='None')
    DocNum = models.IntegerField(db_column='DocNum')
    DocType = models.CharField(max_length=120)
    DocDueDate = models.DateTimeField(null=True, blank=True, db_column='DocDueDate')
    DocTotal = models.DecimalField(max_digits=10, decimal_places=2)  # total factura
    VatSum = models.DecimalField(max_digits=10, decimal_places=2)  # IMPUESTO TOTAL 
    CardCode = models.CharField(max_length=120, )  # CODIGO SN 
    CardName = models.CharField(max_length=100, db_column='CardName')
    DocDate = models.DateTimeField(auto_now_add=False)  # fecha de contabilizacion 
    DiscPrcnt = models.DecimalField(max_digits=10, decimal_places=2)  # % DE DESCUENTO PARA DOCUMENTO  
    ObjType = models.CharField(max_length=120)  # TIPO DE OBJETO 
    Series = models.IntegerField(null=True, blank=True, db_column='Series')
    OCRD_CardCode = models.ForeignKey(OCRD,  on_delete=models.PROTECT, related_name='CD', null=True, default=None) 
           
         
    def __str__(self):
        return self.DocEntry




class RIN1(models.Model):  # DETALLE de la Nota de Crédito
    DocEntry = models.IntegerField(db_column='DocEntry')  # NUMERO INTERNO DE DOCUMENTO
    LineNum = models.IntegerField(db_column='LineNum')  # NÚMERO DE LÍNEA
    TargetType = models.IntegerField(null=True, blank=True, db_column='TargetType')  # TIPO DE DOCUMENTO DE DESTINO
    TrgetEntry = models.IntegerField(null=True, blank=True, db_column='TrgetEntry')  # ID INTERNO DE DOCUMENTO DE DESTINO
    BaseRef = models.CharField(max_length=100, null=True, blank=True, db_column='BaseRef')  # REFERENCIA BASE
    BaseType = models.IntegerField(null=True, blank=True, db_column='BaseType')  # CLASE DE DOCUMENTO BASE
    BaseEntry = models.IntegerField(null=True, blank=True, db_column='BaseEntry')  # ID INTERNO DE DOCUMENTO BASE
    BaseLine = models.IntegerField(null=True, blank=True, db_column='BaseLine')  # NÚMERO DE LÍNEA DEL DOCUMENTO BASE
    LineStatus = models.CharField(max_length=1, null=True, blank=True, db_column='LineStatus')  # ESTADO DE LÍNEA
    ItemCode = models.CharField(max_length=50, db_column='ItemCode')  # NUMERO DE ARTICULO
    Dscription = models.CharField(max_length=254, null=True, blank=True, db_column='Dscription')  # DESCRIPCIÓN DEL ARTÍCULO
    Quantity = models.DecimalField(max_digits=19, decimal_places=6, db_column='Quantity')  # CANTIDAD
    ShipDate = models.DateTimeField(null=True, blank=True, db_column='ShipDate')  # FECHA DE ENTREGA
    OpenQty = models.DecimalField(max_digits=19, decimal_places=6, db_column='OpenQty')  # CANTIDAD ABIERTA
    Price = models.DecimalField(max_digits=19, decimal_places=6, db_column='Price')  # PRECIO UNITARIO
    Currency = models.CharField(max_length=3, null=True, blank=True, db_column='Currency')  # MONEDA
    Rate = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='Rate')  # TIPO DE CAMBIO
    DiscPrcnt = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='DiscPrcnt')  # % DE DESCUENTO PARA LA LÍNEA
    LineTotal = models.DecimalField(max_digits=19, decimal_places=6, db_column='LineTotal')  # TOTAL DE LÍNEA
    TotalFrgn = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='TotalFrgn')  # TOTAL EN MONEDA EXTRANJERA
    OpenSum = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenSum')  # SALDO ABIERTO
    OpenSumFC = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenSumFC')  # SALDO ABIERTO EN MONEDA EXTRANJERA
    VendorNum = models.CharField(max_length=50, null=True, blank=True, db_column='VendorNum')  # CÓDIGO DE PROVEEDOR
    SerialNum = models.CharField(max_length=50, null=True, blank=True, db_column='SerialNum')  # NÚMERO DE SERIE
    WhsCode = models.CharField(max_length=8, null=True, blank=True, db_column='WhsCode')  # CÓDIGO DE ALMACÉN
    SlpCode = models.IntegerField(null=True, blank=True, db_column='SlpCode')  # CÓDIGO DEL VENDEDOR
    Commission = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='Commission')  # COMISIÓN
    TreeType = models.CharField(max_length=1, null=True, blank=True, db_column='TreeType')  # TIPO DE ÁRBOL
    AcctCode = models.CharField(max_length=15, null=True, blank=True, db_column='AcctCode')  # CÓDIGO DE CUENTA
    TaxStatus = models.CharField(max_length=1, null=True, blank=True, db_column='TaxStatus')  # ESTADO DEL IMPUESTO
    GrossBuyPr = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='GrossBuyPr')  # PRECIO BRUTO DE COMPRA
    PriceBefDi = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='PriceBefDi')  # PRECIO ANTES DE DESCUENTO
    DocDate = models.DateTimeField(null=True, blank=True, db_column='DocDate')  # FECHA DEL DOCUMENTO
    Flags = models.IntegerField(null=True, blank=True, db_column='Flags')  # BANDERAS
    OpenCreQty = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenCreQty')  # CANTIDAD ABIERTA PARA CRÉDITO
    UseBaseUn = models.CharField(max_length=1, null=True, blank=True, db_column='UseBaseUn')  # USO DE UNIDAD BASE
    SubCatNum = models.IntegerField(null=True, blank=True, db_column='SubCatNum')  # SUBCATEGORÍA
    BaseCard = models.CharField(max_length=15, null=True, blank=True, db_column='BaseCard')  # CÓDIGO BASE
    TotalSumSy = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='TotalSumSy')  # TOTAL EN SISTEMA
    OpenSumSys = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenSumSys')  # SALDO ABIERTO EN SISTEMA
    InvntSttus = models.CharField(max_length=1, null=True, blank=True, db_column='InvntSttus')  # ESTADO DEL INVENTARIO
    OcrCode = models.CharField(max_length=8, null=True, blank=True, db_column='OcrCode')  # CÓDIGO DE CENTRO DE COSTO
    Project = models.CharField(max_length=20, null=True, blank=True, db_column='Project')  # PROYECTO ASOCIADO
    CodeBars = models.CharField(max_length=254, null=True, blank=True, db_column='CodeBars')  # CÓDIGO DE BARRAS
    VatPrcnt = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='VatPrcnt')  # PORCENTAJE DE IVA
    VatGroup = models.CharField(max_length=8, null=True, blank=True, db_column='VatGroup')  # GRUPO DE IVA
    
    # Relación con ORIN (Cabecera de la Nota de Crédito)
    ORIN_DocEntry = models.ForeignKey(ORIN, on_delete=models.PROTECT, related_name='rin1_lines', null=True, default=None, db_column='DocEntry')
    
    # Relación con OITM (Artículos)
    OITM_ItemCode = models.ForeignKey(OITM, on_delete=models.PROTECT, related_name='oitm_rin1', null=True, default=None, db_column='ItemCode')
    
    def __str__(self):
        return f"DocEntry: {self.DocEntry}, ItemCode: {self.ItemCode}, LineNum: {self.LineNum}"

    


  
# yo no se tu que opinas pero separaria la logica del portal con los permisos procesos con los modelos maestros

#existe la forma de que cuando crees la tabla y esta no tenga datos tu la llenes en forma automatica averigua como es tarea para la casa

class MaeCargos(models.Model): 
    cargo                   = models.CharField(primary_key=True,max_length=50, unique=True,default='Sistemas')
    nombre                  = models.CharField(db_column='nombre',max_length=100, default=None)
    
    class Meta:
        managed             = True
        db_table            = 'maeCargo'
        verbose_name        = 'Cargos en la empresa'
        verbose_name_plural = 'Cargos en la empresa'
        
    def __str__(self):
        return self.cargo if self.cargo else 'Sin cargo'
    
    
    
class MaeLugar(models.Model): 
    lugar                   = models.CharField(primary_key=True,max_length=50, unique=True,default='Sistemas')
    nombre                  = models.CharField(db_column='nombre',max_length=100, default=None)
    
    class Meta:
        managed             = True
        db_table            = 'maeLugar'
        verbose_name        = 'Lugar en la empresa'
        verbose_name_plural = 'Lugar en la empresa'
        
    def __str__(self):
        return self.cargo if self.cargo else 'Sin cargo'


#class MAEempleados(models.Models):
    

  
  
    
#class Usuarios(AbstractUser):
#    telefono        = models.CharField(null=True, blank=True,max_length=20,help_text="Introduzca un número de teléfono.",)
#    imagen          = models.ImageField(upload_to='media/', blank=True, null=True,
#    birthday        = models.DateField(default=None,blank=True, null=True,
#    cargoFK         = models.ForeignKey(MaeCargos, on_delete=models.CASCADE,                                                    db_column='cargoFK',default= 'Sistemas',                                                    help_text="Indique el cargo que ocupa",)
#    lugarFK         = models.ForeignKey(MaeLugar, on_delete=models.CASCADE,                                        db_column='lugarFK',default= 'casa matriz',                                        help_text= "Lugar de trabajo actual del usuario.",                                        )
#    codigoBp        = models.CharField(null=True, blank=True,max_length=50,help_text="Introduzca un Código (bp) existente.",db_column='codigoBp',)
   # generoFK        = models.ForeignKey(MaeGenero, on_delete=models.CASCADE,  db_column='generoFK', default= 'Masculino',  help_text="Indique el género del usuario.",)
   # departamentoFK  = models.ForeignKey(MaeDepartamento,  on_delete=models.CASCADE, db_column='departamentoFK',default=1,   help_text='Área o departamento del usuario',)
   # contableFK      = models.ForeignKey(MaeCuenta, on_delete=models.CASCADE, db_column= 'contableFK',  limit_choices_to=(models.Q(is_analitica=True)) & models.Q(estadoFK=9),  default=0,    help_text='Vinculación de Cuenta Contable con el ERP.',)
   # rolFK           = models.ForeignKey(MaeRoles, on_delete=models.CASCADE, db_column='rolFK',default= 1, related_name='usuarios_rol',  help_text="Seleccione el rol del usuario en el sistema.")
#    class Meta:
#        managed             = True
#        verbose_name        = 'Tabla de Usuarios'  # nombre singular para una instancia
#        verbose_name_plural = 'Tabla de Usuarios'  # nombre plural para el modelo en general
#        db_table            = 'maeUser' 
    
    
    