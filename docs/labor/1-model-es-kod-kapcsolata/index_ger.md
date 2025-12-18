---
author: bzolka
---

# 1. Beziehung zwischen dem Modell und dem Code

## Das Ziel der Übung

Das Ziel der Übung:

- Kennenlernen der Studenten/Studentinnen und des Übungsleiters/ins
- Klärung der Anforderungen für Übungen
- Erste Schritte mit Visual Studio und der Entwicklung von .NET-Anwendungen.
- Erstellen einer einfachen Hello World .NET-Anwendung, C#-Grundlagen
- Veranschaulichung der Beziehung zwischen UML und Code
- Anwendungstechnik der Schnittstelle und der abstrakte Basisklasse 

??? Hinweis "Für Übungsleiter/in"
    Sicherlich gibt es einige Teilnehmer, die Visual Studio bereits in Prog2 (C++) oder aus anderen Gründen verwendet haben, aber es wird auch einige geben, die es noch nicht verwendet haben oder sich weniger daran erinnern. Das Ziel ist in diesem Fall, die Benutzeroberfläche kennenzulernen. So während der Lösung der Übungen, sollten die benutzte Dinge (z. B. Solution Explorer,  Ausführen mit ++f5++, Verwenden von Haltepunkten usw.) auch besprochen werden.

## Voraussetzungen

Die für die Ausführung der Übung benötigten Werkzeuge:

- Visual Studio 2026

Es sollte die neueste Version von Visual Studio installiert sein. Die Versionen Community Edition, Professional und Enterprise sind ebenfalls geeignet. Die Community Edition ist kostenlos und kann von der Microsoft-Website heruntergeladen werden. Der Professional ist kostenpflichtig, steht aber auch für Studenten der Universität kostenlos zur Verfügung (auf der Website, im Rahmen des Programms Azure Dev Tools for Teaching).

!!! Hinweis "Visual Studio Class Diagram support"
    Für einige Aufgaben in dieser Übung (und auch für die erste Hausaufgabe) werden wir die Unterstützung des Visual Studio Class Designer nutzen. Visual Studio fügt die Komponente Class Designer während der Installation nicht immer hinzu. Falls es nicht möglich ist, ein Klassendiagramm zum Visual Studio-Projekt hinzuzufügen (weil „Class Diagram“ in der Liste des Fensters, das beim Befehl „Add New Item“ erscheint, nicht gelistet wird - mehr dazu später in dieser Anleitung), muss man die Komponente Klassendiagramm später installieren:

    1. Starten Sie das Visual Studio-Installationsprogramm (z. B. durch Eingabe von "Visual Studio Installer" im Windows-Startmenü).
    2. Wählen Sie in dem nun erscheinenden Fenster die Registerkarte "Individual components"
    3. Geben Sie in das Suchfeld "class designer" ein und stellen Sie sicher, dass "Class Designer" in der gefilterten Liste aktiviert ist.
        
        ![Installation der Klassendiagramm-Unterstützung](images/vs-isntaller-add-class-diagram.png)

Was Sie sich ansehen sollten:

- Die Übung beinhaltet keine Vorlesung zu diesem Thema. Gleichzeitig baut die Übung auf grundlegendem UML-Kenntnisse und den Grundlagen der Abbildung von UML-Klassendiagrammen auf Code.

## Verlauf der Übung

Der/die Übungsleiter/in fasst die Anforderungen für die Übungen am Anfang der Übung zusammen:

- Die meisten davon finden Sie in dem Merkblatt
- Informationen zu den Hausaufgaben finden Sie auf der Website des Fachs.

Mit dem Entwicklungsumgebung Visual Studio werden wir .NET-Anwendungen in C# erstellen. C# ist ähnlich wie Java, wir lernen stufenweise die Unterschiede. Die Aufgaben werden gemeinsam unter der Leitung des Übungsleiters/ins durchgeführt.

## Lösung

??? success "Laden Sie die fertige Lösung herunter"
    :exclamation: Es ist wichtig, dass Sie sich während des Praktikums an die Anleitung halten. Es ist verboten (und sinnlos), die fertige Lösung herunterzuladen. Allerdings kann es bei der anschließenden Selbsteinübung nützlich sein, die fertige Lösung zu überprüfen, daher stellen wir sie zur Verfügung.

    Die Lösung ist auf [GitHub](https://github.com/bmeviauab00/lab-modellkod-kiindulo/tree/megoldas) verfügbar. Der einfachste Weg, es herunterzuladen, ist, es von der Kommandozeile aus mit dem Befehl `git clone` auf Ihren Computer zu klonen:

    ```git clone https://github.com/bmeviauab00/lab-modellkod-kiindulo -b solved```

    Sie müssen Git auf Ihrem Rechner installiert haben, weitere Informationen [hier](../../hazi/git-github-github-classroom/index.md#git-telepitese).

## 1. Aufgabe - Erstellen einer "Hello World" .NET-Konsolenanwendung

Die Aufgabe ist die Erstellung einer C#-Konsolenanwendung, die den Text "Hello world\!" auf der Konsole ausgibt.

Die Anwendung wird in C# geschrieben. Die kompilierte Anwendung wird von der .NET-Laufzeitumgebung ausgeführt. In der ersten Vorlesung werden die theoretischen Hintergründe des Kompilierens/Ablaufens und die Grundlagen von .NET behandelt.

Die Schritte zum Erstellen einer Projektmappe und eines Projekts in Visual Studio 2026:

1. Starten wir den "Neues Projekt erstellen" Dialogfeld, was auf zwei Arten geschehen kann:
    - Verwendung des Startfensters
        1. Visual Studio starten
        2. In der rechten Seitenleiste des erscheinenden Startfensters *Create new project*
    - Bereits in Visual Studio ausgeführt
        1. File / New-Project
2. Wählen wir im Dialogfeld "Neues Projekt erstellen" die Vorlage " *Console app* " (und **NICHT** die Vorlage " *Console app (.NET Framework)*", einschließlich der C#-Vorlage. Dass es sich um C# handelt, ist an der oberen linken Ecke des Vorlagensymbols zu erkennen. Wenn man es nicht in der Liste sieht, muss man es suchen/filtern. Man kann danach suchen, falls in der oberen Suchleiste "console" eingibt. Oder die Dropdown-Felder unten können auch verwendet werden: im ersten (Sprachauswahl) "C#", im dritten (Projekttypauswahl) "Console".

    ![Ein Projekt erstellen](images/vs-create-new-project-wizard.png)

3. Next-Taste am unteren Rand des Dialogfeldes "Neues Projekt erstellen", auf der nächsten Seite:
    1. Project name: **Hello World**
    2. Location: In den Labors arbeiten wir im Ordner **c:\work\<IhreName\>**, auf den Sie Schreibrechte haben.
    3. Solution name: **Hello World** (dies sollte bis zu unserer Ankunft hier eingeschrieben sein)
    4. Place solution and project in the same directory: kein Häkchen (aber nicht besonders wichtig).

4. Next-Taste am unteren Rand des Dialogfeldes "Neues Projekt erstellen", auf der nächsten Seite:
    1. Framework: **.NET 10 (Langfristige Unterstützung)**.
    2. Aktivieren wir das Kontrollkästchen "Do not use top level statements" (wir werden dies gleich erklären).

Das Projekt erstellt auch eine neue Projektmappe, deren Struktur im Visual Studio *Solution Explorer*-Fenster angezeigt werden kann. Eine Projektmappe (Solution) kann aus mehreren Projekten bestehen, und ein Projekt kann aus mehreren Dateien bestehen. Ein Solution ist eine Zusammenfassung der gesamten Arbeitsumgebung (sie hat die Dateierweiterung `.sln` ), während die Ausgabe eines Projekts typischerweise eine Datei `.exe` oder `.dll` ist, d. h. eine Komponente einer komplexen Anwendung/eines komplexen Systems. Projektdateierweiterung für C#-Anwendungen `.csproj`.

Der Inhalt unserer Datei `Program.cs` ist die folgende:

```csharp title="Program.cs"
namespace HelloWorld
{
    internal class  Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
        }
    }
}
```

Nehmen wir eine `Console.ReadKey()` Zeile aus: 

```csharp hl_lines="8"
namespace HelloWorld
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
            Console.ReadKey();
        }
    }
}
```

1. Führen wir die Anwendung aus (z. B. mit der Taste ++f5++ ).

    Die Struktur des Codes ist sehr ähnlich zu Java und C++. Unsere Klassen sind in Namespaces organisiert. Ein Namespace kann mit dem Schlüsselwort `namespace` definiert werden. Wir können Namespaces mit dem Schlüsselwort `using` "ins Geltungsbereich bringen". z.B.:

    ```csharp
    using System.Collections.Generic;
    ```

2. In einer C#-Konsolenanwendung wird der Eintrittspunkt der Anwendung mit einer statischen Funktion namens `Main` gegeben. Der Name der Klasse kann beliebig gewählt werden, in unserem Fall hat VS eine Klasse namens `Program` erzeugt. Die Parameterliste der Funktion `Main` ist gebunden: entweder werden keine Parameter angegeben, oder es wird ein `string[]`angegeben, in dem die Befehlszeilenargumente zur Laufzeit angegeben werden.
3. In .NET wird die Klasse `Console` aus dem Namensraum `System` verwendet, um die Standardeingabe und -ausgabe zu verarbeiten. Mit der statischen Aktion `WriteLine` kann man eine Zeile drucken, mit `ReadKey` kann man auf das Drücken einer Taste warten.

!!! tip "Top-Level-Anweisungen, implizite und statische Verwendungen und Namespaces"
    Bei der Projekterstellung haben wir zuvor das Kontrollkästchen "Do not use top level statements" aktiviert. Falls wir dies nicht getan hätten, hätten wir in unserer Datei `Program.cs` nur eine einzige Zeile mit Inhalt gefunden:

    ```cs
    // siehe https://aka.ms/new-console-template für weitere Informationen
    Console.WriteLine("Hello World!");
    ```

    Es ist funktionell äquivalent zu dem obigen Code, der die Klasse `Program` und ihre Funktion `Main` enthält. Schauen wir uns an, was dies möglich macht (Sie können hier mehr darüber lesen <https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/tutorials/top-level-statements>, beide neu in C# 10):

    - **Top level statements**. Die Idee ist, dass man Code direkt in einer einzigen Quelldatei schreiben kann, ohne dass Klassen/`Main` und andere Funktionsdefinitionen im Projekt vorhanden sind. In diesem Fall setzt der Compiler dies hinter den Kulissen in eine statische `Main`-Funktion einer Klasse, die wir nicht sehen. Die Motivation für seine Einführung war die Reduzierung von "Boilerplate"-Code für sehr einfache, "skriptartige" Anwendungen.
    - **Implicit global usings**. Je nachdem, welchen Projekttyp wir erstellt haben, werden bestimmte Basis-Namensräume automatisch im Hintergrund in allen Quelldateien verwendet (der Compiler verwendet dazu die *global using*-Direktive). Der Punkt ist: Auf diese Weise müssen Entwickler bestimmte häufig verwendete Namespaces (z.B. `System.IO`, `System.Collections.Generic`, etc.) nicht in jeder Quelldatei mit `using` importieren.
    - **Static using**. Es ist möglich, statische Klassen statt Namespaces in C# mit `using` zu verwenden, so es nicht wichtig ist, diese auszuschreiben, wenn sie verwendet werden. Ein häufiger Fall ist die Verwendung der Klasse "Console" oder "Math".

        ```csharp hl_lines="1 9"
        using static System.Console;

        namensraum ConsoleApp12
        {
            internal class Program
            {
                static void Main(string[] args)
                {
                    WriteLine("Hello World!");
                }
            }
        }
        ```

    - **Namensräume auf Dateiebene**. In C# 10 gibt es auch eine Vereinfachung bei der Deklaration von Namespaces, da es nicht mehr zwingend erforderlich ist, Klammern zu verwenden, so dass der angegebene Namespace für die ganze Datei gültig ist, z.B:

        ```csharp hl_lines="1"
        namespace HelloWorld;

        internal class Program
        {
            // ...
        }
        ```

!!! warning "Inconsistent visibility oder inconsistent accessibility Fehler"
    Während des Semesters können Sie bei der Durchführung von Programmieraufgaben auf Übersetzungsfehlermeldungen stoßen, die sich über *inconsistent visibility* oder *inconsistent accessibility* beschweren. Dieses Phänomen ist auf die Möglichkeit zurückzuführen, die Sichtbarkeit der einzelnen Typen (Klassen, Schnittstellen usw.) in einer .NET-Umgebung zu steuern:

    - `internal` oder keine Sichtbarkeit angeben: der Typ ist nur in der angegebenen Assembly (.exe, .dll)/dem angegebenen Projekt sichtbar
    - `public`: der Typ ist auch für andere Assemblys/Projekte sichtbar
    
    Der einfachste Weg, diesen Fehler zu vermeiden, ist, alle unsere Typen als öffentlich zu definieren, z.B.:

    ```csharp
    public class HardDisk
    {
        // ...
    }
    ```

## Theoretischer Überblick

Die Unterkapitel enthalten keine Übungen, sondern bieten den Studierenden eine mit Beispielen illustrierte Einführung in die entsprechenden theoretischen Themen.

### A) Theorie der Beziehung zwischen dem UML-Klassendiagramm und dem Code \[Student]\*

Das Material ist hier verfügbar: [Die Beziehung zwischen dem UML-Klassendiagramm und dem Code](../../egyeb/uml-kod-kapcsolata/index_ger.md) Dieses Thema wurde im vorangegangenen Semester in der Vorlesung Softwaretechnologien behandelt.

### B) Schnittstelle und abstrakte (Basis)Klasse \[Student]\*

Das Material ist hier verfügbar:  [Schnittstelle und abstrakte (angestammte) Klasse](../../egyeb/interfesz-es-absztrakt-os/index_ger.md).

Themen:

- Konzept und Definition abstrakter Klassen in C#
- Schnittstellenkonzepte und -definitionen in C#
- Vergleich von abstraktem Basisklasse und Schnittstelle

## 2. Aufgabe - Veranschaulichen der Beziehung zwischen UML und Code

### Aufgabenbeschreibung - Equipment inventory

Aufgabe: Wir haben die Aufgabe bekommen, eine Computerteilregister-Anwendung zu entwickeln. Mehr Details:

- Es soll fähig sein, verschiedene Arten von Teilen zu behandeln. Anfänglich sollten die Typen `HardDisk`, `SoundCard` und `LedDisplay` unterstützt werden, aber das System sollte leicht auf neue Typen erweiterbar sein.
- Daten der Teilen: Kaufsjahr, Alter (berechnet), Kaufspreis und aktueller Preis (berechnet), kann aber auch typspezifische Daten enthalten (z. B. Kapazität für `HardDisk` ).
- Der aktueller Preis hängt von der Art des Teils, dem Einkaufspreis und dem Produktionsjahr des Teils ab. Z.B. Je älter das Teil ist, desto höher ist die Ermäßigung, aber die Ermäßigung hängt von dem Typ des Teils ab.
- Es soll fähig sein, die speicherte Teilen aufzulisten.
- Die Klasse `LedDisplay` muss von einer Klasse `DisplayBase` abgeleitet sein, und der Quellcode der Klasse `DisplayBase` darf nicht verändert werden. In diesem Beispiel hat dies nicht viel Sinn, aber in der Praxis treffen wir oft auf ähnliche Situationen, in denen das von uns verwendete Framework/die Plattform verlangt, dass wir von einer eingebauten Klasse ableiten. Typischerweise ist dies der Fall, wenn wir mit Fenstern, Formularen oder benutzerdefinierten Steuerelementen arbeiten: Wir müssen sie von den eingebauten Klassen des Frameworks ableiten, und wir haben den Quellcode des Frameworks nicht (oder wollen ihn zumindest nicht ändern) - z.B. Java, .NET. In unserem Beispiel simulieren wir diese Situation, indem wir eine Ableitung von `DisplayBase`verlangen.

Die Implementierung ist erheblich vereinfacht: Die Teile werden nur im Speicher abgelegt, und die Auflistung ist so einfach wie möglich, einfach die Daten der registrierten Teile werden auf die Konsole geschrieben.

Bei den ersten Gesprächen erhalten wir vom Kunden folgende Information: Ein interner Mitarbeiter hat bereits mit der Entwicklung begonnen, ist aber aus Zeitmangel nur zu einer halbfertigen Lösung gekommen. Ein Teil unserer Aufgabe besteht darin, die halbfertige Lösung zu verstehen und die Aufgabe von dort aus umzusetzen.

### Klassendiagramm

Öffnen wir die Projektmappe des [Quellcodes](https://github.com/bmeviauab00/lab-modellkod-kiindulo) unseres Kunden mit dem Ausführen der folgenden Schritte.

Klonen wir das Git-Repository des ursprünglichen Projekts, das online auf GitHub verfügbar ist, in einen eigenen Ordner innerhalb des Ordners `C:\Work`: z. B.: `C:\Work\NEPTUN\lab1`. Öffnen wir in diesem neuen Ordner eine Befehlszeile oder Powershell und führen wir den folgenden git-Befehl aus:

```cmd
git clone https://github.com/bmeviauab00/lab-modellkod-kiindulo.git
```


Öffnen wir das Visual Studio Solution src/EquipmentInventory.sln im geklonten Ordner.

Blicken wir die Dateien im Solution Explorer kurz über. Es wäre hilfreich, die Beziehungen zwischen den Klassen in einem Klassendiagramm darzustellen, um sie zu verstehen. Wir wollen ein Klassendiagramm in unser Projekt einfügen. Klicken wir im Solution Explorer mit der rechten Maustaste auf das **Projekt** (nicht auf das Solution!), und wählen wir im Popup-Menü die Option *Add/New Item*. Dann wählen wir in dem erscheinenden Fenster die Option Class Diagram, geben wir am unten im Fenster Main.cd als der Namen des Diagramms ein, und schließen wir das Fenster mit OK.

!!! warning "Fehlende Class Diagram-Vorlage"
    Wenn das Element *Class Diagram* nicht in der Liste erscheint, ist die entsprechende Komponente von VS nicht installiert. Weitere Informationen hierzu finden Sie im Abschnitt Voraussetzungen in diesem Dokument.

Die Diagrammdatei `Main.cd` wird dann im  Solution Explorer angezeigt. Doppelklicken wir darauf, um sie zu öffnen. Unseres Diagramm ist derzeit leer. Ziehen wir die .cs-Quelldateien aus Solution Explorer mit drag&drop auf das Diagramm. VS prüft dann, welche Klassen in diesen Quelldateien enthalten sind, und zerlegt sie in UML-Klassen. Erstellen wir das Layout wie in der folgenden Abbildung gezeigt (man kann die Mitglieder der Klassen anzeigen, falls man auf den Doppelpfeil in der oberen rechten Ecke ihres Rechtecks klickt):

![Beginnendes Klassendiagramm](images/class-diagram-initial.png)

Wir können auch den Quellcode der Klassen anschauen, falls wir entweder auf die entsprechende Klasse im Diagramm doppelklicken oder die .cs-Dateien im  Solution Explorer öffnen. Wir werden die Folgenden erfahren:

- Die Klassen `SoundCard`, `HardDisk` und `LedDisplay` sind relativ gut entwickelt und verfügen über die notwendigen Attribute und Abfragefunktionen.
-  `LedDisplay` wird bei Bedarf von `DisplayBase` abgeleitet.
- Obwohl `EquipmentInventory` für die Register der auf Lager befindlichen Teile verantwortlich ist, wird praktisch nichts davon umgesetzt.
- Wir finden eine Schnittstelle `IEquipment`, mit `GetAge` und `GetPrice` Funktionen.

### EquipmentInventory

Lassen wir uns an der Lösung arbeiten. Lassen wir uns zuerst die grundlegenden Konzepte festlegen. In der Klasse `EquipmentInventory` speichern wir eine heterogene Sammlung verschiedener Teiltypen. Dies ist der Schlüssel zu einer konsistenten Teilverwaltung, so dass unsere Lösung problemlos mit neuen Teiltypen erweitert werden kann.

Wie früher erwähnt, kann eine einheitliche Verwaltung entweder durch die Implementierung einer gemeinsamen Basisklasse oder einer gemeinsamen Schnittstelle erreicht werden. In unserem Fall scheint die gemeinsame Basisklasse (z. B. `EquipmentBase`) eliminiert zu werden, denn durch ihre Einführung hätte die Klasse `LedDisplay` zwei Basisklassen: `DisplayBase`, die obligatorisch ist, und `EquipmentBase`, die wir zur einheitlichen Verwaltung einführen. Dies ist nicht möglich, in einer .NET-Umgebung kann eine Klasse nur einen Vorgänger haben. Die Lösung, `DisplayBase`so zu ändern, dass es von `EquipmentBase`stammt, ist nach unseren Anforderungen nicht möglich (es war eine Anforderung, dass der Quellcode nicht geändert werden durfte). Es bleibt also der schnittstellenbasierte Ansatz. Dies ist sicherlich die Schlussfolgerung des vorherigen Entwicklers der Anwendung, weshalb er die Schnittstelle `IEquipment` eingeführt hat.

Fügen wir eine generische Liste von Elementen des Typs `IEquipment` (keine Eigenschaft, sondern ein Feld\!) zur Klasse `EquipmentInventory` hinzu. Ihre Sichtbarkeit sollte - in dem Bemühen um Integration - `private`sein. Der Name sollte `equipment` sein (ohne "s" am Ende, im Englisch ist der Plural von equipment auch equipment). Um eine Membervariable hinzuzufügen, verwenden wir das *Class Details* Fenster von Visual Studio. Wenn das Fenster nicht sichtbar ist, kann es durch Auswahl von *View / Other Windows / Class Details* angezeigt werden.

![Details zur Klasse](images/class-details.png)

Der Typ der Mitgliedsvariablen ist `List<IEquipment>`. Der .NET-Typ `List` ist ein dynamisch dehnbares generisches Array (wie `ArrayList`in Java). Falls wir auf die Klasse `EquipmentInventory` im Diagramm blicken, so sehen wir, dass nur der Name der Mitgliedsvariablen angezeigt wird, nicht aber der Typ. Klicken wir mit der rechten Maustaste auf den Hintergrund des Diagramms und wählen wir im *Change Members Format* Menü  die Option *Display Full Signature*. Das Diagramm zeigt dann den Typ der Mitgliedsvariablen und die vollständige Signatur der Operationen.

![AusrüstungInventar](images/equipmentinventory.png)

Wenn wir auf die Klasse `EquipmentInventory` doppelklicken, können wir zum Quellcode navigieren, und wie wir sehen können, erscheint sie im Code tatsächlich als Mitgliedsvariable vom Typ Liste:

```csharp hl_lines="3"
class EquipmentInventory
{
    private List<IEquipment> equipment;
```

Einerseits freuen wir uns darüber, weil Visual Studio Round-Trip-Engineering unterstützt: **Änderungen am Modell werden sofort in den Code übernommen und umgekehrt**. Andererseits haben wir bereits darüber gesprochen, dass eine Klasse, die eine Sammlung von Mitgliedern einer anderen Klasse hat, sollte in das UML-Modell als eine Assoziationsbeziehung vom Typ 1-mehr zwischen den beiden Klassen erscheinen. Dies ist noch nicht der Fall in unserem Modell. Glücklicherweise kann die VS-Modellierungsschnittstelle dazu gebracht werden, diese Art von Verbindung in dieser Form anzuzeigen. Klicken wir dazu im Diagramm mit der rechten Maustaste auf die Membervariable equipment und wählen wir im Menü die Option *Show as Collection Association* aus. Die Schnittstelle `IEquipment` sollte dann nach rechts verschoben werden, damit im Diagramm genügend Platz für die Darstellung der Assoziationsverbindung und der Rolle der Verbindung bleibt:

![Sammlungsverband](images/collection-association.png)

Der Doppelpfeil, der auf der "Mehr"-Seite endet, entspricht nicht dem UML-Standard, aber sei man nicht zu traurig darüber, es ist nicht wichtig. Wir freuen uns darüber, dass der Name (und sogar der genaue Typ) der Mitgliedsvariablen am `IEquipment` Ende der die Beziehung darstellende Pfeil in der Rolle anzeigt ist.

Navigieren wir zum Quellcode von `EquipmentInventory` und schreiben wir den Konstruktor, der die Sammlung `equipment` initialisiert\!

```csharp
public EquipmentInventory()
{
    equipment = new List<IEquipment>();
}
```

Schreiben wir dann die Methode `ListAll`, die das Alter der Elemente und ihren aktuellen Preis ausgibt:

```csharp
public void ListAll()
{
    foreach (IEquipment eq in equipment)
    {
        Console.WriteLine($"Alter: {eq.GetAge()}\tPreis: {eq.GetPrice()}");
    }
}
```

Mit dem Befehl `foreach` durchlaufen wir die Elemente. Bei der Verwendung des Befehls `foreach` sollte `in` von einer Sammlung gefolgt werden, und `in` sollte eine Variablendeklaration (in diesem Fall `IEquipment eq`) vorangestellt werden, wo type der Elementtyp der Sammlung ist. Bei jeder Iteration nimmt diese Variable den Iterationswert der Sammlung an.

Der Operation `Console.WriteLine` wird entweder eine einfache Zeichenfolge oder, wie in unserem Fall, eine Formatierungszeichenfolge übergeben. Die Ersetzungen werden durch String-Interpolation gelöst: Die zu ersetzenden Werte müssen zwischen `{}` angegeben werden. Bei der String-Interpolation muss der String mit `$` beginnen.

Schreiben wir eine Funktion mit dem Namen `AddEquipment`, die ein neues Bestandteil zu der Liste hinzufügt:

```csharp
public void AddEquipment(IEquipment eq)
{
     equipment.Add(eq);
}
```

### Verwirklichern von IEquipment

Wir haben entschieden, die Schnittstelle `IEquipment` zu verwenden, um die verschiedenen Komponententypen einheitlich zu verwalten. In unserem Fall haben sowohl die Klassen `SoundCard` als auch `HardDisk` die Methoden `GetAge()` und `GetPrice()`, aber wir können sie nicht einheitlich verwalten (z. B. in einer gemeinsamen Liste speichern). Zu diesem Zweck müssen wir beide Klassen dazu bringen, die Schnittstelle `IEquipment` zu implementieren. Ändern wir ihr Quellcode:

```csharp
public class SoundCard : IEquipment
```

```csharp
public class HardDisk : IEquipment
```

Dann müssen wir die Methoden der Schnittstelle `IEquipment` in den Klassen `SoundCard` und `HardDisk` implementieren. Wir stellen fest, dass es damit nichts mehr zu tun gibt, die Funktionen `GetPrice` und `GetAge` sind bereits an beiden Stellen geschrieben.

Erstellen wir testweise ein Objekt `EquipmentInventory` in unserer `Main` Funktion in `Program.cs`, füllen wir es mit den Objekten `HardDisk` und `SoundCard` auf, und listen wir das Objekt dann in der Konsole aus. Wenn 2021 nicht das aktuelle Jahr ist, schreiben wir in den folgenden Zeilen das Jahr 2021 auf das aktuelle Jahr und das Jahr 2020 auf eine mit eins kleinere Zahl um\!

```csharp
static void Main( string[] args )
{
    EquipmentInventory ei = new EquipmentInventory();

    ei.AddEquipment(new HardDisk(2023, 30000, 80));
    ei.AddEquipment(new HardDisk(2024, 25000, 120));
    ei.AddEquipment(new HardDisk(2024, 25000, 250));

    ei.AddEquipment(new SoundCard(2024, 8000));
    ei.AddEquipment(new SoundCard(2025, 7000));
    ei.AddEquipment(new SoundCard(2024, 6000));

    ei.ListAll();
}
```

Wenn wir die Anwendung ausführen, stellen wir fest, dass unsere Lösung zwar anfänglich ist, aber funktioniert:

![Ausgabe auf der Konsole](images/console-out-1.png)

Arbeiten wir weiter mit der Klasse `LedDisplay`.  Der Quellcode von `DisplayBase` kann aufgrund der Anforderungen nicht geändert werden. Aber das ist kein Problem, unsere Klasse `LedDisplay` wird die Schnittstelle `IEquipment` implementieren, lassen wir uns den Code entsprechend ändern:

```csharp
public class LedDisplay : DisplayBase, IEquipment
```

In der Klasse `LedDisplay` müssen die Funktionen der Schnittstelle bereits geschrieben werden:

```csharp
public double GetPrice()
{
    return this.price;
}

public int GetAge()
{
    return DateTime.Today.Year - this.manufacturingYear;
}
```

Erweitern wir unsere `Main` Funktion, fügen wir zwei `LedDisplay` Objekte zu unserer Liste hinzu (auch hier gilt: Wenn 2021 nicht das aktuelle Jahr ist, schreiben wir in den folgenden Zeilen das Jahr 2021 auf das aktuelle Jahr und das Jahr 2020 auf eine mit eins kleinere Zahl um\!)

```csharp hl_lines="1 2"
ei.AddEquipment(new LedDisplay(2020, 80000, 17, 16));
ei.AddEquipment(new LedDisplay (2021, 70000, 17, 12));
        
ei.ListAll();
Console.ReadKey();
```

Führen wir die Anwendung testweise aus.

## 3. Aufgabe - Anwendung der Schnittstelle und der abstrakten Basisklasse

### Schnittstellenprobleme

Bewerten wir unsere aktuelle schnittstellenbasierte Lösung.

Eines der Hauptprobleme ist, dass unser Code mit Code-Duplikationen voll ist, die die Wartbarkeit und Erweiterbarkeit zerstören:

- Die Mitglieder `yearOfCreation` und `newPrice` gelten für alle Komponententypen (mit Ausnahme des speziellen `LedDisplay`) und müssen immer mit copy-paste hinzugefügt werden, wenn ein neuer Typ eingeführt wird.
- Die Implementierung der Funktion `GetAge` ist für alle Komponententypen (mit Ausnahme der speziellen `LedDisplay`) gleich, auch mit copy-paste wird "vermehrt".
- Die Zeilen in den Konstruktoren, die die Mitglieder `yearOfCreation` und `newPrice` initialisieren, werden ebenfalls in jeder Klasse dupliziert.

Auch wenn diese Codeduplizierung im Moment noch unbedeutend zu sein scheint, wird die Situation mit der Einführung neuer Komponententypen immer schlechter, und es ist besser, künftigen Problemen rechtzeitig zu lösen.

Ein weiteres Problem besteht darin, dass die Auflistung der Teiledaten derzeit schmerzlich unvollständig ist, da kein Typ gelistet wird (nur Alter und Preis). Um den Typ anzuzeigen, muss die Schnittstelle `IEquipment` erweitert werden, z. B. durch Einführung einer Operation namens `GetDescription`.   Fügen wir der Schnittstelle eine Funktion `GetDescription` hinzu\!

```csharp hl_lines="5"
public interface IEquipment
{
    double GetPrice();
    int GetAge();
    string GetDescription();
}
```

Dann müsste jede Klasse, die die Schnittstelle `IEquipment` implementiert, diese Methode implementieren, was für viele Klassen eine Menge Arbeit bedeutet (und für eine Mehrkomponenten-Anwendung, d.h. eine Anwendung, die aus mehreren DLLs besteht, oft gar nicht machbar ist, wenn sie nicht in den Händen eines einzigen Entwicklers liegen). Führen wir den Befehl *Build* aus, um zu überprüfen, ob wir nach dem Hinzufügen von `GetDescription` an drei Stellen Übersetzungsfehler erhalten.

!!! tip "Standardimplementierung in der Schnittstelle festlegen" 
    Es ist wichtig zu wissen, dass ab C# 8 (genauer .NET oder .NET Core Runtime ist auch nötig, es ist unter .NET Framework nicht unterstützt ) **Schnittstellenoperationen eine Standardimplementierung erhalten können (default interface methods), so dass wir zur Lösung des obigen Problems keine abstrakte Klasse benötigen, aber die Schnittstelle kann weiterhin keine Mitgliedsvariablen haben**. Weitere Informationen finden Sie hier: [default interface methods](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/proposals/csharp-8.0/default-interface-methods).

    ```csharp hl_lines="5"
    public interface IEquipment
    {
        double GetPrice();
        int GetAge();
        string GetDescription() { return "EquipmentBase"; }
    }
    ```

### Abstrakte Klasse

Eine Lösung für beide Probleme ist die Einführung eines gemeinsamen abstrakten Vorfahres (mit Ausnahme der Klasse `LedDisplay`, auf die wir noch zurückkommen werden). Wir können den Code, der allen Nachkommen gemeinsam ist, dorthin verschieben und eine Standardimplementierung für die neu eingeführte Operation `GetDescription` bereitstellen. Nennen wir unsere neue abstrakte Basisklasse `EquipmentBase`. Die Frage ist, ob die Schnittstelle `IEquipment` noch benötigt wird oder ob sie vollständig durch die neue Klasse `EquipmentBase` ersetzt werden kann. Wir müssen die Schnittstelle `IEquipment` beibehalten, weil wir unsere Klasse LedDisplay nicht von `EquipmentBase`ableiten können: Sie hat bereits eine obligatorische Basisklasse, `DisplayBase`, deshalb bezieht sich EquipmentInventory in unserer erweiterten Lösung auf die verschiedenen Komponenten als Schnittstelle `IEquipment`. 

Beginnen wir mit der Umwandlung. Unser Klassendiagramm soll die aktive Registerkarte sein. Ziehen wir aus der *Toolbox* mit *drag&drop* ein  *Abstract Class* Element auf das Diagramm und benennen wir es `EquipmentBase`.

![Toolbox - abstrakte Klasse](images/toolbox-abstract-class.png)

Im Folgenden müssen wir die Klassen `SoundCard` und `HardDisk` von `EquipmentBase`ableiten (`LedDisplay`hat bereits einen anderen Vorfahren, so dass wir dies dort nicht tun können). Wählen wir dazu die Verknüpfung *Inheritance* in der *Toolbox* und ziehen wir dann eine Linie von der Kindklasse zur Basisklasse sowohl für `SoundCard` als auch für `HardDisk`. 

Im nächsten Schritt ändern wir den Code so, dass `HardDisk` und `SoundCard` die Schnittstelle `IEquipment` nicht separat implementieren, sondern ihr gemeinsamer Vorfahre `EquipmentBase` dies tut. Ändern wir dazu die Klasse `EquipmentBase` so, dass sie die Schnittstelle implementiert (entweder durch Einfügen eines inheritance Beziehung von `EquipmentBase` zu `IEquipment` im Diagramm oder durch Ändern des Quellcodes von `EquipmentBase` ). Entfernen wir die Implementierung von `IEquipment` aus den Klassen `HardDisk` und `SoundCard` (der Vorgänger implementiert sie bereits).

Die relevanten Teile unseres Diagramms und des Quellcodes sehen dann wie folgt aus:

![EquipmentBase und HardDisk/SoundCard](images/class-diagram-eqipmentbase-sc-hd-2.png)

```csharp
public abstract class EquipmentBase : IEquipment
```

```csharp
public class HardDisk : EquipmentBase
```

```csharp
public class SoundCard : EquipmentBase
```

Unser Code kann aus mehreren Gründen noch nicht kompiliert werden.  `EquipmentBase` implementiert die Schnittstelle `IEquipment`, aber sie implementiert noch nicht die Operationen der Schnittstelle. Erzeugen wir die Methoden entweder mit Hilfe des Smarttags oder geben wir sie nach den folgenden Grundsätzen ein:

- Die Mitglieder `newPrice` und `yearOfCreation` sind in den Klassen `HardDisk` und `SoundCard` dupliziert: verschieben (nicht kopieren\!) wir sie in den gemeinsamen Vorfahren `EquipmentBase` und geben wir `protected` Sichtbarkeit.
- Die Operation `GetAge` wird in den Klassen `HardDisk` und `SoundCard` dupliziert, löschen wir die Implementierung aus diesen Klassen und verschieben wir sie in die Klasse `EquipmentBase`. 
- Die Operation `GetPrice` wird als abstrakte Operation in den Vorgänger aufgenommen. Dies ist eine bewusste Design-Entscheidung, so dass wir nachkommende Klassen zwingen, diesen Vorgang trotzdem zu überschreiben.
- Für `GetDescription` gilt das Gegenteil: Wir definieren es als virtuell (und nicht abstrakt), d. h. sie erhält bereits in der Basisklasse eine Implementierung. Dadurch sind die abgeleiteten Klassen nicht dazu gezwungen, die Methode zu überschreiben.

Der entsprechende Code:

```csharp
public abstract class EquipmentBase : IEquipment
{
    protected int yearOfCreation;
    protected int newPrice;

    public int GetAge()
    {
        return DateTime.Today.Year - yearOfCreation;
    }

    public abstract double GetPrice();

    public virtual string GetDescription()
    {
        return "EquipmentBase";
    }
}
```

!!! tip "Einige zusätzliche Gedanken zum Codefragment:"

    - Bei abstrakten Klassen muss das Schlüsselwort `abstract` vor das Wort `class` geschrieben werden.
    - Für abstrakte Operationen muss das Schlüsselwort `abstract` angegeben werden.
    - In .NET-Umgebung kann man steuern, ob eine Methode virtuell ist oder nicht. In dieser Hinsicht ist es ähnlich wie C++. Wenn man eine Operation virtuell machen will, muss man das Schlüsselwort `virtual` für die Operation angeben. Zur Erinnerung: Man definiert eine Operation als virtuell, wenn ihre Nachkommen sie überdefinieren (können). Nur dann ist gewährleistet, dass die Nachfolgeversion aufgerufen wird, wenn die angegebene Operation auf einen Vorgängerverweis angewendet wird.

### Nachkommen

Im nächsten Schritt gehen wir zu den Nachkommen von `EquipmentBase` über. Wenn abstrakte und virtuelle Operationen in C# überschrieben werden, muss das Schlüsselwort `override` im Nachfahren angegeben werden. Zuerst wird die Methode `GetPrice` neu definiert:

```csharp title="HardDisk.cs"
public override double GetPrice()
{
    return yearOfCreation < (DateTime.Today.Year - 4)
        ? 0
        : newPrice - (DateTime.Today.Year - yearOfCreation) * 5000;
}
```

```csharp title="SoundCard.cs"
public override double GetPrice()
{
    return yearOfCreation < (DateTime.Today.Year - 4)
        ? 0 
        : newPrice - (DateTime.Today.Year - yearOfCreation) * 2000;
}
```

Im nächsten Schritt werden wir die Operation `GetDescription` in die Klassen `HardDisk` und `SoundCard` schreiben. Da wir hier die virtuelle Vorgängerfunktion umdefinieren, müssen wir auch das Schlüsselwort `override` angeben:

```csharp title="HardDisk.cs"
public override string GetDescription()
{
    return "Hard Disk";
}
```

```csharp title="SoundCard.cs"
public override string GetDescription()
{
    return "Sound Card";
}
```

Man könnte sich fragen, warum die Entwickler der Sprache C# beschlossen haben, der Definition von Operationen ein zusätzliches Schlüsselwort hinzuzufügen, was im Fall von C++ nicht notwendig war. Der Grund dafür ist einfach: Der Code ist aussagekräftiger. Wenn man sich den Code der Nachkommen ansieht, macht das Wort `override` sofort klar, dass diese Operation in einem der Vorfahren abstrakt oder virtuell ist, ohne dass man sich den Code aller Vorfahren ansehen muss.

### Vorfahre von LedDisplay

Die Basisklasse unserer `LedDisplay` Klasse ist gebunden, ihr Code kann nicht geändert werden, daher können wir sie nicht von `EquipmentBase`ableiten. Wir können die Funktion `GetAge` nicht löschen, diese Code-Duplizierung bleibt hier erhalten (aber nur für `LedDisplay`, die nur eine Klasse unter vielen ist\!).

!!! note
    Mit ein wenig zusätzlicher Arbeit könnten wir diese Codeduplizierung beseitigen. Dazu müsste eine statische Hilfsfunktion in eine der Klassen aufgenommen werden (z. B. `EquipmentBase`) , die das Produktionsjahr ermittelt und das Alter zurückgibt.  `EquipmentBase.GetAge` und `LedDisplay.GetAge` würden diese Hilfsfunktion für ihre Ausgabe verwenden.

    In unserer Klasse `LedDisplay` müssen wir noch `GetDescription` schreiben:

```csharp title="LedDisplay.cs"
public string GetDescription()
{
    return "Led Display";
}
```

Beachten wir, dass das Schlüsselwort `override` hier NICHT angegeben ist. Wenn eine Schnittstellenfunktion implementiert ist, muss/darf `override`nicht ausgeschrieben werden.

### GetDescription verwenden

Ändern wir die Operation `EquipmentInventory.ListAll`, um auch die Beschreibung der Elemente in die Ausgabe zu schreiben:

```csharp title="EquipmentInventory.cs"
public void ListAll()
{
    foreach (IEquipment eq in equipment)
    {
        Console.WriteLine("$Beschreibung: {eq.GetDescription()}\t" +
            $"Alter: {eq.GetAge()}\tPreis: {eq.GetPrice()}");
    }
}
```

Dies führt zu einer informativeren Ausgabe, wenn die Anwendung ausgeführt wird:

![Ausgabe auf der Konsole](images/console-out-2.png)

### Duplizierung von Konstruktorcode

Ein Blick auf unseren Code zeigt, dass es eine weitere Duplikation gibt. Alle Nachfahren von `EquipmentBase` (`HardDisk`, `SoundCard`) haben diese beiden Zeilen in ihrem Konstruktor:

```csharp
 this.yearOfCreation = yearOfCreation;
 this.newPrice = newPrice;
```

Wenn wir nachdenken, werden diese `yearOfCreation` und `newPrice` Mitglieder im Vorfahren definiert, also sollte es seine Verantwortung sein, sie zu initialisieren. Fügen wir einen entsprechenden Konstruktor in `EquipmentBase`hinzu:

```csharp title="EquipmentBase.cs"
public EquipmentBase(int yearOfCreation, int newPrice)
{
    this.yearOfCreation = yearOfCreation;
    this.newPrice = newPrice;
}
```

Entfernen wir die Initialisierung der beiden Mitglieder aus dem Konstruktor der Nachfahren `HardDisk` und `SoundCard` und rufen wir stattdessen den Konstruktor des Vorfahren auf, indem wir auf das Schlüsselwort `base` verweisen:

```csharp title="HardDisk.cs"
public HardDisk(int yearOfCreation, int newPrice, int capacityGB)
    : base(yearOfCreation, newPrice)
{
    this.capacityGB = capacityGB;
}
```

```csharp title="SoundCard.cs"
public SoundCard(int yearOfCreation, int newPrice)
    : base(yearOfCreation, newPrice)
{
}
```

### Bewertung

Durch die Verwendung einer Kombination aus Schnittstelle und abstrakter Basisklasse ist es uns gelungen, die Lösung mit dem geringsten Kompromiss zu entwickeln:

- `IEquipment` als Schnittstelle können wir alle Arten von Teilen einheitlich behandeln, auch solche, bei denen die Basisklasse gebunden war (mit abstrakter Basisklasse allein hätten wir dies nicht erreichen können).
- Durch die Einführung der abstrakten Basisklasse `EquipmentBase` konnten wir den Code, der in den verschiedenen Komponententypen gemeinsam ist, mit einer Ausnahme in einen gemeinsamen Basisklasse bringen und so Code-Duplikationen vermeiden.
- Durch die Einführung des abstrakten Basisklasse `EquipmentBase` können wir eine Standardimplementierung für neu eingeführte Methode der Schnittstelle `IEquipment` (z.B. `GetDescripton`) angeben, so dass wir nicht gezwungen sind, diese in jeder `IEquipment` Implementierungsklasse anzugeben.

Werfen wir abschließend noch einen Blick auf das UML-Klassendiagramm unserer Lösung:

![Ultimatives Klassendiagramm](images/class-diagram-final.png)

!!! note "C# 11 - Statische Schnittstellen"
    Die neueste Funktion von C# 11 ist die Definition von statischen Schnittstellenmitgliedern, die es Ihnen ermöglicht, von einer implementierenden Klasse zu verlangen, dass sie Mitglieder hat, die sich nicht auf die Objektinstanz beziehen, sondern die Klasse muss über ein bestimmtes statisches Mitglied verfügen. Mehr lesen

### Hinweis - fakultative Hausaufgabe

Unsere Lösung unterstützt nicht die Anzeige von komponentenspezifischen Daten (z.B. Kapazität für `HardDisk` ) während der Auflistung. Zu diesem Zweck sollte das Schreiben von Komponentendaten in eine formatierte Zeichenkette von der Klasse `EqipmentInventory` in die Komponentenklassen verlagert werden, und zwar nach den folgenden Grundsätzen:

- Sie können eine `GetFormattedString` Operation in die `IEquipment` Schnittstelle einführen, die ein Objekt vom Typ `string` zurückgibt. Alternativ kann die Operation `System.Object ToString()` überschrieben werden. In .NET sind alle Typen implizit von `System.Object`abgeleitet, das über eine virtuelle Operation `ToString()` verfügt.
- In `EquipmentBase`schreiben Sie die Formatierung der gemensamen Mitglieder (Beschreibung, Preis, Alter) in Strings.
- Wenn eine Komponente auch typspezifische Daten hat, dann überschreibt ihre Klasse die Funktion, die sie in eine Zeichenkette formatiert: Diese Funktion muss zuerst ihren Vorgänger aufrufen (mit dem Schlüsselwort `base` ), dann ihre eigenen formatierten Daten an sie anhängen und mit dieser Zeichenkette zurückkehren.
