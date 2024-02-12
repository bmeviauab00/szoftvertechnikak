# Schnittstelle und abstrakte (angestammte) Klasse

Letztes Änderungsdatum: 2022.10.15  
Er hat trainiert: Zoltán Benedek

Das Kapitel enthält keine Übung, sondern bietet den Studierenden eine Einführung in die entsprechende Theorie.

## Abstrakte Klasse

Die Konzepte wurden bereits in früheren Themen behandelt, so dass wir jetzt nur die wichtigsten zusammenfassen und uns auf den C#\-Aspekt konzentrieren werden. Abstrakte Klasse Eine Klasse, die nicht instanziiert werden kann. In C# sollte in der Klassendefinition das abstrakte Schlüsselwort geschrieben werden, z.B.:

```csharp
abstract class Shape { ... }
```

Abstrakte Klassen können abstrakte Methoden haben, die keine Wurzel haben, und für diese abstrakten Methoden sollte das Schlüsselwort abstract verwendet werden:

```csharp
..
abstract void Draw();
..
```

Es gibt zwei Gründe für die Verwendung abstrakter Klassen:

- In einer Klassenhierarchie können wir Code, der allen Nachkommen gemeinsam ist, auf einen abstrakten gemeinsamen Vorfahren abbilden und so Code\-Duplikation vermeiden.
- Wir können uns einheitlich auf Nachkommen als abstrakte Vorfahren beziehen (z. B. heterogene Sammlungen).

in .NET, wie auch in Java, kann eine Klasse nur eine Vorgängerklasse haben.

## Schnittstelle

Eine Schnittstelle ist nichts anderes als eine Reihe von Operationen. Sie entspricht in der Tat einer abstrakten Klasse, deren sämtliche Operationen abstrakt sind.

In C# können Sie eine Schnittstelle mit dem Schlüsselwort `interface` definieren:

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

Während eine Klasse nur einen Vorfahren haben kann, kann sie eine beliebige Anzahl von Schnittstellen implementieren:

```csharp
public class Rect : Shape, ISerializable, IComparable
{
    ..
}
```

In diesem Beispiel ist die Klasse Rect von der Klasse Shape abgeleitet und implementiert die Schnittstellen `ISerializable` und `IComparable` (die Vorgängerklasse muss zuerst angegeben werden). In der Klasse, die die Schnittstelle implementiert, müssen alle ihre Operationen implementiert werden, d. h. ihr Stamm muss geschrieben werden (außer in dem seltenen Fall, dass sie durch eine abstrakte Operation implementiert wird). Die Verwendung von Schnittstellen hat vor allem einen Zweck. Als Schnittstelle referenziert, können wir alle Klassen, die die Schnittstelle implementieren, einheitlich verwalten (z. B. heterogene Sammlung). Eine Folge davon ist, dass **Schnittstellen es Ihnen ermöglichen, Klassen und Funktionen zu schreiben, die auf vielfältige** Weise **verwendet werden können**. Wir können zum Beispiel eine universelle Sortierfunktion schreiben, die mit jeder Klasse verwendet werden kann, die die Schnittstelle IComparable implementiert.

Weitere Vorteile der Nutzung der Schnittstelle sind:

- Der Client muss nur die Schnittstelle des Serverobjekts kennen, um den Server problemlos nutzen zu können.
- **Wenn der Client den Server nur über die Schnittstelle nutzt, so dass sich die interne Implementierung des Servers ändern kann, muss der Client nicht geändert (und auch nicht neu kompiliert) werden**. Dementsprechend ist die Schnittstelle auch ein Vertrag zwischen dem Server und dem Client: Solange der Server die Unterstützung für die Schnittstelle garantiert, braucht der Client nicht zu wechseln.

## Vergleich von abstraktem Vorfahren und Schnittstelle

Der Vorteil des abstrakten Vorgängers gegenüber der Schnittstelle besteht darin, dass Sie eine Standardimplementierung für die Operationen angeben und Membervariablen einschließen können.

Der Vorteil von Schnittstellen gegenüber abstrakten Vorfahren besteht darin, dass eine Klasse eine beliebige Anzahl von Schnittstellen implementieren kann, während ihr Vorfahre höchstens eine implementieren kann.

Die Verwendung von Schnittstellen hat noch eine weitere Konsequenz, die in einigen Fällen zu Unannehmlichkeiten führen kann. **Wenn eine neue Operation zur Schnittstelle hinzugefügt wird, müssen alle implementierenden Klassen ebenfalls erweitert werden, sonst lässt sich der Code nicht kompilieren. Dies ist bei der Erweiterung eines abstrakten Vorgängers nicht der Fall: Wenn Sie eine neue Operation hinzufügen, haben Sie die Möglichkeit, sie als virtuelle Funktion hinzuzufügen und ihr somit eine Standardimplementierung im Vorgänger zu geben**. In diesem Fall können die Nachkommen dies nach Belieben umdefinieren, sie sind nicht dazu gezwungen. Diese Eigenschaft von Schnittstellen kann für Klassenbibliotheken/Framework\-Systeme besonders unangenehm sein. Angenommen, eine neue Version von .NET wird veröffentlicht und eine neue Operation wird zu einer der Schnittstellen des Frameworks hinzugefügt. Alle implementierenden Klassen in allen Anwendungen müssen dann geändert werden, da der Code sonst nicht kompiliert werden kann. Es gibt zwei Möglichkeiten, dies zu vermeiden. Entweder durch Verwendung einer Legacy\-Klasse oder, wenn eine Schnittstelle erweitert werden soll, durch Einführung einer neuen Schnittstelle, die die neue Operation bereits enthält. Obwohl der erste Ansatz (Verwendung einer Vorgängerklasse) auf den ersten Blick attraktiver erscheint, hat er auch einen Nachteil: Wenn Sie bei der Entwicklung Ihrer Anwendung von einem Vorgänger im Framework ableiten, kann Ihre Klasse keinen weiteren Vorgänger haben, und das ist in vielen Fällen eine schmerzhafte Einschränkung.

Es ist wichtig zu wissen, dass ab C# 8 (oder .NET oder .NET Core Runtime, nicht unterstützt unter .NET Framework), **Schnittstellenoperationen eine Standardimplementierung (Standardschnittstellenmethoden) gegeben werden kann, so dass keine abstrakte Klasse benötigt wird, um das obige Problem zu lösen, aber eine Schnittstelle kann nicht mehr eine Mitgliedsvariable haben**. Weitere Informationen finden Sie hier: [Standardschnittstellenmethoden](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/proposals/csharp-8.0/default-interface-methods).

Da sowohl die Verwendung von Schnittstellen als auch von abstrakten Klassen negative Folgen haben kann, können wir in vielen Fällen das meiste aus unserer Lösung herausholen, wenn wir beides verwenden (d. h. unser Code kann ohne oder mit nur minimaler Code\-Duplizierung leicht erweitert werden).
