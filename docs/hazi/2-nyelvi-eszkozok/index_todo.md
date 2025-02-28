
Az első sorban "----" felett található a fejléc. Alatta az egye személyekhez egy-egy "Person" beégetett szöveg, majd a "----" alatt a lábléc, egyelőre csak egy beégetett "Footer" szöveggel.

A megoldásban látható, hogy a fejléc szövege a `ReportPrinter` osztályba nincs beégetve. Ezt `ReportPrinter` felhasználója adja meg konstruktor paraméterben egy delegate, esetünkben egy lambda kifejezés formájában. A delegate típusa a .NET beépített `Action` típusa.

A feladatok a következők:

!!! warning
    A megoldás során NEM használhatsz saját delegate típust (a .NET beépített delegate típusaival dolgozz, a megoldás csak ekkor elfogadható).

1. Alakítsd át a `ReportPrinter` osztályt úgy, hogy az osztály használója ne csak a fejlécet, hanem a láblécet is meg tudja adni egy delegate formájában a konstruktorban.
   
2. Alakítsd tovább a `ReportPrinter` osztályt úgy, hogy az egyes személyek kiírásakor ne a fix "Person" szöveg jelenjen meg, hanem a `ReportPrinter` osztály használója tudja az egyes személyek adatait az igényeinek megfelelően kiírni a konzolra egy konstruktorban megadott delegate segítségével (a fix "Person" helyett). Lényeges, hogy a sorszám a sor elején mindig meg kell jelenjen, ez nem lehet a `ReportPrinter` használója által megváltoztatható (vagyis ezt a továbbiakban is a `ReportPrinter` osztálynak kell kiírnia)!
   
    !!! tip "Tipp a megoldáshoz"
        Hasonló megközelítésben gondolkozz, mint a fejléc és lábléc esetében, de itt ehhez a `ReportPrinter` felhasználójának meg kell kapnia a személy objektumot ahhoz, hogy azt formázottan ki tudja írni a konzolra.

3. A `Program.cs` fájlban a `ReportPrinter` használatát alakítsd úgy (megfelelő lambda kifejezések megadásával), hogy a kimenet a konzolon a következő legyen:

    ```
    Employees
    -----------------------------------------
    1. Name: Joe (Age: 20)
    2. Name: Jill (Age: 30)
    --------------- Summary -----------------
    Number of Employees: 2
    ```
    
    !!! tip "Láblécben a dolgozók számának kiírása"
        Ahhoz, hogy a láblécben a dolgozók számának kiírását elegáns módon meg tudd tenni, szükség van a "variable capturing" témakör ismeretére (lásd 3. előadás "Variable capturing, closure" fejezet).

    !!! warning "Házi feladat ellenőrzése"
        A "Feladat 6" feladatot, vagyis azt, hogy a `ReportPrinter`-t és annak használatát jól alakítottad-e át, a GitHub-os automata ellenőrző NEM ellenőrzi. Teszteld a megoldásod alaposan, hogy ne csak a határidő után utólag, a házi feladatok manuális ellenőrzése során derüljön ki, hogy a megoldás nem elfogadható.
        (Kiegészítés: 2024.03.13 reggeltől kezdve már erre is van részleges automata ellenőrzés)

4. A következő feladat opcionális, a beépített `Func` delegate-ek gyakorlására ad jó lehetőséget. A `ReportPrinter` osztálynak van egy komolyabb hátránya: a kimeneti riportot csak a konzolon tudjuk a segítségével megjeleníteni. Rugalmasabb megoldás lenne, ha nem írna a konzolra, hanem egy string formájában lehetne a segítségével a riportot előállítani. Ezt a stringet már úgy használhatnánk fel, ahogy csak szeretnénk (pl. írhatnánk fájlba is).
   
    A feladat a következő: vezess be egy `ReportBuilder` osztályt a már meglévő `ReportPrinter` mintájára, de ez ne a konzolra írjon, hanem egy a teljes riportot tartalmazó stringet állítson elő, melyet egy újonnan bevezetett, `GetResult()` művelettel lehessen tőle lekérdezni. 

    !!! warning "Beadás"
        Ha beadod a feladatot, a `ReportBuilder`-t példányosító/tesztelő kódot ne a fenti, `test6` függvénybe tedd, hanem vezess be egy `test6b` nevű függvényt, és lásd el a `[Description("Task6b")]` attribútummal.
   
    !!! tip "Tippek a megoldáshoz"
        * Célszerű az osztályba egy `StringBuilder` tagváltozót bevezetni, és ennek segítségével dolgozni. Ez nagyságrenddel hatékonyabb, mint a stringek "+"-szal való összefűzögetése.
        * A `ReportBuilder` osztály használója itt már ne a konzolra írjon, hanem megfelelő beépített típusú delegate-ek (itt az `Action` nem lesz megfelelő) segítségével adja vissza a `ReportBuilder` számára azokat a stringeket, melyeket bele kell fűznie a kimenetbe. A tesztelés során most is lambda kifejezéseket használj!
