---
authors: bzolka
---

# 1. HW - Relationship between the model and the code

## Introduction

There is no lecture associated with this task. The theoretical and practical background for the exercises is provided by the guided laboratory practice "1. The Relationship Between the Model and the Code":

- This laboratory practice is/was completed by the students with the guidance of the instructor in a supervised manner.
- A guide accompanies the laboratory practice, detailing the theoretical background and explaining the steps of the solution: [1. Relationship between the model and the code](../../labor/1-model-es-kod-kapcsolata/index_eng.md)

Based on this, the tasks of this homework can be completed with the help of the brief guidance following the task description.

Objectives of the homework:

- Developing a simple .NET application and practicing C# basics
- Demonstrating the relationship between UML and code
- Practicing the application of interfaces and abstract base classes

A description of the required development environment can be found [here](../fejlesztokornyezet/index_eng.md).

!!! warning "Using C# 12 (and newer) Language Elements"
    During the completion of the assignment, C# 12 and newer language features (e.g., primary constructor) cannot be used, as the verification system running on GitHub does not yet support them.

## Downloading the Initial Framework and Uploading the Completed Solution

The initial environment for the homework and the submission of the solution are managed using Git, GitHub, and GitHub Classroom. Main steps:

1. Create a repository for yourself using GitHub Classroom. The invitation URL can be found on Moodle (on the course homepage under the "*GitHub classroom links for homework*" link).
2. Clone the newly created repository. This will contain the expected structure for the solution.
3. After completing the tasks, commit and push your solution.

More detailed descriptions can be found here:
- [Git, GitHub, GitHub Classroom](../git-github-github-classroom/index_eng.md)
- [Homework Workflow and Using Git/GitHub](../hf-folyamat/index_eng.md)

## Pre-evaluation and official assessment of the homework

Every time you push your code to GitHub, an automatic pre-evaluation is performed, and you can check the output! More information is available here (make sure to read it): [Pre-evaluation and official assessment of the homework](../eloellenorzes-ertekeles/index_eng.md).

## Task 1 – Creating a Simple .NET Console Application

### Initial Project

The initial environment is located in the `Task1` folder. Open the `MusicApp.sln` file in Visual Studio and work within this solution.

!!! warning "Attention!"
    Creating a new solution and/or project file or targeting the project to other/newer .NET versions is prohibited.

A `music.txt` file is located in the `Task1\Input` folder, that serves as the input for the task.

### Task

A text file stores the titles of songs by composers/artists/bands in the following format:

- Each composer has a separate line.
- Each line starts with the composer's name, followed by `;`, then song titles separated by `;`.
- The file content is considered valid even if it contains empty lines or lines with only whitespace characters (space, tab).

The provided `music.txt` file may contain the following:

```csv
Adele; Hello; Rolling in the Deep; Skyfall
Ennio Morricone;	A Fistful Of Dollars; Man with a Harmonica
AC/DC; Thunderstruck; T.N.T
```

Read the file into a list of `Song` class objects. A `Song` object stores a song's data (composer and title). After reading, format and display the objects' data on standard output in the following format:

```text
composer1: composer1_song1
composer1: composer1_song2
...
composer2: composer2_song1
...
etc.
```

For the sample file, the expected console output would be:

![Console Output](images/music-store-console.png)

### Implementation steps

Create a `Song` class in the project (right-click the project in Solution Explorer, select *Add / Class*).

Define the necessary members and a constructor:

```csharp
public class Song
{
    public readonly string Artist;
    public readonly string Title;

    public Song(string artist, string title)
    {
        Artist = artist;
        Title = title;
    }
}
```

!!! note "Property"
    The member variables are declared as `readonly` to prevent modification after object initialization. An alternative would be to use read-only properties (covered later in the course).

Next, override the `ToString` method inherited from `System.Object` in the `Song` class:

```csharp
public override string ToString()
{
    return $"{Artist}: {Title}";
}
```

For reading the text file, use the [`StreamReader`](https://learn.microsoft.com/en-us/dotnet/api/system.io.streamreader) class from `System.IO`.

In our `Main` function, read the file line by line, create `Song` objects, and store them in a dynamically growing array, `List<Song>`. Be mindful that elements in the file separated by `;` may have whitespace characters (spaces, tabs) before or after them—these should be removed!

The following code presents a possible solution, with details explained in the code comments. This is the first homework of the semester, and for most students, their first .NET/C# application. Therefore, we provide a sample solution here, but more experienced students are encouraged to attempt it independently.

??? example "Solution"

    ```csharp
    namespace MusicApp;

    public class Program
    {
        public static void Main(string[] args)
        {
            List<Song> songs = new List<Song>();

            StreamReader sr = null;
            try
            {
                sr = new StreamReader(@"C:\temp\music.txt");
                string line;
                while ((line = sr.ReadLine()) != null)
                {
                    if (string.IsNullOrWhiteSpace(line))
                        continue;

                    string[] lineItems = line.Split(';');

                    string artist = lineItems[0].Trim();

                    for (int i = 1; i < lineItems.Length; i++)
                    {
                        Song song = new Song(artist, lineItems[i].Trim());
                        songs.Add(song);
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("File processing failed.");
                Console.WriteLine(e.Message);
            }
            finally
            {
                if (sr != null)
                    sr.Close();
            }

            foreach (Song song in songs)
                Console.WriteLine(song.ToString());
        }
    }
    ```

    Copy the `music.txt` file to the `C:\temp` folder and run the application. To keep things simple, everything is handled within the `Main` function, but in a real-world scenario, the code should be moved to a dedicated processing class.

    This example introduces several essential .NET/C# techniques. Be sure to read and understand the code comments, as these concepts will be used throughout the semester.

## Task 2 - UML and code relationship, interface and abstract base class application

### Starting Environment

The starting environment is located in the `Task2` folder. Open the `Shapes.sln` file in Visual Studio and work within this solution.

!!! warning "Attention!"
    Creating a new solution or project file, or targeting the project to different/newer .NET versions is prohibited.

A `Controls.dll` file is located in the `Task2\Shapes` folder, which will be used in this task.

### Required Submission (Beyond the Source Code)

Write a two-to-three paragraph summary explaining the design decisions made during Task 2, as well as the key principles behind the solution. This summary should be added to the `readme.md` file in the `Task2` folder. Ensure you modify the file inside the `Task2` folder (even if an identically named file exists in the root directory).

### Task

You have been assigned to develop the first version of a CAD application capable of handling vector-based graphical shapes.

- The application must support different types of shapes, initially including `Square`, `Circle`, and `TextArea`. The `TextArea` represents an editable text box. The code should be designed for easy extension with new shape types.

!!! warning "Naming Conventions"  
    The classes must be named according to the specifications above!

- Each shape must store its x and y coordinates, as well as data necessary for rendering and area calculation. For example, a square should store its side length, a `TextArea` should store width and height, and a circle should store its radius.

- All shapes must provide methods to retrieve their type, coordinates, and area. The type retrieval method should return a `string`, and the built-in `Type.GetType` method must not be used.

- The application must be able to list all stored shapes in memory on the console, displaying the shape type (e.g., `Square` for squares), the coordinates, and the area. The built-in `Type.GetType` method must not be used for type identification.

- The `TextArea` class must inherit from the `Textbox` class found in `Controls.dll`. This `.NET assembly` provides precompiled class implementations.

    !!! failure "Default Implementation in Interfaces"
        Although C# 8 and later support default method implementations in interfaces, this feature cannot be used in this task. A more traditional approach is required.

- The implementation should follow proper encapsulation principles. Shape management must be handled by a **dedicated class**, rather than being stored in a simple list inside the `Main` function.

    !!! failure
        It is unacceptable to store shapes in a simple list within `Main`. Additionally, the managing class should not inherit from built-in collection classes like `List<T>` but should instead contain such a collection internally. This class should be responsible for listing the data to the standard output.

- The implementation should prioritize **extensibility, maintainability, and avoid code duplication**. These factors are key to acceptance.

- The `Main` function should demonstrate the usage of the implemented classes.

- By the end of the implementation, create a class diagram in Visual Studio that clearly presents the relationships between the classes. Use *Show as Association* or *Show as Collection Association* instead of member variables when representing relationships. (See [1st Lab - instructions](../../labor/1-model-es-kod-kapcsolata/index_eng.md))

    !!! tip "Class Diagram Component"
        Visual Studio 2022 does not always install the *Class Designer* component by default. If the *Class Diagram* option is unavailable when adding a new item, install the *Class Diagram* component manually. See [Development environment](../fejlesztokornyezet/index_eng.md) for further details.

During the implementation, we apply significant simplifications:

- The drawing of shapes will not be implemented (the necessary knowledge for this will be covered later in the semester).
- Shapes only need to be stored in memory.

### Using external libraries

This task builds on concepts from the [1st Lab - Model and Code Relationship](../../labor/1-model-es-kod-kapcsolata/index_eng.md). A key difference is that while in that exercise, `DisplayBase` was read-only by convention, in this task, `Textbox` is truly immutable as it is only available as a compiled `.dll`.

!!! note 
    The development of multi-component applications, assembly, and project reference usage were covered in the first lecture. If you do not remember this topic, it is recommended to review it.

Follow these steps to use an external `dll`:

1. In *Solution Explorer*, right-click *Dependencies* and select *Add Reference* or *Add Project Reference* (which exists).
2. In the new window, choose *Browse*.
   1. If `Controls.dll` appears in the list, check it.
   2. If not, click *Browse...*, navigate to `Controls.dll`, and select it.
      1. In the file browser window that appears, navigate to the `Controls.dll` file and double-click on it to close the window.
      2. In the middle section of the *Reference Manager* window, `Controls.dll` should now be checked. Close the window by clicking the OK button.
3. Click OK to finalize the reference.

??? "If you receive a 'Reference is invalid or unsupported' error"
    In rare cases, Visual Studio may show this error. Reinstalling Visual Studio typically resolves the issue.

Now the project includes a reference to `Controls.dll`, allowing access to its classes. (e.g., they can be instantiated or inherited). In *Solution Explorer*, expand the *D*ependencies* and then the *Assemblies* node to see *Controls* appear.

![Controls.dll](images/controlsdll.png)

The `Textbox` class, from which `TextArea` must inherit, is located in the `Controls` namespace. It has a constructor with four parameters: x and y coordinates, width, and height.
If needed, the *Object Browser* can help explore additional methods. The *Object Browser* can be opened by selecting the *Object Browser* option from the *View* menu. It will appear in a new tab.

!!! note "If Object Browser appears empty"
    In Visual Studio 2022, the Object Browser sometimes does not display content unless a source file is open. Open `Program.cs` and then switch back to the Object Browser to see the components.

In the Object Browser, expanding the `Controls` component and selecting individual nodes (namespace, class) will display the properties of the selected node. For example, when selecting a class, its members will be shown.

![Object Browser](images/object-browser.png)

Now, all necessary information is available for implementation.

## Submission

Checklist reminder:

--8<-- "docs/hazi/beadas-ellenorzes/index_eng.md:3"

- For Task 2, do not forget to document your solution in `readme.md`.
