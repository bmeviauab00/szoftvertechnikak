---
autoren: bzolka
---

# 6. HF - Entwurfsmuster (Erweiterbarkeit)

In der Hausaufgabe werden wir die Datenverarbeitungs-/Anonymisierungsanwendung entwickeln, die im zugehörigen Labor[(Labor 6 - Entwurfsmuster (Erweiterbarkeit)](../../labor/5-entwurfsbeispiele/index.md)) begonnen wurde.

Die eigenständige Aufgabe baut auf den in den Vorlesungen vorgestellten Entwurfsmustern auf:
- "Vorlesung 08 - Entwurfsmuster 1" Vortrag: großes Kapitel "Grundlegende Entwurfsmuster in Bezug auf Erweiterbarkeit und Ausdehnung": Einführungsbeispiel, Template-Methode, Strategie, Open/Closed-Prinzip, SRP-Prinzip, andere Techniken (Methodenreferenz/Lambda)
- "Vorlesung 09 - Entwurfsmuster 1" Vortrag: Dependency Injection Muster

 [Übung 6 - Entwurfsmuster (Erweiterbarkeit)](../../labor/5-tervezesi-mintak/index_ger.md) liefert den praktischen Hintergrund für die Übungen.

Das Ziel der unabhängigen Übung:

- Verwendung von verwandten Entwurfsmustern und anderen Erweiterbarkeitstechniken
- Übung der Konzepte von Integrations- und Einheitstests

Die erforderliche Entwicklungsumgebung wird [hier](../fejlesztokornyezet/index_ger.md) beschrieben. Diese Hausaufgabe erfordert keine WinUI (sie muss im Kontext einer konsolenbasierten Anwendung durchgeführt werden), kann also in einer Linux/MacOS-Umgebung erledigt werden.

## Das Verfahren für die Einreichung

- Der grundlegende Prozess ist derselbe wie zuvor. Erstellen Sie mit GitHub Classroom ein Repository für sich selbst. Sie finden die Einladungs-URL in Moodle (Sie können sie sehen, indem Sie auf den Link*"GitHub classroom links for homework*" auf der Startseite des Fachs klicken). Es ist wichtig, dass Sie die richtige Einladungs-URL für diese Hausaufgabe verwenden (jede Hausaufgabe hat eine andere URL). Klonen Sie das resultierende Repository. Dazu gehört auch die erwartete Struktur der Lösung. Nachdem Sie die Aufgaben erledigt haben, übergeben Sie Ihre Lösung alt und drücken Sie sie alt.
- Um mit den geklonten Dateien zu arbeiten, öffnen Sie `Patterns-Extensibility.sln`.
- :Ausruf: In den Übungen werden Sie aufgefordert, **einen Screenshot von** einem Teil Ihrer Lösung zu machen, da dies beweist, dass Sie Ihre Lösung selbst erstellt haben. **Der erwartete Inhalt der Screenshots ist immer in der Aufgabe angegeben.
**Die Screenshots sollten als Teil der Lösung eingereicht werden, legen Sie sie in den Stammordner Ihres Repositorys (neben neptun.txt).
Die Screenshots werden dann zusammen mit dem Inhalt des Git-Repositorys auf GitHub hochgeladen.
Da das Repository privat ist, ist es für niemanden außer den Ausbildern sichtbar.
Wenn Sie Inhalte im Screenshot haben, die Sie nicht hochladen möchten, können Sie diese aus dem Screenshot ausblenden.
- :Ausruf: Diese Aufgabe enthält keinen sinnvollen Pre-Checker: Sie wird nach jedem Push ausgeführt, prüft aber nur, ob neptun.txt gefüllt ist. Die inhaltliche Überprüfung wird von den Laborleitern nach Ablauf der Frist durchgeführt.

## 1. Verfasst am

Die Hausaufgaben basieren auf den folgenden Punkten:

- Kenntnisse der Strategie und des zugehörigen Entwurfsmusters Dependency Injection (DI)
- Genaues Verständnis der Anwendung dieser Proben im Kontext der Aufgabe des Labors (Anonymisierung)

Der Ausgangszustand der Hausaufgabe entspricht dem Endzustand von Labor 6: Diese Hausaufgabenlösung ist das Projekt "Strategie-DI". Um zu starten/booten, müssen Sie dieses Projekt als Startprojekt festlegen (Rechtsklick,*"Als Startprojekt festlegen*"). Sehen Sie sich den Quellcode genau an und verstehen Sie ihn.

- Die Datei `Program.cs` enthält drei `Anonymizer`, die mit verschiedenen Strategieimplementierungen parametrisiert sind. Um sich daran zu gewöhnen, lohnt es sich, sie nacheinander auszuprobieren/auszuführen und zu sehen, ob die Anonymisierung und Fortschrittsbehandlung tatsächlich gemäß der gewählten Strategieimplementierung erfolgt (zur Erinnerung aus dem Labor: die Anonymisierungseingabe ist us-500.csv im Ordner "binDebugnet8.0", die Ausgabe ist "us-500.processed.txt" im selben Ordner).
- Es lohnt sich auch, den Code ab `Program.cs` zu durchlaufen und Haltepunkte zu setzen (dies kann auch zur Wiederholung und zum Verständnis beitragen). 

!!! note "Dependency Injection (manuell) vs. Dependency Injection Container"
    Im Labor und in dieser Hausaufgabe werden wir eine einfache, manuelle Version von Dependency Injection verwenden (die auch in der Vorlesung verwendet wurde). In diesem Fall werden die Klassenabhängigkeiten manuell instanziiert und im Klassenkonstruktor übergeben. Für alternative und komplexere Anwendungen wird häufig ein Dependency Injection Container verwendet, in dem Sie für jeden Schnittstellentyp registrieren können, welche Implementierung Sie verwenden möchten. Wir haben diese Technik "zufällig" im MVVM-Labor verwendet, aber die Verwendung von DI-Containern ist nicht Teil des Lehrplans. Die manuelle Version ist jedoch von entscheidender Bedeutung, denn ohne sie ist die Verwendung des Strategiemusters sinnlos.

:warning: Beantworten Sie in eigenen Worten die folgenden Fragen in der Datei `readme.md` im Ordner " *Aufgaben"*:

- Was bietet die Strategie in Kombination mit der DI-Probe im Laborbeispiel, welche Vorteile ergeben sich aus ihrer gemeinsamen Verwendung?
- Was bedeutet es, dass durch die Verwendung des Strategiemusters das Open/Closed-Prinzip in der Lösung umgesetzt wird? (Sie können über das Open/Closed-Prinzip in den Vorlesungs- und Übungsunterlagen lesen).

## 2. Aufgabe - Null-Strategie

Die Untersuchung der Parameter des Konstruktors `Anonymizer` zeigt, dass `null` als Fortschrittsstrategie angegeben werden kann. Das ist logisch, denn der Nutzer von `Anonymizer` ist möglicherweise nicht an einer Fortschrittsanzeige interessiert. Dieser Ansatz hat einen Nachteil. In diesem Fall ist die Member-Variable `_progress` in der Klasse null, so dass die Null-Prüfung erforderlich ist, wenn sie angewendet wird. Überprüfen Sie, ob bei der Verwendung von `_progess` mit dem Operator `?.` tatsächlich ein Null-Scan durchgeführt wird. Aber das ist ein gefährliches Spiel, denn wenn in komplexeren Fällen auch nur eine einzige Nullprüfung übersehen wird, erhält man zur Laufzeit `NullReferenceException`. Nullreferenzfehler wie dieser gehören zu den häufigsten.

Aufgabe: Erarbeiten Sie eine Lösung, die die oben erwähnte Möglichkeit des Scheiterns ausschließt. Hinweis: Sie benötigen eine Lösung, bei der das Tag `_progress` niemals Null sein kann. Versuchen Sie zunächst, die Lösung selbst zu finden.

??? tip "Lösungsprinzip"
    Der "Trick" zur Lösung ist folgender. Es sollte eine Implementierung der Strategie `IProgress` (z. B. `NullProgress` ) erstellt werden, die verwendet wird, wenn keine Fortschrittsinformationen benötigt werden. Diese Implementierung tut nichts während des "Fortschritts", der Funktionskörper ist leer. Wenn der Konstruktor von `Anonymizer` null als Klasseninstanzfortschritt angibt, erstellen Sie ein Objekt `NullProgress` im Konstruktor und setzen Sie das Mitglied `_progress` auf dieses. Jetzt kann `_progress` niemals null sein, und die Nullprüfung sollte aus dem Code entfernt werden.

    Diese Technik hat auch einen Namen: **Null-Objekt**.

## 3. Aufgabe - Prüfbarkeit

Beachten Sie, dass es noch viele Aspekte der Klasse `Anonymizer` gibt, die durch eine unserer Lösungen erweitert werden könnten. Dazu gehören unter anderem:

* Verwaltung der **Eingaben**: Jetzt wird nur noch das dateibasierte, spezifische CSV-Format unterstützt.
* **Output-Management**: Jetzt wird nur noch das dateibasierte, spezifische CSV-Format unterstützt.

Sie sollten aufgrund des SRP-Prinzips von der Klasse getrennt und in eine andere Klasse versetzt werden (lesen Sie, was das SRP-Prinzip bedeutet). Die Entkopplung sollte nicht bedingungslos erweiterbar sein, da es nicht notwendig ist, mit verschiedenen Ein- und Ausgängen arbeiten zu können. Daher würde die Strategieprobe nicht für die Trennung verwendet werden.

Es gibt jedoch noch einen weiteren kritischen Aspekt, der nicht diskutiert wurde (und in der älteren, klassischen Entwurfsmusterliteratur nicht unbedingt erwähnt wird). Dies ist die Testbarkeit von Einheiten.

Im Moment können wir automatische **Integrationstests** für unsere Klasse `Anonymizer` schreiben, aber keine automatischen **Unit-Tests**:

* Die Integrationstests testen den gesamten Vorgang in einem: Sie umfassen die Eingabeverarbeitung, die Datenverarbeitung und die Ausgabeerzeugung. In unserem Beispiel ist es ganz einfach: Halten Sie einige CVS-Eingabedateien an und prüfen Sie, ob die erwartete Ausgabedatei erzeugt wird.
* Integrationstests können sehr langsam sein: Sie nehmen häufig Eingaben aus Dateien, Datenbanken oder Cloud-basierten Diensten entgegen oder dienen als Ausgabe. Bei einem größeren Produkt - wenn es viele Tausende von Tests gibt - ist diese Langsamkeit ein begrenzender Faktor, wir können weniger oft testen und/oder wir können keine gute Testabdeckung erreichen.

Aus diesem Grund erreichen wir eine höhere Codeabdeckung oft nicht mit langsameren **Integrationstests**, sondern mit sehr schnellen **Unit-Tests**. Sie **testen eine einzelne logische Einheit im Code ohne langsamen Datei-/Datenbank-/Netzwerk-/Cloud-Zugriff**, aber dies ist blitzschnell. So können wir in einer bestimmten Zeit eine Menge mit guter Testabdeckung durchführen.

!!! note "Testpyramide"
    Dies wird in der Regel durch eine Testpyramide veranschaulicht, von der in der Literatur verschiedene Formen verwendet wurden. Eine einfache Variante ist:
    
    ![Tesztpiramis](images/testing-pyramid.png)

    Je höher man in der Pyramide steht, desto umfassender sind die Tests, aber desto langsamer und teurer sind sie auch. Wir neigen also dazu, weniger davon zu machen (und damit eine geringere Codeabdeckung zu erreichen). An der Spitze der Pyramide stehen automatisierte E2E- (End-to-End) oder GUI-Tests. Im Folgenden finden Sie Integrationstests, die mehrere Einheiten/Module in einem testen. An der Basis der Pyramide befinden sich die Unit-Tests, von denen wir die meisten durchführen (die Basis der Pyramide ist die breiteste).

    Lustige Tatsache: Wenn Unit-Tests während der Entwicklung eines Produkts lange Zeit vernachlässigt werden, ist es sehr schwierig, Unit-Tests im Nachhinein durchzuführen, da die Codestruktur dies nicht unterstützt. Es wird also nur sehr wenige dieser Tests geben, ergänzt durch einige Integrationstests und bestenfalls viele, viele End-to-End-/GUI-Tests durch Testteams (was aber bei einem komplexen Produkt oft keine gute Testabdeckung ergibt). Im Gegensatz zu einer Pyramide hat diese die Form einer Eistüte, stellen Sie sich einfach ein paar Kugeln oben drauf vor. Es ist auch als Eiscreme-"Probe" bekannt (und es ist nicht die Eiscreme, die wir mögen). Es sei jedoch darauf hingewiesen, dass alles an seinem Platz behandelt werden sollte: es gibt Ausnahmen (Anwendungen, bei denen die Logik der einzelnen Teile gering ist, die gesamte Anwendung wird von der Integration sehr einfacher Teile beherrscht: in solchen Fällen sind Integrationstests natürlich übergewichtig).

Klassencode ist oft nicht standardmäßig unit-testbar. In seiner jetzigen Form ist `Anonymizer` eine davon. Es ist eingebaut, dass es nur mit langsamen, dateibasierten Eingaben arbeiten kann. Wenn wir aber beispielsweise die Logik der Operation `Run` testen wollen, spielt es keine Rolle, ob die Daten aus einer Datei kommen (langsam) oder ob wir einfach den `new` Operator verwenden, um einige `Person` Objekte aus dem Code für den Test zu generieren (um Größenordnungen schneller).

Die Lösung - unseren Code unit-testbar zu machen - ist einfach:

<div class="grid cards" markdown>

- :warning:
  *Trennen Sie unter Verwendung des Strategy (+DI) Patterns (oder Delegates) jegliche Logik (z.B. Input/Output Handling), die das Testen behindert oder verlangsamt, von der zu testenden Klasse*.* Wir erstellen Implementierungen, die die tatsächliche Logik implementieren, und Scheinimplementierungen, die das Testen erleichtern.*
</div>

<div class="grid cards" markdown>

- :warning:
  *Dementsprechend verwenden wir das Strategy-Muster oft nicht, weil wir mehrere Verhaltensweisen für die Bedürfnisse des Kunden einschließen müssen, sondern um unseren Code unit-testbar zu machen*.

</div>

Dementsprechend werden wir eine einheitlich getestete Version unserer Lösung vorbereiten, in der die Eingabe- und Ausgabeverarbeitung mit Hilfe des Strategiemusters entkoppelt ist.

Aufgabe: Passen Sie die Lösung im Strategy-DI-Projekt so an, dass die Klasseneinheit nach dem Strategy-Muster getestet werden kann. Weitere Einzelheiten:

- Legen Sie einen Ordner `InputReaders` an, in dem Sie eine Schnittstelle für die Eingabeverarbeitungsstrategie namens `IInputReader` (mit einer einzigen Operation `List<Person> Read()` ) einführen und von der Klasse `Anonymizer` aus, dem Strategiemuster folgend, die Eingabeverarbeitung in einer Strategieimplementierung namens `CsvInputReader` organisieren. Diese Klasse erhält den Pfad zur Datei im Konstruktorparameter, aus dem sie ihre Eingabe liest.
- Führen Sie einen Ordner `ResultWriters` ein, in dem Sie eine Strategie-Schnittstelle einführen, um ein Ergebnis namens `IResultWriter` (mit einer einzigen Operation `void Write(List<Person> persons)` ) auszugeben, und organisieren Sie von der Klasse `Anonymizer` aus, dem Strategie-Muster folgend, die Ausgabe, die in eine Strategie-Implementierung namens `CsvResultWriter` geschrieben werden soll. Diese Klasse erhält in einem Konstruktorparameter den Pfad zu der Datei, in die die Ausgabe geschrieben werden soll.
- Erweitern Sie die Klasse `Anonymizer`, einschließlich ihres Konstruktors (Strategie + DI-Muster), so dass sie mit jeder `IInputReader` und `IResultWriter` Implementierung verwendet werden kann.
- Ändern Sie in der Datei `Program.cs` die Verwendung der Klasse `Anonymizer`, um die neu eingeführten Klassen `CsvInputReader` und `CsvResultWriter` als Parameter zu übergeben.

Der nächste Schritt ist (wäre), Unit-Tests für die Klasse `Anonymizer` zu erstellen. Dies erfordert die Einführung so genannter Mock-Strategie-Implementierungen, die nicht nur Testdaten liefern (natürlich schnell und ohne Dateibehandlung), sondern auch Prüfungen durchführen (ob eine bestimmte logische Einheit tatsächlich korrekt funktioniert). Das hört sich kompliziert an, aber glücklicherweise haben die meisten modernen Frameworks Bibliotheksunterstützung dafür (.NET hat [moq](https://github.com/devlooped/moq)). Ihre Anwendung würde den Rahmen dieses Themas sprengen, so dass der Teil "Testbarkeit der Einheiten" unserer Übung an dieser Stelle abgeschlossen ist.

!!! example "Übung 3 KUNDE"
    - Fügen Sie ein Bildschirmfoto ein, das den Konstruktor der Klasse `Anonymizer` und die Implementierung der Funktion `Run` (`f3.1.png`) zeigt.

## 4. Aufgabe - Einstellung von Delegierten

Heutzutage verbreiten sich Werkzeuge, die die funktionale Programmierung in ehemals streng objektorientierten Sprachen unterstützen, rasant, und Anwendungsentwickler setzen sie zunehmend ein (weil sie oft das Gleiche mit deutlich weniger Code und weniger "Zeremonien" erreichen können). Ein solches Werkzeug in C# ist der Delegat und der damit verbundene Lambda-Ausdruck.

Wie wir zu Beginn des Semesters gesehen haben, ermöglichen es uns Delegierte, Code zu schreiben, der nicht über bestimmte Logik/Verhaltensweisen verfügt, sondern "von außen" empfangen wird. So kann beispielsweise eine Ordnungsfunktion als Delegierter übergeben werden, um anzugeben, wie zwei Elemente verglichen werden sollen oder nach welchem Feld/welcher Eigenschaft der Vergleich durchgeführt werden soll (und damit letztlich die gewünschte Reihenfolge zu bestimmen).

Dementsprechend ist die Verwendung von Delegaten eine weitere Alternative (neben Template Method und Strategy), um Code wiederverwendbar/erweiterbar zu machen und Erweiterungspunkte einzuführen.

Im nächsten Schritt werden wir die bisher mit dem Strategy-Pattern implementierte Fortschrittsbehandlung auf eine Delegatenbasis umstellen (es wird keine neue Funktionalität eingeführt, dies ist eine rein "technische" Umstellung).

Aufgabe: Ändern Sie die Lösung im Projekt Strategy-DI so, dass die Fortschrittsverwaltung auf der Basis von Delegierten anstelle von Strategy implementiert wird. Weitere Einzelheiten:

- Implementieren Sie keinen eigenen Delegatentyp (verwenden Sie den von .NET bereitgestellten Typ `Action` ).
- Verwenden Sie die bestehenden Klassen `SimpleProgress` und `PercentProgress` nicht in Ihrer Lösung (löschen Sie sie aber auch nicht!).
- Der Benutzer von `Anonymizer` sollte weiterhin `null`im Konstruktor angeben können, wenn er keine Progress-Handler verwenden möchte.
- Kommentieren Sie in der Datei `Program.cs` die bisherige Verwendung von `Anonymizer` aus. Führen Sie an gleicher Stelle ein neues Beispiel für die Verwendung von `Anonymizer` ein, bei dem der Progress-Handler als Lambda-Ausdruck angegeben wird, und der Lambda-Ausdruck genau die Logik des vorherigen "einfachen Fortschritts" implementiert. Der "prozentuale Fortschritt" benötigt keine ähnliche Implementierung, er wird in dieser Lösung nicht unterstützt (wir werden in der nächsten Übung darauf zurückkommen).
  
!!! tip "Tipps"
    - Das Prinzip einer delegatenbasierten Lösung ist dem der Strategie sehr ähnlich: nur statt Strategien in den Membervariablen der Klasse zu empfangen und zu speichern (über Schnittstellenreferenzen), empfängt und speichert sie Delegaten und ruft die Funktionen, auf die sie sich beziehen, in den Erweiterungspunkten auf.
    - Sie haben etwas Ähnliches bereits in Hausaufgabe 2 im Abschnitt ReportPrinter gemacht ;).

!!! example "Übung 4 KUNDE"
    - Fügen Sie ein Bildschirmfoto ein, das den Konstruktor der Klasse `Anonymizer` und die Implementierung der Funktion `Run` zeigt (`f4.1.png`).
    - Fügen Sie ein Bildschirmfoto ein, das den Inhalt der Datei `Program.cs` zeigt (insbesondere die neuen Teile) (`f4.2.png`).

## 5. Aufgabe - Verwendung von Delegaten mit wiederverwendbarer Logik

In der vorangegangenen Übung sind wir davon ausgegangen, dass die Logik des "einfachen Fortschritts" und des "prozentualen Fortschritts" nur einmal verwendet wurde, so dass sie nicht wiederverwendet werden musste. Dementsprechend wurde die Logik z. B. des "einfachen Fortschritts" in der einfachsten Form, nämlich als Lambda-Ausdruck, angegeben (es musste keine separate Funktion eingeführt werden). Wenn Sie dem Delegaten jedes Mal, wenn Sie `Anonymizer` erstellen, eine andere Implementierung geben, ist diese lambda-basierte Lösung perfekt.

Was aber, wenn wir die "einfache Fortschrittslogik" aus dem obigen Beispiel für mehrere `Anonymizer` Objekte an verschiedenen Orten verwenden wollen? Es wäre ein schwerwiegender Fehler, den Lambda-Ausdruck mit Copy-Paste zu "vervielfältigen", da dies zu einer Verdoppelung des Codes führen würde (dies würde dem **DRY-Prinzip** (**"Do Not Repeat Yourself**") widersprechen).

Frage: Gibt es eine Möglichkeit, wiederverwendbaren Code für Delegierte bereitzustellen? Ja, natürlich, da Delegierte keine Lambda-Ausdrücke verwenden müssen, können sie für gewöhnliche Operationen (statisch oder nicht statisch) verwendet werden, wie wir bereits früher im Semester gesehen und in vielen Fällen verwendet haben.

Wenn Sie die Logik des "einfachen Fortschritts" und/oder des "prozentualen Fortschritts" bei der Verwendung von Delegaten wiederverwendbar machen wollen, fügen Sie sie in eine separate Funktion in einer Klasse/Klassen ein, die am besten zu diesem Fall passt, und übergeben Sie eine solche Aktion als Parameter an den `Anonymizer` -Konstruktor.

Aufgabe: Erweitern Sie die bisherige Lösung, so dass die Logik des "einfachen Fortschritts" und des "prozentualen Fortschritts" wiederverwendet werden kann. Weitere Einzelheiten:

- Implementieren Sie die Logik des "einfachen Fortschritts" und des "prozentualen Fortschritts" in zwei statischen Operationen einer neu eingeführten statischen Klasse `AllProgresses` (die Klasse sollte im Stammverzeichnis des Projekts abgelegt werden).
- Führen Sie zwei neue `Anonymizer` Verwendungen in `Program.cs` zusätzlich zu den bestehenden ein, die die beiden `AllProgresses` Operationen verwenden (verwenden Sie hier kein Lambda).
- Die bestehende Schnittstelle `IProgress` und ihre Implementierungen könnten gelöscht werden (da sie nicht mehr verwendet werden). Löschen Sie diese jedoch NICHT, um die Fortschrittslogik Ihrer bisherigen Lösung zu überprüfen.

Wir sind bereit, wir prüfen die Lösung:

- Es kann darauf hingewiesen werden, dass die delegatenbasierte Lösung weniger feierlich war als die Strategie: Es mussten keine Schnittstellen- und Implementierungsklassen eingeführt werden (wir konnten die eingebauten generischen Delegatetypen `Action` und `Func` verwenden).
- Die einfachste Art, die völlig "ad hoc"-Logik auszudrücken, ist in Lambda-Ausdrücken. Wenn jedoch wiederverwendbare Logik benötigt wird, sollten Sie "traditionelle" wiederverwendbare Funktionen einführen.

!!! example "Übung 5 - SUBMIT"
    - Fügen Sie ein Bildschirmfoto ein, das den Inhalt der Datei `AllProgresses.cs` zeigt (`f5.1.png`).
    - Fügen Sie ein Bildschirmfoto ein, das den Inhalt der Datei `Program.cs` zeigt (insbesondere die neuen Teile) (`f5.2.png`).

## Das Konzept des Refactoring

Während des Praktikums und der Hausaufgaben gab es mehrere Schritte, in denen der Code so verändert wurde, dass sich das äußere Verhalten der Anwendung nicht änderte, sondern nur ihre interne Struktur. Damit soll eine bessere Codequalität in gewisser Hinsicht erreicht werden. Dieser Code heißt `refaktorálásának` ( `refactoring` auf Englisch). Dies ist ein sehr wichtiges Konzept, das wir in unserer täglichen Arbeit sehr häufig verwenden. Es gibt eine eigene Literatur, und die wichtigsten Techniken werden später näher erläutert. Die seriöseren Entwicklungswerkzeuge verfügen über integrierte Unterstützung für bestimmte Refactoring-Operationen: Visual Studio ist in dieser Hinsicht nicht das stärkste Programm, aber es unterstützt einige grundlegende Operationen (z. B. Methode extrahieren, Basisklasse extrahieren usw.). Wir haben dies manuell geübt, daher wird es keine spezielle Übung geben, aber Sie sollten mit dem Konzept des Refactoring vertraut sein.

## 6. Optionale Aufgabe - Erstellen eines Integrationstests

Durch das Lösen dieser Aufgabe können Sie +1 IMSc-Punkt verdienen.

Das Konzept des Integrationstests wurde in der vorangegangenen Übung 3 vorgestellt. Das Ziel dieser optionalen Übung ist es, dies anhand einer einfachen Aufgabe zu üben und besser zu verstehen. 

Erstellen Sie einen Integrationstest für die Klasse `Anonymizer`, wie folgt:

1. In Solution arbeiten Sie mit dem Projekt `IntegrationTest`, das im Ordner `Test` vorbereitet wurde. Dies ist ein NUnit-Testprojekt.
2. In diesem Projekt haben wir bereits einen Projektverweis auf das Projekt `Strategy-DI` hinzugefügt, so dass wir die (öffentlichen) Klassen im Projekt `Strategy-DI` sehen können. Dies ist natürlich eine Voraussetzung dafür, dass wir sie testen können. Prüfen Sie, ob der Projektverweis existiert (im Solution Explorer unter dem Projekt im Knoten Abhängigkeiten/Projekte).
3. In der Klasse `AnonymizerIntegrationTest` gibt es bereits einen Testvorgang namens `Anonymize_CleanInput_MaskNames_Test` (Testvorgänge sollten das Attribut `[Test]` haben, es ist bereits für diesen Vorgang vorbereitet). Der Stamm der Operation ist im Moment noch leer, daran müssen wir in den nächsten Schritten arbeiten.
    1. Erstellen Sie ein Objekt `Anonymizer`, das
        * arbeitet mit der Eingabe `@"TestFilesus-500-01-clean.input.csv"` (sie befindet sich im Ordner *TestFiles* des Projekts, siehe Inhalt),
        * die Ausgabe sollte die Datei `@"us-500-01-maskedname.processed.txt"` sein,
        * verwendet `NameMaskingAnonymizerAlgorithm`mit dem Parameter "***".
    2. Führen Sie den Anonymisierer aus, indem Sie die Operation `Run` aufrufen, um die Speicherdatei zu erstellen.
    3. Rufen Sie `Assert.AreEqual` auf, um zu überprüfen, ob die vom Anonymisierungsprozess erzeugte Ausgabedatei dem erwarteten Inhalt entspricht. Der erwartete Inhalt steht in der Datei `@"TestFilesus-500-01-maskedname.processed-expected.txt"` zur Verfügung (sie befindet sich im Projektordner `TestFiles`, siehe Inhalt). 
    Hinweis: Der Inhalt einer Datei kann z.B. mit der statischen Operation `File.ReadAllBytes` in einem Schritt gelesen werden.
4. Prüfen Sie, ob der Integrationstest fehlerfrei läuft.
    1. Erstellen Sie Ihr Projekt
    2. Test Explorer öffnen (Menü Test/Test Explorer)
    3. Der Test kann über die Schaltflächen in der Symbolleiste oben in der Test-Explorer-Ansicht ausgeführt werden. Es ist aber auch möglich, den Test zu debuggen, indem Sie mit der rechten Maustaste auf den Test klicken und das Menü Debuggen auswählen: Dies kann sehr nützlich sein, wenn Ihr Test fehlerhaft läuft und Sie den Code mithilfe von Haltepunkten durchgehen oder den Wert von Variablen überprüfen möchten.
    4. Wenn der Test fehlerfrei verläuft, wird das Symbol für den Test grün angezeigt. Wenn ein Fehler auftritt, wird er rot angezeigt, und Sie können weitere Informationen über die Fehlermeldung erhalten, indem Sie den Test unten in der Test-Explorer-Ansicht auswählen.

## 7. Optionale Aufgabe - Erstellen eines Einheitstests

Durch Lösen dieser Aufgabe können +2 IMSc-Punkte erzielt werden.

Das Konzept der Einheitstests wurde in der vorherigen Übung 3 eingeführt. Der Zweck dieser optionalen Übung ist es, dies anhand einer Aufgabe zu üben und besser zu verstehen.

Vorbereitung:

1. Fügen Sie der Projektmappe ein neues Projekt vom Typ "NUnit Test Project" mit dem Namen "UnitTest" hinzu (Rechtsklick auf Projektmappe im Projektmappen-Explorer/Hinzufügen/Neues Projekt).
2. Fügen Sie in diesem neuen Projekt eine Projektreferenz zum Projekt `Strategy-DI` hinzu, damit die in `Strategy-DI`definierten Typen im Projekt verfügbar sind (klicken Sie mit der rechten Maustaste auf den Knoten Abhängigkeiten des Unit-Test-Projekts/Projektreferenz hinzufügen, markieren Sie im angezeigten Fenster das Projekt `Strategy-DI`, "OK").
3. Das Projekt erstellt eine Datei `UnitTest1.cs`, die eine Klasse `Test` enthält. Diese sollten `AnonymizerTest`genannt werden. 

Erstellen Sie einen Einheitstest für die Klasse `Anonymizer`, der prüft, ob die Operation `Run` den Anonymisierungsalgorithmus mit genau denselben Personendaten aufruft, die `Anonymizer` in seiner Eingabe liest (wenn es keine zu bereinigenden Städtenamen gibt). 

* Die Testfunktion sollte den Namen `RunShouldCallAlgorithmForEachInput`tragen.
* :Ausruf: Es ist wichtig, einen sehr schnellen Unit-Test zu schreiben, keinen Integrationstest: Wir wollen also nur die Logik von `Run` selbst testen, ohne jegliche Dateiverarbeitung. Die Lösung darf keine Dateiverwaltung haben!
* Tipp: Erstellen Sie 2-3 `Person` Objekte im Speicher und verwenden Sie sie als Eingabe.
* Tipp: Arbeiten Sie mit personenbezogenen Eingabedaten, die von der Funktion `TrimCityNames` nicht betroffen sind (d. h. keine Daten, die entfernt werden müssen), das erleichtert die Tests.
* Tipp: Erstellen Sie Implementierungen von `IInputReader`, `IAnonymizerAlgorithm` (und verwenden Sie `Anonymizert` mit ihnen), die **geeignete Testdaten bereitstellen und/oder zur Laufzeit Daten sammeln, so dass Sie nach der Laufzeit prüfen können, ob die zu testenden Bedingungen erfüllt sind**. Achten Sie darauf, dass diese Strategieimplementierungen in das Testprojekt aufgenommen werden, da sie nur zu Testzwecken dienen.

Als weitere Übung können Sie einen weiteren Einheitstest erstellen, um zu prüfen, ob alle Eingabedaten die Ausgabe erreichen. 

## Zusammenfassung

Keine Aufgaben mehr 😊. Wenn Sie aber zum Beispiel wissen wollen, wie "perfekt"/defekt diese Lösung ist oder wann Sie mit der Schablonenmethode, der Strategie oder den Delegierten arbeiten sollten, sollten Sie den folgenden Abschnitt lesen, in dem wir die im Labor begonnene und in der Hausaufgabe abgeschlossene Lösung bewerten.

### Überblick über unseren Arbeitsablauf

 * Als sich die Anforderungen änderten, entwickelten sich die Entwurfsmuster organisch und andere Techniken wurden während des Refactorings eingeführt. Das ist ganz natürlich, wir arbeiten in der Praxis oft so.
 * In jedem Fall beginnt man bei einer komplexeren Aufgabe, vor allem, wenn man nicht über langjährige Erfahrung verfügt, oft mit einer einfacheren Implementierung (das ist das, was man zuerst sieht) und passt sie so an, dass sie die Parameter für die Erweiterbarkeit/Wiederverwendbarkeit aufweist, die man im jeweiligen Kontext wünscht.

### Grad der Wiederverwendbarkeit und Erweiterbarkeit in jeder Lösung

Wir können versuchen, uns vorzustellen, wie unsere Lösung mit jeder Iteration zunehmend wiederverwendbar und erweiterbar wird:

![Stufen der Skalierbarkeit und Wiederverwendbarkeit](images/extensibility-levels.png)

Natürlich sollten die Prozentzahlen nicht zu ernst genommen werden. In jedem Fall sind die Fortschritte deutlich sichtbar.

??? note "Warum geben wir "nur" 70 % für die endgültige Lösung?"
    Es stellt sich die Frage, warum wir etwa 70 % für meine Lösung geben? Unter anderem:

    * In der Klasse "Anonymizer" ist die Art der Datenbereinigung fest eingebrannt (Trimmen für eine bestimmte Spalte auf eine bestimmte Weise).
    * Wir haben einen sehr wichtigen allgemeinen Grundsatz nicht beachtet: die Trennung von Benutzeroberfläche und Logik. Unser Code schreibt an mehreren Stellen in eine Konsole, so dass er z. B. nicht mit einer grafischen Oberfläche verwendet werden kann!
    * Einige unserer Anonymisierungsalgorithmen sind sehr spezifisch. Es könnten allgemeinere Algorithmen entwickelt werden, die beliebige Felder hochstellen (nicht nur den eingebrannten Namen) oder beliebige Felder verbinden (nicht nur das Alter).
    * Diese Lösung kann nur mit `Person`-Objekten funktionieren.
    * Es ist nicht möglich, verschiedene Anonymisierungsalgorithmen gleichzeitig zu kombinieren.

### Überblick über die Erweiterungstechniken

* **Vorlage Methode**: In einem einfachen Fall, in dem man nicht viele Kreuzkombinationen verschiedener Verhaltensaspekte unterstützen muss, stellt dies eine sehr bequeme und einfache Lösung dar, insbesondere wenn man ohnehin Ableitungen verwenden muss. Aber es erzeugt nicht oder nur schwer eine unit-testbare Basisklasse.
* **Strategie**: Sie bietet eine sehr flexible Lösung und führt nicht zu einer kombinatorischen Explosion, wenn Sie die Klasse um mehrere Aspekte erweitern und in mehreren Kreuzkombinationen verwenden wollen. In vielen Fällen verwenden wir es nur, um Abhängigkeiten von unserer Klasse über Schnittstellen zu lösen und so unsere Klasse unit-testbar zu machen.
* **Delegierter/Lambda**: Dieser Ansatz ist weniger feierlich als die Verwendung von Strategy, da er die Einführung von Schnittstellen und Implementierungsklassen nicht erfordert, und wird daher in modernen objektorientierten Sprachen zunehmend (schnell) verwendet. Dies hat insbesondere dann Vorteile, wenn Sie die Verhaltensweisen nicht wiederverwendbar machen wollen (weil Sie sie dann nur mit einem einzigen Lambda-Ausdruck bereitstellen, ohne neue Klassen/Spezialfunktionen einzuführen). 
  
Es lohnt sich, zu kompilieren, wenn die Strategie einen Vorteil gegenüber den Delegierten hat/haben kann:

* Wenn ein bestimmter Aspekt der zu erweiternden Klasse mehr als eine (je mehr, desto besser) Operation hat. In diesem Fall werden sie von der Strategie-Schnittstelle "automatisch" zusammengefasst (wie die Schnittstelle `IAnonymizerAlgorithm` in unserem Beispiel, die die Vorgänge `Anonymize` und `GetAnonymizerDescription` zusammenfasst). Sie sind auch in Schnittstellenimplementierungen gruppiert (keine solche Gruppierung für Delegierte). Dies kann die Lösung transparenter machen, und für viele Vorgänge ist dies eindeutig der Fall.
* Die Sprache ist rein objektorientiert und unterstützt keine Delegate/Lambda. Heutzutage unterstützen die meisten modernen OO-Sprachen dies jedoch glücklicherweise in irgendeiner Form (auch Java und C++).
* Strategieimplementierungen können ihren Zustand auch in ihren Mitgliedsvariablen speichern, die bei ihrer Erstellung angegeben werden können. Diese wurde verwendet (für `NameMaskingAnonymizerAlgorithm` war es `_mask`, für `AgeAnonymizerAlgorithm` war es `_rangeSize`). Das bedeutet nicht, dass wir in einem solchen Fall überhaupt keine Delegierten verwenden können, denn:
    * können diese Daten bei jedem Delegatenaufruf in einem neu eingeführten Funktionsparameter übergeben werden,
    * oder, wenn Lambda verwendet wird, der "Variablenerfassungs"-Mechanismus, der es Lambda-Funktionen ermöglicht, Zustände aus ihrer Umgebung zu übernehmen.

    Diese Lösungen sind jedoch nicht immer anwendbar oder zumindest schwerfällig in der Umsetzung.

In jedem Fall sollte erwähnt werden, dass nicht nur einige der in dieser Übung erwähnten Muster der Erweiterbarkeit und Wiederverwendbarkeit dienen, sondern praktisch alle von ihnen. Wir haben nun einige hervorgehoben, die (auch einschließlich Observer/Iterator/Adapter) vielleicht am häufigsten und am weitesten verbreitet sind und immer noch in Frameworks auftauchen.

Wenn du bis hierher gelesen hast, verdienst du auf jeden Fall einen extra Daumen hoch 👍!