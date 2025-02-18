# Generated by Django 5.0.11 on 2025-02-12 20:37

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Estado',
            fields=[
                ('id_estado', models.CharField(max_length=30, primary_key=True, serialize=False)),
                ('nombre', models.CharField(choices=[('AUTORIZADO', 'autorizado'), ('LECTURA', 'lectura'), ('NO AUTORIZADO', 'no autorizado')], default='NO AUTORIZADO', max_length=30)),
            ],
        ),
        migrations.CreateModel(
            name='Modulos',
            fields=[
                ('id_modulo', models.CharField(max_length=30, primary_key=True, serialize=False)),
                ('nombre', models.CharField(max_length=30)),
            ],
        ),
        migrations.CreateModel(
            name='DetalleModulo',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('descripcion', models.CharField(max_length=120)),
                ('acceso', models.CharField(max_length=60)),
                ('id_modulo', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, related_name='Idm', to='app.modulos')),
            ],
        ),
        migrations.CreateModel(
            name='Perfiles',
            fields=[
                ('id_perfil', models.CharField(max_length=30, primary_key=True, serialize=False)),
                ('nombre', models.CharField(max_length=30)),
                ('descripcion', models.CharField(max_length=30)),
                ('modulos', models.ManyToManyField(related_name='perfiles', to='app.modulos')),
            ],
        ),
        migrations.CreateModel(
            name='Empleados',
            fields=[
                ('id_empleado', models.CharField(max_length=30, primary_key=True, serialize=False)),
                ('nombre', models.CharField(max_length=60)),
                ('apellido', models.CharField(max_length=60)),
                ('departamento', models.CharField(max_length=30)),
                ('cargo', models.CharField(max_length=60)),
                ('perfil', models.ForeignKey(default=1, on_delete=django.db.models.deletion.PROTECT, related_name='empleados', to='app.perfiles')),
            ],
        ),
        migrations.CreateModel(
            name='Rel_Perfiles_Modulos',
            fields=[
                ('track_id', models.IntegerField(primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=30)),
                ('parent_id', models.IntegerField()),
                ('order', models.IntegerField()),
                ('estado', models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.PROTECT, related_name='es', to='app.estado')),
                ('id_detalle_mod', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, related_name='Iddm', to='app.detallemodulo')),
                ('id_perfil', models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.PROTECT, related_name='E', to='app.perfiles')),
            ],
        ),
    ]
