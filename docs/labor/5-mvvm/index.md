---
authors: tibitoth
---

# 5. MVVM

A labor során egy recept böngésző alkalmazást fogunk készíteni, amelyben alkalmazzuk az MVVM tervezési mintát.

## A gyakorlat célja

A labor során egy recept böngésző alkalmazást fogunk készíteni, amelyben alkalmazzuk az MVVM tervezési mintát.

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

## Megoldás

??? success "A kész megoldás letöltése"
    :exclamation: Lényeges, hogy a labor során a laborvezetőt követve kell dolgozni, tilos (és értelmetlen) a kész megoldás letöltése. Ugyanakkor az utólagos önálló gyakorlás során hasznos lehet a kész megoldás áttekintése, így ezt elérhetővé tesszük.

    A megoldás [GitHubon érhető el](https://github.com/bmeviauab00/lab-mvvm-kiindulo) a `megoldas` ágon. A legegyszerűbb mód a letöltésére, ha parancssorból a `git clone` utasítással leklónozzuk a gépünkre a `megoldas` ágat:

    ```git clone https://github.com/bmeviauab00/lab-xaml-kiindulo -b megoldas```

## Az MVVM mintáról

Az MVVM (Model-View-ViewModel) egy architekturális tervezési minta, amelyet a XAML alkalmazások fejlesztése során használhatunk, de gyakran más kliens oldali technológiák esetében is megjelenik. Az MVVM minta célja, hogy a felhasználói felületet és a mögötte lévő üzleti logikát szétválassza, és ezzel egy lazább csatolású alkalmazást hozzon létre, ami növeli a tesztelhetőséget, a karbantarthatóságot, és az újrafelhasználhatóságot.

Az MVVM minta három fő részből áll:

* **Model**: Az alkalmazás üzleti logikáját tartalmazza, amelyet a ViewModel-ek használnak.
* **View**: A felhasználói felület leírását tartalmazza, és a tisztán a nézetekhez kapcsolódó logikát (pl.: animációk kezelését).
* **ViewModel**: A nézet **absztrakciója**, ami tartalmazza a nézet állapotát és a végrehajtható műveleteket, **nézet függetlenül**. A lazán csatolást a ViewModel és a nézet közötti adatkötés biztosítja.

<figure markdown>
![MVVM](images/mvvm.drawio.png)
</figure>

## 0. Feladat - Projekt felépítése

TBD

## 1. Feladat - Receptek főoldal

A megoldás során "alulról", az adatok felől fogunk építkezni és fokozatosan fogunk eljutni a nézetig. Ugyan a való életben egy top-bottom fejlesztés gyakran hasznosabb, de a labor során az idő rövidsége miatt az alulról építkezés gyorsabb és egyszerűbb, mert így nem kell az adatokat mockolni.

### Adatelérési szolgáltatás

Kezdjük az adatelérési réteggel, amit most tekinthetünk az MVVM mintában a modell rétegnek is.

Az alkalmazásunk adatait egy webszerverről, REST API-n, HTTP-n keresztül éri el. Ez ehhez hasonló kliens-szerver architektúrájú alkalmazások egy kifejezetten gyakori megoldás a modern alkalmazások fejlesztése során. Erről bővebben a Mobil és Webes szoftverek, illetve az Adatvezérelt alkalmazások tárgyakban lesz szó. Most elég annyit tudni, hogy a kliens alkalmazásunk HTTP kéréseket fog küldeni a szervernek, amelyekre a szerver válaszolni fog. A kérések és válaszok formátuma JSON lesz.

<figure markdown>
![Kliens-szerver architektúra](images/client-server.drawio.png)
<figurecation>Kliens-szerver architektúra<figurecaption>
</figure>

A távoli szolgáltatás a következő címen érhető el: <https://bmecookbook.azurewebsites.net>. A szolgáltatáshoz pedig tartozik egy OpenApi alapú dokumentáció a <https://bmecookbook.azurewebsites.net/swagger> címen. Tanulmányozzuk ezt át.
Az első feladathoz a `/api/Recipes/Groups` végpontot fogjuk használni, amely a receptek csoportosítását adja vissza.

Vegyünk fel az `MvvmLab.Core` projekt `Models` mappájába egy új osztályt `RecipeGroup` néven.

Az OpenApi dokumentációból rakjunk a vágólapra egy `RecipeGroup`-nyi JSON adatot, majd a Visual Studio-ban az `Edit` menü `Paste Special` menüpontjában a `Paste JSON as Classes` menüpontot választva illesszük be a vágólap tartalmát.

![Paste JSON as Classes](images/paste-json-as-classes.png)

A kapott osztályokat átnevezhetjük, hogy a C# kódolási konvencióknak megfeleljenek. A `Rootobject` osztályt nevezzük át `RecipeGroup`-ra, a `Recipe` osztályt pedig `RecipeHeader`-re. Használjunk tömbök helyett `List<T>`-t.

```csharp
public class RecipeGroup
{
    public string Id { get; set; }
    public string Title { get; set; }
    public List<RecipeHeader> Recipes { get; set; }
}

public class RecipeHeader
{
    public int Id { get; set; }
    public string Title { get; set; }
    public string BackgroundImage { get; set; }
    public string TileImage { get; set; }
}
```

Készítsünk egy `IRecipeService` interfészt az `MvvmLab.Core.Services` névtérbe, amelyen keresztül el fogjuk érni a szolgáltatást. Az interfészben egy `GetRecipeGroupsAsync` metódust hozzunk létre, amely a recept csoportokat adja vissza.

```csharp
public interface IRecipeService
{
    public Task<List<RecipeGroup>> GetRecipeGroupsAsync();
}
```

Az interfész implementációját a `MvvmLab.Core.Services` névtérben hozzuk létre `RecipeService` néven.
A szolgáltatásunk a `HttpClient` beépített .NET osztályt fogja használni a REST API hívásokhoz.
A `GetFromJsonAsync` indít egy HTTP GET kérést a megadott címre, és a
választ JSON formátumban deszerializálja a megadott típusra.

```csharp
public class RecipeService : IRecipeService
{
    private readonly string _baseUrl = "https://bmecookbook.azurewebsites.net/api";

    public async Task<List<RecipeGroup>> GetRecipeGroupsAsync()
    {
        using var client = new HttpClient();
        return await client.GetFromJsonAsync<List<RecipeGroup>>($"{_baseUrl}/Recipes/Groups");
    }
}
```

### Főoldal ViewModel

Következő lépésben a főoldal ViewModeljét fogjuk elkészíteni, amely az előbb elkészített szolgáltatást fogja használni a recept csoportok lekérdezéséhez, és azt állapotként fogja tárolni a nézet számára.

Nyissuk meg a `MainViewModel` osztályt az `MvvmLab.ViewModels` mappából. A ViewModelünknek szüksége lesz egy `IRecipeService` interfészt implementáló osztályra, amelyen keresztül le tudja kérdezni a recept csoportokat.
A `MainViewModel` konstruktorában függőség injektáláson keresztül szerezzük be a szükséges függőséget.
Esetünkben ez annyit tesz, hogy várunk egy `IRecipeService` típusú paramétert, amelyet majd a ViewModel példányosításakor fog megkapni, és a paramétert elmentjük egy privát változóba.

```csharp
private readonly IRecipeService _recipeService;

public MainViewModel(IRecipeService recipeService)
{
    _recipeService = recipeService;
}
```

??? tip "Függőség Injektálás - Dependency Injection - DI"
    A függőség injektálás (dependency injection (DI)), egy modern alkalmazásokban elkerülhetetlen tervezési minta, ami az objektumok életciklusát szabályozza. 

    Alap esetben az osztályok szoros csatolást alakítanak ki a függőségeikkel (referencia, példányosítás). Ez a szoros csatolás nehezíti a tesztelhetőséget, a karbantarthatóságot, és az újrafelhasználhatóságot.
    
    ![Without DI](images/without-di.png)

    A DI segítségével a függőségeket életciklusát egy kitüntetett kompoenes kezeli, a DI konténer. A DI konténer (ábrán Builder) felelős az osztályok példányosításáért, és a függőségek beinjektálásáért. A DI konténerben regisztrálni kell az osztályokat, amelyeket a DI konténer példányosítani fog. A példányosítás során pedig a függőségi gráfot bejárva beinjektálja a megfelelő implementációkat.

    ![With DI](images/with-di.png)

Ahhoz, hogy a Dependency Injection működjön, szükséges a `MainViewModel` osztályt regisztrálni az `App.xaml.cs` fájlban a `ConfigureServices` metódusban.

```csharp
services.AddTransient<IRecipeService, RecipeService>();
```

Jelenleg ezt a szolgáltatást **Tranziens** élettartamúként regisztráltuk, ami azt jelenti, hogy minden egyes `IRecipeService` függőség igényt egy új `RecipeService` példány fog kielégíteni.

Következő lépésben a ViewModel állapotát implementáljuk.

A `MainViewModel`-ben hozzunk létre egy `_recipeGroups` nevű `List<RecipeGroup>` változót, amelyben tárolni fogjuk a recept csoportokat. A változót attributáljuk fel a `ObservableProperty` attribútummal, ami alapján az MVVM Toolkit automatikusan generálni fogja a `RecipeGroups` nevű property-t az osztály másik generált partial felében.
Ez a generált property kihasználja az `INotifyPropertyChanged` interfészt, így a `RecipeGroups` property értékének megváltozásakor a `PropertyChanged` eseményt kiváltva értesíti a nézetet, hogy frissítse magát.

```csharp
[ObservableProperty]
private List<RecipeGroup>? _recipeGroups = new();
```

A `MainViewModel` implementálja az előkészített `INavigationAware` interfészt, amelynek segítségével a nézetek közötti navigáció során tudunk adatokat átadni a ViewModel-ek között. A `OnNavigatedTo` metódusban kérdezzük le a recept csoportokat az `IRecipeService`-en keresztül, majd tároljuk el a `RecipeGroups` változóban.

```csharp
public partial class MainViewModel : ObservableRecipient, INavigationAware
{
    // ...

    public async void OnNavigatedTo(object parameter)
    {
        RecipeGroups = await _recipeService.GetRecipeGroupsAsync();
    }

    public void OnNavigatedFrom()
    {
    }
}
```

## Főoldal nézet

A `MainPage`-en készítsük el a nézetet, amelyen megjelenítjük a recept csoportokat.

Ahhoz, hogy a csoportosítást kezelni tudja a `GridView`, szükségünk van egy olyan listára, ami elvégzi a csoportosítást.
Ezt a `CollectionViewSource` osztály segítségével tudjuk megvalósítani, ami bizonyos szempontból UI specifikus burkoló feladatokat lát el.
A `CollectionViewSource`-nak meg kell adnunk a csoportosítandó elemeket, valamint azt, hogy a csoportokat milyen property alapján hozza létre.
Továbbá meg kell adnunk azt is, hogy a csoportokon belül milyen property alapján jelenítse meg az elemeket.
A `CollectionViewSource` `View` property-jét kössük a `GridView` `ItemsSource` property-jére.

A `GridView`-en belül a `GridView.ItemTemplate` property-n keresztül tudjuk megadni, hogy az egyes elemeket hogyan kell megjeleníteni. A `GridView`-n belül a `GridView.GroupStyle` property-n keresztül tudjuk megadni, hogy a csoportokat hogyan kell megjeleníteni.

```xml
<Page.Resources>
    <CollectionViewSource x:Name="RecipeGroupsCollectionSource"
                            IsSourceGrouped="True"
                            ItemsPath="Recipes"
                            Source="{x:Bind ViewModel.RecipeGroups, Mode=OneWay}" />
</Page.Resources>

<Grid x:Name="ContentArea">
    <Grid.RowDefinitions>
        <RowDefinition Height="48" />
        <RowDefinition Height="*" />
    </Grid.RowDefinitions>

    <TextBlock Text="Recipes"
               Grid.Row="0"
               Style="{StaticResource PageTitleStyle}" />

    <controls:AdaptiveGridView Grid.Row="1"
                               DesiredWidth="180"
                               IsItemClickEnabled="True"
                               ItemHeight="160"
                               ItemsSource="{x:Bind RecipeGroupsCollectionSource.View, Mode=OneWay}"
                               SelectionMode="None"
                               StretchContentForSingleRow="False">
        <GridView.ItemTemplate>
            <DataTemplate x:DataType="models:RecipeHeader">
                <Grid MaxWidth="300">
                    <Image Source="{x:Bind BackgroundImage}" />
                    <Border Height="40"
                            Padding="10,0,0,0"
                            VerticalAlignment="Bottom"
                            Background="#88000000">
                        <TextBlock VerticalAlignment="Center"
                                   Foreground="White"
                                   Text="{x:Bind Title}" />
                    </Border>
                </Grid>
            </DataTemplate>
        </GridView.ItemTemplate>
        <GridView.GroupStyle>
            <GroupStyle>
                <GroupStyle.HeaderTemplate>
                    <DataTemplate x:DataType="models:RecipeGroup">
                        <TextBlock Margin="0"
                                   Style="{ThemeResource TitleTextBlockStyle}"
                                   Text="{x:Bind Title}" />
                    </DataTemplate>
                </GroupStyle.HeaderTemplate>
            </GroupStyle>
        </GridView.GroupStyle>
    </controls:AdaptiveGridView>
</Grid>
```

Próbáljuk ki az alkalmazást, és győződjünk meg róla, hogy a recept csoportok megjelennek a főoldalon.

## Recept részletes oldal

A receptek részletes oldalának elkészítése a következő lépésekből fog állni:

1. Kiegészítjük az `IRecipeService` interfészt egy `GetRecipeAsync` metódussal és létrehozzuk a szükséges osztályokat
1. Létrehozzuk a `RecipeDetailViewModel` ViewModel-t, amiben lekérdezzük a recept adatait a `RecipeDetailViewModel`-ben az `IRecipeService`-en keresztül
1. Létrehozzuk a `RecipeDetailPage` nézetet, építve a ViewModel adataira
1. Regisztráljuk a ViewModel-t és a nézetet a Dependency Injection konfigurációhoz és a navigációhoz
1. Navigálunk a `RecipeDetailPage`-re a `MainViewModel`-ből az `INavigationService`-en keresztül, ha egy receptre kattintunk, és átadjuk a kiválasztott recept azonosítóját (vagy recept fejlécet)

### Recept lekérdezése

Generáljuk le a `Recipe` osztályt a `MvvmLab.Core.Model` névtérbe a `/api/recipes/{id}` végpont által visszaadott példa JSON adatokból, a fenti módszerrel.

```csharp
public class Recipe
{
    public List<string> ExtraImages { get; set; }
    public List<string> Ingredients { get; set; }
    public string Directions { get; set; }
    public string Video { get; set; }
    public List<Comment> Comments { get; set; }
    public List<StoresNearby> StoresNearby { get; set; }
    public int Id { get; set; }
    public string Title { get; set; }
    public string BackgroundImage { get; set; }
    public string TileImage { get; set; }
}

public class Comment
{
    public string Name { get; set; }
    public string PictureUrl { get; set; }
    public string Text { get; set; }
}

public class StoresNearby
{
    public string Name { get; set; }
    public string Url { get; set; }
    public float Longitude { get; set; }
    public float Latitude { get; set; }
}
```

A `IRecipeService` interfészt egészítsük ki egy `GetRecipeAsync` metódussal, ami egy receptet ad vissza az azonosítója alapján.

```csharp
public Task<Recipe> GetRecipeAsync(int id);
```

Az interfész implementációját a `RecipeService` osztályban valósítsuk meg.

```csharp
public async Task<Recipe> GetRecipeAsync(int id)
{
    using var client = new HttpClient();
    return await client.GetFromJsonAsync<Recipe>($"{_baseUrl}/Recipes/{id}");
}
```

### Recept részletes ViewModel

Hozzuk létre a `RecipeDetailViewModel` osztályt az `MvvmLab.ViewModels` mappában.

A ViewModel-nek szüksége lesz egy `IRecipeService` interfészt implementáló osztályra, amelyen keresztül le tudja kérdezni a receptet. A `RecipeDetailViewModel` konstruktorában DI segítségével szerezzük be a szükséges függőséget.

```csharp
private readonly IRecipeService _recipeService;

public RecipeDetailViewModel(IRecipeService recipeService)
{
    _recipeService = recipeService;
}
```

A `RecipeDetailViewModel`-ben hozzunk létre egy `_recipe` nevű `Recipe` típusú változót, amelyben tárolni fogjuk a receptet.
A változót attributáljuk fel a `ObservableProperty` attribútummal, ami alapján az MVVM Toolkit automatikusan generálni fogja a `Recipe` nevű property-t az osztály másik generált partial felében.
Ehhez szükséges, hogy az osztály az `ObservableObject` osztályból származzon, és `partial` kulcsszóval legyen jelölve.

```csharp
public partial class RecipeDetailViewModel : ObservableObject
{
    // ...

    [ObservableProperty]
    private Recipe? _recipe = new();
```

Implementáljuk a `RecipeDetailViewModel`-ben az előkészített `INavigationAware` interfészt.
Arra készülünk, hogy a navigációs paraméterként a recept azonosítóját fogjuk megkapni.
A `OnNavigatedTo` metódusban kérdezzük le a receptet a `RecipeService`-en keresztül, majd tároljuk el a `Recipe` változóban.

```csharp
public partial class RecipeDetailViewModel : ObservableRecipient, INavigationAware
{
    // ...

    public async void OnNavigatedTo(object parameter)
    {
        Recipe = await _recipeService.GetRecipeAsync((int)parameter);
    }

    public void OnNavigatedFrom()
    {
    }
}
```

### Recept részletes nézet, navigáció

A `RecipeDetailPage`-en készítsük el a nézetet, amelyen megjelenítjük a receptet. Első körben csak a recept címét jelenítsük meg egy `TextBlock`-ban.

```xml
<Grid x:Name="ContentArea">
    <Grid.RowDefinitions>
        <RowDefinition Height="48" />
        <RowDefinition Height="*" />
    </Grid.RowDefinitions>

    <TextBlock Grid.Row="0"
               Style="{StaticResource PageTitleStyle}"
               Text="{x:Bind ViewModel.Recipe.Title, Mode=OneWay}" />
</Grid>
```

A `Services` mappában lévő `PageService`-ben regisztráljuk be a `RecipeDetailPage`-et a navigációhoz.
Erre azért van szükség, mert a projekt sablonban lévő `INavigationService` alapvetően egy kulccsal azonosítja a nézeteket, hogy a ViewModel-ben ne legyen szükség a nézet típusának ismeretére.

```csharp
Configure<RecipeDetailViewModel, RecipeDetailPage>();
```

Az `App.xaml.cs` fájlban a `ConfigureServices` metódusban regisztráljuk be a ViewModel-t és a nézetet a Dependency Injection konténerbe.

```csharp
services.AddTransient<RecipeDetailPage>();
services.AddTransient<RecipeDetailViewModel>();
```

A `MainViewModel`-ben injektáljuk be az `INavigationService`-t, amelyen keresztül navigálni fogunk a `RecipeDetailPage`-re.

```csharp
private readonly INavigationService _navigationService;

public MainViewModel(IRecipeService recipeService, INavigationService navigationService)
{
    _recipeService = recipeService;
    _navigationService = navigationService;
}
```

A `MainViewModel`-ben készítsünk egy Commandot, ami a receptre kattintva fog lefutni. A Command paraméterként megkapja a kiválasztott receptet fejlécet, és navigáljunk a `RecipeDetailPage`-re, és adjuk át a kiválasztott recept azonosítóját. Az MvvmToolkitel szintén egy attribútummal (`[RelayCommand]`) tudunk generálni a Commandot egy metódusból.

```csharp
[RelayCommand]
private void RecipeSelected(RecipeHeader recipe)
{
    _navigationService.NavigateTo(typeof(RecipeDetailViewModel).FullName!, recipe.Id);
}
```

A `MainPage`-en kössük a `GridView` `ItemClickCommand` eseményét a `RecipeSelectedCommand`-ra.

TODO: AdaptiveGridView, ItemClickCommand, mi van ha nincs az adott eseményre Command property, de MVVM-esen szeretnénk kezelni az eseményt?

```xml
ItemClickCommand="{x:Bind ViewModel.RecipeSelectedCommand}"
```

Próbáljuk ki az alkalmazást, és győződjünk meg róla, hogy a receptekre kattintva megjelenik a recept részletes oldala.

### Recept részletes nézet

A recept részletes adataihoz egy `Grid`-et használjunk, amelynek két oszlopa van.
Az első oszlopban egy `ScrollViewer`-t helyezzünk el, amelyben egy `StackPanel`-t helyezzünk el. A `StackPanel`-ben helyezzünk el egy `FlipView`-et, amelyben a recept képeit fogjuk megjeleníteni. A `FlipView` egy listaként működik, de az elemeit egy lapozható felületen jeleníti meg.

A `FlipView` alatt  helyezzünk el egy `ItemsControl`-t (lista, ami nem támogat görgetést, kiválasztás kattintást stb.), amelyben a recept hozzávalóit fogjuk megjeleníteni.Ez alatt helyezzünk el egy `TextBlock`-ot, amelyben a recept elkészítésének lépéseit fogjuk megjeleníteni.

A második oszlopban helyezzünk el egy `Grid`-et, amelynek három sorában egy `TextBlock`-ot helyezzünk el, amelyben a recepthez fűzött kommenteket fogjuk megjeleníteni egy `ListView`-ben.

```xml
<Grid Grid.Row="1">
    <Grid.ColumnDefinitions>
        <ColumnDefinition Width="*" />
        <ColumnDefinition Width="Auto" />
    </Grid.ColumnDefinitions>

    <ScrollViewer Grid.Column="0">
        <StackPanel Orientation="Vertical">
            <StackPanel x:Name="images"
                        Margin="0,0,24,0"
                        Orientation="Vertical">
                <TextBlock Margin="0,0,0,12"
                            Style="{StaticResource SubtitleTextBlockStyle}"
                            Text="Images" />
                <FlipView x:Name="flipView"
                            MaxHeight="250"
                            VerticalAlignment="Top"
                            ItemsSource="{x:Bind ViewModel.Recipe.ExtraImages, Mode=OneWay}">
                    <FlipView.ItemTemplate>
                        <DataTemplate>
                            <Image Source="{Binding}" Stretch="Uniform" />
                        </DataTemplate>
                    </FlipView.ItemTemplate>
                </FlipView>
            </StackPanel>

            <StackPanel x:Name="ingredients"
                        Margin="0,0,24,0"
                        Orientation="Vertical">
                <TextBlock Margin="0,0,0,12"
                            Style="{StaticResource SubtitleTextBlockStyle}"
                            Text="Ingredients" />
                <ItemsControl HorizontalAlignment="Left" ItemsSource="{x:Bind ViewModel.Recipe.Ingredients, Mode=OneWay}">
                    <ItemsControl.ItemTemplate>
                        <DataTemplate>
                            <TextBlock Margin="0,0,0,10"
                                        Text="{Binding}"
                                        TextWrapping="Wrap" />
                        </DataTemplate>
                    </ItemsControl.ItemTemplate>
                </ItemsControl>
            </StackPanel>

            <StackPanel x:Name="directions"
                        Margin="0,0,24,0"
                        Orientation="Vertical"
                        RelativePanel.RightOf="ingredients">
                <TextBlock Margin="0,0,0,12"
                            Style="{StaticResource SubtitleTextBlockStyle}"
                            Text="Directions" />
                <TextBlock HorizontalAlignment="Left"
                            Text="{x:Bind ViewModel.Recipe.Directions, Mode=OneWay}"
                            TextWrapping="Wrap" />
            </StackPanel>
        </StackPanel>
    </ScrollViewer>

    <Grid Grid.Column="1" RowSpacing="12">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto" />
            <RowDefinition Height="*" />
            <RowDefinition Height="Auto" />
        </Grid.RowDefinitions>

        <TextBlock Grid.Row="0"
                    Style="{StaticResource SubtitleTextBlockStyle}"
                    Text="Comments" />

        <ListView Grid.Row="1" ItemsSource="{x:Bind ViewModel.Recipe.Comments, Mode=OneWay}">
            <ListView.ItemTemplate>
                <DataTemplate x:DataType="models:Comment">
                    <StackPanel Orientation="Vertical">
                        <TextBlock FontWeight="Bold" Text="{x:Bind Name}" />
                        <TextBlock Text="{x:Bind Text}" />
                    </StackPanel>
                </DataTemplate>
            </ListView.ItemTemplate>
        </ListView>
    </Grid>
</Grid>
```

Próbáljuk ki az alkalmazást.

## Kommentek hozzáadása

TBD

## Vissza a főoldalra

TBD
