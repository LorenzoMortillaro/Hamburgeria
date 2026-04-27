# Hamburgeria
1. Terminale BACKEND (Il più importante)
Senza questo, né il Totem né il Pannello Staff vedranno mai i dati.
Vai nel terminale del backend.
Comando: python app.py
Verifica: Controlla nella tab PORTE che la 5000 sia Public.
2. Terminale STAFF (Angular)
Apri un secondo terminale.
Comando: cd staff-panel e poi ng serve
Verifica: Controlla nella tab PORTE che la 4200 sia Public.
3. Terminale TOTEM (Flutter)
Apri un terzo terminale.
Comando: cd totem_cliente e poi flutter run -d web-server --web-port 8080 --web-renderer html
Verifica: Controlla nella tab PORTE che la 8080 sia Public.