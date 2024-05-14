---
authors: tibitoth
---

# 5b. HF - MVVM mintára épülő alkalmazások (opcionális)

## Bevezetés

A házi feladatban a laboron elkezdett recept alkalmazást fogjuk tovább bővíteni az MVVM mintát használva.

A megvalósításért 3 IMSc pont szerezhető.

Az önálló feladat az MVVM előadásokon elhangzottakra épít. A feladatok gyakorlati hátteréül a [5. labor – MVVM](../../labor/5-mvvm/index.md) laborgyakorlat szolgál.

A fentiekre építve, jelen önálló gyakorlat feladatai a feladatleírást követő rövidebb iránymutatás segítségével (néha alapértelmezetten összecsukva) önállóan elvégezhetők.

Az önálló gyakorlat célja:

- MVVM minta használatának gyakorlása
- Adatok megjelenítése és interakciók kezelése a felületen adatkötéssel
- Dependency Injection minta alkalmazása
- Adatok kezelése a szolgáltatás rétegben HTTP kéréseken illetve egy lokális adattár segítségével

A szükséges fejlesztőkörnyezetről [itt](../fejlesztokornyezet/index.md) található leírás.

!!! warning "Fejlesztőkörnyezet WinUI3 fejlesztéshez"
    A korábbi laborokhoz hasonlóan plusz komponensek telepítése szükséges. A [fenti](../fejlesztokornyezet/index.md) oldal említi, hogy szükség van a ".NET desktop development" Visual Studio Workload telepítésére, valamint ugyanitt az oldal alján van egy "WinUI támogatás" fejezet, az itt megadott lépéseket is mindenképpen meg kell tenni!

## A beadás menete

- Az alapfolyamat megegyezik a korábbiakkal. GitHub Classroom segítségével hozz létre magadnak egy repository-t. A meghívó URL-t Moodle-ben találod (a tárgy nyitóoldalán a "*GitHub classroom hivatkozások a házi feladatokhoz*" hivatkozásra kattintva megjelenő oldalon látható). Fontos, hogy a megfelelő, ezen házi feladathoz tartozó meghívó URL-t használd (minden házi feladathoz más URL tartozik). Klónozd le az így elkészült repository-t. Ez tartalmazni fogja a megoldás elvárt szerkezetét. A feladatok elkészítése után commit-old és push-old a megoldásod.
- A kiklónozott fájlok között a `MvvmLab.sln`-t megnyitva kell dolgozni.
- :exclamation: A feladatok kérik, hogy készíts **képernyőképet** a megoldás egy-egy részéről, mert ezzel bizonyítod, hogy a megoldásod saját magad készítetted. **A képernyőképek elvárt tartalmát a feladat minden esetben pontosan megnevezi.**
A képernyőképeket a megoldás részeként kell beadni, a repository-d gyökérmappájába tedd (a neptun.txt mellé).
A képernyőképek így felkerülnek GitHub-ra a git repository tartalmával együtt.
Mivel a repository privát, azt az oktatókon kívül más nem látja.
Amennyiben olyan tartalom kerül a képernyőképre, amit nem szeretnél feltölteni, kitakarhatod a képről.
- :exclamation: Ehhez a feladathoz érdemi előellenőrző nem tartozik: minden push után lefut ugyan, de csak a neptun.txt kitöltöttségét ellenőrzi. Az érdemi ellenőrzést a határidő lejárta után a laborvezetők teszik majd meg.

## Kikötések

:warning: __MVVM minta kötelező alkalmazása!__  
  Jelen házi feladatban az MVVM mintát gyakoroljuk, így a feladatok megoldásában kötelező az MVVM minta alkalmazása. Az ettől való eltérés a feladatok értékelésének elutasítását vonja maga után.

## Kiinduló állapot

A kiinduló állapot épít az 5. labor végállapotára, de ahhoz képest egy lényeges változtatást tartalmaz.

Az alkalmazás az indulása után létrehoz egy `ShellPage` típusú oldalt, ami a projektben a `Views` mappában található meg.
Ez egy `NavigationView`-t tartalmaz (aka. Hamburger menü), mely a navigációt fogja esetünkben kezelni.
Tartalmazhat `NavigationViewItem`-eket, melyek a menüpontokat reprezentálják, és mindig elérhetőek az alkalmazásban.
A menüpontokra kattintva a `Frame`-en belül a megfelelő oldal jelenik meg a projektben található segédosztályok segítségével, ami támogatja a korábbi oldalra történő vissza navigációt is.

## 1. Feladat - Receptek kedvencként kezelése

Feladatunk funkcionális követelményei a következőek:

- A recepteket kedvencek közé lehessen menteni
    - Jelenjen meg egy kitöltetlen csillag ikonnal rendelkező gomb a recept részletes oldalon (pl. bal oldali oszlop tetején), amelyre kattintva a receptet a kedvencek közé menthetjük.
    - A kedvenc kezelő gomb ikonja váltson tele csillagra, a szövege pedig *"Remove from Favorites"*-re, ha a recept kedvencnek lett jelölve.
    - A korábban kedvencnek jelölt recept kivehető a kedvencek közül ugyanezen a gombon történő kattintással: ekkor a gomb ikonja állapota visszaáll üres csillagra, a szövege pedig *"Add to Favorites"*-re.
    - A kedvenc receptek listáját lokálisan tároljuk, az alkalmazás bezárásával ne vesszenek el.

        === "Add To Favorites"
            ![Add To Favorites](images/add_to_favorites.png)

        === "Remove From Favorites"
            ![Remove From Favorites](images/remove_from_favorites.png)

        !!! tip "A két gomb állapot megjelenítése"
            A fenti ábra felett az "Add To Favorites" és "Remove From Favorites"-en kattintva lehet váltani a két állapotot megjelenítő képek között.

- A kedvencek listáját jelenítsük meg egy külön oldalon.
    - A kedvencek listát a hamburger menüből lehessen elérni
    - A listában lévő elemek kinézete hasonló legyen a receptek listájában lévő elemekhez
    - A lista ne legyen csoportosítva
    - A kedvencek listájának elemei között a recepteket kattintva megnyithatjuk a recept részletes oldalát (pont úgy, mint a Recipes oldalon)

        ![Favorites Page](images/favorites_page.png)

### 1.1 Kedvencek kezelése a szolgáltatás rétegben

Bottom-up megvalósítási sorrendben haladva készítsük el először a szolgáltatás rétegben a kedvencek kezeléséhez szükséges funkciókat.

A kedvencnek megjelölést az online szolgáltatás nem támogatja. A megoldás alapelve így a következő lesz:

* Lokálisan perzisztensen eltároljuk a kedvencnek megjelölt receptek **azonosítóit** (annak érdekében, hogy a program újraindulását követően megmaradjon ez az információ).
* A kedvencnek megjelölt receptek részletes adatait (cím, kép) az online szolgáltatástól kérdezzük le (az azonosítóik alapján).

Lokális perzisztens adattároláshoz a kiinduló projektben elő van készítve az `ILocalSettingsService` interfész (és egy ezt megvalósító implementáció). Erre építve kulcs érték párokat tudunk JSON sorosítva tárolni lokálisan az alkalmazásban.

```csharp
public interface ILocalSettingsService
{
    Task<T> ReadSettingAsync<T>(string key);
    Task SaveSettingAsync<T>(string key, T value);
}
```

Használata során érdemes odafigyelni arra, hogy a függvények generikusak, így a típusokat explicit meg kell(het) adni a hívás során.

A fenti `ILocalSettingsService` segítségével egy adott kulcs alatt fogjuk a kedvenc receptek azonosítóinak listáját eltárolni.

Szintén fontos, hogy a függvények `Task`-kal térnek vissza, tehát aszinkronok, így `await` kulcsszóval kell hívni őket, és a hívó függvénynek is aszinkronnak kell lennie (a részletesebb szabályhalmaz a kapcsolódó "5. MVVM" labor leírásában található).

A kedvencek kezelése a labor során bevezetett `IRecipeService` interfész és az ezt megvalósító `RecipeService` osztály feladata legyen. 

Első lépésben azt kell megoldani, hogy a `RecipeService` számára rendelkezésre álljon egy `ILocalSettingsService` interfészt megvalósító objektum, melyet fel tud használni  megvalósításában a kedvenc receptazonosítók eltárolására és lekérdezésére. A célunk az, hogy `RecipeService`-ben `ILocalSettingsService` interfészként **kapjuk meg** és **tároljuk** ezt az implementációs objektumot, semmiféle függést nem szeretnénk itt bevezetni a konkrét implementációtól. Ezt a laboron már alkalmazott DI konténer segítségével valósítsuk meg.

!!! tip 
    A megvalósítás során a `RecipeService`-ben ahhoz hasonlóan kell kezeljük a `ILocalSettingsService`-t, mint a ahogy a labor során a `MainPageViewModel`-ben kezeltük a `IRecipeService`-t.


Miután a fenti előkészítéssel elkészültél, valósítsd meg a szükséges funkciókat a `RecipeService` osztályban! Az alábbiakban ehhez némi iránymutatást adunk.


??? success "RecipeService váza"

    A `RecipeService`-nek (és interfésznek) a következő új funkciókkal kell rendelkeznie:

    1. Recept kedvenc állapotának módosítása id (int) alapján az új állapottal (bool). (Recept részletes oldalon gombra kattintás során használjuk.)
         1. Kérdezzük le az `ILocalSettingsService`-ből kedvencek azonosítóinak listáját. 
         2. Lista módosítása a kapott id és új kedvenc állapot alapján.
             1. Kedvencnek jelölés esetén, berakjuk, egyébként töröljük.
             2. Gondoljunk arra is, ha a lista már tartalmazza az adott id-t, akkor ne adjuk hozzá újra. (Lista helyett egyébként lehet használni egy speciális halmaz tulajdonságú kollekciót is, a `HashSet<T>`-et, mely egy elemet csak egyszer tartalmaz.)
    
    2. Kedvenc receptek lekérdezése. (Kedvencek oldalon listázás során használjuk.)
         1. Kérdezzük le az `ILocalSettingsService`-ből a kedvenc receptek azonosítóinak listáját.
         2. A kapott id-k alapján egyesével kérjük le a recepteket a REST API-tól, a `GET /api/Recipes/{id}/Header` végponton keresztül. Ez a laborhoz képest egy új végpont, és az adott azonosítójú recept `RecipeHeader`-be sorosított adataival tér vissza. Ehhez a végponthoz érdemes új segédfüggvényt is készíteni. Dolgozhatunk a laboron már bevezetett `RecipeService`-ben levő `HttpClient`-et használó műveletek "mintájára".
         3. A lekérdezett `RecipeHeader` objektumokból összeállított listával térjünk vissza.
    
    3. Recept kedvenc állapotának lekérdezése id alapján. (Recept részletes oldal betöltésekor a gomb állapotának beállításához használjuk.)
         1. Igaz hamis értékkel térjünk vissza, attól függően, hogy az adott azonosító szerepel-e a kedvenc receptek listájában.

    !!! warning "Első hívás"
        Gondolni kell arra is, ha még most hívjuk meg először a lekérdező függvényt, és nincs még mentett kedvenc recept azonosító listánk (`null`-lal tér vissza az adott kulcsú elem lekérdezésekor az `ILocalSettingsService.ReadSettingAsync`).

### 1.2 Kedvencnek jelölés a részletes oldalon

A recept részletes oldalon (a `RecipeDetailPage`-en) meg kell jeleníteni egy gombot, melynek két állapota van:

1. Ha a recept nincs kedvencnek jelölve, akkor egy üres csillag ikon jelenik meg a gombon, a gomb felirata pedig legyen *"Add to Favorites"*.
2. Ha a recept kedvencnek van jelölve, akkor egy kitöltött csillag ikon jelenik meg a gombon, a gomb felirata pedig legyen *"Remove from Favorites"*.

=== "Add To Favorites"
    ![Add To Favorites](images/add_to_favorites.png)

=== "Remove From Favorites"
    ![Remove From Favorites](images/remove_from_favorites.png)

Ezt az igaz-hamis állapotot és módosító műveletet célszerű a `RecipeDetailPageViewModel`-ban tárolni/bevezetni (mivel a ViewModelnek definíció szerint ez a feladata), majd adatkötéssel kötni az állapotot gomb kinézetéhez, illetve a műveletet commandjához. Mindenképpen az MVVM mintát követve dolgozzunk!

??? success "RecipeDetailPageViewModel módosítása"

    A `RecipeDetailViewModel`-t módosítani szükséges a következőkkel:

    1. Kedvenc állapot tárolása
        1. Az állapotot egy `bool` típusú property-ben tároljuk (mindenképpen érdemes az  `[ObservableProperty]` attribútumot használni, működésének és jelentőségének átismétlésével).
        2. Az állapotot az `IRecipeService`-ből lekérdezve inicializáljuk az oldalra való navigáláskor.
    2. Új command függvény készítése, amely 
        1. Elmenti az új kedvenc állapotot az `IRecipeService` segítségével.
        2. Gondoskodik a ViewModel osztályunkban tárolt `bool` kedvenc állapot tulajdonság karbantartásáról.
   
        ??? tip "Tipp a megoldáshoz"
            A megoldás elve hasonlít a SendComment parancsfüggvényhez, de itt a CanExecute-tal nem kell foglalkozzunk, hiszen az új commandunk mindig futtatható.

    !!! note "Állapot tárolása a modellben"
        A kedvenc állapotot a `RecipeHeader` modellben is tárolhatnánk, viszont az két másik problémát is generálna: a modellnek kell megvalósítania az `INotifyPropertyChanged` interfészt, hogy az állapot változását jelezni tudja.  Ezen felül az új property értékét valamelyik másik rétegben (ViewModel vagy Service) kellene kitölteni, mivel ez az infó csak lokálisan érhető el, a `RecipeHeader`pedig alapvetően most csak egy DTO (Data Transfer Object) a modell rétegben.

??? success "RecipeDetailPage (vagyis a View) módosítása"

    A `RecipeDetailPage`-en a következőket kell módosítani:

    1. Új gomb hozzáadása az oldal tetejére, tartalma legyen egy `SymbolIcon` és egy `TextBlock` egymás mellett.
          1. A `SymbolIcon`-nak a `Symbol` tulajdonságához használjuk a `Symbol.SolidStar` és `Symbol.OutlineStar` enum értékeket a csillag ikonokhoz.
    2. A gomb commandját adatkötni kell a ViewModel-ben található command-hoz.

    A ViewModel-ben tárolt `bool` értéket valamilyen módon `Symbol` enumra (gomb ikonja) és `string`-re (gomb aktuális szövege) kell konvertálni, hogy a felületen a gomb megjelenése mindkét állapotban a megfelelő legyen. Erre több megoldás is lehetséges:

    - `x:Bind` használata, ahol nem property-t kötünk, hanem egy a xaml.cs-ben lévő segédfüggvényt, mely a konverziót elvégzi. Vagyis property kötés helyett függvény/funkció kötést használunk. Előadásanyagban a "Property kötése funkciókhoz"-ra érdemes rákeresni, illetve a 3. házi feladatban a "függvény kötés példa"-ra.
    - Az `IValueConverter` interfész implementálása és használata az adatkötés során.
    - A `RecipeDetailPageViewModel`-ben tároljuk a nézethez szükséges adatokat új tuljadonságokat bevezetve (a tulajdonságok típusa a nézet számára szükséges `Symbol` és `string`), és ezekhez történik az adatkötés.
        - Talán ez a legegyszerűbb megoldás, ha nem szeretnénk külön konvertert írni vagy az adatkötéseket "bonyolítani", viszont a legkevésbé is lesz karbantartható, mivel a ViewModel view specifikus adatokat is tartalmaz, melyeket külön karban is kell tartani ha a bool property megváltozik.

!!! example "1.2. feladat BEADANDÓ"
    Illessz be egy képernyőképet az alkalmazásról, ahol a teendő részletes oldalon megjelenik a kedvencnek jelölés gomb! (`f1.2.1.png`)

    Illessz be egy képernyőképet az alkalmazásról, ahol a teendő részletes oldalon egy már kedvencnek jelölt recepthez a kedvencekből eltávolítás gomb jelenik meg! (`f1.2.2.png`)

### 1.3 Kedvencek oldal navigáció

A kedvencek oldalra navigáláshoz több lépésre is szükségünk lesz, melyek a kiinduló projekt sajátosságaiból adódódnak, de ezeket itt részletesen átvesszük (a navigáció megvalósítása nem része a tanagyagnak).

1. Hozzuk létre a `FavoritesPage`-et a `Views` mappában (Add/New Item/Blank Page (WinUI3))

    !!! warning "Fordítási hibák"
        Ha valamiért egzotikus hibákat kapnánk az új oldal felvétele után töröljük ki a projekt fájlból az alábbi sorokat:

        ```xml
        <ItemGroup>
            <None Remove="Views\FavoritesPage.xaml" />
        </ItemGroup>
        ```

        ```xml
        <Page Update="Views\FavoritesPage.xaml">
            <Generator>MSBuild:Compile</Generator>
        </Page>
        ```

2. Hozzuk létre a `FavoritesPageViewModel` osztályt a `ViewModels` mappában
    1. Gondoskodjunk arról, hogy a megfelelő osztályból származzon!
    2. Valósítsa meg az `INavigationAware` interfészt a navigáció támogatásához (egyelőre üres függvénytörzzsel).
3. Regisztráljuk be az `App.xaml.cs`-ben a Dependency Injection konténerbe az új nézetet és az új ViewModelt:

    ```csharp
    services.AddTransient<FavoritesPage>();
    services.AddTransient<FavoritesPageViewModel>();
    ```

4. A `Pages` osztályban (`PageService.cs`) vegyünk fel egy új kulcsot a kedvencek oldalhoz, és konfiguráljuk a navigációt ehhez a kulcshoz:

    ```csharp title="Pages"
    public static string Favorites { get; } = "Favorites";
    ```

    ```csharp title="PageService konstruktor"
    Configure<FavoritesPageViewModel, FavoritesPage>(Pages.Favorites);
    ```

5. A `ShellPage`-en a `NavigationView`-hoz adjunk hozzá egy új `NavigationViewItem`-et a kedvencek oldalhoz:

    ```xml
    <NavigationViewItem helpers:NavigationHelper.NavigateTo="Favorites" Content="Favorites">
        <NavigationViewItem.Icon>
            <SymbolIcon Symbol="SolidStar" />
        </NavigationViewItem.Icon>
    </NavigationViewItem>
    ```

    !!! note "Navigáció"
        A navigáció a `helpers:NavigationHelper.NavigateTo="Favorites"` attached property segítségével történik, ahol azt a kulcsot adhatjuk meg, amilyen kulcsú oldalra navigálni szeretnénk.

### 1.4 Kedvencek oldal logika

A kedvencek oldal (`FavoritesPage`) a `MainPage` mintájára készüljön el, és a receptek listáját jelenítse meg, csoportosítás nélkül (!) egy `AdaptiveGridView` vezérlőben.

![Favorites Page](images/favorites_page.png)

A ViewModel (`FavoritesPageViewModel`) a `MainPageViewModel` mintájára készüljön el, és a navigáció során kérdezze le az `IRecipeService`-től a kedvenc receptek listáját (`GetFavoriteRecipesAsync`) és tárolja el egy megfelelő, pl. generált tulajdonságba. Mivel itt nem csoportosítjuk a recepteket, `RecipeGroup`-ok helyett `RecipeHeader`-ekkel kell dolgozni.

!!! example "1.4. feladat BEADANDÓ"
    Illessz be egy képernyőképet az alkalmazásról, ahol kedvencek lista látható! (`f1.4.png`)

## Beadás

Ellenőrzőlista ismétlésképpen:

--8<-- "docs/hazi/beadas-ellenorzes/index.md:3"