import os
from flask import Flask, jsonify, request
from flask_cors import CORS
from dotenv import load_dotenv
from database_wrapper import DatabaseWrapper

load_dotenv()
app = Flask(__name__)
CORS(app)

db = DatabaseWrapper(
    host=os.getenv("DB_HOST"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    database=os.getenv("DB_NAME"),
    port=int(os.getenv("DB_PORT"))
)

@app.route("/prodotti", methods=["GET"])
def get_prodotti():
    return jsonify(db.get_menu())

@app.route("/prodotti", methods=["POST"])
def add_prodotto():
    dati = request.json
    # Passiamo anche l'immagine al database wrapper
    db.aggiungi_prodotto(dati['nome'], dati['prezzo'], dati['categoria'], dati['immagine'])
    return jsonify({"msg": "Prodotto aggiunto"}), 201

@app.route("/prodotti/<int:id>", methods=["DELETE"])
def delete_prodotto(id):
    db.elimina_prodotto(id)
    return jsonify({"msg": "Eliminato"})

@app.route("/ordini", methods=["GET"])
def get_ordini():
    return jsonify(db.get_ordini())

@app.route("/ordini", methods=["POST"])
def crea_ordine():
    dati = request.json
    db.invia_ordine(dati['dettagli'])
    return jsonify({"msg": "Inviato"}), 201

@app.route("/ordini/<int:id>", methods=["PATCH"])
def update_ordine(id):
    dati = request.json
    db.cambia_stato_ordine(id, dati['stato'])
    return jsonify({"msg": "Aggiornato"})

if __name__ == '__main__':
    app.run(debug=True, port=5000)