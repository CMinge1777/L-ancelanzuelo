# Lance L'anzuelo

Juego de simulación de pesca multijugador.

## Instalación

1. `pip install -r requirements.txt`
2. `python manage.py makemigrations game`
3. `python manage.py migrate`
4. `python manage.py setup_inicial`
5. `python manage.py runserver` (o `daphne lancelanzuelo.asgi:application`)

## Acceso
http://localhost:8000/login/

Credenciales por defecto:
- Compañía: UNO (u otras como DOS, TRES, CUATRO)
- Contraseña: UNO (u otras)
- Juego ID: 1
