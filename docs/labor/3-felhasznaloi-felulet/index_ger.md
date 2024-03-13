---
autoren: tibitoth
---
# 3. Entwurf der Benutzeroberfläche

## Das Ziel der Übung

Das Ziel der Übung ist, die Grundlagen der Entwicklung von Thick-Client-Anwendungen unter Verwendung der deklarativen XAML-Oberflächebeschreibungstechnologie zu erlernen. Die hier gelernten Grundlagen gelten für alle XAML-Dialekte (WinUI, WPF, UWP, Xamarin.Forms, MAUI) oder können auf sehr ähnliche Weise angewendet werden, aber wir werden XAML in der heutigen Übung speziell über das WinAppSDK / WinUI 3-Framework verwenden.

## Voraussetzungen

Die für die Durchführung des Labors benötigten Werkzeuge:

* Betriebssystem Windows 10 oder Windows 11 (Linux und macOS nicht geeignet)
* Visual Studio 2022
  * Windows Desktop Entwicklung Workload

    ![desktop-Arbeitslast](images/desktop-workload.png)

## Lösung

??? success "Laden Sie die fertige Lösung herunter"
    :exclamation: Es ist wichtig, dass Sie sich während des Praktikums an die Anleitung halten. Es ist verboten (und sinnlos), die fertige Lösung herunterzuladen. Allerdings kann es bei der anschließenden Selbsteinübung nützlich sein, die fertige Lösung zu überprüfen, daher stellen wir sie zur Verfügung.

    Die Lösung ist [auf GitHub](https://github.com/bmeviauab00/lab-XAML-kiindulo) im `megoldas`-Zweig verfügbar. Der einfachste Weg, es herunterzuladen, ist, mit dem `git clone`-Befehl von der Kommandozeile aus zu klonen:

    `git clone https://github.com/bmeviauab00/lab-xaml-kiindulo -b megoldas`

    Sie müssen Git auf Ihrem Rechner installiert haben, weitere Informationen [hier](../../hazi/git-github-github-classroom/index.md#git-telepitese).

## Ursprüngliches Projekt

In der ersten Aufgabe werden wir die Umgebung einrichten, in der wir die Funktionalität der XAML-Sprache und des WinUI-Frameworks untersuchen werden. Das anfängliche Projekt könnte mit Visual Studio erstellt werden (WinUI 3 Projekt, *Blank App, Packaged (WinUI 3 in Desktop)* type), aber um den Ablauf der Übung zu vereinfachen, werden wir das vorgefertigte Projekt verwenden.

Wir können das Projekt auf unseren Rechner klonen, mit dem folgenden Befehl:

```cmd
git clone https://github.com/bmeviauab00/lab-xaml-kiindulo.git
```

Öffnen wir `HelloXaml.sln`.

Schauen wir uns an, welche Dateien in dem Projekt enthalten sind:

* App
    * Zwei Dateien `App.xaml` und `App.xaml.cs`(später zu klärende zwei Dateien gehören dazu)
    * Eintrittspunkt in die Anwendung: `OnLaunched` überschriebene Method in `App.xaml.cs`
    * In unserem Fall initialisieren wir das einzige Fenster der Anwendung hier `MainWindow`
* MainWindow
    * Zu dem Hauptfenster unserer Anwendung gehörende .xaml und .xaml.cs Dateien.

??? Note "Zusätzliche Lösungselemente"
    Die ursprüngliche VS-Lösung enthält auch die folgenden Elemente:

    * Dependencies
        * Frameworks
            * `Microsoft.AspNetCore.App`: .NET SDK-Metapaket (verweist auf Microsoft .NET und SDK-Basispakete)
            * Windows-spezifisches .NET SDK
        * Packages
            * Windows SDK Build Tools
            * WindowsAppSDK
    * Assets
        * Anwendungslogos
    * app.manifest, Package.appxmanifest
        * Eine XML-Datei mit den Metadaten der Anwendung, in der wir, unter anderem, Logos angeben oder, wie bei Android, den Zugriff auf sicherheitskritische Systemressourcen anfordern können.

**Starten wir die Anwendung!**

## XAML-Einführung

Die Schnittstelle wird in einer XML-basierten Beschreibungssprache, XAML (ausgesprochen: zemöl), beschrieben.

!!! tip "Grafische Designeroberfläche"
    Bei einigen XAML-Dialekten (z.B.: WPF) steht auch ein grafisches Designer-Tool für die Gestaltung der Oberfläche zur Verfügung, das jedoch in der Regel eine weniger effiziente XAML-Beschreibung erzeugt. Darüber hinaus unterstützt Visual Studio bereits Hot Reload für XAML, so dass die Anwendung während der Bearbeitung der XAML nicht angehalten werden muss und die Änderungen sofort in der laufenden Anwendung sichtbar sind. Daher gibt es für WinUI keine Designer-Unterstützung mehr in Visual Studio. Die Erfahrung hat gezeigt, dass es Grenzen gibt, wobei "größere" Änderungen einen Neustart der Anwendung erfordern.

### Grundlagen der XAML-Sprache

Die XAML-Sprache:

* Sprache für Objektinstanziierung
* Standard-XML
* XML-Elemente/Tags: instanziieren Objekte, deren Klassen Standard-.NET-Klassen sind
* XML-Attribute: Eigenschaften (dependency properties) werden festgelegt
* Deklarativ

Schauen wir uns die von der Projektvorlage generierte XAML (`MainWindow.xaml`) an.
Wir können sehen, dass für jedes Steuerelement in der XAML ein XML-Element/Tag erstellt wurde.
Und die Eigenschaften der Steuerelementen werden auf die Tags der Steuerelementen gesetzt. Z.B. `HorizontalAlignment`: Ausrichtung innerhalb eines Containers (in unserem Fall Fenster).
Steuerelemente können andere Steuerelemente enthalten, wodurch ein Baum von Steuerelementen entsteht.

Schauen wir uns `MainWindow.xaml`genauer an:

* Namensräume auf dem Root-Tag: definieren, welche Tags und Attribute in XML verwendet werden können
    * Standardnamensraum: Namensraum der XAML-Elemente/Steuerelemente (z. B. `Button`, `TextBox` usw.)
    * `x` Namensraum: XAML-Parser-Namensraum (z. B.: `x:Class`, `x:Name`)
    * Andere beliebige Namespaces können referenziert werden
* `Window` Wurzelelement:
    * Auf der Grundlage unseres Fensters/unserer Seite erstellen wir eine .NET-Klasse, die von der Klasse `Window` abgeleitet ist.
    * Der Name unserer abgeleiteten Klasse wird durch das Attribut `x:Class` definiert: Auf der Grundlage von `x:Class="HelloXaml.MainWindow"` wird eine Klasse namens `MainWindow` im Namensraum `HelloXaml` erstellt.
    * Dies ist eine Teilklasse, die "andere Hälfte" der Klasse befindet sich in der Code-Behind-Datei (`MainWindow.xaml.cs`) für das Fenster/die Seite. Siehe nächster Punkt.
* Code-Behind-Datei (`MainWindow.xaml.cs`):
    * Die andere "Hälfte" unserer partiellen Klasse: Überprüfen wir, ob der Name und der Namensraum der Klasse hier derselbe ist wie in der .xaml-Datei (partielle Klasse!).
    * Hier werden u.a. Ereignishandler und Hilfsfunktionen untergebracht.
    * `this.InitializeComponent();` muss immer im Konstruktor aufgerufen werden, er liest die XAML zur Laufzeit ein, er initialisiert den Inhalt des Fensters/der Seite (d.h. die in der XAML-Datei angegebenen Controls mit den dort definierten Eigenschaften).

Löschen wir den Inhalt von `Window` und den Ereignishandler aus der Code-Behind-Datei (Funktion`myButton_Click` ).
Jetzt werden wir XAML manuell schreiben, um die Oberfläche0 zu erstellen. Fügen wir ein `Grid`zu `Window`hinzu, mit dem wir später ein Tabellenlayout erstellen können:

```xml hl_lines="11 13"
<?xml version="1.0" encoding="utf-8"?>
<Window
    x:Class="HelloXaml.MainWindow"
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    xmlns:local="using:HelloXaml"
    xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
    xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
    mc:Ignorable="d">

    <Grid>
        
    </Grid>
</Window>
```

Führen wir die Anwendung aus (z. B. mit ++f5++ ). Die `Grid` füllt das gesamte Fenster aus, ihre Farbe ist dieselbe wie die Hintergrundfarbe des Fensters, so dass man sie mit dem Auge nicht mehr unterscheiden kann.

In den folgenden Aufgaben lassen wir die Anwendung laufen, damit wir die Änderungen, die wir an der Schnittstelle vorgenommen haben, sofort sehen können.

!!! warning "Hot Reload Limitations"
    Beachten wir die Einschränkungen von Hot Reload: Wenn eine Änderung nicht in der laufenden Anwendung erscheinen soll, müssen wir die Anwendung neu starten!

### Objektinstanzen und ihre Eigenschaften

Sehen wir uns an, wie wir Objekte auf der Grundlage von XAML instanziieren und die Eigenschaften dieser Objekte festlegen können.

Fügen wir `Button`innerhalb der `Grid` hinzu. Die Eigenschaft `Content` wird verwendet, um den Text des Knopfs, genauer gesagt seinen Inhalt, anzugeben.

```xml
<Button Content="Hello WinUI App!"/>
```

Dadurch wird zur Laufzeit ein Objekt `Button` an der Stelle erzeugt, an der es deklariert ist, und die Eigenschaft `Content` auf "Hello WinUI App!" gesetzt. Dies hätte in C# in der Code-Behind-Datei wie folgt geschehen können (was jedoch zu weniger lesbarem Code führen würde):

```csharp
// z.B. am Ende des Konstruktors geschrieben:

Button b = new Button();
b.Content = "Hello WinUI App!";
rootGrid.Children.Add(b); 
// Für die vorherige Zeile sollte das Attribut x:Name="rootGrid" des Grids in der XAML-Datei angegeben
// werden, um das Grid mit dem Namen rootGrid aus dem Code-Behind-Datai zu erreichen.
```

:exclamation: Dieses Beispiel verdeutlicht sehr gut, dass XAML im Grunde eine Objektinstanziirungs-Sprache ist und das Setzen von Eigenschaften von Objekten unterstützt.

Die Eigenschaft `Content` ist eine Besonderheit: Sie kann nicht nur in einem XML-Attribut, sondern auch innerhalb eines Tags (XML-Element) angegeben werden.

```xml
<Button>Hello WinUI App!</Button>
```

Sogar! Wir können nicht nur eine Beschriftung auf die Taste setzen, sondern auch jedes andere Element, das wir möchten. Fügen wir zum Beispiel einen roten Kreis ein. Der Kreis ist 10 Pixel breit, 10 Pixel hoch und die Farbe (`Fill`) ist rot.

```xml
<Button>
    <Ellipse Width="10" Height="10" Fill="Red" />
</Button>
```

Dies konnte mit früheren .NET UI-Technologien (z. B. Windows Forms) nicht so einfach erreichen.

Neben dem roten Kreis steht nun *Record* (um den Sinn der roten Kreistaste zu verdeutlichen). Die Taste kann nur ein untergeordnetes Element haben, daher müssen wir den Kreis und den Text (`TextBlock`) in ein Layout-Steuerelement (z. B. ein `StackPanel`) einfügen. Fügen wir außerdem einen linken Rand zu `TextBlock`hinzu, damit sie sich nicht berühren.

```xml
<Button>
    <StackPanel Orientation="Horizontal">
        <Ellipse Width="10" Height="10" Fill="Red" />
        <TextBlock Text="Record" Margin="10,0,0,0" />
    </StackPanel>
</Button>
```

 `StackPanel` ist ein einfaches Layout-Panel für die Anordnung von Steuerelementen: Die darin enthaltenen Steuerelemente werden nebeneinander angeordnet, wenn `Horizental` `Orientation` angegeben ist, und untereinander, wenn `Vertical` `Orientation` angegeben ist. In unserem Beispiel legen wir also einfach die beiden Steuerelemente nebeneinander.

Das Ergebnis ist:

![aufnahmetaste](images/record-button.png)

!!! note "XAML-Vektorgrafik-Controller"
    Es ist wichtig zu beachten, dass die meisten XAML-Controller Vektorgrafiken sind. Diese Taste sieht bei jeder DPI oder Vergrößerung genauso scharf aus (keine "Verpixelung").

Es gibt drei Optionen für die Angabe von Eigenschaften von XAML-instanziierten Steuerelementen (von denen wir einige bereits verwendet haben):

* Property ATTRIBUTE syntax
* Property ELEMENT syntax
* Property CONTENT syntax

Schauen wir uns diese Optionen nun genauer an:

1. **Property ATTRIBUTE syntax**.  Wir haben sie bereits in unserem allerersten Beispiel verwendet:

    ```xml
    <Button Content="Hello WinUI App!"/>
    ```

    Der Name kommt daher, dass die Eigenschaft als **XML-Attribut** angegeben wird. Da XML-Attribute nur Strings sein können, können sie nur für den Zugriff auf einfache Zahlen-, String- usw. Werte in Stringform oder auf Mitgliedsvariablen und Ereignishandler, die in einer Code-Behind-Datei definiert sind, verwendet werden. Wir können aber auch "komplexe" Objekte mit Hilfe von Typkonvertern angeben. Wir werden nicht viel darüber reden, aber wir benutzen die eingebauten Typkonverter sehr oft, praktisch "instinktiv". Beispiel:

    Fügen wir eine Hintergrundfarbe zu `Grid`hinzu:

    ```xml
    <Grid Background="Azure">
    ```

    Oder wir können es in Hexadezimal angeben:

    ```xml
    <Grid Background="#FFF0FFFF">
    ```

    Der Rand (`Margin`) ist ebenfalls ein zusammengesetzter Wert, wobei der zugehörige Typkonverter **durch ein Komma (oder ein Leerzeichen) getrennt ist und Werte für die vier Seiten (links, oben, rechts, unten) erwartet werden**. Wir haben es bereits für unseren TextBlock mit `Record` verwendet. Hinweis: wir können eine einzige Zahl für den Rand angeben, die dann für alle vier Seiten gleich ist.

1. **Property ELEMENT syntax**. Es ermöglicht uns, eine Eigenschaft auf ein komplex instanziiertes/parametrisiertes Objekt zu setzen, ohne Typkonverter zu verwenden. Schauen wir uns das anhand eines Beispiels an.
    * Im obigen Beispiel wird durch die Einstellung der Eigenschaft `Background` auf `Azure` tatsächlich ein `SolidColorBrush`mit der Farbe hellblau erstellt. Dies kann ohne Verwendung eines Typkonverters wie folgt angegeben werden:
    
    ```xml
    <Grid>
        <Grid.Background>
            <SolidColorBrush Color="Azure" />
        </Grid.Background>
        ...
    ```

    Damit wird die Eigenschaft `Grid` `Background` auf die angegebene `SolidColorBrush`gesetzt. Dabei handelt es sich um die so genannte "property element syntax"-basierte Eigenschaftsübermittlung.
      
      * Der Name kommt daher, dass die Eigenschaft in Form eines XML-Elements (und nicht eines XML-Attributs) angegeben wird.
      * :exclamation: Hier erstellt `<Grid.Background>` keine Objektinstanz, sondern setzt den Wert der angegebenen Eigenschaft (in diesem Fall `Background`) auf die entsprechende Objektinstanz (in diesem Fall `SolidColorBrush`). Sie erkennen dies an dem Punkt im Namen des XML-Elements.
      * Dadurch erhält man eine "expansivere" Formeigenschaft, jedoch mit voller Flexibilität. 
      
    Ersetzen wir `SolidColorBrush`durch eine `Brush` mit Farbübergang (`LinearGradientBrush`):
    
    ```xml
    <Grid>
        <Grid.Background>
            <LinearGradientBrush>
                <LinearGradientBrush.GradientStops>
                    <GradientStop Color="Black" Offset="0" />
                    <GradientStop Color="White" Offset="1" />
                </LinearGradientBrush.GradientStops>
            </LinearGradientBrush>
        </Grid.Background>
        ...
    ```

    Für `LinearGradientBrush` gibt es keinen Typkonverter, er kann nur mit der Elementsyntax angegeben werden!

     Es ist eine Frage, wie ist es möglich, dass die `Background` Eigenschaft des `Grid` Steuerelements sowohl `SolidColorBrush` und `LinearGradientBrush` Pinsel haben könnte? Die Antwort ist ganz einfach: Polymorphismus macht dies möglich:

     *  Die Klassen `SolidColorBrush` und `LinearGradientBrush` sind beide aus der eingebauten Klasse `Brush` abgeleitet. 
     *  Die Eigenschaft `Background` ist eine Eigenschaft des Typs `Brush`, so dass aufgrund der Polymorphie jeder Nachkomme dieser Eigenschaft verwendet werden kann.

    ??? note Hinweise
        * Wenn in den obigen Beispielen `Color` (Farbe) angegeben ist, z. B. `Color="Azure"`, erstellt der Typkonverter auch eine blaue `Color` -Instanz von `Azure`.  So würde unser vorheriges Beispiel, das auf `SolidColorBrush` basiert, vollständig erklärt aussehen:
        ```xml
        <Grid>
            <Grid.Background>
                <SolidColorBrush>
                    <SolidColorBrush.Color>
                        <Color>#FFF0FFFF</Color>
                    </SolidColorBrush.Color>
                </SolidColorBrush>
            </Grid.Background>
            ...
        ```
        * Wo unterstützt, lohnt es sich, die Vorteile von Typkonvertern zu nutzen und die Attributsyntax zu verwenden, um eine ausführliche XAML-Beschreibung zu vermeiden.
        * Bei Werttypen (`struct`), wie z. B. `Color`, muss der Wert bei der Instanziierung des Objekts ("Konstruktorzeit") angegeben werden, d. h. hier können wir die Eigenschaften nicht separat festlegen, sondern müssen sich auf die Typkonverter verlassen.

2. **Property CONTENT syntax**. Um das besser zu verstehen, schauen wir uns die drei Möglichkeiten an, die `Content` Eigenschaft einer Taste auf einen Text zu setzen (wir müssen das nicht im Labor machen, schauen wir es sich einfach zusammen in diesem Leitfaden an):
   
      * Property **attribute** syntax (bereits verwendet):
        ```xml
        <Button Content="Hello WinUI App!"/>
        ```
      * Richten wir sie mit der property **element** syntax ein, die wir im vorigen Abschnitt gelernt haben:
       ```xml
       <Button>
           <Button.Content>
           Hello WinUI App!
           </Button.Content>
       </Button>
       ```
       * Jedes Steuerelement kann für sich selbst eine spezielle Eigenschaft "Content" definieren, für die die öffnenden und schließenden Tags nicht gedruckt werden müssen. Das heißt, die öffnenden und schließenden Tags `<Button.Content>`, die im vorigen Beispiel verwendet wurden, können für diese eine Eigenschaft weggelassen werden:
       ```xml
       <Button>
           Hello WinUI App!
       </Button>
       ```
       Oder in einer einzigen Zeile geschrieben werden:
       ```xml
       <Button>Hello WinUI App!</Button>
       ```
       Dies ist bekannt, wir haben es in unserem Einführungsbeispiel gesehen: dies ist die so genannte **Property CONTENT syntax**-basierte Eigenschaftsdeklaration. Der Name deutet auch darauf hin, dass diese eine Eigenschaft im "Content"-Teil des Steuerelements angegeben werden kann. Nicht alle Steuerelemente haben `Content` als Namen für diese besondere Eigenschaft:  `StackPanel`und `Grid`haben `Children` als Namen. Erinnern wir uns, oder schauen wir uns den Code an: wir haben diese bereits verwendet: allerdings haben wir die XML-Elemente `StackPanel.Children` oder `Grid.Children` nicht ausgeschrieben, wenn wir das Innere von `StackPanel` oder `Grid` angegeben haben (aber wir hätten es tun können!)

Ändern wir den Hintergrund von `Grid` wieder in etwas sympathisch Einfaches, oder löschen wir die Hintergrundfarbe.

### Ereignis-Management

XAML-Anwendungen sind ereignisgesteuerte Anwendungen. Alle Benutzerinteraktionen werden durch Ereignisse gemeldet, die zur Aktualisierung der Oberfläche verwendet werden können.

Jetzt geht es um das Klicken auf die Taste.

Als vorbereitenden Schritt geben wir unserem `TextBlock` Steuerelement einen Namen, damit wir später in der Code-Behind-Datei darauf verweisen können:

```xml
<TextBlock x:Name="recordTextBlock" Text="Record" Margin="10,0,0,0" />
```

Die `x:Name` ist für den XAML-Parser und erstellt eine Member-Variable in unserer Klasse mit diesem Namen, die den Verweis auf das angegebene Steuerelement enthält. :exclamation: Denken wir darüber nach: da es sich um eine Membervariable ist, können wir es in der Code-Behind-Datei erreichen, da es sich einen "partiellen Teil" der gleichen Klasse ist!

!!! tip "Benannte Steuerelemente"
    Benennen wir keine Steuerelemente, auf die wir nicht verweisen wollen. (Wir sollten uns angewöhnen, nur auf das zu verweisen, was wir wirklich brauchen. Auch die Datenverknüpfung ist hilfreich)

    Eine Ausnahme: Wenn wir eine sehr komplexe Kontrollhierarchie haben, können Namen helfen, den Code transparenter zu machen, da sie im _Live Visual Tree_-Fenster erscheinen und die generierten Ereignishandlernamen ebenfalls daran ausgerichtet sind.

Behandeln wir das Ereignis `Click` der Taste und probieren wir dann den Code aus.

```xml title="MainWindow.xaml"
<Button Click="RecordButton_Click">
```

```csharp title="MainWindow.xaml.cs"
private void RecordButton_Click(object sender, RoutedEventArgs e)
{
    recordTextBlock.Text = "Recording...";
}
```

!!! tip "Erstellen von Ereignishandlern"
    Wenn wir für die Ereignishandler nicht *New Event Handler* wählen, sondern manuell den gewünschten Namen eingeben und ++f12++drücken oder Rechtsklick / Go to Definition wählen, wird der Ereignishandler in der Code-Behind-Datei generiert.

Der Ereignishandler hat zwei Parameter: das sendende Objekt (`object sender`) und den Parameter, der die Parameter/Bedingungen des Ereignisses enthält (`EventArgs e`). Schauen wir uns diese im Detail an:

* `object sender`: Der Auslöser des Ereignisses. In diesem Fall handelt es sich um die Taste selbst, die unter `Button`zu finden ist. Wir verwenden diesen Parameter nur selten.
* Der zweite Parameter ist immer vom Typ `EventArgs` oder dessen Nachkomme (je nach Art des Ereignisses), in dem die Parameter des Ereignisses zurückgegeben werden. Für das Ereignis `Click` ist dies der Typ `RoutedEventArgs`. 
  
!!! Hinweis "Ereignisargumente"
    Einige Ereignisargumenttypen:

      * routedEventArgs": wird z. B. im Falle des Ereignisses "Click" verwendet, wie in unserem Beispiel. In der Eigenschaft "OriginalSource" wird das Steuerelement angegeben, in dem das Ereignis zuerst ausgelöst wurde.
          * Beachten wir, dass es im obigen Fall die Taste selbst ist, aber wenn wir ein Mausklick-Ereignis (nicht `Click`, sondern `PointerPressed`) auf z.B. `StackPanel` behandeln würden, könnten wir eines seiner Kindelemente erhalten, wenn es angeklickt wird.
      * keyRoutedEventArgs": z.B. für ein "KeyDown"-Ereignis (Tastendruck), erhalten wir die gedrückte Taste darin.
      * pointerRoutedEventArgs": wird z.B. für das "PointerPressed"-Ereignis (Maus-/Stiftdruck) verwendet und kann u.a. dazu verwendet werden, die Koordinaten des Klicks zu ermitteln.
  
Die XAML-Ereignishandler basieren vollständig auf C#-Ereignissen (Schlüsselwort`event`, siehe [vorherige Übung](../2-nyelvi-eszkozok/index_ger.md#3-aufgabe-ereignis-event)):

Z.B. eine

```xml
<Button Click="RecordButton_Click">
```

ist dafür ausgebildet:

```csharp
Button b = new Button();
b.Click += RecordButton_Click;
```



## Layout, Gestaltung

Die Anordnung der Steuerelemente wird durch zwei Faktoren bestimmt:

1. Layout-Steuerelemente (panel) und ihre angefügte Eigenschaften (attached property)
2. Allgemeine Positionseigenschaften innerhalb des übergeordneten Steuerelements (z. B. Rand, vertikale oder horizontale Ausrichtung)

Eingebaute Layout-Steuerelemente zum Beispiel:

* `StackPanel`: Elemente untereinander oder nebeneinander
* `Grid`: Wir können ein Raster festlegen, an dem sich die Elemente ausrichten
* `Canvas`: Wir positionieren die Elemente explizit durch Angabe ihrer X- und Y-Koordinaten
* `RelativePanel`: Die Beziehung der Elemente zueinander kann durch Nebenbedingungen definiert werden

Versuchen wir es mit `Grid`(wir verwenden dies normalerweise, um das grundlegende Layout unseres Fensters/unserer Seite einzurichten). Wir werden eine Oberfläche erstellen, über die man Personen zu einer Liste hinzufügen kann, indem man ihren Namen und ihr Alter eingeben kann. Unser Ziel ist es, das folgende Layout zu erstellen:

![anwendungs-UI](images/app-ui.gif)

Einige wichtige Verhaltensbeschränkungen:

* Wenn die Größe des Fensters geändert wird, sollte das Formular eine feste Breite haben und zentriert bleiben.
* In der Zeile Alter erhöht die Taste + das Alter, die Taste - verringert es.
* Die Taste Hinzufügen fügt die Person mit den oben angegebenen Daten zur unteren Liste hinzu (die Abbildung zeigt die Daten von zwei Personen in der unteren Liste).

Definieren wir die Wurzel `Grid`als 4 Zeilen und 2 Spalten. Die erste Spalte sollte die Bezeichnungen und die zweite Spalte die Eingabefelder enthalten. Setzen wir unsere vorhandene Taste in Zeile 3 und ändern wir ihren Inhalt auf *Add*, und ersetzen wir den Kreis durch `SymbolIcon`. Geben wir in Zeile 4 eine Liste ein, die 2 Spalten einnehmen sollte.

```xml
<Grid x:Name="rootGrid">
    <Grid.RowDefinitions>
        <RowDefinition Height="Auto" />
        <RowDefinition Height="Auto" />
        <RowDefinition Height="Auto" />
        <RowDefinition Height="*" />
    </Grid.RowDefinitions>
    <Grid.ColumnDefinitions>
        <ColumnDefinition Width="Auto" />
        <ColumnDefinition Width="*" />
    </Grid.ColumnDefinitions>

    <TextBlock Grid.Row="0" Grid.Column="0" Text="Name"/>
    <TextBox Grid.Row="0" Grid.Column="1" />
    <TextBlock Grid.Row="1" Grid.Column="0" Text="Age"/>
    <TextBox Grid.Row="1" Grid.Column="1" />

    <Button Grid.Row="2" Grid.Column="1">
        <StackPanel Orientation="Horizontal">
            <SymbolIcon Symbol="Add" />
            <TextBlock Text="Add" Margin="5,0,0,0"/>
        </StackPanel>
    </Button>
    
    <ListView Grid.Row="3" Grid.Column="0" Grid.ColumnSpan="2"/>
</Grid>
```

Für die Zeilen- und Spaltendefinitionen können wir angeben, ob die Zeile die Größe ihres Inhalts einnehmen soll (`Auto`) oder den verbleibenden Platz ausfüllen soll (`*`), oder sogar eine feste Breite in Pixeln (`Width` Eigenschaft).
Wenn es mehrere `*` in den Definitionen gibt, können sie skaliert werden, z.B. `*` und `*` haben ein Verhältnis von 1:1, während `*` und `3*` ein Verhältnis von 1:3 haben.

Die `Grid.Row`, `Grid.Column` werden als **Attached Properties** (angefügte Eigneschaften) bezeichnet. Das bedeutet, dass der Controller, auf den sie angewendet wird, diese Eigenschaft nicht besitzt und diese Information nur "angehängt" wird. In unserem Fall sind diese Informationen für `Grid`wichtig, um Ihre Kinder unterzubringen. Der Standardwert für `Grid.Row` und `Grid.Column` ist 0, so dass wir dies gar nicht schreiben sollten.

!!! note "Imperative UI-Beschreibung"
    In anderen UI-Frameworks, in denen die UI imperativ ist, wird dies einfach mit Funktionsparametern gelöst - z.B.: `myPanel.Add(new TextBox(), 0, 1)`.

Die angefügte Eigenschaft `Grid.ColumnSpan="2"` unter `ListView`bedarf vielleicht einer Erklärung: `ColumnSpan` und `RowSpan` definieren die Anzahl der Spalten und Zeilen, die das Steuerelement "umspannen". In unserem Beispiel füllt `ListView` beide Spalten.

Probieren wir die Anwendung aus (wenn der Code nicht funktioniert, löschen wir den Ereignishandler im Code hinter der Datei `RecordButton_Click` ).

In seinem derzeitigen Zustand füllt `Grid` den gesamten Raum sowohl horizontal als auch vertikal aus. Was ist der Grund dafür? Eines der grundlegenden Merkmale des Layouts der Steuerelemente sind ihre Eigenschaften `HorizontalAlignment` und `VerticalAlignment`.   **Diese bestimmen, wo der Controller horizontal und vertikal in dem ihn enthaltenden Container (d. h. dem übergeordneten Controller) positioniert werden soll**. Die möglichen Werte:

* `VerticalAlignment`: `Top`, `Center`, `Bottom`, `Stretch`(oben, mittig, unten ausgerichtet oder vertikal ausfüllen)
* `HorizontalAlignment`: `Left`, `Center`, `Right`, `Stretch` (links-, zentriert-, rechtsbündig oder horizontal ausfüllen)   

(Hinweis: Für Stretch ist es erforderlich, dass die Eigenschaft `Height` oder `Width` für den Controller nicht angegeben ist)

Unserem `Grid`wurden die Eigenschaften `HorizontalAlignment` und `VerticalAlignment` nicht zugewiesen, so dass sein Wert standardmäßig `Stretch` für das Raster ist, weshalb `Grid` den Raum im übergeordneten Container, dem Fenster, in beide Richtungen füllt.

Unsere Oberfläche sieht nicht so aus, wie wir sie haben wollen, also müssen wir sie noch ein wenig optimieren. Die vorzunehmenden Änderungen:

* Die Tabelle muss nicht den ganzen Bildschirm ausfüllen, sondern sollte horizontal in der Mitte liegen
    * `HorizontalAlignment="Center"`
* 300px breit machen
    * `Width="300"`
* Halten wir 10px zwischen den Zeilen, 5px zwischen den Spalten und 20px vom Rand des Containers
    * `RowSpacing="5" ColumnSpacing="10" Margin="20"`
* Richten wir die Bezeichnungen (`TexBlock`) vertikal in der Mitte aus
    * `VerticalAlignment="Center"`
* Richten wir die Taste nach rechts aus
    * `HorizontalAlignment="Right"`
* Machen wir die Liste identifizierbar
    * `BorderThickness="1"` und `BorderBrush="DarkGray"`

```xml hl_lines="2-6 18 20 23 33-34"
<Grid x:Name="rootGrid"
      Width="300"
      HorizontalAlignment="Center"
      Margin="20"
      RowSpacing="5"
      ColumnSpacing="10">
    <Grid.RowDefinitions>
        <RowDefinition Height="Auto" />
        <RowDefinition Height="Auto" />
        <RowDefinition Height="Auto" />
        <RowDefinition Height="*" />
    </Grid.RowDefinitions>
    <Grid.ColumnDefinitions>
        <ColumnDefinition Width="Auto" />
        <ColumnDefinition Width="*" />
    </Grid.ColumnDefinitions>

    <TextBlock Grid.Row="0" Grid.Column="0" Text="Name" VerticalAlignment="Center"/>
    <TextBox Grid.Row="0" Grid.Column="1" x:Name="tbName" />
    <TextBlock Grid.Row="1" Grid.Column="0" Text="Age" VerticalAlignment="Center"/>
    <TextBox Grid.Row="1" Grid.Column="1" x:Name="tbAge"/>

    <Button Grid.Row="2" Grid.Column="1" HorizontalAlignment="Right">
        <StackPanel Orientation="Horizontal">
            <SymbolIcon Symbol="Add"/>
            <TextBlock Text="Add" Margin="5,0,0,0" />
        </StackPanel>
    </Button>

    <ListView Grid.Row="3"
              Grid.Column="0"
              Grid.ColumnSpan="2"
              BorderThickness="1"
              BorderBrush="DarkGray"/>
</Grid>
```

Erweitern wir unser Formular um zwei weitere Tasten (+/- Tasten für das Alter, siehe vorheriges animiertes Bildschirmfoto):

* -': auf der linken Seite von `TextBox` 
* +' auf der rechten Seite von`TextBox` 
  
Dazu nehmen wir anstatt die Zeile (mit Löschen)

```xml
<TextBox Grid.Row="1" Grid.Column="1" x:Name="tbAge"/>
```

ein `Grid` mit 1 Zeile und 3 Spalten :

```xml
<Grid Grid.Row="1" Grid.Column="1" ColumnSpacing="5">
    <Grid.ColumnDefinitions>
        <ColumnDefinition Width="Auto" />
        <ColumnDefinition Width="*" />
        <ColumnDefinition Width="Auto" />
    </Grid.ColumnDefinitions>

    <Button Grid.Row="0" Grid.Column="0" Content="-" />
    <TextBox Grid.Row="0" Grid.Column="1" x:Name="tbAge" />
    <Button Grid.Row="0" Grid.Column="2" Content="+" />
</Grid>
```

!!! tip "Verschachtelung mehrerer Layout-Steuerelemente"
    Sie fragen sich vielleicht, warum wir nicht zusätzliche Spalten und Zeilen in das externe `Grid`(durch Anwendung von `ColumnSpan` auf die vorhandenen Steuerelemente) eingefügt haben.
    Stattdessen folgten wir dem Prinzip der Vereinheitlichung: Die neu eingeführten Steuerelemente sind im Wesentlichen ein Element, so dass wir eine transparentere Lösung erhielten, indem wir sie in ein separates `Grid` Steuerelement einfügten.
    Die Erweiterung des externen `Grid` wäre gerechtfertigt, wenn wir aufgrund von Leistungsproblemen bei der Erstellung von Steuerelementen sparen wollten. In unserem Fall ist dies nicht gerechtfertigt.

Wir sind fertig mit dem Aussehen unseres einfachen Formulars.

## Datenverbindung

### Binding

Im nächsten Schritt soll es möglich sein, die Daten einer Person in das soeben erstellte kleine Formular einzugeben und zu ändern.
Erstellen wir dazu zunächst eine Datenklasse namens `Person` in einem neu erstellten Ordner `Models` im Projekt.

```csharp
public class Person
{
    public string Name { get; set; }
    public int Age { get; set; }
}
```

Wir wollen die beiden Eigenschaften hier an die `TextBox` Steuerelemente binden, also verwenden wir die Datenbindung.
Führen wir in der Code-Behind-Datei unseres Fensters eine Eigenschaft ein, die auf ein Objekt `Person` verweist, und geben wir ihr im Konstruktor einen Anfangswert:

```csharp
public Person NewPerson { get; set; }

public MainWindow()
{
    InitializeComponent();

    NewPerson = new Person()
    {
        Name = "Eric Cartman",
        Age = 8
    };
}
```

Im nächsten Schritt werden die Eigenschaften des oben genannten Objekts `NewPerson` zu die `Text` Eigenschaft der geigneten Textfelder gebunden:

* die Eigenschaft `Name` zu die `Text` Eigenschaft von `tbName` `Textbox` 
* die Eigenschaft `Age` zu die `Text` Eigenschaft von `tbAge` `Textbox` 

 Wir verwenden Datenverbindung (data binding) dafür:

```xml
Text="{x:Bind NewPerson.Name}"
Text="{x:Bind NewPerson.Age}"
```
(fügen wir die oben genannten 1-1 Eigenschaftseinstellungen in die Zeilen von `tbName` und `tbAge` `TextBox`ein)

!!! danger "Wichtig"
    Bei der Datenverbindung geht es darum, dass anstatt die Eigenschaften (in unserem Fall den Text) der Steuerelemente in der Oberfläche von der Code-Behind-Datei aus manuell einstellen, werden die Eigenschaften mit dem Datenverbindungsmechanismus der Plattform zusammengesetzt/verbunden. So können wir auch dafür sorgen, dass sich bei einer Änderung einer Eigenschaft die andere automatisch ändert!

Die Syntax `Text="{x:Bind}"` wird als Markup Extension bezeichnet: Sie hat eine besondere Bedeutung für den XAML-Prozessor. Dies ist der Hauptgrund, warum wir XAML und nicht einfaches XML verwenden.
Es ist auch möglich, eine eigene Markup Extension zu erstellen, aber dies ist kein Material des Kurses.

Laufen wir die Anwendung! Es ist zu erkennen, dass den Namen und das Alter, die in den Eigenschaften `Name` und `Age` des Objekts `NewPerson` (als Datenquelle) angegeben sind, wegem der Datenverbindung automatisch in die `Text` Eigenschaften beider `TextBox`  übernommen wurden.

### Benachrichtigung über Änderungen

Implementieren wir die `Click` Ereignishandler für die Tasten +/- . 

```xml
<Button Grid.Row="1" Grid.Column="0" Content="-" Click="DecreaseButton_Click"/>
<!-- ... -->
<Button Grid.Row="1" Grid.Column="2" Content="+" Click="IncreaseButton_Click"/>
```

```csharp
private void DecreaseButton_Click(object sender, RoutedEventArgs e)
{
    NewPerson.Age--;
}

private void IncreaseButton_Click(object sender, RoutedEventArgs e)
{
    NewPerson.Age++;
}
```

Aufgrund der Datenverbindung, die im vorherigen Abschnitt eingeführt wurde, würden wir erwarten, dass, wenn wir die Eigenschaft `Age` der Datenquelle `NewPerson` in den obigen Ereignishandlern ändern, unser Steuerelement `tbAge` `Textbox` auf unserer Oberfläche dies verfolgen würde. Probieren wir es aus! Dies funktioniert noch nicht, da es die **Implementierung der Schnittstelle `INotifyPropertyChanged`** erfordert.

1. Implementieren wir die Schnittstelle `INotifyPropertyChanged` in unserer Klasse `Person`.  Wenn wir Daten an diese Klasse binden, abonniert das System das Ereignis `PropertyChanged`. Durch Auslösen dieses Ereignisses können wir die Verbindung benachrichtigen, wenn sich eine Eigenschaft geändert hat.

    ```csharp
    public class Person : INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;

        private string name;
        public string Name
        {
            get { return name; }
            set
            {
                if (name != value)
                {
                    name = value;
                    PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(Name)));
                }
            }
        }

        private int age;
        public int Age
        {
            get { return age; }
            set
            {
                if (age != value)
                {
                    age = value;
                    PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(Age)));
                }
            }
        }
    }
    ```

    !!! tip "Ist der Code zu viel?"
        In Zukunft könnte diese Logik in einer Klasse von Vorgängern organisiert werden, aber das würde zum MVVM-Muster führen, das mit einem späteren Thema verknüpft ist. Lassen wir uns also nicht von diesem etwas hässlichen Code abschrecken.

2. Bei der Datenverbindung schalten wir die Änderungsbenachrichtigung ein, indem wir sie auf `Mode` `OneWay`ändern, da der Standardmodus für `x:Bind` `OneTime` ist, was eine einmalige Datenbindung darstellt.

    ```xml
    Text="{x:Bind NewPerson.Age, Mode=OneWay}"
    ```

Probieren wir es aus! Die Ereignishandler ändern die Datenquelle (`NewPerson`), die nun auch die Oberfläche aufgrund der richtig vorbereiteten Datenverbindung ändert.

## Rückwärtige Datenbindung (vom Controller zur Datenquelle)

Wie Age sollte auch die Datenbindung für die Eigenschaft Name auf einseitig eingestellt werden:

```xml
Text="{x:Bind NewPerson.Name, Mode=OneWay}"
```

Starten wir die Anwendung und setzen wir dann einen Haltepunkt im Setter der Eigenschaft `Name` der Klasse `Person` (Zeile`if (name != value)` ), und sehen wir nach, ob die Datenverbindung in umgekehrter Richtung funktioniert: Wenn wir den Wert eines der `TextBox` ändern, ändert sich dann die Eigenschaft `Name` des Objekts `NewPerson`?  Geben wir etwas in das Textfeld ein, das mit dem Namen verknüpft ist, und klicken wir dann auf ein anderes Feld: Der Inhalt des Textfelds wird dann "abgeschlossen", sein Inhalt sollte in die Datenquelle zurückgeschrieben werden, wird aber nicht, der Code läuft nicht an unserem Haltepunkt.

Das liegt daran, dass wir oben die Datenverbindung `OneWay` verwendet haben, die nur eine Datenbindung von der Datenquelle zur Oberfläche ist. **Für den Weg zurück soll der Datenbindungsmodus auf `TwoWay` eingestellt werden.**

```xml
Text="{x:Bind Name, Mode=TwoWay}"
Text="{x:Bind Age, Mode=TwoWay}"
```

Probieren wir es aus! Auf diese Weise funktioniert die Rückwärts-Datenverbindung: Die angegebene Eigenschaft des Controllers (in unserem Fall Text) und die Datenquelle bleiben bei jeder Richtungsänderung synchron.

## Listen

Im Folgenden werden wir die Listenverbindung üben.
Fügen wir eine Liste von `Person`-Objekten in die Code-Behind-Datei unserer Ansicht ein und geben wir ihr am Ende des Konstruktors einen Anfangswert.

```csharp hl_lines="1 13-17"
public List<Person> People { get; set; }

public MainWindow()
{
    InitializeComponent();

    NewPerson = new Person()
    {
        Name = "Eric Cartman",
        Age = 8
    };

    People = new List<Person>()
    {
      new Person() { Name = "Peter Griffin", Age = 40 },
      new Person() { Name = "Homer Simpson", Age = 42 },
    };
}
```

Verwenden wir die Datenverbindung, um die Datenquelle des Steuerelements `ListView` festzulegen. Dazu sollen wir die Eigenschaft `ItemsSource` des Steuerelements `ListView` einstellen.

```xml
<ListView Grid.Row="3" Grid.ColumnSpan="2" ItemsSource="{x:Bind People}"/>
```

Probieren wir es aus!

Wir sehen, dass zwei Einträge in der Liste erschienen sind. Natürlich ist es nicht das, was wir wollen, aber das ist leicht zu ändern.
Standardmäßig ruft `ListView` `ToString()`bei Listenelementen auf, was die Eigenschaft `FullName` des Klassentyps (d.h. der Typname) ist, wenn `ToString()` nicht überschrieben wird.

Legen wir **die Eigenschaft** `ItemTemplate` **von** `ListView`fest (unter Verwendung der bekannten property element syntax), die das Aussehen des Listenelementes unter Verwendung einer Vorlage verleiht: In unserem Fall machen wir daraus ein einzelliges `Grid`, wobei `TextBlock`s die Eigenschaften von `Person` anzeigt, wobei der Name links und das Alter rechts ausgerichtet ist.

```xml
<ListView Grid.Row="3" Grid.ColumnSpan="2" ItemsSource="{x:Bind People}">
    <ListView.ItemTemplate>
        <DataTemplate x:DataType="model:Person">
            <Grid>
                <TextBlock Text="{x:Bind Name}" />
                <TextBlock Text="{x:Bind Age}" HorizontalAlignment="Right" />
            </Grid>
        </DataTemplate>
    </ListView.ItemTemplate>
</ListView>
```

**`DataTemplate` ist eine Oberflächenschablone, die von der `ListView` (er ist gegeben durch `ItemTemplate` eigenschaft) auf alle Elemente während der Anzeige angewendet wird.**

Da `x:Bind` eine Datenverbindung zur Übersetzungszeit ist, müssen wir auch den Datentyp in der Datenvorlage mit dem Attribut `x:DataType` angeben. Im obigen Beispiel haben wir `model:Person`angegeben, so dass das **Präfix** `model` dem Namensraum `HelloXaml.Models` unseres Codes zugeordnet werden soll (der die Klasse `Person` enthält). Dazu müssen wir die folgende **Namensraumdeklaration** zu den Attributen des Tags `Window` am Anfang unserer XAML-Datei hinzufügen: `xmlns:model="using:HelloXaml.Models"` (danach wird das Präfix `model` verwendet). Dies kann manuell oder mit Visual Studio erfolgen: Klicken wir einfach auf den unterstrichenen (als fehlerhaft markierten) `model:Person`Text, dann auf die Lampe am Anfang der Zeile (oder die Tastenkombination `Ctrl` + `.` ) und wählen wir das angezeigte Element *"Add xmlns using:HelloXaml.Models"*.


Probieren wir es aus! Die Einträge erscheinen nun gut in der Liste.

Klicken wir auf die Taste *Add*, um eine neue Kopie von `Person` mit den Daten der Person des Formilar zur Liste hinzuzufügen, und löschen wir dann die Formulardaten in unserem Objekt `NewPerson`. 

Fügen wir dazu unserer Taste *Add* einen `Click` Ereignishandler hinzu:

```xml
<Button ... Click="AddButton_Click">
```

```csharp hl_lines="3"
private void AddButton_Click(object sender, RoutedEventArgs e)
{
    People.Add(new Person()
    { 
        Name = NewPerson.Name,
        Age = NewPerson.Age,
    });

    NewPerson.Name = string.Empty;
    NewPerson.Age = 0;
}
```

Der neue Eintrag erscheint nicht in der Liste, da `ListView` nicht darüber informiert wird, dass ein neuer Eintrag in die Liste aufgenommen wurde. Dies kann leicht behoben werden, indem `List<Person>`durch `ObservableCollection<Person>`ersetzt wird:

```csharp
public ObservableCollection<Person> People { get; set; }
```

!!! tip "`ObservableCollection<T>`"
    Es ist wichtig zu beachten, dass sich hier nicht der Wert der Eigenschaft `People` selbst geändert hat, sondern der Inhalt des Objekts `List<Person>`. Die Lösung ist also nicht die Schnittstelle `INotifyPropertyChanged`, sondern die Schnittstelle `INotifyCollectionChanged`, die von `ObservableCollection` implementiert wird.

    Wir kennen und verwenden also bereits zwei Schnittstellen, die die Datenverbindung unterstützen: `INotifyPropertyChanged` und `INotifyCollectionChanged`.

## Ausblick: Klassische Bindung

Die klassische Form der Datenverbindung ist die `Binding` Markup Extension.

Die wichtigsten Unterschiede im Vergleich zu `x:Bind`sind:

* Der Standardmodus für `Binding` ist `OneWay` und nicht `OneTime`: Er überwacht also standardmäßig Änderungen, während dies für `x:Bind`ausdrücklich angegeben werden muss.
*  `Binding` arbeitet standardmäßig mit `DataContext`, aber es ist möglich, die Quelle für die Datenbindung festzulegen. Während `x:Bind` standardmäßig von unserer Ansichtsklasse (xaml.cs) gebunden wird.
*  `Binding` arbeitet zur Laufzeit mit Reflection, so dass Sie einerseits keine Kompilierfehler bekommen, wenn Sie etwas falsch schreiben, und andererseits können viele Datenbindungen (in der Größenordnung von 1000) Ihre Anwendung verlangsamen.
*  `x:Bind` ist kompilierbar, d. h. der Compiler prüft, ob die angegebenen Eigenschaften vorhanden sind. In Datenvorlagen müssen Sie bei der Angabe von `DataTemplate` mit dem Attribut `x:DataType` angeben, mit welchen Daten sie arbeiten werden.
* Für `x:Bind` ist es möglich, Methoden zu binden, während für `Binding`nur Konverter verwendet werden können. Bei gebundenen Funktionen funktioniert die Änderungsbenachrichtigung auch bei Änderungen von Parametern.

!!! tip "Empfehlung"
    Als Faustregel gilt, dass Sie vorzugsweise `x:Bind`verwenden sollten, da Sie so schneller und zeitnaher Fehler erhalten. Wenn Sie jedoch aus irgendeinem Grund Probleme mit `x:Bind`haben, sollten Sie zu `Binding`wechseln.
