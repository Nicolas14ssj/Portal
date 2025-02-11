from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import Empleados, Rel_Perfiles_Modulos, Modulos, DetalleModulo, Perfiles, Estado





#crear detalle modulo: funsiona 
@receiver(post_save, sender=Modulos)
def crear_detalle_modulo(sender, instance, created, **kwargs):
    if created:
        # Crea un DetalleModulo con el mismo id_modulo
        DetalleModulo.objects.create(
            id_modulo=instance,
            descripcion=f"Detalle para {instance.nombre}"  
        )
        print(f"DetalleModulo creado para el módulo: {instance.nombre}")





# Llenar rel_perfiles_modulos
@receiver(post_save, sender=Empleados)
def crear_relaciones_empleado(sender, instance, created, **kwargs):
    if created:
        print(f"Señal activada para el empleado: {instance}")
        print(f"Empleado creado: {instance}")

        # Obten el primer estado
        estado = Estado.objects.first()
        print(f"Estado obtenido: {estado}")

        if estado is None:
            print("No hay estados disponibles.")
            return

        # Filtrar el módulo que coincida con el id del empleado
        modulo = Modulos.objects.filter(id_modulo=instance.id_perfil.id_perfil).first()
        
        if modulo:
            track_id = f"{int(modulo.id_modulo):02d}-00-00"
            parent_id = None  
            orden = '0'

            try:
                Rel_Perfiles_Modulos.objects.create(
                    id_detalle_mod=modulo,
                    name=modulo.nombre,
                    parent_id=parent_id,  
                    order=orden,
                    id_perfil=instance.id_perfil,
                    estado=estado,
                    track_id=track_id 
                )
                print(f"Relación creada para el módulo: {modulo.nombre} con track_id: {track_id}")
            except Exception as e:
                print(f"Error al crear Rel_Perfiles_Modulos: {e}")
        else:
            print("No se encontró un módulo correspondiente.")