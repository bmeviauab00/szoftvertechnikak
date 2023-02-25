---
search:
  exclude: true
authors: BenceKovari,bzolka
---

# 2. HF - Nyelvi eszközök

## Bevezetés

Az önálló feladat a 2. előadáson elhangzottakra épít. A feladatok elméleti hátteréül az [Előadás 02 - Modern nyelvi eszközök.zip](https://www.aut.bme.hu/Upload/Course/VIAUAB00/hallgatoi_jegyzetek/El%c5%91ad%c3%a1s%2002%20-%20Modern%20programoz%c3%a1si%20eszk%c3%b6z%c3%b6k.zip) leírás, gyakorlati hátteréül a [2. labor - Nyelvi eszközök](../../labor/2-nyelvi-eszkozok/index.md) laborgyakorlat szolgál.

A fentiekre építve, jelen önálló gyakorlat feladatai a feladatleírást követő rövidebb iránymutatás segítségével elvégezhetők.

Az önálló gyakorlat célja:

- Tulajdonságok (property) és események (event) használatának gyakorlása
- Az attribútumok használatának gyakorlása
- Alapvető gyűjteménytípusok használatának gyakorlása
- Lambda kifejezések gyakorlása

A szükséges fejlesztőkörnyezetről [itt](../fejlesztokornyezet/index.md) található leírás.

## Beadás menete

**TODO linkelni a közös leírást.**

## Feladat 1 – Baljós árnyak

### Feladat

Amint az közismert, a jedi lovagok erejét a sejtjeikben élő kis életformák, a midi-chlorianok adják.
Az eddigi legmagasabb midi-chlorian szintet (20.000 fölötti értéket) Anakin Skywalkernél mérték.

Készíts egy osztályt `Jedi` néven mely egy `string` típusú `Name` és egy `int` típusú `MidiChlorianCount` tulajdonsággal rendelkezik.
Utóbbi esetében figyelj rá, hogy a `MidiChlorianCount` értékét ne lehessen 35-re, vagy annál kisebb értékre állítani, ha ezzel próbálkozik valaki, az osztálynak kivételt kell dobnia.
A validáció során a lehető legegyszerűbb, legletisztultabb megoldást válaszd: a property setterben egyszerű `if`-et használj és dobj kivételt, ne legyen az `if`-nek `else` ága, valamint nincs szükség a `return` használatára sem.

### Megoldás

A feladat megoldása a [2. labor 1. feladatával](../../labor/2-nyelvi-eszkozok/index.md#1-feladat-tulajdonsag-property) analóg módon készíthető el.
A `MidiChlorianCount` tulajdonság setterében érvénytelen érték esetén dobj kivételt. Ezt például a következő utasítással tehető meg:

```csharp
throw new ArgumentException("You are not a true jedi!");
```

## Feladat 2 – A klónok támadása

### Feladat

Egészítsd ki az 1. feladatban elkészített osztályt attribútumokkal úgy, hogy amennyiben az `XmlSerializer` osztály segítségével, XML formátumú adatfájlba írunk/sorosítunk ki egy `Jedi` objektumot, a tulajdonságai egy-egy XML attribútum formájában, magyarul jelenjenek meg!
Ezt követően írjon egy függvényt, mely a `Jedi` osztály egy példányát egy szövegfájlba sorosítja, majd onnan visszaolvassa egy új objektumba (ezzel tulajdonképpen klónozva az eredeti objektumot).

!!! tip "XML sorosító attribútumai"
    Az XML sorosítást szabályozó attribútumokat ne tagváltozók, hanem a property-k felett helyezd el!

!!! danger "Fontos"
    A mentést és betöltést végző/demonstráló kódot írd egy közös, erre dedikált függvénybe, a függvényt pedig lásd el a `[Description("Feladat2")]` C# attribútummal (a függvény előtti sorba kell beírni).
    A mentett/betöltött objektum lokális változóként legyen ebben a függvényben megvalósítva.
    Az osztály/függvény neve bármi lehet (pl. kerülhet a `Program` osztályba is).
    A függvény nem szorosan a feladathoz tartozó kódot ne tartalmazzon, így más (rész)feladathoz tartozót sem.
    A függvényt hívd meg a `Program` osztály `Main` függvényéből.
    A fenti attribútum használatához using-olni kell a `System.ComponentModel` névteret.

    Lényeges, hogy

    - az attribútumot függvény, és NE osztály fölé írd,
    - az attribútumot ne a logikát megvalósító, hanem a tesztelést végző függvény fölé írd,
    - **az attribútum csak egyetlen függvény fölött szerepelhet.**



### Megoldás

A feladat megoldása a [2. labor 4. feladatával](../../labor/2-nyelvi-eszkozok/index.md#4-feladat-attributumok) analóg módon készíthető el.
A megoldáshoz az alábbi segítségeket adjuk:

- A sorosítást követően az XML fájlnak ehhez hasonlóan kell kinéznie:

    ```xml
    <?xml version="1.0"?>
    <Jedi xmlns:xsi="..." Nev="Obi-Wan" MidiChlorianSzam="15000" />
    ```

    Lényeges, hogy az egyes Jedik `Jedi` XML elemként, nevük `Nev`, a midichlorianszámuk `MidiChlorianSzam` XML attribútumként jelenjen meg.

- A sorosított objektumok visszatöltésére a labor során nem néztünk példakódot, ezért ezt itt megadjuk:

    ```csharp
    var serializer = new XmlSerializer(typeof(Jedi));
    var stream = new FileStream("jedi.txt", FileMode.Open);
    var clone = (Jedi)ser.Deserialize(stream);
    stream.Close();
    ```

    Az előző műveletsor először létrehoz egy sorosítót (`serializer`), mellyel majd a beolvasást később elvégezzük.
    A beolvasást egy `jedi.txt` nevű fájlból fogjuk végezni, amelyet a második sorban olvasásra nyitunk meg (figyeljük meg, hogy ha írni akartuk volna, akkor` FileMode.Create`-et kellett volna megadni).

## Feladat 3 – A Sith-ek bosszúja

### Feladat

A Jeditanácsban az utóbbi időben nagy a fluktuáció.
Hogy a változásokat könnyebben nyomon követhessük, készíts egy osztályt, mely képes nyilvántartani a tanács tagjait és minden változásról egy esemény formájában szöveges értesítést küldeni!
A lista manipulációját két függvénnyel lehessen végezni.
Az `Add` függvény egy új jedi lovagot regisztráljon a tanácsba, míg a `Remove` függvény távolítsa el a **legutoljára** felvett tanácstagot.
Külön értesítés jelezze, ha a tanács teljesen kiürül.

A tanácstagok (`members`) nyilvántartását egy `List<Jedi>` típusú tagváltozóban tároljuk, az `Add` függvény ehhez a listához fűzze hozzá az új elemeket, míg a `Remove` függvény generikus lista `RemoveAt` utasításával mindig a **legutoljára** felvett tagot távolítsa el (az utolsó elem indexét a lista hossza alapján tudjuk meghatározni, melyet a `Count` property ad vissza).

Az értesítés egy C# eseményen (C# event) keresztül történjen. Az eseményhez tartozó delegate típus paraméterként egy egyszerű `string`-et kapjon. Az új tag hozzáadását, az egyes tagok eltávolítását, illetve az utolsó tag eltávolítását más-más szövegű üzenet jelezze. Az esemény elsütését közvetlenül az `Add` és a `Remove` műveletekben végezd el (ne vezess be erre segédfüggvényt).

Az esemény típusának ne használj beépített delegate típust, hanem vezess be egy sajátot.

!!! danger "Fontos"
      A Jeditanács objektumot létrehozó és azt tesztelő (C# eseményére való feliratkozás, `Add` és `Remove` hívása) kód kerüljön egy közös, önálló függvénybe, ezt a függvényt pedig lásd el a `[Description("Feladat3")]` C# attribútummal.
      Az osztály/függvény neve bármi lehet.
      A függvény nem szorosan a feladathoz tartozó kódot ne tartalmazzon, így más (rész)feladathoz tartozót sem.
      A függvényt hívd meg a `Program` osztály `Main` függvényéből.

      Lényeges, hogy

      - az attribútumot függvény, és NE osztály fölé írd,
      - az attribútumot ne a logikát megvalósító, hanem a tesztelést végző függvény fölé írd,
      - az attribútum csak egyetlen függvény fölött szerepelhet.

### Megoldás

A feladat megoldása a 2. labor több részletére is épít. Az új esemény bevezetését a 2. és a 3. feladatban leírt módon tudjuk elvégezni, míg a tanács tagjait egy listában tudjuk nyilvántartani.

A fenti információk alapján próbáld meg önállóan megoldani a feladatot, majd ha készen vagy, a következő kinyitható blokkban folytasd az útmutató olvasását és vesd össze a megoldásodat a lenti referencia megoldással!
Szükség szerint korrigáld a saját megoldásod!

!!! tip "Publikus láthatóság"
    A példa épít arra, hogy a résztvevő osztályok, tulajdonságok, delegate-ek publikus láthatóságúak.
    Amennyiben fura fordítási hibával találkozol, vagy az `XmlSerializer` futásidőben hibát dob, első körben azt ellenőrizd, hogy minden érintett helyen megfelelően beállítottad-e a publikus láthatóságot.

??? example "Referencia megoldás"
    A referencia megoldás lépései a következők:

    1. Hozzunk létre egy új osztályt, `JediCouncil` néven.
    2. Vegyünk fel egy `List<Jedi>` típusú mezőt és inicializáljuk egy üres listával.
    3. Valósítsuk meg az `Add` és a `Remove` függvényeket.

        A fenti lépéseket követően az alábbi kódot kapjuk:

        ```csharp
        public class JediCouncil
        {
            List<Jedi> members = new List<Jedi>();

            public void Add(Jedi newJedi)
            {
                members.Add(newJedi);
            }

            public void Remove()
            {
                // Eltávolítja a lista utolsó elemét
                members.RemoveAt(members.Count - 1);
            }
        }
        ```

        Következő lépésként valósítsuk meg az eseménykezelést. 

    4. Definiáljunk egy új delegát típust (az osztályon kívül, mivel ez is egy típus), mely az értesítések szövegét adja majd át:

        ```csharp
        public delegate void CouncilChangedDelegate(string message);
        ```

    5. Egészítsük ki a `JediCouncil` osztályt az eseménykezelővel:

        ```csharp hl_lines="3"
        public class JediCouncil
        {
            public event CouncilChangedDelegate CouncilChanged;

            // ...
        }
        ```

    6. Süssük el az eseményt, amikor új tanácstagot veszünk fel. Ehhez az `Add` metódust kell kiegészítenünk.

        ```csharp
        public void Add(Jedi newJedi)
        {
            members.Add(newJedi);

            // TODO: Itt süsd el az eseményt.
            // Figyelj arra, hogy csak akkor tedd meg, ha van legalább egy feliratkozó/előfizető.
            // Ennek során ne a terjengősebb null ellenőrzést, hanem a modernebb, ?.Invoke-ot használd.
        }
        ```

    7. Süssük el az eseményt, amikor egy tanácstag távozik! Különböztessük meg azt az esetet, amikor a tanács teljesen kiürül. Ehhez a `Remove` metódust kell kiegészítenünk.

        ```csharp
        public void Remove()
        {
            // Eltávolítja a lista utolsó elemét
            members.RemoveAt(members.Count - 1);

            // TODO: Itt süsd el az eseményt.
            // Figyelj arra, hogy csak akkor tedd meg, ha van legalább egy feliratkozó/előfizető.
        }
        ```

    8. Megoldásunk teszteléséhez vegyünk fel egy `MessageReceived` függvényt abba az osztályba, ahol az eseményre való feliratkozást és az esemény kezelését tesztelni szeretnénk (pl. a `Program` osztályba). Ezt a függvényt fogjuk feliratkoztatni a `JediCouncil` értesítéseire.

        ```csharp title="Program.cs"
        private static void MessageReceived(string message)
        {
            Console.WriteLine(message);
        }
        ```

    9. Végezetül teszteljük az új osztályunkat egy erre a célra dedikált függvény megírásával (ez történhet pl. a `Program` osztályban), a függvény fölé tegyük oda a `[Description("Feladat3")]` attribútumot! A függvény váza:

        ```csharp
        // Tanács létrehozása
        var council = new JediCouncil();
        
        // TODO: Itt iratkozz fel a council CouncilChanged eseményére
        
        // TODO Itt adj hozzá két Jedi objektumot a council objektumhoz az Add hívásával

        council.Remove();
        council.Remove();
        ```

    10. Ha jól végeztük a dolgunkat, a program futtatását követően a következő kimenetet kell kapnunk:

        ```text
        Új taggal bővültünk
        Új taggal bővültünk
        Zavart érzek az erőben
        A tanács elesett!
        ```

!!! tip "Események null vizsgálata"
    Amennyiben a `JediCouncil.Add` műveletben `null` vizsgálattal végezted annak ellenőrzését, hogy van-e legalább egy feliratkozó az eseményre, ezt alakítsd át korszerűbb megoldásra (`?.Invoke` alkalmazása, mely tömörebb formában szintén elvégzi az ellenőrzést, de `null` vizsgálat nélkül – erről a kapcsolódó előadáson és laboron is volt szó).
    Ezt elég a `JediCouncil.Add` kapcsán megtenni, a `JediCouncil.Remove` esetében mindkét megoldás elfogadható most.

## Feladat 4 – Delegátok

### Feladat

Egészítstd ki a `JediCouncil` osztályt egy olyan paraméter nélküli függvénnyel (**a függvénynév végződjön `_Delegate`-re, ez kötelező**), mely visszatérési értékében visszaadja a Jedi tanács összes olyan tagját, melynek a midi-chlorian száma **530** alatt van!
A függvényen belül a tagok kikeresésére használd a `List<Jedi>` osztály `FindAll()` függvényét.
Ebben a feladatban még **NEM használhatsz lambda kifejezést**!
Írj egy dedikált „tesztelő” függvényt is (pl. a `Program` osztályba), mely meghívja a fenti függvényünket és kiírja a visszaadott jedi lovagok neveit! Ez a függvény nem szorosan a feladathoz tartozó kódot ne tartalmazzon, így más (rész)feladathoz tartozót sem.

!!! danger "Fontos"
    Ezt a „tesztelő” függvényt lásd el a `[Description("Feladat4")]` C# attribútummal. A függvényt hívd meg a `Program` osztály `Main` függvényéből.

    Lényeges, hogy
        
    - az attribútumot függvény, és NE osztály fölé írd,
    - az attribútumot ne a logikát megvalósító, hanem a tesztelést végző függvény fölé írd,
    - az attribútum csak egyetlen függvény fölött szerepelhet.

!!! tip "Inicializáció kiszervezése"
    A megvalósítás során vezess be egy külön statikus metódust (pl. a `Program` osztályba), mely paraméterként egy Jeditanács objektumot kap, abba legalább három felparaméterezett `Jedi` objektumot az `Add` hívásával felvesz.
    A célunk ezzel az, hogy egy olyan inicializáló metódusunk legyen, mely a későbbi feladat(ok) során is felhasználható, ne kelljen a kapcsolódó inicializáló kódot duplikálni.

### Megoldás

A feladat megoldásához a 2. labor 6. feladatát használhatjuk referenciaként. Segítségként megadjuk a következőket:

- a függvényünk akár több találatot is visszaadhat, ezért a visszatérési érték típusa `List<Jedi>`,
- a `FindAll` paraméterként az esetünkben egy `bool Függvénynév(Jedi j)` szignatúrájú szűrőfüggvényt vár el.

## Feladat 5 – Lambda kifejezések

A feladat megfelel az előzőnek, csak most lambda kifejezés segítségével fogunk dolgozni. Ez a témakör szerepelt előadáson és laboron is ([2. labor 6. feladat](../../labor/2-nyelvi-eszkozok/index.md#6-feladat-lambda-kifejezesek)).

Egészítsd ki a JediCouncil osztályt egy olyan paraméter nélküli függvénnyel (**a függvénynév végződjön `_Lambda`-ra, ez kötelező**), mely visszatérési értékében visszaadja a Jedi tanács összes olyan tagját, melynek a midi-chlorian száma 1000 alatt van!
A függvényen belül a tagok kikeresésére használd a `List<Jedi>` osztály `FindAll()` függvényét. Ebben a feladatban kötelezően lambda kifejezést kell használj (az mindegy, hogy statement vagy expression lambdát)!
Írj egy dedikált „tesztelő” függvényt is (pl. a `Program` osztályba), mely meghívja a fenti függvényünket és kiírja a visszaadott jedi lovagok neveit!
Ez a függvény nem szorosan a feladathoz tartozó kódot ne tartalmazzon, így más (rész)feladathoz tartozót sem.

!!! danger "Fontos" 
    Ezt a „tesztelő” függvényt lásd el a `[Description("Feladat5")]` C# attribútummal. A függvényt hívd meg a `Program` osztály `Main` függvényéből.

    Lényeges, hogy
        
    - az attribútumot függvény, és NE osztály fölé írd,
    - az attribútumot ne a logikát megvalósító, hanem a tesztelést végző függvény fölé írd,
    - az attribútum csak egyetlen függvény fölött szerepelhet.

## Feladat 6 (iMSc) – beépített `Func`/`Action` generikus delegate típusok használata

A feladat megoldása nem kötelező, de erősen ajánlott: alapanyag, így ZH-n/vizsgán szerepelhet. Laboron nem volt, csak előadáson.

**A megoldásért +2 IMSc pont is jár.**

### Feladat

Bővítsd ki a `JediCouncil` osztályt.

- Készíts egy `Count` nevű `int` visszatérési értékű property-t (tulajdonságot), amely minden lekérdezéskor a tanácsban aktuálisan található Jedi-k számát adja vissza. Ügyelj arra, hogy ezt az értéket csak lekérdezni lehessen (beállítani nem).

    !!! tip "Tipp"
        A `JediCouncil`-ban található members nevű tagváltozónak van egy `Count` nevű property-je, a megoldás építsen erre.

- Készíts egy `CountIf` nevű függvényt, amely szintén a tanácstagok megszámlálására való, de csak bizonyos feltételnek eleget tevő tanácstagokat vesz figyelembe. A függvény visszatérési értéke `int`, és a feltételt, amelynek megfelelő tanácstagok számát visszaadja, egy delegate segítségével kap meg paraméterként (tehát a `CountIf`-nek kell legyen paramétere).

    !!! warning "Delegate típusa"
        A delegate típusa kötelezően a beépített generikus `Action` / `Func` delegate típusok közül a megfelelő kell legyen (vagyis saját delegate típus, ill. a beépített `Predicate` típus nem használható).

        Emiatt a listán NEM használhatod a beépített `FindAll` műveletét, mivel az általunk használt delegate típus nem lenne kompatibilis a `FindAll` által várt paraméterrel. A tagokon egy `foreach` ciklusban végigiterálva dolgozz!

- A property és a függvény működését demonstráld egy erre dedikált közös függvényben, amit láss el a `[Description("Feladat6")]` attribútummal. Ez a függvény nem szorosan a feladathoz tartozó kódot ne tartalmazzon, viszont a Jeditanács feltöltéséhez az előző feladatban bevezetett segédfüggvényt hívd. A függvényt hívd meg a `Program` osztály `Main` függvényéből. 

    !!! danger "Fontos"
        A `[Description("Feladat6")]` attribútum csak egyetlen függvény fölött szerepelhet.

### Megoldás

- A `Count` nevű property esetében csak a `get` ágnak van értelme, ezért a `set` ágat meg se írjuk. Ez egy csak olvasható tulajdonság legyen.
- A `CountIf` függvény megírásában a 4-es feladat nyújt segítséget. A különbség, hogy a `CountIf` nem a tanácstagokat, csak a darabszámot adja vissza.
    - A `CountIf` függvény a feltételt paraméterként egy `bool Függvénynév(Jedi jedi)` szignatúrájú szűrőfüggvényt várjon.

## Beadás

Ellenőrzőlista ismétlésképpen:

--8<-- "docs/hazi/beadas-ellenorzes/index.md:3"