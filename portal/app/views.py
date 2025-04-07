from django.shortcuts import render, redirect
#from .forms import EmpleadoForm
from django.contrib import messages
from rest_framework import viewsets
from .models import (
    OITM, ORTT, OITW, OWHS, Series, OCRD, INV1, OINV, OQUT, ORDR, RIN1, QUT1, ORIN, RDR1, 
    Modulos, DetalleModulo, Perfiles, Detalle_usuarios, Usuarios, Estado, Rel_Perfiles_Modulos, Presupuesto_B1, HLD1, OSLP, 
)
from .serializers import (
    OITMSerializer, ORTTSerializer, OITWSerializer, OWHSSerializer, SeriesSerializer ,OCRDSerializer, 
    INV1Serializer, OINVSerializer, OQUTSerializer, ORDRSerializer, RIN1Serializer, 
    QUT1Serializer, ORINSerializer, RDR1Serializer, ModulosSerializer, DetalleModuloSerializer, 
    PerfilesSerializer, Detalle_usuariosSerializer, UsuariosSerializer, EstadoSerializer, RelPerfilesModulosSerializer, 
    PresupuestoB1Serializer, HLD1Serializer, OSLPSerializer, 
    )

# def crear_empleado(request):
#     if request.method == 'POST':
#         form = EmpleadoForm(request.POST)
#         if form.is_valid():
#             form.save()  
#             messages.success(request, 'Empleado creado con éxito.')
#             return redirect('crear_empleado.html')  
#     else:
#         form = EmpleadoForm()
#     return render(request, 'crear_empleado.html', {'form': form})

# --- VIEWSETS ---
# ViewSet para Modulos
class ModulosViewsets(viewsets.ModelViewSet):
    queryset = Modulos.objects.all().order_by('id_modulo')
    serializer_class = ModulosSerializer

# ViewSet para DetalleModulo
class DetalleModuloViewsets(viewsets.ModelViewSet):
    queryset = DetalleModulo.objects.all().order_by('id_modulo')
    serializer_class = DetalleModuloSerializer

# ViewSet para Perfiles
class PerfilesViewsets(viewsets.ModelViewSet):
    queryset = Perfiles.objects.all().order_by('id_perfil')
    serializer_class = PerfilesSerializer

# ViewSet para Detalle_suarios
class Detalle_usuariosViewsets(viewsets.ModelViewSet):
    queryset = Detalle_usuarios.objects.all().order_by('USERID')
    serializer_class = Detalle_usuariosSerializer
    
# ViewSet para Usuarios
class UsuariosViewsets(viewsets.ModelViewSet):
    queryset = Usuarios.objects.all().order_by('USERID')
    serializer_class = UsuariosSerializer
    
# ViewSet para Estado
class EstadoViewsets(viewsets.ModelViewSet):
    queryset = Estado.objects.all().order_by('id_estado')
    serializer_class = EstadoSerializer

# ViewSet para Rel_Perfiles_Modulos
class RelPerfilesModulosViewsets(viewsets.ModelViewSet):
    queryset = Rel_Perfiles_Modulos.objects.all().order_by('track_id')
    serializer_class = RelPerfilesModulosSerializer

# ViewSet para OITM
class OITMViewsets(viewsets.ModelViewSet):
    queryset = OITM.objects.all().order_by('ItemCode')  
    serializer_class = OITMSerializer

# ViewSet para ORTT
class ORTTViewsets(viewsets.ModelViewSet):
    queryset = ORTT.objects.all().order_by('Currency')
    serializer_class = ORTTSerializer

# ViewSet para OITW
class OITWViewsets(viewsets.ModelViewSet):
    queryset = OITW.objects.all().order_by('Itemcode') 
    serializer_class = OITWSerializer

# ViewSet para OWHS
class OWHSViewsets(viewsets.ModelViewSet):
    queryset = OWHS.objects.all().order_by('WhsCode')
    serializer_class = OWHSSerializer
    
# viewSet para Series 
class SeriesViewset(viewsets.ModelViewSet):
    queryset = Series.objects.all().order_by('Series')
    serializer_class = SeriesSerializer
    

# ViewSet para OCRD
class OCRDViewsets(viewsets.ModelViewSet):
    queryset = OCRD.objects.all().order_by('CardCode')
    serializer_class = OCRDSerializer

# ViewSet para OINV
class OINVViewsets(viewsets.ModelViewSet):
    queryset = OINV.objects.all().order_by('DocNum')
    serializer_class = OINVSerializer

# ViewSet para INV1
class INV1Viewsets(viewsets.ModelViewSet):
    queryset = INV1.objects.all().order_by('DocEntry')
    serializer_class = INV1Serializer

# ViewSet para OQUT
class OQUTViewsets(viewsets.ModelViewSet):
    queryset = OQUT.objects.all().order_by('DocEntry')
    serializer_class = OQUTSerializer

# ViewSet para QUT1
class QUT1Viewsets(viewsets.ModelViewSet):
    queryset = QUT1.objects.all().order_by('DocEntry')
    serializer_class = QUT1Serializer

# ViewSet para ORDR
class ORDRViewsets(viewsets.ModelViewSet):
    queryset = ORDR.objects.all().order_by('DocEntry')
    serializer_class = ORDRSerializer

# ViewSet para RDR1
class RDR1Viewsets(viewsets.ModelViewSet):
    queryset = RDR1.objects.all().order_by('DocEntry')
    serializer_class = RDR1Serializer

# ViewSet para ORIN
class ORINViewsets(viewsets.ModelViewSet):
    queryset = ORIN.objects.all().order_by('DocEntry')
    serializer_class = ORINSerializer

# ViewSet para RIN1
class RIN1Viewsets(viewsets.ModelViewSet):
    queryset = RIN1.objects.all().order_by('DocEntry')
    serializer_class = RIN1Serializer

# ViewSet para Presupuesto_B1
class PresupuestoB1Viewsets(viewsets.ModelViewSet):
    queryset = Presupuesto_B1.objects.all().order_by('anio')
    serializer_class = PresupuestoB1Serializer

# ViewSet para HLD1
class HLD1Viewsets(viewsets.ModelViewSet):
    queryset = HLD1.objects.all().order_by('StrDate')
    serializer_class  = HLD1Serializer


class OSLPViewsets(viewsets.ModelViewSet):
    queryset = OSLP.objects.all().order_by('SlpCode')
    serializer_class  = OSLPSerializer


# class OUSRViewsets(viewsets.ModelViewSet):
#     queryset = OUSR.objects.all().order_by('USERID')
#     serializer_class  = OUSRSerializer
