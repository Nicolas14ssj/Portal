# Generated by Django 5.0.11 on 2025-02-26 16:38

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0007_alter_owhs_itemcode'),
    ]

    operations = [
        migrations.AlterField(
            model_name='owhs',
            name='OnHand',
            field=models.IntegerField(blank=True, null=True),
        ),
    ]
