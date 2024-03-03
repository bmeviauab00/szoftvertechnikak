---
autoren: BenceKovari,bzolka
---

# 2. HF - Sprachwerkzeuge

## Einführung

Die eigenständige Aufgabe baut auf den Vorlesungen der Vorlesung 2 und der ersten Hälfte der Vorlesung 3 auf (diese sind im Vorlesungsmaterial "Vorlesung 02 - Sprachliche Mittel" enthalten). [Labor 2 - Sprachwerkzeuge](../../labor/2-nyelvi-eszkozok/index_ger.md) liefert den praktischen Hintergrund für die Laborübung.

Aufbauend auf den obigen Ausführungen können die Aufgaben in dieser Selbstübung unter Verwendung der kürzeren Richtlinien, die auf die Aufgabenbeschreibung folgen, erledigt werden.

Das Ziel der unabhängigen Übung:

- Praktische Nutzung von Eigentum
- Delegierte und Ereignisse verwenden
- üben Sie die Verwendung von .NET-Attributen
- Üben der Verwendung grundlegender Sammlungstypen
- Übung Lambda-Terme

Die erforderliche Entwicklungsumgebung wird [hier](../fejlesztokornyezet/index_ger.md) beschrieben.

!!! warning "Using C# 12 (and newer) language elements"
    C# 12 und neuere Sprachelemente (z.B. primärer Konstruktor) können in dieser Hausaufgabe nicht verwendet werden, da der Checker auf GitHub sie noch nicht unterstützt.

## Einreichungsverfahren, Pre-Checker

Der Einreichungsprozess ist derselbe wie bei der ersten Hausaufgabe (siehe Arbeitsablauf bei [Hausaufgaben und Verwendung von Git/GitHub](../hf-folyamat/index.md) für eine detaillierte Beschreibung an der üblichen Stelle):

1. Erstellen Sie mit GitHub Classroom ein Repository für sich selbst. Sie finden die Einladungs-URL in Moodle (Sie können sie sehen, indem Sie auf den Link*"GitHub classroom links for homework*" auf der Startseite des Fachs klicken). Es ist wichtig, dass Sie die richtige Einladungs-URL für diese Hausaufgabe verwenden (jede Hausaufgabe hat eine andere URL).
2. Klonen Sie das resultierende Repository. Dazu gehört auch die erwartete Struktur der Lösung.
3. Nachdem Sie die Aufgaben erledigt haben, übergeben Sie Ihre Lösung alt und drücken Sie sie alt.

Auch der Pre-Checker funktioniert wie gewohnt. Ausführliche Beschreibung: [Vorabkontrolle und formale Bewertung der Hausaufgaben]((../eloellenorzes-ertekeles/index.md)).

## Aufgabe 1 - Ominöse Schatten

### Verfasst am

Die Macht der Jedi-Ritter kommt bekanntlich von den winzigen Lebensformen, die in ihren Zellen leben, den Midi-Chlorianern. Der höchste jemals gemessene Midi-Chlor-Wert (über 20.000) wurde bei Anakin Skywalker gemessen.

Erstellen Sie eine Klasse mit dem Namen `Jedi`, die eine Eigenschaft `Name` vom Typ `string` und eine Eigenschaft `MidiChlorianCount` vom Typ `int` hat. Bei letzterem ist darauf zu achten, dass der Wert von `MidiChlorianCount` nicht auf 35 oder weniger gesetzt werden kann. Wählen Sie für die Validierung die einfachste und sauberste Lösung, die möglich ist: Verwenden Sie ein einfaches `if`im Property Setter und lösen Sie eine Exception aus, keine `else` Verzweigung von `if`, und keine Notwendigkeit, `return` zu verwenden.

### Lösung

Die Lösung dieser Aufgabe kann auf ähnliche Weise vorbereitet werden wie in [Labor 2, Aufgabe 1.](../../labor/2-nyelvi-eszkozok/index_ger.md#1-aufgabe-eigenschaft-property) Lösen Sie im Setter der Eigenschaft `MidiChlorianCount` eine Ausnahme für einen ungültigen Wert aus. Dies kann zum Beispiel mit dem folgenden Befehl geschehen:

```csharp
throw new ArgumentException("You are not a true jedi!");
```

## Aufgabe 2 - Angriff auf die Klone

### Verfasst am

Fügen Sie der Klasse, die Sie in Übung 1 erstellt haben, Attribute hinzu, so dass, wenn Sie ein Objekt `Jedi` mit der Klasse `XmlSerializer` in eine XML-Datendatei schreiben/zuweisen, seine Eigenschaften in Englisch als XML-Attribute angezeigt werden Schreiben Sie dann eine Funktion, die eine Instanz der Klasse `Jedi` in eine Textdatei sortiert und sie in ein neues Objekt zurückliest (und damit das ursprüngliche Objekt klont).

!!! tip "XML-Sortierattribute"
    Platzieren Sie die Attribute, die die XML-Sortierung steuern, über den Eigenschaften, nicht über den Mitgliedsvariablen!

!!! tip "Die Jedi-Klasse sollte öffentlich sein"
    Der XML-Sorter kann nur mit öffentlichen Klassen arbeiten, daher sollte die Jedi-Klasse öffentlich sein: ```csharp     public class Jedi { ...}     ```

!!! danger "Wichtig"
    Schreiben Sie den Code zum Speichern und Laden/Demonstrieren in eine gemeinsame dedizierte Funktion, und verweisen Sie auf die Funktion mit dem C#-Attribut `[Description("Task2")]` (das in der Zeile vor der Funktion eingegeben werden muss). Das gespeicherte/geladene Objekt sollte in dieser Funktion als lokale Variable implementiert werden. Der Name der Klasse/Funktion kann beliebig sein (z. B. kann er in der Klasse `Program` stehen). Die Funktion sollte keinen Code enthalten, der nicht strikt mit der Aufgabe und somit auch nicht mit einer anderen (Unter-)Aufgabe zusammenhängt. Rufen Sie die Funktion über die Funktion `Main` der Klasse `Program` auf. Um das oben genannte Attribut zu verwenden, müssen Sie den Namespace `System.ComponentModel` verwenden.

    Es ist wichtig, dass

    - attribut über Funktion und NE-Klasse,
    - schreiben Sie das Attribut nicht über die Funktion, die die Logik implementiert, sondern über die Funktion, die sie testet,
    - **das Attribut kann nur über einer einzigen Funktion erscheinen.**



### Lösung

Die Lösung dieser Aufgabe kann auf ähnliche Weise wie in [Labor 2, Aufgabe 4](../../labor/2-nyelvi-eszkozok/index_ger.md#4-aufgabe-attribute), vorbereitet werden. Die folgende Hilfe wird angeboten:

- Nach der Sortierung sollte die XML-Datei etwa so aussehen:

    ```xml
    <?xml version="1.0"?>
    <Jedi xmlns:xsi="..." Nev="Obi-Wan" MidiChlorianSzam="15000" />
    ```

    Es ist wichtig, dass jeder Jedi als XML-Element `Jedi` erscheint, sein Name `Nev`, seine Midichlorian-Nummer `MidiChlorianSzam` als XML-Attribut.

- Wir haben uns im Labor keinen Beispielcode für die Rückgabe sortierter Objekte angesehen, daher stellen wir ihn hier zur Verfügung:

    ```csharp
    var serializer = new XmlSerializer(typeof(Jedi));
    var stream = new FileStream("jedi.txt", FileMode.Open);
    var clone = (Jedi)serializer.Deserialize(stream);
    stream.Close();
    ```

    In der vorherigen Zeile wird zunächst eine Sortiertabelle (`serializer`) erstellt, die später zur Durchführung der Suche verwendet wird. Gelesen wird aus einer Datei namens `jedi.txt`, die in der zweiten Zeile zum Lesen geöffnet wird (wenn wir schreiben wollten, hätten wir` FileMode.Create`angeben müssen).

## Herausforderung 3 - Die Rache der Sith

### Verfasst am

Im Rat der Jedi hat es in letzter Zeit eine hohe Fluktuation gegeben. Um den Überblick über Änderungen zu behalten, erstellen Sie eine Klasse, die Vorstandsmitglieder registrieren und eine Textbenachrichtigung über Änderungen in Form eines Ereignisses senden kann! Die Liste kann mit zwei Funktionen bearbeitet werden. Die Funktion `Add` nimmt einen neuen Jedi-Ritter in den Rat auf, während die Funktion `Remove` das **zuletzt** aufgenommene Ratsmitglied wieder entfernt. Separate Benachrichtigung, wenn der Rat komplett leer ist (verwenden Sie dasselbe Ereignis wie für andere Änderungen, nur mit anderem Text).

Die Liste der Vorstandsmitglieder (`members`) wird in einer Mitgliedsvariablen des Typs `List<Jedi>` gespeichert, die Funktion `Add` fügt dieser Liste neue Mitglieder hinzu, während die Funktion `Remove` immer das **letzte** durch die generische Liste `RemoveAt` hinzugefügte Mitglied entfernt (der Index des letzten Mitglieds wird durch die Länge der Liste bestimmt, die durch die Eigenschaft `Count` zurückgegeben wird).

Die Benachrichtigung sollte über ein C#-Ereignis erfolgen. Der Delegatentyp für das Ereignis sollte ein einfacher `string`sein. Das Hinzufügen eines neuen Mitglieds, das Entfernen jedes Mitglieds und das Entfernen des letzten Mitglieds sollte durch einen anderen Nachrichtentext angezeigt werden. Das Auslösen von Ereignissen sollte direkt in `Add` und `Remove` erfolgen (führen Sie keine Hilfsfunktion ein).

Verwenden Sie keinen eingebauten Delegatentyp für den Ereignistyp, sondern führen Sie einen eigenen ein.

!!! danger "Wichtig" 
    Der Code, der das Jeditanács-Objekt erstellt und testet (Abonnieren eines C#-Ereignisses, Aufrufen von `Add` und `Remove` ), sollte in einer gemeinsamen, separaten Funktion untergebracht werden, und diese Funktion sollte durch das C#-Attribut `[Description("Task3")]` dargestellt werden. Der Name der Klasse/Funktion kann beliebig sein. Die Funktion sollte keinen Code enthalten, der nicht strikt mit der Aufgabe und somit auch nicht mit einer anderen (Unter-)Aufgabe zusammenhängt. Rufen Sie die Funktion über die Funktion `Main` der Klasse `Program` auf.

      Es ist wichtig, dass

      - attribut über Funktion und NE-Klasse,
      - schreiben Sie das Attribut nicht über die Funktion, die die Logik implementiert, sondern über die Funktion, die sie testet,
      - das Attribut kann nur über einer einzigen Funktion erscheinen.

### Lösung

Die Lösung dieses Problems baut auf mehreren Details aus Labor 2 auf. Die Einführung einer neuen Veranstaltung kann wie in den Übungen 2 und 3 beschrieben erfolgen, wobei die Mitglieder des Gremiums in einer Liste eingetragen werden können.

Versuchen Sie anhand der obigen Informationen, das Problem selbst zu lösen. Wenn Sie fertig sind, lesen Sie die Anleitung im nächsten zu öffnenden Block weiter und vergleichen Sie Ihre Lösung mit der Referenzlösung unten Korrigieren Sie gegebenenfalls Ihre eigene Lösung!

!!! tip "Öffentliche Sichtbarkeit"
    Das Beispiel baut auf der Tatsache auf, dass die beteiligten Klassen, Eigenschaften und Delegierten öffentlich sichtbar sind. Wenn Sie auf einen seltsamen Übersetzungsfehler stoßen oder `XmlSerializer` zur Laufzeit einen Fehler auslöst, überprüfen Sie zunächst, ob Sie die öffentliche Sichtbarkeit auf allen relevanten Websites korrekt eingestellt haben.

??? example "Referenzlösung"
    Die Schritte der Referenzlösung sind wie folgt:

    1. Erstelle eine neue Klasse mit dem Namen `JediCouncil`.
    2. Man nehme ein Feld vom Typ "Liste<Jedi>" und initialisiere es mit einer leeren Liste.
    3. Machen Sie die Funktionen "Hinzufügen" und "Entfernen" gültig.

        Nach den obigen Schritten erhalten wir den folgenden Code:

        ```csharp
        public class JediCouncil
        {
            Liste<Jedi> members = new List<Jedi>();

            public void Add(Jedi newJedi)
            {
                members.Add(newJedi);
            }

            public void Remove()
            {
                // Entfernt den letzten Eintrag in der Liste
                members.RemoveAt(members.Count - 1);
            }
        }
        ```

        Der nächste Schritt ist die Implementierung der Ereignisbehandlung. 

    4. Definieren Sie einen neuen Delegatentyp (außerhalb der Klasse, da es sich ebenfalls um einen Typ handelt), der den Benachrichtigungstext übergeben wird:

        ```csharp
        public delegate void CouncilChangedDelegate(string message);
        ```

    5. Fügen Sie die Klasse "JediCouncil" zum Ereignis-Handler hinzu:

        ```csharp hl_lines="3"
        public class JediCouncil
        {
            public event CouncilChangedDelegate CouncilChanged;

            // ...
        }
        ```

    6. Lassen Sie uns das Ereignis feiern, wenn wir ein neues Vorstandsmitglied aufnehmen. Zu diesem Zweck müssen wir die Methode "Hinzufügen" hinzufügen.

        ```csharp
        public void Add(Jedi newJedi)
        {
            members.Add(newJedi);

            // TODO: Fry die Veranstaltung hier.
            // Beachten Sie, dass Sie dies nur tun sollten, wenn Sie mindestens einen Teilnehmer haben.
            // Verwenden Sie dabei das modernere ?.Invoke und nicht die häufigere Nullprüfung.
        }
        ```

    7. Braten Sie das Ereignis, wenn ein Ratsmitglied geht! Unterscheiden Sie den Fall, dass der Rat völlig leer ist. Dazu müssen wir die Methode `Remove` hinzufügen.

        ```csharp
        public void Remove()
        {
            // Entfernt den letzten Eintrag in der Liste
            members.RemoveAt(members.Count - 1);

            // TODO: Fry die Veranstaltung hier.
            // Beachten Sie, dass Sie dies nur tun sollten, wenn Sie mindestens einen Teilnehmer haben.
        }
        ```

    8. Um unsere Lösung zu testen, fügen Sie eine Funktion `MessageReceived` zu der Klasse hinzu, in der wir das Ereignisabonnement und die Ereignisbehandlung testen wollen (z.B. die Klasse `Program`). Diese Funktion wird verwendet, um `JediCouncil'-Benachrichtigungen zu abonnieren.

        ```csharp title="Programm.cs"
        private static void MessageReceived(string message)
        {
            Console.WriteLine(Nachricht);
        }
        ```

    9. Testen Sie schließlich die neue Klasse, indem Sie eine eigene Funktion schreiben (dies kann in der Klasse `Programm` geschehen) und fügen Sie das Attribut `[Description("Task3")]` oberhalb der Funktion hinzu Das Grundgerüst der Funktion:

        ```csharp
        // Einrichtung des Rates
        var council = new JediCouncil();
        
        // TODO: Melden Sie sich hier für die CouncilChanged-Veranstaltung an
        
        // TODO Hier fügen Sie zwei Jedi-Objekte zum Ratsobjekt hinzu, indem Sie Add

        council.Remove();
        council.Remove();
        ```

    10. Wenn wir unsere Arbeit gut gemacht haben, sollten wir nach der Ausführung des Programms die folgende Ausgabe erhalten:

        ``Text
        Wir haben ein neues Mitglied
        Wir haben ein neues Mitglied
        Ich spüre eine Störung in der Kraft
        Der Rat ist gefallen!
        ```

!!! tip "Nullprüfung von Ereignissen"
    Wenn Sie `null` in der Operation `JediCouncil.Add` verwendet haben, um zu prüfen, ob es mindestens einen Abonnenten des Ereignisses gibt, konvertieren Sie dies in eine modernere Lösung (unter Verwendung von`?.Invoke`, die die Prüfung auch in einer prägnanteren Form durchführt, aber ohne `null` Prüfung - dies wurde in der zugehörigen Präsentation und im Labor besprochen). Für `JediCouncil.Add` ist dies ausreichend, für `JediCouncil.Remove` sind beide Lösungen vorerst akzeptabel.

## Aufgabe 4 - Delegierte

### Verfasst am

Ergänzen Sie die Klasse `JediCouncil` um eine parameterlose Funktion**(der Funktionsname muss ** mit** `_Delegate`enden , das ist zwingend erforderlich**), die alle Mitglieder des Jedi-Rates mit einer Midi-Chlorzahl unter **530** zurückgibt

- Verwenden Sie zur Abfrage eine Funktion, keine Eigenschaft.
- Um die Mitglieder innerhalb der Funktion zu finden, verwenden Sie die Funktion `FindAll()` der Klasse `List<Jedi>`. 
- In dieser Übung **können Sie lambda** noch **NICHT verwenden**!
  
Schreibe auch eine eigene "Tester"-Funktion (z.B. in der Klasse `Program` ), die unsere obige Funktion aufruft und die Namen der zurückgegebenen Jedi-Ritter ausgibt! Diese Funktion sollte keinen Code enthalten, der nicht strikt mit der Aufgabe und somit auch nicht mit einer anderen (Unter-)Aufgabe zusammenhängt.

!!! danger
    Gefahr "Wichtig" Siehe diese "Tester"-Funktion mit dem `[Description("Task4")]` C#-Attribut. Rufen Sie die Funktion über die Funktion `Main` der Klasse `Program` auf.

    Es ist wichtig, dass
        
    - attribut über Funktion und NE-Klasse,
    - schreiben Sie das Attribut nicht über die Funktion, die die Logik implementiert, sondern über die Funktion, die sie testet,
    - das Attribut kann nur über einer einzigen Funktion erscheinen.

!!! tip "Initialisierung auslagern"
    Führen Sie bei der Implementierung eine eigene statische Methode ein (z.B. in der Klasse `Program` ), die ein Jeditanács-Objekt als Parameter annimmt und durch Aufruf von `Add` mindestens drei parametrisierte `Jedi` -Objekte hinzufügt. Unser Ziel ist es, eine Initialisierungsmethode zu haben, die in der/den späteren Aufgabe(n) verwendet werden kann, ohne dass der entsprechende Initialisierungscode dupliziert werden muss.

### Lösung

Zur Lösung dieser Aufgabe können Sie Labor 2 Labor 6 als Referenz verwenden. Um Sie zu unterstützen, bieten wir Folgendes an:

- unsere Funktion kann mehrere Treffer zurückgeben, daher ist der Rückgabetyp `List<Jedi>`,
- erwartet in unserem Fall eine Filterfunktion mit `bool Függvénynév(Jedi j)` als Parameter `FindAll`. 

## Übung 5 - Lambda-Ausdrücke

Die Übung ist dieselbe wie die vorhergehende, nur dass wir diesmal mit Lambda-Ausdrücken arbeiten werden. Dieses Thema wurde sowohl in der Vorlesung als auch im Labor ([Labor 2, Übung 6](../../labor/2-nyelvi-eszkozok/index_ger.md#6-aufgabe-lambda-begriffe)) behandelt.

Füge der Klasse JediCouncil eine Funktion ohne Parameter hinzu**(der Funktionsname muss ** mit** `_Lambda`enden , das ist obligatorisch**), die alle Mitglieder des Jedi-Rates mit einer Midi-Chlorianzahl unter 1000 zurückgibt

- Verwenden Sie zur Abfrage eine Funktion, keine Eigenschaft.
- Um die Mitglieder innerhalb der Funktion zu finden, verwenden Sie die Funktion `FindAll()` der Klasse `List<Jedi>`. 
- In dieser Übung müssen Sie einen Lambda-Ausdruck verwenden (es spielt keine Rolle, ob Sie Anweisungs- oder Ausdrucks-Lambda verwenden)!
  
Schreibe auch eine eigene "Tester"-Funktion (z.B. in der Klasse `Program` ), die unsere obige Funktion aufruft und die Namen der zurückgegebenen Jedi-Ritter ausgibt! Diese Funktion sollte keinen Code enthalten, der nicht strikt mit der Aufgabe und somit auch nicht mit einer anderen (Unter-)Aufgabe zusammenhängt.

!!! danger "Wichtig"
    Siehe diese "Tester"-Funktion mit dem `[Description("Task5")]` C#-Attribut. Rufen Sie die Funktion über die Funktion `Main` der Klasse `Program` auf.

    Es ist wichtig, dass
        
    - attribut über Funktion und NE-Klasse,
    - schreiben Sie das Attribut nicht über die Funktion, die die Logik implementiert, sondern über die Funktion, die sie testet,
    - das Attribut kann nur über einer einzigen Funktion erscheinen.

## Aufgabe 6 - `Action`/`Func` verwenden

Diese Übung baut auf dem Stoff der Vorlesung 3 auf und war (aus Zeitgründen) nicht Bestandteil des Praktikums. Dennoch handelt es sich um ein wesentliches Kernthema des Fachs.

Fügen Sie dem Projekt eine Klasse `Person` und eine Klasse `ReportPrinter` (jeweils in einer Datei mit dem gleichen Namen wie die Klasse) mit folgendem Inhalt hinzu:

??? tip "Person und ReportPrinter Klassen"

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
            Console.WriteLine("-----------------------------------------");
            int i = 0;
            foreach (var person in people)
            {
                Console.Write($"{++i}. ");
                Console.WriteLine("Person");
            }
            Console.WriteLine("--------------- Summary -----------------");
            Console.WriteLine("Footer");
        }
    }
    ```

Diese Klasse `ReportPrinter` kann verwendet werden, um einen formatierten Bericht über die Daten der in ihrem Konstruktor angegebenen Personen in die Konsole zu schreiben, und zwar in einer Dreifachaufteilung von Kopfzeile/Daten/Fußzeile. Fügen Sie die folgende Funktion zu `Program.cs` hinzu, um `ReportPrinter` zu testen, und rufen Sie sie von `Main` aus auf:

??? tip "Test ReportPrinter"

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

Führen Sie die Anwendung aus. Die Ausgabe auf der Konsole sieht wie folgt aus:

```
Employees
-----------------------------------------
1. Person
2. Person
--------------- Summary -----------------
Footer
```

Die erste Zeile über "----" ist die Kopfzeile. Unter jeder Person befindet sich ein eingebrannter "Person"-Text, dann unter "----" die Fußzeile, vorerst nur mit einem eingebrannten "Footer"-Text.

In der Lösung können Sie sehen, dass der Überschriftentext nicht in die Klasse `ReportPrinter` eingebrannt wird. Diese wird vom Benutzer von `ReportPrinter` in einem Konstruktorparameter in Form eines Delegaten, in unserem Fall eines Lambda-Ausdrucks, angegeben. Der Delegatentyp ist der in .NET integrierte Typ `Action`. 

Die Aufgaben sind:

!!! warning
    Sie können NICHT Ihren eigenen Delegattyp in der Lösung verwenden (arbeiten Sie mit .NET eingebauten Delegattypen, die Lösung ist nur dann akzeptabel).

1. Umstrukturierung der Klasse `ReportPrinter`, so dass der Benutzer der Klasse nicht nur die Kopfzeile, sondern auch die Fußzeile in Form eines Delegaten angeben kann.
   
2. Ändern Sie die Klasse `ReportPrinter` so, dass der feste Text "Person" nicht angezeigt wird, wenn jede Person hinzugefügt wird, sondern der Benutzer der Klasse `ReportPrinter` die Daten jeder Person nach Bedarf über einen Delegaten hinzufügen kann (anstelle des festen Texts "Person"). Es ist wichtig, dass die Zeilennummer immer am Anfang der Zeile steht, sie kann vom Benutzer von `ReportPrinter` nicht geändert werden!
   
    !!! tip "Tipp für die Lösung"
        Denken Sie an einen ähnlichen Ansatz wie für die Kopf- und Fußzeile, aber hier muss der Benutzer von `ReportPrinter` das Personenobjekt erhalten, um es formatiert in die Konsole schreiben zu können.

3. Ändern Sie in der Datei `Program.cs` die Verwendung von `ReportPrinter` (mit den entsprechenden Lambda-Ausdrücken), so dass die Ausgabe auf der Konsole lautet:

    ```
    Employees
    -----------------------------------------
    1. Name: Joe (Age: 20)
    2. Name: Jill (Age: 30)
    --------------- Summary -----------------
    Anzahl der Mitarbeiter: 2
    ```

    !!! Warning "Hausaufgabenprüfung"
        Die Aufgabe "Aufgabe 6", d.h. ob Sie `ReportPrinter`und dessen Verwendung korrekt konvertiert haben, wird NICHT vom automatischen GitHub-Checker geprüft. Testen Sie Ihre Lösung gründlich, damit Sie nicht erst nach dem Abgabetermin bei der manuellen Kontrolle Ihrer Hausaufgaben feststellen, dass sie nicht akzeptabel ist.

4. Die nächste Übung ist optional und bietet Ihnen eine gute Gelegenheit, die eingebauten `Func` Delegierten zu üben. Die Klasse `ReportPrinter` hat einen großen Nachteil: Der Ausgabebericht kann nur auf der Konsole angezeigt werden. Eine flexiblere Lösung wäre, nicht in die Konsole zu schreiben, sondern einen String zu verwenden, um den Bericht zu erstellen. Diese Zeichenkette kann auf beliebige Weise verwendet werden (z. B. in eine Datei schreiben).
   
    Die Aufgabe besteht darin, eine Klasse `ReportBuilder` einzuführen, die auf der bestehenden `ReportPrinter` basiert, aber nicht in die Konsole schreibt, sondern eine Zeichenkette mit dem vollständigen Bericht erzeugt, der durch eine neu eingeführte Operation `GetResult()` abgerufen werden kann. 
   
    !!! tip "Tipps für die Lösung"
        * Es ist eine gute Idee, eine `StringBuilder` Mitgliedsvariable in die Klasse einzuführen und mit ihr zu arbeiten. Dies ist um Größenordnungen effizienter als die Verkettung von Zeichenketten mit "+".
        * In diesem Fall sollte der Benutzer der Klasse `ReportBuilder` nicht mehr in die Konsole schreiben, sondern die an die Ausgabe anzuhängenden Zeichenketten an `ReportBuilder` zurückgeben und dabei die entsprechenden eingebauten Typdelegierten verwenden ( `Action` ist hier nicht geeignet). Verwenden Sie jetzt Lambda-Terme in der Prüfung!

## Aufgabe 7 (IMSc) - Verwendung eingebauter `Func`/`Action` generischer Delegatentypen

Das Lösen der Aufgabe ist nicht obligatorisch, aber sehr empfehlenswert: Es handelt sich um einen Grundstoff, der in die ZH/Prüfung aufgenommen werden kann. Nicht in einem Labor, nur in einer Vorlesung.

**Die Lösung bringt außerdem +2 IMSc-Punkte ein.**

### Verfasst am

Erweitern Sie die Klasse `JediCouncil`. 

- Erstellen Sie eine Eigenschaft `Count` mit dem Rückgabewert `int`, die bei jeder Abfrage die aktuelle Anzahl der Jedi im Rat zurückgibt. Achten Sie darauf, dass dieser Wert nur abgefragt (nicht gesetzt) werden kann.

    !!! tip "Tipp"
        Die Membervariable members in `JediCouncil`hat eine Eigenschaft `Count`, die Lösung baut darauf auf.

- Erstellen Sie eine Funktion namens `CountIf`, die ebenfalls die Anzahl der Ratsmitglieder zählt, aber nur die Ratsmitglieder berücksichtigt, die bestimmte Bedingungen erfüllen. Der Rückgabewert der Funktion ist `int`, und die Bedingung, für die sie die entsprechende Anzahl von Ratsmitgliedern zurückgibt, wird als Parameter über einen Delegaten zurückgegeben ( `CountIf`muss also einen Parameter haben).

    !!! warning "Delegatentyp"
        Der Delegatentyp muss der richtige der eingebauten generischen `Action` / `Func` Delegatentypen sein (d.h. Sie können nicht Ihren eigenen Delegatentyp oder den eingebauten `Predicate` Typ verwenden).

        Aus diesem Grund können Sie die eingebaute Operation `FindAll` für die Liste NICHT verwenden, da der von uns verwendete Delegatentyp nicht mit dem von `FindAll` erwarteten Parameter kompatibel wäre. Bearbeite die Tags, indem du eine `foreach'-Schleife durchläufst!

- Zeigen Sie die Eigenschaft und die Funktion in einer eigenen gemeinsamen Funktion, die Sie mit dem Attribut `[Description("Task7")]` bereitstellen können. Diese Funktion sollte keinen Code enthalten, der nicht unmittelbar mit der Aufgabe zusammenhängt. Um den Jedi-Rat zu laden, rufen Sie die in der vorherigen Aufgabe vorgestellte Hilfsfunktion auf. Rufen Sie die Funktion über die Funktion `Main` der Klasse `Program` auf. 

    !!! danger "Wichtig"
        Das Attribut `[Description("Task7")]` kann nur oberhalb einer einzigen Funktion verwendet werden.

### Lösung

- Bei einer Eigenschaft namens `Count` ist nur der Zweig `get` sinnvoll, der Zweig `set` wird also nicht geschrieben. Diese Eigenschaft sollte schreibgeschützt sein.
- Übung 4 hilft Ihnen, die Funktion `CountIf` zu schreiben. Der Unterschied besteht darin, dass `CountIf` nicht die Anzahl der Ratsmitglieder, sondern nur die Anzahl der Stücke angibt.
    - Die Funktion `CountIf` sollte eine Filterfunktion mit der Signatur `bool Függvénynév(Jedi jedi)` als Bedingungsparameter erwarten.

## Vorlegen bei

Checkliste für Wiederholungen:

--8<-- "docs/hazi/beadas-ellenorzes/index_ger.md:3"
