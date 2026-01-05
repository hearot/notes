#!/bin/bash

# Configurazione nomi
TEMP_DIR="no_proofs_temp"
MAIN_FILE="main.tex"
PREAMBLE_FILE="preamble.tex"
OUTPUT_PDF="no_proofs.pdf"

NEW_TITLE="\\\\title{\\\\Huge{Teoria del corso di \\\\\\\\ \\\\textit{Geometria e topologia differenziale} \\\\\\\\ (senza dimostrazioni)}}"

# 1. Crea la struttura della directory temporanea
mkdir -p "$TEMP_DIR/sections"

# Funzione per rimuovere le proof usando awk
remove_proofs() {
    local src=$1
    local dest=$2
    awk '/\\begin{proof}/, /\\end{proof}/ {next} 1' "$src" | \
    sed "s/\\\\title{.*}/$NEW_TITLE/" > "$dest"
}

# 2. Elabora il file principale e il preambolo
if [ -f "$MAIN_FILE" ]; then
    echo "Elaborazione $MAIN_FILE..."
    remove_proofs "$MAIN_FILE" "$TEMP_DIR/$MAIN_FILE"
else
    echo "Errore: $MAIN_FILE non trovato nella directory corrente."
    exit 1
fi

if [ -f "$PREAMBLE_FILE" ]; then
    echo "Elaborazione $PREAMBLE_FILE..."
    remove_proofs "$PREAMBLE_FILE" "$TEMP_DIR/$PREAMBLE_FILE"
else
    echo "Errore: $PREAMBLE_FILE non trovato nella directory corrente."
    exit 1
fi

# 3. Elabora tutti i file nella cartella sections
if [ -d "sections" ]; then
    echo "Elaborazione dei file in sections/..."
    for f in sections/*.tex; do
        if [ -f "$f" ]; then
            remove_proofs "$f" "$TEMP_DIR/$f"
        fi
    done
fi

# 4. Compilazione
echo "Compilazione in corso..."
cd "$TEMP_DIR"

# Eseguiamo pdflatex (due volte per riferimenti/indice)
# -interaction=nonstopmode evita che lo script si blocchi in caso di warning
pdflatex -interaction=nonstopmode "$MAIN_FILE" > /dev/null
pdflatex -interaction=nonstopmode "$MAIN_FILE"

# 5. Sposta il PDF nella directory originale e pulisci
if [ -f "main.pdf" ]; then
    mv "main.pdf" "../$OUTPUT_PDF"
    cd ..
    echo "Successo! PDF generato: $OUTPUT_PDF"

    # Cancella i file temporanei
    rm -rf "$TEMP_DIR"
else
    echo "Errore durante la compilazione del PDF."
    cd ..
    exit 1
fi