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

