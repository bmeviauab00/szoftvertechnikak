# Interface and abstract (base) class

Last modified date: 2022.10.15
Edited by Zoltán Benedek

The chapter does not contain an exercise, it introduces the related theory to students.

## Abstract class

The concepts have been covered in previous topics, so for now we will just summarize the most important ones and focus on the C# aspect.
Abstract class
A class that cannot be instantiated. In C#, in the class definition, the abstract keyword must be written out, e.g.:

```csharp
abstract class Shape { ... }
```

Abstract classes may have abstract methods that do not have a root, and for these abstract methods the abstract keyword should be used:

```csharp
...
abstract void Draw();
...
```

There are two purposes for using abstract classes:

- In a class hierarchy, we can map code common to descendants into an abstract common base class, thus avoiding code duplication.
- We can uniformly refer to descendants as abstract base classes (e.g. heterogeneous collections).

in .NET, as in Java, a class can have only one base class class.

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

In this example, the Rect class is derived from the Shape class and implements the `ISerializable` and `IComparable` interfaces (mandatory to specify the base class first). In a class implementing an interface, all its operations must be implemented, i.e., its trunk must be written (except in the rare case where it is implemented by an abstract operation).
There is one main purpose for using interfaces. Referenced as an interface, we can uniformly manage all the classes that implement the interface (e.g., a heterogeneous collection). One consequence of this is that **interfaces allow us to write classes and functions that can be used in a wide variety of** ways. For example, we can write a universal Sort ordering function that can be used with any class that implements the IComparable interface.

Other benefits of using the interface include:

- The client only needs to know the interface of the server object to be able to use the server easily.
- **If the client only uses the server through the interface, so the internal implementation of the server may change, the client does not need to be modified (nor recompiled)**. Accordingly, the interface is also a contract between the server and the client: as long as the server guarantees support for the interface, the client does not need to change.

## Comparison of abstract base class and interface

The advantage of the abstract base class over the interface is that you can specify a default implementation for the operations and include member variables.

The advantage of interfaces over abstract ancestors is that a class can implement any number of interfaces, while its base class can implement at most one.

There is another consequence of using interfaces, which can cause inconvenience in some cases. **When a new operation is added to the interface, all implementing classes must also be extended, otherwise the code will not compile. This is not the case when extending an abstract base class: if you add a new operation, you have the option to add it as a virtual function, and thus give it a default implementation in the ancestor**. In this case, the descendants can redefine this as they wish, they are not forced to do so. This feature of interfaces can be particularly inconvenient for class libraries/framework systems. Suppose a new version of .NET is released and a new operation is added to one of the interfaces of the framework. All implementing classes in all applications must then be modified, otherwise the code will not compile. There are two ways to avoid this. Either by using a legacy class, or, if an interface should be extended, by introducing a new interface that already contains the new operation. Although the first approach (using an base class class) seems more attractive at first sight, it also has a drawback: if you derive from an ancestor in the framework when developing your application, your class can have no other ancestor, and this is a painful constraint in many cases.

It's worth knowing that starting from C# 8 (or .NET or .NET Core runtime, not supported under .NET Framework), **interface operations can be given a default implementation (default interface methods), so no abstract class is needed to solve the above problem, but an interface can no longer have a member variable**. More information here: default interface methods.

Since using both interfaces and abstract classes can have negative consequences, in many cases we can get the most out of our solution by using both (i.e., our code can be easily extended with no or minimal code duplication).
