import pymysql

class DatabaseWrapper:
    def __init__(self, host, user, password, database, port):
        self.db_config = {
            'host': host, 'user': user, 'password': password,
            'database': database, 'port': port, 
            'cursorclass': pymysql.cursors.DictCursor
        }
        self.create_tables()

    def connect(self):
        return pymysql.connect(**self.db_config)

    def execute_query(self, query, params=()):
        conn = self.connect()
        with conn.cursor() as cursor:
            cursor.execute(query, params)
            conn.commit()
        conn.close()

    def fetch_query(self, query, params=()):
        conn = self.connect()
        with conn.cursor() as cursor:
            cursor.execute(query, params)
            result = cursor.fetchall()
        conn.close()
        return result

    def create_tables(self):
        # 1. Creazione tabella prodotti (con colonna immagine)
        self.execute_query('''
            CREATE TABLE IF NOT EXISTS prodotti (
                id INT AUTO_INCREMENT PRIMARY KEY,
                nome VARCHAR(100) NOT NULL,
                prezzo DECIMAL(10,2) NOT NULL,
                categoria VARCHAR(50) NOT NULL,
                immagine VARCHAR(500)
            )
        ''')
        
        # 2. TRUCCO: Questo comando aggiunge la colonna 'immagine' se la tabella esiste già da prima
        # Lo mettiamo in un try/except così se la colonna c'è già non dà errore e va avanti
        try:
            self.execute_query("ALTER TABLE prodotti ADD COLUMN immagine VARCHAR(500)")
        except:
            pass # Se dà errore significa che la colonna c'è già, quindi tutto ok

        # 3. Tabella Ordini
        self.execute_query('''
            CREATE TABLE IF NOT EXISTS ordini (
                id INT AUTO_INCREMENT PRIMARY KEY,
                stato VARCHAR(20) DEFAULT 'in corso',
                dettagli TEXT NOT NULL,
                data_ordine TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')

    def get_menu(self):
        return self.fetch_query("SELECT * FROM prodotti")

    def aggiungi_prodotto(self, nome, prezzo, categoria, immagine):
        self.execute_query("INSERT INTO prodotti (nome, prezzo, categoria, immagine) VALUES (%s, %s, %s, %s)", 
                           (nome, prezzo, categoria, immagine))

    def elimina_prodotto(self, id_prodotto):
        self.execute_query("DELETE FROM prodotti WHERE id = %s", (id_prodotto,))

    def invia_ordine(self, dettagli):
        self.execute_query("INSERT INTO ordini (dettagli) VALUES (%s)", (dettagli,))

    def get_ordini(self):
        return self.fetch_query("SELECT * FROM ordini ORDER BY data_ordine DESC")

    def cambia_stato_ordine(self, id_ordine, nuovo_stato):
        self.execute_query("UPDATE ordini SET stato = %s WHERE id = %s", (nuovo_stato, id_ordine))