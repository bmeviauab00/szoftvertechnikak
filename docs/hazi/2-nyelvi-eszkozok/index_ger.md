---
autoren: BenceKovari,bzolka
---

# HA 2 - Sprachliche Mittel

## Einführung

Die selbstständige Aufgabe baut auf den Inhalten der 2. Vorlesung und der ersten Hälfte der 3. Vorlesung auf. Als praktischer Hintergrund dient die [Laborübung 2. - Sprachliche Mittel](../../labor/2-nyelvi-eszkozok/index_ger.md).

Aufbauend auf den oben genannten Inhalten können die Aufgaben dieser Hausaufgabe mit der Hilfe der kürzeren Leitfäden nach der Aufgabenbeschreibung gelöst werden.

Das Ziel der Hausaufgabe:

- Übung der Verwendung von Eigenschaften (property)
- Anwendung von Delegaten (delegate) und Ereignissen (event)
- Übung der Verwendung von .NET-Attributen
- Übung der Verwendung grundlegender Sammlungstypen
- Übung von Lambda-Ausdrücken

Die erforderliche Entwicklungsumgebung wird [hier](../fejlesztokornyezet/index_ger.md) beschrieben.

!!! warning "Verwendung von Sprachelementen aus C# 12 (und neuer)"
    Bei der Lösung der Hausaufgabe dürfen Sprachelementen von C# 12 und neuer (z. B. primary constructor) NICHT verwendet werden, da das auf GitHub laufende Prüfsystem diese noch nicht unterstützt.

## Abgabeablauf, Vorprüfung

Der Ablauf der Eingabe entspricht dem der ersten Hausaufgabe (detaillierte Beschreibung an der üblichen Stelle, siehe [Hausaufgaben-Workflow und die Verwendung von Git/GitHub](../hf-folyamat/index.md)):

1. Erstelle mit GitHub Classroom ein eigenes Repository. Die Einladungs-URL findest du in Moodle (bei Hausaufgabe 2.). Wichtig ist, dass du die richtige Einladungs-URL für diese Hausaufgabe verwendest (für jede Hausaufgabe gibt es eine andere URL).
2. Klone das so erstellte Repository. Dieses enthält die erwartete Struktur der Lösung.
3. Nach der Fertigstellung der Aufgaben committe und pushe deine Lösung.

Die Vorprüfung funktioniert ebenfalls auf die übliche Weise. Detaillierte Beschreibung: [Vorprüfung und offizielle Bewertung der Hausaufgabe](../eloellenorzes-ertekeles/index.md).

## Aufgabe 1 – Die dunkle Bedrohung

### Aufgabe

Wie es bewusst ist, stammt die Macht der Jedi-Ritter von den kleinen Lebensformen, den sogenannten Midi-Chlorianern, die in ihren Zellen leben. Der bisher höchste gemessene Midi-Chlorian-Wert (über 20.000) wurde bei Anakin Skywalker festgestellt.

Erstelle eine Klasse mit dem Namen `Jedi`, die eine `string`-Eigenschaft `Name` und eine `int`-Eigenschaft `MidiChlorianCount` hat. Achte im letzteren Fall darauf, dass der Wert von `MidiChlorianCount` nicht auf 35 oder einen kleineren Wert gesetzt werden kann. Wenn jemand dies versucht, muss die Klasse eine Ausnahme auslösen. Wähle bei der Validierung die einfachste und klarste Lösung: Verwende im Setter der Property ein einfaches `if` und löse eine Ausnahme aus. Das `if` soll keinen `else`-Zweig haben, und die Verwendung von `return` ist ebenfalls nicht notwendig.

### Lösung

Die Lösung der Aufgabe kann analog zur [1. Aufgabe des 2. Labors](../../labor/2-nyelvi-eszkozok/index_ger.md#1-aufgabe-Eigenschaft-property) erstellt werden. Im Setter der Eigenschaft `MidiChlorianCount` soll bei einem ungültigen Wert eine Ausnahme ausgelöst werden. Dies kann beispielsweise mit der folgenden Anweisung erfolgen:

```csharp
throw new ArgumentException("You are not a true jedi!");
```

## Aufgabe 2 – Angriff der Klonkrieger

### Aufgabe

Erweitere die in Aufgabe 1 erstellte Klasse mit Attributen, sodass wenn eines `Jedi`-Objekts in eine XML-Datei mithilfe der `XmlSerializer`-Klasse geschrieben/serialisiert wird, die Eigenschaften als XML-Attribute als `JediName` und `JediMidiChlorianCount` angezeigt werden! Schreibe danach eine Funktion, die eine Instanz der `Jedi`-Klasse in eine Textdatei serialisiert und dann wieder in ein neues Objekt einliest (dadurch wird das ursprüngliche Objekt praktisch geklont).

!!! tip "Attribute für XML-Serialisierung"
    Die Attribute, die die XML-Serialisierung steuern, sollen über den Eigenschaften und **nicht** über den Membervariablen platziert werden!

!!! tip "Die Jedi-Klasse soll öffentlich sein"
    Der XML-Serializer kann nur mit öffentlichen Klassen arbeiten, daher soll die Jedi-Klasse öffentlich sein:
    ```csharp
    public class Jedi { ...}
    ```

!!! danger "Wichtig"
    Schreibe den Code, der das Specihern und Einlesen verwirklicht/demonstriert, in eine gemeinsame, dafür dedizierte Funktion, und versehe die Funktion mit dem C#-Attribut `[Description("Task2")]` (direkt über die Zeile der Funktion). Das gespeicherte/geladene Objekt soll als lokale Variable in dieser Funktion implementiert werden. Der Name der Klasse/Funktion kann beliebig sein (z. B. kann sie auch in die `Program`-Klasse gesetzt werden). Die Funktion darf keinen Code enthalten, der nicht zur Aufgabe gehört, also auch keinen, der zu anderen (Teil-)Aufgaben gehört. Rufe die Funktion aus der `Main`-Methode der `Program`-Klasse auf. Um das oben genannte Attribut zu verwenden, muss der Namespace `System.ComponentModel` eingebunden werden.

    Die folgenden sind wesentlich:

    - das Attribut soll über die Funktion und NICHT über die Klasse geschrieben werden,  
    - das Attribut soll über der Test-/Demonstrationsfunktion platziert werden und **nicht** über der Funktion, die die Logik implementiert,  
    - **das Attribut darf nur über einer einzigen Funktion stehen.**

### Lösung

Die Aufgabe kann analog zur [4. Aufgabe des 2. Labors](../../labor/2-nyelvi-eszkozok/index_ger.md#4-aufgabe-attribute) gelöst werden. Für die Lösung geben wir folgende Hilfen:

- Nach der Serialisierung sollte die XML-Datei in etwa wie folgt aussehen:

    ```xml
    <?xml version="1.0"?>
    <Jedi xmlns:xsi="..." JediName="Obi-Wan" JediMidiChlorianCount="15000" />
    ```

    Wesentlich ist, dass jede Jedi-Instanz als `Jedi`-XML-Element erscheint, ihr Name als `JediName` und die Midi-Chlorian-Zahl als `JediMidiChlorianCount`-XML-Attribut dargestellt wird.

- Zum Laden der serialisierten Objekte geben wir hier Beispielcode, da dies im Labor nicht behandelt wurde:

    ```csharp
    var serializer = new XmlSerializer(typeof(Jedi));
    var stream = new FileStream("jedi.txt", FileMode.Open);
    var clone = (Jedi)serializer.Deserialize(stream);
    stream.Close();
    ```

    Der vorherige Code erstellt zuerst einen Serializer (`serializer`), mit dem das Einlesen später durchgeführt wird. Das Einlesen erfolgt aus einer Datei namens `jedi.txt`, die in der zweiten Zeile zum Lesen geöffnet wird (beachte, dass wir beim Schreiben `FileMode.Create` hätten verwenden müssen).

## Aufgabe 3 – Die Rache der Sith

### Aufgabe

Im Jedi-Rat herrscht in letzter Zeit eine hohe Fluktuation. Um die Änderungen leichter verfolgen zu können, erstelle eine Klasse, die die Mitglieder des Rates verwalten kann und bei jeder Änderung eine Benachrichtigung als Ereignis in Form eines Textes sendet! Die Liste soll über zwei Funktionen manipuliert werden. Die Funktion `Add` registriert einen neuen Jedi-Ritter im Rat, während die Funktion `Remove` das **zuletzt** hinzugefügte Mitglied entfernt. Eine besondere Benachrichtigung zeigt an, wenn der Rat vollständig geleert ist (verwende hierfür dasselbe Ereignis wie für die anderen Änderungen, aber mit anderem Text).

Die Mitglieder (`members`) werden in einer Feldvariablen vom Typ `List<Jedi>` gespeichert. Die Funktion `Add` fügt neue Elemente dieser Liste hinzu, während `Remove` mit dem generischen Listenbefehl `RemoveAt` immer das **zuletzt** hinzugefügte Mitglied entfernt (den Index des letzten Elements kann man über die Länge der Liste ermitteln, die die Property `Count` zurückgibt).

Die Benachrichtigung erfolgt über ein C#-Ereignis (C# event). Der zugehörige Delegate-Typ erhält als Parameter einen einfachen `string`. Die Hinzufügung eines neuen Mitglieds, das Entfernen einzelner Mitglieder und das Entfernen des letzten Mitglieds werden durch Nachrichten mit unterschiedlichem Text signalisiert. Das Auslösen des Events erfolgt direkt in den `Add`- und `Remove`-Operationen (führe dafür keine Hilfsfunktion ein).

Verwende für den Event-Typ keinen eingebauten Delegate-Typ, sondern definiere einen eigenen.

!!! danger "Wichtig"
    Der Code zum Erstellen des Jedi-Rats-Objekts und zum Testen (Abonnieren auf C#-Ereignis, Aufrufe von `Add` und `Remove`) soll in eine gemeinsame, dafür dedizierte Funktion geschrieben werden, die mit dem C#-Attribut `[Description("Task3")]` versehen wird. Der Name der Klasse/Funktion kann beliebig sein. Die Funktion darf keinen Code enthalten, der nicht zur Aufgabe gehört, also auch keinen, der zu anderen (Teil-)Aufgaben gehört. Rufe die Funktion aus der `Main`-Methode der `Program`-Klasse auf.

    Die folgenden sind wesentlich:

    - das Attribut soll über die Funktion und NICHT über die Klasse geschrieben werden,  
    - das Attribut soll über der Test-/Demonstrationsfunktion platziert werden und **nicht** über der Funktion, die die Logik implementiert,  
    - das Attribut darf nur über einer einzigen Funktion stehen.

### Lösung

Die Aufgabe baut auf mehreren Teilen des 2. Labors auf. Die Einführung des neuen Ereignisses kann analog zu den Aufgaben 2 und 3 durchgeführt werden, während die Mitglieder des Rates in einer Liste verwaltet werden.

Versuche anhand der oben genannten Informationen, die Aufgabe selbstständig zu lösen. Wenn du fertig bist, lies die Anleitung im nächsten ausklappbaren Block weiter und vergleiche deine Lösung mit der Referenzlösung unten! Korrigiere deine Lösung falls nötig!

!!! tip "Öffentliche Sichtbarkeit"
    Das Beispiel geht davon aus, dass die beteiligten Klassen, Eigenschaften und Delegates öffentlich sind. Wenn du auf seltsame Kompilierungsfehler stößt oder der `XmlSerializer` zur Laufzeit einen Fehler wirft, überprüfe zuerst, ob überall die Sichtbarkeit korrekt auf `public` gesetzt ist.

??? example "Referenzlösung"
    Die Schritte der Referenzlösung sind:

    1. Erstelle eine neue Klasse namens `JediCouncil`.
    2. Füge ein Feld vom Typ `List<Jedi>` hinzu und initialisiere es mit einer leeren Liste.
    3. Implementiere die Methoden `Add` und `Remove`.

        Nach diesen Schritten erhält man folgenden Code:

        ```csharp
        public class JediCouncil
        {
            List<Jedi> members = new List<Jedi>();

            public void Add(Jedi newJedi)
            {
                members.Add(newJedi);
            }

            public void Remove()
            {
                // Entfernt das letzte Element der Liste
                members.RemoveAt(members.Count - 1);
            }
        }
        ```

        Als nächstes wird die Ereignisbehandlung implementiert.

    4. Definiere einen neuen Delegatetyp (außerhalb der Klasse, da dies ebenfalls ein Typ ist), der die Benachrichtigungstexte überträgt:

        ```csharp
        public delegate void CouncilChangedDelegate(string message);
        ```

    5. Ergänze die `JediCouncil`-Klasse mit dem Ereignishandler:

        ```csharp hl_lines="3"
        public class JediCouncil
        {
            public event CouncilChangedDelegate CouncilChanged;

            // ...
        }
        ```

    6. Löse das Ereignis aus, wenn ein neues Mitglied hinzugefügt wird. Hierzu wird die `Add`-Methode erweitert:

        ```csharp
        public void Add(Jedi newJedi)
        {
            members.Add(newJedi);

            // TODO: Auslösen des Ereignisses.
            // Beachte, dass du dies nur tun solltest, wenn mindestens ein Teilnehmer/Abonnent registriert ist.
            // Verwende die moderne, kurze Syntax ?.Invoke, statt einer Nullprüfung.
        }
        ```

    7. Löst das Ereignis aus, wenn ein Mitglied entfernt wird. Unterscheide den Fall, dass der Rat vollständig geleert ist. Hierzu die `Remove`-Methode erweitern:

        ```csharp
        public void Remove()
        {
            // Entfernt das letzte Element der Liste
            members.RemoveAt(members.Count - 1);

            // TODO: Auslösen des Ereignisses.
            // Beachte, dass du dies nur tun solltest, wenn mindestens ein Teilnehmer/Abonnent registriert ist.
        }
        ```

    8. Um die Lösung zu testen, erstelle eine `MessageReceived`-Funktion in der Klasse, in der wir die Anmeldung für das Ereignis und die Ereignisbehandlung testen möchten (z. B. in der `Program`-Klasse). Diese Funktion werden wir für die Benachrichtigungen des JediCouncil anmelden.

        ```csharp title="Program.cs"
        private static void MessageReceived(string message)
        {
            Console.WriteLine(message);
        }
        ```

    9. Zum Schluss testen wir unsere neue Klasse mit einer für diesen Zweck dedizierte Funktion (z. B. in der `Program`-Klasse), die mit dem `[Description("Task3")]`-Attribut versehen wird. Der Aufbau der Funktion:

        ```csharp
        // Erstellen des Rates
        var council = new JediCouncil();
        
        // TODO: Abonniere das CouncilChanged-Ereignis des councils
        
        // TODO: Füge zwei Jedi-Objekte zum council mit Add hinzu

        council.Remove();
        council.Remove();
        ```

    10. Wenn alles korrekt umgesetzt wurde, sollte die Ausgabe des Programms nach dem Ausführen wie folgt aussehen:

        ```text
        Ein neues Mitglied wurde hinzugefügt
        Ein neues Mitglied wurde hinzugefügt
        Ich spüre eine Erschütterung in der Macht
        Der Rat ist gefallen!
        ```

!!! tip "Nullprüfung von Ereignissen"
    Wenn du in `JediCouncil.Add` eine Nullprüfung verwendet hast, um sicherzustellen, dass mindestens ein Abonnent existiert, ersetze dies durch eine modernere Lösung (Anwendung von `?.Invoke`, das die Überprüfung ebenfalls in kompakterer Form durchführt, jedoch ohne Nullprüfung – dies wurde auch in der entsprechenden Vorlesung und im Labor behandelt). Dies muss nur für die `JediCouncil.Add` gemacht werden, bei `JediCouncil.Remove` sind derzeit beide Lösungen akzeptabel.

## Aufgabe 4 – Delegaten

### Aufgabe

Ergänze die Klasse `JediCouncil` mit einer parameterlosen Funktion (**der Funktionsname muss auf `_Delegate` enden, das ist obligatorisch**), die als Rückgabewert alle Mitglieder des Jedi-Rats zurückgibt, deren Midi-Chlorian-Zahl **unter 530** liegt!

- Verwende für die Abfrage eine Funktion, keine Eigenschaft.
- Verwende innerhalb der Funktion die Methode `FindAll()` der Klasse `List<Jedi>`, um die Mitglieder zu finden.
- In dieser Aufgabe darfst du noch **KEINE Lambda-Ausdrücke** verwenden!

Schreibe außerdem eine dedizierte Testfunktion (z. B. in der `Program`-Klasse), die unsere oben definierte Funktion aufruft und die Namen der zurückgegebenen Jedi-Ritter ausgibt! Diese Funktion darf keinen Code enthalten, der nicht direkt zur Aufgabe gehört, also auch keinen, der zu anderen (Teil-)Aufgaben gehört.

!!! danger "Wichtig"
    Diese Testfunktion muss mit dem C#-Attribut `[Description("Task4")]` versehen werden. Rufe die Funktion aus der `Main`-Methode der `Program`-Klasse auf.

    Die folgenden sind wesentlich:

    - das Attribut soll über die Funktion und NICHT über die Klasse geschrieben werden,  
    - das Attribut soll über der Testfunktion platziert werden und nicht über der Funktion, die die Logik implementiert,  
    - das Attribut darf nur über einer einzigen Funktion stehen.

!!! tip "Auslagerung der Initialisierung"
    Während der Implementierung sollst du eine separate statische Methode einführen (z. B. in der `Program`-Klasse), die als Parameter ein `JediCouncil`-Objekt erhält und darin mindestens drei parametrisierte `Jedi`-Objekte mithilfe von `Add` hinzufügt. Ziel ist es, eine Initialisierungsmethode zu haben, die auch in späteren Aufgaben wiederverwendet werden kann, sodass der entsprechende Initialisierungscode nicht dupliziert werden muss.

### Lösung

Zur Lösung der Aufgabe kann die 6. Aufgabe des 2. Labors als Referenz verwendet werden. Als Hilfe geben wir Folgendes an:

- Unsere Funktion kann mehrere Suchergebnisse zurückgeben, daher ist der Rückgabetyp `List<Jedi>`.
- Die Methode `FindAll` erwartet in unserem Fall eine Filterfunktion mit der Signatur `bool Funktionsname(Jedi j)`.

## Aufgabe 5 – Lambda-Ausdrücke

Die Aufgabe entspricht der vorherigen, nur dass wir jetzt mit Hilfe eines Lambda-Ausdrucks arbeiten werden. Dieses Thema wurde sowohl in der Vorlesung als auch im Labor behandelt ([2. Labor Aufgabe 6](../../labor/2-nyelvi-eszkozok/index_ger.md#6-aufgabe-lambda-begriffe)).

Ergänze die Klasse JediCouncil mit einer parameterlosen Funktion (**der Funktionsname muss auf `_Lambda` enden, das ist obligatorisch**), die als Rückgabewert alle Mitglieder des Jedi-Rates zurückgibt, deren Midi-Chlorian-Wert unter 1000 liegt!

- Verwende für die Abfrage eine Funktion und keine Eigenschaft.
- Verwende innerhalb der Funktion die Methode `FindAll()` der Klasse `List<Jedi>`, um die Mitglieder zu finden.
- In dieser Aufgabe muss zwingend ein Lambda-Ausdruck verwendet werden (egal ob Statement- oder Expression-Lambda)!

Schreibe auch eine dedizierte Testfunktion (z. B. in der Klasse `Program`), die unsere obige Funktion aufruft und die Namen der zurückgegebenen Jedi-Ritter ausgibt!
Diese Funktion darf keinen Code enthalten, der nicht direkt zu dieser Aufgabe gehört, also auch keinen, der zu anderen (Teil-)Aufgaben gehört.

!!! danger "Wichtig" 
    Diese Testfunktion muss mit dem C#-Attribut `[Description("Task5")]` versehen werden. Rufe die Funktion aus der `Main`-Funktion der Klasse `Program` auf.

    Die folgenden sind wesentlich:
        
    - das Attribut soll über die Funktion und NICHT über die Klasse geschrieben werden,  
    - das Attribut soll über der Testfunktion platziert werden und nicht über der Funktion, die die Logik implementiert,  
    - das Attribut darf nur über einer einzigen Funktion stehen.

## Aufgabe 6 – Verwendung von `Action`/`Func`

Diese Aufgabe basiert auf dem Lehrstoff der 3. Vorlesung und kam im Labor (aufgrund von Zeitmangel) nicht vor. Trotzdem ist dies ein wichtiges Grundthema in diesem Fach.

Füge dem Projekt eine `Person`- und eine `ReportPrinter`-Klasse hinzu (jeweils in eine eigene Datei mit dem gleichen Namen wie die Klasse, im Standard-Namensraum `ModernLangToolsApp`) mit folgendem Inhalt:

??? tip "Person- und ReportPrinter-Klassen"

    ```csharp   
    class Person
    {
        public Person(string name, int age)
        {
            Name = name;
            Age = age;
        }

        public string Name { get; set; }
        public int Age { get; set; }
    }
    ```

    ```csharp   
    class ReportPrinter
    {
        private readonly IEnumerable<Person> people;
        private readonly Action headerPrinter;

        public ReportPrinter(IEnumerable<Person> people, Action headerPrinter)
        {
            this.people = people;
            this.headerPrinter = headerPrinter;
        }

        public void PrintReport()
        {
            headerPrinter();
            Console.WriteLine("------------------------------------------");
            int i = 0;
            foreach (var person in people)
            {
                Console.Write($"{++i}. ");
                Console.WriteLine("Person");
            }
            Console.WriteLine("---------------- Summary ------------------");
            Console.WriteLine("Footer");
        }
    }
    ```

Diese `ReportPrinter`-Klasse kann verwendet werden, um auf Basis der im Konstruktor übergebenen Personen einen formatierten Bericht in der Konsole auszugeben, aufgeteilt in Kopfzeile/Daten/Fußzeile.
Füge in die Datei `Program.cs` die folgende Funktion hinzu, um den `ReportPrinter` auszuprobieren, und rufe diese auch aus der `Main`-Funktion auf:

??? tip "Testen von ReportPrinter"

    ```csharp   
    [Description("Task6")]
    static void test6()
    {
        var employees = new Person[] { new Person("Joe", 20), new Person("Jill", 30) };

        ReportPrinter reportPrinter = new ReportPrinter(
            employees,
            () => Console.WriteLine("Employees")
            );

        reportPrinter.PrintReport();
    }
    ```

Führen wir die Anwendung aus. In der Konsole erhalten wir folgende Ausgabe:

```
Employees
-----------------------------------------
1. Person
2. Person
--------------- Summary -----------------
Footer
```

In der ersten Zeile über "----" befindet sich die Kopfzeile. Darunter steht für jede Person der fest eingebaute Text "Person", und unter "----" die Fußzeile, vorerst nur mit einem fest eingebauten "Footer"-Text.

In der Lösung ist zu sehen, dass der Text der Kopfzeile nicht in die Klasse `ReportPrinter` eingebaut ist. Dies wird vom Benutzer des `ReportPrinter` als Konstruktorparameter in Form eines Delegates angegeben, in unserem Fall als Lambda-Ausdruck. Der Delegatetyp ist der in .NET eingebaute Typ `Action`.

Die Aufgaben sind die folgenden:

!!! warning
    In der Lösung darfst du KEINEN eigenen Delegatetyp verwenden (arbeite mit den in .NET eingebauten Delegatetypen, nur dann ist die Lösung akzeptabel).

1. Passe die Klasse `ReportPrinter` so an, dass der Benutzer der Klasse nicht nur die Kopfzeile, sondern auch die Fußzeile über einen Delegate im Konstruktor angeben kann.
   
2. Erweitere die Klasse `ReportPrinter` so, dass beim Ausgeben der einzelnen Personen nicht der feste Text "Person" erscheint, sondern der Benutzer der Klasse die Daten jeder Person mithilfe eines im Konstruktor übergebenen Delegates formatiert ausgeben kann (anstelle des festen "Person"-Textes). Wichtig: Die Zeilennummer am Anfang jeder Zeile muss immer angezeigt werden; dies darf vom Benutzer nicht verändert werden (also weiterhin von der `ReportPrinter`-Klasse ausgegeben werden).
   
    !!! tip "Tipp zur Lösung"
        Verwende einen ähnlichen Ansatz wie bei Kopf- und Fußzeile, aber hier muss der Benutzer des `ReportPrinter` die Person-Objekte erhalten, um diese formatiert auszugeben.

3. Passe in der Datei `Program.cs` die Verwendung von `ReportPrinter` an (mit passenden Lambda-Ausdrücken), sodass die Konsolenausgabe wie folgt aussieht:

    ```
    Employees
    -----------------------------------------
    1. Name: Joe (Age: 20)
    2. Name: Jill (Age: 30)
    --------------- Summary -----------------
    Number of Employees: 2
    ```
    
    !!! tip "Fußzeile mit Mitarbeiteranzahl"
        Um die Anzahl der Mitarbeiter in der Fußzeile elegant auszugeben, ist Kenntnis über das Thema "variable capturing" erforderlich (siehe 3. Vorlesung, Abschnitt "Variable capturing, closure").

    !!! warning "Überprüfung der Hausaufgabe"
        Die „Aufgabe 6“, also die korrekte Anpassung von `ReportPrinter` und dessen Nutzung, wird vom automatischen GitHub-Checker NICHT überprüft. Teste deine Lösung gründlich, damit nach der Frist nicht erst bei der manuellen Überprüfung festgestellt wird, dass die Lösung nicht akzeptabel ist.
        (Ergänzung: ab dem Morgen des 13.03.2024 gibt es dafür teilweise automatische Checks)

4. Die folgende Aufgabe ist optional und eignet sich zum Üben der eingebauten `Func`-Delegates. Ein Nachteil der Klasse `ReportPrinter` ist, dass der Bericht nur auf der Konsole ausgegeben werden kann. Eine flexiblere Lösung wäre, wenn der Bericht als String erzeugt werden könnte. Diesen String könnte man dann beliebig weiterverwenden (z. B. in eine Datei schreiben).
   
    Die Aufgabe lautet: Führe eine `ReportBuilder`-Klasse nach dem Beispiel der bereits vorhandenen `ReportPrinter` ein, die jedoch nicht auf die Konsole schreibt, sondern einen String mit dem gesamten Bericht erstellt, den man über eine neue Methode `GetResult()` abrufen kann.

    !!! warning "Eingabe"
        Wenn du diese Aufgabe abgibst, setze den Code zum Instanziieren/Testen von `ReportBuilder` nicht in die obige `test6`-Funktion, sondern erstelle eine neue Funktion `test6b` und versieh sie mit dem Attribut `[Description("Task6b")]`.
   
    !!! tip "Tipps zur Lösung"
        * Es ist sinnvoll, in der Klasse eine `StringBuilder`-Variable einzuführen und damit zu arbeiten. Dies ist deutlich effizienter, als Strings mit "+" zusammenzufügen.
        * Der Benutzer von `ReportBuilder` gibt hier nicht mehr auf die Konsole aus, sondern liefert mithilfe geeigneter eingebauter Delegates (hier ist `Action` nicht geeignet) die Strings, die in den Bericht eingefügt werden sollen. Verwende auch hier Lambda-Ausdrücke für die Tests.

## Aufgabe 7 (IMSc) – Verwendung der eingebauten generischen `Func`/`Action`-Delegates

Die Lösung dieser Aufgabe ist nicht verpflichtend, wird aber dringend empfohlen: sie dient als Grundlage und kann in der Klausur/Prüfung vorkommen. Im Labor kam sie nicht vor, nur in der Vorlesung.

**Für die Lösung gibt es +2 IMSc-Punkte.**

### Aufgabe

Erweitere die Klasse `JediCouncil`.

- Erstelle eine Eigenschaft `Count` vom Typ `int`, die bei jeder Abfrage die aktuelle Anzahl der Jedi im Rat zurückgibt. Achte darauf, dass diese Eigenschaft nur lesbar ist (kein Setter).

    !!! tip "Tipp"
        Die Membervariable `members` in `JediCouncil` hat eine Eigenschaft `Count`. Die Lösung sollte darauf aufbauen.

- Erstelle eine Funktion `CountIf`, die ebenfalls dazu dient, Ratmitglieder zu zählen, aber nur solche, die eine bestimmte Bedingung erfüllen. Der Rückgabewert der Funktion ist `int`, und die Bedingung, die die Anzahl der passenden Mitglieder bestimmt, wird über einen Delegate als Parameter übergeben (also muss `CountIf` einen Parameter haben).

    !!! warning "Delegate-Typ"
        Der Delegate-Typ muss zwingend der entsprechende Typ aus der eingebauten generischen `Action` / `Func`-Delegates sein (d. h. eigene Delegate-Typen oder der eingebaute `Predicate` dürfen nicht verwendet werden).

        Daher kann auf der Liste NICHT die eingebaute Methode `FindAll` verwendet werden, da unser gewählter Delegate-Typ damit nicht kompatibel wäre. Arbeite stattdessen mit einer `foreach`-Schleife über die Mitglieder.

- Demonstriere die Funktionalität der Eigenschaft und der Funktion in einer dafür dedizierten gemeinsamen Funktion, die mit dem Attribut `[Description("Task7")]` versehen wird. Die Funktion darf keinen Code enthalten, der nicht direkt zur Aufgabe gehört, aber rufe die Hilfsfunktion auf, die du in der vorherigen Aufgabe zur Initialisierung des Jedi-Rats eingeführt hast. Rufe die Funktion anschließend aus der `Main`-Methode der Klasse `Program` auf.

    !!! danger "Wichtig"
        Das Attribut `[Description("Task7")]` darf nur über einer einzigen Funktion stehen.

### Lösung

- Im Fall der Eigenschaft `Count` ist nur der `get`-Zweig sinnvoll, daher schreiben wir den `set`-Zweig gar nicht. Es soll eine nur-lesbare Eigenschaft sein.
- Bei der Implementierung der Funktion `CountIf` hilft Aufgabe 4. Der Unterschied ist, dass `CountIf` nur die Anzahl zurückgibt, nicht die Mitglieder selbst.
    - Der Delegate-Parameter der Funktion `CountIf` sollte die Signatur `bool Funktionsname(Jedi jedi)` haben.

## Eingabe

Checkliste (zur Wiederholung):

--8<-- "docs/hazi/beadas-ellenorzes/index.md:3"
