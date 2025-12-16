---
authors: tibitoth
---

# 5. MVVM

## The aim of the laboratory

During this lab, we will refactor a simple application using the MVVM pattern to improve clarity and maintainability.

## Prerequisites

Tools required for completing the lab:

* Windows 10 or Windows 11 operating system (Linux and macOS are not suitable)
* Visual Studio 2022
    * Windows Desktop Development Workload

## Starter Project

Clone the starter project using the following command:

```cmd
git clone https://github.com/bmeviauab00/lab-mvvm-kiindulo
```

??? success "Download the completed solution"
    :exclamation: It is essential to work following the instructor during the lab, it is forbidden (and pointless) to download the final solution in advance. However, during subsequent independent practice, it can be useful to review the final solution, so we make it available.

    The solution is available on [GitHub](https://github.com/bmeviauab00/lab-mvvm-kiindulo/tree/megoldas) on the `megoldas` branch. The easiest way to download it is to use the `git clone` command from the command line and clone the `megoldas` branch:

    `git clone https://github.com/bmeviauab00/lab-mvvm-kiindulo -b megoldas`

## About the MVVM Pattern

MVVM (Model-View-ViewModel) is an architectural design pattern commonly used in developing XAML applications, but it also appears in many other client-side technologies (e.g., Android, iOS, Angular, etc.). The goal of the MVVM pattern is to separate the user interface from the underlying logic, creating a more loosely coupled application that enhances testability, maintainability, and reusability.

The MVVM pattern consists of three (+1) main components:

* **Model**: Encapsulates domain-specific data that ViewModels can use for data storage. For example, a `Recipe`/`Product`/`Order` class aggregates the data of a recipe/ product/order.
* **View**: Contains the user interface definition (and any logic strictly related to the view, such as handling animations). Typically inherits from `Window`, `Page`, or `UserControl`, using declarative XAML descriptions. The code-behind is often empty since the logic resides in the ViewModel.
* **ViewModel**: Contains the logic for the corresponding view: it holds the state of the view and the actions that can be performed on it. **Independent** of the view, the loose coupling between ViewModel and View is achieved through data binding (the UI controls bind to properties of the ViewModel). It is unit testable!
* **Services**: Classes that contain the business/application logic of the application, used by the ViewModels. If all business logic were in the ViewModels, they would become overly complex and hard to manage. This is not officially part of the MVVM pattern, we mention them here because this is how we will structure the architecture of our application.

<figure markdown>
![MVVM](images/mvvm.drawio.png)
</figure>

:exclamation: When do we create ViewModel classes?

* For each **view** (e.g., `Window`, `Page`, `Dialog`, `UserControl`), we typically create a ViewModel class and instantiate one object of it per view. For example, `MainPage` gets a `MainPageViewModel`, and `DancerDialog` gets a `DancerDialogViewModel`. We will follow this approach during the lab.
* For each **model** class (e.g., `Recipe`, `Product`, `Dancer`, etc.), we may optionally create wrapper ViewModel classes (e.g., `RecipeViewModel`, `ProductViewModel`, `DancerViewModel`), but we **will not** do this in this lab. This is because we are following the Relaxed MVVM pattern instead of the Strict one (see the lecture).

## Task 0 – Reviewing the starter project

Our application is a simple book listing tool where books are displayed in a tabular format using an `ItemsView`.
Above the list, there is a `ComboBox` that allows filtering the books by genre.
The filter can be cleared using a _Clear_ button.

**Let's try it out!**

<figure markdown>
![Initial UI](images/kiindulo.png)
<figcaption>UI of the starter project</figcaption>
</figure>

!!! tip "ComboBox and ItemsView"
    Both `ComboBox` and `ItemsView` are list-based controls that can be filledwith data using the `ItemsSource` property.

    * `ComboBox` is a dropdown menu that allows the user to select an item from a list.

    * `ItemsView` provides a tabular layout where multiple items are visible simultaneously. It supports various display modes such as grid or list view, which can be set via the `Layout` property. Unlike the `ListView` used in the previous lab, each item template in `ItemsView` must have an `ItemContainer` as the root element.

In the starter project, the application logic is in the `BooksPage.xaml.cs` file, while the user interface is defined in `BooksPage.xaml`.
This implementation **does not** follow the MVVM pattern, meaning that the UI and its logic are tightly coupled, resulting in what is often referred to as “spaghetti code.”

A good example of this is how data loading directly manipulates the UI controls in this file.
User interactions are handled via event handlers, which can quickly become hard to manage and blur responsibility boundaries.

In our case, sample data is loaded using the `SeedDatabase` function, which is called in the constructor of `BooksPage`.
The `LoadGenres` and `LoadBooks` functions are responsible for loading the dropdown menu and the table respectively.

Changes in the selection of the dropdown and the press of the _Clear_ button are handled by separate event handler functions, which reload the list based on the selected genre (look for these in the code).

!!! note "Loading data from SQLite using ADO.NET"
    The application uses a SQLite database for data storage, accessed via ADO.NET. This technology will not be covered in detail during this lab, but we will discuss it more thoroughly at the end of the semester.

!!! note "Using Page instead of Window"
    Our view here is not a `Window`, but a subclass of `Page`. As the name suggests, a `Page` represents a "page" within the application: it cannot be displayed on its own, it must be placed e.g. within a window. The benefit is that — given proper navigation setup — it is possible to navigate between pages (different `Page` subclasses). We won’t use this feature; our app will only have a single page. The purpose of using a page is to demonstrate that in MVVM architecture, views can be implemented not only as `Window` (full windows) but also as `Page` objects (or other UI components such as `UserControl`).

## Task 1 – Introducing the MVVM pattern

During the lab, we will refactor the starter project to follow the MVVM pattern.

### Model

Let’s start from the bottom up, beginning with the model class. Move the `Book` class from the `BooksPage.xaml.cs` file into a new file located in a newly created `Models` folder.

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

The `Book` class has been moved from the previous `Lab.Mvvm` namespace to the `Lab.Mvvm.Models` namespace.  
To avoid long-term compilation errors due to this, we need to adjust the view (`BooksPage.xaml.cs`) to reflect the namespace change.  
Specifically, we should introduce a new namespace (`models`) and use it when specifying the data template type for the `ItemsView`:

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

Move the code responsible for loading the data into a new class called `BookService`, and place it into a newly created `Services` folder.

* Move the `SeedDatabase`, `LoadGenres`, and `LoadBooks` functions from the `BookPage.xaml.cs` file into the `BookService` class.

* Also, move the `_connectionString` field.

* Set the visibility of the functions to `public` so that our ViewModel class can access them.

The `SeedDatabase` function is fine as it is, but in the other two functions, we use several UI elements that we need to eliminate.

Refactor the functions so they only return the necessary data and do not directly use UI elements. Rename them to `GetGenres` and `GetBooks`.

* The `LoadGenres` function will return a list of type `List<string>`.

* The `LoadBooks` function will return a list of type `List<Book>`. Here, we also need to consider that previously we used the selected value of the `ComboBox` for the query; now, we need to pass this as an optional parameter to the function.

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

In addition to the changes highlighted above:

*  In the `GetGenres` function, we also remove the lines that manipulate the `genreFilterComboBox` and `clearGenreFilterButton`.
*  In the `BooksPage` class, we remove the calls to `SeedDatabase`, `LoadGenres`, and `LoadBooks` that cause compilation errors.

At this point, if we have done it correctly, there should be no compilation errors in our `BookService` class.

Call the `SeedDatabase` method when the application starts, so that the book and genre data is loaded into the database. The easiest place to do this is in the `OnLaunched` method in the `App.xaml.cs` file.

```csharp title="App.xaml.cs" hl_lines="6"
protected override void OnLaunched(Microsoft.UI.Xaml.LaunchActivatedEventArgs args)
{
    m_window = new MainWindow();
    new BookService().SeedDatabase();
    m_window.Activate();
}
```

### ViewModel

Let's create the new `BooksPageViewModel` class (for the `BooksPage`) in a new `ViewModels` folder. This, like a classic ViewModel, will contain the state of the view and the operations that can be performed on it — in other words, the **presentation logic** for the `BooksPage` view.

When we think about it, the `BooksPage` contains the following state information:

* The list of books
* The list of genres in the dropdown menu
* The selected genre

Let's add these as properties to the `BooksPageViewModel` class and implement the change notification based on the `INotifyPropertyChanged` interface that we learned in the previous lab to support data binding.

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
    The `SetProperty` method is a helper function that simplifies setting properties and notifying changes.

    The return value is `true` if the property value changed, and `false` if it didn't. This will help later in determining whether a change occurred in the property value.

    The `ref` keyword allows the method to modify the variable's value directly (not just the reference is passed, but the reference itself can be modified to change where the original variable points).

    The `CallerMemberName` attribute automatically passes the name of the calling member (in this case, the property), so we don't have to manually specify the property name everywhere.

We will implement data loading using the `BookService` class (scroll up in the guide, and check the introductory MVVM diagram to see that the ViewModel indeed uses the Service class/classes). Instantiate the `BookService` class and load the genres and books in its constructor.

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
    // Setting the Books property triggers the INPC PropertyChanged event (see Books property setter above) - the view will be refreshed
    Books = _booksService.GetBooks(SelectedGenre);
}
```

The book loading should not only be done in the constructor, but also in the setter of the `SelectedGenre` property to reload the books when the selected genre changes. In the setter of `SelectedGenre`, we will call the `LoadBooks` method if a change has occurred.

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

Now we only need to modify the view so that it uses the ViewModel.

Create a new `BooksPageViewModel` type readonly property in the `BooksPage.xaml.cs` file, and assign it a value by creating a new `BooksPageViewModel` instance.

```csharp
public BooksPageViewModel ViewModel { get; } = new BooksPageViewModel();
```

!!! warning "readonly property vs getter only property"
    Remember that there is a significant difference between an auto-implemented (once initialized) readonly property and a getter-only property. In the example above, we use an auto-implemented readonly property, meaning the `ViewModel` property value is created only once. In contrast, if we used a getter-only property, a new instance would be created every time it is accessed, leading to undesired behavior: `public BooksPageViewModel ViewModel => new BooksPageViewModel();`

From this point on, in the `BooksPage.xaml` file, we can use the `ViewModel` property for data binding.

* Let's first focus on the `ComboBox`:
    * In the initial solution, we manually manipulated the `SelectedItem` and `ItemsSource` properties in the code-behind file. We need to convert this handling into a data-binding-based solution: according to the MVVM pattern, we bind to the properties of the ViewModel object defined in the code-behind.
    * Delete the `SelectionChanged` event subscription in the XAML file and the `GenreFilterComboBox_SelectionChanged` event handler in the code-behind (since we no longer need it due to the `SelectedItem` data binding).
 
    ```xml hl_lines="4-5"
    <ComboBox x:Name="genreFilterComboBox"
            Grid.Row="1"
            PlaceholderText="Filter Genre"
            ItemsSource="{x:Bind ViewModel.Genres}"
            SelectedItem="{x:Bind ViewModel.SelectedGenre, Mode=TwoWay}" />
    ```

* For the _Clear_ button, also remove the `Click` event subscription and the `GenreFilterComboBox_SelectionChanged` event handler in the code-behind. We will implement its behavior in the ViewModel later.

    ```xml
    <Button x:Name="clearGenreFilterButton"
            Content="Clear" />
    ```

* In the `ItemsView`, we also need to use data binding for the `ItemsSource` property.

    ```xml hl_lines="3"    
    <ItemsView x:Name="booksGridView"
            Grid.Row="2"
            ItemsSource="{x:Bind ViewModel.Books, Mode=OneWay}">
        ...
    </ItemsView>
    ```

??? note "Classic Binding usage"
    If we were to use classic binding instead of `x:Bind`, we would need to set the `DataContext` property of the control/page to a ViewModel instance.

**Let's try it!**

Our application should work similarly to the previous one (except for the _Clear_ button), but now the architecture of the application follows the MVVM pattern.

### Summary

Let's evaluate our solution by looking at the code. In our initial solution, we had only one **Page** class, which mixed the presentation (.xaml) with application logic and presentation logic (the last two in the Page code-behind). In our MVVM-based solution:

* The Page now only contains the presentation (**View**), and the code-behind is essentially empty (it only contains a ViewModel).
* The application logic has been moved to a **Service** class.
* The display logic specific to the page has been placed into a **ViewModel** class (and the View binds to it).

In addition to better clarity, the main advantage of this approach is that the coupling between the ViewModel and the View is looser, making the ViewModel easier to test and potentially reusable. The ViewModel does not depend on the View, so it can easily be rewritten or replaced without modifying the View.

## Task 2 - MVVMToolkit

It is rare to implement the MVVM pattern relying solely on the .NET framework. It's worth using an MVVM library, which can make our code more compact, clearer, and contain less boilerplate code. Some of the most popular libraries include:

* [MVVM Toolkit](https://learn.microsoft.com/en-us/dotnet/communitytoolkit/mvvm/): MVVM library maintained by Microsoft.
* [Prism](https://prismlibrary.com/): Once maintained by Microsoft and very popular, but now maintained by external developers and has become a paid library over time.
* [ReactiveUI](https://reactiveui.net/): Uses the Reactive Extensions (Rx) libraries to manage ViewModel state and bind data between the View and ViewModel. This library offers the most features, but it is the hardest to learn.
* [Uno.Extensions](https://platform.uno/uno-extensions/): Built on top of MVVM Toolkit, but also includes services that fill in gaps in the WinUI framework.
* [Windows Template Studio](https://marketplace.visualstudio.com/items?itemName=TemplateStudio.TemplateStudioForWinUICs) is a Visual Studio extension that makes available a project template for more complex WinUI applications.

During the lab, we will try the MVVM Toolkit maintained by Microsoft.

### Installation

To install the MVVM Toolkit, open the NuGet Package Manager in Visual Studio (right-click on the project and select "Manage NuGet Packages"), and search for the `CommunityToolkit.Mvvm` package. 
:exclamation: It is important to install version 8.4.0 in the lab environments!
This will actually create the following `PackageReference` entry in the project file (we can manually add it alongside the other PackageReferences instead of following the steps above):

```xml
<PackageReference Include="CommunityToolkit.Mvvm" Version="8.4.0" />
```

### ObservableObject and ObservableProperty

In our `BooksPageViewModel` class, the implementation of `INotifyPropertyChanged` is quite verbose. Instead of directly implementing the `INotifyPropertyChanged` interface, we can use the `ObservableObject` class, which already implements this interface and contains several helper functions that make it easier to set properties and notify about changes.  
Additionally, we have the option to use the `ObservableProperty` attribute, which controls a code generator, allowing properties to be automatically created without manually writing boilerplate code, simply by declaring fields with the attribute. Let's make the following changes:

* Our `BooksPageViewModel` class should inherit from the `ObservableObject` class found in the `CommunityToolkit.Mvvm.ComponentModel` namespace.

* To use the source generator, the class must be marked as `partial` so that the generated code and the manual code can be placed in separate files.

* Instead of using full property syntax, we only need to keep the fields to which we apply the `ObservableProperty` attribute.

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

It is important that we remove the member variables (except for `_booksService`), the properties (since these are generated by the code generator), the `PropertyChanged` event, and the `SetProperty` method from the previous `BooksPageViewModel` solution. :exclamation: After the transformation, let's perform a build (e.g., Build/Build Solution menu): without this, the compilation errors won't be resolved, and Visual Studio will report many errors in the code. This is logical because the data-bound properties are generated by the code generator only during the build (in a "hidden" file).

We can check what code has been generated by navigating to the `Genres` property using ++F12++ (in the XAML file, place the cursor on `ViewModel.Genres` in the `ItemsSource` data binding).

!!! tip "ObservableProperty attribute on property"
    The `ObservableProperty` attribute can also be applied to properties instead of fields with the help of a [new C# language feature](https://devblogs.microsoft.com/dotnet/announcing-the-dotnet-community-toolkit-840/#partial-properties-support-for-the-mvvm-toolkit-🎉), but we would need to use a preview version of C# for this, so we will skip this for now this year.

**Try it out!**

We observe that the books load, but when selecting a genre, the books do not reload.  
Yes, that's because, earlier, we called the `LoadBooks` method when the `SelectedGenre` changed (which the generated code doesn't do).

We have three options:

1. We revert the `SelectedGenre` property to a non-generated version so we can define the setter.
2. We subscribe to the ViewModel `PropertyChanged` event in the constructor and call the `LoadBooks` method in the event handler when the `SelectedGenre` property changes.
3. We use the partial methods generated by the code generator, which will allow us to extend the behavior of the setters.

Option 3 seems to be the easiest, but it requires knowing how partial methods work (which we haven't covered in this course yet).  
Partial methods are methods whose declaration and definition are located in different files (associated with the same partial class), and which are automatically linked by the compiler. Moreover, partial methods don't have to be implemented by us.  
In our case, the code generator declares them, invokes them in the setters, and we can implement them in the `BooksPageViewModel` class.

Let's implement the `OnSelectedGenreChanged(string value)` partial method, where we call the `LoadBooks` method.

```csharp title="BooksPageViewModel.cs"
partial void OnSelectedGenreChanged(string value) => LoadBooks();
```

We have nothing more to do, the generated code now calls this method.

**Try it out!**

Now, when selecting a genre, the books reload properly.

## Task 3 - Command

When designing user interfaces, we have two tasks:

* **Displaying data** on the interface. This task was elegantly solved using data binding in our MVVM-based solution.
* Handling **user interactions/commands**. In our original solution, this was handled using event handlers, but we later "elegantly" removed all of them (which is why the `Clear` button no longer works). In the following, we will explore how we can implement a solution for this using the MVVM pattern (spoiler: binding commands or actions defined in the ViewModel to the View).

The ViewModel typically publishes the actions that can be performed on it to the View. This can be done through public methods or by using objects that implement the `ICommand` interface.

!!! tip "ICommand"
    The advantage of `ICommand` is that it encapsulates the operation and its execution state in one object, and it can even publish an event when the execution state changes.

    ```csharp
    public interface ICommand
    {
        event EventHandler? CanExecuteChanged;
        bool CanExecute(object? parameter);
        void Execute(object? parameter);
    }
    ```
    
    This mechanism is also used by the `Button` control, to whose `Command` property can be assigned commands defined in the ViewModel.

    The most important for us among the operations defined in `ICommand` is `Execute`, which is called when the command is executed. With `CanExecute`, the interface can query the command to check if the command can be executed at a given moment (for example, the button will be enabled/disabled accordingly). The `CanExecuteChanged` event, as the name suggests, is used to notify the interface that the "CanExecute" state of the command has changed, and the interface needs to update the enabled/disabled state.

### Using ICommand

Let's create an `ICommand` type property in the `BooksPageViewModel` class, which sets the selected genre to a "not set" state (this will be used for the Clear button).
For the implementation, we will use the `RelayCommand` class from the MVVM Toolkit, which is found in the `CommunityToolkit.Mvvm.Input` namespace.
We will create a new instance of it in the `BooksPageViewModel` constructor, where we define the execution of the command in a lambda expression (the `Execute` method of the command will call this lambda).

```csharp title="BooksPageViewModel.cs" hl_lines="5 8"
public BooksPageViewModel()
{
    // ...

    ClearFilterCommand = new RelayCommand(() => SelectedGenre = null);
}

public ICommand ClearFilterCommand { get; }
```

Let's bind the `ClearFilterCommand` property to the `Command` property of the _Clear_ button.

```xml title="BooksPage.xaml" hl_lines="2"
<Button Content="Clear"
        Command="{x:Bind ViewModel.ClearFilterCommand}" />
```

Notice how elegant the solution is. We worked in exactly the same way as before when displaying data during the lab: in the View, we used data binding to the property in the ViewModel (except now it was a command object).

**Try it out!** The _Clear_ button works, and the selected genre is cleared.

### ICommand executability state

What still doesn't work is disabling the button when no genre is selected.

To achieve this, in the constructor of the `RelayCommand` class, we should provide a `Func<bool>` function as the second parameter, which will indicate whether the command can be executed or not (the command's `CanExecute` method will call this lambda).

```csharp title="BooksPageViewModel.cs konstruktora" hl_lines="3"
ClearFilterCommand = new RelayCommand(
    execute: () => SelectedGenre = null,
    canExecute: () => SelectedGenre != null);
```

!!! note Parameter names
    The code above illustrates a common C# language feature: when calling a function, you can specify the **name** of a parameter before the `:`. This is rarely used because it requires more typing, but it can be considered when it greatly enhances the readability of the code.

However, the UI will only update — and thus the function specified in the `canExecute` parameter will only be called — if the `ICommand.CanExecuteChanged` event is triggered.

We can trigger this event through the `IRelayCommand` interface (which also implements `ICommand`). To do this, we need to call the `NotifyCanExecuteChanged()` method in the setter of the `SelectedGenre` property.

Let's change the property type to `IRelayCommand`. 

```csharp title="BooksPageViewModel.cs"
public IRelayCommand ClearFilterCommand { get; }
```

Call the `NotifyCanExecuteChanged()` method inside our already existing `OnSelectedGenreChanged` partial method.

```csharp title="BooksPageViewModel.cs" hl_lines="4"
partial void OnSelectedGenreChanged(string value)
{
    LoadBooks();
    ClearFilterCommand.NotifyCanExecuteChanged();
}
```

**Let's try it out!** Now the _Clear_ button becomes disabled when no genre is selected.

### Command with MVVMToolkit code generator

Instead of manually declaring and instantiating the `RelayCommand` property, we can use the `RelayCommand` attribute on a **method**, which automatically generates the necessary boilerplate code using the code generator.

* Delete the previously used `ClearFilterCommand` property and its instantiation in the constructor.

* Instead, create a new method named `ClearFilter`, and use the `RelayCommand` attribute to have the necessary command property automatically generated in the background.

    ```csharp title="BooksPageViewModel.cs"
    [RelayCommand]
    private void ClearFilter() => SelectedGenre = null;
    ```

* For the `CanExecute` logic, we can reference another method or property that defines whether the command can be executed.

    ```csharp title="BooksPageViewModel.cs" hl_lines="1 3"
    private bool IsClearFilterCommandEnabled => SelectedGenre != null;

    [RelayCommand(CanExecute = nameof(IsClearFilterCommandEnabled))]
    private void ClearFilter() => SelectedGenre = null;
    ```

**Let's try it out!** It should work just like before (only now the `ClearFilterCommand` property is generated by the source generator).

Moreover, `NotifyCanExecuteChanged` can also be triggered declaratively using attributes.
In our case, use `NotifyCanExecuteChangedFor` to link changes in `SelectedGenre` to the executability of the `ClearFilterCommand`.
This way, we can remove the event trigger from our `OnSelectedGenreChanged` partial method.

```csharp title="BooksPageViewModel.cs" hl_lines="2"
[ObservableProperty]
[NotifyCanExecuteChangedFor(nameof(ClearFilterCommand))]
private string _selectedGenre;

partial void OnSelectedGenreChanged(string value)
{
    LoadBooks();
}
```

**Let's try it out!** It should work just like before.

??? tip "If the Command pattern is not directly supported"
    Not all controls directly support the `Command` pattern. In such cases, we have two options:

    1. We can use `x:Bind` data binding, which is applicable not only to properties but also to event handlers. This allows us to bind even a ViewModel-based event handler to the control’s event. The downside is that this can break the MVVM pattern, as the ViewModel may become dependent on the View (e.g., due to event handler signatures and parameters).
   
    2. We can still use the Command pattern, but connect the desired event of the control to the ViewModel using a so-called Behavior. A Behavior is a class that allows us to modify a control’s behavior without changing the control’s code directly. In our case, we need to install the [Microsoft.Xaml.Behaviors](https://www.nuget.org/packages/Microsoft.Xaml.Behaviors.WinUI.Managed) package, which includes a prebuilt behavior that [converts events to command invocations](https://github.com/Microsoft/XamlBehaviors/wiki/InvokeCommandAction).

## Summary

During the lab, we transformed the initial project to follow the MVVM pattern, thus separating responsibilities between the View and the ViewModel:

* The ViewModel contains the state of the view and the actions that can be performed on it, while the View is responsible solely for presenting the user interface.
* There is a loose coupling between the ViewModel and the View through data binding, which makes the ViewModel easier to test and potentially reusable.
* The ViewModel does not depend on the View, so it can be easily rewritten or replaced without modifying the View.
* The ViewModel does not contain the full business logic (such as data access); instead, we placed that in a separate Service class.
