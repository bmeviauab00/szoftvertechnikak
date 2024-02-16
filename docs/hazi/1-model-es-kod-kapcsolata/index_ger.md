---
suche:
  ausschließen: wahr
Autoren: bzolka
---

# 1. HF - Beziehung zwischen Modell und Code

## Einführung

Die Übung ist nicht mit einer Präsentation verbunden.  Den theoretischen und praktischen Hintergrund für die Übungen liefert das Kapitel "1. Die Beziehung zwischen Modell und Code" wird als angeleitete Laborübung dienen:

- Diese Laborübung wird von den Studierenden unter Anleitung des Tutors gemeinsam durchgeführt.
- Die Laborübung wird von einem Leitfaden begleitet, der einen detaillierten theoretischen Hintergrund und eine Schritt-für-Schritt-Anleitung für die Herstellung einer Lösung enthält: [1. Beziehung zwischen dem Modell und dem Code](../../labor/1-model-es-kod-kapcsolata/index_ger.md)

Darauf aufbauend können die Aufgaben dieser Selbstübung mit Hilfe der kürzeren Leitfäden, die der Aufgabenbeschreibung folgen, durchgeführt werden.

Das Ziel der unabhängigen Übung:

- Erstellen einer einfachen .NET-Anwendung, Üben der C#-Grundlagen
- Veranschaulichung der Beziehung zwischen UML und Code
- Praktische Anwendung der Schnittstelle und der abstrakten primitiven Klasse

Die erforderliche Entwicklungsumgebung wird [hier](../fejlesztokornyezet/index_ger.md) beschrieben.

## Laden Sie den Ausgangsrahmen herunter, laden Sie die fertige Lösung hoch

Die ursprüngliche Hausaufgabenumgebung wird veröffentlicht und die Lösung wird über Git, GitHub und GitHub Classroom eingereicht. Die wichtigsten Schritte:

1. Erstellen Sie mit GitHub Classroom ein Repository für sich selbst. Sie finden die Einladungs-URL in Moodle (Sie können sie sehen, indem Sie auf den Link*"GitHub classroom links for homework*" auf der Startseite des Fachs klicken).
2. Klonen Sie das resultierende Repository. Dazu gehört auch die erwartete Struktur der Lösung.
3. Nachdem Sie die Aufgaben erledigt haben, übergeben Sie Ihre Lösung alt und drücken Sie sie alt.

Diese werden hier ausführlicher beschrieben:

- [Git, GitHub, GitHub Classroom](../git-github-github-classroom/index.md)
- [Arbeitsablauf bei Hausaufgaben und Verwendung von Git/GitHub](../hf-folyamat/index.md)

## Vorabkontrolle und formale Bewertung der Hausaufgaben

Jedes Mal, wenn Sie Code auf GitHub hochladen, führt GitHub automatisch eine (Vor-)Prüfung des hochgeladenen Codes durch und Sie können das Ergebnis sehen! Weitere Informationen dazu finden Sie hier (lesen Sie sie unbedingt): [Vorabkontrolle und formale Bewertung der Hausaufgaben](../eloellenorzes-ertekeles/index.md).

## Aufgabe 1 - Erstellen einer einfachen .NET-Konsolenanwendung

### Ursprüngliches Projekt

Die anfängliche Umgebung befindet sich im Ordner `Feladat1`, öffnen Sie die Datei `MusicApp.sln` in Visual Studio und arbeiten Sie in dieser Lösung.

!!! warning "Achtung!"
    Das Erstellen einer neuen Projektmappe und/oder Projektdatei oder die Ausrichtung des Projekts auf andere/neuere .NET-Versionen ist verboten.

Im Ordner `Feladat1\Input` befindet sich eine Datei `music.txt`, die als Eingabe für die Aufgabe verwendet werden soll.

### Verfasst am

In einem Textstring speichern wir die Titel der Lieder von Komponisten/Interpreten/Ensembles im folgenden Format.

- Jeder Autor hat eine eigene Zeile.
- Jede Zeile beginnt mit dem Namen des Autors, gefolgt von `;`, gefolgt von den Titeln der Nummern, getrennt durch `;`.
- Der Inhalt der Datei wird als gültig angesehen, wenn Leerzeilen oder Zeilen, die nur Leerzeichen (Leerzeichen, Tabulator) enthalten, vorhanden sind.

Der Inhalt der beigefügten Datei music.txt ist ähnlich wie der folgende:

```csv
Adele; Hello; Rolling in the Deep; Skyfall
Ennio Morricone;	A Fistful Of Dollars; Mann mit der Mundharmonika
AC/DC; Thunderstruck; T.N.T
```

Lesen Sie die Datei in die Liste der Klassenobjekte `Song`.  Ein Objekt `Song` speichert die Daten (Autor und Titel) eines Liedes. Nach dem Scannen schreiben Sie die formatierten Daten der Objekte in folgendem Format auf die Standardausgabe:

```text
autor1: Autor1_Titel1
autor1: Autor1_Titel2
...
autor2: Autor2_Songtitel1
...
usw.
```

Für unsere Beispieldatei möchten wir die folgende Ausgabe sehen (die je nach Inhalt der Datei variieren kann):

![Ergebnis auf der Konsole](images/music-store-console.png)

### Schritte der Umsetzung

Fügen Sie dem Projekt eine Klasse mit dem Namen `Song` hinzu (Rechtsklick auf das Projekt im Solution Explorer, Menü *Hinzufügen / Klasse*).

Fügen Sie die erforderlichen Mitglieder und einen passenden Konstruktor ein:

```csharp
public class Song
{
    public readonly string Artist;
    public readonly string Title;

    public Song(string artist, string title)
    {
        Artist = artist;
        Title = title;
    }
}
```

!!! note "Property"
    Die Mitgliedsvariablen wurden als `readonly`eingefügt, weil wir nicht wollten, dass sie nach Ausführung des Konstruktors geändert werden können. Eine Alternative wäre die Verwendung von schreibgeschützten Eigenschaften anstelle von schreibgeschützten Mitgliedsvariablen (dies ist ein späterer Kern).

Im Folgenden werden wir die Operation `ToString`, die vom impliziten Vorfahren `System.Object` geerbt wurde, in unserer Klasse `Song` umdefinieren, um Objektdaten in der gewünschten Form zurückzugeben. Verwenden Sie die String-Interpolation in der Lösung (wir haben dies bereits in der ersten Übung verwendet):

```csharp
public override string ToString()
{
    return $"{Artist}: {Title}";
}
```

Die geeignetste Klasse zur Verarbeitung einer Textdatei ist [`StreamReader`](https://learn.microsoft.com/en-us/dotnet/api/system.io.streamreader) im Namensraum `System.IO`. 

In unserer Funktion `Main` lesen wir die Datei Zeile für Zeile ein, erstellen die `Song` Objekte und legen sie in ein `List<Song>` dynamisch dehnbares Array. Bitte beachten Sie, dass in der Datei vor/nach den durch `;`getrennten Elementen Leerzeichen (Space, Tab) stehen können, entfernen Sie diese!

Der folgende Code zeigt eine mögliche Lösung, deren Einzelheiten in den Codekommentaren erläutert werden. Dies ist die erste eigenständige Aufgabe des Semesters und für die meisten Studenten die erste Anwendung von .NET/C#, daher geben wir Ihnen eine Musterlösung, aber erfahrenere Studenten können es auch selbst versuchen.

??? Beispiel "Lösung"

    ```csharp
    namespace MusicApp;

    public class Program
    {
        // Die Funktion Main befindet sich innerhalb der Klasse Program, die hier nicht gezeigt wird
        public static void Main(string[] args)
        {
            // Hier werden die Liedobjekte gespeichert
            Liste<Song> songs = new List<Song>();

            // Datei zeilenweise durchsuchen, Liederliste hochladen
            StreamReader sr = null;
            try
            {
                // @ steht für @ vor der Zeichenkettenkonstante:
                // Deaktiviert String Escape,
                // damit Sie nicht '\\' statt '\\' schreiben müssen.
                sr = new StreamReader(@"C:\temp\music.txt");
                string line;
                while ((line = sr.ReadLine()) != null)
                {
                    // Wenn die Warteschlange leer war
                    if (string.IsNullOrWhiteSpace(line))
                        continue;

                    // Die Zeilenvariable enthält die gesamte Zeile,
                    // geteilt entlang der ;- mit Split
                    string[] lineItems = line.Split(';');

                    // Erstes Element, in dem wir den Namen des Autors erwarten
                    // Trim entfernt führende und nachfolgende Weißraumzeichen
                    string artist = lineItems[0].Trim();

                    // Gehen Sie die Lieder durch und fügen Sie sie der Liste hinzu
                    for (int i = 1; i < lineItems.Length; i++)
                    {
                        Song song = new Song(artist, lineItems[i].Trim());
                        songs.Add(song);
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Die Datei konnte nicht verarbeitet werden.");
                // e.Message enthält nur den Text der Ausnahme. 
                // Wenn Sie alle Ausnahmeinformationen (z.B. Stacktrace) ausgeben möchten, 
                // dann wird e.ToString() gedruckt.
                Console.WriteLine(e.Message);
            }
            finally
            {
                // Es ist wichtig, dass die Datei abschließend in einem Block geschlossen wird, 
                // um sicherzustellen, dass wir im Falle einer Ausnahme keine offene Datei haben.
                // Wir hätten einen using-Block anstelle von try-finally verwenden können,
                // Das brauchen Sie noch nicht zu wissen (wir werden es in der Mitte des Semesters lernen).
                if (sr != null)
                    sr.Close();
            }

            // Ausgabe der Lieder in der Liste auf der Konsole
            foreach (Song song in songs)
                Console.WriteLine(song.ToString());
        }
    }
    ```

    Kopieren Sie die Datei "music.txt" in den Ordner "c:\temp" und starten Sie die Anwendung. Der Einfachheit halber haben wir alles in die Funktion `main` aufgenommen, aber in einer "Live"-Umgebung ist es ratsam, den Code in eine separate Verarbeitungsklasse auszulagern.

    Im obigen Beispiel werden eine Reihe grundlegender .NET/C#-Techniken vorgestellt. Es lohnt sich auf jeden Fall, sie zu interpretieren und aus den Notizen im obigen Code zu lernen, und wir werden im Laufe des Semesters auf ihnen aufbauen.

## Aufgabe 2 - Beziehung zwischen UML und Code, Schnittstellen und abstrakten Anwendungstechniken

### Ursprüngliche Umgebung

Die anfängliche Umgebung befindet sich im Ordner `Feladat2`, öffnen Sie die Datei `Shapes.sln` in Visual Studio und arbeiten Sie in dieser Lösung.

!!! warning "Achtung!"
    Das Erstellen einer neuen Projektmappe und/oder Projektdatei oder die Ausrichtung des Projekts auf andere/neuere .NET-Versionen ist verboten.

Es gibt eine Datei `Controls.dll` im Ordner `Feladat2\Shapes`, die Sie zur Lösung des Problems verwenden müssen.

### Einzureichen (zusätzlich zum Quellcode)

In zwei bis drei Absätzen eine kurze textliche Zusammenfassung der bei der Lösung von Aufgabe 2 getroffenen Entwurfsentscheidungen, der wichtigsten Grundsätze der Lösung und der Begründung dafür. Dies sollte in die Textdatei `readme.md` geschrieben werden, die sich bereits im Ordner `Feladat2` des ursprünglichen Frames befindet, in einem beliebigen Markdown-Format oder als einfacher Text. Es ist wichtig, in der Datei im Ordner `Feladat2` zu arbeiten (auch wenn es eine Datei mit demselben Namen im Stammordner gibt).

### Verfasst am

Wir haben die Aufgabe, die erste Version einer CAD-Anwendung zu entwickeln, die flächige Vektorgrafiken verarbeiten kann. Lesen Sie mehr:

- Sie müssen in der Lage sein, verschiedene Arten von Formen zu bearbeiten. Zunächst sollten `Square` (Quadrat), `Circle` (Kreis) und `TextArea` unterstützt werden, aber der Code sollte leicht um neue Typen erweiterbar sein.  `TextArea` ist ein editierbares Textfeld.

    !!! warning "Namen"
        Achten Sie darauf, dass Sie die Klassen entsprechend den obigen Angaben benennen!

- Die mit den Formen verbundenen Daten: x- und y-Koordinaten sowie Daten, die für die Visualisierung und die Berechnung des Flächeninhalts der Formen erforderlich sind. Zum Beispiel Seitenlänge für ein Quadrat, Breite und Höhe für `TextArea`, Radius für einen Kreis.

- Jede Form muss Operationen zur Abfrage ihres Typs, ihrer Koordinaten und ihrer Fläche bieten. Die Typabfrageoperation sollte `string`zurückgeben, und die Operation `GetType` der eingebauten Klasse `Type` sollte in der Implementierung nicht verwendet werden.

- Sie müssen in der Lage sein, die im Speicher abgelegten Formen auf der Standardausgabe (Konsole) aufzulisten. Die folgenden Daten werden geschrieben: Art der Form (z. B. für ein Quadrat `Square` usw.), die beiden Koordinaten, Fläche der Form. Die Operation `GetType` der eingebauten Klasse `Type` kann nicht in der Typdeklaration verwendet werden.

- Die Klasse `TextArea` muss aus der Klasse `Textbox` der Klassenbibliothek `Controls.dll` für diese Aufgabe stammen.  `Controls.dll` ist eine .NET-Assembly, die kompiliert wurde, um Klassen zu enthalten.

    !!! failure "Standardimplementierung in Schnittstelle"
        Geben Sie die Standardimplementierung in der .NET-Schnittstelle an, die in C# 8 und höher unterstützt wird. Dies ist oft eine nützliche Technik, die aber bei der Lösung nicht anwendbar ist; es sollte ein eher "klassischer" Ansatz gewählt werden.

- Bei der Umsetzung ist eine Vereinheitlichung anzustreben: z.B. sollte die Verwaltung der Formen in die Zuständigkeit einer **eigenen Abteilung** fallen.
  
    !!! failure
        Es ist nicht zulässig, Formen in einer lokal erzeugten einfachen Liste in der Funktion `Main` zu speichern! Außerdem sollte die Klasse, die für die Verwaltung zuständig ist, NICHT von der eingebauten Klasse `List` oder einer ähnlichen Klasse abgeleitet werden, sondern sie sollte diese enthalten. Diese Abteilung sollte für die Auflistung der Daten in einer Standardausgabe zuständig sein.

- Streben Sie bei der Implementierung nach einfacher Erweiterbarkeit, Wartbarkeit und Vermeidung von doppeltem Code (für Mitgliedsvariablen, Operationen, Konstruktoren). Dies sind die wichtigsten Kriterien für die Annahme der Lösung!

- Zeigen Sie ein Beispiel für die Verwendung von Klassen in der Funktion `Main`. 

- Spätestens am Ende der Implementierung erstellen Sie in Visual Studio Solution ein Klassendiagramm, in dem Sie die Klassen der Lösung übersichtlich anordnen können. Zeigen Sie Assoziationsbeziehungen als Assoziation, nicht als Mitgliedsvariable*(Als Assoziation anzeigen* oder*Als Assoziation* anzeigen). *Als Sammlungsverband anzeigen*, siehe [Laboranleitung 1](../../labor/1-model-es-kod-kapcsolata/index_ger.md)).

    !!! tip "Klassendiagrammkomponente"
        Visual Studio 2022 fügt die *Klassendesignerkomponente* bei der Installation nicht immer hinzu. Wenn es nicht möglich ist, ein Klassendiagramm zum Visual Studio-Projekt hinzuzufügen (weil das *Klassendiagramm* nicht in der Liste des Fensters aufgeführt ist, das während des Befehls *Hinzufügen / Neues Element* erscheint), muss die Komponente *Klassendiagramm* nachträglich installiert werden. Weitere Informationen hierzu finden Sie auf der Seite Entwicklungsumgebung in diesem Handbuch.

Wir nehmen erhebliche Vereinfachungen bei der Umsetzung vor:

- Formen werden nicht gezeichnet (die notwendigen Fähigkeiten werden später im Semester behandelt).
- Die Formen sollten nur im Speicher aufgezeichnet werden.

### Verwendung von Klassenbibliotheken

Die Lösung ist [1. Die Beziehung zwischen dem Modell und dem Code](../../labor/1-model-es-kod-kapcsolata/index_ger.md) kann auf der Grundlage einer Laborübung entwickelt werden. Die vorliegende Aufgabe unterscheidet sich in einem wichtigen Detail: Während wir nur verbal feststellten, dass der Quellcode der Vorfahrenklasse `DisplayBase` nicht veränderbar ist, ist dies im Fall unserer Vorfahrenklasse `Textbox` eine Selbstverständlichkeit, da sie nur als kompilierte DLL verfügbar ist.

!!! note 
    Die Entwicklung von Mehrkomponentenanwendungen, die Zusammenstellung und die Projektreferenz wurden in der ersten Vorlesung behandelt; wenn Sie sich nicht an dieses Thema erinnern, lohnt es sich, es zu wiederholen.

Im Folgenden werden wir uns die Schritte zur Verwendung der Klassen in einer solchen DLL in unserem Code ansehen:



1. Klicken Sie im Fenster Visual Studio Solution Explorer mit der rechten Maustaste auf *Abhängigkeiten* und wählen Sie *Verweis hinzufügen* oder *Projektverweis hinzufügen*(je nachdem, was vorhanden ist).
2. Wählen Sie auf der linken Seite des angezeigten Fensters *Browse*,
   1. Wenn `Controls.dll` in der Liste in der Mitte des Fensters erscheint, deaktivieren Sie das Kontrollkästchen.
   2. Wenn sie nicht angezeigt wird, klicken Sie auf die Schaltfläche *Durchsuchen.*.. unten rechts im Fenster.
        1. Navigieren Sie im angezeigten Dateibrowser-Fenster zur Datei `Controls.dll` und doppelklicken Sie darauf, um das Fenster zu schließen.
        2. In der Mitte des *Referenzmanager-Fensters* sehen Sie das Häkchen bei `Controls.dll`. Klicken Sie auf OK, um das Fenster zu schließen.
3. Klicken Sie auf OK, um das Fenster zu schließen.

??? "Sehr selten, aber es kann vorkommen, dass Visual Studio eine Fehlermeldung"
    Referenz ist ungültig oder wird nicht unterstützt" anzeigt, wenn Sie die oben genannten Schritte ausführen. In den meisten Fällen hilft eine Neuinstallation von Visual Studio.

Damit haben wir in unserem Projekt einen Verweis auf `Controls.dll`hinzugefügt, so dass die darin enthaltenen Klassen verwendet werden können (z. B. können sie instanziiert oder von ihnen abgeleitet werden). Wenn Sie im Projektmappen-Explorer auf *Abhängigkeiten* und dann auf *Baugruppen* klicken, werden *Steuerelemente* angezeigt:

![Steuerelemente.dll](images/controlsdll.png)

Die Klasse `Textbox`, von der unsere Klasse `TextArea` abgeleitet werden soll, befindet sich im Namespace `Controls`.  Die Klasse `TextBox` hat einen Konstruktor mit vier Parametern, den x- und y-Koordinaten sowie der Breite und Höhe. Bei Bedarf kann der *Object Browser *Ihnen helfen, andere Operationen zu entdecken. Der *Object Browser *kann durch Auswahl des Menüs *Object Browser *aus dem Menü *Ansicht* geöffnet werden. Der *Object Browser *wird in einer neuen Registerkarte angezeigt.

!!! note "Wenn die Objektbrowser-Ansicht leer ist"
    Visual Studio 2022 zeigt im Objektbrowser nichts an (nur den Text "Keine Informationen"), solange keine Quelldatei geöffnet ist. Wenn Sie feststellen, dass die Object Browser-Ansicht leer ist, öffnen Sie einfach die Datei Program.cs im Projektmappen-Explorer und wechseln Sie zurück zur Registerkarte Object Browser, wo die Komponenten nun angezeigt werden. 

Wenn Sie im *Object Browser *auf die Komponente `Controls` klicken und jeden Knoten (Namensraum, Klasse) auswählen, werden die Attribute dieses Knotens angezeigt: Wenn Sie z. B. auf den Klassennamen klicken, werden die Mitglieder der Klasse angezeigt.


![Object Browser](images/object-browser.png)

Wir haben nun alle Informationen, die wir zur Erfüllung der Aufgabe benötigen.

## Vorlegen bei

Checkliste für Wiederholungen:

--8<-- "docs/hazi/beadas-ellenorzes/index_ger.md:3"

- Vergessen Sie bei Aufgabe 2 nicht, Ihre Lösung unter `readme.md`einzureichen.
