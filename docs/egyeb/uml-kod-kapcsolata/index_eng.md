---
authors: bzolka
---

# Theory of the relationship between the UML class diagram and code

The chapter does not contain any exercise, it introduces the related theory to students.

## Introduction

The chapter provides a brief, outline-based overview of the basics of mapping between UML class diagrams and source code, as a review of what was already learned in the previous semester in the Software Technology course.

Today, there are many software development methodologies. These methodologies vary in the extent to which they rely on or require modeling during software development. However, it is undeniable that even the followers of the most agile, "code-centric" approaches acknowledge the usefulness of visually modeling key/complex software components and structural elements due to the greater expressiveness of graphical representations.

Let’s assume our task is to develop an application or a specific module of it. Following our chosen methodology, we will go through the steps of requirements analysis, analysis, design, implementation and testing, probably in multiple iterations. Let's now focus on the design phase. This will result in a detailed design of the system (or at least parts of it), resulting in a detailed/implementation plan and model. At this level, certain elements of the model (e.g. classes) can be explicitly mapped to elements of the programming language chosen for implementing the subsystem. If we have a good development/modeling tool, it can generate class skeletons (e.g. C++, Java, C# classes). Our task then is to fill in the method bodies in the generated code.

### Concepts

- Forward engineering: generating code from a model. The modeling tool can generate a program skeleton from the detailed design. The advantage is that less manual coding is needed.
- Reverse engineering: generating a model from existing code. This helps to understand already written code.
- Round-trip engineering: a combined application of the previous two. The key idea is keeping the model and the code synchronized at all times. Changes in the code are reflected in the model, and changes in the model are reflected in the code.

In order to take advantage of code generation, we must understand how the modeling tool maps specific model elements to elements of the chosen programming language. The mapping depends on both the programming language and the modeling tool, there is no universal standard for it. The mappings are usually intuitive, with little significant variation.

In the following sections, we will examine how the different elements of a UML class diagram are mapped to source code and vice versa.

## Mapping of classes

It's trivially simple:

- UML class -> class
- UML attribute -> member variable
- UML operation -> operation/method

An example:

![Shape class](images/shapeclass.png)

which corresponds to the following C# code:

```csharp
public abstract class Shape
{
    private int x;
    private int y;
    public Shape(int x, int y) { this.x = x; this.y = y; }
    public abstract void Draw(Graphics gr);
}
```

Regarding visibility, the mapping is:

- +: public
- -: private
- \#: protected

A more interesting topic is how relationships between classes are mapped, which is explained in the following chapters.

### I. Generalization and Specialization Relationship

![Generalization, Specialization](images/alt-spec.png)

C# mapping:

```csharp
public class Base
{ };
public class Derived : Base
{ };
```

### II. Association

This type of relationship always represents communication between the objects of classes. A given class utilizes the services of another class.

#### A) Mapping of an association with 0..1 multiplicity

In this case, the client class contains a pointer or reference through which it can use the services of the target class (it can call its operations).
Example:

![Generalization, Specialization, Single Relationship](images/association-single.png)

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

In both cases, we see that **a pointer or reference member variable is added to the client class, whose type matches the type of the target class referenced in the association, and the name of the member variable corresponds to the role assigned to the target class in the association**, which in this example is `windowManager`.
The mapping is logical, since the client can access the target object from any of its methods and invoke its methods through this pointer/reference.

Note. The association may be bidirectional, meaning both classes use each other's services. In such cases, instead of putting an arrow at both ends of the association, the arrows at both ends are often omitted. In a bidirectional relationship, the role must be specified at both ends. When mapping, both classes must contain a pointer/reference to the other.

#### B) Mapping in the case of a 0..n multiplicity association

In this case, a client-side object is associated with multiple target-side objects. Example:

![Generalization, specialization, multiple association](images/association-multiple.png)

One `WindowManager` object manages multiple `Window` objects. **In the mapping process, the client class contains some kind of collection of objects from the target class.** This can be an array, list, etc., depending on what is most suitable for our specific situation.

A possible mapping for the above example in C++:

```cpp
class WindowManager
{
  vector<Window*> windows;
};
```

And in C#:

```csharp
class WindowManager
{
  List<Window> windows; 
};
```

### III. Aggregation (containment, part-Whole relationship)

Typically, the mapping is done in exactly the same way as for associations.

### IV. Dependency

This represents the loosest relationship between classes. Example:

![Dependency](images/dependency.png)

Its meaning: the `Window` class depends on the `Graphics` class. In other words, if the `Graphics` class changes, it might be necessary to modify the `Window` class as well.
This type of relationship is typically used when the methods of the class at the beginning of the dependency relationship include the class at the end of the relationship in their parameter list or return type. In the example, the `onDraw` operation of the `Window` class receives an object of the `Graphics` class as a parameter, making it dependent on it because the method body can call methods from the `Graphics` class. For example, if we change the name of the `FillRect` method in the `Graphics` class, this change must be reflected where the method is called, i.e., in the body of the `Window` class's `onDraw` method as well.
