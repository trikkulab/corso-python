# Corso di Python

Ambiente di lavoro per programmare in Python con VS Code, uguale su Windows e Mac.
Usa lo stesso profilo **"Corso Info"** del corso di C: se hai già installato quello,
lo script aggiunge solo Python e le sue estensioni.

## Installazione (una volta sola)

### 1. Installa VS Code
Se non l'hai già fatto per il corso di C, scaricalo da <https://code.visualstudio.com> e installalo.

### 2. Installa Python e Git

**Windows**
1. Apri la cartella `Corso-Python`, poi la cartella `setup`.
2. Doppio clic su **`setup-windows-bat.cmd`**.
   Se compare l'avviso blu "Windows ha protetto il PC", clicca *Ulteriori informazioni* → **Esegui comunque**.
3. Aspetta la fine (si apre VS Code da solo), poi premi un tasto per chiudere la finestra nera.

**Mac**
1. Apri il Terminale nella cartella `Corso-Python` (tasto destro sulla cartella → *Nuovo terminale nella cartella*).
2. Scrivi:
   ```
   bash setup/setup-mac.sh
   ```
3. Se si apre l'installazione di Python, completala (ti chiede la password del Mac),
   poi chiudi il Terminale, aprine uno nuovo nella cartella e rilancia lo stesso comando.

### 3. Apri la cartella in VS Code
Durante l'installazione lo script apre da solo VS Code sulla cartella `Corso-Python`,
usando il **profilo "Corso Info"** (lo vedi in basso a sinistra, icona dell'ingranaggio).

Le volte successive basta aprire la cartella (*File → Apri cartella…* → `Corso-Python`):
VS Code si ricorda di usare il profilo "Corso Info".

## Come si usa

È tutto come nel corso di C:

| Cosa vuoi fare | Windows | Mac |
|---|---|---|
| Eseguire (con debug) | `F5` | `F5` (o `Fn+F5`) |
| Mettere un breakpoint | clic a sinistra del numero di riga | uguale |
| Passo successivo durante il debug | `F10` | `F10` |
| Entrare in una funzione | `F11` | `F11` |
| Formattare il codice | si fa da solo quando salvi | uguale |

In Python non c'è da compilare: `F5` esegue direttamente il file aperto.
Il programma gira nel **terminale** in basso: lì vedi l'output e scrivi l'input (`input()`).

## Organizzazione dei file

```
esempi/                  gli stessi esempi del corso di C, scritti in Python
├── 01-ciao/ciao.py
├── 02-input/somma.py
└── 03-debug/media.py    esercizio guidato sul debugger
esercizi/                qui metti i tuoi programmi, una cartella per lezione
```

Confronta ogni esempio con la versione in C: è il modo più veloce per capire
cosa fa Python al posto tuo.

## Problemi comuni

- **`python` apre il Microsoft Store** (Windows): l'installazione non è andata a buon fine.
  Rilancia `setup-windows-bat.cmd`; se non basta, riavvia il computer.
- **VS Code chiede di scegliere un interprete Python**: scegli quello con la versione più alta (3.14).
- **Il programma non si ferma sul breakpoint**: controlla di aver premuto `F5`
  e di avere aperto la cartella `Corso-Python` (non `Corso-C`).
