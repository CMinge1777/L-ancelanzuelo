import os

if __name__ == "__main__":
    os.system("python manage.py makemigrations game")
    os.system("python manage.py migrate")
    os.system("python manage.py setup_inicial")
    print("Setup completo")
