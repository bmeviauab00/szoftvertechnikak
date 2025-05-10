---
authors: bzolka
---

# 6th Homework - Design patterns (extensibility)

In this homework, you will further develop the data processing/anonymization application that was started in the [corresponding lab](../../labor/6-tervezesi-mintak/index_eng.md).

This independent task is based on the material covered in the Design Patterns lectures:
- Template Method, Strategy, Open/Closed principle, SRP principle, other techniques (method reference/lambda)
- Dependency Injection pattern

The practical foundation for the tasks is provided by: [Lab 6 – Design Patterns (Extensibility)](../../labor/6-tervezesi-mintak/index_eng.md)

Goals of this independent exercise:

- Applying related design patterns and other extensibility techniques
- Practicing the concepts of integration and unit testing

Information about the required development environment is available [here](../fejlesztokornyezet/index_eng.md). For this homework, WinUI is not required (you will work in the context of a console-based application), so **the tasks can also be completed on Linux or macOS.**

## Submission process

- The submission process is the same as in previous assignments. Use GitHub Classroom to create a personal repository. The invitation URL is available on Teams and on AUT portal. Make sure you use the correct URL specific to this homework (each homework has its own unique link). Clone the repository that gets created — it will include the expected structure for your solution. After completing the tasks, commit and push your work.
- Open and work in the `Patterns-Extensibility.sln` solution file found among the cloned files.
- :exclamation: The tasks require you to take **screenshots** of specific parts of your solution, which serve as proof that you created the solution yourself. **The expected content of each screenshot is clearly specified in the individual tasks.** 
These screenshots must be submitted as part of your solution — place them in the root folder of your repository (next to neptun.txt).
The screenshots will be uploaded to GitHub along with the rest of the repository.
Since the repository is private, only instructors will have access to it.
If any screenshot includes content you don’t want to share, you may blur or redact it.
- :exclamation: This assignment does not include a functional pre-checker: Although a check runs after each push, it only verifies whether neptun.txt is filled out. The actual evaluation will be performed by the lab instructors after the deadline.

## Task 1

The foundation of this homework assignment is the following:

- Understanding the Strategy pattern and the related Dependency Injection (DI) design pattern
- A clear understanding of how these patterns are applied in the context of the lab task (anonymizer)

The starting state of the homework corresponds to the final state of Lab 6. In the homework solution, this is the "Strategy-DI" project. To run/debug it, make sure to set it as the startup project (right-click → *Set as Startup Project*). Carefully review and understand the source code of this project.

- In the `Program.cs` file, you’ll find three `Anonymizer` instances, each configured with a different strategy implementation. To get familiar with the code, it’s worth trying them out one by one and verifying that the anonymization and progress handling behave according to the selected strategy implementation. (Reminder from the lab: the anonymizer reads its input from the "bin\Debug\net8.0\us-500.csv" file and writes the output to "us-500.processed.txt" in the same folder.)
- Also, starting from `Program.cs`, it's helpful to place breakpoints and step through the code — this reinforces understanding and helps with repetition.

!!! note "Dependency Injection (Manual) vs. Dependency Injection Container"
    In the lab — and in this homework — we use the simple, manual form of Dependency Injection (this is also what is shown in the lecture). In this case, dependencies of a class are manually instantiated and passed into the constructor. In more complex real-world applications, it is common to use a Dependency Injection Container,  where you can register which implementation to use for each interface type.  However, DI containers are not covered in this course and are not part of the curriculum. The manual version of DI **is required** and critically important — without it, applying the Strategy pattern would not make sense.

:warning: In your own words, provide short answers to the following questions in the `readme.md` file located in the *Feladatok* folder:

- What does combining the Strategy pattern with Dependency Injection provide in the context of the lab example? What are the advantages of using them together?
- What does it mean that applying the Strategy pattern results in satisfying the Open/Closed Principle in the solution? (You can read about the Open/Closed Principle in the lecture and lab materials.)

## Task 2 - Null Strategy

Looking at the constructor parameters of `Anonymizer`, you’ll see that it accepts `null` as a valid value for the progress strategy. This makes sense — the user of the Anonymizer class might not care about progress updates. However, this approach has a downside: if `_progress `is null, then every usage of it in the class must include a null check. Indeed, the code uses the null-conditional operator `?.` to safely invoke methods on `_progress`. But this is a risky practice: in more complex code, if a single null check is missed, it can lead to a runtime `NullReferenceException`. Null reference errors are among the most common and hardest to track.

Task: Design a solution that eliminates the possibility of this kind of error. Hint: You need a solution where `_progress` is never null. Try to figure it out on your own first.

??? tip "Solution Principle"
    The key idea is this: Create a new strategy implementation of `IProgress` (e.g., called `NullProgress`), which is used when no progress reporting is needed. This implementation will do nothing — the method body will be empty. Then, in the `Anonymizer` constructor, whenever the caller passes null for the progress parameter, instantiate a `NullProgress` object and assign it to `_progress`. Now, `_progress` is guaranteed never to be null, and you can safely remove all null checks from the code.

    This technique also has a name — it is commonly referred to as the **Null Object** pattern.

## Task 3 - Testability

Let’s observe that there are still several aspects of the `Anonymizer` class's behavior that could be made extensible using one of the design patterns we've learned. Among them are:

* **Input** handling: Currently, it only supports file-based input in a fixed CSV format.
* **Output** handling: Also file-based and limited to a fixed CSV format.

According to the Single Responsibility Principle (SRP), these responsibilities should be separated from the class, and moved into separate classes. (Make sure to review what the SRP entails.) However, this separation does not necessarily require an extensible (e.g., Strategy-based) implementation — there is no requirement in this case to support multiple kinds of inputs and outputs. So we would perform the separation without using the Strategy pattern.

That said, there is another critical factor that we haven’t yet discussed (and one that traditional design pattern literature often overlooks): unit testability.

Currently, our `Anonymizer` class can be covered by automated **integration tests**, but not **unit tests**.

* Integration tests evaluate the entire flow from end to end: including reading input, processing data, and writing the output. In our example, this is straightforward — we create input CSV files and check whether the expected output files are produced.
* However, integration tests tend to be slow — they often involve reading from files, databases, cloud services, etc. In large products (with thousands of tests), this slowness becomes a limiting factor: tests are run less frequently, and achieving good test coverage becomes harder.

To address this, we often rely on **unit tests**, which are much faster and can offer higher code coverage. **Unit tests execute individual logical units in isolation, without any slow file/database/network/cloud dependencies.** This allows us to run many tests in a short time — and achieve excellent test coverage efficiently.

!!! note "Test Pyramid"
    This concept is often illustrated with a test pyramid, which has several variations in the literature. A simple version looks like this:

    ![Test pyramid](images/testing-pyramid.png)

    The higher we go in the pyramid layers, the more comprehensive the tests become, but they are also slower and more expensive to run. That’s why we usually create fewer of them (and achieve lower code coverage with them). At the top of the pyramid are automated E2E (End-to-End) or GUI tests. Below them are integration tests that cover multiple components or modules together. At the base of the pyramid are unit tests, which we write in the greatest numbers (hence the widest layer at the bottom).

    Fun fact: When a development team neglects unit testing for a long time, the codebase becomes structurally difficult to test at that level. As a result, only a few unit tests get written, maybe some integration tests on top — and the testing effort falls mostly on a large number of E2E/GUI tests written by QA teams. In contrast to the pyramid, this structure resembles an ice cream cone — just imagine a few scoops at the top. This is often referred to as the ice cream cone anti-pattern (and it’s not the kind of ice cream we like). However, it’s worth noting that exceptions exist: Some applications contain very little logic within their individual parts, and instead focus heavily on the integration of simple modules. In such cases, it is natural for integration tests to be the dominant layer.

By default, many classes are not unit-testable as they are. The current version of the `Anonymizer` class is one such case — it's hardcoded to work only with slow, file-based input. But suppose we want to unit test the logic of its `Run` method. In that case, it doesn’t matter whether the input comes from a slow file or we simply create a few `Person` objects using `new` in code (which is orders of magnitude faster).

The solution — to make our code unit-testable — is simple:

<div class="grid cards" markdown>

- :warning:
    *Using the Strategy (+DI) pattern (or delegates), we separate the logic that hinders or slows down testing (e.g., input/output handling) from the class we want to unit test. We then create real implementations for production use and mock implementations to aid testing.*
</div>

<div class="grid cards" markdown>

- :warning:
    *Therefore, we often use the Strategy pattern not because multiple behaviors are required due to client needs, but to make our code unit-testable.*

</div>

Accordingly, we will prepare a version of our solution that is suitable for unit testing, in which both input and output handling are decoupled using the Strategy pattern.

Task: Refactor the solution found in the Strategy-DI project so that the class becomes unit-testable using the Strategy pattern. Specifically:

- Introduce an `InputReaders` folder in which you create an input processing strategy interface named `IInputReader` (with a single method: `List<Person>` `Read()`), and refactor input handling out of the `Anonymizer` class into a `CsvInputReader` strategy implementation. This class should receive the input file path as a constructor parameter.
- Introduce a `ResultWriters` folder in which you create a result writing strategy interface named `IResultWriter` (with a single method: void `Write(List<Person> persons)`), and refactor result writing out of the `Anonymizer` class into a `CsvResultWriter` strategy implementation. This class should receive the output file path as a constructor parameter.
- Extend the `Anonymizer` class, including its constructor (following the Strategy + DI pattern), so that it can be used with any `IInputReader` and `IResultWriter` implementation.
- Refactor the usage of the `Anonymizer` class in the `Program.cs` file so that the newly introduced `CsvInputReader` and `CsvResultWriter` classes are passed as parameters.

The next step would be to create unit tests for the `Anonymizer` class. To do this, we need to introduce so-called mock strategy implementations, which not only provide test data (quickly, without file handling), but also perform verifications (i.e., whether a given logical unit truly works correctly). This may sound complicated at first, but fortunately most modern frameworks provide library support for this (in .NET, for example, the [moq](https://github.com/devlooped/moq) library). Using such tools goes beyond the scope of this course, so we now conclude the unit testability-related part of the task at this point.

Before finishing the task, make sure to verify the output file’s contents to ensure that the anonymization actually runs!

!!! example "Task 3 - TO BE SUBMITTED"
    - Insert a screenshot showing the constructor and `Run` method implementation of the `Anonymizer` class (f3.1.png).

## Task 4 - Using delegates

Nowadays, features supporting functional programming are rapidly spreading even in previously strictly object-oriented languages. Developers are increasingly fond of using them, as these often allow the same functionality to be implemented with significantly shorter code and less "ceremony". One such feature in C# is the delegate, along with lambda expressions.

As we’ve seen earlier in the semester, delegates allow us to write code where certain logic/behavior is not hardcoded, but provided externally. For example, we can pass a delegate to a sorting function that defines how two elements should be compared, or which property of the element should be used for comparison — ultimately determining the desired sort order.

Accordingly, using delegates is another alternative (besides Template Method and Strategy patterns) for making code reusable/extensible by introducing extension points.

In the next step, we will refactor the previously Strategy pattern–based progress handling into a delegate-based solution (no new functionality will be introduced; this will be a purely technical transformation).

Task: Refactor the solution in the Strategy-DI project so that progress handling, which was previously implemented using the Strategy pattern, is now based on delegates.

- Do not introduce a custom delegate type (use the built-in .NET `Action` type).
- Do not use the existing `SimpleProgress` and `PercentProgress` classes in your solution (but do not delete them either).
- The `Anonymizer` should still allow passing `null` to its constructor if the user does not want any progress handling.
- In the `Program.cs` file, comment out the previous usages of `Anonymizer`. Then, introduce a new example of using the Anonymizer where progress handling is provided in the form of a lambda expression, and the lambda should implement the exact same logic as the previous "simple progress". You do not need to implement or support the "percent progress" logic in this solution (we'll return to that in the next task).

!!! tip "Tips"
    - The core idea of the delegate-based solution is very similar to Strategy: instead of receiving and storing strategies as class members (via interface references), the class receives delegates, and calls the functions referenced by them at extension points.
    - You already did something similar in Homework 2, in the ReportPrinter part ;)

!!! example "Task 4 – TO BE SUBMITTED"
    - Insert a screenshot showing the constructor and `Run` method implementation of the `Anonymizer` class (`f4.1.png`).
    - Insert a screenshot showing the contents of the `Program.cs` file (especially the new parts) (`f4.2.png`).

## Task 5 - Using delegates with reusable logic

In the previous task, we assumed that the “simple progress” and “percent progress” logic was used only once, so there was no need to make it reusable. Accordingly, the “simple progress” logic was provided in the simplest form — as a lambda expression (no need for a separate function). 

However, what if we want to reuse the “simple progress” logic in multiple places, across multiple `Anonymizer` objects? It would be a serious mistake to multiply the lambda expression using copy-paste, as this leads to code duplication — violating the "**Do Not Repeat Yourself**" (**DRY) principle.

Question: Is there a way to provide reusable code when working with delegates? Of course there is — with delegates, it's not mandatory to use lambda expressions. As we’ve seen (and used) many times throughout the semester, delegates can refer to regular methods (whether static or instance methods).

If we want the “simple progress” and/or “percent progress” logic to be reusable when using delegates, we should place them into separate functions, inside an appropriate class (or classes). Then, we pass these method references to the `Anonymizer` constructor as parameters.

Task: Extend the previous solution so that the “simple progress” and “percent progress” logic becomes reusable. Specifically:

- Implement the “simple progress” and “percent progress” logic as two static methods in a newly introduced static class named `AllProgresses` (place this class in the root of the project).
- Add two new usages of the `Anonymizer` class in the `Program.cs `file (in addition to the existing ones), which utilize the two static methods from the `AllProgresses` class (do not use lambda expressions here).
- The existing `IProgress` interface and its implementations could theoretically be deleted (since they are no longer used), but do not delete them — keep them so the progress logic from your earlier solutions can still be reviewed.

We’re done — let’s evaluate the solution:

- It’s clear that the delegate-based solution required less ceremony than Strategy: no need to introduce interfaces and implementation classes (we could use the built-in generic delegate types like `Action` and `Func`).
- Fully “one-off” logic is easiest to provide via a lambda expression. If reusable logic is needed, then we should create traditional, reusable methods instead.

!!! example "Task 5 – TO BE SUBMITTED"
    - Insert a screenshot showing the contents of the `AllProgresses.cs` file (f5.1.png).
    - Insert a screenshot showing the contents of the `Program.cs` file (especially the new parts) (`f5.2.png`).

## Refactoring – the concept

Throughout the lab and homework implementation, there were many steps where we changed the code without altering the external behavior of the application, only its internal structure. The goal of these changes was to improve certain code quality characteristics. This process is called refactoring. Refactoring is a very important concept and is used frequently in everyday software development. There is even dedicated literature on it, and it’s worth learning about the key techniques in more detail later on. Most modern development tools offer built-in support for certain refactoring operations — Visual Studio is not the strongest in this area, but still supports a few basic operations (e.g., Extract Method, Extract Base Class, etc.). We have practiced refactoring manually, and although there won’t be a separate assignment for it, it’s important to know the concept of refactoring.

## Task 6 - Optional task: Creating an integration test

This task is **optional, not mandatory**.

The concept of integration testing was introduced earlier in Task 3. The goal of this optional task is to practice and better understand integration testing through a simple exercise.

Create an integration test for the `Anonymizer` class, following these guidelines:

1. Work in the `IntegrationTest` project located in the `Test` folder of the Solution. This is an NUnit test project.
2. A project reference to the `Strategy-DI` project has already been added in this test project, so we can access the public classes from the `Strategy-DI` project. Naturally, this is a prerequisite for being able to test them. Verify the project reference under Dependencies > Projects in the Solution Explorer.
3. In the `AnonymizerIntegrationTest` class, there is already a method prepared for testing, named `Anonymize_CleanInput_MaskNames_Test`. (Test methods must be marked with the [Test] attribute — this is already done for this method.) The body of the method is currently empty — continue working inside it with the following steps:
    1. Create an Anonymizer object which:
        * uses the input file `@"TestFiles\us-500-01-clean.input.csv"` (found in the project’s *TestFiles* folder — check its contents),
        * writes the output to the file `@"us-500-01-maskedname.processed.txt"`,
        * uses a "***"-parameter `NameMaskingAnonymizerAlgorithm`.
    2. Run the anonymizer by calling its `Run` method so that the output file gets generated.
    3. Use `Assert.AreEqual` to verify that the content of the output file created during anonymization matches the expected content. The expected content is available in the file `@"TestFiles\us-500-01-maskedname.processed-expected.txt"` (also located in the `TestFiles` folder — check its contents).
    Tip: You can read the entire content of a file in one step using the static method `File.ReadAllBytes`.
4. Verify that the integration test runs without errors:
    1. Build the project.
    2. Open the Test Explorer (Test > Test Explorer menu).
    3. Run the test using the buttons in the toolbar at the top of the Test Explorer window. You can also debug the test by right-clicking on it and selecting the Debug option — this is very useful if the test fails, as it allows you to step through the code with breakpoints and inspect variable values.
    4. If the test runs successfully, its icon will turn green. If it fails, the icon turns red, and more information about the failure can be found at the bottom of the Test Explorer view after selecting the test.

## Task 7 - Optional: Creating a unit test

This task is **optional, not mandatory**.

The concept of unit testing was introduced earlier in Task 3. The goal of this optional task is to practice and better understand unit testing through a hands-on example.

Preparation:

1. Add a new "NUnit Test Project" to your solution, name it "UnitTest" (Right-click on the Solution in the Solution Explorer → Add → New Project).
2. In this new project, add a project reference to the `Strategy-DI` project so you can access the types defined in it. (Right-click on the Dependencies node of the UnitTest project → Add Project Reference → check the Strategy-DI project → OK).
3. The project will include a default `UnitTest1.cs` file with a `Test` class inside it. It is recommended to rename these to `AnonymizerTest`.

Create a unit test for the Anonymizer class that verifies: That the `Run` method calls the anonymizer algorithm with exactly the same person records, in the same order, that the `Anonymizer` reads from the input (assuming there are no city names to trim).

* The test method should be named: `RunShouldCallAlgorithmForEachInput`
* :exclamation: It is crucial to write a very fast unit test, not an integration test — so we only want to test the logic of `Run` in isolation, without any file processing. There must be no file handling in your solution!
* Tip: Create 2–3 `Person` objects in memory and use them as input.
* Tip: Use input data for which the `TrimCityNames` function has no effect (i.e., no cities that should be trimmed), to simplify testing.
* Tip: Create your own test implementations of `IInputReader` and `IAnonymizerAlgorithm` (and pass them to `Anonymizer`) that: **provide the appropriate test data, and/or collect information during execution, so you can verify after the run that the tested conditions are met**. These strategy implementations should be declared inside the test project, since they are only used for testing.

For additional practice, you may write another unit test that checks whether all input person records make it to the output.

## Summary

There will be no more tasks 😊. But if you're curious about how "perfect"/incomplete the current solution is, or when it's better to use Template Method, Strategy, or delegates, it's worth reading the following evaluation of the solution we started in the lab and completed as part of the homework.

## Overview of our workflow

* Throughout the evolving requirements, we introduced design patterns and other techniques organically during the refactorings. This is completely natural — it's how development often happens in real life.
* Especially in more complex tasks — and particularly when we don’t yet have years of experience — we often start with a simpler implementation (the one we understand best at first), and then gradually transform it into one that meets the extensibility/reusability requirements of the given context.

### Levels of Reusability and Extensibility in Each Iteration

We can try to visualize how our solution evolved with each iteration to become increasingly reusable and extensible:

![Levels of extensibility and reusability](images/extensibility-levels.png)

Of course, the % values should not be taken too literally — but the progress is clearly visible.

??? note "Why is the final solution 'only' at 70%?"
    You might wonder: why do we rate the current solution at approximately 70%? Among other reasons:

    * The data cleaning method in the `Anonymizer` class is hardcoded (trimming is applied to a specific column in a specific way).
    * We did not follow a very important general principle: separating the UI from the logic. Our code writes to the console in multiple places — which means it’s not usable with a graphical interface!
    * Some of our anonymizer algorithms are very specific. It would be possible to write more general algorithms that star out arbitrary fields (not just hardcoded to "name") or band arbitrary values (not just age).
    * The current solution works only with `Person` objects.
    * We cannot combine different anonymizer algorithms simultaneously.

### Overview of extension techniques

* **Template Method**: In simpler cases, where we don’t need to support many cross-combinations of different behavior aspects, this is a very convenient and straightforward solution — especially if inheritance is already being used. However, it can result in base classes that are hard or even impossible to unit test.
* **Strategy**: Provides a highly flexible solution and avoids combinatorial explosion when we need to extend a class across multiple behavior dimensions and want to support combinations of these. In many cases, we apply it specifically to separate dependencies from our class using interfaces — making the class unit-testable.
* **Delegate/lambda**: This approach involves much less ceremony than using Strategy, since there’s no need to introduce interfaces or implementation classes. For this reason, its usage is rapidly growing even in modern object-oriented languages. Its benefits are especially clear when the behaviors do not need to be reusable — in such cases, we can simply define them with inline lambda expressions, without introducing new classes or separate methods.

It’s worth summarizing when Strategy has advantages over delegates:

* When the aspect being extended includes multiple operations (the more operations, the clearer the benefit). In such cases, the strategy interface naturally groups these operations (e.g., in our case, the `IAnonymizerAlgorithm` interface contains both `Anonymize` and `GetAnonymizerDescription`). These are also grouped together in the interface implementations. With delegates, there is no such grouping, which may make things less transparent when dealing with many operations.
* When the language is purely object-oriented and doesn’t support delegates/lambdas. But most modern OO languages today (e.g., Java, C++) support them in some form.
* When strategy implementations store state in their member variables that is provided at creation time. We used this approach: _mask in NameMaskingAnonymizerAlgorithm, and _rangeSize in AgeAnonymizerAlgorithm. This doesn’t mean we can’t use delegates in such cases, but:
    * These values can be passed as parameters to the delegate methods,
    * Or, when using lambdas, the variable capture mechanism allows lambdas to inherit values from their enclosing scope.

    However, these solutions may not always be applicable, or may be more cumbersome to implement.

It’s also important to mention that the patterns covered here are not the only ones that promote extensibility and reusability — in fact, nearly all design patterns serve these purposes. We simply focused on a few that are among the most frequently and broadly used (we could also include Observer, Iterator, and Adapter in this category).

If you’ve read this far, you definitely deserve an extra thumbs up 👍!