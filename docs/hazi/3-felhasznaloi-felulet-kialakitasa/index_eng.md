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
    2. Set `IsFormVisible` to true whenever EditedTodo is not null. This must be maintained manually, e.g., in the EditedTodo setter.
    3. Bind this property to the `Visibility` of the container representing the form. Although `Visibility` is not a boolean, WinUI automatically converts `bool` to `Visibility`.
    4. Ensure that when the source property (`IsFormVisible`) changes, the bound UI property (control visibility) is updated. (Hint: The class containing `IsFormVisible` must implement an appropriate interface to notify about changes.)
        
    ??? "Alternative Approaches"

        Other solutions could be used, but stick to the method above for this assignment:

        1. Function-based binding using x:Bind, but this would be more complex:
            * The function should convert `EditedTodo` being null/non-null to `Visibility`.
            * FallbackValue='Collapsed' must be used since `x:Bind` does not call functions when bound properties are null by default.
            * The function needs to take a parameter indicating which property should trigger updates, and property change notifications must be handled manually.
        2. Using a converter to transform `bool` to `Visibility`.

??? tip "Priority list"
    The `ComboBox` should display all values of the Priority enum. To achieve this, use `Enum.GetValues` and define a property in `MainPage.xaml.cs`:

    ```csharp
    public List<Priority> Priorities { get; } = Enum.GetValues(typeof(Priority)).Cast<Priority>().ToList();
    ```

    Bind this list to the `ItemsSource` of the `ComboBox`:

    ```xml
    <ComboBox ItemsSource="{x:Bind Priorities}" />
    ```

    However, this only defines the list of available values. To bind the selected value, another data binding must be added. (Check lecture materials for `SelectedItem`. It's worth reviewing all mentions of it.)

??? tip "Key Control Properties"
    * `CheckBox`: Use `IsChecked` (not `Checked!`) to store the checked state. The accompanying label text can be set via the `Content` property.
    * `DatePicker`: The selected date is stored in the `Date` property.

??? tip "Strange NullReferenceException in data binding"
    If you encounter an unexpected `NullReferenceException` when adding a new item, check whether you accidentally bound `ComboBox` `SelectedValue` instead of `SelectedItem`. Always use `SelectedItem` for binding in this case.

!!! example "Task 3 - Submission requirement"
    Insert a **screenshot** of the application where the new task entry form is visible before saving! (`f3.1.png`)
    Insert a **screenshot** of the application where the previously entered task appears in the list and the form has disappeared! (`f3.2.png`)

!!! warning "Important criteria"
    The following criteria are mandatory for the homework to be accepted:

    * The task description explicitly requires that both the list and form controls must use data binding. Any solution that bypasses data binding is not acceptable. For example, the code-behind file (`MainPage.xaml.cs`) must NOT contain code that directly reads or modifies form control properties (e.g., `TextBox.Text`).
    * Two exceptions to this rule: 
        * The `ListView.SelectedItem` property should be set directly.  
        * Controlling form visibility without data binding is acceptable (though using data binding is recommended for better practice).  
    * If a new task is added after a previous task, the previous task's data must NOT remain in the form controls.

Optional Practice Tasks

??? tip "Optional Practice Task 1 - Making the Form Scrollable"
    Wrap the form inside a ScrollViewer control. Note: Since the ScrollViewer will now be the outermost element in the grid cell, its grid position must be specified.If implemented, this can be included in the submitted solution.

??? tip "Optional Practice Task 2 - Fixed-Width Form"
    In the current solution, the form resizes automatically with the window. A good practice task is to modify the form so that it has a fixed width (e.g., 500 pixels) and its height matches the total height of its contents. If you used a StackPanel for the form layout, only three attributes need to be added or modified. The animation below illustrates this behavior. Note: The submitted solution must follow the original requirement (auto-resizing form), not the behavior from this optional task.
    ![Fixed-size form](images/newtodo-resizing-optional.gif)

## Submission

Checklist Reminder

--8<-- "docs/hazi/beadas-ellenorzes/index_eng.md:3"