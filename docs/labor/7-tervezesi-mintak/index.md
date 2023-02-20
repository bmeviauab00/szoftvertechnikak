---
authors: bzolka
---
# 7. Tervezési minták

Utolsó módosítás ideje: 2022.11.01  
Kidolgozta: Benedek Zoltán

## A gyakorlat célja

A gyakorlat céljai:

- Egy összetettebb példa alapján néhány tervezési minta gyakorlati alkalmazása (elsődlegesen Singleton, Command Processor és Memento).
- A Document-View minta további gyakorlása, illetve annak demonstrálása, hogy a mintának több variánsa létezik.
- Alapszintű betekintést nyerni az újrafelhasználhatóságot támogató osztálykönyvtárak/keretrendszerek fejlesztésének világába.
- Jelentőségüknek megfelelően tovább gyakoroljuk az objektumorientált paradigma legfontosabb koncepcióit (pl. felelősségek különválasztása).

Kapcsolódó előadások:

- Tervezési minták
- Szoftver architektúrák témakörből a Document-View architektúra
- Windows Forms alkalmazások fejlesztése

## Előfeltételek

A gyakorlat elvégzéséhez szükséges eszközök:

- Visual Studio 2022
- Windows 10 vagy Windows 11 operációs rendszer (Linux és macOS nem alkalmas)

## Megoldás

??? "A kész megoldás letöltése"
    :exclamation: Lényeges, hogy a labor során a laborvezetőt követve kell dolgozni, tilos (és értelmetlen) a kész megoldás letöltése. Ugyanakkor az utólagos önálló gyakorlás során hasznos lehet a kész megoldás áttekintése, így ezt elérhetővé tesszük.

    A megoldás GitHubon érhető el [itt](https://github.com/bmeviauab00/lab-designpattern-kiindulo). A legegyszerűbb mód a letöltésére, ha parancssorból a `git clone` utasítással leklónozzuk a gépünkre:

    ```git clone https://github.com/bmeviauab00/lab-designpattern-kiindulo -b megoldas```

    Ehhez telepítve kell legyen a gépre a parancssori git, bővebb információ [itt](../hazi/git-github-github-classroom/#git-telepitese).

## Bevezető

### Elméleti háttér

A komplexebb alkalmazások fejlesztése során számos tervezői döntést kell meghoznunk, melyek során több lehetőség közül is választhatunk. Amennyiben ezen pontokban olyan döntéseket hozunk, melyek nem követik az objektumorientált szemléletmód alapelveit, nem tartjuk szem előtt az alkalmazásunk könnyű karbantarthatóságát, illetve egyszerűen megvalósítható továbbfejlesztési lehetőségét, könnyen hamar rémálommá válhat a fejlesztés. Az egyes hibák javítása folyamatosan új hibákat szül. Ezen felül a megrendelői változtatási és bővítési igények a kód nagymértékű folyamatos átírását igénylik ahelyett, hogy a kód pár jól meghatározott pontjában történő bővítésével - a meglévő kód jelentős módosítása nélkül - el tudnánk ezt érni.
A tervezési minták jól bevált megoldásokat mutatnak bizonyos gyakran előforduló tervezési problémákra: ezen megoldások abban segítenek, hogy kódunk könnyebben bővíthető, karbantartható és minél nagyobb mértékben újrafelhasználható legyen.
Ugyanakkor ne essünk át a ló túloldalára: csak akkor érdemes egy adott tervezési mintát bevetni, ha adott esetben valós előnyt jelent az alkalmazása. Ellenkező esetben csak a megvalósítás komplexitását növeli feleslegesen.

### A feladat ismertetése

A feladatunk egy vektorgrafikus rajzolóprogram kifejlesztése:

- Az alkalmazásban vektorgrafikus alakzatokat lehet létrehozni, úgymint téglalap, ellipszis, stb.
- A már létrehozott alakzatokat egy grafikus felületen meg kell jeleníteni (ki kell rajzolni).
- A már létrehozott alakzatok fontosabb paramétereit, úgymint koordináták, befoglaló téglalap meg kell jeleníteni egy listában egy információs panelen.
- Windows Forms technológiára építve dolgozunk.
- Document-View architektúrát követjük, de egyszerre csak egy dokumentum lehet megnyitva (nincsenek dokumentumonként tabfülek vagy ablakok).
- Egy adott pontig előkészített környezetet viszünk tovább. A munka mennyiségének kezelhető szinten tartása végett csak bizonyos pontig visszük tovább a fejlesztést, nem valósítjuk meg a teljes értékű megoldást.
kiemelt háttér jelzi.

## 1. Feladat - A kiindulási környezet megismerése

COMING SOON

## 2. Feladat - Command Processor minta

COMING SOON

## 3- Feladat – Memento minta

COMING SOON