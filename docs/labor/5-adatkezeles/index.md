---
authors: kaszomark,kszicsillag
---
# 5. Adatkezelés

## A gyakorlat célja

A gyakorlat célja az ADO.NET programozási modelljének megismerése és a leggyakoribb adatkezelési problémák, buktatók szemléltetése alapvető CRUD műveletek megírásán keresztül.

Kapcsolódó előadások: Adatkezelés, ADO.NET alapismeretek.

## Előfeltételek

A gyakorlat elvégzéséhez szükséges eszközök:

- Visual Studio 2022
- Windows 10 vagy Windows 11 operációs rendszer
- A gyakorlat során  Visual Studioban az *SQL Server Object Explorer*-t fogjuk használni az adatbázis objektumok közötti navigálására és a lekérdezések futtatására. Ehhez szükség lehet az *SQL Server Data Tools* komponensre, melyet legegyszerűbben az *Individual Components* oldalon tudunk telepíteni a Visual Studio Installer-ben, de a *Data Storage and Processing* workload is tartalmazza ezt.

!!! tip "Gyakorlat Linuxon vagy Macen"
    A gyakorlat anyag alapvetően Windowsra és Visual Studiora készült, de - némiképpen más úton - elvégezhető más operációs rendszereken is, mivel a .NET 6 SDK támogatott Linuxon és Mac-en, Linuxon:

    - Visual Studio helyett szövegszerkesztővel (pl.: VSCode) és CLI eszközökkel.
    - Az SQL szervernek van Linuxos változata, Mac-en pedig Dockerben futtatható (de Linuxon is talán a Docker legkényelmesebb mód a futtatására).
    - Az adatok vizualizációjára használható a szintén keresztplatformos *Azure Data Studio* eszköz.

## Megoldás

??? "A kész megoldás letöltése"
    :exclamation: Lényeges, hogy a labor során a laborvezetőt követve kell dolgozni, tilos (és értelmetlen) a kész megoldás letöltése. Ugyanakkor az utólagos önálló gyakorlás során hasznos lehet a kész megoldás áttekintése, így ezt elérhetővé tesszük.

    A megoldás GitHubon érhető el [itt](https://github.com/bmeviauab00/lab-adatkezeles-megoldas). A legegyszerűbb mód a letöltésére, ha parancssorból a `git clone` utasítással leklónozzuk a gépünkre:

    ```git clone https://github.com/bmeviauab00/lab-adatkezeles-megoldas```

    Ehhez telepítve kell legyen a gépre a parancssori git, bővebb információ [itt](../hazi/git-github-github-classroom/#git-telepitese).

## Bevezető

??? warning "Megjegyzés gyakorlatvezetőknek"
    Ezt a fejezetet gyakorlaton nem kell a leírtaknak megfelelő részletességgel ismertetni, a fontosabb fogalmakat azonban mindenképpen ismertessük röviden.

### ADO.NET

Alacsony szintű adatbáziskezelésre a .NET platformon az ADO.NET áll rendelkezésre, segítségével relációs adatbázisokat tudunk elérni.

Az ADO.NET használata során két eltérő adathozzáférési modellt alkalmazhatunk:

- Kapcsolatalapú modell
- Kapcsolat nélküli modell

Az alábbi két blokkot lenyitva áttekintést kaphatunk a két modell alapelvéről.

??? abstract "A Kapcsolatalapú modell alapelvei"
    Lényege az, hogy az adatbáziskapcsolatot végig nyitva tartjuk, amíg az adatokat lekérdezzük, módosítjuk, majd a változtatásokat az adatbázisba visszaírjuk. A megoldásra DataReader objektumokat használhatunk (lásd később). A megoldás előnye az egyszerűségében rejlik (egyszerűbb programozási modell és konkurenciakezelés). A megoldás hátránya, hogy a folyamatosan fenntartott hálózati kapcsolat miatt skálázhatósági problémák adódhatnak. Ez azt jelenti, hogy az adatkezelőhöz történő nagyszámú párhuzamos felhasználói hozzáférés esetén folyamatosan nagyszámú adatbázis kapcsolat él, ami adatkezelő rendszerek esetén a teljesítmény szempontjából költséges erőforrásnak számít. Így a fejlesztés során célszerű arra törekedni, hogy az adatbázis kapcsolatokat mielőbb zárjuk le.

    A modell előnyei:

    - Egyszerűbb a konkurencia kezelése
    - Az adatok mindenhol a legfrissebbek

    Megjegyzés: ezek az előnyök akkor jelentkeznek, ha az adatbázis hozzáférés az adatkezelő szigorú zárakat használ – ezt mi a hozzáférés során megfelelő tranzakció izolációs szint megadásával tudjuk szabályozni. Ennek technikái későbbi tanulmányok során kerülnek ismertetésre).

    Hátrányok:

    - Folyamatos hálózati kapcsolat
    - Skálázhatóság

??? abstract "A Kapcsolatnélküli modell alapelvei"
    A kapcsolatalapú modellel ellentétben az adatok megjelenítése és memóriában történő módosítása során nem tartunk fent adatbázis kapcsolatot. Ennek megfelelően a főbb lépések a következők: a kapcsolat felvételét és az adatok lekérdezését követően azonnal bontjuk a kapcsolatot. Az adatokat ezt követően tipikusan megjelenítjük és lehetőséget biztosítunk a felhasználónak az adatok módosítására (rekordok felvétele, módosítása, törlése igény szerint). A módosítások mentése során újra felvesszük az adatkapcsolatot, mentjük az adatbázisba a változtatásokat és zárjuk a kapcsolatot. Természetesen a modell megköveteli, hogy a lekérdezése és a módosítások visszaírása között – amikor nincs kapcsolatunk az adatbázissal – az adatokat és a változtatásokat a memóriában nyilvántartsuk. Erre az ADO.NET környezetben nagyon kényelmes megoldást nyújt a `DataSet` objektumok alkalmazása.

    A modell előnyei:

    - Nem szükséges folyamatos hálózati kapcsolat
    - Skálázhatóság

    Hátrányok

    - Az adatok nem mindig a legfrissebbek
    - Ütközések lehetségesek
      
    Megjegyzés: Számos lehetőségünk van arra, hogy az objektumokat és kapcsolódó változásokat nyilvántartsuk a memóriában. A `DataSet` csak az egyik lehetséges technika. De használhatunk erre a célra közönséges objektumokat, illetve ezek menedzselését megkönnyítő ADO.NET-nél korszerűbb .NET technológiákat (pl. Entity Framework Core).

### A kapcsolatalapú modell

A labor keretében a kapcsolatalapú modellt ismerjük meg.

Az alapfolyamat a következő:

1. Kapcsolat létrehozása az alkalmazás, illetve az adatbázis kezelő rendszer között (`Connection` objektum felhasználásával).
2. A futtatandó SQL utasítás összeállítás (`Command` objektum felhasználásával).
3. Utasítás futtatása (`Command` objektum felhasználásával).
4. Lekérdezések esetén a visszakapott rekordhalmaz feldolgozása (`DataReader` objektum felhasználásával). Erre a módosító parancsok esetén értelemszerűen nincs szükség.
5. Kapcsolat lezárása.

Mint a fentiekből kiderül, az adatbázissal való kommunikációnak ebben a modellben három fő összetevője van:

- Connection
- Command
- Data Reader

Ezek az összetevők egy-egy osztályként jelennek meg, adatbáziskezelőfüggetlen részük a BCL *System.Data.Common* névterében található `DbConnection`, `DbCommand`, illetve `DbDataReader` néven. Ezek absztrakt osztályok, az adatbáziskezelők gyártóinak feladata, hogy ezekből leszármazva megírják a konkrét adatbáziskezelőket támogató változatokat.

Mindhárom ADO.NET összetevő támogatja a *Dispose* mintát, így `using` blokkban használható – használjuk is így, amikor csak tudjuk. Az adatbáziskezelő általában másik gépen található, mint ahol a kódunk fut (a labor során pont nem :)), így tekintsünk ezekre, mint távoli hálózati erőforrásokra.

A Microsoft SQL Servert támogató változat a *Microsoft.Data.SqlClient* NuGet csomagban, az „Sql” prefixű osztályokban találhatók (`SqlConnection`, `SqlCommand` és `SqlDataReader`).

A többi gyártó külön dll-(ek)be teszi a saját változatát, az így létrejött komponenst data providernek nevezik. Teljesség igénye nélkül néhány példa:

- [PostgreSQL](https://www.npgsql.org/)
- [SQLite](https://learn.microsoft.com/en-us/dotnet/standard/data/sqlite/?tabs=netcore-cli) 
- [Oracle](https://www.oracle.com/database/technologies/appdev/dotnet/odp.html)

#### Connection

Ez teremti meg a kapcsolatot a programunk, illetve az adatbáziskezelő-rendszer között.
Inicializálásához szükség van egy connection string-re, mely a kapcsolat felépítéséhez szükséges adatokat adja meg a driver számára. Adatbázisgyártónként eltérő a belső formátuma ([bővebben](http://www.connectionstrings.com)).

Új `Connection` példányosításakor nem biztos, hogy tényleg új kapcsolat fog létrejönni az adatbázis felé, a driverek általában connection pooling-ot alkalmaznak, hasonlóan, mint a thread pool esetében, újrahasználhatják a korábbi (éppen nem használt) kapcsolatokat.

A `Connection` különösen költséges nem felügyelt erőforrásokat használ, **így kiemelten fontos, hogy a lehető leghamarabb gondoskodjunk lezárásáról**, amikor már nincs rá szükség (pl. a `Dispose()` hívásával, amit az esetek többségében legegyszerűbben a `using` blokk alkalmazásával tehetünk meg).

#### Command

Ennek segítségével vagyunk képesek „utasításokat” megfogalmazni az adatbázis kezelő számára. Ezeket SQL nyelven kell megfogalmaznunk.
A `Command`-nak be kell állítani egy kapcsolatot – ezen keresztül fog a parancs végrehajtódni. A parancsnak különböző eredménye lehet, ennek megfelelően különböző függvényekkel futtatjuk a parancsot:

- **ExecuteReader**: Eredményhalmaz (result set) lekérdezése
- **ExecuteScalar**: Skalár érték lekérdezése
- **ExecuteNonQuery**: Nincs visszatérési érték (Pl: INSERT, UPDATE és DELETE), viszont a művelet következtében érintett rekordok számát visszakapjuk

#### Data Reader

Ha a parancs eredménye eredményhalmaz, akkor ennek a komponensnek a segítségével tudjuk az adatokat kiolvasni. Az eredményhalmaz egy táblázatnak tekinthető, a Data Reader ezen tud soronként végignavigálni (csak egyesével előrefelé!). A kurzor egyszerre egy soron áll, ha a sorból a szükséges adatokat kiolvastuk, a kurzort egy sorral előre léptethetjük. Csak az aktuális sorból tudunk olvasni. Kezdetben a kurzor nem az első soron áll, azt egyszer léptetnünk kell, hogy az első sorra álljon.

Megjegyzés: navigálás kliens oldalon történik a memóriában, nincs köze az egyes adatkezelők által támogatott kiszolgáló oldali kurzorokhoz.

## 1. Feladat – Adatbázis előkészítése

Elsőként szükségünk van egy adatbáziskezelőre. Ezt valós környezetben dedikált szerveren futó, adatbázis adminisztrátorok által felügyelt, teljesértékű adatbáziskezelők jelentik. Fejlesztési időben, lokális teszteléshez azonban kényelmesebb egy fejlesztői adatbáziskezelő használata.
A Visual Studio telepítésének részeként kapunk is egy ilyen adatbázismotort, ez a LocalDB, mely a teljesértékű SQL Server egyszerűsített változata. Főbb tulajdonságai:

- nem csak a Visual Studio-val, hanem külön is telepíthető,
- az adatbázismotor szinte teljes mértékben kompatibilis a teljesértékű Microsoft SQL Serverrel,
- alapvetően arról a gépről érhető el, melyre telepítettük,
- több példány is létrehozható igény szerint, a példányok alapvetően a létrehozó operációs rendszer felhasználója számára érhetők el (igény esetén megosztható egy példány a felhasználók között),
- a saját példányok kezelése (létrehozás, törlés, stb.) nem igényel adminisztrátori jogokat.
  
??? note "ssqllocaldb parancssori eszköz"
    A gyakorlat során nincs szükségünk erre, de a példányok kezelésére az `sqllocaldb` parancssori eszköz használható.  Néhány parancs, melyet az `sqllocaldb` után beírva alkalmazhatunk:

    | Paracs         | Leírás                                                     |
    |----------------|------------------------------------------------------------|
    | info           | az aktuális felhasznááló számára látható példányok listája |
    | create „locdb” | új példány létrehozása „locdb” névvel                      |
    | delete „locdb” | „locdb” nevű példány törlése                               |
    | start „locdb”  | „locdb” nevű példány indítása                              |
    | stop „locdb”   | „locdb” nevű példány leállítása                            |

A Visual Studio is telepít, illetve indít LocalDB példányokat, ezért érdemes megnézni, hogy a Visual Studio alapesetben milyen példányokat lát.

1. Indítsuk el a Visual Studio-t, a View menüből válasszuk az SQL Server Object Explorer-t (SSOE).
2. Nyissuk ki az SQL Server csomópontot, ha alatta látunk további csomópontokat, akkor nyert ügyünk van, nyissuk ki valamelyiket (ilyenkor indul el a példány, ha nincs elindítva, így lehet, hogy várni kell kicsit).
3. Ha nem jelent meg semmi, akkor parancssorból az `mssqllocaldb info` parancs megadja a létező példányokat. Válasszuk az SQL Server csomóponton jobbklikkelve az *Add SQL Server* opciót, majd adjuk meg valamelyik létező példányt, pl.: *(localdb)\MSSQLLocalDB*
4. A megjelenő *Databases* csomóponton válasszuk a *New Database* opciót, itt adjunk meg egy adatbázisnevet. (Laboron, mivel több hallgató is használhatja ugyanazt az operációs rendszer felhasználót, javasolt a Neptun kód, mint név használata).
5. Az új adatbázis csomópontján jobbklikkelve válasszuk a *New Query* opciót, ami egy új query ablakot nyit.
6. Nyissuk meg vagy töltsük le a *Northwind* adatbázis inicializáló [szkriptet](northwind.sql).
7. Másoljuk be a teljes szkriptet a query ablakba.
8. Futtassuk le a szkriptet a kis zöld nyíllal (*Execute*). Figyeljünk oda, hogy **jó adatbázis (melyet fenti 4. lépésben hoztunk létre) legyen kiválasztva a query ablak tetején a legördülőben**!.
9. Ellenőrizzük, hogy az adatbázisunkban megjelentek-e táblák, nézetek.
10. Fedezzük fel az SSOE legfontosabb funkcióit (táblák adatainak, sémájának lekérdezése stb.).

!!! Note "MSSQL menedzsment eszközök"
    A Visual Studio-ban két eszközzel is kezelhetünk adatbázisokat: a Server Explorer-rel és az SQL Server Object Explorer-rel is. Előbbi egy általánosabb eszköz, mely nem csak adatbázis, hanem egyéb szerver erőforrások (pl. Azure szerverek) kezelésére is alkalmas, míg a másik kifejezetten csak adatbáziskezelésre van kihegyezve. Mindkettő elérhető a View menüből és mindkettő hasonló funkciókat ad adatbáziskezeléshez, ezért ebben a mérésben csak az egyiket (SQL Server Object Explorer) használjuk.

    Amikor nem áll rendelkezésünkre a Visual Studio fejlesztőkörnyezet, akkor az adatbázisunk menedzselésére az (ingyenes) SQL Server Management Studio-t vagy a szintén ingyenes és multiplatform Azure Data Studio-t tudjuk használni.

## 2. Feladat – Lekérdezés ADO.NET SqlDataReader-rel

A feladat egy olyan C# nyelvű konzol alkalmazás elkészítése, amely használja a Northwind adatbázis `Shippers` táblájának rekordjait.

1. Hozzunk létre egy C# nyelvű konzolos alkalmazást. A projekt típusa *Console App* legyen, és **NE** a *Console App (.NET Framework)*:
    - A projekt neve legyen *AdoExample*
    - A Target Framework legyen *.NET 6*
    - Pipáljuk be a *Do not use top-level statements* kapcsolót
  
2. Keressük ki a connection stringet az SSOE-ből: jobbklikk az adatbáziskapcsolatunkon (pirossal jelölve az alábbi ábrán) / Properties.

    ![SSOE Database](images/SSOS-database.png)

3. Másoljuk a Properties ablakból *Connection String* tulajdonság értékét egy változóba a `Program` osztályba.

    ```cs
    private const string ConnString = @"Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=neptun;Integrated Security=True;Connect Timeout=30;Encrypt=False;TrustServerCertificate=False;ApplicationIntent=ReadWrite;MultiSubnetFailover=False";
    ```

    !!! tip "SQL Server connection string formátuma"
        MSSQL esetében a connection string kulcs érték párokat tartalmaz pontosvesszővel elválasztva.
        A `Data Source` kulcs alatt az SQL szerver példány neve, az` Initial Catalog` kulcs alatt az adatbázis neve szerepel.
        Az `Integrated Security=true` kapcsoló pedig a Windows authentikációt jelenti.

    !!! tip "@-os string (C# verbatim string)"
        A `@` egy speciális karakter (verbatim indentifier), amit itt arra használunk, hogy a connection string-ben megjelenő backslash karakter (`\`) ne feloldójelként (escape character) kerüljön értelmezésre.

4. Vegyük fel a projektbe a `Microsoft.Data.SqlClient` NuGet csomagot. Ezt kétféleképpen tehetjük meg:
  
      - A) Visual Studio NuGet kezelőben:
        1. Projekten jobb gomb / *Manage NuGet Packages...*, a megjelenő oldalon *Browse* oldalra váltás.
        2. A keresőbe *Microsoft.Data.SqlClient* beírása.
        3. A *Version* mezőben az 5.0.1 kiválasztása (laboron azért válaszuk ki ezt a verziót, mert ez szerepel a gépeken a NuGet cache-ben, otthoni gyakorlás során válasszuk inkább a *Latest stable*-t).
      - B) Bemásoljuk az alábbi csomag referenciát a a projektfájlba:

        ```xml
        <ItemGroup>
            <PackageReference Include="Microsoft.Data.SqlClient" Version="5.0.1" />
        </ItemGroup>
        ```

    !!! note "NuGet csomagkezelő"
        A NuGet egy olyan online csomagkezelő rendszer, ahonnan .NET alapú projektjeinbe tudunk külső függőségeket, osztálykönyvtárakat egyszerűen, verziózott formában behivatkozni. Bővebben az első előadáson szerepel.

5. Írjunk lekérdező függvényt, mely lekérdezi az összes szállítót:

    ```cs
    private static void GetShippers()
    {
        using (var conn = new SqlConnection(ConnString))
        using (var command = new SqlCommand("SELECT ShipperID, CompanyName, Phone FROM Shippers", conn))
        {
            conn.Open();
            Console.WriteLine("{0,-10}{1,-20}{2,-20}", "ShipperID", "CompanyName", "Phone");
            Console.WriteLine(new string('-', 60));
            using (SqlDataReader reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    Console.WriteLine(
                        $"{reader["ShipperID"],-10}" +
                        $"{reader["CompanyName"],-20}" +
                        $"{reader["Phone"],-20}");
                }
            }
        }
    }
    ```

    A kapcsolat alapú modell folyamata

    - Kapcsolat, parancs inicializálása
    - Kapcsolat megnyitása
    - Parancs futtatása
    - Eredmény feldolgozása
    - Kapcsolat bontása, takarítás

    !!! tip "Néhány megjegyzés a kódhoz"
        - A `DataReader`-t a parancs futtatásának eredményeként kapjuk meg, nem pedig közvetlenül példányosítjuk
        - A parancs futtatása előtt meg kell nyitnunk a kapcsolatot
        - A `DbConnection` példányosításakor nem nyitódik meg a kapcsolat (nem történik hálózati kommunikáció)
        - A `DataReader.Read()` függvénye mutatja, hogy van-e még adat az eredményhalmazban
        - A `DataReader`-t az eredményhalmazban található oszlopok nevével indexelhetjük – az eredmény `object` lesz, így, ha konkrétabb típusra van szükségünk cast-olni kell
        - A fordító nem értelmezi az SQL parancs szövegét (az csak egy string), hanem majd csak az adatbázis, így hibás SQL esetén csak futási idejű kivételt kapunk
        - Figyeljük meg, hogy az adatbázis séma változása esetén, pl. egy oszlop átnevezése után, hány helyen kell kézzel átírni string-eket a kódban
        - `$`-ral prefixelve string interpolációt alkalmazhatunk, azaz közvetlenül a stringbe ágyazhatunk kiértékelendő kifejezéseket (C# 6-os képesség). A `$@` segítségével többsoros string interpolációs kifejezéseket írhatunk (a sortörést a {}-k között kell betennünk, különben a kimeneten is megjelenik). Érdekesség: C# 8-tól fölfele bármilyen sorrendben írhatjuk a $ és @ karaktereket, tehát a `$@` és a `@$` is helyesnek számít.
        - A using kulcsszú blokk utasítás helyett egysoros kifejezésként is használható. Ilyen esetben a using blokk vége az tartalmazó blokkig tart (esetünkben a függvény végéig.). Ezzel csökkenthető a behúzások száma, de ne legyen automatikus reflex a használata, mert előfordulhat, hogy hamarabb célszerű kikényszeríteni az erőforrások felszabadítását, mint a tartalmazó blokk vége.

            ```cs
            private static void GetShippers()
            {
                using var conn = new SqlConnection(ConnString);
                using var command = new SqlCommand("SELECT ShipperID, CompanyName, Phone FROM Shippers", conn);

                conn.Open();

                Console.WriteLine("{0,-10}{1,-20}{2,-20}","ShipperID", "CompanyName", "Phone");
                Console.WriteLine(new string('-', 60));

                using var reader = command.ExecuteReader();
                while (reader.Read())
                {
                    Console.WriteLine(
                        $"{reader["ShipperID"],-10}" +
                        $"{reader["CompanyName"],-20}" +
                        $"{reader["Phone"],-20}");
                }
            }
            ``` 

            A továbbiakban ezt a módszert használjuk a behúzások és zárójelek megspórolása érdekében.

6. Hívjuk meg új függvényünket a `Main` függvényből.

    ```cs hl_lines="3"
    private static void Main(string[] args)
    {
        GetShippers();
    }
    ```

7. Próbáljuk ki az alkalmazást. Rontsuk el az SQL-t, és úgy is próbáljuk ki.

## 3. Feladat – Beszúrás SQL utasítással

1. Írjunk függvényt, mely új szállítót szúr be az adatbázisba:

    ```cs
    private static void InsertShipper(string companyName, string phone)
    {
        using var conn = new SqlConnection(ConnString);
        using var command = new SqlCommand(
            "INSERT INTO Shippers(CompanyName, Phone) VALUES(@name,@phone)", conn);
        command.Parameters.AddWithValue("@name", companyName);
        command.Parameters.AddWithValue("@phone", phone);

        conn.Open();

        int affectedRows = command.ExecuteNonQuery();

        Console.WriteLine($"{affectedRows} rows affected");
    }
    ```

    Itt olyan SQL-t kell írnunk, melynek az összeállításánál kívülről kapott változók értékeit is felhasználtuk. A string összerakásához egyszerűen a sztring összefűzés operátort, sztring interpolációt vagy `string.Format`-ot is használhattunk volna, de ez biztonsági kockázatot (SQL Injection – bővebben lásd lentebb) rejt – **SOHA!!! ne rakjuk össze az SQL-t stringművelettel**. Helyette írjuk meg úgy az SQL-t, hogy ahová a változók értékeit írnánk, oda paraméterhivatkozásokat teszünk. SQL Server esetében a hivatkozás szintaxisa: @paramnév.

    A parancs futtatásához a paraméterek értékeit is át kell adnunk az adatbázisnak, ugyanis az fogja elvégezni a paraméterek helyére az értékek behelyettesítését.

    A beszúrási parancs kimenete nem eredményhalmaz, így az `ExecuteNonQuery` művelettel kell futtatnuk, mely visszaadja beszúrt sorok számát.

2. Hívjuk meg új függvényünket a `Main` függvényből.

    ```cs hl_lines="2-3"
    GetShippers();
    InsertShipper("Super Shipper","49-98562");
    GetShippers();
    ```

3. Próbáljuk ki az alkalmazást, ellenőrizzük a konzolban és az SSOE-ben is, hogy bekerült az új sor. Az SSOE-ben való gyors és kényelmes ellenőrzéshez a `Shippers` tábla context menüjéből válasszuk a *View Data* lehetőséget.

## 4. Feladat - Módosítás tárolt eljárással

1. Tanulmányozzuk SSOE-ben a `Product_Update` tárolt eljárás kódját. Ehhez nyissuk le a *Programmability* alatt található Stored *Procedures* csomópontot, majd a `Product_Update` tárolt eljárás context menüjéből válasszuk a *View Code* lehetőséget.

    !!! note "Programkód az adatbázisban"
        A nagyobb adatkezelő rendszerek lehetőséget biztosítanak arra, hogy programkódot definiáljunk magában az adatkezelő adatbázisában. Ezeket tárol eljárásoknak (stored procedure) nevezzük. A nyelve adatkezelő függő, de MSSQL esetében ez T-SQL.

        Manapság már egyre inkább kezd kikopni az a gyakorlat az iparból, hogy komolyabb üzleti logikát az adatbázisban helyezzünk el, mivel ezeknek az SQL dialektusoknak az eszközkészlete ma már jóval korlátosabb, mint egy magas szintű programozási nyelvé (C#, Java). Ráadásul a rendszer tesztelhetőségét nagyban rontja a tárolt eljárások használata. Ennek ellenére néha indokolt lehet az adatbázisban tartani valamennyi logikát, amikor ki szeretnénk azt használni, hogy az adatokhoz közel futnak a programkódjaink, pl. ha nem akarjuk megutaztatni a hálózaton az adatot egy egyszerű tömeges adatkarbantartás érdekében.

2. Írjunk függvényt, mely ezt a tárolt eljárást hívja

    ```cs
    private static void UpdateProduct(int productID, string productName, decimal price)
    {
        using var conn = new SqlConnection(ConnString);
        using var command = new SqlCommand("Product_Update", conn);

        command.CommandType = CommandType.StoredProcedure;

        command.Parameters.AddWithValue("@ProductID", productID);
        command.Parameters.AddWithValue("@ProductName", productName);
        command.Parameters.AddWithValue("@UnitPrice", price);

        conn.Open();

        int affectedRows = command.ExecuteNonQuery();
        
        Console.WriteLine($"{affectedRows} rows affected");
    }
    ```

    A `Command`-nak a tárolt eljárás nevét kellett megadni, és a parancs típusát kellett átállítani, egyébként szerkezetileg hasonlít a korábbi beszúró kódra.

3. Hívjuk meg az új függvényünket a `Main` függvényből, például az alábbi paraméterezéssel:

    ```cs
    UpdateProduct(1, "MyProduct", 50);
    ```

4. Próbáljuk ki az alkalmazást, ellenőrizzük a konzolban és az SSOE-ben is, hogy módosult-e az 1-es azonosítójú termék.

## 5. Feladat - SQL Injection

1. Írjuk meg a beszúró függvényt úgy, hogy string interpolációval rakja össze az SQL-t.

    ```cs
    private static void InsertShipper2(string companyName, string phone)
    {
        using var conn = new SqlConnection(ConnString);
        using var command = new SqlCommand(
            $"INSERT INTO Shippers(CompanyName, Phone) VALUES('{companyName}','{phone}')",
            conn);

        conn.Open();

        int affectedRows = command.ExecuteNonQuery();
        Console.WriteLine($"{affectedRows} row(s) inserted");
    }
    ```

2. Hívjuk meg új függvényünket a `Main` függvényből „speciálisan” paraméterezve.

    ```cs
    InsertShipper2("Super Shipper", "49-98562'); DELETE FROM Shippers;--");
    ```

    Úgy állítottuk össze a második paramétert, hogy az lezárja az eredeti utasítást, ezután tetszőleges **(!!!)** SQL-t írhatunk, végül kikommentezzük az erdeti utasítás maradékát (`--`).

3. Próbáljuk ki az alkalmazást, hibát kell kapjunk, mely arra utal, hogy valamelyik szállító nem törölhető idegen kulcs hivatkozás miatt.

    Tehát a `DELETE FROM` is lefutott! Nézzük meg debuggerrel (pl. a `conn.Open` utasításon állva), hogy mi a végleges SQL (`command.CommandText`).

    Tanulságok:

    - SOSE fűzzünk össze programozottan SQL-t (semmilyen módszerrel), mert azzal kitesszük a kódunkat SQL Injection alapú támadásnak.
    - Az adatbázis állítsa össze a végleges SQL-t SQL paraméterek alapján, mert ilyenkor biztosított, hogy a paraméter értékek nem fognak SQL-ként értelmeződni (hiába írunk be SQL-t). Használjunk paraméterezett SQL-t vagy tárolt eljárást.
    - Használjunk adatbázis kényszereket, pl. a véletlen törlés ellen is véd.
    - Konfiguráljunk adatbázisban felhasználókat különböző jogosultságokkal, a programunk connection string-jében megadott felhasználó csak a működéshez szükséges minimális jogokkal rendelkezzen. A mi esetünkben nem adtunk meg felhasználót, a windows-os felhasználóként fogunk csatlakozni.

4. Hívjuk meg az eredeti (vagyis a biztonságos, SQL paramétereket használó) beszúró függvényt a „speciális” paraméterezéssel, hogy lássuk, működik-e a védelem:

    ```cs
    InsertShipper("Super Shipper", "49-98562'); DELETE FROM Shippers;--");
    InsertShipper("XXX');DELETE FROM Shippers;--", "49-98562");
    ```

    Az elsőnél nem férünk bele a méretkorlátba, a második lefut, de csak egy „furcsa” nevű szállító került be. A paraméter értéke tényleg értékként értelmeződött nem pedig SQL-ként. Nem úgy mint itt:

    ![XKCD](images/xkcd-sql-injection.png)

## 6. Feladat - Törlés

1. Írjunk egy új függvényt, mely kitöröl egy adott szállítót.

    ```cs
    private static void DeleteShipper(int shipperID)
    {
        using var conn = new SqlConnection(ConnString);
        using var command = new SqlCommand("DELETE FROM Shippers WHERE ShipperID = @ShipperID", conn);
        command.Parameters.AddWithValue("@ShipperID", shipperID);

        conn.Open();

        int affectedRows = command.ExecuteNonQuery();

        Console.WriteLine($"{affectedRows} row(s) affected");
    }
    ```

2. Hívjuk meg új függvényünket a `Main` függvényből, pl. 1-gyel paraméterezve.
3. Próbáljuk ki az alkalmazást. Valószínűleg kivételt kapunk, ugyanis van hivatkozás (idegen kulcs kényszerrel) az adott rekordra.
4. SSOE-ből nézzük ki az azonosítóját egy olyan szállítónak, melyet mi vettünk fel. Adjuk át ezt az azonosítót a törlő függvénynek – ezt már ki tudja törölni, hiszen nincs rá hivatkozás.

!!! tip "Törlési stratégiák"
    Látható, hogy a törlés igen kockázatos és kiszámíthatatlan művelet az idegen kulcs kényszerek miatt. Néhány módszer a törlés kezelésére:

    - **nem engedélyezzük a törlést**: Ha hivatkoznak a törlendő rekordra, az adatbázis hibával tér vissza (ahogy fent is láthattuk).
    - **kaszkád törlés** – az idegen kulcs kényszeren beállítható, hogy a hivatkozott rekord törlésekor a hivatkozó rekord is törlődjön. Gyakran ez oda vezet, hogy minden idegen kulcs kényszerünk ilyen lesz, és egy (véletlen) törléssel végigtörölhetjük akár a teljes adatbázist, azaz nehezen jósolható a törlés hatása.
    - **hivatkozás NULL-ozása** – az idegen kulcs kényszeren beállítható, hogy a hivatkozott rekord törlésekor a hivatkozó rekord idegen kulcs mezője `NULL` értékű legyen. Csak akkor alkalmazható, ha a modellünkben az adott idegen kulcs mező `NULL`-ozható.
    - **logikai törlés** (soft delete) – törlés művelet helyett csak egy flag oszlopot (pl. `IsDeleted`) állítunk be. Előnye, hogy nem kell az idegen kulcs kényszerekkel foglalkoznunk, a törölt adat rendelkezésre áll, ha szükség lenne rá (pl. undelete művelet). Ám a működés bonyolódik, mert foglalkozni kell azzal, hogy hogyan és mikor szűrjük a törölt rekordokat (pl. hogy ne jelenjenek meg a felületen, statisztikákban), vagy hogyan kezeljük, ha egy nem törölt rekord töröltre hivatkozik.

## Kitekintés

A fenti ADO.NET alapműveleteket ebben az itt látott alapformában ritkán használják két okból kifolyóan (még akkor is, ha ez a megközelítés adja a legjobb teljesítményt):

- Gyenge típusosság (egy rekord adatait beolvasni egy osztály property-jeibe igen körülményes, cast-olni kell stb.)
- Stringbe kódolt SQL (az elgépelésből eredő hibák csak futási időben derülnek ki)
  
Az előbbire megoldást jelenthetnek a különböző ADO.NET-et kiegészítő komponensek, pl.:

- [Dapper](https://github.com/DapperLib/Dapper)
- [PetaPoco](https://github.com/CollaboratingPlatypus/PetaPoco)

Ezek a megoldások egy minimális teljesítményveszteségért cserébe nagyobb kényelmet kínálnak.

Mindkét problémára megoldást jelentenek az ORM (Object-Relational-Mapping) rendszerek, cserébe ezek nagyobb overheaddel járnak, mint az előbb említett megoldások. Az ORM-ek leképezést alakítanak ki az adatbázis és az OO osztályaink között, és ennek a leképezésnek a segítségével egyszerűsítik az adatbázis műveleteket. Az osztályainkon végzett, típusos kóddal leírt műveleteinket automatikusan átfordítják a megfelelő adatbázis műveletekre, így a memóriabeli objektummodellünket szinkronban tartják az adatbázissal. Az ORM-ek ebből következően kapcsolat nélküli modellt használnak. Ismertebb .NET-es ORM-ek:

- ADO.NET DataSet – elsőgenerációs ORM, ma már nagyon ritkán használjuk.
- Entity Framework 6.x – (régi) .NET Framework leggyakrabban használt ORM keretrendszere
- [Entity Framework Core](https://learn.microsoft.com/en-us/ef/core/) (EF Core) – a jelenleg elsődlegesen használt .NET ORM (open source)
- [NHibernate](https://nhibernate.info/) – a java-s Hibernate .NET-es portja (open source)

Az Entity Framework Core-ral részletesebben foglalkozunk az *Adatvezérelt rendszerek* specializáció tárgyban illetve a *Szofverfejlesztés .NET platformon* választható tárgyban.
