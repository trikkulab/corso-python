#!/bin/bash
# Installa Git, Python e le estensioni Python di VS Code nel profilo "Corso Info".
# Se il profilo esiste già (corso di C), aggiunge solo quello che manca.
#
# Uso, dal Terminale nella cartella Corso-Python:
#   bash setup/setup-mac.sh

SERIE="3.14"
PROFILO="Corso Info"
CORSO="$(cd "$(dirname "$0")/.." && pwd)"

# Vero se c'è un python3 di versione almeno 3.10.
# /usr/bin/python3 senza gli strumenti di sviluppo Apple è solo un finto comando
# che apre la finestra di installazione: in quel caso non lo prova nemmeno.
python_ok() {
    local py
    py=$(command -v python3) || return 1
    if [ "$py" = "/usr/bin/python3" ] && ! xcode-select -p >/dev/null 2>&1; then
        return 1
    fi
    python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 10) else 1)' 2>/dev/null
}

echo "== 1/3 Git (strumenti di sviluppo Apple) =="
if xcode-select -p >/dev/null 2>&1; then
    echo "Già installato."
else
    xcode-select --install
    echo
    echo "Completa l'installazione nella finestra che si è aperta,"
    echo "poi rilancia questo script."
    exit 0
fi

echo "== 2/3 Python =="
if python_ok; then
    echo "Già installato: $(command -v python3)"
else
    # Cerca l'ultima versione $SERIE.x che ha già l'installatore pubblicato
    PATCH=$(curl -fsSL https://www.python.org/ftp/python/ \
        | grep -oE "href=\"$SERIE\.[0-9]+/\"" \
        | grep -oE '[0-9]+/"$' | tr -d '/"' | sort -rn)
    URL=""
    for p in $PATCH; do
        V="$SERIE.$p"
        PROVA="https://www.python.org/ftp/python/$V/python-$V-macos11.pkg"
        if curl -fsIL "$PROVA" >/dev/null 2>&1; then
            URL="$PROVA"
            break
        fi
    done
    if [ -z "$URL" ]; then
        echo "Non trovo l'installatore di Python $SERIE."
        exit 1
    fi

    PKG="${TMPDIR:-/tmp}/$(basename "$URL")"
    echo "Scarico $URL"
    curl -fL "$URL" -o "$PKG" || exit 1
    open "$PKG"
    echo
    echo "Completa l'installazione di Python nella finestra che si è aperta"
    echo "(ti chiederà la password del Mac), poi chiudi questo Terminale,"
    echo "aprine uno nuovo e rilancia lo stesso comando."
    exit 0
fi

echo "== 3/3 Estensioni Python nel profilo VS Code \"$PROFILO\" =="
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
    echo "Comando 'code' non trovato. In VS Code: Cmd+Shift+P ->"
    echo "  \"Shell Command: Install 'code' command in PATH\", poi rilancia lo script."
    echo "(In alternativa installa le estensioni da VS Code: te le propone aprendo la cartella.)"
fi

echo
python3 --version
echo
echo "Fatto! Se VS Code chiede di ricaricare la finestra, accetta."
