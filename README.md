# Hamburgeria
1. Terminale BACKEND (Il più importante)
Senza questo, né il Totem né il Pannello Staff vedranno mai i dati.
Vai nel terminale del backend.
Installa le dipendenze  pip install flask flask-cors pymysql cryptography python-dotenv
Comando: python app.py
Verifica: Controlla nella tab PORTE che la 5000 sia Public.
2. sostituire nel flutter e nel frontend l'indirizzo del backend della nuova codespace
3. Terminale STAFF (Angular)
Apri un secondo terminale.
installa angular npm  i -g @angular/cli
Comando: cd staff-panel, npm i e poi ng serve
Verifica: Controlla nella tab PORTE che la 4200 sia Public.
4. Terminale TOTEM (Flutter)
Apri un terzo terminale.
Comando: cd totem_cliente e poi flutter run -d web-server --web-port 8080
Verifica: Controlla nella tab PORTE che la 8080 sia Public.
