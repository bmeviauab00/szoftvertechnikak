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
  
```
"James","Butt","Benton, John B Jr","6649 N Blue Gum St","New Orleans ","Orleans","LA","70116","504-621-8927","504-845-1427","39","96","Heart-related","jbutt@gmail.com"*
```

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
2. Szükség van egy kis adattisztításra. A bemeneti adatokban a várost tartalmazó oszlop elején/végén lehetnek felesleges `_` és `#` karakterek, ezeket el kell távolítani (trim művelet).
3. Ki kell írni minden sor feldolgozása után a konzolra, hogy a sor feldolgozása megtörtént, ill. a minden adat feldolgozás után némi összesítő információt (Summary): hány sort dolgoztunk fel, és mennynél kellett a városnevet trimmelni.
4. Lényeges szempont: az alkalmazásra csak rövid időre lesz szükség, nem a kívánjuk későbbiekben bővíteni.

Megjegyzés: hogy a kódban kevesebb mezővel kelljen dolgozni, és a kimenet is átláthatóbb legyen, elhagyunk még néhány mezőt a feldolgozás során.

A várt kimeneti formátumra egy egysoros példa:

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

### A megoldás értékelése

* A megoldás alapvetően jól strukturált, könnyen megérthető.
* Követi a **==KISS (Keep It Stupid Simple)==** elvet, nem használ felesleges bonyolításokat. Ez így jó, hiszen nem merültek fel jövőbeli potenciális jövőbeli továbbfejlesztési igények, nem kell különböző formátumokat, logikákat stb. támogatni.
* A megoldásunk nem követi az egyik legalapvetőbb és leghíresebb tervezési elvet, mely **==Single Responsibility Principle (röviden SRP)==** néven közismert. Ez némi egyszerűsítéssel élve azt várja el, hogy egy osztálynak egy felelőssége legyen.
  
    * Kétségtelen, hogy az `Anonymizer` osztályunknak számos felelőssége van: bemenet feldolgozása, adattisztítás, anonimizálás, kimenet előállítása stb.
    * Ez a probléma nálunk azért nem feltűnő, illetve azért nem okoz gondot, mert mindegyik felelősség megvalósítása egyszerű, "belefért" egy-egy rövidebb függvénybe. De ha bármelyik is összetettebb lenne, több függvényben lennének megvalósítva, akkor mindenképpen külön osztályba illene szervezni.

    ??? Note "Miért probléma, ha egy osztálynak több felelőssége van? Előadáson szerepelt, ismétlésképpen:"

        * Ha bármelyik felelősség mentén is jön be változási igény, egy nagy osztályt kell változtatni és újra tesztelni.
        * Ha több felelőssége van az osztálynak, akkor ezek egybefonódnak, így nehéz a kódunkat az egyes felelősségek mentén újrafelhasználhatóvá, kiterjeszthetővé és egységtesztelhetővé tenni. Látni fogjuk rövidesen.
  
* A megoldáshoz lehet írni automatizált integrációs (input-output) teszteket, de "igazi" egységteszteket nem. Arra  majd később térünk vissza, hogyan kell ezt értelmezni.

Nézzük, hogy kódunk "hasraütésre" mennyire tekinthető újrafelhasználhatónak és kiterjeszthetőnek:

![Reusability and extensibility 1](images/resuse-extensibility-20.png)

Érzésre 20 %-nál többet nem illene mondjunk: hiszen megoldásunk csak egyfajta bemeneti formátumot tud kezelni, egyfajta algoritmust támogat, egyféle kimenetet tud előállítani stb.

## 3. Megoldás (OrganizedToFunctions-2-TwoAlgorithms)

A korábbi "tervekkel" ellentétben új felhasználói igények merültek fel. Az ügyfelünk meggondolta magát, egy másik adathalmaznál másféle anonimizáló algoritmusra megvalósítását kéri: az személyek életkorát kell sávosan menteni, nem derülhet ki a személyek pontos életkora. Az egyszerűség érdekében ez esetben a személyek nevét nem fogjuk anonimizálni, így tekintsük ezt egyfajta "pszeudo" anonimizálásnak (ettől még lehet értelme, csak nem teljesen korrekt ezt anonimizálásnak nevezni).

A megoldásunkat - mely egyaránt támogatja a régi és az új algoritmust - a VS solution *OrganizedToFunctions-2-TwoAlgorithms* nevű projektjében találjuk. Nézzünk rá az `Anonymizer` osztályra, a megoldás alapelve (ezeket tekintsük át a kódban):

* Bevezettünk egy `AnonymizerMode` enum típust, mely meghatározza, hogy melyik üzemmódban használjuk az `Anonymizer` osztályt.
* Az `Anonymizer` osztálynak két anonimizáló művelete van: `Anonymize_MaskName`, `Anonymize_AgeRange`
* Az `Anonymizer` osztály a `_anonymizerMode` tagjában tárolja, melyik algoritmust kell használni: a két üzemmódhoz két külön konstruktort vezettünk be, ezek állítják be az `_anonymizerMode` értékét.
* Az `Anonymizer` osztály több helyen is megvizsgálja (pl. `Run`, `GetAnonymizerDescription` műveletek), hogy mi az _anonymizerMode értéke, és ennek függvényében elágazik.
* A `GetAnonymizerDescription`-ben azért kell megtenni, mert ennek a műveletnek a feladata az anonimizáló algoritmusról egy egysoros leírás előállítása, melyet a feldolgozás végén a "summary"-ben megjelenít. Nézzünk rá a `PintSummary` kódjára, ez a művelet hívja.

### A megoldás értékelése

Összegészében megoldásunk a korábbinál rosszabb lett.
Azzal nem volt gond, hogy korábban nem volt az algoritmus tekintetében kiterjeszthető (hiszen nem volt rá igény), de ha már egyszer felmerült rá az igény, akkor hiba ebben a tekintetben nem kiterjeszthetővé tenni: innen sokkal inkább számítunk arra, hogy újabb algoritmus kell bevezetni a jövőben.

Miért állítjuk azt, hogy a kódunk nem kiterjeszthető, amikor "csak" egy új enum értéket, és egy-egy plusz if/switch ágat kell a kód néhány pontjára bevezetni?

<div class="grid cards" markdown>

- :warning: __FONTOS__  
  *Kulcsfontosságú, hogy egy kódot (osztályt) akkor tekintünk kiterjeszthetőnek, ha annak **módosítása nélkül**, pusztán a kód **bővítésével** lehet új viselkedést (esetünkben új algoritmust) bevezetni. Vagyis esetünkben az `Anonymizer` kódjához nem szabadna hozzányúlni! Ez egyértelműen nem teljesül. Ez a híres **==Open/Closed==** elv (the class should be Open for Extension, Closed for Modification). A módosítás azért probléma, mert annak során jó eséllyel új bugokat vezetünk be, ill. a módosított kódot mindig újra kell tesztelni, ez pedig jelentős idő/költségráfordítási igényt jelenthet.*

</div>

Vannak olyan részek az osztályban, melyeket nem szeretnénk beégetni:

* Ezek nem adatok, hanem **==viselkedések (kód, logika)==**
* Nem `if`/`switch` utasításokkal oldjuk meg: "kiterjesztési pontokat" vezetünk be, és valamilyen módon megoldjuk, hogy ezekben "tetszőleges" kód lefuthasson.
* Ezek változó/esetfüggő részek kódját más osztályokba tesszük (az osztályunk szempontjából "lecserélhető" módon)!

!!! Note
    Ne gondoljunk semmiféle varázslatra, a már ismert eszközöket fogjuk erre használni:  öröklést absztrakt/virtuális függvényekkel, vagy interfészeket vagy delegate-eket.

Keressük meg azokat a részeket, melyek esetfüggő, változó logikák, így nem jó beégetni az `Anonymizer` osztályba:

* Az egyik maga az anonimizálási logika: `Anonymize_MaskName`/`Anonymize_AgeRange`
* A másik a `GetAnonymizerDescription`

Ezeket kell leválasztani az osztályról, ezeknél kell kiterjeszthetővé tenni az osztályt. Az alábbi ábra illusztrálja a célt általánosságában:

??? Note "Az általános megoldási elv illusztrálása"

    ![Extensibility illustration](images/illustrate-extensibility.png)

A labor keretében három konkrét tervezési mintát, ill. technikát nézünk meg a fentiek megvalósítására:

* Template Method tervezési minta
* Strategy tervezési minta
* Delegate/Lambda funkcionális

Valójában mind használtuk már a tanulmányaink során, de most mélyebben megismerkedünk velük, és átfogóbban be fogjuk gyakorolni ezek alkalmazását.

## 4. Megoldás (TemplateMethod-1)

Ebben a lépésben a **Template Method** tervezési minta alkalmazásával fogjuk a megoldásunkat a szükséges pontokban kiterjeszthetővé tenni. A mintában a következő elvek mentén valósul meg a "változatlan" és "változó" részek különválasztása:

* A "közös/változatlan" részeket egy ősosztályba tesszük.
* Ebben a kiterjesztési pontokat absztrakt/virtuális függvények bevezetése jelenti, ezeket hívjuk a kiterjesztési pontokban.
* Ezek esetfüggő megvalósítása a leszármazott osztályokba kerül (az ősben hívott).

A jól ismert "trükk" a dologban az, hogy amikor az ős meghívja az absztrakt/virtuális függvényeket, akkor a leszármazottbéli, esetfüggő kód hívódik meg.

!!! Note
    A minta neve "megtévesztő": semmi köze nincs a C++-ban tanult sablonmetódusokhoz!

Alakítsuk át a korábbi `if`/`switch` alapú megoldás **Template Method** alapúra. A VS solution-ben a "3-TemplateMethod" mappában a "TemplateMethod-0-Begin" projekt tartalmazza a korábbi megoldásunk kódját (annak "másolatát"), ebben a projektben dolgozzunk:

1. Nevezzük át az `Anonymizer` osztályt `AnonymizerBase`-re (pl. az osztály nevére állva a forrásfájlban és ++f2++-t nyomva).
2. Vegyünk fel az projektbe egy `NameMaskingAnonymizer` és egy `AgeAnonymizer` osztályt (projekten jobb katt, *Add*/*class*).
3. Származtassuk az `AnonymizerBase`-ből őket
4. Az `AnonymizerBase`-ből mozgassuk át a `NameMaskingAnonymizer`-be az ide tartozó részeket
   1. `_mask` tag
   2. A `string inputFileName, string mask` paraméterezésű konstruktor, átnevezve `NameMaskingAnonymizer`-re,
      1. `_anonymizerMode = AnonymizerMode.Name;` sort törölve,
      2. a `this` konstruktorhívás helyett `base` konstruktorhívással.
4. Az `AnonymizerBase`-ből mozgassuk át az `AgeAnonymizer`-be az ide tartozó részeket
   1. `_rangeSize` tag
   2. A `string inputFileName, string rangeSize` paraméterezésű konstruktor, átnevezve `AgeAnonymizer`-re,
      1. `_anonymizerMode = AnonymizerMode.Name;` sort törölve,
      2. a `this` konstruktorhívás helyett `base` konstruktorhívással.
5. Az `AnonymizerBase`-ben
   1. Töröljük az `AnonymizerMode` enum típust
   2. Töröljük a `_anonymizerMode` tagot

Keressük meg azokat a részeket, melyek esetfüggő, változó logikák, így nem akarunk beégetni az újrafelhasználhatónak szánt `AnonymizerBase` osztályba:

* Az egyik az `Anonymize_MaskName`/`Anonymize_AgeRange`,
* a másik a `GetAnonymizerDescription`.

A mintát követve ezek esetfüggő implementációit a leszármazottakba tesszük, az ősben pedig absztrakt (vagy esetleg virtuális) függvényeket vezetünk be ezekre, és ezeket hívjuk:

1. Tegyük az `AnonymizerBase` osztály absztrakttá (a `class` elé `abstract` kulcsszó)
2. Vezessünk be az `AnonymizerBase`-ben egy

    ``` csharp
    protected abstract Person Anonymize(Person person);
    ```

    műveletet.

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

5. A `AnonymizerBase` osztály Run függvényében az if/else kifejezésben található Anonymize hívásokat most már le tudjuk cserélni egy egyszerű absztrakt függvény hívásra:

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

Az egyik kiterjesztési pontunkkal el is készültünk. De maradt még egy, a `GetAnonymizerDescription`, mely kezelése szintén esetfüggő. Ennek átalakítása nagyon hasonló az előző lépéssorozathoz. Idő hiányában ezt az átalakítást gyakorlaton nem tesszük meg (lehet otthoni gyakorló feladat), hanem a kész megoldásra ugrunk, ezt a "TemplateMethod-1" nevű projektben találjuk. Fussuk át a megoldás alapelemeit:

1. Az `AnonymizerBase`-ben a `GetAnonymizerDescription` nem absztrakt, hanem virtuális függvényként került bevezetésre, hiszen itt tudtunk értelmes alapértelmezett viselkedést biztosítani: egyszerűen visszaadjuk az osztály nevét (mely pl. a `NameMaskingAnonymizer` osztály esetében "NameMaskingAnonymizer"). Mindenesetre a csúnya switch-case szerkezettől megszabadultunk.
2. A leszármazottakban felülírjuk ezt a virtuális függvényt, belefűzzük a leírásba az osztályspecifikus adatokat (pl.`NameMaskingAnonymizer` esetében a `_mask` értékét).

A "TemplateMethod-0-Begin" projektünk most nem forduló kódot tartalmaz, ezt célszerű eltávolítani a solution-ből, hogy a későbbi futtatások során ne legyen zavaró: jobb katt a projekten és `Remove` menü.

El is készültünk. Ha sok időnk van, ki is próbálhatjuk, hogy jobban "érezzük", működnek az kiterjesztési pontok (de ez különösebben nem fontos, hasonlót már C++ ismereteinktől kezdve csináltunk):

* Legyen a "TemplateMethod-1" projekt a startup projekt.
* Tegyünk egy töréspontot az `AnonymizerBase` osztály `var person = Anonymize(persons[i]);` sorára.
* Amikor futás közben itt megáll a debugger, ++F11++-gyel lépjünk bele.
* Az tapasztaljuk, hogy a  leszármazott `AgeAnonymizer` művelete hívódik.

Vethetünk egy pillantást a megoldás osztálydiagramjára:

??? "Template Method alapú megoldás osztálydiagram"
    ![Template Method alapú megoldás osztálydiagram](images/template-method.png)

??? "Miért Template Method a minta neve"
    A minta azért kapta a Template Method nevet, mert - esetünket példaként használva - a `Run` és a `PrintSummary` olyan "sablonok metódus", melyek meghatároznak egy sablonszerű logikát, vázat, melyben bizonyos lépések nincsenek megkötve (ezek "kódját" absztrakt/virtuális függvényekre bízzuk, és a leszármazott osztályok határozzák meg a megvalósításukat).

### A megoldás értékelése

Ellenőrizzük a megoldást, megvalósítja-e a céljainkat:

* Az `AnonymizerBase` egy újrafelhasználható(bb) osztály lett.
* Ha új anonimizáló logikára van szükség a jövőben, csak származtatunk belőle. Ez nem módosítás, hanem bővítés.
* Ennek megfelelően teljesül az OPEN/CLOSED elv, vagyis a kódjának módosítása nélkül tudjuk az ősben megadott két pontban a logikát testre szabni, kiterjeszteni.

!!! Note "Legyen minden pontban kiterjeszthető az osztályunk?"
    Figyeljük meg, hogy nem tettünk az `AnonymizerBase` minden műveletét virtuálissá (így sok pontban kiterjeszthetővé az osztályt). Csak ott tettük meg, ahogy azt gondoljuk, hogy a jövőben szükség lehet a logika kiterjesztésére.

## 5. Megoldás (TemplateMethod-2-Progress)

T.f.h új - viszonylag egyszerű - igény merül fel:

* A `NameMaskinAnonimizer` esetén marad a korábbi marad ugyan a korább folyamat (angolul progress) kijelzés (minden sor után kiírjuk, hányadiknál tartottunk),
* de az `AgeAnonymizer` esetén a folyamat (progress) kijelzés más kell legyen: azt kell kiírni - minden sor után frissítve -, hogy hány százaléknál tart a feldolgozás.

A megoldás nagyon egyszerű: a Run műveletben szélesebb körben alkalmazva a Template Method mintát, a progress kiíráskor is egy kiterjesztési pontot vezetünk be, egy virtuális függvényre bízzuk.

Ugorjunk egyből a kész megoldásra (*TemplateMethod-2-Progress* projekt):

* `AnonymizerBase` osztályban új PrintProgress virtuális függvény (alapértelmezésben nem ír ki semmit)
* `Run`-ban ennek hívása
* `NameMaskingAnonymizer`-ben és `NameMaskingAnonymizer`-ben megfelelő megvalósítás (override)
  
Ennek egyelőre különösebb tanulsága nincs, de a következő lépésben már lesz.

## 5. Megoldás (TemplateMethod-3-ProgressMultiple)

Új - és teljesen logikus - igény merült fel: a jövőben bármely anonimizáló algoritmust bármely progress megjelenítéssel lehessen használni. Ez jelen pillanatban négy keresztkombinációt jelent:

| Anonimizáló         | Progress          |
| ------------------- | ----------------- |
| Név anonimizáló     | Egyszerű progress |
| Név anonimizáló     | Százalék progress |
| Kor anonimizáló     | Egyszerű progress |
| Kor anonimizáló     | Százalék progress |

Ugorjunk a kész megoldásra (TemplateMethod-3-ProgressMultiple projekt). Kód helyett érdemes a Main.cd osztálydiagramot megnyitni és a megoldást az alapján áttekinteni.

??? "Template Method alapú megoldás (két aspektus) osztálydiagram"
    ![Template Method alapú megoldás (két aspektus) osztálydiagram](images/template-method-progress-multiple.png)

Érezhető, hogy valami "baj van", minden keresztkombinációnak külön leszármazottat kellett létrehozni. Sőt, a kódduplikáció csökkentésére még plusz, köztes osztályok is vannak a hierarchiában. Ráadásul:
* Ha a jövőben új anonimizáló algoritmust vezetünk be, annyi új osztályt kell írni (legalább), ahány progress típust támogatunk.
* Ha a jövőben új progress típust vezetünk be, annyi új osztályt kell írni (legalább), ahány anonimizáló típust támogatunk.

Mi okozta a problémát? Az, hogy az osztályunk viselkedését több asektuk/dimenzió mentén (példánkban az anonimizálás és progress) kell kiterjeszthetővé tenni, és ezeket sok keresztkombinációban támogatni. Ha újabb aspektusok mentén kellene ezt megtenni (pl. beolvasás módja, kimenet generálása), akkor a probléma exponenciálisan tovább "robbanna". Ilyen esetekben a Template Method tervezési minta nem alkalmazható.

??? "Template Method minta további korlátai"

    * A viselkedés futás közben nem megváltoztatható. Pl. ha létrehoztunk egy AgeAnonymizerWithPercentProgress típusú objektumot, akkor ez csak életkor szerint tud anonimizálni és százalék progresst megjeleníteni, ezeket a viselkedéseket nem lehez az objektumra futás közben megváltoztatni. Esetünkben ennek nincs semmi jelentősége, de vannak olyan feladatok, amikor hasonlóra szükség lehet.
    * Körülményesen támogatja az egységtesztelhetőséget (később visszatérünk erre).

## 6. Megoldás (Strategy-1)

Ebben a lépésben a **Strategy** tervezési minta alkalmazásával fogjuk a kezdeti megoldásunkat a szükséges pontokban kiterjeszthetővé tenni. A mintában a következő elvek mentén valósul meg a "változatlan" és "változó" részek különválasztása:

* A "közös/változatlan" részeket egy adott osztályba tesszük (de ez most nem egy "ősosztály" lesz).
* A Template Methoddal szemben nem öröklést, hanem kompozíciót (tartalmazást) alkalmazunk: interfészként tartalmazott más objektumokra bízzuk a viselkedés megvalósítását a kiterjesztési pontokban (és nem absztrakt/virtuális függvényekre).
* Mindezt az osztály viselkedésének minden olyan aspektusára/dimenziójára, melyet lecserélhetővé/bővíthetővé szeretnénk tenni, egymástól függetlenül megtesszük. Ezzel az előző fejezetben tapasztalt kombinatorikus robbanás elkerülhető.

Ez sokkal egyszerűbb a gyakorlatban, mint amilyennel leírva érződik (már használtuk is jópárszor tanulmányaink során), értsük meg a példánkra vetítve.

Kiinduló környezetünk a "4-Strategy" mappában a "Strategy-0-Begin" projektben található, ebben dolgozzunk. Ez ugyanaz, az enum-ot használó megoldás, mint amit a Template Method minta esetében is kiindulásként használtunk.

A Strategy minta alkalmazásának első lépése, hogy meghatározzuk, az osztály viselkedésének hány különböző aspektusa van, melyet kiterjeszthetővé szeretnénk tenni. A példánkban ebből - egyelőre legalábbis - kettő van:

* Anonimizáláshoz kötödő viselkedés, melyhez két művelet tartozik:
    * Anonimizáló logika
    * Aninimizáló leírásának meghatározása (description)
* Progress kezelés, melyhez egy művelet tartozik:
    * Progress megjelenítése

A nehezével meg is vagyunk, ettől kezdve alapvetően mechanikusan lehet dolgozni:

* a fenti aspektusok mindegyikéhez egy-egy interfészt kell bevezetni, a fent meghatározott műveletekkel,
* majd ezekhez el kell készíteni a megfelelő implementációkat.

Ezeket fogjuk most megtenni.

Először vezessük be az **anonimizáláshoz** tartozó interfészt és implementációkat:

1. Hozzunk létre a projektben egy `AnonymizerAlgorithms` nevű mappát (jobb katt a "Strategy-0-Begin" projekten, majd *Add/New Folder* menü).
2. A következő lépésekben minden interfészt és osztály egy külön, a nevének megfelelő forrásfájlba tegyünk a szokásos módon!
3. Vegyünk fel ebben egy `IAnonymizerAlgorithm` interfészt az alábbi kóddal:

    ``` csharp title="IAnonymizerAlgorithm.cs"
    public interface IAnonymizerAlgorithm
    {
        Person Anonymize(Person person);
        string GetAnonymizerDescription() => GetType().Name;
    }
    ```

    Azt is megfigyelhetjük a `GetAnonymizerDescription` művelet esetében, hogy a modern C# nyelven, amennyiben akarunk, tudunk az egyes interfész műveleteknek alapértelmezett implementációt adni!

4. Vegyük fel ennek az interfésznek az név anonimizáláshoz tartozó megvalósítását ugyanebbe a mappába **

    ??? example "Megoldás"

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

5. Vegyük fel ennek az interfésznek az életkor anonimizáláshoz tartozó megvalósítását ugyanebbe a mappába**

    ??? example "Megoldás"

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

6. Fontos gondolat

    !!! warning
        Mindenképpen figyeljük meg, hogy az interfész és a megvalósításai kizárólag az anonimizálással foglalkoznak, semmiféle más logika (pl. progress kezelés) nincs itt!

Második lépésben vezessük be a **progress kezeléshez** tartozó interfészt és implementációkat:

1. Hozzunk létre a projektben egy `Progresses` nevű mappát.
2. A következő lépésekben minden interfészt és osztály egy külön, a nevének megfelelő forrásfájlba tegyünk a szokásos módon.
3. Vegyünk fel ebben egy `IProgress` interfészt az alábbi kóddal:

    ``` csharp title="IProgress.cs"
    public interface IProgress
    {
        void Report(int count, int index);
    }
    ```

4. Vegyük fel ennek az interfésznek az egyszerű progresshez tartozó megvalósítását ugyanebbe a mappába**

    ??? example "Megoldás"

        ``` csharp title="IProgress.cs"
        public class SimpleProgress: IProgress
        {
            public void Report(int count, int index)
            {
                Console.WriteLine($"{index + 1}. person processed");
            }
        }
        ```

5. Vegyük fel ennek az interfésznek az százalékos progresshez tartozó megvalósítását ugyanebbe a mappába**

    ??? example "Megoldás"

        ``` csharp title="IProgress.cs"
        public class PercentProgress: IProgress
        {
            public void Report(int count, int index)
            {
                int percentage = (int)((double)(index+1) / count * 100);

                var pos = Console.GetCursorPosition();
                Console.SetCursorPosition(0, pos.Top);

                Console.Write($"Processing: {percentage} %");

                if (index == count - 1)
                    Console.WriteLine();
            }
        }
        ```

6. Fontos gondolat

    !!! warning "Fontos"
        Mindenképpen figyeljük meg, hogy az interfész és a megvalósításai kizárólag a progress kezeléssel foglalkoznak, semmiféle más logika (pl. anonimizálás) nincs itt!


A következő fontos lépés az anoninimizáló alaposztály újrafelhasználhatóvá és kiterjeszthetővé tétele a fent bevezetett strategy-k segítségével. Az Anonymizer.cs fájlban:

1. Töröljük a következőket:
   1. `AnonymizerMode` enum típus
   2. `_anonymizerMode`, `_mask` és `_rangeSize` tagok
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

    ``` csharp
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

Az `Anonymizer` osztályban a jelenleg beégetett anonimizálás függő logikákat bízzuk a _anonymizerAlgorithm tagváltozó által hivatkozott strategy implementációra:

1. Az osztály `Run` függvényében az `if`/`else` kifejezésben található `Anonymize` hívásokat most már le delegáljuk a `_anonymizerAlgorithm` objektumnak:

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

    !!! warning "Fontos"
        Vegyük észre, hogy a viselkedés nincs beégetve a kódba, teljesen attól függ, hogy a `_anonymizerAlgorithm` interfész milyen implementációra mutat. Vagyis itt valóban egy kiterjesztési pontot vezettünk be.

TODO <COMING SOON>

### A megoldás értékelése

Ellenőrizzük a megoldást, megvalósítja-e a céljainkat:

* Az `Anonymizer` egy újrafelhasználható(bb) osztály lett.
* Ha új anonimizáló logikára van szükség a jövőben, csak egy új `IAnonymizerAlgorithm` implementációt kell bevezetni. Ez nem módosítás, hanem bővítés.
* Ha új progress logikára van szükség a jövőben, csak egy új `IProgress` implementációt kell bevezetni. Ez nem módosítás, hanem bővítés.
* A fenti két pontban teljesül az OPEN/CLOSED elv, vagyis az `Anonymizer` kódjának módosítása nélkül tudjuk a logikát testre szabni, kiterjeszteni.
* Itt nem kell tartani a Template Methodnál tapasztalt kombinatorikus robbanástól: bármely `IAnonymizerAlgorithm` implementáció bármely `IProgress` implementációban kényelmesen használható, nem kell a kombinációkhoz új osztályokat bevezetni.

!!! Note "További Strategy előnyök
    * Futás közben lecserélhető
    * ...

Keressük meg azokat a részeket, melyek esetfüggő, változó logikák, így nem akarunk beégetni az újrafelhasználhatónak szánt `Anonymizer` osztályunkba:

* Az egyik az `Anonymize_MaskName`/`Anonymize_AgeRange`,
* a másik a `GetAnonymizerDescription`.

A mintát követve ezek esetfüggő implementációit a leszármazottakba tesszük, az ősben pedig absztrakt (vagy esetleg virtuális) függvényeket vezetünk be ezekre, és ezeket hívjuk:

TODO NullStrategy

## Tanulságok

Strategy elejére tegyük be az UML diagramot? ?????????????????????

 * A változó igények során organikusan jelennek meg tervezési minták és vetettünk be egyéb technikákat a refaktorálások során.

A Template Method egyszerű esetben, ha a viselkedések különböző aspektusainak nem kell sok keresztkombinációját támogatni, nagyon kényelmes és egyszerű megoldást ad, különösen, ha egyébként is kell használjuk a származtatást. De nem, vagy csak nehezen egységtesztelhető.

