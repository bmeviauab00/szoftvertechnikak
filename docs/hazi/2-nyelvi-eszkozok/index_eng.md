---
authors: BenceKovari,bzolka
---

# 2nd Homework - language tools

## Introduction

This independent assignment builds on the content presented in the [2nd Lab - Language Tools](../../labor/2-nyelvi-eszkozok/index_eng.md) lab session.

Based on the above, the tasks in this independent exercise can be completed with the guidance provided after the task descriptions.

Goals of the independent exercise:

- Practicing the use of properties
- Applying delegates and events
- Practicing the use of .NET attributes
- Utilizing basic collection types
- Practicing lambda expressions

A description of the necessary development environment can be found [here](../fejlesztokornyezet/index_eng.md).

!!! warning "Usage of C# 12 (and newer) language features" 
    When solving the homework, C# 12 and newer language features (e.g., primary constructor) must not be used, as the verification system running on GitHub does not yet support them.

## Submission Process & Pre-evaluation

The submission process is the same as for the first homework (detailed instructions can be found at the usual location, see [Homework Workflow and Using Git/GitHub](../hf-folyamat/index_eng.md)):

1. Use GitHub Classroom to create a repository for yourself. The invitation URL can be found in the notification message or post (see Teams or Neptun). It is important to use the correct invitation URL corresponding to this homework assignment (each homework has a different URL).
2. Clone the newly created repository. This will contain the expected structure of the solution.
3. After completing the tasks, commit and push your solution.

The pre-evaluation process also works as usual. Detailed instructions: [Pre-evaluation and official grading of the homework](../eloellenorzes-ertekeles/index_eng.md).

## Task 1 – The Phantom Menace

### Task

As is widely known, Jedi knights derive their power from small life forms living in their cells, called midi-chlorians. The highest midi-chlorian level ever recorded (above 20,000) was measured in Anakin Skywalker.

Create a class named `Jedi`, which has a `string` type property `Name` and an `int` type property `MidiChlorianCount`.
For the latter, ensure that the `MidiChlorianCount` value cannot be set to 35 or lower. If someone attempts this, the class must throw an exception.
For validation, choose the simplest and cleanest solution: use a simple `if` statement in the property setter and throw an exception. The `if` statement should not have an `else` branch, and there is no need to use `return`.

## Solution

The task can be solved in a manner similar to [Lab 2, Task 1](../../labor/2-nyelvi-eszkozok/index_eng.md).
In the `MidiChlorianCount` property setter, throw an exception if an invalid value is provided. This can be done using the following statement:

```csharp
throw new ArgumentException("You are not a true Jedi!");
```

## Task 2 – Attack of the Clones

### Task

Extend the class created in Task 1 with attributes so that when a `Jedi` object is serialized into an XML file using the `XmlSerializer` class, its properties appear as XML attributes in Hungarian.
Then, write a function that serializes an instance of the `Jedi` class into a text file and then reads it back into a new object (effectively cloning the original object).

!!! tip "XML Serializer Attributes"
    Place the XML serialization attributes above the properties, not the member variables!

!!! tip "The Jedi Class Must Be Public"
    The XML serializer can only process public classes, so ensure that the `Jedi` class is public:
    ```csharp
    public class Jedi { ...}
    ```

!!! danger "Important"
    Write the save and load demonstration code in a dedicated function, and annotate it with the `[Description("Task2")]` C# attribute (this should be placed in the line before the function declaration).
    The saved/loaded object should be implemented as a local variable within this function.
    The class/function name can be anything (e.g., it can be placed inside the `Program` class).
    The function should contain only the relevant code and should not include unrelated subtasks.
    Call this function from the `Main` function of the `Program` class.
    To use the above attribute, you need to include the `System.ComponentModel` namespace.

    Key requirements:

    - The attribute should be placed above a function, NOT a class.
    - The attribute should be applied to the function that performs testing, not the one implementing the logic.
    - **The attribute should only appear above one function.**

### Solution

The solution follows the approach of [Lab 2, Task 4](../../labor/2-nyelvi-eszkozok/index_eng.md).
We provide the following guidance:

- After serialization, the XML file should look like this:

    ```xml
    <?xml version="1.0"?>
    <Jedi xmlns:xsi="..." Nev="Obi-Wan" MidiChlorianSzam="15000" />
    ```

    It is essential that each Jedi appears as a `Jedi` XML element, their name as `Nev`, and their midi-chlorian count as `MidiChlorianSzam` XML attributes.

- Since we did not examine example code for deserializing objects during the lab, we provide one here:

    ```csharp
    var serializer = new XmlSerializer(typeof(Jedi));
    var stream = new FileStream("jedi.txt", FileMode.Open);
    var clone = (Jedi)serializer.Deserialize(stream);
    stream.Close();
    ```

    The above code first creates a serializer (`serializer`), which is later used for reading the data.
    The reading operation is performed from a file named `jedi.txt`, which is opened in the second line for reading (note that if we intended to write to it, we would have needed to specify `FileMode.Create`).

## Task 3 – Revenge of the Sith

### Task

The Jedi Council has been experiencing high turnover recently.
To track changes more easily, create a class that keeps a record of council members and sends text notifications about any changes via an event!
The list should be modified with two functions.
The `Add` function should register a new Jedi knight in the council, while the `Remove` function should remove the **last** added council member.
A separate notification should indicate when the council becomes empty (use the same event as for other changes, but with a different message).

The council members (`members`) should be stored in a `List<Jedi>` member variable. The `Add` function should append new elements to this list, while the `Remove` function should always remove the **last** added member using the generic list's `RemoveAt` method (the index of the last element can be determined from the list length, which is provided by the `Count` property).

Notifications should be handled via a C# event. The event delegate type should take a simple `string` as a parameter. Adding a new member, removing individual members, and removing the last member should each trigger a different message. Fire the event directly within the `Add` and `Remove` methods (do not introduce a helper function for this).

Do not use a built-in delegate type for the event; instead, define a custom one.

!!! danger "Important"
      The code for creating and testing the Jedi Council object (subscribing to its C# event, calling `Add` and `Remove`) should be placed in a single dedicated function, which should be annotated with the `[Description("Task3")]` C# attribute.
      The class/function name can be anything.
      The function should contain only code relevant to this task and should not include other subtasks.
      Call this function from the `Main` function of the `Program` class.

      Key requirements:

      - The attribute should be placed above a function, NOT a class.
      - The attribute should be applied to the function that performs testing, not the one implementing the logic.
      - The attribute should only appear above a single function.

### Solution

The solution builds on several parts of Lab 2. The introduction of the new event should follow the approach described in Tasks 2 and 3, while council members should be stored in a list.

Try solving the task independently based on the above information. Once finished, compare your solution with the reference solution provided in the expandable section below!
Adjust your solution as needed.

!!! tip "Public Visibility"
    The example assumes that the involved classes, properties, and delegates have public visibility.
    If you encounter strange compilation errors or if `XmlSerializer` throws a runtime error, first check that all relevant elements have the appropriate public visibility settings.

??? example "Reference Solution"
    The steps for the reference solution are as follows:

    1. Create a new class named `JediCouncil`.
    2. Add a `List<Jedi>` type field and initialize it with an empty list.
    3. Implement the `Add` and `Remove` functions.

        After completing these steps, the following code is obtained:

        ```csharp
        public class JediCouncil
        {
            List<Jedi> members = new List<Jedi>();

            public void Add(Jedi newJedi)
            {
                members.Add(newJedi);
            }

            public void Remove()
            {
                // Removes the last member of the list
                members.RemoveAt(members.Count - 1);
            }
        }
        ```

        Next, implement event handling.

    4. Define a new delegate type (outside the class, as it is a type) that will pass notification messages:

        ```csharp
        public delegate void CouncilChangedDelegate(string message);
        ```

    5. Extend the `JediCouncil` class with the event handler:

        ```csharp hl_lines="3"
        public class JediCouncil
        {
            public event CouncilChangedDelegate CouncilChanged;

            // ...
        }
        ```

    6. Trigger the event when a new council member is added. To do this, modify the `Add` method.

        ```csharp
        public void Add(Jedi newJedi)
        {
            members.Add(newJedi);

            // TODO: Trigger the event here.
            // Ensure it is only triggered if at least one subscriber is present.
            // Use the modern ?.Invoke approach instead of verbose null checking.
        }
        ```

    7. Trigger the event when a council member leaves! Differentiate the case when the council becomes completely empty. To do this, modify the `Remove` method.

        ```csharp
        public void Remove()
        {
            // Removes the last member of the list
            members.RemoveAt(members.Count - 1);

            // TODO: Trigger the event here.
            // Ensure it is only triggered if at least one subscriber is present.
        }
        ```

    8. To test our solution, add a `MessageReceived` function in the class where you want to test event subscription and handling (e.g., the `Program` class). This function will subscribe to `JediCouncil` notifications.

        ```csharp title="Program.cs"
        private static void MessageReceived(string message)
        {
            Console.WriteLine(message);
        }
        ```

    9. Finally, test our new class by writing a dedicated function (this can be in the `Program` class). Add the `[Description("Task3")]` attribute above the function! The function template:

        ```csharp
        // Create the council
        var council = new JediCouncil();
        
        // TODO: Subscribe to the CouncilChanged event of the council
        
        // TODO: Add two Jedi objects to the council using the Add method

        council.Remove();
        council.Remove();
        ```

    10. If everything is implemented correctly, the following output should appear when the program is executed:

        ```text
        A new member has joined
        A new member has joined
        I sense a disturbance in the Force
        The council has fallen!
        ```

!!! tip "Null Checking for Events"
    If you used explicit `null` checks in `JediCouncil.Add` to determine whether there is at least one subscriber, update your approach to the more modern `?.Invoke` method, which performs the same check in a more concise manner without explicit `null` validation. This change is required for `JediCouncil.Add`, but for `JediCouncil.Remove`, both approaches are acceptable.

## Task 4 – Delegates

### Task

Extend the `JediCouncil` class with a parameterless function (**the function name must end with `_Delegate`, this is mandatory**) that returns all members of the Jedi Council whose midi-chlorian count is **below 530**!

- Use a function, not a property, for the query.
- Within the function, use the `FindAll()` method of the `List<Jedi>` class to filter members.
- In this task, you are **NOT allowed to use lambda expressions**!

Write a dedicated "test" function (e.g., in the `Program` class) that calls the above function and prints the names of the returned Jedi knights! This function should contain only the relevant test code and should not include unrelated subtasks.

!!! danger "Important"
    Annotate this "test" function with `[Description("Task4")]` in C#. Call this function from the `Main` function of the `Program` class.

    Key requirements:

    - The attribute should be placed above a function, NOT a class.
    - The attribute should be applied to the function that performs testing, not the one implementing the logic.
    - The attribute should only appear above a single function.

!!! tip "Extract Initialization"
    Introduce a separate static method (e.g., in the `Program` class) that takes a `JediCouncil` object as a parameter and adds at least three initialized `Jedi` objects using the `Add` method.
    The goal is to have an initialization method that can be reused in later tasks, avoiding redundant initialization code.

### Solution

The solution follows the approach of Lab 2, Task 6. Here are some guidelines:

- The function may return multiple results, so its return type should be `List<Jedi>`.
- The `FindAll` method expects a filtering function with the signature `bool FunctionName(Jedi j)`.


## Task 5 – Lambda Expressions

This task is similar to the previous one, but now we will use lambda expressions. This topic was covered in both lectures and labs ([Lab 2, Task 6](../../labor/2-nyelvi-eszkozok/index_eng.md)).

Extend the `JediCouncil` class with a parameterless function (**the function name must end with `_Lambda`, this is mandatory**) that returns all members of the Jedi Council whose midi-chlorian count is **below 1000**!

- Use a function, not a property, for the query.
- Within the function, use the `FindAll()` method of the `List<Jedi>` class to filter members.
- You **must** use a lambda expression (either a statement or an expression lambda)!

Write a dedicated "test" function (e.g., in the `Program` class) that calls the above function and prints the names of the returned Jedi knights!  
This function should contain only the relevant test code and should not include unrelated subtasks.

!!! danger "Important"
    Annotate this "test" function with `[Description("Task5")]` in C#. Call this function from the `Main` function of the `Program` class.

    Key requirements:

    - The attribute should be placed above a function, NOT a class.
    - The attribute should be applied to the function that performs testing, not the one implementing the logic.
    - The attribute should only appear above a single function.


## Task 6 – Using `Action`/`Func`

Follow the detailed instructions. This topic was not covered in the lab (due to time constraints), but it is an essential topic in the course.

Add `Person` and `ReportPrinter` classes to the project (each in a separate file named after the class, within the default `ModernLangToolsApp` namespace) with the following content:

??? tip "Person and ReportPrinter Classes"


    ```csharp   
    class Person
    {
        public Person(string name, int age)
        {
            Name = name;
            Age = age;
        }

        public string Name { get; set; }
        public int Age { get; set; }
    }
    ```

    ```csharp   
    class ReportPrinter
    {
        private readonly IEnumerable<Person> people;
        private readonly Action headerPrinter;

        public ReportPrinter(IEnumerable<Person> people, Action headerPrinter)
        {
            this.people = people;
            this.headerPrinter = headerPrinter;
        }

        public void PrintReport()
        {
            headerPrinter();
            Console.WriteLine("-----------------------------------------");
            int i = 0;
            foreach (var person in people)
            {
                Console.Write($"{++i}. ");
                Console.WriteLine("Person");
            }
            Console.WriteLine("--------------- Summary -----------------");
            Console.WriteLine("Footer");
        }
    }
    ```

This `ReportPrinter` class is used to generate a formatted report in the console for the persons provided in its constructor, structured in a header/data/footer format.  
Add the following function to the `Program.cs` file to test the `ReportPrinter`, and call this function from the `Main` function:

??? tip "Testing ReportPrinter"

    ```csharp   
    [Description("Task6")]
    static void test6()
    {
        var employees = new Person[] { new Person("Joe", 20), new Person("Jill", 30) };

        ReportPrinter reportPrinter = new ReportPrinter(
            employees,
            () => Console.WriteLine("Employees")
            );

        reportPrinter.PrintReport();
    }
    ```

Run the application. The following output will appear in the console:

```
Employees
-----------------------------------------
1. Person
2. Person
--------------- Summary -----------------
Footer
```
The first row above the "----" represents the header. Below, each person is displayed with a hardcoded "Person" text, followed by the footer section below the "----", which currently only contains a hardcoded "Footer" text.

In the solution, you can see that the header text is not hardcoded inside the `ReportPrinter` class. Instead, the `ReportPrinter` user provides it through the constructor as a delegate, in this case, a lambda expression. The delegate type used is the built-in .NET `Action` type.

Tasks are the following:

!!! warning
    You MUST NOT use a custom delegate type in this solution. Only the built-in .NET delegate types are allowed; otherwise, the solution will not be accepted.

1. Modify the `ReportPrinter` class so that the user can specify not only the header but also the footer as a delegate in the constructor.
   
2. Further modify the `ReportPrinter` class so that instead of displaying the fixed "Person" text for each individual, the user of `ReportPrinter` can specify how each person's data is displayed in the console using a delegate provided in the constructor.  It is **important** that the serial number at the beginning of each row must always be displayed and cannot be modified by the `ReportPrinter` user. This means that `ReportPrinter` itself must handle this output.

    !!! tip "Solution Approach"
        Use a similar approach as for the header and footer, but ensure that the `ReportPrinter` user receives the person object so they can format and display the data appropriately.

3. Modify the `ReportPrinter` usage in `Program.cs` (using appropriate lambda expressions) so that the console output looks like this:

    ```
    Employees
    -----------------------------------------
    1. Name: Joe (Age: 20)
    2. Name: Jill (Age: 30)
    --------------- Summary -----------------
    Number of Employees: 2
    ```
    
    !!! tip "Displaying the Employee Count in the Footer"
        To properly display the number of employees in the footer, you will need to understand "variable capturing" (covered in Lecture 3 under "Variable Capturing, Closure").

    !!! warning "Homework Evaluation"
        The automatic GitHub checker does NOT verify whether you correctly modified `ReportPrinter` and its usage for "Task 6". Be sure to thoroughly test your solution so that any issues do not only become apparent during manual homework evaluation after the deadline.  
        *(Update: Since March 13, 2024, partial automatic verification is available for this task.)*

4. The following task is optional but provides a good opportunity to practice using the built-in `Func` delegates.  
   One major limitation of the `ReportPrinter` class is that it only allows the output report to be displayed on the console. A more flexible solution would allow generating the report as a string instead, which could then be used as needed (e.g., written to a file).

    The task is as follows: introduce a `ReportBuilder` class modeled after `ReportPrinter`, but instead of writing to the console, it should generate a string containing the entire report, which can be retrieved using a new `GetResult()` method.

    !!! warning "Submission"
        If you submit this task, do not include the instantiation/testing code for `ReportBuilder` in the `test6` function. Instead, introduce a `test6b` function and annotate it with `[Description("Task6b")]`.

    !!! tip "Solution Hints"
        * Introduce a `StringBuilder` field in the class to handle string operations efficiently. This is significantly more efficient than concatenating strings using `"+"`.
        * The `ReportBuilder` user should not write directly to the console but should provide formatted strings to `ReportBuilder` using built-in delegate types (in this case, `Action` is not suitable). Use lambda expressions for testing as well.

## Submission

Checklist:

--8<-- "docs/hazi/beadas-ellenorzes/index_eng.md"