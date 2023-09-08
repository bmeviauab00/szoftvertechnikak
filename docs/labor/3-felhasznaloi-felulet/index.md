---
authors: tibitoth
---
# 3. A felhasználói felület kialakítása

## A gyakorlat célja

A gyakorlat célja megismerkedni a vastagkliens alkalmazások fejlesztésének alapjaival a deklaratív XAML felületleíró technológián keresztül. Az itt tanult alapok az összes XAML dialektusra (WinUI, WPF, UWP, Xamarin.Forms, MAUI) igazak lesznek, vagy nagyon hasonlóan lehet őket alkalmazni, mi viszont a mai órán specifikusan a WinAppSDK / WinUI 3 keretrendszeren keresztül fogjuk használni a XAML-t.

## Előfeltételek

A labor elvégzéséhez szükséges eszközök:

* Visual Studio 2022 (TODO)
* WindowsAppSDK 1.4 (TODO)

## Áttekintés

Az első feladatban kialakítjuk a környezetet, amelyben a továbbiakban a XAML nyelv és a WinUI keretrendszer működését vizsgáljuk.

Hozzunk létre egy új WinUI 3 projektet (_Blank App, Packaged (WinUI 3 Desktop)_), a projekt neve legyen _HelloXaml_.

Tekintsük át milyen alapértelmezett fájlokat generált a Visual Studio:

* Dependencies
    * Frameworks
        * .NET keretrendszer
        * Windows specifikus .NET SDK
    * Packages
        * Windows SDK Build Tools
        * WindowsAppSDK
* Assets
    * Alkalmazás logói
* app.manifest, Package.appxmanifest
    * Az alkalmazás metaadatait tartalmazó XML állomány, amiben többek között megadhatjuk a logókat, vagy pl. androidhoz hasonlóan itt kell jogot kérjünk a biztonságkritikus rendszererőforrásokhoz.
* App
    * Két fájl `App.xaml`` és `App.xaml.cs `(később kiderül miért)
    * Alkalmazás belépési pontja: `OnLaunched` felüldefiniált metódus az `App.xaml.cs`-ben
    * Esetünkben itt inicializáljuk az alkalmazás egyetlen ablakát a `MainWindow`-t
* MainPage
    * Az alkalmazás egyik (kezdő) oldala

**Futtassuk az alkalmazást!**

## XAML bevezetés

A felület leírását egy XML szerű leíró nyelvben, XAML-ben fogjuk leírni. (ejtsd: zemöl)

!!! tip "Grafikus designer felület"
    Bizonyos XAML dialektusok esetében (pl.: WPF) rendelkezésünkre áll grafikus designer eszköz is, de az általában kevésbé hatékony XAML leírót szokott generálni. Ráadásul már a Visual Studio is támogata a Hot Reload működést XAML esetben, így nem szükséges leállítani az alkalmazást a XAML szerkesztése közben, a változtatásokat pedig azonnal láthatjuk a futó alkalmazásban. Ezért WinUI esetében már nem is kapunk designer támogatást a Visual Studioban.

### XAML nyelvi alapok

XAML nyelv:

* objektumpéldányosító nyelv
* szabványos XML
* XML tagek: objektumokat példányosítanak, melyek osztályai szabványos .NET-es osztályok
* XML attribútumok: tulajdonságokat (dependency property-ket) állítanak be
* deklaratív: nem úgy működik, hogy példányosítunk egy vezérlőt, aztán hozzáadjuk egy korábban példányosított konténerhez, hanem azt mondjuk meg, hogy van egy konténer, és abban az X vezérlő található, ilyen meg olyan tulajdonságokkal. Ezt nevezzük a vezérlők **logikai fájának**.

Nézzük meg milyen XAML-t generált a projekt sablon.
Láthatjuk, hogy a XAML-ben minden vezérlőhöz létrehozott egy taget.
A vezérlők tagjein pedig be vannak állítva a vezérlő tulajdonságai. Pl. `HorizontalAlignment`: igazítás a konténeren (most ablakon) belül.
Vezérlők egymást tartalmazhatják, így egy vezérlő fát alkotva.

Nézzük meg részletesebben a `MainWindow.xaml`-t:

* Gyökér tagen névterek: megadja, hogy az XML-ben milyen tageket és attribútumokat használhatunk
    * Alapértelmezett névtér: XAML elemek vezérlők (pl. gomb)
    * `x` névtér: XAML parser névtere (pl.: `x:Class`, `x:Name`)
    * Egyéb tetszőleges névterek hivatkozva
* `Window` gyökér tag
    * A gyökér elem származtatást definiál, ha az `x:Class` attribútum szerepel az elemen: az oldalunk a `Window` osztályból származik, ezt a codebehindban (`xaml.cs`) is láthatjuk
    * A leszármaztatott osztály neve: `x:Class="HelloXaml.MainWindow"`
* Codebehind (`MainWindow.xaml.cs`):
    * `this.InitializeComponent();` - konstruktorban mindig meg kell hívni, ez olvassa majd be a XAML-t, ez példányosítja, inicializálja az oldal tartalmát.

Töröljük ki a `Window` tartalmát és a code-behindból az eseménykezelőt.
Most kézzel fogunk XAML-t írni.
Nyugodtan futtassuk az alkalmazást, hogy azonnal láthassuk a módosításainkat.

Vegyünk fel egy `Grid`-et a `Window`-ba, amivel a későbbiekben egy táblázatos layoutot fogunk tudunk készíteni:

```xml
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

### Objektum példányok és tulajdonságaik

Vegyünk fel a `Grid`-be egy `Button`-t. A `Content` tulajdonságba adhatjuk meg a gomb szövegét, pontosabban a tartalmát.

```xml
<Button Content="Helló Universal App!"/>
```

A `Content` tulajdonságot nem csak attribútumban lehet megadni, hanem tagen belül is.

```xml
<Button>Helló Universal App!</Button>
```

Sőt! A gombra nem csak feliratot rakhatunk, hanem tetszőleges más elemet. Pl. rakjunk bele egy piros kört. A kör 10 pixel széles, 10 pixel magas, a szín (`Fill`) pedig piros.

```xml
<Button>
    <Ellipse Width="10" Height="10" Fill="Red" />
</Button>
```

Ezt WinFormsban megcsinálni nem lett volna ilyen egyszerű.

Legyen most a piros kör mellett a _Record_ felirat (hogy értelme is legyen a piros körös gombnak). A gombnak csak egy gyereke lehet, ezért egy layout vezérlőbe (pl. egy `StackPanel`-be) kell beraknunk a kört és a szöveget (`TextBlock`). Adjunk egy bal oldali margót is a `TextBlock`-nak, hogy ne érjenek össze.

```xml
<Button>
    <StackPanel Orientation="Horizontal">
        <Ellipse Width="10" Height="10" Fill="Red" />
        <TextBlock Text="Record" Margin="10,0,0,0" />
    </StackPanel>
</Button>
```

!!! note "XAML vektorgrafikus vezérlők"
    Ami itt fontos, hogy a XAML vezérlők nagy része vektorgrafikus. Ez a gomb ugyanolyan élesen fog kinézni bármilyen felbontáson, bármilyen DPI mellett, bármennyire is zoomolunk bele.

Itt feltűnhet, hogy ha az XML attribútum csak string, hogyan adunk meg „összetett” property értékeket (mint pl. most a Content is szöveg volt eddig, most meg már egy összetett objektum)

1. Egyrészt: típuskonverterek. (Erről sok szó nem lesz, de magától szépen működik általában.)

    Vegyünk fel a Grid-re, egy háttérszínt:

    ```xml
    <Grid Background="Azure">
    ```

    Vagy meg is adhatjuk hexában:

    ```xml
    <Grid Background="#FFF0FFFF">
    ```

    A margó is egy összetett érték, az ő típuskonvetere vesszővel (vagy szóközzel) elválasztva várja a 4 oldal értékeit. (bal, fent, jobb, lent)

2. A Background nem csak egy szín lehet, hanem pl. színátmenet vagy háttérkép is.
    Itt az `Azure` valójában egy `SolidColorBrush`-t hoz létre, aminek a színét világos kékre állítja.
    „Kézzel” az alábbi módon lehet megadni.
    Ezzel el is érkeztünk a property element syntaxhoz.
    Ez a tag nem külön objektum példány, hanem az adott property értékét állítjuk be a megfelelő objektum példányára.
    A típushelyesség természetesen itt is fennáll: A `Backgroud` tulajdonság egy `Brush` típusú property.

    ```xml
    <Grid>
        <Grid.Background>
            <SolidColorBrush Color="Azure" />
        </Grid.Background>
    ```

    Persze az `Azure` szóból itt is típuskonverter csinál kék `Color` példányt. Így nézne ki teljesen kiírva:

    ```xml
    <Grid.Background>
        <SolidColorBrush>
            <SolidColorBrush.Color>
                <Color>#FFF0FFFF</Color>
            </SolidColorBrush.Color>
        </SolidColorBrush>
    </Grid.Background>
    ```

    !!! note Megjegyzés
        Értéktípusoknál (`struct`), mint a `Color` mindig konstruktor időben kell megadni az értéket, ezért itt nem lehet a propertyket külön állítgatni, muszáj a típuskonverterre bízni magunkat.

3. Érdemes kihasználni a típuskonvertereket, hogy ne legyen terjengős a XAML leírásunk.
    Csak írjuk le mégis kibontva, ha valami összetettebbet szeretnénk, pl. színátmenetre nincs típus konverter.

    ```xml
    <Grid.Background>
        <LinearGradientBrush>
            <LinearGradientBrush.GradientStops>
                <GradientStop Color="Black" Offset="0" />
                <GradientStop Color="White" Offset="1" />
            </LinearGradientBrush.GradientStops>
        </LinearGradientBrush>
    </Grid.Background>
    ```

4. A gombnál is valójában a `Content` tulajdonságot állítottuk. Írhattunk volna ezt is:

    Minden vezérlő meghatározhat magáról egy "Content" tulajdonságot, ami egy kitüntetett tulajdonság, ennél nem kell kiírni ezt, hanem az XML tag gyerekei lesznek ide felvéve. Nem minden vezérlő esetében `Content`-nek hívják, pl. `StackPanel`-nél és `Grid`-nél `Children` – ugye itt sem írtuk ki.

Írjuk vissza a G`rid hátterét valami szimpatikusan egyszerűre, vagy töröljük ki a háttérszínt.

### Eseménykezelés

A XAML appok eseményvezérelt alkalmazások. Minden felhasználói interakcióról események segítségével értesülünk, ezek hatására frissíthetjük a felületet.

Most kezeljük le a gomb kattintását.

Adjunk nevet a `TextBlock` vezérlőknek, hogy a code-behindból hivatkozni tudjunk rá:

```xml
<TextBlock x:Name="recordTextBlock" Text="Record" Margin="10,0,0,0" />
```

Az `x:Name` a XAML parsernek szól, és ezen a néven fog létrehozni egy osztályváltozót, ami az adott vezérlő referenciáját tartalmazza.

!!! tip "Elnevezett vezérlők"
    Ne adjunk nevet azoknak a vezérlőknek, amikre nem akarunk hivatkozni. (Szoktassuk magunkat arra, hogy csak arra hivatkozunk közvetlenül, amire nagyon muszáj. Ebben az adatkötés is segít majd.)

    Kivétel: Ha nagyon bonyolult a vezérlőhierarchiánk, segíthetnek a nevek az átláthatóbbá tételben, mivel a _Document Outline_ ablakban megjelennek, illetve a generált eseménykezelő-nevek is ehhez igazodnak.

Kezeljük le a gomb `Click` eseményét, majd próbáljuk ki a kódot.

```xml
<Button Click="RecordButton_Click">
```

```csharp
private void RecordButton_Click(object sender, RoutedEventArgs e)
{
    recordTextBlock.Text = "Recording...";
}
```

!!! tip "Eseménykezelők létrehozása"
    Ha az eseménykezelőknél nem a _New Event Handler_-t választjuk, hanem beírjuk kézzel a kívánt nevet, majd F12-t nyomunk, vagy a jobb gomb / Go to Definition-t választjuk, az eseménykezelő legenerálásra kerül.

Az eseménykezelőnek két paramétere van: a küldő objektum (`sender`), és az esemény körülményeit tartalmazó `EventArgs` (`e`) példány. Jelenesetben ez:

* `object sender`: maga a gomb, ezt kasztolva használhatjuk is.
* `RoutedEventArgs e`: ebben megkapjuk azt a vezérlőt, aminél először kiváltódott az esemény. Jelen esetben ez maga a gomb, de ha pl. egy egér lenyomás eseményt (nem a `Click`, hanem `PointerPressed`) kezelnénk pl. a `StackPanel`-en, akkor lehet, hogy az egyik gyerekelemét kapnánk meg, ha arra kattintottak. Az összetettebb eseményeknél (mint pl. a `PointerPressed`) majd több infót kapunk itt meg.

## Layout, elrendezés

A vezérlők elrendezését két dolog határozza meg:

1. Layout (panel) vezérlők, és kapcsotható tulajdonságaik (attached property)
2. Szülő vezérlőn belüli általános pozíció tulajdonságok (pl. margó, igazítás függőlegesen vagy vízszintesen)

Beépített layout vezérlők például:

* `StackPanel`: elemek egymás alatt vagy mellett
* `Grid`: definiálhatunk egy rácsot, amihez igazodnak az elemek
* `Canvas`: tetszőleges elrendezés (koordinátarendszer).
* `RelativePanel`: elemek egymáshoz képesti viszonyát határozhatjuk meg kényszerekkel

A `Grid`-et fogjuk kipróbálni. Egy személy nevét és életkorát fogjuk szerkeszthetővé tenni egy űrlapon.

Vegyünk fel egy 3 soros és 2 oszlopos új `Grid`-et a gyökér `Grid`-ünkbe. Az első oszlopába kerüljenek a címkék, a második oszlopba pedig a beviteli mezők. A meglévő gombunkat is rakjuk a 3. sorba, és írjuk át a tartalmát _Add_-ra, az kör helyett pedig vegyünk fel egy `SymbolIcon`-t.

```xml
<Grid>
    <Grid.RowDefinitions>
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
            <TextBlock Text="Add" Margon="5,0,0,0"/>
        </StackPanel>
    </Button>
</Grid>
```

A sor és oszlopdefiniciók esetében megadhatjuk, hogy az adott sor vegye fel a tartalmának a méretét (`Auto`), vagy töltse ki a maradék helyet (`*`), de akár fix szélességet is megadhatnánk pixelben.
Ha több `*` is szerepel a definíciókban, akkor azok arányosíthatóak pl.: `*` és `*` 1:1-es arányt jelent, míg a `*` és `3*` 1:3-at.

A `Grid.Row`, `Grid.Column` úgynevezett **Attached Property**-k (csatolt tulajdonságok). Ez azt jelenti, hogy az adott tulajdonság nem egy másik vezérlőhöz tartozik, és ezt az információt „hozzácsatoljuk” egy másik objektumhoz / vezérlőhöz. Ez az információ jelenleg a `Grid`-nek lesz fontos, hogy el tudja helyezni a gyerekeit. Az alapértelmezett értéke a 0, tehát azt ki sem kéne írnunk.

!!! note "Imperatív UI leírás"
    Más UI keretrendszerekben, ahol imperatív a felület összeállítása, ezt egyszerűen megoldják függvényparaméterekkel – pl.: `myPanel.Add(new TextBox(), 0, 1)`.

Ez még nem pont olyan, amit szeretnénk, finomítsunk kicsit a kinézetén:

* Ne töltse ki az egész képernyőt a táblázat, hanem legyen középen felül.
    * `HorizontalAlignment="Center" VerticalAlignment="Top"`
* Legyen 300px széles
    * `Width="300"`
* Legyen a sorok között 10px, az oszlopok között 5px távolság és tartsunk 20px távolságot a konténer szélétől
    * `RowSpacing="5" ColumnSpacing="10" Margin="20"`
* Igazítsuk a labelt függőlegesen középre
    * `VerticalAlignment="Center"`
* Igazítsuk a gombot jobbra
    * `HorizontalAlignment="Right"`

```xml hl_lines="1-6 17 19 22"
<Grid Width="300"
      HorizontalAlignment="Center"
      VerticalAlignment="Top"
      Margin="20"
      RowSpacing="5"
      ColumnSpacing="10">
    <Grid.RowDefinitions>
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
</Grid>
```

Bővítsük ki még két gombbal az űrlapunkat: +/- gomb az életkorhoz: `TextBox` bal oldalán ’-’ jobb oldalán ’+’).
Ehhez fel kell vegyünk még két oszlopot.
A felső `TextBox`-ra és `Button`-re be kell állítanunk `ColumSpan`-t, hogy 3 illetve 2 oszlopnyi helyet töltsenek ki.
Az alsó `TextBox`-ot  pedig egy oszloppal odébb kell rakni.

```xml hl_lines="3 5 9 11-15"
<Grid.ColumnDefinitions>
    <ColumnDefinition Width="Auto" />
    <ColumnDefinition Width="Auto" />
    <ColumnDefinition Width="*" />
    <ColumnDefinition Width="Auto" />
</Grid.ColumnDefinitions>

<TextBlock Grid.Row="0" Grid.Column="0" Text="Name" VerticalAlignment="Center"/>
<TextBox Grid.Row="0" Grid.Column="1" Grid.ColumnSpan="3" />
<TextBlock Grid.Row="1" Grid.Column="0" Text="Age" VerticalAlignment="Center"/>
<TextBox Grid.Row="1" Grid.Column="2" />
<Button Grid.Row="1" Grid.Column="1" Content="-"/>
<Button Grid.Row="1" Grid.Column="3" Content="+"/>

<Button Grid.Row="2" Grid.Column="2" Grid.ColumnSpan="2" HorizontalAlignment="Right">
    <StackPanel Orientation="Horizontal">
        <SymbolIcon Symbol="Add"/>
        <TextBlock Text="Add" Margin="5,0,0,0" />
    </StackPanel>
</Button>
```

Készen is vagyunk az egyszerű formunk kinézetével.

## Adatkötés

### Binding

Csináljuk meg, hogy az előbb elkészített kis űrlapon lehessen egy személy adatait megadni, módosítani.
Ehhez először csinálunk egy adatosztályt `Person` néven a project egy újonnan létrehozott `Models` mappájába.

```csharp
public class Person
{
    public string Name { get; set; }
    public int Age { get; set; }
}
```

Azt itt lévő két tulajdonságot akarjuk a `TextBox` vezérlőkhöz kötni, ehhez adatkötést fogunk alkalmazni. 
A nézet codebehindjában csináljunk egy propertyt, ami tartalmaz egy `Person` objektumot.
Példányosítsuk meg a `Person`-t konstruktorban, majd rendeljük hozzá az oldal adatkontextusához (`DataContext`).
Azzel adjuk meg, hogy az adott nézet / adatkötés honnan veszi majd az adatait.

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

    rootGrid.DataContext = NewPerson;
}
```

A `Person` tulajdonságait rendeljük hozzá a két `TextBox` `Text` mezőihez adatkötéssel.

```xml
Text="{Binding Name}"
Text="{Binding Age}"
```

!!! danger "Fontos"
    Az adatkötésnek az a lényege, hogy nem kézzel a codebehindból állítgatjuk a felületen megjelenő szöveget például, hanem kvázi összerendeljük a tulajdonságokat. Így azt is elérhetjük, hogyha az egyik tulajdonság megváltozik, akkor a másik is változzon meg!

A `Text="{Binding}"` szintaktika az úgynevezett markup extension, ami egy speciális objektum példányosítást jelent. Elsősorban emiatt használunk XAML és nem sima XML-t. 
Van lehetőségünk saját Markup Extension-t is készíteni, de ez nem tananyag.

Futtassuk! Látható, hogy bekerült a `Person`-ban megadott név és életkor.

!!! tip "Binding.Path"
    Itt valójában a `Binding` `Path` tulajdonságát állítjuk be, ami lehet tetszőleges mélységű is. Pl.: `Person.Address.Street`

    A teljes szintaktika így nézne ki, de a `Path=` elhagyhaó, ha az az első paraméter: `Text="{Binding Path=Name}"`

!!! tip "Design DataContext"
    A kódszerkesztőben észrevehetjük, hogy nincs IntelliSense az adatkötés során. Ezt az alábbi névtérrel és attribútummal javíthatjuk a gyökér Grid-ünkön:

    ```xml
    xmlns:model="using:HelloXaml.Models" d:DataContext="{d:DesignInstance Type=models:Person}"
    ```

    A névtér deklarációt rakhatjuk a `Window`-ra is.

Készítsünk egy `Click` eseménykezelőt az _Add_ gombunkra:

```xml
<Button ... Click="AddButton_Click">
```

```csharp
private void AddButton_Click(object sender, RoutedEventArgs e)
{
}
```

Rakjunk egy breakpointot az eseménykezelőbe, és próbáljuk, hogy vissza irányba is működik-e az adatkötés, ha megváltoztatjuk az egyik `TextBox` értékét.

**Nem íródott vissza!** Ez azért történik, mert WinUI esetében az alapértelmezett adatkötési mód a `OneWay`, ami csak a forrás => cél irányt támogatja változásértesítéssel. A vissza irányhoz `TwoWay`-re kell állítsuk az adatkötés módját.

```xml
Text="{Binding Name, Mode=TwoWay}"
Text="{Binding Age, Mode=TwoWay}"
```

Próbáljuk ki! Így már működik a vissza irányú adatkötés is.

### Változásértesítés

Implementáljuk a +/- gombok Click eseménykezelőit.

```xml
<Button Grid.Row="1" Grid.Column="1" Content="-" Click="DecreaseButton_Click"/>
<Button Grid.Row="1" Grid.Column="3" Content="+" Click="IncreaseButton_Click"/>
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

Próbáljuk ki!

Mi történik, ha az adatosztályban írjuk át code behindból az értéket, esetünkben a +/- gombok megnyomásának hatására? A felület frissülni fog? Most nem, de ezt egyszerűen megoldhatjuk.

Implementáljuk az `INotifyPropertyChanged` interfészt a `Person` osztályunkba. Ha adatkötünk ehhez az osztályhoz, akkor a rendszer a `PropertyChanged` eseményre fog feliratkozni, ennek az eseménynek a elsütésével tudjuk értesíteni a `Binding`-ot, ha egy property megváltozott.

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
                PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(Name)))
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

Próbáljuk ki!

!!! tip "Terjengős a kód?"
    A későbbiekben ezt a logikát ki is szervezhetnénk egy ősosztályba, de ez már az MVVM mintát vezetné elő. Tehát ne ijedjünk meg ettől a csúnya kódtól.

## Listák

Csináljunk listás adatkötést.
Vegyük fel a `Person`-ök listáját a nézetünk code-behindjába.
A konstruktor elején pedig példányosítsuk, és állítsuk a `MainWindow` aktuális példányát a `rootGrid` `DataContext`-jének.

```csharp hl_lines="1 "13-19"
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

    rootGrid.DataContext = this;
}
```

!!! warning "DataContext"
    Nem szokás a `DataContext`-nek a `this` objektumot beállítani, jelen esetben csak a demonstráció célját szolgálja, és itt valójában az MVVM minta szerint egy ViewModel objektumnak kellene lennie.

Vegyünk fel egy új sort a `Grid`-be, amibe majd a lista fog kerülni. Az eddigi 3. sor legyen `Auto` magas, míg az új 4. sor töltse ki a maradék helyet.

```xml hl_lines="4-5"
<Grid.RowDefinitions>
    <RowDefinition Height="Auto" />
    <RowDefinition Height="Auto" />
    <RowDefinition Height="Auto" />
    <RowDefinition Height="*" />
</Grid.RowDefinitions>
```

Rakjuk a 4. sorba (és az összes oszlopba) a `ListView` vezérlőnket, ahol adatkötéssel állítsuk be az `ItemsSource` tulajdonságán keresztül, milyen adatforrásból dolgozzon.

```xml
<ListView Grid.Row="3" Grid.ColumnSpan="4" ItemsSource="{Binding People}"/>
```

Sajnos a fenti `DataContext` módosításunkkal elrontottuk az űrlap adatkötéseit, javítsuk ezeket meg.

```xml
Text="{Binding NewPerson.Name, Mode=TwoWay}"
Text="{Binding NewPerson.Age, Mode=TwoWay}"
```

Próbáljuk ki!

Látjuk, hogy megjelent két elem. Persze nem az van kiírva, amit mi szeretnénk, de ezen könnyen változtathatunk.
Alapértelmezetten a `ListView` a `ToString()`-et hívja a listaelemen, ami ha nem definiáljuk felül, akkor az osztály típusának `FullName`-je.

Állítsunk be `ItemTemplate`-et, ami a listaelem megjelenését adja meg egy sablon segítségével: amiben egy több elemből (`Run`) álló `TextBlock` kerüljön.

```xml
<ListView Grid.Row="3" Grid.ColumnSpan="4" ItemsSource="{Binding People}">
    <ListView.ItemTemplate>
        <DataTemplate>
            <TextBlock><Run Text="{Binding Name}"/> (<Run Text="{Binding Age}"/>)</TextBlock>
        </DataTemplate>
    </ListView.ItemTemplate>
</ListView>
```

Próbáljuk ki!

Az _Add_ gomb hatására rakjuk bele a listába az űrlapon található személyt.

```csharp hl_lines="3"
private void AddButton_Click(object sender, RoutedEventArgs e)
{
    People.Add(NewPerson);
}
```

Nem jelenik meg a listában az új elem, mert a `ListView` nem értesül arról, hogy új elem került a listába. Ezt könnyen orvosolhatjuk: a `List<Persont>`-t cseréljük le `ObservableCollection<Person>`-re:

```csharp
public ObservableCollection<Person> People { get; set; }
```

!!! tip ObservableCollection
    A kollekció implementálja az `INotifyCollectionChanged` interfészt.

    Tehát már két változáskezelést támogató interfészünk van, amit a `Binding` figyel: `INotifyPropertyChanged` és `INotifyCollectionChanged`.

## Önálló feladat

Az előző feladatot teszteljük a következő módon:

Adjunk a listához az új elemet, majd módosítsuk a beviteli mezők valamelyikét. Adjuk hozzá ismét a listához a személy adatait és ismét módosítsuk az adatoat.

1. Mit tapasztalunk és miért?
2. Próbáljuk megjavítani az eddig tanultak alapján!

## Kitekintés: Fordítás idejű adatkötés (x:Bind)

A Binding markup extension futás időben dolgozik reflection segítségével, így egyrészt nem kapunk fordítás idejű hibákat, ha valamit elírtunk volna, másrészt pedig sok adatkötés (1000-es nagyságrend) jelentésen lassíthatja az alkalmazásunkat.

Ennek megoldására megjelent a fordítás idejű adatkötés támogatása, amit WinUI platformon az `x:Bind` szintaktikával érhetünk el.

Van viszont néhány eltérés a sima Binding-hoz képest:

* Nem a `DataContext`-ből dolgozik és nem is lehet állítani az adatkötés forrását, mivel mindig az adott nézetből köt
    * Olyan, mint amikor megadtuk a a nézetben, hogy `DataContext = this;`
* Alapértelmezett módja a `OneTime` és nem a `OneWay`: tehát nem figyeli a változásokat!
* Adatsablonokban is használható, de olyankor nyilatkozni kell a `DataTemplate`-en, hogy az milyen adatokon fog dolgozni az `x:DataType` attribútummal.

Írjuk át a nézetünben az adatkötéseket `x:Bind`-ra.

