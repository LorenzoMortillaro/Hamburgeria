import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.orange),
    home: const TotemHome(),
    debugShowCheckedModeBanner: false,
  ));
}

class TotemHome extends StatefulWidget {
  const TotemHome({super.key});
  @override
  State<TotemHome> createState() => _TotemHomeState();
}

class _TotemHomeState extends State<TotemHome> {
  // SOSTITUISCI CON IL TUO URL PORTA 5000
  final String apiUrl = "https://orange-train-r49945x7x69g2x456-5000.app.github.dev";
  List prodotti = [];
  List carrello = []; // Lista di nomi prodotti (es: ["cheeseburger", "cheeseburger", "cola"])

  @override
  void initState() {
    super.initState();
    caricaMenu();
  }

  Future<void> caricaMenu() async {
    try {
      final res = await http.get(Uri.parse('$apiUrl/prodotti'));
      if (res.statusCode == 200) {
        if (!mounted) return;
        setState(() => prodotti = json.decode(res.body));
      }
    } catch (e) { debugPrint("Errore: $e"); }
  }

  Future<void> inviaOrdine() async {
    if (carrello.isEmpty) return;
    try {
      final res = await http.post(
        Uri.parse('$apiUrl/ordini'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'dettagli': carrello.join(", ")}),
      );
      if (!mounted) return;
      if (res.statusCode == 201) {
        setState(() => carrello = []);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🍔 Ordine inviato! Prendi lo scontrino.'))
        );
      }
    } catch (e) { debugPrint("Errore: $e"); }
  }

  // Funzione per contare quante volte un prodotto è nel carrello
  int quanteInCarrello(String nome) {
    return carrello.where((item) => item == nome).length;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    int columns = width > 1200 ? 4 : (width > 800 ? 3 : 2);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orange[800],
        elevation: 8,
        title: const Text("HAMBURGERIA L & A 🍔", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(25),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 20, 
                    mainAxisSpacing: 20, 
                    childAspectRatio: 0.82, 
                  ),
                  itemCount: prodotti.length,
                  itemBuilder: (context, i) {
                    String nomeProdotto = prodotti[i]['nome'];
                    int quantita = quanteInCarrello(nomeProdotto);

                    return Card(
                      elevation: 3,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // IMMAGINE
                          Expanded(
                            flex: 3,
                            child: (prodotti[i]['immagine'] != null && prodotti[i]['immagine'] != "") 
                            ? Image.network(prodotti[i]['immagine'], fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Container(color: Colors.orange[50], child: const Icon(Icons.fastfood, color: Colors.orange)))
                            : Container(color: Colors.orange[50], child: const Icon(Icons.fastfood, color: Colors.orange)),
                          ),
                          // INFO E CONTROLLI QUANTITÀ
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(nomeProdotto, 
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), 
                                    textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                                  Text("${prodotti[i]['prezzo']} €", 
                                    style: TextStyle(color: Colors.orange[900], fontSize: 14, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  
                                  // CONTROLLI + / -
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Tasto Meno (appare solo se c'è almeno 1 prodotto)
                                      if (quantita > 0)
                                        IconButton(
                                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                          onPressed: () => setState(() => carrello.remove(nomeProdotto)),
                                        ),
                                      
                                      // Numero Quantità
                                      if (quantita > 0)
                                        Text("$quantita", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

                                      // Tasto Più (Sempre presente)
                                      IconButton(
                                        icon: const Icon(Icons.add_circle, color: Colors.green, size: 28),
                                        onPressed: () => setState(() => carrello.add(nomeProdotto)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              
              // BARRA DI CONFERMA
              if (carrello.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.2), blurRadius: 15, spreadRadius: 2)]
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("${carrello.length} prodotti selezionati", style: const TextStyle(fontWeight: FontWeight.bold)),
                          const Text("Scorri le card per modificare", style: TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(width: 30),
                      ElevatedButton(
                        onPressed: inviaOrdine,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700], 
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                        ),
                        child: const Text("CONFERMA ORDINE", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () => setState(() => carrello = []),
                        icon: const Icon(Icons.delete_sweep, color: Colors.red),
                        tooltip: "Svuota tutto",
                      )
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}