# Generated by Django 5.0.11 on 2025-02-27 19:31

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0008_alter_owhs_onhand'),
    ]

    operations = [
        migrations.AlterField(
            model_name='ocrd',
            name='GroupCode',
            field=models.IntegerField(blank=True, null=True),
        ),
        migrations.AlterField(
            model_name='ocrd',
            name='validFor',
            field=models.CharField(blank=True, max_length=120, null=True),
        ),
    ]
