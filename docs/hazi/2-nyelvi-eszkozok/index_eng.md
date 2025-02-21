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