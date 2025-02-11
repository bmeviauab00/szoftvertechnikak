---
authors: bzolka
---

# 1. Relationship between the model and the code

## The goal of the exercise

The goal of the exercise:

- Getting to know the students/trainer
- Clarification of the requirements for exercises
- Getting started with Visual Studio and .NET application development.
- Building a simple Hello World .NET application, C# basics
- Illustrating the relationship between UML and code
- The interface and the abstract primitive class application technique

??? note "For teachers"
    While there will certainly be some students who have used the Visual Studio environment before, in Prog2 (C++) or for other reasons, there will almost certainly be others who have not used it or who remember it less. The goal here is to get familiar with the interface, so as you work through the exercises, you will be introduced to the things you use (e.g. Solution Explorer, ++f5++ running, using breakpoints, etc.) to build your first C# application.

## Prerequisites

The tools needed to carry out the exercise:

- Visual Studio 2022

The latest version of Visual Studio should be installed. The Community Edition, Professional and Enterprise versions are also suitable. The Community Edition is free and can be downloaded from the Microsoft website. The Professional is paid, but it is also available free of charge to students of the university (on the website, as part of the Azure Dev Tools for Teaching programme).

!!! note "Visual Studio Class Diagram support"
    For some of the exercises in this exercise (and also for the first homework) we will use the Visual Studio Class Designer support. Visual Studio does not always add the Class Designer component during installation. If it is not possible to add a Class Diagram to your Visual Studio project (because the Class Diagram is not listed in the list of the window that appears during the Add New Item command - more on this later in this guide), you will need to install the Class Diagram component later:

    1. Start the Visual Studio installer (e.g. by typing "Visual Studio Installer" in the Windows Start menu).
    2. In the window that appears, select the "Individual components" tab
    3. In the search box, type "class designer" and then make sure that "Class Designer" is unchecked in the filtered list.
        
        ![Class diagram support installation](images/vs-isntaller-add-class-diagram.png)

What you should check out:

- The exercise does not include a lecture on the subject. At the same time, the exercise builds on basic UML knowledge and the basics of mapping UML class diagrams to code.

## Course of exercise

The trainer will summarise the requirements for the exercises at the beginning of the exercise:

- Most of these can be found in the fact sheet
- Information on homework is available on the subject's website.

Using Visual Studio development tool, we will build .NET applications in C#. C# is similar to Java, we will gradually learn the differences.
The tutorial is guided, with instructions from the tutor, and the tasks are done together.

## Solution

??? success "Download the finished solution"
    :exclamation: It is essential that you follow the lab guide during the lab, it is forbidden (and pointless) to download the ready-made solution. However, during subsequent self-practice, it can be useful to review the ready-made solution, so we make it available.

    The solution is available on [GitHub](https://github.com/bmeviauab00/lab-modellkod-kiindulo/tree/megoldas). The easiest way to download it is to clone it from the command line to your machine using the `git clone` command:

    ```git clone https://github.com/bmeviauab00/lab-modellkod-kiindulo -b solved```

    You need to have git installed on your machine, more information [here](../../hazi/git-github-github-classroom/index.md#git-telepitese).

## 1. Task - Build a "Hello world" .NET console application

The task is to create a C# console application that prints the text "Hello world!" to the console.

The application is written in C#. The compiled application is run by the .NET runtime. The theoretical background of compiling/running and the basics of .NET are covered in the first lecture.

The steps to create a solution and a project within it in Visual Studio 2022:

1. Start a new project wizard, which can be done in two ways
    - Using the startup window
        1. Launch Visual Studio
        2. In the right-hand sidebar of the launch window that appears *Create new project*
    - Already running in Visual Studio
        1. File / New-Project
2. In the Create new project wizard, select the *Console app* (and **NOT** the *Console app (.NET Framework)* template, including the C# one. That it is C# is indicated by the top left corner of the template icon. If you don't see it in the list, you have to search/filter for it. You can search for it by typing "console" in the top search bar. Or by using the drop-down boxes below: in the first (language selector) "C#", in the third (project type selector) "Console".

    Creating a project

3. Next button at the bottom of the wizard window, on the next wizard page:
    1. Project name: **Hello World**
    2. Location: in the labs, work in the **c:\work\<your name>** folder, you have write access to it.
    3. Solution name: **Hello World** (this should be written in by the time we get here)
    4. Place solution and project in the same directory: no tick (but not particularly significant).

4. Next button at the bottom of the wizard window, on the next wizard page:
    1. Framework: **.NET 8 (Long-term support).**
    2. Check the "Do not use top level statements" checkbox (we'll explain this in a moment).

The project also creates a new solution, whose structure can be viewed in the Visual Studio *Solution Explorer* window. A solution can consist of several projects, and a project can consist of several files. A solution is a summary of the entire working environment (it includes a file with the extension `.sln`), while the output of a project is typically a file `.exe` or `.dll`, i.e. a component of a complex application/system. The project file extension for C# applications is `.csproj`.

The content of our `Program.cs` file is as follows:

```csharp title="Program.cs"
namespace HelloWorld
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
        }
    }
}
```

Take a `Console.ReadKey()` line:

```csharp hl_lines="8"
namespace HelloWorld
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
            Console.ReadKey();
        }
    }
}
```

1. Run the application (e.g. using the ++f5++ key).

    The structure of the code is very similar to Java and C++. Our classes are organised into namespaces. You can define a namespace with the keyword `namespace`. You can "scope" namespaces with the `using` keyword. e.g:

    ```csharp
    using System.Collections.Generic;
    ```

2. In a console C# application, you specify the entry point of your application by writing a static function called `Main`. Our class name can be anything, VS generated a class called `Program` in our case. The parameter list of the `Main` function is bound: either no parameters are given, or a `string[]` is given, in which the command line arguments are given at runtime.
3. in .NET, the `Console` class of the `System` namespace is used to handle standard input and output. With the static operation `WriteLine` you can write a line, with `ReadKey` you can wait for a key to be pressed.

!!! tip "Top level statements, Implicit and static usings and namespaces"
    When the project was created, we previously checked the "Do not use top level statements" checkbox. If we had not done this, we would have found only one meaningful line in our `Program.cs` file:

    ```cs
    // See https://aka.ms/new-console-template for more information
    Console.WriteLine("Hello World!");
    ```

    This is functionally equivalent to the code above containing the `Program` class and its `Main` function. Let's look at what makes this possible (you can read more about them here <https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/tutorials/top-level-statements>, both new in C# 10):

    - **Top level statements**. The idea is that you can write code directly in a single source file without any class/`Main` and other function definitions in the project. In this case, behind the scenes, the compiler puts this into a static `Main` function of a class we don't see. The motivation for its introduction was to reduce boilerplate code for very simple, "script-like" applications.
    - **Implicit global usings**. Depending on exactly what project type you have created, certain base namespaces will be automatically using behind the scenes in all source files (the compiler uses the *global using* directive for this). The point is: this way, developers don't have to use certain frequently used namespaces (e.g. `System.IO`, `System.Collections.Generic`, etc.) as source files.
    - **Static using**. It is possible to use static classes instead of namespaces in C#, so it is not important to write them when using them. A common case is the use of the `Console` or `Math` class.

        ```csharp hl_lines="1 9"
        using static System.Console;

        namespace ConsoleApp12
        {
            internal class Program
            {
                static void Main(string[] args)
                {
                    WriteLine("Hello, World!");
                }
            }
        }
        ```

    - **File-level namespaces**. In C# 10, we also get a simplification when declaring namespaces, because it is no longer mandatory to use brackets, so the given namespace will be valid for the whole file, e.g.:

        ```csharp hl_lines="1"
        namespace HelloWorld;

        internal class Program
        {
            // ...
        }
        ```

!!! warning "Inconsistent visibility or inconsistent accessibility error"
    During the semester, you may encounter translation error messages complaining *about inconsistent visibility* or *inconsistent accessibility* when implementing programming tasks. This phenomenon is due to the possibility to control the visibility of each type (class, interface, etc.) in a .NET environment:

    - `internal` or no visibility is specified: the type is visible only inside the assembly (.exe, .dll)/project
    - `public`: the type is visible to other assemblies/projects
    
    The easiest way to avoid this error is to define all our types as public, e.g.:

    ```csharp
    public class HardDisk
    {
        // ...
    }
    ```

## Theoretical overview

The sub-chapters do not contain exercises, but provide students with an introduction to the related theoretical topics, illustrated with examples.

### A) Theory of the relationship between the UML class diagram and code [student]*

The material is available here: [The relationship between the UML class diagram and code](../../egyeb/uml-kod-kapcsolata/index_eng.md). The relationship between the UML class diagram and code. This topic was covered in the previous semester in the Software Engineering course.

### B) Interface and abstract (parent) class [student]*

The material is available here: [Interface and abstract (base) class](../../egyeb/interfesz-es-absztrakt-os/index_eng.md).   Interface and abstract (base) class.

Topics:

- Abstract class concept and definition in C#
- Interface concepts and definitions in C#
- Comparison of abstract base class and interface

## 2. Task - Illustrate the relationship between UML and code

### Task description - Equipment inventory

Task: We were asked to develop a computer parts inventory application. Read more:

- You need to be able to handle different types of parts. Initially, `HardDisk`, `SoundCard` and `LedDisplay` types should be supported, but the system should be easily extensible to new types.
- The data related to the parts are: year of purchase, age (calculated), purchase price and current price (calculated), but may also include type-specific data (e.g. capacity for `HardDisk`).
- The actual price depends on the type of part, the purchase price and the year of production of the part. For example, the older the part, the bigger the discount, but the discount depends on the part type.
- You must be able to list the parts in stock.
- The `LedDisplay` class must be derived from an `DisplayBase` class, and the source code of the `DisplayBase` class cannot be changed. In this example this does not make much sense, but in practice we often encounter similar situations where the framework/platform we are using requires us to derive from a built-in class. Typically, this is the case when working with windows, forms, custom control types: we have to derive them from the framework's built-in classes, and we don't have (or at least certainly don't want to change) the source code of the framework - e.g. Java, .NET. In our example, we simulate this situation by specifying a derivation from `DisplayBase`.

The implementation is simplified considerably: the parts are only stored in memory, and the listing is as simple as possible, simply by writing the data of the registered parts to the console.

During the initial discussions, we receive the following information from the client: an internal staff member has already started the development, but due to lack of time, they have only reached a half-finished solution. Part of our task is to understand the semi-finished solution and to implement the task from there.

### Class Diagram

Let's open the source code solution from our customer, which we can do by following the steps below.

To do this, clone the Git repository of the initial project, available online on GitHub, to a new folder of its own within `C:\Work`: e.g: `C:\Work\NEPTUN\lab1`. In this new folder, open a command line or powershell and run the following git command:

```cmd
git clone https://github.com/bmeviauab00/lab-modellkod-kiindulo.git
```

!!! note Git and GitHub
    You will read more about Git as a source code management system in the context of the first homework assignment.

Open the Visual Studio solution src/EquipmentInventory.sln in the cloned folder.

In Solution Explorer, run through the files by eye. It would help to understand the relationships between classes by displaying them on a class diagram. Let's include a class diagram in our project. In the Solution Explorer, right-click on the **project** (not the solution!), select *Add/New Item* from the pop-up menu, then in the window that appears, select Class Diagram, enter Main.cd as the name of the diagram at the bottom of the window, and OK-close the window.

!!! warning "Missing Class Diagram template"
     If the *Class Diagram* item does not appear in the list, then the appropriate component of VS is not installed. You can read more about this in the Prerequisites section of this document.

The chart file `Main.cd` will then appear in Solution Explorer, double-click on it to open it. Our chart is currently empty. From Solution Explorer, drag&drop the .cs source files onto the diagram. VS then looks at what classes are in these source files and decomposes them into UML classes. Build the layout as shown in the following figure (you can display the members of the classes by clicking on the double arrow in the top right corner of their rectangle):

Starting class diagram

You can also view the source code for the classes, either by double-clicking on the corresponding class on the diagram or by opening the .cs files from Solution Explorer.
Here's what we see:

- The `SoundCard`, `HardDisk` and `LedDisplay` classes are relatively well developed, with the necessary attributes and query functions.
- The `LedDisplay` is derived from the `DisplayBase` class as required.
- `EquipmentInventory` is responsible for the inventory of parts in stock, but practically none of this is implemented.
- We find an interface `IEquipment` with operations `GetAge` and `GetPrice`

### EquipmentInventory

Let's start working on a solution. First, let's lay down the basic concepts. In the `EquipmentInventory` class, we store a heterogeneous collection of different types of equipment. This is the key to consistent parts management, so that our solution can be easily extended with new parts types.

As discussed earlier, unified management can be achieved either by implementing a common base class or a common interface. In our case, the common base class (e.g. `EquipmentBase`) seems to be dropped, because by introducing it, the `LedDisplay` class would have two base classes: the mandatory `DisplayBase`, and the `EquipmentBase` that we introduce for uniform management. This is not possible, in a .NET environment a class can have only one base class. The solution to modify `DisplayBase` to be derived from `EquipmentBase` is not possible according to our requirement (it was a requirement that its source code cannot be modified). This leaves the interface-based approach. This was probably the conclusion of the previous developer of the application, which is why he introduced the `IEquipment` interface.

Add a generic list of items of type `IEquipment` (not property but field!) to the `EquipmentInventory` class. Its visibility - in an effort to be unified - should be `private`. The name should be `equipment` (no "s" at the end, in English the plural of equipment is also equipment). To add a member variable, we use the Visual Studio *Class Details* window. If the window is not visible, it can be displayed by selecting *View / Other Windows / Class Details.*

Class Details

The member variable type is therefore `List`. The type of .NET `List` is a dynamically stretching generic array (like `ArrayList` in Java).
Looking at the `EquipmentInventory` class in the diagram, we see that only the name of the member variable is displayed, not the type. Right-click on the background of the diagram and select *Display Full Signature* from the *Change Members Format* menu. The chart will then display the type of member variables and the full signature of the operations.

EquipmentInventory

By double-clicking on the `EquipmentInventory` class, you can navigate to the source code, and as you can see, it does indeed appear in the code as a member variable of type list:

```csharp hl_lines="3"
class EquipmentInventory
{
    private List<IEquipment> equipment;
```

On the one hand, we're happy about this because Visual Studio supports round-trip engineering: **changes to the model are immediately reflected in the code, and vice versa**. On the other hand, we have previously discussed that if a class has a collection of members from another class, then it "fits" in the UML model as a type 1-more association relation between the two classes. This is not yet the case in our model. Fortunately, the VS modelling interface can be made to display this type of connection in this form. To do this, right-click on the equipment tag variable on the diagram and select *Show as Collection Association* from the menu. The `IEquipment` interface should then be moved to the right to allow enough space on the diagram to display the association relationship and the role on the relationship:

Collection association

The double arrow ending on the "plural" side is not standard UML, but don't be too sad about it, it's not important. We are certainly pleased that the arrow representing the relationship at the end of the `IEquipment` role shows the name (and even the exact type) of the member variable.

Navigate to the source code of `EquipmentInventory` and write the constructor that initializes the `equipment` collection

```csharp
public EquipmentInventory()
{
    equipment = new List<IEquipment>();
}
```

Then write the `ListAll` method, which prints the age of the elements and their current values:

```csharp
public void ListAll()
{
    foreach (IEquipment eq in equipment)
    {
        Console.WriteLine($"Age: {eq.GetAge()}\tÉrtéke: {eq.GetPrice()}");
    }
}
```

Iterate through the elements using the `foreach` statement. When using the `foreach` statement, the `in` keyword should be followed by a collection and preceded by a variable declaration (in this case `IEquipment eq`), where type is the element type of the collection. In each iteration, this variable takes the iteration value of the collection.

`Console.WriteLine` is either a simple string or, as in this case, a formatting string. The substitutions are solved by string interpolation: the values to be substituted must be given between ``. If string interpolation is used, the string must start with `$`.

Write a function called `AddEquipment` that adds a new device to the inventory:

```csharp
public void AddEquipment(IEquipment eq)
{
     equipment.Add(eq);
}
```

### IEquipment implementers

We have previously decided to use the `IEquipment` interface to manage the different component types in a uniform way. In our example, both `SoundCard` and `HardDisk` have `GetAge()` and `GetPrice()` methods, yet we cannot manage them in a unified way (e.g., store them in a common list). To do this, we need to get both classes to implement the `IEquipment` interface. Change their source:

```csharp
public class SoundCard : IEquipment
```

```csharp
public class HardDisk : IEquipment
```

Then we need to implement the methods in the `IEquipment` interface in the `SoundCard` and `HardDisk` classes. We find that there is nothing to do with this now, the `GetPrice` and `GetAge` functions are already written in both places.

As a test, in our `Main` function in `Program.cs`, create an `EquipmentInventory` object, populate it with `HardDisk` and `SoundCard` objects, and then list the object on the console. If 2021 is not the current year, in the following rows, copy the year 2021 to the current year and the year 2020 to a smaller number!

```csharp
static void Main( string[] args )
{
    EquipmentInventory ei = new EquipmentInventory();

    ei.AddEquipment(new HardDisk(2023, 30000, 80));
    ei.AddEquipment(new HardDisk(2024, 25000, 120));
    ei.AddEquipment(new HardDisk(2024, 25000, 250));

    ei.AddEquipment(new SoundCard(2024, 8000));
    ei.AddEquipment(new SoundCard(2025, 7000));
    ei.AddEquipment(new SoundCard(2024, 6000));

    ei.ListAll();
}
```

Running the application, we find that although our solution is rudimentary, it works:

Console output

Continue with the `LedDisplay` class. The `DisplayBase` base class source code cannot be modified due to requirements. But this doesn't cause any problems, our `LedDisplay` class will implement the `IEquipment` interface, so modify the code accordingly:

```csharp
public class LedDisplay : DisplayBase, IEquipment
```

In the `LedDisplay` class, the functions in the interface must already be written:

```csharp
public double GetPrice()
{
    return this.price;
}

public int GetAge()
{
    return DateTime.Today.Year - this.manufacturingYear;
}
```

Let's extend our `Main` function by adding two `LedDisplay` objects to our set (again, if 2021 is not the current year, we should rewrite 2021 to the current year in the following lines, and 2020 to a smaller number!

```csharp hl_lines="1 2"
ei.AddEquipment(new LedDisplay(2020, 80000, 17, 16));
ei.AddEquipment(new LedDisplay (2021, 70000, 17, 12));
        
ei.ListAll();
Console.ReadKey();
```

As a test, run the application.

## 3. Task - Application of the interface and the abstract primitive class

### Interface problems

Evaluate our current interface-based solution.

One of the main problems is that our code is full of code duplication that destroys maintainability and extensibility:

- The `yearOfCreation` and `newPrice` tags are common to all part types (except the special `LedDisplay`), and must be copy-pasted when a new type is introduced.
- The implementation of the `GetAge` function is the same for all component types (except for the special `LedDisplay`), also copy-paste "propagated".
- The lines of the constructors `yearOfCreation` and `newPrice` initializing tags are also duplicated in each class.

Although this code duplication does not seem significant at the moment, the situation is getting worse as new component types are introduced, and it is better to prevent future pains in time.

The other problem is that the listing of parts data is currently painfully incomplete, with no part type (only age and price). To display the type, the IEquipment interface must be extended, e.g. by introducing an operation called `GetDescription`.  Let's add a `GetDescription` function to the interface!

```csharp hl_lines="5"
public interface IEquipment
{
    double GetPrice();
    int GetAge();
    string GetDescription();
}
```

Then every class implementing the `IEquipment` interface would have to implement this method, which is a lot of work for many classes (and often not even feasible for a multi-component application, i.e. one with several DLLs, when they are not in the hands of a single developer). Run the *Build* command to check that after adding `GetDescription`, you get compilation errors in three places.

!!! tip "Specifying default implementation in interface"
    It is worth knowing that starting from C# 8 (or .NET or .NET Core runtime, not supported under .NET Framework), **interface operations can be given default implementation (default interface methods), so to solve the above problem you don't need an abstract class, but interface can no longer have member variables**. More information here: default interface methods.

    ```csharp hl_lines="5"
    public interface IEquipment
    {
        double GetPrice();
        int GetAge();
        string GetDescription() { return "EquipmentBase"; }
    }
    ```

### Abstract class

A solution to both problems is the introduction of a common abstract base class (except for the `LedDisplay` class, which we will come back to). We can move the code common to descendants into it, and provide a default implementation for the newly introduced `GetDescription` operation. Let our new abstract base class be called `EquipmentBase`. The question is whether the `IEquipment` interface is still needed, or whether it can be completely replaced by the new `EquipmentBase` class. We need to keep the `IEquipment` interface, because we cannot derive our LedDisplay class from `EquipmentBase`: it already has a mandatory base class, `DisplayBase`: for this reason, EquipmentInventory in our enhanced solution also refers to the various components as `IEquipment` interface.

Let's start the transformation. Let our class diagram be the active tab. *From the Toolbox*, drag&drop an *Abstract Class* element onto the diagram, name it `EquipmentBase`.

Toolbox - abstract class

In the following, we need to make the `SoundCard` and `HardDisk` classes derive from `EquipmentBase` (`LedDisplay` already has another base class, so we cannot do this there). To do this, select the *Inheritance* link in the *Toolbox*, then draw a line from the child class to the base class for both `SoundCard` and `HardDisk`.

In the next step, let's modify the code so that `HardDisk` and `SoundCard` do not implement the `IEquipment` interface separately, but rather their common base class `EquipmentBase` implement it once. To do this, modify the EquipmentBase class to implement the interface (either by drawing an inheritance link from `EquipmentBase` to `IEquipment` on the diagram, or by modifying the source code of `EquipmentBase`). Delete the implementation of `IEquipment` from the `HardDisk` and `SoundCard` classes (the base class already implements it).

The relevant parts of our diagram and source code will then look like this:

EquipmentBase and HardDisk/SoundCard

```csharp
public abstract class EquipmentBase : IEquipment
```

```csharp
public class HardDisk : EquipmentBase
```

```csharp
public class SoundCard : EquipmentBase
```

Our code is not yet turning, for several reasons. The `EquipmentBase` implements the `IEquipment` interface, but it does not yet implement the interface operations. Either generate the methods using the smart tag, or type them according to the following principles:

- The `newPrice` and `yearOfCreation` are duplicated in the `HardDisk` and `SoundCard` classes: move (not copy!) them to the common `EquipmentBase` base class and give `protected` visibility.
- The `GetAge` operation is duplicated in the `HardDisk` and `SoundCard` classes, delete the implementation from these and move it to the `EquipmentBase` class.
- The `GetPrice` operation is included in the base class as an abstract operation. This is a deliberate design decision, so we force descendant classes to override this operation anyway.
- In the case of `GetDescription`, the opposite is true: it is defined as virtual (and not abstract), i.e. we provide an implementation in the base class. This way, descendants are not forced to override the operation.

The code corresponding to the above is:

```csharp
public abstract class EquipmentBase : IEquipment
{
    protected int yearOfCreation;
    protected int newPrice;

    public int GetAge()
    {
        return DateTime.Today.Year - yearOfCreation;
    }

    public abstract double GetPrice();

    public virtual string GetDescription()
    {
        return "EquipmentBase";
    }
}
```

!!! tip "Some additional thoughts on the code fragment:"

    - For abstract classes, the keyword `abstract` must be written before the word `class`.
    - For abstract operations, the keyword `abstract` must be specified
    - in a .NET environment, you can control whether an operation is virtual or not. In this respect, it is similar to C++. To make an operation virtual, the keyword `virtual` must be specified for the operation. Reminder: define an operation as virtual if its descendants overdefine it. Only then is it guaranteed that the descendant version will be called when invoking the given operation on an ancestor reference.

### Descendants

In the next step, let's move on to the `EquipmentBase` descendants. When overriding abstract and virtual operations in C#, you must specify the `override` keyword in the descendant. First, the `GetPrice` operation is redefined:

```csharp title="HardDisk.cs"
public override double GetPrice()
{
    return yearOfCreation < (DateTime.Today.Year - 4)
        ? 0
        : newPrice - (DateTime.Today.Year - yearOfCreation) * 5000;
}
```

```csharp title="SoundCard.cs"
public override double GetPrice()
{
    return yearOfCreation < (DateTime.Today.Year - 4)
        ? 0 
        : newPrice - (DateTime.Today.Year - yearOfCreation) * 2000;
}
```

In the next step, the `GetDescription` operation is written in the `HardDisk` and `SoundCard` classes. Since the virtual function of the base class is being overridden here, the `override` keyword must also be specified:

```csharp title="HardDisk.cs"
public override string GetDescription()
{
    return "Hard Disk";
}
```

```csharp title="SoundCard.cs"
public override string GetDescription()
{
    return "Sound Card";
}
```

One might ask why the designers of the C# language decided to add an extra keyword to the definition of operations, which was not necessary in the case of C++. The reason is simple: the code is more expressive. Looking at the descendant code, the word `override` immediately makes it clear whether this operation is abstract or virtual in one of the base classes, without having to look at the code of all the ancestors.

### Base class of LedDisplay

The base class of our `LedDisplay` class is bound, its code cannot be modified, so we cannot derive it from `EquipmentBase`. We cannot delete the `GetAge` operation, this code duplication is preserved here (but only for `LedDisplay`, which is only one class among many!).

!!! note
    In fact, with a little extra work we could get rid of this duplication. This would require a static helper function in one of the classes (e.g. `EquipmentBase`), which would get the year of manufacture and return the age. `EquipmentBase.GetAge` and `LedDisplay.GetAge` would use this helper function to produce their output.

    In our `LedDisplay` class, we are yet to write `GetDescription`:

```csharp title="LedDisplay.cs"
public string GetDescription()
{
    return "Led Display";
}
```

Note that we have NOT specified the `override` keyword here. When an interface function is implemented, `override` is not required/allowed to be written.

### Use GetDescription

Modify the `EquipmentInventory.ListAll` operation to also write the description of the items to the output:

```csharp title="EquipmentInventory.cs"
public void ListAll()
{
    foreach (IEquipment eq in equipment)
    {
        Console.WriteLine($"Description: {eq.GetDescription()}\t" +
            $"Age: {eq.GetAge()}\tÉrtéke: {eq.GetPrice()}");
    }
}
```

This gives a more informative output when the application is run:

Console output

### Constructor code duplication

Looking at our code, there is one more duplication. All `EquipmentBase` descendants (`HardDisk`, `SoundCard`) have these two lines in their constructor:

```csharp
 this.yearOfCreation = yearOfCreation;
 this.newPrice = newPrice;
```

If you think about it, these `yearOfCreation` and `newPrice` members are defined in the base class, so it should be his responsibility to initialize them anyway. Let's add a corresponding constructor in `EquipmentBase`:

```csharp title="EquipmentBase.cs"
public EquipmentBase(int yearOfCreation, int newPrice)
{
    this.yearOfCreation = yearOfCreation;
    this.newPrice = newPrice;
}
```

Remove the initialization of the two members from the constructor of the descendants `HardDisk` and `SoundCard`, and instead invoke the base class’s constructor by referencing the `base` keyword:

```csharp title="HardDisk.cs"
public HardDisk(int yearOfCreation, int newPrice, int capacityGB)
    : base(yearOfCreation, newPrice)
{
    this.capacityGB = capacityGB;
}
```

```csharp title="SoundCard.cs"
public SoundCard(int yearOfCreation, int newPrice)
    : base(yearOfCreation, newPrice)
{
}
```

### Evaluation

By using a combination of interface and abstract base class, we have managed to develop the solution with the least compromise:

- By referring to `IEquipment` as an interface, we can uniformly handle all types of parts, even those where the base class was bound (using abstract base classes alone would not have achieved this).
- By introducing the `EquipmentBase` abstract base class, we were able to put the code common to different part types into a common base, with one exception, thus avoiding code duplication.
- By introducing the `EquipmentBase` abstract ancestor, we can specify a default implementation for newly introduced `IEquipment` operations (e.g. `GetDescripton`), so we are not forced to specify it in every `IEquipment` implementation class.

Finally, let's take a look at the UML (like) class diagram of our solution:

Ultimate class diagram

!!! note "Static interfaces"
    The latest addition to C# 11 is the definition of static interface members, which allows you to require an implementing class to have members that do not refer to the object instance, but rather the class must have a specific static member. Read more

### Note - optional homework exercise

Our solution does not support the display of component specific data (e.g. capacity for `HardDisk`) during listing. To do this, the writing of component data to a formatted string should be moved from the `EqipmentInventory` class to the component classes, following the principles below:

- To do this, we can introduce an `GetFormattedString` operation in the `IEquipment` interface, which returns an object of type `string`. Alternatively, you can override the ToString()` operation of `System.Object. indeed, in .NET, all types are implicitly derived from `System.Object`, which has a virtual `ToString()` operation.
- In `EquipmentBase` we write the formatting of the common tags (description, price, age) into a string.
- If a component also has type-specific data, then its class overrides the function that formats it into a string: this function must first call its ancestor (using the `base` keyword), then append its own formatted data to it, and return with this string.
