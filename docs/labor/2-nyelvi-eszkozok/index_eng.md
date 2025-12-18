---
authors: BenceKovari,bzolka,tibitoth
---

# 2. Language tools

## The aim of the laboratory

During this laboratory, students will become familiar with the most important modern language tools available in the .NET environment. We assume that the student has already acquired an object-oriented mindset in previous studies and is familiar with the fundamental concepts of object-oriented programming. In this laboratory, we focus on .NET language features that go beyond general object-oriented principles, but significantly contribute to writing clear and maintainable code. These include:

- Property
- Delegate (method reference)
- Event
- Attribute
- Lambda expression
- Generic type
- A few additional language constructs

Related lectures: Lecture 2 and the beginning of Lecture 3 – Language Tools.

## Prerequisites

Tools needed to complete the laboratory:

- Visual Studio 2026

!!! tip "Exercise on Linux or macOS"
    The exercise material is primarily designed for Windows and Visual Studio, but it can also be completed on other operating systems using different development tools (e.g., VS Code, Rider), or even with a text editor and CLI (command-line) tools. This is possible because the examples are presented in the context of a simple Console application (without Windows-specific elements), and the .NET SDK is supported on Linux and macOS. [Hello World on Linux](https://learn.microsoft.com/en-us/dotnet/core/tutorials/with-visual-studio-code)

## Introduction

!!! tip "Additional insights"
    This guide provides extended knowledge and extra explanations in sections framed with the same color and marked with the same icon as this note. These are useful insights but are not part of the core learning material.

## Solution

??? success "Download the completed solution"
    :exclamation: It is essential to work following the instructor during the lab, it is forbidden (and pointless) to download the final solution. However, during subsequent independent practice, it can be useful to review the final solution, so we make it available.

    The solution is available on [GitHub](https://github.com/bmeviauab00/lab-nyelvieszkozok-megoldas). The easiest way to download it is to clone it to your computer via the command line using the git clone command:

    `git clone https://github.com/bmeviauab00/lab-nyelvieszkozok-megoldas`

    To do this, Git must be installed on your machine. More information can be found [here](../../hazi/git-github-github-classroom/index_eng.md#git-installation).

## Task 0 - var keyword - Implicitly typed local variables

We'll start with a simple warm-up exercise. In the following example, we will create a class named `Person`, which represents a person.

1. Create a new C# console application using .NET (not .NET Framework):
    - We saw an example of this in the first laboratory, and its description is included in that guide.
    - Check the "*Do not use top-level statements*" checkbox during project creation.
2. Add a new class to our application named `Person`. (To add a new class, right-click on the project file in the Solution Explorer and select the *Add / Class* option. In the pop-up window, change the file name to `Person.cs` and click the Add button.)
3. Make the class public. To do this, add the `public` keyword before the class name. While this modification is not necessary at this stage, a later task will require a public class.

    ```csharp
    public class Person
    {
    }
    ```

4. Extend the `Main` function in the `Program.cs` file to test our new class.

    ```csharp
    static void Main(string[] args)
    {
        Person p = new Person();
    }
    ```

5. Instead of explicitly specifying the type of **local** variables, we can also use the `var` keyword:

    ```csharp
    static void Main(string[] args)
    {
        var p = new Person();
    }
    ```

    This is called **implicitly typed local variables**. In this case, the compiler tries to infer the type of the variable from the context, specifically from the right side of the equal sign, which in this example is a `Person`. It's important to note that the language is still strongly/static typed (it does **not** work like the `var` keyword in JavaScript), because the type of the `p` variable remains fixed and cannot change later. This is only a syntactic sugar to make local variable definitions more concise (so that we don’t have to specify the type on both the left and right sides of `=`).

    !!! note "Target-typed `new` expressions"
        Another approach introduced in C# 9 is Target-typed `new` expressions, where the type can be omitted when using the `new` operator if it can be inferred from the context (e.g., the left-hand side of an assignment, parameter type, etc.). Our `Person` constructor would look like this:

        ```csharp
        Person p = new();
        ```

        The advantage of this approach over `var` is that it can also be used for member variables.

## Task 1 – Property

Properties are typically used (although, as we will see, not exclusively) to access class member variables in a way that is syntactically similar to accessing traditional member variables. However, instead of simply read or setting a value, properties allow us to implement access behavior in a method-like manner, and we can even separately define the visibility of the getter and setter.

### Property syntax

In the following example, we will create a `Person` class that represents a person. It has two member variables: `name` and `age`. These member variables are private, meaning they cannot be accessed directly. Instead, they are managed through the public properties `Name` and `Age`. **This example clearly demonstrates that .NET properties are functionally equivalent to the `SetX(…)` and `GetX()` methods known from C++ and Java, but in a more encapsulated and language-supported way**.

1. In the previously introduced `Person` class, create a private member variable `age` of type `int` and an `Age` property that enables the access to this variable.

    ```csharp
    public class Person
    {
        private int age;
        public int Age
        {
            get { return age; }
            set { age = value; }
        }
    }
    ```

    !!! tip "Visual Studio snippets"
        Although we manually typed the full property during the lab for practice, but Visual Studio provides code snippets for creating frequently occurring code fragments which allow us to use common language constructs as templates. The property definition above can be inserted using the `propfull` snippet. Type the name of the snippet (`propfull`) and press the ++tab++ key (typically twice) to activate it.

        Some other useful snippets include:

        - `ctor`: constructor
        - `for`: for loop
        - `foreach`: foreach loop
        - `prop`: auto property (see later)
        - `switch`: switch statement
        - `cw`: Console.WriteLine

        We can even create our own [snippets](https://learn.microsoft.com/en-us/visualstudio/ide/walkthrough-creating-a-code-snippet).

2. Modify the `Main` function in the `Program.cs` file to test the new property.

    ```csharp hl_lines="4 6"
    static void Main(string[] args)
    {
        var p = new Person();
        p.Age = 17;
        p.Age++;
        Console.WriteLine(p.Age);
    }
    ```

3. Run the program (++f5++).

    We can see that the property is used similarly to a member variable. When querying the property, the **`get`** part is executed, and the property's value is the returned value. When setting the property, the **`set`** part is executed, where the special `value` variable contains the assigned value.

    Notice how easily we can increment the age by one. In Java or C++, a similar operation would be written as `p.setAge(p.getAge() + 1)`, which is more complicated and less readable. The main benefit of using properties is that our code becomes syntactically cleaner, and property assignments/accesses are clearly distinguished from function calls.

4. Check that the program actually calls the `get` and `set` methods by placing breakpoints inside the getter and setter blocks. Click on the gray margin in the editor to set a breakpoint.
5. Run the program step by step. Instead of pressing ++f5++, start the program with ++f11++, then press ++f11++ repeatedly to execute it line by line.

    We can see that the program calls the getter whenever a value is queried and the setter whenever a value is assigned.

6. One important feature of setter functions is that they allow input validation. Modify the `Age` property’s setter to enforce a constraint.

    ```csharp
    public int Age
    {
        get { return age; }
        set 
        {
            if (value < 0)
                throw new ArgumentException("Invalid age!");
            age = value; 
        }
    }
    ```

    Notice that while simple getters and setters are kept on a single line, more complex logic is formatted across multiple lines.

7. To test the validation, assign a negative age in the `Main` function of the `Program` class.

    ```csharp
    p.Age = -2;
    ```

8. Run the program and verify that the validation correctly prevents invalid age values. Then, fix the issue by setting a positive age.

    ```csharp
    p.Age = 2;
    ```

### Auto-implemented property

In everyday development, we often encounter a more concise syntax for properties. This syntax can be used when:

- We do not need any additional logic in the getter and setter methods.
- We do not need direct access to the private member variable.

Let's look at an example.

1. Extend the `Person` class with an **auto-implemented property**. Create a `string` property called `Name`.

    ```csharp
    public string Name { get; set; }
    ```

    The difference in syntax compared to previous examples: we did not provide implementations for the `get` and `set` blocks (no curly braces). In the case of an auto-implemented property, the compiler generates a hidden, inaccessible field within the class to store the current value of the property. It is important to note that this does **not** set or retrieve the previously introduced `name` field (which could be deleted), but instead works with a newly generated hidden variable!

2. Now, test its functionality by modifying the `Main` function.

    ```csharp hl_lines="4 6"
    static void Main(string[] args)
    {
        // ...
        p.Name = "Luke";
        // ...
        Console.WriteLine(p.Name);
    }
    ```

### Default value

Auto-implemented properties can also have an initial value assigned during declaration.

1. Set an initial value for the `Name` property.

    ```csharp
    public string Name { get; set; } = "anonymous";
    ```

### Property visibility

Besides the ability to fully customize their implementation, a key advantage of properties is that the visibility of the getter and setter can be controlled separately.

1. Set the `Name` property’s setter to private.

    ```csharp
    public string Name { get; private set; }
    ```

    In this case, the `p.Name = "Luke";` statement in the `Program` class will cause a compilation error. The general rule is that both the getter and setter inherit the property's visibility, which can be further restricted but not relaxed.
    
    Visibility control can be used for both auto-implemented and manually implemented properties.

2. Restore the visibility (remove the `private` keyword from the `Name` property’s setter) to eliminate the compilation error.

### Readonly property

The setter can be omitted, resulting in a readonly property. In the case of an auto-implemented property, a readonly property can still be assigned an initial value, but only within the constructor or by providing a default value (as shown above). This is different from properties with a private setter, which can still be modified by any method within the class.

Here are examples of defining readonly properties (DO NOT implement this in your code):

a) Auto-implemented case

```csharp
public string Name { get; }
```

b) Not auto-implemented case

```csharp
private string name;
...
public string Name { get {return name; } }
```

### Calculated value

Properties that only have a getter can also be used to determine a computed/calculated value. These properties always calculate a value based on a given logic, but unlike "readonly properties", they do not have a directly associated backing field. The following code snippet illustrates this concept (DO NOT introduce it into our code):


```csharp
public int AgeInDogYear { get { return Age * 7; } }
```

## Task 2 – Delegate (method reference)

!!! danger "Ensure the code compiles!"  
    The following tasks will build on the results of the previous ones. If your program does not compile or does not function correctly, inform your instructor at the end of the tasks, and he/she will help you fix the issue.  

Delegates represent strongly typed method references in .NET, serving as a modern equivalent to function pointers in C/C++. A delegate allows us to define a variable type that can reference methods. However, similar to C++ function pointers, they can only reference methods whose type (parameter list and return value) matches the delegate type. When the delegate variable is "invoked", the assigned (registered) method is automatically called. One advantage of using delegates is that they allow us to decide at runtime which method to call among multiple options.  

Some examples of delegate usage:  

- Passing a comparison function as a parameter to a universal sorting function,  
- Implementing a universal filtering logic on a general collection, where the function deciding whether an element should be included in the filtered list is passed as a delegate,  
- Implementing the publish-subscribe pattern, where certain objects notify other objects about events related to them.  

In our next example, we will enable objects of the previously created `Person` class to freely notify other class objects when a person's age changes. To achieve this, we introduce a delegate type (`AgeChangingDelegate`), which, in its parameter list, can pass the current and new age of the person. We then create a public `AgeChangingDelegate`-typed member variable in the `Person` class, allowing an external entity to specify the function through which it requests notifications about changes in the given `Person` instance.  

1. Create a new **delegate type** that can reference a function with `void` return type and expecting two `int` parameters. Ensure that the new type is defined in the namespace scope, right before the `Person` class!  

    ```csharp hl_lines="3"
    namespace PropertyDemo
    {
        public delegate void AgeChangingDelegate(int oldAge, int newAge);

        public class Person
        {
            // ...
    ```

    The `AgeChangingDelegate` is a **type** (note its syntax highlighting in Visual Studio), which can be used anywhere a type is allowed (e.g., it can be used to declare member variables, local variables, function parameters, etc.).  

2. Enable `Person` objects to reference any function that matches the above signature. To do this, create an `AgeChangingDelegate`-typed member variable in the `Person` class!  

    ```csharp hl_lines="3"
    public class Person
    {
        public AgeChangingDelegate AgeChanging;
    ```

    !!! warning "How object-oriented is this?"  
        Declaring a method reference as a public member variable actually (for now) violates object-oriented encapsulation and information-hiding principles. We will revisit this issue later.  

3. Call the function every time the person's age changes. To do this, extend the `Age` property setter with the following:

    ```csharp hl_lines="8-9"
    public int Age
    {
        get { return age; }
        set 
        {
            if (value < 0)
                throw new ArgumentException("Invalid age!");
            if (AgeChanging != null)
                AgeChanging(age, value);
            age = value; 
        }
    }
    ```

    The above code demonstrates several important principles:

    - Validation logic generally precedes notification logic.
    - Depending on the nature of the notification logic, it may run before or after the assignment (in this case, since the word "changing" implies an ongoing process, the notification precedes the assignment; "changed" would indicate the event has already occurred).
    - We must be prepared for the possibility that no value has been assigned to the delegate-type member variable yet (i.e., there are no subscribers). Calling it in such cases would cause an exception, so we must always check if the member variable is `null` before invoking it.
    - When triggering the event, the `null` check can be done in a more elegant, concise, and thread-safe manner using the "`?.`" null-conditional operator (available from C# 6):

    ```csharp
    if (AgeChanging != null)
        AgeChanging(age, value);
    ```

    can be replaced with:

    ```csharp
    AgeChanging?.Invoke(age, value);
    ```

    This will only trigger the event if it is not `null`; otherwise, it does nothing.

   - Strictly speaking, we should only trigger the event if the age actually changes. In the property setter, we should check if the new value is the same as the old one. A solution is to return immediately at the beginning of the setter if the new value equals the old one:

    ```csharp
    if (age == value) 
        return;
    …
    ```

4. We have completed the `Person` class code. Now, let's move on to the subscriber! First, we need to extend the `Program` class with a new function.

    ```csharp hl_lines="5-8"
    class Program
    {
        // ...

        private static void PersonAgeChanging(int oldAge, int newAge)
        {
            Console.WriteLine(oldAge + " => " + newAge);
        }
    }
    ```

    !!! warning "Tip"
        Make sure to place the new function in the correct scope! While we placed the delegate type outside the class (but inside the namespace), we place the function inside the class!

5. Finally, subscribe to the change tracking in the `Main` function.

    ```csharp hl_lines="4"
    static void Main(string[] args)
    {
      Person p = new Person();
      p.AgeChanging = new AgeChangingDelegate(PersonAgeChanging);
      // ...
    ```

6. Run the program!

    For example, place a breakpoint on the line `AgeChanging?.Invoke(age, value);`, run the application in debug mode, and step through the code to observe that the event is triggered every time the setter runs, including the initial assignment and increments.

7. Extend the `Main` function to subscribe multiple times (use the `+=` operator to add additional subscribers), then run the program.

    ```csharp hl_lines="2-3"
    p.AgeChanging = new AgeChangingDelegate(PersonAgeChanging);
    p.AgeChanging += new AgeChangingDelegate(PersonAgeChanging);
    p.AgeChanging += PersonAgeChanging; // More concise syntax
    ```

    Notice that every time the value changes, all three registered/"subscribed" functions execute. This is because delegate-type member variables do not merely store a single function reference but actually maintain a **list of function references**.

    Observe in the third line above that function references can be written in a more concise syntax than previously seen: we simply provide the function name after the `+=` operator without `new AgeChangingDelegate(...)`. However, behind the scenes, an `AgeChangingDelegate` object still wraps the `PersonAgeChanging` function. In practice, this more concise syntax is preferred.

8. Try unsubscribing at any chosen point, then run the program.

    ```csharp
    p.AgeChanging -= PersonAgeChanging;
    ```

## Task 3 – Event

Just as properties provide a cleaner alternative to getter and setter methods, the delegate mechanism we saw earlier offers a more refined syntax compared to Java's Event Listeners. However, our previous solution still violates several key object-oriented principles (encapsulation, information hiding). We can demonstrate these issues with the following two examples.

1. The event can actually be triggered externally (by operations in other classes). This is problematic because it allows false event triggers with incorrect data, misleading all subscribers. To illustrate this issue, insert the following line at the end of the `Main` function:

    ```csharp
    p.AgeChanging(67, 12);
    ```

    Here, we have triggered an invalid age change event on the `p` `Person` object, misleading all subscribers. The correct solution would be to ensure that only `Person` class operations can trigger the event.

2. Another issue arises because, although `+=` and `-=` respect the list of subscribed functions, the `=` operator allows complete overwriting (and deletion) of other subscriptions. Try this by inserting the following line (right after the subscription and unsubscription lines):

    ```csharp
    p.AgeChanging = null;
    ```

3. Use the `event` keyword to modify the `AgeChanging` member variable in `Person.cs`:

    ```csharp title="Person.cs"
    public event AgeChangingDelegate AgeChanging;
    ```

    The aim of the `event` keyword is to enforce object-oriented principles by preventing the two issues described above.

4. Try compiling the program. We will notice that the compiler now treats our previous violations as compilation errors.

    ![event errors](images/event-errors.png)

5. Remove the three incorrect lines (note that even the first direct assignment is now an error), then recompile and run the application!

## Task 4 – Attributes

### Customizing serialization with attributes

**Attributes allow us to declaratively add metadata to our source code.** An attribute is essentially a class that we attach to a specific program element (such as a type, class, interface, method, etc.). These metadata can be read at runtime using the reflection mechanism. Attributes in .NET are similar to annotations in Java.

!!! tip "property vs. attribute vs. static"
    A common question is whether a class characteristic should be defined as a property or an attribute. Properties relate to the instance of an object, whereas attributes describe the class itself (or one of its members).

    In this sense, attributes are closer to static properties, but it is still worth considering whether to define a given piece of data as a static member or an attribute. Attributes provide a more declarative approach, preventing unnecessary details from appearing in the public interface of a class.

.NET defines numerous **built-in** attributes with various functionalities. The attributes in the following example communicate metadata to the XML serializer.

1. Insert the following code snippet at the end of the `Main` function and run the program:

    ```csharp
    var serializer = new XmlSerializer(typeof(Person));
    var stream = new FileStream("person.txt", FileMode.Create);
    serializer.Serialize(stream, p);
    stream.Close();
    Process.Start(new ProcessStartInfo
    {
        FileName = "person.txt",
        UseShellExecute = true,
    });
    ```

    The `Process.Start` function call above is not part of the serialization logic, it simply opens the generated file in the default text viewer on Windows. This may not work in all environments due to OS or .NET runtime limitations. If an error occurs, comment out this part and manually locate and open the `person.txt` file (found in the *\bin\Debug\* folder alongside the executable).

2. Examine the generated XML file structure. Notice how each property is mapped to an XML element with a matching name.

3. .NET attributes allow us to provide our `Person` class with metadata that directly modifies the serialization behavior. The `XmlRoot` attribute allows renaming the root element. Add it above the `Person` class:

    ```csharp hl_lines="1"
    [XmlRoot("MyPerson")] //Instead of "MyPerson" you can use "Person" in your language
    public class Person 
    {
        // ...
    }
    ```

4. The `XmlAttribute` attribute instructs the serializer to map a property to an XML attribute instead of an element. Apply this to the `Age` property (and NOT the variable!):

    ```csharp hl_lines="1"
    [XmlAttribute("MyAge")] //Instead of "MyAge" you can use "Age" in your language
    public int Age { get; set; }
    ```

5. The `XmlIgnore` attribute tells the serializer to completely exclude a property from the output. Try it on the `Name` property:

    ```csharp hl_lines="1"
    [XmlIgnore]
    public string Name { get; set; }
    ```

6. Run the program again and compare the output with the previous version.

## Task 5 – Delegate 2

In Tasks 2 and 3, we used delegates to implement event-driven messaging. **In another typical use case for delegates, function references are used to pass an implementation of an undefined step to an algorithm or more complex operation.**

For example, the built-in generic list class (`List<T>`) has a `FindAll` method that can return a new list containing all elements that meet a given condition. The specific filtering condition is provided as a function, or more precisely, as a delegate parameter (which `FindAll` calls for each element), which will return true for all elements that we want to see in the result list. The type of the function's parameter is the following predefined delegate type (**no need to type/create it**, as it already exists):

```csharp
public delegate bool Predicate<T>(T obj)
```

!!! note
    To view the full definition above, simply type the `Predicate` type name somewhere, such as at the end of the `Main` function, click on it with the mouse, and navigate to its definition using the ++F12++ key.

In other words, it expects an input of the same type as the list elements and returns a boolean (`bool`) value. To demonstrate this, we will extend our previous program with a filtering operation that keeps only the odd numbers from the list.

1. Implement a filter function in our application that returns only odd numbers:

    ```csharp
    private static bool MyFilter(int n)
    {
        return n % 2 == 1;
    }
    ```

2. Extend our previously written code by applying our filter function:

    ```csharp hl_lines="5"
    var list = new List<int>();
    list.Add(1);
    list.Add(2);
    list.Add(3);
    list = list.FindAll(MyFilter);

    foreach (int n in list)
    {
        Console.WriteLine($"Value: {n}");
    }
    ```

3. Run the application. Observe that only odd numbers appear on the console.
4. As an interesting experiment, we can place a breakpoint inside the `MyFilter` function and observe that it gets called separately for each element in the list.

!!! tip "Collection initializer syntax"
    For any class that implements the `IEnumerable` interface and has an `Add` method (typically collections), the collection initializer syntax can be used as follows:

    ```csharp
    var list = new List<int>() { 1, 2, 3 };
    ```

    Starting from C# 12, an even simpler syntax (so-called *collection expression*) can be used to initialize a collection, provided that the compiler can infer that the variable is a collection. For example:

    ```csharp
    List<int> list = [1, 2, 3];
    ```

## Task 6 – Lambda expressions

The relevant topics are covered in detail in the lecture materials, so we will not repeat them here. See the "Lambda expression" chapter in the "Lecture 02 - Language tools.pdf" document. The key element is the `=>` (lambda operator), which allows the definition of **lambda expressions**, i.e., anonymous functions.

!!! note "`Action and Func`"
      Due to time constraints, we will not cover the built-in `.NET` generic delegate types `Func` and `Action` here. However, they are still part of the core material!

We will solve the previous Task 5 in the following way: instead of defining a separate filtering function, we will pass the filtering logic as a lambda expression directly to the `FindAll` method.

We only need to modify one line:

```csharp
list = list.FindAll((int n) => { return n % 2 == 1; });
```

We defined and passed an anonymous function to the `FindAll` method:

- This is a lambda expression.
- On the left side of `=>`, we specified the function parameters (only one in this case).
- On the right side of `=>`, we defined the function body (which is the same as the previous `MyFilter` function body).

The above line can be written in a much simpler and more readable form:

```csharp
list = list.FindAll(n => n % 2 == 1);
```

The following simplifications were made:

- We omitted the parameter type: the compiler can infer it from the `FindAll` delegate parameter type, which is the previously examined `Predicate`.
- We removed the parentheses around the parameter (since there is only one parameter).
- We omitted the `{}` curly brackets and the `return` statement on the right side of `=>` (since the function body consists of a single expression, which is returned implicitly).

## Task 7 - Additional language constructs

Below, we take a look at some C# language features that are increasingly used in daily programming tasks. There may not be enough time to cover these during the laboratory.

### Expression-bodied members

Sometimes, we write very short functions, and particularly often, very short get/set/init definitions for properties that consist of **a single expression**. In such cases, the function body or the get/set/init body of a property can be defined using the so-called **expression-bodied members** syntax with `=>`. This can be done regardless of whether the context has a return value (`return` statement) or not.

As we will see in the examples, using expression-bodied members is merely a minor syntactic "twist" to minimize boilerplate code in such simple cases.

Let's first look at a function example (assuming the class contains an `Age` field or property):

```csharp 
public int GetAgeInDogYear() => Age * 7; 
public void DisplayName() => Console.WriteLine(ToString());
```

As seen, we omitted the `{}` curly brackets and the `return` statement, making the syntax more concise.

!!! tip "Important"
    Although we use the `=>` token here, it has nothing to do with the previously discussed lambda expressions. It is simply a case where the C# language uses the same `=>` token (symbol pair) for two entirely different purposes.

Example of defining a property getter:

```csharp
public int AgeInDogYear { get => Age * 7; }
```

Moreover, if the property has only a getter, we can also omit the `get` keyword and the curly brackets.

```csharp
public int AgeInDogYear => Age * 7;
```

This differs from the similar syntax used for functions in that we did not include parentheses.

### Object initializer

The initialization of public properties/fields can be combined with constructor invocation using a syntax called **object initializer**. When using this approach, after calling the constructor, we open a block with curly brackets `{}` where we can set the values of public properties/fields using the following syntax.


```csharp
var p = new Person()
{
    Age = 17,
    Name = "Luke",
};
```

The initialization of properties/fields occurs after the constructor runs (if the class has a constructor). This syntax is advantageous because it counts as a single expression (as opposed to creating an uninitialized `Person` object and then assigning values to the `Age` and `Name` fields in two additional steps). This way, an initialized object can be directly passed as a function argument without needing to declare a separate variable.

```csharp
void Foo(Person p)
{
    // do something with p
}
```

```csharp
Foo(new Person() { Age = 17, Name = "Luke" });
```

The syntax is also copy-paste friendly, as, as shown in the previous examples, it does not matter whether there is a comma after the last property value or not.

### Properties - Init only setter

The object initializer syntax from the previous point is very convenient, but it requires the property to be public. If we want a property's value to be set only during the creation of the object, we need to introduce a constructor parameter and assign it to a read-only  property (has only a getter). A simpler solution to this problem is the *Init only setter* syntax, where we can create a 'setter' using the **`init`** keyword, which allows assignment only in the constructor or when using the object initializer syntax from the previous chapter, and is no longer allowed afterward.

```csharp
public string Name { get; init; }
```

```csharp
var p = new Person()
{
    Age = 17,
    Name = "Luke",
};

p.Name = "Test"; // build error, cannot be changed afterwards
```

Furthermore, we can enforce the requirement for the `init only setter` by applying the `required` keyword to the property. In this case, the property value must be provided in the object initializer syntax; otherwise, a compilation error will occur.

```csharp
public required string Name { get; init; }
```

This is also useful because if we want to publish properties from the class and also want to support the object initializer syntax, we can avoid the need for mandatory constructor parameters.

## Task 8 – Generic classes

Note: There may not be time for this task. In that case, it is advisable to complete the task at home for practice.

.NET's generic classes are similar to C++ template classes, but they are closer to the generic classes already known in Java. With their help, we can create general-purpose (working with multiple types) but type-safe classes. Without generic classes, if we want to handle a problem in a general way, we use `object` type data (since in .NET, every class inherits from the `object` class). This is the case, for example, with `ArrayList`, which is a general-purpose collection capable of storing elements of any `object` type. Let's look at an example of using `ArrayList`:

```csharp
var list = new ArrayList();
list.Add(1);
list.Add(2);
list.Add(3);
for (int n = 0; n < list.Count; n++)
{
    // You have to cast, otherwise it won't compile
    int i = (int)list[n];
    Console.WriteLine($"Value: {i}");
}
```

The above solution raises the following issues:

- The `ArrayList` stores each element as an `object`.
- When we want to access an element in the list, we always need to cast it to the appropriate type.
- It is not type-safe. In the above example, nothing prevents (and no error message is shown) from inserting an object of a different type into the list alongside `int` type data. In this case, we would only encounter an error during the list traversal, when trying to cast a non-`int` type to `int`. With generic collections, such errors are detected at compile-time.
- When storing value types, the list works slower because the value type needs to be boxed first to be stored as an `object` (i.e., as a reference type).

The solution to the above problem is to use a generic list, as shown below (during the practice, just modify the highlighted lines in the previously typed example):

```csharp hl_lines="1 7"
var list = new List<int>();
list.Add(1);
list.Add(2);
list.Add(3);
for (int n = 0; n < list.Count; n++)
{
    int i = list[n]; // No need to cast
    Console.WriteLine($"Value: {i}");
}
```
