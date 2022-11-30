# 2. Nyelvi eszközök

Utolsó módosítás ideje: 2022.10.31  
Kidolgozta: Kővári Bence, Benedek Zoltán

## A gyakorlat célja

A gyakorlat célja az alábbi C# nyelvi elemek megismerése:

- Tulajdonság (property)
- Delegát (delegate, metódusreferencia)
- Esemény (event)
- Attribútum (attribute)
- Lambda kifejezés
- Generikus típus (generic type)

Kapcsolódó előadások: a 2. előadás és a 3. előadás eleje – (Modern) programozási eszközök.

## Előfeltételek

A gyakorlat elvégzéséhez szükséges eszközök:

- Visual Studio 2022

!!! tip "Gyakorlat Linuxon vagy Macen"
    A gyakorlat anyag alapvetően Windowsra és Visual Studiora készült, de az elvégezhető más operációs rendszereken is egy szövegszerkesztővel (pl.: VSCode) és CLI eszközökkel, mivel a .NET 6 SDK támogatott Linuxon és Macen. [Hello World linuxon](https://learn.microsoft.com/en-us/dotnet/core/tutorials/with-visual-studio-code?pivots=dotnet-6-0)

## Bevezető

A gyakorlat során a hallgatók megismerkednek a legfontosabb modern, a .NET környezetben is rendelkezésre álló nyelvi eszközökkel. Feltételezzük, hogy a hallgató a korábbi tanulmányai során elsajátította az objektum-orientált szemléletmódot, és tisztában van az objektum-orientált alapfogalmakkal. Jelen gyakorlat során azokra a .NET-es nyelvi elemekre koncentrálunk, amelyek túlmutatnak az általános objektum-orientált szemléleten, ugyanakkor nagyban hozzájárulnak a jól átlátható és könnyen karbantartható kód elkészítéséhez. Ezek a következők:

- Tulajdonságok (properties)
- Delegátok (delegates)
- Események (events)
- Attribútumok (attributes)
- Generikus osztályok (generics)
- Lambda kifejezések

## 1. Feladat – Tulajdonság (property)

A tulajdonságok segítségével tipikusan (de nem kizárólagosan) osztályok tagváltozóihoz férhetünk hozzá szintaktikailag hasonló módon, mintha egy hagyományos tagváltozót érnénk el. A hozzáférés során azonban lehetőségünk van arra,  hogy az egyszerű érték lekérdezés vagy beállítás helyett metódusszerűen implementáljuk a változó elérésének a módját, sőt külön külön is meghatározhatjuk a lekérdezés és a beállítás láthatóságát.

### Tulajdonság szintaktikája

A következő példában egy `Person` nevű osztályt fogunk elkészíteni, mely egy embert reprezentál. Két tagváltozója van, `name` és `age`. A tagváltozókhoz közvetlenül nem férhetünk hozzá (mivel privátok), csak a `Name`, illetve `Age` publikus tulajdonságokon keresztül kezelhetjük őket. A példa jól szemlélteti, hogy a .NET-es tulajdonságok egyértelműen megfelelnek a C++-ból és Java-ból már jól ismert `SetX(…)` illetve `GetX()` típusú metódusoknak, csak itt ez a megoldás egységbezártabb módon nyelvi szinten támogatott.

1. Hozzunk létre egy új C# konzolos alkalmazást. .NET alapút (vagyis **ne** .NET Framework-öset):
    - Erre az első gyakorlat alkalmával láttunk példát, leírása annak útmutatójában szerepel.
    - A "*Do not use top level statements*" jelölőnégyzetet pipáljuk be a projekt létrehozás során.
2. Adjunk hozzá egy új osztályt az alkalmazásunkhoz `Person` néven.
    (Új osztály hozzáadásához a Solution Explorerben kattintsunk jobb egérgombbal a projekt fájlra és válasszuk az *Add / Class* menüpontot. Az előugró ablakban a létrehozandó fájl nevét módosítsuk `Person.cs`-re, majd nyomjuk meg az Add gombot.)
3. Tegyük az osztályt publikussá. Ehhez az osztály neve elé be kell írni a `public` kulcsszót. Erre a módosításra itt valójában még nem volna szükség, ugyanakkor a 4. feladat már egy publikus osztályt fog igényelni.
4. Hozzunk létre az osztályon belül egy `int` típusú `age` nevű mezőt és egy ezt elérhetővé tevő `Age` tulajdonságot.

    ```cs
    public class Person
    {
        private int age;
        public int Age
        {
            get { return age; }
            set { age = value; }
        }
    }
    ```

    !!! tip "Visual Studio snippetek"
        A laboron ugyan a gyakorlás kedvéért kézzel gépeltük be a teljes tulajdonságot, de a Visual Studio-ban a gyakran előforduló kódrészletekre úgynevezett snippetek állnak rendelkezésünkre, amivel a gyakri fordulatokat tudjuk sablon szerűen felhasználni. A felti property kódrészletet a `propfull` snippettel tudjuk előcsalni. Gépeljük be a snippet nevét (`propfull`), majd addig nyomjuk a TAB billentyűt amíg el nem sül a snippet (tipikusan 2x).

        Említésre méltó egyéb snippetek a teljesség igénye nélkül:

        - `ctor`: konstruktor
        - `for`: for ciklus
        - `foreach`: foreach ciklus
        - `prop`: auto property (lásd később)
        - `switch`: switch utasítás
        - `cw`: Console.WriteLine

        Ilyen snippeteket egyébként mi is [készíthetünk](https://learn.microsoft.com/en-us/visualstudio/ide/walkthrough-creating-a-code-snippet?view=vs-2022).

5. Egészítsük ki a `Program.cs` fájl `Main` függvényét, hogy kipróbálhassuk az új osztályunkat.

    ```cs
    static void Main(string[] args)
    {
        var p = new Person();
        p.Age = 17;
        p.Age++;
        Console.WriteLine(p.Age);
    }
    ```

    !!! tip "Implicit Type (`var`) és Target-typed `new` expressions"
        A változók deklarálása során kiírhatjuk a típust is, de használhatjuk a `var` kulcsszót és az implicit típus mechanizmust. Ilyenkor a fordító a kontextusból, az egyenlőségjel jobb oldalából megpróbálja kitalálni a változó típusát, fenti esetben ez egy `Person` lesz. Fontos, hogy ettől a nyelv még statikusan tipusos marad (tehát **nem** úgy működik mint a JavaScript-es `var` kulcsszó), mert a `p` változó típusa a későbbiekben nem változhat meg, ez csak egy szintaktikai édesítőszer.

        Egy másik megközelítés lehet a a C# 9-ben megjelent Target-typed `new` expressions, ahol a new operátor esetén hagyható el a típus, ha az a fordító által kitalálható a kontektusból (pl.: értékadás bal oldala, paraméter típusa, stb.). A fenti Person konstruktorunk a következőképpen nézne ki:

        ```cs
        Person p = new();
        ```

        Fontos, hogy ezt ne keverjük össze a C# anoním típusaival (`new {}`, kerekzárójel nélkül), amit ez a tantárgy nem fog érinteni.

6. Futtassuk a programunkat (F5)

    Láthatjuk, hogy a tulajdonság a tagváltozókhoz hasonlóan használható. A tulajdonság lekérdezése esetén a tulajdonságban definiált **`get`** rész fog lefutni, és a tulajdonság értéke a return által visszaadott érték lesz. A tulajdonság beállítása esetén a tulajdonságban definiált **`set`** rész fog lefutni, és a speciális `value` változó értéke ebben a szakaszban megfelel a tulajdonságnak értékül adott kifejezéssel.

    Figyeljük meg a fenti megoldásban azt, hogy milyen elegánsan tudjuk egy évvel megemelni az ember életkorát. Java, vagy C++ kódban egy hasonló műveletet a `p.setAge(p.getAge() + 1)` formában írhattunk volna le, amely jelentősen körülményesebb és nehezen olvashatóbb szintaktika a fentinél. A tulajdonságok használatának legfőbb hozadéka, hogy kódunk szintaktikailag tisztább lesz, az értékadások illetve lekérdezések pedig az esetek többségében jól elválnak a tényleges függvényhívásoktól.

7. Győződjünk meg róla, hogy a programunk valóban elvégzi a `get` és `set` részek hívását. Ehhez helyezzünk töréspontokat (breakpoint) a getter és setter blokkok belsejébe a kódszerkesztő bal szélén látható szürke sávra kattintva.
8. Futtassuk a programot lépésről lépésre. Ehhez a programot F5 helyett az F11 billentyűvel indítsuk, majd az F11 további megnyomásaival engedjük sorról sorra a végrehajtást.

    Láthatjuk, hogy a programunk valóban minden egyes alkalommal meghívja a gettert, amikor értéklekérdezés, illetve a settert, amikor értékbeállítás történik.

9. A setter függvények egyik fontos funkciója, hogy lehetőséget kínálnak az értékvalidációra. Egészítsük ki ennek szellemében az `Age` tulajdonság setter-ét.

    ```cs
    public int Age
    {
        get { return age; }
        set 
        {
            if (value < 0)
                throw new ArgumentException("Érvénytelen életkor!");
            age = value; 
        }
    }
    ```

    Figyeljük meg, hogy míg az egyszerű getter és setter esetében az értéklekérdezést/beállítást egy sorban tartjuk, addig komplexebb törzs esetén már több sorra tördeljük.

10. Az alkalmazás teszteléséhez rendeljünk hozzá negatív értéket az életkorhoz a `Program` osztály `Main` függvényében.

    ```cs
    p.Age = -2;
    ```

11.	Futtassuk a programot, győződjünk meg arról, hogy az ellenőrzés helyesen működik, majd a további munka kedvéért hárítsuk el a hibát azzal, hogy pozitívra cseréljük a beállított életkort.

    ```cs
    p.Age = 2;
    ```

### Autoimplementált tulajdonság

1. A mindennapi munkánk során találkozhatunk a tulajdonságoknak egy sokkal tömörebb szintaktikájával is. Ez a szintaktika akkor alkalmazható, ha egy olyan tulajdonságot szeretnénk létrehozni, melyben:

    - nincs szükségünk a privát tagváltozó közvetlen elérésére
    - nem szeretnénk semmilyen kiegészítő logikával ellátni a getter és setter metódusokat

    Erre nézzünk a következőkben példát. Egészítsük ki a `Person` osztályunkat egy ilyen, ún. **„autoimplementált” tulajdonsággal (auto-implemented property)**. Készítsünk egy `string` típusú `Name` tulajdonságot.

    ```cs
    public string Name { get; set; }
    ```

    Autoimplemetált tulajdonság esetén a fordító egy rejtett, kódból nem elérhető változót generál az osztályba, mely a tulajdonság aktuális értékének tárolására szolgál.

2. Most ellenőrizzük a működését a `Main` függvény kiegészítésével.

    ```cs hl_lines="4 6"
    static void Main(string[] args)
    {
        // ...
        p.Name = "Luke";
        // ...
        Console.WriteLine(p.Name);
    }
    ```

3. A tulajdonságok nagy előnye a teljesen szabad implementáció mellett, hogy a getter és a setter láthatóságát külön külön is lehet állítani. Állítsuk a `Name` tulajdonság setterének a láthatóságát privátra.

    ```cs
    public string Name { get; private set; }
    ```

    Ilyenkor a `Program` osztékyban fordítási hibát kapunk a `p.Name = "Luke";` utasításra. Az alapvető szabály az, hogy a getter és a setter örökli a property láthatóságát, ami tovább szűkíthető, de nem lazítható.

4. Állítsuk vissza a láthatóságot, hogy megjavuljon a fordítási hiba:

    ```cs
    public string Name { get; set; }
    ```

### Kitekintés: Egyéb propertyhez kapcsolódó nyelvi elemek

Ha jól állunk az idővel, akkor tekintsük át az alábbi propertyhez kapcsolódó szintaktikai édesítőszereket.

1. **Default érték:** A tulajdonságok esetében megadható a kezdeti értékük is a deklaráció során. Adjunk kiinduló értéket a `Name` tulajdonságnak.

    ```cs
    public string Name { get; set; } = "anonymous";
    ```

2. **Readonly property:** A setter elhagyható, így egy olyan readonly tulajdonságot kapunk, amit csak konstruktorban vagy az előző pont alapján default értékkel tudunk beállítani. Ellentétben a privát szetterrel rendelkező tulajdonságokkal, amiknek a settere bármely az osztályban található függvényből hívható.

    ```cs
    public string Name { get; }
    ```

3. **Getter only property:** Készíthető getter only tulajdonság is, ami mindig kiszámol egy megadott logika alapján egy értéket, de nincs settere és nincs mögötte közvetlen tároló.

    ```cs
    public int AgeInDogYear { get { return Age * 7; } }
    ```

    Ez nem összekeverendő az előző pontban lévő Csak getterrel rendelkező readonly propertyvel, ami mögött van mező.

4. **Expression body:** A getter vagy setter csak egy sorból állna, akár rendelkezik vagy sem visszatérési értékkel a kifejezés, megadható úgynevezett expression body szintaktikával is, a `=>` operátorral

    ```cs
    public int AgeInDogYear { get => Age * 7; }
    ```

    Sőt, ha csak getterje lenne a tulajdonságnak, a `get` kulcsszót és a kapcsos zárójeleket is lehagyhatjuk.

    ```cs
    public int AgeInDogYear => Age * 7;
    ```

    Ez nem összekeverendő a függvények hasonló expression body szintaktikájával, ahol kötelező a kerek zárójeleket kitenni. Tehát az alábbi egy függvény, a fentebbi pedig egy getter only property.

    ```cs
    public int AgeInDogYear() => Age * 7;
    ```

5. **Object initializer**: A tulajdonságok setter hívása és a konstruktor hívás kombinálható egy úgynevezett object initializez szintaxis segítségével. Elég csak a konstruktor után kapcsos zárójelekkel blokkot nyissunk, ahol a propertyk értéke adható meg, az alábbi szintaktikával.

    ```cs
    var p = new Person()
    {
        Age = 17,
        Name = "Luke",
    };
    ```
  
    Ez a szintaktika azért is előnyös, mert egy kifejezésnek számít a példában szereplő három helyett, így akár közvetlenül függvényhívás paramétereként átadható egy objektum, anélkül, hogy változót kellene deklarálni.

    ```cs
    void Foo(Person p)
    {
        // do something with p
    }
    ```

    ```cs
    Foo(new Person() { Age = 17, Name = "Luke" });
    ```

    A szintaxis ráadásul copy-paste barát, mert a fenti példában is látszik, hogy nem számít, hogy az utolsó property után van-e vessző vagy nincs.

6. **Init only setter**: Az előző pontban lévő object initializer szintaxis nagyon kényelmes viszont azt követeli meg a tulajdonságtól, hogy publikus legyen. Ha azt akarjuk, hogy egy tulajdonság értéke csak konstruktor időben változhasson meg, ahol konstruktor paramétert kell bevezessünk, és egy readonly propertybe kell azt értékül adjuk. Erre a problémára ad megoldást az *Init only setter* szintaxis, ahol olyan settert tudunk készíteni az `init` kulcsszóval, ami csak konstruktor időben és az objektum inicializáló szintaxis során engedélyezett.

    ```cs
    public string Name { get; init; }
    ```

    ```cs
    var p = new Person()
    {
        Age = 17,
        Name = "Luke",
    };

    p.Name = "Test"; // build error
    ```

!!! danger "Forduljon a kód!"
    A további feladatok építeni fognak az előző feladatok végeredményeire. Ha programod nem fordul le, vagy nem megfelelően működik, jelezd ezt a gyakorlatvezetődnek a feladatok végén, és segít elhárítani a hibát.

## 2. Feladat – Delegát (delegate, metódusreferencia)

A delegátok típusos metódusreferenciákat jelentenek .NET-ben, a C/C++ függvénypointerek modern megfelelői. Egy delegát definiálásával egy olyan változót definiálunk, amellyel rámutathatunk egy olyan metódusra, amely típusa (paraméterlistája és visszatérési értéke) megfelel a delegát típusának. A delegát meghívásával az értékül adott (beregisztrált) metódus automatikusan meghívódik. A delegátok használatának egyik előnye az, hogy futási időben dönthetjük el, hogy több metódus közül éppen melyiket szeretnénk meghívni.

Néhány példa delegátok használatára:

- egy univerzális sorrendező függvénynek  paraméterként az elemek összehasonlítását végző függvény átadása,
- egy általános gyűjteményen univerzális szűrési logika megvalósítása, melynek paraméterben egy delegát formájában adjuk át azt a függvényt, amely eldönti, hogy egy elemet bele kell-e venni a szűrt listába,
- a publish-subscribe minta megvalósítása, amikor bizonyos objektumok más objektumokat értesítenek bizonyos magukkal kapcsolatos események bekövetkezéséről.

A következő példánkban lehetővé tesszük, hogy a korábban létrehozott `Person` osztály objektumai szabadon értesíthessék más osztályok objektumait arról, ha egy személy életkora megváltozott. Ennek érdekében bevezetünk egy delegát típust (`AgeChangingDelegate`), mely paraméterlistájában át tudja adni az emberünk életkorának aktuális, illetve új értékét. Ezt követően létrehozunk egy publikus `AgeChangingDelegate` típusú mezőt a `Person` osztályban, mely lehetővé teszi, hogy egy külső fél megadhassa azt a függvényt, amelyen keresztül az adott `Person` példány változásairól értesítést kér.

1. Hozzunk létre egy új **delegát típust**, mely `void` visszatérési értékű, és két darab `int` paramétert elváró függvényre tud hivatkozni. Figyeljünk rá, hogy az új típust a `Person` osztály előtt, közvetlenül a névtér scope-jában definiáljuk!

    ```cs
    namespace PropertyDemo
    {
        public delegate void AgeChangingDelegate(int oldAge, int newAge);

        public class Person
        {
            // ...
    ```

    Az `AgeChangingDelegate` egy típus (fogyeljük a VS színezését is), mely bárhol szerepelhet, ahol típus állhat (pl. lehet létrehozni ez alapján tagváltozót, lokális változót, függvény paramétert stb.).

2. Tegyük lehetővé, hogy a `Person` objektumai rámutathassanak tetszőleges, a fenti szignatúrának megfelelő függvényre. Ehhez hozzunk létre egy `AgeChangingDelegate` típusú mezőt a `Person` osztályban!

    ```cs
    public class Person
    {
        public AgeChangingDelegate AgeChanging;
    ```

    !!! warning "Ez így most OO?"
        A publikus mezőként létrehozott metódusreferencia valójában (egyelőre) sérti az OO elveket. Erre később visszatérünk még.

3. Hívjuk meg a függvényt minden alkalommal, amikor az emberünk kora megváltozik. Ehhez egészítsük ki az `Age` tulajdonság setterét a következőkkel.

    ```cs hl_lines="8-9"
    public int Age
    {
        get { return age; }
        set 
        {
            if (value < 0)
                throw new ArgumentException("Érvénytelen életkor!");
            if (AgeChanging != null)
                AgeChanging(age, value);
            age = value; 
        }
    }
    ```

    A  fenti kódrészlet számos fontos szabályt demonstrál:

    - A validációs logika általában megelőzi az értesítési logikát.
    - Az értesítési logika jellegétől függ, hogy az értékadás előtt, vagy után futtatjuk le (ebben az esetben, mivel a „changing” szó egy folyamatban lévő dologra utal, az értesítés megelőzi az értékadást, a bekövetkezést múlt idő jelezni: "changed")
    - Fel kell készülnünk rá, hogy a delegate típusú mezőnkhöz még senki nem rendelt értéket (nincs egy subscriber/előfizető sem). Ilyen esetekben a meghívásuk kivételt okozna, ezért meghívás előtt mindig ellenőrizni kell, hogy a mező értéke `null`-e.
    - Az esemény elsütésekor a `null` vizsgálatot és az esemény elsütést elegánsabb, tömörebb, és szálbiztosabb formában is meg tudjuk tenni a „`?.`” null-conditional operátorral (C# 6-tól):

    ```cs
    if (AgeChanging != null)
        AgeChanging(age, value);
    ```

    helyett

    ```cs
    AgeChanging?.Invoke(age, value);
    ```

    Ez csak akkor süti el az eseményt, ha nem `null`, egyébként semmit nem csinál.

   - Ha szigorúan nézzük, akkor csak akkor kellene elsütni az eseményt, ha a kor valóban változik is, vagyis a property set ágában meg kellene vizsgálni, az új érték egyezik-e a régivel. Megoldás lehet, ha a setter első sorában azonnal visszatérünk, ha az új érték egyezik a régivel:

    ```cs
    if (age == value) 
        return;
    …
    ```

4. Kész vagyunk a `Person` osztály kódjával. Térjünk át az előfizetőre! Ehhez mindenek előtt a `Program` osztályt kell kiegészítenünk egy újabb függvénnyel.

    ```cs
    class Program
    {
        // ...

        private static void PersonAgeChanging(int oldAge, int newAge)
        {
            Console.WriteLine(oldAge + " => " + newAge);
        }
    }
    ```

    !!! warning "Tip"
        Fokozottan ügyeljünk rá, hogy az új függvény a megfelelő scope-ba kerüljön! Míg a delegate típust az osztályon kívülre (de namespace-en belülre) helyeztük el, a függvényt az osztályon belülre helyezzük!

5. Végezetül iratkozzunk fel a változáskövetésre a `Main` függvényben!

    ```cs
    static void Main(string[] args)
    {
      Person p = new Person();
      p.AgeChanging = new AgeChangingDelegate(PersonAgeChanging);
      // ...
    ```

6. Futtassuk a programot!

    Figyeljük meg, hogy az esemény minden egyes setter futáskor, így az első értékadáskor és az inkrementáláskor egyaránt lefut. A megoldásunk azonban még fejleszthető.

7. Egészítsük ki a Main függvényt többszöri feliratkozással, majd futtassuk a programot.

    ```cs
    p.AgeChanging = new AgeChangingDelegate(PersonAgeChanging);
    p.AgeChanging += new AgeChangingDelegate(PersonAgeChanging);
    p.AgeChanging += PersonAgeChanging; // Tömörebb szintaktika
    ```

    Láthatóan minden egyes értékváltozáskor mind a három beregisztrált/„feliratkozott” függvény lefut. Ez azért lehetséges, mert a delegate típusú mezők valójában nem csupán egy függvény-referenciát, hanem egy **függvény-referencia listát** tartalmaznak (és tartanak karban).

    Figyeljük meg a fenti harmadik sorban, hogy a függvényreferenciákat az először látottnál tömörebb szintaxissal is leírhatjuk: csak a függvény nevét adjuk meg a `+=` operátor után, a `new AgeChangingDelegate(...)` nélkül. Ettől függetlenül ekkor is egy `AgeChangingDelegate` objektum fogja becsomagolni a `PersonAgeChanging` függvényeket a színfalak mögött.

8. Próbáljuk ki a leiratkozást is (szabadon választott ponton), majd futtassuk a programot.

    ```cs
    p.AgeChanging -= PersonAgeChanging;
    ```

## 3. Feladat – Esemény (event)

Ahogyan a tulajdonságok a getter és setter metódusoknak, addig a fent látott delegate mechanizmus a Java-ból ismert Event Listener-eknek kínálják egy a szintaktika tekintetében letisztultabb alternatíváját. A fenti megoldásunk azonban egyelőre még súlyosan sért pár OO elvet (egységbezárás, információrejtés). Ezt az alábbi két példával tudjuk demonstrálni.

1. Az eseményt valójában kívülről (más osztályok műveletiből) is ki tudjuk váltani. Ez szerencsétlen, hisz így az eseményre feliratkozott függvényeken keresztül az osztály nevében hamis adatokat közölhetünk. Ennek demonstrálására szúrjuk be a következő sort a `Main` függvény végére.

    ```cs
    p.AgeChanging(67, 12);
    ```

    Itt a `p` személy objektum vonatkozásában egy "kamu" életkorváltozás eseményt váltottunk ki a `Person` objektumból, becsapva minden előfizetőt. A jó megoldás az lenne, ha az eseményt csak a `Person` osztály műveletei tudnák kiváltani.

2. Bár a `+=` és a `-=` tekintettel vannak a listába feliratkozott többi függvényre, valójában az `=` operátorral bármikor felülírhatjuk (kitörölhetjük) mások feliratkozásait. Próbáljuk ki ezt is, a következő sor beszúrásával (közvetlenül a fel és leiratkozások után szúrjuk be).

    ```cs
    p.AgeChanging = null;
    ```

3. Lássuk el az `event` kulcsszóval az `AgeChanging` mezőt `Person.cs`-ben!

    ```cs title="Person.cs"
    public event AgeChangingDelegate AgeChanging;
    ```

    Az `event` kulcsszó feladata valójában az, hogy a fenti két jelenséget megtiltva visszakényszerítse programunkat az objektumorientált mederbe.

4. Próbáljuk meg lefordítani a programot. Látni fogjuk, hogy a fordító a korábbi kihágásainkat most már fordítási hibaként kezeli.

    ![event errors](images/event-errors.png)

5. Távolítsuk el a három hibás kódsort (figyeljük meg, hogy már az első közvetlen értékadás is hibának minősül), majd fordítsuk le és futtassuk az alkalmazásunkat!

## 4. Feladat – Attribútumok

**Az attribútumok segítségével deklaratív módon metaadatokkal láthatjuk el forráskódunkat**. Az attribútum is tulajdonképpen egy osztály, melyet hozzákötünk a program egy megadott eleméhez (típushoz, osztályhoz, interfészhez, metódushoz, stb.). Ezeket a metainformációkat a program futása közben bárki (akár mi magunk is) kiolvashatja az úgynevezett reflection mechanizmus segítségével. Az attribútumok a Java annotációk .NET-beli megfelelőinek is tekinthetők.

!!! note "property vs. attribútum vs. static"
    Felmerül a kérdés, hogy milyen attribútumok kerüljenek tulajdonságokba és melyek attribútumokra egy osztály esetében. A tulajdonságok magára az objektum példányra vonatkoznak, míg az attribútum az azt leíró osztályra (vagy annak valamilyen tagjára).

    Ilyen szempontból az attribútumok közelebb állnak a statikus tulajdonságokhoz, mégis megfontolandó, hogy egy adott adatot statikus tagként vagy attribútumként definiálnánk. Attribútummal sokkal deklaratívabb a leírás, és nem szennyezzük olyan részletekkel a kódot, aminek nem kellene az osztály publikus interfészén megjelennie.

A NET számos **beépített** attribútumot definiál, melyek funkciója a legkülönbözőbb féle lehet. A következő példában használt attribútumok például az XML sorosítóval közölnek különböző metainformációkat.

1. Szúrjuk be a `Main` függvény végére a következő kódrészletet, majd futtassuk a programunkat!

    ```cs
    var serializer = new XmlSerializer(typeof(Person));
    var stream = new FileStream("person.txt", FileMode.Create);
    serializer.Serialize(stream, p);
    stream.Close();
    Process.Start(new ProcessStartInfo
    {
        FileName = "person.txt",
        UseShellExecute = true,
    });
    ```

    A fenti példából az utolsó `Process.Start` függvényhívás nem a sorosító logika része, csupán egy frappáns megoldás arra, hogy a Windows alapértelmezett szövegfájl nézegetőjével megnyissuk a keletkezett adatállományt. Ezt kipróbálhatjuk, de a használt .NET runtime-tól és az operációs rendszerünktől függ, támogatott-e. Ha nem, futás közben hibát kapunk. Ez esetben hagyjuk kikommentezve, és a `person.txt` fájlt a fájlrendszerben megkeresve kézzel nyissuk meg (a Visual Studio mappánkban a *\bin\Debug\<valami>\* alatt található az .exe alkalmazásunk mellett.

2. Nézzük meg a keletkezett fájl szerkezetét. Figyeljük meg, hogy minden tulajdonság a nevének megfelelő XML elemre lett leképezve.

3. .NET attribútumok segítségével olyan metaadatokkal láthatjuk el a `Person` osztályunkat, melyek közvetlenül módosítják a sorosító viselkedését. Az `XmlRoot` attribútum lehetőséget kínál a gyökérelem átnevezésére. Helyezzük el a `Person` osztály fölé!

    ```cs
    [XmlRoot("Személy")]
    public class Person 
    {
        // ...
    }
    ```

4. Az `XmlAttribute` attribútum jelzi a sorosító számára, hogy a jelölt tulajdonságot ne xml elemre, hanem xml attribútumra képezze le. Lássuk el ezzel az `Age` tulajdonságot (és ne a mezőt!)!

    ```cs
    [XmlAttribute("Kor")]
    public int Age
    ```

5. Az `XmlIgnore` attribútum jelzi a sorosítónak, hogy a jelölt tulajdonság teljesen elhagyandó az eredményből. Próbáljuk ki a `Name` tulajdonság fölött.

    ```cs
    [XmlIgnore]
    public string Name { get; set; }
    ```

6. Futtassuk az alkalmazásunkat! Hasonlítsuk össze az eredményt a korábbiakkal.

## 5. Feladat – Delegát 2.

A 2. és 3. feladatokban a delegátokkal esemény alapú üzenetküldést valósítottunk meg. **A delegátok használatának másik tipikus esetében a függvényreferenciákat arra használjuk, hogy egy algoritmus vagy összetettebb művelet számára egy előre nem definiált lépés implementációját átadjuk**.

A generikus lista osztály (`List<T>`) `FindAll` függvénye például képes arra, hogy visszaadjon egy új listában minden olyan elemet, mely egy adott feltételnek eleget tesz. A konkrét szűrési feltételt egy függvény formájában adhatjuk meg paraméterben (melyet a `FindAll` minden elemre meghív), mely igazat ad minden olyan elemre, amit az eredménylistában szeretnénk látni.

Figyeljük meg (F12-vel belelépve), hogy a függvény paraméterének a típusa a következő előre definiált delegate típus (**nem kell létrehozni**):

```cs
public delegate bool Predicate<T>(T obj)
```

Vagyis bemenetként egy olyan típusú változót vár, mint a listaelemek típusa, kimenetként pedig egy logikai értéket. A fentiek demonstrálására kiegészítjük a korábbi programunkat egy szűréssel, mely a listából csak a páratlan elemeket fogja megtartani.

1. Valósítsunk meg egy olyan szűrőfüggvényt az alkalmazásunkban, amely a páratlan számokat adja vissza:

    ```cs
    private static bool MyFilter(int n)
    {
        return n % 2 == 1;
    }
    ```

2. Egészítsük ki a korábban írt kódunkat a szűrő függvényünk használatával:

    ```cs hl_lines="5"
    var list = new List<int>();
    list.Add(1);
    list.Add(2);
    list.Add(3);
    list = list.FindAll(MyFilter);

    foreach (int n in list)
    {
        Console.WriteLine($"Value: {n}");
    }
    ```

3. Futtassuk az alkalmazásunkat. Figyeljük meg, hogy a konzolon valóban csak a páratlan számok jelennek meg.
4. Érdekességként elhelyezhetünk egy töréspontot (breakpoint) a `MyFilter` függvényünk belsejében és megfigyelhetjük, hogy a függvény valóban minden egyes listaelemre külön-külön meghívódik.

!!! tip "Collection initializer szintaxis"
    Az object initializer szintaxis mellett elérhető minden `Add` metódussal rendelkező osztályra (tipikusan kollekciók) a collection initializer szintaxis az alábbi módon:

    ```cs
    var list = new List<int>()
    {
        1,
        2,
        3,
    };
    ```

## 6. Feladat – Lambda kifejezések

Az érintett témakörök az előadásanyagban részletesen szerepelnek, itt nem ismételjük meg őket Lásd „Előadás 02 - Modern nyelvi eszközök.pdf” dokumentum „Lambda expression (lambda kifejezés)” fejezete. A kulcselem a `=>` (lambda operátor) segítségével **lambda kifejezések**, vagyis névtelen függvények definiálása.

!!! note "`Action<T>`"
      A .NET beépített `Func` és `Action` generikus delegate típusokra itt idő hiányáéban nem térünk ki.

Az előző, 5. feladatot oldjuk meg a következőképpen: ne adjunk meg külön szűrőfüggvényt, hanem a szűrési logikát egy lambda kifejezés formájában adjuk meg a `FindAll` műveletnek.

Ehhez mindössze egy sort kell megváltoztatni:

```cs
list = list.FindAll((int n) => { return n % 2 == 1; });
```

Egy név nélküli függvényt definiáltunk és adtunk át a `FindAll` műveletnek:

- Ez egy lambda kifejezés
- A `=>` bal oldalán megadtuk a művelet paramétereket (itt csak egy volt)
- A `=>` jobb oldalán a művelet törzsét (ugyanaz, mint a korábbi `MyFilter` törzse)

A fenti sort jóval egyszerűbb és áttekinthetőbb formába is írhatjuk:

```cs
list = list.FindAll(n => n % 2 == 1);
```

A következő egyszerűsítéseket eszközöltük:

- A paraméter típusát nem írtuk ki (a fordító ki tudja következtetni a `FindAll` delegate paraméter típusából)
- A paraméter körüli zárójelet elhagyhattuk (mert csak egy paraméter van)
- A `=>` jobb oldalán elhagyhattuk a {} zárójeleket és a `return`-t (mert egyetlen kifejezésből állt a függvény törzse, mellyel a függvény visszatér)

## 7. Feladat – Generikus osztályok

Megjegyzés: erre a feladatra jó eséllyel nem marad idő. Ez esetben célszerű a feladatot gyakorlásképpen otthon elvégezni.

A .NET generikus osztályai hasonlítanak C++ nyelv template osztályaihoz, de közelebb állnak a Java-ban már megismert generikus osztályokhoz. A segítségükkel általános (több típusra is működő), de ugyanakkor típusbiztos osztályokat hozhatunk létre. Generikus osztályok nélkül, ha általánosan szeretnénk kezelni egy problémát, akkor `object` típusú adatokat használunk (mert .NET-ben minden osztály az `object` osztályból származik). Ez a helyzet például az `ArrayList`-tel is, ami egy általános célú gyűjtemény, tetszőleges, `object` típusú elemek tárolására alkalmas. Lássunk egy példát az `ArrayList` használatára:

```cs
var list = new ArrayList();
list.Add(1);
list.Add(2);
list.Add(3);
for (int n = 0; n < list.Count; n++)
{
    // Castolni kell, különben nem fordul
    int i = (int)list[n];
    Console.WriteLine($"Value: {i}");
}
```

A fenti megoldással a következő problémák adódnak:

- Az `ArrayList` minden egyes elemet `object`-ként tárol.
- Amikor hozzá szeretnénk férni a lista egy eleméhez, mindig a megfelelő típusúvá kell cast-olni.
- Nem típusbiztos. A fenti példában semmi nem akadályoz meg abban (és semmilyen hibaüzenet sem jelzi), hogy az `int` típusú adatok mellé  beszúrjunk a listába egy másik típusú objektumot. Ilyenkor csak a lista bejárása során kapnánk hibát, amikor a nem `int` típust `int` típusúra próbálunk castolni. Generikus gyűjtemények használatakor az ilyen hibák már a fordítás során kiderülnek.
- Érték típusú adatok tárolásakor a lista lassabban működik, mert az érték típust először be kell dobozolni (boxing), hogy az `object`-ként (azaz referencia típusként) tárolható legyen.

A fenti probléma megoldása egy generikus lista használatával a következőképpen néz ki (a gyakorlat során csak a kiemelt sort módosítsuk a korábban begépelt példában):

```cs hl_lines="1 7"
var list = new List<int>();
list.Add(1);
list.Add(2);
list.Add(3);
for (int n = 0; n < list.Count; n++)
{
    int i = list[n]; // Nem kell cast-olni
    Console.WriteLine($"Value: {i}");
}
```
