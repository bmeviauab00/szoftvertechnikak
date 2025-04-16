---
authors: bzolka
---

# 5th Homework - MVVM

## Introduction

TODO

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
(Just note that instead of installing "Newtonsoft.Json", you should search for and install CommunityToolkit.Mvvm.)