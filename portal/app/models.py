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
    OnHand = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OnHand')  # EN STOCK   
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
        locals()[f'QryGroup{i}'] = models.CharField( max_length=1, null=True, default=False, db_column=f'QryGroup{i}')  

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
    RateDate = models.DateTimeField(db_column='RateDate')  # FECHA DE TIPO DE CAMBIO
    Currency = models.CharField(max_length=3, db_column='Currency')  # CODIGO DE MONETA
    Rate = models.DecimalField(max_digits=19, decimal_places=6, db_column='Rate')    # TIPO DE CAMBIO
    
    def __str__(self):
        return self.Currency
    
    

class OITW(models.Model):  # STOCK x bodega
    Itemcode = models.ForeignKey(OITM, on_delete=models.PROTECT, related_name='n_items', db_column='Itemcode')  # NUMERO DE ARTICULO
    OnHand = models.IntegerField(db_column='OnHand')  # EN STOCK 
    WhsCode = models.CharField(max_length=120, db_column='WhsCode')
    AvgPrice =  models.DecimalField(max_digits=19, null=True, decimal_places=6, db_column='AvgPrice') # precio promedio
    

    def __str__(self):
        return str(self.Itemcode)
    
    

class OWHS(models.Model):  # maestro de BODEGA
    WhsCode = models.CharField(max_length=120, primary_key=True, db_column='WhsCode')  # CODIGO DE ALMACEN 
    Itemcode = models.ForeignKey(OITM, null=True, blank=True, on_delete=models.PROTECT, related_name='warehouse_items', db_column='Itemcode')  # NUMERO DE ARTICULO
    OnHand = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OnHand')  # EN STOCK 
    WhsName = models.CharField(max_length=120, null=True, db_column='WhsName')

    def __str__(self):
        return self.WhsCode
    
    class Meta:
        managed             = True  #quien administra la tabla es el modelo de django
        db_table            = 'OWHS' # le asignas un nombre a la base
        verbose_name        = 'Maestro de bodegas'
        verbose_name_plural = 'Maestro de bodegas'
    # en sap existen 3 tipos de negocios los leed que corresponden a algo no especifico, pueden ser clientes o proveedores y los ya mencionados


class Series (models.Model): #NNM1 
    ObjectCode = models.CharField(max_length=20, db_column='ObjectCode')
    Series = models.IntegerField(primary_key=True,db_column='Series')
    SeriesName = models.CharField(max_length=8, db_column='SeriesName')

    class Meta:
        unique_together = ('ObjectCode', 'Series')  # Clave primaria compuesta

    def __str__(self):
        return f"{self.ObjectCode} - {self.Series}"




class OCRD(models.Model):  # maestro de socios de negocios  
    CardCode = models.CharField(max_length=120, primary_key=True, db_column='CardCode')  # CODIGO SN 
    CardName = models.CharField(max_length=120,  null=True, db_column='CardName')  # NOMBRE SN  
    CardType = models.CharField(max_length=120, null=True, default='No especifico', db_column='CardType')  # Tipo de socio de necogio   
    validFor = models.CharField(max_length=120, null=True, blank=True, db_column='validFor')  # ACTIVO
    GroupCode = models.SmallIntegerField(null=True, blank=True, db_column='GroupCode')  # # CODIGO DE GRUPO 
    LicTradNum =  models.CharField(max_length=120,  null=True, blank=True, db_column='LicTradNum') 
    E_Mail = models.CharField(max_length=120,  null=True, blank=True, db_column='E_Mail') 
    
    def __str__(self):
        return self.CardCode 
    
    
class OINV(models.Model):
    DocEntry = models.BigIntegerField(primary_key=True, default=0)
    DocNum = models.IntegerField(db_column='DocNum')
    DocType = models.CharField(max_length=120)
    DocDueDate = models.DateTimeField(null=True, blank=True, db_column='DocDueDate')
    DocTotal = models.DecimalField(max_digits=19, decimal_places=6)
    VatSum = models.DecimalField(null=True, max_digits=19, decimal_places=6)
    CardCode = models.ForeignKey(OCRD, on_delete=models.PROTECT, related_name='OINV_CD', null=True, default=None, db_column='CardCode')
    DocDate = models.DateTimeField(null=True, auto_now_add=False)
    DiscPrcnt = models.DecimalField(null=True, max_digits=16, decimal_places=6)
    ObjType = models.CharField(max_length=120)
    Series = models.IntegerField(null=True, blank=True, db_column='Series')

    def __str__(self):
        return str(self.DocEntry)


class INV1(models.Model):
    id = models.AutoField(primary_key=True, default=1)
    DocEntry = models.ForeignKey(OINV, on_delete=models.PROTECT, related_name='inv1_lines', null=True, default=None, db_column='DocEntry')
    LineNum = models.IntegerField(db_column='LineNum')
    TargetType = models.IntegerField(null=True, blank=True, db_column='TargetType')
    TrgetEntry = models.BigIntegerField(null=True, blank=True, db_column='TrgetEntry')
    BaseRef = models.CharField(max_length=100, null=True, blank=True, db_column='BaseRef')
    BaseType = models.IntegerField(null=True, blank=True, db_column='BaseType')
    BaseEntry = models.BigIntegerField(null=True, blank=True, db_column='BaseEntry')
    BaseLine = models.IntegerField(null=True, blank=True, db_column='BaseLine')
    LineStatus = models.CharField(max_length=1, null=True, blank=True, db_column='LineStatus')
    ItemCode = models.ForeignKey(OITM, on_delete=models.PROTECT, related_name='oitm_inv1', null=True, default=None, db_column='temCode')
    Dscription = models.CharField(max_length=254, null=True, blank=True, db_column='Dscription')
    Quantity = models.DecimalField(max_digits=19, decimal_places=6, db_column='Quantity')
    ShipDate = models.DateTimeField(null=True, blank=True, db_column='ShipDate')
    OpenQty = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenQty')
    Price = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='Price')
    Currency = models.CharField(max_length=3, null=True, blank=True, db_column='Currency')
    Rate = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='Rate')
    DiscPrcnt = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='DiscPrcnt')
    LineTotal = models.DecimalField(max_digits=19, decimal_places=6, db_column='LineTotal')
    TotalFrgn = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='TotalFrgn')
    OpenSum = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenSum')
    OpenSumFC = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenSumFC')
    VendorNum = models.CharField(max_length=50, null=True, blank=True, db_column='VendorNum')
    SerialNum = models.CharField(max_length=50, null=True, blank=True, db_column='SerialNum')
    WhsCode = models.CharField(max_length=8, null=True, blank=True, db_column='WhsCode')
    SlpCode = models.IntegerField(null=True, blank=True, db_column='SlpCode')
    Commission = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='Commission')
    TreeType = models.CharField(max_length=1, null=True, blank=True, db_column='TreeType')
    AcctCode = models.CharField(max_length=15, null=True, blank=True, db_column='AcctCode')
    TaxStatus = models.CharField(max_length=1, null=True, blank=True, db_column='TaxStatus')
    GrossBuyPr = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='GrossBuyPr')
    PriceBefDi = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='PriceBefDi')
    DocDate = models.DateTimeField(null=True, blank=True, db_column='DocDate')
    Flags = models.IntegerField(null=True, blank=True, db_column='Flags')
    OpenCreQty = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenCreQty')
    UseBaseUn = models.CharField(max_length=1, null=True, blank=True, db_column='UseBaseUn')
    SubCatNum = models.IntegerField(null=True, blank=True, db_column='SubCatNum')
    BaseCard = models.CharField(max_length=15, null=True, blank=True, db_column='BaseCard')
    TotalSumSy = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='TotalSumSy')
    OpenSumSys = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenSumSys')
    InvntSttus = models.CharField(max_length=1, null=True, blank=True, db_column='InvntSttus')
    OcrCode = models.CharField(max_length=8, null=True, blank=True, db_column='OcrCode')
    Project = models.CharField(max_length=20, null=True, blank=True, db_column='Project')
    CodeBars = models.CharField(max_length=254, null=True, blank=True, db_column='CodeBars')
    VatPrcnt = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='VatPrcnt')
    VatGroup = models.CharField(max_length=8, null=True, blank=True, db_column='VatGroup')

    def __str__(self):
        return f"DocEntry: {self.DocEntry}, ItemCode: {self.ItemCode}, LineNum: {self.LineNum}"


    


class OQUT(models.Model):
    DocEntry = models.BigIntegerField(primary_key=True, default=0)
    DocNum = models.IntegerField(db_column='DocNum')
    DocType = models.CharField(max_length=120)
    DocDueDate = models.DateTimeField(null=True, blank=True, db_column='DocDueDate')
    DocTotal = models.DecimalField(max_digits=19, decimal_places=6)
    VatSum = models.DecimalField(null=True, max_digits=19, decimal_places=6)
    CardCode = models.ForeignKey(OCRD, on_delete=models.PROTECT, related_name='OQUT_CD', null=True, default=None, db_column='CardCode')
    DocDate = models.DateTimeField(null=True, auto_now_add=False)
    DiscPrcnt = models.DecimalField(null=True, max_digits=16, decimal_places=6)
    ObjType = models.CharField(max_length=120)
    Series = models.IntegerField(null=True, blank=True, db_column='Series')

    def __str__(self):
        return str(self.DocEntry)
    
    
    
    
class QUT1(models.Model):
    id = models.AutoField(primary_key=True, default=1)
    DocEntry = models.ForeignKey(OQUT, on_delete=models.PROTECT, related_name='OQUT_lines', null=True, default=None, db_column='DocEntry')
    LineNum = models.IntegerField(db_column='LineNum')
    TargetType = models.IntegerField(null=True, blank=True, db_column='TargetType')
    TrgetEntry = models.BigIntegerField(null=True, blank=True, db_column='TrgetEntry')
    BaseRef = models.CharField(max_length=100, null=True, blank=True, db_column='BaseRef')
    BaseType = models.IntegerField(null=True, blank=True, db_column='BaseType')
    BaseEntry = models.BigIntegerField(null=True, blank=True, db_column='BaseEntry')
    BaseLine = models.IntegerField(null=True, blank=True, db_column='BaseLine')
    LineStatus = models.CharField(max_length=1, null=True, blank=True, db_column='LineStatus')
    ItemCode = models.ForeignKey(OITM, on_delete=models.PROTECT, related_name='oitm', null=True, default=None, db_column='temCode')
    Dscription = models.CharField(max_length=254, null=True, blank=True, db_column='Dscription')
    Quantity = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='Quantity')
    ShipDate = models.DateTimeField(null=True, blank=True, db_column='ShipDate')
    OpenQty = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenQty')
    Price = models.DecimalField(max_digits=19, decimal_places=6, db_column='Price')
    Currency = models.CharField(max_length=3, null=True, blank=True, db_column='Currency')
    Rate = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='Rate')
    DiscPrcnt = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='DiscPrcnt')
    LineTotal = models.DecimalField(max_digits=19, decimal_places=6, db_column='LineTotal')
    TotalFrgn = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='TotalFrgn')
    OpenSum = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenSum')
    OpenSumFC = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenSumFC')
    VendorNum = models.CharField(max_length=50, null=True, blank=True, db_column='VendorNum')
    SerialNum = models.CharField(max_length=50, null=True, blank=True, db_column='SerialNum')
    WhsCode = models.CharField(max_length=8, null=True, blank=True, db_column='WhsCode')
    SlpCode = models.IntegerField(null=True, blank=True, db_column='SlpCode')
    Commission = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='Commission')
    TreeType = models.CharField(max_length=1, null=True, blank=True, db_column='TreeType')
    AcctCode = models.CharField(max_length=15, null=True, blank=True, db_column='AcctCode')
    TaxStatus = models.CharField(max_length=1, null=True, blank=True, db_column='TaxStatus')
    GrossBuyPr = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='GrossBuyPr')
    PriceBefDi = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='PriceBefDi')
    DocDate = models.DateTimeField(null=True, blank=True, db_column='DocDate')
    Flags = models.IntegerField(null=True, blank=True, db_column='Flags')
    OpenCreQty = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenCreQty')
    UseBaseUn = models.CharField(max_length=1, null=True, blank=True, db_column='UseBaseUn')
    SubCatNum = models.IntegerField(null=True, blank=True, db_column='SubCatNum')
    BaseCard = models.CharField(max_length=15, null=True, blank=True, db_column='BaseCard')
    TotalSumSy = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='TotalSumSy')
    OpenSumSys = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenSumSys')
    InvntSttus = models.CharField(max_length=1, null=True, blank=True, db_column='InvntSttus')
    OcrCode = models.CharField(max_length=8, null=True, blank=True, db_column='OcrCode')
    Project = models.CharField(max_length=20, null=True, blank=True, db_column='Project')
    CodeBars = models.CharField(max_length=254, null=True, blank=True, db_column='CodeBars')
    VatPrcnt = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='VatPrcnt')
    VatGroup = models.CharField(max_length=8, null=True, blank=True, db_column='VatGroup')

    def __str__(self):
        return f"DocEntry: {self.DocEntry}, ItemCode: {self.ItemCode}, LineNum: {self.LineNum}"







class ORDR(models.Model):
    DocEntry = models.BigIntegerField(primary_key=True, default=0)
    DocNum = models.IntegerField(db_column='DocNum')
    DocType = models.CharField(max_length=120)
    DocDueDate = models.DateTimeField(null=True, blank=True, db_column='DocDueDate')
    DocTotal = models.DecimalField(max_digits=19, decimal_places=6)
    VatSum = models.DecimalField(null=True, max_digits=19, decimal_places=6)
    CardCode = models.ForeignKey(OCRD, on_delete=models.PROTECT, related_name='ORDR_CD', null=True, default=None, db_column='CardCode')
    DocDate = models.DateTimeField(null=True, auto_now_add=False)
    DiscPrcnt = models.DecimalField(null=True, max_digits=16, decimal_places=6)
    ObjType = models.CharField(max_length=120)
    Series = models.IntegerField(null=True, blank=True, db_column='Series')

    def __str__(self):
        return str(self.DocEntry)


    
    

class RDR1(models.Model):  # DETALLE DE PEDIDO
    id = models.AutoField(primary_key=True, default=1)
    DocEntry = models.ForeignKey(ORDR, on_delete=models.PROTECT, related_name='ORDR_lines', null=True, default=None, db_column='DocEntry')
    LineNum = models.IntegerField(db_column='LineNum')
    TargetType = models.IntegerField(null=True, blank=True, db_column='TargetType')
    TrgetEntry = models.BigIntegerField(null=True, blank=True, db_column='TrgetEntry')
    BaseRef = models.CharField(max_length=100, null=True, blank=True, db_column='BaseRef')
    BaseType = models.IntegerField(null=True, blank=True, db_column='BaseType')
    BaseEntry = models.BigIntegerField(null=True, blank=True, db_column='BaseEntry')
    BaseLine = models.IntegerField(null=True, blank=True, db_column='BaseLine')
    LineStatus = models.CharField(max_length=1, null=True, blank=True, db_column='LineStatus')
    ItemCode = models.ForeignKey(OITM, on_delete=models.PROTECT, related_name='L_oitm', null=True, default=None, db_column='temCode')
    Dscription = models.CharField(max_length=254, null=True, blank=True, db_column='Dscription')
    Quantity = models.DecimalField(max_digits=19, decimal_places=6, db_column='Quantity')
    ShipDate = models.DateTimeField(null=True, blank=True, db_column='ShipDate')
    OpenQty = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenQty')
    Price = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='Price')
    Currency = models.CharField(max_length=3, null=True, blank=True, db_column='Currency')
    Rate = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='Rate')
    DiscPrcnt = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='DiscPrcnt')
    LineTotal = models.DecimalField(max_digits=19, decimal_places=6, db_column='LineTotal')
    TotalFrgn = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='TotalFrgn')
    OpenSum = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenSum')
    OpenSumFC = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenSumFC')
    VendorNum = models.CharField(max_length=50, null=True, blank=True, db_column='VendorNum')
    SerialNum = models.CharField(max_length=50, null=True, blank=True, db_column='SerialNum')
    WhsCode = models.CharField(max_length=8, null=True, blank=True, db_column='WhsCode')
    SlpCode = models.IntegerField(null=True, blank=True, db_column='SlpCode')
    Commission = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='Commission')
    TreeType = models.CharField(max_length=1, null=True, blank=True, db_column='TreeType')
    AcctCode = models.CharField(max_length=15, null=True, blank=True, db_column='AcctCode')
    TaxStatus = models.CharField(max_length=1, null=True, blank=True, db_column='TaxStatus')
    GrossBuyPr = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='GrossBuyPr')
    PriceBefDi = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='PriceBefDi')
    DocDate = models.DateTimeField(null=True, blank=True, db_column='DocDate')
    Flags = models.IntegerField(null=True, blank=True, db_column='Flags')
    OpenCreQty = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenCreQty')
    UseBaseUn = models.CharField(max_length=1, null=True, blank=True, db_column='UseBaseUn')
    SubCatNum = models.IntegerField(null=True, blank=True, db_column='SubCatNum')
    BaseCard = models.CharField(max_length=15, null=True, blank=True, db_column='BaseCard')
    TotalSumSy = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='TotalSumSy')
    OpenSumSys = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenSumSys')
    InvntSttus = models.CharField(max_length=1, null=True, blank=True, db_column='InvntSttus')
    OcrCode = models.CharField(max_length=8, null=True, blank=True, db_column='OcrCode')
    Project = models.CharField(max_length=20, null=True, blank=True, db_column='Project')
    CodeBars = models.CharField(max_length=254, null=True, blank=True, db_column='CodeBars')
    VatPrcnt = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='VatPrcnt')
    VatGroup = models.CharField(max_length=8, null=True, blank=True, db_column='VatGroup')

    def __str__(self):
        return f"DocEntry: {self.DocEntry}, ItemCode: {self.ItemCode}, LineNum: {self.LineNum}"

    

class ORIN(models.Model):  # NOTA DE CRÉDITO (Base)
    DocEntry = models.BigIntegerField(primary_key=True, default=0)
    DocNum = models.IntegerField(db_column='DocNum')
    DocType = models.CharField(max_length=120)
    DocDueDate = models.DateTimeField(null=True, blank=True, db_column='DocDueDate')
    DocTotal = models.DecimalField(max_digits=19, decimal_places=6)
    VatSum = models.DecimalField(null=True, max_digits=19, decimal_places=6)
    CardCode = models.ForeignKey(OCRD, on_delete=models.PROTECT, related_name='CD', null=True, default=None, db_column='CardCode')
    DocDate = models.DateTimeField(null=True, auto_now_add=False)
    DiscPrcnt = models.DecimalField(null=True, max_digits=16, decimal_places=6)
    ObjType = models.CharField(max_length=120)
    Series = models.IntegerField(null=True, blank=True, db_column='Series')

    def __str__(self):
        return str(self.DocEntry)
        

class RIN1(models.Model):
    id = models.AutoField(primary_key=True, default=1)
    DocEntry = models.ForeignKey(ORIN, on_delete=models.PROTECT, related_name='ORIN_lines', null=True, default=None, db_column='DocEntry')
    LineNum = models.IntegerField(db_column='LineNum')
    TargetType = models.IntegerField(null=True, blank=True, db_column='TargetType')
    TrgetEntry = models.BigIntegerField(null=True, blank=True, db_column='TrgetEntry')
    BaseRef = models.CharField(max_length=100, null=True, blank=True, db_column='BaseRef')
    BaseType = models.IntegerField(null=True, blank=True, db_column='BaseType')
    BaseEntry = models.BigIntegerField(null=True, blank=True, db_column='BaseEntry')
    BaseLine = models.IntegerField(null=True, blank=True, db_column='BaseLine')
    LineStatus = models.CharField(max_length=1, null=True, blank=True, db_column='LineStatus')
    ItemCode = models.ForeignKey(OITM, on_delete=models.PROTECT, related_name='LIN_oitm', null=True, default=None, db_column='temCode')
    Dscription = models.CharField(max_length=254, null=True, blank=True, db_column='Dscription')
    Quantity = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='Quantity')
    ShipDate = models.DateTimeField(null=True, blank=True, db_column='ShipDate')
    OpenQty = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenQty')
    Price = models.DecimalField(max_digits=19, decimal_places=6,null=True, blank=True,  db_column='Price')
    Currency = models.CharField(max_length=3, null=True, blank=True, db_column='Currency')
    Rate = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='Rate')
    DiscPrcnt = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='DiscPrcnt')
    LineTotal = models.DecimalField(max_digits=19, decimal_places=6, db_column='LineTotal')
    TotalFrgn = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='TotalFrgn')
    OpenSum = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenSum')
    OpenSumFC = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenSumFC')
    VendorNum = models.CharField(max_length=50, null=True, blank=True, db_column='VendorNum')
    SerialNum = models.CharField(max_length=50, null=True, blank=True, db_column='SerialNum')
    WhsCode = models.CharField(max_length=8, null=True, blank=True, db_column='WhsCode')
    SlpCode = models.IntegerField(null=True, blank=True, db_column='SlpCode')
    Commission = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='Commission')
    TreeType = models.CharField(max_length=1, null=True, blank=True, db_column='TreeType')
    AcctCode = models.CharField(max_length=15, null=True, blank=True, db_column='AcctCode')
    TaxStatus = models.CharField(max_length=1, null=True, blank=True, db_column='TaxStatus')
    GrossBuyPr = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='GrossBuyPr')
    PriceBefDi = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='PriceBefDi')
    DocDate = models.DateTimeField(null=True, blank=True, db_column='DocDate')
    Flags = models.IntegerField(null=True, blank=True, db_column='Flags')
    OpenCreQty = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenCreQty')
    UseBaseUn = models.CharField(max_length=1, null=True, blank=True, db_column='UseBaseUn')
    SubCatNum = models.IntegerField(null=True, blank=True, db_column='SubCatNum')
    BaseCard = models.CharField(max_length=15, null=True, blank=True, db_column='BaseCard')
    TotalSumSy = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='TotalSumSy')
    OpenSumSys = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='OpenSumSys')
    InvntSttus = models.CharField(max_length=1, null=True, blank=True, db_column='InvntSttus')
    OcrCode = models.CharField(max_length=8, null=True, blank=True, db_column='OcrCode')
    Project = models.CharField(max_length=20, null=True, blank=True, db_column='Project')
    CodeBars = models.CharField(max_length=254, null=True, blank=True, db_column='CodeBars')
    VatPrcnt = models.DecimalField(max_digits=19, decimal_places=6, null=True, blank=True, db_column='VatPrcnt')
    VatGroup = models.CharField(max_length=8, null=True, blank=True, db_column='VatGroup')

    def __str__(self):
        return f"DocEntry: {self.DocEntry}, ItemCode: {self.ItemCode}, LineNum: {self.LineNum}"

    
    
    
    

class Presupuesto_B1(models.Model):
    sucursal = models.CharField(max_length=50,  null=True, db_column='U_Sucursal')  # SUCURSAL
    linea = models.CharField(max_length=50, null=True, db_column='U_Linea')  # LÍNEA
    anio = models.IntegerField(db_column='U_Periodo')  
    enero = models.DecimalField(max_digits=19, decimal_places=6, null=True, db_column='U_Enero')  
    febrero = models.DecimalField(max_digits=19, decimal_places=6, null=True, db_column='U_Febrero')  
    marzo = models.DecimalField(max_digits=19, decimal_places=6, null=True, db_column='U_Marzo')  
    abril = models.DecimalField(max_digits=19, decimal_places=6, null=True, db_column='U_Abril')  
    mayo = models.DecimalField(max_digits=19, decimal_places=6, null=True, db_column='U_Mayo')  
    junio = models.DecimalField(max_digits=19, decimal_places=6, null=True, db_column='U_Junio')  
    julio = models.DecimalField(max_digits=19, decimal_places=6, null=True, db_column='U_Julio')  
    agosto = models.DecimalField(max_digits=19, decimal_places=6, null=True, db_column='U_Agosto') 
    septiembre = models.DecimalField(max_digits=19, decimal_places=6, null=True, db_column='U_Septiembre')  
    octubre = models.DecimalField(max_digits=19, decimal_places=6, null=True, db_column='U_Octubre')  
    noviembre = models.DecimalField(max_digits=19, decimal_places=6, null=True, db_column='U_Noviembre')  
    diciembre = models.DecimalField(max_digits=19, decimal_places=6, null=True, db_column='U_Diciembre')  
    
    class Meta:
        db_table = 'PRESUPUESTO_B1'  # Nombre de la tabla en la base de datos
    
    def __str__(self):
        return f"{self.sucursal} - {self.linea} - {self.año}"



class HLD1(models.Model): #Feriados
    StrDate = models.DateField(db_column='StrDate') #fecha del feriado 
    Rmrks = models.CharField(max_length=50, null=True, db_column='Rmrks') #nombre del feriado
    
    def __str__(self):
        return f"{self.StrDate}"




  
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
    
    
    