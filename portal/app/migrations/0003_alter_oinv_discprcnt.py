# Generated by Django 5.0.11 on 2025-03-07 01:31

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('app', '0002_alter_ortt_currency_alter_ortt_ratedate'),
    ]

    operations = [
        migrations.AlterField(
            model_name='oinv',
            name='DiscPrcnt',
            field=models.DecimalField(db_column='DiscPrcnt', decimal_places=2, max_digits=10, null=True),
        ),
    ]
