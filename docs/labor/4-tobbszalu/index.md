---
authors: Szabó Zoltán,kszicsillag,bzolka
---
# 4. Többszálú alkalmazások készítése

## A gyakorlat célja

A gyakorlat célja, hogy megismertesse a hallgatókat a többszálas programozás során követendő alapelvekkel. Érintett témakörök (többek között):

- Szálak indítása (`Thread`)
- Szálak leállítása
- Szálbiztos (thread safe) osztályok készítése a `lock` kulcsszó alkalmazásával
- `ThreadPool` használata
- Jelzés és jelzésre várakozás szál szinkronizáció `ManualResetEvent` segítségével (`WaitHandle`)
- WinUI szálkezelési sajátosságok (`DispatcherQueue`)

Természetesen, mivel a témakör hatalmas, csak alapszintű tudást fogunk szerezni, de e tudás birtokában már képesek leszünk önállóan is elindulni a bonyolultabb feladatok megvalósításában.

A kapcsolódó előadások: Konkurens (többszálú) alkalmazások fejlesztése.

## Előfeltételek

A gyakorlat elvégzéséhez szükséges eszközök:

- Visual Studio 2022
    - Windows Desktop Development Workload
- Windows 10 vagy Windows 11 operációs rendszer (Linux és macOS nem alkalmas)

## Megoldás

??? success "A kész megoldás letöltése"
    :exclamation: Lényeges, hogy a labor során a laborvezetőt követve kell dolgozni, tilos (és értelmetlen) a kész megoldás letöltése. Ugyanakkor az utólagos önálló gyakorlás során hasznos lehet a kész megoldás áttekintése, így ezt elérhetővé tesszük.

    A megoldás [GitHubon érhető el](https://github.com/bmeviauab00/lab-tobbszalu-kiindulo/tree/megoldas). A legegyszerűbb mód a letöltésére, ha parancssorból a `git clone` utasítással leklónozzuk a gépünkre a `megoldas` ágat:

    `git clone https://github.com/bmeviauab00/lab-tobbszalu-kiindulo -b megoldas`

    Ehhez telepítve kell legyen a gépre a parancssori git, bővebb információ [itt](../../hazi/git-github-github-classroom/index.md#git-telepitese).

## Bevezető

A párhuzamosan futó szálak kezelése kiemelt fontosságú terület, melyet minden szoftverfejlesztőnek legalább alapszinten ismernie kell. A gyakorlat során alapszintű, de kiemelt fontosságú problémákat oldunk meg, ezért törekednünk kell arra, hogy ne csak a végeredményt, hanem az elvégzett módosítások értelmét és indokait is megértsük.

A feladat során egyszerű WinUI alkalmazást fogunk felruházni többszálas képességekkel, egyre komplexebb feladatokat megoldva. Az alapprobléma a következő: van egy függvényünk, mely hosszú ideig fut, s mint látni fogjuk, ennek „direktben” történő hívása a felületről kellemetlen következményekkel jár. A megoldás során egy meglévő alkalmazást fogunk kiegészíteni saját kódrészletekkel. Az újonnan beszúrandó sorokat az útmutatóban kiemelt háttér jelzi.

## 0. Feladat - Ismerkedés a kiinduló alkalmazással, előkészítés

Klónozzuk le a 4. gyakorlathoz tartozó kiinduló alkalmazás [repositoryját](https://github.com/bmeviauab00/lab-tobbszalu-kiindulo):

- Nyissunk egy command prompt-ot
- Navigáljunk el egy tetszőleges mappába, például c:\work\NEPTUN
- Adjuk ki a következő parancsot: `git clone https://github.com/bmeviauab00/lab-tobbszalu-kiindulo.git`
- Nyissuk meg a _SuperCalculator.sln_ solutiont Visual Studio-ban.

A feladatunk az, hogy egy bináris formában megkapott algoritmus futtatásához WinUI technológiával felhasználói felületet készítsünk. A bináris forma .NET esetében egy _.dll_ kiterjesztésű fájlt jelent, ami programozói szemmel egy osztálykönyvtár.  A fájl neve esetünkben _Algorithms.dll_, megtalálható a leklónozott Git repositoryban.

A kiinduló alkalmazásban a felhasználói felület elő is van készítve. Futtassuk az alkalmazást:

![starter](images/starter.png)

Az alkalmazás felületén meg tudjuk adni az algoritmus bemenő paramétereit (`double` számok tömbje): a példánkban mindig két `double` szám paraméterrel hívjuk az algoritmust, ezt a két felső szövegmezőben lehet megadni.
A feladatunk az, hogy a _Calculate Result_ gombra kattintás során futtassuk az algoritmust a megadott paraméterekkel, majd, ha végzett, akkor a _Result_ alatti listázó mező új sorában jelenítsük meg a kapott eredményt a bemenő paraméterekkel együtt.

Következő lépésben ismerkedjünk meg a letöltött Visual Studio solutionnel:

A keretalkalmazás egy WinUI 3 alapú alkalmazás. A felület alapvetően kész, definíciója a `MainWindow.xaml` fájlban található. Ez számunkra a gyakorlat célját tekintve kevésbé izgalmas, de otthon a gyakorlás kedvéért érdemes áttekinteni.

??? note "Felület kialakítása a `MainWindow.xaml`-ben"

       Az ablakfelület kialakításának alapjai:
       
       - A gyökérelem (root) "szokásosan" egy `Grid`. 
       - A gyökér `Grid`  felső sorában található a két `TextBox`-ot és a `Button`-t tartalmazó `StackPanel`.
       - A gyökér `Grid` alsó sorában egy másik `Grid` található. A `TextBox`-szal ellentétben a `ListBox` nem rendelkezik `Header` tulajdonsággal, így ezt nekünk kellett egy különálló "Result" szövegű `TextBlock` formájában bevezetni. Ezt a `Grid`-et azért vezettük be (egy "egyszerűbb" `StackPanel` helyett), mert így lehetett elérni, hogy a felső sorában a "Result" `TextBlock` fix magasságú legyen, az alsó sorban pedig a `ListBox` töltse ki a teljes maradó helyet (a felső sor magassága `Auto`, az alsó sor magassága `*`).
       - A "Calculate Result" szövegű gomb szép példa arra, hogy a `Button` `Content`-jének sokszor nemcsak egy egyszerű szöveget adunk meg. A példában egy `SymbolIcon` és a `TextBlock` kompozíciója (`StackPanel` segítségével megvalósítva), ezáltal tudjunk a egy megfelelő ikont/szimbólumot rendelni, mely feldobja a megjelenését.
       - Arra is látunk példát, hogy a `ListBox` hogyan tehető görgethetővé, ha már sok elem van benne (vagy túl szélesek az elemek). Ehhez a `ScrollViewer`-ét kell megfelelően paraméterezni.
       - A `ListBox` `ItemContainerStyle` tulajdonságával a `ListBox` elemre adhatunk meg stílusokat. A példában a `Padding`-et vettük kisebbre az alapértelmezettnél, enélkül a `ListBox` elemek magassága helypazarlóan nagy lenne.

A `MainWindow.xaml.cs` forrásfájl a főablakhoz tartozó code behind fájl, ezt tekintsük át, főbb elemei a következők:

- Az eredmény és a paraméterek `ListBox`-ba történő naplózásához találunk egy `ShowResult` nevű segédfüggvényt.
- A `CalculateResultButton_Click` a gomb a _Calculate Result_ gomb kattintásához tartozó eseménykezelő. Azt látjuk, hogy a két szövegdobozból kiolvassa a paraméterek értékét, és megpróbálja számmá alakítani. Ha sikerül, akkor itt történik majd az algoritmus hívása (ez nincs még megvalósítva), illetve, ha nem sikerül, akkor a `DisplayInvalidElementDialog` segítségével egy üzenetablakban tájékoztatja a felhasználót az érvénytelen paraméterekről.
- A konstruktorból hívott `AddKeyboardAcceleratorToChangeTheme` függvény számunkra nem releváns, a világos és sötét téma közötti váltást teszi lehetővé (futás közben érdemes kipróbálni, ++ctrl+t++ billentyűkombináció).

### A DLL-ben levő kód felhasználása

A kiinduló projektben megtaláljuk a _Algorithm.dll_-t. Ebben lefordított formában egy `Algorithms` névtérben levő `SuperAlgorithm` nevű osztály található, melynek egy `Calculate` nevű statikus művelete van. Ahhoz, hogy egy projektben fel tudjuk használni a DLL-ben levő osztályokat, a DLL-re a projektünkben egy ún. referenciát kell felvegyünk.

1. Solution Explorerben a projektünk _Dependencies_ node-jára jobbklikkelve válasszuk az _Add Project reference_ opciót!

    ![Add project reference](images/add-project-ref.png)

    !!! note "Külső referenciák"

        Itt valójában nem egy másik Visual Studio projektre adunk referenciát, de így a legegyszerűbb előhozni ezt az ablakot.

        Megemlítendő még, hogy külső osztálykönyvtárak esetében már nem DLL-eket szoktunk referálni egy rendes projektben, hanem a .NET csomagkezelő rendeszeréből a NuGet-ről szokás a külső csomagokat beszerezni. Most az _Algorithm.dll_ esetünkben nincs NuGet-en publikálva, ezért kell kézzel felvegyük azt.

2. Az előugró ablak jobb alsó sarokban található _Browse_ gomb segítségével keressük meg és válasszuk ki projekt _External_ almappájában található _Algorithms.dll_ fájlt, majd hagyjuk jóvá a hozzáadást az OK gombbal!

A Solution Explorerben egy projekt alatti _Dependencies_ csomópontot lenyitva láthatjuk a hivatkozott külső függőségeket. Itt most már megjelenik az Assemblyk között előbb felvett Algorithms referencia is. A Frameworks kategóriában a .NET keretrendszer csomagjait találjuk. Az Analyzerek pedig statikus kódelemző eszközök fordítás időben. Illetve itt lennének még a projekt vagy a NuGet referenciák is.

![Dependencies](images/dependencies.png)

Kattintsunk Algorithms referencián jobb gombbal és válasszuk a _View in Object Browser_ funkciót. Ekkor megnyílik az Object Browser tabfül, ahol megtekinthetjük, hogy az adott DLL-ben milyen névterek, osztályok találhatók, illetve ezeknek milyen tagjaik (tagváltozó, tagfüggvény, property, event) vannak. Ezeket a Visual Studio a DLL metaadataiból az ún. reflection mechanizmus segítségével olvassa ki (ilyen kódot akár mi is írhatunk).

Az alábbi ábrának megfelelően az Object Browserben baloldalt keressük ki az Algorithms csomópontot, nyissuk le, és láthatóvá válik, hogy egy `Algorithms` névtér van benne, abban pedig egy `SuperAlgorithm` osztály. Ezt kiválasztva középen megjelennek az osztály függvényei, itt egy függvényt kiválasztva pedig az adott függvény pontos szignatúrája:

![Object browser](images/object-browser.png)

## 1. Feladat – Művelet futtatása a főszálon

Most már rátérhetünk az algoritmus futtatására. Első lépésben ezt az alkalmazásunk fő szálán tesszük meg.

1. A főablakon lévő gomb `Click` eseménykezelőjében hívjuk meg a számoló függvényünket. Ehhez a Solution Explorerben nyissuk meg a `MainWindow.xaml.cs` code behind fájlt, és keressük meg a `CalculateResultButton_Click` eseménykezelőt. Egészítsük ki a kódot az újonnan behivatkozott algoritmus meghívásával.

    ```cs hl_lines="7-8"
    private void CalculateResultButton_Click(object sender, RoutedEventArgs e)
    {
        if (double.TryParse(param1TextBox.Text, out var p1) && double.TryParse(param2TextBox.Text, out var p2))
        {
            var parameters = new double[] { p1, p2 };

            var result = Algorithms.SuperAlgorithm.Calculate(parameters);
            ShowResult(parameters, result);
        }
        else
            DisplayInvalidElementDialog();
    }
    ```

2. Próbáljuk ki az alkalmazást, és vegyük észre, hogy az ablak a számolás ideje alatt nem reagál a mozgatásra, átméretezésre, a felület gyakorlatilag befagy.

Az alkalmazásunk eseményvezérelt, mint minden Windows alkalmazás. Az operációs rendszer a különböző interakciókról (pl. mozgatás, átméretezés, egérkattintás) értesíti az alkalmazásunkat: mivel a gombnyomást követően az alkalmazásunk egyetlen szála a kalkulációval van elfoglalva, nem tudja azonnal feldolgozni a további felhasználói utasításokat. Amint a számítás lefutott (és az eredmények megjelennek a listában) a korábban kapott parancsok is végrehajtásra kerülnek.

## 2. Feladat – Végezzük a számítást külön szálban

Következő lépésben a számítás elvégzésére egy külön szálat fogunk indítani, hogy az ne blokkolja a felhasználói felületet.

1. Készítsünk egy új függvényt a `MainWindow` osztályban, mely a feldolgozó szál belépési pontja lesz.

    ```cs
    private void CalculatorThread(object arg)
    {
        var parameters = (double[])arg;
        var result = Algorithms.SuperAlgorithm.Calculate(parameters);
        ShowResult(parameters, result);
    }
    ```

2. Indítsuk el a szálat a gomb `Click` eseménykezelőjében. Ehhez cseréljük le a korábban hozzáadott kódot:

    ```cs hl_lines="7-8"
    private void CalculateResultButton_Click(object sender, RoutedEventArgs e)
    {
        if (double.TryParse(param1TextBox.Text, out var p1) && double.TryParse(param2TextBox.Text, out var p2))
        {
            var parameters = new double[] { p1, p2 };

            var th = new Thread(CalculatorThread);
            th.Start(parameters);
        }
        else
            DisplayInvalidElementDialog();
    }
    ```

    A Thread objektum `Start` műveletében átadott paramétert kapja meg a `CalculatorThread` szálfüggvényünk.

3. Futtassuk az alkalmazást ++f5++-tel (most fontos, hogy így, a debuggerben futtassuk)! _The application called an interface that was marshalled for a different thread. (0x8001010E (RPC_E_WRONG_THREAD))_ hibaüzenetet kapunk a `ShowResult` metódusban, ugyanis nem abból a szálból próbálunk hozzáférni a UI elemhez / vezérlőhöz, amelyik létrehozta (a vezérlőt). A következő feladatban ezt a problémát analizáljuk és oldjuk meg.

## 3. Feladat – a `DispatcherQueue.HasThreadAccess` és `DispatcherQueue.TryEnqueue` használata

Az előző pontban a problémát a következő okozza. WinUI alkalmazásoknál él az alábbi szabály: az ablakok/felületelemek/vezérlőelemek alapvetően nem szálvédett (thread safe) objektumok, így **egy ablakhoz/felületelemhez/vezérlőhöz csak abból a szálból szabad hozzáférni (pl. propertyjét olvasni, állítani, műveletét meghívni), amelyik szál az adott ablakot/felületelemet/vezérlőt létrehozta**, máskülönben kivételt kapunk.
Alkalmazásunkban azért kaptunk kivételt, mert a `resultListBox` vezérlőt a fő szálban hoztuk létre, a `ShowResult` metódusban az eredmény megjelenítésekor viszont egy másik szálból férünk hozzá (`resultListBox.Items.Add` művelet hívása).

Kérdés, hogyan lehet mégis valamilyen módon ezekhez a felületelemekhez/vezérlőkhöz egy másik szálból hozzáférni. A megoldást a `DispatcherQueue` alkalmazása jelenti, mely abban nyújt segítséget, hogy a vezérlőkhöz mindig a megfelelő szálból történjen a hozzáférés:

- `DispatcherQueue` objektum `TryEnqueue` függvénye a vezérlőelemet létrehozó szálon futtatja le a számára paraméterként megadott függvényt (mely függvényből így már közvetlenül hozzáférhetünk a vezérlőhöz).
- A `DispatcherQueue` objektum `HasThreadAccess` tulajdonsága azt segít eldönteni, szükség van-e egyáltalán az előző pontban említett `TryEnqueue` alkalmazására. Ha a tulajdonság értéke
    - igaz, akkor a vezérlőhöz közvetlenül is hozzáférhetünk (mert az aktuális szál megegyezik a vezérlőt létrehozó szállal), ellenben ha
    - hamis, akkor a vezérlőhöz csak "kerülő úton", a `DispatcherQueue` objektum `TryEnqueue` segítségével férhetünk hozzá (mert az aktuális szál NEM egyezik a vezérlőt létrehozó szállal).

A `DispatcherQueue` segítségével tehát el tudjuk kerülni korábbi kivételünket (a vezérlőhöz, esetünkben a `resultListBox`-hoz való hozzáférést a megfelelő szálra tudjuk "irányítani"). Ezt fogjuk a következőkben megtenni.

!!! Note
    A `DispatcherQueue` objektum a Window osztály leszármazottakban érhető el a`DispatcherQueue` tulajdonságán keresztül (más osztályokban pedig a `DispatcherQueue.GetForCurrentThread()` statikus művelet segítségével szerezhető meg).

Módosítanunk kell a `ShowResult` metódust annak érdekében, hogy mellékszálból történő hívás esetén se dobjon kivételt.

```cs hl_lines="3-5 7 18-19"
private void ShowResult(double[] parameters, double result)
{
    // Closing the window the DispatcherQueue property may return null, so we have to perform a null check
    if (this.DispatcherQueue == null)
        return;

    if (this.DispatcherQueue.HasThreadAccess)
    {
        var item = new ListBoxItem()
        {
            Content = $"{parameters[0]} #  {parameters[1]} = {result}"
        };
        resultListBox.Items.Add(item);
        resultListBox.ScrollIntoView(item);
    }
    else
    {
        this.DispatcherQueue.TryEnqueue( () => ShowResult(parameters, result) );
    }
}
```

Próbáljuk ki!

Ez a megoldás már működőképes, főbb elemei a következők:

- A `DispatcherQueue` `null` vizsgálat szerepe: a főablak bezárása után a `DispatcherQueue` már `null`, nem használható.
- A `DispatcherQueue.HasThreadAccess` segítségével megnézzük, hogy a hívó szál hozzáférhet-e közvetlenül a vezérlőkhöz (esetünkben a `ListBox`-hoz):
    - Ha igen, minden úgy történik, mint eddig, a `ListBox`-ot kezelő kód változatlan.
    - Ha nem, a `DispatcherQueue.TryEnqueue` segítségével férünk hozzá a vezérlőhöz. A következő trükköt alkalmazzuk. A `TryEnqueue` függvénynek egy olyan paraméter nélküli, egysoros függvényt adunk meg lambda kifejezés formájában, mellyel a `ShowResult` függvényünket hívja meg (gyakorlatilag rekurzívan), a paramétereket tovább passzolva számára. Ez nekünk azért jó, mert ez a `ShowResult` hívás már azon a szálon történik, mely a vezérlőt létrehozta (az alkalmazás fő szála), ebben a `HasThreadAccess` értéke már igaz, és hozzá tudunk férni közvetlenül a `ListBox`-unkhoz. Ez a rekurzív megközelítés egy bevett minta a redundáns kódok elkerülésére.
  
Tegyünk töréspontot a `ShowResult` művelet első sorára, és az alkalmazást futtatva győződjünk meg arról, hogy a `ShowResult` művelet első hívásakor `HasThreadAccess` még hamis (így megtörténik a `TryEnqueue` hívása), majd ennek hatására még egyszer meghívódik a `ShowResult`, de ekkor a `HasThreadAccess` értéke már igaz.

Vegyük ki a töréspontot, így futtassuk az alkalmazást: vegyük észre, hogy amíg egy számítás fut, újabbakat is indíthatunk, hiszen a felületünk végig reszponzív maradt (a korábban tapasztalt hiba pedig már nem jelentkezik).

## 4. feladat – Művelet végzése Threadpool szálon

Az előző megoldás egy jellemzője, hogy mindig új szálat hoz létre a művelethez. Esetünkben ennek nincs különösebb jelentősége, de ez a megközelítés egy olyan kiszolgáló alkalmazás esetében, amely nagyszámú kérést szolgál ki úgy, hogy minden kéréshez külön szálat indít, már problémás lehet. Két okból is:

- Ha a szálfüggvény gyorsan lefut (egy kliens kiszolgálása gyors), akkor a CPU nagy részét arra pazaroljuk, hogy szálakat indítsunk és állítsunk le, ezek ugyanis önmagukban is erőforrásigényesek.
- Túl nagy számú szál is létrejöhet, ennyit kell ütemeznie az operációs rendszernek, ami feleslegesen pazarolja az erőforrásokat.
  
Egy másik probléma jelen megoldásunkkal: mivel a számítás ún. **előtérszálon** fut (az újonnan létrehozott szálak alapértelmezésben előtérszálak), hiába zárjuk be az alkalmazást, a program tovább fut a háttérben mindaddig, amíg végre nem hajtódik az utoljára indított számolás is: egy processz futása ugyanis akkor fejeződik csak be, ha már nincs futó előtérszála.

Módosítsuk a gomb eseménykezelőjét, hogy új szál indítása helyett **threadpool** szálon futtassa a számítást. Ehhez csak a gombnyomás eseménykezelőjét kell ismét átírni.

```cs hl_lines="7"
private void CalculateResultButton_Click(object sender, RoutedEventArgs e)
{
    if (double.TryParse(param1TextBox.Text, out var p1) && double.TryParse(param2TextBox.Text, out var p2))
    {
        var parameters = new double[] { p1, p2 };

        ThreadPool.QueueUserWorkItem(CalculatorThread, parameters);
    }
    else
        DisplayInvalidElementDialog();
}
```

Próbáljuk ki az alkalmazást, és vegyük észre, hogy az alkalmazás az ablak bezárásakor azonnal leáll, nem foglalkozik az esetlegesen még futó szálakkal (mert a threadpool szálak háttér szálak).

## 5. Feladat – Termelő-fogyasztó alapú megoldás

Az előző feladatok megoldása során önmagában egy jól működő komplett megoldását kaptuk az eredeti problémának, mely lehetővé teszi, hogy akár több munkaszál is párhuzamosan dolgozzon a háttérben a számításon, ha a gombot sokszor egymás után megnyomjuk. A következőkben úgy fogjuk módosítani az alkalmazásunkat, hogy a gombnyomásra ne mindig keletkezzen új szál, hanem a feladatok bekerüljenek egy feladatsorba, ahonnan több, a háttérben folyamatosan futó szál egymás után fogja kivenni őket és végrehajtani. Ez a feladat a klasszikus termelő-fogyasztó probléma, mely a gyakorlatban is sokszor előfordul, a működését az alábbi ábra szemlélteti.

![Termelő fogyasztó](images/termelo-fogyaszto.png)

!!! tip "Termelő fogyasztó vs `ThreadPool`"
    Ha belegondolunk, a `ThreadPool` is egy speciális, a .NET által számunkra biztosított termelő-fogyasztó és ütemező mechanizmus. A következőkben egy más jellegű termelő-fogyasztó megoldást dolgozunk ki annak érdekében, hogy bizonyos szálkezeléssel kapcsolatos konkurencia problémákkal találkozhassunk.

A főszálunk a termelő, a _Calculate result_ gombra kattintva hoz létre egy új feladatot. Fogyasztó/feldolgozó munkaszálból azért indítunk majd többet, mert így több CPU magot is ki tudunk használni, valamint a feladatok végrehajtását párhuzamosítani tudjuk.

A feladatok ideiglenes tárolására a kiinduló projektünkben már némiképpen előkészített `DataFifo` osztályt tudjuk használni (a Solution Explorerben a `Data` mappában található). Nézzük meg a forráskódját. Egy egyszerű FIFO sort valósít meg, melyben `double[]` elemeket tárol. A `Put` metódus hozzáfűzi a belső lista végéhez az új párokat, míg a `TryGet` metódus visszaadja (és eltávolítja) a belső lista első elemét. Amennyiben a lista üres, a függvény nem tud visszaadni elemet. Ilyenkor a `false` visszatérési értékkel jelzi ezt.

1. Módosítsuk a gomb eseménykezelőjét, hogy ne `ThreadPool`ba dolgozzon, hanem a FIFO-ba:

    ```cs hl_lines="7"
    private void CalculateResultButton_Click(object sender, RoutedEventArgs e)
    {
        if (double.TryParse(param1TextBox.Text, out var p1) && double.TryParse(param2TextBox.Text, out var p2))
        {
            var parameters = new double[] { p1, p2 };

            _fifo.Put(parameters);
        }
        else
            DisplayInvalidElementDialog();
    }
    ```

2. Készítsük el az új szálkezelő függvény naív implementációját az űrlap osztályunkban:

    ```cs
    private void WorkerThread()
    {
        while (true)
        {
            if (_fifo.TryGet(out var data))
            {
                double result = Algorithms.SuperAlgorithm.Calculate(data);
                ShowResult(data, result);
            }

            Thread.Sleep(500);
        }
    }
    ```

    A `Thread.Sleep` bevezetésére azért van szükség, mert e nélkül a munkaszálak üres FIFO esetén folyamatosan feleslegesen pörögnének, semmi hasznos műveletet nem végezve is 100%-ban kiterhelnének egy-egy CPU magot. Megoldásunk nem ideális, később továbbfejlesztjük.

3. Hozzuk létre, és indítsuk el a feldolgozó szálakat a konstruktorban:

    ```cs
    new Thread(WorkerThread) { Name = "Worker thread 1" }.Start();
    new Thread(WorkerThread) { Name = "Worker thread 2" }.Start();
    new Thread(WorkerThread) { Name = "Worker thread 3" }.Start();
    ```

4. Indítsuk el az alkalmazást, majd zárjuk is be azonnal anélkül, hogy a _Calculate Result_ gombra kattintanánk. Az tapasztaljuk, hogy az ablakunk bezáródik ugyan, de a processzünk tovább fut, az alkalmazás bezárására csak a Visual Studioból, vagy a Task Managerből van lehetőség:

    ![Stop Debugging](images/stop-debugging.png)

    A feldolgozó szálak előtérszálak, kilépéskor megakadályozzák a processz megszűnését. Az egyik megoldás az lehetne, ha a szálak `IsBackground` tulajdonságát `true`-ra állítanánk a létrehozásukat követően. A másik megoldás, hogy kilépéskor gondoskodunk a feldolgozó szálak kiléptetéséről. Egyelőre tegyük félre ezt a problémát, később visszatérünk rá.

5. Indítsuk el az alkalmazást azt tapasztaljuk, hogy miután kattintunk a _Calculate Result_ gombon (csak egyszer kattintsunk rajta) nagy valószínűséggel kivételt fogunk kapni. A probléma az, hogy a `DataFifo` nem szálbiztos, inkonzisztensé vált. Két eredő ok is húzódik a háttérben:

### Probléma 1

Nézzük a következő forgatókönyvet:

1. A sor üres. A feldolgozó szálak egy `while` ciklusban folyamatosan pollozzák a FIFO-t, vagyis hívják a `TryGet` metódusát.
2. A felhasználó egy feladatot tesz a sorba.
3. Az egyik feldolgozó szál a `TryGet` metódusban azt látja, van adat a sorban, vagyis `if ( _innerList.Count > 0 )` kódsor feltétele teljesül, és rálép a következő kódsorra. Tegyük fel, hogy ez a szál ebben a pillanatban elveszti a futási jogát, már nincs ideje kivenni az adatot a sorból.
4. Egy másik feldolgozó szál is éppen ekkor ejti meg az `if ( _innerList.Count > 0 )` vizsgálatot, nála is teljesül a feltétel, és ez a szál ki is veszi az adatot a sorból.
5. Az első szálunk újra ütemezésre kerül, felébred, ő is megpróbálja kivenni az adatot a sorból: a sor viszont már üres, a másik szálunk kivette az egyetlen adatot a sorból az orra előtt. Így az `_innerList[0]` hozzáférés kivételt eredményez.

Ezt a problémát csak úgy tudjuk elkerülni, ha a sor ürességének a vizsgálatát és az elem kivételét oszthatatlanná tesszük.

!!! note "Thread.Sleep(500)"
    Az ürességvizsgálatot figyelő kódsort követő `Thread.Sleep(500);` kódsornak csak az a szerepe a példakódunkban, hogy a fenti peches forgatókönyv bekövetkezésének a valószínűségét megnövelje, s így a példát szemléletesebbé tegye (mivel ilyenkor szinte biztos, hogy átütemeződik a szál). A későbbiekben ezt ki is fogjuk venni, egyelőre hagyjuk benne.

### Probléma 2

A `DataFifo` osztály egyidőben több szálból is hozzáférhet a `List<double[]>` típusú `_innerList` tagváltozóhoz. Ugyanakkor, ha megnézzük a `List<T>` dokumentációját, azt találjuk, hogy az osztály nem szálbiztos (not thread safe). Ez esetben viszont ezt nem tehetjük meg, nekünk kell zárakkal biztosítanunk, hogy a kódunk egyidőben csak egy metódusához / tulajdonságához / tagváltozójához fér hozzá (pontosabban inkonzisztencia csak egyidejű írás, illetve egyidejű írás és olvasás esetén léphet fel, de az írókat és az olvasókat a legtöbb esetben nem szoktuk megkülönböztetni, itt sem tesszük).

A következő lépésben a `DataFifo` osztályunkat szálbiztossá tesszük, amivel megakadályozzuk, hogy a fenti két probléma bekövetkezhessen.

## 6. feladat – Tegyük szábiztossá a DataFifo osztályt

A `DataFifo` osztály szálbiztossá tételéhez szükségünk van egy objektumra (ez bármilyen referencia típusú objektum lehet), melyet kulcsként használhatunk a zárolásnál. Ezt követően a `lock` kulcsszó segítségével el tudjuk érni, hogy egyszerre mindig csak egy szál tartózkodjon az adott kulccsal védett blokkokban.

1.	Vegyünk fel egy `object` típusú mezőt `_syncRoot` néven a `DataFifo` osztályba.

    ```cs
    private object _syncRoot = new object();
    ```

2. Egészítsük ki a `Put` és a `TryGet` függvényeket a zárolással.

    ```cs hl_lines="3-4 6"
    public void Put(double[] data)
    {
        lock (_syncRoot)
        {
            _innerList.Add(data); 
        }
    }
    ```

    ```cs hl_lines="3-4 16"
    public bool TryGet(out double[] data)
    {
        lock (_syncRoot)
        {
            if (_innerList.Count > 0)
            {
                Thread.Sleep(500);

                data = _innerList[0];
                _innerList.RemoveAt(0);
                return true;
            }

            data = null;
            return false;
        }
    }
    ```

    !!! tip "Surround with"
        Használjuk a Visual Studio _Surround with_ funkcióját a CTRL + K, CTRL + S billentyű kombinációjával a körülvenni kívánt kijelölt kódrészleten.


Most már nem szabad kivételt kapnunk.

Ki is vehetjük a `TryGet` metódusból a mesterséges késleltetést (`Thread.Sleep(500);` sor).

!!! error "Lockolás `this`-en"
    Felmerülhet a kérdés, hogy miért vezettünk be egy külön `_syncRoot` tagváltozót és használtuk ezt zárolásra a `lock` paramétereként, amikor a `this`-t is használhattuk volna helyette (a `DataFifo` referencia típus, így ennek nem lenne akadálya). A `this` alkalmazása azonban **sértené az osztályunk egységbezárását**! Ne feledjük: a `this` egy referencia az objektumunkra, de más osztályoknak is van ugyanerre az objektumra referenciájuk (pl. esetünkben a `MainWindow`-nak van referenciája a `DataFifo`-ra), és ha ezek a külső osztályok zárat tesznek a `lock` segítségével az objektumra, akkor az "interferál" az általunk az osztályon belük használt zárolással (mivel `this` alkalmazása miatt a külső és belső `lock`-ok paramétere ugyanaz lesz). Így pl. egy külső zárral teljesen meg lehet "bénítani" a `TryGet` és `Put` művelet működését. Ezzel szemben az általunk választott megoldásban a `lock` paramétere, a `_syncRoot` változó privát, ehhez már külső osztályok nem férhetnek hozzá, így nem is zavarhatják meg az osztályunk belső működését.

## 7. feladat – Hatékony jelzés megvalósítása

### ManualResetEvent használata

A `WorkerThread`-ben folyamatosan futó `while` ciklus ún. aktív várakozást valósít meg, ami mindig kerülendő. Ha a `Thread.Sleep`-et nem tettük volna a ciklusmagba, akkor ezzel maximumra ki is terhelné a processzort. A `Thread.Sleep` megoldja ugyan a processzor terhelés problémát, de bevezet egy másikat: ha mindhárom munkaszálunk éppen alvó állapotba lépett, mikor beérkezik egy új adat, akkor feleslegesen várunk 500 ms-ot az adat feldolgozásának megkezdéséig.

A következőkben úgy fogjuk módosítani az alkalmazást, hogy blokkolva várakozzon, amíg adat nem kerül a FIFO-ba (amikor viszont adat kerül bele, azonnal kezdje meg a feldolgozást). Annak jelzésére, hogy van-e adat a sorban egy `ManualResetEvent`-et fogunk használni.

1. Adjunk hozzá egy `MaunalResetEvent` példányt a `DataFifo` osztályunkhoz `_hasData` néven.

    ```cs
    // A false konstruktor paraméter eredményeképpen kezdetben az esemény nem jelzett (kapu csukva)
    private ManualResetEvent _hasData = new ManualResetEvent(false);
    ```

2. A `_hasData` alkalmazásunkban kapuként viselkedik. Amikor adat kerül a listába „kinyitjuk”, míg amikor kiürül a lista „bezárjuk”.

    !!! tip "Az esemény szemantikája és elnevezése"
        Lényeges, hogy jó válasszuk meg az eseményünk szemantikáját és ezt a változónk nevével pontosan ki is fejezzük. A példánkban a `_hasData` név jól kifejezi, hogy pontosan akkor és csak akkor jelzett az eseményünk (nyitott a kapu), amikor van feldolgozandó adat. Most már "csak" az a dolgunk, hogy ezt a szemantikát megvalósítsuk: jelzettbe tegyük az eseményt, mikor adat kerül a FIFO-ba, és jelzetlenbe, amikor kiürül a FIFO.

    ```cs hl_lines="6"
    public void Put(double[] data)
    {
        lock (_syncRoot)
        {
            _innerList.Add(data);
            _hasData.Set();
        }
    }
    ```

    ```cs hl_lines="9-12"
    public bool TryGet(out double[] data)
    {
        lock (_syncRoot)
        {
            if (_innerList.Count > 0)
            {
                data = _innerList[0];
                _innerList.RemoveAt(0);
                if (_innerList.Count == 0)
                {
                    _hasData.Reset();
                }

                return true;
            }

            data = null;
            return false;
        }
    }
    ```

### Jelzésre várakozás (blokkoló a Get)

Az előző pontban megoldottuk a jelzést, ám ez önmagában nem sokat ér, hiszen nem várakoznak rá. Ennek megvalósítása jön most.

1. Módosítsuk a metódust az alábbiak szerint: kidobjuk az üresség vizsgálatot és az eseményre való várakozással pótoljuk.

    ```cs hl_lines="5"
    public bool TryGet(out double[] data)
    {
        lock (_syncRoot)
        {
            if (_hasData.WaitOne())
            {
                // ...
    ```
   
    !!! note "A WaitOne művelet visszatérési értékének vizsgálata"
        A `WaitOne` művelet egy `bool` értékkel tér vissza, mely igaz, ha a `WaitOne` paraméterében megadott időkorlát előtt jelzett állapotba kerül az esemény (ill. ennek megfelelően hamis, ha lejárt az időkorlát). A példánkban nem adtunk meg időkorlátot paraméterben, mely végtelen időkorlát alkalmazását jelenti. Ennek megfelelően felesleges is az `if` feltételvizsgálat, hiszen esetünkben a `WaitOne()` mindig igaz értékkel tér vissza. Ez egyetlen ok, amiért mégis éltünk feltételvizsgálattal: így a követketkező és egy későbbi feladatnál kisebb átalakításra lesz majd szükség.

2. Ezzel a `Thread.Sleep` a `WorkerThread`-ben feleslegessé vált, kommentezzük ki!

    A fenti megoldás futtatásakor azt tapasztaljuk, hogy az alkalmazásunk felülete az első gombnyomást követően befagy. Az előző megoldásunkban ugyanis egy amatőr hibát követtünk el. A lock-olt kódrészleten belül várakozunk a `_hasData` jelzésére, így a főszálnak lehetősége sincs arra, hogy a `Put` műveletben (egy szintén `lock`-kal védett részen belül) jelzést küldjön `_hasData`-val. **Gyakorlatilag egy holtpont (deadlock) helyzet alakult ki.**

    Próbálkozhatnánk egy időkorlát megadásával (ms) a várakozásnál:

    ```cs
    if (_hasData.WaitOne(100))
    ```

    Ez önmagában sem lenne elegáns megoldás, ráadásul a folyamatosan pollozó munkaszálak jelentősen kiéheztetnék a Put-ot hívó szálat! Helyette, az elegáns és követendő minta az, hogy lock-on belül kerüljük a blokkolva várakozást.

    Valódi javításként cseréljük meg a `lock`-ot és a `WaitOne`-t, illetve a `WaitOne` paraméter eltávolításával szüntessük meg a várakozási időkorlátot:

    ```cs hl_lines="3-6"
    public bool TryGet(out double[] data)
    {
        if (_hasData.WaitOne())
        {
            lock (_syncRoot)
            {
                data = _innerList[0];
                _innerList.RemoveAt(0);
                if (_innerList.Count == 0)
                {
                    _hasData.Reset();
                }

                return true; 
            }
        }

        data = null;
        return false;
    }
    ```

    Próbáljuk ki az alkalmazást. Az első gombnyomás hatására kivételt kapunk. Így elkerüljük ugyan a deadlockot, **azonban a szálbiztosság sérült**, hiszen mire a `lock`-on belülre jutunk, nem biztos, hogy maradt elem a listában. Ugyanis lehet, több szál is várakozik a `_hasData.WaitOne()` műveletnél arra, hogy elem kerüljön a sorba. Mikor ez bekövetkezik, a `ManualResetEvent` objektumunk mind átengedi (hacsak éppen gyorsan le nem csukja egy szál, de ez nem garantált).

    !!! note "A konkurens, többszálú környezetben való programozás nehézségei"
        Jól illusztrálja a feladat, hogy milyen alapos átgondolást igényel a konkurens, többszálú környezetben való programozás. Tulajdonképpen még szerencsénk is volt az előzőekben, mert jól reprodukálhatóan előjött a hiba. A gyakorlatban azonban ez ritkán van így. Sajnos sokkal gyakoribb, hogy a konkurenciahibák időnkénti, nem reprodukálható problémákat okoznak. Az ilyen jellegű feladatok megoldását mindig nagyon át kell gondolni, nem lehet az "addig-próbálkozom-míg-jó-nem-lesz-a-kézi-teszt-során" elv mentén leprogramozni.


3. Javításként tegyük vissza a `lock`-on belüli üresség-vizsgálatot.

    ```cs hl_lines="7-8 17"
    public bool TryGet(out double[] data)
    {
        if (_hasData.WaitOne())
        {
            lock (_syncRoot)
            {
                if (_innerList.Count > 0)
                {
                    data = _innerList[0];
                    _innerList.RemoveAt(0);
                    if (_innerList.Count == 0)
                    {
                        _hasData.Reset();
                    }

                    return true;  
                }
            }
        }

        data = null;
        return false;
    }
    ```

    Ez már jól működik. Előfordulhat ugyan, hogy feleslegesen fordulunk a listához, de ezzel így most megelégszünk.

    Teszteljük az alkalmazást!

!!! note "System.Collections.Concurrent"
    A .NET keretrendszerben több beépített szálbiztosságra felkészített osztály is található a `System.Collections.Concurrent` névtérben. A fenti példában a `DataFifo` osztályt a `System.Collections.Concurrent.ConcurrentQueue` osztállyal kiválthattuk volna.

## 8. feladat – Kulturált leállás

Korábban félretettük azt a problémát, hogy az ablakunk bezárásakor a processzünk „beragad”, ugyanis a feldolgozó munkaszálak előtérszálak, kiléptetésüket eddig nem oldottuk meg. Célunk, hogy a végtelen `while` ciklust kiváltva a munkaszálaink az alkalmazás bezárásakor kulturált módon álljanak le.

1. Egy `ManualResetEvent` segítségével jelezzük a leállítást a FIFO-ban a `TryGet`-ben történő várakozás során. A FIFO-ban vegyünk fel egy új `ManualResetEvent`-et, és vezessünk be egy `Release` műveletet, amellyel a várakozásainkat zárhatjuk rövidre (új eseményünk jelzett állapotba állítható).

    ```cs
    private ManualResetEvent _releaseTryGet = new ManualResetEvent(false);

    public void Release()
    {
        _releaseTryGet.Set();
    }
    ```

2.	A `TryGet`-ben erre az eseményre is várakozzunk. A `WaitAny` metódus akkor engedi tovább a futtatást, ha a paraméterként megadott `WaitHandle` típusú objektumok közül valamelyik jelzett állapotba kerül, és visszaadja annak tömbbéli indexét. Tényleges adatfeldolgozást pedig csak akkor szeretnénk, ha a `_hasData` jelzett (amikor is a `WaitAny` 0-val tér vissza).

    ```cs hl_lines="3"
    public bool TryGet(out double[] data)
    {
        if (WaitHandle.WaitAny(new[] { _hasData, _releaseTryGet }) == 0)
        {
            lock (_syncRoot)
            {
    ```

3. `MainWindow.xaml.cs`-ban vegyünk fel egy flag tagváltozót a bezárás jelzésére:

    ```cs
    private bool _isClosed = false;
    ```

4. A főablak bezárásakor állítsuk jelzettre az új eseményt és billentsünk be a flag-et is: a `MainWindow` osztály `Closed` eseményére iratkozzunk fel a konstruktorban, és írjuk meg a megfelelő eseménykezelő függvényt:

    ```cs
    public MainWindow()
    {
        ...

        Closed += MainWindow_Closed;
    }

    private void MainWindow_Closed(object sender, WindowEventArgs args)
    {
        _isClosed = true;
        _fifo.Release();
    }
    ```

5. Írjuk át a while ciklust az előző pontban felvett flag figyelésére.

    ```cs hl_lines="3"
    private void WorkerThread()
    {
        while (!_isClosed)
        {
    ```

6. Végül biztosítsuk, hogy a már bezáródó ablak esetében ne próbáljunk üzeneteket kiírni

    ```cs hl_lines="3-4"
    private void ShowResult(double[] parameters, double result)
    {
        if (_isClosed)
		    return;
    ```

7. Futtassuk az alkalmazást, és ellenőrizzük, kilépéskor az processzünk valóban befejezi-e a futását.

## Kitekintés: Task, async, await

A gyakorlat során az alacsonyabb szintű szálkezelési technikákkal kívántunk megismerkedni. Ugyanakkor megoldásunkat (legalábbis részben) építhettük volna a .NET aszinkron programozást támogató magasabb szintű eszközeire és mechanizmusaira, úgymint `Task`/`Task<T>` osztályok és `async`/`await` kulcsszavak.
