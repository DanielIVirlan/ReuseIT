# 📱 Paper - Guida alla Riparazione DIY

**Paper** è un prototipo di applicazione iOS sviluppato in **SwiftUI** che aiuta gli utenti a riparare i propri dispositivi elettronici attraverso guide dettagliate, valutazioni dei danni e un marketplace integrato.

---

## 🎥 Demo dell'App
Ecco l'app in funzione (Xcode 17 / iOS 18+):

![Descrizione del video](https://github.com/user-attachments/assets/8e148fb1-f9ab-4fbd-86c2-80b391ea268d)


---

## 🚀 Caratteristiche Principali
- **Selezione Oggetto**: Scegli tra diverse categorie (Smartphone, PC/Laptop, Console).
- **Diagnosi Problemi**: Identifica i problemi comuni tramite una selezione rapida.
- **Guide Dettagliate**: Accesso a istruzioni passo-passo, tempi stimati e video tutorial esterni.
- **Valutazione Usato**: Un sistema per valutare lo stato del dispositivo prima della riparazione o vendita.

---

## 🛠 Note Tecniche
L'app è stata sviluppata seguendo i più recenti standard di Apple:
- **Linguaggio**: Swift
- **Framework**: SwiftUI
- **Versione Xcode**: Xcode 17.0+ 
- **Target iOS**: iOS 18.0+
- **Architettura**: Clean & Modular (Organizzata in Gruppi: `Models`, `Views`, `Resources`).

---

## 📂 Organizzazione del Progetto
Il codice è strutturato per essere facilmente leggibile e scalabile:
- `Models/`: Contiene le strutture dati (`Guida`, `Problema`, `Categoria`).
- `Views/`: Contiene tutte le schermate dell'interfaccia divise per funzionalità.
- `Resources/`: Asset grafici e icone.

---

## 👨‍💻 Come Provare l'App
Per testare il progetto sul tuo Mac:
1. Clonare la repository: `git clone https://github.com/TUO_UTENTE/Paper.git`
2. Aprire il file `Paper.xcodeproj` con **Xcode**.
3. Assicurarsi di aver selezionato un simulatore con **iOS 18 o superiore**.
4. Premere `Cmd + R` per avviare.

