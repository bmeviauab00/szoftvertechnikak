---
autoren: bzolka
---
# 6. Entwurfsmuster (Erweiterbarkeit)

## Das Ziel der Übung

Ziele der Übung (anhand eines komplexeren, praxisnahen Beispiels):

- Üben einiger grundlegender Entwurfsprinzipien, die Erweiterbarkeit, Wiederverwendbarkeit, Codeübersichtlichkeit und Wartbarkeit fördern: SRP, OPEN-CLOSED, DRY, KISS usw.
- Anwendung einiger Entwurfsmuster, die besonders mit Erweiterbarkeit in Verbindung stehen (Template Method, Strategy, Dependency Injection).
- Üben und Kombinieren weiterer Techniken zur Unterstützung von Erweiterbarkeit und Wiederverwendbarkeit (z. B. Delegates/Lambda-Ausdrücke) mit Entwurfsmustern.
- Übung zur Refaktorisierung von Code.

Zugehörige Vorlesungen:

- Entwurfsmuster: Muster im Zusammenhang mit Erweiterbarkeit (Einführung, Template Method, Strategy) sowie das „Muster“ der Dependency Injection.

## Voraussetzungen

Für die Durchführung der Übung benötigte Werkzeuge:

- Visual Studio 2022

!!! tip "Übung unter Linux oder macOS"
    Das Übungsmaterial wurde grundsätzlich für Windows und Visual Studio erstellt, kann aber auch unter anderen Betriebssystemen mit anderen Entwicklungsumgebungen (z. B. VS Code, Rider, Visual Studio for Mac) oder sogar mit einem Texteditor und CLI-Tools durchgeführt werden. Dies ist möglich, weil die Beispiele im Kontext einer einfachen Konsolenanwendung dargestellt werden (es gibt keine Windows-spezifischen Elemente), und das .NET 8 SDK wird unter Linux und macOS unterstützt. [Hello World unter Linux](https://learn.microsoft.com/en-us/dotnet/core/tutorials/with-visual-studio-code).

### Theoretischer Hintergrund, Denkweise *

Bei der Entwicklung komplexerer Anwendungen müssen wir zahlreiche Designentscheidungen treffen, bei denen oft mehrere Möglichkeiten zur Auswahl stehen. Wenn wir in diesen Punkten nicht auf einfache Wartbarkeit und einfache Erweiterbarkeit unserer Anwendung achten, kann die Entwicklung schnell zum Albtraum werden. Änderungs- und Erweiterungswünsche des Kunden erfordern eine ständige, umfassende Umstrukturierung des Codes: dabei entstehen neue Fehler, und es ist erheblicher Aufwand für umfassende Retests notwendig!

Unser Ziel ist es, solche Änderungs- und Erweiterungswünsche durch Erweiterungen an wenigen, gut definierten Stellen im Code – **ohne** wesentliche Änderungen am bestehenden Code – umsetzen zu können. Das Schlüsselwort ist: statt **Änderung** lieber **Erweiterung**. Damit verbunden gilt: Wenn bestimmte Logiken erweiterbar sind, dann sind sie auch allgemeiner und können in mehreren Kontexten leichter wiederverwendet werden. So kommen wir langfristig schneller voran, unser Code wird kürzer, wir vermeiden Code-Duplikationen (was wiederum die Wartbarkeit erhöht).

**Entwurfsmuster** zeigen bewährte Lösungen für häufig auftretende Entwurfsprobleme: Sie helfen dabei, unseren Code leichter erweiterbar, wartbar und so weit wie möglich wiederverwendbar zu gestalten. In dieser Übung konzentrieren wir uns auf solche Muster, Prinzipien und einige Programmierwerkzeuge, die helfen, die oben genannten Probleme zu lösen.
Aber man soll es nicht übertreiben: Ein bestimmtes Entwurfsmuster sollte nur dann eingesetzt werden, wenn es tatsächlich einen Vorteil bringt. Andernfalls erhöht es nur unnötig die Komplexität der Implementierung.
Vor diesem Hintergrund ist es nicht unser Ziel (und oft auch gar nicht möglich), alle zukünftigen Erweiterungsbedürfnisse vorherzusehen oder im Voraus zu durchdenken. Wichtig ist, dass wir – auch ausgehend von einer einfachen Lösung – unsere Probleme erkennen und den Code kontinuierlich so refaktorisieren, dass er den aktuellen (funktionalen und nicht-funktionalen) Anforderungen entspricht und an den richtigen Stellen besser erweiterbar und wiederverwendbar wird.

Es sei auch erwähnt, dass entsprechende Entwurfsmuster und Sprachmittel auch bei der **Unit-Testbarkeit** unseres Codes eine große Hilfe darstellen: In vielen Unternehmen ist es bei der Entwicklung von Softwareprodukten (zurecht) eine Grundanforderung an die Entwickler, dass sie Unit-Tests mit hoher Codeabdeckung erstellen. Dies ist jedoch praktisch unmöglich, wenn unsere Codeeinheiten/Klassen zu eng miteinander gekoppelt sind.

## 0. Aufgabe – Kennenlernen der Aufgabe und der Ausgangsanwendung

Klonen wir das Repository der Ausgangsanwendung zur 6. Übung [von hier](https://github.com/bmeviauab00/lab-patterns-extensibility-kiindulo):

- Öffne eine Kommandozeile (Command Prompt)
- Navigiere in einen beliebigen Ordner, z. B. nach `c:\work\NEPTUN`
- Führe folgenden Befehl aus: `git clone https://github.com/bmeviauab00/lab-patterns-extensibility-kiindulo.git`
- Öffne die Solution _Lab-Patterns-Extensibility.sln_ in Visual Studio.

### Beschreibung der Aufgabe

Im Labor werden wir eine konsolenbasierte Datenverarbeitungsanwendung (genauer gesagt, eine Anonymisierungsanwendung) entsprechend den sich fortlaufend entwickelnder Anforderungen erweitern – entlang verschiedener Aspekte und unter Anwendung unterschiedlicher Techniken. In der ersten Aufgabe wird auch das Konzept der Anonymisierung vorgestellt.

Die Eingabe in die Anwendung ist eine CSV-Textdatei, in der jede Zeile Daten zu einer bestimmten Person enthält. Öffnen wir im Dateisystem die Datei *us-500.csv* im Ordner *Data* (durch Doppelklick oder mit Notepad).  Wir sehen, dass die Daten zu den einzelnen Personen in Anführungszeichen ("") und durch Kommas getrennt dargestellt sind (es handelt sich um fiktive Daten). Schauen wir uns die erste Zeile an:
  
```
"James","Rhymes","Benton, John B Jr","6649 N Blue Gum St","New Orleans ","Orleans","LA","70116","504-621-8927","504-845-1427","30","65","Heart-related","jRhymes@gmail.com"
```

Die Person in der ersten Zeile heißt James Rhymes, arbeitet bei der Firma "Benton, John B Jr", danach folgen einige Adressfelder, er ist 30 Jahre alt und wiegt 65 kg. Das nachfolgende Feld beschreibt eine schwerwiegende Erkrankung (in der obigen Zeile: „Heart-related“). Die letzte Spalte enthält die E-Mail-Adresse der Person.

??? note "Datenquelle und genaues Format *"
    Die Daten stammen von: https://www.briandunning.com/sample-data/, ergänzt um einige zusätzliche Spalten (Alter, Gewicht, Krankheit). Die Reihenfolge der Felder: First Name, Last Name, Company, Address, City, County (falls zutreffend), State/Province (falls zutreffend), ZIP/Postal Code, Phone 1, Phone 2, Age, Weight, Illness, Email

Die Hauptaufgabe der Anwendung besteht darin, diese Daten je nach aktueller Anforderung zu anonymisieren und in eine Ausgabedatei im CSV-Textformat zu schreiben. Ziel der Anonymisierung ist es, die Personen in der Datenmenge durch Transformationen unkenntlich zu machen – allerdings auf eine Weise, die dennoch statistische Auswertungen über die Daten ermöglicht. Anonymisierung ist ein eigenständiger, sehr anspruchsvoller und herausfordernder Bereich der Datenverarbeitung. In dieser Übung ist es nicht unser Ziel, Lösungen zu entwickeln, die in realen Szenarien einsetzbar oder in jeder Hinsicht sinnvoll sind. Für uns ist eigentlich die Anwendung eines beliebigen Datenverarbeitungsalgorithmus wichtig, um die Entwurfsmuster zu demonstrieren. Dies liefert einen etwas „spannenderen“ Rahmen als einfache Filter-, Sortier- oder ähnliche Datenverarbeitung (die von .NET standardmäßig unterstützt wird).

!!! note "Einige Gedanken zur Anonymisierung"
    Man könnte meinen, dass die Anonymisierung ein einfaches Problem ist. Zum Beispiel müsste man nur die Namen der Personen entfernen oder durch Sternchen ersetzen, ebenso wie die Straßenadresse, Telefonnummern und E-Mail-Adresse – und schon wäre man fertig. Für die erste Zeile unserer Eingabedateri sähe die Ausgabe dann so aus:

    ```
    "***","***","Benton, John B Jr","***","New Orleans ","Orleans","LA","70116","***","***","30","65","Heart-related","***"
    ```

    Doch so einfach ist es nicht – vor allem nicht bei großen Datenmengen. Denken wir zum Beispiel an ein kleines Dorf mit wenigen Einwohnern. Angenommen, eine auf die oben beschriebene Weise anonymisierte Person ist 14 Jahre alt, aber extrem übergewichtig, etwa 95 kg. Das ist eine seltene „Kombination“, es ist sehr wahrscheinlich, dass niemand sonst im Dorf solche Merkmale aufweist. Wenn jemand aus seiner Schulklasse (8. Klasse, da 14 Jahre alt) die „anonymisierten“ Daten sieht, wird er sofort wissen, um wen es sich handelt (es gibt keinen anderen übergewichtigen Achtklässler an der Schule). So erfährt er z. B. auch, welche Krankheit die Person hat. Fazit: Zusammenhänge zwischen den Daten können Rückschlüsse auf die Identität zulassen.
    
    Was ist die Lösung? Stadt, Alter und Gewicht können nicht entfernt oder mit Sternchen ersetzt werden, da genau zu diesen Merkmalen Auswertungen durchgeführt werden sollen. Eine typische Lösung: Anstelle des genauen Alters oder Gewichts werden nach der Anonymisierung Intervalle angegeben (also eine Generalisierung der Daten). Für die obige Person würde man z. B. „10–20 Jahre“ beim Alter und „80–100 kg“ beim Gewicht angeben – und genau diese Werte würden in die Ausgabedatei geschrieben. Auf diese Weise ist keine eindeutige Identifikation der Person mehr möglich. Diese Technik werden wir später noch anwenden.

### Ausgangsanforderungen

Die Ausgangsanforderungen an die Anwendung:

1. Es sollen von einem bestimmten Kunden empfangene Dateien (alle im gleichen Format) verarbeitet werden, die mit demselben Anonymisierungsalgorithmus in dasselbe Ausgabeformat konvertiert werden. Die Anonymisierung soll lediglich darin bestehen, Vor- und Nachnamen mit Sternchen zu ersetzen.
2. Eine gewisse Datenbereinigung ist notwendig. In der Spalte mit dem Stadtnamen können am Anfang oder Ende überflüssige `_`- oder `#`-Zeichen vorkommen, diese müssen entfernt werden (Trim-Operation).
3. Nach der Verarbeitung jeder Zeile soll eine Nachricht auf der Konsole ausgegeben werden, dass die Zeile verarbeitet wurde. Außerdem sollen nach der vollständigen Verarbeitung aller Daten zusammenfassende Informationen (Summary) angezeigt werden: wie viele Zeilen wurden verarbeitet, und in wie vielen Fällen musste der Stadtname getrimmt werden.
4. **Wichtiger Aspekt**: Die Anwendung wird nur für kurze Zeit benötigt und soll in Zukunft nicht erweitert werden.

Hinweis: Um den Code übersichtlicher zu halten und weniger Felder verarbeiten zu müssen, werden einige Felder bei der Verarbeitung weggelassen.

Beispiel für die erwartete Ausgabe der ersten Zeile aus der Eingabedatei:

```
***; ***; LA; New Orleans; 30; 65; Heart-related
```

## 1. Lösung – Alles in einem (1-Start/Start)

Im Solution Explorer von Visual Studio sehen wir Ordner mit Namen, die mit den Zahlen 1 bis 4 beginnen. Diese enthalten die Lösungen zu den jeweiligen Arbeitsiterationen. Die erste Lösung befindet sich im Ordner „1-Start“ unter dem Projektnamen „Start“. Werfen wir einen Blick auf die im Projekt enthaltenen Dateien:

* `Person.cs` – Enthält die für uns relevanten Daten einer Person. Die Daten einer einzelnen Person werden in Objekte dieser Klasse eingelesen.
* `Program.cs` – In der Main-Funktion dieser Datei ist die gesamte Logik implementiert, durch Kommentare  "getrennt". Sobald die Logik etwas komplexer wird, wird es bereits nach wenigen Tagen (oder Stunden?) schwierig sein, den eigenen Code zu überblicken und zu verstehen. Diese Lösung ist daher nicht weiter von Interesse.

Insgesamt ist die Lösung sehr einfach gehalten, da für den Code keine lange Lebensdauer erwartet wird. Dennoch ist eine „skriptartige“ Lösung, bei der sich alles in einer einzigen Funktion befindet, auch in solchen Fällen nicht empfehlenswert – sie erschwert erheblich das **Verständnis** und die **Übersichtlichkeit** des Codes. Daher sollten wir uns damit nicht weiter beschäftigen.

## 2. Lösung (2-OrganizedToFunctions/OrganizedToFunctions-1)

Wechseln wir im Visual Studio zum Projekt „OrganizedToFunctions-1“, das sich im Ordner „2-OrganizedToFunctions“ befindet. Diese Lösung ist bereits deutlich sympathischer, da die Logik in Funktionen aufgeteilt wurde. Werfen wir einen kurzen Blick auf den Code:

`Anonymizer.cs`

  * Die Funktion `Run` bildet das „Rückgrat“ der Anwendung. Sie enthält die Steuerlogik und ruft die einzelnen, für die jeweiligen Schritte zuständigen Funktionen auf.
  * `ReadFromInput`: Liest die Quelldatei ein, erstellt für jede Zeile ein `Person`-Objekt und gibt eine Liste der eingelesenen `Person`-Objekte zurück.
  * `TrimCityNames`: Führt die Datenbereinigung durch (Trimmen der Städtenamen).
  * `Anonymize`: Wird für jedes eingelesene `Person`-Objekt aufgerufen und gibt ein neues `Person`-Objekt zurück, das die anonymisierten Daten enthält.
  * `WriteToOutput`: Schreibt die bereits anonymisierten `Person`-Objekte in die Ausgabedatei.
  * `PrintSummary`: Gibt eine Zusammenfassung der Verarbeitung am Ende in der Konsole aus.

`Program.cs`

  * Erstellt ein `Anonymizer`-Objekt und führt es durch einen Aufruf der `Run`-Funktion aus. Es ist ersichtlich, dass der String für das Maskieren während der Anonymisierung als Konstruktorparameter übergeben werden muss.

Probieren wir es aus, und führen wir das Projekt aus! Stellen wir sicher, dass „OrganizedToFunctions-1“ im Visual Studio als Startprojekt festgelegt ist (Rechtsklick darauf und *Set as Startup Project*), und starten wir es dann:

![Console output](images/OrganizedToFunctions-1-console-out.png)

Die Ausgabedatei können wir im Datei-Explorer finden, sie befindet sich im Ordner „OrganizedToFunctions-1\bin\Debug\net8.0\" oder einem ähnlichen Ordner und hat den Namen „us-500.processed.txt“. Öffnen wir diese Datei und werfen einen Blick auf die Daten.

### Bewertung der Lösung

* Die Lösung ist grundsätzlich gut strukturiert und leicht verständlich.
* Sie folgt dem **==KISS (Keep It Stupid Simple)==**-Prinzip, verwendet keine unnötigen Komplikationen. Das ist gut, da keine potenziellen zukünftigen Erweiterungen zu erwarten sind und keine unterschiedlichen Formate, Logiken usw. unterstützt werden müssen.
* Unsere Lösung folgt jedoch nicht einem der grundlegendsten und bekanntesten Entwurfsprinzipien, das unter dem Namen **==Single Responsibility Principle (SRP)==** bekannt ist. Dieses besagt - vereinfacht ausgedrückt -, dass eine Klasse nur eine Verantwortung haben sollte (sich grundsätzlich nur mit einer Sache beschäftigen sollte).
  
    * Zweifellos hat unsere `Anonymizer`-Klasse mehrere Verantwortlichkeiten: Eingabeverarbeitung, Datenbereinigung, Anonymisierung, Ausgabeerstellung usw.
    * Dieses Problem fällt bei uns jedoch nicht auf und verursacht keine Probleme, weil jede dieser Verantwortlichkeiten einfach umgesetzt ist und in eine kürzere Funktion passt. Wenn jedoch eine der Verantwortlichkeiten komplexer wäre und in mehreren Funktionen umgesetzt werden müsste, sollte sie auf jeden Fall in eine separate Klasse ausgelagert werden.

    ??? note "Warum ist es problematisch, wenn eine Klasse mehrere Verantwortlichkeiten hat? *"

        * Es wird schwieriger, ihr Verhalten zu verstehen, weil sie sich nicht nur auf eine Aufgabe konzentriert.
        * Wenn Änderungen in einer der Verantwortlichkeiten erforderlich sind, muss eine große Klasse geändert und neu getestet werden.
  
* Für die Lösung können automatisierte Integrations- (Input-Output) Tests geschrieben werden, aber „echte“ Unit-Tests sind nicht möglich.

## 3. Lösung (OrganizedToFunctions-2-TwoAlgorithms)

Im Gegensatz zu den vorherigen "Plänen" sind neue Benutzeranforderungen aufgetreten. Unser Kunde hat seine Meinung geändert und bittet um die Implementierung eines anderen Anonymisierungsalgorithmus für einen anderen Datensatz: Das Alter der Personen muss in Bereichen gespeichert werden, das genaue Alter darf nicht erkennbar sein. Zur Vereinfachung werden in diesem Fall die Namen der Personen nicht anonymisiert, betrachten wir dies als eine Art "Pseudo"-Anonymisierung (es macht immer noch Sinn, ist es nicht ganz korrekt, dies Anonymisierung zu nennen).

Unsere Lösung, die sowohl den alten als auch den neuen Algorithmus unterstützt (aber immer nur einen von beiden), befindet sich im VS-Projekt *OrganizedToFunctions-2-TwoAlgorithms*. Werfen wir einen Blick auf die `Anonymizer`-Klasse. Die Grundprinzipien der Lösung (lassen wir uns diese im Code durchgehen):

* Wir haben einen `AnonymizerMode`-Enum-Typ eingeführt, der festlegt, in welchem Modus (mit welchem Algorithmus) die `Anonymizer`-Klasse verwendet wird.
* Die `Anonymizer`-Klasse hat zwei Anonymisierungsoperationen: `Anonymize_MaskName`, `Anonymize_AgeRange`.
* Die `Anonymizer`-Klasse speichert im `_anonymizerMode`-Feld, welcher Algorithmus verwendet werden soll: Für die beiden Modi haben wir zwei verschiedene Konstruktoren eingeführt, die den Wert von `_anonymizerMode` festlegen.
* Die `Anonymizer`-Klasse überprüft an mehreren Stellen (z.B. in den Methoden `Run` und `GetAnonymizerDescription`), welchen Wert `_anonymizerMode` hat, und verzweigt sich entsprechend.
  * In `GetAnonymizerDescription` muss dies getan werden, da diese Methode dafür verantwortlich ist, eine einzeilige Beschreibung des Anonymisierungsalgorithmus zu erstellen, die am Ende der Verarbeitung im "Summary" angezeigt wird. Werfen wir einen Blick auf den Code von `PrintSummary`, der diese Methode aufruft. Zum Beispiel wird dies als Zusammenfassung auf der Konsole angezeigt, wenn wir den Altersanonymisierer mit einem Bereich von 20 verwenden:

      ```Summary - Anonymizer (Age anonymizer with range size 20): Persons: 500, trimmed: 2```

### Bewertung der Lösung

Insgesamt ist die Qualität unseres Codes im Vergleich zum Vorherigen **schlechter** geworden.  
Früher war es kein Problem, dass die Anonymisierungsalgorithmen nicht erweiterbar waren, da es keine Nachfrage danach gab. Aber sobald der Bedarf für einen neuen Algorithmus aufgetreten ist, war es ein Fehler, die Lösung in dieser Hinsicht nicht erweiterbar zu machen: Ab jetzt müssen wir lieber damit rechnen, dass weitere Algorithmen in der Zukunft eingeführt werden müssen.

Warum behaupten wir, dass unser Code nicht erweiterbar ist, wenn "nur" ein neuer Enum-Wert und ein paar zusätzliche `if`/`switch`-Zweige im Code hinzugefügt werden müssen, wenn ein neuer Algorithmus eingeführt wird?

:warning: **Open/Closed Principle**  
Es ist entscheidend, dass wir eine Klasse nur dann als erweiterbar betrachten, wenn es möglich ist, neues Verhalten (in unserem Fall einen neuen Algorithmus) **ohne Modifikation** der Klasse einzuführen, indem wir nur den Code **erweitern/vergrößern**. Das bedeutet, dass der Code der `Anonymizer`-Klasse nicht verändert werden sollte, was hier eindeutig nicht der Fall ist. Dies ist das berühmte **Open/Closed Principle**: Die Klasse sollte für Erweiterungen offen und für Änderungen geschlossen sein. Das Problem bei der Modifikation des Codes ist, dass durch diese Änderungen sehr wahrscheinlich neue Bugs eingeführt werden und der modifizierte Code immer wieder getestet werden muss, was erhebliche Zeit- und Kostenaufwände verursachen kann.

Was ist das genaue Ziel und wie erreichen wir es? Es gibt Teile in unserer Klasse, die wir nicht "einbrennen" möchten:

* Diese sind keine Daten, sondern **==Verhalten (Code, Logik)==**.
* Wir lösen es nicht mit `if`/`switch`-Befehlen: Wir führen "Erweiterungspunkte" ein und stellen sicher, dass an diesen Stellen "beliebiger" Code ausgeführt werden kann.
* Den Code dieser variablen/fallspezifischen Teile legen wir **in andere Klassen** (die aus der Perspektive unserer Klasse "austauschbar" sind)!

!!! note  
    Denken wir nicht an irgendwelche Zauberei, wir werden dafür die bekannten Werkzeuge verwenden: Vererbung mit abstrakten/virtuellen Funktionen, Schnittstellen oder Delegaten.

Suchen wir nach den Teilen, die fallabhängige, variable Logik enthalten, und die daher nicht direkt in die `Anonymizer`-Klasse eingebaut werden sollten:

* Eine der Logiken ist die Anonymisierungslogik: `Anonymize_MaskName`/`Anonymize_AgeRange`
* Die andere ist `GetAnonymizerDescription`

Diese müssen vom Code der Klasse getrennt werden, und an diesen Stellen muss die Klasse erweiterbar gemacht werden. Die folgende Abbildung zeigt das allgemeine Ziel:

??? note "Illustration der allgemeinen Lösungsmethode"

    ![Extensibility illustration](images/illustrate-extensibility.png)

Wir werden uns drei spezifische Entwurfsmuster und -techniken ansehen, um die oben genannten Ziele zu erreichen:

* Template Method Entwurfsmuster
* Strategy Entwurfsmuster (einschließlich Dependency Injection)
* Delegate (optional mit Lambda-Ausdruck)

Eigentlich haben wir diese Konzepte bereits in unseren Studien verwendet, aber jetzt werden wir sie noch besser kennen lernen und ihre Anwendung umfassender üben. Die ersten beiden werden wir im Labor untersuchen, das dritte wird dann im Rahmen einer zugehörigen Hausaufgabe behandelt.

## 4. Lösung (3-TemplateMethod/TemplateMethod-1)

In diesem Schritt werden wir mit der Anwendung des **Template Method** Entwurfsmusters unsere Lösung an den erforderlichen Punkten erweiterbar machen.

!!! note  
    Der Name des Musters ist "irreführend": Es hat nichts mit den in C++ erlernten Template-Methoden zu tun!

??? info "Klassendiagramm der Template Method basierte Lösung"  
    Das folgende UML-Klassendiagramm veranschaulicht die Template-Methoden-basierte Lösung mit einem Fokus auf die wesentlichen Punkte:

    ![Template Method UML Klassendiagramm Ziel](images/template-method-goal.png)

Im Muster wird die Trennung der "unveränderlichen" und "variablen" Teile nach den folgenden Prinzipien umgesetzt (es ist sinnvoll, diese anhand des oben gezeigten Klassendiagramms - angewendet auf unser Beispiel - zu verstehen):

* Die "gemeinsamen/unveränderlichen" Teile kommen in eine Basisklasse.
* Erweiterungspunkte werden hier durch die Einführung abstrakter/virtueller Funktionen geschaffen, die an den Erweiterungspunkten aufgerufen werden.
* Die fallabhängige Implementierung dieser Erweiterungspunkte kommt in die abgeleiteten Klassen.

Der bekannte "Trick" besteht darin, dass, wenn die Basisklasse die abstrakten/virtuellen Funktionen aufruft, der fallabhängige Code in den abgeleiteten Klassen ausgeführt wird.

In den folgenden Schritten werden wir die vorherige `enum`- bzw. `if`/`switch`-basierte Lösung in eine **Template Method** Lösung umwandeln (es wird kein `enum` mehr verwendet). Wir werden eine Basisklasse und zwei algorithmusabhängige abgeleitete Klassen einführen.

Lassen wir uns den Code entsprechend anpassen. Im Visual Studio Solution "3-TemplateMethod" befindet sich das Projekt "TemplateMethod-0-Begin", das eine Kopie unserer vorherigen Lösung enthält. In diesem Projekt werden wir arbeiten:

1. Benennen wir die Klasse `Anonymizer` in `AnonymizerBase` um (z. B. in der Quelldatei mit Rechtsklick auf den Klassennamen und Drücken von ++f2++).
2. Fügen wir dem Projekt eine `NameMaskingAnonymizer`- und eine `AgeAnonymizer`-Klasse hinzu (Rechtsklick im Projekt, *Add*/*Class*).
3. Erben wir die Klassen `NameMaskingAnonymizer` und `AgeAnonymizer` von der `AnonymizerBase`.
4. Verschieben wir die entsprechenden Teile aus der `AnonymizerBase` in die `NameMaskingAnonymizer`:
    1. Die `_mask`-Mitgliedsvariable.
    2. Der Konstruktor mit den Parametern `string inputFileName, string mask`, umbenannt zu `NameMaskingAnonymizer`, wobei:
        1. Die Zeile `_anonymizerMode = AnonymizerMode.Name;` entfernt wird.
        2. Anstelle von `this` verwenden wir `base` für den Konstruktoraufruf.
      
            ??? example "Der Konstruktor Code"

                ``` csharp
                public NameMaskingAnonymizer(string inputFileName, string mask): base(inputFileName)
                {
                    _mask = mask;
                }
                ```

5. Verschieben wir die entsprechenden Teile aus der `AnonymizerBase` in die `AgeAnonymizer`:
    1. Die `_rangeSize`-Mitgliedsvariable.
    2. Der Konstruktor mit den Parametern `string inputFileName, string rangeSize`, umbenannt zu `AgeAnonymizer`, wobei:
        1. Die Zeile `_anonymizerMode = AnonymizerMode.Age;` entfernt wird.
        2. Anstelle von `this` verwenden wir `base` für den Konstruktoraufruf.

            ??? example "Der Konstruktor Code"
      
                ``` csharp
                public AgeAnonymizer(string inputFileName, int rangeSize): base(inputFileName)
                {
                    _rangeSize = rangeSize;
                }
                ```

6. In der `AnonymizerBase`:
    1. Löschen wir den `AnonymizerMode` Aufzählungstyp.
    2. Löschen wir das `_anonymizerMode`-Feld.

Suchen wir die Teile, die fallabhängige, variable Logiken enthalten, die wir nicht in die wiederverwendbare `AnonymizerBase`-Klasse einbetten möchten:

* Eine davon ist `Anonymize_MaskName`/`Anonymize_AgeRange`,
* die andere ist `GetAnonymizerDescription`.

Dem Muster folgend führen wir in der Basisklasse abstrakte (oder möglicherweise virtuelle) Methoden ein und rufen diese auf, wobei die fallabhängigen Implementierungen in den abgeleiteten Klassen platziert werden (mit `override`):

1. Machen wir die `AnonymizerBase`-Klasse abstrakt (indem wir das Schlüsselwort `abstract` vor `class` setzen).
2. Fügen wir in `AnonymizerBase` die folgende Methode hinzu:

    ``` csharp
    protected abstract Person Anonymize(Person person);
    ```

    Diese Methode wird für die Durchführung der Anonymisierung verantwortlich sein.

3. Bewegen wir die Methode `Anonymize_MaskName` in die `NameMaskingAnonymizer`-Klasse und ändern wir ihre Signatur, sodass sie die abstrakte Methode `Anonymize` der Basisklasse überschreibt:

    ``` csharp
    protected override Person Anonymize(Person person)
    {
        return new Person(_mask, _mask, person.CompanyName,
            person.Address, person.City, person.State, person.Age, person.Weight, person.Decease);
    }
    ```

    Der Körper der Methode muss nur so geändert werden, dass anstelle des entfernten `mask`-Parameters die `_mask`-MemberVariable verwendet wird.

4. Auf die gleiche Weise wie im vorherigen Schritt verschieben wir die Methode `Anonymize_AgeRange` in die `AgeAnonymizer`-Klasse und ändern ihre Signatur so, dass sie die abstrakte Methode `Anonymize` der Basisklasse überschreibt:

    ``` csharp
    protected override Person Anonymize(Person person)
    {
        ...
    }
    ```

    Der Körper der Methode muss nur so geändert werden, dass anstelle des entfernten `rangeSize`-Parameters die `_rangeSize`-MemberVariable verwendet wird.

5. In der `Run`-Methode der `AnonymizerBase`-Klasse können wir die `Anonymize`-Aufrufe im `if`/`else`-Ausdruck jetzt durch einen einfachen Aufruf der abstrakten Methode ersetzen:

    {--
    
    ``` csharp
    Person person;
    if (_anonymizerMode == AnonymizerMode.Name)
        person = Anonymize_MaskName(persons[i], _mask);
    else if (_anonymizerMode == AnonymizerMode.Age)
        person = Anonymize_AgeRange(persons[i], _rangeSize);
    else
        throw new NotSupportedException("The requested anonymization mode is not supported.");
    ```

    --}

    Stattdessen:

    ``` csharp
    var person = Anonymize(persons[i]);
    ```

Ein unserer Erweiterungspunkte ist fertig. Es bleibt jedoch noch einer, `GetAnonymizerDescription`, deren Behandlung ebenfalls fallspezifisch ist. Die Umwandlung davon ist sehr ähnlich zu den vorherigen Schritten:

1. Kopieren wir die Methode `GetAnonymizerDescription` aus der Klasse `AnonymizerBase` in die Klasse `NameMaskingAnonymizer`, fügen wir das Schlüsselwort `override` in die Signatur ein und lassen wir im Funktionskörper nur die Logik, die für `NameMaskingAnonymizer` gilt:

    ``` csharp
    protected override string GetAnonymizerDescription()
    {
        return $"NameMasking anonymizer with mask {_mask}";
    }
    ```

2. Kopieren wir die Methode `GetAnonymizerDescription` aus der Klasse `AnonymizerBase` auch in die Klasse `AgeAnonymizer`, fügen wir das Schlüsselwort `override` in die Signatur ein und lassen wir im Funktionskörper nur die Logik, die für `AgeAnonymizer` gilt:

    ``` csharp
    protected override string GetAnonymizerDescription()
    {
        return $"Age anonymizer with range size {_rangeSize}";
    }
    ```

3. Die Frage ist, was wir mit der Methode `GetAnonymizerDescription` in `AnonymizerBase` machen. Wir machen sie nicht abstrakt, sondern zu einer virtuellen Methode, da wir hier ein sinnvolles Standardverhalten bereitstellen können: Wir geben einfach den Namen der Klasse zurück (der z.B. für die Klasse `NameMaskingAnonymizer` "NameMaskingAnonymizer" wäre). Auf diese Weise befreien wir uns von der starren `switch`-Struktur:

    ``` csharp
    protected virtual string GetAnonymizerDescription()
    {
        return GetType().Name;
    }
    ```

    !!! note "Reflexion"
        Mit der aus der `object`-Klasse geerbten Methode `GetType()` erhalten wir ein `Type`-Objekt, das Informationen über die Klasse enthält. Dies gehört zum Thema **Reflexion**, über das wir am Ende des Semesters in einer Vorlesung ausführlicher lernen werden.

Es bleibt nur noch eine Sache: In der `Main`-Methode der `Program.cs` versuchen wir nun, die Basisklasse `AnonymizerBase` zu instanziieren (aufgrund der vorherigen Umbenennung). Stattdessen sollten wir eine der beiden abgeleiteten Klassen verwenden. Zum Beispiel:

``` csharp
NameMaskingAnonymizer anonymizer = new("us-500.csv", "***");
anonymizer.Run();
```

Wir sind fertig! Versuchen wir nun, die Erweiterungspunkte besser zu verstehen, um sicherzustellen, dass sie wirklich funktionieren (aber falls wir im Labor wenig Zeit haben, ist das nicht unbedingt wichtig; etwas Ähnliches haben wir bereits in früheren Semestern in C++/Java durchgeführt):

* Stellen wir sicher, dass das Projekt *TemplateMethod-0-Begin* das Startprojekt in Visual Studio ist, falls wir das noch nicht eingestellt haben.
* Setzen wir einen Haltepunkt in der `AnonymizerBase`-Klasse auf die Zeile `var person = Anonymize(persons[i]);`.
* Wenn der Debugger während der Ausführung hier anhält, drücken wir `F11`, um in die Methode hineinzugehen.
* Wir werden feststellen, dass die Methode der abgeleiteten Klasse `AgeAnonymizer` aufgerufen wird.

Werfen wir einen Blick auf das Klassendiagramm der Lösung:

??? "Klassendiagramm der Template Method basiertes Lösung*"
    ![Template Method basiertes Lösungs-Klassendiagramm](images/template-method.png)

!!! note "Unsere bisherige Lösung ist im `3-TemplateMethod/TemplateMethod-1` Projekt zu finden, falls wir sie brauchen."

??? "Warum heißt das Muster Template Method? *"
    Das Muster trägt den Namen "Template Method", weil - unter Verwendung unserer Anwendung als Beispiel - die Methoden `Run` und `PrintSummary` "Schablonenmethoden" sind, die eine schablonenartige Logik oder Struktur definieren, in der bestimmte Schritte nicht festgelegt sind. Diese Code-Teile werden an abstrakte/virtuelle Methoden delegiert, und die abgeleiteten Klassen bestimmen deren Implementierung.

### Bewertung der Lösung

Überprüfen wir, ob die Lösung unsere Ziele erfüllt:

* Die `AnonymizerBase`-Klasse wurde wiederverwendbarer.
* Wenn in Zukunft eine neue Anonymisierungslogik erforderlich ist, müssen wir nur davon ableiten. Dies ist keine Modifikation, sondern eine Erweiterung.
* Entsprechend wird das OPEN/CLOSED-Prinzip eingehalten, das heißt, wir können die Logik an den beiden Punkten im Basisklassen-Code anpassen und erweitern, ohne den Code der Basisklasse zu ändern.

!!! note "Soll jede Methode unserer Klasse erweiterbar sein?"
    Beachten wir, dass wir nicht jede Methode der `AnonymizerBase`-Klasse virtuell gemacht haben, um die Klasse an jeder Stelle erweiterbar zu machen. Wir haben dies nur dort getan, wo wir glauben, dass es in Zukunft erforderlich sein könnte, die Logik zu erweitern.

## 5. Lösung (3-TemplateMethod/TemplateMethod-2-Progress)

Nehmen wir an, dass es eine neue - relativ einfache - Anforderung gibt:

* Beim `NameMaskingAnonymizer` bleibt die bisher einfache Fortschrittsanzeige bestehen (wir geben nach jeder Zeile an, wie weit wir sind),

    ??? note "Einfache Fortschrittsanzeige"
        ![Einfache Fortschrittsanzeige](images/progress-simple.png)

* Beim `AgeAnonymizer` muss die Fortschrittsanzeige jedoch anders aussehen: Es soll nach jeder Zeile angezeigt werden, wie viel Prozent der Verarbeitung abgeschlossen sind.

    ??? note "Prozentuale Fortschrittsanzeige"
        ![Prozentuale Fortschrittsanzeige](images/progress-percent.gif)
        
        (Da wir derzeit nur wenige Daten haben (nur 500 Zeilen), wird diese Lösung am Ende schnell auf 100% springen.)

Die Lösung ist sehr einfach: Wir wenden das Template Method-Muster in der `Run`-Methode weiter an und führen auch für die Fortschrittsanzeige einen Erweiterungspunkt ein, indem wir die Implementierung in eine virtuelle Methode auslagern.

Springen wir direkt zur fertigen Lösung (*3-TemplateMethod/TemplateMethod-2-Progress* Projekt):

* In der `AnonymizerBase`-Klasse neue virtuelle Funktion `PrintProgress` (gibt standardmäßig nichts aus)
* Aufruf dieser Funktion in `Run`
* Entsprechende Implementierung in `NameMaskingAnonymizer` und `AgeAnonymizer` (override)

Dies hat zunächst keine wesentlichen Erkenntnisse, aber im nächsten Schritt wird es welche geben.

## 6. Lösung (3-TemplateMethod/TemplateMethod-3-ProgressMultiple)

Ein neuer - und völlig logischer - Bedarf ist aufgetaucht: In Zukunft soll jeder Anonymisierungsalgorithmus mit jeder Art der Fortschrittsanzeige verwendet werden können. Dies bedeutet derzeit vier Kreuzkombinationen:

| Anonymisierer       | Fortschritt       |
| ------------------- | ----------------- |
| Namensanonymisierer | Einfache Fortschritte |
| Namensanonymisierer | Prozentualer Fortschritt |
| Altersanonymisierer | Einfache Fortschritte |
| Altersanonymisierer | Prozentualer Fortschritt |

Springen wir zur fertigen Lösung (*3-TemplateMethod/TemplateMethod-3-ProgressMultiple* Projekt). Statt des Codes öffnen wir das `Main.cd` Klassendiagramm im Projekt und betrachten die Lösung anhand dieses Diagramms (oder wir können das Diagramm unten in der Anleitung ansehen).

??? "Template Method basierte Lösung (zwei Aspekte) Klassendiagramm"
    ![Template Method basierte Lösung (zwei Aspekte) Klassendiagramm](images/template-method-progress-multiple.png)

Es ist spürbar, dass etwas "nicht stimmt", da für jede Kreuzkombination eine separate abgeleitete Klasse erstellt werden musste. Um den Code-Duplikationen zu verringern, gibt es sogar zusätzliche, Zwischenklassen in der Hierarchie. Außerdem:

* Wenn wir in Zukunft einen neuen Anonymisierungsalgorithmus einführen, müssen wir so viele neue Klassen schreiben (mindestens), wie viele Fortschrittstypen wir unterstützen.
* Wenn wir in Zukunft einen neuen Fortschrittstyp einführen, müssen wir so viele neue Klassen schreiben (mindestens), wie viele Anonymisierungstypen wir unterstützen.

Was hat das Problem verursacht? Dass **das Verhalten unserer Klassen entlang mehrerer Dimensionen/Aspekte (in unserem Beispiel Anonymisierung und Fortschritt) erweiterbar gemacht werden muss, und diese in vielen Kreuzkombinationen unterstützt werden müssen**. Wenn wir weitere Aspekte hinzufügen müssten (z.B. Art des Lesens oder Generierung der Ausgabe), würde das Problem exponentiell "explodieren". In solchen Fällen ist das Template-Method-Designmuster nicht anwendbar.

## 7. Lösung (4-Strategy/Strategy-1)

In diesem Schritt werden wir das **Strategy**-Entwurfsmuster anwenden, um unsere ursprüngliche Lösung an den erforderlichen Stellen erweiterbar zu machen. Im Muster wird die Trennung der "unveränderlichen/wiederverwendbaren" und "veränderbaren" Teile wie folgt umgesetzt:

* Die "gemeinsamen/unveränderlichen" Teile werden in eine bestimmte Klasse eingefügt (aber es wird keine "Basisklasse" sein).
* Im Gegensatz zum Template Method-Muster verwenden wir hier keine Vererbung, sondern Komposition (Enthaltensein): Das Verhalten in den Erweiterungspunkten wird auf andere Objekte übertragen, die als Schnittstellen enthalten sind (und nicht auf abstrakte/virtuelle Funktionen).
* Dies wird für jeden Aspekt des Verhaltens der Klasse durchgeführt, den wir ersetzbar/erweiterbar machen wollen, unabhängig voneinander. Wie wir sehen werden, kann so die kombinatorische Explosion, die im vorherigen Kapitel auftrat, vermieden werden.

Das ist in der Praxis viel einfacher, als es in der Theorie erscheint (wir haben es auch schon in früheren Studien verwendet). Um das zu verstehen, betrachten wir unser Beispiel.

Im Folgenden betrachten wir das Klassendiagramm, das die Strategy-basierte Lösung veranschaulicht (auf die Erklärung nach dem Diagramm basierend).

??? info "Klassendiagramm der Strategie-basierte Lösung"
    Das folgende UML-Klassendiagramm veranschaulicht die strategie-basierte Lösung, mit Fokus auf das Wesentliche:

    ![Strategie UML Klassendiagramm Ziel](images/strategy-goal.png)

Der erste Schritt bei der Anwendung des Strategy-Musters ist die Bestimmung, **wie viele verschiedene Aspekte des Verhaltens der Klasse** wir erweiterbar machen möchten. In unserem Beispiel gibt es vorerst - zumindest - zwei:

* Verhalten im Zusammenhang mit der Anonymisierung, das zwei Operationen umfasst:
    * Anonymisierungslogik
    * Bestimmung der Beschreibung der Anonymisierungslogik (Erzeugung des Beschreibungstextes)
* Fortschrittsbehandlung, die eine Operation umfasst:
    * Fortschrittsanzeige

Der schwierigste Teil ist damit erledigt, ab jetzt kann man grundsätzlich mechanisch arbeiten, indem man dem Strategy-Muster folgt:

1. Für jeden der oben genannten Aspekte muss ein eigenes Strategy-Interface eingeführt werden, mit den oben definierten Operationen, und für jedes müssen die entsprechende Implementierungen erstellt werden.
2. In der `Anonymizer`-Klasse muss für jedes Strategy-Interface eine Mitgliedsvariable eingeführt werden, und in den Erweiterungspunkten wird über diese Mitgliedsvariablen die aktuell eingestellte Strategy-Implementierung verwendet.

Diese Elemente erscheinen auch im obigen Klassendiagramm. Jetzt wechseln wir zum Code. Unsere Ausgangsumgebung befindet sich im "4-Strategy"-Ordner im "Strategy-0-Begin"-Projekt, in dem wir weiterarbeiten werden. Dies ist dieselbe Lösung, die das Enum verwendet, wie die, die wir auch als Ausgangspunkt für das Template Method-Muster verwendet haben.

### Anonymisierungsstrategie

Wir beginnen mit der Verwaltung der **Anonymisierungsstrategie/-aspekts**. Führen wir die zugehörige Schnittstelle ein:

1. Erstellen wir im Projekt einen Ordner namens `AnonymizerAlgorithms` (Rechtsklick auf das "Strategy-0-Begin"-Projekt, dann *Add/New Folder* Menü). In den nächsten Schritten fügen wir jede Schnittstelle und Klasse in eine separate Datei mit dem entsprechenden Namen im gewohnten Format ein!
2. Fügen wir in diesem Ordner eine Schnittstelle `IAnonymizerAlgorithm` mit folgendem Code hinzu:

    ``` csharp title="IAnonymizerAlgorithm.cs"
    public interface IAnonymizerAlgorithm
    {
        Person Anonymize(Person person);
        string GetAnonymizerDescription() => GetType().Name;
    }
    ```

    Es ist auch bemerkenswert, dass wir in modernen C#-Versionen bei Bedarf den Methoden in Schnittstellen eine Standardimplementierung geben können, wie es bei der Methode `GetAnonymizerDescription` der Fall ist!

Jetzt erstellen wir die Implementierung für die Anonymisierung von **Namen** (also eine Strategy-Implementierung).

1. Fügen wir eine `NameMaskingAnonymizerAlgorithm` Klasse in denselben Ordner hinzu.
2. Verschieben wir die zugehörige `_mask` Mitgliedsvariable aus der `Anonymizer`-Klasse in die `NameMaskingAnonymizerAlgorithm` Klasse.
3. Fügen wir folgenden Konstruktor in die `NameMaskingAnonymizerAlgorithm` Klasse ein:

    ``` csharp
    public NameMaskingAnonymizerAlgorithm(string mask)
    {
        _mask = mask;
    }
    ```

4. Implementieren wir die `IAnonymizerAlgorithm` Schnittstelle. Nachdem wir den Schnittstellennamen nach dem Klassennamen als `: IAnonymizerAlgorithm` hinzugefügt haben, ist es sinnvoll, mit Visual Studio das Grundgerüst für die Methoden zu erzeugen: Platzieren wir den Cursor auf den Schnittstellennamen (klicken wir im Quellcode darauf), verwenden wir die Tastenkombination 'ctrl' + '.', und wählen wir im Menü "Implement interface". Hinweis: Da es für die `GetAnonymizerDescription` Methode bereits eine Standardimplementierung in der Schnittstelle gibt, wird nur die `Anonymize` Methode generiert. Das ist momentan in Ordnung.
5. Übernehmen wir den Code der `Anonymize_MaskName` Methode aus der `Anonymizer`-Klasse in die `Anonymize` Methode der `NameMaskingAnonymizerAlgorithm`. Der Methodenkörper muss nur so geändert werden, dass nicht mehr der nicht mehr existierende `mask` Parameter, sondern die `_mask` Membervariable verwendet wird. Löschen wir dann die `Anonymize` Methode in der `Anonymizer` Klasse.

6. Jetzt wenden wir uns der Implementierung der `GetAnonymizerDescription` Methode im Strategy Interface zu. Kopieren wir die `GetAnonymizerDescription` Methode aus der `Anonymizer` Klasse in die `NameMaskingAnonymizerAlgorithm` Klasse und lassen wir nur die Logik für den Namensanonymisierer übrig, indem wir die Methode öffentlich machen:

    ``` csharp
    public string GetAnonymizerDescription()
    {
        return $"NameMasking anonymizer with mask {_mask}";
    }
    ```

8. ??? example "Mit dieser Implementierung haben wir die Strategy für die Namensanonymisierung abgeschlossen. Der vollständige Code sieht nun wie folgt aus:"

        ``` csharp title="NameMaskingAnonymizerAlgorithm.cs"
        public class NameMaskingAnonymizerAlgorithm: IAnonymizerAlgorithm
        {
            private readonly string _mask;

            public NameMaskingAnonymizerAlgorithm(string mask)
            {
                _mask = mask;
            }

            public Person Anonymize(Person person)
            {
                return new Person(_mask, _mask, person.CompanyName,
                    person.Address, person.City, person.State, person.Age, person.Weight, person.Decease);
            }

            public string GetAnonymizerDescription()
            {
                return $"NameMasking anonymizer with mask {_mask}";
            }
        }
        ```

Im nächsten Schritt erstellen wir die Implementierung des `IAnonymizerAlgorithm` Strategy-Interfaces für die Anonymisierung von **Alter**.

1. Erstellen wir eine `AgeAnonymizerAlgorithm`-Klasse im gleichen Ordner (AnonymizerAlgorithms).
2. Verschieben wir die zugehörige `_rangeSize`-Membervariable aus der `Anonymizer`-Klasse in die `AgeAnonymizerAlgorithm`-Klasse.
3. Fügen wir den folgenden Konstruktor in die `AgeAnonymizerAlgorithm`-Klasse ein:

    ``` csharp
    public AgeAnonymizerAlgorithm(int rangeSize)
    {
        _rangeSize = rangeSize;
    }
    ```

4. Implementieren wir die `IAnonymizerAlgorithm`-Schnittstelle. Nachdem wir den Schnittstellennamen `: IAnonymizerAlgorithm` nach dem Klassennamen hinzugefügt haben, ist es ratsam, das Skelett der `Anonymize`-Methode mithilfe von Visual Studio wie zuvor zu generieren.
5. Übertragen wir den Code der `Anonymize_AgeRange`-Methode aus der `Anonymizer`-Klasse in die `AgeAnonymizerAlgorithm`.`Anonymize`-Methode. Der Code muss nur so angepasst werden, dass anstelle des nicht mehr existierenden `rangeSize`-Parameters nun die `_rangeSize`-Membervariable verwendet wird. Löschen wir dann die `Anonymize_AgeRange`-Methode in der `Anonymizer`-Klasse.
6. Jetzt gehen wir weiter mit der Implementierung der `GetAnonymizerDescription`-Methode des Strategy-Interfaces. Kopieren wir die `GetAnonymizerDescription`-Methode aus der `Anonymizer`-Klasse in die `AgeAnonymizerAlgorithm`-Klasse und lassen wir im Methodenkörper nur die Logik für die Altersanonymisierung, und machen wir die Methode öffentlich:

    ``` csharp
    public string GetAnonymizerDescription()
    {
        return $"Age anonymizer with range size {_rangeSize}";
    } 
    ```

7. ??? example "Damit ist die Implementierung der Strategie für die Altersanonymisierung abgeschlossen, der gesamte Code lautet wie folgt"

        ``` csharp title="AgeAnonymizerAlgorithm.cs"
        public class AgeAnonymizerAlgorithm: IAnonymizerAlgorithm
        {
            private readonly int _rangeSize;

            public AgeAnonymizerAlgorithm(int rangeSize)
            {
                _rangeSize = rangeSize;
            }

            public Person Anonymize(Person person)
            {
                // This is whole number integer arithmetics, e.g for 55 / 20 we get 2
                int rangeIndex = int.Parse(person.Age) / _rangeSize;
                string newAge = $"{rangeIndex * _rangeSize}..{(rangeIndex + 1) * _rangeSize}";

                return new Person(person.FirstName, person.LastName, person.CompanyName,
                    person.Address, person.City, person.State, newAge,
                    person.Weight, person.Decease);
            }

            public string GetAnonymizerDescription()
            {
                return $"Age anonymizer with range size {_rangeSize}";
            }
        }
        ```

:exclamation: Beachten wir unbedingt, dass die Schnittstelle und ihre Implementierungen ausschließlich mit der Anonymisierung zu tun haben, ohne jegliche andere Logik (z. B. Fortschrittsanzeige)!

### Fortschrittsstrategie

Im nächsten Schritt führen wir die Schnittstelle und die Implementierungen für die **Fortschrittsanzeige** ein:

1. Erstellen wir im Projekt einen Ordner namens `Progresses`. In den folgenden Schritten fügen wir jede Schnittstelle und jede Klasse in eine separate, benannte Quelldatei gemäß den üblichen Konventionen ein.
2. Fügen wir in diesem Ordner eine `IProgress`-Schnittstelle mit folgendem Code hinzu:

    ??? example "Lösung"

        ``` csharp title="IProgress.cs"
        public interface IProgress
        {
            void Report(int count, int index);
        }
        ```

3. Fügen wir eine Implementierung dieser Schnittstelle für den einfachen Fortschritt in denselben Ordner ein. Die Implementierung wurde aus der `PrintProgress`-Methode unserer `Anonymizer`-Klasse abgeleitet:

    ??? example "Lösung"

        ``` csharp title="SimpleProgress.cs"
        public class SimpleProgress: IProgress
        {
            public void Report(int count, int index)
            {
                Console.WriteLine($"{index + 1}. person processed");
            }
        }
        ```

4. Fügen wir eine Implementierung dieser Schnittstelle für den Prozentsatz-Fortschritt in denselben Ordner ein. Wir werden uns nicht mit der Interpretation des Codes befassen. Diese Lösung existiert in unserer `Anonymizer`-Klasse nicht, da wir sie nur in unserer Template Method-basierten Lösung eingeführt haben (die wir dort nicht im Detail betrachtet haben, aber sie ist praktisch identisch in ihrer Logik):

    ??? example "Lösung"

        ``` csharp title="PercentProgress.cs"
        public class PercentProgress: IProgress
        {
            public void Report(int count, int index)
            {
                int percentage = (int)((double)(index+1) / count * 100);

                Console.Write($"\rProcessing: {percentage} %");

                if (index == count - 1)
                    Console.WriteLine();
            }
        }
        ```

:exclamation: Beachten wir unbedingt, dass die Schnittstelle und ihre Implementierungen ausschließlich mit der Fortschrittsanzeige zu tun haben, ohne jegliche andere Logik (z. B. Anonymisierung)!

### Anwendung der Strategien

Der nächste wichtige Schritt ist es, die Basisklasse des Anonymisierers mithilfe der oben eingeführten Strategien wiederverwendbar und erweiterbar zu machen. Im `Anonymizer.cs`-Datei:

1. Löschen wir das Folgende:
      * `AnonymizerMode`-Enum-Typ
      * `_anonymizerMode`-Feld (sowie die Felder `_mask` und `_rangeSize`, falls diese vorher noch vorhanden sind)
  
2. Führen wir jeweils ein Strategie-Interface-Typ-Feld ein:

    ``` csharp
    private readonly IProgress _progress;
    private readonly IAnonymizerAlgorithm _anonymizerAlgorithm;
    ```

3. Fügen wir am Anfang der Datei die entsprechenden `using`-Anweisungen hinzu:

    ``` csharp
    using Lab_Extensibility.AnonymizerAlgorithms;
    using Lab_Extensibility.Progresses;
    ```

4. Die in dem vorherigen Punkt eingeführten Felder `_progress` und `_anonymizerAlgorithm` haben anfangs den Wert `null`. Im Konstruktor setzen wir diese Referenzen auf die für unsere Anforderungen passende Implementierung. Zum Beispiel:

    ``` csharp hl_lines="3-4 9-10"
    public Anonymizer(string inputFileName, string mask) : this(inputFileName)
    {
        _progress = new PercentProgress();
        _anonymizerAlgorithm = new NameMaskingAnonymizerAlgorithm(mask);
    }

    public Anonymizer(string inputFileName, int rangeSize) : this(inputFileName)
    {
        _progress = new PercentProgress();
        _anonymizerAlgorithm = new AgeAnonymizerAlgorithm(rangeSize);
    }
    ```

Im `Anonymizer`-Klasse übergeben wir die aktuell eingebettete, aber **anonymisierungsabhängige** Logik an die von der `_anonymizerAlgorithm`-Membervariable referenzierte Strategy-Implementierung:

1. In der `Run`-Methode der Klasse delegieren wir die `Anonymize`-Aufrufe, die sich im `if`/`else`-Ausdruck befinden, nun an das `_anonymizerAlgorithm`-Objekt:

    {--

    ``` csharp
    Person person;
    if (_anonymizerMode == AnonymizerMode.Name)
        person = Anonymize_MaskName(persons[i], _mask);
    else if (_anonymizerMode == AnonymizerMode.Age)
        person = Anonymize_AgeRange(persons[i], _rangeSize);
    else
        throw new NotSupportedException("The requested anonymization mode is not supported.");
    ```

    --}

    Stattdessen:

    ``` csharp
    Person person = _anonymizerAlgorithm.Anonymize(persons[i]);
    ```

2. Falls wir dies noch nicht getan haben, löschen wir die `Anonymize_MaskName`- und `Anonymize_AgeRange`-Methoden, da deren Code jetzt in die Strategy-Implementierungen verschoben wurde und vom Rest der Klasse getrennt ist.

4. Unsere `PrintSummary`-Methode ruft die unflexible, auf `switch` basierende `GetAnonymizerDescription`-Methode auf. Diese `GetAnonymizerDescription`-Methode ersetzen wir, delegieren sie an das `_anonymizerAlgorithm`-Objekt. In der `PrintSummary`-Methode (nur das Wesentliche hervorgehoben):

    {--
    
    ``` csharp
        ... GetAnonymizerDescription() ...
    ```

    --}

    Stattdessen:

    ``` csharp
        ... _anonymizerAlgorithm.GetAnonymizerDescription() ...
    ```

    Ein paar Zeilen weiter unten löschen wir die `GetAnonymizerDescription`-Methode aus der Klasse (ihr Code wurde in die entsprechenden Strategy-Implementierungen verschoben).

Der letzte Schritt ist der Austausch der im `Anonymizer`-Klasse eingebetteten **Fortschrittsverwaltung**:

1. Auch hier delegieren wir die Anfrage an das zuvor eingeführte `_progress`-Objekt. In der `Run`-Methode muss eine Zeile ausgetauscht werden:

    {--

    ``` csharp
    PrintProgress(i);
    ```

    --}

    Stattdessen:

    ``` csharp
    _progress.Report(persons.Count, i);
    ```

2. Löschen wir die `PrintProgress`-Methode, da ihr Code nun in eine passende Strategy-Implementierung verschoben wurde und von der Klasse getrennt ist.

Wir sind fertig, die fertige Lösung befindet sich im "4-Strategy/Strategy-1"-Projekt (falls wir irgendwo stecken geblieben sind oder der Code nicht kompiliert, können wir ihn hier mit der Lösung vergleichen).

### Bewertung der Lösung

Mit der Einführung des Strategy-Musters sind wir fertig. In seiner jetzigen Form wird es jedoch so gut wie nie verwendet. Überprüfen wir unsere Lösung: Ist sie tatsächlich wiederverwendbar, und ist es möglich, den Anonymisierungsalgorithmus sowie die Fortschrittsbehandlung zu ändern, ohne die `Anonymizer`-Klasse zu modifizieren? Dafür müssen wir überprüfen, ob es im Code irgendwo Implementierungsabhängigkeiten gibt.

Leider finden wir solche Stellen. Im Konstruktor ist festgelegt, welche Implementierung des Algorithmus und der Fortschrittsbehandlung erstellt wird. Dies müssen wir unbedingt im Code beachten! Wenn wir den Algorithmus oder den Fortschrittsmodus ändern möchten, müssen wir den Typ hinter dem `new`-Operator in diesen Zeilen ändern, was eine Modifikation der Klasse mit sich bringt.

Viele – völlig zu Recht – betrachten dies in dieser Form nicht als eine echte Strategie-basierte Lösung. Die vollständige Lösung werden wir im nächsten Schritt umsetzen.

## 8. Lösung (4-Strategy/Strategy-2-DI)

:warning: **Dependency Injection (DI)**  
Die Lösung besteht in der Anwendung von **Dependency Injection (kurz DI)**. Das Prinzip dabei ist, dass die Klasse ihre Verhaltensabhängigkeiten (diese sind die Strategy-Implementierungen) nicht selbst instanziiert, sondern diese von außen übergeben bekommt, z. B. als Konstruktorparameter oder sogar als Properties oder Setter-Methoden. Natürlich unter der Verwendung von Schnittstellentypen!

Passen wir die `Anonymizer`-Klasse entsprechend an, sodass wir die Strategy-Implementierungen nicht selbst instanziieren, sondern diese über Konstruktorparameter erhalten:

1. Löschen wir alle drei Konstruktoren.
2. Fügen wir den folgenden Konstruktor hinzu:

    ``` csharp
    public Anonymizer(string inputFileName, IAnonymizerAlgorithm anonymizerAlgorithm, IProgress progress = null)
    {
        ArgumentException.ThrowIfNullOrEmpty(inputFileName);
        ArgumentNullException.ThrowIfNull(anonymizerAlgorithm);

        _inputFileName = inputFileName;
        _anonymizerAlgorithm = anonymizerAlgorithm;
        _progress = progress;
    }
    ```

    Wie zu sehen ist, ist die Angabe des `progress`-Parameters nicht zwingend erforderlich, da der Benutzer der Klasse möglicherweise keine Fortschrittsinformationen benötigt.

3. Da die _progress-Strategie auch null sein kann, müssen wir eine Nullprüfung während der Verwendung einführen. Anstelle des "."-Operators verwenden wir den "?."-Operator:

    ``` csharp
    _progress?.Report(persons.Count,i);
    ```

4. Jetzt sind wir fertig, die `Anonymizer`-Klasse ist vollständig von den Strategy-Implementierungen entkoppelt. Wir haben nun die Möglichkeit, die `Anonymizer`-Klasse mit jeder beliebigen Kombination von Anonymisierungsalgorithmen und Fortschrittsbehandlungen zu verwenden (ohne die Klasse selbst zu ändern). Erstellen wir drei `Anonymizer`-Instanzen mit verschiedenen Kombinationen im `Main`-Methode der `Program.cs`-Datei (löschen wir den bestehenden Code zuvor aus der `Main`-Methode):

    ``` csharp
    Anonymizer p1 = new("us-500.csv",
        new NameMaskingAnonymizerAlgorithm("***"),
        new SimpleProgress());
    p1.Run();

    Console.WriteLine("--------------------");

    Anonymizer p2 = new("us-500.csv",
        new NameMaskingAnonymizerAlgorithm("***"),
        new PercentProgress());
    p2.Run();

    Console.WriteLine("--------------------");

    Anonymizer p3 = new("us-500.csv",
        new AgeAnonymizerAlgorithm(20),
        new SimpleProgress());
    p3.Run();
    ```

5. Um sicherzustellen, dass der Code funktioniert, fügen wir am Anfang der Datei die erforderlichen `using`-Anweisungen ein:

    ``` csharp
    using Lab_Extensibility.AnonymizerAlgorithms;
    using Lab_Extensibility.Progresses;
    ```

Wir sind fertig, die Lösung ist im Projekt "4-Strategy/Strategy-2-DI" zu finden (falls wir irgendwo stecken bleiben oder der Code nicht kompiliert, können wir dies mit der Lösung vergleichen).

!!! Hinweis "Überprüfung der Funktionsweise"
    Während der Übung wird wahrscheinlich keine Zeit für diese Überprüfung bleiben, aber wer sich unsicher ist, "warum das Strategy-Muster funktioniert" und warum sich das Verhalten in den oben genannten vier Fällen unterscheidet, sollte Breakpoints in der `Program.cs`-Datei an den vier `Run`-Funktionsaufrufen setzen und durch die Funktionen im Debugger eintreten, um zu überprüfen, dass immer die richtige Strategy-Implementierung aufgerufen wird.

Im Projekt befindet sich ein Klassendiagramm (`Main.cd`), das die fertige Lösung ebenfalls veranschaulicht:

??? Hinweis "Klassendiagramm der Strategy-basierten Lösung"
    Das folgende UML-Klassendiagramm veranschaulicht unsere Strategy-basierte Lösung:

    ![Strategy DI UML Klassendiagramm](images/strategy-di.png)

### Bewertung der Lösung

Überprüfen wir, ob die Lösung unsere Ziele erreicht:

* Der `Anonymizer` ist zu einer wiederverwendba(re)ren Klasse geworden.
* Wenn in der Zukunft eine neue Anonymisierungslogik benötigt wird, muss nur eine neue `IAnonymizerAlgorithm`-Implementierung eingeführt werden. Dies ist keine Änderung, sondern eine Erweiterung.
* Wenn in der Zukunft eine neue Fortschrittslogik benötigt wird, muss nur eine neue `IProgress`-Implementierung eingeführt werden. Dies ist keine Änderung, sondern eine Erweiterung.
* Die beiden obigen Punkte erfüllen das OPEN/CLOSED-Prinzip, d. h. wir können die Logik des `Anonymizer` anpassen und erweitern, ohne den Code der Klasse zu ändern.
* Hier müssen wir nicht die kombinatorische Explosion für die Template Method befürchten: Jede `IAnonymizerAlgorithm`-Implementierung kann bequem mit jeder `IProgress`-Implementierung verwendet werden, ohne dass neue Klassen für die Kombinationen eingeführt werden müssen (dies haben wir in der `Program.cs`-Datei gesehen).

!!! Note "Weitere Vorteile von Strategy im Vergleich zur Template Method *"
    * Es kann auch ein Verhalten zur Laufzeit ersetzt werden. Wenn es notwendig wäre, dass wir nach der Erstellung eines bestimmten `Anonymizer`-Objekts das Anonymisierungs- oder Progress-Verhalten ändern können, dann könnten wir das leicht tun (wir müssten nur eine `SetAnonimizerAlgorithm`- bzw. `SetProgress`-Methode einführen, in der das erhaltene Implementierung auf das von der Klasse verwendete Strategy gesetzt wird).
    * Unterstützung der Unit-Tests (dies betrachten wir im Labor nicht).