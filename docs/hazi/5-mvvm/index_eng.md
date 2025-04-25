---
authors: bzolka
---

# 5th Homework - MVVM

## Introduction

In this homework, you will refactor the person registration application implemented in XAML Lab 3 so that it follows the MVVM pattern, and you will also get introduced to using the MVVM Toolkit.

This independent task is based on the MVVM topic covered at the end of the WinUI lecture series. Its practical foundation is provided by [Lab 5 – MVVM](../../labor/5-mvvm/index_eng.md).

By reviewing the related lecture material, the tasks in this independent exercise can be completed on your own using the brief guidance provided after each task description (some sections may be collapsed by default).

Goals of this exercise:
* Practice using the MVVM pattern
* Learn to use NuGet references
* Get familiar with the MVVM Toolkit
* Practice advanced XAML techniques

Information about the required development environment is available [here](../fejlesztokornyezet/index_eng.md), and it is the same as for the 3rd Homework.

## Submission process

- The submission process is the same as in previous assignments. Use GitHub Classroom to create a personal repository. The invitation URL can be found on Teams or on the AUT portal.
It is important to use the correct invitation URL for this specific assignment (each homework has a different URL). Clone the repository that gets created — it will include the expected folder structure for your solution. After completing the tasks, commit and push your work.
- Open and work in the `HelloXaml.sln` solution file from the cloned folder.
- :exclamation: Many tasks require you to take **screenshots** of parts of your solution, which serve as proof that you created the solution yourself.
**The required content of each screenshot is specified clearly within the task descriptions.** Save the screenshots as part of your submission — place them in the root folder of your repository (next to neptun.txt). These screenshots will be uploaded to GitHub along with the rest of your project.
Since the repository is private, only the instructors can access it. If a screenshot includes anything you don’t want to upload, you may blur or crop that part before submission.

- :exclamation: This assignment does not include a functional pre-checker: Although a check will run after each push, it only verifies whether neptun.txt is filled out. The actual evaluation will be performed by the lab instructors after the deadline.

## Constraints

:warning: __Use of the MVVM Pattern is Mandatory!__
    This homework is focused on practicing the MVVM pattern, so applying the MVVM architecture is required for all tasks. Any deviation from this requirement will result in rejection of the submission during evaluation.

## Task 0 – Reviewing the initial state

The starting state is essentially the same as the final state of [Lab 3 – The design of the user interface](../../labor/3-felhasznaloi-felulet/index_eng.md). That is, an application where users can enter personal data into a list. Compared to the lab's final state, there's one small change. In the lab, the entire UI was defined in `MainWindow.xaml` (and the corresponding code-behind file). In this initial solution, that code has been moved to the `PersonListPage.xaml` (and its code-behind file) located in the Views folder. `PersonListPage` is not a `Window` but rather a class derived from `Page` (check this in the code-behind file!). Otherwise, nothing else has changed. As its name implies, a `Page` represents a "page" in an application: it cannot display itself alone — it must be placed inside a window. The advantage of using pages is that it allows navigation between different views (`Page` objects) inside the same window. We will not use navigation in this assignment — we will have only one page. The sole purpose of using a `Page` here is to demonstrate that in an MVVM architecture, views can be implemented using not only `Window` objects, but also `Page` objects.

Since everything was moved from `MainWindow` to `PersonListPage`, the `MainWindow.xaml` now contains nothing but an instantiation of the `PersonListPage` object:

``` csharp
<views:PersonListPage/>
```

Check the code to confirm that this is indeed the case!

## MainWindow title

:exclamation: The title of the main window must be the text "MVVM - [YOUR NEPTUN CODE]". For example, if your Neptun code is ABCDEF, the full title should be: MVVM - ABCDEF. To do this, set the `Title` property in the `MainWindow.xaml` file.

## Task 1 – Using the MVVM Toolkit

In the existing application, the `Person` class located in the `Models` folder already implements the `INotifyPropertyChanged` interface (also known as INPC). This means it exposes a `PropertyChanged` event, and within the set methods of both `Name` and `Age`, it raises the `PropertyChanged` event to notify about changes. (Examine this carefully in the `Person.cs` file.)

As a warm-up or refresher — after reviewing the code (`PersonListPage.xaml` and `PersonListPage.xaml.cs`) thoroughly and running the application — try to answer this question for yourself: Why was implementing `INotifyPropertyChanged` necessary in this application?

??? "The Answer (Review)"
    In the application, inside `PersonListPage.xaml`, the `Text` properties of the `TextBox` controls (the targets of the bindings) are bound to the `Name` and `Age` properties of the `NewPerson` object (a `Person` instance defined in the code-behind — these are the sources of the bindings). If you look at the code, you'll see that `NewPerson.Name` and `NewPerson.Age` are indeed **modified programmatically in the code**. For the UI controls to reflect these changes (and stay in sync with the data source), they must be notified when the source properties (`Name`, `Age`) change. This is why the class that contains those properties — `Person` — needs to implement the `INotifyPropertyChanged` interface and raise the `PropertyChanged` event properly whenever those properties are updated.

Run the application and check that pressing the '+' and '–' buttons updates `NewPerson.Age` — and that these changes are reflected in the age display `TextBox`.

You'll notice that the implementation of `INotifyPropertyChanged` in the `Person` class is quite verbose.
Review the lecture slides, where slides illustrate the main alternatives for implementing `INotifyPropertyChanged`. The most concise solution is using the MVVM Toolkit — in the next step, we will refactor this verbose, manual INPC implementation to use the MVVM Toolkit.

### Task 1/a - Adding MVVM Toolkit via NuGet Reference

The first step is to add a NuGet reference to the MVVM Toolkit, so it can be used within the project.

**Task**: Add a NuGet reference to the package "CommunityToolkit.Mvvm" in your project. This Visual Studio documentation explains how to add a NuGet package using the [NuGet Package Manager](https://learn.microsoft.com/en-us/nuget/quickstart/install-and-use-a-package-in-visual-studio#nuget-package-manager).
The link jumps directly to the "NuGet Package Manager" section — just follow the four steps described there.
(Just note that instead of installing "Newtonsoft.Json", you should search for and install "CommunityToolkit.Mvvm".)

Now that we’ve added this NuGet reference to our project, during the next build (which includes a NuGet restore step), the NuGet package will be downloaded, and its contents — the DLLs — will be extracted into the output folder. These DLLs now become an integral part of the application (a NuGet package is essentially a zip archive). It’s important to mention that:

- Neither the NuGet .nupkg file nor the extracted DLLs are included in Git.
- The .gitignore file at the root of the solution filters them out.
- This is the core idea behind NuGet: the repository remains small, because the project file only contains references to the NuGet packages.
- When someone clones the solution and builds it for the first time, the referenced NuGet packages are automatically downloaded from the online NuGet sources.

:warning: Understanding the concepts related to NuGet is important — they are an essential part of the curriculum!

A NuGet reference is essentially just a single line in the `.csproj` project file. In Solution Explorer, click on the "HelloXaml" project node, open the `.csproj` file, and check that the following line is present
(the version number may differ):

``` csharp
    <PackageReference Include="CommunityToolkit.Mvvm" Version="8.2.2" />
```

You can also verify our NuGet reference without opening the `.csproj` file:
In Solution Explorer, expand the "HelloXaml"/"Dependencies"/"Packages" node — if everything is correct, you should see a "CommunityToolkit.Mvvm (version)" node under it.

### Task 1/b – INPC implementation using MVVM Toolkit

Now that we can use the classes, interfaces, and attributes provided by the MVVM Toolkit NuGet package,
we can switch to an MVVM Toolkit-based implementation of INotifyPropertyChanged (INPC).

* Comment out the entire existing Person class.
* Then, directly above the commented-out code, reimplement the class using MVVM Toolkit-based INPC.
    * Refer to the slide explaining INPC from the lecture.
    * The class must be declared as `partial` (this means the class can be defined across multiple files).
    * Inherit from `ObservableObject` from the Toolkit — this base class already implements `INotifyPropertyChanged`, so you don’t have to.
    * Instead of creating regular properties `Name` and `Age`, define backing fields `name` and `age` and annotate them with `[ObservableProperty]` attribute.

Done!

??? note "Verifying the Solution"
    ``` csharp
    public partial class Person : ObservableObject
    {
        [ObservableProperty]
        private string name;

        [ObservableProperty]
        private int age;
    }
    ```

After compilation, this code essentially results in the same solution as the previous, much more verbose version that is now commented out. In other words (even if we don't immediately see it), `Name` and `Age` properties are being created, along with the appropriate `PropertyChanged` event invocations. How is this possible?

* First, the `ObservableObject` base class already implements the `INotifyPropertyChanged` interface,
so it includes the `PropertyChanged` event, which our class inherits through subclassing.
* During compilation, the MVVM Toolkit's source generator runs.
For every field marked with the `[ObservableProperty]` attribute, it generates a property in the class with the same name but starting with an uppercase letter. The set accessor of the generated property includes the logic to raise the `PropertyChanged` event with the appropriate conditions and parameters. So we don’t have to write this boilerplate code ourselves.
* The question is: where is this generated code? In another partial part of our class. After compiling, right-click on the class name `Person` in Visual Studio and select "Go to Definition". In the bottom panel, you’ll see two entries: one pointing to your original source code,
and the other (labeled "public class Person") pointing to the generated partial class. Double-clicking that entry shows the generated code, which is quite verbose. But what matters is that this is where the `Name` and `Age` properties are defined, including the call to `OnPropertyChanged`.

:exclamation: The source generator always outputs code into a separate "partial" class to keep user-written and generated code separate. Partial classes are commonly used to organize manually written and automatically generated code into separate files.

Since much less code needs to be written, in practice we typically use the MVVM Toolkit-based solution
(but it's also important to understand the manual implementation, as it helps you understand what’s happening behind the scenes).

!!! example "TO BE SUBMITTED"
    Take a screenshot named f1b.png with the following setup:

    - Start the application. If necessary, resize the window so it doesn’t take up too much space.

    - In the background, Visual Studio should be open with the `Person.cs` file visible.

## Task 2 – Transitioning to an MVVM-based solution

In the previous step, although we used the MVVM Toolkit, we had not yet transitioned to a full MVVM-based solution — we only used the toolkit to simplify the implementation of INotifyPropertyChanged.

Now, we will refactor our application's architecture to align with the principles of the MVVM pattern.
To keep implementation simple, we will continue to use the MVVM Toolkit.

**Task**: Review the related lecture materials:

* Understand the core concepts of the MVVM pattern.
* The complete source code of an example is available in the [linked GitHub Repository](https://github.com/bmeviauab00/eloadas-demok), under the "04-05 WinUI\DancerProfiles" folder
(look for the "RelaxedMVVM" and "StrictMVVM" examples). These will help you understand the pattern and assist with later tasks.

What does the MVVM pattern mean for our example?

* The Model class is the existing `Person` class in the `Models` folder — it represents a person's data. It contains NO UI logic and is completely independent from any form of presentation.
* Currently, all UI-related declarations and logic are in `PersonListPage`.
:exclamation: We will now split `PersonListPage` into two parts:
    * `PersonListPage.xaml` and its code-behind will become the View.
    * We'll introduce a ViewModel called `PersonListPageViewModel`.
        * :exclamation: It is essential that all display logic currently in the code-behind of `PersonListPage` be moved into `PersonListPageViewModel`.
        **The core idea of MVVM is that the View should contain only the layout, and the ViewModel should contain all the UI logic.**
* Another cornerstone of the MVVM pattern: The View holds a reference to its ViewModel, typically via a property.
    * In our case, this means `PersonListPage` must have a property of type `PersonListPageViewModel`.
    * :exclamation: This is crucial because it allows the `PersonListPage.xaml` file to bind to properties and event handlers defined in the ViewModel!
* The `PersonListPageViewModel` will work with the model and handle user interactions (event handlers).
* Since we are using the Relaxed MVVM pattern (not Strict MVVM), we do not need to introduce a wrapper `PersonViewModel` around the `Person` model class.

Task: Refactor the existing logic to follow the MVVM (Model-View-ViewModel) pattern as described above. Move the `PersonListPageViewModel` class into a newly created `ViewModels` folder. Try to figure out the solution yourself based on the provided hints! Here's a helpful tip in advance (since this part is a bit trickier): for events, you can bind event handler methods using data binding — see the the lecture. (After the refactor, event handlers must only be specified via bindings.) Also important: You can only bind to public properties or methods, so keep that in mind when refactoring!

??? "Tips / solution validation"
    1. From `PersonListPage.xaml.cs`, you should move almost everything (except the `this.InitializeComponent()` call in the constructor) into the new `PersonListPageViewModel` class. These are part of the UI logic, which belongs in the ViewModel.
    2. The `PersonListPageViewModel` class must be public.
    3. In the `PersonListPage.xaml.cs` code-behind, add a public `ViewModel` property of type `PersonListPageViewModel` with a getter only, and initialize it to a new object. This means the View creates and holds a reference to the ViewModel.
    4. In `PersonListPage.xaml`, update the bindings for the two `TextBox` objects properly. Since `NewPerson.Name` and `NewPerson.Age` are now one level deeper, you need to bind to them through the `ViewModel` property.
    5. In `PersonListPage.xaml`, you need to adjust the event handlers (`Click`) in three places. This is trickier:
        * You can no longer define event handlers using the old syntax (`Click="SomeHandler"`) because the handlers are no longer in the code-behind — they have been moved to the ViewModel.
        * Instead, you must bind the handlers using command bindings, as shown in the lecture. This works because the `ViewModel` property in the code-behind gives access to the `PersonListPageViewModel` instance, which contains the handler methods (`AddButton_Click`, `IncreaseButton_Click`, `DecreaseButton_Click`).
        * Make sure these handler methods are public, otherwise the bindings won't work — you must change them from private to public.

Further essential modifications:

* In the ViewModel, the current names of the `Click` event handlers are: `AddButton_Click`, `IncreaseButton_Click`, and `DecreaseButton_Click`. This is not ideal. In a ViewModel, we don't think in terms of "event handlers", but rather in terms of modifier methods that alter the state of the ViewModel. Much better, more expressive names for these methods would be: `AddPersonToList`, `IncreaseAge` and `DecreaseAge`. Rename the functions accordingly! And of course, continue to use data binding to bind these methods to the `Click` events in the XAML file.
* These functions currently have the parameter list "`object sender, RoutedEventArgs e`". However, these parameters are not used for anything.
Fortunately, the x:Bind event binding is flexible enough to allow methods without parameters — it will still work just fine. In light of this, remove the unused parameters from the three functions in our ViewModel. This will result in a cleaner and more elegant solution.

Make sure that after these changes, the application still behaves exactly the same as it did before!

What did we gain by converting our earlier solution to an MVVM-based one? The answer is given in the lecture material. Here's a quick highlight of the benefits:

* Responsibilities are nicely separated, no more mixing of concerns, which makes things easier to understand:
    * UI-independent logic (Model and related classes)
    * UI logic (ViewModel)
    * Pure UI appearance (View)
* Since the UI logic is separate, it can (and should) be unit tested independently.

!!! example "SUBMISSION REQUIRED"
    Take a screenshot named `f2.png` as follows:

    - Launch the application. If needed, resize it to make it smaller so it doesn’t take up too much screen space.
    - In the background, Visual Studio should be open with the `PersonListPageViewModel.cs` file displayed.

## Task 3 - Enabling/disabling Controls

In its current state, the application behaves a bit oddly: you can use the "–" button to reduce someone's age into negative values, or the "+" to push it beyond 150. Also, the "+Add" button allows adding a person with nonsensical properties. We need to disable these buttons when the action doesn’t make sense, and enable them when it does.

As the next step, let's implement the disabling/enabling of the "–" button appropriately. The button should only be enabled when the person’s age is greater than 0.

Try to implement this yourself first, at least lay down the basics! Be sure to use a data binding–based solution, as only this is acceptable. If you get stuck or your solution doesn’t "want" to work, rethink what might be the issue, and adjust your implementation according to the following:

Multiple valid solutions are possible for this problem. What they all have in common is that the `IsEnabled` property of the “–” button is bound in some way. In our chosen solution, we bind it to a newly introduced bool property inside `PersonListPageViewModel`.

``` csharp title="PersonListPageViewModel.cs"
    public bool IsDecrementEnabled
    {
        get { return NewPerson.Age > 0; }
    }
```

``` xml title="PersonListPage.xaml-be a '-' gombhoz"
    IsEnabled="{x:Bind ViewModel.IsDecrementEnabled, Mode=OneWay}"
```

Let’s try it out! Unfortunately, it doesn’t work: the "–" button is not disabled when the age becomes 0 or less (e.g. by clicking the button multiple times). If we place a breakpoint inside the `IsDecrementEnabled` property and then launch the application, we’ll notice that the property is only queried once by the bound control — during application startup. Even after repeatedly clicking the "–" button, it won’t be queried again. Try it yourself!

Think through what’s causing this, and only then continue with the guide.

??? tip "Explanation"
    According to what we’ve learned earlier, data binding only queries a source property’s value when it receives a change notification via `INotifyPropertyChanged`! In our current solution, even though the `Age` property of the `NewPerson` object changes, there’s no notification that the dependent `IsDecrementEnabled` property has changed as a result.

Next step: Implement the corresponding change notification in the `PersonListPageViewModel` class:

* Use MVVM Toolkit foundations to implement the `INotifyPropertyChanged` interface:
    * Derive from `ObservableObject`.
    * The `IsDecrementEnabled` property can remain as a getter-only property — it does not need to be based on `[ObservableProperty]`. (Although rewriting it that way is also a valid and fully acceptable solution for the assignment — just be aware the next steps work slightly differently in that case.)
* Try to implement the following on your own, in the ViewModel class (note: the `Person` class remains unchanged): when `NewPerson.Age` changes, trigger a call to `OnPropertyChanged`, which is inherited from `ObservableObject`, to notify that `IsDecrementEnabled` has changed. Hint: the `Person` class already implements `INotifyPropertyChanged`, so you can subscribe to its `PropertyChanged` event! For simplicity, it’s okay if you notify a change to `IsDecrementEnabled` even when the logical value might not have actually changed.
* You can achieve all of this without writing a separate handler method — hint: use a lambda expression to assign the event handler.

Test your solution! If everything is working correctly, the "–" button should also become disabled if you manually type a negative age value into the TextBox and then click outside the TextBox. Take a moment to think about why this works!

Next, implement a similar solution for both the "+" button and the "+Add" button.

* The maximum acceptable age should be 150.
* A name is only acceptable if it contains at least one non-whitespace character. (Use the static method `string.IsNullOrWhiteSpace` for this validation.)
* You don’t need to handle cases where the user types a non-numeric value into the age TextBox. (This is not manageable with the current implementation anyway.)

During testing, you may notice that if you delete the name in the TextBox, the +Add button’s enabled state does not update immediately. It only changes after leaving (unfocusing) the TextBox.
Why is this? This happens because the default binding behavior is to update the bound source only when the TextBox loses focus. Modify your implementation so that the update happens on every keystroke, without needing to leave the TextBox.

!!! example "SUBMISSION REQUIRED"
    Take a screenshot named `f3.png` as follows:
    
    - Start the application. If needed, resize it so it doesn’t take up too much screen space.
    - In the app, reduce the age to 0.
    - In the background, have Visual Studio open with the `PersonListPageViewModel.cs` file visible.

## Task 4 – Using Command

At the moment, handling the "–" button requires us to do two things:

* Execute an event handler when `Click` is triggered
* Enable or disable the button using the `IsEnabled` property

However, certain controls — like buttons — support doing both via a Command-based approach, using a command object. You can learn more about the Command design pattern from the "Design Patterns 3" lecture (although that only covers the basic Command pattern, which supports execution but not enabling/disabling). The MVVM-specific implementation of the Command pattern is introduced at the end of the WinUI lecture series.

The basic principle: Instead of using `Click` and `IsEnabled`, the button’s `Command` property is set to a command object that implements the `ICommand` interface. Execution and enabling/disabling are now handled entirely by the command object.

Normally, each command would require its own `ICommand` implementation. But this would mean creating a separate class for each command — a lot of boilerplate. Thankfully, the MVVM Toolkit helps here. It provides a `RelayCommand` class that implements `ICommand`. This class is flexible enough to handle any command via delegates passed to its constructor, so there’s no need to create additional command classes. How does this work?
The `RelayCommand` constructor takes two delegates:

* The first parameter is the code to execute when the command is run.
* The second parameter (optional) is the code that returns a bool indicating whether the command should be enabled. If it returns true, the command is enabled; otherwise, it's disabled.

Your next step: convert the handling of the "–" button to use the command pattern. Try to implement most of this on your own, based on the related WinUI lecture slides. Execution is relatively simple, but handling enabling/disabling requires a bit more. Main steps:

* In your ViewModel, introduce a public `RelayCommand` property with only a getter, e.g. named `DecreaseAgeCommand`. Unlike the lecture slides, in our case the `RelayCommand` does not need a generic parameter, because our handler method (`DecreaseAge`) takes no arguments.
* In the ViewModel constructor, assign a value to this new property.
Pass appropriate delegates to the `RelayCommand` constructor (one for execution, one for `CanExecute`).
* In `PersonListPage.xaml`: remove the current `Click` and `IsEnabled` bindings on the "–" button. Instead, bind the button’s `Command` property to the `DecreaseAgeCommand` you just added in the ViewModel.

If we try it out, the command execution works, but the enable/disable logic doesn’t. If we observe carefully, the button always remains visually enabled. This actually makes sense. While the `RelayCommand` is capable of calling the function passed as the second constructor parameter (used to determine its enabled state), it has no way of knowing that it should re-evaluate this every time `NewPerson.Age` changes! But we can fix this: in the ViewModel’s constructor, we already subscribed to `NewPerson.PropertyChanged`. Based on this, we can do the following: whenever Age changes (or even when it might change — it’s okay if we notify a bit too often), call the `NotifyCanExecuteChanged()` method on the `DecreaseAgeCommand`. This method has a very descriptive name: it notifies the command that the condition determining whether it should be enabled or disabled may have changed. As a result, the command will update itself, or more precisely, it will update the enabled state of the associated button.

Refactor the handling of the "+" button in the same way, using a command-based approach. Do not modify the handling of the "+Add" button.

!!! example "SUBMISSION REQUIRED"
    Take a screenshot named `f4.png` as follows:

    - Launch the application. Resize it if needed so it doesn’t take up too much screen space.
    - In the app, make sure the name TextBox is empty.
    - In the background, have Visual Studio open with the `PersonListPageViewModel.cs` file visible.

