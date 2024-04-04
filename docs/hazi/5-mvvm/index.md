---
authors: tibitoth
---

# 5. HF - MVVM mintára épülő alkalmazások

## Bevezetés

A házi feladatban a laboron elkezdett recept alkalmazást fogjuk tovább bővíteni az MVVM mintát használva.

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

:exclamation: [Bár az alapok hasonlók](../hf-folyamat/index.md), vannak lényeges, a folyamatra és követelményekre vonatkozó eltérések a korábbi házi feladatokhoz képest, így mindenképpen figyelmesen olvasd el a következőket.

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
Ez egy `NavigationView`-t tartalmaz (aka. Hamburger menü), ami a navigációt fogja esetünkben kezelni.
Tartalmazhat `NavigationViewItem`-eket, amik a menüpontokat reprezentálják, és mindig elérhetőek az alkalmazásban.
A menüpontokra kattintva a `Frame`-en belül a megfelelő oldal jelenik meg a projektben található segédosztályok segítségével, ami támogatja a vissza navigációt is.

## 1. Feladat - Receptek kedvencként kezelése

Feladatunk funkcionális követelményei a következőek:

- A recepteket kedvencek közé lehessen menteni
    - Jelenlen meg egy kitöltetlen csillag ikon a recept részletes oldalon (pl. bal oldali oszlop tetején), amelyre kattintva a receptet a kedvencek közé menthetjük
    - A kedvenc kezelő gomb állapota váltson tele csillagra, ha a recept kedvencnek lett jelölve, amit megnyomva kivehető a kedvencek közül a recept és a gomb állapota visszaáll üres csillagra
    - A kedvenc receptek listáját lokálisan tároljuk, az alkalmazás bezárásával ne vesszenek el

        === "Add To Favorites"
            ![Add To Favorites](images/add_to_favorites.png)

        === "Remove From Favorites"
            ![Remove From Favorites](images/remove_from_favorites.png)

- A kedvencek listáját jelenítsük meg egy külön oldalon.
    - A kedvencek listát a hamburger menüből lehessen elérni
    - A listában lévő elemek kinézete hasonló legyen a receptek listájában lévő elemekhez
    - A lista ne legyen csoportosítva
    - A kedvencek listájának elemei között a recepteket kattintva megnyithatjuk a recept részletes oldalát

        ![Favorites Page](images/favorites_page.png)

### 1.1 Kedvencek kezelése a szolgáltatás rétegben

Bottom-up megvalósítási sorrendben haladva készítsük el először a szolgáltatás rétegben a kedvencek kezeléséhez szükséges funkciókat.

Tárolnunk kell a kedvenc recepteket perzisztensen. Ehhez a kiinduló projektben elő van készítve az `ILocalSettingsService` interfész, amellyel kulcs érték párokat tudunk JSON sorosítva tárolni lokálisan az alkalmazásban.

```csharp
public interface ILocalSettingsService
{
    Task<T> ReadSettingAsync<T>(string key);
    Task SaveSettingAsync<T>(string key, T value);
}
```

Használata során érdemes odafigyelni arra, hogy a függvények generikusak, így a típusokat explicit meg kell(het) adni a hívás során.

Szintén fontos, hogy a függvények `Task`-kal térnek vissza, tehát aszinkronok, így `await` kulcsszóval kell hívni őket, és a hívó függvénynek is aszinkronnak kell lennie.

A kedvencek kezelése az `IRecipeService` feladata legyen, és Dependency Injection segítségével érjük el, hogy a `RecipeService`-nek legyen egy `ILocalSettingsService`-re mutató referenciája.

??? success "RecipeService váza"

    A `RecipeService`-nek (és interfésznek) a következő új funkciókkal kell rendelkeznie:

    1. Recept kedvenc állapotának módosítása id-val és az új állapottal. (részletes oldalon gombra kattintás)
         1. Kérdezzük le az `ILocalSettingsService`-ből kedvencek listáját. Mivel nem elvárás az offline működés, elég csak a receptek azonosítóit kezelni a kedvencek listájában, a lekérdezéskor pedig tudunk majd a REST API-hoz nyúlni.
         2. Lista módosítása a kapott id és új kedvenc állapot alapján
             1. Kedvencnek jelölés esetén, berakjuk, egyébként töröljük.
             2. Gondoljunk arra is, ha a lista már tartalmazza az adott id-t, akkor ne adjuk hozzá újra. (Ehhez egyébként lehet használni egy speciális halmaz tulajdonságú kollekciót is a `HashSet<T>`-et, ami egy elemet csak egyszer tartalmaz.)
    
    2. Kedvenc receptek lekérdezése. (kedvencek oldal listázás)
         1. Kérdezzük le az `ILocalSettingsService`-ből a kedvenc receptek listáját
         2. A kapott id-k alapján kérjük le a recepteket a REST API-tól, a `GET /api/Recipes/{id}/Header` végponton keresztül, ami a laborhoz képest egy új végpont, és az adott azonosítójú recept `RecipeHeader`-be sorosított adataival tér vissza. Ehhez a végponthoz érdemes új segédfüggvényt is készíteni.
         3. A lekérdezett `RecipeHeader` objektumokból összeállított listával térjünk vissza.
    
    3. Recept kedvenc állapotának lekérdezése id alapján. (részletes oldal betöltésekor gomb állapotának lekérdezése)
         1. Igaz hamis értékkel térjünk vissza, attól függően, hogy az adott azonosító szerepel-e a kedvenc receptek listájában.

    !!! warning "Első hívás"
        Gondolni kell arra is, ha még most hívjuk meg először a lekérdező függvényt, és nincs még mentett kedvenc recept listánk (`null`-lal tér vissza az adott kulcsú elem).

### 1.2 Kedvencnek jelölés a részletes oldalon

A recept részlete oldalon (a `RecipeDetailPage`-en) meg kell jeleníteni egy gombot, aminek 2 állapota van:

1. Ha a recept nincs kedvencnek jelölve, akkor egy üres csillag ikon jelenik meg a gombon a gomb felirata pedig legyen *"Add to Favorites"*
2. Ha a recept kedvencnek van jelölve, akkor egy kitöltött csillag ikon jelenik meg a gombon a gomb felirata pedig legyen *"Remove from Favorites"*

=== "Add To Favorites"
    ![Add To Favorites](images/add_to_favorites.png)

=== "Remove From Favorites"
    ![Remove From Favorites](images/remove_from_favorites.png)

Ezt az igaz-hamis állapotot és módosító műveletet célszerű a `RecipeDetailPageViewModel`-ban tárolni (mivel a ViewModelnek definíció szerint ez a feladata), majd  adatkötéssel kötni a gomb kinézetéhez és commandjához.

??? success "RecipeDetailPageViewModel módosítása"

    A `RecipeDetailViewModel`-t módosítani szükésges a következőkkel:

    1. Kedvenc állapot tárolása
        1. Az állapotot egy `bool` típusú property-ben tároljuk
        2. Az állapotot az `IRecipeService`-ből lekérdezve inicializáljuk az oldalra való navigáláskor
    2. Új command függvény készítése, amely a kedvenc állapotot módosítja az `IRecipeService` segítségével

    !!! note "Állapot tárolása a modellben"
        A kedvenc állapotot a `RecipeHeader` modellben is tárolhatnánk, viszont az két másik problémát is generálna: a modellnek kell megvalósítania az `INotifyPropertyChanged` interfészt, hogy az állapot változását jelezni tudja, illetve az új property értékét valamelyik másik rétegben (ViewModel vagy Service) tölteni kellene, mivel ez az infó csak lokálisan érhető el, a `RecipeHeader` pedig alapvetően most csak egy DTO (Data Transfer Object) a modell rétegben.

??? success "RecipeDetailPage módosítása"

    A `RecipeDetailPage`-en a következőket kell módosítani:

    1. Új gomb hozzáadása az oldal tetejére, tartalma legyen egy `SymbolIcon` és egy `TextBlock` egymás mellett
          1. A `SymbolIcon`-nak a `Symbol` tulajdonságához használjuk a `Symbol.SolidStar` és `Symbol.OutlineStar` enum értékeket a csillag ikonokhoz
    2. A gomb commandját adatkötni kell a ViewModel-ben található command-hoz

    A ViewModel-ben tárolt `bool` értéket valamilyen módon `Symbol` enumra és `string`-re kell konvertálni, hogy a felületen megfelelő adatok jelenjenek meg. Erre több megoldás is lehetséges

    - Az `IValueConverter` interfész implementálása és használata az adatkötés során
    - `x:Bind` használata, ahol nem property-t kötünk, hanem egy a xaml.cs-ben lévő segédfüggvényt, ami a konverziót elvégzi
    - A `RecipeDetailPageViewModel`-ben tároljuk a nézethez szükséges adatokat, és azokat a megfelelő formátumban állítjuk elő. 
        - Talán ez a legegyszerűbb megoldás, ha nem szeretnénk külön konvertert írni vagy az adatkötéseket bonyolítani, viszont a legkevésbé is lesz karbantartható, mivel a ViewModel view specifikus adatokat is tartalmaz, amiket külön karban is kell tartani ha a bool property megváltozik.

!!! example "1.2. feladat BEADANDÓ"
    Illessz be egy képernyőképet az alkalmazásról, ahol a teendő részletes oldalon megjelenik a kedvencnek jelölés gomb! (`f1.2.1.png`)

    Illessz be egy képernyőképet az alkalmazásról, ahol a teendő részletes oldalon egy már kedvencnek jelölt recepthez a kedvencekből eltávolítás gomb jelenik meg! (`f1.2.2.png`)

### 1.3 Kedvencek oldal navigáció

A kedvencek oldalra navigáláshoz több lépésre is szükségünk lesz, amik a kiinduló projekt sajátosságaiból adódódnak, de ezeket itt részletesen átvesszük.

1. Hozzuk létre a `FavoritesPage`-et a `Views` mappában

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

2. Hozzuk létre a `FavoritesPageViewModel`-t a `ViewModels` mappában
3. Regisztráljuk be az `App.xaml.cs`-ben a Dependency Injection konténerbe nézetet és VM-et:

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

A kedvencek oldal a `MainPage` mintájára készüljön el, és a receptek listáját jelenítse meg, csoportosítás nélkül egy `AdaptiveGridView` vezérlőben.

![Favorites Page](images/favorites_page.png)

A ViewModel a `MainPageViewModel` mintájára készüljön el, és a navigáció során kérdezze le az `IRecipeService`-től a kedvenc receptek listáját (`GetFavoriteRecipesAsync`) és tárolja el.

!!! example "1.4. feladat BEADANDÓ"
    Illessz be egy képernyőképet az alkalmazásról, ahol kedvencek lista látható! (`f1.4.png`)

## Beadás

Ellenőrzőlista ismétlésképpen:

--8<-- "docs/hazi/beadas-ellenorzes/index.md:3"