---
authors: bzolka
---

# 6. Tervezési minták (kiterjeszthetőség)

## A gyakorlat célja

A gyakorlat céljai (egy összetettebb példa alapján):

- Kiterjeszthetőséget, újrafelhasználhatóságot, kód átláthatóságot és karbantarthatóságot segítő néhány tervezési alapelv gyakorlása: SRP, OPEN-CLOSED, DRY, KISS stb.
- Néhány, a kiterjeszthetőséghez leginkább kapcsolódó tervezési minta alkalmazása (Template Method, Strategy, Dependency Injection).
- Kiterjeszthetőséget és újrafelhasználhatóságot támogató további technikák (pl. delegate/lambda kifejezés) gyakorlása és kombinálása tervezési mintákkal.
- Kód refaktorálás gyakorlása.
- Egységteszt (unit test) fogalmának pontosítása, egységtesztelhető kód kialakítása.

Kapcsolódó előadások:

- Tervezési minták: kiterjeszthetőséghez kapcsolódó minták (bevezető, Template Method, Strategy), valamint a Depedency Injection "minta".

## Előfeltételek

A gyakorlat elvégzéséhez szükséges eszközök:

- Visual Studio 2022

!!! tip "Gyakorlat Linuxon vagy macOS alatt"
    A gyakorlat anyag alapvetően Windowsra és Visual Studiora készült, de az elvégezhető más operációs rendszereken is más fejlesztőeszközökkel (pl. VS Code, Rider, Visual Studio for Mac), vagy akár egy szövegszerkesztővel és CLI (parancssori) eszközökkel. Ezt az teszi lehetővé, hogy a példák egy egyszerű Console alkalmazás kontextusában kerülnek ismertetésre (nincsenek Windows specifikus elemek), a .NET 8 SDK pedig támogatott Linuxon és macOS alatt. [Hello World Linuxon](https://learn.microsoft.com/en-us/dotnet/core/tutorials/with-visual-studio-code).

### Elméleti háttér, szemléletmód *

A komplexebb alkalmazások fejlesztése során számos tervezői döntést kell meghoznunk, melyek során több lehetőség közül is választhatunk. Amennyiben ezen pontokban nem tartjuk szem előtt az alkalmazásunk könnyű karbantarthatóságát, illetve egyszerűen megvalósítható továbbfejlesztési lehetőségét, könnyen hamar rémálommá válhat a fejlesztés. A megrendelői változtatási és bővítési igények a kód nagymértékű folyamatos átírását/módosítását igénylik: ennek során új hibák születnek, illetve jelentős munkát kell fektetni a kód nagyléptékű újratesztelésébe is!

Ehelyett a célunk az, hogy az ilyen változtatási és bővítési igényeket a kód pár jól meghatározott pontjában történő bővítésével - a meglévő kód érdemi módosítása nélkül - meg tudjuk valósítani. A kulcsszó: **módosítással** szemben **bővítés** (meglévő kódon minél kisebb léptékben kelljen módosítani). Ehhez kapcsolódóan: amennyiben bizonyos logikáink kiterjeszthetők, így általánosabbak is leszek, könnyebben, több kontextusban is fel tudjuk használni. Így hosszabb távon gyorsabban haladunk, rövidebb a kód, elkerüljük a kódduplikációt (ezáltal karbantarthatóbb is).

A tervezési minták jól bevált megoldásokat mutatnak bizonyos gyakran előforduló tervezési problémákra: ezen megoldások abban segítenek, hogy kódunk könnyebben bővíthető, karbantartható és minél nagyobb mértékben újrafelhasználható legyen. Jelen gyakorlat keretében azon mintákra, tervezési elvekre és néhány programozói eszközre fókuszálunk, melyek a fenti problémákon segítenek.
Ugyanakkor ne essünk át a ló túloldalára: csak akkor érdemes egy adott tervezési mintát bevetni, ha adott esetben valós előnyt jelent az alkalmazása. Ellenkező esetben csak a megvalósítás komplexitását növeli feleslegesen.
Ennek tükrében nem is célunk (és sokszor nincs is rá lehetőségünk), hogy minden jövőbeli kiterjeszthetőségi igény előre megérezzünk, illetve nagyon előre átgondoljunk. A lényeg az, hogy akár egy egyszerű megoldásból kiindulva, az egyes problémákat felismerve, a kódunkat folyamatosan refaktoráljuk úgy, hogy az aktuális (funkcionális és nemfuncionális) követelményeknek és előrelátásunknak megfelelően, a megfelelő pontokban tegyük kódunkat könnyebben kiterjeszthetővé és újrafelhasználhatóvá.

Zárásképpen megvizsgáljuk, hogyan segítenek bizonyos tervezési minták és nyelvi eszközök a kódunk egységtesztelhetővé tételében: sok cégnél egy szoftvertermék fejlesztése esetén (jogos) alapelvárás a fejlesztőktől, hogy nagy kódlefedettségű egységteszteket (unit test) készítsenek. Ennek kivitelezése viszont gyakorlatilag lehetetlen, ha a kódunk egyes egységei/osztályai túl szoros csatolásban vannak egymással.

### A gyakorlat menete

## 0. Feladat - Ismerkedés a feladattal és a kiinduló alkalmazással

Klónozzuk le a 6. gyakorlathoz tartozó kiinduló alkalmazás [repositoryját](https://github.com/bmeviauab00/lab-designpatterns-kiindulo):

- Nyissunk egy command prompt-ot
- Navigáljunk el egy tetszőleges mappába, például c:\work\NEPTUN
- Adjuk ki a következő parancsot: `git clone https://github.com/bmeviauab00/lab-designpatterns-kiindulo.git`
- Nyissuk meg a _Lab-Extensibility.sln_ solutiont Visual Studio-ban.

### A feladat ismertetése

A gyakorlat során egy adatfeldolgozó (esettanulmányunkban anonimizáló) alkalmazást fogunk a folyamatosan alakuló igényeknek megfelelően - különböző pontok mentén és különböző technikákat alkalmazva - kiterjeszthetővé tenni. Az első feladat keretében az anonimizálás fogalmával is megismerkedünk.

Egy konzol alapú alkalmazást kell készíteni.

Az alkalmazás bemenete egy CSV szövegfájl, mely minden sora egy adott személyre vonatkozóan tartalmaz adatokat. A fájrendszerben nyissuk meg a *Data* mappában levő us-500.csv fájlt (duplakattal, vagy akár a Jegyezettömb/Notepad alkalmazásban). Az látjuk, hogy "" között, vesszővel elválasztva találhatók az egyes személyekre vonatkozó adatok (ezek nem valósak). Nézzük az első sort:
  
  *"James","Butt","Benton, John B Jr","6649 N Blue Gum St","New Orleans ","Orleans","LA","70116","504-621-8927","504-845-1427","39","96","Heart-related","jbutt@gmail.com"*

Az első sorban levő személyt James Buttnak nevezik, a "Benton, John B Jr" cégnél dolgozik, majd néhány címre vonatkozó mező található, 39 éves, 96 kg a testsúlya. Az ezt követő mező azt mondja meg, milyen súlyosabb betegsége van (a fenti sorba ez "Heart-related"). Ezt követi még néhány, számunkra nem izgalmas mező.

??? Note Adatok forrása és pontos formátuma
    Az adatok forrása: https://www.briandunning.com/sample-data/, pár oszloppal (kor, súly, betegség) kiegészítve. A mezők sorrendje: First Name, Company, Address, City, County (where applicable), State/Province (where applicable), ZIP/Postal Code, Phone 1, Phone 2, Age, Weight, Illness, Email, Web

Az alkalmazás alapfeladata, hogy ezeket az adatokat az aktuális igényeknek megfelelően anonimizálja, majd egy kimeneti CSV szövegfájlba kiírja. Az anonimizálás feladata, hogy az adatokat olyan formába alakítsa, hogy agy adathalmazban levő személyeket beazonosíthatatlanná tegye, de olyan módon, hogy az adatokból mégis lehessen kimutatásokat készíteni. Az anonimizálás egy különálló, nagyon komoly, és sok kihívást rejtő adatfeldolgozási szakterület. A gyakorlat keretében nem célunk, hogy valós környezetben is használható, vagy akár minden tekintetben értelmes megoldásokat dolgozzunk ki. Számunkra tulajdonképpen csak egy valamilyen adatfeldolgozó algoritmus "bevetése" a fontos a minták bemutatásához, és ez talán kicsit "izgalmasabb" keretet ad, mint egy egyszerű adatszűrés/sorrendezés/stb. alapú adatfeldolgozás (melyeket ráadásul a .NET már eleve beépítve támogat).

!!! Note "Pár gondolat az anonimizálásról"

    Azt gondolhatnánk, hogy az anonimizálás egy egyszerű problémakör. Pl. csak el kell távolítani, vagy ki kell "csillagozni" a személyek neveit, lakcíméből az utca-házszámot, telefonszámokat, e-mail címet és megvagyunk. Például a bemenetünk első sorára:

    ```
    "***","***","Benton, John B Jr","***","New Orleans ","Orleans","LA","70116","***","***","39","96","Heart-related","***"
    ```

    De ez koránt sincs így, különösen, ha igazán sok adatról van szó. Gondolunk arra, hogy van egy kisebb falu, ahol nem laknak sokan. Tegyük fel, hogy az egyik fenti módon anonimizált személy életkora 14 év (amit lehet tudni, hiszen 8. osztályba jár), de rendkívül túlsúlyos, 95 kg. Akkor, mivel ez egy ritka "kombináció", és más személy jó eséllyel nem él ilyen paraméterekkel a faluban. Azonnal lehet tudni, legalábbis sejteni, ki ő, és mindenki tudni fogja, milyen betegsége van (ami személyes adat). Vagyis az adatok összefüggésben árulkodók lehetnek.
    
    Mi a megoldás? A várost, az életkort és a testtömeget nem törölhetjük/csillagozhatjuk, mert ezekre vonatkozóan kell kimutatást készíteni. Egy tipikus megoldás: nem pontos életkort/testsúlyt adunk meg, hanem sávokat (vagyis általánosítjuk az adatokat): pl. a fenti személy esetében az életkora 10..20 év, testsúlya 80..100 kg, és ezt adjuk meg erre a személyre vonatkozóan a fájlban. Így már nem lehet beazonosítani. Ezt a technikát mi is fogjuk később alkalmazni.

### Kiinduló követelmények

Az alkalmazással szemben támasztott kiinduló követelmények:

1. Egy adott ügyféltől kapott fájlokat (mindnek ugyanaz a formátuma) kell ugyanazzal az anonimizáló algoritmussal, ugyanabba a kimeneti formátumba konvertálni. Az anonimizálás egyszerűen a keresztnév és vezeténév "kicsillagozásából" álljon.
2. Szükség van egy kis adattisztításra. A bemeneti adatokban a várost tartalmazó oszlop elején/végén lehetnek felesleges '\_' és '\_' karakterek, ezeket el kell távolítani (trim művelet).
3. Ki kell írni minden sor feldolgozása után a konzolra, hogy a sor feldolgozása megtörtént, ill. a minden adat feldolgozás után némi összesítő információt (Summary): hány sort dolgoztunk fel, és mennynél kellett a városnevet trimmelni.
4. Lényeges szempont: az alkalmazásra csak rövid időre lesz szükség, nem a kívánjuk későbbiekben bővíteni.

Megjegyzés: hogy a kódban kevesebb mezővel kelljen dolgozni, és a kimenet is átláthatóbb legyen, elhagyunk még néhány mezőt a feldolgozás során.

A várt kimeneti formátumre egy egysoros példa:

```
***; ***; LA; New Orleans; 39; 96; Heart-related
```

## 1. Megoldás - minden egyben

A Visual Studio Solution Explorerében mappákat látunk, 1-től 6-ig számmal kezdve. Ezek az egyes munkaiterációkhoz tartozó megoldásokat tartalmazzák. Az első körös megoldás az "1-Start" mappában, "Start" projektnév alatt található. Nézzük meg a projektben található fájlokat:

* Person.cs - Egy személy számunkra érdekes adatai tartalmazza, ennek objektumaiba olvassuk be egy-egy személy adatait.
* Program.cs - Ennek Main függvényében van megvalósítva minden logika, kódmegjegyzésekkel "elválasztva". Amennyiben kicsit is bonyolultabbá válik a logika, már két nap mi is csak nehezen fogjuk áttekinteni és megérteni a saját kódunkat. Ezt a megoldást ne is nézzük.

Összegészében minden nagyon egyszerű. Összegészében nem gondolkodtunk rosszul, hiszen a kódnak nem jóslunk hosszú jövőt. De az egy függvénybe öntött a "szkriptszerű" "minden egybe" megoldás ekkor sem jó irány, nagyon nehézzé teszi a kód átlátását, megértését. Ne is nézzük tovább.

## 2. Megoldás (OrganizedToFunctions-1)

Térjünk át Visual Studioban a "2-OrganizedToFunctions" mappában található "OrganizedToFunctions-1" projektben található megoldásra. Ez már sokkal jobb, mert függvényekre bontottuk a logikát. Tekintsük át a kódot röviden:

`Anonymizer.cs`

  * A `Run` függvény a "gerince", ez tartalmazza a vezérlési logikát, hívja az egyes lépésekért felelős függvényeket.
  * `ReadFromInput` művelet: beolvassa a forrásfájlt, minden sorhoz készít egy Person objektumot, és visszatér a beolvasott Person objektumok listájával.
  * `TrimCityNames`: Az adattisztítást végzi (városnevek trimmelése).
  * `Anonymize`: Minden egyes beolvasott Person objektummal meghívásra kerül, és feladata, hogy visszaadjon egy új `Person` objektumot, mely már az anonimizált adatokat tartalmazza.
  * `WriteToOutput`: már anonimizált Person objektumokat kiírja a kimeneti fájlba.
  * `PrintSummary`: kiírja az összesítést a feldolgozás végén a konzolra.

`Program.cs`

  * Létrehoz egy Anonymizer-t és a `Run` hívásával futtatja. Látható, hogy az anonimizálás során maszkolásra használt sztringet konstruktor paraméterben kell megadni.

Próbáljuk ki, futtassuk! Ehhez a "OrganizedToFunctions-1" legyen Visual Studioban a startup projekt (Jobb katt rajta, és *Set as Startup Project*), majd futtassuk:

![Console output](images/OrganizedToFunctions-1-console-out.png)

A kimeneti fájt fájlkezelőben tudjuk megnézni, a "OrganizedToFunctions-1\bin\Debug\net8.0\" vagy hasonló nevű mappában találjuk, "us-500.processed.txt" néven. Nyissuk meg, és vessünk egy pillantást az adatokra.

#### Értékeljük a megoldást

* A megoldás alapvetően jól strukturált, könnyen megérthető.
* Követi a **==KISS (Keep It Stupid Simple)==** elvet, nem használ felesleges bonyolításokat. Ez így jó, hiszen nem merültek fel jövőbeli potenciális jövőbeli továbbfejlesztési igények, nem kell különböző formátumokat, logikákat stb. támogatni.
* A megoldásunk nem követi az egyik legalapvetőbb és leghíresebb tervezési elvet, mely **==Single Responsibility Principle (röviden SRP)==** néven közismert. Ez némi egyszerűsítéssel élve azt várja el, hogy egy osztálynak egy felelőssége legyen.
  
    * Kétségtelen, hogy az `Anonymizer` osztályunknak számos felelőssége van: bemenet feldolgozása, adattisztítás, anonimizálás, kimenet előállítása stb.
    * Ez a probléma nálunk azért nem feltűnő, illetve azért nem okoz gondot, mert mindegyik felelősség megvalósítása egyszerű, "belefért" egy-egy rövidebb függvénybe. De ha bármelyik is összetettebb lenne, több függvényben lennének megvalósítva, akkor mindenképpen külön osztályba illene szervezni.

    ??? Note "Miért probléma, ha egy osztálynak több felelőssége van? Előadáson szerepelt, ismétlésképpen:"

        * Ha bármelyik felelősség mentén is jön be változási igény, egy nagy osztályt kell változtatni és újra tesztelni.
        * Ha több felelőssége van az osztálynak, akkor ezek egybefonódnak, így nehéz a kódunkat az egyes felelősségek mentén újrafelhasználhatóvá, kiterjeszthetővé és egységtesztelhetővé tenni. Látni fogjuk rövidesen.
  
* A megoldáshoz lehet írni automatizált integrációs (input-output) teszteket, de "igazi" egységteszteket nem. Arra  majd később térünk vissza, hogyan kell ezt értelmezni.

Nézzük, hogy kódunk mennyire tekinthető újrafelhasználhatónak és kiterjeszthetőnek:

![Reusability and extensibility 1](images/resuse-extensibility-20.png)

Érzésre 20 %-nál többet nem illene mondjunk: hiszen megoldásunk csak egyfajta bemeneti formátumot tud kezelni, egyfajta algoritmust támogat, egyféle kimenetet tud előállítani stb.

## 3. Megoldás (OrganizedToFunctions-2-TwoAlgorithms)

A korábbi "tervekkel" ellentétben új felhasználói igények merültek fel. Az ügyfelünk meggondolta magát, egy másik adathalmaznál másféle anonimizáló algoritmusra megvalósítását kéri: az személyek életkorát kell sávosan menteni, nem derülhet ki a személyek pontos életkora. Az egyszerűség érdekében ez esetben a személyek nevét nem fogjuk anonimizálni, így tekintsük ezt egyfajta "pszeudo" anonimizálásnak (ettől még lehet értelme, csak nem teljesen korrekt ezt anonimizálásnak nevezni).

A megoldásunkat - mely egyaránt támogatja a régi és az új algoritmust - a VS solution *OrganizedToFunctions-2-TwoAlgorithms* nevű projektjében találjuk. Nézzünk rá az Anonymizer osztályra. A megoldás alapelve (ezeket tekintsük át a kódban):

* Bevezettünk egy AnonymizerMode enum típus, mely meghatározza, hogy melyik üzemmódban használjuk az Anonymizer osztályt.
* Az `Anonymizer` osztálynak két anonimizáló művelete van: Anonymize_MaskName, Anonymize_AgeRange
* Az `Anonymizer` osztály a _anonymizerMode tagjában tárolja, melyik algoritmust kell használni: a két üzemmódhoz két külön konstruktort vezettünk be, ezek állítják be a _anonymizerMode értékét.
* Az `Anonymizer` osztály több helyen is megvizsgálja (pl. `Run`, `GetAnonymizerDescription` műveletek), hogy mi az _anonymizerMode értéke, és ennek függvényében elágazik.
* A `GetAnonymizerDescription`-ben azért kell megtenni, mert ennek a műveletnek a feladata az anonimizáló algoritmusról egy egysoros leírás előállítása, melyet a feldolgozás végén a "summary"-ben megjelenít. Nézzünk rá a `PintSummary` kódjára, ez a művelet hívja.

#### A megoldás értékelése

Összegészében megoldásunk a korábbinál rosszabb lett.
Azzal nem volt gond, hogy korábban nem volt az algoritmus tekintetében kiterjeszthető (hiszen nem volt rá igény), de ha már egyszer felmerült rá az igény, akkor hiba ebben a tekintetben nem kiterjeszthetővé tenni: innen sokkal inkább számítunk arra, hogy újabb algoritmus kell bevezetni a jövőben.

Miért állítjuk azt, hogy a kódunk nem kiterjeszthető, amikor "csak" egy új enum értéket, és egy-egy plusz if/switch ágat kell a kód néhány pontjára bevezetni?

Kulcsfontosságú, hogy egy kódot (osztályt) akkor tekintünk kiterjeszthetőnek, ha annak **módosítása nélkül**, pusztán a kód **bővítésével** lehet új viselkedést (esetünkben új algoritmust) bevezetni. Vagyis esetünkben az `Anonymizer` kódjához nem szabadna hozzányúlni! Ez egyértelműen nem teljesül. Ez a híres **==Open/Closed==** elv (the class should be Open for Extension, Closed for Modification). A módosítás azért probléma, mert annak során jó eséllyel új bugokat vezetünk be, ill. a módosított kódot mindig újra kell tesztelni, ez pedig jelentős idő/költségráfordítási igényt jelenthet.

Ábra ide!

## Tanulságok

 * A változó igények során organikusan jelennek meg tervezési minták és vetettünk be egyéb technikákat a refaktorálások során.