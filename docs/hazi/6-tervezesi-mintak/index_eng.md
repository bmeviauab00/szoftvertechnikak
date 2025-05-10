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

<div class="grid cards" markdown>