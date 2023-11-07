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

Hozzunk létre egy új WinUI 3 projektet, _Blank App, Packaged (WinUI 3 in Desktop)_ típusút, a projekt neve legyen _HelloXaml_.

Tekintsük át milyen alapértelmezett fájlokat generált a Visual Studio:

* App
    * Két fájl `App.xaml` és `App.xaml.cs`(később tisztázzuk két fájl tartozik hozzá)
    * Alkalmazás belépési pontja: `OnLaunched` felüldefiniált metódus az `App.xaml.cs`-ben
    * Esetünkben itt inicializáljuk az alkalmazás egyetlen ablakát a `MainWindow`-t
* MainWindow
    * Alkalmazásunk főablakához tartozó .xaml és .xaml.cs fájlok.

??? Note "További solution elemek"
    A kiinduló VS solution a következő elemeket tartalmazza még:

    * Dependencies
        * Frameworks
            * `Microsoft.AspNetCore.App`: .NET SDK metapackage (Microsoft .NET és SDK alapcsomagokat hivatkozza be)
            * Windows specifikus .NET SDK
        * Packages
            * Windows SDK Build Tools
            * WindowsAppSDK
    * Assets
        * Alkalmazás logói
    * app.manifest, Package.appxmanifest
        * Az alkalmazás metaadatait tartalmazó XML állomány, melyben többek között megadhatjuk a logókat, vagy pl. Androidhoz hasonlóan itt kell jogot kérjünk a biztonságkritikus rendszererőforrásokhoz.

**Futtassuk az alkalmazást!**

## XAML bevezetés

A felület leírását egy XML alapú leíró nyelvben, XAML-ben (ejtsd: zemöl) fogjuk megadni.

!!! tip "Grafikus designer felület"
    Bizonyos XAML dialektusok esetében (pl.: WPF) rendelkezésünkre áll grafikus designer eszköz is a felület kialakításához, de az általában kevésbé hatékony XAML leírást szokott generálni. Ráadásul már a Visual Studio is támogatja a Hot Reload működést XAML esetben, így nem szükséges leállítani az alkalmazást a XAML szerkesztése közben, a változtatásokat pedig azonnal láthatjuk a futó alkalmazásban. Ezért WinUI esetében már nem is kapunk designer támogatást a Visual Studioban. A tapasztalatok alapján vannak limitációi, "nagyobb" léptékű változtatások esetén szükség van az alkalmazás újraindítására.

### XAML nyelvi alapok

A XAML nyelv:

* Objektumpéldányosító nyelv
* Szabványos XML
* XML elemek/tagek: objektumokat példányosítanak, melyek osztályai szabványos .NET osztályok
* XML attribútumok: tulajdonságokat (dependency property-ket) állítanak be
* Deklaratív

Nézzük meg, milyen XAML-t generált a projekt sablon (`MainWindow.xaml`).
Láthatjuk, hogy a XAML-ben minden vezérlőhöz létrehozott egy XML elemet/taget.
A vezérlők tagjein pedig be vannak állítva a vezérlő tulajdonságai. Pl. `HorizontalAlignment`: igazítás a konténeren (esetünkben ablakon) belül.
Vezérlők tartalmazhatnak más vezérlőket, így vezérlőkből álló fa jön létre.

Nézzük meg részletesebben a `MainWindow.xaml`-t:

* Gyökér tagen névterek: meghatározzák, hogy az XML-ben milyen tageket és attribútumokat használhatunk
    * Alapértelmezett névtér: XAML elemek/vezérlők (pl. `Button`, `TextBox` stb.) névtere
    * `x` névtér: XAML parser névtere (pl.: `x:Class`, `x:Name`)
    * Egyéb tetszőleges névterek hivatkozhatók
* `Window` gyökér tag
    * Az ablakunk/oldalunk alapján egy .NET osztály jön létre, mely a `Window` osztályból származik.
    * A leszármaztatott osztályunk nevét az `x:Class` attribútum határozza meg: az `x:Class="HelloXaml.MainWindow"` alapján egy `HelloXaml` névtérben egy `MainWindow` nevű osztály lesz.
    * Ez egy partial class, az osztály "másik fele" az ablakhoz/oldalhoz tartozó ún. a code-behind fájlban (`MainWindow.xaml.cs`) található. Lásd következő pont.
* Code-behind fájl (`MainWindow.xaml.cs`):
    * A partial classunk másik "fele": ellenőrizzük, hogy itt az osztály neve és névtere megegyezik a .xaml fájlban megadottal (partial class!).
    * Eseménykezelő és segédfüggvényeket tesszük ide (többek között).
    * `this.InitializeComponent();`: a konstruktorban mindig meg kell hívni, ez olvassa majd be futás közben a XAML-t, ez példányosítja, inicializálja az ablak/oldal tartalmát (vagyis a XAML-fájlban megadott vezérlőket az ott meghatározott tulajdonságokkal).

Töröljük ki a `Window` tartalmát és a code-behind fájlból az eseménykezelőt (`myButton_Click` függvény).
Most kézzel fogunk XAML-t írni és ezzel a felületet kialakítani. Vegyünk fel egy `Grid`-et a `Window`-ba, mellyel a későbbiekben egy táblázatos elrendezést (layout) fogunk tudunk kialakítani:

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

Futtassuk az alkalmazást (pl. az ++f5++ billentyűvel). A `Grid` most kitölti a teljes ablakot, a színe megegyezik az ablak háttérszínével, ezért szemmel nem tudjuk megkülönböztetni.

A következő feladatok során hagyjuk futni az alkalmazást, hogy azonnal láthassuk a felületen eszközölt módosításainkat.

!!! Warning "Hot Reload limitációk"
    Tartsuk szem előtt a Hot Reload limitációit: ha egy változásunk nem akar a futó alkalmazás felületén megjelenni, akkor indítsuk majd újra az alkalmazást!

### Objektum példányok és tulajdonságaik

Most azt nézzük meg, hogyan tudunk XAML alapokon objektumokat példányosítani és ezen objektumok tulajdonságait beállítani.

Vegyünk fel a `Grid` belsejébe egy `Button`-t. A `Content` tulajdonsággal adhatjuk meg a gomb szövegét, pontosabban a tartalmát.

```xml
<Button Content="Hello WinUI App!"/>
```

Ez azon a helyen, ahol deklaráltuk, futás közben létrehoz egy `Button` objektumot, és a `Content` tulajdonságát a "Hello WinUI App!" szövegre állítja. Ezt megtehettük volna a code-behind fájlban C# nyelven is következőképpen (de ez kevésbé olvasható kódot eredményezne):

```csharp
// Pl. a konstruktor végére beírva:

Button b = new Button();
b.Content = "Hello WinUI App!";
rootGrid.Children.Add(b); 
// Az előző a sorhoz XAML fájlban a Gridnek meg kellene adni az x:Name="rootGrid" 
// attribútumot, hogy rootGrid néven elérhető legyen a code-behind fájlban
```

:exclamation: Ez a példa nagyon jól szemlélteti, hogy a XAML alapvetően egy objektumpéldányosító nyelv, és támogatja objektumok tulajdonságainak beállítását.

A `Content` tulajdonság különleges, nem csak XML attribútumban lehet megadni, hanem tagen (XML elemen) belül is.

```xml
<Button>Hello WinUI App!</Button>
```

Sőt! A gombra nem csak feliratot rakhatunk, hanem tetszőleges más elemet. Pl. rakjunk bele egy piros kört. A kör 10 pixel széles, 10 pixel magas, a szín (`Fill`) pedig piros.

```xml
<Button>
    <Ellipse Width="10" Height="10" Fill="Red" />
</Button>
```

Ezt korábbi .NET UI technológiák esetében (pl. Windows Forms) nem lett volna ilyen egyszerű megvalósítani.

Legyen most a piros kör mellett a _Record_ felirat (hogy értelme is legyen a piros körös gombnak). A gombnak csak egy gyereke lehet, ezért egy layout vezérlőbe (pl. egy `StackPanel`-be) kell beraknunk a kört és a szöveget (`TextBlock`). Adjunk egy bal oldali margót is a `TextBlock`-nak, hogy ne érjenek össze.

```xml
<Button>
    <StackPanel Orientation="Horizontal">
        <Ellipse Width="10" Height="10" Fill="Red" />
        <TextBlock Text="Record" Margin="10,0,0,0" />
    </StackPanel>
</Button>
```

A `StackPanel` egy egyszerű, vezérlők elrendezésére szolgáló layout panel:  a tartalmazott vezérlőket `Horizental` `Orientation` megadása esetén egymás mellé, `Vertical` `Orientation` esetén egymás alá helyezi el. Így a példánkban egyszerűen egymás mellé teszi a két vezérlőt.

Az eredmény a következő:

![record button](images/record-button.png)

!!! note "XAML vektorgrafikus vezérlők"
    Lényeges, hogy a XAML vezérlők nagy része vektorgrafikus. Ez a gomb ugyanolyan élesen fog kinézni (nem tapasztalunk "pixelesedést") bármilyen bármilyen DPI  ill. nagyítás mellett nézzük.

A XAML-ben példányosított vezérlők tulajdonságainak megadására három lehetőség van (ezeket részben használtuk is már):

* Property ATTRIBUTE syntax
* Property ELEMENT syntax
* Property CONTENT syntax

Tekintsük át most részletesebben ezeket a lehetőségeket:

1. **Property ATTRIBUTE syntax**.  Már alkalmaztuk, mégpedig a legelső példánkban:

    ```xml
    <Button Content="Hello WinUI App!"/>
    ```

    Az elnevezés onnan ered, hogy a tulajdonságot XML **attribútum** formájában adjuk meg. Segítségével - mivel XML attribútum csak string lehet! - csak sztring formában megadott egyszerű szám/sztring/stb. érték, ill. code-behind fájlban definiált tagváltozó, eseménykezelő érhető el. De típuskonverterek segítségével "összetett" objektumok is megadhatók. Erről sok szó nem lesz, de a beépített típuskonvertereket sokszor használjuk, gyakorlatilag "ösztönösen". Példa:

    Vegyünk fel a `Grid`-re egy háttérszínt:

    ```xml
    <Grid Background="Azure">
    ```

    Vagy megadhatjuk hexában is:

    ```xml
    <Grid Background="#FFF0FFFF">
    ```

    A margó (`Margin`) is egy összetett érték, a hozzá tartozó típuskonveter vesszővel (vagy szóközzel) elválasztva várja a négy oldalra vonatkozó értékeket (bal, fent, jobb, lent). Már használtuk is a `Record` feliratú TextBlockunk esetében.

1. **Property ELEMENT syntax**. Segítségével egy tulajdonságot típuskonverterek nélkül tudjuk egy összetett módon példányosított/felparaméterezett objektumra állítani. Nézzük egy példán keresztül.
    * A fenti példában `Background` tulajdonság beállításakor az `Azure` valójában egy `SolidColorBrush`-t hoz létre, melynek a színét világoskékre állítja. Ezt típuskonverter alkalmazása nélkül az alábbi módon lehet megadni:
    
    ```xml
    <Grid>
        <Grid.Background>
            <SolidColorBrush Color="Azure" />
        </Grid.Background>
        ...
    ```

    Ez a `Grid` `Background` tulajdonságát állítja be a megadott `SolidColorBrush`-ra. Ez az ún. "property element syntax" alapú tulajdonságmegadás.
      
      * A név onnan ered, hogy a tulajdonságot egy XML elem (és pl. nem XML attribútum) formájában adjuk meg.
      * :exclamation: Itt a `<Grid.Background>` elem nem objektumpéldányt hoz létre, hanem az adott (esetünkben `Background`) property értékét állítja be a megfelelő objektum példányára (esetünkben egy `SolidColorBrush`-ra). Ezt az XML elem nevében levő pont alapján lehet tudni.
      * Ez "terjengősebb" forma tulajdonság megadására, de teljes rugalmasságot biztosít. 
      
    Cseréljük le a `SolidColorBrush`-t egy színátmenetes `Brush`-ra (`LinearGradientBrush`):
    
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

    `LinearGradientBrush`-ra nincs típuskonverter, ezt csak az element syntax segítségével tudtuk megadni!

     Kérdés, hogyan lehetséges az, hogy a `Grid` vezérlő `Background` tulajdonságának `SolidColorBrush` és `LinearGradientBrush` típusú ecsetet is meg tudtunk adni? A válasz nagyon egyszerű:

     *  A `Background` tulajdonság egy `Brush` típusú property.
     *  Ennek a `Brush` osztálynak leszármazottai a `SolidColorBrush` (egyszerű "tele" ecset) és a `LinearGradientBrush` (lineáris színátmenet alapú ecset) osztályok.
     * Így a fenti példák mindegyikében fennáll (a polimorfizmus miatt).

    ??? note Megjegyzések
        * A fenti példákban a `Color` (szín) megadásánál pl. a `Color="Azure"` esetben az `Azure` szóból is típuskonverter készít kék `Color` példányt. Így nézne a korábbi, `SolidColorBrush` alapú példánk teljesen kifejtve:
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
        * Ahol támogatott, érdemes kihasználni a típuskonvertereket, és attribute syntaxot használni, hogy ne legyen terjengős a XAML leírásunk.
        * Értéktípusoknál (`struct`), mint amilyen a `Color` is, már az objektum példányosításakor ("konstruktor időben") kell megadni az értéket, ezért itt nem lehet a propertyket külön állítgatni, muszáj típuskonverterre bízni magunkat.

2. **Property CONTENT syntax**. Annak érdekében, hogy jobban megértsük, nézzük meg, milyen háromféle módon tudjuk beállítani egy gomb `Content` tulajdonságát valamilyen szövegre (ezt laboron nem kell megtenni, elég, ha jelen útmutatóban nézzük közösen):
   
      * Property **attribute** syntax (már használtuk):
        ```xml
        <Button Content="Hello WinUI App!"/>
        ```
      * Állítsuk be az előző pontban tanult property **element** syntax alapján:
       ```xml
       <Button>
           <Button.Content>
           Hello WinUI App!
           </Button.Content>
       </Button>
       ```
       * Minden vezérlő meghatározhat magáról egy kitüntetett "Content" tulajdonságot, melynél nem kell kiírni a nyitó és csukó tag-eket. Vagyis az előző példában alkalmazott `<Button.Content>` nyitó és záró tag-ek ennél az egy tulajdonságnál elhagyhatók:
       ```xml
       <Button>
           Hello WinUI App!
       </Button>
       ```
       Vagy egy sorba írva:
       ```xml
       <Button>Hello WinUI App!</Button>
       ```
       Ezt ismerős, láttuk a bevezető példánkban: ez az ún. **Property CONTENT syntax** alapú tulajdonságmegadás. Az elnevezés is sugallja, hogy ezt az egy tulajdonságot a vezérlő "tartalmi" részében, contentjében is megadhatjuk. Nem minden vezérlő esetében `Content` ezen kitüntetett tulajdonság neve:  `StackPanel`-nél és `Grid`-nél `Children` a neve. Emlékezzünk vissza, ill. nézzük meg a kódot: ezeket már használtuk is:  ugyanakkor, nem írtuk ki a `StackPanel.Children`, ill. `Grid.Children` XML elemeket a `StackPanel`, ill. `Grid` belsejének megadásakor (de megtehettük volna!)

Írjuk vissza a `Grid` hátterét valami szimpatikusan egyszerűre, vagy töröljük ki a háttérszín megadását.

### Eseménykezelés

A XAML applikációk eseményvezérelt alkalmazások. Minden felhasználói interakcióról események segítségével értesülünk, ezek hatására frissíthetjük a felületet.

Most kezeljük le a gombon történő kattintást.

Előkészítő lépésként adjunk nevet a `TextBlock` vezérlőnknek, hogy a code-behind fájlból hivatkozni tudjunk majd rá a későbbiekben:

```xml
<TextBlock x:Name="recordTextBlock" Text="Record" Margin="10,0,0,0" />
```

Az `x:Name` a XAML parsernek szól, és ezen a néven fog létrehozni egy tagváltozót az osztályunkban, mely az adott vezérlő referenciáját tartalmazza. :exclamation: Gondoljuk át: mivel tagváltozó lesz, a code-behind fájlban el tudjuk érni, hiszen az egy "partial része" ugyanazon osztálynak!

!!! tip "Elnevezett vezérlők"
    Ne adjunk nevet azoknak a vezérlőknek, melyekre nem akarunk hivatkozni. (Szoktassuk magunkat arra, hogy csak arra hivatkozunk közvetlenül, amire nagyon muszáj. Ebben az adatkötés is segít majd.)

    Kivétel: Ha nagyon bonyolult a vezérlőhierarchiánk, segíthetnek a nevek a kód átláthatóbbá tételében, mivel a _Document Outline_ ablakban megjelennek, illetve a generált eseménykezelő-nevek is ehhez igazodnak.

Kezeljük le a gomb `Click` eseményét, majd próbáljuk ki a kódot.

```xml title="MainWindow.xaml-be"
<Button Click="RecordButton_Click">
```

```csharp title="MainWindow.xaml.cs-be"
private void RecordButton_Click(object sender, RoutedEventArgs e)
{
    recordTextBlock.Text = "Recording...";
}
```

!!! tip "Eseménykezelők létrehozása"
    Ha az eseménykezelőknél nem a _New Event Handler_-t választjuk, hanem beírjuk kézzel a kívánt nevet, majd ++f12++-t nyomunk, vagy a jobb gomb / Go to Definition-t választjuk, az eseménykezelő legenerálásra kerül a code-behind fájlban.

Az eseménykezelőnek két paramétere van: a küldő objektum (`sender`) és az esemény paramétereit/körülményeit tartalmazó `EventArgs` (`e`) példány. Nézzük ezeket részletesebben:

* `object sender`: Az esemény kiváltója. Esetünkben ez maga a gomb, `Button`-ra kasztolva használhatnánk is. Ritkán használjuk ez a paramétert.
* A második paraméter mindig `EventArgs` típusú, vagy annak leszármazottja (ez az esemény típusától függ), melyben az esemény paramétereit kapjuk meg. A `Click` esemény esetében ez `RoutedEventArgs` típusú.
  
!!! Note "Eseményargumentumok"
    Néhány eseményargumentum típus:

      * `RoutedEventArgs`: pl. a `Click` esemény estében használandó, ahogy a példánkban is volt. Az `OriginalSource` tulajdonságban megkapjuk azt a vezérlőt, melynél először kiváltódott az esemény.
          * Megjegyzés: a fenti esetben ez maga a gomb, de ha pl. egy egérlenyomás eseményt (nem a `Click`, hanem `PointerPressed`) kezelnénk pl. a `StackPanel`-en, akkor lehet, hogy az egyik gyerekelemét kapnánk meg, ha arra kattintottak.
      * `KeyRoutedEventArgs`: pl. `KeyDown` (billentyű lenyomása) esemény esetében megkapjuk benne a lenyomott billentyűt.
      * `PointerRoutedEventArgs`: pl. `PointerPressed` (egér/toll lenyomása) esemény esetében használjuk, rajta keresztül lekérdezhetők - többek között - a kattintás koordinátái.
  
A XAML eseménykezelők teljes egészében a C# nyelv eseményeire épülnek (`event` kulcsszó, lásd [előző gyakorlat](../2-nyelvi-eszkozok/index.md#3-feladat-esemeny-event)):

Pl. a

```xml
<Button Click="RecordButton_Click">
```

erre képződik le:

```csharp
Button b = new Button();
b.Click += RecordButton_Click;
```

## Layout, elrendezés

A vezérlők elrendezését két dolog határozza meg:

1. Layout (panel) vezérlők és kapcsolható tulajdonságaik (attached property)
2. Szülő vezérlőn belüli általános pozíció tulajdonságok (pl. margó, igazítás függőlegesen vagy vízszintesen)

Beépített layout vezérlők például:

* `StackPanel`: elemek egymás alatt vagy mellett
* `Grid`: definiálhatunk egy rácsot, melyhez igazodnak az elemek
* `Canvas`: explicit pozícionálhatók az elemek az X és Y koordinátájuk megadásával
* `RelativePanel`: elemek egymáshoz képesti viszonyát határozhatjuk meg kényszerekkel

A `Grid`-et fogjuk kipróbálni (általában ezt használjuk az ablakunk/oldalunk alapelrendezésének kialakítására). Egy személy nevét és életkorát fogjuk szerkeszthetővé tenni egy űrlap jellegű elrendezés kialakításával. A következő elrendezés kialakítása a végső célunk:

![record button](images/app-ui.gif)

Pár lényeges viselkedésbeli megkötés:

* Az ablak átméretezésekor az űrlap fix szélességű legyen, és maradjon középre igazítva.
* Az Age sorban a + gombbal növelhető, a - gombbal csökkenthető az életkor.
* Az Add gombbal a fent meghatározott adatokkal felveszi a személyt az alsó listába (az ábrán az alsó listában két személy adatai láthatók).

Definiáljunk a gyökér `Grid`-en 4 sort és 2 oszlopot. Az első oszlopába kerüljenek a címkék, a második oszlopba pedig a beviteli mezők. A meglévő gombunkat is rakjuk a 3. sorba, és írjuk át a tartalmát _Add_-ra, a kör helyett pedig vegyünk fel egy `SymbolIcon`-t. A 4. sorban pedig listát helyezzünk el, ami 2 oszlopot is foglaljon el.

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

A sor- és oszlopdefiníciók esetében megadhatjuk, hogy az adott sor vegye fel a tartalmának a méretét (`Auto`), vagy töltse ki a maradék helyet (`*`), de akár fix szélességet is megadhatnánk pixelben (`Width` tulajdonság).
Ha több `*` is szerepel a definíciókban, akkor azok arányosíthatóak pl.: `*` és `*` 1:1-es arányt jelent, míg a `*` és `3*` 1:3-at.

A `Grid.Row`, `Grid.Column` úgynevezett **Attached Property**-k (csatolt tulajdonságok). Ez azt jelenti, hogy az adott tulajdonság nem egy másik vezérlőhöz tartozik, és ezt az információt „hozzácsatoljuk” egy másik objektumhoz / vezérlőhöz. Ez az információ jelenleg a `Grid`-nek lesz fontos, hogy el tudja helyezni a gyerekeit. A `Grid.Row` és `Grid.Column` alapértelmezett értéke a 0, tehát ezt ki sem kéne írnunk.

!!! note "Imperatív UI leírás"
    Más UI keretrendszerekben, ahol imperatív a felület összeállítása, ezt egyszerűen megoldják függvényparaméterekkel – pl.: `myPanel.Add(new TextBox(), 0, 1)`.

A felületünk még nem pont olyan, mint amit szeretnénk, finomítsunk kicsit a kinézetén:

* Ne töltse ki az egész képernyőt a táblázat, hanem legyen vízszintesen középen.
    * `HorizontalAlignment="Center"`
* Legyen 300px széles
    * `Width="300"`
* Legyen a sorok között 10px, az oszlopok között 5px távolság és tartsunk 20px távolságot a konténer szélétől
    * `RowSpacing="5" ColumnSpacing="10" Margin="20"`
* Igazítsuk a címkéket (`TexBlock`) függőlegesen középre
    * `VerticalAlignment="Center"`
* Igazítsuk a gombot jobbra
    * `HorizontalAlignment="Right"`
* Tegyük beazonosíthatóvá a listát
  * `BorderThickness="1"` és `BorderBrush="DarkGray"`

```xml hl_lines="2-5 18 20 23 33-34"
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

Bővítsük ki még két gombbal az űrlapunkat: +/- gomb az életkorhoz: `TextBox` bal oldalán ’-’ jobb oldalán ’+’.
Ehhez vegyünk fel a 2. sor 2. oszlopba egy új `Grid`-et, aminek 1 sora és 3 oszlopa legyen.

```xml
<Grid Grid.Row="1"
      Grid.Column="1"
      ColumnSpacing="5">
    <Grid.ColumnDefinitions>
        <ColumnDefinition Width="Auto" />
        <ColumnDefinition Width="*" />
        <ColumnDefinition Width="Auto" />
    </Grid.ColumnDefinitions>

    <Button Grid.Row="0"
            Grid.Column="0"
            Click="DecreaseButton_Click"
            Content="-" />
    <TextBox Grid.Row="0"
             Grid.Column="1"
             Text="{x:Bind NewPerson.Age, Mode=TwoWay}" />
    <Button Grid.Row="0"
            Grid.Column="2"
            Click="IncreaseButton_Click"
            Content="+" />
</Grid>
```

!!! tip "Több layout vezérlő egymásba ágyazása"
    Feltehetjük a kérdést, hogy miért nem a külső `Grid`-ben vettünk fel plusz oszlopokat és sorokat.
    Most az egységbezárás elvét követtük, és mert ezek alapvetően egybe tartozó elemek.
    Ha a külső `Grid`-ben vettünk volna fel plusz oszlopokat, akkor a `TextBox`-ot és a gombokat is a megfelelő oszlopba kellett volna tenni, és a `TextBox`-ot a megfelelő sorba.
    A külső `Grid` bővítése akkor lenne indokolt, ha spórolni akarnánk a vezérlők létrehozásával, teljesítményokok miatt.

Készen is vagyunk az egyszerű űrlapunk kinézetével.

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
A nézet code-behindjában csináljunk egy propertyt, ami tartalmaz (pontosabban hivatkozik) egy `Person` objektumot.
Példányosítsuk meg a `Person`-t konstruktorban.

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

A `NewPerson` tulajdonságait rendeljük hozzá a két `TextBox` `Text` mezőihez adatkötéssel.

```xml
Text="{x:Bind NewPerson.Name}"
Text="{x:Bind NewPerson.Age}"
```

!!! danger "Fontos"
    Az adatkötésnek az a lényege, hogy nem kézzel a code-behindból állítgatjuk a felületen megjelenő szöveget például, hanem kvázi összerendeljük a tulajdonságokat. Így azt is elérhetjük, hogyha az egyik tulajdonság megváltozik, akkor a másik is változzon meg!

A `Text="{x:Bind}"` szintaktika az úgynevezett markup extension, ami egy speciális jelentéssel rendelkezik a XAML feldolgozó számára. Elsősorban emiatt használunk XAML és nem sima XML-t.
Van lehetőségünk saját Markup Extension-t is készíteni, de ez nem tananyag.

Futtassuk! Látható, hogy az adatkötés miatt automatikusan bekerült a két `TextBox`-ba a `NewPerson` objektum (mint adatforrás) `Name` és `Age` tulajdonságaiban megadott név és életkor.

### Változásértesítés

Implementáljuk a +/- gombok Click eseménykezelőit.

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

Próbáljuk ki!

Mi történik, ha az adatosztályban írjuk át code-behindból az értéket, esetünkben a +/- gombok megnyomásának hatására? A felület frissülni fog? Most nem, de ezt egyszerűen megoldhatjuk.

1. Implementáljuk az `INotifyPropertyChanged` interfészt a `Person` osztályunkban. Ha adatkötünk ehhez az osztályhoz, akkor a rendszer a `PropertyChanged` eseményre fog feliratkozni, ennek az eseménynek a elsütésével tudjuk értesíteni a `Binding`-ot, ha egy property megváltozott.

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

    !!! tip "Terjengős a kód?"
        A későbbiekben ezt a logikát ki is szervezhetnénk egy ősosztályba, de ez már az MVVM mintát vezetné elő. Tehát ne ijedjünk meg ettől a csúnya kódtól.

1. Az adatkötésen kapcsoljuk be a változásértesítést a `Mode` `OneWay`-re történő módosításával:

    ```xml
    Text="{x:Bind NewPerson.Age, Mode=OneWay}"
    ```

Próbáljuk ki!

## Vissza irányú adatkötés

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

**Nem íródott vissza!** Ez azért történik, mert `x:Bind` esetében az alapértelmezett adatkötési mód a `OneTime`, ami csak a forrás => cél irányt támogatja változásértesítés nélkül.
Az előző pontban már láttuk, hogy hogyan működik a `OneWay` változásértesítéssel.
A vissza irányhoz `TwoWay`-re kell állítsuk az adatkötés módját.

```xml
Text="{Binding Name, Mode=TwoWay}"
Text="{Binding Age, Mode=TwoWay}"
```

Próbáljuk ki! Így már működik a vissza irányú adatkötés is.

## Listák

Csináljunk listás adatkötést.
Vegyük fel a `Person`-ök listáját a nézetünk code-behindjába, a konstruktor elején pedig példányosítsuk.

```csharp hl_lines="1 "13-17"
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

Adatkötéssel állítsuk be a a `ListView` vezérlő `ItemsSource` tulajdonságán keresztül, milyen adatforrásból dolgozzon.

```xml
<ListView Grid.Row="3" Grid.ColumnSpan="2" ItemsSource="{x:Bind People}"/>
```

Próbáljuk ki!

Látjuk, hogy megjelent két elem. Persze nem az van kiírva, amit mi szeretnénk, de ezen könnyen változtathatunk.
Alapértelmezetten a `ListView` a `ToString()`-et hívja a listaelemen, ami ha nem definiáljuk felül, akkor az osztály típusának `FullName`-je.

Állítsunk be `ItemTemplate`-et, ami a listaelem megjelenését adja meg egy sablon segítségével: egy cellás `Grid`-et, ahol a `TextBlock`-ok a `Person` tulajdonságait jelenítik meg, az életkort jobbra igazítva.

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

Próbáljuk ki!

Az _Add_ gomb hatására rakjuk bele a listába az űrlapon található személy adataival egy új `Person` másolatát, majd töröljük ki az űrlap adatait a `NewPerson` objektumunkban.

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

Nem jelenik meg a listában az új elem, mert a `ListView` nem értesül arról, hogy új elem került a listába. Ezt könnyen orvosolhatjuk: a `List<Persont>`-t cseréljük le `ObservableCollection<Person>`-re:

```csharp
public ObservableCollection<Person> People { get; set; }
```

Fontos, hogy itt nem maga a People tulajdonság értéke változott, hanem a `People` objektum tartalma, ezért nem az `INotifyPropertyChanged` interfész segít, hanem az `INotifyCollectionChanged` interfész, amit az `ObservableCollection` implementál.

!!! tip `ObservableCollection`
    Fontos, hogy itt nem maga a `People` tulajdonság értéke változott, hanem a `People` (`List<T>`) objektum tartalma, ezért nem az `INotifyPropertyChanged` interfész a megoldás itt, hanem az `INotifyCollectionChanged` interfész, ami a kollekció változásairól küld értesítést. Ezt az `ObservableCollection` implementálja.

    Tehát már két változáskezelést támogató interfészünk van, amit az adatkötés figyel: `INotifyPropertyChanged` és `INotifyCollectionChanged`.

## Fordítás idejű adatkötés (x:Bind)

A `Binding` markup extension futás időben dolgozik reflection segítségével, így egyrészt nem kapunk fordítás idejű hibákat, ha valamit elírtunk volna, másrészt pedig sok adatkötés (1000-es nagyságrend) jelentésen lassíthatja az alkalmazásunkat.

Ennek megoldására megjelent a fordítás idejű adatkötés támogatása, amit WinUI platformon az `x:Bind` szintaktikával érhetünk el.

Van viszont néhány eltérés a sima Binding-hoz képest:

* Nem a `DataContext`-ből dolgozik és nem is lehet állítani az adatkötés forrását, mivel mindig az adott nézetből (xaml.cs) köt. Olyan, mint amikor megadtuk a a nézetben, hogy `DataContext = this;`
* Alapértelmezett módja a `OneTime` és nem a `OneWay`: tehát nem figyeli a változásokat alapértelmezetten!
* Adatsablonokban is használható, de olyankor nyilatkozni kell a `DataTemplate`-en, hogy az milyen adatokon fog dolgozni az `x:DataType` attribútummal.
* Lehetőség van függvényeket is kötni, amivel kiváltható a konverterek használata. Függvények kötése esetén a változásértesítés a paraméterek változására is működik.

Írjuk át a nézetünkben az adatkötéseket `x:Bind`-ra.

NewPerson form:

```xml
Text="{x:Bind NewPerson.Name, Mode=TwoWay}"
Text="{x:Bind NewPerson.Age, Mode=TwoWay}"
```

ListView:

```xml hl_lines="3 5 6"
<ListView Grid.Row="3"
          Grid.ColumnSpan="4"
          ItemsSource="{x:Bind People, Mode=OneWay}">
    <ListView.ItemTemplate>
        <DataTemplate x:DataType="model:Person">
            <TextBlock Text="{x:Bind local:MainWindow.FormatPerson(Name, Age)}" />
        </DataTemplate>
    </ListView.ItemTemplate>
</ListView>
```

Fentebb említettük, hogy `x:Bind`-ban lehet függvényeket is kötni. Ezek lehetne példányhoz kötött függvények, amik ebben az esetben a `Person` osztályon keresne, mivel a `DataTemplate`-ben most ez a kontextus. Mi most viszont egy statikus függvényt fogunk kötni, ami a `MainWindow` osztályon keresendő.

```csharp
private static string FormatPerson(string name, int age)
{
    return $"{name} ({age})";
}
```

## Önálló feladat

Az előző feladatot teszteljük a következő módon:

Adjunk a listához az új elemet, majd módosítsuk a beviteli mezők valamelyikét. Adjuk hozzá ismét a listához a személyt és ismét módosítsuk az adatait.

1. Mit tapasztalunk és miért?
2. Próbáljuk megjavítani az eddig tanultak alapján!
