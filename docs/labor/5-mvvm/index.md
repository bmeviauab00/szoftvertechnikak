---
authors: tibitoth
---

# 5. MVVM

A labor során egy recept böngésző alkalmazást fogunk készíteni, amelyben alkalmazzuk az MVVM tervezési mintát.

## Az MVVM mintáról

TBD

## Kiinduló projekt

Klónozzuk le a kiinduló projektet az alábbi paranccsal:

```cmd
git clone https://github.com/bmeviauab00/MvvmLab
```

### Projekt felépítése

TBD

## Adatelérési szolgáltatás

Az alkalmazásunk adatait egy REST API-n keresztül éri el, ami a következő címen érhető el: `https://bmecookbook.azurewebsites.net/api/recipes/groups`. A szolgáltatás egy recepteket tartalmazó listát ad vissza csoportosítva JSON formátumban.

Az OpenApi specifikációban lévő `/api/recipes/groups` végpont által visszaadott példa JSON adatokból generáljuk le a szükséges osztályokat most a Visual Studio segítségével.

Vegyünk fel az `MvvmLab.Core` projekt `Model` mappájába egy új osztályt `RecipeGroup` néven.
Rakjunk a vágólapra egy RecipeGroup-nyi JSON adatot, majd a Visual Studio-ban az `Edit` menü `Paste Special` menüpontjában a `Paste JSON as Classes` menüpontot választva illesszük be a vágólap tartalmát.

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

Készítsünk egy `IRecipeService` interfészt az `MvvmLab.Core.Services` névtérbe, amelyen keresztül le fogjuk tudni kérdezni a recept csoportokat.

```csharp
public interface IRecipeService
{
    public Task<List<RecipeGroup>> GetRecipeGroupsAsync();
}
```

Az interfész implementációját a `MvvmLab.Core.Services` névtérben hozzuk létre `RecipeService` néven. A szolgáltatásunk a `HttpClient` osztályt fogja használni a REST API hívásokhoz.

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

## Főoldal ViewModel

Nyissuk meg a `MainViewModel` osztályt az `MvvmLab.ViewModels` mappából. A ViewModelünknek szüksége lesz egy `IRecipeService` interfészt implementáló osztályra, amelyen keresztül le tudja kérdezni a recept csoportokat. A `MainViewModel` konstruktorában dependency injection segítségével szerezzük be a szükséges függőséget.

```csharp
private readonly IRecipeService _recipeService;

public MainViewModel(IRecipeService recipeService)
{
    _recipeService = recipeService;
}
```

Ahhoz, hogy a Dependency Injection működjön, szükséges a `MainViewModel` osztályt regisztrálni az `App.xaml.cs` fájlban a `ConfigureServices` metódusban.

```csharp
services.AddTransient<IRecipeService, RecipeService>();
```

Jelenleg ezt a szolgáltatást Transient élettartamúként regisztráltuk, ami azt jelenti, hogy minden egyes `IRecipeService` függőséget egy új `RecipeService` példány fog kiszolgálni.

A `MainViewModel`-ben hozzunk létre egy `_recipeGroups` nevű `List<RecipeGroup>` változót, amelyben tárolni fogjuk a recept csoportokat. A változót attributáljuk fel a `ObservableProperty` attribútummal, ami alapján az MVVM Toolkit automatikusan generálni fogja a `RecipeGroups` nevű property-t az osztály másik generált partial felében.
Ez a generált property kihasználja az `INotidyPropertyChanged` interfészt, így a `RecipeGroups` property értékének megváltozásakor a `PropertyChanged` eseményt kiváltva értesíti a nézetet, hogy frissítse magát.

```csharp
[ObservableProperty]
private List<RecipeGroup>? _recipeGroups = new();
```

A `MainViewModel` implementálja az előkészített `INavigationAware` interfészt, amelynek segítségével a nézetek közötti navigáció során tudunk adatokat átadni a ViewModel-ek között. A `OnNavigatedTo` metódusban kérdezzük le a recept csoportokat a `RecipeService`-en keresztül, majd tároljuk el a `RecipeGroups` változóban.

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

A `MainPage`-en készítsük el a nézetet, amelyen megjelenítjük a recept csoportokat. A nézetet a `MainPage.xaml` fájlban hozzuk létre, amelynek kódja a következő legyen:

Ahhoz, hogy a csoportosítást kezelni tudja a GridView, szükségünk van egy olyan listára, ami elvégzi a coportosítást. Ezt a `CollectionViewSource` osztály segítségével tudjuk megvalósítani. A `CollectionViewSource`-nak meg kell adnunk a csoportosítandó elemeket, valamint azt, hogy a csoportokat milyen property alapján hozza létre. A `CollectionViewSource`-nak meg kell adnunk azt is, hogy a csoportokon belül milyen property alapján jelenítse meg az elemeket.
Ezt a `CollectionViewSource` `View` propertijét kössük a `GridView` `ItemsSource` property-jére.

A `GridView`-en belül a `GridView.ItemTemplate` property-n keresztül tudjuk megadni, hogy az egyes elemeket hogyan kell megjeleníteni. A `GridView`-en belül a `GridView.GroupStyle` property-n keresztül tudjuk megadni, hogy a csoportokat hogyan kell megjeleníteni.

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
1. Regisztráljuk a ViewModel-t és a nézetet a Dependency Injectionhöz és a navigációhoz
1. Navigálunk a `RecipeDetailPage`-re a `MainViewModel`-ből az `INavigationService`-en keresztül, ha egy receptre kattintunk, és átadjuk a kiválasztott recept azonosítóját (vagy recept fejlécet)

### Recept lekérdezése

Generáljuk le a `Recipe` osztályt a `/api/recipes/{id}` végpont által visszaadott példa JSON adatokból, a fenti módszerrel. A `Recipe` osztályt a `MvvmLab.Core.Model` névtérbe hozzuk létre.

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

A `IRecipeService` interfészt egészítsük ki egy `GetRecipeAsync` metódussal, amely egy receptet ad vissza az azonosítója alapján.

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

Hozzuk létre a `RecipeDetailViewModel` osztályt az `MvvmLab.ViewModels` mappában. A ViewModel-nek szüksége lesz egy `IRecipeService` interfészt implementáló osztályra, amelyen keresztül le tudja kérdezni a receptet. A `RecipeDetailViewModel` konstruktorában dependency injection segítségével szerezzük be a szükséges függőséget.

```csharp
private readonly IRecipeService _recipeService;

public RecipeDetailViewModel(IRecipeService recipeService)
{
    _recipeService = recipeService;
}
```

A `RecipeDetailViewModel`-ben hozzunk létre egy `_recipe` nevű `Recipe` változót, amelyben tárolni fogjuk a receptet. A változót attributáljuk fel a `ObservableProperty` attribútummal, ami alapján az MVVM Toolkit automatikusan generálni fogja a `Recipe` nevű property-t az osztály másik generált partial felében.

```csharp
[ObservableProperty]
private Recipe? _recipe = new();
```

A `RecipeDetailViewModel` implementálja az előkészített `INavigationAware` interfészt, amelynek segítségével a nézetek közötti navigáció során tudunk adatokat átadni a ViewModel-ek között.
Arra készülünk, hogy a navigáció paraméterek a recept azonosítóját fogjuk megkapni.
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

### Recept részletes nézet navigáció

A `RecipeDetailPage`-en készítsük el a nézetet, amelyen megjelenítjük a receptet. A nézetet a `RecipeDetailPage.xaml` fájlban hozzuk létre. Első körben csak a recept címét jelenítsük meg egy `TextBlock`-ban.

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
