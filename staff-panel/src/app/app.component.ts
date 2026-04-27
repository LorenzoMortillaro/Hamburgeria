import { Component, OnInit } from '@angular/core';
import { DataService } from './services/data.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
  standalone: false
})
export class AppComponent implements OnInit {
  ordini: any[] = [];
  prodotti: any[] = [];
  
  // Variabili per il nuovo prodotto
  nuovoProd = { nome: '', prezzo: 0, categoria: 'panini' };

  constructor(private dataService: DataService) {}

  ngOnInit() {
    this.caricaDati();
  }

  caricaDati() {
    this.dataService.getOrdini().subscribe(res => this.ordini = res);
    this.dataService.getProdotti().subscribe(res => this.prodotti = res);
  }

  // Cambia lo stato dell'ordine (es. da 'in corso' a 'pronto')
  preparaOrdine(id: number) {
    this.dataService.aggiornaStatoOrdine(id, 'pronto').subscribe(() => {
      this.caricaDati(); // Ricarica la lista per vedere il cambiamento
    });
  }

  // Aggiunge un prodotto al menù
  aggiungiProdotto() {
    if (this.nuovoProd.nome && this.nuovoProd.prezzo > 0) {
      this.dataService.addProdotto(this.nuovoProd).subscribe(() => {
        this.nuovoProd = { nome: '', prezzo: 0, categoria: 'panini' }; // Svuota il form
        this.caricaDati();
      });
    }
  }

  // Elimina un prodotto dal menù
  cancellaProdotto(id: number) {
    this.dataService.eliminaProdotto(id).subscribe(() => {
      this.caricaDati();
    });
  }
}