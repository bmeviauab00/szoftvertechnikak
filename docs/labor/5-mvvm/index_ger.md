---
authors: tibitoth
---

# 5. MVVM

## Das Ziel der Übung

In dieser Übung werden wir eine einfache Anwendung mit Hilfe des MVVM-Musters refaktorisieren, um eine bessere Transparenz und Wartbarkeit zu erreichen.

## Voraussetzungen

Die für die Durchführung der Übung benötigten Werkzeuge:

* Windows 11 (Linux und macOS sind nicht geeignet)
* Visual Studio 2026
    * Windows Desktop Development Workload

## Ausgangsprojekt

Das Ausgangsprojekt kann mit folgendem Befehl geklont werden:

```cmd
git clone https://github.com/bmeviauab00/lab-mvvm-kiindulo
```

??? success "Die fertige Lösung herunterladen"
    :exclamation: Es ist wichtig, dass Sie sich während des Praktikums an die Anleitung halten.

    Für das spätere selbstständige Üben kann es jedoch hilfreich sein, die fertige Lösung durchzusehen, daher stellen wir sie zur Verfügung. Es ist verboten (und sinnlos), die fertige Lösung herunterzuladen. Allerdings kann es bei der anschließenden Selbsteinübung nützlich sein, die fertige Lösung zu überprüfen, daher stellen wir sie zur Verfügung.

    Die Lösung ist [auf GitHub verfügbar](https://github.com/bmeviauab00/lab-mvvm-kiindulo/tree/megoldas) im Branch `megoldas`. Die einfachste Möglichkeit zum Herunterladen ist die Verwendung des folgenden Befehls:

    `git clone https://github.com/bmeviauab00/lab-mvvm-kiindulo -b megoldas`

## Über das MVVM-Muster

Das MVVM (Model-View-ViewModel) ist ein architektonisches Entwurfsmuster, das bei der Entwicklung von XAML-Anwendungen verwendet wird, aber auch in anderen clientseitigen Technologien vorkommt (z. B. Android, iOS, Angular usw.).

Ziel des MVVM-Musters ist es, die Benutzeroberfläche und die dahinterliegende Logik voneinander zu trennen, um eine lose gekoppelte Anwendung zu schaffen, die besser testbar, wartbar und wiederverwendbar ist.

Das MVVM-Muster besteht aus drei (+1) Hauptbestandteilen:

* **Model**: Enthält domänenspezifische Daten, die von ViewModels zur Datenspeicherung verwendet werden können, z. B. Klassen wie `Recipe`, `Product`, `Order`, die Rezept-, Produkt- oder Bestelldaten kapseln.
* **View**: Enthält die Beschreibung der Benutzeroberfläche (sowie Logik, die ausschließlich das UI betrifft, z. B. Animationen). Typischerweise abgeleitet von `Window`, `Page` oder `UserControl`, deklarativ in XAML beschrieben. Die Code-Behind-Datei bleibt meist leer, da die Logik ins ViewModel gehört.
* **ViewModel**: Enthält die zur View gehörige Logik: den Zustand der Ansicht und die möglichen Aktionen. **Unabhängig** von der View – die lose Kopplung zwischen View und ViewModel wird durch Datenverbindung realisiert (UI-Elemente binden an ViewModel-Eigenschaften). Kann mit Unit Tests getestet werden!
* **Services**: Klassen, die Geschäfts- bzw. Anwendunglogik enthalten, und vom ViewModel genutzt werden. Würde man alle Logik ins ViewModel packen, würde dieses schnell unübersichtlich werden. Obwohl Services kein Teil des MVVM-Musters sind, erwähnen wir sie hier, da auch wir unsere Architektur so gestalten werden.

<figure markdown>
![MVVM](images/mvvm.drawio.png)
</figure>

:exclamation: Wann erstellen wir ViewModel-Klassen?

* Für jede **Ansicht/View** (z. B. `Window`, `Page`, `Dialog`, `UserControl`) erstellen wir typischerweise eine ViewModel-Klasse und instanziieren davon ein Objekt. Zum Beispiel `MainPageViewModel` für `MainPage`, `DancerDialogViewModel` für `DancerDialog`. Dies wird auch im Labor angewendet.
* Für die einzelnen **Model-Klassen** (z. B. `Recipe`, `Product`, `Dancer` usw.) können optional Wrapper-ViewModels erstellt werden (z. B. `RecipeViewModel`, `ProductViewModel`, `DancerViewModel`), das werden wir im Labor jedoch **nicht** tun. Der Grund dafür ist, dass wir nicht dem Strict MVVM Muster folgen, sondern dem Relaxed MVVM Muster (siehe Vorlesung).

## 0. Aufgabe – Überblick über das Ausgangsprojekt

Unsere Anwendung ist eine einfache Bücherliste, bei der die Bücher in einer `ItemsView` in tabellarischer Form angezeigt werden.  
Über der Liste befindet sich ein `ComboBox`, mit dem die Bücher nach Genre gefiltert werden können.  
Der Filter kann mit einem _Clear_-Knopf zurückgesetzt werden.

**Probieren wir es aus!**

<figure markdown>
![Startansicht](images/kiindulo.png)
<figcaption>Oberfläche des Ausgangsprojekts</figcaption>
</figure>

!!! tip "ComboBox und ItemsView"
    Sowohl `ComboBox` als auch `ItemsView` sind Listensteuerungen, die über die Eigenschaft `ItemsSource` mit Daten gefüllt werden können.

    * Die `ComboBox` ist ein Dropdown-Menü, das dem Benutzer ermöglicht, ein Element aus der Liste auszuwählen.
    
    * Die `ItemsView` zeigt mehrere Elemente gleichzeitig in tabellarischer Form an. Sie erlaubt verschiedene Layouts (z. B. Grid oder Liste), einstellbar über die `Layout`-Eigenschaft. Im Unterschied zur im vorherigen Labor verwendeten `ListView` muss das Wurzelelement in einer Listenelementvorlage immer ein `ItemContainer` sein.

Im Ausgangsprojekt befindet sich die Anwendungslogik in der Datei `BooksPage.xaml.cs`, und die Benutzeroberfläche in `BooksPage.xaml`.
Diese Lösung folgt **nicht** dem MVVM-Muster, wodurch die Benutzeroberfläche und die zugrunde liegende Logik eng miteinander verflochten sind, was fast schon den Charakter von Spaghetti-Code annimmt.

Ein gutes Beispiel dafür ist, dass das Laden der Daten direkt im Code-Behind geschieht, und werden die UI-Elemente direkt manipuliert.  
Interaktionen werden auch in Ereignishandlern behandelt, was nach einer Weile undurchsichtig wird und die Zuständigkeiten sind gemischt.

In unserem Fall werden die Beispieldaten über die Funktion `SeedDatabase` geladen, die im Konstruktor von `BooksPage` aufgerufen wird.  
Die Funktionen `LoadGenres` und `LoadBooks` sind für das Auffüllen des Dropdowns und der Tabelle zuständig.

Die Änderung der Auswahl im Dropdown-Menü sowie das Drücken des _Clear_-Knopfs wird jeweils durch einen Ereignishandler behandelt, die die Liste je nach Genre neu laden (suchen wir diese Funktionen im Code!).

!!! note "Datenladen mit ADO.NET aus SQLite-Datenbank"
    Die Anwendung verwendet eine SQLite-Datenbank zur Datenspeicherung, die mit ADO.NET angesprochen wird. Diese Technologie wird im Labor nicht im Detail behandelt, aber wir werden sie am Ende des Semesters besprechen.

!!! note "`Page`-Klasse statt `Window`"
    Unsere View basiert diesmal nicht auf `Window`, sondern auf einer von `Page` abgeleiteten Klasse. Eine `Page` stellt eine „Seite“ in der Anwendung dar: sie kann nicht selbstständig angezeigt werden, sondern muss z. B. in einem Fenster eingebettet werden. Vorteil: Mit entsprechender Navigation kann man in einem Fenster zwischen Seiten wechseln. Das werden wir aber nicht ausnutzen – wir haben nur eine einzige Seite.  
    Ziel der Verwendung einer `Page` war lediglich, zu zeigen: In einer MVVM-Architektur können Views auch durch `Page`- oder sogar andere UI-Komponenten wie `UserControl` realisiert werden – nicht nur durch `Window`.

## 1. Aufgabe – Einführung des MVVM-Musters

Im Rahmen des Labors werden wir das Ausgangsprojekt gemäß dem MVVM-Muster umstrukturieren.

### Model

Bauen wir nun von unten nach oben auf, beginnend mit unserer Modellklasse. Die `Book`-Klasse, die sich derzeit in der Datei `BooksPage.xaml.cs` befindet, soll in eine neue Datei innerhalb eines neu erstellten Ordners `Models` verschoben werden.

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

Die `Book`-Klasse wurde vom früheren Namensraum `Lab.Mvvm` in den neuen Namensraum `Lab.Mvvm.Models` verschoben.  
Aus diesem Grund sollten wir die Ansicht (`BooksPage.xaml.cs`) jetzt an die Namensraumänderung anpassen, um lange Kompilierungsfehler zu vermeiden.
Konkret müssen wir einen neuen Namensraum (`model`) einführen und diesen beim Festlegen des Typs der Datenvorlage (`ItemTemplate`) im `ItemsView` verwenden:

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

Den für das Laden der Daten verantwortlichen Code verschieben wir in eine neue Klasse namens `BookService`, die im neu erstellten Ordner `Services` abgelegt wird.

* In die Klasse `BookService` verschieben wir die Methoden `SeedDatabase`, `LoadGenres` und `LoadBooks` aus der Datei `BooksPage.xaml.cs`.

* Auch das Feld `_connectionString` soll in diese Klasse übertragen werden.

* Die Sichtbarkeit der Methoden soll auf `public` gesetzt werden, damit sie von der ViewModel-Klasse aufgerufen werden können.

Die Methode `SeedDatabase` ist bereits in Ordnung, aber in den beiden anderen Methoden greifen wir noch auf UI-Elemente zu, die entfernt werden müssen.

Wir ändern die Methoden so, dass sie nur die benötigten Daten zurückgeben und keine direkten Referenzen auf UI-Komponenten enthalten. Zudem benennen wir sie um in `GetGenres` und `GetBooks`.

* Die Methode `GetGenres` gibt eine Liste vom Typ `List<string>` zurück.

* Die Methode `GetBooks` gibt eine Liste vom Typ `List<Book>` zurück.  
  Dabei müssen wir beachten, dass zuvor der aktuell gewählte Wert aus der `ComboBox` verwendet wurde, aber jetzt müssen wir diesen Parameter optional an die Funktion übergeben.

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

Zusätzlich zu den oben hervorgehobenen Änderungen:

* In der Methode `GetGenres` löschen wir auch die Zeilen, die `genreFilterComboBox` und `clearGenreFilterButton` manipulieren.
* In der Klasse `BooksPage` entfernen wir die Aufrufe von `SeedDatabase`, `LoadGenres` und `LoadBooks`, da sie zu Kompilierungsfehlern führen würden.

Wenn wir alles richtig gemacht haben, sollten in der Klasse `BookService` keine Kompilierungsfehler mehr auftreten.

Die Methode `SeedDatabase` rufen wir beim Start der Anwendung auf, damit die Buch- und Genre-Daten in die Datenbank geladen werden.  
Dies kann am einfachsten in der Methode `OnLaunched` in der Datei `App.xaml.cs` geschehen.

```csharp title="App.xaml.cs" hl_lines="6"
protected override void OnLaunched(Microsoft.UI.Xaml.LaunchActivatedEventArgs args)
{
    m_window = new MainWindow();
    new BookService().SeedDatabase();
    m_window.Activate();
}
```

### ViewModel

Erstellen wir die neue Klasse `BooksPageViewModel`, die zu `BooksPage` gehört, in einem neuen Ordner namens `ViewModels`. Diese Klasse übernimmt – ganz klassisch für ein ViewModel – den Zustand der Ansicht sowie die darauf ausführbaren Operationen, also die **Darstellungslogik** für die `BooksPage`-Ansicht.

Wenn wir darüber nachdenken, enthält `BooksPage` die folgenden Zustandsinformationen:

* Die Liste der Bücher
* Die Liste der Genres im Dropdown-Menü
* Das aktuell ausgewählte Genre

Diese Informationen fügen wir als Eigenschaften zur Klasse `BooksPageViewModel` hinzu und implementieren die Benachrichtigung über Eigenschaftsänderungen mit der Hilfe der Schnittstelle `INotifyPropertyChanged`, wie wir es im vorherigen Labor gelernt haben, um die Datenbindung zu unterstützen.

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
    Die Methode `SetProperty` ist eine Hilfsfunktion, die das Setzen von Eigenschaften und die Benachrichtigung über Änderungen vereinfacht.

    Der Rückgabewert ist `true`, wenn sich der Wert der Eigenschaft geändert hat, und `false`, wenn nicht. Das hilft später zu entscheiden, ob sich eine Eigenschaft tatsächlich geändert hat.

    Das Schlüsselwort `ref` erlaubt der Methode, den Wert der Variablen direkt zu ändern (es wird nicht nur die Referenz übergeben, sondern die Methode kann auch ändern, worauf diese Referenz zeigt).

    Das Attribut `CallerMemberName` übergibt automatisch den Namen des aufrufenden Elements (hier der Property), sodass man nicht bei jeder Eigenschaft den Namen manuell angeben muss.

Das Laden der Daten erfolgt mit Hilfe der Klasse `BookService` (scrollen wir nach oben in der Anleitung und schauen wir uns im Einführungsbild zur MVVM-Architektur an, dass tatsächlich das ViewModel die Service-Klasse(n) verwendet). Instanziieren wir die Klasse `BookService`, und laden wir die Genres sowie die Bücher im Konstruktor des ViewModels.

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
    // Das Setzen der Books-Eigenschaft löst das INPC PropertyChanged-Ereignis aus (siehe Setter der Books-Eigenschaft oben) – die Ansicht wird aktualisiert
    Books = _booksService.GetBooks(SelectedGenre);
}
```

Das Laden der Bücher muss nicht nur im Konstruktor erfolgen, sondern auch im Setter der `SelectedGenre`-Eigenschaft.  
Wenn sich das ausgewählte Genre ändert, müssen die Bücher entsprechend neu geladen werden.  
Im Setter von `SelectedGenre` soll die Methode `LoadBooks` aufgerufen werden, wenn sich der Wert tatsächlich geändert hat.

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

Jetzt muss nur noch die Ansicht angepasst werden, sodass sie das ViewModel verwendet.

Fügen wir in der Datei `BooksPage.xaml.cs` eine neue, readonly Eigenschaft vom Typ `BooksPageViewModel` hinzu, und weisen wir ihr eine neue Instanz von `BooksPageViewModel` zu.

```csharp
public BooksPageViewModel ViewModel { get; } = new BooksPageViewModel();
```

!!! warning "readonly property vs getter-only property"
    Erinnern wir uns daran, dass es einen wichtigen Unterschied zwischen einer automatisch implementierten readonly Eigenschaft (die einmalig initialisiert wird) und einer Eigenschaft mit nur einem Getter gibt. Im obigen Beispiel verwenden wir eine automatisch implementierte readonly Eigenschaft, was bedeutet, dass der Wert der `ViewModel`-Eigenschaft nur einmalig beim Erstellen gesetzt wird.
    Im Gegensatz dazu würde eine Getter-only Eigenschaft – wie z. B. `public BooksPageViewModel ViewModel => new BooksPageViewModel();` – bei jedem Zugriff eine neue Instanz erzeugen, was zu unerwünschtem Verhalten führen würde.

Im `BooksPage.xaml` können wir ab jetzt die `ViewModel`-Eigenschaft für Datenverbindung verwenden.

* Konzentrieren wir uns zunächst auf das `ComboBox`-Element:
    * Die Eigenschaften `SelectedItem` und `ItemsSource` wurden in der Ausgangslösung noch manuell im Code-Behind gesetzt.
    Konvertieren wir ihre Behandlung in eine auf Datenverbindung basierende Lösung: Binden wir sie an die Eigenschaften des im Code-Behind definierten ViewModel-Objekts, entsprechend dem MVVM-Muster.
    * Entfernen wir die `SelectionChanged`-Ereignisabonnement im XAML sowie die Methode `GenreFilterComboBox_SelectionChanged` im Code-Behind, da diese durch die Datenverbindung von `SelectedItem` überflüssig geworden ist.

    ```xml hl_lines="4-5"
    <ComboBox x:Name="genreFilterComboBox"
            Grid.Row="1"
            PlaceholderText="Filter Genre"
            ItemsSource="{x:Bind ViewModel.Genres}"
            SelectedItem="{x:Bind ViewModel.SelectedGenre, Mode=TwoWay}" />
    ```

* Auch beim _Clear_-Button entfernen wir die `Click`-Ereignisabonnement im XAML sowie den `GenreFilterComboBox_SelectionChanged`-Ereignishandler im Code-Behind.
Das gewünschte Verhalten wird später im ViewModel implementiert.

    ```xml
    <Button x:Name="clearGenreFilterButton"
            Content="Clear" />
    ```

* Auch in `ItemsView` müssen wir Datenverbindung für die `ItemsSource`-Eigenschaft verwenden.

    ```xml hl_lines="3"    
    <ItemsView x:Name="booksGridView"
            Grid.Row="2"
            ItemsSource="{x:Bind ViewModel.Books, Mode=OneWay}">
        ...
    </ItemsView>
    ```

??? note "Verwendung klassisches Binding"
    Wenn wir klassisches Binding anstelle von `x:Bind` verwenden würden, müssten wir die `DataContext`-Eigenschaft des jeweiligen Steuerelements/der Seite auf eine Instanz des ViewModels setzen.

**Probieren wir es aus!**

Unsere Anwendung sollte nun wie zuvor funktionieren (mit Ausnahme der _Clear_-Knopf), aber jetzt folgt die Architektur der Anwendung dem MVVM-Muster.

### Zusammenfassung

Lassen wir uns unsere Lösung bewerten, auch den Code ansehen. In unserer ursprünglichen Lösung hatten wir nur eine **Page**-Klasse, in der sowohl die Darstellung (.xaml) als auch die Anwendungslogik und Darstellungslogik gemischt waren (die letzten beiden in der Page Code-Behind-Datei). In unserer MVVM-basierten Lösung:

* In der Page bleibt nur die Darstellung (**View**), die Code-Behind-Datei ist praktisch leer (sie enthält nur ein ViewModel).
* Die Anwendungslogik wurde in eine **Service**-Klasse ausgelagert.
* Die Darstellungslogik der Seite wurde in eine **ViewModel**-Klasse verschoben (und die View bindet an diese).

Neben der besseren Übersichtlichkeit hat dieser Ansatz den Hauptvorteil, dass die Verbindung zwischen ViewModel und View lockerer ist, sodass das ViewModel leichter testbar und wiederverwendbar ist. Das ViewModel ist nicht vom View abhängig, sodass es leicht verändert oder ersetzt werden kann, ohne dass das View geändert werden muss.

## 2. Aufgabe - MVVMToolkit

Das MVVM-Muster wird selten ausschließlich mit dem .NET-Framework implementiert.
Es ist sinnvoll, eine MVVM-Bibliothek zu verwenden, die unseren Code kompakter, übersichtlicher macht und weniger Boilerplate-Code erfordert.
Einige der bekanntesten Bibliotheken sind:

* [MVVM Toolkit](https://learn.microsoft.com/en-us/dotnet/communitytoolkit/mvvm/): MVVM-Bibliothek, die von Microsoft betreut wird.
* [Prism](https://prismlibrary.com/): Früher von Microsoft betreut und sehr verbreitet, wird jetzt von externen Entwicklern gepflegt und ist inzwischen kostenpflichtig.
* [ReactiveUI](https://reactiveui.net/): Verwendet die Reactive Extensions (Rx) Bibliotheken zur Verwaltung des ViewModel-Status und für das Datenverbinding zwischen View und ViewModel. Diese Bibliothek bietet die meisten Funktionen, ist aber auch die am schwersten zu erlernende.
* [Uno.Extensions](https://platform.uno/uno-extensions/): Basiert auf dem MVVM Toolkit, enthält jedoch zusätzliche Funktionen, die die Lücken im WinUI-Framework füllen.
* [Windows Template Studio](https://marketplace.visualstudio.com/items?itemName=TemplateStudio.TemplateStudioForWinUICs): Ein Visual Studio-Plugin, das eine Vorlage für komplexere WinUI-Anwendungsprojekte bereitstellt.

Im Labor werden wir das von Microsoft betreute MVVM Toolkit ausprobieren.

### Installation

Um das MVVM Toolkit zu installieren, öffnen wir den NuGet Package Manager in Visual Studio (Rechtsklick auf das Projekt und dann "Manage NuGet Packages") und suchen wir nach dem Paket `CommunityToolkit.Mvvm`. 
:exclamation: Es ist wichtig, dass wir die Version 8.4.0 in den Laborräumen installieren!
Dies wird im Projektdatei die folgende `PackageReference`-Zeile erstellen (wir können sie auch manuell hinzufügen, anstatt die oben beschriebenen Schritte zu befolgen und sie zu den anderen `PackageReference`-Elementen hinzuzufügen):

```xml
<PackageReference Include="CommunityToolkit.Mvvm" Version="8.4.0" />
```

### ObservableObject und ObservableProperty

In unserer `BooksPageViewModel`-Klasse ist die Implementierung von `INotifyPropertyChanged` ziemlich umfangreich. Anstatt die `INotifyPropertyChanged`-Schnittstelle direkt zu implementieren, können wir die `ObservableObject`-Klasse verwenden, die diese Schnittstelle bereits implementiert und verschiedene Hilfsmethoden enthält, die das Setzen von Eigenschaften und die Benachrichtigung über Änderungen erleichtern.
Außerdem haben wir die Möglichkeit, das `ObservableProperty`-Attribut zu verwenden, das einen Code-Generator steuert, sodass Eigenschaften automatisch ohne manuell geschriebenen Boilerplate-Code erstellt werden können, nur durch das Deklarieren der Felder mit Attributen. Führen wir die folgenden Anpassungen durch:

* Die `BooksPageViewModel`-Klasse sollte von der `ObservableObject`-Klasse aus dem Namensraum `CommunityToolkit.Mvvm.ComponentModel` abgeleitet werden.

* Um den Source-Generator zu verwenden, muss die Klasse mit dem `partial`-Schlüsselwort versehen werden, damit der generierte Code und der manuelle Code in separaten Dateien platziert werden können.

* Statt der vollständigen Property-Syntax reicht es aus, nur die Felder zu behalten, auf denen wir das `ObservableProperty`-Attribut anwenden.

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

Es ist wichtig, dass wir in der vorherigen `BooksPageViewModel`-Lösung die Membervariablen (außer `_booksService`), die Eigenschaften (denn diese werden vom Code-Generator erzeugt), das `PropertyChanged`-Ereignis und die `SetProperty`-Methode löschen. :exclamation: Nach der Umstellung sollten wir das Projekt einmal bauen (z.B. über das Menü "Build/Build Solution"). Ohne diesen Schritt werden die Kompilierungsfehler nicht behoben, da Visual Studio viele Fehler im Code anzeigen wird. Das ist logisch, denn die gebundenen Properties werden erst beim Bauen des Projekts vom Code-Generator in einer "versteckten" Datei erstellt.

Wir können überprüfen, welcher Code generiert wurde, indem wir z.B. mit ++f12++ zur `Genres`-Property navigieren (in der XAML-Datei, wenn der Cursor auf der Bindung `ViewModel.Genres` steht).

!!! tip "Verwendung des `ObservableProperty`-Attributs auf eine Eigenschaft"
    Das `ObservableProperty`-Attribut kann statt auf Felder auch auf Eigenschaften angewendet werden, mit Hilfe einer [neuen C#-Sprachfunktion](https://devblogs.microsoft.com/dotnet/announcing-the-dotnet-community-toolkit-840/#partial-properties-support-for-the-mvvm-toolkit-🎉). Dafür müsste jedoch eine Preview-Version von C# verwendet werden, was wir in diesem Jahr noch auslassen.

**Probieren wir es aus!**

Wir stellen fest, dass die Bücher geladen werden, aber bei der Auswahl eines Genres werden die Bücher nicht erneut geladen.  
Ja, das liegt daran, dass wir früher bei einer Änderung des `SelectedGenre` die Methode `LoadBooks` aufgerufen haben (dies wird vom generierten Code nicht gemacht).

Wir haben drei Möglichkeiten:

1. Wir ändern die `SelectedGenre`-Eigenschaft zurück zu einer nicht-generierten Version, sodass wir den Setter selbst definieren können.
2. Wir abonnieren das `PropertyChanged`-Ereignis im ViewModel im Konstruktor und rufen im Ereignishandler die Methode `LoadBooks` auf, wenn sich die `SelectedGenre`-Eigenschaft ändert.
3. Wir verwenden die vom Code-Generator erzeugten `partial`-Methoden, mit denen wir das Verhalten der Setter erweitern können.

Option 3 scheint die einfachste zu sein, dafür müssen wir jedoch das Konzept der `partial`-Methoden verstehen (dies wurde im Rahmen des Kurses noch nicht behandelt).  
`Partial`-Methoden sind solche Methoden, deren Deklaration und Definition in verschiedenen Dateien einer bestimmten `partial`-Klasse enthalten sind und die der Compiler automatisch verbindet. Außerdem müssen `partial`-Methoden nicht zwingend implementiert werden.  
In unserem Fall deklariert der Code-Generator sie, ruft sie in den Settern auf, und wir können sie in der `BooksPageViewModel`-Klasse implementieren.

Erstellen wir eine Implementierung für die `OnSelectedGenreChanged(string value)`-`partial`-Methode, in der wir die `LoadBooks`-Methode aufrufen:

```csharp title="BooksPageViewModel.cs"
partial void OnSelectedGenreChanged(string value) => LoadBooks();
```

Wir haben nichts weiter zu tun, der generierte Code ruft es bereits auf.

**Probieren wir es aus!**

Nun werden die Bücher beim Auswählen des Genres erneut geladen.

## 3. Aufgabe - Command

Bei der Erstellung von Benutzeroberflächen haben wir zwei Aufgaben:

* **Anzeige von Daten** auf der Benutzeroberfläche. Dies haben wir in unserer MVVM-basierten Lösung elegant mit Datenverbindung gelöst.
* Behandlung der **Benutzerinteraktionen/Befehle**. In unserer ursprünglichen Lösung wurde dies durch Ereignishandler gelöst, die wir ebenfalls „elegant“ vollständig entfernt haben (weshalb der `Clear`-Knopf nicht funktioniert). Im Folgenden untersuchen wir, welche Lösung im Rahmen des MVVM-Musters dafür angewendet werden kann (Spoiler: Verbindung von Commands oder Operationen, die im ViewModel definiert sind, zur View).

Das ViewModel veröffentlicht typischerweise die ausführbaren Operationen an die View. Dies kann durch öffentliche Methoden oder durch Objekte, die das `ICommand`-Interface implementieren, erfolgen.

!!! tip "ICommand"
    Der Vorteil von `ICommand` besteht darin, dass es eine Operation und ihren Ausführbarkeitszustand in einem Objekt zusammenfasst, wobei auch ein Ereignis über Änderungen dieses Zustands veröffentlicht wird.

    ```csharp
    public interface ICommand
    {
        event EventHandler? CanExecuteChanged;
        bool CanExecute(object? parameter);
        void Execute(object? parameter);
    }
    ```
    Diese Mechanismus wird auch vom `Button`-Steuerelement verwendet, dessen `Command`-Eigenschaft wir den im ViewModel definierten Befehlen zuweisen können.

    Von den in `ICommand` definierten Operationen ist `Execute` die wichtigste für uns, die aufgerufen wird, wenn der Befehl ausgeführt wird. Mit `CanExecute` kann die Benutzeroberfläche den Befehl abfragen, ob er zu einem bestimmten Zeitpunkt ausführbar ist (z. B. wird den Knopf je nach Zustand deaktiviert oder aktiviert). Mit dem Ereignis `CanExecuteChanged` kann der Befehl der Benutzeroberfläche signalisieren, dass sich der Zustand `CanExecute` geändert hat, und die Benutzeroberfläche muss den deaktivierten/aktivierten Zustand aktualisieren.

### Verwendung von ICommand

Erstellen wir eine `ICommand`-Eigenschaft in der `BooksPageViewModel`-Klasse, die den ausgewählten Genre auf einen "nicht gesetzt"-Zustand setzt (dies wird später bei dem Clear-Button verwendet).
Für die Implementierung werden wir die `RelayCommand`-Klasse aus dem MVVMToolkit verwenden, die im Namensraum `CommunityToolkit.Mvvm.Input` zu finden ist.
Wir erstellen eine neue Instanz davon im Konstruktor von `BooksPageViewModel`, wo wir die Ausführung des Befehls in einem Lambda-Ausdruck definieren (die `Execute`-Methode des Befehls ruft dieses Lambda auf).

```csharp title="BooksPageViewModel.cs" hl_lines="5 8"
public BooksPageViewModel()
{
    // ...

    ClearFilterCommand = new RelayCommand(() => SelectedGenre = null);
}

public ICommand ClearFilterCommand { get; }
```

Binden wir die `ClearFilterCommand`-Eigenschaft an die `Command`-Eigenschaft des _Clear_-Buttons.

```xml title="BooksPage.xaml" hl_lines="2"
<Button Content="Clear"
        Command="{x:Bind ViewModel.ClearFilterCommand}" />
```

Beachten wir, wie elegant die Lösung ist. Wir haben genauso gearbeitet wie beim Anzeigen der Daten während des Labors: Wir haben in der View eine Datenverbindung auf die Eigenschaft im ViewModel angewendet (nur dass es sich diesmal um ein Command-Objekt handelt).

**Probieren wir es aus!** Der _Clear_-Button funktioniert, das ausgewählte Genre wird gelöscht.

### ICommand-Ausführbarkeitszustand

Was noch nicht funktioniert, ist das Deaktivieren des Buttons, wenn kein Genre ausgewählt wurde.

Dazu geben wir im Konstruktor der `RelayCommand`-Klasse eine `Func<bool>`-Funktion als zweiten Parameter an, die angibt, ob der Befehl ausgeführt werden kann oder nicht (die `CanExecute`-Methode des Befehls ruft diese Lambda-Funktion auf).

```csharp title="Konstruktor von BooksPageViewModel.cs" hl_lines="3"
ClearFilterCommand = new RelayCommand(
    execute: () => SelectedGenre = null,
    canExecute: () => SelectedGenre != null);
```

!!! note Paraméter nevek
    Im obigen Code sind `execute:` und `canExecute:` Beispiele für die Verwendung eines allgemeinen C#-Sprachtools: In C# ist es bei der Übergabe von Parametern zu einer Funktionsaufruf möglich, den **Namen** des Parameters vor dem `:` anzugeben.  Dies wird selten verwendet, da es mehr Tippen erfordert, aber manchmal, wenn es die Lesbarkeit des Codes erheblich verbessert, können wir es in Betracht ziehen.

Allerdings wird die UI nur dann aktualisiert - und damit die im `canExecute` angegebene Funktion nur dann aufgerufen -, wenn das `ICommand.CanExecuteChanged`-Ereignis ausgelöst wird.

Dieses Ereignis können wir durch die `IRelayCommand`-Schnittstelle (das auch `ICommand` ist) selbst auslösen, wenn wir die `NotifyCanExecuteChanged()`-Methode im Setter der `SelectedGenre`-Eigenschaft aufrufen.

Ändern wir den Typ der Eigenschaft auf `IRelayCommand`.

```csharp title="BooksPageViewModel.cs"
public IRelayCommand ClearFilterCommand { get; }
```

Die `NotifyCanExecuteChanged()`-Methode rufen wir dann in unserer bereits existierenden `OnSelectedGenreChanged` partial-Methode auf.

```csharp title="BooksPageViewModel.cs" hl_lines="4"
partial void OnSelectedGenreChanged(string value)
{
    LoadBooks();
    ClearFilterCommand.NotifyCanExecuteChanged();
}
```

**Probieren wir es aus!** Jetzt wird der _Clear_-Knopf deaktiviert, wenn kein Genre ausgewählt ist.

### Command mit MVVMToolkit Code-Generator

Anstatt die `RelayCommand`-Eigenschaft manuell zu deklarieren und zu instanziieren, können wir auch das `RelayCommand`-Attribut auf einer **Methode** verwenden, die im Hintergrund automatisch den benötigten Code mit Hilfe des Code-Generators erzeugt.

* Löschen wir die zuvor verwendete `ClearFilterCommand`-Eigenschaft und die Instanziierung im Konstruktor.

* Erstellen wir stattdessen eine neue Methode namens `ClearFilter`, die mit dem `RelayCommand`-Attribut im Hintergrund automatisch die benötigte Command-Eigenschaft generiert.

    ```csharp title="BooksPageViewModel.cs"
    [RelayCommand]
    private void ClearFilter() => SelectedGenre = null;
    ```

* Für die `CanExecute`-Logik können wir eine andere Methode oder Eigenschaft aufrufen, die angibt, ob der Befehl ausführbar ist.

    ```csharp title="BooksPageViewModel.cs" hl_lines="1 3"
    private bool IsClearFilterCommandEnabled => SelectedGenre != null;

    [RelayCommand(CanExecute = nameof(IsClearFilterCommandEnabled))]
    private void ClearFilter() => SelectedGenre = null;
    ```

**Probieren wir es aus!** Es sollte wie bisher funktionieren (nur jetzt wird die `ClearFilterCommand`-Eigenschaft vom Code-Generator erstellt).

Außerdem kann `NotifyCanExecuteChanged` auch deklarativ durch Attribute ausgelöst werden.  
In unserem Fall verbinden wir die Änderung von `SelectedGenre` mit der Ausführbarkeit des `ClearFilterCommand` mittels `NotifyCanExecuteChangedFor`.  
So können wir das Auslösen des Ereignisses aus unserer `OnSelectedGenreChanged`-Partial-Methode entfernen.

```csharp title="BooksPageViewModel.cs" hl_lines="2"
[ObservableProperty]
[NotifyCanExecuteChangedFor(nameof(ClearFilterCommand))]
private string _selectedGenre;

partial void OnSelectedGenreChanged(string value)
{
    LoadBooks();
}
```

**Probieren wir es aus!** Es sollte wie zuvor funktionieren.

??? tip "Wenn das Command-Muster nicht direkt unterstützt wird"
    Nicht alle Steuerelemente unterstützen das `Command`-Muster direkt. In diesem Fall haben wir zwei Möglichkeiten:

    1. Wir können `x:Bind`-Datenverbindung verwenden, die nicht nur für Eigenschaften, sondern auch für Ereignishandler genutzt werden kann. So können wir auch einen Ereignishandler im ViewModel an das Steuerelement-Ereignis binden. Der Nachteil ist, dass dies das MVVM-Muster verletzen kann, da das ViewModel vom View abhängt (z. B. bezüglich der Ereignishandler-Signatur und der Parameter).
   
    2. Wir verwenden weiterhin das `Command`-Muster, aber wir können das gewünschte Ereignis des Steuerelements mit einem sogenannten Behavior an das ViewModel binden. Ein Behavior ist eine Klasse, die es ermöglicht, das Verhalten eines Steuerelements zu ändern, ohne den Steuerelement-Code direkt zu ändern. In diesem Fall müssen wir das [Microsoft.Xaml.Behaviors](https://www.nuget.org/packages/Microsoft.Xaml.Behaviors.WinUI.Managed)-Paket installieren, das bereits ein Behavior enthält, mit dem wir [Ereignisse in Command-Aufrufe umwandeln können](https://github.com/Microsoft/XamlBehaviors/wiki/InvokeCommandAction).

## Zusammenfassung

Im Labor haben wir das Ausgangsprojekt in das MVVM-Muster umgewandelt, wodurch die Verantwortlichkeiten zwischen View und ViewModel getrennt wurden:

* Das ViewModel enthält den Zustand der Ansicht und die darauf ausführbaren Aktionen, während die View nur für die Darstellung der Benutzeroberfläche verantwortlich ist.
* Zwischen View und ViewModel besteht eine lose Kopplung durch Datenverbindung, sodass das ViewModel leichter testbar und wiederverwendbar ist.
* Das ViewModel ist nicht vom View abhängig, sodass es leicht geändert oder ersetzt werden kann, ohne dass die View geändert werden muss.
* Das ViewModel enthält auch nicht die gesamte Geschäftslogik, wie zum Beispiel den Datenzugriff, sondern diese ist in einer separaten Service-Klasse untergebracht.
