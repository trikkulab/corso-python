# Esercizio di debug: il programma dovrebbe stampare 2.5, ma stampa 2.25.
#
# Nella versione in C l'errore era la divisione tra interi: in Python "/" dà
# sempre un numero con la virgola, quindi qui quel problema non c'è.
# Però c'è un altro errore. Trovalo con il debugger:
#
# 1. Clicca a sinistra del numero di riga 14 per mettere un breakpoint.
# 2. Premi F5: il programma si ferma sul breakpoint.
# 3. Usa F10 e guarda i valori di i e somma nel pannello a sinistra.

voti = [1, 2, 3, 4]
somma = 0
for i in range(1, len(voti)):
    somma = somma + voti[i]

media = somma / len(voti)
print(f"Media: {media}")
