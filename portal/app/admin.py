from django.contrib import admin

# Register your models here.
from .models import OITM, ORTT, OITW, OWHS, OCRD, INV1, OINV, OQUT, ORDR, RIN1, QUT1, ORIN, RDR1, Modulos, DetalleModulo, Perfiles, Empleados, Estado, Rel_Perfiles_Modulos

# Registrando todos los modelos para que sean gestionables desde el panel de administración
admin.site.register(OITM)
admin.site.register(ORTT)
admin.site.register(OITW)
admin.site.register(OWHS)
admin.site.register(OCRD)
admin.site.register(INV1)
admin.site.register(OINV)
admin.site.register(OQUT)
admin.site.register(ORDR)
admin.site.register(RIN1)
admin.site.register(QUT1)
admin.site.register(RDR1)
admin.site.register(ORIN)
admin.site.register(Modulos)
admin.site.register(DetalleModulo)
admin.site.register(Perfiles)
admin.site.register(Empleados)
admin.site.register(Estado)
admin.site.register(Rel_Perfiles_Modulos)

