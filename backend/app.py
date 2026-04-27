import os
from flask import Flask, jsonify, request
from flask_cors import CORS
from dotenv import load_dotenv
from database_wrapper import DatabaseWrapper

# 1. Carichiamo le variabili dal file nascosto .env
load_dotenv()

app = Flask(__name__)

# 2. Abilitiamo i CORS così Angular e Flutter possono fare richieste a Flask
CORS(app)

# 3. Inizializziamo il DatabaseWrapper usando i dati del file .env
# Usiamo int() sulla porta perché i parametri di connessione la vogliono come numero
db = DatabaseWrapper(
    host=os.getenv("DB_HOST"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    database=os.getenv("DB_NAME"),
    port=int(os.getenv("DB_PORT"))
)

# --- ROTTE PER IL MENU (Prodotti) ---

# Prende tutti i prodotti (usata sia da Angular che da Flutter)
@app.route("/prodotti", methods=["GET"])
def get_prodotti():
    lista = db.get_menu()
    return jsonify(lista)

# Aggiunge un nuovo prodotto (usata dal Pannello Staff in Angular)
@app.route("/prodotti", methods=["POST"])
def add_prodotto():
    dati = request.json
    nome = dati.get('nome')
    prezzo = dati.get('prezzo')
    categoria = dati.get('categoria')
    
    if nome and prezzo and categoria:
        db.aggiungi_prodotto(nome, prezzo, categoria)
        return jsonify({"msg": "Prodotto aggiunto correttamente"}), 201
    return jsonify({"error": "Dati mancanti"}), 400

# Elimina un prodotto tramite ID (usata dal Pannello Staff in Angular)
@app.route("/prodotti/<int:id>", methods=["DELETE"])
def delete_prodotto(id):
    db.elimina_prodotto(id)
    return jsonify({"msg": f"Prodotto {id} eliminato"})


# --- ROTTE PER GLI ORDINI ---

# Prende la lista di tutti gli ordini (usata dal Pannello Staff in Angular)
@app.route("/ordini", methods=["GET"])
def get_ordini():
    lista = db.get_ordini()
    return jsonify(lista)

# Crea un nuovo ordine (usata dal Totem Cliente in Flutter)
@app.route("/ordini", methods=["POST"])
def crea_ordine():
    dati = request.json
    dettagli = dati.get('dettagli') # Esempio: "2x Cheeseburger, 1x Coca Cola"
    
    if dettagli:
        db.invia_ordine(dettagli)
        return jsonify({"msg": "Ordine inviato in cucina!"}), 201
    return jsonify({"error": "L'ordine è vuoto"}), 400

# Cambia lo stato di un ordine (es: da 'in corso' a 'pronto')
# Usiamo PATCH perché modifichiamo solo un pezzetto dell'ordine (lo stato)
@app.route("/ordini/<int:id>", methods=["PATCH"])
def update_ordine(id):
    dati = request.json
    nuovo_stato = dati.get('stato')
    
    if nuovo_stato:
        db.cambia_stato_ordine(id, nuovo_stato)
        return jsonify({"msg": "Stato ordine aggiornato"})
    return jsonify({"error": "Stato non fornito"}), 400


# 4. Avvio del server sulla porta 5000
if __name__ == '__main__':
    # debug=True serve per riavviare il server in automatico se modifichi il codice
    app.run(debug=True, port=5000)