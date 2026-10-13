#!/bin/bash
# Installa Git, Python e le estensioni Python di VS Code nel profilo "Corso Info".
# Se il profilo esiste già (corso di C), aggiunge solo quello che manca.
# Funziona su Ubuntu/Debian/Mint, Fedora, Arch/Manjaro e openSUSE.
#
# Uso, dal Terminale nella cartella Corso-Python:
#   bash setup/setup-linux.sh

PROFILO="Corso Info"
CORSO="$(cd "$(dirname "$0")/.." && pwd)"

# Vero se c'è un python3 di versione almeno 3.10
python_ok() {
    command -v python3 >/dev/null 2>&1 || return 1
    python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 10) else 1)' 2>/dev/null
}

if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
else
    SUDO="sudo"
fi

echo "== 1/2 Python e Git =="
if python_ok && command -v git >/dev/null 2>&1; then
    echo "Già installati: $(command -v python3)"
else
    if command -v apt-get >/dev/null 2>&1; then
        $SUDO apt-get update
        # venv e pip sono pacchetti a parte su Debian/Ubuntu
        $SUDO apt-get install -y python3 python3-venv python3-pip git
    elif command -v dnf >/dev/null 2>&1; then
        $SUDO dnf install -y python3 python3-pip git
    elif command -v pacman >/dev/null 2>&1; then
        $SUDO pacman -S --needed --noconfirm python python-pip git
    elif command -v zypper >/dev/null 2>&1; then
        $SUDO zypper install -y python3 python3-pip git
    else
        echo "Distribuzione non riconosciuta."
        echo "Installa a mano i pacchetti: python3 (3.10 o più recente), pip, venv, git."
        echo "Poi rilancia lo script."
        exit 1
    fi
    if ! python_ok; then
        echo
        echo "La versione di Python di questa distribuzione è troppo vecchia (serve 3.10 o più)."
        echo "Aggiorna la distribuzione oppure installa un Python più recente, poi rilancia lo script."
        exit 1
    fi
fi

echo
echo "== 2/2 Estensioni Python nel profilo VS Code \"$PROFILO\" =="
if command -v code >/dev/null 2>&1; then
    # Il profilo viene creato solo aprendo VS Code: se non esiste ancora (chi non ha fatto
    # il setup del corso di C) lo crea, altrimenti apre quello che c'è già.
    echo "Apro VS Code sulla cartella Corso-Python nel profilo \"$PROFILO\"..."
    code --profile "$PROFILO" "$CORSO"
    for attesa in $(seq 1 60); do
        code --profile "$PROFILO" --list-extensions 2>&1 | grep -qi "not found" || break
        sleep 1
    done
    # Le estensioni già presenti (ad esempio quelle del C) restano come sono
    code --profile "$PROFILO" --install-extension ms-python.python
    code --profile "$PROFILO" --install-extension ms-python.debugpy
    code --profile "$PROFILO" --install-extension charliermarsh.ruff
else
    echo "Comando 'code' non trovato: VS Code non è installato."
    echo "Scaricalo da https://code.visualstudio.com (pacchetto .deb o .rpm) oppure"
    echo "installalo dal gestore di software della tua distribuzione, poi rilancia lo script."
    echo "(In alternativa apri la cartella in VS Code: ti propone le estensioni consigliate.)"
fi

echo
python3 --version
echo
echo "Fatto! Se VS Code chiede di ricaricare la finestra, accetta."
