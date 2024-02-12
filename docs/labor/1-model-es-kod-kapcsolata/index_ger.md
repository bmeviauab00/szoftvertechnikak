---
autoren: bzolka
---

# 1. Beziehung zwischen dem Modell und dem Code

## Das Ziel der Übung

Das Ziel der Übung:

- Kennenlernen der Schüler/Trainer
- Klärung der Anforderungen für Übungen
- Erste Schritte mit Visual Studio und der Entwicklung von .NET-Anwendungen.
- Erstellen einer einfachen Hello World .NET-Anwendung, C#-Grundlagen
- Veranschaulichung der Beziehung zwischen UML und Code
- Die Schnittstelle und die abstrakte primitive Klasse Anwendungstechnik

??? Hinweis "Für Praktiker"
    Während es sicherlich einige Studenten geben wird, die die Visual Studio-Umgebung bereits in Prog2 (C++) oder aus anderen Gründen verwendet haben, wird es mit ziemlicher Sicherheit andere geben, die sie nicht verwendet haben oder sich weniger daran erinnern. Ziel ist es, sich mit der Benutzeroberfläche vertraut zu machen. Während Sie die Übungen durcharbeiten, werden Sie mit den Dingen vertraut gemacht, die Sie zum Erstellen Ihrer ersten C#-Anwendung verwenden (z. B. Lösungsexplorer, ++Ausführen von f5++, Verwenden von Haltepunkten usw.).

## Voraussetzungen

Die für die Durchführung der Übung benötigten Werkzeuge:

- Visual Studio 2022

Es sollte die neueste Version von Visual Studio installiert sein. Die Versionen Community Edition, Professional und Enterprise sind ebenfalls geeignet. Die Community Edition ist kostenlos und kann von der Microsoft-Website heruntergeladen werden. Der Professional ist kostenpflichtig, steht aber auch Studenten der Universität kostenlos zur Verfügung (auf der Website, im Rahmen des Programms Azure Dev Tools for Teaching).

!!! Hinweis "Visual Studio Class Diagram support"
    Für einige der Übungen in dieser Übung (und auch für die erste Hausaufgabe) werden wir die Unterstützung des Visual Studio Class Designer nutzen. Visual Studio fügt die Komponente Class Designer während der Installation nicht immer hinzu. Wenn es nicht möglich ist, ein Klassendiagramm zu Ihrem Visual Studio-Projekt hinzuzufügen (weil das Klassendiagramm nicht in der Liste des Fensters aufgeführt ist, das während des Befehls Neues Element hinzufügen angezeigt wird - mehr dazu später in diesem Handbuch), müssen Sie die Komponente Klassendiagramm später installieren:

    1. Starten Sie das Visual Studio-Installationsprogramm (z. B. durch Eingabe von "Visual Studio Installer" im Windows-Startmenü).
    2. Wählen Sie in dem nun erscheinenden Fenster die Registerkarte "Einzelne Komponenten"
    3. Geben Sie in das Suchfeld "Klassendesigner" ein und vergewissern Sie sich, dass "Klassendesigner" in der gefilterten Liste nicht angekreuzt ist.
        
        ![Installation der Klassendiagramm-Unterstützung](images/vs-isntaller-add-class-diagram.png)

Was Sie sich ansehen sollten:

- Die Übung beinhaltet keine Vorlesung zu diesem Thema. Gleichzeitig baut die Übung auf grundlegendem UML-Wissen und den Grundlagen der Abbildung von UML-Klassendiagrammen auf Code auf.

## Verlauf der Übung

Der Ausbilder fasst die Anforderungen für die Übungen zu Beginn der Übung zusammen:

- Die meisten davon finden Sie in dem Merkblatt
- Informationen zu den Hausaufgaben finden Sie auf der Website des Fachs.

Mit dem Entwicklungswerkzeug Visual Studio werden wir .NET-Anwendungen in C# erstellen. C# ist ähnlich wie Java, wir lernen allmählich die Unterschiede. Die Aufgaben werden gemeinsam unter der Leitung des Übungsleiters durchgeführt.

## Lösung

??? success "Laden Sie die fertige Lösung herunter"
    :exclamation: Es ist wichtig, dass Sie sich während des Praktikums an die Anleitung halten. Es ist verboten (und sinnlos), die fertige Lösung herunterzuladen. Allerdings kann es bei der anschließenden Selbsteinübung nützlich sein, die fertige Lösung zu überprüfen, daher stellen wir sie zur Verfügung.

    Die Lösung ist [verfügbar auf GitHub] (https://github.com/bmeviauab00/lab-modellkod-kiindulo/tree/megoldas). Der einfachste Weg, es herunterzuladen, ist, es von der Kommandozeile aus mit dem Befehl `git clone` auf Ihren Computer zu klonen:

    ```git clone https://github.com/bmeviauab00/lab-modellkod-kiindulo -b solved```

    Sie müssen Git auf Ihrem Rechner installiert haben, weitere Informationen [hier](../../hazi/git-github-github-classroom/index.md#git-telepitese).

## 1. Aufgabe - Erstellen einer "Hallo Welt" .NET-Konsolenanwendung

Die Aufgabe besteht darin, eine C#-Konsolenanwendung zu erstellen, die den Text "Hello world\!" auf der Konsole ausgibt.

Die Anwendung ist in C# geschrieben. Die kompilierte Anwendung wird von der .NET-Laufzeitumgebung ausgeführt. In der ersten Vorlesung werden die theoretischen Hintergründe des Kompilierens/Ablaufens und die Grundlagen von .NET behandelt.

Die Schritte zum Erstellen einer Projektmappe und eines Projekts in Visual Studio 2022:

1. Starten Sie einen neuen Projektassistenten, was auf zwei Arten geschehen kann
    - Verwendung des Startfensters
        1. Visual Studio starten
        2. In der rechten Seitenleiste des erscheinenden Startfensters *Neues Projekt erstellen*
    - Bereits in Visual Studio ausgeführt
        1. Datei / Neues Projekt
2. Wählen Sie im Assistenten "Neues Projekt erstellen" die Vorlage " *Konsolenanwendung* " (und **NICHT** die Vorlage " *Konsolenanwendung (.NET Framework)* ", einschließlich der C#-Vorlage. Dass es sich um C# handelt, ist an der oberen linken Ecke des Vorlagensymbols zu erkennen. Wenn Sie es nicht in der Liste sehen, müssen Sie es suchen/filtern. Sie können danach suchen, indem Sie in der oberen Suchleiste "Konsole" eingeben. Oder verwenden Sie die Dropdown-Felder unten: im ersten (Sprachauswahl) "C#", im dritten (Projekttypauswahl) "Konsole".

    ![Ein Projekt erstellen](images/vs-create-new-project-wizard.png)

3. Weiter am unteren Rand des Assistentenfensters, auf der nächsten Assistentenseite:
    1. Name des Projekts: **Hallo Welt**
    2. Speicherort: In den Labors arbeiten Sie im Ordner **c:\work\<filename\>**, auf den Sie Schreibrechte haben.
    3. Name der Lösung: **Hello World** (dies sollte bis zu unserer Ankunft bereits eingegeben sein)
    4. Projektmappe und Projekt in dasselbe Verzeichnis legen: kein Problem (aber nicht besonders wichtig).

4. Weiter am unteren Rand des Assistentenfensters, auf der nächsten Assistentenseite:
    1. Rahmenwerk: **.NET 8 (Langfristige Unterstützung)**.
    2. Aktivieren Sie das Kontrollkästchen "Keine Anweisungen der obersten Ebene verwenden" (wir werden dies gleich erklären).

Das Projekt erstellt auch eine neue Projektmappe, deren Struktur im Visual Studio *Solution Explorer-Fenster* angezeigt werden kann. Eine Lösung kann aus mehreren Projekten bestehen, und ein Projekt kann aus mehreren Dateien bestehen. Eine Lösung ist eine Zusammenfassung der gesamten Arbeitsumgebung (sie hat die Dateierweiterung `.sln` ), während die Ausgabe eines Projekts typischerweise eine Datei `.exe` oder `.dll` ist, d. h. eine Komponente einer komplexen Anwendung/eines komplexen Systems. Projektdateierweiterung für C#-Anwendungen `.csproj`.

Der Inhalt unserer Datei `Program.cs` lautet wie folgt:

```csharp title="Program.cs"
namespace HelloWorld
{
    internal class  Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hallo Welt!");
        }
    }
}
```

Nehmen Sie eine Zeile aus `Console.ReadKey()`: 

```csharp hl_lines="8"
namespace HelloWorld
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hallo Welt!");
            Console.ReadKey();
        }
    }
}
```

1. Führen Sie die Anwendung aus (z. B. mit der Taste ++f5++ ).

    Die Struktur des Codes ist der von Java und C++ sehr ähnlich. Unsere Klassen sind in Namespaces organisiert. Sie können einen Namespace mit dem Schlüsselwort `namespace` definieren. Wir können Namespaces mit dem Schlüsselwort `using` "abdecken". z.B.:

    ```csharp
    using System.Collections.Generic;
    ```

2. In einer C#-Konsolenanwendung geben Sie den Einstiegspunkt Ihrer Anwendung an, indem Sie eine statische Funktion namens `Main` schreiben. Unser Klassenname kann beliebig sein, in unserem Fall hat VS eine Klasse namens `Program` erzeugt. Die Parameterliste der Funktion `Main` ist gebunden: entweder werden keine Parameter angegeben, oder es wird ein `string[]`angegeben, in dem die Befehlszeilenargumente zur Laufzeit angegeben werden.
3. in .NET wird die Klasse `Console` aus dem Namensraum `System` verwendet, um die Standardeingabe und -ausgabe zu verarbeiten. Mit der statischen Aktion `WriteLine` können Sie eine Zeile drucken, mit `ReadKey` können Sie auf das Drücken einer Taste warten.

!!! tip "Top-Level-Anweisungen, implizite und statische Verwendungen und Namespaces"
    Bei der Projekterstellung haben wir zuvor das Kontrollkästchen "Top-Level-Anweisungen nicht verwenden" aktiviert. Hätten wir dies nicht getan, hätten wir in unserer Datei `Program.cs` nur eine einzige Zeile mit Inhalt gefunden:

    ```cs
    // siehe https://aka.ms/new-console-template für weitere Informationen
    Console.WriteLine("Hallo Welt!");
    ```

    Dies ist funktionell äquivalent zu dem obigen Code, der die Klasse "Program" und ihre Funktion "Main" enthält. Schauen wir uns an, was dies möglich macht (Sie können hier mehr darüber lesen <https://docs.microsoft.com/en-us/dotnet/csharp/whats-new/tutorials/top-level-statements>, beide neu in C# 10):

    - **Aussagen der obersten Ebene**. Die Idee ist, dass Sie Code direkt in einer einzigen Quelldatei schreiben können, ohne dass Klassen/`Main` und andere Funktionsdefinitionen im Projekt vorhanden sind. In diesem Fall setzt der Compiler dies hinter den Kulissen in eine statische "Main"-Funktion einer Klasse, die wir nicht sehen. Die Motivation für seine Einführung war die Reduzierung von "Boilerplate"-Code für sehr einfache, "skriptartige" Anwendungen.
    - **Implizite globale Verwendungen**. Je nachdem, welchen Projekttyp Sie erstellt haben, werden bestimmte Basis-Namensräume automatisch im Hintergrund in allen Quelldateien verwendet (der Compiler verwendet dazu die *globale using*-Direktive). Der Punkt ist: Auf diese Weise müssen Entwickler bestimmte häufig verwendete Namespaces (z.B. `System.IO`, `System.Collections.Generic`, etc.) nicht als Quelldateien verwenden.
    - **Statische Verwendung**. Es ist möglich, statische Klassen anstelle von Namespaces in C# zu verwenden, so dass es nicht wichtig ist, sie zu schreiben, wenn sie verwendet werden. Ein häufiger Fall ist die Verwendung der Klasse "Console" oder "Math".

        ```csharp hl_lines="1 9"
        using static System.Console;

        namensraum ConsoleApp12
        {
            internal class Program
            {
                static void Main(string[] args)
                {
                    WriteLine("Hallo, Welt!");
                }
            }
        }
        ```

    - **Namensräume auf Dateiebene**. In C# 10 gibt es auch eine Vereinfachung bei der Deklaration von Namespaces, da es nicht mehr zwingend erforderlich ist, Klammern zu verwenden, so dass der angegebene Namespace für die gesamte Datei gültig ist, z.B:

        ```csharp hl_lines="1"
        namespace HelloWorld;

        internal class Program
        {
            // ...
        }
        ```

!!! Warnung "Fehler bei inkonsistenter Sichtbarkeit oder inkonsistenter Zugänglichkeit"
    Während des Semesters können Sie bei der Durchführung von Programmieraufgaben auf Übersetzungsfehlermeldungen stoßen, die sich über *inkonsistente Sichtbarkeit* oder *inkonsistente Zugänglichkeit* beschweren. Dieses Phänomen ist auf die Möglichkeit zurückzuführen, die Sichtbarkeit der einzelnen Typen (Klassen, Schnittstellen usw.) in einer .NET-Umgebung zu steuern:

    - intern" oder keine Sichtbarkeit angeben: der Typ ist nur intern in der angegebenen Assembly (.exe, .dll)/dem angegebenen Projekt sichtbar
    - öffentlich": der Typ ist für andere Baugruppen/Projekte sichtbar
    
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

Das Material ist hier verfügbar: [Die Beziehung zwischen dem UML-Klassendiagramm und dem Code](../../egyeb/uml-kod-kapcsolata/index_ger.md) Dieses Thema wurde im vorangegangenen Semester in der Vorlesung Softwaretechnik behandelt.

### B) Schnittstelle und abstrakte (übergeordnete) Klasse \[student]\*

Das Material ist hier verfügbar:  [Schnittstelle und abstrakte (angestammte) Klasse](../../egyeb/interfesz-es-absztrakt-os/index_ger.md).

Themen:

- Konzept und Definition abstrakter Klassen in C#
- Schnittstellenkonzepte und -definitionen in C#
- Vergleich von abstraktem Vorfahren und Schnittstelle

## 2. Aufgabe - Veranschaulichen Sie die Beziehung zwischen UML und Code

### Aufgabenbeschreibung - Inventarisierung der Ausrüstung

Aufgabe: Wir wurden gebeten, eine Anwendung zur Inventarisierung von Computerteilen zu entwickeln. Lesen Sie mehr:

- Sie müssen in der Lage sein, verschiedene Arten von Teilen zu bearbeiten. Anfänglich sollten die Typen `HardDisk`, `SoundCard` und `LedDisplay` unterstützt werden, aber das System sollte leicht auf neue Typen erweiterbar sein.
- Daten zu den Teilen: Anschaffungsjahr, Alter (berechnet), Anschaffungspreis und aktueller Preis (berechnet), kann aber auch typspezifische Daten enthalten (z. B. Kapazität für `HardDisk` ).
- Der tatsächliche Preis hängt von der Art des Teils, dem Einkaufspreis und dem Produktionsjahr des Teils ab. Je älter das Teil ist, desto höher ist der Preisnachlass, aber der Preisnachlass hängt von der Art des Teils ab.
- Sie müssen in der Lage sein, die vorrätigen Teile aufzulisten.
- Die Klasse `LedDisplay` muss von einer Klasse `DisplayBase` abgeleitet sein, und der Quellcode der Klasse `DisplayBase` darf nicht verändert werden. In diesem Beispiel macht dies nicht viel Sinn, aber in der Praxis treffen wir oft auf ähnliche Situationen, in denen das von uns verwendete Framework/die Plattform verlangt, dass wir von einer eingebauten Klasse ableiten. Typischerweise ist dies der Fall, wenn wir mit Fenstern, Formularen oder benutzerdefinierten Steuerelementen arbeiten: Wir müssen sie von den eingebauten Klassen des Frameworks ableiten, und wir haben den Quellcode des Frameworks nicht (oder wollen ihn zumindest nicht ändern) - z.B. Java, .NET. In unserem Beispiel simulieren wir diese Situation, indem wir eine Ableitung von `DisplayBase`verlangen.

Die Implementierung ist erheblich vereinfacht: Die Teile werden nur im Speicher abgelegt, und die Auflistung ist so einfach wie möglich, indem einfach die Daten der registrierten Teile in die Konsole geschrieben werden.

Bei den ersten Gesprächen erhalten wir vom Kunden folgende Information: Ein interner Mitarbeiter hat bereits mit der Entwicklung begonnen, ist aber aus Zeitmangel nur zu einer halbfertigen Lösung gekommen. Ein Teil unserer Aufgabe besteht darin, die halbfertige Lösung zu verstehen und die Aufgabe von dort aus umzusetzen.

### Klassendiagramm

Öffnen wir die Quellcode-Lösung unseres Kunden [source code](https://github.com/bmeviauab00/lab-modellkod-kiindulo), indem wir die nachstehenden Schritte ausführen.

Dazu klonen Sie das Git-Repository des ursprünglichen Projekts, das online auf GitHub verfügbar ist, in einen eigenen Ordner innerhalb des Ordners `C:\Work`: z. B.: `C:\Work\NEPTUN\lab1`. Öffnen Sie in diesem neuen Ordner eine Befehlszeile oder Powershell und führen Sie den folgenden git-Befehl aus:

```cmd
git clone https://github.com/bmeviauab00/lab-modellkod-kiindulo.git
```

!!! Hinweis "Git und GitHub"
    Sie werden mehr über Git als Quellcode-Verwaltungssystem im Rahmen der ersten Hausaufgabe erfahren.

Öffnen Sie die Visual Studio-Lösung src/EquipmentInventory.sln im geklonten Ordner.

Gehen Sie im Solution Explorer die Dateien nach Augenmaß durch. Es wäre hilfreich, die Beziehungen zwischen den Klassen in einem Klassendiagramm darzustellen, um sie zu verstehen. Wir wollen ein Klassendiagramm in unser Projekt einfügen. Klicken Sie im Projektmappen-Explorer mit der rechten Maustaste auf das **Projekt** (nicht auf die Projektmappe!), wählen Sie im Popup-Menü die Option *Hinzufügen/Neues Element*, wählen Sie im daraufhin angezeigten Fenster die Option Klassendiagramm, geben Sie unten im Fenster den Namen Main.cd als Diagramm ein, und schließen Sie das Fenster mit OK.

!!! Warnung "Fehlende Klassendiagramm-Vorlage" Wenn das Element *Klassendiagramm* nicht in der Liste erscheint, ist die entsprechende Komponente von VS nicht installiert. Weitere Informationen hierzu finden Sie im Abschnitt Voraussetzungen in diesem Dokument.

Die Diagrammdatei `Main.cd` wird dann im Projektmappen-Explorer angezeigt. Doppelklicken Sie darauf, um sie zu öffnen. Unsere Karte ist derzeit leer. Ziehen Sie im Projektmappen-Explorer\&die .cs-Quelldateien auf das Diagramm. VS prüft dann, welche Klassen in diesen Quelldateien enthalten sind, und zerlegt sie in UML-Klassen. Erstellen Sie das Layout wie in der folgenden Abbildung gezeigt (Sie können die Mitglieder der Klassen anzeigen, indem Sie auf den Doppelpfeil in der oberen rechten Ecke ihres Rechtecks klicken):

![Beginnendes Klassendiagramm](images/class-diagram-initial.png)

Sie können auch den Quellcode für die Klassen anzeigen, indem Sie entweder auf die entsprechende Klasse im Diagramm doppelklicken oder die .cs-Dateien im Projektmappen-Explorer öffnen. Wir haben folgende Erfahrungen gemacht:

- Die Klassen `SoundCard`, `HardDisk` und `LedDisplay` sind relativ gut entwickelt und verfügen über die notwendigen Attribute und Abfragefunktionen.
-  `LedDisplay` wird bei Bedarf von `DisplayBase` abgeleitet.
- Obwohl `EquipmentInventory` für die Bestandsaufnahme der auf Lager befindlichen Teile zuständig ist, wird praktisch nichts davon umgesetzt.
- Wir finden eine Schnittstelle `IEquipment`, mit `GetAge` und `GetPrice` Operationen

### AusrüstungInventar

Lassen Sie uns an einer Lösung arbeiten. Lassen Sie uns zunächst die grundlegenden Konzepte erläutern. In der Klasse `EquipmentInventory` speichern wir eine heterogene Sammlung verschiedener Teiletypen. Dies ist der Schlüssel zu einer konsistenten Teileverwaltung, so dass unsere Lösung problemlos um neue Teiletypen erweitert werden kann.

Wie bereits erwähnt, kann eine einheitliche Verwaltung entweder durch die Implementierung einer gemeinsamen Vorläuferklasse oder einer gemeinsamen Schnittstelle erreicht werden. In unserem Fall scheint die gemeinsame Vorgängerklasse (z. B. `EquipmentBase`) eliminiert zu werden, denn durch ihre Einführung hätte die Klasse `LedDisplay` zwei Vorgängerklassen: `DisplayBase`, die obligatorisch ist, und `EquipmentBase`, die wir zur einheitlichen Verwaltung einführen. Dies ist nicht möglich, in einer .NET-Umgebung kann eine Klasse nur einen Vorgänger haben. Die Lösung, `DisplayBase`so zu ändern, dass es von `EquipmentBase`stammt, ist nach unseren Anforderungen nicht möglich (es war eine Anforderung, dass der Quellcode nicht geändert werden durfte). Es bleibt also der schnittstellenbasierte Ansatz. Dies ist sicherlich die Schlussfolgerung des vorherigen Entwicklers der Anwendung, weshalb er die Schnittstelle `IEquipment` eingeführt hat.

Fügen Sie eine generische Liste von Elementen des Typs `IEquipment` (keine Eigenschaft, sondern ein Feld\!) zur Klasse `EquipmentInventory` hinzu. Ihre Sichtbarkeit sollte - in dem Bemühen um Integration - `private`sein. Der Name sollte `equipment` lauten (ohne "s" am Ende, im Englischen ist der Plural von equipment auch equipment). Um eine Member-Variable hinzuzufügen, verwenden wir das Fenster Visual Studio *Class Details*. Wenn das Fenster nicht sichtbar ist, kann es durch Auswahl von *Ansicht / Andere Fenster / Klassendetails* angezeigt werden.

![Details zur Klasse](images/class-details.png)

Der Typ der Mitgliedsvariablen ist `List<IEquipment>`. Der .NET-Typ `List` ist ein dynamisch dehnbares generisches Array (wie `ArrayList`in Java). Betrachtet man die Klasse `EquipmentInventory` im Diagramm, so sieht man, dass nur der Name der Mitgliedsvariablen angezeigt wird, nicht aber der Typ. Klicken Sie mit der rechten Maustaste auf den Hintergrund des Diagramms und wählen Sie im Menü *Mitgliederformat ändern* die Option *Vollständige Signatur anzeigen*. Das Diagramm zeigt dann den Typ der Mitgliedsvariablen und die vollständige Signatur der Operationen.

![AusrüstungInventar](images/equipmentinventory.png)

Wenn Sie auf die Klasse `EquipmentInventory` doppelklicken, können Sie zum Quellcode navigieren, und wie Sie sehen können, erscheint sie im Code tatsächlich als Mitgliedsvariable vom Typ Liste:

```csharp hl_lines="3"
class EquipmentInventory
{
    private List<IEquipment> equipment;
```

Einerseits freuen wir uns darüber, weil Visual Studio Round-Trip-Engineering unterstützt: **Änderungen am Modell spiegeln sich sofort im Code wider und umgekehrt**. Andererseits haben wir bereits erörtert, dass eine Klasse, die eine Sammlung von Mitgliedern einer anderen Klasse hat, in das UML-Modell als eine Assoziationsbeziehung vom Typ 1-more zwischen den beiden Klassen "passt". Dies ist in unserem Modell noch nicht der Fall. Glücklicherweise kann die VS-Modellierungsschnittstelle dazu gebracht werden, diese Art von Verbindung in dieser Form anzuzeigen. Klicken Sie dazu im Diagramm mit der rechten Maustaste auf die Variable Equipment-Tag und wählen Sie im Menü die Option *Als Sammelassoziation anzeigen* aus. Die Schnittstelle `IEquipment` sollte dann nach rechts verschoben werden, damit im Diagramm genügend Platz für die Darstellung der Assoziationsverbindung und der Rolle der Verbindung bleibt:

![Sammlungsverband](images/collection-association.png)

Der Doppelpfeil, der auf der "Plural"-Seite endet, entspricht nicht dem UML-Standard, aber seien Sie nicht zu traurig darüber, es ist nicht wichtig. Wir sind sehr erfreut, dass der Pfeil, der den Link am Ende von `IEquipment` darstellt, den Namen (und sogar den genauen Typ) der Mitgliedsvariablen in der Rolle anzeigt.

Navigieren Sie zum Quellcode von `EquipmentInventory` und schreiben Sie den Konstruktor, der die Sammlung `equipment` initialisiert\!

```csharp
public EquipmentInventory()
{
    equipment = new List<IEquipment>();
}
```

Schreiben Sie dann die Methode `ListAll`, die das Alter der Elemente und ihren aktuellen Wert ausgibt:

```csharp
public void ListAll()
{
    foreach (IEquipment eq in equipment)
    {
        Console.WriteLine($"Alter: {eq.GetAge()}\tÉrtéke: {eq.GetPrice()}");
    }
}
```

Mit dem Befehl `foreach` durchlaufen Sie die Elemente. Bei der Verwendung der Richtlinie `foreach` sollte `in` von einer Sammlung gefolgt werden, und `in` sollte eine Variablendeklaration vorangestellt werden (in diesem Fall `IEquipment eq`), wobei type der Elementtyp der Sammlung ist. Bei jeder Iteration nimmt diese Variable den Iterationswert der Sammlung an.

Der Operation `Console.WriteLine` wird entweder eine einfache Zeichenfolge oder, wie in unserem Fall, eine Formatierungszeichenfolge übergeben. Die Ersetzungen werden durch String-Interpolation gelöst: Die zu ersetzenden Werte müssen zwischen `{}` angegeben werden. Bei der String-Interpolation muss der String mit `$` beginnen.

Schreiben Sie eine Funktion mit der Bezeichnung `AddEquipment`, die ein neues Gerät zu der Menge hinzufügt:

```csharp
public void AddEquipment(IEquipment eq)
{
     equipment.Add(eq);
}
```

### IEquipment von Ausrüstungen

Wir haben beschlossen, die Schnittstelle `IEquipment` zu verwenden, um die verschiedenen Komponententypen einheitlich zu verwalten. In unserem Fall haben sowohl die Klassen `SoundCard` als auch `HardDisk` die Methoden `GetAge()` und `GetPrice()`, aber wir können sie nicht einheitlich verwalten (z. B. in einer gemeinsamen Liste speichern). Zu diesem Zweck müssen wir beide Klassen dazu bringen, die Schnittstelle `IEquipment` zu implementieren. Ändern Sie ihre Quelle:

```csharp
public class SoundCard : IEquipment
```

```csharp
public class HardDisk : IEquipment
```

Dann müssen wir die Methoden der Schnittstelle `IEquipment` in den Klassen `SoundCard` und `HardDisk` implementieren. Wir stellen fest, dass es damit nichts mehr zu tun gibt, die Funktionen `GetPrice` und `GetAge` sind bereits an beiden Stellen geschrieben.

Erstellen Sie testweise ein Objekt `EquipmentInventory` in unserer Funktion `Main` in `Program.cs`, füllen Sie es mit den Objekten `HardDisk` und `SoundCard` und listen Sie das Objekt dann in der Konsole auf. Wenn 2021 nicht das aktuelle Jahr ist, kopieren Sie in den folgenden Zeilen das Jahr 2021 in das aktuelle Jahr und das Jahr 2020 in eine kleinere Zahl\!

```csharp
static void Main( string[] args )
{
    EquipmentInventory ei = new EquipmentInventory();

    ei.AddEquipment(new HardDisk(2021, 30000, 80));
    ei.AddEquipment(new HardDisk(2020, 25000, 120));
    ei.AddEquipment(new HardDisk(2020, 25000, 250));

    ei.AddEquipment(new SoundCard(2021, 8000));
    ei.AddEquipment(new SoundCard(2020, 7000));
    ei.AddEquipment(new SoundCard(2020, 6000));

    ei.ListAll();
}
```

Wenn wir die Anwendung ausführen, stellen wir fest, dass unsere Lösung zwar rudimentär ist, aber funktioniert:

![Ausgabe auf der Konsole](images/console-out-1.png)

Arbeiten Sie weiter mit der Klasse `LedDisplay`.  Der Quellcode von `DisplayBase` kann aufgrund der Anforderungen nicht geändert werden. Aber das ist kein Problem, unsere Klasse `LedDisplay` wird die Schnittstelle `IEquipment` implementieren, lassen Sie uns den Code entsprechend ändern:

```csharp
public class LedDisplay : DisplayBase, IEquipment
```

In der Klasse `LedDisplay` müssen die Funktionen der Schnittstelle bereits geschrieben sein:

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

Erweitern wir unsere Funktion `Main`, fügen wir zwei `LedDisplay` Objekte zu unserer Menge hinzu (auch hier gilt: Wenn 2021 nicht das aktuelle Jahr ist, sollten wir in den folgenden Zeilen 2021 in das aktuelle Jahr und 2020 in eine kleinere Zahl schreiben\!

```csharp hl_lines="1 2"
ei.AddEquipment(new LedDisplay(2020, 80000, 17, 16));
ei.AddEquipment(new LedDisplay (2021, 70000, 17, 12));
        
ei.ListAll();
Console.ReadKey();
```

Führen Sie die Anwendung testweise aus.

## 3. Aufgabe - Anwendung der Schnittstelle und der abstrakten primitiven Klasse

### Schnittstellenprobleme

Bewerten Sie unsere aktuelle schnittstellenbasierte Lösung.

Eines der Hauptprobleme ist, dass unser Code voller Code-Duplikationen ist, die die Wartbarkeit und Erweiterbarkeit zerstören:

- Die Tags `yearOfCreation` und `newPrice` gelten für alle Komponententypen (mit Ausnahme des speziellen `LedDisplay`) und müssen eingefügt werden, wenn ein neuer Typ eingeführt wird.
- Die Implementierungsebene der Funktion `GetAge` ist für alle Komponententypen (mit Ausnahme der speziellen `LedDisplay`) gleich, auch Copy-Paste wird "propagiert".
- Die Zeilen in den Konstruktoren, die die Mitglieder `yearOfCreation` und `newPrice` initialisieren, werden ebenfalls in jeder Klasse dupliziert.

Auch wenn diese Codeduplizierung im Moment noch unbedeutend zu sein scheint, wird die Situation mit der Einführung neuer Komponententypen immer schlimmer, und es ist besser, künftigen Problemen rechtzeitig vorzubeugen.

Ein weiteres Problem besteht darin, dass die Auflistung der Teiledaten derzeit schmerzlich unvollständig ist, da es keine Teileart gibt (nur Alter und Preis). Um den Typ anzuzeigen, muss die Schnittstelle IEquipment erweitert werden, z. B. durch Einführung einer Operation namens `GetDescription`.   Fügen wir der Schnittstelle eine Funktion `GetDescription` hinzu\!

```csharp hl_lines="5"
public interface IEquipment
{
    double GetPrice();
    int GetAge();
    string GetDescription();
}
```

Dann müsste jede Klasse, die die Schnittstelle `IEquipment` implementiert, diese Methode implementieren, was für viele Klassen eine Menge Arbeit bedeutet (und für eine Mehrkomponenten-Anwendung, d.h. eine Anwendung, die aus mehreren DLLs besteht, oft gar nicht machbar ist, wenn sie nicht in den Händen eines einzigen Entwicklers liegen). Führen Sie den Befehl *Build* aus, um zu überprüfen, ob Sie nach dem Hinzufügen von `GetDescription` an drei Stellen Übersetzungsfehler erhalten.

tipp "Standardimplementierung in der Schnittstelle festlegen" Es ist wichtig zu wissen, dass ab C# 8 (oder .NET oder .NET Core Runtime, nicht unterstützt unter .NET Framework) **Schnittstellenoperationen eine Standardimplementierung erhalten können (Standardschnittstellenmethoden), so dass Sie zur Lösung des obigen Problems keine abstrakte Klasse benötigen, aber die Schnittstelle kann keine Mitgliedsvariablen mehr haben**. Weitere Informationen finden Sie hier: Standardschnittstellenmethoden.

    ```csharp hl_lines="5"
    public interface IEquipment
    {
        double GetPrice();
        int GetAge();
        string GetDescription() { return "EquipmentBase"; }
    }
    ```

### Abstrakte Klasse

Eine Lösung für beide Probleme ist die Einführung eines gemeinsamen abstrakten Vorgängers (mit Ausnahme der Klasse `LedDisplay`, auf die wir noch zurückkommen werden). Wir können den Code, der allen Nachkommen gemeinsam ist, dorthin verschieben und eine Standardimplementierung für die neu eingeführte Operation `GetDescription` bereitstellen. Nennen wir unsere neue abstrakte Meisterklasse `EquipmentBase`. Die Frage ist, ob die Schnittstelle `IEquipment` noch benötigt wird oder ob sie vollständig durch die neue Klasse `EquipmentBase` ersetzt werden kann. Wir müssen die Schnittstelle `IEquipment` beibehalten, weil wir unsere Klasse LedDisplay nicht von `EquipmentBase`ableiten können: Sie hat bereits eine obligatorische Vorgängerklasse, `DisplayBase`: Deshalb bezieht sich EquipmentInventory in unserer erweiterten Lösung auf die verschiedenen Komponenten als Schnittstelle `IEquipment`. 

Beginnen wir mit der Umwandlung. Unser Klassendiagramm soll die aktive Registerkarte sein. Ziehen Sie *aus der Toolbox\&*ein Element *Abstrakte Klasse* auf das Diagramm und benennen Sie es `EquipmentBase`.

![Toolbox - abstrakte Klasse](images/toolbox-abstract-class.png)

Im Folgenden müssen wir die Klassen `SoundCard` und `HardDisk` von `EquipmentBase`ableiten ( `LedDisplay`hat bereits einen anderen Vorfahren, so dass wir dies dort nicht tun können). Wählen Sie dazu die Verknüpfung *Vererbung* in der *Toolbox* und ziehen Sie dann eine Linie von der untergeordneten Klasse zur Vorgängerklasse sowohl für `SoundCard` als auch für `HardDisk`. 

Im nächsten Schritt ändern wir den Code so, dass `HardDisk` und `SoundCard` die Schnittstelle `IEquipment` nicht separat implementieren, sondern ihr gemeinsamer Vorfahre `EquipmentBase` dies tut. Ändern Sie dazu die Klasse EquipmentBase so, dass sie die Schnittstelle implementiert (entweder durch Einfügen eines Vererbungslinks von `EquipmentBase`zu `IEquipment`im Diagramm oder durch Ändern des Quellcodes von `EquipmentBase` ). Entfernen Sie die Implementierung von `IEquipment` aus den Klassen `HardDisk` und `SoundCard` (der Vorgänger implementiert sie bereits).

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

Unser Code ist aus mehreren Gründen noch nicht in Betrieb.  `EquipmentBase` implementiert die Schnittstelle `IEquipment`, aber sie implementiert noch nicht die Operationen der Schnittstelle. Erzeugen Sie die Methoden entweder mit Hilfe des Smarttags oder geben Sie sie nach den folgenden Grundsätzen ein:

- Die Klassen `newPrice` und `yearOfCreation` sind in den Klassen `HardDisk` und `SoundCard` dupliziert: verschieben (nicht kopieren\!) Sie sie in den gemeinsamen Vorfahren `EquipmentBase` und geben Sie `protected` Sichtbarkeit.
- Die Operation `GetAge` wird in den Klassen `HardDisk` und `SoundCard` dupliziert, löschen Sie die Implementierung aus diesen Klassen und verschieben Sie sie in die Klasse `EquipmentBase`. 
- Die Operation `GetPrice` wird als abstrakte Operation in den Vorgänger aufgenommen. Dies ist eine bewusste Design-Entscheidung, so dass wir nachkommende Klassen zwingen, diesen Vorgang trotzdem zu überschreiben.
- Für `GetDescription` gilt das Gegenteil: Wir definieren es als virtuell (und nicht abstrakt), d. h. wir geben eine Implementierung im Vorgänger an. Auf diese Weise sind die Nachkommen nicht gezwungen, den Vorgang außer Kraft zu setzen.

Der entsprechende Code lautet:

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
        rückgabe "EquipmentBase";
    }
}
```

!!! tip "Einige zusätzliche Gedanken zum Codefragment:"

    - Bei abstrakten Klassen muss das Schlüsselwort "abstrakt" vor das Wort "Klasse" geschrieben werden.
    - Für abstrakte Operationen muss das Schlüsselwort `abstract` angegeben werden
    - in einer .NET-Umgebung können Sie steuern, ob ein Vorgang virtuell ist oder nicht. In dieser Hinsicht ist es ähnlich wie C++. Wenn Sie eine Operation virtuell machen wollen, müssen Sie das Schlüsselwort `virtual` für die Operation angeben. Zur Erinnerung: Definieren Sie eine Operation als virtuell, wenn ihre Nachkommen sie überdefinieren. Nur dann ist gewährleistet, dass die Nachfolgeversion aufgerufen wird, wenn die angegebene Operation auf einen Vorgängerverweis angewendet wird.

### Nachkommenschaft

Im nächsten Schritt gehen wir zu `EquipmentBase` descendants über. Wenn in C# abstrakte und virtuelle Operationen überschrieben werden, muss das Schlüsselwort `override` im Nachfahren angegeben werden. Zunächst wird der Vorgang `GetPrice` neu definiert:

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

Man könnte sich fragen, warum die Entwickler der Sprache C# beschlossen haben, der Definition von Operationen ein zusätzliches Schlüsselwort hinzuzufügen, was im Fall von C++ nicht notwendig war. Der Grund dafür ist einfach: Der Code ist aussagekräftiger. Wenn man sich den Code der Nachkommen ansieht, macht das Wort `override` sofort klar, ob diese Operation in einem der Vorfahren abstrakt oder virtuell ist, ohne dass man sich den Code aller Vorfahren ansehen muss.

### Vorfahre von LedDisplay

Unsere Vorgängerklasse `LedDisplay` ist gebunden, ihr Code kann nicht geändert werden, daher können wir sie nicht von `EquipmentBase`ableiten. Wir können den Vorgang `GetAge` nicht löschen, diese Code-Duplizierung bleibt hier erhalten (aber nur für `LedDisplay`, die nur eine Klasse unter vielen ist\!).

!!! note
    Mit ein wenig zusätzlicher Arbeit könnten wir diese Doppelung beseitigen. Dazu müsste eine statische Hilfsfunktion in eine der Klassen aufgenommen werden (z. B. `EquipmentBase`) , die das Produktionsjahr ermittelt und das Alter zurückgibt.  `EquipmentBase.GetAge` und `LedDisplay.GetAge` würden diese Hilfsfunktion für ihre Ausgabe verwenden.

    In unserer Klasse `LedDisplay` müssen wir noch `GetDescription` schreiben:

```csharp title="LedDisplay.cs"
public string GetDescription()
{
    return "Led Display";
}
```

Beachten Sie, dass das Schlüsselwort `override` hier NICHT angegeben ist. Wenn eine Schnittstellenfunktion implementiert ist, muss/kann `override`nicht gedruckt werden.

### GetDescription verwenden

Ändern Sie die Operation `EquipmentInventory.ListAll`, um auch die Beschreibung der Elemente in die Ausgabe zu schreiben:

```csharp title="EquipmentInventory.cs"
public void ListAll()
{
    foreach (IEquipment eq in equipment)
    {
        Console.WriteLine("$Description: {eq.GetDescription()}\t" +
            $"Alter: {eq.GetAge()}\tValue: {eq.GetPrice()}");
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

Wenn Sie darüber nachdenken, werden diese `yearOfCreation` und `newPrice` Mitglieder im Vorfahren definiert, also sollte es seine Verantwortung sein, sie zu initialisieren. Fügen wir einen entsprechenden Konstruktor in `EquipmentBase`hinzu:

```csharp title="EquipmentBase.cs"
public EquipmentBase(int Erstellungsjahr, int neuerPreis)
{
    this.yearOfCreation = yearOfCreation;
    this.newPrice = newPrice;
}
```

Entfernen Sie die Initialisierung der beiden Mitglieder aus dem Konstruktor der Nachfahren `HardDisk` und `SoundCard` und rufen Sie stattdessen den Konstruktor des Vorfahren auf, indem Sie auf das Schlüsselwort `base` verweisen:

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

Durch die Verwendung einer Kombination aus Schnittstelle und abstraktem Vorgänger ist es uns gelungen, die Lösung mit dem geringsten Kompromiss zu entwickeln:

- `IEquipment` als Schnittstelle können wir alle Arten von Teilen einheitlich behandeln, auch solche, bei denen die Vorgängerklasse gebunden war (mit abstrakten Vorgängern allein hätten wir dies nicht erreichen können).
- Durch die Einführung des abstrakten Vorfahren `EquipmentBase` konnten wir den Code, der verschiedenen Komponententypen gemeinsam ist, mit einer Ausnahme in einen gemeinsamen Vorfahren bringen und so Code-Duplikationen vermeiden.
- Durch die Einführung des abstrakten Vorgängers `EquipmentBase` können wir eine Standardimplementierung für neu eingeführte `IEquipment` Operationen (z.B. `GetDescripton`) angeben, so dass wir nicht gezwungen sind, diese in jeder `IEquipment` Implementierungsklasse anzugeben.

Werfen wir abschließend noch einen Blick auf das UML-Klassendiagramm unserer Lösung:

![Ultimatives Klassendiagramm](images/class-diagram-final.png)

!!! note "C# 11 - Statische Schnittstellen"
    Die neueste Funktion von C# 11 ist die Definition von statischen Schnittstellenmitgliedern, die es Ihnen ermöglicht, von einer implementierenden Klasse zu verlangen, dass sie Mitglieder hat, die sich nicht auf die Objektinstanz beziehen, sondern die Klasse muss über ein bestimmtes statisches Mitglied verfügen. Mehr lesen

### Hinweis - fakultative Hausaufgabe

Unsere Lösung unterstützt nicht die Anzeige von komponentenspezifischen Daten (z.B. Kapazität für `HardDisk` ) während der Auflistung. Zu diesem Zweck sollte das Schreiben von Komponentendaten in eine formatierte Zeichenkette von der Klasse `EqipmentInventory` in die Komponentenklassen verlagert werden, und zwar nach den folgenden Grundsätzen:

- Sie können eine `GetFormattedString` Operation in die `IEquipment` Schnittstelle einführen, die ein Objekt vom Typ `string` zurückgibt. Alternativ kann die Operation `System.Object ToString()` außer Kraft gesetzt werden. in .NET sind alle Typen implizit von `System.Object`abgeleitet, das über eine virtuelle Operation `ToString()` verfügt.
- In `EquipmentBase`schreiben wir die Formatierung der üblichen Tags (Beschreibung, Preis, Alter) in Strings.
- Wenn eine Komponente auch typspezifische Daten hat, dann überschreibt ihre Klasse die Funktion, die sie in eine Zeichenkette formatiert: Diese Funktion muss zuerst ihren Vorgänger aufrufen (mit dem Schlüsselwort `base` ), dann ihre eigenen formatierten Daten an sie anhängen und mit dieser Zeichenkette zurückkehren.
