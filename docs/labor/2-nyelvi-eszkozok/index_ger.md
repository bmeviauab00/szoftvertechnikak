---
autoren: BenceKovari,bzolka,tibitoth
---

# 2. Sprachliche Mittel

## Das Ziel der Übung

Während des Praktikums werden die Studenten mit den wichtigsten modernen Sprachwerkzeugen vertraut gemacht, die in der .NET-Umgebung verfügbar sind. Es wird vorausgesetzt, dass der Studierende den objektorientierten Ansatz in seinem bisherigen Studium beherrscht und mit den grundlegenden Konzepten der Objektorientierung vertraut ist. In dieser Übung werden wir uns auf die Sprachelemente in .NET konzentrieren, die über den allgemeinen objektorientierten Ansatz hinausgehen, aber wesentlich zur Erstellung von transparentem und wartbarem Code beitragen. Diese sind:

- Eigentum (property)
- Delegate (delegate, Methodenreferenz)
- Ereignis (event)
- Attribut (attribute)
- Lambda-Ausdruck (lambda expression)
- Generischer Typ (generic type)
- Einige zusätzliche Sprachkonstruktionen

Verwandte Vorlesungen: Vorlesung 2 und Anfang der Vorlesung 3 - Sprachliche Mittel.

## Voraussetzungen

Die für die Durchführung der Übung benötigten Werkzeuge:

- Visual Studio 2022

!!! tip "Übung unter Linux oder macOS"
    Das Übungsmaterial ist grundsätzlich für Windows und Visual Studio gedacht, kann aber auch auf anderen Betriebssystemen mit anderen Entwicklungswerkzeugen (z.B. VS Code, Rider, Visual Studio für Mac) oder sogar mit einem Texteditor und CLI (Kommandozeilen)-Tools durchgeführt werden. Dies wird dadurch ermöglicht, dass die Beispiele im Kontext einer einfachen Konsolenanwendung präsentiert werden (keine Windows-spezifischen Elemente) und das .NET 6 SDK auf Linux und macOS unterstützt wird. Hallo Welt unter Linux

## Einführung

!!! tip "Highlights"
    Dieser Leitfaden enthält an mehreren Stellen zusätzliche Informationen **und** Erklärungen, die in derselben Farbe wie dieser Hinweis und mit demselben Symbol umrahmt sind. Dies sind nützliche Erkenntnisse, die jedoch nicht Teil des Kernlehrplans sind.

## Lösung

??? success "Laden Sie die fertige Lösung herunter"
    :exclamation: Es ist wichtig, dass Sie sich während des Praktikums an die Anleitung halten. Es ist verboten (und sinnlos), die fertige Lösung herunterzuladen. Allerdings kann es bei der anschließenden Selbsteinübung nützlich sein, die fertige Lösung zu überprüfen, daher stellen wir sie zur Verfügung.

    Die Lösung ist auf GitHub [hier] verfügbar (https://github.com/bmeviauab00/lab-nyelvieszkozok-megoldas). Der einfachste Weg, es herunterzuladen, ist, es von der Kommandozeile aus mit dem Befehl `git clone` auf Ihren Computer zu klonen:

    `git clone https://github.com/bmeviauab00/lab-nyelvieszkozok-megoldas`

    Sie müssen Git auf Ihrem Rechner installiert haben, weitere Informationen [hier](../../hazi/git-github-github-classroom/index.md#git-telepitese).

## 0. Aufgabe - Schlüsselwort var - Implizit typisierte lokale Variablen

Wir beginnen mit einer einfachen Aufwärmübung. Im folgenden Beispiel erstellen wir eine Klasse namens `Person`, die eine Person darstellt.

1. Erstellen Sie eine neue C#-Konsolenanwendung. .NET-Basis (d.h. **nicht**.NET Framework):
    - Ein Beispiel dafür haben wir in der ersten Übung gesehen, die im Leitfaden beschrieben wird.
    - Das Kontrollkästchen "*Do not use top level statements*" ist bei der Projekterstellung aktiviert.
2. Fügen Sie eine neue Klasse mit dem Namen `Person` zu Ihrer Anwendung hinzu.
    (Um eine neue Klasse im Projektmappen-Explorer hinzuzufügen, klicken Sie mit der rechten Maustaste auf die Projektdatei und wählen Sie *Add / Class*. Ändern Sie im Pop-up-Fenster den Namen der zu erstellenden Datei in `Person.cs`und klicken Sie auf die Schaltfläche Hinzufügen)
3. Lassen Sie uns die Klasse öffentlich machen. Dazu müssen Sie das Schlüsselwort `public` vor dem Klassennamen eingeben. Diese Änderung wäre hier eigentlich nicht nötig, aber eine spätere Aufgabe wird eine öffentliche Klasse erfordern.

    ```csharp
    public class Person
    {
    }
    ```

4. Fügen wir die Funktion `Main` in die Datei `Program.cs` ein, um unsere neue Klasse zu testen.

    ```csharp
    static void Main(string[] args)
    {
        Person p = new Person();
    }
    ```

 5. Anstatt den Typ der **lokalen** Variablen explizit anzugeben, können Sie das Schlüsselwort `var` verwenden:

    ```csharp
    static void Main(string[] args)
    {
        var p = new Person();
    }
    ```

    Dies wird als **implizit typisierte lokale** **Variablen** bezeichnet. In diesem Fall versucht der Compiler, den Typ der Variablen aus dem Kontext zu erraten, und zwar von der rechten Seite des Gleichheitszeichens, in diesem Fall ist es `Person`.  Es ist wichtig anzumerken, dass die Sprache dadurch statisch typisiert bleibt (es funktioniert also **nicht** wie das JavaScript-Schlüsselwort `var` ), da der Typ der `p` -Variable später nicht mehr geändert werden kann. Es ist nur ein einfaches syntaktisches Bonbon, um die Definition lokaler Variablen prägnanter zu machen (keine Notwendigkeit, den Typ "zweimal" anzugeben, auf der linken und auf der rechten Seite von `=` ).

    !!! note "Target-typed `new` expressions"
        Ein weiterer Ansatz könnte die Target-typed `new` expressions in C# 9 sein, wo der Typ für den neuen Operator weggelassen werden kann, wenn er vom Compiler aus dem Kontext erraten werden kann (z.B.: linke Seite eines Wertes, Typ eines Parameters, etc.). Unser obiger `Person` -Konstruktor würde wie folgt aussehen:

        ``csharp
        Person p = new();
        ```

        Der Vorteil dieses Ansatzes gegenüber `var' ist, dass er auch für Member-Variablen verwendet werden kann.

## 1. Aufgabe - property

Eigenschaften erlauben uns typischerweise (aber nicht ausschließlich, wie wir noch sehen werden) den Zugriff auf Membervariablen von Klassen auf eine syntaktisch ähnliche Weise wie den Zugriff auf eine traditionelle Membervariable. Beim Zugriff haben wir jedoch die Möglichkeit, anstelle einer einfachen Wertabfrage oder Einstellung eine methodenähnliche Art des Zugriffs auf die Variable zu implementieren, und wir können sogar die Sichtbarkeit der Abfrage und der Einstellung separat definieren.

### Eigenschaftssyntax

Im folgenden Beispiel erstellen wir eine Klasse namens `Person`, die eine Person darstellt. Sie hat zwei Mitgliedsvariablen, `name` und `age`. Auf Mitgliedsvariablen kann nicht direkt zugegriffen werden (da sie privat sind), sie können nur über die öffentlichen Eigenschaften `Name` und `Age` verwaltet werden. **Das Beispiel veranschaulicht, dass die .NET-Eigenschaften eindeutig den aus C++ und Java bekannten  Methoden `SetX(…)` und `GetX()` entsprechen **, aber auf** einheitlichere Weise auf Sprachebene unterstützt werden**.

1. Erstellen Sie in der in der vorherigen Übung vorgestellten Klasse `Person` eine Membervariable des Typs `int` mit dem Namen `age` und eine Eigenschaft `Age`, die sie verfügbar macht.

    ```csharp
    public class Person
    {
        private int Alter;
        public int Alter
        {
            get { return age; }
            set { age = value; }
        }
    }
    ```

    !!! tip "Visual Studio Snippets"
        Obwohl wir die gesamte Eigenschaft im Labor zu Übungszwecken manuell eingegeben haben, stellt Visual Studio Code Snippets zur Verfügung, um häufig vorkommende Codeschnipsel zu erstellen, mit denen wir allgemeine Sprachkonstrukte als Vorlagen verwenden können. Das obige Eigenschaftscode-Snippet kann mit dem Snippet `propfull` abgerufen werden. Geben Sie den Namen des Snippets ein (`propfull`) und drücken Sie dann die ++Tabulatortaste++, bis das Snippet aktiviert ist (normalerweise 2x).

        Weitere erwähnenswerte Informationen sind unter anderem:

        - ctor": Konstruktor
        - für": für Zyklus
        - foreach": foreach-Schleife
        - prop": automatische Eigenschaft (siehe später)
        - switch": Schaltbefehl
        - cw": Console.WriteLine

        Wir können solche Schnipsel [herstellen] (https://learn.microsoft.com/en-us/visualstudio/ide/walkthrough-creating-a-code-snippet?view=vs-2022).

2. Fügen wir die Funktion `Main` in die Datei `Program.cs` ein, um unsere neue Eigenschaft zu testen.

    ```csharp hl_lines="4 6"
    static void Main(string[] args)
    {
        var p = new Person();
        p.Alter = 17;
        p.Alter++;
        Console.WriteLine(p.Alter);
    }
    ```

3. Unser Programm ausführen++(f5++)

    Sie sehen, dass die Eigenschaft auf ähnliche Weise wie die Mitgliedsvariablen verwendet werden kann. Wenn die Eigenschaft abgefragt wird, wird der in der Eigenschaft definierte Teil `get` ausgeführt und der Wert der Eigenschaft ist der durch return zurückgegebene Wert. Wenn die Eigenschaft gesetzt ist, wird der in der Eigenschaft definierte Abschnitt `set` ausgeführt, und der Wert der speziellen Variablen `value` in diesem Abschnitt entspricht dem als Eigenschaftswert angegebenen Ausdruck.

    Beachten Sie in der obigen Lösung, wie elegant wir ein Jahr zum Alter einer Person hinzufügen können. In Java- oder C++-Code hätte ein ähnlicher Vorgang in der Form `p.setAge(p.getAge() + 1)` geschrieben werden können, was eine wesentlich umständlichere und schwieriger zu lesende Syntax ist als die in Fint. Der Hauptvorteil der Verwendung von Eigenschaften besteht darin, dass unser Code syntaktisch sauberer ist und Wertzuweisungen/-abfragen in den meisten Fällen gut von tatsächlichen Funktionsaufrufen getrennt sind.

4. Vergewissern wir uns, dass unser Programm wirklich `get` und `set` aufruft. Dazu setzen Sie Haltepunkte innerhalb der Getter- und Setter-Blöcke, indem Sie auf den grauen Balken am linken Rand des Code-Editors klicken.
5. Führen Sie das Programm Schritt für Schritt aus. Starten Sie dazu das Programm, indem Sie ++f11++ statt ++f5++ drücken, und drücken Sie dann erneut ++f11++, um es Zeile für Zeile ablaufen zu lassen.

    Sie sehen, dass unser Programm tatsächlich jedes Mal den Getter aufruft, wenn ein Wert abgefragt wird, und den Setter, wenn ein Wert gesetzt wird.

6. Ein wichtiges Merkmal von Setter-Funktionen ist, dass sie die Möglichkeit der Wertüberprüfung bieten. Fügen wir in diesem Sinne dem Setter der Eigenschaft `Age` etwas hinzu.

    ```csharp
    public int Alter
    {
        get { return age; }
        einstellen 
        {
            wenn (Wert \< 0)
                throw new ArgumentException("Ungültiges Alter!");
            alter = Wert; 
        }
    }
    ```

    Beachten Sie, dass bei einfachen Gettern und Settern die Abfrage bzw. das Setzen von Werten in einer Zeile erfolgt, während sie bei komplexeren Stammdaten auf mehrere Zeilen aufgeteilt wird.

7. Um die Anwendung zu testen, weisen Sie dem Alter in Abhängigkeit von der Klasse `Program` einen negativen Wert zu `Main`. 

    ```csharp
    p.Alter = -2;
    ```

8. Führen Sie das Programm aus, vergewissern Sie sich, dass die Prüfung korrekt funktioniert, und korrigieren Sie dann den Fehler, indem Sie das eingestellte Alter auf positiv ändern.

    ```csharp
    p.Alter = 2;
    ```

### Auto-implementierte Eigenschaft (Auto-implementierte property)

In unserer täglichen Arbeit begegnen wir auch einer viel kompakteren Syntax von Eigenschaften. Diese Syntax kann verwendet werden, wenn Sie eine Eigenschaft erstellen möchten, in der:

- wir wollen keine zusätzliche Logik zu den Getter- und Setter-Methoden hinzufügen,
- müssen wir nicht direkt auf die private Mitgliedsvariable zugreifen.

Nachfolgend ein Beispiel dafür.

1. Fügen wir eine solche **automatisch implementierte Eigenschaft zu** unserer Klasse `Person` hinzu. Erstellen Sie eine Eigenschaft vom Typ `string` mit dem Namen `Name`. 

    ```csharp
    public string Name { get; set; }
    ```

    Der syntaktische Unterschied zu den vorherigen ist, dass weder der get- noch der set-Zweig implementiert wurden (keine Klammern). Im Falle einer automatisch implementierten Eigenschaft erzeugt der Compiler eine versteckte Variable in der Klasse, auf die vom Code aus nicht zugegriffen werden kann und die zum Speichern des aktuellen Werts der Eigenschaft verwendet wird. Es sollte betont werden, dass dies nicht die zuvor eingeführte `name` Mitgliedsvariable (die gelöscht werden könnte) anhält und abfragt, sondern auf eine versteckte, neue Variable wirkt!

2. Überprüfen wir nun seine Funktionalität, indem wir die Funktion `Main` hinzufügen.

    ```csharp hl_lines="4 6"
    static void Main(string[] args)
    {
        // ...
        p.Name = "Lukas";
        // ...
        Console.WriteLine(p.Name);
    }
    ```

### Standardwert (default value)

Für automatisch implementierte Eigenschaften können Sie bei der Deklaration auch deren Anfangswert angeben.

1. Geben Sie der Eigenschaft `Name` einen Anfangswert.

    ```csharp
    public string Name { get; set; } = "anonymous";
    ```

### Sichtbarkeit von Eigenschaften

Ein großer Vorteil der Eigenschaften, neben der völlig freien Implementierung, ist, dass die Sichtbarkeit des Getters und des Setters getrennt eingestellt werden kann.

1. Setzen Sie die Sichtbarkeit des Setters der Eigenschaft `Name` auf privat.

    ```csharp
    public string Name { get; private set; }
    ```

    In diesem Fall wird ein Übersetzungsfehler in der Klasse `Program` für die Richtlinie `p.Name = "Luke";` zurückgegeben. Die Grundregel ist, dass Getter und Setter die Sichtbarkeit der Eigenschaft erben, die weiter eingeschränkt, aber nicht gelockert werden kann.
    Die Sichtbarkeitskontrolle kann sowohl für autoimplementierte als auch für nicht autoimplementierte Eigenschaften verwendet werden.

2. Stellen Sie die Sichtbarkeit wieder her (entfernen Sie das Schlüsselwort `private` aus dem Property Setter `Name` ), um den Übersetzungsfehler zu beheben.

### Nur-Lese-Eigenschaft (readonly property)

Der Setter kann weggelassen werden, um eine schreibgeschützte Eigenschaft zu erhalten. Für eine automatisch implementierte Eigenschaft kann auch ein Anfangswert angegeben werden: Dies ist nur in einem Konstruktor oder durch Angabe eines Standardwerts (siehe oben) möglich, im Gegensatz zu Eigenschaften mit einem privaten Setter, deren Setter von jeder Mitgliedsfunktion der Klasse aufgerufen werden kann.

Die Definition einer schreibgeschützten Eigenschaft wird in den folgenden Codeschnipseln veranschaulicht (implementieren Sie sie NICHT in Ihrem Code):

a) Autoimplementierter Fall

```csharp
public string Name { get; }
```

b) Nicht automatisch implementierter Fall

```csharp
private string name;
...
public string Name { get {return name; } }
```

### Berechneter Wert (calculated value)

Eigenschaften mit nur Getter haben eine andere Verwendung. Sie kann auch verwendet werden, um einen berechneten Wert zu ermitteln, der immer einen Wert auf der Grundlage einer bestimmten Logik berechnet, aber im Gegensatz zur "Nur-Lese-Eigenschaft" verfügt sie nicht über ein Datenelement direkt hinter ihr. Dies wird im folgenden Codeschnipsel veranschaulicht (übernehmen Sie ihn NICHT in Ihren Code):

```csharp
public int AgeInDogYear { get { return Age * 7; } }
```

## 2. Aufgabe - Delegat (delegate, Methodenreferenz)

!!! danger "Ensure the code compiles!"
    Die folgenden Übungen bauen auf den Ergebnissen der vorherigen Übungen auf. Wenn Ihr Programm nicht abstürzt oder nicht richtig funktioniert, melden Sie dies Ihrem Tutor am Ende der Übung, damit er Ihnen bei der Behebung des Problems helfen kann.

Delegate sind Methodenreferenzen in .NET, das moderne Äquivalent zu C/C++-Funktionszeigern. Ein Delegat ist eine Möglichkeit, einen Variablentyp zu definieren, der verwendet werden kann, um auf Methoden zu verweisen. Nicht irgendein Zeiger, sondern - ähnlich wie bei C++-Funktionszeigern - solche, deren Typ (Parameterliste und Rückgabewert) dem Typ des Delegaten entspricht. Durch das "Aufrufen" der Delegiertenvariable wird die als Wert angegebene (registrierte) Methode automatisch aufgerufen. Ein Vorteil der Verwendung von Delegaten ist, dass Sie zur Laufzeit entscheiden können, welche von mehreren Methoden Sie aufrufen möchten.

Einige Beispiele für den Einsatz von Delegierten:

- die Funktion, die die Elemente vergleicht, als Parameter an eine universelle Ordnungsfunktion übergeben,
- ist die Implementierung einer universellen Filterlogik für eine allgemeine Sammlung, bei der eine Funktion als Delegierter in einem Parameter übergeben wird, um zu entscheiden, ob ein Element in die gefilterte Liste aufgenommen werden soll,
- implementierung des Publish-Subscribe-Musters, bei dem bestimmte Objekte andere Objekte über das Eintreten bestimmter, sie selbst betreffender Ereignisse informieren.

Im folgenden Beispiel werden wir Objekten der zuvor erstellten Klasse `Person` erlauben, Objekte anderer Klassen frei zu benachrichtigen, wenn sich das Alter einer Person geändert hat. Zu diesem Zweck führen wir einen Delegatentyp (`AgeChangingDelegate`) ein, der den aktuellen oder neuen Wert des Alters der Person in seiner Parameterliste übergeben kann. Als Nächstes erstellen wir eine öffentliche Mitgliedsvariable des Typs `AgeChangingDelegate` in der Klasse `Person`, die es einer externen Partei ermöglicht, die Funktion anzugeben, über die sie die Benachrichtigung über Änderungen an der Instanz `Person` anfordern wird.

1. Erstellen wir einen neuen **Delegatentyp**, der `void` zurückgibt und auf zwei Funktionen verweisen kann, die `int` Parameter annehmen. Vergewissern Sie sich, dass der neue Typ vor der Klasse `Person` definiert ist, direkt im Gültigkeitsbereich des Namespaces!

    ```csharp hl_lines="3"
    namensraum PropertyDemo
    {
        public delegate void AgeChangingDelegate(int oldAge, int newAge);

        public class Person
        {
            // ...
    ```

     `AgeChangingDelegate` ist ein **Typ** (man beachte auch die VS-Färbung), der überall dort verwendet werden kann, wo ein Typ gesetzt werden kann (z.B. kann man eine Member-Variable, eine lokale Variable, einen Funktionsparameter, etc. auf dieser Basis erstellen).

2. Erlauben Sie Objekten in `Person`, auf jede Funktion zu zeigen, die der obigen Signatur entspricht. Erstellen Sie dazu eine Membervariable vom Typ `AgeChangingDelegate` in der Klasse `Person`! 

    ```csharp hl_lines="3"
    public class Person
    {
        public AgeChangingDelegate AgeChanging;
    ```

    !!! warning "Wie objektorientiert ist das?"
        Die Methodenreferenz, die als öffentliche Membervariable erstellt wurde, verstößt (vorerst) gegen die Grundsätze der objektorientierten Einheitsbegrenzung/Informationsverschleierung. Wir werden später darauf zurückkommen.

3. Rufen Sie die Funktion jedes Mal auf, wenn sich Ihr Alter ändert. Dazu fügen Sie dem Setter der Eigenschaft `Age` Folgendes hinzu.

    ```csharp hl_lines="8-9"
    public int Alter
    {
        get { return age; }
        einstellen 
        {
            wenn (Wert \< 0)
                throw new ArgumentException("Ungültiges Alter!");
            if (AgeChanging != null)
                AgeChanging(age, value);
            alter = Wert; 
        }
    }
    ```

    Der obige Codeschnipsel veranschaulicht mehrere wichtige Regeln:

    - Die Validierungslogik geht in der Regel der Meldungslogik voraus.
    - Es hängt von der Art der Meldelogik ab, ob sie vor oder nach der Auswertung ausgeführt wird (in diesem Fall, da sich das Wort "ändern" auf etwas in Arbeit befindliches bezieht, geht die Meldung der Auswertung voraus, das Vorkommen wird durch die Vergangenheitsform angezeigt: "geändert")
    - Beachten Sie, dass noch niemand der Mitgliedsvariablen vom Typ Delegat einen Wert zugewiesen hat (kein Abonnent/Teilnehmer). In solchen Fällen würde der Aufruf zu einer Ausnahme führen. Überprüfen Sie daher immer, ob die Mitgliedsvariable `null`ist, bevor Sie sie aufrufen.
    - Wenn das Ereignis ausgelöst wird, können wir auch die Überprüfung von `null` und die Auslösung des Ereignisses auf elegantere, prägnantere und thread-sichere Weise mit dem "`?.`" Null-Bedingungs-Operator durchführen (C# 6 und höher):

    ```csharp
    if (AgeChanging != null)
        AgeChanging(age, value);
    ```

    anstelle von

    ```csharp
    AgeChanging?.Invoke(age, value);
    ```

    Das Ereignis wird nur ausgelöst, wenn es nicht `null` ist, ansonsten geschieht nichts.

   - Streng genommen sollte das Ereignis nur ausgelöst werden, wenn sich das Alter tatsächlich ändert, d. h. die Verzweigung der Eigenschaft set sollte prüfen, ob der neue Wert mit dem alten übereinstimmt. Eine Lösung könnte darin bestehen, in der ersten Zeile des Setters sofort zurückzukehren, wenn der neue Wert mit dem alten übereinstimmt:

    ```csharp
    wenn (Alter == Wert) 
        rückkehr;
    ..
    ```

4. Wir sind fertig mit dem Code für die Klasse `Person`.  Kommen wir zum Abonnenten! Als erstes müssen wir der Klasse `Program` eine neue Funktion hinzufügen.

    ```csharp hl_lines="5-8"
    class Programm
    {
        // ...

        private static void PersonAgeChanging(int altesAlter, int neuesAlter)
        {
            Console.WriteLine(oldAge + " => " + newAge);
        }
    }
    ```

    !!! warning "Tipp"
        Vergewissern Sie sich, dass die neue Funktion im richtigen Bereich platziert ist! Während der Delegatentyp außerhalb der Klasse (aber innerhalb des Namespace) platziert ist, befindet sich die Funktion innerhalb der Klasse!

5. Melden Sie sich schließlich für die Änderungsverfolgung in der Funktion `Main` an!

    ```csharp hl_lines="4"
    static void Main(string[] args)
    {
      Person p = new Person();
      p.AgeChanging = new AgeChangingDelegate(PersonAgeChanging);
      // ...
    ```

6. Starten wir das Programm!

    Wenn Sie z. B. einen Haltepunkt in der Zeile `AgeChanging?.Invoke(age, value);` setzen, die Anwendung debuggen und den Code steppen, können Sie feststellen, dass das Ereignis bei jedem Setter-Durchlauf ausgeführt wird, sowohl bei der ersten Wertzuweisung als auch beim Inkrement.

7. Fügen Sie der Funktion `Main` mehrere Abonnenten hinzu (mit dem Operator `+=` können Sie neue Abonnenten zu den bereits vorhandenen hinzufügen) und führen Sie das Programm dann aus.

    ```csharp hl_lines="2-3"
    p.AgeChanging = new AgeChangingDelegate(PersonAgeChanging);
    p.AgeChanging += new AgeChangingDelegate(PersonAgeChanging);
    p.AgeChanging += PersonAgeChanging; // Präzisere Syntax
    ```

    Es ist zu erkennen, dass alle drei registrierten/"abonnierten" Funktionen bei jeder Wertänderung ausgeführt werden. Dies ist möglich, weil die Mitgliedsvariablen des Delegatentyps nicht nur eine Funktionsreferenz, sondern eine **Funktionsreferenzliste** enthalten (und pflegen).

    Beachten Sie in der dritten Zeile oben, dass wir Funktionsreferenzen mit einer prägnanteren Syntax schreiben können, als wir sie beim ersten Mal gesehen haben: Geben Sie einfach den Namen der Funktion nach dem `+=` Operator an, ohne das `new AgeChangingDelegate(...)`.  Unabhängig davon wird ein `AgeChangingDelegate` -Objekt die `PersonAgeChanging` -Funktionen hinter den Kulissen umhüllen. In der Praxis verwenden wir diese prägnantere Syntax.

8. Versuchen Sie auch, sich abzumelden (an einem Punkt Ihrer Wahl) und starten Sie dann das Programm.

    ```csharp
    p.AgeChanging -= PersonAgeChanging;
    ```

## 3. Aufgabe - Ereignis (event)

So wie Eigenschaften eine syntaktisch schlankere Alternative zu Getter- und Setter-Methoden sind, bietet der oben beschriebene Delegat-Mechanismus eine schlankere Alternative zu den aus Java bekannten Event Listenern. Allerdings verstößt unsere obige Lösung immer noch erheblich gegen einige OO-Prinzipien (Einheiteneinschränkung, Verbergen von Informationen). Wir können dies anhand der folgenden zwei Beispiele veranschaulichen.

1. Das Ereignis kann auch von außen ausgelöst werden (durch die Operationen anderer Klassen). Das ist bedauerlich, denn so kann das Ereignis fälschlicherweise ausgelöst werden, auch wenn es in Wirklichkeit nicht eingetreten ist, und alle Teilnehmer werden getäuscht. Um dies zu demonstrieren, fügen Sie die folgende Zeile am Ende der Funktion `Main` ein.

    ```csharp
    p.AgeChanging(67, 12);
    ```

    Hier haben wir ein gefälschtes Altersänderungsereignis für das Objekt `p` `Person` ausgelöst und damit alle Abonnenten getäuscht. Eine gute Lösung wäre, wenn das Ereignis nur durch Aktionen der Klasse `Person` ausgelöst werden könnte.

2. Ein weiteres Problem ist das folgende. Während `+=` und `-=` andere Funktionen, die die Liste abonniert haben, respektieren, können Sie die Abonnements anderer jederzeit mit dem Operator `=` überschreiben (löschen). Versuchen wir dies, indem wir die folgende Zeile einfügen (direkt nach den An- und Abmeldungen).

    ```csharp
    p.AgeChanging = null;
    ```

3. Fügen wir das Schlüsselwort `event` zur `AgeChanging` Member-Variable `Person.cs`hinzu!

    ```csharp title="Person.cs"
    public event AgeChangingDelegate AgeChanging;
    ```

    Das Schlüsselwort `event` ist eigentlich dazu gedacht, unser Programm zurück auf den objektorientierten Weg zu zwingen und die beiden oben genannten Probleme auszuschließen.

4. Lassen Sie uns versuchen, das Programm zu übersetzen. Sie werden sehen, dass der Übersetzer unsere früheren Übertretungen jetzt als Übersetzungsfehler behandelt.

    ereignisfehler

5. Entfernen Sie die drei fehlerhaften Codezeilen (beachten Sie, dass die erste direkte Wertzuweisung bereits ein Fehler ist), kompilieren Sie dann und führen Sie Ihre Anwendung aus

## 4. Aufgabe - Attribute

### Anpassen der Sortierung nach Attribut

**Attribute sind ein deklarativer Weg, um Metadaten für Ihren Quellcode bereitzustellen**. Ein Attribut ist eigentlich eine Klasse, die an ein bestimmtes Element des Programms (Typ, Klasse, Schnittstelle, Methode usw.) angehängt ist. Diese Metainformationen können von jedem (auch von uns selbst) gelesen werden, während das Programm läuft, und zwar über einen Mechanismus, der Reflection genannt wird. Die Attribute können auch als das .NET-Äquivalent zu den Java-Annotationen betrachtet werden.

!!! tip "property vs. attribute vs. static"
    Es stellt sich die Frage, welche Klasseneigenschaften in properties und welche in attributes einer Klasse untergebracht werden sollten. Eigenschaften beziehen sich auf die Objektinstanz selbst, während sich ein Attribut auf die Klasse (oder ein Mitglied der Klasse) bezieht, die das Objekt beschreibt.

    In dieser Hinsicht sind Attribute näher an statischen Eigenschaften, aber es ist immer noch eine Überlegung wert, ob man ein bestimmtes Datenelement als statisches Mitglied oder als Attribut definiert. Mit einem Attribut ist die Beschreibung deklarativer, und wir verschmutzen den Code nicht mit Details, die nicht in der öffentlichen Schnittstelle der Klasse erscheinen sollten.

NET definiert viele **eingebaute** Attribute, die eine große Vielfalt an Funktionen haben können. Die im folgenden Beispiel verwendeten Attribute kommunizieren beispielsweise verschiedene Metainformationen mit dem XML-Sorter.

1. Fügen Sie den folgenden Codeschnipsel am Ende der Funktion `Main` ein und führen Sie dann Ihr Programm aus

    ```csharp
    var serializer = new XmlSerializer(typeof(Person));
    var stream = new FileStream("person.txt", FileMode.Create);
    serializer.Serialize(stream, p);
    stream.Close();
    Process.Start(neue ProzessStartInfo
    {
        Dateiname = "person.txt",
        UseShellExecute = true,
    });
    ```

    Der letzte Funktionsaufruf `Process.Start` im obigen Beispiel ist nicht Teil der Sortierlogik, sondern lediglich eine clevere Methode, um die resultierende Datendatei mit dem Windows-Standardtextdateibetrachter zu öffnen. Sie können dies versuchen, aber es hängt davon ab, welche .NET-Laufzeitumgebung Sie verwenden und ob diese von Ihrem Betriebssystem unterstützt wird. Ist dies nicht der Fall, erhalten Sie bei der Ausführung eine Fehlermeldung. In diesem Fall lassen Sie es unkommentiert und öffnen Sie die Datei `person.txt` manuell im Dateisystem (sie befindet sich in unserem Visual Studio Ordner unter *\bin\Debug\<etwas>* neben unserer .exe Anwendung).

2. Schauen wir uns die Struktur der resultierenden Datei an. Beachten Sie, dass jede Eigenschaft auf das XML-Element abgebildet wird, das ihrem Namen entspricht.

3. .NET-Attribute ermöglichen es uns, unsere Klasse `Person` mit Metadaten zu versehen, die das Verhalten des Sortierers direkt verändern. Das Attribut `XmlRoot` bietet die Möglichkeit, das Wurzelelement umzubenennen. Platzieren Sie es über der Klasse `Person`! 

    ```csharp hl_lines="1"
    [XmlRoot("Person")]
    public class Person 
    {
        // ...
    }
    ```

4. Das `XmlAttribute` -Attribut zeigt dem Klassifikator an, dass die Kandidateneigenschaft auf ein xml-Attribut und nicht auf ein xml-Element abgebildet werden soll. Machen wir daraus die Eigenschaft `Age` (und nicht die Member-Variable!)!

    ```csharp hl_lines="1"
    [XmlAttribute("Kor")]
    public int Alter
    ```

5. Das Attribut `XmlIgnore` zeigt dem Sortierer an, dass die Kandidateneigenschaft vollständig aus dem Ergebnis ausgelassen werden soll. Versuchen Sie es über das Grundstück `Name`. 

    ```csharp hl_lines="1"
    [XmlIgnore]
    public string Name { get; set; }
    ```

6. Führen Sie unsere App aus! Vergleichen Sie die Ergebnisse mit den vorherigen Ergebnissen.

## 5. Aufgabe - Delegieren 2.

In den Aufgaben 2 und 3 haben wir ereignisbasierte Nachrichtenübermittlung mit Delegierten implementiert. Bei einer **anderen typischen Verwendung von Delegaten werden Funktionsreferenzen verwendet, um eine Implementierung eines undefinierten Schritts an einen Algorithmus oder eine komplexere Operation zu übergeben**.

Zum Beispiel kann die eingebaute generische Listenklasse (`List<T>`) mit der Funktion `FindAll` eine neue Liste mit allen Elementen zurückgeben, die eine bestimmte Bedingung erfüllen. Die spezifische Filterbedingung kann als Funktion angegeben werden, genauer gesagt als Delegate-Parameter (dies ruft `FindAll` für jedes Element auf), der für jedes Element, das wir in der Ergebnisliste sehen wollen, true zurückgibt. Der Typ des Funktionsparameters ist der folgende vordefinierte Delegatentyp**(er muss nicht eingegeben/erstellt** werden, er existiert bereits):

```csharp
public delegate bool Predicate<T>(T obj)
```

!!! note
    Um die vollständige Definition oben anzuzeigen, geben Sie einfach `Predicate` irgendwo ein, z. B. am Ende der Funktion `Main`, klicken Sie mit der Maus darauf, und verwenden Sie ++f12++, um zur Definition zu navigieren.

Das heißt, sie nimmt als Eingabe eine Variable des gleichen Typs wie der Typ des Listenelements und als Ausgabe einen logischen (booleschen) Wert. Um dies zu veranschaulichen, fügen wir unserem vorherigen Programm einen Filter hinzu, der nur die ungeraden Einträge in der Liste behält.

1. Stellen Sie in Ihrer Anwendung eine Filterfunktion bereit, die ungerade Zahlen zurückgibt:

    ```csharp
    private static bool MyFilter(int n)
    {
        return n % 2 == 1;
    }
    ```

2. Vervollständigen wir den Code, den wir zuvor geschrieben haben, mit unserer Filterfunktion:

    ```csharp hl_lines="5"
    var list = new List\<int>();
    list.Add(1);
    list.Add(2);
    list.Add(3);
    list = list.FindAll(MyFilter);

    foreach (int n in Liste)
    {
        Console.WriteLine($"Wert: {n}");
    }
    ```

3. Führen Sie die Anwendung aus. Beachten Sie, dass in der Konsole nur ungerade Zahlen angezeigt werden.
4. Als Kuriosität können wir einen Haltepunkt innerhalb unserer Funktion `MyFilter` setzen und beobachten, dass die Funktion tatsächlich für jedes Listenelement einzeln aufgerufen wird.

!!! tip "Collection initializer syntax"
    Für alle Klassen (typischerweise Sammlungen) mit der Methode `Add`, die die Schnittstelle `IEnumerable` implementieren, lautet die Syntax für die Sammlungsinitialisierung wie folgt:

    ```csharp
    var list = new List<int>() { 1, 2, 3 };
    ```

    Ab C# 12 kann eine noch einfachere Syntax (*collection expression* genannt) verwendet werden, um eine Sammlung zu initialisieren, wenn der Compiler aus dem Typ der Variablen schließen kann, dass es sich um eine Sammlung handelt. Pl.:
    
    ```csharp
    Liste<int> liste = [1, 2, 3];
    ```

## 6. Aufgabe - Lambda-Begriffe

Die entsprechenden Themen werden in den Vorlesungsunterlagen ausführlich behandelt, sie werden hier nicht wiederholt. Siehe das Kapitel "Lambda-Ausdruck" im Dokument "Vorlesung 02 - Sprachwerkzeuge.pdf". Das Schlüsselelement ist `=>` (Lambda-Operator), das die Definition von **Lambda-Ausdrücken**, d. h. anonymen Funktionen, ermöglicht.

!!! note "`Action und Func`"
      Die in .NET eingebauten generischen Delegatentypen `Func` und `Action` werden hier aus Zeitgründen nicht behandelt. Sie sind immer noch Teil des Rohmaterials!

Das vorherige Problem 5 wird wie folgt gelöst: Geben Sie keine separate Filterfunktion an, sondern spezifizieren Sie die Filterlogik in Form eines Lambda-Ausdrucks für die Operation `FindAll`. 

Sie brauchen nur eine Zeile zu ändern:

```csharp
list = list.FindAll((int n) => { return n % 2 == 1; });
```

Eine unbenannte Funktion wird definiert und an den Vorgang `FindAll` übergeben:

- dies ist ein Lambda-Term,
- auf der linken Seite von `=>` haben wir die Parameter der Operation angegeben (hier gab es nur einen),
- auf der rechten Seite von `=>` haben wir die Wurzel der Operation angegeben (die gleiche wie die Wurzel der vorherigen `MyFilter` ).

Die obige Zeile kann in einer viel einfacheren und klareren Form geschrieben werden:

```csharp
list = list.FindAll(n => n % 2 == 1);
```

Es wurden die folgenden Vereinfachungen vorgenommen:

- wird der Typ des Parameters nicht geschrieben: der Compiler kann ihn aus dem Typ des Delegatenparameters von `FindAll` ableiten, der `Predicate`ist.
- die Klammern um den Parameter können weggelassen werden (da es nur einen Parameter gibt)
- auf der rechten Seite von `=>` könnten wir die Klammern und `return`weglassen (weil es nur einen Ausdruck im Funktionsrumpf gab, der von der Funktion zurückgegeben wird).

## 7. Andere Sprachkonstruktionen

Im Folgenden werfen wir einen Blick auf einige der C#-Sprachelemente, die bei alltäglichen Programmieraufgaben immer häufiger verwendet werden. Während der Übung kann es sein, dass keine Zeit bleibt, diese zu überprüfen.

### Ausdrucksstarke Mitglieder (Expression-bodied members)

Manchmal schreiben wir kurze Funktionen oder, im Falle von Eigenschaften, sehr oft kurze get/set/init-Definitionen, die aus einem **einzigen Ausdruck** bestehen. In diesem Fall kann der get/set/init-Stamm einer Funktion oder Eigenschaft unter Verwendung der Syntax für **Ausdrücke in Form von Members (Expression-bodied members)** angegeben werden, und zwar unter `=>`.  Dies kann unabhängig davon geschehen, ob es im Kontext einen Rückgabewert (Return-Anweisung) gibt oder nicht.

In den Beispielen werden wir sehen, dass die Verwendung von Ausdrucks-Tags nichts weiter als eine kleine syntaktische "Wendung" ist, um die Notwendigkeit zu minimieren, so viel umgebenden Code wie möglich in solch einfachen Fällen zu schreiben.

Schauen wir uns zunächst ein Funktionsbeispiel an (angenommen, die Klasse hat eine Mitgliedsvariable oder eine Eigenschaft `Age` ):

```csharp 
public int GetAgeInDogYear() => Alter * 7; 
public void DisplayName() => Console.WriteLine(ToString());
```
Wie Sie sehen können, haben wir die Klammern und die Anweisung `return` entfernt, so dass die Syntax prägnanter ist.

!!! tip "Wichtig"
    Obwohl hier das Token `=>` verwendet wird, hat dies nichts mit den zuvor besprochenen Lambda-Ausdrücken zu tun: Es ist einfach so, dass dasselbe `=>` Token (Symbolpaar) von C# für zwei völlig unterschiedliche Dinge verwendet wird.

Beispiel für die Angabe eines Property Getters:

```csharp
public int AgeInDogYear { get => Age * 7; }
```

Wenn Sie nur einen Getter für die Eigenschaft haben, können Sie sogar das Schlüsselwort `get` und die Klammern weglassen.

```csharp
public int AgeInDogYear => Age * 7;
```

Der Unterschied zur ähnlichen Syntax der bisherigen Funktionen ist, dass wir die runden Klammern nicht ausgeschrieben haben.

!!! note
    In der offiziellen Microsoft-Dokumentation wird "expression-bodied members" nicht als "expression-bodied", sondern als "expression-bodied" übersetzt. Vielen Dank, aber Funktionen haben in der ungarischen Terminologie eher einen Rumpf als einen Körper, also werden wir das nicht nehmen...

### Objektinitialisierer (Object initializer)

Die Initialisierung von öffentlichen Eigenschaften/Mitgliedsvariablen und der Aufruf des Konstruktors können mit einer Syntax kombiniert werden, die als Objektinitialisierung bezeichnet wird. Dazu wird nach dem Konstruktoraufruf ein Block mit eckigen Klammern geöffnet, in dem der Wert der öffentlichen Eigenschaften/Mitgliedsvariablen unter Verwendung der folgenden Syntax angegeben werden kann.

```csharp
var p = new Person()
{
    Alter = 17,
    Name = "Lukas",
};
```

Eigenschaften/Mitglieder werden initialisiert, nachdem der Konstruktor ausgeführt wurde (wenn die Klasse einen Konstruktor hat). Diese Syntax ist auch deshalb vorteilhaft, weil sie als ein Ausdruck zählt (im Gegensatz zu drei Ausdrücken, wenn Sie ein nicht initialisiertes Objekt `Person` erstellen und dann in zwei weiteren Schritten Werte an `Age` und `Name` übergeben). Auf diese Weise können Sie ein initialisiertes Objekt direkt als Parameter für einen Funktionsaufruf übergeben, ohne eine separate Variable deklarieren zu müssen.

```csharp
void Foo(Person p)
{
    // etwas mit p machen
}
```

```csharp
Foo(new Person() { Alter = 17, Name = "Luke" });
```

Die Syntax ist auch zum Kopieren und Einfügen geeignet, denn wie Sie in den obigen Beispielen sehen können, spielt es keine Rolle, ob nach der letzten Eigenschaft ein Komma steht oder nicht.

### Eigenschaften - Init only setter

Die Syntax für die Objektinitialisierung im vorigen Abschnitt ist sehr praktisch, erfordert aber, dass die Eigenschaft öffentlich ist. Wenn Sie möchten, dass eine Eigenschaft nur bei der Erstellung des Objekts auf einen Wert gesetzt wird, müssen Sie einen Konstruktorparameter einführen und ihn auf eine Nur-Lese-Eigenschaft (Getter-Only) setzen. Eine einfachere Lösung für dieses Problem ist die so genannte *Init only setter-Syntax*, bei der Sie mit dem Schlüsselwort `init` einen "Setter" erstellen können, der nur im Konstruktor und in der im vorigen Kapitel beschriebenen Syntax für die Objektinitialisierung gesetzt werden darf, nicht aber danach.

```csharp
public string Name { get; init; }
```

```csharp
var p = new Person()
{
    Alter = 17,
    Name = "Lukas",
};

p.Name = "Test"; // Erstellungsfehler, kann nicht nachträglich geändert werden
```

Sie können auch den init only setter als obligatorisch festlegen, indem Sie das Schlüsselwort `required` für die Eigenschaft verwenden. In diesem Fall muss der Wert der Eigenschaft in der Syntax der Objektinitialisierung angegeben werden, da sonst ein Übersetzungsfehler auftritt.

```csharp
public required string Name { get; init; }
```

Dies ist auch deshalb nützlich, weil Sie die obligatorischen Konstruktorparameter speichern können, wenn Sie die Eigenschaften der Klasse ohnehin veröffentlichen und die Syntax der Objektinitialisierung unterstützen wollen.


## 8. Aufgabe - Allgemeine Klassen (generic classes)

Hinweis: Die Zeit für diese Übung reicht wahrscheinlich nicht aus. In diesem Fall ist es ratsam, die Übung zu Hause zu machen.

Generische Klassen in .NET ähneln den Template-Klassen in C++, sind aber näher an den bereits bekannten generischen Klassen in Java. Sie können verwendet werden, um generische (Multi-Typ), aber typsichere Klassen zu erstellen. Wenn Sie ohne generische Klassen ein Problem allgemein behandeln wollen, verwenden Sie Daten des Typs `object` (da in .NET alle Klassen von der Klasse `object` abgeleitet sind). Dies ist z. B. bei `ArrayList`der Fall, einer Allzwecksammlung zum Speichern beliebiger Elemente des Typs `object`.  Schauen wir uns ein Beispiel für die Verwendung von `ArrayList` an:

```csharp
var list = new ArrayList();
list.Add(1);
list.Add(2);
list.Add(3);
for (int n = 0; n < list.Count; n++)
{
    // Du musst sie werfen, sonst wird sie nicht gedreht
    int i = (int)list[n];
    Console.WriteLine($"Wert: {i}");
}
```

Bei der obigen Lösung ergeben sich folgende Probleme:

-  `ArrayList` speichert jedes Element als `object`.
- Wenn Sie auf ein Element in der Liste zugreifen wollen, müssen Sie es immer in den richtigen Typ umwandeln.
- Nicht typsicher. Im obigen Beispiel hindert Sie nichts (und keine Fehlermeldung) daran, ein Objekt eines anderen Typs in die Liste neben dem Typ `int` einzufügen. In diesem Fall würden Sie nur dann einen Fehler erhalten, wenn Sie versuchen, den Typ, der nicht `int` ist, auf `int` zu übertragen. Bei der Verwendung generischer Sammlungen werden solche Fehler während der Übersetzung erkannt.
- Bei der Speicherung von Daten des Typs "Wert" ist die Liste langsamer, da der Typ "Wert" zunächst in eine Box eingeschlossen werden muss, um als `object`(d. h. als Referenztyp) gespeichert werden zu können.

Die Lösung des obigen Problems unter Verwendung einer allgemeinen Liste sieht wie folgt aus (in der Übung wird nur die hervorgehobene Zeile im zuvor eingegebenen Beispiel geändert):

```csharp hl_lines="1 7"
var list = new List<int>();
list.Add(1);
list.Add(2);
list.Add(3);
for (int n = 0; n < list.Count; n++)
{
    int i = list[n]; // Kein Casting erforderlich
    Console.WriteLine($"Wert: {i}");
}
```