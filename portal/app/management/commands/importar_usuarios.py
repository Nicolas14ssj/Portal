from django.core.management.base import BaseCommand
from django.contrib.auth.hashers import make_password
from app.models import Detalle_usuarios, Usuarios 

class Command(BaseCommand):
    help = 'Importa usuarios desde la tabla Detalle_usuarios a Usuarios'

    def handle(self, *args, **kwargs):
        creados = 0
        
        #Recorre todo detalle_usuario y despues compara por USERID si no existe lo inserta
        for detalle in Detalle_usuarios.objects.all():
            if Usuarios.objects.filter(USERID=detalle.USERID).exists():
                continue

            usuario = Usuarios(
                USERID=detalle.USERID,
                USER_CODE=detalle.USER_CODE,
                username=detalle.U_NAME or f"user_{detalle.USERID}",
                email=detalle.E_Mail or '',
                Branch=detalle.Branch,
                BranchName=detalle.BranchName,
                Department=detalle.Department,
                DepartmentName=detalle.DepartmentName,
                is_active=True,
                is_staff=False,
                is_superuser=False,
                password=make_password('ANWO1234'),
            )
            usuario.save()
            creados += 1

        self.stdout.write(self.style.SUCCESS(f'{creados} usuarios creados correctamente.'))
#agregar signals 