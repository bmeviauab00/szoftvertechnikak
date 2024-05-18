---
autoren: bzolka
---

# 6. Entwurfsmuster (Erweiterbarkeit)

## Das Ziel der Übung

Ziele der Übung (anhand eines komplexeren Beispiels aus dem wirklichen Leben):

- Anwendung einiger Designprinzipien zur Förderung von Skalierbarkeit, Wiederverwendbarkeit, Codetransparenz und Wartbarkeit: SRP, OPEN-CLOSED, DRY, KISS, etc.
- Einige der für die Erweiterbarkeit wichtigsten Entwurfsmuster (Template Method, Strategy, Dependency Injection).
- Zusätzliche Techniken (z.B. Delegate/Lambda-Ausdruck) zur Unterstützung von Skalierbarkeit und Wiederverwendbarkeit mit Entwurfsmustern anwenden und kombinieren.
- Code-Refactoring-Übung.

Verwandte Präsentationen:

- Entwurfsmuster: erweiterungsbezogene Muster (Einführung, Schablonenmethode, Strategie) und das Dependency Injection "Muster".

## Voraussetzungen

Die für die Durchführung der Übung benötigten Werkzeuge:

- Visual Studio 2022

!!! tip "Übung unter Linux oder macOS"
    Das Übungsmaterial ist grundsätzlich für Windows und Visual Studio gedacht, kann aber auch auf anderen Betriebssystemen mit anderen Entwicklungswerkzeugen (z.B. VS Code, Rider, Visual Studio für Mac) oder sogar mit einem Texteditor und CLI (Kommandozeilen)-Tools durchgeführt werden. Dies wird dadurch ermöglicht, dass die Beispiele im Kontext einer einfachen Konsolenanwendung präsentiert werden (keine Windows-spezifischen Elemente) und das .NET 8 SDK auf Linux und macOS unterstützt wird. [Hallo Welt unter Linux](https://learn.microsoft.com/en-us/dotnet/core/tutorials/with-visual-studio-code).

### Theoretischer Hintergrund, Ansatz *

Bei der Entwicklung komplexerer Anwendungen müssen wir eine Reihe von Designentscheidungen treffen, wobei mehrere Optionen zur Auswahl stehen. Wenn wir die Wartungsfreundlichkeit und die Möglichkeit der einfachen Weiterentwicklung unserer Anwendung nicht im Auge behalten, kann die Entwicklung schnell zu einem Alptraum werden. Kundenwünsche nach Änderungen und Erweiterungen erfordern eine umfangreiche kontinuierliche Neuschreibung/Änderung des Codes: Dies führt zu neuen Fehlern und erfordert einen erheblichen Arbeitsaufwand für umfangreiche Code-Neu-Tests!

Unser Ziel ist es, diesen Änderungs- und Erweiterungsbedarf zu decken, indem wir den Code an einigen wenigen, genau definierten Stellen erweitern, ohne den bestehenden Code wesentlich zu verändern. Das Schlüsselwort lautet: **Erweiterung** im Gegensatz zur **Änderung**. Damit zusammenhängend: Wenn bestimmte Logiken erweitert werden können, sind sie auch allgemeiner, und wir können sie leichter in mehr Kontexten verwenden. Langfristig gesehen kommen wir auf diese Weise schneller voran, der Code ist kürzer und doppelter Code wird vermieden (wodurch der Code leichter zu pflegen ist).

Die **Entwurfsmuster** zeigen bewährte Lösungen für einige häufig auftretende Entwurfsprobleme: Diese Lösungen tragen dazu bei, dass unser Code einfacher zu erweitern, zu pflegen und wiederzuverwenden ist. In dieser Übung konzentrieren wir uns auf Muster, Entwurfsprinzipien und einige Programmierwerkzeuge, die bei diesen Problemen helfen können. Aber wir wollen es nicht übertreiben: Es lohnt sich nur dann, ein bestimmtes Entwurfsmuster zu verwenden, wenn es einen echten Nutzen bringt. Andernfalls wird die Implementierung nur unnötig kompliziert. Vor diesem Hintergrund ist es nicht unser Ziel (und oft auch gar nicht möglich), alle zukünftigen Erweiterungsbedürfnisse vorherzusehen oder sehr weit im Voraus darüber nachzudenken. Der Punkt ist, dass wir, selbst wenn wir von einer einfachen Lösung ausgehen und jedes Problem erkennen, unseren Code ständig überarbeiten, um ihn an den richtigen Stellen erweiterbar und wiederverwendbar zu machen, je nach unseren aktuellen Anforderungen (funktional und nicht funktional) und unserer Voraussicht.

Es ist erwähnenswert, dass verwandte Entwurfsmuster und Sprachtools auch sehr dabei helfen, unseren Code **unit-testbar** zu machen: In vielen Unternehmen ist es bei der Entwicklung eines Softwareprodukts eine (legitime) Anforderung an die Entwickler, Unit-Tests mit hoher Codeabdeckung zu erstellen. Dies ist jedoch praktisch unmöglich, wenn die Einheiten/Klassen Ihres Codes zu eng gekoppelt sind.

## 0. Aufgabe - Kennenlernen der Aufgabe und der Erstanwendung

Klonen Sie [das Repository der](https://github.com/bmeviauab00/lab-patterns-extensibility-kiindulo)ursprünglichen Anwendung für Labor 6:

- Öffnen Sie eine Eingabeaufforderung
- Navigieren Sie zu einem Ordner Ihrer Wahl, zum Beispiel c:workNEPTUN
- Geben Sie den folgenden Befehl ein: `git clone https://github.com/bmeviauab00/lab-patterns-extensibility-kiindulo.git`
- Öffnen Sie die Lösung *Lab-Patterns-Extensibility.sln* in Visual Studio.

### Beschreibung der Aufgabe

Im Labor werden wir eine konsolenbasierte Datenverarbeitungsanwendung (genauer gesagt, eine Anonymisierungsanwendung) entsprechend den sich entwickelnden Bedürfnissen erweitern, und zwar an verschiedenen Punkten und mit verschiedenen Techniken. In der ersten Übung wird auch das Konzept der Anonymisierung vorgestellt.

Die Eingabe in die Anwendung ist eine CSV-Textdatei, in der jede Zeile Daten für eine bestimmte Person enthält. Öffnen Sie im Dateisystem die Datei us-500.csv im Ordner *Data* (durch Doppelklick oder mit Notepad/Notepad). Wir sehen, dass wir zwischen "", getrennt durch ein Komma, die Daten für jede Person haben (sie sind nicht real). Schauen wir uns die erste Zeile an:
  
```
"James", "Rhymes", "Benton, John B Jr", "6649 N Blue Gum St", "New Orleans", "Orleans", "LA", "70116", "504-621-8927", "504-845-1427", "30", "65", "Herzbezogen", "jRhymes@gmail.com"
```

Die Person in der ersten Reihe heißt James Rhymes, arbeitet für "Benton, John B Jr.", gefolgt von einigen Adressfeldern, 30 Jahre alt, 65 kg Körpergewicht. Das folgende Feld gibt Auskunft darüber, welche schwerere Krankheit Sie haben (in der Zeile oben ist es "Herzkrankheit"). Die letzte Spalte enthält die E-Mail-Adresse der Person.

??? note "Quelle und genaues Format der Daten *"
    Datenquelle: [https://www.briandunning.com/sample-data/,](https://www.briandunning.com/sample-data/) mit einigen Spalten (Alter, Gewicht, Krankheit). Die Reihenfolge der Felder: Vorname, Nachname, Unternehmen, Adresse, Stadt, Landkreis (falls zutreffend), Bundesland/Provinz (falls zutreffend), Postleitzahl, Telefon 1, Telefon 2, Alter, Gewicht, Krankheit, E-Mail

Die Hauptaufgabe der Anwendung besteht darin, diese Daten entsprechend den aktuellen Bedürfnissen zu anonymisieren und sie dann in eine CSV-Textdatei auszugeben. Der Zweck der Anonymisierung besteht darin, die Daten so umzuwandeln, dass die Personen im Datensatz nicht mehr identifizierbar sind, die Daten aber weiterhin für die Erstellung von Berichten verwendet werden können. Die Anonymisierung ist ein eigener, sehr ernster und anspruchsvoller Bereich der Datenverarbeitung. Die Übung zielt nicht darauf ab, Lösungen zu entwickeln, die in einem realen Kontext anwendbar oder sogar in jeder Hinsicht sinnvoll sind. Für uns ist eigentlich nur der "Einsatz" einer Art von Datenverarbeitungsalgorithmus für die Darstellung von Mustern wichtig. Dies kann einen etwas "aufregenderen" Rahmen bieten als einfache Datenfilterung/ Sequenzierung/etc. basierte Datenverarbeitung (die von .NET standardmäßig unterstützt wird).

!!! note "Einige Gedanken zur Anonymisierung"

    Man könnte meinen, dass die Anonymisierung ein einfaches Problem ist. So müssen Sie beispielsweise nur die Namen der Personen, die Adresse, die Hausnummer, die Telefonnummern und die E-Mail-Adresse entfernen oder mit einem Sternchen versehen, und schon sind Sie fertig. Zum Beispiel würde die erste Zeile unserer Eingabe die Ausgabe sein:

    ```
    "***", "***", "Benton, John B Jr", "***", "New Orleans ", "Orleans", "LA", "70116", "***", "***", "30", "65", "herzbezogen", "***"
    ```

    Dies ist jedoch bei weitem nicht der Fall, insbesondere wenn es um wirklich große Daten geht. Stellen Sie sich ein kleines Dorf vor, in dem es nicht viele Menschen gibt. Nehmen wir an, eine der auf diese Weise anonymisierten Personen ist 14 Jahre alt, aber stark übergewichtig und wiegt 95 kg. Dies ist eine seltene "Kombination", und es besteht eine gute Chance, dass keine andere Person mit diesen Parametern im Dorf lebt. Wenn einer seiner Klassenkameraden (ein Achtklässler, er ist 14) sich die "anonymisierten" Daten ansieht, wird er wissen, wer er ist (es gibt keinen anderen Achtklässler in der Schule, der so übergewichtig ist), er wird die Person identifizieren. Sie werden zum Beispiel wissen, welche Krankheit die Person hat. Lektion: Daten können im Kontext aufschlussreich sein.
    
    Was ist die Lösung? Stadt, Alter und Körpergewicht können nicht gelöscht/gestrichen werden, da sie gemeldet werden müssen. Eine typische Lösung besteht darin, nach der Anonymisierung nicht das genaue Alter/Gewicht einzugeben, sondern Bereiche (d. h. die Daten zu verallgemeinern): z. B. für die oben genannte Person Alter 10..20 Jahre, Gewicht 80..100 kg, und diese Werte für diese Person in die Ausgabedatei einzugeben. Es ist nicht mehr möglich, die Personen zu identifizieren. Wir werden diese Technik später noch anwenden.

### Ursprüngliche Anforderungen

Ursprüngliche Anforderungen an die Bewerbung:

1. Von einem bestimmten Client empfangene Dateien (alle im gleichen Format) müssen mit dem gleichen Anonymisierungsalgorithmus in das gleiche Ausgabeformat konvertiert werden. Die Anonymisierung sollte lediglich darin bestehen, den Vor- und Nachnamen "auszubuchstabieren".
2. Eine gewisse Datenbereinigung ist erforderlich.  `_` `#` In den Eingabedaten kann es am Anfang/Ende der Spalte, die die Stadt enthält, redundante Zeichen geben, die entfernt werden sollten (Trimm-Operation).
3. Nach der Verarbeitung jeder Zeile sollte in die Konsole geschrieben werden, dass die Zeile verarbeitet wurde, und nach der Verarbeitung jeder Zeile sollten einige zusammenfassende Informationen angezeigt werden: wie viele Zeilen verarbeitet wurden und bei wie vielen der Stadtname gekürzt wurde.
4. Ein **entscheidender Punkt**: Die Anwendung wird nur für einen kurzen Zeitraum benötigt, und wir haben nicht die Absicht, sie in Zukunft zu erweitern.

Hinweis: Um mit weniger Feldern im Code zu arbeiten und die Ausgabe transparenter zu gestalten, lassen wir bei der Verarbeitung einige weitere Felder weg.

Ein Beispiel: Die erste Zeile unserer Eingabedatei ist die erwartete Ausgabe:

```
***; ***; LA; New Orleans; 30; 65; Herzbezogen
```

## 1. Lösung - alles in einem (1-Start/Start)

Im Visual Studio Solution Explorer sehen Sie Ordner, deren Namen mit den Zahlen 1 bis 4 beginnen. Diese enthalten die Lösungen für jede Arbeitsiteration. Die Lösung der ersten Runde befindet sich im Ordner "1-Start" unter dem Projektnamen "Start". Schauen wir uns die Dateien im Projekt an:

* `Person.cs` - Sie enthält die Daten einer Person, die für uns von Interesse ist, und wir lesen die Daten einer Person in ihre Objekte ein.
* `Programm.cs` - Die gesamte Logik ist als Funktion dieses Main implementiert, "getrennt" durch Code-Einträge. Wenn die Logik ein wenig komplizierter wird, werden wir nach ein oder zwei Tagen (Stunden?) Schwierigkeiten haben, unseren eigenen Code zu überprüfen und zu verstehen. Wir sollten diese Lösung gar nicht erst in Betracht ziehen.

Insgesamt ist die Lösung sehr einfach, da dem Code keine lange Zukunft vorausgesagt wird. Aber die "skriptartige", in eine Funktion gegossene "All-in-one"-Lösung ist auch nicht der richtige Weg, sie macht es sehr schwierig, den Code **zu sehen** und **zu verstehen**. Lassen Sie uns das nicht weiter betrachten.

## 2. Lösung (2-OrganizedToFunctions/OrganizedToFunctions-1)

Gehen wir in Visual Studio zu der Lösung über, die sich im Projekt "OrganizedToFunctions-1" im Ordner "2-OrganizedToFunctions" befindet. Das ist viel sympathischer, weil wir die Logik in Funktionen zerlegt haben. Schauen wir uns kurz den Code an:

`Anonymizer.cs`

  *  `Laufen lassen` Die Funktion ist das "Rückgrat", sie enthält die Steuerlogik und ruft die für die einzelnen Schritte zuständigen Funktionen auf.
  * `ReadFromInput` `Person` `Person` operation: scannt die Quelldatei, erstellt für jede Zeile ein Objekt und gibt eine Liste der gescannten Objekte zurück.
  * `TrimCityNames`: Führt eine Datenbereinigung durch (Abschneiden von Städtenamen).
  * `Anonym`:  `Person` `Person` Bei jedem gescannten Objekt wird es aufgerufen und ist dafür verantwortlich, ein neues Objekt zurückzugeben, das bereits die anonymisierten Daten enthält.
  * `WriteToOutput` `Person`: schreibt die bereits anonymisierten Objekte in die Ausgabedatei.
  * `PrintSummary`: gibt die Zusammenfassung am Ende der Verarbeitung auf der Konsole aus.

`Programm.cs`

  *  `Anonym` `Laufen lassen` Erzeugt ein Objekt und führt es durch den Aufruf von . Es ist ersichtlich, dass die Zeichenkette, die zur Maskierung während der Anonymisierung verwendet wird, in einem Konstruktorparameter angegeben werden muss.

Probieren wir es aus, lassen wir es laufen! Um dies zu tun, sollte "OrganizedToFunctions-1" das Startprojekt in Visual Studio sein (mit der rechten Maustaste darauf klicken und *als Startprojekt festlegen*), dann starten Sie es:

![Ausgabe auf der Konsole](bilder/OrganizedToFunctions-1-Konsole-out.png)

Die Ausgabedatei kann in einem Dateimanager in einem Ordner mit dem Namen "OrganizedToFunctions-1binDebugnet8.0" oder ähnlichem mit dem Namen "us-500.processed.txt" angezeigt werden. Öffnen wir sie und sehen wir uns die Daten an.

### Bewertung der Lösung

* Die Lösung ist grundsätzlich gut strukturiert und leicht zu verstehen.
* Folgt dem ==**KISS (Keep It Stupid Simple)==** prinzip, ohne unnötige Komplikationen. Das ist gut, denn es gibt keinen potenziellen künftigen Entwicklungsbedarf, keine Notwendigkeit, verschiedene Formate, Logiken usw. zu unterstützen.
* Unsere Lösung folgt jedoch nicht einem der grundlegendsten und bekanntesten Gestaltungsprinzipien, nämlich dem ==**Single Responsibility Principle (kurz: SRP)==** allgemein bekannt als SRP. Sie geht davon aus, dass eine Abteilung - vereinfacht ausgedrückt - nur eine Aufgabe hat (im Grunde nur eine Sache).
  
    *  `Anonym` Unsere Abteilung hat zweifellos viele Aufgaben: Verarbeitung von Input, Datenbereinigung, Anonymisierung, Erstellung von Output usw.
    * Dieses Problem ist in unserem Fall nicht spürbar und stellt kein Problem dar, da die Umsetzung jeder dieser Aufgaben einfach ist und in eine kürzere Funktion "passt". Wären diese jedoch komplexer und in mehreren Funktionen implementiert, müssten sie definitiv in einer eigenen Klasse organisiert werden.

    ??? note "Warum ist es ein Problem, wenn eine Abteilung mehr Aufgaben hat? *"

        * Es ist schwieriger zu verstehen, wie es funktioniert, weil es nicht auf eine Sache konzentriert ist.
        * Wenn eine dieser Zuständigkeiten geändert werden muss, muss eine große, multidisziplinäre Abteilung geändert und erneut getestet werden.
  
* Sie können automatisierte Integrationstests (Input-Output) für die Lösung schreiben, aber keine "echten" Unit-Tests.

## 3. Lösung (OrganizedToFunctions-2-TwoAlgorithms)

Im Gegensatz zu früheren "Plänen" haben sich neue Bedürfnisse der Nutzer ergeben. Unser Kunde hat seine Meinung geändert und verlangt für einen anderen Datensatz einen anderen Anonymisierungsalgorithmus: Das Alter der Personen soll in Banden gespeichert werden, das genaue Alter der Personen darf nicht offenbart werden. Der Einfachheit halber werden wir in diesem Fall die Namen der Personen nicht anonymisieren. Betrachten Sie dies also als eine Art "Pseudo"-Anonymisierung (es macht immer noch Sinn, aber es ist nicht ganz korrekt, es Anonymisierung zu nennen).

Unsere Lösung - die sowohl den alten als auch den neuen Algorithmus (einen nach dem anderen) unterstützt - finden Sie im VS-Lösungsprojekt *OrganizedToFunctions-2-TwoAlgorithms*.  `Anonymizer` Schauen wir uns die Klasse, das Grundprinzip der Lösung an (überprüfen Sie diese im Code):

*  `AnonymizerMode` `Anonym` Wir haben einen Enum-Typ eingeführt, der den Modus (Algorithmus) angibt, in dem die Klasse verwendet wird.
*  `Anonymizer` `Anonymize_MaskName` Die Klasse verfügt über zwei Anonymisierungsoperationen: , `Anonymize_AgeRange`
*  `Anonymizer` `_anonymizerMode` `_anonymizerMode` Die Klasse speichert den zu verwendenden Algorithmus im Member: für die beiden Modi werden zwei separate Konstruktoren eingeführt, die den Wert von .
*  `Anonymizer` `Run` `GetAnonymizerDescription` `_anonymizerMode` Die Klasse prüft an mehreren Stellen (z.B. bei Operationen) auf den Wert von und gabelt sich in Abhängigkeit davon auf.
  *  `GetAnonymizerDescription`In ist dies notwendig, da die Aufgabe dieses Vorgangs darin besteht, eine einzeilige Beschreibung des Anonymisierungsalgorithmus zu erstellen, die am Ende der Verarbeitung in der "Zusammenfassung" angezeigt wird.  `PintSummary` Sehen wir uns den Code für die Aufrufe dieser Aktion an. So sieht die Zusammenfassung auf der Konsole aus, wenn ein Altersanonymisierer mit einem Bereich von 20 Jahren verwendet wird:
  
      ```Summary - Anonymizer (Age anonymizer with range size 20): Persons: 500, trimmed: 2```

### Bewertung der Lösung

Insgesamt ist unsere Lösung in Bezug auf die Codequalität **schlechter** als zuvor. In der Vergangenheit gab es kein Problem damit, dass es in Bezug auf Anonymisierungsalgorithmen nicht erweiterbar war, da es keinen Bedarf dafür gab. Wenn aber einmal die Notwendigkeit besteht, einen neuen Algorithmus einzuführen, ist es ein Fehler, unsere Lösung in dieser Hinsicht nicht erweiterbar zu machen: Von nun an würden wir lieber damit rechnen, dass in Zukunft zusätzliche Algorithmen eingeführt werden müssen.

 `if``switch` Warum behaupten wir, dass unser Code nicht erweitert werden kann, wenn "nur" ein neuer Enum-Wert und eine zusätzliche / Verzweigung an einer Stelle des Codes eingeführt werden soll, wenn ein neuer Algorithmus eingeführt werden soll?

:warning: **Prinzip Offen/Geschlossen**  
Entscheidend ist, dass eine Klasse dann als erweiterbar gilt, wenn es möglich ist, ein neues Verhalten (in unserem Fall einen neuen Algorithmus) einzuführen **, ohne** sie in irgendeiner Weise **zu verändern**, **indem man** einfach den Code **erweitert/erweitert**.  `Anonymizer` Mit anderen Worten, in unserem Fall sollte der Code von nicht angetastet werden, was eindeutig nicht der Fall ist. Dies ist das berühmte **Offen/Geschlossen-Prinzip**: Die Klasse sollte offen für Erweiterungen und geschlossen für Änderungen sein. Die Änderung des Codes ist problematisch, da sie wahrscheinlich neue Fehler einführt und der geänderte Code immer wieder neu getestet werden muss, was einen erheblichen Zeit- und Kostenaufwand bedeutet.

Was genau ist das Ziel und wie können wir es erreichen? Es gibt Teile unseres Klassenzimmers, die wir nicht verbrennen wollen:

* Dies sind keine Daten, sondern ==**verhaltensweisen (Code, Logik)==**.
*  `if``switch` Wir lösen das Problem nicht mit / : Wir führen "Erweiterungspunkte" ein und schaffen es irgendwie, "beliebigen" Code in ihnen laufen zu lassen.
* Wir setzen den Code dieser variablen/fallabhängigen Teile **in andere Klassen** (in einer Weise, die für unsere Klasse "austauschbar" ist)!

!!! note
    Denken Sie nicht an Zauberei, wir werden die Werkzeuge verwenden, die wir bereits kennen: Vererbung mit abstrakten/virtuellen Funktionen, oder Schnittstellen, oder Delegaten.

 `Anonymizer` Suchen Sie nach Teilen, die fallabhängig sind, variable Logik, so dass es nicht gut ist, sie in die Klasse zu brennen:

*  `Anonymize_MaskName`Das eine ist die Anonymisierungslogik selbst: /`Anonymize_AgeRange`
* Die andere ist die `GetAnonymizerDescription`

Diese sollten von der Klasse entkoppelt werden, an diesen Stellen sollte die Klasse erweitert werden. Die folgende Abbildung veranschaulicht das allgemeine Ziel *:

??? note "Veranschaulichung des allgemeinen Lösungsprinzips"

    ![Extensibility illustration](images/illustrate-extensibility.png)

Wir werden uns drei spezifische Entwurfsmuster und -techniken ansehen, um die oben genannten Ziele zu erreichen:

* Vorlage Methodenentwurf Muster
* Strategieentwurfsmuster (einschließlich Dependency Injection)
* Delegate (optional mit Lambda-Ausdruck)

Eigentlich haben wir sie alle in unserem Studium verwendet, aber jetzt werden wir sie noch besser kennen lernen und ihre Verwendung noch umfassender üben. Die ersten beiden im Labor und die dritte in einer entsprechenden Hausaufgabe.

## 4. Lösung (3-TemplateMethod/TemplateMethod-1)

In diesem Schritt werden wir das Entwurfsmuster **Template Method** verwenden, um unsere Lösung an den erforderlichen Stellen erweiterbar zu machen.

!!! note
    Der Name des Musters ist "irreführend": Es hat nichts mit den in C++ erlernten Template-Methoden zu tun!

??? info "Klassendiagramm der auf der Schablonenmethode basierenden Lösung"
    Das folgende UML-Klassendiagramm veranschaulicht die auf der Schablonenmethode basierende Lösung und konzentriert sich auf das Wesentliche:

    ![Template Method UML osztálydiagram cél](images/template-method-goal.png)

Im Beispiel beruht die Trennung zwischen "unveränderlichen" und "veränderlichen" Teilen auf den folgenden Grundsätzen (es lohnt sich, diese im obigen Klassendiagramm zu verstehen, das auf unser Beispiel angewandt wird):

* Die "gemeinsamen/ungemeinsamen" Teile werden in eine Vorgängerklasse eingeordnet.
* Dabei sind die Erweiterungspunkte die Einführung von abstrakten/virtuellen Funktionen, die an den Erweiterungspunkten aufgerufen werden.
* Ihre fallspezifische Implementierung ist in den Nachfolgeklassen untergebracht.

Der bekannte "Trick" besteht darin, dass beim Aufruf der abstrakten/virtuellen Funktionen durch den Vorgänger der fallabhängige Code des Nachfolgers aufgerufen wird.

 `enum` `if``switch` Im Folgenden wird die frühere , oder /-basierte Lösung in eine **Template-Methoden-basierte** Lösung umgewandelt (diese wird keine Aufzählung mehr haben). Wir führen eine Vorgängerklasse und zwei vom Algorithmus abhängige Nachkommen ein.

Wir müssen unseren Code entsprechend umstrukturieren. In der VS-Lösung, im Ordner "3-TemplateMethod", enthält das Projekt "TemplateMethod-0-Begin" den Code unserer vorherigen Lösung (eine "Kopie" davon), lassen Sie uns in diesem Projekt arbeiten:

1.  `Anonymizer` `AnonymizerBase`Benennen Sie die Klasse um in (z. B. indem Sie auf den Klassennamen in der Quelldatei zeigen und ++f2++drücken).
2.  `NameMaskingAnonymizer` `AgeAnonymizer` Fügen Sie eine Klasse und eine Klasse zu dem Projekt hinzu (Rechtsklick auf das Projekt, *Hinzufügen/Klasse*).
3.  `AnonymizerBase`Extrahieren Sie sie aus
4.  `AnonymizerBase` `NameMaskingAnonymizer`Verschieben Sie die entsprechenden Teile von nach :
    1.  `_mask` Die Mitgliedsvariable .
    2.  `string inputFileName, string mask` `NameMaskingAnonymizer`Der Konstruktor, umbenannt in ,
        1. `_anonymizerMode = AnonymizerMode.Name;` zeile wird gelöscht,
        2.  `this` `base` anstelle von .
      
            ??? example "Konstrukteurscode"
      
                ``` csharp
                public NameMaskingAnonymizer(string inputFileName, string mask): base(inputFileName)
                {
                    _mask = mask;
                }
                ```

5.  `AnonymizerBase` `AgeAnonymizer`Verschieben Sie die entsprechenden Teile von nach :
    1.  `_rangeSize` Die Mitgliedsvariable .
    2.  `string inputFileName, string rangeSize` `AgeAnonymizer`Der Konstruktor, umbenannt in ,
        1. `_anonymizerMode = AnonymizerMode.Age;` zeile wird gelöscht,
        2.  `this` `base` anstelle von .

            ??? example "Konstrukteurscode"
      
                ``` csharp
                public AgeAnonymizer(string inputFileName, int rangeSize): base(inputFileName)
                {
                    _rangeSize = rangeSize;
                }
                ```

6.  `AnonymizerBase`Bei :
      1.  `AnonymizerMode` Löschen Sie den Aufzählungstyp .
      2.  `_anonymizerMode` Wir löschen den Tag .

 `AnonymizerBase` Suchen Sie nach Teilen, die fallabhängig sind, nach variabler Logik, so dass Sie diese nicht in die Klasse einbauen wollen, die wiederverwendbar sein soll:

*  `Anonymize_MaskName``Anonymize_AgeRange`Einer ist / ,
*  `GetAnonymizerDescription`das andere ist .

Dem Muster folgend führen wir abstrakte (oder möglicherweise virtuelle) Funktionen für diese in der Vorgängerklasse ein und rufen sie auf, und überschreiben ihre fallabhängigen Implementierungen in den Nachfolgeklassen:

1.  `AnonymizerBase` `class` `abstract` Machen Sie die Klasse abstrakt (das Schlüsselwort vor ).
2.  `AnonymizerBase`Geben wir eine neue URL in

    ``` csharp
    protected abstract Person Anonymize(Person person person);
    ```

    (diese ist für die Anonymisierung zuständig).

3.  `Anonymize_MaskName` `NameMaskingAnonymizer` `Anonymize` Verschieben Sie die Operation in die Klasse und ändern Sie die Signatur so, dass die übergeordnete abstrakte Funktion überschrieben wird:

    ``` csharp
    protected override Person Anonymize(Person person)
    {
        return new Person(_mask, _mask, person.CompanyName,
            person.Address, person.City, person.State, person.Age, person.Weight, person.Decease);
    }
    ```

     `mask` `_mask` Der Funktionskörper muss nur umgeschrieben werden, um die Mitgliedsvariable anstelle des veralteten Parameters zu verwenden.

4.  `Anonymisieren_Altersbereich` `AgeAnonymizer` `Anonymize` In völliger Analogie zum vorherigen Schritt verschieben Sie die Operation in die Klasse und ändern ihre Signatur so, dass die übergeordnete abstrakte Funktion überschrieben wird:

    ``` csharp
    protected override Person Anonymize(Person person)
    {
        ...
    }
    ```

     `rangeSize` `_rangeSize` Der Funktionskörper muss nur umgeschrieben werden, um die Mitgliedsvariable anstelle des veralteten Parameters zu verwenden.

5.  `AnonymizerBase` `Run` `if``else` `Anonymize` In der Funktion der Klasse können wir nun die Aufrufe in / durch einen einfachen abstrakten Funktionsaufruf ersetzen:

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

    stattdessen:

    ``` csharp
    var person = Anonymize(persons[i]);
    ```

Einer unserer Verlängerungspunkte ist fertig.  `GetAnonymizerDescription` Es gibt aber noch eine weitere, die ebenfalls fallspezifisch ist. Die Umwandlung ist der vorherigen Reihe von Schritten sehr ähnlich:

1.  `AnonymizerBase` `GetAnonymizerDescription` `NameMaskingAnonymizer` `override` `NameMaskingAnonymizer`Die Operation der Klasse wird nach , einschließlich des Schlüsselworts in der Signatur, kopiert, wobei nur die Logik für im Funktionskörper verbleibt:

    ``` csharp
    protected override string GetAnonymizerDescription()
    {
        return $"NameMasking anonymizer with mask {_mask}";
    }
    ```

 2.  `AnonymizerBase` `GetAnonymizerDescription` `AgeAnonymizer` `override` `AgeAnonymizer`Kopieren wir die Operation nach , einschließlich des Schlüsselworts in der Signatur, und lassen wir nur die Logik für im Funktionskörper:

    ``` csharp
    protected override string GetAnonymizerDescription()
    {
        return $"Age anonymizer with range size {_rangeSize}";
    }
    ```

3.  `AnonymizerBase` `GetAnonymizerDescription` Die Frage ist, was man mit der Operation in .  `NameMaskingAnonymizer` Dies wird nicht abstrahiert, sondern in eine virtuelle Abhängigkeit umgewandelt, da wir hier ein sinnvolles Standardverhalten bereitstellen können: Wir geben einfach den Namen der Klasse zurück (der für die Klasse z. B. "NameMaskingAnonymizer" lauten würde).  `switch` Auf jeden Fall wird dadurch die starre Struktur beseitigt:

    ``` csharp
    protected virtual string GetAnonymizerDescription()
    {
        return GetType().Name;
    }
    ```

    !!! note "Reflexion"
        `GetType()` `Type` Mit der vom Objektvorgänger geerbten Operation erhalten wir ein Objekt des Typs für unsere Klasse. Dies gehört zum Thema **Reflexion**, über das wir in einer Vorlesung am Ende des Semesters mehr erfahren werden.

 `Programm.cs` `Main` `AnonymizerBase` Es bleibt nur noch eines zu tun: Je nach , versuchen wir nun, den Vorgänger zu replizieren (wegen der früheren Umbenennung). Stattdessen sollte es einer der beiden Abkömmlinge sein. Pl.:

``` csharp
NameMaskingAnonymizer anonymizer = new("us-500.csv", "***");
anonymizer.Run();
```

Wir sind bereit. Probieren wir es aus, um ein besseres "Gefühl" dafür zu bekommen, wie Erweiterungspunkte wirklich funktionieren (aber wenn Sie während des Praktikums wenig Zeit haben, ist das nicht besonders wichtig, wir haben ähnliche Dinge im Zusammenhang mit C++/Java in früheren Semestern getan):

* In Visual Studio sollte das Projekt *TemplateMethod-0-Begin* das Startprojekt sein, wenn es nicht bereits eingestellt ist.
*  `AnonymizerBase` `var person = Anonymize(persons[i]);` Setzen Sie einen Haltepunkt in der Zeile der Klasse.
* Wenn der Debugger hier anhält, während er läuft, ++verwenden Sie f11++zur Eingabe.
*  `AgeAnonymizer` Wir erfahren, dass die Operation des Nachkommens aufgerufen wird.

Wir können einen Blick auf das Klassendiagramm der Lösung werfen:

??? "Template Method based solution class diagram *"
    ![Template Method based solution class diagram](bilder/vorlage-methode.png)

!!! note "`3-TemplateMethod/TemplateMethod-1` Die Lösung für unsere bisherige Arbeit finden Sie im Projekt, falls Sie sie benötigen."

??? "Das Muster heißt Schablonenmethode"
    , weil es sich - am Beispiel unserer Anwendung - um "Schablonenmethoden" handelt, die eine schablonenartige Logik, einen Rahmen, definieren, in dem bestimmte Schritte nicht gebunden sind.  `Run` `PrintSummary` Ihr "Code" wird abstrakten/virtuellen Funktionen überlassen, und ihre Implementierung wird von den abgeleiteten Klassen definiert.

### Bewertung der Lösung

Wir überprüfen die Lösung, um zu sehen, ob sie unsere Ziele erreicht:

*  `AnonymizerBase` Ist eine wiederverwendbare Klasse geworden.
* Wenn in Zukunft eine neue Anonymisierungslogik benötigt wird, leiten wir sie einfach ab. Es handelt sich nicht um eine Änderung, sondern um eine Verlängerung.
* Damit ist das OPEN/CLOSED-Prinzip erfüllt, d.h. wir können die Logik an den beiden im Ahnen angegebenen Stellen anpassen und erweitern, ohne den Code zu verändern.

!!! note "Soll unsere Klasse an allen Stellen erweiterbar sein?"
    `AnonymizerBase` Beachten Sie, dass wir nicht alle Operationen virtuell gemacht haben (und somit die Klasse an vielen Stellen erweitern). Wir haben dies nur dort getan, wo wir glauben, dass die Logik in Zukunft erweitert werden muss.

## 5. Megoldás (3-TemplateMethod/TemplateMethod-2-Progress)

T.f.h ein neuer - relativ einfacher - Bedarf entsteht:

*  `NameMaskinAnonimizer` Für , bleibt die bisherige einfache Fortschrittsanzeige erhalten (nach jeder Zeile wird die Anzahl der erreichten Zeilen ausgegeben),

    ??? note "Illustration des einfachen Fortschritts"
        ![Illustration des einfachen Fortschritts](images/progress-simple.png)

*  `AgeAnonymizer` aber für , sollte die Fortschrittsanzeige anders sein: Sie sollte - nach jeder Zeile aktualisiert - den Prozentsatz der Verarbeitung anzeigen.

    ??? note "Darstellung des prozentualen Fortschritts"
        ![Darstellung des prozentualen Fortschritts](images/fortschritt-prozent.gif)
        
        (Da wir derzeit nur 500 Datenzeilen haben, werden wir dies am Ende unserer Lösung nicht sehen, es wird in kürzester Zeit auf 100 % steigen)

 `Laufen lassen` Die Lösung ist sehr einfach: Wir verwenden das Muster der Schablonenmethode in größerem Umfang in der Operation, führen einen Erweiterungspunkt in den Fortschrittsausdruck ein und überlassen die Implementierung einer virtuellen Funktion.

Springen wir direkt zur fertigen Lösung*(* Projekt*3-TemplateMethod/TemplateMethod-2-Progress* ):

* `AnonymizerBase` `PrintProgress` neue virtuelle Funktion in der Klasse (druckt standardmäßig nichts aus)
* `Run`-bei diesem Gespräch
* `NameMaskingAnonymizer`- `NameMaskingAnonymizer`implementierung (Override) in und
  
Bislang gibt es keine besonderen Lehren, die man ziehen könnte, aber im nächsten Schritt wird es welche geben.

## 6. Lösung (3-TemplateMethod/TemplateMethod-3-ProgressMultiple)

Es ist ein neuer - und völlig logischer - Bedarf entstanden: In Zukunft kann jeder Anonymisierungsalgorithmus mit jeder Fortschrittsdarstellung verwendet werden. Dies bedeutet derzeit vier Kreuzkombinationen:

|Anonym|Progress|
| ------------------- | ----------------- |
|Namensanonymisierer|Einfacher Fortschritt|
|Namensanonymisierer|Prozentualer Fortschritt|
|Altersanonymisierung|Einfacher Fortschritt|
|Altersanonymisierung|Prozentualer Fortschritt|

Springen Sie zur fertigen Lösung*(* Projekt*3-TemplateMethod/TemplateMethod-3-ProgressMultiple* ).  `Haupt.cd` Öffnen Sie statt des Codes das Klassendiagramm im Projekt und überprüfen Sie die Lösung auf der Grundlage dieses Diagramms (oder Sie können das Diagramm unten im Leitfaden sehen).

??? klassendiagramm "Template Method based solution (two aspects)"
    ![Klassendiagramm "Template Method based solution (two aspects)](images/template-method-progress-multiple.png)

Man merkt, dass etwas "nicht stimmt", denn jede Kreuzung musste einen eigenen Nachkommen hervorbringen. Es gibt sogar zusätzliche Zwischenklassen in der Hierarchie, um Code-Duplizierung zu vermeiden. Darüber hinaus:

* Wenn wir in Zukunft einen neuen Anonymisierungsalgorithmus einführen, sollten wir (mindestens) so viele neue Klassen schreiben, wie wir Fortschrittstypen unterstützen.
* Wenn in Zukunft eine neue Verlaufsart eingeführt wird, sollten (mindestens) so viele neue Klassen geschrieben werden, wie Anonymisierungsarten unterstützt werden.

Was hat das Problem verursacht? Die **Notwendigkeit, das Verhalten unserer Klasse um mehrere Aspekte/Dimensionen zu erweitern (in unserem Beispiel Anonymisierung und Fortschritt) und diese in vielen Kreuzkombinationen zu unterstützen**. Müssten wir dies unter neuen Gesichtspunkten tun (z. B. wie man scannt, wie man Output erzeugt), würde das Problem exponentiell "explodieren". In solchen Fällen ist das Entwurfsmuster Template Method nicht anwendbar.

## 7. Lösung (4-Strategie/Strategie-1)

In diesem Schritt werden wir das Entwurfsmuster **Strategy** verwenden, um unsere ursprüngliche Lösung an den erforderlichen Stellen zu erweitern. In der Stichprobe erfolgt die Trennung zwischen "unveränderten/wiederverwendbaren" und "sich ändernden" Teilen nach folgenden Grundsätzen:

* Die "gemeinsamen/ungemeinsamen" Teile werden in einer Klasse zusammengefasst (dieses Mal jedoch nicht als "Elternklasse").
* Im Gegensatz zur Template-Methode verwenden wir Komposition (Containment) statt Vererbung: Wir verlassen uns auf andere Objekte, die als Schnittstellen enthalten sind, um das Verhalten an Erweiterungspunkten zu implementieren (anstelle von abstrakten/virtuellen Funktionen).
* Wir tun dies unabhängig für jeden Aspekt/Dimension des Klassenverhaltens, den wir austauschbar/erweiterbar machen wollen. Wie wir sehen werden, wird dadurch die kombinatorische Explosion vermieden, die wir im vorherigen Kapitel gesehen haben.

Dies ist in der Praxis viel einfacher, als es sich in der Schrift anfühlt (wir haben es in unseren früheren Studien schon einige Male verwendet). Um das zu verstehen, betrachten wir unser Beispiel.

Als Nächstes wollen wir das Klassendiagramm betrachten, das die strategiebasierte Lösung veranschaulicht (aufbauend auf der Erklärung, die dem Diagramm folgt).

??? info "Klassendiagramm der strategiebasierten Lösung"
    Das folgende UML-Klassendiagramm veranschaulicht die strategiebasierte Lösung und konzentriert sich auf das Wesentliche:

    ![Strategy UML osztálydiagram cél](imagesstrategy-goal.png)

Der erste Schritt bei der Verwendung des Strategiemusters besteht darin, zu bestimmen, **wie viele verschiedene Aspekte des Klassenverhaltens** Sie erweiterbar machen wollen. In unserem Beispiel gibt es zwei davon - zumindest im Moment:

* Anonymisierungsbezogenes Verhalten mit zwei Aktionen:
    * Anonymisierungslogik
    * Definition der Beschreibung der Anonymisierungslogik (Generierung eines Beschreibungsstrings)
* Fortschreitende Behandlung mit einer Aktion:
    * Fortschritt zeigen

Der schwierige Teil ist geschafft, von nun an können Sie im Wesentlichen mechanisch nach dem Strategiemuster arbeiten:

1. Für jeden der oben genannten Aspekte sollte eine Strategie-Schnittstelle mit den oben definierten Operationen eingeführt werden, und die entsprechenden Implementierungen sollten vorbereitet werden.
2.  `Anonym` In der Klasse sollte eine Mitgliedsvariable der Strategie-Schnittstelle eingeführt werden, und die aktuell konfigurierten Strategie-Implementierungsobjekte sollten in den Erweiterungspunkten über diese Mitgliedsvariablen verwendet werden.

Diese Elemente sind in dem obigen Klassendiagramm dargestellt. Kommen wir nun zum Code. Unsere Startumgebung befindet sich im Ordner "4-Strategy" im Projekt "Strategy-0-Begin", lassen Sie uns darin arbeiten. Dies ist dieselbe Lösung mit enum, die als Ausgangspunkt für das Muster Template Method verwendet wurde. 

### Anonymisierungsstrategie

Wir beginnen mit der **Anonymisierungsstrategie/dem Anonymisierungsaspekt**. Implementieren Sie die entsprechende Schnittstelle:

1.  `AnonymizerAlgorithms` Erstellen Sie im Projekt einen Ordner mit dem Namen (klicken Sie mit der rechten Maustaste auf das Projekt "Strategy-0-Begin" und dann auf das Menü " *Add/New Folder* "). Legen Sie in den nächsten Schritten jede Schnittstelle und jede Klasse in eine eigene Quelldatei mit eigenem Namen, wie üblich!
2.  `IAnonymizerAlgorithmus` Fügen Sie in diesem Ordner eine Schnittstelle mit dem folgenden Code hinzu:

    ``` csharp title="IAnonymizerAlgorithm.cs"
    public interface IAnonymizerAlgorithm
    {
        Person Anonymize(Person person);
        string GetAnonymizerDescription() => GetType().Name;
    }
    ```

     `GetAnonymizerDescription` Wir können auch für die Operation beobachten, dass wir in modernem C#, wenn wir wollen, Standardimplementierungen für jede Schnittstellenoperation geben können!

Wir bauen jetzt eine Implementierung dieser Schnittstelle für die Anonymisierung von **Namen** (d.h. wir bauen eine Strategieimplementierung). 

1.  `NameMaskingAnonymizerAlgorithm` Fügen Sie demselben Ordner eine Klasse hinzu.
2.  `Anonymizer` `NameMaskingAnonymizerAlgorithm` `_mask` Verschieben Sie in der Klasse die entsprechende Mitgliedsvariable nach :
3.  `NameMaskingAnonymizerAlgorithm`Fügen Sie den folgenden Konstruktor zu :

    ``` csharp
    public NameMaskingAnonymizerAlgorithm(string mask)
    {
        _mask = mask;
    }
    ```

4.  `IAnonymizerAlgorithmus` Machen Sie die Schnittstelle verfügbar.  `: IAnonymizerAlgorithmus` Nachdem Sie die Schnittstelle nach dem Klassennamen eingegeben haben, empfiehlt es sich, das Skelett der Operationen mit Visual Studio zu generieren: Setzen Sie den Cursor auf den Schnittstellennamen (klicken Sie ihn im Quellcode an), verwenden Sie die Tastenkombination 'ctrl' + '.', und wählen Sie dann "Schnittstelle implementieren" aus dem erscheinenden Menü.  `GetAnonymizerDescription` `Anonymize` Hinweis: Da es eine Standardimplementierung für die Operation in der Schnittstelle gibt, wird nur die Operation generiert, aber das ist für uns erst einmal in Ordnung. 
5.  `Anonymizer` `Anonymize_MaskName` `NameMaskingAnonymizerAlgorithm``Anonymize`Verschieben Sie die Wurzel der Operation von der Klasse nach .  `mask` `_mask` Der Funktionskörper muss nur umgeschrieben werden, um die Mitgliedsvariable anstelle des nicht mehr vorhandenen Parameters zu verwenden.  `Anonymize` `Anonymize_MaskName`Die Klasse wird gelöscht.
6.  `GetAnonymizerDescription`Wir wenden uns nun der Implementierung des Betriebs der Strategie-Schnittstelle zu.  `Anonymizer` `GetAnonymizerDescription` `NameMaskingAnonymizerAlgorithm`Kopieren Sie die Operation der Klasse nach , wobei Sie nur die Logik der Namensanonymisierung im Funktionskörper belassen und die Operation öffentlich machen:

    ``` csharp
    public string GetAnonymizerDescription()
    {
        return $"NameMasking anonymizer with mask {_mask}";
    }  
    ```

8. ??? example "Damit ist unsere Strategieimplementierung für die Namensanonymisierung abgeschlossen, der vollständige Code lautet wie folgt"

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

 `IAnonymizerAlgorithm` Im nächsten Schritt werden wir eine Implementierung unserer Strategie-Schnittstelle zur **Altersanonymisierung** vorbereiten.

1.  `AgeAnonymizerAlgorithm` Fügen Sie im gleichen Ordner eine Klasse hinzu (AnonymizerAlgorithms).
2.  `Anonymizer` `AgeAnonymizerAlgorithm` `_rangeSize` Verschieben Sie in der Klasse die entsprechende Mitgliedsvariable nach :
3.  `AgeAnonymizerAlgorithm`Fügen Sie den folgenden Konstruktor zu :

    ``` csharp
    public AgeAnonymizerAlgorithm(int rangeSize)
    {
        _rangeSize = rangeSize;
    }
    ```

4.  `IAnonymizerAlgorithm` Machen Sie die Schnittstelle verfügbar.  `: IAnonymizerAlgorithm` `Anonymize` Nachdem Sie die Schnittstelle nach dem Klassennamen eingegeben haben, empfiehlt es sich auch, das Skelett der Operation mit Visual Studio auf dieselbe Weise wie zuvor zu generieren. 
5.  `Anonymizer` `Anonymize_AgeRange` `AgeAnonymizerAlgorithm``Anonymize`Verschieben Sie die Wurzel der Operation von der Klasse nach .  `rangeSize` `_rangeSize` Der Funktionskörper muss nur umgeschrieben werden, um die Mitgliedsvariable anstelle des nicht mehr vorhandenen Parameters zu verwenden.  `Anonymize` `Anonymize_AgeRange`Die Klasse wird gelöscht.
6.  `GetAnonymizerDescription`Wir wenden uns nun der Implementierung des Betriebs der Strategie-Schnittstelle zu.  `Anonymizer` `GetAnonymizerDescription` `AgeAnonymizerAlgorithm`Kopieren Sie die Operation der Klasse nach , wobei Sie nur die Logik der Altersanonymisierung im Funktionskörper beibehalten und die Operation öffentlich machen:

    ``` csharp
    public string GetAnonymizerDescription()
    {
        return $"Age anonymizer with range size {_rangeSize}";
    } 
    ```

7. ??? example "Ezzel a kor anonimizáláshoz tartozó strategy implementációnk elkészült, a teljes kódja a következő lett"

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


warning:exclamation: Beachten Sie, dass die Schnittstelle und ihre Implementierungen sich nur mit der Anonymisierung befassen und keine andere Logik (z.B. Fortschrittsverarbeitung) involviert ist!

### Strategie für den Fortschritt

Im nächsten Schritt stellen wir die Schnittstelle und die Implementierungen **für das Fortschrittsmanagement** vor:

1.  `Progresses` Erstellen Sie im Projekt einen Ordner mit dem Namen . In den nächsten Schritten legen Sie jede Schnittstelle und Klasse wie üblich in einer eigenen Quelldatei mit eigenem Namen ab.
2.  `IProgress` Fügen Sie in diesem Ordner eine Schnittstelle mit dem folgenden Code hinzu:

    ??? example "Lösung"

        ``` csharp title="IProgress.cs"
        public interface IProgress
        {
            void Report(int count, int index);
        }
        ```

3. Fügen Sie die Implementierung dieser Schnittstelle für einfache Fortschritte in denselben Ordner ein.  `Anonymizer` `PrintProgress` Die Implementierung ist von der Operation unserer Klasse "abgeleitet":

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

4. Nehmen Sie die Implementierung dieser Schnittstelle für den prozentualen Fortschritt in denselben Ordner auf. Wir wollen uns nicht mit der Auslegung des Gesetzes befassen.  `Anonym` In unserer Klasse gibt es dafür keine Lösung, da wir sie nur in unserer auf Vorlagenmethoden basierenden Lösung eingeführt haben (wir haben uns den Code dort nicht angesehen, aber er ist praktisch derselbe):

    ??? example "Lösung"

        ``` csharp title="PercentProgress.cs"
        public class PercentProgress: IProgress
        {
            public void Report(int count, int index)
            {
                int percentage = (int)((double)(index+1) / count * 100);

                Console.Write($"rProcessing: {percentage} %");

                if (index == count - 1)
                    Console.WriteLine();
            }
        }
        ```

:exclamation: Beachten Sie, dass sich die Schnittstelle und ihre Implementierungen nur mit der Fortschrittsverarbeitung befassen und keine andere Logik (z.B. Anonymisierung) involviert ist!

### Anwendung der Strategien

Der nächste wichtige Schritt besteht darin, die anonymisierende Basisklasse mit Hilfe der oben vorgestellten Strategien wiederverwendbar und erweiterbar zu machen.  `Anonymizer.cs` Bei :

1. Löschen Sie Folgendes:
      * `AnonymizerMode` aufzählungstyp
      * `_anonymizerMode` `_mask` `_rangeSize` mitglied (oder und Mitglieder, wenn Sie schon einmal hier gewohnt haben)
  
2. Einführung eines einzigen Strategie-Schnittstellentyp-Tags:

    ``` csharp
    private readonly IProgress _progress;
    private readonly IAnonymizerAlgorithm _anonymizerAlgorithm;
    ```

3. Fügen Sie die entsprechende Verwendung am Anfang der Datei ein:

    ``` csharp
    mit Lab_Extensibility.AnonymizerAlgorithms;
    mit Lab_Extensibility.Progresses;
    ```

4.  `_progress` `_anonymizerAlgorithm` Der anfängliche Wert von und, der im vorigen Abschnitt eingeführt wurde, ist Null. Im Konstruktor werden diese Referenzen auf die Implementierung gesetzt, die Ihren Anforderungen entspricht. Pl.:

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

 `Anonymizer` `_anonymizerAlgorithm` In der Klasse wird die derzeit implementierte, aber **von der Anonymisierung abhängige** Logik der Strategieimplementierung überlassen, auf die die Mitgliedsvariable verweist:

1.  `Run` `if``else` `Anonymize` `_anonymizerAlgorithm` Als eine Funktion der Klasse werden die Aufrufe im /-Ausdruck nun an das Objekt delegiert:

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

    stattdessen:

    ``` csharp
    Person person = _anonymizerAlgorithm.Anonymize(persons[i]);
    ```

2.  `Anonymize_MaskName` `Anonymize_AgeRange` Falls noch nicht geschehen, löschen Sie die Funktionen und, da ihr Code bereits in die Strategieimplementierungen aufgenommen wurde, die von der Klasse entkoppelt sind.

4.  `PrintSummary` `switch` `GetAnonymizerDescription`Unsere Funktion ruft den unflexiblen , basierend auf auf.  `GetAnonymizerDescription` `_anonymizerAlgorithm` Dieser Aufruf an wird durch eine Delegation an das Objekt ersetzt.  `PrintSummary` In der Funktion (nur zur Hervorhebung der Grundzüge):

    ``` csharp
        ... GetAnonymizerDescription() ...
    ```

    stattdessen:

    ``` csharp
        ... _anonymizerAlgorithm.GetAnonymizerDescription() ...
    ```

     `GetAnonymizerDescription` Ein paar Zeilen weiter unten wird die Funktion aus der Klasse entfernt (ihr Code ist in den entsprechenden Strategieimplementierungen enthalten).

 `Anonymizer` Der letzte Schritt besteht darin, den **Progress-Handler** in der Klasse zu ersetzen:

1.  `_progress` Auch hier delegieren wir die Anfrage an unser zuvor eingeführtes Objekt.  `Run` Sie müssen eine Zeile in der Funktion ersetzen:

    {--

    ``` csharp
    PrintProgress(i);
    ```

    --}

    stattdessen:

    ``` csharp
    _progress.Report(persons.Count, i);
    ```

2.  `PrintProgress` Löschen Sie die Funktion, da sich ihr Code bereits in einer eigenen Strategieimplementierung befindet, die von der Klasse entkoppelt ist.

Wir sind fertig, die fertige Lösung befindet sich im Projekt "4-Strategy/Strategy-1" (wenn Sie irgendwo stecken bleiben oder der Code sich nicht kompilieren lässt, können Sie ihn damit überprüfen).

### Bewertung der Lösung

Wir sind mit der Umsetzung der Strategievorlage fertig. In seiner jetzigen Form wird es jedoch fast nie verwendet.  `Anomymizer` Überprüfen wir unsere Lösung: Ist sie wirklich wiederverwendbar, und ist es möglich, den Anonymisierungsalgorithmus und die Fortschrittsbehandlung zu ändern, ohne die Klasse zu modifizieren? Dazu müssen Sie prüfen, ob es irgendwo in der Klasse Code gibt, der von der Implementierung abhängig ist.

Leider finden wir sie. Der Konstruktor wird in die Algorithmus-Implementierung eingebrannt und die Fortschrittsimplementierung wird erstellt. Achten Sie darauf, dies im Code zu überprüfen!  `neu` Wenn Sie den Algorithmus oder den Fortschrittsmodus ändern wollen, müssen Sie den Typ nach dem Operator in diesen Zeilen umschreiben, wodurch sich die Klasse ändert.

Viele halten sie - zu Recht - nicht einmal in ihrer jetzigen Form für eine echte strategiebasierte Lösung. Die vollständige Lösung wird im nächsten Schritt umgesetzt.

## 8. Megoldás (4-Strategy/Strategy-2-DI)

:warning: **Dependency Injection (DI)**  
Die Lösung heißt **Dependency Injection (kurz: DI)**. Die Idee ist, dass die Klasse selbst ihre Verhaltensabhängigkeiten nicht instanziiert (dies sind Strategieimplementierungen), sondern wir sie von außen an sie weitergeben, z. B. in Konstruktorparametern oder sogar in Form von Eigenschaften oder Setter-Operationen. Das wird natürlich als Schnittstellentyp bezeichnet!

 `Anonymizer` Strukturieren Sie die Klasse entsprechend um, so dass sie die Strategieimplementierungen nicht selbst instanziiert, sondern sie als Konstruktorparameter erhält:

1. Alle drei Konstruktoren löschen
2. Betrachten Sie den folgenden Konstruktor:

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

     `progress` Wie Sie sehen können, ist der Parameter optional, da der Benutzer der Klasse möglicherweise keine Fortschrittsinformationen sehen möchte.

3. Da die _progress-Strategie null sein kann, muss bei ihrer Verwendung ein Nulltest eingeführt werden. Der Operator "." wird durch den Operator "?." ersetzt:

    ``` csharp
    _progress?.Report(persons.Count,i);
    ```

4.  `Anonymizer` Jetzt sind wir fertig, die Klasse ist völlig unabhängig von Strategieimplementierungen.  `Anonymizer` Es ist möglich, die Klasse mit einer beliebigen Kombination von Anonymisierungsalgorithmen und einer beliebigen Verlaufsbehandlung zu verwenden (ohne sie zu modifizieren).  `Anonymizer` `Program.cs` `Main` `Main` Lassen Sie uns auch drei mit verschiedenen Kombinationen der Datei in der Funktion erstellen (der vorhandene Code wird zuerst aus der Funktion gelöscht):

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

5.  `using`Um den Code zum Kochen zu bringen, fügen Sie am Anfang der Datei das Notwendige ein

    ``` csharp
    using Lab_Extensibility.AnonymizerAlgorithms;
    using Lab_Extensibility.Progresses;
    ```

Wir haben es getan, und die fertige Lösung ist im Projekt "4-Strategy/Strategy-2-DI" zu finden (wenn Sie irgendwo stecken bleiben oder der Code sich nicht kompilieren lässt, können Sie ihn damit überprüfen).

!!!  `Program.cs` `Run` Hinweis "Überprüfen der Funktionsweise" In der Übung wird wahrscheinlich keine Zeit dafür sein, aber wenn Sie sich nicht sicher sind, "warum das Strategiemuster funktioniert", warum sich das Verhalten in den vier oben genannten Fällen unterscheidet: Es lohnt sich, in der Datei Haltepunkte für die vier Funktionsaufrufe zu setzen und die Funktionen im Debugger aufzurufen, um zu testen, dass immer die richtige Strategieimplementierung aufgerufen wird.

`Main.cd`Es gibt ein Klassendiagramm im Projekt ( ), wo Sie auch die fertige Lösung sehen können:

??? note "Klassendiagramm der strategiebasierten Lösung"
    Das folgende UML-Klassendiagramm veranschaulicht unsere strategiebasierte Lösung:

    ![Strategy DI UML osztálydiagram](imagesstrategy-di.png)

### Bewertung der Lösung

Wir überprüfen die Lösung, um zu sehen, ob sie unsere Ziele erreicht:

*  `Anonym` Ist eine wiederverwendbare Klasse geworden.
*  `IAnonymizerAlgorithmus` Wenn in Zukunft eine neue Anonymisierungslogik benötigt wird, muss lediglich eine neue Implementierung eingeführt werden. Es handelt sich nicht um eine Änderung, sondern um eine Verlängerung/Erweiterung.
*  `IProgress` Wenn in Zukunft eine neue Fortschrittslogik benötigt wird, ist lediglich eine neue Implementierung erforderlich. Es handelt sich nicht um eine Änderung, sondern um eine Verlängerung.
*  `Anonymizer` In den beiden oben genannten Punkten ist das OPEN/CLOSED-Prinzip erfüllt, d.h. wir können die Logik von anpassen und erweitern, ohne den Code zu verändern.
*  `IAnonymizerAlgorithm` `IProgress` `Program.cs` Hier ist die kombinatorische Explosion, wie sie bei der Schablonenmethode auftritt, nicht zu befürchten: Jede Implementierung kann bequem mit jeder Implementierung verwendet werden, ohne dass neue Klassen für Kombinationen eingeführt werden müssen (wir haben dies in der Datei gesehen).

!!! Hinweis "Zusätzliche Strategievorteile gegenüber der Template-Methode *"
   * On the fly-Verhalten kann implementiert werden.  `Anonymizer` `SetAnonimizerAlgorithm` `SetProgress` Wenn wir in der Lage sein müssten, das Anonymisierungs- oder Fortschrittsverhalten für ein bestimmtes Objekt nach seiner Erstellung zu ändern, könnten wir das leicht tun (wir müssten nur einen , oder eine Operation einführen, bei der wir die von der Klasse verwendete Strategie auf die im Parameter angegebene Implementierung setzen könnten).
   * Unterstützung der Testbarkeit von Einheiten (wir sehen uns das im Labor nicht an).