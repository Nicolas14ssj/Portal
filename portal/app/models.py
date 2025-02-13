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
    id_empleado = models.CharField(primary_key = True, max_length =30)
    nombre = models.CharField(max_length =60)
    apellido = models.CharField(max_length =60)
    departamento = models.CharField(max_length =30)
    cargo = models.CharField(max_length =60)
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
    name = models.CharField(max_length =30,)
    parent_id = models.IntegerField()
    order = models.IntegerField()
    id_perfil = models.ForeignKey(Perfiles,  on_delete=models.PROTECT, related_name='E', null=True, default=None)
    estado = models.ForeignKey(Estado,  on_delete=models.PROTECT, related_name='es', null=True, default=None)  

    
    def __str__(self):
        return str(self.track_id)
    



#MER
class OITM(models.Model):  # Maestro de Articulos
    Itemcode = models.IntegerField(primary_key=True)  # NUMERO DE ARTICULO
    ItemName = models.CharField(max_length=60)  # NOMBRE DE ARTICULO 
    
    def __str__(self):
        return str(self.Itemcode)
    
    

class ORTT(models.Model):  # maestro de tipo de cambio
    RateDate = models.DateTimeField(auto_now_add=False)  # FECHA DE TIPO DE CAMBIO
    Currency = models.CharField(max_length=60, primary_key=True)  # CODIGO DE MONETA
    Rate = models.CharField(max_length=40)  # TIPO DE CAMBIO
    
    def __str__(self):
        return self.Currency
    
    

class OITW(models.Model):  # STOCK x bodega
    Itemcode = models.ForeignKey(OITM, on_delete=models.PROTECT, related_name='n_items')  # NUMERO DE ARTICULO
    OnHand = models.IntegerField()  # EN STOCK 

    def __str__(self):
        return str(self.Itemcode)
    
    

class OWHS(models.Model):  # maestro de BODEGA
    WhsCode = models.CharField(max_length=60, primary_key=True)  # CODIGO DE ALMACEN 
    Itemcode = models.ForeignKey(OITM, on_delete=models.PROTECT, related_name='warehouse_items')  # NUMERO DE ARTICULO
    OnHand = models.IntegerField()  # EN STOCK 

    def __str__(self):
        return self.WhsCode
    
    class Meta:
        managed             = True  #quien administra la tabla es el modelo de django
        db_table            = 'OWHS' # le asignas un nombre a la base
        verbose_name        = 'Maestro de bodegas'
        verbose_name_plural = 'Maestro de bodegas'
    # en sap existen 3 tipos de negocios los leed que corresponden a algo no especifico, pueden ser clientes o proveedores y los ya mencionados


class OCRD(models.Model):  # maestro de socios de negocios  
    CardCode = models.CharField(max_length=60, primary_key=True)  # CODIGO SN 
    CardName = models.CharField(max_length=60)  # NOMBRE SN  
    CardType = models.CharField(max_length=60, default='No especifico')  # Tipo de socio de necogio   
    validFor = models.CharField(max_length=60)  # ACTIVO 
    
    def __str__(self):
        return self.CardCode 
    
    
     
class OINV(models.Model):  # cabecera de documentos de venta (FACTURA nota de debito - factura reserva-boleta etc) 
    DocNum = models.CharField(max_length=60, primary_key=True)  # NUMERO DE DOCUMENTO
    DocTotal = models.DecimalField(max_digits=10, decimal_places=2)  # total factura
    VatSum = models.DecimalField(max_digits=10, decimal_places=2)  # IMPUESTO TOTAL 
    CardCode = models.ForeignKey(OCRD, on_delete=models.PROTECT, related_name='invoices')  # Codgo de cliente/proveedor
    DocDate = models.DateTimeField(auto_now_add=False)  # fecha de contabilizacion 
    DiscPrcnt = models.DecimalField(max_digits=10, decimal_places=2)  # % DE DESCUENTO PARA DOCUMENTO 
    ObjType = models.CharField(max_length=50)  # TIPO DE OBJETO 
    OCRD_CardCode = models.ForeignKey(OCRD,  on_delete=models.PROTECT, related_name='C', null=True, default=None) 
           
    def __str__(self):
        return self.DocNum
    
    
    
class INV1(models.Model):  # DETALLE del documento de venta
    DocEntry = models.CharField(max_length=60, primary_key=True)  # NUMERO INTERNO DE DOCUMENTO 
    Itemcode = models.IntegerField()  # NUMERO DE ARTICULO
    Quantity = models.IntegerField()  # CANTIDAD
    LineTotal = models.IntegerField()  # TOTAL DE LINEAS
    GrossBuyPr = models.DecimalField(max_digits=10, decimal_places=2)  # PRECIO DE COSTE INGRESO BRUTO
    BaseEntry = models.CharField(max_length=50)  # ID INTERNO DE DOCUMENTO BASE
    BaseType = models.CharField(max_length=50)  # CLASE DE DOCUMENTO BASE
    TrgetEntry = models.CharField(max_length=50)  # ID INTERNO DE DOCUMENTO DE DESTINO
    DoCnum = models.ForeignKey(OINV, on_delete=models.PROTECT, related_name='nd', null=True, default=None) 
    OITM_ItemCode = models.ForeignKey(OITM,  on_delete=models.PROTECT, related_name='OP', null=True, default=None) 
    
    def __str__(self):
        return self.DocEntry
    


class OQUT(models.Model):  # COTIZACION (QUT1)
    DocTotal = models.DecimalField(max_digits=10, decimal_places=2)  # total factura
    VatSum = models.DecimalField(max_digits=10, decimal_places=2)  # IMPUESTO TOTAL 
    CardCode = models.CharField(max_length=60)  # CODIGO SN 
    DocDate = models.DateTimeField()  # fecha de contabilizacion 
    DiscPrcnt = models.DecimalField(max_digits=10, decimal_places=2)  # % DE DESCUENTO PARA DOCUMENTO 
    DocEntry = models.CharField(max_length=60, primary_key=True, default='0')  # NUMERO INTERNO DE DOCUMENTO 
    ObjType = models.CharField(max_length=50)  # TIPO DE OBJETO 
    OCRD_CardCode = models.ForeignKey(OCRD,  on_delete=models.PROTECT, related_name='CI', null=True, default=None) 
           
      
    def __str__(self):
        return self.DocEntry
    
    
    
    
class QUT1(models.Model):  # DETALLE 
    DocEntry = models.CharField(max_length=60, primary_key=True, default='None')  # NÚMERO INTERNO DE DOCUMENTO 
    Itemcode = models.IntegerField()  # NÚMERO DE ARTÍCULO
    Quantity = models.IntegerField()  # CANTIDAD
    LineTotal = models.IntegerField()  # TOTAL DE LÍNEAS
    GrossBuyPr = models.DecimalField(max_digits=10, decimal_places=2)  # PRECIO DE COSTE INGRESO BRUTO
    BaseEntry = models.CharField(max_length=50)  # ID INTERNO DE DOCUMENTO BASE
    BaseType = models.CharField(max_length=50)  # CLASE DE DOCUMENTO BASE
    TrgetEntry = models.CharField(max_length=50)  # ID INTERNO DE DOCUMENTO DE DESTINO
    OQUT_DocEntry = models.ForeignKey(OQUT, on_delete=models.PROTECT, related_name='qut1_entries',  null=True, default=None)  # Cambiado a OQUT_DocEntry para evitar confusión
    OITM_ItemCode = models.ForeignKey(OITM,  on_delete=models.PROTECT, related_name='OE', null=True, default=None) 
    
    def __str__(self):
        return self.DocEntry



class ORDR(models.Model):  # PEDIDOS (RDR1)
    DocTotal = models.DecimalField(max_digits=10, decimal_places=2)  # total factura
    VatSum = models.DecimalField(max_digits=10, decimal_places=2)  # IMPUESTO TOTAL 
    CardCode = models.CharField(max_length=60, )  # CODIGO SN 
    DocDate = models.DateTimeField(auto_now_add=False)  # fecha de contabilizacion 
    DiscPrcnt = models.DecimalField(max_digits=10, decimal_places=2)  # % DE DESCUENTO PARA DOCUMENTO 
    DocEntry = models.CharField(max_length=60, primary_key=True)  # NUMERO INTERNO DE DOCUMENTO 
    ObjType = models.CharField(max_length=50)  # TIPO DE OBJETO 
    OCRD_CardCode = models.ForeignKey(OCRD,  on_delete=models.PROTECT, related_name='CO', null=True, default=None) 
           
             
    def __str__(self):
        return self.DocEntry
    
    

class RDR1(models.Model):  # DETALLE 
    DocEntry = models.CharField(max_length=60, primary_key=True, default='None')  # NUMERO INTERNO DE DOCUMENTO 
    Itemcode = models.IntegerField()  # NUMERO DE ARTICULO
    Quantity = models.IntegerField()  # CANTIDAD
    LineTotal = models.IntegerField()  # TOTAL DE LINEAS
    GrossBuyPr = models.DecimalField(max_digits=10, decimal_places=2)  # PRECIO DE COSTE INGRESO BRUTO
    BaseEntry = models.CharField(max_length=50)  # ID INTERNO DE DOCUMENTO BASE
    BaseType = models.CharField(max_length=50)  # CLASE DE DOCUMENTO BASE
    TrgetEntry = models.CharField(max_length=50)  # ID INTERNO DE DOCUMENTO DE DESTINO
    ORDR_DocEntry = models.ForeignKey(ORDR, on_delete=models.PROTECT, related_name='cno', null=True, default=None) 
    OITM_ItemCode = models.ForeignKey(OITM,  on_delete=models.PROTECT, related_name='OI', null=True, default=None)  
    
    def __str__(self):
        return self.DocEntry


    
class ORIN(models.Model):  # NOTA DE CREDITO (RIN1)
    DocTotal = models.DecimalField(max_digits=10, decimal_places=2)  # total factura
    VatSum = models.DecimalField(max_digits=10, decimal_places=2)  # IMPUESTO TOTAL 
    CardCode = models.CharField(max_length=60, )  # CODIGO SN 
    DocDate = models.DateTimeField(auto_now_add=False)  # fecha de contabilizacion 
    DiscPrcnt = models.DecimalField(max_digits=10, decimal_places=2)  # % DE DESCUENTO PARA DOCUMENTO 
    DocEntry = models.CharField(max_length=60, primary_key=True)  # NUMERO INTERNO DE DOCUMENTO 
    ObjType = models.CharField(max_length=50)  # TIPO DE OBJETO 
    OCRD_CardCode = models.ForeignKey(OCRD,  on_delete=models.PROTECT, related_name='CD', null=True, default=None) 
           
         
    def __str__(self):
        return self.DocEntry




class RIN1(models.Model): 
    DocEntry = models.CharField(max_length=60, primary_key=True, default='None')  # NUMERO INTERNO DE DOCUMENTO 
    Itemcode = models.IntegerField()  # NUMERO DE ARTICULO
    Quantity = models.IntegerField()  # CANTIDAD
    LineTotal = models.IntegerField()  # TOTAL DE LINEAS
    GrossBuyPr = models.DecimalField(max_digits=10, decimal_places=2)  # PRECIO DE COSTE INGRESO BRUTO
    BaseEntry = models.CharField(max_length=50)  # ID INTERNO DE DOCUMENTO BASE
    BaseType = models.CharField(max_length=50)  # CLASE DE DOCUMENTO BASE
    TrgetEntry = models.CharField(max_length=50)  # ID INTERNO DE DOCUMENTO DE DESTINO
    ORIN_DocEntry = models.ForeignKey(ORIN, on_delete=models.PROTECT, related_name='c',  null=True, default=None)  
    OITM_ItemCode = models.ForeignKey(OITM,  on_delete=models.PROTECT, related_name='O', null=True, default=None) 
            
    def __str__(self):
        return self.BaseEntry
    


  
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
    
    
    