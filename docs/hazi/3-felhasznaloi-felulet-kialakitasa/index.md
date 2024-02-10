---
authors: tibitoth
---

# 3. HF - Felhasználói felület kialakítása

## Bevezetés

A házifeladatban elkészítendő kis szoftver egy egyszerű feladatkezelő alkalmazás, amelyben a felhasználók feladatokat tudnak listázni létrehozni, módosítani.

Az önálló feladat a XAML előadásokon elhangzottakra épít. A feladatok gyakorlati hátteréül a [3. labor – Felhasználói felületek kialakítása](../../labor/3-felhasznaloi-felulet/index.md) laborgyakorlat szolgál.

A fentiekre építve, jelen önálló gyakorlat feladatai a feladatleírást követő rövidebb iránymutatás segítségével (néha alapértelmezetten összecsukva) önállóan elvégezhetők.

Az önálló gyakorlat célja:

- XAML felületleíró nyelv használatának gyakorlása
- Alapvető vezérlők (táblázat, gomb, szövegdoboz, listák) használatának gyakorlása
- Felületi interakciók kezelése eseményvezérelten
- Adatok megjelenítése a felületen adatkötéssel

A szükséges fejlesztőkörnyezetről [itt](../fejlesztokornyezet/index.md) található leírás.

## A beadás menete

:exclamation: [Bár az alapok hasonlók](../hf-folyamat/index.md), vannak lényeges, a folyamatra és követelményekre vonatkozó eltérések a korábbi házi feladatokhoz képest, így mindenképpen figyelmesen olvasd el a következőket.

- Az alapfolyamat megegyezik a korábbiakkal. GitHub Classroom segítségével hozz létre magadnak egy repository-t. A meghívó URL-t Moodle-ben találod (a tárgy nyitóoldalán a "*GitHub classroom hivatkozások a házi feladatokhoz*" hivatkozásra kattintva megjelenő oldalon látható). Fontos, hogy a megfelelő, ezen házi feladathoz tartozó meghívó URL-t használd (minden házi feladathoz más URL tartozik). Klónozd le az így elkészült repository-t. Ez tartalmazni fogja a megoldás elvárt szerkezetét. A feladatok elkészítése után commit-old és push-old a megoldásod.
- A kiklónozott fájlok között a `TodoXaml.sln`-t megnyitva kell dolgozni.
- :exclamation: A feladatok kérik, hogy készíts **képernyőképet** a megoldás egy-egy részéről, mert ezzel bizonyítod, hogy a megoldásod saját magad készítetted. **A képernyőképek elvárt tartalmát a feladat minden esetben pontosan megnevezi.**
A képernyőképeket a megoldás részeként kell beadni, a repository-d gyökérmappájába tedd (a neptun.txt mellé).
A képernyőképek így felkerülnek GitHub-ra a git repository tartalmával együtt.
Mivel a repository privát, azt az oktatókon kívül más nem látja.
Amennyiben olyan tartalom kerül a képernyőképre, amit nem szeretnél feltölteni, kitakarhatod a képről.
- :exclamation: A beadott megoldások mellé külön indoklást, illetve leírást nem várunk el, ugyanakkor az elfogadás feltétele, hogy a beadott kódban a feladat megoldása szempontjából relevánsabb részek kommentekkel legyenek ellátva.

## 1. feladat - Modell kialakítása és tesztadatok

A projekten belül hozzuk létre a `Models` mappába az alábbi ábrán látható osztályt és enum típust. A `TodoItem` osztály fogja tartalmazni a teendők adatait, a prioritáshoz egy felsorolt típust hozunk létre.

<figure markdown>
![Modell](images/model.png)
</figure>

A `MainPage` oldal fogja a teendők listáját megjeleníteni. Most memóriában lévő tesztadatokkal használjunk, amit a `MainPage.xaml.cs`-ben hozzunk létre.
A `Todos` tulajdonság fogja tartalmazni a listát, amit kikötünk a felületen a listában. Ez a lista `TodoItem` objektumokat tartalmaz.

```csharp title="MainPage.xaml.cs"
public List<TodoItem> Todos { get; set; } = new()
{
    new TodoItem()
    {
        Id = 3,
        Title = "Neptunkódot is felvenni a neptun.txt-be",
        Description = "NEPTUN",
        Priority = Priority.Normal,
        IsDone = false,
        Deadline = new DateTime(2024, 11, 08)
    },
    new TodoItem()
    {
        Id = 1,
        Title = "Tejet venni",
        Description = "Ha van tojás, hozz tizet!",
        Priority = Priority.Low,
        IsDone = true,
        Deadline = DateTimeOffset.Now + TimeSpan.FromDays(1)
    },
    new TodoItem()
    {
        Id = 2,
        Title = "Megcsinálni a grafika házit",
        Description = "Sugárkövetés, csilli-villi legyen! :)",
        Priority = Priority.High,
        IsDone = false,
        Deadline = new DateTime(2024, 11, 08)
    },
};
```

## 2. feladat - Oldal layoutja, lista megjelenítése

### Layout

A `MainPage.xaml`-ben hozzuk létre a felületet, amelyen a teendők listáját megjelenítjük.

<figure markdown>
![MainPage](images/mainpage.png)
<figurecaption>Készítendő alkalmazás listázó felülettel</figurecaption>
</figure>

A felületen a következő struktúrában helyezkednek el az elemek:

* A `MainPage`-en belül egy `Grid`-et használjunk, amelynek két sorban és két oszlopban helyezkednek el az elemek. Az első oszlop fix széles legyen (pl.: 300 px), a második pedig a maradék helyet foglalja el.
* Az első oszlop első sorában egy `CommandBar` vezérlő kerüljön, amibe egy cím és egy gomb helyezkedik el. Ehhez az alábbi példa szolgál segítségül:

    ```xml
    <CommandBar VerticalContentAlignment="Center"
                Background="{ThemeResource AppBarBackgroundThemeBrush}"
                DefaultLabelPosition="Right">
        <CommandBar.Content>
            <TextBlock Margin="12,0,0,0"
                       Style="{ThemeResource SubtitleTextBlockStyle}"
                       Text="Teendők" />
        </CommandBar.Content>

        <AppBarButton Icon="Add"
                      Label="Hozzáadás" />
    </CommandBar>
    ```

    !!! note "ThemeResource"
        A példában szerepló `ThemeResource`-okat használhatjuk a színek és stílusok beállítására, amik a felület témájától függően változnak. Például a `AppBarBackgroundThemeBrush` a felület témájától függően a megfelelő színű háttér lesz.

        Részletekért lásd a [dokumentációt](https://docs.microsoft.com/en-us/windows/uwp/design/style/color#theme-resources) és a [WinUI 3 Gallery App Colors](winui3gallery://item/Colors) példáit.

A `CommandBar` alatti cellában egy listába (`ListView`) kerüljenek a teendők a következő tartalommal egymás alatt. Az adatok adatkötésen keresztül hassanak a felület megjelenítésére.

* Teendő címe
    * Félkövér betűtípussal
    * Prioritás alapján színezve
        * Magas prioritás: piros egy árnyalata
        * Normál prioritás: beépített előtérszín
        * Alacsony prioritás: kék egy árnyalata
* A teendő címével egy sorban jobbra rendezve egy pipa ikon, ha a teendő el van végezve
* Teendő leírása
* Teendő határideje `yyyy.MM.dd` formátumban
    

??? tip "Feltételes színezés"
    A cím színezésére használhatunk konvertert vagy `x:Bind` alapú függvény kötést is.

    - `x:Bind` alapú függvény kötés példa:
            
        ```xml
        Foreground="{x:Bind local:MainPage.GetForeground(Priority)}"
        ```

        Itt a `GetForeground` egy statikus függvény a `MainPage` osztályban, amely a `Priority` felsorolt típus alapján visszaadja a megfelelő színű `Brush` objektumot.
        Alap esetben nem lenne fontos a függvénynek statikusnak lennie, de mivel itt egy `DataTemplate`-ben használjuk az adatkötést, ezért az `x:Bind` kontextusa nem az oldal példánya lesz, hanem a listaelem.


    - Converter használatára példa:

        Hozzunk létre egy konverter osztályt egy `Converters` mappába, ami megvalósítja az `IValueConverter` interfészt.

        ```csharp
        public class PriorityBrushConverter : IValueConverter
        {
            public object Convert(object value, Type targetType, object parameter, string language)
            {
                // TODO return a SolidColorBrush instance
            }

            public object ConvertBack(object value, Type targetType, object parameter, string language)
            {
                throw new NotImplementedException();
            }
        }
        ```

        Példányosítsuk a konvertert a `MainPage` erőforrásai között.

        ```xml
        xmlns:c="using:TodoXaml.Converters"

        <Page.Resources>
            <c:PriorityBrushConverter x:Key="PriorityBrushConverter" />
        </Page.Resources>
        ```

        Használjuk az adatkötésben statikus erőforrásként a konvertert

        ```xml
        Foreground="{x:Bind Priority, Converter={StaticResource PriorityBrushConverter}}"
        ```

    A Brushok példányosításához használjuk a `SolidColorBrush` osztályt, vagy használhatunk beépített ecseteket is C#-kódból (mint fentebb a `ThemeResource`-szal).

    ```csharp
    new SolidColorBrush(Colors.Red);

    (Brush)App.Current.Resources["ApplicationForegroundThemeBrush"]
    ```

??? tip "Pipa ikon láthatósága"
    A pipa ikonhoz használjunk egy `SymbolIcon`-t, aminek az `Icon` tulajdonságát állítsuk be `Accept` értékre.

    A pipa ikon megjelenítésekor egy igaz-hamis értéket kell átalakítani `Visibility` típusúra. Erre ugyan használhatnánk konvertert is, de ez a konverzió annyira gyakori, hogy az `x:Bind` adatkötés beépítetten konvertálja a `bool` értéket `Visibility`-re.

??? tip "Dátumok formázása"
    A határidő dátum formázására használhatunk szintén konvertert vagy `x:Bind` alapú függvény kötést is, ahol a `DateTime.ToString` függvényét kötjük ki paraméterezve.

    ```xml
    Text="{x:Bind Deadline.ToString('yyyy.MM.dd', {x:Null})}"
    ```

    A `{x:Null}` azért kell, mert a `ToString` függvénynek a második paraméterét is meg kell adni, de az lehet `null` is ebben az esetben.

!!! example "2. feladat BEADANDÓ"
    Illessz be egy képernyőképet az alkalmazásról, ahol az egyik teendőnek a listában a neve vagy leírása a NEPTUN kódod legyen! (`f2.png`)

## 3. feladat - Új teendő hozzáadása

A felületen a `Hozzáadás` gombra kattintva jelenjen a grid jobb oldalán a 2. sorban egy űrlap, ahol új teendőt lehet felvenni.
Az űrlap kinézete legyen a következő:

<figure markdown>
![New Todo](images/newtodo.png)
<figurecaption>Teendő szerkesztő űrlap</figurecaption>
</figure>

Az űrlapban a következő elemek legyenek egymás alatt.

* **Cím**: szöveges beviteli mező
* **Leírás**: magasabb szöveges beviteli mező, fogadjon el entert is (`AcceptsReturn="True"`)
* **Határidő**: dátumválasztó (`DatePicker`) (Megj.: Ezért a vezérlő miatt használunk a modellben `DateTimeOffset` típust.)
* **Prioritás**: legördülő lista (`ComboBox`), amiben a `Priority` felsorolt típus értékei szerepelnek
* **Készültség**: jelölőnégyzet (`CheckBox`)
* **Mentés**: gomb beépített accent stílussal (`Style="{StaticResource AccentButtonStyle}"`)

További funkcionális követelmények:

* Az űrlap csak akkor legyen látható, ha a _Hozzáadás_ gombra kattintottak, és tűnjön el, ha a teendő mentésre kerül.
* A _Mentés_ gombra kattintva a felvitt adatok kerüljenek a listába, és az űrlap tűnjön el.
* Az űrlap legyen görgethető, ha a tartalma nem fér ki a képernyőre (`ScrollViewer` használata).

??? success "Mentés megvalósításának lépései"

    1. Az űrlapban lévő adatokat egy új `TodoItem` objektumba gyűjtsük össze, aminek az propertyjeit adatkötjük (két irányúan) a felületen. Hozzunk létre egy tulajdonságot ehhez `EditedTodo` néven.
    2. A _Hozzáadás_ gombra kattintva legyen példányosítva az `EditedTodo`. Gondoljunk arra, hogy az adatkötéseknek frissülniük kell a felületen.
    3. A mentés során a `Todos` listához adjuk hozzá a szerkesztett teendő objektumot. Itt is gondoljunk arra, hogy az adatkötéseknek frissülniük kell a felületen a lista tartalmának változása során.
    4. Az `EditedTodo` property-t nullozzuk ki, hogy az űrlap újra üres legyen, és tűnjön el.
          1. A megjelenítés és elrejtéshez az `EditedTodo` property `null` vagy nem `null` értékét kell konvertálni `Visibility`-re. Erre használhatunk konvertert vagy `x:Bind` alapú függvény kötést is.

??? tip "Prioritások listája"
    A `ComboBox`-ban a `Priority` felsorolt típus értékeit jelenítsük meg. Ehhez használhatjuk a `Enum.GetValues` függvényt, amihez készítsünk egy tulajdonságot a `MainPage.xaml.cs`-ben.

    ```csharp
    public List<Priority> Priorities { get; } = Enum.GetValues(typeof(Priority)).Cast<Priority>().ToList();
    ```

    A `ComboBox` `ItemsSource` tulajdonságához kössük az `Priorities` listát.

    ```xml
    <ComboBox ItemsSource="{x:Bind Priorities}" />
    ```

!!! example "3. feladat BEADANDÓ"
    Illessz be egy képernyőképet az alkalmazásról, ahol az új teendő felvétele látható még mentés előtt! (`f3.1.png`)

    Illessz be egy képernyőképet az alkalmazásról, ahol az előző képen lévő teendő a listába került és eltűnt az űrlap! (`f3.2.png`)

## 4. (opcionális) iMSc feladat - Teendő szerkesztése

Valósítsd meg a teendők szerkesztésének lehetőségét az alábbiak szerint:

* A felületen a teendők listában az elemre kattintva, az adott teendő adatai a szerkesztő felületen kerüljön megjelenítésre, ahol azok így szerkeszthetőek és menthetőek lesznek.
* A mentés során a listában a szerkesztett teendő adatai frissüljenek, és az űrlap tűnjön el.

??? success "Megoldási tippek"
    * Érdemes karbantartani a teendők egyedi azonosítóját a beszúrás során, ,hogy figyelni tudjuk a mentés során, hogy ez egy szerkesztés vagy beszúrás-e.
    * A lista elemre kattintáshoz az `ItemClick` eseményt célszerű használni, miután bekapcsoltuk a `IsItemClickEnabled` tulajdonságot a `ListView`-n.
    * A szerkesztendő adatok kezelésére több megoldás is elképzelhető, ezekből az egyik: 
        * Az `EditedTodo` property-t állítsuk be a szerkesztett teendőre a kattintáskor.
        * A mentés gombra kattintva a `Todos` listában cseréljük le a szerkesztett teendőt az `EditedTodo` értékére. Valójában ugyanazt az elemet cseréljük le önmagára, de a `ListView` így frissülni tud.

!!! example "4. iMSc feladat BEADANDÓ"
    Illessz be egy képernyőképet az alkalmazásról, ahol egy meglévő elemre kattintva kitöltődik az űrlap! (`f4.imsc.1.png`)

    Illessz be egy képernyőképet az alkalmazásról, ahol az előző képen kiválasztott teendő mentés hatására frissül a listában! (`f4.imsc.2.png`)

## Beadás

Ellenőrzőlista ismétlésképpen:

--8<-- "docs/hazi/beadas-ellenorzes/index.md:3"