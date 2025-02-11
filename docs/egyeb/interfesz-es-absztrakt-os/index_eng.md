# Interface and abstract (base) class

The chapter does not contain exercises; instead, it introduces the related theory for the students.

## Abstract class

The concepts have already been introduced within the context of earlier subjects, so now we will only summarize the most important points and focus on their relevance to C#.

Abstract class: a class that cannot be instantiated.  In C#, the abstract keyword must be used in the class definition, for example:

```csharp
abstract class Shape { ... }
```

Abstract classes can have abstract methods, for which no body is provided. The abstract keyword must also be used for these methods:

```csharp
...
abstract void Draw();
...
```

The use of abstract classes can serve two purposes:

- In a class hierarchy, common code can be moved into an abstract base class, allowing derived classes to inherit this shared functionality. This helps avoid code duplication.
- Abstract base classes enable a unified way to reference and manage derived classes, such as in heterogeneous collections.

In the .NET environment, just like in Java, a class can only have one direct base class (single inheritance).

## Interface

An interface is nothing more than a set of operations. In fact, it corresponds to an abstract class whose all operations are abstract.

In C# you can define an interface with the `interface` keyword:

```csharp
public interface ISerializable 
{
   void WriteToStream(Stream s);
   void LoadFromStream(Stream s);
}

public interface IComparable 
{
   int CompareTo(Object obj);
}
```

While a class can have only one base class, it can implement any number of interfaces:

```csharp
public class Rect : Shape, ISerializable, IComparable
{
    ...
}
```

In this example, the `Rect` class inherits from the `Shape` class and implements the `ISerializable` and `IComparable` interfaces (the base class must always be specified first). In a class that implements an interface, all of its operations must be implemented, meaning their bodies must be written (except for the rare case where they are implemented with an abstract method).
The primary purpose of using interfaces is to enable uniform handling of all classes that implement the interface (e.g., in heterogeneous collections). One consequence of this is that **interfaces allow the creation of widely reusable classes and functions**. For example, it is possible to write a universal `Sort` function that can be used with any class that implements the `IComparable` interface.

Other benefits of using the interface include:

- The client only needs to know the interface of the an object to be able to use the server object easily.
- **If the client only uses the server through the interface, so the internal implementation of the server may change, the client does not need to be modified (nor recompiled)**. Accordingly, the interface is also a contract between the server and the client: as long as the server guarantees support for the interface, the client does not need to change.

## Comparison of abstract base class and interface

The advantage of an abstract base class over an interface is that it allows providing default implementations for operations and adding member variables.

The advantage of interfaces over abstract base classes is that a class can implement any number of interfaces, whereas it can only inherit from only one base class.

There is another consequence of using interfaces, which can cause inconvenience in some cases. **When a new operation is added to the interface, all implementing classes must also be extended, otherwise the code will not compile. This is not the case when extending an abstract base class: if you add a new operation, you have the option to add it as a virtual function, and thus give it a default implementation in the derived class**. In this case, the descendants can redefine this as they wish, they are not forced to do so. This feature of interfaces can be particularly inconvenient for class libraries/framework systems. Suppose a new version of .NET is released and a new operation is added to one of the interfaces of the framework. All implementing classes in all applications must then be modified, otherwise the code will not compile. There are two ways to avoid this. Either by using a legacy class, or, if an interface should be extended, by introducing a new interface that already contains the new operation. Although the first approach (using a base class) may seem more appealing at first glance, it also has a drawback: if we derive our class from a framework base class during application development, our class cannot have any other base class, and this can often impose a painful limitation.

It's worth knowing that starting from C# 8 (or .NET or .NET Core runtime, not supported under .NET Framework), **interface operations can be given a default implementation (default interface methods), so no abstract class is needed to solve the above problem, but an interface still can't have member variables**. More information here: default interface methods.

Since using both interfaces and abstract classes can have negative consequences, in many cases we can get the most out of our solution by using both (i.e., our code can be easily extended with no or minimal code duplication).
