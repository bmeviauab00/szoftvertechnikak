# Theorie der Beziehung zwischen dem UML-Klassendiagramm und dem Code

Letztes Änderungsdatum: 2022.10.15  
Ausgearbeitet von: Zoltán Benedek

Das Kapitel enthält keine Übung, sondern bietet den Studierenden eine Einführung in die entsprechende Theorie.

## Einführung

Das Kapitel gibt einen kurzen Überblick über die Grundlagen des Mappings zwischen dem UML-Klassendiagramm und dem Quellcode, als Wiederholung dessen, was bereits im vorherigen Semester in Softwarechnologien gelernt wurde.

Heutzutage gibt es viele Softwareentwicklungsmethoden. Sie stützen sich bei der Erstellung der Software in unterschiedlichem Maße auf die Modellierung bzw. erfordern diese. Es besteht jedoch kein Zweifel daran, dass selbst die Anhänger der agilsten, "code-zentrierten" Ansätze es für nützlich halten, die wichtigeren/komplexeren Komponenten und Strukturelemente der Software visuell zu modellieren, da deren grafische Natur eine größere Ausdruckskraft hat.

Nehmen wir an, man muss eine Anwendung oder ein bestimmtes Modul einer Anwendung erstellen. Nach der von sich gewählten Methodik wird man die Schritte Anforderungsanalyse, Analyse, Entwurf, Implementierung und Test durchführen, wahrscheinlich in mehreren Iterationen. Konzentrieren wir uns nun auf die Entwurfsphase. Das Ergebnis ist ein detaillierter Entwurf des Systems (zumindest von Teilen davon), der in einen detaillierten Plan oder ein Modell für die Umsetzung mündet. Auf dieser Ebene können bestimmte Elemente des Modells (z. B. Klassen) explizit auf Elemente der für die Implementierung des Teilsystems gewählten Programmiersprache abgebildet werden. Wenn man über ein gutes Entwicklungs-/Modellierungswerkzeug verfügt, kann dieses das Klassenskelett (z. B. C++, Java-, C#-Klassen) generieren. Unsere Aufgabe besteht nun darin, die Wurzel der Methoden in den generierten Code einzutragen.

### Konzepte

- Forward Engineering: Generierung von Code aus einem Modell. Aus dem detaillierten Plan kann das Modellierungswerkzeug das Programmgerüst erstellen. Der Vorteil ist, dass weniger Kodierung erforderlich ist.
- Reverse Engineering: Generierung eines Modells aus Code. Es hilft Ihnen, den bereits vorhandenen Code zu verstehen.
- Round-Trip-Engineering: eine Kombination der beiden vorgenannten Verfahren. Der springende Punkt ist, dass das Modell und der Code ständig synchronisiert sind. Wenn Sie den Code ändern, erscheint die Änderung im Modell, wenn Sie das Modell ändern, erscheint die Änderung im Code.

Um die Vorteile der Codegenerierung nutzen zu können, muss man Folgendes wissen: man muss wissen, wie ein bestimmtes Modellierungswerkzeug jedes Modellelement auf Elemente einer bestimmten Programmiersprache abbildet. Das Mapping hängt von der Sprache und dem Modellierungswerkzeug ab, es gibt keinen universellen Standard. Die Zuordnungen sind in der Regel selbsterklärend, es gibt in der Regel nicht allzu viele Variationen.

Im Folgenden werden wir uns ansehen, wie jedes Modellelement des UML-Klassendiagramms auf den Quellcode abgebildet wird und umgekehrt.

## Zuordnung von Klassen

Es ist trivial einfach:

- UML-Klasse -> Klasse
- UML-Attribut -> Mitgliedsvariable
- UML-Operation -> Funktion/Method

Ein Beispiel:

![Klasse Shape](images/shapeclass.png)

, was folgendem Code in C# entspricht:

```csharp
public abstract class Shape
{
    private int x;
    private int y;
    public Shape(int x, int y) { this.x = x; this.y = y; }
    public abstract void Draw(Graphics gr);
}
```

Im Zusammenhang mit der Sichtbarkeit, Kartierung:

- +: public
- -: private
- \# : protected

Eine spannendere Frage ist, wie die Beziehungen zwischen den Klassen abgebildet werden, und dies wird in den folgenden Kapiteln diskutiert.

### I. Generalisierung und Spezialisierung

![Generalisierung, Spezialisierung](images/alt-spec.png)

C#-Zuordnung:

```csharp
public class Base
{ };
public class Derived : Base
{ };
```

### II. Assoziation

Dieser Beziehungstyp impliziert immer eine Kommunikation zwischen Objekten von Klassen. Eine Abteilung nimmt die Dienste einer anderen Abteilung in Anspruch.

#### A) Aufbau einer 0..1-Multiplizitäts-Assoziationsbeziehung

In diesem Fall enthält die Client-Klasse einen Zeiger oder Verweis, über den sie die Dienste der Zielklasse nutzen (ihre Operationen aufrufen) kann. Beispiel:

![Generalisierung, Spezialisierung, einheitlicher Ansprechpartner](images/association-single.png)

C++-Zuordnung:

```cpp
klasse Bewerbung
{
   WindowManager* windowManager;
};

class WindowManager
{
};
```

C#-Zuordnung (keine Zeiger, nur Referenzen):

```csharp
class Application
{
   WindowManager windowManager;
};

class WindowManager
{
};
```

In beiden Fällen sehen wir, dass **wir der Client-Klasse eine Zeiger- oder Referenz-Member-Variable hinzufügen, die vom gleichen Typ ist wie die Zielklasse, auf die in der Assoziation verwiesen wird, und der Name der Member-Variable ist die Rolle, die der Zielklasse für die Assoziationsbeziehung gegeben wurde**, die in diesem Beispiel `windowManager`ist. Die Zuordnung ist logisch, da der Client auf das Zielobjekt aus jeder seiner Operationen zugreifen und seine Methoden über diesen Zeiger/Verweis aufrufen kann.

Kommentar. Manchmal ist die Assoziation in beide Richtungen, wobei jede Klasse die Dienste der anderen nutzt. Anstatt einen Pfeil an beiden Enden der Assoziation anzubringen, lassen wir ihn oft an beiden Enden stehen. In einer solchen wechselseitigen Beziehung muss die Rolle an beiden Enden der Beziehung angegeben werden. Während des Mappings fügen wir einen Zeiger/Referenz auf jede Klasse der anderen hinzu.

#### B) Ableitung für eine Assoziationsbeziehung mit der Multiplizität 0..n

In diesem Fall ist ein Objekt auf der Client-Seite mit mehreren Objekten auf der Zielseite verbunden. Beispiel:

![Generalisierung, Spezialisierung, Mehrfachverknüpfungen](images/association-multiple.png)

Ein `WindowManager` Objekt verwaltet mehrere `Window` Objekte. **Das Mapping übernimmt eine Sammlung von Objekten der Zielklasse in die Client-Klasse.** Dabei kann es sich um ein Array, eine Liste usw. handeln, je nachdem, was für unsere Zwecke in der jeweiligen Situation am besten geeignet ist.

Eine Abbildung des obigen Beispiels in C++:

```cpp
class WindowManager
{
  vector<Window*> windows;
};
```

Oder in C#:

```csharp
class WindowManager
{
  List<Window> windows; 
};
```

### III. Aggregation (Einbeziehung, Teil-Ganzes-Beziehung)

Im Allgemeinen ist die Zuordnung genau die gleiche wie bei der Assoziation.

### IV. Abhängigkeit (Dependenz)

Sie stellt die lockerste Verbindung zwischen den Abteilungen dar. Beispiel:

![Abhängigkeit](images/dependency.png)

Das bedeutet: Die Klasse `Window` hängt von der Klasse `Graphics` ab. Das heißt, wenn die Klasse `Graphics` geändert wird, muss möglicherweise auch die Klasse Window geändert werden. Diese Art der Beziehung wird verwendet, wenn die Parameterliste/Rückgabewerte der Methoden der Klasse am Anfang der Abhängigkeitsbeziehung die Klasse am Ende der Beziehung enthält. Im Beispiel erhält die Operation `onDraw` der Klasse `Window` ein Objekt der Klasse `Graphics` als Parameter und ist somit von dieser abhängig, da sie die Methoden der Klasse `Graphics` im Stamm der Methode aufrufen kann. Wird z.B. der Name der Methode `FillRect` der Klasse `Graphics` geändert, muss sich diese Änderung in der Aufrufstelle, d.h. im Stamm der Methode onDraw der Klasse `Window` widerspiegeln.
