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
  // Aggiunta la proprietà immagine qui
  nuovoProd = { nome: '', prezzo: 0, categoria: 'panini', immagine: '' };

  constructor(private dataService: DataService) {}

  ngOnInit() { this.caricaDati(); }

  caricaDati() {
    this.dataService.getOrdini().subscribe(res => this.ordini = res);
    this.dataService.getProdotti().subscribe(res => this.prodotti = res);
  }

  preparaOrdine(id: number) {
    this.dataService.aggiornaStatoOrdine(id, 'pronto').subscribe(() => this.caricaDati());
  }

  aggiungiProdotto() {
    if (this.nuovoProd.nome && this.nuovoProd.prezzo > 0) {
      this.dataService.addProdotto(this.nuovoProd).subscribe(() => {
        // Reset del form includendo l'immagine
        this.nuovoProd = { nome: '', prezzo: 0, categoria: 'panini', immagine: '' };
        this.caricaDati();
      });
    }
  }

  cancellaProdotto(id: number) {
    this.dataService.eliminaProdotto(id).subscribe(() => this.caricaDati());
  }
}