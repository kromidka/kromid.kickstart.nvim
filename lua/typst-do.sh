#!/bin/zsh

if [[ -z "$1" ]]; then exit 1; fi

typ_file="$1"
pdf_file="${typ_file:r}.pdf"

# --- CHANGE IS HERE ---
# We redirect stdout (>) to /dev/null to hide "compiled successfully" spam.
# But we DO NOT redirect stderr, so errors flow back to Neovim.
typst watch "$typ_file" > /dev/null &
typ_pid=$!

# Wait for PDF to exist
while [[ ! -f "$pdf_file" ]]; do sleep 0.2; done

# Start MuPDF (Silence this completely, we don't need its errors)
mupdf "$pdf_file" >/dev/null 2>&1 &
mu_pid=$!

cleanup() { kill $typ_pid $mu_pid 2>/dev/null; }
trap cleanup EXIT INT TERM

# Watch loop
while kill -0 $mu_pid 2>/dev/null && kill -0 $typ_pid 2>/dev/null; do
    inotifywait -q -e close_write "$pdf_file" >/dev/null 2>&1
    kill -HUP $mu_pid 2>/dev/null
done
