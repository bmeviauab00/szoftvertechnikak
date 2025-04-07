---
authors: tibitoth
---

# 5. MVVM

## A gyakorlat célja

A labor során egy egyszerű alkalmazást fogunk refaktorálni MVVM minta segítségével a jobb átláthatóság és karbantarthatóság jegyében.

## Előfeltételek

A labor elvégzéséhez szükséges eszközök:

* Windows 10 vagy Windows 11 operációs rendszer (Linux és macOS nem alkalmas)
* Visual Studio 2022
    * Windows Desktop Development Workload

## Kiinduló projekt

Klónozzuk le a kiinduló projektet az alábbi paranccsal:

```cmd
git clone https://github.com/bmeviauab00/lab-mvvm-kiindulo
```

??? success "A kész megoldás letöltése"
    :exclamation: Lényeges, hogy a labor során a laborvezetőt követve kell dolgozni, így értelmetlen a kész megoldás letöltése. Ugyanakkor az utólagos önálló gyakorlás során hasznos lehet a kész megoldás áttekintése, így ezt elérhetővé tesszük.

    A megoldás [GitHubon érhető el](https://github.com/bmeviauab00/lab-mvvm-kiindulo/tree/megoldas) a `megoldas` ágon. A legegyszerűbb mód a letöltésére, ha parancssorból a `git clone` utasítással leklónozzuk a gépünkre a `megoldas` ágat:

    `git clone https://github.com/bmeviauab00/lab-mvvm-kiindulo -b megoldas`

## Az MVVM mintáról

Az MVVM (Model-View-ViewModel) egy architekturális tervezési minta, amelyet a XAML alkalmazások fejlesztése során használhatunk, de gyakran más kliens oldali technológiák esetében is megjelenik (pl.: Android, iOS, Angular stb.).
Az MVVM minta célja, hogy a felhasználói felületet és a mögötte lévő logikát szétválassza, és ezzel egy lazább csatolású alkalmazást hozzon létre, ami növeli a tesztelhetőséget, a karbantarthatóságot és az újrafelhasználhatóságot.

Az MVVM minta három (+1) fő részből áll:

* **Model**: Domainspecifikus adatokat fog össze, melyet a ViewModel-ek használhatnak az adatok tárolására. Pl. Recipe/Product/Order osztály, egy recept/termék/megrendelés adatait fogja össze.
* **View**: A felhasználói felület leírását tartalmazza, (és a tisztán a nézetekhez kapcsolódó logikát, pl. animációk kezelését). Tipikusan `Window`, `Page`, `UserControl` leszármazott osztály, XAML-beli deklaratív leírással, a code-behind sokszor üres (mert a logika a ViewModel-ben van).
* **ViewModel**: A nézethez tartozó logika van benne: tartalmazza a nézet állapotát és a nézeten végrehajtható műveleteket. **Független** a nézettől, a laza csatolást a ViewModel és a nézet között adatkötés biztosítja (a nézet vezérlői kötnek a ViewModel tulajdonságaihoz). Unit tesztelhető!
* **Services** (szolgáltatások): Az alkalmazás üzleti/alkalmazás logikáját tartalmazó osztályok, amelyeket a ViewModel-ek használnak. Ha minden üzleti logika a ViewModel-ekben lenne, azok túl bonyolultak és átláthatatlanok lennének. Ez nem az MVVM minta része, de itt említjük meg, mert mi is így fogjuk felépíteni az alkalmazás architektúráját.

<figure markdown>
![MVVM](images/mvvm.drawio.png)
</figure>

:exclamation: Mihez készítünk ViewModel osztályokat?

* Az egyes **nézetekhez** (pl. `Window`, `Page`, `Dialog`, `UserControl`) tipikusan készítünk ViewModel osztályt, és belőle egy nézethez egy objektumot hozunk létre.  Pl. `MainPage`-hez `MainPageViewModel`, `DancerDialog`-hoz `DancerDialogViewModel`. Ezt a gyakorlat során is alkalmazzuk.
* Az egyes **modell** osztályokhoz (pl. `Recipe`, `Product`, `Dancer` stb.) opcionálisan készíthetünk csomagoló ViewModel osztályokat (pl. `RecipeViewModel`, `ProductViewModel`, `DancerViewModel`), ilyeneket a gyakorlat során **nem** fogunk készíteni. Ez azért van, mert nem a Strict, hanem a Relaxed MVVM mintát követjük (lásd előadás).

## 0. Feladat - Kiinduló projekt áttekintése

Az alkalmazásunk egy egyszerű könyveket listázó alkalmazás, ahol a könyvek egy `ItemsView`-ban jelennek meg táblázatos formában.
A lista felett pedig egy `ComboBox` található, amellyel a könyvek szűrhetők műfaj szerint.
A szűrő egy _Clear_ gombbal törölhető.

**Próbáljuk ki!**

<figure markdown>
![Kiinduló felület](images/kiindulo.png)
<figcaption>A kiinduló projekt felülete</figcaption>
</figure>

!!! tip "ComboBox és ItemsView"
    A `ComboBox` és az `ItemsView` is alapvetően listás vezérlők, amiket az `ItemsSource` tulajdonság segítségével tudunk adatokkal feltölteni.

    * A `ComboBox` egy legördülő menü, amely lehetővé teszi a felhasználó számára, hogy kiválasszon egy elemet a listából

    * Az `ItemsView` egy táblázatos megjelenítést biztosít, ahol több elem is látható egyszerre. Az `ItemsView` lehetőséget biztosít több fajta megjelenítési módra, például rácsos vagy listás nézetre is, amit a `Layout` tulajdonsággal állíthatunk be. Különbség az előző laborban használt `ListView`-hoz képest, hogy a lista elem sablonokban mindenképpen egy `ItemContainer` objektumnak kell szerepelnie gyökér elemként.

A kiinduló projektben az alkalmazás logikája a `BooksPage.xaml.cs` fájlban található, a felhasználói felület pedig a `BooksPage.xaml` fájlban.
Ez a megoldás **nem** MVVM mintát követ, így a felhasználói felület és a mögötte lévő logika szorosan összefonódik, szinte már-már spagetti kód jelleget öltve.

Jó példa erre, hogy ebben a fájlban található az adatok betöltése közvetlenül a vezérlők adatait manipulálva.
Az interakciók lekezelése is eseménykezelőkben történik, ami egy idő után átláthatatlanná válik, és keverednek a felelősségi körök.

Esetünkben a példaadatokat a `SeedDatabase` függvény tölti fel, amely a `BooksPage` konstruktorában kerül meghívásra.
A `LoadGenres` és `LoadBooks` függvények pedig a legördülő menü és a táblázat feltöltéséért felelnek.

A legördülő menü aktuális kiválasztásának megváltozását és a _Clear_ gomb megnyomását egy-egy eseménykezelő függvény kezeli le, melyek újratöltik a listát a kiválasztott műfaj szerint (keressük meg ezeket a kódban). 

!!! note "Adatok betöltése ADO.NET-tel SQLite adatbázisból"
    Az alkalmazásban az adatok tárolására SQLite adatbázist használunk, amelyet ADO.NET-tel érünk el. Ezt a technológiát a labor során nem fogjuk részletesen bemutatni, a félév végén fogunk részletesen foglalkozni vele.

!!! note "Page osztály Windows helyett"
    A nézetünk most nem egy `Window`, hanem egy `Page` leszármazott osztály. Mint a neve is utal rá, a `Page` egy "oldalt" reprezentál az alkalmazásban: önmagában nem tud megjelenni, hanem pl. egy ablakon kell elhelyezni. Előnye, hogy az ablakon - megfelelő navigáció kialakításával - lehetőség van oldalak (különböző `Page` leszármazottak) között navigálni. Ezt mi nem fogjuk kihasználni, egyetlen oldalunk lesz csak. Az oldal bevezetésével a célunk mindössze az volt, hogy szemléltessük: az MVVM architektúrában a nézeteket nem csak `Window` (teljes ablak), hanem pl. `Page` objektumokkal (vagy akár más UI komponens pl.: `UserControl`) is meg lehet valósítani.

## 1. Feladat - MVVM minta bevezetése

A labor során a kiinduló projektet MVVM mintára fogjuk átalakítani.

### Model

Építkezzünk most alulról felfelé, így kezdjük a modell osztályunkkal.
A `BooksPage.xaml.cs` fájlban található `Book` osztályt helyezzük át egy új fájlba egy újonnan létrehozott `Models` mappába.

```csharp
namespace Lab.Mvvm.Models;

public class Book
{
    public string Title { get; set; }
    public string Genre { get; set; }
    public string ImageUrl { get; set; }

    // Other properties like Author, ISBN etc.
}
```

A `Book` osztályunk a korábbi `Lab.Mvvm` névtérből a `Lab.Mvvm.Models` névtérbe került. Emiatt - annak érdekében, hogy ne kapjunk emiatt hosszú ideig fordítási hibát - a View-t (`BooksPage.xaml.cs`) már most igazítsuk a névtér változáshoz. Konkrétan, be kell vezessünk egy új névteret (`models`), és az `ItemsView` adatsablon típusának megadásakor ezt kell használjuk:

```xml hl_lines="3 15"
<Page x:Class="Lab.Mvvm.BooksPage"
    // ...
    xmlns:model="using:Lab.Mvvm.Models">

<ItemsView x:Name="booksGridView"
        Grid.Row="2"
        ItemsSource="{x:Bind ViewModel.Books, Mode=OneWay}">
    <ItemsView.Layout>
        <LinedFlowLayout ItemsStretch="Fill"
                        LineHeight="160"
                        LineSpacing="5"
                        MinItemSpacing="5" />
    </ItemsView.Layout>
    <ItemsView.ItemTemplate>
        <DataTemplate x:DataType="model:Book">
            // ...
        </DataTemplate>
    </ItemsView.ItemTemplate>
</ItemsView>
```

### Service

Az adatok betöltéséért felelős kódot helyezzük át egy új `BookService` nevű osztályba, amit egy újonnan létrehozott `Services` mappába helyezzünk el.

* A `BookService` osztályba a `SeedDatabase`, `LoadGenres` és `LoadBooks` függvényeket emeljük át a `BookPage.xaml.cs`-ből

* Mozgassuk át a `_connectionString` mezőt is.

* A függvények láthatóságát állítsuk `public`-ra, hogy a ViewModel osztályunk elérhesse őket.

A `SeedDatabase` függvény így rendben van, de a másik két függvényben több UI elemet is használunk, amiktől meg kell szabaduljunk.

Alakítsuk át a függvényeket, hogy csak a szükséges adatokat adják vissza, és ne közvetlenül a UI elemeket használják. Nevezzük is át őket `GetGenres` és `GetBooks`-ra.

* A `LoadGenres` függvényben egy `List<string>` típusú listát fogunk visszaadni.

* A `LoadBooks` függvényben pedig egy `List<Book>` típusú listát fogunk visszaadni.
Itt arra is gondolnunk kell, hogy korábban a `ComboBox` kiválasztott értékét használtuk a lekérdezéshez, most viszont ezt a paramétert át kell adnunk a függvénynek opcionálisan.

```csharp hl_lines="11 16 20 23 29 34 36 43"
using Lab.Mvvm.Models;
using Microsoft.Data.Sqlite;
using System.Collections.Generic;

namespace Lab.Mvvm.Services;

public class BookService
{
    private readonly string _connectionString = "Data Source=books.db";

    public void SeedDatabase()
    {
        // ...
    }

    public List<string> GetGenres()
    {
        // ...

        return genres;
    }

    public List<Book> GetBooks(string genre = null)
    {
        using var connection = new SqliteConnection(_connectionString);
        connection.Open();

        string query = "SELECT Title, Genre, ImageUrl FROM books";
        if (genre != null)
        {
            query += " WHERE Genre = @genre";
        }
        using var command = new SqliteCommand(query, connection);
        if (genre != null)
        {
            command.Parameters.AddWithValue("@genre", genre);
        }

        List<Book> books = [];
        
        // ...

        return books;
    }
}
```
A fent kiemelt változtatásokon túl

*  a `GetGenres` függvényben a `genreFilterComboBox`-ot és `clearGenreFilterButton`-t manipuláló sorokat is töröljük. 
*  a `BooksPage` osztályban töröljük a fordítási hibát okozó `SeedDatabase`, `LoadGenres` és `LoadBooks` hívásokat.

Ekkor, ha jól dolgoztunk, a `BookService` osztályunkban már nem lehet fordítási hiba.

A `SeedDatabase` metódust hívjuk meg az alkalmazás indulásakor, hogy a könyvek és műfajok adatai betöltődjenek az adatbázisba.
Ezt az `App.xaml.cs` fájlban a `OnLaunched` metódusban tehetjük meg legkönnyebben.

```csharp title="App.xaml.cs" hl_lines="6"
protected override void OnLaunched(Microsoft.UI.Xaml.LaunchActivatedEventArgs args)
{
    m_window = new MainWindow();
    m_window.Activate();

    new BookService().SeedDatabase();
}
```

### ViewModel

Készítsük el az új (`BooksPage`-hez tartozó) `BooksPageViewModel` osztályt egy új `ViewModels` mappába. Ez, mint egy klasszikus ViewModel, a nézet állapotát és a rajta végrehajtható műveleteket fogja tartalmazni - vagyis a `BooksPage` nézethez tartozó **megjelenítési logikát**.

Ha belegondolunk, a `BooksPage` az alábbi állapotinformációkat tartalmazza:

* A könyvek listája
* A műfajok listája a legördülő menüben
* A kiválasztott műfaj

Ezeket vegyük fel tulajdonságokként a `BooksPageViewModel` osztályba, és implementáljuk az előző laboron tanult `INotifyPropertyChanged` interfész alapú változásértesítést az adatkötés támogatásához.

```csharp
using Lab.Mvvm.Models;

using System.Collections.Generic;
using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace Lab.Mvvm.ViewModels;

public class BooksPageViewModel : INotifyPropertyChanged
{
    private List<Book> _books;
    public List<Book> Books
    { 
        get => _books;
        set => SetProperty(ref _books, value);
    }

    private List<string> _genres;
    public List<string> Genres
    {
        get => _genres;
        set => SetProperty(ref _genres, value);
    }

    private string _selectedGenre;
    public string SelectedGenre
    { 
        get => _selectedGenre;
        set => SetProperty(ref _selectedGenre, value);
    }

    public event PropertyChangedEventHandler PropertyChanged;

    protected virtual bool SetProperty<T>(ref T property, T value, [CallerMemberName] string propertyName = null)
    {
        if (object.Equals(property, value))
            return false;
        property = value;
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));

        return true;
    }
}
```

!!! tip "SetProperty"
    Az `SetProperty` metódus egy segédfüggvény, amely megkönnyíti a tulajdonságok beállítását és a változásértesítést.

    A visszatérési érték `true`, ha a tulajdonság értéke megváltozott, és `false`, ha nem. Ez segít majd a későbbiekben eldönteni, hogy történt-e változás a tulajdonság értékében.

    A `ref` kulcsszó lehetővé teszi, hogy a metódus közvetlenül módosítsa a változó értékét (nem csak a referencia kerül átadásra, hanem maga referencia is módosítható, hogy az eredeti változó hova mutasson).

    A `CallerMemberName` attribútum automatikusan átadja a hívó  (itt property) nevét, így nem kell mindenhol megadni a tulajdonság nevét kézzel.

Az adatok betöltését a `BookService` osztály segítségével fogjuk megvalósítani (görgessünk fel az útmutatóban, és a bevezető MVVM ábrán nézzük meg, hogy valóban a ViewModel használja a Service osztályt/osztályokat). Példányosítsuk a `BookService` osztályt, és a konstruktorában töltsük be a műfajokat és a könyveket.

```csharp
private readonly BookService _booksService;

public BooksPageViewModel()
{
    _booksService = new BookService();
    Genres = _booksService.GetGenres();
    LoadBooks();
}

private void LoadBooks()
{
    // A Books  property állítása kiváltja az INPC PropertyChanged eseményt (lásd Books property setter fent) - a nézet frissülni fog
    Books = _booksService.GetBooks(SelectedGenre);
}
```

A könyv betöltést nem csak a konstruktorban kell elvégezni, hanem a `SelectedGenre` tulajdonság setterében is, hogy a kiválasztott műfaj megváltozása esetén újra betöltsük a könyveket.
A `SelectedGenre` setterében a `LoadBooks` metódust hívjuk meg, ha változás történt.

```csharp hl_lines="5-9"
private string _selectedGenre;
public string SelectedGenre
{
    get => _selectedGenre;
    set
    {
        if (SetProperty(ref _selectedGenre, value))
            LoadBooks();
    }
}
```

### View

Most már csak a nézetet kell átalakítanunk, hogy a ViewModelt használja.

Hozzunk létre a `BooksPage.xaml.cs` fájlban egy új `BooksPageViewModel` típusú readonly propertyt, és adjunk neki értéket egy új `BooksPageViewModel` példány létrehozásával.

```csharp
public BooksPageViewModel ViewModel { get; } = new BooksPageViewModel();
```

!!! warning "readonly property vs getter only property"
    Emlékezzünk vissza, hogy az autoimplementált (egyszer inicializált) readonly property és a getter only property között lényeges különbség van. A fenti példában autoimplementált readonly propertyt használunk, ami azt jelenti, hogy a `ViewModel` property értéke csak egyszer jön létre. Ezzel szemben a getter only property esetén minden egyes híváskor új példányt hoznánk létre, ami nem kívánt viselkedést okozna: `public BooksPageViewModel ViewModel => new BooksPageViewModel();`

A `BooksPage.xaml` fájlban innentől kezdve használhatjuk a `ViewModel` propertyt az adatkötéshez.

* Fókuszáljunk első körben a `ComboBox`-ra:
    * A `SelectedItem` és az `ItemsSource` tulajdonságokat a kiinduló megoldásban a code-behind fájlban kézzel manipuláltuk. Ezeket kezelését alakítsuk át adatkötés alapú megoldásra: az MVVM mintának megfelelőan a code-behindban definiált ViewModel objektum tulajdonságaihoz kötjük.
    * Töröljük a xaml fájlban a `SelectionChanged` esemény feliratkozást és a code-behindban a `GenreFilterComboBox_SelectionChanged` eseménykezelőt (erre a `SelectedItem` adatkötése miatt nincs már szükség).

    ```xml hl_lines="4-5"
    <ComboBox x:Name="genreFilterComboBox"
            Grid.Row="1"
            PlaceholderText="Filter Genre"
            ItemsSource="{x:Bind ViewModel.Genres}"
            SelectedItem="{x:Bind ViewModel.SelectedGenre, Mode=TwoWay}" />
    ```

* A _Clear_ gomb esetében is töröljük a `Click` esemény feliratkozást és a code-behindban a `GenreFilterComboBox_SelectionChanged` eseménykezelőt. Ennek viselkedését majd csak később implementáljuk a ViewModel-ben.

    ```xml
    <Button x:Name="clearGenreFilterButton"
            Content="Clear" />
    ```

* Az `ItemsView`-ban is adatkötést kell használnunk a `ItemsSource` tulajdonsághoz.

    ```xml hl_lines="3"    
    <ItemsView x:Name="booksGridView"
            Grid.Row="2"
            ItemsSource="{x:Bind ViewModel.Books, Mode=OneWay}">
        ...
    </ItemsView>
    ```

??? note "Klasszikus Binding használata"
    Ha klasszikus bindingot használnánk `x:Bind` helyett, akkor az adott vezérlő/oldal `DataContext` tulajdonságát be kellene állítani egy ViewModel példányra.

**Próbáljuk ki!**

Az alkalmazásunknak az előzőekhez hasonlóan kell működnie (kivéve a _Clear_ gomb), de most már MVVM mintát követ az alkalmazásunk architektúrája.

### Összefoglalás

Értékeljük ki a megoldásunkat, a kódot is nézve. A kezdeti megoldásunkban csak egy **Page** osztályunk volt, ebben az egyben volt mixelve a megjelenítés (.xaml-ben) az alkalmazáslogika és a megjelenítési logika (ez utóbbi kettő a Page code-behindban). Az MVVM alapú megoldásunkban:

* A Page-ben csak a megjelenítés maradt (**View**), a code-behind gyakorlatilag üres (csak egy ViewModel-t tartalmaz).
* Az alkalmazáslogika egy **Service** osztályba került.
* Az oldalhoz tartozó megjelenítési logika egy **ViewModel** osztályba került (és a View adatköt hozzá).

A jobb áttekinthetőségen felül a megközelítés legfőbb előnye, hogy a ViewModel és a View között lazább csatolás van, így a ViewModel könnyebben tesztelhető és akár újrafelhasználható. A ViewModel nem függ a View-tól, így könnyen átírható vagy lecserélhető anélkül, hogy a View-t módosítani kellene.

## 2. Feladat - MVVMToolkit

MVVM mintát ritkán szoktunk kizárólag a .NET keretrendszerre támaszkodva implementálni.
Érdemes használni valamilyen MVVM könyvtárat, amelyek segítségével a kódunk tömörebb, átláthatóbb, és kevesebb boilerplate kódot fog tartalmazni.
A könyvtárak közül a legelterjedtebbek a következők:

* [MVVM Toolkit](https://learn.microsoft.com/en-us/dotnet/communitytoolkit/mvvm/): Microsoft által gondozott MVVM könyvtár.
* [Prism](https://prismlibrary.com/): Régen Microsoft gondozásában állt és nagyon elterjedt volt, de már külső fejlesztők tartják karban és fizetős lett idő közben.
* [ReactiveUI](https://reactiveui.net/): A Reactive Extensions (Rx) könyvtárakat használja a ViewModel állapotának kezelésére, és a View-ViewModel közötti adatkötésre. Ez a könyvtár nyújtja a legtöbb szolgáltatást, de a legnehezebben tanulható is.
* [Uno.Extensions](https://platform.uno/uno-extensions/): MVVM Toolkitre épül, de több olyan szolgáltatást is tartalmaz, amelyek a WinUI keretrendszer hiányosságait pótolják.
* A [Windows Template Studio](https://marketplace.visualstudio.com/items?itemName=TemplateStudio.TemplateStudioForWinUICs) egy Visual Studio kiegészítő, ami komplexebb WinUI alkalmazások kiinduló projektsablonját teszi elérhetővé.

A labor során a Microsoft által gondozott MVVM Toolkitet fogjuk kipróbálni.

### Telepítés

A MVVM Toolkit telepítéséhez nyissuk meg a NuGet Package Manager-t a Visual Studio-ban (jobb katt a projekten majd "Manage Nuget Packages"), és keressük meg a `CommunityToolkit.Mvvm` csomagot. 
:exclamation: Lényeges, hogy a labortermekben a 8.4.0-s verziót telepítsük!
Ez valójában a projektfájlban az alábbi `PackageReference` bejegyzést fogja létrehozni (akár kézzel is felvehetjük a fenti lépések helyett a többi PackageReference mellé):

```xml
<PackageReference Include="CommunityToolkit.Mvvm" Version="8.4.0" />
```

### ObservableObject és ObservableProperty

A BooksPageViewModel osztályunkban az `INotifyPropertyChanged` megvalósítása meglehetősen terjengős.  A `INotifyPropertyChanged` interfész közvetlen implementálása helyett használhatjuk a `ObservableObject` osztályt, amely már implementálja ezt az interfészt és több segédfüggvényt is tartalmaz, amelyek megkönnyítik a tulajdonságok beállítását és a változásértesítést.
Továbbá lehetőségünk van az `ObservableProperty` attribútum használatára is, amely egy kódgenerátort vezérel, így automatikusan létrehozhatóak a tulajdonságok kézzel írt boilerplate kód nélkül, kizárólag a mezők attributált deklarálásával. Hajtsuk végre az alábbi átalakításokat:

* A `BooksPageViewModel` osztályunknak az `CommunityToolkit.Mvvm.ComponentModel` névtérben található `ObservableObject` osztályból kell leszármaznia.

* A source generator használatához azt osztályt `partial` kulcsszóval kell ellátni, hogy a generált kód és a kézi kód külön fájlokban kaphassanak helyet.

* A fullproperty szintaxis helyett pedig elég megtartanunk a mezőket, amikre az `ObservableProperty` attribútumot helyezzük el.

    ```csharp hl_lines="1 5 8 11"
    public partial class BooksPageViewModel : ObservableObject
    {
        // ...

        [ObservableProperty]
        private List<Book> _books;

        [ObservableProperty]
        private List<string> _genres;

        [ObservableProperty]
        private string _selectedGenre;

        // ...
    }
    ```

Lényeges, hogy a korábbi `BooksPageViewModel` megoldásból töröljük a tagváltozókat (a _booksService kivételével), a property-ket (hiszen ezeket a kódgenerátor hozza létre), a `PropertyChanged` eseményt és a `SetProperty` műveletet. :exclamation: az átalakítás után buildeljünk egyet (pl. Build/Build solution menü): enélkül a fordítási hibák nem szűnnek meg, a Visual Studio számos hibát jelez a kódban. Ez logikus is, hiszen az adatkötött propertyket a kódgenerátor csak a build során generálja le (egy "rejtett" állományban).

Ellenőrizhetjük, hogy milyen kód generálódott, ha például ++f12++-vel navigálunk a `Genres` tulajdonságra (a xaml fájlban az `ItemsSource` adatkötésnél a kurzorral a `ViewModel.Genres`-en állva).

!!! tip "ObservableProperty attribútum property-re"
    Az `ObservableProperty` attribútumot mezők helyett property-kre is alkalmazhatjuk egy [új C# nyelvi funkció segítéségével](https://devblogs.microsoft.com/dotnet/announcing-the-dotnet-community-toolkit-840/#partial-properties-support-for-the-mvvm-toolkit-🎉), ehhez viszont preview C# verziót kellene használnunk, így ezt idén még kihagyjuk.

**Próbáljuk ki!**

Azt tapasztaljuk, hogy a könyvek betöltődnek, de a műfaj kiválasztásakor nem töltődnek be újra a könyvek.
Igen, mert korábban a `SelectedGenre` változására meghívtuk a `LoadBooks` metódust (ezt a generált kód nem teszi meg).

Három lehetőségünk van:

1. Visszalakítjuk a `SelectedGenre` propertyt nem kódgenerált változatra, hogy a settert mi tudjuk definiálni.
2. Feliratkozunk a ViewModel `PropertyChanged` eseményre a konstruktorban, az eseménykezelőnkben a `LoadBooks` metódust meghívjuk, ha a `SelectedGenre` property változik.
3. Használjuk a kódgeneráltor által elkészített partial metódusokat, melyekkel kibővíthetjük a setterek viselkedését.

A 3. lehetőség tűnik a legegyszerűbbnek, ehhez viszont ismerni kell a partial metódusok működését (erről a tárgy keretében nem volt még szó).
A partial metódusok olyan metódusok, amelyeknek a deklarációja és definíciója külön (egy adott partial classhoz) tartozó fájlokban kap helyet, és amiket a fordító automatikusan összekapcsol. Ráadásul a partial metódusokat nem kell megvalósítanunk kötelezően.
Esetünkben a kódgenerátor deklarálja őket, hívja meg ezeket a setterekben, és mi implementálhatjuk őket a `BooksPageViewModel` osztályban.

Készítsünk egy implementációt az `OnSelectedGenreChanged(string value)` partial metódusra, amelyben meghívjuk a `LoadBooks` metódust.

```csharp title="BooksPageViewModel.cs"
partial void OnSelectedGenreChanged(string value) => LoadBooks();
```

Több teendőnk nincs, a generált kód ezt meg is hívja.

**Próbáljuk ki!**

Most már a műfaj kiválasztásakor újra betöltődnek a könyvek is.

## 3. Feladat - Command

A felhasználói felületek kialakításakor két feladatunk van:

* Adatok **megjelenítése** a felületen. Ezt az MVVM minta alapú megoldásunkban adatkötéssel elegánsan megoldottuk.
* A felhasználói **interakciók/parancsok** kezelése. Az eredeti megoldásunkban ez eseménykezelőkkel volt megoldva, majd ezeket szintén "elegánsan" mindenestől töröltük (emiatt nem működik a `Clear` gomb). A következőkben azt vizsgáljuk meg, hogy az MVVM minta alkalmazásával milyen megoldást lehet erre alkalmazni (spoiler: ViewModel-ben definiált commandok vagy műveletek kötése a View-ba).

A ViewModel tipikusan publikálja a rajta végrehajtható műveleteket a View felé. Ezt megtehetjük publikus függvényeken keresztül vagy egy `ICommand` interfészt megvalósító objektumokon keresztül.

!!! tip "ICommand"
    Az `ICommand` előnye, hogy összefogjuk egy objektumba a műveletet és annak végrehajthatósági állapotát, melynek változásáról még eseményt is publikál.

    ```csharp
    public interface ICommand
    {
        event EventHandler? CanExecuteChanged;
        bool CanExecute(object? parameter);
        void Execute(object? parameter);
    }
    ```
    
    Ezt a mechanizmust használja a `Button` vezérlő is, amelynek `Command` tulajdonságához rendelhetjük a ViewModel-ben definiált parancsokat.

    Az `ICommand`-ban definiált műveletek közül legfontosabb számunkra az `Execute`, mely a parancs futtatásakor hívódik meg. A `CanExecute`-tal a felület le tudja kérdezni a felület a parancstól, hogy adott pillanatban a parancs végrejaktható-e (pl. a gomb tiltott/engedélyezett lesz ennek megfelelően). A `CanExecuteChanged` eseménnyel pedig - az esemény nevének megfelelően - azt tudja jelezni a parancs a felület felé, hogy a parancs "CanExecute" állapota megváltozott, a felületnek frissítenie kell a tiltott/engedélyezett állapotát.

### ICommand használata

Készítsünk egy `ICommand` típusú propertyt a `BooksPageViewModel` osztályban, amely "nem beállított" állapotba teszi a kiválasztott műfajt (a Clear gombnál használjuk majd).
Megvalósításként az MVVMToolkit `RelayCommand` osztályt fogjuk használni, amely a `CommunityToolkit.Mvvm.Input` névtérben található.
Ebből készítünk egy új példányt a `BooksPageViewModel` konstruktorban, ahol egy lambda kifejezésben definiáljuk a parancs végrehajtását (a parancs `Execute` művelete ezt a lambdát hívja).

```csharp title="BooksPageViewModel.cs" hl_lines="5 8"
public BooksPageViewModel()
{
    // ...

    ClearFilterCommand = new RelayCommand(() => SelectedGenre = null);
}

public ICommand ClearFilterCommand { get; }
```

Kössük rá a _Clear_ gomb `Command` tulajdonságára a `ClearFilterCommand` propertyt.

```xml title="BooksPage.xaml" hl_lines="2"
<Button Content="Clear"
        Command="{x:Bind ViewModel.ClearFilterCommand}" />
```

Vegyük észre, milyen elegáns a megoldás. Pontosan ugyanúgy dolgoztunk, mint a labor során korábban az adatok megjelenítésénél: a View-ban adatkötést alkalmaztunk a ViewModel-ben levő tulajdonságra (csak éppen az most egy parancs objektum volt).

**Próbáljuk ki!** Működik a _Clear_ gomb, a kiválasztott műfaj törlődik.

### ICommand végrehajthatósági állapota

Ami viszont még nem működik, az a gomb letiltása, ha nincs kiválasztott műfaj.

Ehhez a `RelayCommand` osztály konstruktorában adjunk meg egy `Func<bool>` típusú függvényt második paraméterben, amely megmondja, hogy a parancs végrehajtható-e vagy sem (a parancs `CanExecute` művelete ezt a lambdát hívja).

```csharp title="BooksPageViewModel.cs konstruktora" hl_lines="3"
ClearFilterCommand = new RelayCommand(
    execute: () => SelectedGenre = null,
    canExecute: () => SelectedGenre != null);
```

!!! note Paraméter nevek
    A fenti kódban az `execute:` és `canExecute:` egy általános C# nyelvi eszköz alkalmazására mutat példát: C#-ban egy függvény hívásakor paraméterek megadásakor lehetőség van a paraméter **nevének** megadására (`:` előtt). Ezt ritkán alkalmazzuk, mert többet kell gépelni, viszont néha - amikor nagyban segíti - a kód olvashatóságát, érdemes megfontolni a használatát.

Viszont a UI csak akkor frissül - és ezáltal a `canExecute` paraméterben megadott függvény csak akkor hívódik meg -, ha az `ICommand.CanExecuteChanged` eseménye elsütésre kerül.

Ezt az esemény elsütést az `IRelayCommand` interfészen keresztül (ami egyben `ICommand` is) mi is ki tudjuk váltani, ha a `SelectedGenre` property setterében meghívjuk a `NotifyCanExecuteChanged()` metódust.

Módosítsuk a property típusát `IRelayCommand`-ra.

```csharp title="BooksPageViewModel.cs"
public IRelayCommand ClearFilterCommand { get; }
```

A `NotifyCanExecuteChanged()` metódust pedig a már létező `OnSelectedGenreChanged` partial metódusunkban hívjuk meg.

```csharp title="BooksPageViewModel.cs" hl_lines="4"
partial void OnSelectedGenreChanged(string value)
{
    LoadBooks();
    ClearFilterCommand.NotifyCanExecuteChanged();
}
```

**Próbáljuk ki!** Most már a _Clear_ gomb letiltásra kerül, ha nincs kiválasztott műfaj.

### Command MVVMToolkit kódgenerátorral

A `RelayCommand` property kézi deklarálása és példányosítása helyett használhatjuk a `RelayCommand` attribútumot is egy **függvényen**, amely automatikusan legenerálja a szükséges körítést a kódgenerátor segítségével.

* Töröljük ki a korábban használt `ClearFilterCommand` propertyt és a konstruktorban való példányosítást.

* Helyette hozzunk létre egy új `ClearFilter` nevű metódust, amely a `RelayCommand` attribútum segítéségével a háttérben legenerálja a szükséges command propertyt.

    ```csharp title="BooksPageViewModel.cs"
    [RelayCommand]
    private void ClearFilter() => SelectedGenre = null;
    ```

* A `CanExecute` logikához pedig behivatkozhatunk egy másik metódust vagy propertyt, amely megadja a parancs végrehajthatóságát.

    ```csharp title="BooksPageViewModel.cs" hl_lines="1 3"
    private bool IsClearFilterCommandEnabled => SelectedGenre != null;

    [RelayCommand(CanExecute = nameof(IsClearFilterCommandEnabled))]
    private void ClearFilter() => SelectedGenre = null;
    ```

**Próbáljuk ki!** Úgy kell működnie, mint eddig (csak most a `ClearFilterCommand` tulajdonságot a kódgenerátor hozza létre).

Ráadásul a `NotifyCanExecuteChanged` is kiváltható deklaratívan attribútumok segítségével.
Esetünkben a `NotifyCanExecuteChangedFor`-ral kössük össze a `SelectedGenre` változását a `ClearFilterCommand` végrehajthatóságával.
Így az `OnSelectedGenreChanged` partial metódusunkból törölhetjük az esemény elsütését.

```csharp title="BooksPageViewModel.cs" hl_lines="2"
[ObservableProperty]
[NotifyCanExecuteChangedFor(nameof(ClearFilterCommand))]
private string _selectedGenre;

partial void OnSelectedGenreChanged(string value)
{
    LoadBooks();
}
```

**Próbáljuk ki!** Úgy kell működnie, mint eddig.

??? tip "Ha nem támogatott a Command minta közvetlenül"
    Nem minden vezérlő támogatja a `Command` mintát közvetlenül. Ilyenkor két lehetőségünk van:

    1. Használhatunk `x:Bind` adatkötést, amely nem csak a tulajdonságokhoz, hanem eseménykezelőkhöz is használható. Így akát ViewModel-ben lévő eseménykezelőt is köthetünk a vezérlő eseményéhez. Ennek hátránya, hogy sértheti az MVVM mintát, mivel a ViewModel függeni fog a View-tól (pl.: eseménykezelő szignatúra és paraméterek tekintetében).
   
    2. Továbbra is Command mintát használunk, de az adott vezérlő kívánt eseményét egy úgynevezett Behavior segítségével köthetjük a ViewModelhez. A Behavior egy olyan osztály, amely lehetővé teszi, hogy a vezérlő viselkedését módosítsuk anélkül, hogy közvetlenül módosítanánk a vezérlő kódját. Esetünkben a [Microsoft.Xaml.Behaviors](https://www.nuget.org/packages/Microsoft.Xaml.Behaviors.WinUI.Managed) csomagot kell telepítenünk, melyben előre elkészítve található olyan behavior, amivel [eseményeket tudunk Command meghívássá konvertálni](https://github.com/Microsoft/XamlBehaviors/wiki/InvokeCommandAction).

## Összefoglalás

A labor során a kiinduló projektet MVVM mintára alakítottuk át, így a felelősségi körök el lettek választva a View és a ViewModel között:

* A ViewModel tartalmazza a nézet állapotát és a rajta végrehajtható műveleteket, míg a View csak a felhasználói felület megjelenítéséért felelős.
* A ViewModel és a View között lazább csatolás van adatkötés formájában, így a ViewModel könnyebben tesztelhető és akár újrafelhasználható.
* A ViewModel nem függ a View-tól, így könnyen átírható vagy lecserélhető anélkül, hogy a View-t módosítani kellene.
* A ViewModel sem tartalmazza a teljes üzleti logikát, például az adatelérést, hanem egy külön Service osztályban helyeztük el.
