---
authors: bzolka
---

# 1. The relationship between the model and the code

## The aim of the laboratory

The aim of the laboratory:

- Getting to know the students/instructor
- Clarification of the requirements for the laboratories
- Getting started with Visual Studio and .NET application development.
- Creating a simple Hello World .NET application, C# basics
- Illustrating the relationship between UML and code
- How to use an interface and an abstract base class

??? note "For instructors"
    Although there are certainly students who have used the Visual Studio environment before, either during the Prog2 (C++) course or for other reasons, there will almost certainly be others who have not used it or who remember it less. The goal here is to get familiar with the interface, so while solving the tasks, continuously explain the features being used (e.g. Solution Explorer, ++f5++ run, using breakpoints, etc.), in order to create our very first C# application.

## Prerequisites

Tools needed to complete the laboratory:

- Visual Studio 2026

It is recommended to install the latest version of Visual Studio. The Community Edition, Professional and Enterprise versions are also suitable. The Community Edition is free and can be downloaded from the Microsoft website. The Professional is paid, but it is also available free of charge to students of the university (on the website <https://azureforeducation.microsoft.com/devtools>, as part of the Azure Dev Tools for Teaching programme).

!!! note "Visual Studio Class Diagram support"
    For some of the exercises in this laboratory (and also for the first homework) we will use the Visual Studio Class Designer support. Visual Studio does not always add the Class Designer component during installation. If it is not possible to add a Class Diagram to your Visual Studio project (because the Class Diagram is not listed in the list of the window that appears during the Add New Item command - more on this later in this guide), you will need to install the Class Diagram component later:

    1. Start the Visual Studio installer (e.g. by typing "Visual Studio Installer" in the Windows Start menu).
    2. In the window that appears, select the "Individual components" tab
    3. In the search box, type "class designer" and then make sure that "Class Designer" is checked in the filtered list.
        
        ![Class diagram support installation](images/vs-isntaller-add-class-diagram.png)

What you should review:

- There is no lecture associated with this laboratory. However, the laboratory builds on basic UML knowledge and the principles of mapping UML class diagrams to code.

## Structure of the laboratory

At the beginning of the exercise, the instructor summarizes the requirements for the laboratories:

- Most of these can be found in the course data sheet
- Information about the homework assignments can be found on the course website.

We will create .NET applications in C# using the Visual Studio development tool. C# is similar to Java, we will gradually learn the differences.
The laboratory is guided, and tasks are carried out together based on the instructor's instructions.

## Solution

??? success "Download the completed solution"
    :exclamation: It is essential to work following the instructor during the lab, it is forbidden (and pointless) to download the final solution. However, during subsequent independent practice, it can be useful to review the final solution, so we make it available.

    The solution is available on [GitHub](https://github.com/bmeviauab00/lab-modellkod-kiindulo/tree/megoldas). The easiest way to download it is to clone it to your computer via the command line using the `git clone` command:

    ```git clone https://github.com/bmeviauab00/lab-modellkod-kiindulo -b megoldas```

    You need to have the command-line git installed on your machine, more information [here](../../hazi/git-github-github-classroom/index_eng.md#git-telepitese).

## Task 1 - Creating a "Hello world" .NET console application

The task is to create a C# console application that prints the text "Hello world!" to the console.

The application is written in C#. The compiled application is run by the .NET runtime. The theoretical background of compiling/running and the basics of .NET are covered in the first lecture.

The steps to create a solution and a project within it in Visual Studio 2026:

1. Start a new project wizard, which can be done in two ways
    - Using the startup window
        1. Launch Visual Studio
        2. In the right-hand sidebar of the launch window that appears, choose *Create new project*
    - In a running Visual Studio
        1. File / New-Project
2. In the Create new project wizard, select the *Console app* (and **NOT** the *Console app (.NET Framework)* template, choose the C# one. That it is C# is indicated by the top left corner of the template icon. If it doesn’t appear in the list, you have to search/filter for it. You can search for it by typing "console" in the top search bar, or use the drop-down boxes below: set the first one (language) to "C#" and the third one (project type) to "Console".

    ![Creating a new project](images/vs-create-new-project-wizard.png)

3. Next button at the bottom of the wizard window, on the next wizard page:
    1. Project name: **Hello World**
    2. Location: in the labs, work in the **c:\work\** folder, you have write access to it.
    3. Solution name: **Hello World** (this should be written in by the time we get here)
    4. Place solution and project in the same directory: no tick (but not particularly significant).

4. Next button at the bottom of the wizard window, on the next wizard page:
    1. Framework: **.NET 10 (Long-term support).**
    2. Check the "Do not use top level statements" checkbox (we will return to this explanation shortly).

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

Add a `Console.ReadKey()` line:

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

    The structure of the code is very similar to Java and C++. Our classes are organised into namespaces. A namespace can be defined with the keyword `namespace`. To bring namespaces into scope use the `using` keyword. e.g:

    ```csharp
    using System.Collections.Generic;
    ```

2. In a C# console application, the entry point of the application is defined by writing a static function named `Main`. The class name can be anything, VS generated a class called `Program` in our case. The parameter list of the `Main` function is fix: either no parameters are given, or a `string[]` is given, in which the command line arguments are given at runtime.
3. In .NET, the `Console` class of the `System` namespace is used to handle standard input and output. With the static operation `WriteLine` you can write a line, with `ReadKey` you can wait for a key to be pressed.

!!! tip "Top level statements, Implicit and static usings, and namespaces"
    When creating the project earlier, we checked the "Do not use top-level statements" checkbox. If we had not done this, our `Program.cs` file would contain only one meaningful line:

    ```cs
    // See https://aka.ms/new-console-template for more information
    Console.WriteLine("Hello World!");
    ```

    This is functionally equivalent to the code above containing the `Program` class and its `Main` function. Let's see what makes this possible (you can read more about them here <https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/tutorials/top-level-statements>, both new in C# 10):

    - **Top level statements**. The idea is that you can write code directly in a single source file without any class/`Main` and other function definitions in the project. In this case, behind the scenes, the compiler puts this into a static `Main` function of a class we don't see. The motivation for its introduction was to reduce boilerplate code for very simple, "script-like" applications.
    - **Implicit global usings**. Depending on exactly what project type you have created, certain fundamental namespaces will be automatically using in all source files behind the scenes (the compiler uses the *global using* directive for this). The point is: this way, developers don't have to add certain frequently used namespaces (e.g. `System.IO`, `System.Collections.Generic`, etc.) in each source file.
    - **Static using**. In C#, you can also use static classes instead of namespaces, so you do not have to explicitly reference them. A common case is the use of the `Console` or `Math` class.

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

    - **File-scoped namespaces**. Also a C# 10 simplification that lets you skip braces when declaring namespaces, so the namespace applies to the entire file:

        ```csharp hl_lines="1"
        namespace HelloWorld;

        internal class Program
        {
            // ...
        }
        ```

!!! warning "Inconsistent visibility or inconsistent accessibility error"
    During the the semester, while implementing programming tasks, you may encounter a compiler error complaining about *inconsistent visibility* or *inconsistent accessibility*. This phenomenon is due to the possibility to control the visibility of each type (class, interface, etc.) in a .NET environment:

    - `internal` or no visibility is specified: the type is visible only inside the assembly (.exe, .dll)/project
    - `public`: the type is also visible to other assemblies/projects
    
    The easiest way to avoid this error is to define all our types as public, e.g.:

    ```csharp
    public class HardDisk
    {
        // ...
    }
    ```

## Theoretical overview

The following subchapters do not contain tasks; they are meant to introduce students to relevant theoretical topics with examples.

### A) Theory of the relationship between the UML class diagram and code [student]*

The material is available here: [The relationship between the UML class diagram and code](../../egyeb/uml-kod-kapcsolata/index_eng.md). This topic was covered in the previous semester in the Software Technology course.

### B) Interface and abstract (base) class [student]*

The material is available here: [Interface and abstract (base) class](../../egyeb/interfesz-es-absztrakt-os/index_eng.md).

Topics:

- The concept and definition of an abstract class in C#
- The concept and definition of an interface in C#
- Comparison of abstract base class and interface

## Task 2 - Illustrating the relationship between UML and code

### Task description - Equipment inventory

Task: We were asked to develop a computer parts inventory application. In details:

- We need to be able to handle different types of parts. Initially, `HardDisk`, `SoundCard` and `LedDisplay` types should be supported, but the system should be easily extensible to new types.
- The data related to the parts are: year of purchase, age (calculated), purchase price and current price (calculated), but may also include type-specific data (e.g. capacity for `HardDisk`).
- The actual price depends on the type of part, the purchase price and the part’s manufacturing year. For example, the older the part, the higher the discount, but the discount depends on the part type.
- You must be able to list the parts in stock.
- The `LedDisplay` class must be derived from a `DisplayBase` class, and the source code of the `DisplayBase` class cannot be changed. In this example, it may not seem particularly meaningful, but in practice, we often encounter similar situations where the framework/platform we are using requires us to derive from a built-in class. Typically, this is the case when working with windows, forms, or custom control types: they must inherit from the framework's built-in classes, and we don't have (or at least certainly don't want to change) the source code of the framework - e.g. Java, .NET. Our example simulates that scenario by requiring that `LedDisplay` inherit from `DisplayBase`.

In our implementation, we are making a big simplification: the parts are only stored in memory, and the listing is as simple as possible, simply by writing the data of the registered parts to the console.

During the initial discussions, we receive the following information from the client: an internal staff member has already started the development, but due to lack of time, they have only reached a half-finished solution. Part of our task is to understand the semi-finished solution and to implement the task from there.

### Class Diagram

Open the [source code](https://github.com/bmeviauab00/lab-modellkod-kiindulo) solution provided by our client by following the steps below.

To do this, clone the Git repository of the initial project, available online on GitHub, to a new folder of its own within `C:\Work`: e.g: `C:\Work\NEPTUN\lab1`. In this new folder, open a command line or powershell and run the following git command:

```cmd
git clone https://github.com/bmeviauab00/lab-modellkod-kiindulo.git
```

!!! note Git and GitHub
    You will read more about Git as a source code management system in the context of the first homework assignment.

Open the Visual Studio solution src/EquipmentInventory.sln in the cloned folder.

In Solution Explorer, run through the files by eye. It would help to understand the relationships between classes by displaying them on a class diagram. Let's add a class diagram in our project. In the Solution Explorer, right-click on the **project** (not the solution!), select *Add/New Item* from the pop-up menu, then in the window that appears, select Class Diagram. Enter Main.cd as the name of the diagram at the bottom of the window, then click OK.

!!! warning "Missing Class Diagram template"
     If the *Class Diagram* item does not appear in the list, then the appropriate component of VS is not installed. You can read more about this in the Prerequisites section of this document.

At this point, the `Main.cd` diagram file appears in the Solution Explorer, double-click to open it. The diagram is currently empty. Drag and drop the .cs files from the Solution Explorer onto the diagram. Visual Studio then examines the classes in those source files and reverse-engineers them into UML classes. Arrange them to match the figure below (expand the class members by clicking the double arrow in the upper-right corner of each class shape):

![Initial class diagram](images/class-diagram-initial.png)

You can also view the source code for the classes, either by double-clicking on the corresponding class on the diagram or by opening the .cs files from Solution Explorer.
We observe the following:

- The `SoundCard`, `HardDisk` and `LedDisplay` classes are relatively well-developed, with the necessary attributes and getter functions.
- `LedDisplay` inherits from the `DisplayBase` class as required.
- `EquipmentInventory` is responsible for handling the inventory of parts in stock, but practically none of this is implemented.
- There is an `IEquipment` interface with `GetAge` and `GetPrice` methods.

### EquipmentInventory

Let's start working on the solution. First, establish the basic concepts. In the `EquipmentInventory` class, we will store different part types in a heterogeneous collection. This is the key to uniform handling of parts, enabling the solution to be easily extended with new part types.

As discussed earlier, unified management can be achieved either by implementing a common base class or a common interface. In our case, a common base class (e.g. `EquipmentBase`) is ruled out because `LedDisplay` is already forced to inherit from `DisplayBase`, and .NET does not allow multiple inheritance from classes. We also cannot modify `DisplayBase` so that it inherits from `EquipmentBase` (the requirement says we cannot modify its source code). So, an interface-based approach remains. Likely, the earlier developer reached the same conclusion and introduced the `IEquipment` interface.

Add a generic list of `IEquipment` type elements (not property but field!) to the `EquipmentInventory` class. Its visibility - striving for encapsulation - should be `private`. The name should be `equipment` (no "s" at the end, in English the plural of equipment is also equipment). To add a member variable, we use the Visual Studio *Class Details* window. If the window is not visible, it can be displayed by selecting *View / Other Windows / Class Details.*

![Class Details](images/class-details.png)

So the field type is `List<IEquipment>`. The .NET `List` type is a dynamically resizing generic array (like `ArrayList` in Java).
Looking at the `EquipmentInventory` class in the diagram, we see that only the name of the member variable is displayed, not the type. Right-click on the background of the diagram and from the *Change Members Format* menu, select *Display Full Signature*. Then the field type will be visible, and method signatures will also be fully displayed.

![EquipmentInventory](images/equipmentinventory.png)

Double-clicking the `EquipmentInventory` class navigates to its source code, and indeed we see a list field there:

```csharp hl_lines="3"
class EquipmentInventory
{
    private List<IEquipment> equipment;
```

On the one hand, we are pleased because Visual Studio supports round-trip engineering: **changes to the model are immediately reflected in the code, and vice versa**. On the other hand, we have previously discussed that if a class has a collection of members from another class, then it "fits" in the UML model as a type 1-to-many association relation between the two classes. Currently, we do not see that in our model. Fortunately, the VS modelling interface can be made to display this type of connection in this form. To do this, right-click on the equipment field on the diagram and select *Show as Collection Association* from the menu. The `IEquipment` interface should then be moved to the right to allow enough space on the diagram to display the association relationship and the role on the relationship:

![Collection association](images/collection-association.png)

The double arrow ending on the "many" side is not standard UML, but don't worry about it, it's not important. The important thing is that the narrow representing the relationship at the `IEquipment` end displays the role (field) name (and even the exact type).

Navigate to the source code of `EquipmentInventory` and write the constructor that initializes the `equipment` collection:

```csharp
public EquipmentInventory()
{
    equipment = new List<IEquipment>();
}
```

Next, implement the `ListAll` method that prints each item’s age and current value:

```csharp
public void ListAll()
{
    foreach (IEquipment eq in equipment)
    {
        Console.WriteLine($"Age: {eq.GetAge()}\tPrice: {eq.GetPrice()}");
    }
}
```

Iterate through the elements using the `foreach` statement. The `in` keyword is followed by the collection, and before `in` is a variable declaration (in this case `IEquipment eq`) whose type matches the collection’s element type. In each iteration, this variable gets the current element from the collection.

The `Console.WriteLine` method can take a simple string or, as in our case, a formatting string. The substitutions are solved by string interpolation: the values to be substituted must be given between `{}`. If string interpolation is used, the string must start with `$`.

Write a function called `AddEquipment` that adds a new piece of equipment to the inventory:

```csharp
public void AddEquipment(IEquipment eq)
{
     equipment.Add(eq);
}
```

### Implementers of IEquipment

According to our earlier decision, we use the `IEquipment` interface to uniformly handle different part types. In our example, both `SoundCard` and `HardDisk` have `GetAge()` and `GetPrice()` methods, yet we cannot treat them uniformly (e.g., store them in a common list) because they do not actually implement `IEquipment`. Let’s fix that. Modify their declarations:

```csharp
public class SoundCard : IEquipment
```

```csharp
public class HardDisk : IEquipment
```

Then, in each class (`SoundCard` and `HardDisk`), we have to implement the methods defined by the `IEquipment` interface. In our case, `GetPrice` and `GetAge` are already implemented. That’s convenient.

As a test, in our `Main` function in `Program.cs`, create an `EquipmentInventory` object, add some `HardDisk` and `SoundCard` objects, and then list them. . If the current year is not 2021, replace 2021 shown below with your current year (and 2020 with one less than that):

```csharp
static void Main( string[] args )
{
    EquipmentInventory ei = new EquipmentInventory();

    ei.AddEquipment(new HardDisk(2021, 30000, 80));
    ei.AddEquipment(new HardDisk(2020, 25000, 120));
    ei.AddEquipment(new HardDisk(2020, 25000, 250));

    ei.AddEquipment(new SoundCard(2021, 8000));
    ei.AddEquipment(new SoundCard(2020, 7000));
    ei.AddEquipment(new SoundCard(2020, 6000));

    ei.ListAll();
}
```

Running the application, we can see that although our solution is still basic, it works:

![Console output](images/console-out-1.png)

Continue with the `LedDisplay` class. The `DisplayBase` source code cannot be modified due to requirements. But this doesn't cause any problems, our `LedDisplay` class will implement the `IEquipment` interface, so modify the code accordingly:

```csharp
public class LedDisplay : DisplayBase, IEquipment
```

In the `LedDisplay` class, we already need to implement the methods in the interface:

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

Let's extend our `Main` function by adding two `LedDisplay` objects to our set (again, if 2021 is not the current year, adjust the year in the following lines accordingly):

```csharp hl_lines="1 2"
ei.AddEquipment(new LedDisplay(2020, 80000, 17, 16));
ei.AddEquipment(new LedDisplay (2021, 70000, 17, 12));
        
ei.ListAll();
Console.ReadKey();
```

Test by running the application.

## Task 3 - Application of the interface and the abstract primitive class

### Interface problems

Let’s evaluate our current interface-based solution.

One main issue is that our code is full of code duplication that harms maintainability and extensibility:

- The `yearOfCreation` and `newPrice` fields are common to all part types (except the special `LedDisplay`), and must be copy-pasted when a new type is introduced.
- The implementation of the `GetAge` function is the same for all component types (except for the special `LedDisplay`), so we would copy-paste it again.
- The lines of the constructors that initialize `yearOfCreation` and `newPrice` are similarly duplicated.

Although this code duplication does not seem significant at the moment, the situation is getting worse as new component types are introduced, and it is better to prevent future pains in time.

Another problem arises because part listing is incomplete: we only see the item’s age and price, not its type. To display the type, the IEquipment interface must be extended, e.g. by introducing a method called `GetDescription`. Let's add a `GetDescription` function to the interface:

```csharp hl_lines="5"
public interface IEquipment
{
    double GetPrice();
    int GetAge();
    string GetDescription();
}
```

Then every class implementing the `IEquipment` interface would have to implement this method, which is a lot of work for many classes (and often not even feasible for a multi-component application, i.e. one with several DLLs, when they are not in the hands of a single developer). Run the *Build* command to check that after adding `GetDescription`, you get compilation errors in three places.

!!! tip "Default implementations in interfaces"
    INote that from C# 8 onward (and on .NET or .NET Core runtime, not supported under .NET Framework), **it’s possible to provide default implementations for interface methods (default interface methods), so to solve the above problem you don't need an abstract class, but you still cannot have instance fields in an interface**. More information here: [default interface methods](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/proposals/csharp-8.0/default-interface-methods).

    ```csharp hl_lines="5"
    public interface IEquipment
    {
        double GetPrice();
        int GetAge();
        string GetDescription() { return "EquipmentBase"; }
    }
    ```

### Abstract class

A solution to both problems is the introduction of a common abstract base class (except for the `LedDisplay` class, which we will come back to later). In this abstract base class, we can place the code common to all part types, and we can provide a default implementation of newly added `GetDescription` method. Let our new abstract base class be called `EquipmentBase`. The question is whether the `IEquipment` interface is still needed, or whether it can be completely replaced by the new `EquipmentBase` class. We need to keep the `IEquipment` interface, because we cannot derive our `LedDisplay` class from `EquipmentBase`: it already has a mandatory base class, `DisplayBase`. For this reason, `EquipmentInventory` in our enhanced solution also refers to the different components as `IEquipment` interface.

Let's begin the transformation. Let our class diagram be the active tab. From the *Toolbox*, add an *Abstract Class* element onto the diagram with drag&drop, and name it `EquipmentBase`.

![Toolbox - abstract class](images/toolbox-abstract-class.png)

In the following, we need to make the `SoundCard` and `HardDisk` classes derive from `EquipmentBase` (`LedDisplay` already has another base class, so we cannot do this there). To do this, select the *Inheritance* relationship in the *Toolbox*, then draw a line from the child class to the base class for both `SoundCard` and `HardDisk`.

In the next step, we want `EquipmentBase` to implement the `IEquipment` interface instead of `SoundCard` and `HardDisk` directly. To do this, modify the `EquipmentBase` class to implement the interface (either by drawing an inheritance link from `EquipmentBase` to `IEquipment` on the diagram, or by modifying the source code of `EquipmentBase`). Delete the implementation of `IEquipment` from the `HardDisk` and `SoundCard` classes (the base class already implements it).

The relevant parts of our diagram and source code will then look like this:

![EquipmentBase, HardDisk, and SoundCard](images/class-diagram-eqipmentbase-sc-hd-2.png)

```csharp
public abstract class EquipmentBase : IEquipment
```

```csharp
public class HardDisk : EquipmentBase
```

```csharp
public class SoundCard : EquipmentBase
```

The code won’t compile yet for several reasons. The `EquipmentBase` class implements the `IEquipment` interface, but it does not yet implement the interface methods. Either generate the methods using the smart tag, or type them according to the following principles:

- `newPrice` and `yearOfCreation` are duplicated in the `HardDisk` and `SoundCard` classes: move (not copy!) them to `EquipmentBase` and make them `protected`.
- The `GetAge` method is also duplicated in the `HardDisk` and `SoundCard` classes, delete the implementation from these and move it to the `EquipmentBase` class.
- The `GetPrice` method should be declared abstract in the base class. This is an intentional design choice, that forces each subclass to override this operation anyway.
- In the case of `GetDescription`, the opposite is true: we give an implementation in the base class marked as `virtual`(not `abstract`), so child classes are not forced to override it.

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

!!! tip "A few additional remarks on the code snippet:"

    - For abstract classes, the keyword `abstract` must be written before the word `class`.
    - For abstract methods, use the keyword `abstract`
    - .NET allows you to control whether methods are virtual or not. In this respect, it is similar to C++. To make a function virtual, the keyword `virtual` must be used. Reminder: define a method as virtual if it might be overridden by its descendants. This ensures if you call it via a reference to the base class, the child’s overridden method is invoked.

### Descendants

Next, we handle the `EquipmentBase` descendants. In C#, when overriding abstract or virtual methods in child classes, we must use the `override` keyword. First, override `GetPrice`:

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

In the next step, the `GetDescription` method is implemented in the `HardDisk` and `SoundCard` classes. Since the virtual function of the base class is being overridden here, the `override` keyword is needed:

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

One might ask why the designers of the C# language decided to add an extra keyword to the definition of methods, which was not necessary in the case of C++. The reason is simple: the code is more expressive. Looking at the descendant code, the word `override` clearly indicates that this operation is abstract or virtual in one of the base classes, without having to to search up the entire class hierarchy.

### Base class of LedDisplay

`LedDisplay` is forced to inherit from `DisplayBase`, whose code we can’t change, so it can’t inherit from `EquipmentBase`. This means we cannot remove the code duplication for `GetAge` from `LedDisplay`, this is preserved here (but only for `LedDisplay`, which is only one class among many!).

!!! note
    In fact, with a bit of extra work, we could avoid even that duplication by adding a static helper method in e.g. `EquipmentBase` that calculates the age based on its parameter containing the manufacturing year. Then both `EquipmentBase.GetAge` and `LedDisplay.GetAge` could call that helper method.

We still need to implement `GetDescription` in `LedDisplay`:

```csharp title="LedDisplay.cs"
public string GetDescription()
{
    return "Led Display";
}
```

Note that we do NOT write the `override` keyword here. When an interface function is implemented, `override` is not required/allowed to be written.

### Using GetDescription

Finally, let’s modify the `EquipmentInventory.ListAll` method so that the description of the items are also printed:

```csharp title="EquipmentInventory.cs"
public void ListAll()
{
    foreach (IEquipment eq in equipment)
    {
        Console.WriteLine($"Description: {eq.GetDescription()}\t" +
            $"Age: {eq.GetAge()}\tPrice: {eq.GetPrice()}");
    }
}
```

Now we get a more informative output:

![Console output](images/console-out-2.png)

### Constructor code duplication

If we review our code, there is still some duplication in our constructors. Each descendant of `EquipmentBase` (`HardDisk`, `SoundCard`) has the same lines in its constructor:

```csharp
 this.yearOfCreation = yearOfCreation;
 this.newPrice = newPrice;
```

If you think about it, these `yearOfCreation` and `newPrice` fields are defined in the base class, so it should be responsible for their initialization. Let's add a corresponding constructor in `EquipmentBase`:

```csharp title="EquipmentBase.cs"
public EquipmentBase(int yearOfCreation, int newPrice)
{
    this.yearOfCreation = yearOfCreation;
    this.newPrice = newPrice;
}
```

In the `HardDisk` and `SoundCard` constructors, remove the two lines that initialize those fields. Instead, call the base constructor via the `base` keyword:

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

By combining an interface and an abstract base class, we get a solution that involves the fewest compromises:

- Referencing parts through the `IEquipment` interface lets us handle all part types uniformly, including those with a required base class (`LedDisplay`). (With an abstract base class alone, we could not achieve this.)
- Introducing `EquipmentBase` as an abstract base class lets us move the shared code for various part types (except one) into a single place, avoiding duplication.
- Introducing `EquipmentBase` also lets us provide a default implementation for newly added methods in the `IEquipment` interface (e.g., `GetDescription`), so we are not forced to define them in every implementer of `IEquipment`.

Finally, let's take a look at the UML (like) class diagram of our solution:

![Final class diagram](images/class-diagram-final.png)

!!! note "C# 11 – Static interfaces"
    A new feature in C# 11 is the ability to define static interface members, so that a class implementing the interface must provide certain static members. [More info](https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/tutorials/static-virtual-interface-members)

### Note - optional homework practice

In our current solution, component-specific data (e.g. capacity for `HardDisk`) is not displayed when listing the parts. To accomplish that, the formatting of component data as a string should be moved from `EquipmentInventory` into the component classes, following the principles below:

- We could add a `GetFormattedString` method to the `IEquipment` interface that returns a string. Alternatively, we could override `ToString()`, since in .NET every type implicitly inherits from `System.Object`, which has a virtual `ToString()` method.
- In `EquipmentBase`, we could implement the formatting of common fields (description, price, age) into a string.
- If a component also has type-specific data, then its class overrides the function that formats it into a string: this function must first call its ancestor (using the `base` keyword), then append its own formatted data to it, and return with this string.
