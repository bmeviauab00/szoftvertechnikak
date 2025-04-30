---
autoren: Zoltán Szabó,kszicsillag,bzolka
---
# 4. Erstellung von mehrfädigen Anwendungen

## Das Ziel der Übung

Ziel der Übung ist, dass die Studenten mit den Grundsätzen kennenzulernen, die bei der Programmierung von mehreren Threads beachtet werden müssen. Behandelte Themen (unter anderem):

- Einen Thread starten (`Thread`)
- Einen Thread beenden
- Erstellen von faedensicheren (thread safe) Klassen mit dem Schlüsselwort `lock` 
- `ThreadPool` verwenden
- Signalisieren und Synchronisation von auf Signal wartenden Threads mit der Hilfe von `ManualResetEvent` (`WaitHandle`)
- Besonderheiten des WinUI-Threadings (`DispatcherQueue`)

Da das Thema sehr umfangreich ist, werden Sie natürlich nur Grundkenntnisse erwerben, aber mit diesem Wissen werden Sie in der Lage sein, komplexere Aufgaben selbständig zu bearbeiten.

Zugehörige Vorlesungen: Entwicklung konkurrierender (meghrfädigen) Anwendungen.

## Voraussetzungen

Die für die Durchführung der Übung benötigten Werkzeuge:

- Visual Studio 2022
    - Windows Desktop Development Workload
- Betriebssystem Windows 10 oder Windows 11 (Linux und macOS nicht geeignet)

## Lösung

??? success "Laden Sie die fertige Lösung herunter"
    :exclamation: Es ist wichtig, dass Sie sich während des Praktikums an die Anleitung halten. Es ist verboten (und sinnlos), die fertige Lösung herunterzuladen. Allerdings kann es bei der anschließenden Selbsteinübung nützlich sein, die fertige Lösung zu überprüfen, daher stellen wir sie zur Verfügung.

    Die Lösung ist [verfügbar auf GitHub](https://github.com/bmeviauab00/lab-tobbszalu-kiindulo/tree/megoldas). Der einfachste Weg, es herunterzuladen, ist, den `git clone`-Zweig von der Kommandozeile aus zu klonen:

    `git clone https://github.com/bmeviauab00/lab-tobbszalu-kiindulo -b solved`

    Sie müssen Git auf Ihrem Rechner installiert haben, weitere Informationen [hier](../../hazi/git-github-github-classroom/index.md#git-telepitese).

## Einführung

Die Verwaltung parallel laufender Threads ist ein Bereich mit hoher Priorität, den alle Softwareentwickler zumindest in den Grundlagen kennen sollten. In der Übung lösen wir grundlegende, aber vorrangige Probleme, so dass wir uns bemühen sollten, nicht nur das Endergebnis, sondern auch die Bedeutung und die Gründe für die von uns vorgenommenen Änderungen zu verstehen.

In dieser Übung werden wir einer einfachen WinUI-Anwendung mehrfädige Fähigkeiten hinzufügen und zunehmend komplexere Aufgaben lösen. Das Grundproblem ist folgendes: Wir haben eine Funktion, die lange läuft, und wie wir sehen werden, hat der "direkte" Aufruf über die Benutzeroberfläche unangenehme Folgen. Während dem Lösen werden wir eine bestehende Anwendung mit eigenen Codezeile ergänzen. Neue Zeilen, die eingefügt werden sollen, sind in der Anleitung durch einen hervorgehobenen Hintergrund gekennzeichnet.

## 0. Aufgabe - Kennenlernen des Anfangsprojekt, Vorbereitung

Klonen wir [das Repository](https://github.com/bmeviauab00/lab-tobbszalu-kiindulo) der ursprünglichen Anwendung für Übung 4:

- Öffnen wir ein command prompt
- Navigieren wir zu einem Ordner unserer Wahl, zum Beispiel c:\work\NEPTUN
- Geben wir den folgenden Befehl ein: `git clone https://github.com/bmeviauab00/lab-tobbszalu-kiindulo.git`
- Öffnen wir das Solution *SuperCalculator.sln* in Visual Studio.

Unsere Aufgabe ist es, eine Benutzeroberfläche unter Verwendung der WinUI-Technologie zu erstellen, um einen in binärer Form erreichbaren Algorithmus auszuführen. Die binäre Form von .NET ist eine Datei mit der Erweiterung *.dll*, die in der Programmiersprache eine Klassenbibliothek darstellt.  In unserem Fall lautet der Dateiname *Algorithms.dll*, der sich im geklonten Git-Repository befindet.

In der Anfangsprojekt ist die Benutzeroberfläche bereits vorbereitet. Führen wir die Anwendung aus:

![starthilfe](images/starter.png)

In der Benutzeroberfläche der Anwendung können wir die Eingabeparametern des Algorithmus angeben (`double` array of numbers): in unserem Beispiel rufen wir den Algorithmus immer mit zwei `double` Zahlenparametern auf, die in den zwei oberen Textfeldern angegeben werden können.
Unsere Aufgabe ist es, den Algorithmus mit den angegebenen Parametern auszuführen, falls wir auf die Taste *Calculate Result* klicken, und wenn er fertig ist, das Ergebnis mit den Eingabeparametern in einer neuen Zeile des Listenfeldes unterhalb des *Results* anzuzeigen.

In der nächsten Schritten schauen wir zuerst das heruntergeladene Visual Studio Solution an:

Die Rahmenanwendung ist eine auf WinUI 3 basierte Anwendung. Die Oberfläche ist grundsätzlich fertig, ihre Definition ist in der Datei `MainWindow.xaml` zu finden. Dies ist für uns im Hinblick auf den Zweck der Übung weniger aufregend, aber es lohnt sich, sie zu Hause zu üben.

??? note "Gestaltung der Oberfläche in `MainWindow.xaml`"

       Grundlagen der Gestaltung von Fensterflächen:
       
       - Die Wurzel (root) ist "normalerweise" ein `Grid`. 
       - In der obersten Zeile des Wurzel-`Grid` befindet sich das `StackPanel`, das die zwei Texteingabefelder (`TextBox`) und die Taste (`Button`) enthält.
       - Die unterste Zeile des Wurzel-`Grid` enthält ein weiteres `Grid`. Im Gegensatz zur `TextBox` hat die `ListBox` keine `Header`-Eigenschaft, so dass wir diese als separaten `TextBlock` mit dem Text "Result" einführen mussten. Dieses `Grid` wurde eingeführt (anstelle eines "einfacheren" `StackPanel`), weil es möglich war, den `TextBlock` in der oberen Zeile mit einer festen Höhe für das "Result" und die `ListBox` in der unteren Zeile so zu haben, dass sie den gesamten verbleibenden Platz ausfüllt (die Höhe der oberen Zeile ist `Auto`, die Höhe der unteren Zeile ist `*`).
       - Die Taste mit dem Text "Calculate Result" ist ein gutes Beispiel dafür, dass der `Content` eines `Button` Elementes oft nicht nur ein einfacher Text ist. Das Beispiel zeigt eine Komposition aus einem `SymbolIcon` und einem `TextBlock` (implementiert mit `StackPanel`), so dass wir ein geeignetes Icon/Symbol zuweisen können, um sein Aussehen zu verbessern.
       - Wir sehen auch ein Beispiel dafür, wie man eine `ListBox` scrollbar macht, wenn sie bereits viele Elemente enthält (oder die Elemente zu breit sind). Dazu muss der `ScrollViewer` richtig parametrisiert werden.
       - Die Eigenschaft `ItemContainerStyle` der `ListBox` wird verwendet, um Stile für das Element `ListBox` festzulegen. Im Beispiel ist `Padding` auf einen kleineren Wert als den Standardwert eingestellt, da sonst die Höhe der `ListBox`-Elemente überflüssig groß wäre.

Die Quelldatei `MainWindow.xaml.cs` ist der Code hinter der Datei für das Hauptfenster, lassen wir uns diese überprüfen, ihre Hauptelemente sind wie folgt:

- Um das Ergebnis und die Parameter auf `ListBox`zu loggen, gibt es eine Hilfsfunktion namens `ShowResult`. 
-  `CalculateResultButton_Click` ist der Ereignishandler für das Anklicken der Taste " *Calculate Result* ". Wir sehen, dass er den Wert der Parameter aus den beiden Textfeldern liest und versucht, ihn in eine Zahl umzuwandeln. Wenn er erfolgreich ist, wird der Algorithmus hier aufgerufen (dies ist noch nicht implementiert), oder wenn er fehlschlägt, wird der Benutzer über `DisplayInvalidElementDialog` in einem Nachrichtenfenster über ungültige Parameter informiert.
- Die Funktion `AddKeyboardAcceleratorToChangeTheme`, die vom Konstruktor aufgerufen wird, ist für uns nicht relevant, sie ermöglicht das Umschalten zwischen hellen und dunklen Themen (Sie sollten es zur Laufzeit ausprobieren, ++ctrl+t++ ).

### Verwendung des Codes in der DLL

Im ursprünglichen Projekt finden wir die Datei *Algorithm.dll.* In dieser kompilierten Form gibt es eine Klasse `SuperAlgorithm` im Namensraum `Algorithms`, die eine statische Operation namens `Calculate` hat. Um die Klassen einer DLL in einem Projekt verwenden zu können, müssen wir in unsrem Projekt einen Verweis auf die DLL hinzufügen.

1. Klicken wir im Solution Explorer mit der rechten Maustaste auf den Knoten *Dependencies* unseres Projekts und wählen wir *Add Project reference*!

    ![Projektreferenz hinzufügen](images/add-project-ref.png)

    !!! note "Externe Referenzen"

        Hier verweisen wir eigentlich nicht auf ein anderes Visual Studio-Projekt, aber dies ist der einfachste Weg, dieses Fenster aufzurufen.

        Es sollte auch erwähnt werden, dass wir für externe Klassenbibliotheken keine DLLs mehr in einem regulären Projekt referenzieren, sondern die externen Pakete aus dem Paketmanager von .NET, aus dem NuGet beziehen. Jetzt ist _Algorithm.dll_ in unserem Fall nicht in NuGet veröffentlicht, so dass wir sie manuell hinzufügen müssen.

2. Verwenden wir die Taste *Browse* in der rechten unteren Ecke des Popup-Fensters, wählen wir die Datei *Algorithms.dll* im Unterordner *External* unseres Projekts aus und klicken wir auf OK, um das Hinzufügen zu bestätigen!

Im Solution Explorer können wir auf den Knoten *Dependencies* unter einem Projekt klicken, um die referenzierten externen Abhängigkeiten anzuzeigen. Der Verweis auf Algorithmen, der zuvor addiert war, wird auch hier unter Assemblys angezeigt. Die Kategorie Frameworks enthält die .NET Framework-Pakete. Und die Elemente unter Analyzer sind Werkzeuge für die statische Codeanalyse zur Kompilierzeit. Und es gäbe hier auch die Projekt- oder NuGet-Referenzen.

![Abhängigkeiten](images/dependencies.png)

Klicken wir mit der rechten Maustaste auf die Referenz Algorithms und wählen wir *View in Object Browser*. Dies öffnet die Registerkarte Object Browser, in der wir sehen können, welche Namensräume, Klassen und deren Mitglieder (Membervariable, Memberfunktion, Eigenschaft, Ereignis) in der angegebenen DLL enthalten sind. Visual Studio liest diese aus den DLL-Metadaten mit Hilfe des so genannten Reflection-Mechanismus (wir können diesen Code selbst schreiben).

Wie in der Abbildung unten dargestellt ist, suchen wir im Object Browser den Knoten Algorithmen auf der linken Seite, öffnen ihn und sehen, dass er einen Namensraum `Algorithms` und eine Klasse `SuperAlgorithm` enthält. Wenn wir dies auswählen, werden die Funktionen der Klasse in der Mitte angezeigt, und wenn wir hier eine Funktion auswählen, wird die genaue Signatur dieser Funktion angezeigt:

![Objekt-Browser](images/object-browser.png)

## Aufgabe 1 - Ausführen einer Operation auf dem Hauptthread

Jetzt können wir mit der Ausführung des Algorithmus fortfahren. Zunächst tun wir dies im Hauptthread unserer Anwendung.

1. Im Ereignishandler der Taste `Click` im Hauptfenster rufen wir unsere Zählerfunktion auf. Öffnen wir dazu die code behind Datei `MainWindow.xaml.cs` im Solution Explorer und suchen wir nach dem Ereignishandler `CalculateResultButton_Click`. Vervollständigen wir den Code durch den Aufruf des neu referenzierten Algorithmus.

    ```cs hl_lines="7-8"
    private void CalculateResultButton_Click(object sender, RoutedEventArgs e)
    {
        if (double.TryParse(param1TextBox.Text, out var p1) && double.TryParse(param2TextBox.Text, out var p2))
        {
            var parameters = new double[] { p1, p2 };

            var result = Algorithms.SuperAlgorithm.Calculate(parameters);
            ShowResult(parameters, result);
        }
        else
            DisplayInvalidElementDialog();
    }
    ```

2. Probieren wir die Anwendung aus und stellen fest, dass das Fenster während der Berechnung nicht auf Verschieben oder Größenänderung reagiert, die Oberfläche friert praktisch ein.

Unsere Anwendung ist ereignisgesteuert, wie alle Windows-Anwendungen. Das Betriebssystem benachrichtigt unsere Anwendung über die verschiedenen Interaktionen (z. B. Verschieben, Größenänderung, Mausklick): Da der einzige Thread unserer Anwendung nach dem Tastendruck mit der Berechnung beschäftigt ist, kann er nicht sofort weitere Benutzeranweisungen verarbeiten. Sobald die Berechnung abgeschlossen ist (und die Ergebnisse in der Liste angezeigt werden), werden die zuvor erhaltenen Befehle ausgeführt.

## Aufgabe 2 - Durchführung der Berechnung in einem separaten Thread

Im nächsten Schritt werden wir einen separaten Thread starten, um die Berechnung durchzuführen, damit die Benutzeroberfläche nicht blockiert wird.

1. Erstellen wir eine neue Funktion in der Klasse `MainWindow`, die der Eintrittspunkt für den VerarbeitungsFaden sein wird.

    ```cs
    private void CalculatorThread(object arg)
    {
        var parameters = (double[])arg;
        var result = Algorithms.SuperAlgorithm.Calculate(parameters);
        ShowResult(parameters, result);
    }
    ```

2. Starten wir den Thread in dem Ereignishandler der Taste `Click`. Ersetzen wir dazu den Code, den wir zuvor hinzugefügt haben:

    ```cs hl_lines="7-8"
    private void CalculateResultButton_Click(object sender, RoutedEventArgs e)
    {
        if (double.TryParse(param1TextBox.Text, out var p1) && double.TryParse(param2TextBox.Text, out var p2))
        {
            var parameters = new double[] { p1, p2 };

            var th = new Thread(CalculatorThread);
            th.Start(parameters);
        }
        else
            DisplayInvalidElementDialog();
    }
    ```

    Der in der Operation `Start` des Fadenobjekts übergebene Parameter wird an unsere Fadenfunktion `CalculatorThread` übergeben.

3. Führen wir die Anwendung mit ++f5++ aus (jetzt ist es wichtig, sie so auszuführen, im Debugger)! *The application called an interface that was marshalled for a different thread. (0x8001010E (RPC_E_WRONG_THREAD))* Fehlermeldung bekommen wir in der Methode `ShowResult`, weil wir nicht versuchen, auf das UI-Element/Controller von dem Thread aus zuzugreifen, der es erstellt hat (der Controller). In der nächsten Übung werden wir dieses Problem analysieren und lösen.

## Aufgabe 3 - Verwendung von `DispatcherQueue.HasThreadAccess` und `DispatcherQueue.TryEnqueue` 

Das Problem im vorigen Aufgabe hat folgende Ursachen. Für WinUI-Anwendungen gilt folgende Regel: Fenster/Oberflächen/Steuerelemente sind standardmäßig keine fadensicheren Objekte, so dass **auf ein Fenster/Oberfläche/Steuerelement nur von dem Thread aus zugegriffen werden darf (z.B. Eigenschaft lesen, einstellen, Operation aufrufen), der das gegebenen Fenster/Oberfläche/Steuerelement erstellt hat**, sondern gibt es eine Ausnahme. In unserer Anwendung haben wir eine Ausnahme bekommen, weil das `resultListBox` Steuerelement im Haupt-Thread erstellt wird, aber in der `ShowResult` Methode, wenn das Ergebnis angezeigt wird, wird von einem anderen Thread aus darauf zugegriffen (Aufruf der`resultListBox.Items.Add` Methode).

Die Frage ist, wie auf diese Oberflächenelemente/Steuerelemente von einem anderen Thread aus noch irgendwie zugegriffen werden kann. Die Lösung besteht in der Verwendung von `DispatcherQueue`, um sicherzustellen, dass der Zugriff auf die Steuerelemente immer über den richtigen Thread erfolgt:

- Die Funktion `TryEnqueue` des Objekts `DispatcherQueue` führt die als Parameter angegebene Funktion auf dem Thread aus, der das Steuerelement erstellt (von dem aus man nun direkt auf das Steuerelement zugreifen kann).
- Die Eigenschaft `HasThreadAccess` des Objekts `DispatcherQueue` hilft bei der Entscheidung, ob es notwendig ist, `TryEnqueue` zu verwenden, wie im vorherigen Abschnitt erwähnt. Wenn der Wert dieser Eigenschaft
    - wahr ist, kann auf den Controller direkt zugegriffen werden (weil der aktuelle Thread derselbe ist wie der Thread, der den Controller erstellt hat), aber wenn
    - falsch ist, kann auf den Controller nur "unter Umgehung", durch die Funktion `TryEnqueue` des Objekts `DispatcherQueue` zugegriffen werden (da der aktuelle Thread NICHT mit dem Thread identisch ist, der den Controller erstellt hat).

Mit `DispatcherQueue` können wir also unsere vorherige Ausnahme vermeiden (der Zugriff auf den Controller, in diesem Fall `resultListBox`, kann an den entsprechenden Thread "geleitet" werden). Wir werden dies im Folgenden tun.

!!! Hinweis
    Das Objekt `DispatcherQueue` ist in Nachkommen der Klasse Window über die Eigenschaft `DispatcherQueue` verfügbar (und in anderen Klassen über die statische Operation `DispatcherQueue.GetForCurrentThread()` ).

Wir müssen die Methode `ShowResult` so ändern, dass sie keine Ausnahme auslöst, wenn sie aus einem neuen, separaten Thread aufgerufen wird.

```cs hl_lines="3-5 7 18-19"
private void ShowResult(double[] parameters, double result)
{
    // Closing the window the DispatcherQueue property may return null, so we have to perform a null check
    if (this.DispatcherQueue == null)
        return;

    if (this.DispatcherQueue.HasThreadAccess)
    {
        var item = new ListBoxItem()
        {
            Content = $"{parameters[0]} #  {parameters[1]} = {result}"
        };
        resultListBox.Items.Add(item);
        resultListBox.ScrollIntoView(item);
    }
    else
    {
        this.DispatcherQueue.TryEnqueue( () => ShowResult(parameters, result) );
    }
}
```

Probieren wir es aus!

Diese Lösung ist bereits funktionsfähig und ihre wichtigste Elemente sind die folgenden:

- Die Rolle der Prüfung, ob `DispatcherQueue` `null` ist: Nach dem Schließen des Hauptfensters ist `DispatcherQueue` schon `null`, es kann nicht verwendet werden.
- Die `DispatcherQueue.HasThreadAccess` wird verwendet, um zu prüfen, ob der aufrufende Thread direkt auf die Controller zugreifen kann (in unserem Fall `ListBox`):
    - Falls ja, wird alles wie bisher passieren, der Code für `ListBox`bleibt unverändert.
    - Falls nicht, können wir durch `DispatcherQueue.TryEnqueue` auf den Controller zugreifen. Dabei wird der folgende Trick angewendet. Die Funktion `TryEnqueue` erhält eine parameterlose, einzeilige Funktion in Form eines Lambda-Ausdrucks, der unsere Funktion `ShowResult` aufruft (praktisch rekursiv) und ihr die Parameter übergibt. Das ist gut für uns, weil dieser `ShowResult`-Aufruf bereits auf dem Thread erfolgt, der den Controller erstellt hat (dem Hauptthread der Anwendung), der Wert von `HasThreadAccess` ist jetzt wahr, und wir können direkt auf unser `ListBox`zugreifen. Dieser rekursive Ansatz ist ein oft benutztes Muster, um redundanten Code zu vermeiden.
  
Setzen wir einen Haltepunkt in der ersten Zeile der Operation `ShowResult`, und führen wir die Anwendung aus, um sicherzustellen, dass `HasThreadAccess` falsch ist, wenn `ShowResult` zum ersten Mal aufgerufen wird (also wird `TryEnqueue` aufgerufen), und dann wird `ShowResult` erneut aufgerufen, aber `HasThreadAccess` ist wahr.

Entfernen wir den Haltepunkt und führen wir die Anwendung aus: Beachten wir, dass während eine Berechnung läuft, eine andere gestartet werden kann, da unsere Benutzeroberfläche durchgehend reaktionsfähig bleibt (und der Fehler, der zuvor auftrat, nicht mehr auftritt).

## Aufgabe 4 - Ausführen einer Operation auf einem Threadpool-Thread

Eine Merkmal der bisherigen Lösung ist, dass sie immer einen neuen Thread für die Operation erstellt. In unserem Fall ist dies nicht besonders wichtig, aber dieser Ansatz kann für eine Serveranwendung, die eine große Anzahl von Anfragen bedient, problematisch sein, da für jede Anfrage ein eigener Thread gestartet wird. Aus zwei Gründen:

- Wenn die Fadenfunktion schnell läuft (um einen Client schnell zu bedienen), dann wird ein großer Teil der CPU für das Starten und Stoppen von Threads verschwendet, was an sich schon ressourcenintensiv ist.
- Es können zu viele Threads erstellt werden, und das Betriebssystem muss zu viele planen, was unnötig Ressourcen verschwendet.
  
Ein weiteres Problem mit unserer derzeitigen Lösung: Da die Berechnung auf einem so genannten **Vordergrundfaden** läuft (neu erstellte Threads sind standardmäßig Vordergrundfäden), läuft das Programm selbst dann im Hintergrund weiter, obwohl wir die Anwendung schließen, solange bis die letzte Berechnung ausgeführt wurde: Ein Prozess hört erst auf zu laufen, wenn er keinen Vordergrundfaden mehr hat.

Ändern wir den Ereignishandler der Taste, um die Berechnung in einem **Threadpool-Thread** auszuführen, anstatt einen neuen Thread zu starten. Um dies zu tun, schreiben wir einfach den Ereignishandler für das Drücken der Taste um.

```cs hl_lines="7"
private void CalculateResultButton_Click(object sender, RoutedEventArgs e)
{
    if (double.TryParse(param1TextBox.Text, out var p1) && double.TryParse(param2TextBox.Text, out var p2))
    {
        var parameters = new double[] { p1, p2 };

        ThreadPool.QueueUserWorkItem(CalculatorThread, parameters);
    }
    else
        DisplayInvalidElementDialog();
}
```

Probieren wir die Anwendung aus und stellen fest, dass die Anwendung sofort anhält, wenn das Fenster geschlossen wird, ohne sich um eventuell noch laufende Threads zu kümmern (denn Threadpool-Threads sind Hintergrundfäden).

## Aufgabe 5 - Hersteller-Verbraucher-basierte Lösung

Allein durch die Lösung der vorangegangenen Probleme erhielten wir eine vollständige und gut funktionierende Lösung für das ursprüngliche Problem, die es ermöglicht, dass mehrere Threads parallel im Hintergrund arbeiten, wenn die Taste mehrmals nacheinander gedrückt wird. Im Folgenden werden wir unsere Anwendung so modifizieren, dass ein Tastendruck nicht immer einen neuen Thread erzeugt, sondern die Aufgaben in eine Aufgabenwarteschlange stellt, aus der mehrere im Hintergrund laufende Threads sie nacheinander auswählen und ausführen. Bei dieser Aufgabe handelt es sich um das klassische Hersteller-Verbraucher-Problem, das in der Praxis häufig auftritt und in der folgenden Abbildung dargestellt ist.

![Produzierender Verbraucher](images/termelo-fogyaszto.png)

!!! tip "Hersteller-Verbraucher vs `ThreadPool`"
    Wenn Sie darüber nachdenken, ist `ThreadPool` auch ein spezieller Hersteller-Verbraucher und Scheduler-Mechanismus, der uns von .NET zur Verfügung gestellt wird. Im Folgenden entwickeln wir eine andere Art von Hersteller-Verbraucher-Lösung, um einige mit der Fadenbehandlung verbundenen Wettbewerbsprobleme anzuschauen.

Der Hauptthread ist der Hersteller, der eine neue Aufgabe erstellt, falls die Taste *Calculate result* geklickt wird. Wir werden mehr Threads in der Verbraucher-/verarbeitenden Threads starten, da wir mehr CPU-Kerne verwenden und die Ausführung von Aufgaben parallelisieren können.

Für die Zwischenspeicherung von Aufgaben können wir die Klasse `DataFifo` (im Ordner `Data` im Solution Explorer) verwenden, die in unserem ursprünglichen Projekt bereits etwas vorbereitet ist. Schauen wir uns den Quellcode an. Es implementiert eine einfache FIFO-Warteschlange, um `double[]` zu speichern. Die Methode `Put` hängt die neuen Paare an das Ende der internen Liste an, während die Methode `TryGet` das erste Element der internen Liste zurückgibt (und entfernt). Wenn die Liste leer ist, kann die Funktion kein Element zurückgeben. In diesem Fall zeigt `false` dies durch einen Rückgabewert an.

1. Ändern wir den Ereignishandler der Taste so, dass er nicht in `ThreadPool`, sondern in FIFO arbeitet:

    ```cs hl_lines="7"
    private void CalculateResultButton_Click(object sender, RoutedEventArgs e)
    {
        if (double.TryParse(param1TextBox.Text, out var p1) && double.TryParse(param2TextBox.Text, out var p2))
        {
            var parameters = new double[] { p1, p2 };

            _fifo.Put(parameters);
        }
        else
            DisplayInvalidElementDialog();
    }
    ```

2. Erstellen wir eine naive Implementierung der neuen Fadenbehandlungsfunktion in unserer Formularklasse:

    ```cs
    private void WorkerThread()
    {
        while (true)
        {
            if (_fifo.TryGet(out var data))
            {
                double result = Algorithms.SuperAlgorithm.Calculate(data);
                ShowResult(data, result);
            }

            Thread.Sleep(500);
        }
    }
    ```

    Der Grund für die Einführung von `Thread.Sleep` ist, dass sich die Threads sonst unnötigerweise die ganze Zeit mit einem leeren FIFO beschäftigen würden, ohne irgendeine nützliche Operation auszuführen, und einen CPU-Kern zu 100% überlasten würden. Unsere Lösung ist nicht ideal, wir werden sie später verbessern.

3. Erstellen und starten wir die Verarbeitungsfäden im Konstruktor:

    ```cs
    new Thread(WorkerThread) { Name = "Worker thread 1" }.Start();
    new Thread(WorkerThread) { Name = "Worker thread 2" }.Start();
    new Thread(WorkerThread) { Name = "Worker thread 3" }.Start();
    ```

4. Starten wir die Anwendung und schließen wir sie sofort, ohne auf die Taste *Calculate Result* zu klicken. Unser Fenster wird geschlossen, aber unser Prozess läuft weiter, und die einzige Möglichkeit, die Anwendung zu schließen, ist über Visual Studio oder den Task-Manager:

    ![Fehlersuche beenden](images/stop-debugging.png)

    Die Verarbeitungsfäden sind Vordergrundfäden, die verhindern das Beenden der Prozess beim Schließen des Fensters. Eine Lösung könnte darin bestehen, die Eigenschaft `IsBackground` der Threads auf `true`zu setzen, nachdem sie erstellt wurden. Die andere Lösung stellt sicher, dass die Verarbeitungsfäden beim Beenden beendet werden. Lassen wir dieses Thema erst einmal beiseite, wir kommen später darauf zurück.

5. Starten wir die Anwendung und wir werden feststellen, dass wir nach dem Klicken auf die Taste *Calculate Result* (nur einmal klicken) höchstwahrscheinlich eine Ausnahme erhalten. Das Problem ist, dass `DataFifo` nicht fadensicher ist, es ist inkonsistent geworden. Hierfür gibt es zwei Ursachen:

### Problem 1

Betrachten wir das folgende Szenario:

1. Die Zeile ist leer. Die verarbeitenden Threads fragen den FIFO kontinuierlich in einer `while`-Schleife ab, d. h. sie rufen die Methode `TryGet` auf.
2. Der Benutzer fügt der Warteschlange eine Aufgabe hinzu.
3. Einer der Verarbeitungsfäden in der Methode `TryGet` stellt fest, dass Daten in der Zeile vorhanden sind, d. h. die Bedingung der Codezeile `if ( _innerList.Count > 0 )` ist erfüllt, und geht zur nächsten Codezeile über. Angenommen, dieser Thread verliert an dieser Stelle seine Durchführungsrecht, dann hat er keine Zeit mehr, die Daten aus der Warteschlange zu nehmen.
4. Ein anderer Verarbeitungsthread lässt die Prüfung von `if ( _innerList.Count > 0 )` zu diesem Zeitpunkt ebenfalls fallen, die Bedingung ist ebenfalls erfüllt, und dieser Thread nimmt die Daten aus der Warteschlange.
5. Der erste Thread wird neu geplant, wacht auf und versucht, die Daten aus der Warteschlange zu nehmen: die Warteschlange ist leer, der andere Thread hat die einzigen Daten aus der Warteschlange vor ihm genommen. Der Zugriff auf `_innerList[0]` führt daher zu einer Ausnahme.

Die einzige Möglichkeit, dieses Problem zu vermeiden, ist die Prüfung der Zeilenleere und die Elementausnahme unteilbar zu machen.

!!! note "Thread.Sleep(500)"
    Die Rolle der Codezeile `Thread.Sleep(500);`, die auf die Codezeile folgt, die die Leere-Prüfung in unserem Beispielcode überwacht, besteht nur darin, die Wahrscheinlichkeit zu erhöhen, dass das obige unglückliche Szenario eintritt, und somit das Beispiel anschaulicher zu machen (da es fast sicher ist, dass der Thread neu geplant wird). Wir werden dies in Zukunft herausnehmen, aber vorläufig lassen wir es drin.

### Problem 2

Die Klasse `DataFifo` kann von mehreren Threads gleichzeitig auf die Mitgliedsvariable `_innerList` mit der Typ `List<double[]>` zugreifen. Wenn wir uns jedoch die Dokumentation zu `List<T>` ansehen, werden wir feststellen, dass die Klasse nicht fadensicher (not thread safe) ist. Aber in diesem Fall können wir das nicht tun, wir müssen Sperren verwenden, um sicherzustellen, dass unser Code nur auf eine Methode/Eigenschaft/Mitgliedsvariable zur gleichen Zeit zugreifen kann (genauer gesagt, kann Inkonsistenz nur im Fall von gleichzeitigen Schreiben und Lesen auftreten, aber wir unterscheiden in den meisten Fällen nicht zwischen Lesern und Schreibern, und wir tun es hier auch nicht).

Der nächste Schritt ist, unsere Klasse `DataFifo` fadensicher zu machen, wodurch die beiden oben genannten Probleme vermieden werden.

## Aufgabe 6 - Die DataFifo-Klasse fadensicher machen

Um die Klasse `DataFifo` fadensicher zu machen, benötigen wir ein Objekt (dies kann ein beliebiges Objekt vom Referenztyp sein), das als Schlüssel zum Sperren verwendet wird. Mit dem Schlüsselwort `lock` können wir dann sicherstellen, dass sich jeweils nur ein Thread in den durch diesen Schlüssel geschützten Blöcken aufhält.

1.	Fügen wir ein Feld vom Typ `object` mit dem Namen `_syncRoot` zur Klasse `DataFifo` hinzu.

    ```cs
    private object _syncRoot = new object();
    ```

2. Ergänzen wir die Funktionen `Put` und `TryGet` mit dem Sperre.

    ```cs hl_lines="3-4 6"
    public void Put(double[] data)
    {
        lock (_syncRoot)
        {
            _innerList.Add(data); 
        }
    }
    ```

    ```cs hl_lines="3-4 16"
    public bool TryGet(out double[] data)
    {
        lock (_syncRoot)
        {
            if (_innerList.Count > 0)
            {
                Thread.Sleep(500);

                data = _innerList[0];
                _innerList.RemoveAt(0);
                return true;
            }

            data = null;
            return false;
        }
    }
    ```

    !!! tip "Surround with"
        Verwenden wir die Funktion *"Surround with"* von Visual Studio, indem Sie STRG + K, STRG + S auf dem ausgewählten Codeschnipsel drücken, den wir umschließen möchten.


Jetzt dürfen wir keine Ausnahme bekommen.

Wir können die künstliche Verzögerung auch aus der Methode `TryGet` entfernen ( Zeile`Thread.Sleep(500);` ).

!!! error "Sperre auf `this`"
    Es stellt sich die Frage, warum wir eine separate Membervariable `_syncRoot` eingeführt und diese als Sperrparameter für `lock` verwendet haben, wenn wir stattdessen auch `this` hätten verwenden können ( `DataFifo` ist der Referenztyp, daher wäre dies kein Problem). Die Verwendung von `this` **würde jedoch gegen die Einkapselung unserer Klasse verstoßen**! Erinnern wir uns: `this` ist ein Verweis auf unser Objekt, aber andere Klassen haben Verweise auf dasselbe Objekt (z.B. in unserem Fall `MainWindow`hat einen Verweis auf `DataFifo`), und wenn diese externen Klassen eine Sperre auf das Objekt setzen, indem sie `lock` verwenden, wird dies die Sperre "stören", die wir auf die Klasse darin verwenden (da die Verwendung von `this` dazu führt, dass die externen und internen `lock` denselben Parameter haben). Zum Beispiel kann eine externe Sperre verwendet werden, um die Operationen `TryGet` und `Put` vollständig "lahmzulegen". Im Gegensatz dazu ist in unserer Lösung der Parameter `lock`, die Variable `_syncRoot`, privat und kann nicht von externen Klassen aufgerufen werden, so dass sie die internen Abläufe unserer Klasse nicht beeinträchtigen kann.

## Aufgabe 7 - Implementierung einer effektiven Signalisierung

### Verwendung von ManualResetEvent

Die Schleife `while`, die in `WorkerThread`ständig läuft, implementiert ein sogenanntes aktives Warten, das immer vermieden werden sollte. Falls `Thread.Sleep` nicht in den Schleifenkern eingebaut worden wäre, wäre der Prozessor überlastet gewesen. `Thread.Sleep` löst zwar das Problem der CPU-Belastung, führt aber ein weiteres ein: Wenn sich alle drei Arbeitsfäden im Ruhezustand befinden, wenn neue Daten empfangen werden, warten wir unnötigerweise 500 ms, bevor wir mit der Verarbeitung der Daten beginnen.

Im Folgenden wird die Anwendung so geändert, dass sie in einem blockierten Zustand wartet, bis Daten zum FIFO hinzugefügt werden (aber wenn Daten hinzugefügt werden, beginnt sie sofort mit der Verarbeitung). Um anzuzeigen, ob sich Daten in der Warteschlange befinden, wird `ManualResetEvent`verwendet.

1. Fügen wir eine Instanz von `MaunalResetEvent` zu unserer Klasse `DataFifo` als `_hasData` hinzu.

    ```cs
    // Infolge des Konstruktorparameters false wird das Ereignis anfänglich nicht signalisiert (Tor geschlossen)
    private ManualResetEvent _hasData = new ManualResetEvent(false);
    ```

2. `_hasData` funktioniert als ein Tor in unserer Anwendung.  Wenn der Liste Daten hinzugefügt werden, wird sie "geöffnet", und wenn die Liste geleert wird, wird sie "geschlossen".

    !!! tip "Semantik und Benennung des Ereignisses"
        Es ist wichtig, die Semantik unseres Ereignisses gut zu wählen und wir im Namen unseres Ereignisses präzise auszudrücken. In unserem Beispiel drückt der Name `_hasData` aus, dass unser Ereignis genau dann und nur dann signalisiert wird, wenn es Daten zu verarbeiten gibt (Tor geöffnet). Jetzt müssen wir "nur" noch diese Semantik implementieren: das Ereignis signalisiert setzen, wenn Daten in den FIFO eingegeben werden, und nicht signalisiert, wenn der FIFO geleert wird.

    ```cs hl_lines="6"
    public void Put(double[] data)
    {
        lock (_syncRoot)
        {
            _innerList.Add(data);
            _hasData.Set();
        }
    }
    ```

    ```cs hl_lines="9-12"
    public bool TryGet(out double[] data)
    {
        lock (_syncRoot)
        {
            if (_innerList.Count > 0)
            {
                data = _innerList[0];
                _innerList.RemoveAt(0);
                if (_innerList.Count == 0)
                {
                    _hasData.Reset();
                }

                return true;
            }

            data = null;
            return false;
        }
    }
    ```

### Warten auf Signal (Get blockiert)

In dem vorherigen Punkt wurde die Signalisierung gelöst, aber das sich selbst macht nicht viel, weil niemand auf das Signal wartet. Diese Erkenntnis kommt jetzt.

1. Ändern wir die Methode wie folgt: Entfernen wir den Leere-Test und ersetzen wir ihn durch Warten auf das Ereignis.

    ```cs hl_lines="5"
    public bool TryGet(out double[] data)
    {
        lock (_syncRoot)
        {
            if (_hasData.WaitOne())
            {
                // ...
    ```
   
    !!! note "Prüfung des Rückgabewerts der Operation WaitOne"
        Die Operation `WaitOne` gibt den Wert `bool` zurück, der wahr ist, wenn sich das Ereignis vor der im Parameter von `WaitOne` angegebenen Zeitspanne signalisiert wird (und entsprechend falsch, wenn die Zeitspanne abgelaufen ist). In unserem Beispiel haben wir im Parameter kein Zeitlimit angegeben, was eine unendliche Zeitspanne bedeutet. Dementsprechend ist die Prüfung der Bedingung `if` überflüssig, da in unserem Fall `WaitOne()` immer einen wahren Wert liefert. Dies ist der einzige Grund, warum wir dennoch die Konditionstests verwendet haben: Wir erfordern weniger Änderungen für die nächste und eine zukünftige Übung.

2. Dies macht `Thread.Sleep` in `WorkerThread` überflüssig, kommentieren wir es aus!

    Wenn wir die obige Lösung ausführen, werden wir feststellen, dass die Oberfläche unserer Anwendung nach dem ersten Tastendruck einfriert. Bei unserer vorherigen Lösung haben wir einen Anfängerfehler gemacht. In dem gesperrten Codeschnipsel warten wir darauf, dass `_hasData` gesendet wird, so dass der Hauptthread keine Gelegenheit hat, `_hasData` in der Operation `Put` zu senden (ebenfalls geschützt durch `lock`). **In der Praxis wurde eine Verklemmung (deadlock) gebildet.**

    Wir könnten versuchen, ein Zeitlimit (ms) für die Wartezeit festzulegen:

    ```cs
    if (_hasData.WaitOne(100))
    ```

    Dies wäre an sich keine elegante Lösung, außerdem würden die ständig verschmutzenden Arbeitsfäden den Thread, der Put aufruft, erheblich aushungern! Stattdessen ist das elegante Muster zu folgen, um zu vermeiden, dass man innerhalb einer Sperre blockiert wartet.

    Tauschen wir `lock` und `WaitOne` um, und entfernen wir die Wartezeitbegrenzung, also den Parameter von `WaitOne`:

    ```cs hl_lines="3-6"
    public bool TryGet(out double[] data)
    {
        if (_hasData.WaitOne())
        {
            lock (_syncRoot)
            {
                data = _innerList[0];
                _innerList.RemoveAt(0);
                if (_innerList.Count == 0)
                {
                    _hasData.Reset();
                }

                return true; 
            }
        }

        data = null;
        return false;
    }
    ```

    Probieren wir die App aus. Wenn wir die Taste zum ersten Mal drücken, erhalten wir eine Ausnahme. Dadurch wird zwar ein Deadlock vermieden, **aber die Fadensicherheit ist verletzt**, weiles ist nicht sicher, dass wenn wir in `lock` eintreten können, noch Elemente in der Liste vorhanden sind. Es kann mehrere Threads geben, die mit `_hasData.WaitOne()` darauf warten, dass ein Element zu der Liste hinzugefügt wird. Wenn dies geschieht, wird unser `ManualResetEvent` Objekt alle durchlassen (außer wenn ein Thread schließt es schnell, aber das ist nicht garantiert).

    !!! note "Die Schwierigkeiten der Programmierung in einer konkurrierenden, mehrfädigen Umgebung"
        Diese Aufgabe veranschaulicht, wie sorgfältig man bei der Programmierung in einer konkurrierenden, mehrfädigen Umgebung vorgehen muss. Bei den vorherigen hatten wir sogar noch Glück, denn der Fehler war reproduzierbar. In der Praxis ist dies jedoch selten der Fall. Leider ist es viel häufiger der Fall, dass Konkurenzprobleme gelegentliche, nicht reproduzierbare Probleme verursachen. Die Lösung einer solchen Aufgabe muss immer sehr sorgfältig durchdacht sein und kann nicht nach dem Motto "wir-probieren-es-solange-es-wird-gut-im-per-Hand-Test" programmiert werden.


3. Als Korrektur setzen wir den Leertest in `lock` zurück.

    ```cs hl_lines="7-8 17"
    public bool TryGet(out double[] data)
    {
        if (_hasData.WaitOne())
        {
            lock (_syncRoot)
            {
                if (_innerList.Count > 0)
                {
                    data = _innerList[0];
                    _innerList.RemoveAt(0);
                    if (_innerList.Count == 0)
                    {
                        _hasData.Reset();
                    }

                    return true;  
                }
            }
        }

        data = null;
        return false;
    }
    ```

    Dies funktioniert bereits gut. Es ist möglich, dass wir unnötigerweise auf die Liste eingehen, aber wir belassen es vorerst dabei.

    Testen wir die App!

!!! note "System.Collections.Concurrent"
    Im .NET-Framework gibt es mehrere eingebaute fadensichere Klassen im Namensraum `System.Collections.Concurrent`.  In dem obigen Beispiel hätte die Klasse `DataFifo` durch `System.Collections.Concurrent.ConcurrentQueue` ersetzt werden können.

## Aufgabe 8 - Kulturelle Abschaltung

Bisher haben wir das Problem, dass unser Prozess beim Schließen des Fensters "stecken bleibt", weil die Verarbeitungsthreads Vordergrundfäden sind und wir das Problem des Beendens dieser Threads nicht gelöst haben. Unser Ziel ist es, den unendlichen `while`-Schleife auszulösen, so dass unsere Arbeitsfäden auf zivilisierte Weise beendet werden, wenn die Anwendung geschlossen wird.

1. Ein `ManualResetEvent` wird verwendet, um das Beenden im FIFO anzuzeigen, während in `TryGet`gewartet wird. Fügen wir im FIFO ein neues `ManualResetEvent` hinzu und führen wir eine `Release`-Operation ein, um unsere Wartezeiten zu verkürzen (unser neues Ereignis kann auf einen signalisierten Zustand gesetzt werden).

    ```cs
    private ManualResetEvent _releaseTryGet = new ManualResetEvent(false);

    public void Release()
    {
        _releaseTryGet.Set();
    }
    ```

2.	Warten wir auf diese Ereignis auch in `TryGet`. Die Methode `WaitAny` darf die Ausführung fortsetzen, wenn sich eines der als Parameter angegebenen Objekte vom Typ `WaitHandle` signalisiert ist, und gibt dessen Index innerhalb der Block zurück. Und wir wollen die tatsächliche Verarbeitung nur, wenn `_hasData` signalisiert ist (wenn `WaitAny` 0 zurückgibt).

    ```cs hl_lines="3"
    public bool TryGet(out double[] data)
    {
        if (WaitHandle.WaitAny(new[] { _hasData, _releaseTryGet }) == 0)
        {
            lock (_syncRoot)
            {
    ```

3. Fügen wir eine flag Variable in `MainWindow.xaml.cs` hinzu, um das Beenden anzuzeigen:

    ```cs
    private bool _isClosed = false;
    ```

4. Wenn das Hauptfenster geschlossen wird, setzen wir das neue Ereignis auf signalisiert und setzen wir auch das Flag auf true: abonnieren wir uns auf das Ereignis `Closed` der Klasse `MainWindow` im Konstruktor und schreiben wir die entsprechende Ereignishandler:

    ```cs
    public MainWindow()
    {
        ...

        Closed += MainWindow_Closed;
    }

    private void MainWindow_Closed(object sender, WindowEventArgs args)
    {
        _isClosed = true;
        _fifo.Release();
    }
    ```

5. Schreiben wir die while-Schleife so um, dass sie auf das im vorigen Punkt addierte Flag wartet.

    ```cs hl_lines="3"
    private void WorkerThread()
    {
        while (!_isClosed)
        {
    ```

6. Stellen wir sicher, dass wir nicht versuchen, Nachrichten für ein Fenster zu senden, das bereits geschlossen ist

    ```cs hl_lines="3-4"
    private void ShowResult(double[] parameters, double result)
    {
        if (_isClosed)
		    return;
    ```

7. Führen wir die Anwendung aus und überprüfen wir, ob unser Prozess tatsächlich beendet wird, wenn wir ihn beenden.

## Ausblick: Task, async, await

Ziel der Übung war es, die Techniken für das Management von Fäden auf unterer Ebene kennen zu lernen. Wir hätten unsere Lösung jedoch (zumindest teilweise) auf den übergeordneten Werkzeugen und Mechanismen aufbauen können, die die asynchrone Programmierung in .NET unterstützen, z. B. die Klassen `Task`/`Task<T>` und die Schlüsselwörter `async`/`await`. 
