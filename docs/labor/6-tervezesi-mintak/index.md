---
authors: bzolka
---

# 6. Tervezési minták (kiterjeszthetőség)

## A gyakorlat célja

A gyakorlat céljai (egy összetettebb, életszerű példa alapján):

- Kiterjeszthetőséget, újrafelhasználhatóságot, kód átláthatóságot és karbantarthatóságot segítő néhány tervezési alapelv gyakorlása: SRP, OPEN-CLOSED, DRY, KISS stb.
- Néhány, a kiterjeszthetőséghez leginkább kapcsolódó tervezési minta alkalmazása (Template Method, Strategy, Dependency Injection).
- Kiterjeszthetőséget és újrafelhasználhatóságot támogató további technikák (pl. delegate/lambda kifejezés) gyakorlása és kombinálása tervezési mintákkal.
- Kód refaktorálás gyakorlása.

Kapcsolódó előadások:

- Tervezési minták: kiterjeszthetőséghez kapcsolódó minták (bevezető, Template Method, Strategy), valamint a Dependency Injection "minta".

## Előfeltételek

A gyakorlat elvégzéséhez szükséges eszközök:

- Visual Studio 2022

!!! tip "Gyakorlat Linuxon vagy macOS alatt"
    A gyakorlat anyag alapvetően Windowsra és Visual Studiora készült, de az elvégezhető más operációs rendszereken is más fejlesztőeszközökkel (pl. VS Code, Rider, Visual Studio for Mac), vagy akár egy szövegszerkesztővel és CLI (parancssori) eszközökkel. Ezt az teszi lehetővé, hogy a példák egy egyszerű Console alkalmazás kontextusában kerülnek ismertetésre (nincsenek Windows specifikus elemek), a .NET 8 SDK pedig támogatott Linuxon és macOS alatt. [Hello World Linuxon](https://learn.microsoft.com/en-us/dotnet/core/tutorials/with-visual-studio-code).

### Elméleti háttér, szemléletmód *

A komplexebb alkalmazások fejlesztése során számos tervezői döntést kell meghoznunk, melyek során több lehetőség közül is választhatunk. Amennyiben ezen pontokban nem tartjuk szem előtt az alkalmazásunk könnyű karbantarthatóságát, illetve egyszerűen megvalósítható továbbfejlesztési lehetőségét, könnyen hamar rémálommá válhat a fejlesztés. A megrendelői változtatási és bővítési igények a kód nagymértékű folyamatos átírását/módosítását igénylik: ennek során új hibák születnek, illetve jelentős munkát kell fektetni a kód nagy léptékű újratesztelésébe is!

A célunk az, hogy az ilyen változtatási és bővítési igényeket a kód pár jól meghatározott pontjában történő bővítésével - a meglévő kód érdemi módosítása nélkül - meg tudjuk valósítani. A kulcsszó: **módosítással** szemben **bővítés**. Ehhez kapcsolódóan: amennyiben bizonyos logikáink kiterjeszthetők, akkor azok általánosabbak is leszek, több kontextusban könnyebben is fel tudjuk ezeket használni. Így hosszabb távon gyorsabban haladunk, rövidebb a kód, elkerüljük a kódduplikációt (ezáltal könnyebben karbantartható is a kód).

A **tervezési minták** jól bevált megoldásokat mutatnak bizonyos gyakran előforduló tervezési problémákra: ezen megoldások abban segítenek, hogy kódunk könnyebben bővíthető, karbantartható és minél nagyobb mértékben újrafelhasználható legyen. Jelen gyakorlat keretében azon mintákra, tervezési elvekre és néhány programozói eszközre fókuszálunk, melyek a fenti problémákon segítenek.
Ugyanakkor ne essünk át a ló túloldalára: csak akkor érdemes egy adott tervezési mintát bevetni, ha adott esetben valós előnyt jelent az alkalmazása. Ellenkező esetben csak a megvalósítás komplexitását növeli feleslegesen.
Ennek tükrében nem is célunk (és sokszor nincs is rá lehetőségünk), hogy minden jövőbeli kiterjeszthetőségi igényt előre megérezzünk, illetve nagyon előre átgondoljunk. A lényeg az, hogy akár egy egyszerű megoldásból kiindulva, az egyes problémákat felismerve, a kódunkat folyamatosan refaktoráljuk úgy, hogy az aktuális (funkcionális és nemfunkcionális) követelményeknek és előrelátásunk szerint a megfelelő pontokban tegyük kódunkat könnyebben kiterjeszthetővé és újrafelhasználhatóvá.

Meg kell említeni, hogy kapcsolódó tervezési minták és nyelvi eszközök a kódunk **egységtesztelhetővé** tételében is nagymértékben segítenek: sok cégnél egy szoftvertermék fejlesztése esetén (jogos) alapelvárás a fejlesztőktől, hogy nagy kódlefedettségű egységteszteket (unit test) készítsenek. Ennek kivitelezése viszont gyakorlatilag lehetetlen, ha a kódunk egyes egységei/osztályai túl szoros csatolásban vannak egymással.

## 0. Feladat - Ismerkedés a feladattal és a kiinduló alkalmazással

Klónozzuk le a 6. laborhoz tartozó kiinduló alkalmazás [repositoryját](https://github.com/bmeviauab00/lab-patterns-extensibility-kiindulo):

- Nyissunk egy command prompt-ot
- Navigáljunk el egy tetszőleges mappába, például c:\work\NEPTUN
- Adjuk ki a következő parancsot: `git clone https://github.com/bmeviauab00/lab-patterns-extensibility-kiindulo.git`
- Nyissuk meg a _Lab-Patterns-Extensibility.sln_ solutiont Visual Studio-ban.

### A feladat ismertetése

A labor során egy konzol alapú, adatfeldolgozó (pontosabban anonimizáló) alkalmazást fogunk a folyamatosan alakuló igényeknek megfelelően - különböző pontok mentén és különböző technikákat alkalmazva - kiterjeszthetővé tenni. Az első feladat keretében az anonimizálás fogalmával is megismerkedünk.

Az alkalmazás bemenete egy CSV szövegfájl, mely minden sora egy adott személyre vonatkozóan tartalmaz adatokat. A fájlrendszerben nyissuk meg a *Data* mappában levő us-500.csv fájlt (duplakattal, vagy akár a Jegyzettömb/Notepad alkalmazásban). Az látjuk, hogy "" között, vesszővel elválasztva találhatók az egyes személyekre vonatkozó adatok (ezek nem valósak). Nézzük az első sort:
  
```
"James","Rhymes","Benton, John B Jr","6649 N Blue Gum St","New Orleans ","Orleans","LA","70116","504-621-8927","504-845-1427","30","65","Heart-related","jRhymes@gmail.com"
```

Az első sorban levő személyt James Rhymesnak nevezik, a "Benton, John B Jr" cégnél dolgozik, majd néhány címre vonatkozó mező található, 30 éves, 65 kg a testsúlya. Az ezt követő mező azt mondja meg, milyen súlyosabb betegsége van (a fenti sorban ez "Heart-related"). Az utolsó oszlop pedig a személy e-mail címét tartalmazza.

??? note "Adatok forrása és pontos formátuma *"
    Az adatok forrása: https://www.briandunning.com/sample-data/, pár oszloppal (kor, súly, betegség) kiegészítve. A mezők sorrendje: First Name, Last Name, Company, Address, City, County (where applicable), State/Province (where applicable), ZIP/Postal Code, Phone 1, Phone 2, Age, Weight, Illness, Email

Az alkalmazás alapfeladata, hogy ezeket az adatokat az aktuális igényeknek megfelelően anonimizálja, majd egy kimeneti CSV szövegfájlba kiírja. Az anonimizálás célja, hogy az adatok átalakításával adathalmazban levő személyeket beazonosíthatatlanná tegye, de olyan módon, hogy az adatokból mégis lehessen kimutatásokat készíteni. Az anonimizálás egy különálló, nagyon komoly és sok kihívást rejtő adatfeldolgozási szakterület. A gyakorlat keretében nem célunk, hogy valós környezetben is használható, vagy akár minden tekintetben értelmes megoldásokat dolgozzunk ki. Számunkra tulajdonképpen csak egy valamilyen adatfeldolgozó algoritmus "bevetése" a fontos a minták bemutatásához. Ez talán kicsit "izgalmasabb" keretet ad, mint egy egyszerű adatszűrés/sorrendezés/stb. alapú adatfeldolgozás (melyeket ráadásul a .NET már eleve beépítve támogat).

!!! note "Pár gondolat az anonimizálásról"

    Azt gondolhatnánk, hogy az anonimizálás egy egyszerű problémakör. Pl. csak el kell távolítani, vagy ki kell "csillagozni" a személyek neveit, lakcíméből az utca-házszámot, telefonszámokat, e-mail címet, és meg is vagyunk. Például a bemenetünk első sorára ez lenne a kimenet:

    ```
    "***","***","Benton, John B Jr","***","New Orleans ","Orleans","LA","70116","***","***","30","65","Heart-related","***"
    ```

    De ez koránt sincs így, különösen, ha igazán sok adatról van szó. Gondoljunk arra, hogy van egy kisebb falu, ahol nem laknak sokan. Tegyük fel, hogy az egyik fenti módon anonimizált személy életkora 14 év, de rendkívül túlsúlyos, 95 kg. Ez egy ritka "kombináció", más személy jó eséllyel nem él ilyen paraméterekkel a faluban. Ha az ő osztálytársai közül (nyolcadikos, hiszen 14 éves) valaki megnézi az "anonimizált" adatokat, tudni fogja ki ő (nincs más ennyire túlsúlyos nyolcadikos az iskolában), beazonosítja a személyt. Így pl. tudni fogja, milyen betegsége van az illetőnek. Tanulság: az adatok összefüggésben árulkodók lehetnek.
    
    Mi a megoldás? A várost, az életkort és a testtömeget nem törölhetjük/csillagozhatjuk, mert ezekre vonatkozóan kell kimutatást készíteni. Egy tipikus megoldás: nem pontos életkort/testsúlyt adunk meg az anonimizálást követően, hanem sávokat (vagyis általánosítjuk az adatokat): pl. a fenti személy esetében az életkora 10..20 év, testsúlya 80..100 kg, és ezeket adjuk meg erre a személyre vonatkozóan a kimeneti fájlban. Így már nem lehet beazonosítani a személyeket. Ezt a technikát mi is fogjuk később alkalmazni.

### Kiinduló követelmények

Az alkalmazással szemben támasztott kiinduló követelmények:

1. Egy adott ügyféltől kapott fájlokat (mindnek ugyanaz a formátuma) kell ugyanazzal az anonimizáló algoritmussal, ugyanabba a kimeneti formátumba konvertálni. Az anonimizálás egyszerűen a keresztnév és vezetéknév "kicsillagozásából" álljon.
2. Szükség van némi adattisztításra. A bemeneti adatokban a várost tartalmazó oszlop elején/végén lehetnek felesleges `_` és `#` karakterek, ezeket el kell távolítani (trim művelet).
3. Ki kell írni minden sor feldolgozása után a konzolra, hogy a sor feldolgozása megtörtént, ill. a minden adat feldolgozás után némi összesítő információt (Summary) is meg kell jeleníteni: hány sort dolgoztunk fel, és mennyinél kellett a városnevet trimmelni.
4. **Lényeges szempont**: az alkalmazásra csak rövid időre lesz szükség, nem a kívánjuk későbbiekben bővíteni.

Megjegyzés: annak érdekében, hogy a kódban kevesebb mezővel kelljen dolgozni, és a kimenet is átláthatóbb legyen, elhagyunk még néhány mezőt a feldolgozás során.

Példaként a bemeneti fájlunk első sorára a várt kimenet:

```
***; ***; LA; New Orleans; 30; 65; Heart-related
```

## 1. Megoldás - minden egyben (1-Start/Start)

A Visual Studio Solution Explorerében mappákat látunk, 1-től 4-ig számmal kezdődő névvel. Ezek az egyes munkaiterációkhoz tartozó megoldásokat tartalmazzák. Az első körös megoldás az "1-Start" mappában, "Start" projektnév alatt található. Nézzük meg a projektben található fájlokat:

* `Person.cs` - Egy személy számunkra érdekes adatai tartalmazza, ennek objektumaiba olvassuk be egy-egy személy adatait.
* `Program.cs` - Ennek Main függvényében van megvalósítva minden logika, kódmegjegyzésekkel "elválasztva". Amennyiben kicsit is bonyolultabbá válik a logika, már egy-két nap (óra?) után mi magunk is csak nehezen fogjuk áttekinteni és megérteni a saját kódunkat. Ezt a megoldást ne is nézzük.

Összegészében minden nagyon egyszerű a megoldásban, hiszen a kódnak nem jósolunk hosszú jövőt. De az egy függvénybe öntött "szkriptszerű", "minden egybe" megoldás ekkor sem jó irány, nagyon nehézzé teszi a kód **átlátását**, **megértését**. Ne is nézzük ezt tovább.

## 2. Megoldás (2-OrganizedToFunctions/OrganizedToFunctions-1)

Térjünk át Visual Studioban a "2-OrganizedToFunctions" mappában található "OrganizedToFunctions-1" projektben található megoldásra. Ez már sokkal szimpatikusabb, mert függvényekre bontottuk a logikát. Tekintsük át a kódot röviden:

`Anonymizer.cs`

  * A `Run` függvény a "gerince", ez tartalmazza a vezérlési logikát, ez hívja az egyes lépésekért felelős függvényeket.
  * `ReadFromInput` művelet: beolvassa a forrásfájlt, minden sorhoz készít egy `Person` objektumot, és visszatér a beolvasott `Person` objektumok listájával.
  * `TrimCityNames`: Az adattisztítást végzi (városnevek trimmelése).
  * `Anonymize`: Minden egyes beolvasott `Person` objektummal meghívásra kerül, és feladata, hogy visszaadjon egy új `Person` objektumot, mely már az anonimizált adatokat tartalmazza.
  * `WriteToOutput`: már anonimizált `Person` objektumokat kiírja a kimeneti fájlba.
  * `PrintSummary`: kiírja az összesítést a feldolgozás végén a konzolra.

`Program.cs`

  * Létrehoz egy `Anonymizer` objektumot és a `Run` hívásával futtatja. Látható, hogy az anonimizálás során maszkolásra használt stringet konstruktor paraméterben kell megadni.

Próbáljuk ki, futtassuk! Ehhez a "OrganizedToFunctions-1" legyen Visual Studioban a startup projekt (jobb katt rajta, és *Set as Startup Project*), majd futtassuk:

![Console output](images/OrganizedToFunctions-1-console-out.png)

A kimeneti fájt fájlkezelőben tudjuk megnézni, az "OrganizedToFunctions-1\bin\Debug\net8.0\" vagy hasonló nevű mappában találjuk, "us-500.processed.txt" néven. Nyissuk meg, és vessünk egy pillantást az adatokra.

### A megoldás értékelése

* A megoldás alapvetően jól strukturált, könnyen megérthető.
* Követi a **==KISS (Keep It Stupid Simple)==** elvet, nem használ felesleges bonyolításokat. Ez így jó, hiszen nem merültek fel potenciális jövőbeli továbbfejlesztési igények, nem kell különböző formátumokat, logikákat stb. támogatni.
* A megoldásunk ugyanakkor nem követi az egyik legalapvetőbb és leghíresebb tervezési elvet, mely **==Single Responsibility Principle (röviden SRP)==** néven közismert. Ez - némi egyszerűsítéssel élve - azt várja el, hogy egy osztálynak egy felelőssége legyen (alapvetően egy dologgal foglalkozzon).
  
    * Kétségtelen, hogy az `Anonymizer` osztályunknak számos felelőssége van: bemenet feldolgozása, adattisztítás, anonimizálás, kimenet előállítása stb.
    * Ez a probléma nálunk azért nem feltűnő, illetve azért nem okoz gondot, mert mindegyik felelősség megvalósítása egyszerű, "belefért" egy-egy rövidebb függvénybe. De ha bármelyik is összetettebb lenne, több függvényben lennének megvalósítva, akkor mindenképpen külön osztályba illene szervezni.

    ??? note "Miért probléma, ha egy osztálynak több felelőssége van? *"

        * Nehezebb megérteni a működését, mert nem egy dologra fókuszál.
        * Ha bármelyik felelősség mentén is jön be változási igény, egy nagy, sok mindennel foglalkozó osztályt kell változtatni és újra tesztelni.
  
* A megoldáshoz lehet írni automatizált integrációs (input-output) teszteket, de "igazi" egységteszteket nem.

## 3. Megoldás (OrganizedToFunctions-2-TwoAlgorithms)

A korábbi "tervekkel" ellentétben új felhasználói igények merültek fel. Az ügyfelünk meggondolta magát, egy másik adathalmaznál másféle anonimizáló algoritmus megvalósítását kéri: a személyek életkorát kell sávosan menteni, nem derülhet ki a személyek pontos életkora. Az egyszerűség érdekében ez esetben a személyek nevét nem fogjuk anonimizálni, így tekintsük ezt egyfajta "pszeudo" anonimizálásnak (ettől még lehet értelme, csak nem teljesen korrekt ezt anonimizálásnak nevezni).

A megoldásunkat - mely egyaránt támogatja a régi és az új algoritmust (egyszerre csak az egyiket) - a VS solution *OrganizedToFunctions-2-TwoAlgorithms* nevű projektjében találjuk. Nézzünk rá az `Anonymizer` osztályra, a megoldás alapelve (ezeket tekintsük át a kódban):

* Bevezettünk egy `AnonymizerMode` enum típust, mely meghatározza, hogy melyik üzemmódban (algoritmussal) használjuk az `Anonymizer` osztályt.
* Az `Anonymizer` osztálynak két anonimizáló művelete van: `Anonymize_MaskName`, `Anonymize_AgeRange`
* Az `Anonymizer` osztály a `_anonymizerMode` tagjában tárolja, melyik algoritmust kell használni: a két üzemmódhoz két külön konstruktort vezettünk be, ezek állítják be az `_anonymizerMode` értékét.
* Az `Anonymizer` osztály több helyen is megvizsgálja (pl. `Run`, `GetAnonymizerDescription` műveletek), hogy mi az `_anonymizerMode` értéke, és ennek függvényében elágazik.
  * A `GetAnonymizerDescription`-ben azért kell ezt megtenni, mert ennek a műveletnek a feladata az anonimizáló algoritmusról egy egysoros leírás előállítása, melyet a feldolgozás végén a "summary"-ben megjelenít. Nézzünk rá a `PintSummary` kódjára, ez a művelet hívja. Pl. ez jelenik meg a konzolon összefoglalóként, ha életkor anonimizálót használunk 20-as range-dzsel:
  
      ```Summary - Anonymizer (Age anonymizer with range size 20): Persons: 500, trimmed: 2```

### A megoldás értékelése

Összegészében megoldásunk kódminőség tekintetében a korábbinál **rosszabb** lett.
Korábban nem volt probléma, hogy anonimizáló algoritmusok tekintetében nem volt kiterjeszthető, hiszen nem volt rá igény. De ha már egyszer felmerült az igény új algoritmus bevezetésére, akkor hiba ebben a tekintetben nem kiterjeszthetővé tenni a megoldásunkat: ettől kezdve sokkal inkább számítunk arra, hogy újabb további algoritmusokat kell bevezetni a jövőben.

Miért állítjuk azt, hogy a kódunk nem kiterjeszthető, amikor "csak" egy új enum értéket, és egy-egy plusz `if`/`switch` ágat kell a kód néhány pontjára bevezetni, amikor új algoritmust kell majd bevezetni?

:warning: **Open/Closed principle**  
Kulcsfontosságú, hogy egy osztályt akkor tekintünk kiterjeszthetőnek, ha annak bármilyen nemű **módosítása nélkül**, pusztán a kód **kiterjesztésével/bővítésével** lehet új viselkedést (esetünkben új algoritmust) bevezetni. Vagyis esetünkben az `Anonymizer` kódjához nem szabadna hozzányúlni, ami egyértelműen nem teljesül. Ez a híres **Open/Closed principle/elv**: the class should be Open for Extension, Closed for Modification. A kód módosítása azért probléma, mert annak során jó eséllyel új bugokat vezetünk be, ill. a módosított kódot mindig újra kell tesztelni, ez pedig jelentős idő/költségráfordítási igényt jelenthet.

Mi is a pontos cél, és hogyan érjük ezt el? Vannak olyan részek az osztályunkban, melyeket nem szeretnénk beégetni:

* Ezek nem adatok, hanem **==viselkedések (kód, logika)==**.
* Nem `if`/`switch` utasításokkal oldjuk meg: "kiterjesztési pontokat" vezetünk be, és valamilyen módon megoldjuk, hogy ezekben "tetszőleges" kód lefuthasson.
* Ezek változó/esetfüggő részek kódját **más osztályokba** tesszük (az osztályunk szempontjából "lecserélhető" módon)!

!!! note
    Ne gondoljunk semmiféle varázslatra, a már ismert eszközöket fogjuk erre használni: öröklést absztrakt/virtuális függvényekkel, vagy interfészeket, vagy delegate-eket.

Keressük meg azokat a részeket, melyek esetfüggő, változó logikák, így nem jó beégetni az `Anonymizer` osztályba:

* Az egyik maga az anonimizálási logika: `Anonymize_MaskName`/`Anonymize_AgeRange`
* A másik a `GetAnonymizerDescription`

Ezeket kell leválasztani az osztályról, ezekben a pontokban kell kiterjeszthetővé tenni az osztályt. Az alábbi ábra illusztrálja a célt általánosságában *:

??? note "Az általános megoldási elv illusztrálása"

    ![Extensibility illustration](images/illustrate-extensibility.png)

A három konkrét tervezési mintát, ill. technikát nézünk meg a fentiek megvalósítására:

* Template Method tervezési minta
* Strategy tervezési minta (Dependency Injectionnel egyetemben)
* Delegate (opcionálisan Lambda kifejezéssel)

Valójában mind használtuk már a tanulmányaink során, de most mélyebben megismerkedünk velük, és átfogóbban be fogjuk gyakorolni ezek alkalmazását. Az első kettőt a labor keretében, a harmadikat pedig majd egy kapcsolódó házi feladat keretében.

## 4. Megoldás (3-TemplateMethod/TemplateMethod-1)

Ebben a lépésben a **Template Method** tervezési minta alkalmazásával fogjuk a megoldásunkat a szükséges pontokban kiterjeszthetővé tenni.

!!! note
    A minta neve "megtévesztő": semmi köze nincs a C++-ban tanult sablonmetódusokhoz!

??? info "Template Method alapú megoldás osztálydiagram"
    Az alábbi UML osztálydiagram illusztrálja a Template Method alapú megoldást, a lényegre fókuszálva:

    ![Template Method UML osztálydiagram cél](images/template-method-goal.png)

A mintában a következő elvek mentén valósul meg a "változatlan" és "változó" részek különválasztása (érdemes a fenti osztálydiagram alapján - a példánkra vetítve - ezeket megérteni):

* A "közös/változatlan" részeket egy ősosztályba tesszük.
* Ebben a kiterjesztési pontokat absztrakt/virtuális függvények bevezetése jelenti, ezeket hívjuk a kiterjesztési pontokban.
* Ezek esetfüggő megvalósítása a leszármazott osztályokba kerül.

A jól ismert "trükk" a dologban az, hogy amikor az ős meghívja az absztrakt/virtuális függvényeket, akkor a leszármazottbéli, esetfüggő kód hívódik meg.

A következőkben a korábbi `enum`, illetve `if`/`switch` alapú megoldást alakítjuk át **Template Method** alapúra (ebben már nem lesz enum). Egy ősosztályt és két, algoritmusfüggő leszármazottat vezetünk be.

Alakítsuk át a kódunkat ennek megfelelően. A VS solution-ben a "3-TemplateMethod" mappában a "TemplateMethod-0-Begin" projekt tartalmazza a korábbi megoldásunk kódját (annak "másolatát"), ebben a projektben dolgozzunk:

1. Nevezzük át az `Anonymizer` osztályt `AnonymizerBase`-re (pl. az osztály nevére állva a forrásfájlban és ++f2++-t nyomva).
2. Vegyünk fel az projektbe egy `NameMaskingAnonymizer` és egy `AgeAnonymizer` osztályt (projekten jobb katt, *Add*/*Class*).
3. Származtassuk az `AnonymizerBase`-ből őket
4. Az `AnonymizerBase`-ből mozgassuk át a `NameMaskingAnonymizer`-be az ide tartozó részeket:
    1. A `_mask` tagváltozót.
    2. A `string inputFileName, string mask` paraméterezésű konstruktort, átnevezve `NameMaskingAnonymizer`-re,
        1. `_anonymizerMode = AnonymizerMode.Name;` sort törölve,
        2. a `this` konstruktorhívás helyett `base` konstruktorhívással.
      
            ??? example "A konstruktor kódja"
      
                ``` csharp
                public NameMaskingAnonymizer(string inputFileName, string mask): base(inputFileName)
                {
                    _mask = mask;
                }
                ```

5. Az `AnonymizerBase`-ből mozgassuk át az `AgeAnonymizer`-be az ide tartozó részeket:
    1. A `_rangeSize` tagváltozót.
    2. A `string inputFileName, string rangeSize` paraméterezésű konstruktort, átnevezve `AgeAnonymizer`-re,
        1. `_anonymizerMode = AnonymizerMode.Age;` sort törölve,
        2. a `this` konstruktorhívás helyett `base` konstruktorhívással.

            ??? example "A konstruktor kódja"
      
                ``` csharp
                public AgeAnonymizer(string inputFileName, int rangeSize): base(inputFileName)
                {
                    _rangeSize = rangeSize;
                }
                ```

6. Az `AnonymizerBase`-ben:
      1. Töröljük az `AnonymizerMode` enum típust.
      2. Töröljük a `_anonymizerMode` tagot.

Keressük meg azokat a részeket, melyek esetfüggő, változó logikák, így nem akarjuk beégetni az újrafelhasználhatónak szánt `AnonymizerBase` osztályba:

* Az egyik az `Anonymize_MaskName`/`Anonymize_AgeRange`,
* a másik a `GetAnonymizerDescription`.

A mintát követve ezekre az ősben absztrakt (vagy esetleg virtuális) függvényeket vezetünk be, és ezeket hívjuk, az esetfüggő implementációikat pedig a leszármazott osztályokba tesszük (override):

1. Tegyük az `AnonymizerBase` osztályt absztrakttá (a `class` elé `abstract` kulcsszó).
2. Vezessünk be az `AnonymizerBase`-ben egy

    ``` csharp
    protected abstract Person Anonymize(Person person);
    ```

    műveletet (ennek feladata lesz az anonimizálás végrehajtása).

3. Az `Anonymize_MaskName` műveletet mozgassuk át a `NameMaskingAnonymizer` osztályba, és alakítsuk át a szignatúráját úgy, hogy override-olja az ősbeli `Anonymize` absztrakt függvényt:

    ``` csharp
    protected override Person Anonymize(Person person)
    {
        return new Person(_mask, _mask, person.CompanyName,
            person.Address, person.City, person.State, person.Age, person.Weight, person.Decease);
    }
    ```

    A függvény törzsét csak annyiban kell átírni, hogy ne a megszüntetett `mask` paramétert, hanem a `_mask` tagváltozót használja.

4. Az előző lépéssel teljesen analóg módon az `Anonymize_AgeRange` műveletet mozgassuk át a `AgeAnonymizer` osztályba, és alakítsuk át a szignatúráját úgy, hogy override-olja az ősbeli `Anonymize` absztrakt függvényt:

    ``` csharp
    protected override Person Anonymize(Person person)
    {
        ...
    }
    ```

    A függvény törzsét csak annyiban kell átírni, hogy ne a megszüntetett `rangeSize` paramétert, hanem a `_rangeSize` tagváltozót használja.

5. A `AnonymizerBase` osztály `Run` függvényében az `if`/`else` kifejezésben található `Anonymize` hívásokat most már le tudjuk cserélni egy egyszerű absztrakt függvény hívásra:

    {--

    ``` csharp
    Person person;
    if (_anonymizerMode == AnonymizerMode.Name)
        person = Anonymize_MaskName(persons[i], _mask);
    else if (_anonymizerMode == AnonymizerMode.Age)
        person = Anonymize_AgeRange(persons[i], _rangeSize);
    else
        throw new NotSupportedException("The requested anonymization mode is not supported.");
    ```

    --}

    helyett:

    ``` csharp
    var person = Anonymize(persons[i]);
    ```

Az egyik kiterjesztési pontunkkal el is készültünk. De maradt még egy, a `GetAnonymizerDescription`, mely kezelése szintén esetfüggő. Ennek átalakítása nagyon hasonló az előző lépéssorozathoz:

1. Az `AnonymizerBase` osztály `GetAnonymizerDescription` műveletét másoljuk át a `NameMaskingAnonymizer`-be, a szignatúrába belevéve az `override` kulcsszót, a függvény törzsében csak a `NameMaskingAnonymizer`-re vonatkozó logikát meghagyva:

    ``` csharp
    protected override string GetAnonymizerDescription()
    {
        return $"NameMasking anonymizer with mask {_mask}";
    }
    ```

 2. A `AnonymizerBase` `GetAnonymizerDescription` műveletét másoljuk át az `AgeAnonymizer`-be is, a szignatúrába belevéve az `override` kulcsszót, a függvény törzsében most csak a `AgeAnonymizer`-re vonatkozó logikát meghagyva:

    ``` csharp
    protected override string GetAnonymizerDescription()
    {
        return $"Age anonymizer with range size {_rangeSize}";
    }
    ```

3. Kérdés, mi legyen `AnonymizerBase`-ben a `GetAnonymizerDescription` művelettel. Ezt nem absztraktá, hanem virtuális függvénnyé alakítjuk, hiszen itt tudunk értelmes alapértelmezett viselkedést biztosítani: egyszerűen visszaadjuk az osztály nevét (mely pl. a `NameMaskingAnonymizer` osztály esetében "NameMaskingAnonymizer" lenne). Mindenesetre a rugalmatlan `switch` szerkezettől ezzel megszabadulunk:

    ``` csharp
    protected virtual string GetAnonymizerDescription()
    {
        return GetType().Name;
    }
    ```

    !!! note "Reflexió"
        Az object ősből örökölt `GetType()` művelettel egy `Type` típusú objektumot szerzünk az osztályunkra vonatkozóan. Ez a **refelexió** témakörhöz tartozik, erről a félév végén fogunk előadáson részletesebben tanulni.

Egy dolog van már csak hátra: a `Program.cs` `Main` függvényében most az `AnonymizerBase` őst próbáljuk példányosítani (a korábbi átnevezés miatt). Helyette a két leszármazott valamelyikét kellene. Pl.:

``` csharp
NameMaskingAnonymizer anonymizer = new("us-500.csv", "***");
anonymizer.Run();
```

El is készültünk. Próbáljuk ki, hogy jobban "érezzük", valóban működnek az kiterjesztési pontok (de ha kevés az időnk a labor során, ez különösebben nem fontos, hasonlót már korábbi félévekben C++/Java nyelvek kontextusában is csináltunk):

* Visual Studioban a *TemplateMethod-0-Begin* projekt legyen a startup projekt, ha ezt eddig még nem állítottuk be.
* Tegyünk egy töréspontot az `AnonymizerBase` osztály `var person = Anonymize(persons[i]);` sorára.
* Amikor futás közben itt megáll a debugger, ++f11++-gyel lépjünk bele.
* Az tapasztaljuk, hogy a  leszármazott `AgeAnonymizer` művelete hívódik.

Vethetünk egy pillantást a megoldás osztálydiagramjára:

??? "Template Method alapú megoldás osztálydiagram *"
    ![Template Method alapú megoldás osztálydiagram](images/template-method.png)

!!! note "Az eddigi munkánk megoldása a `3-TemplateMethod/TemplateMethod-1` projektben megtalálható, ha esetleg szükség lenne rá."

??? "Miért Template Method a minta neve *"
    A minta azért kapta a Template Method nevet, mert - alkalmazásunkat példaként használva - a `Run` és a `PrintSummary` olyan "sablon metódusok", melyek meghatároznak egy sablonszerű logikát, vázat, melyben bizonyos lépések nincsenek megkötve. Ezek "kódját" absztrakt/virtuális függvényekre bízzuk, és a leszármazott osztályok határozzák meg a megvalósításukat.

### A megoldás értékelése

Ellenőrizzük a megoldást, megvalósítja-e a céljainkat:

* Az `AnonymizerBase` egy újrafelhasználható(bb) osztály lett.
* Ha új anonimizáló logikára van szükség a jövőben, csak származtatunk belőle. Ez nem módosítás, hanem bővítés.
* Ennek megfelelően teljesül az OPEN/CLOSED elv, vagyis a kódjának módosítása nélkül tudjuk az ősben megadott két pontban a logikát testre szabni, kiterjeszteni.

!!! note "Legyen minden pontban kiterjeszthető az osztályunk?"
    Figyeljük meg, hogy nem tettünk az `AnonymizerBase` minden műveletét virtuálissá (így sok pontban kiterjeszthetővé az osztályt). Csak ott tettük meg, ahol azt gondoljuk, hogy a jövőben szükség lehet a logika kiterjesztésére.

## 5. Megoldás (3-TemplateMethod/TemplateMethod-2-Progress)

T.f.h új - viszonylag egyszerű - igény merül fel:

* A `NameMaskinAnonimizer` esetén marad ugyan a korábbi egyszerű progress kijelzés (minden sor után kiírjuk, hányadiknál tartottunk),

    ??? note "Egyszerű progress illusztrálása"
        ![Egyszerű progress illusztrálása](images/progress-simple.png)

* de az `AgeAnonymizer` esetén a progress kijelzés más kell legyen: azt kell kiírni - minden sor után frissítve -, hogy hány százaléknál tart a feldolgozás.

    ??? note "Százalékos progress illusztrálása"
        ![Százalékos progress illusztrálása](images/progress-percent.gif)
        
        (Mivel jelenleg kevés az adatunk (mindössze 500 sor), ezt a megoldásunk végén nem így látjuk majd, pillanatok alatt 100%-ra ugrik)

A megoldás nagyon egyszerű: a `Run` műveletben szélesebb körben alkalmazva a Template Method mintát, a progress kiíráskor is egy kiterjesztési pontot vezetünk be, egy virtuális függvényre bízzuk a megvalósítást.

Ugorjunk egyből a kész megoldásra (*3-TemplateMethod/TemplateMethod-2-Progress* projekt):

* `AnonymizerBase` osztályban új `PrintProgress` virtuális függvény (alapértelmezésben nem ír ki semmit)
* `Run`-ban ennek hívása
* `NameMaskingAnonymizer`-ben és `NameMaskingAnonymizer`-ben megfelelő megvalósítás (override)
  
Ennek egyelőre különösebb tanulsága nincs, de a következő lépésben már lesz.

## 6. Megoldás (3-TemplateMethod/TemplateMethod-3-ProgressMultiple)

Új - és teljesen logikus - igény merült fel: a jövőben bármely anonimizáló algoritmust bármely progress megjelenítéssel lehessen használni. Ez jelen pillanatban négy keresztkombinációt jelent:

| Anonimizáló         | Progress          |
| ------------------- | ----------------- |
| Név anonimizáló     | Egyszerű progress |
| Név anonimizáló     | Százalék progress |
| Kor anonimizáló     | Egyszerű progress |
| Kor anonimizáló     | Százalék progress |

Ugorjunk a kész megoldásra (*3-TemplateMethod/TemplateMethod-3-ProgressMultiple* projekt). Kód helyett a `Main.cd` osztálydiagramot nyissuk meg a projektben, és a megoldást az alapján tekintjük át (vagy nézhetjük a diagramot alább az útmutatóban).

??? "Template Method alapú megoldás (két aspektus) osztálydiagram"
    ![Template Method alapú megoldás (két aspektus) osztálydiagram](images/template-method-progress-multiple.png)

Érezhető, hogy valami "baj van", minden keresztkombinációnak külön leszármazottat kellett létrehozni. Sőt, a kódduplikáció csökkentésére még plusz, köztes osztályok is vannak a hierarchiában. Ráadásul:

* Ha a jövőben új anonimizáló algoritmust vezetünk be, annyi új osztályt kell írni (legalább), ahány progress típust támogatunk.
* Ha a jövőben új progress típust vezetünk be, annyi új osztályt kell írni (legalább), ahány anonimizáló típust támogatunk.

Mi okozta a problémát? Az, hogy **az osztályunk viselkedését több aspektus/dimenzió mentén (példánkban az anonimizálás és progress) kell kiterjeszthetővé tenni, és ezeket sok keresztkombinációban kell támogatni**. Ha újabb aspektusok mentén kellene ezt megtenni (pl. beolvasás módja, kimenet generálása), akkor a probléma exponenciálisan tovább "robbanna". Ilyen esetekben a Template Method tervezési minta nem alkalmazható.

## 7. Megoldás (4-Strategy/Strategy-1)

Ebben a lépésben a **Strategy** tervezési minta alkalmazásával fogjuk a kezdeti megoldásunkat a szükséges pontokban kiterjeszthetővé tenni. A mintában a következő elvek mentén valósul meg a "változatlan/újrafelhasználható" és "változó" részek különválasztása:

* A "közös/változatlan" részeket egy adott osztályba tesszük (de ez most nem egy "ősosztály" lesz).
* A Template Methoddal szemben nem öröklést, hanem kompozíciót (tartalmazást) alkalmazunk: interfészként tartalmazott más objektumokra bízzuk a viselkedés megvalósítását a kiterjesztési pontokban (és nem absztrakt/virtuális függvényekre).
* Mindezt az osztály viselkedésének minden olyan aspektusára/dimenziójára, melyet lecserélhetővé/bővíthetővé szeretnénk tenni, egymástól függetlenül megtesszük. Mint látni fogjuk, ezzel az előző fejezetben tapasztalt kombinatorikus robbanás elkerülhető.

Ez sokkal egyszerűbb a gyakorlatban, mint amilyennel leírva érződik (már használtuk is párszor korábbi tanulmányaink során). Értsük meg a példánkra vetítve.

A következőkben tekintsük át a Strategy alapú megoldást illusztráló osztálydiagramot (a diagramot követő magyarázatra építve).

??? info "Strategy alapú megoldás osztálydiagram"
    Az alábbi UML osztálydiagram illusztrálja a Strategy alapú megoldást, a lényegre fókuszálva:

    ![Strategy UML osztálydiagram cél](images\strategy-goal.png)

A Strategy minta alkalmazásának első lépése, hogy meghatározzuk, **az osztály viselkedésének hány különböző aspektusa van**, melyet kiterjeszthetővé szeretnénk tenni. A példánkban ebből - egyelőre legalábbis - kettő van:

* Anonimizáláshoz kötődő viselkedés, melyhez két művelet tartozik:
    * Anonimizáló logika
    * Anonimizáló logika leírásának meghatározása (description string előállítása)
* Progress kezelés, melyhez egy művelet tartozik:
    * Progress megjelenítése

A nehezével meg is vagyunk, ettől kezdve alapvetően mechanikusan lehet dolgozni a Strategy mintát követve:

1. A fenti aspektusok mindegyikéhez egy-egy strategy interfészt kell bevezetni, a fent meghatározott műveletekkel, és ezekhez el kell készíteni a megfelelő implementációkat.
2. Az `Anonymizer` osztályba be kell vezetni egy-egy strategy interfész tagváltozót, és a kiterjesztési pontokban ezen tagváltozókon keresztül használni az aktuálisan beállított strategy implementációs objektumokat.

A fenti osztálydiagramon meg is jelennek ezek az elemek. Most térjünk át a kódra. Kiinduló környezetünk a "4-Strategy" mappában a "Strategy-0-Begin" projektben található, ebben dolgozzunk. Ez ugyanaz, az enum-ot használó megoldás, mint amelyet a Template Method minta esetében is kiindulásként használtunk. 

### Anonimizálási stratégia

Az **anonimizálási stratégia/aspektus** kezelésével kezdünk. Vezessük be az ehhez tartozó interfészt:

1. Hozzunk létre a projektben egy `AnonymizerAlgorithms` nevű mappát (jobb katt a "Strategy-0-Begin" projekten, majd *Add/New Folder* menü). A következő lépésekben minden interfészt és osztályt egy külön, a nevének megfelelő forrásfájlba tegyünk a szokásos módon!
2. Vegyünk fel ebben a mappában egy `IAnonymizerAlgorithm` interfészt az alábbi kóddal:

    ``` csharp title="IAnonymizerAlgorithm.cs"
    public interface IAnonymizerAlgorithm
    {
        Person Anonymize(Person person);
        string GetAnonymizerDescription() => GetType().Name;
    }
    ```

    Azt is megfigyelhetjük a `GetAnonymizerDescription` művelet esetében, hogy a modern C# nyelven, amennyiben akarunk, tudunk az egyes interfész műveleteknek alapértelmezett implementációt adni!

Most ennek az interfésznek a **név** anonimizáláshoz tartozó megvalósítását készítjük el (vagyis egy strategy implementációt készítünk). 

1. Vegyünk fel egy `NameMaskingAnonymizerAlgorithm` osztályt ugyenebbe a mappába.
2. Az `Anonymizer` osztályból mozgassuk át a `NameMaskingAnonymizerAlgorithm`-be az ide tartozó `_mask` tagváltozót:
3. A `NameMaskingAnonymizerAlgorithm`-be vegyük fel a következő konstruktort:

    ``` csharp
    public NameMaskingAnonymizerAlgorithm(string mask)
    {
        _mask = mask;
    }
    ```

4. Valósítsuk meg a `IAnonymizerAlgorithm` interfészt. Miután az osztály neve után beírjuk a `: IAnonymizerAlgorithm` interfészt, célszerű a műveletek vázát a Visual Studioval legeneráltatni: tegyük a kurzort a interfész nevére (kattintsunk rá a forráskódban), használjuk a 'ctrl' + '.' billentyűkombinációt, majd a megjelenő menüben "Implement interface" kiválasztása. Megjegyzés: mivel a `GetAnonymizerDescription` művelethez van alapértelmezett implementáció az interfészben, csak az `Anonymize` művelet generálódik le, de ez most nekünk egyelőre rendben van így. 
5. Az `Anonymizer` osztályból vegyük át a `Anonymize_MaskName` művelet törzsét a `NameMaskingAnonymizerAlgorithm`.`Anonymize`-be. A függvény törzsét csak annyiban kell átírni, hogy ne a már nem létező `mask` paramétert, hanem a `_mask` tagváltozót használja. Az `Anonymize` osztály `Anonymize_MaskName`-et pedig töröljük.
6. A stategy interfész `GetAnonymizerDescription`műveletének megvalósítására térünk most át. Az `Anonymizer` osztály `GetAnonymizerDescription` műveletét másoljuk át a `NameMaskingAnonymizerAlgorithm`-be, a függvény törzsében csak a név anonimizálóra vonatkozó logikát meghagyva, a műveletet publikussá téve:

    ``` csharp
    public string GetAnonymizerDescription()
    {
        return $"NameMasking anonymizer with mask {_mask}";
    }  
    ```

8. ??? example "Ezzel a név anonimizáláshoz tartozó strategy implementációnk elkészült, a teljes kódja a következő lett"

        ``` csharp title="NameMaskingAnonymizerAlgorithm.cs"
        public class NameMaskingAnonymizerAlgorithm: IAnonymizerAlgorithm
        {
            private readonly string _mask;

            public NameMaskingAnonymizerAlgorithm(string mask)
            {
                _mask = mask;
            }

            public Person Anonymize(Person person)
            {
                return new Person(_mask, _mask, person.CompanyName,
                    person.Address, person.City, person.State, person.Age, person.Weight, person.Decease);
            }

            public string GetAnonymizerDescription()
            {
                return $"NameMasking anonymizer with mask {_mask}";
            }
        }
        ```

A következő lépésben az `IAnonymizerAlgorithm` strategy interfészünk **életkor** anonimizáláshoz tartozó megvalósítását készítjük el.

1. Vegyünk fel egy `AgeAnonymizerAlgorithm` osztályt ugyenebbe a mappába (AnonymizerAlgorithms).
2. Az `Anonymizer` osztályból mozgassuk át a `AgeAnonymizerAlgorithm`-be az ide tartozó `_rangeSize` tagváltozót:
3. A `AgeAnonymizerAlgorithm`-be vegyük fel a következő konstruktort:

    ``` csharp
    public AgeAnonymizerAlgorithm(int rangeSize)
    {
        _rangeSize = rangeSize;
    }
    ```

4. Valósítsuk meg a `IAnonymizerAlgorithm` interfészt. Miután az osztály neve után beírjuk a `: IAnonymizerAlgorithm` interfészt, most is célszerű az `Anonymize` művelet vázát a Visual Studioval a korábbihoz hasonló módon legeneráltatni. 
5. Az `Anonymizer` osztályból vegyük át az `Anonymize_AgeRange` művelet törzsét a `AgeAnonymizerAlgorithm`.`Anonymize`-be. A függvény törzsét csak annyiban kell átírni, hogy ne a már nem létező `rangeSize` paramétert, hanem a `_rangeSize` tagváltozót használja. Az `Anonymize` osztály `Anonymize_AgeRange`-et pedig töröljük.
6. A stategy interfész `GetAnonymizerDescription`műveletének megvalósítására térünk most át. Az `Anonymizer` osztály `GetAnonymizerDescription` műveletét másoljuk át az `AgeAnonymizerAlgorithm`-be, a függvény törzsében csak a kor anonimizálóra vonatkozó logikát meghagyva, a műveletet publikussá téve:

    ``` csharp
    public string GetAnonymizerDescription()
    {
        return $"Age anonymizer with range size {_rangeSize}";
    } 
    ```

7. ??? example "Ezzel a kor anonimizáláshoz tartozó strategy implementációnk elkészült, a teljes kódja a következő lett"

        ``` csharp title="AgeAnonymizerAlgorithm.cs"
        public class AgeAnonymizerAlgorithm: IAnonymizerAlgorithm
        {
            private readonly int _rangeSize;

            public AgeAnonymizerAlgorithm(int rangeSize)
            {
                _rangeSize = rangeSize;
            }

            public Person Anonymize(Person person)
            {
                // This is whole number integer arithmetics, e.g for 55 / 20 we get 2
                int rangeIndex = int.Parse(person.Age) / _rangeSize;
                string newAge = $"{rangeIndex * _rangeSize}..{(rangeIndex + 1) * _rangeSize}";

                return new Person(person.FirstName, person.LastName, person.CompanyName,
                    person.Address, person.City, person.State, newAge,
                    person.Weight, person.Decease);
            }

            public string GetAnonymizerDescription()
            {
                return $"Age anonymizer with range size {_rangeSize}";
            }
        }
        ```


:exclamation: Mindenképpen figyeljük meg, hogy az interfész és a megvalósításai kizárólag az anonimizálással foglalkoznak, semmiféle más logika (pl. progress kezelés) nincs itt!

### Progress stratégia

A következő lépésben vezessük be a **progress kezeléshez** tartozó interfészt és implementációkat:

1. Hozzunk létre a projektben egy `Progresses` nevű mappát. A következő lépésekben minden interfészt és osztályt egy külön, a nevének megfelelő forrásfájlba tegyünk a szokásos módon.
2. Vegyünk fel ebben a mappában egy `IProgress` interfészt az alábbi kóddal:

    ??? example "Megoldás"

        ``` csharp title="IProgress.cs"
        public interface IProgress
        {
            void Report(int count, int index);
        }
        ```

3. Vegyük fel ennek az interfésznek az egyszerű progresshez tartozó megvalósítását ugyanebbe a mappába. Az implementáció az `Anonymizer` osztályunk `PrintProgress` műveletéből lett "levezetve":

    ??? example "Megoldás"

        ``` csharp title="SimpleProgress.cs"
        public class SimpleProgress: IProgress
        {
            public void Report(int count, int index)
            {
                Console.WriteLine($"{index + 1}. person processed");
            }
        }
        ```

4. Vegyük fel ennek az interfésznek a százalékos progresshez tartozó megvalósítását ugyanebbe a mappába. A kód értelmezésével ne foglalkozzunk. Erre megoldás az `Anonymizer` osztályunkban nincs, hiszen ezt csak a template method alapú megoldásunknál vezettük be (ott nem néztük a kódját, de azzal gyakorlatilag megegyezik a lényege):

    ??? example "Megoldás"

        ``` csharp title="PercentProgress.cs"
        public class PercentProgress: IProgress
        {
            public void Report(int count, int index)
            {
                int percentage = (int)((double)(index+1) / count * 100);

                Console.Write($"\rProcessing: {percentage} %");

                if (index == count - 1)
                    Console.WriteLine();
            }
        }
        ```

:exclamation: Mindenképpen figyeljük meg, hogy az interfész és a megvalósításai kizárólag a progress kezeléssel foglalkoznak, semmiféle más logika (pl. anonimizálás) nincs itt!

### A stratégiák alkalmazása

A következő fontos lépés az anonimizáló alaposztály újrafelhasználhatóvá és kiterjeszthetővé tétele a fent bevezetett strategy-k segítségével. Az `Anonymizer.cs` fájlban:

1. Töröljük a következőket:
      * `AnonymizerMode` enum típus
      * `_anonymizerMode` tag (illetve a `_mask` és `_rangeSize` tagok, ha esetleg itt maradtak korábban)
  
2. Vezessünk be egy-egy strategy interfész típusú tagot:

    ``` csharp
    private readonly IProgress _progress;
    private readonly IAnonymizerAlgorithm _anonymizerAlgorithm;
    ```

3. A fájl elejére szúrjunk be a megfelelő usingokat:

    ``` csharp
    using Lab_Extensibility.AnonymizerAlgorithms;
    using Lab_Extensibility.Progresses;
    ```

4. Az előző pontban bevezetett `_progress` és `_anonymizerAlgorithm` kezdőértéke null, a konstruktorban állítsuk ezeket a referenciákat az igényeinknek megfelelő implementációra. Pl.:

    ``` csharp hl_lines="3-4 9-10"
    public Anonymizer(string inputFileName, string mask) : this(inputFileName)
    {
        _progress = new PercentProgress();
        _anonymizerAlgorithm = new NameMaskingAnonymizerAlgorithm(mask);
    }

    public Anonymizer(string inputFileName, int rangeSize) : this(inputFileName)
    {
        _progress = new PercentProgress();
        _anonymizerAlgorithm = new AgeAnonymizerAlgorithm(rangeSize);
    }
    ```

Az `Anonymizer` osztályban a jelenleg beégetett, de **anonimizálás függő** logikákat bízzuk a `_anonymizerAlgorithm` tagváltozó által hivatkozott strategy implementációra:

1. Az osztály `Run` függvényében az `if`/`else` kifejezésben található `Anonymize` hívásokat most már delegáljuk a `_anonymizerAlgorithm` objektumnak:

    {--

    ``` csharp
    Person person;
    if (_anonymizerMode == AnonymizerMode.Name)
        person = Anonymize_MaskName(persons[i], _mask);
    else if (_anonymizerMode == AnonymizerMode.Age)
        person = Anonymize_AgeRange(persons[i], _rangeSize);
    else
        throw new NotSupportedException("The requested anonymization mode is not supported.");
    ```

    --}

    helyett:

    ``` csharp
    Person person = _anonymizerAlgorithm.Anonymize(persons[i]);
    ```

2. Ha esetleg korábban nem tettük meg, töröljük a `Anonymize_MaskName` és `Anonymize_AgeRange` függvényeket, hiszen ezek kódja már a strategy implementációkba került, az osztályról leválasztva.

4. A `PrintSummary` függvényünk a rugalmatlan, `switch` alapokon működő `GetAnonymizerDescription`-t hívja. Ezt a `GetAnonymizerDescription` hívást cseréljük le, delegáljuk a `_anonymizerAlgorithm` objektumnak. A `PrintSummary` függvényben (csak a lényeget kiemelve):

    ``` csharp
        ... GetAnonymizerDescription() ...
    ```

    helyett:

    ``` csharp
        ... _anonymizerAlgorithm.GetAnonymizerDescription() ...
    ```

    Pár sorral lejjebb a `GetAnonymizerDescription` függvényt töröljük is az osztályból (ennek kódja megfelelő strategy implementációkba bekült).

Az utolsó lépés az `Anonymizer` osztályba beégetett **progress kezelés** lecserélése:

1. Itt is delegáljuk a kérést, mégpedig a korábban bevezetett `_progress` objektumunknak. A `Run` függvényben egy sort kell ehhez lecserélni:

    {--

    ``` csharp
    PrintProgress(i);
    ```

    --}

    helyett:

    ``` csharp
    _progress.Report(persons.Count, i);
    ```

2. Töröljük a `PrintProgress` függvényt, hiszen ennek kódja már egy megfelelő strategy implementációba került, az osztályról leválasztva.

Elkészültünk, a kész megoldás a "4-Strategy/Strategy-1" projektben meg is található (ha valahol elakadtunk, vagy nem fordul a kód, ezzel össze lehet nézni).

### A megoldás értékelése

A strategy minta bevezetésével elkészültünk. Jelen formájában ugyanakkor szinte soha nem használjuk. Ellenőrizzük a megoldásunkat: valóban újrafelhasználható, és az `Anomymizer` osztály módosítása nélkül lehetőség van-e az anonimizáló algoritmus, illetve a progress kezelés megváltoztatására? Ehhez azt kell megnézni, bárhol az osztályban van-e olyan kód, mely implementáció függő.

Sajnos találunk ilyet. A konstruktorba be van égetve, milyen algoritmus implementációt és progress implementációt hozunk létre. Ezt mindenképpen nézzük meg a kódban! Ha algoritmus vagy progress módot akarunk változtatni, ezekben a sorokban át kell írni a `new` operátor utáni típust, mely így az osztály módosításával jár.

Sokan - teljesen jogosan - ezt jelen formájában nem is tekintik igazi Strategy alapú megoldásnak. A teljes körű megoldást a következő lépésben valósítjuk meg.

## 8. Megoldás (4-Strategy/Strategy-2-DI)

:warning: **Dependency Injection (DI)**  
A megoldást a **Dependency Injection (röviden DI)** alkalmazása jelenti. Ennek lényege az, hogy nem maga az osztály példányosítja a viselkedésbeli függőségeit (ezek a strategy implementációk), hanem ezeket kívülről adjuk át neki, pl. konstruktor paraméterekben, vagy akár property-k vagy setter műveletek formájában. Természetesen interfész típusként hivatkozva!

Alakítsuk át ennek megfelelően az `Anonymizer` osztályt úgy, hogy ne maga példányosítsa a strategy implementációit, hanem konstruktor paraméterekben kapja meg azokat:

1. Töröljük mindhárom konstruktorát
2. Vegyük fel a következő konstruktort:

    ``` csharp
    public Anonymizer(string inputFileName, IAnonymizerAlgorithm anonymizerAlgorithm, IProgress progress = null)
    {
        ArgumentException.ThrowIfNullOrEmpty(inputFileName);
        ArgumentNullException.ThrowIfNull(anonymizerAlgorithm);

        _inputFileName = inputFileName;
        _anonymizerAlgorithm = anonymizerAlgorithm;
        _progress = progress;
    }
    ```

    Mint látható, a `progress` paraméter megadása nem kötelező, hiszen lehet, hogy az osztály használója nem kíváncsi semmiféle progress információra.

3. Mivel a _progress strategy null is lehet, egy null vizsgálatot be kell vezessünk a használata során. A "." operátor helyett a "?." operátort használjuk:

    ``` csharp
    _progress?.Report(persons.Count,i);
    ```

4. Most már elkészültünk, az `Anonymizer` osztály teljesen független lett a strategy implementációktól. Lehetőségünk van az `Anonymizer` osztályt bármilyen anonimizáló algoritmus és bármilyen progress kezelés kombinációval használni (annak módosítása nélkül). Hozzunk is létre három `Anonymizer` különböző kombinációkkal a `Program.cs` fájl `Main` függvényében (a meglévő kódot előtte töröljük a `Main` függvényből):

    ``` csharp
    Anonymizer p1 = new("us-500.csv",
        new NameMaskingAnonymizerAlgorithm("***"),
        new SimpleProgress());
    p1.Run();

    Console.WriteLine("--------------------");

    Anonymizer p2 = new("us-500.csv",
        new NameMaskingAnonymizerAlgorithm("***"),
        new PercentProgress());
    p2.Run();

    Console.WriteLine("--------------------");

    Anonymizer p3 = new("us-500.csv",
        new AgeAnonymizerAlgorithm(20),
        new SimpleProgress());
    p3.Run();
    ```

5. Ahhoz, hogy a kód foruljon, szúrjuk be a fájl elejére a szükséges `using`-okat

    ``` csharp
    using Lab_Extensibility.AnonymizerAlgorithms;
    using Lab_Extensibility.Progresses;
    ```

Elkészültünk, a kész megoldás a "4-Strategy/Strategy-2-DI" projektben meg is található (ha valahol elakadtunk, vagy nem fordul a kód, ezzel össze lehet nézni).

!!! Note "A működés ellenőrzése"
    A gyakorlat során erre valószínűleg nem lesz idő, de aki bizonytalan abban, "mitől is működik" a strategy minta, mitől lesz más a viselkedés a fenti négy esetre: érdemes töréspontokat tenni a `Program.cs` fájlban a négy `Run` függvényhívásra, és a függvényekbe a debuggerben belelépkedve kipróbálni, hogy mindig a megfelelő strategy implementáció hívódik meg.

A projektben található egy osztálydiagram (`Main.cd`), ezen is megtekinthető a kész megoldás:

??? note "Strategy alapú megoldás osztálydiagram"
    Az alábbi UML osztálydiagram illusztrálja a Strategy alapú megoldásunkat:

    ![Strategy DI UML osztálydiagram](images\strategy-di.png)

### A megoldás értékelése

Ellenőrizzük a megoldást, megvalósítja-e a céljainkat:

* Az `Anonymizer` egy újrafelhasználható(bb) osztály lett.
* Ha új anonimizáló logikára van szükség a jövőben, csak egy új `IAnonymizerAlgorithm` implementációt kell bevezetni. Ez nem módosítás, hanem kiterjesztés/bővítés.
* Ha új progress logikára van szükség a jövőben, csak egy új `IProgress` implementációt kell bevezetni. Ez nem módosítás, hanem bővítés.
* A fenti két pontban teljesül az OPEN/CLOSED elv, vagyis az `Anonymizer` kódjának módosítása nélkül tudjuk a logikáját testre szabni, kiterjeszteni.
* Itt nem kell tartani a Template Methodnál tapasztalt kombinatorikus robbanástól: bármely `IAnonymizerAlgorithm` implementáció bármely `IProgress` implementációval kényelmesen használható, nem kell a kombinációkhoz új osztályokat bevezetni (ezt láttuk a `Program.cs` fájlban).

!!! Note "További Strategy előnyök a Template Methoddal szemben *"
    * Futás közben lecserélhető viselkedés is megvalósítható. Ha szükség lenne arra, hogy egy adott `Anonymizer` objektumra vonatkozóan a létrehozása után meg tudjuk változtatni az anonimizáló vagy progress viselkedést, akkor azt könnyen meg tudnánk tenni (csak egy `SetAnonimizerAlgorithm`, ill. `SetProgress` műveletet kellene bevezetni, melyben a paraméterben megkapott implementációra lehetne állítani az osztály által használt strategy-t).
    * Egységtesztelhetőség támogatása (laboron ezt nem nézzük).