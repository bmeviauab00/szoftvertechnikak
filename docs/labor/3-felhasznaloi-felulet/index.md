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

A `Grid`-et fogjuk kipróbálni. Egy személy nevét és életkorát fogjuk szerkeszthetővé tenni.

Vegyünk fel 3 sort és 2 oszlopot a `Grid`-ünkbe:

```xml

<Grid.RowDefinitions>
    <RowDefinition Height="Auto" />
    <RowDefinition Height="Auto" />
    <RowDefinition Height="*" />
</Grid.RowDefinitions>
<Grid.ColumnDefinitions>
    <ColumnDefinition Width="Auto" />
    <ColumnDefinition Width="*" />
</Grid.ColumnDefinitions>

<TextBlock Grid.Row="0" Grid.Column="0" Text="Name" />
<TextBox Grid.Row="0" Grid.Column="1" x:Name="tbName" />
<TextBlock Grid.Row="1" Grid.Column="0" Text="Age" />
<TextBox Grid.Row="1" Grid.Column="1" x:Name="tbAge" />
```