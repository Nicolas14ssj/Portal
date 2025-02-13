# forms.py
from django import forms
from .models import Empleados, Perfiles


#formulario crear empleado prueba 
class EmpleadoForm(forms.ModelForm):
    class Meta:
        model = Empleados
        fields = ['id_empleado', 'nombre', 'apellido', 'departamento', 'cargo', 'perfil']

