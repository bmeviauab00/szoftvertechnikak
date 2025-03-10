# BMEVIAUAB00 Szoftvertechnikák

[![Build docs](https://github.com/bmeviauab00/szoftvertechnikak/actions/workflows/github-pages.yml/badge.svg)](https://github.com/bmeviauab00/szoftvertechnikak/actions/workflows/github-pages.yml)

[BMEVIAUAB00 Szoftvertechnikák](https://www.aut.bme.hu/Course/VIAUAB00/) tárgy jegyzetei, labor anyagai, házi feladatai.

A jegyzetek MkDocs segítségével készülnek és GitHub Pages-en kerülnek publikálásra: <https://bmeviauab00.github.io/szoftvertechnikak/>

## MKDocs tesztelése (Docker-rel)

### Helyi gépen

A futtatáshoz Dockerre van szükség, amihez Windows-on a [Docker Desktop](https://www.docker.com/products/docker-desktop/) egy kényelmes választás.

### GitHub Codespaces fejlesztőkörnyezetben

A GitHub Codespaces funkciója jelentős mennyiségű virtuális gép időt ad a felhasználók számára, ahol GitHub repositoryk tartalmát tudjuk egy virtuális gépben fordítani és futtatni.

Ehhez elegendő a repository (akár a forkon) Code gombját lenyitni majd létrehozni egy új codespace-t. Ez lényegében egy böngészős VSCode, ami egy konténerben fut, és az alkalmazás által nyitott portokat egy port forwardinggal el is érhetjük a böngészőnkből.

### Dockerfile elindítása (helyi gépen vagy Codespaces-ben)

A repository tartalmaz egy Dockerfile-t, mely az MKDocs keretrendszer és függőségeinek konfigurációját tartalmazza. Ezt a konténert le kell buildelni, majd futtatni, ami lebuildeli az MKDocs alapú dokumentációt, és egyben egy fejlesztési idejű webservert is elindít a dokumentáció "futtatásához".

1. Terminál nyitása a repository gyökerébe.
2. Adjuk ki ezt a parancsot Windows (PowerShell), Linux és MacOS esetén:

   ```cmd
   docker build -t mkdocs .
   docker run -it --rm -p 8000:8000 -v ${PWD}:/docs mkdocs
   ```

3. <http://localhost:8000> vagy a codespace átirányított címének megnyitása böngészőből.
4. Markdown szerkesztése és mentése után automatikusan frissül a weboldal.
