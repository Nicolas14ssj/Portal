# Generated by Django 5.0.11 on 2025-01-24 17:51

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='MaeCargos',
            fields=[
                ('cargo', models.CharField(default='Sistemas', max_length=50, primary_key=True, serialize=False, unique=True)),
                ('nombre', models.CharField(db_column='nombre', default=None, max_length=100)),
            ],
            options={
                'verbose_name': 'Cargos en la empresa',
                'verbose_name_plural': 'Cargos en la empresa',
                'db_table': 'maeCargo',
                'managed': True,
            },
        ),
        migrations.CreateModel(
            name='MaeLugar',
            fields=[
                ('lugar', models.CharField(default='Sistemas', max_length=50, primary_key=True, serialize=False, unique=True)),
                ('nombre', models.CharField(db_column='nombre', default=None, max_length=100)),
            ],
            options={
                'verbose_name': 'Lugar en la empresa',
                'verbose_name_plural': 'Lugar en la empresa',
                'db_table': 'maeLugar',
                'managed': True,
            },
        ),
        migrations.CreateModel(
            name='OCRD',
            fields=[
                ('CardCode', models.CharField(max_length=60, primary_key=True, serialize=False)),
                ('CardName', models.CharField(max_length=60)),
                ('CardType', models.CharField(default='No especifico', max_length=60)),
                ('validFor', models.CharField(max_length=60)),
            ],
        ),
        migrations.CreateModel(
            name='OITM',
            fields=[
                ('Itemcode', models.IntegerField(primary_key=True, serialize=False)),
                ('ItemName', models.CharField(max_length=60)),
            ],
        ),
        migrations.CreateModel(
            name='ORTT',
            fields=[
                ('RateDate', models.DateTimeField()),
                ('Currency', models.CharField(max_length=60, primary_key=True, serialize=False)),
                ('Rate', models.CharField(max_length=40)),
            ],
        ),
        migrations.CreateModel(
            name='OINV',
            fields=[
                ('DocNum', models.CharField(max_length=60, primary_key=True, serialize=False)),
                ('DocTotal', models.DecimalField(decimal_places=2, max_digits=10)),
                ('VatSum', models.DecimalField(decimal_places=2, max_digits=10)),
                ('DocDate', models.DateTimeField()),
                ('DiscPrcnt', models.DecimalField(decimal_places=2, max_digits=10)),
                ('ObjType', models.CharField(max_length=50)),
                ('CardCode', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, related_name='invoices', to='app.ocrd')),
                ('OCRD_CardCode', models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.PROTECT, related_name='C', to='app.ocrd')),
            ],
        ),
        migrations.CreateModel(
            name='INV1',
            fields=[
                ('DocEntry', models.CharField(max_length=60, primary_key=True, serialize=False)),
                ('Itemcode', models.IntegerField()),
                ('Quantity', models.IntegerField()),
                ('LineTotal', models.IntegerField()),
                ('GrossBuyPr', models.DecimalField(decimal_places=2, max_digits=10)),
                ('BaseEntry', models.CharField(max_length=50)),
                ('BaseType', models.CharField(max_length=50)),
                ('TrgetEntry', models.CharField(max_length=50)),
                ('DoCnum', models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.PROTECT, related_name='nd', to='app.oinv')),
                ('OITM_ItemCode', models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.PROTECT, related_name='OP', to='app.oitm')),
            ],
        ),
        migrations.CreateModel(
            name='OITW',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('OnHand', models.IntegerField()),
                ('Itemcode', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, related_name='n_items', to='app.oitm')),
            ],
        ),
        migrations.CreateModel(
            name='OQUT',
            fields=[
                ('DocTotal', models.DecimalField(decimal_places=2, max_digits=10)),
                ('VatSum', models.DecimalField(decimal_places=2, max_digits=10)),
                ('CardCode', models.CharField(max_length=60)),
                ('DocDate', models.DateTimeField()),
                ('DiscPrcnt', models.DecimalField(decimal_places=2, max_digits=10)),
                ('DocEntry', models.CharField(default='0', max_length=60, primary_key=True, serialize=False)),
                ('ObjType', models.CharField(max_length=50)),
                ('OCRD_CardCode', models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.PROTECT, related_name='CI', to='app.ocrd')),
            ],
        ),
        migrations.CreateModel(
            name='ORDR',
            fields=[
                ('DocTotal', models.DecimalField(decimal_places=2, max_digits=10)),
                ('VatSum', models.DecimalField(decimal_places=2, max_digits=10)),
                ('CardCode', models.CharField(max_length=60)),
                ('DocDate', models.DateTimeField()),
                ('DiscPrcnt', models.DecimalField(decimal_places=2, max_digits=10)),
                ('DocEntry', models.CharField(max_length=60, primary_key=True, serialize=False)),
                ('ObjType', models.CharField(max_length=50)),
                ('OCRD_CardCode', models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.PROTECT, related_name='CO', to='app.ocrd')),
            ],
        ),
        migrations.CreateModel(
            name='ORIN',
            fields=[
                ('DocTotal', models.DecimalField(decimal_places=2, max_digits=10)),
                ('VatSum', models.DecimalField(decimal_places=2, max_digits=10)),
                ('CardCode', models.CharField(max_length=60)),
                ('DocDate', models.DateTimeField()),
                ('DiscPrcnt', models.DecimalField(decimal_places=2, max_digits=10)),
                ('DocEntry', models.CharField(max_length=60, primary_key=True, serialize=False)),
                ('ObjType', models.CharField(max_length=50)),
                ('OCRD_CardCode', models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.PROTECT, related_name='CD', to='app.ocrd')),
            ],
        ),
        migrations.CreateModel(
            name='OWHS',
            fields=[
                ('WhsCode', models.CharField(max_length=60, primary_key=True, serialize=False)),
                ('OnHand', models.IntegerField()),
                ('Itemcode', models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, related_name='warehouse_items', to='app.oitm')),
            ],
            options={
                'verbose_name': 'Maestro de bodegas',
                'verbose_name_plural': 'Maestro de bodegas',
                'db_table': 'OWHS',
                'managed': True,
            },
        ),
        migrations.CreateModel(
            name='QUT1',
            fields=[
                ('DocEntry', models.CharField(default='None', max_length=60, primary_key=True, serialize=False)),
                ('Itemcode', models.IntegerField()),
                ('Quantity', models.IntegerField()),
                ('LineTotal', models.IntegerField()),
                ('GrossBuyPr', models.DecimalField(decimal_places=2, max_digits=10)),
                ('BaseEntry', models.CharField(max_length=50)),
                ('BaseType', models.CharField(max_length=50)),
                ('TrgetEntry', models.CharField(max_length=50)),
                ('OITM_ItemCode', models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.PROTECT, related_name='OE', to='app.oitm')),
                ('OQUT_DocEntry', models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.PROTECT, related_name='qut1_entries', to='app.oqut')),
            ],
        ),
        migrations.CreateModel(
            name='RDR1',
            fields=[
                ('DocEntry', models.CharField(default='None', max_length=60, primary_key=True, serialize=False)),
                ('Itemcode', models.IntegerField()),
                ('Quantity', models.IntegerField()),
                ('LineTotal', models.IntegerField()),
                ('GrossBuyPr', models.DecimalField(decimal_places=2, max_digits=10)),
                ('BaseEntry', models.CharField(max_length=50)),
                ('BaseType', models.CharField(max_length=50)),
                ('TrgetEntry', models.CharField(max_length=50)),
                ('OITM_ItemCode', models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.PROTECT, related_name='OI', to='app.oitm')),
                ('ORDR_DocEntry', models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.PROTECT, related_name='cno', to='app.ordr')),
            ],
        ),
        migrations.CreateModel(
            name='RIN1',
            fields=[
                ('DocEntry', models.CharField(default='None', max_length=60, primary_key=True, serialize=False)),
                ('Itemcode', models.IntegerField()),
                ('Quantity', models.IntegerField()),
                ('LineTotal', models.IntegerField()),
                ('GrossBuyPr', models.DecimalField(decimal_places=2, max_digits=10)),
                ('BaseEntry', models.CharField(max_length=50)),
                ('BaseType', models.CharField(max_length=50)),
                ('TrgetEntry', models.CharField(max_length=50)),
                ('OITM_ItemCode', models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.PROTECT, related_name='O', to='app.oitm')),
                ('ORIN_DocEntry', models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.PROTECT, related_name='c', to='app.orin')),
            ],
        ),
    ]
