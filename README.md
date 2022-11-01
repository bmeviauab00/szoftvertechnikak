# BMEVIAUAB00 Szoftvertechnikák

![Build docs](https://github.com/bmeviauab00/szoftvertechnikak/workflows/Build%20docs/badge.svg?branch=main)

[BMEVIAUAB00 Szoftvertechnikák](https://www.aut.bme.hu/Course/VIAUAB00/) tárgy jegyzetei, gyakorlati anyagai, házi feladatai.

A jegyzetek MkDocs segítségével készülnek és GitHub Pages-en kerülnek publikálásra: <https://bmeviauab00.github.io/szoftvertechnikak/>

#### Helyi gépen történő renderelés (Docker-rel)

1. Powershell konzol nyitása a repository gyökerébe

1. `docker run -it --rm -p 8001:8000 -v ${PWD}:/docs squidfunk/mkdocs-material:8.5.7`

1. <http://localhost:8001> megnyitása böngészőből.

1. Markdown szerkesztése és mentése után automatikusan frissül a weboldal
