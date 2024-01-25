# Theory of the relationship between the UML class diagram and code

Last modified date: 2022.10.15
Edited by Zoltán Benedek

The chapter does not contain an exercise, it introduces the related theory to students.

## Introduction

The chapter gives a brief, sketchy overview of the basics of mapping between the UML class diagram and the source code, as a review of what has already been learned in Software Engineering in the previous semester.

Today, there are many software development methodologies. They rely on, or require, modelling to varying degrees in the construction of the software. However, there is no doubt that even the most agile, "code-centric" followers of the most "code-centric" approaches find it useful to visually model the more important/complex components and structural elements of software, because of the greater expressive power of the graphical nature of the software.

Let's say you have to build an application or a specific module of an application. Following our chosen methodology, we will cover the steps of requirements analysis, analysis, design, implementation and testing, probably in several iterations. Let's now focus on the design phase. This will result in a detailed design of the system (at least parts of it), resulting in a detailed/implementation plan or model. At this level, certain elements of the model (e.g. classes) can be explicitly mapped to elements of the programming language chosen to implement the subsystem. If you have a good development/modeling tool, it can generate the class skeleton (e.g. C++, Java, C# classes). Our task is then to fill in the root of the methods in the generated code.

### Concepts

- Forward engineering: generating code from a model. From the detailed plan, the modelling tool can generate the program framework. The advantage is that less coding is needed.
- Reverse engineering: generating a model from code. It helps you understand the code you already have.
- Round-trip engineering: a combination of the previous two. The point is: the model and the code are in sync all the time. If you change the code, the change appears in the model, if you change the model, the change appears in the code.

In order to take advantage of code generation, you need to be aware of the following: you need to know how a given modelling tool maps each model element to elements of a given programming language. The mapping depends on the language and the modelling tool, there is no universal standard. The mappings are usually self-explanatory, there is not usually too much variation.

In the following we will look at how each model element of the UML class diagram is mapped to source code, and vice versa.

## Mapping of classes

It's trivially simple:

- UML class -> class
- UML attribute -> member variable
- UML operation -> operation/method

An example:

Shape class

, which corresponds to the following code in C#:

```csharp
public abstract class Shape
{
    private int x;
    private int y;
    public Shape(int x, int y) { this.x = x; this.y = y; }
    public abstract void Draw(Graphics gr);
}
```

In the context of visibility, mapping:

- +: public
- -: private
- \#: protected

A more exciting question is how the relationships between classes are mapped, and this is discussed in the following chapters.

### I. Generalisation, specialisation link

Generalisation, specialisation

C# mapping:

```csharp
public class Base
{ };
public class Derived : Base
{ };
```

### II. Association

This relationship type always implies communication between objects of classes. A department uses the services of another department.

#### A) Building a 0..1 multiplicity association relation

In this case, the client class contains a pointer or reference through which it can use the services of the target class (call its operations).
Example:

Generalisation, specialisation, single contact

C++ mapping:

```cpp
class Application
{
   WindowManager* windowManager;
};

class WindowManager
{
};
```

C# mapping (no pointers, only references):

```csharp
class Application
{
   WindowManager windowManager;
};

class WindowManager
{
};
```

In both cases, we see that **a pointer or reference member variable is added to the client class, whose type is the same as the type of the target class referenced in the association, and the name of the member variable is the role given to the target class for the association relationship**, which in the example is .
The mapping is logical, since the client can access the target object from any of its operations and call its methods through this pointer/reference.

Comment. Sometimes the association is two-way, with each class using the services of the other. Often, instead of putting an arrow at both ends of the association, we leave it at both ends. In such a two-way relationship, the role must be specified at both ends of the relationship. During the mapping, we add a pointer/reference to each class to the other.

#### B) Derivation for an association relation with multiplicity 0..n

In this case, a client-side object is related to several target-side objects. Example:

Generalisation, specialisation, multiple links

One `WindowManager` object manages several `Window` objects. **The mapping takes some collection of objects in the target class into the client class.** This can be an array, list, etc., whichever best suits our purpose in the situation.

A mapping to the above example in C++:

```cpp
class WindowManager
{
  vector<Window*> windows;
};
```

Or in C#:

```csharp
class WindowManager
{
  List<Window> windows; 
};
```

### III. Aggregation (inclusion, part-part relationship)

In general, the mapping is exactly the same as for association.

### IV. Dependency (dependency)

It represents the loosest link between departments. Example:

Dependency

Meaning: the `Window` class depends on the `Graphics` class. That is, if the `Graphics` class is changed, the Window class may also need to be changed.
This connection type is used when the parameter list/return value of the methods of the class at the beginning of the dependency connection contains the class at the end of the connection. In the example, the `onDraw` operation of the `Window` class receives an object of the `Graphics` class as a parameter, and thus depends on it, since it can call the methods of the `Graphics` class in the method's trunk. If, for example, the name of the `FillRect` method of the `Graphics` class is changed, this change must be reflected in the call location, i.e., in the trunk of the `onDraw` method of the Window class.
