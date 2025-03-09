# urls.py
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from django.contrib import admin
from .views import (
    crear_empleado, ModulosViewsets, DetalleModuloViewsets, PerfilesViewsets, EmpleadosViewsets,
    EstadoViewsets, RelPerfilesModulosViewsets, OITMViewsets, ORTTViewsets,
    OITWViewsets, OWHSViewsets, OCRDViewsets, OINVViewsets, INV1Viewsets,
    OQUTViewsets, QUT1Viewsets, ORDRViewsets, RDR1Viewsets, ORINViewsets,
    RIN1Viewsets, PresupuestoB1Viewsets
)

# Creación del router para los ViewSets
router = DefaultRouter()
router.register(r'modulos', ModulosViewsets)
router.register(r'detalle-modulo', DetalleModuloViewsets)
router.register(r'perfiles', PerfilesViewsets)
router.register(r'empleados', EmpleadosViewsets)
router.register(r'estado', EstadoViewsets)
router.register(r'rel-perfiles-modulos', RelPerfilesModulosViewsets)
router.register(r'oitm', OITMViewsets)
router.register(r'ortt', ORTTViewsets)
router.register(r'oitw', OITWViewsets)
router.register(r'owhs', OWHSViewsets)
router.register(r'ocrd', OCRDViewsets)
router.register(r'oinv', OINVViewsets)
router.register(r'inv1', INV1Viewsets)
router.register(r'oqut', OQUTViewsets)
router.register(r'qut1', QUT1Viewsets)
router.register(r'ordr', ORDRViewsets)
router.register(r'rdr1', RDR1Viewsets)
router.register(r'orin', ORINViewsets)
router.register(r'rin1', RIN1Viewsets)
router.register(r'presupuesto-b1', PresupuestoB1Viewsets)

urlpatterns = [
    path('', include(router.urls)),
    path('api-auth/', include('rest_framework.urls', namespace='rest_framework')),
    path('crear-empleado/', crear_empleado, name='crear_empleado'),
    
]

