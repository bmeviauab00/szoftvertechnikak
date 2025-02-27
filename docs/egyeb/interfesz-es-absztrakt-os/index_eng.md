# Interface and abstract (base) class

The chapter does not contain exercises; instead, it introduces the related theory for the students.

## Abstract class 

The concepts have already been introduced within the context of earlier subjects, so now we will only summarize the most important points and focus on their relevance to C#.

Abstract class: a class that cannot be instantiated.  In C#, the `abstract` keyword must be used in the class definition, for example:

```csharp
abstract class Shape { ... }
```

Abstract classes can have abstract methods, where the body is not provided, and the `abstract` keyword must also be used for these:

```csharp
...
abstract void Draw();
...
```

There are two purposes for using abstract classes:

- In a class hierarchy, we can place common code for the descendants in an abstract common base class, thus avoiding code duplication.
- We can uniformly handle descendants by referring to them as abstract ancestors (e.g., heterogeneous collections).

In the .NET environment, just like in Java, a class can only have one base class (single inheritance).

## Interface

An interface is nothing more than a set of operations. Essentially, it corresponds to an abstract class where all the methods are abstract.

In C#, we can define an interface using the `interface` keyword:

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

In this example, the `Rect` class inherits from the `Shape` class and implements the `ISerializable` and `IComparable` interfaces (the base class must always be specified first). The class implementing the interface must implement all of its operations, meaning it must define the body of the methods (except in the rare case when they are implemented with an abstract method).
The main purpose of using interfaces is to enable uniform handling of all classes that implement the interface (e.g., in heterogeneous collections). A consequence of this is that **interfaces allow us to write classes and functions that can be widely used**. For example, it is possible to write a universal `Sort` function that can be used with any class that implements the `IComparable` interface.

Other advantages of using the interface include:

- The client only needs to be familiar with the server object’s interface, making it simple to use the server.
- **If the client uses the server through the interface only, the server's internal implementation can change, and the client doesn’t need to be modified (or even recompiled)**. Accordingly, the interface acts as a contract between the server and the client: as long as the server guarantees support for the interface, the client does not need to change.

## Comparison of abstract base class and interface

The advantage of an abstract base class over an interface is that we can provide default implementations for the methods and add member variables.

The advantage of interfaces over abstract base classes is that a class can implement any number of interfaces, while it can have at most one base class.

There is another consequence of using interfaces, which can cause inconvenience in some cases. **When a new operation is added to the interface, all implementing classes must also be extended, otherwise the code will not compile. In contrast, when we extend an abstract base class, this is not the case: if we add a new method, we can add it as a virtual function and provide a default implementation in the base class**. In this case, the derived classes can override it if necessary, but they are not forced to. This property of interfaces can be particularly inconvenient in class libraries/frameworks. Let’s assume that a new version of the .NET framework adds a new method to one of its interfaces. Then, in all applications, all implementing classes must be modified, or the code will not compile. There are two ways to avoid this. Either by using a base class, or if we must extend an interface, by introducing a new interface that includes the new method. Although the first approach (using a base class) may seem more attractive at first, it also has a downside: if we derive our class from a framework base class during application development, our class cannot have any other base class, and this can be a painful restriction in many cases.

It's worth to know that starting from C# 8 (and with .NET or .NET Core runtime, as it is not supported under .NET Framework), **interface methods can have default implementations  (default interface methods), so no abstract class is needed to solve the above problem, but an interfaces still cannot have member variables**. More information here: [default interface methods](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/proposals/csharp-8.0/default-interface-methods).

Since both interfaces and abstract base classes can have negative consequences, in many cases, we can get the most out of our solution by using both together (i.e., our code will be easily extensible without or with minimal code duplication).
