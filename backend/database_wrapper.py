import pymysql

class DatabaseWrapper:
    # Il costruttore riceve i dati di Aiven
    def __init__(self, host, user, password, database, port):
        self.db_config = {
            'host': host,
            'user': user,
            'password': password,
            'database': database,
            'port': port, 
            'cursorclass': pymysql.cursors.DictCursor
        }
        self.create_tables() # Crea le tabelle all'avvio

    # Apre la connessione
    def connect(self):
        return pymysql.connect(**self.db_config)

    # Esegue query come INSERT, DELETE, UPDATE, CREATE
    def execute_query(self, query, params=()):
        conn = self.connect()
        with conn.cursor() as cursor:
            cursor.execute(query, params)
            conn.commit()
        conn.close()

    # Esegue query SELECT (ritorna una lista di dizionari)
    def fetch_query(self, query, params=()):
        conn = self.connect()
        with conn.cursor() as cursor:
            cursor.execute(query, params)
            result = cursor.fetchall()
        conn.close()
        return result

    # Qui creiamo le tabelle (come chiesto dal prof)
    def create_tables(self):
        # Tabella Prodotti
        self.execute_query('''
            CREATE TABLE IF NOT EXISTS prodotti (
                id INT AUTO_INCREMENT PRIMARY KEY,
                nome VARCHAR(100) NOT NULL,
                prezzo DECIMAL(10,2) NOT NULL,
                categoria VARCHAR(50) NOT NULL
            )
        ''')
        # Tabella Ordini
        self.execute_query('''
            CREATE TABLE IF NOT EXISTS ordini (
                id INT AUTO_INCREMENT PRIMARY KEY,
                stato VARCHAR(20) DEFAULT 'in corso',
                dettagli TEXT NOT NULL,
                data_ordine TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')

    # --- METODI PER L'APP ---
    def get_menu(self):
        return self.fetch_query("SELECT * FROM prodotti")

    def aggiungi_prodotto(self, nome, prezzo, categoria):
        self.execute_query("INSERT INTO prodotti (nome, prezzo, categoria) VALUES (%s, %s, %s)", (nome, prezzo, categoria))

    def elimina_prodotto(self, id_prodotto):
        self.execute_query("DELETE FROM prodotti WHERE id = %s", (id_prodotto,))

    def invia_ordine(self, dettagli):
        self.execute_query("INSERT INTO ordini (dettagli) VALUES (%s)", (dettagli,))

    def get_ordini(self):
        return self.fetch_query("SELECT * FROM ordini")

    def cambia_stato_ordine(self, id_ordine, nuovo_stato):
        self.execute_query("UPDATE ordini SET stato = %s WHERE id = %s", (nuovo_stato, id_ordine))