# 5. Adatkezelés

Utolsó módosítás ideje: 2022.10.31  
Kidolgozta: Kaszó Márk, Simon Gábor

## A gyakorlat célja

A gyakorlat célja az ADO.NET programozási modelljének megismerése és a leggyakoribb adatkezelési problémák, buktatók szemléltetése alapvető CRUD műveletek megírásán keresztül.

Kapcsolódó előadások: Adatkezelés, ADO.NET alapismeretek.

## Előfeltételek

A gyakorlat elvégzéséhez szükséges eszközök:

- Visual Studio 2022
- Windows 10 vagy Windows 11 operációs rendszer (Linux és macOS nem alkalmas)
- A gyakorlat során az *SQL Server Object Explorer*-t fogjuk használni az adatbázis objektumok közötti navigálására és a lekérdezések futtatására. Ehhez szükség lehet az *SQL Server Data Tools* komponensre, melyet legegyszerűbben az *Individual Components* oldalon tudunk telepíteni a Visual Studio Installer-ben.

## Bevezető

!!! note "Megjegyzés gyakorlatvezetőknek"
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
    A kapcsolatalapú modellel ellentétben az adatok megjelenítése és memóriában történő módosítása során nem tartunk fent adatbázis kapcsolatot. Ennek megfelelően a főbb lépések a következők: a kapcsolat felvételét és az adatok lekérdezését követően azonnal bontjuk a kapcsolatot. Az adatokat ezt követően tipikusan megjelenítjük és lehetőséget biztosítunk a felhasználónak az adatok módosítására (rekordok felvétele, módosítása, törlése igény szerint). A módosítások mentése során újra felvesszük az adatkapcsolatot, mentjük az adatbázisba a változtatásokat és zárjuk a kapcsolatot. Természetesen a modell megköveteli, hogy a lekérdezése és a módosítások visszaírása között – amikor nincs kapcsolatunk az adatbázissal – az adatokat és a változtatásokat a memóriában nyilvántartsuk. Erre az ADO.NET környezetben nagyon kényelmes megoldást nyújt a DataSet objektumok alkalmazása.

    A modell előnyei:

    - Nem szükséges folyamatos hálózati kapcsolat
    - Skálázhatóság

    Hátrányok

    - Az adatok nem mindig a legfrissebbek
    - Ütközések lehetségesek
      
    Megjegyzés: Számos lehetőségünk van arra, hogy az objektumokat és kapcsolódó változásokat nyilvántartsuk a memóriában. A DataSet csak az egyik lehetséges technika. De használhatunk erre a célra közönséges objektumokat, illetve ezek menedzselését megkönnyítő ADO.NET-nél korszerűbb .NET technológiákat (pl. Entity Framework).

### A kapcsolatalapú modell

A mérés keretében a kapcsolatalapú modellt ismerjük meg.

Az alapfolyamat a következő:

1. Kapcsolat létrehozása az alkalmazás illetve az adatbázis kezelő rendszer között (`Connection` objektum felhasználásával)
2. A futtatandó SQL utasítás összeállítás (`Command` objektum felhasználásával)
3. Utasítás futtatása (`Command` objektum felhasználásával)
4. Lekérdezések esetén a visszakapott rekordhalmaz feldolgozása (`DataReader` objektum felhasználásával). Erre a módosító parancsok esetén értelemszerűen nincs szükség.
5. Kapcsolat lezárása

Mint a fentiekből kiderül, az adatbázissal való kommunikációnak ebben a modellben három fő összetevője van:

- Connection
- Command
- Data Reader

Ezek az összetevők egy-egy osztályként jelennek meg, adatbáziskezelőfüggetlen részük a *System.Data.dll*-ben található `DbConnection`, `DbCommand`, illetve `DbDataReader` néven. Ezek absztrakt osztályok, az adatbáziskezelők gyártóinak feladata, hogy ezekből leszármazva megírják a konkrét adatbáziskezelőket támogató változatokat. A Microsoftt SQL Servert támogató változatok szintén a *System.Data.dll*-ben, „Sql” prefixű osztályokban találhatók (`SqlConnection`, `SqlCommand` és `SqlDataReader`).
A többi gyártó külön dll-(ek)be teszi a saját változatát, az így létrejött komponenst data providernek nevezik. Található még a *System.Data.dll*-ben Oracle adatbáziskezelőt támogató provider is, azonban ez már elavult. Néhány további gyártó ADO.NET adatbázis providere a teljesség igénye nélkül: ODP.NET (Oracle), MySqlConnector/Net (MySQL), Npgsql (PostgreSQL), System.Data.SQLite (SQLite)

Mindhárom ADO.NET összetevő támogatja a *Dispose* mintát, így using blokkban használható – használjuk is így, amikor csak tudjuk. Az adatbáziskezelő általában másik gépen található, mint ahol a kódunk fut (a mérés során pont nem :)), így tekintsünk ezekre, mint távoli hálózati erőforrásokra.

#### Connection

Ez teremti meg a kapcsolatot a programunk, illetve az adatbáziskezelő-rendszer között
Inicializálásához szükség van egy connection string-re, ami a kapcsolat felépítéséhez szükséges adatokat adja meg a driver számára. Adatbázisgyártónként eltérő belső formátuma van (bővebben: http://www.connectionstrings.com).

Új `Connection` példányosításakor nem biztos, hogy tényleg új kapcsolat fog létrejönni az adatbázis felé, a driverek általában connection pooling-ot alkalmaznak, hasonlóan, mint a thread pool esetében, újrahasználhatják a korábbi (éppen nem használt) kapcsolatokat.

#### Command

Ennek segítségével vagyunk képesek „utasításokat” megfogalmazni az adatbázis kezelő számára. Ezeket SQL nyelven kell megfogalmaznunk.
A `Command`-nak be kell állítani egy kapcsolatot – ezen keresztül fog a parancs végrehajtódni. A parancsnak különböző eredménye lehet, ennek megfelelően különböző függvényekkel sütjük el a parancsot:

- **ExecuteReader**: Eredményhalmaz (result set) lekérdezése
- **ExecuteScalar**: Skalár érték lekérdezése
- **ExecuteNonQuery**: Nincs visszatérési érték (Pl: INSERT), viszont a művelet következtében érintett rekordok számát visszakapjuk

#### Data Reader

Ha a parancs eredménye eredményhalmaz, akkor ennek a komponensnek a segítségével tudjuk az adatokat kiolvasni. Az eredményhalmaz egy táblázatnak tekinthető, a Data Reader ezen tud kurzoros módszerrel soronként végignavigálni (csak előrefelé!). A kurzor egyszerre egy soron áll, ha a sorból a szükséges adatokat kiolvastuk, a kurzort egy sorral előre léptethetjük. Csak az aktuális sorból tudunk olvasni. Kezdetben a kurzor nem az első soron áll, azt egyszer léptetnünk kell, hogy az első sorra álljon.

Megjegyzés: navigálás kliens oldalon történik a memóriában, nincs köze az egyes adatkezelők által támogatott kiszolgáló oldali kurzorokhoz.

## 1. Feladat – Adatbázis előkészítése

Elsőként szükségünk van egy adatbáziskezelőre. Ezt valós környezetben dedikált szerveren futó, adatbázis adminisztrátorok által felügyelt, teljesértékű adatbáziskezelők jelentik. Fejlesztési időben, lokális teszteléshez azonban kényelmesebb fejlesztői adatbáziskezelő használata.
A Visual Studio telepítésének részeként kapunk is egy ilyen adatbázis engine-t, ez a LocalDB, ami a teljesértékű SQL Server egyszerűsített változata. Főbb tulajdonságai:

- nem csak a Visual Studio-val, hanem külön is telepíthető
- az adatbázismotor szinte teljes mértékben kompatibilis a teljesértékű Microsoft SQL Serverrel
- alapvetően arról a gépről érhető el, amire telepítettük
- több példány is létrehozható igény szerint, a példányok alapvetően a létrehozó operációs rendszer felhasználója számára érhető el (igény esetén megosztható egy példány a felhasználók között)
- a saját példányok kezelése (létrehozás, törlés, stb.) nem igényel adminisztrátori jogokat
  
!!! note "ssqllocaldb parancssori eszköz"
    Érdekesség, (ezeket a gyakorlaton nem kell elmondani), csak a lehetőséget említsük meg. A példányok kezelésére az sqllocaldb parancssori eszköz használható.  Néhány parancs, melyet az sqllocaldb után beírva alkalmazhatunk :

    |Paracs|Leírás|
    |-------------|--------------|
    |info|az aktuális felhasznááló számára látható példányok listája|
    |create „locdb”|„locdb” nevű példány törlése|
    |start „locdb”|„locdb” nevű példány indítása|
    |stop „locdb”|„locdb” nevű példány leállítása|

A Visual Studio is vesz fel, illetve indít LocalDB példányokat, ezért érdemes megnézni, hogy a Visual Studio alapból milyen példányokat lát.

1. Indítsuk el a Visual Studio-t, a View menüből válasszuk az SQL Server Object Explorer-t (SSOE).
2. Nyissuk ki az SQL Server csomópontot, ha alatta látunk további csomópontokat, akkor nyert ügyünk van, nyissuk ki valamelyiket (ilyenkor indul el a példány, ha nincs elindítva, így lehet, hogy várni kell kicsit)
3. Ha nem jelent meg semmi, akkor parancssorból az `mssqllocaldb info` parancs megadja a létező példányokat. Válasszuk az SQL Server csomóponton jobbklikkelve az *Add SQL Server* opciót, majd adjuk meg valamelyik létező példányt, pl.: *(localdb)\MSSQLLocalDB*
4. A megjelenő *Databases* csomóponton válasszuk a *New Database* opciót, itt adjunk meg egy adatbázisnevet. (Laboron, mivel több hallgató is használhatja ugyanazt az operációs rendszer felhasználót, így javasolt a neptunkód mint név használata.)
5. Az új adatbázis csomópontján jobbklikkelve válasszuk a *New Query* opciót, ami egy új query ablakot nyit
6. A tárgyhonlapról nyissuk meg vagy töltsük le a *Northwind* adatbázis inicializáló szkriptet (a publikus anyagok között található, [„Northwind példaadatbázis”](https://www.aut.bme.hu/Upload/Course/ujgen/publikus_anyagok/instnwndEx.sql) néven)
7. Másoljuk be a teljes szkriptet a query ablakba
8. A szkript elején a megadott helyen írjuk be az adatbázisunk nevét
9. Futtassuk le a szkriptet a kis zöld nyíllal (*Execute*)
10. Ellenőrizzük, hogy az adatbázisunk ban megjelentek-e táblák, nézetek
11. Fedezzük fel az SSOE legfontosabb funkcióit (táblák adatainak, sémájának lekérdezése stb.)

!!! Note
    A Visual Studio-ban két eszközzel is kezelhetünk adatbázisokat: a Server Explorer-rel és az SQL Server Object Explorer-rel is. Előbbi egy általánosabb eszköz, mely nem csak adatbázis, hanem egyéb szerver erőforrások (pl. Azure szerverek) kezelésére is alkalmas, míg a másik kifejezetten csak adatbáziskezelésre van kihegyezve. Mindkettő elérhető a View menüből és mindkettő hasonló funkciókat ad adatbáziskezeléshez, ezért ebben a mérésben csak az egyiket (SQL Server Object Explorer) használjuk.

    Amikor nem áll rendelkezésünkre a Visual Studio fejlesztőkörnyezet, akkor az adatbázisunk menedzselésére az (ingyenes) SQL Server Management Studio-t tudjuk használni.

## 2. Feladat – Lekérdezés ADO.NET SqlDataReader-rel

COMING SOON

## 3. Feladat – Beszúrás SQL utasítással

COMING SOON

## 4. Feladat - Módosítás tárolt eljárással

COMING SOON

## 5. Feladat - SQL Injection

COMING SOON

## 6. Feladat - Törlés

COMING SOON

## Kitekintés

COMING SOON

## Függelék – Adatbázisok, SQL nyelv alapok

Az adatbáziskezelő rendszerek világába és az SQL nyelvbe betekintést a kapcsolódó előadáson, illetve az alábbi hivatkozás alatt találsz: [Adatbázisok, SQL nyelv alapok](adatbazisok-sql-alapok/index.md)