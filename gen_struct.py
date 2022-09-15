import os

with open("templates/main_tmpl.tex", "r") as f:
    main_tmpl = f.read()

with open("templates/chap_tmpl.tex", "r") as f:
    chap_tmpl = f.read() 

title = input("Inserisci il titolo dei nuovi appunti: ")
filename = title.lower().replace(" ", "_")

try:
    os.mkdir(title)
except FileExistsError:
    pass

with open(os.path.join(title, filename + ".tex"), "w") as f:
    f.write(main_tmpl.replace("{{titolo}}", title))

with open(os.path.join(title, "1. Primo capitolo.tex"), "w") as f:
    f.write(chap_tmpl)
