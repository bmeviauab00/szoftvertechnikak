---
authors: bzolka
---

# Die Theorie der Beziehung zwischen UML-Klassendiagramm und Code

Dieses Kapitel enthält keine Übungsaufgabe, sondern stellt den Studierenden die zugehörige Theorie vor.

## Einführung

Das Kapitel gibt einen kurzen, skizzenhaften Überblick über die Grundlagen der Abbildung zwischen UML-Klassendiagramm und Quellcode, als Wiederholung der im vorherigen Semester im Fach Softwaretechnologie gelernten Inhalte.

Heutzutage gibt es zahlreiche Softwareentwicklungsmethoden. Diese bauen in unterschiedlichem Maße darauf auf bzw. verlangen, dass während der Softwareerstellung Modellierung angewandt wird. Es steht jedoch außer Zweifel, dass selbst Anhänger der agilsten, am meisten „codezentrierten“ Vorgehensweisen die visuelle Modellierung wichtiger/komplexerer Komponenten und Strukturelemente der Software wegen ihrer größeren Ausdruckskraft durch die grafische Form als nützlich erachten.

Nehmen wir an, unsere Aufgabe ist die Erstellung einer Anwendung oder eines bestimmten Moduls davon. Folgend unserer gewählten Methodologie, durchlaufen wir – wahrscheinlich in mehreren Iterationen – die Schritte Anforderungsanalyse, Analyse, Entwurf, Implementierung und Test. Konzentrieren wir uns jetzt auf die Entwurfsphase. Dabei entsteht der detaillierte Entwurf des Systems (bzw. bestimmter Teile davon), dessen Ergebnis der detaillierte/Implementierungsplan und das Modell sind. Auf dieser Ebene lassen sich bestimmte Elemente im Modell (z. B. Klassen) eindeutig auf die Elemente der Programmiersprache abbilden, die für die Implementierung des jeweiligen Subsystems gewählt wurde. Wenn unser Entwickler-/Modellierungswerkzeug gut ist, kann es das Skelett der Klasse generieren (z. B. C++, Java, C# Klassen). Unsere Aufgabe ist es anschließend, die Methodenkörper im generierten Code zu füllen.

### Begriffe

- Forward Engineering: Code-Generierung aus dem Modell. Aus dem detaillierten Entwurf kann das Modellierungswerkzeug das Programmskelett generieren. Vorteil: es muss weniger kodiert werden.
- Reverse Engineering: Modell-Generierung aus Code. Hilft, bereits fertigen Code zu verstehen.
- Round-Trip Engineering: die kombinierte Anwendung der beiden vorherigen. Das Wesentliche: Modell und Code sind durchgängig synchron. Wenn im Code eine Änderung vorgenommen wird, erscheint diese Änderung im Modell, und wenn im Modell eine Änderung erfolgt, wird diese im Code sichtbar.

Um die Vorteile der Code-Generierung nutzen zu können, muss man Folgendes wissen: Man muss verstehen, wie das jeweilige Modellierungswerkzeug die einzelnen Modellelemente auf die Elemente der jeweiligen Programmiersprache abbildet. Die Abbildung hängt von der Sprache und dem Modellierungswerkzeug ab; es gibt keinen universellen Standard. Die Abbildungen sind meist selbsterklärend, größere Abweichungen sind selten.

Im Folgenden betrachten wir, wie die einzelnen Modellelemente eines UML-Klassendiagramms in Quellcode abgebildet werden und umgekehrt.

## Abbildung der Klassen

Man kann sagen, es ist trivial einfach:

- UML-Klasse -> Klasse
- UML-Attribut -> Feld (Membervariable)
- UML-Operation -> Methode

Ein Beispiel:

![Shape-Klasse](images/shapeclass.png)

entspricht folgendem Code in C#:

```csharp
public abstract class Shape
{
    private int x;
    private int y;
    public Shape(int x, int y) { this.x = x; this.y = y; }
    public abstract void Draw(Graphics gr);
}
```

Bezüglich der Sichtbarkeit erfolgt die Abbildung wie folgt:

- +: public
- -: private
- \#: protected

Eine spannendere Fragestellung ist, wie die Beziehungen zwischen Klassen abgebildet werden, dies wird in den folgenden Kapiteln behandelt.

### I. Generalisierungs- und Spezialisierungsbeziehung

![Generalisierung, Spezialisierung](images/alt-spec.png)

Abbildung in C#:

```csharp
public class Base
{ };
public class Derived : Base
{ };
```

### II. Assoziation

Dieser Beziehungstyp bedeutet immer Kommunikation zwischen den Objekten der Klassen. Eine bestimmte Klasse nutzt die Dienste einer anderen Klasse.

#### A) Abbildung bei einer 0..1-Multiplizitäts-Assoziationsbeziehung

In diesem Fall enthält die Client-Klasse einen Zeiger oder eine Referenz, über die sie die Dienste der Zielklasse in Anspruch nehmen kann (d.h. deren Methoden aufrufen kann).  
Beispiel:

![Generalisierung, Spezialisierung, einzelne Beziehung](images/association-single.png)

Abbildung in C++:

```cpp
class Application
{
   WindowManager* windowManager;
};

class WindowManager
{
};
```

Abbildung in C# (es gibt keine Zeiger, nur Referenzen):

```csharp
class Application
{
   WindowManager windowManager;
};

class WindowManager
{
};
```

In beiden Fällen sehen wir, dass **die Client-Klasse einen Zeiger- oder Referenz-Membervariable erhält, deren Typ mit dem der Zielklasse im Assoziationsverhältnis übereinstimmt, und deren Name der Rolle (role) entspricht, die in der Assoziation für die Zielklasse angegeben ist**, im Beispiel also `windowManager`.  
Die Abbildung ist logisch, da der Client über diesen Zeiger / diese Referenz auf das Zielobjekt zugreifen und dessen Methoden aufrufen kann.

Bemerkung: Es kann vorkommen, dass die Assoziation bidirektional ist, das heißt, beide Klassen nutzen die Dienste der jeweils anderen. In diesem Fall, anstatt einen Pfeil an beiden Enden der Assoziation anzubringen, wird er oft an beiden Enden weggelassen. In einer solchen zweiseitigen Assoziation muss die Rolle (role) an beiden Enden der Assoziation angegeben werden. In der Abbildung erhält dann jede Klasse einen Zeiger/eine Referenz auf die jeweils andere.

#### B) Abbildung bei 0..n-Multiplizitäts-Assoziationsbeziehung

In diesem Fall steht ein clientseitiges Objekt in Beziehung zu mehreren zielseitigen Objekten. Beispiel:

![Verallgemeinerung, Spezialisierung, Mehrfachverbindung](images/association-multiple.png)

Ein `WindowManager`-Objekt verwaltet mehrere `Window`-Objekte. **Bei der Abbildung wird in der Client-Klasse eine Sammlung von Zielobjekten aufgenommen.** Das kann ein Array, eine Liste usw. sein, je nachdem, was in der jeweiligen Situation am besten passt.

Eine mögliche Abbildung für das obige Beispiel in C++:

```cpp
class WindowManager
{
  vector<Window*> windows;
};
```

Und im C#:

```csharp
class WindowManager
{
  List<Window> windows; 
};
```

### III. Aggregation (Inklusion, Teil-Ganzes-Beziehung)

Im Allgemeinen erfolgt die Abbildung genauso wie bei der Assoziation.

### IV. Abhängigkeit (dependency)

Dies stellt die lockerste Beziehung zwischen Klassen dar. Beispiel:

![Dependency](images/dependency.png)

Die Bedeutung: Die Klasse `Window` hängt von der Klasse `Graphics` ab. Das heißt, wenn sich die Klasse `Graphics` ändert, muss eventuell auch die Klasse `Window` angepasst werden.  
Diese Art der Beziehung wird verwendet, wenn die Methoden der Klasse am Anfang der Abhängigkeitsbeziehung in ihrer Parameterliste oder ihrem Rückgabewert die Klasse am Ende der Beziehung verwenden.  
Im Beispiel erhält die Methode `onDraw` der Klasse `Window` als Parameter ein Objekt der Klasse `Graphics`, wodurch eine Abhängigkeit besteht, da in ihrem Methodenkörper Methoden der Klasse `Graphics` aufgerufen werden können. Wenn beispielsweise der Name der Methode `FillRect` der Klasse `Graphics` geändert wird, muss diese Änderung an allen Aufrufstellen vorgenommen werden, also auch im Methodenkörper von `Window`'s `onDraw`.