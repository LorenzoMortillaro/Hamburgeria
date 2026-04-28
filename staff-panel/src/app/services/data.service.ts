import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class DataService {
  // ATTENZIONE: Qui devi mettere l'indirizzo della tua Codespace Backend sulla porta 5000
  // Lo trovi nella tab "Ports" vicino al terminale. Deve finire con .app.github.dev
  private baseUrl = 'https://orange-train-r49945x7x69g2x456-5000.app.github.dev'; 

  constructor(private http: HttpClient) { }

  // Gestione Prodotti
  getProdotti(): Observable<any> {
    return this.http.get(`${this.baseUrl}/prodotti`);
  }

  addProdotto(prodotto: any): Observable<any> {
    return this.http.post(`${this.baseUrl}/prodotti`, prodotto);
  }

  eliminaProdotto(id: number): Observable<any> {
    return this.http.delete(`${this.baseUrl}/prodotti/${id}`);
  }

  // Gestione Ordini
  getOrdini(): Observable<any> {
    return this.http.get(`${this.baseUrl}/ordini`);
  }

  aggiornaStatoOrdine(id: number, nuovoStato: string): Observable<any> {
    return this.http.patch(`${this.baseUrl}/ordini/${id}`, { stato: nuovoStato });
  }
}