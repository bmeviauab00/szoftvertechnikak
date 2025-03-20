---
authors: tibitoth
---

# 3rd Homework - The design of the user interface

## Introduction

In this homework, you will develop a simple task management application where users can list, create, and modify tasks.

This independent task builds upon the content covered in XAML lectures. Its practical foundation is based on the [3rd lab – The design of the user interface](../../labor/3-felhasznaloi-felulet/index_eng.md) exercise.

Based on the above, the tasks in this independent exercise can be completed independently with the help of the short guidelines following the task descriptions (sometimes collapsed by default).

Objectives:

- Practicing the use of the XAML interface description language
- Practicing the use of basic controls (table, button, text box, lists)
- Handling user interactions with event-driven programming
- Displaying data in the UI using data binding

A description of the necessary development environment can be found [here](../fejlesztokornyezet/index_eng.md).

!!! warning "Environment for WinUI3 development"
    Additional components must be installed compared to previous labs. The [above page](../fejlesztokornyezet/index_eng.md) mentions that the ".NET desktop development" Visual Studio Workload is required. Additionally, at the bottom of the same page, there is a "WinUI support" section. Make sure to follow the listed steps! 

## Submission process

:exclamation:  [Although the basics are similar](../hf-folyamat/index_eng.md), there are important differences in the process and requirements compared to previous homework assignments. Therefore, be sure to read the following carefully.

- The general process remains the same as before. Use GitHub Classroom to create a repository for yourself. The invitation URL can be found in the Teams post about the homework. Make sure to use the correct invitation URL corresponding to this specific homework (each homework has a different URL). Clone the newly created repository, which will contain the expected structure for your solution. After completing the tasks, commit and push your solution.
- Among the cloned files, open and work in `TodoXaml.sln`.
- :exclamation: Some tasks require you to take **screenshots** of certain parts of your solution to prove that you created it yourself. **The required content of the screenshots is explicitly specified in each task.** Screenshots must be submitted as part of your solution and placed in the root directory of your repository (next to neptun.txt). This ensures that the screenshots are uploaded to GitHub along with the repository content. Since the repository is private, only instructors can see it. If the screenshot contains any content you do not wish to upload, you may blur it or cut it out.
- :exclamation: There is no substantive pre-checker for this assignment: while an automated check will run after each push, **it will only verify that neptun.txt is filled out. The actual evaluation will be conducted by the lab instructors after the submission deadline.**

## Restrictions

:warning: __MVVM Pattern - Do not use!__
    In this homework, do not use the MVVM pattern (not even in any of the later subtasks), and do not introduce a `ViewModel` class. MVVM will be the subject of a later homework assignment.

:warning: __Layout - Keep it simple__
    As in most cases, the basic page layout for this homework should be created using a `Grid`. However, when designing the internal sections, prioritize simplicity: where a `StackPanel` is sufficient, avoid using `Grid`.

## Task 1 - Model creation and test data

Within the project, create a `Models` folder in Visual Studio Solution Explorer and add the class and enum type shown in the diagram below. The `TodoItem` class will store the task data, and an enumerated type will be used for priority.

<figure markdown>
![Model](images/model.png)
</figure>

Both types should be public (add the `public` keyword before `class` and `enum`), otherwise, you may encounter an "Inconsistent accessibility" error during compilation.

The `MainPage` will display the list of tasks. For now, use in-memory test data, which should be created in `MainPage.xaml.cs`, located inside the `Views` folder. Here, introduce a `List<TodoItem>` property named `Todos` (which will later be bound to the `ListView` control on the UI using data binding). This list should contain `TodoItem` objects.

```csharp title="MainPage.xaml.cs"
public List<TodoItem> Todos { get; set; } = new()
{
    new TodoItem()
    {
        Id = 3,
        Title = "Add Neptun code to neptun.txt",
        Description = "NEPTUN",
        Priority = Priority.Normal,
        IsDone = false,
        Deadline = new DateTime(2024, 11, 08)
    },
    new TodoItem()
    {
        Id = 1,
        Title = "Buy milk",
        Description = "Should be lactose and gluten free!",
        Priority = Priority.Low,
        IsDone = true,
        Deadline = DateTimeOffset.Now + TimeSpan.FromDays(1)
    },
    new TodoItem()
    {
        Id = 2,
        Title = "Do the Computer Graphics homework",
        Description = "Ray tracing, make it shiny and gleamy! :)",
        Priority = Priority.High,
        IsDone = false,
        Deadline = new DateTime(2024, 11, 08)
    },
};
```

??? note "Explanation of the code above"
    The code snippet above combines several modern C# language features:

    * It uses an auto-implemented property (see Lab 2).  
    * It is initialized.  
    * The `new` keyword does not specify a type because the compiler can infer it (see Lab 2, "Target-typed new expressions").  
    * The elements of the collection are listed within `{}` (see Lab 2, "Collection initializer syntax").  

!!! note "`MainPage` class"
    In this homework, we work within the `MainPage` class, which inherits from the built-in `Page` class. The `Page` class facilitates navigation between pages within a window. Although this feature is not used in the current task, it is good to familiarize yourself with it. Since our application consists of a single page, the main window simply instantiates a `MainPage` object (you can check this in the `MainWindow.xaml` file).

## Task 2 - Page layout and list display

### Layout

In `MainPage.xaml`, create the user interface that will display the task list.

<figure markdown>
![MainPage](images/mainpage.png)
<figurecaption>Task management application with a list view</figurecaption>
</figure>

As shown in the above diagram, which displays three tasks, the task details should be displayed in a vertical list. Task priorities are indicated by colors. Completed tasks have a checkmark on the right side.

The interface elements should be structured as follows:

* Inside `MainPage`, use a `Grid` layout with two rows and two columns. The first column should have a fixed width (e.g., 300 px), while the second column should take up the remaining available space.
* In the first row of the first column, place a `CommandBar` control containing a title and a button. The following example provides guidance for this:

    ```xml
    <CommandBar VerticalContentAlignment="Center"
                Background="{ThemeResource AppBarBackgroundThemeBrush}"
                DefaultLabelPosition="Right">
        <CommandBar.Content>
            <TextBlock Margin="12,0,0,0"
                       Style="{ThemeResource SubtitleTextBlockStyle}"
                       Text="To-Dos" />
        </CommandBar.Content>

        <AppBarButton Icon="Add"
                      Label="Add" />
    </CommandBar>
    ```
    !!! note "Light/dark appearance"
        Depending on your Windows settings (light/dark mode), the interface may appear with light colors on a dark background. This is completely normal.By default, WinUI applications adapt to the operating system's theme settings, which is why this behavior occurs.

    !!! note "ThemeResource"
        The example uses `ThemeResource` values to set colors and styles that automatically adjust based on the application's theme. For instance, `AppBarBackgroundThemeBrush` will apply the appropriate background color depending on whether the theme is light or dark.

        For more details, refer to the [documentation](https://docs.microsoft.com/en-us/windows/uwp/design/style/color#theme-resources) and [WinUI 3 Gallery App Colors](winui3gallery://item/Colors).

If everything is set up correctly, when you run the application, the `CommandBar` should appear in the appropriate position.

### List display

In the cell below the `CommandBar`, add a `ListView` to display the list of tasks (Todos) with the following content.
The UI should be updated dynamically using data binding, ensuring that the elements displayed are bound to the previously defined Todos list. Each task should be displayed as follows:

* Task title
    * Use **SemiBold** font style.
    * Color based on priority:
        * High priority: A shade of red
        * Normal priority: Default foreground color.
        * Low priority: A shade of blue.
* Task completion indicator: a checkmark icon aligned to the right of the task title if the task is completed.
* Task description
* Task deadline displayed in `yyyy.MM.dd` format
* The `ListView` background should match the `CommandBar` to create a continuous left-aligned section.

??? tip "Binding elements in the list"
    Always consider whether you are binding to a single object or a list, and apply the appropriate binding technique! In this homework, the order of elements may differ from how they were covered in the lab sessions.

??? tip "Conditional formatting"
    You can use either a converter or an `x:Bind` function binding to set the title color dynamically based on priority.

    - Example of an `x:Bind` function binding:
            
        ```xml
        Foreground="{x:Bind local:MainPage.GetForeground(Priority)}"
        ```
        Here, `GetForeground` is a public static function within the `MainPage` class that returns the appropriate `Brush` object based on the `Priority` enumeration type. Normally, the function does not need to be static, but since it is used inside a `DataTemplate`, the context of `x:Bind` will be the list item rather than the page instance.

    - Example of using a converter 

        To use a converter, create a new class inside a `Converters` folder that implements the `IValueConverter` interface.

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

        Instantiate the converter within the resources of `MainPage`.

        ```xml
        xmlns:c="using:TodoXaml.Converters"

        <Page.Resources>
            <c:PriorityBrushConverter x:Key="PriorityBrushConverter" />
        </Page.Resources>
        ```

        Use the converter as a static resource in data binding:

        ```xml
        Foreground="{x:Bind Priority, Converter={StaticResource PriorityBrushConverter}}"
        ```

    To instantiate brushes, use the SolidColorBrush class, or alternatively, use built-in brushes in C# code (as shown above with ThemeResource).

    ```csharp
    new SolidColorBrush(Colors.Red);

    (Brush)App.Current.Resources["ApplicationForegroundThemeBrush"]
    ```

??? tip "Bold Font Style"
    Font characteristics are determined by properties with names starting with "Font...": `FontFamily`, `FontSize`, `FontStyle`, `FontStretch` and `FontWeight`.

??? tip "Checkmark icon visibility"
    Use a `SymbolIcon` for the checkmark and set its `Symbol` property to `Accept`.

    The checkmark icon should be displayed based on a boolean value converted to a `Visibility` type. While a converter could be used, this conversion is so common that **`x:Bind` automatically converts a `bool` to `Visibility`**.

??? tip "Aligning the checkmark icon"
    The task title and checkmark icon should be in the same row (one aligned left, the other right). Tip: You can use a single-cell `Grid`. In a `Grid`, multiple controls can be placed in the same cell, while each control's alignment is individually controlled. This technique was used in Lab 2 to display names and ages in a `ListView` `DataTemplate`.

??? tip "Formatting dates"
    The deadline date can be formatted using a converter or an `x:Bind` function binding. One approach is binding `DateTime.ToString` with parameters:

    ```xml
    Text="{x:Bind Deadline.ToString('yyyy.MM.dd', x:Null)}"
    ```
    
    The `x:Null` is required because the `ToString` function expects a second parameter, which can be `null` in this case.

??? tip "Spacing between list items"
    The provided screenshot example shows that there is vertical spacing between list items, improving readability. By default, this spacing is not present. Since a DataTemplate will already be used for displaying items, a small adjustment (e.g., setting Margin/Padding) can create adequate spacing between list items for better readability. 

!!! example "Task 2 - Submission requirement"
    Insert a **screenshot** of the application where one task in the list has either its **title or description set to your NEPTUN code!** (`f2.png`)

## Task 3 - Adding a new task

On the right side of the grid, in row 1, display the text "To-Do item" with:

- A font size of 25,
- Horizontally aligned to the left,
- Vertically centered,
- 20 pixels of left padding.

Clicking the __Add__ button should display a form in row 2, allowing the user to add a new task.

The form should look like this:

<figure markdown>
![New Todo](images/newtodo.png)
<figurecaption>To-Do Item Editor Form</figurecaption>
</figure>

The form should contain the following elements in a vertical layout:

* **Title**: Text input field
* **Description**: Multi-line text input field (accepts line breaks with Enter, set AcceptsReturn="True").
* **Deadline**: Date picker (`DatePicker`) (Note: This is why the model uses the `DateTimeOffset` type.)
* **Priority**: Dropdown list (`ComboBox`) containing values from the `Priority` enum.
* **Completion Status**: Checkbox (`CheckBox`).
* **Save**: `Button` with built-in accent style (`Style="{StaticResource AccentButtonStyle}"`).

You do not need to create a custom control (e.g., `UserControl`) for this form. Simply use a layout panel that best fits the task.

Additional guidance on implementing some of the requirements is available in the collapsible sections below.

Functional requirements:

* The form should only be visible after clicking the __Add__ button and should disappear once the task is saved.
* Clicking the __Save__ button should add the entered data to the list and hide the form.
* Clicking the __Add__ button should clear the currently selected item in the list (`SelectedItem`).
* Optional: Make the form scrollable if its content does not fit on the screen (use `ScrollViewer`).
  
Form layout

* Use the `Header` property in `TextBox`, `ComboBox`, and `DatePicker` controls to define their labels instead of adding separate `TextBlock` elements.
* Ensure sufficient spacing between form elements. It should be about 15 pixels (use the `StackPanel` `Spacing` property for easy control).
* Add a visible border to the form: This is not for styling but to clearly show where the form is placed (alternatively, a background color change could be used.). Set `BorderThickness="1"` and `BorderBrush="LightGray"` for clear visibility.
* Apply margins: Left, right, and bottom margins should be 8 px. Top margin should be 0 px. This ensures consistent spacing between the form and its container, even when the window is resized.
* Maintain spacing inside the form: Add 15 px padding at the top and bottom. Add 10 px padding on the left and right. Instead of setting margins individually for each control, adjust the container’s **padding** to maintain spacing between the form’s border and its contents.
* Ensure the form and textboxes resize with the window, as illustrated below:
    
    ??? note "Illustration of form behavior and expected sizes"
        ![Resizing](images/newtodo-resizing.gif)
        ![Size annotations](images/newtodo-annotated.png)

??? success "Steps to implement the save functionality"
    1. Store form data in a new `TodoItem` object bound to UI elements using two-way data binding. Introduce a property named `EditedTodo`. Then two possible approaches are working:
        1. EditedTodo is initially null. When the user starts adding a new task, create a new EditedTodo object to hold the task data. On save, add this object to the list. Every time a new task is added, EditedTodo points to a new object.
        2. Use a shared EditedTodo object for all task entries. Initialize it when the page is created. When a user adds a task (or after saving), reset EditedTodo with default values. On save, create a copy of EditedTodo and add it to the list.
    2. The following guidance focuses on the first approach, but you should try implementing it independently first.
    3. Initialize EditedTodo as null and instantiate it when the __Add__ button is clicked.
    4. On save, add the edited task object to the `Todos` list. Ensure that the UI updates when the list contents change (this may require modifying how data is stored).
    5. After saving, reset the EditedTodo property to null. This ensures that the form fields are empty when adding a new task instead of retaining the previous task’s data. Test your solution! Does resetting EditedTodo alone ensure that the UI updates? Consider what’s needed for bound controls to refresh when EditedTodo changes.
        (Hint: The concern here is not that properties of the `TodoItem` change, but that MainPage’s `EditedTodo` property itself is updated. What interface needs to be implemented in the containing class?)

??? success "Controlling form visibility"
    
    If implemented correctly, the form should be visible only when EditedTodo is not null (consider whether this holds true). Based on this, several approaches can be used, but the simplest is property-based binding with `x:Bind`:

    1. Introduce a new boolean property in `MainPage` (e.g., `IsFormVisible`).
    2.

    2. Ez pontosan akkor legyen igaz, amikor az `EditedTodo` nem null. Ennek a karbantartása a mi feladatunk, pl. az `EditedTodo` setterében.
    3. Ezt a tulajdonságot lehet adatkötni az űrlapunkat reprezentáló konténer láthatóságához (`Visibility` tulajdonság). Igaz, hogy a típusuk nem egyezik, de WinUI alatt van automatikus konverzió a `bool` és `Visibility` típusok között.
    4. Gondoljunk arra is, hogy amikor a forrás tulajdonság (`IsFormVisible`) változik, a hozzá kötött cél tulajdonságot (vezérlő láthatóság) esetünkben mindig frissíteni kell. Mire van ehhez szükség? (Tipp: a **tulajdonságot közvetlenül tartalmazó osztálynak** - gondoljuk át, esetünkben ez melyik osztály - egy megfelelő interfészt meg kell valósítania stb.)
        
    ??? "Alternatív lehetőségek a megoldásra"
        
        Egyéb alternatívák alkalmazása is lehetséges (csak érdekességképpen, de ne ezeket alkalmazzuk a megoldás során):
        
        1. Függvény alapú adatkötés megvalósítása, de esetünkben ez körülményesebb lenne.
            * A `x:Bind` alapon kötött függvénynek a megjelenítés és elrejtéshez az `EditedTodo` property `null` vagy nem `null` értékét kell konvertálni `Visibility`-re.
            * Az adatkötés során a `FallbackValue='Collapsed'` beállítást is használnunk kell, mert sajnos az `x:Bind` alapértelmezetten nem hívja meg a függvényt, ha az érték `null`.
            * A kötött függvénynek paraméterben meg kell adni azt a tulajdonságot, melynek változása esetén az adatkötést frissíteni kell, illetve a tulajdonságra vonatkozó változásértesítést itt is meg kell valósítani.
        2. Konverter alkalmazása.

??? tip "Prioritások listája"
    A `ComboBox`-ban a `Priority` felsorolt típus értékeit jelenítsük meg. Ehhez használhatjuk a `Enum.GetValues` függvényt, amihez készítsünk egy tulajdonságot a `MainPage.xaml.cs`-ben.

    ```csharp
    public List<Priority> Priorities { get; } = Enum.GetValues(typeof(Priority)).Cast<Priority>().ToList();
    ```

    A `ComboBox` `ItemsSource` tulajdonságához kössük az `Priorities` listát.

    ```xml
    <ComboBox ItemsSource="{x:Bind Priorities}" />
    ```

    A fenti példában az `ItemsSource` csak azt határozza meg, hogy milyen elemek jelenjenek meg a `ComboBox` listájában. De ez semmit nem mond arról, hogy a `ComboBox` kiválasztott elemét mihez kell kötni. Ehhez szükség van még egy adatkötésre. Laboron ez nem szerepelt, előadásanyagban pl. a `SelectedItem`-re érdemes rákeresni (minden előfordulását érdemes megnézni).

??? tip "Néhány fontosabb vezérlő tulajdonság"
    * A `CheckBox` vezérlő `IsChecked` (és nem a `Checked`!) tulajdonsága. A mellette jobbra megjelenő szöveg a `Content` tulajdonságával adható meg.
    * `DatePicker` vezérlő `Date` tulajdonsága

??? tip "Furcsa, adatkötéshez kapcsolódó NullReferenceException"
    Ha egy "megfoghatatlannak" tűnő `NullReferenceException`-t kapsz az új elem felvételekor, akkor ellenőrizd, hogy a `ComboBox` esetében a `SelectedValue`-t kötötted-e esetleg a `SelectedItem` helyett (a `SelectedItem` használandó).


!!! example "3. feladat BEADANDÓ"
    Illessz be egy képernyőképet az alkalmazásról, ahol az új teendő felvétele látható még mentés előtt! (`f3.1.png`)

    Illessz be egy képernyőképet az alkalmazásról, ahol az előző képen lévő teendő a listába került és eltűnt az űrlap! (`f3.2.png`)

!!! warning "Fontos kritériumok"
    Az alábbiakban megadunk néhány fontos kritériumot, melyek mindenképpen feltételei a házi feladat elfogadásának:

    * A feladatkiírás kikötötte, hogy a listában és az űrlapon levő vezélők esetében is adatkötéssel kell dolgozni. Olyan megoldás nem elfogadható, mely ezt megkerüli. Így például nem lehet a code behind fájlban (`MainPage.xaml.cs`) olyan kód, mely az űrlapokon levő vezérlők tulajdonságait (pl. TextBox Text tulajdonsága) közvetlenül kérdezi le vagy állítja.
    * Az előző pont alól két kivétel van: 
        * A `ListView` `SelectedItem` tulajdonsága közvetlenül állítandó.
        * Az űrlap láthatóságának szabályozása adatkötés nélkül is elfogadható (bár nem a legszebb megoldás, és a gyakorlás kedvéért is érdemesebb adatkötéssel dolgozni).
    * Amikor egy új to-do elem felvétele történik, és korábban már történt egy ilyen elem felvétele, akkor a korábbi elem adatai NEM lehetnek benne az űrlap vezérlőiben.

Opcionális gyakorló feladatok

??? tip "Opcionális gyakorló feladat 1 - Űrlap görgethetővé tétele"
    Ehhez mindössze be kell csomagolni az űrlapot egy `ScrollViewer` vezérlőbe (illetve ne feledkezzünk meg arról, hogy így már ez lesz a legkülső elem a grid cellában, így rá vonatkozóan kell megadni a gridbeli pozíciót). Ha ezt megvalósítod, benne lehet a beadott megoldásodban.

??? tip "Opcionális gyakorló feladat 2 - Fix szélességű űrlap"
    Jelen megoldásunkban az űrlap automatikusan méreteződik az ablakkal. Jó gyakorlási lehetőség ennek olyan átalakítása, mely esetben az űrlap fix szélességű (pl. 500 pixel) és olyan magasságú, mint a benne levő elemek össz magassága. Ha az űrlap esetén StackPanellel dolgoztál, ehhez mindössze három attribútumot kell felvenni vagy megváltoztatni. Ezt a viselkedést az alábbi animált kép illusztrálja. Lényeges, hogy beadni a korábbi megoldást kell, nem ez az opcionális feladatban leírt viselkedést!
    ![Fix méretű űrlap](images/newtodo-resizing-optional.gif)

## 4. Opcionális feladat 3 IMSc pontért - Teendő szerkesztése

Valósítsd meg a teendők szerkesztésének lehetőségét az alábbiak szerint:

* A felületen a teendők listában az elemre kattintva, az adott teendő adatai a szerkesztő felületen (a korábbi feladatban bevezetett űrlapon) kerüljenek megjelenítésre, ahol azok így szerkeszthetőek és menthetőek lesznek.
* A mentés során a listában a szerkesztett teendő adatai frissüljenek, és az űrlap tűnjön el.

??? success "Megoldási tippek"
    * Érdemes karbantartani a teendők egyedi azonosítóját a beszúrás során, hogy meg tudjuk különböztetni mentéskor, szerkesztés vagy beszúrás esete áll fenn. Pl. beszúrás esetén használhatjuk a -1 értéket, melyet mentés során lecserélünk az eddig használtaknál eggyel nagyobb számra. De tegyük fel, hogy a -1 is egy olyan érték, mellyel rendelkezhet egy érvényes to-do objektum. Mit lehet ekkor tenni? A `TodoItem` osztályban az `Id` típusát alakítsuk át `int?`-re. A `?`-lel az érték típusok (`int`, `bool`, `char`, `enum`, `struct` stb.) is felvehetnek `null` értéket. Ezeket nullable érték típusoknak (nullable value types) nevezzük. Ezek a `Nullable<T>` .NET struktúrára képződnek le fordítás során, melyek tartalmazzák az eredeti változót, illetve egy flag-et, mely jelzi, ki van-e töltve az érték, vagy sem. Bővebben [itt](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/nullable-value-types) és [itt](https://learn.microsoft.com/en-us/dotnet/api/system.nullable-1) lehet ezekről olvasni. Alkalmazzuk ezt a megoldás során.
    * A lista elemre kattintáshoz a `ListView` `ItemClick` eseményét célszerű használni, miután bekapcsoltuk a `IsItemClickEnabled` tulajdonságot a `ListView`-n. Az újonnan kiválasztott listaelem kapcsán információt az eseménykezelő `ItemClickEventArgs` paraméterében kapunk. 
    * A szerkesztendő adatok kezelésére több megoldás is elképzelhető, ezekből az egyik: 
        * Az `EditedTodo` property-t állítsuk be a szerkesztett teendőre a kattintáskor.
        * A mentés gombra kattintva a `Todos` listában cseréljük le a szerkesztett teendőt az `EditedTodo` értékére. Valójában ugyanazt az elemet cseréljük le önmagára, de a `ListView` így frissülni tud.

!!! example "4. iMSc feladat BEADANDÓ"
    Illessz be egy képernyőképet az alkalmazásról, ahol egy meglévő elemre kattintva kitöltődik az űrlap! (`f4.imsc.1.png`)

    Illessz be egy képernyőképet az alkalmazásról, ahol az előző képen kiválasztott teendő mentés hatására frissül a listában! (`f4.imsc.2.png`)

## Beadás

Ellenőrzőlista ismétlésképpen:

--8<-- "docs/hazi/beadas-ellenorzes/index.md:3"