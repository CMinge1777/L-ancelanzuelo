from django.contrib import admin
from django.urls import path
from django.http import HttpResponseRedirect
from django.utils.html import format_html
from django.urls import reverse
from .models import *
from . import game_logic

@admin.register(Juego)
class JuegoAdmin(admin.ModelAdmin):
    list_display = ('id', 'descripcion', 'finalizado', 'turno_actual', 'avanzar_turno_btn')
    
    def turno_actual(self, obj):
        return Turno.objects.filter(juego=obj).order_by('-turno_id').first().turno_id if Turno.objects.filter(juego=obj).exists() else 'N/A'
    
    def avanzar_turno_btn(self, obj):
        if obj.finalizado:
            return "Finalizado"
        return format_html(
            '<a class="button" href="{}">Avanzar Turno</a>',
            reverse('admin:avanzar_turno', args=[obj.pk])
        )
    avanzar_turno_btn.short_description = 'Acción'
    avanzar_turno_btn.allow_tags = True
    
    def get_urls(self):
        urls = super().get_urls()
        custom_urls = [
            path('<int:juego_id>/avanzar/', self.admin_site.admin_view(self.avanzar_turno_view), name='avanzar_turno'),
        ]
        return custom_urls + urls

    def avanzar_turno_view(self, request, juego_id):
        game_logic.avanzar_turno(juego_id)
        self.message_user(request, "Turno avanzado exitosamente.")
        return HttpResponseRedirect(reverse('admin:game_juego_changelist'))

admin.site.register(TipoBarco)
admin.site.register(TipoPez)
admin.site.register(Ubicacion)
admin.site.register(CostoOperativo)
admin.site.register(Compania)
admin.site.register(Turno)
admin.site.register(Decision)
admin.site.register(BarcosXCompania)
admin.site.register(Pez)
admin.site.register(Reporte)
admin.site.register(Pedido)
admin.site.register(Subasta)
admin.site.register(Oferta)
admin.site.register(Mensaje)
