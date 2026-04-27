import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MaterialApp(
    home: TotemHome(),
    debugShowCheckedModeBanner: false,
  ));
}

class TotemHome extends StatefulWidget {
  const TotemHome({super.key});

  @override
  State<TotemHome> createState() => _TotemHomeState();
}

class _TotemHomeState extends State<TotemHome> {
  // RICORDATI: Incolla qui l'URL corretto della tua porta 5000 (Backend)
  final String apiUrl = "https://fictional-funicular-v6446j5r6xxjcx4x4-5000.app.github.dev";

  List prodotti = []; 
  List carrello = [];

  @override
  void initState() {
    super.initState();
    caricaMenu();
  }

  // Scarica i prodotti dal database Flask
  Future<void> caricaMenu() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/prodotti'));
      if (response.statusCode == 200) {
        if (!mounted) return; // Controllo di sicurezza per gli avvisi blu
        setState(() {
          prodotti = json.decode(response.body);
        });
      }
    } catch (e) {
      debugPrint("Errore caricamento menu: $e");
    }
  }

  // Invia l'ordine a Flask
  Future<void> inviaOrdine() async {
    if (carrello.isEmpty) return;

    String listaProdotti = carrello.join(", ");

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/ordini'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'dettagli': listaProdotti}),
      );

      // Questo "if (!mounted) return" risolve l'avviso "Don't use BuildContext across async gaps"
      if (!mounted) return;

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Ordine inviato in cucina!')),
        );
        setState(() {
          carrello = []; 
        });
      }
    } catch (e) {
      debugPrint("Errore invio ordine: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🍔 Totem Hamburgeria"),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: prodotti.length,
              itemBuilder: (context, i) {
                return ListTile(
                  leading: const Icon(Icons.fastfood),
                  title: Text(prodotti[i]['nome']),
                  subtitle: Text("${prodotti[i]['prezzo']} €"),
                  trailing: const Icon(Icons.add_circle, color: Colors.green),
                  onTap: () {
                    setState(() {
                      carrello.add(prodotti[i]['nome']);
                    });
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: const Border(top: BorderSide(color: Colors.orange, width: 2))
            ),
            child: Column(
              children: [
                Text("Elementi nel carrello: ${carrello.length}", style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: carrello.isEmpty ? null : inviaOrdine,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size.fromHeight(50)
                  ),
                  child: const Text("CONFERMA ORDINE", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}