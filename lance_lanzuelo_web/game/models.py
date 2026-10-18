from django.db import models

class TipoBarco(models.Model):
    nombre = models.CharField(max_length=20)
    precio = models.BigIntegerField()
    capacidad = models.IntegerField()

class TipoPez(models.Model):
    nombre = models.CharField(max_length=25)
    precio = models.IntegerField()  # precio por kg

class Ubicacion(models.Model):
    nombre = models.CharField(max_length=45)  # PUERTO, COSTA, MAR PROFUNDO

class CostoOperativo(models.Model):
    ubicacion = models.ForeignKey(Ubicacion, on_delete=models.CASCADE)
    tipo_barco = models.ForeignKey(TipoBarco, on_delete=models.CASCADE)
    valor = models.BigIntegerField()

class Juego(models.Model):
    descripcion = models.CharField(max_length=500, blank=True)
    duracion_turnos = models.IntegerField()  # en minutos
    fecha_inicio = models.DateTimeField(auto_now_add=True)
    finalizado = models.BooleanField(default=False)
    max_turnos = models.IntegerField(default=11)

class Compania(models.Model):
    nombre = models.CharField(max_length=15)
    password = models.CharField(max_length=15)
    juego = models.ForeignKey(Juego, on_delete=models.CASCADE)
    ubicacion_terrestre = models.IntegerField()  # 1=Necocli/Azul, 2=Turbo/Verde, 3=BocasAtrato/Rojo, 4=Acandí/Amarillo
    estado_resultados = models.BigIntegerField(default=500000000)  # balance acumulado
    costo_ultimo_turno = models.BigIntegerField(default=0)
    
    class Meta:
        unique_together = ('nombre', 'juego')

class Turno(models.Model):
    turno_id = models.IntegerField()
    juego = models.ForeignKey(Juego, on_delete=models.CASCADE)
    insercion = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        unique_together = ('turno_id', 'juego')

class Decision(models.Model):  # posicionamiento de barcos
    compania = models.ForeignKey(Compania, on_delete=models.CASCADE)
    turno = models.ForeignKey(Turno, on_delete=models.CASCADE)
    chalupas_costa = models.IntegerField(default=0)
    chalupas_mar_profundo = models.IntegerField(default=0)
    chalupas_puerto = models.IntegerField(default=0)
    pangas_costa = models.IntegerField(default=0)
    pangas_mar_profundo = models.IntegerField(default=0)
    pangas_puerto = models.IntegerField(default=0)
    pesqueros_costa = models.IntegerField(default=0)
    pesqueros_mar_profundo = models.IntegerField(default=0)
    pesqueros_puerto = models.IntegerField(default=0)

class BarcosXCompania(models.Model):  # inventario actual de barcos
    compania = models.ForeignKey(Compania, on_delete=models.CASCADE)
    tipo_barco = models.ForeignKey(TipoBarco, on_delete=models.CASCADE)
    ubicacion = models.ForeignKey(Ubicacion, on_delete=models.CASCADE)
    cantidad = models.IntegerField(default=0)
    
    class Meta:
        unique_together = ('compania', 'tipo_barco', 'ubicacion')

class Pez(models.Model):
    tipo_pez = models.ForeignKey(TipoPez, on_delete=models.CASCADE)
    ubicacion = models.ForeignKey(Ubicacion, on_delete=models.CASCADE)
    turno = models.ForeignKey(Turno, on_delete=models.CASCADE)
    poblacion = models.BigIntegerField(default=0)

class Reporte(models.Model):
    compania = models.ForeignKey(Compania, on_delete=models.CASCADE)
    turno = models.ForeignKey(Turno, on_delete=models.CASCADE)
    captura_robalo_costa = models.BigIntegerField(default=0)
    captura_robalo_mar_profundo = models.BigIntegerField(default=0)
    captura_sierra_costa = models.BigIntegerField(default=0)
    captura_sierra_mar_profundo = models.BigIntegerField(default=0)
    captura_pargo_costa = models.BigIntegerField(default=0)
    captura_pargo_mar_profundo = models.BigIntegerField(default=0)
    balance_general = models.BigIntegerField(default=0)  # ingresos del turno

class Pedido(models.Model):
    compania = models.ForeignKey(Compania, on_delete=models.CASCADE)
    turno = models.ForeignKey(Turno, on_delete=models.CASCADE)
    num_chalupas = models.IntegerField(default=0)
    num_pangas = models.IntegerField(default=0)
    num_pesqueros = models.IntegerField(default=0)
    
    class Meta:
        unique_together = ('compania', 'turno')

class Subasta(models.Model):
    turno = models.OneToOneField(Turno, on_delete=models.CASCADE)
    abierta = models.BooleanField(default=True)
    costo_base = models.BigIntegerField(default=0)
    num_chalupas = models.IntegerField(default=0)
    num_pangas = models.IntegerField(default=0)
    num_pesqueros = models.IntegerField(default=0)

class Oferta(models.Model):
    compania = models.ForeignKey(Compania, on_delete=models.CASCADE)
    subasta = models.ForeignKey(Subasta, on_delete=models.CASCADE)
    valor = models.BigIntegerField()
    
    class Meta:
        unique_together = ('compania', 'subasta')

class Mensaje(models.Model):
    turno = models.ForeignKey(Turno, on_delete=models.CASCADE)
    texto = models.TextField(blank=True)
