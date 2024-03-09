---
autoren: Zoltán Szabó,kszicsillag,bzolka
---
# 4. Erstellung von Multithreading-Anwendungen

## Das Ziel der Übung

Ziel der Übung ist es, die Studierenden mit den Grundsätzen vertraut zu machen, die bei der Programmierung mit mehreren Threads beachtet werden müssen. Behandelte Themen (unter anderem):

- Einen Thread starten (`Thread`)
- Anhalten der Fasern
- Erstellen von thread-sicheren Klassen mit dem Schlüsselwort `lock` 
- `ThreadPool` verwenden
- Signalisieren und Warten auf Signal-Thread-Synchronisation über `ManualResetEvent` (`WaitHandle`)
- Besonderheiten des WinUI-Threadings (`DispatcherQueue`)

Da das Thema sehr umfangreich ist, werden Sie natürlich nur Grundkenntnisse erwerben, aber mit diesem Wissen werden Sie in der Lage sein, komplexere Aufgaben selbständig zu bearbeiten.

Verwandte Präsentationen: Entwicklung konkurrierender (Multithreading-) Anwendungen.

## Voraussetzungen

Die für die Durchführung der Übung benötigten Werkzeuge:

- Visual Studio 2022
    - Windows Desktop Entwicklung Workload
- Betriebssystem Windows 10 oder Windows 11 (Linux und macOS nicht geeignet)

## Lösung

??? success "Laden Sie die fertige Lösung herunter"
    :exclamation: Es ist wichtig, dass Sie sich während des Praktikums an die Anleitung halten. Es ist verboten (und sinnlos), die fertige Lösung herunterzuladen. Allerdings kann es bei der anschließenden Selbsteinübung nützlich sein, die fertige Lösung zu überprüfen, daher stellen wir sie zur Verfügung.

    Die Lösung ist [verfügbar auf GitHub] (https://github.com/bmeviauab00/lab-tobbszalu-kiindulo/tree/megoldas). Der einfachste Weg, es herunterzuladen, ist, den `git clone`-Zweig von der Kommandozeile aus zu klonen:

    `git clone https://github.com/bmeviauab00/lab-tobbszalu-kiindulo -b solved`

    Sie müssen Git auf Ihrem Rechner installiert haben, weitere Informationen [hier](../../hazi/git-github-github-classroom/index.md#git-telepitese).

## Einführung

Die Verwaltung parallel laufender Threads ist ein Bereich mit hoher Priorität, den alle Softwareentwickler zumindest in Grundzügen kennen sollten. In der Übung lösen wir grundlegende, aber vorrangige Probleme, so dass wir uns bemühen sollten, nicht nur das Endergebnis, sondern auch die Bedeutung und die Gründe für die von uns vorgenommenen Änderungen zu verstehen.

In dieser Übung werden wir einer einfachen WinUI-Anwendung Multithreading-Fähigkeiten hinzufügen und zunehmend komplexere Aufgaben lösen. Das Grundproblem ist folgendes: Wir haben eine Funktion, die lange läuft, und wie wir sehen werden, hat der "direkte" Aufruf über die Schnittstelle unangenehme Folgen. Die Lösung besteht darin, eigene Codeschnipsel zu einer bestehenden Anwendung hinzuzufügen. Neue Zeilen, die eingefügt werden sollen, sind in der Anleitung durch einen hervorgehobenen Hintergrund gekennzeichnet.

## 0. Aufgabe - Kennenlernen des Erstantrags, Vorbereitung

Klonen Sie [das Repository](https://github.com/bmeviauab00/lab-tobbszalu-kiindulo) der ursprünglichen Anwendung für Übung 4:

- Öffnen Sie eine Eingabeaufforderung
- Navigieren Sie zu einem Ordner Ihrer Wahl, zum Beispiel c:workNEPTUN
- Geben Sie den folgenden Befehl ein: `git clone https://github.com/bmeviauab00/lab-tobbszalu-kiindulo.git`
- Öffnen Sie die Lösung *SuperCalculator.sln* in Visual Studio.

Unsere Aufgabe ist es, eine Benutzeroberfläche zu erstellen, um einen Algorithmus in binärer Form unter Verwendung der WinUI-Technologie auszuführen. Die binäre Form von .NET ist eine Datei mit der Erweiterung *.dll*, die in der Programmiersprache eine Klassenbibliothek darstellt.  In unserem Fall lautet der Dateiname *Algorithms.dll*, der sich im geklonten Git-Repository befindet.

Bei der Erstanwendung ist die Benutzeroberfläche bereits vorbereitet. Führen Sie die Anwendung aus:

![starthilfe](images/starter.png)

In der Anwendungsschnittstelle können wir die Eingabeparameter des Algorithmus angeben (`double` array of numbers): in unserem Beispiel rufen wir den Algorithmus immer mit zwei Parametern auf `double` numbers, die in den beiden oberen Textfeldern angegeben werden können.
Unsere Aufgabe ist es, den Algorithmus mit den angegebenen Parametern auszuführen, indem wir auf die Schaltfläche *Calculate Result* klicken, und wenn er fertig ist, das Ergebnis mit den Eingabeparametern in einer neuen Zeile des Listenfeldes unterhalb des *Results* anzuzeigen.

Machen wir uns nun mit der heruntergeladenen Visual Studio-Lösung vertraut:

Die Rahmenanwendung ist eine auf WinUI 3 basierende Anwendung. Die Schnittstelle ist grundsätzlich fertig, ihre Definition ist in der Datei `MainWindow.xaml` zu finden. Dies ist für uns im Hinblick auf den Zweck der Übung weniger aufregend, aber es lohnt sich, sie zu Hause zu üben.

??? note "Gestaltung der Schnittstelle in `MainWindow.xaml`"

       Grundlagen der Gestaltung von Fensterflächen:
       
       - Die Wurzel ist "normalerweise" ein `Grid`. 
       - In der obersten Zeile des Wurzelgitters befindet sich das "StackPanel", das die beiden "Textboxen" und die Schaltfläche enthält.
       - Die unterste Zeile des Wurzel-"Grid" enthält ein weiteres "Grid". Im Gegensatz zur "TextBox" hat die "ListBox" keine "Header"-Eigenschaft, so dass wir diese als separaten "TextBlock" mit einem "Ergebnis"-Text einführen mussten. Dieses `Grid` wurde eingeführt (anstelle eines "einfacheren" `StackPanel`), weil es möglich war, den `TextBlock` in der oberen Zeile mit einer festen Höhe für das "Ergebnis" und die `ListBox` in der unteren Zeile so zu haben, dass sie den gesamten verbleibenden Platz ausfüllt (die Höhe der oberen Zeile ist `Auto`, die Höhe der unteren Zeile ist `*`).
       - Die Schaltfläche mit dem Text "Ergebnis berechnen" ist ein gutes Beispiel dafür, dass der `Inhalt` einer `Schaltfläche` oft nicht nur ein einfacher Text ist. Das Beispiel zeigt eine Komposition aus einem `SymbolIcon` und einem `TextBlock` (implementiert mit `StackPanel`), so dass wir ein geeignetes Icon/Symbol zuweisen können, um sein Aussehen zu verbessern.
       - Wir sehen auch ein Beispiel dafür, wie man eine `ListBox` scrollbar macht, wenn sie bereits viele Elemente enthält (oder die Elemente zu breit sind). Dazu muss der `ScrollViewer` richtig parametrisiert werden.
       - Die Eigenschaft `ItemContainerStyle` der `ListBox` wird verwendet, um Stile für das Element `ListBox` festzulegen. Im Beispiel ist "Padding" auf einen kleineren Wert als den Standardwert eingestellt, da sonst die Höhe der "ListBox"-Elemente verschwenderisch wäre.

Die Quelldatei `MainWindow.xaml.cs` ist der Code hinter der Datei für das Hauptfenster, lassen Sie uns diese überprüfen, ihre Hauptelemente sind wie folgt:

- Um das Ergebnis und die Parameter auf `ListBox`zu protokollieren, gibt es eine Hilfsfunktion namens `ShowResult`. 
-  `CalculateResultButton_Click` ist der Event-Handler für das Anklicken der Schaltfläche " *Ergebnis berechnen* ". Wir sehen, dass er den Wert der Parameter aus den beiden Textfeldern liest und versucht, ihn in eine Zahl umzuwandeln. Wenn er erfolgreich ist, wird der Algorithmus hier aufgerufen (dies ist noch nicht implementiert), oder wenn er fehlschlägt, wird der Benutzer über `DisplayInvalidElementDialog` in einem Nachrichtenfenster über ungültige Parameter informiert.
- Die Funktion `AddKeyboardAcceleratorToChangeTheme`, die vom Konstruktor aufgerufen wird, ist für uns nicht relevant, sie ermöglicht das Umschalten zwischen hellen und dunklen Themen (Sie sollten es zur Laufzeit ausprobieren, ++ctrl+t++ ).

### Verwendung des Codes in der DLL

Im ursprünglichen Projekt finden wir die *Datei Algorithm.dll.* In dieser kompilierten Form gibt es eine Klasse `SuperAlgorithm` im Namensraum `Algorithms`, die eine statische Operation namens `Calculate` hat. Um die Klassen einer DLL in einem Projekt verwenden zu können, müssen Sie in Ihrem Projekt einen Verweis auf die DLL hinzufügen.

1. Klicken Sie im Projektmappen-Explorer mit der rechten Maustaste auf den Knoten *Abhängigkeiten* Ihres Projekts und wählen Sie *Projektreferenz hinzufügen* 

    ![Projektreferenz hinzufügen](images/add-project-ref.png)

    !!! note "Externe Referenzen"

        Hier verweisen wir eigentlich nicht auf ein anderes Visual Studio-Projekt, aber dies ist der einfachste Weg, dieses Fenster aufzurufen.

        Es sollte auch erwähnt werden, dass wir für externe Klassenbibliotheken keine DLLs mehr in einem regulären Projekt referenzieren, sondern die externen Pakete aus dem NuGet-Repository des .NET-Paketmanagers beziehen. Nun ist _Algorithm.dll_ in unserem Fall nicht in NuGet veröffentlicht, so dass wir sie manuell hinzufügen müssen.

2. Verwenden Sie die Schaltfläche *Durchsuchen* in der rechten unteren Ecke des Popup-Fensters, wählen Sie die Datei *Algorithms.dll* im Unterordner *External* Ihres Projekts aus und klicken Sie auf OK, um das Hinzufügen zu bestätigen

Im Projektmappen-Explorer können Sie auf den Knoten *Abhängigkeiten* unter einem Projekt klicken, um die referenzierten externen Abhängigkeiten anzuzeigen. Der Verweis auf Algorithmen, der zuvor in Baugruppen enthalten war, wird nun auch hier angezeigt. Die Kategorie Frameworks enthält die .NET Framework-Pakete. Und Analyzer sind Werkzeuge für die statische Codeanalyse zur Kompilierzeit. Oder es gäbe auch die Projekt- oder NuGet-Referenzen.

![Abhängigkeiten](images/dependencies.png)

Klicken Sie mit der rechten Maustaste auf die Referenz Algorithms und wählen Sie *View in Object Browser*. Dies öffnet die Registerkarte Objektbrowser, in der Sie sehen können, welche Namespaces, Klassen und deren Mitglieder (Membervariable, Memberfunktion, Eigenschaft, Ereignis) in der angegebenen DLL enthalten sind. Visual Studio liest diese aus den DLL-Metadaten mit Hilfe des so genannten Reflection-Mechanismus (wir können diesen Code selbst schreiben).

Wie in der Abbildung unten dargestellt, suchen Sie im Objektbrowser den Knoten Algorithmen auf der linken Seite, öffnen ihn und sehen, dass er einen Namensraum `Algorithms` und eine Klasse `SuperAlgorithm` enthält. Wenn Sie dies auswählen, werden die Funktionen der Klasse in der Mitte angezeigt, und wenn Sie hier eine Funktion auswählen, wird die genaue Signatur dieser Funktion angezeigt:

![Objekt-Browser](images/object-browser.png)

## 1. Task - Ausführen einer Operation auf dem Hauptthread

Jetzt können wir mit der Ausführung des Algorithmus fortfahren. Zunächst tun wir dies im Hauptthread unserer Anwendung.

1. Im Event-Handler der Schaltfläche `Click` im Hauptfenster rufen wir unsere Zählerfunktion auf. Öffnen Sie dazu die Datei `MainWindow.xaml.cs` code behind im Projektmappen-Explorer und suchen Sie nach `CalculateResultButton_Click` event handler. Vervollständigen Sie den Code durch den Aufruf des neu aufgerufenen Algorithmus.

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

2. Probieren wir die Anwendung aus und stellen fest, dass das Fenster während der Berechnung nicht auf Verschieben oder Größenänderung reagiert, die Schnittstelle friert praktisch ein.

Unsere Anwendung ist ereignisgesteuert, wie alle Windows-Anwendungen. Das Betriebssystem benachrichtigt unsere Anwendung über die verschiedenen Interaktionen (z. B. Verschieben, Größenänderung, Mausklick): Da der einzige Thread unserer Anwendung nach dem Tastendruck mit der Berechnung beschäftigt ist, kann er nicht sofort weitere Benutzeranweisungen verarbeiten. Sobald die Berechnung abgeschlossen ist (und die Ergebnisse in der Liste angezeigt werden), werden die zuvor erhaltenen Befehle ausgeführt.

## 2. Aufgabe - Durchführung der Berechnung in einem separaten Thread

Im nächsten Schritt werden wir einen separaten Thread starten, um die Berechnung durchzuführen, damit die Benutzeroberfläche nicht blockiert wird.

1. Erstellen Sie eine neue Funktion in der Klasse `MainWindow`, die der Einstiegspunkt für den Verarbeitungs-Thread sein wird.

    ```cs
    private void CalculatorThread(object arg)
    {
        var parameters = (double[])arg;
        var result = Algorithms.SuperAlgorithm.Calculate(parameters);
        ShowResult(parameters, result);
    }
    ```

2. Starten Sie den Thread in der Ereignisverwaltung der Schaltfläche `Click`.  Ersetzen Sie dazu den Code, den Sie zuvor hinzugefügt haben:

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

    Der in der Operation `Start` des Thread-Objekts übergebene Parameter wird an unsere Thread-Funktion `CalculatorThread` übergeben.

3. Führen Sie die Anwendung ++mit f5++aus (jetzt ist es wichtig, sie so auszuführen, im Debugger)! *Die Anwendung rief eine Schnittstelle auf, die für einen anderen Thread bereitgestellt wurde. (0x8001010E (RPC_E_WRONG_THREAD))* Fehlermeldung in der Methode `ShowResult`, weil wir nicht versuchen, auf das UI-Element/Controller von dem Thread aus zuzugreifen, der es erstellt hat (der Controller). In der nächsten Übung werden wir dieses Problem analysieren und lösen.

## 3. Aufgabe - verwenden Sie `DispatcherQueue.HasThreadAccess` und `DispatcherQueue.TryEnqueue` 

Das Problem im vorigen Punkt hat folgende Ursachen. Für WinUI-Anwendungen gilt folgende Regel: Fenster/Oberflächen/Steuerelemente sind standardmäßig keine thread-sicheren Objekte, so dass **auf ein Fenster/Oberfläche/Steuerelement nur von einem Thread aus zugegriffen werden sollte (**z. B.
i **n** unserer Anwendung gibt es eine Ausnahme, da das `resultListBox` Steuerelement im Haupt-Thread erstellt wird, aber in der `ShowResult` Methode, wenn das Ergebnis angezeigt wird, wird von einem anderen Thread aus darauf zugegriffen (Aufruf der`resultListBox.Items.Add` Aktion).

Die Frage ist, wie auf diese Schnittstellen/Controller von einem anderen Thread aus noch irgendwie zugegriffen werden kann. Die Lösung besteht in der Verwendung von `DispatcherQueue`, um sicherzustellen, dass der Zugriff auf die Steuerelemente immer über den richtigen Thread erfolgt:

- `DispatcherQueue` des `TryEnqueue` -Objekts führt die als Parameter angegebene Funktion auf dem Thread aus, der das Steuerelement erstellt (von dem aus Sie nun direkt auf das Steuerelement zugreifen können).
- Die Eigenschaft `HasThreadAccess` des Objekts `DispatcherQueue` hilft bei der Entscheidung, ob es notwendig ist, `TryEnqueue` zu verwenden, wie im vorherigen Abschnitt erwähnt. Wenn die Immobilie
    - wahr ist, kann auf den Controller direkt zugegriffen werden (weil der aktuelle Thread derselbe ist wie der Thread, der den Controller erstellt hat), aber wenn
    - falsch ist, kann auf den Controller nur unter Umgehung des `DispatcherQueue` Objekts `TryEnqueue` zugegriffen werden (da der aktuelle Thread NICHT mit dem Thread identisch ist, der den Controller erstellt hat).

Mit `DispatcherQueue` können wir also unsere vorherige Ausnahme vermeiden (der Zugriff auf den Controller, in diesem Fall `resultListBox`, kann an den entsprechenden Thread "geleitet" werden). Wir werden dies im Folgenden tun.

!!! Hinweis
    Das Objekt `DispatcherQueue` ist in Nachkommen der Klasse Window über die Eigenschaft`DispatcherQueue` verfügbar (und in anderen Klassen über die statische Operation `DispatcherQueue.GetForCurrentThread()` ).

Wir müssen die Methode `ShowResult` so ändern, dass sie keine Ausnahme auslöst, wenn sie von einer Erweiterung aus aufgerufen wird.

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

Diese Lösung ist bereits einsatzbereit und besteht im Wesentlichen aus folgenden Elementen:

- Die Rolle des `DispatcherQueue` `null` -Scans: Nach dem Schließen des Hauptfensters ist `DispatcherQueue` nicht mehr `null`, es kann nicht verwendet werden.
- Die `DispatcherQueue.HasThreadAccess` wird verwendet, um zu prüfen, ob der aufrufende Thread direkt auf die Controller zugreifen kann (in unserem Fall `ListBox`):
    - Wenn ja, wird alles wie bisher gehandhabt, der Code für `ListBox`bleibt unverändert.
    - Falls nicht, können Sie über `DispatcherQueue.TryEnqueue` auf den Controller zugreifen. Dabei wird der folgende Trick angewendet. Die Funktion `TryEnqueue` erhält eine parameterlose, einzeilige Funktion in Form eines Lambda-Ausdrucks, der unsere Funktion `ShowResult` aufruft (effektiv rekursiv) und ihr die Parameter übergibt. Das ist gut für uns, weil dieser `ShowResult` -Aufruf bereits auf dem Thread erfolgt, der den Controller erstellt hat (dem Hauptthread der Anwendung), der Wert von `HasThreadAccess` ist jetzt wahr, und wir können direkt auf unser `ListBox`zugreifen. Dieser rekursive Ansatz ist ein gängiges Muster, um redundanten Code zu vermeiden.
  
Setzen Sie einen Haltepunkt in der ersten Zeile der Operation `ShowResult`, und führen Sie die Anwendung aus, um sicherzustellen, dass `HasThreadAccess` falsch ist, wenn `ShowResult` zum ersten Mal aufgerufen wird (also wird `TryEnqueue` aufgerufen), und dann wird `ShowResult` erneut aufgerufen, aber `HasThreadAccess` ist wahr.

Nehmen Sie den Haltepunkt heraus und führen Sie die Anwendung aus: Beachten Sie, dass Sie, während eine Berechnung läuft, eine andere starten können, da Ihre Schnittstelle durchgehend ansprechbar bleibt (und der Fehler, der zuvor auftrat, nicht mehr auftritt).

## 4. problem 1 - Ausführen einer Operation auf einem Threadpool-Thread

Eine Besonderheit der bisherigen Lösung ist, dass sie immer einen neuen Thread für die Operation erstellt. In unserem Fall ist dies nicht besonders wichtig, aber dieser Ansatz kann für eine Serveranwendung, die eine große Anzahl von Anfragen bedient, problematisch sein, da für jede Anfrage ein eigener Thread gestartet wird. Aus zwei Gründen:

- Wenn die Thread-Funktion schnell läuft (um einen Client schnell zu bedienen), dann wird ein großer Teil der CPU für das Starten und Stoppen von Threads verschwendet, was an sich schon ressourcenintensiv ist.
- Es können zu viele Threads erstellt werden, und das Betriebssystem muss zu viele planen, was unnötig Ressourcen verschwendet.
  
Ein weiteres Problem mit unserer derzeitigen Lösung: Da die Berechnung **auf einem** so genannten **Vordergrund-Thread** läuft (neu erstellte Threads sind standardmäßig Vordergrund-Threads), läuft das Programm selbst dann im Hintergrund weiter, wenn Sie die Anwendung schließen, bis die letzte Berechnung ausgeführt wurde: Ein Prozess hört erst auf zu laufen, wenn er keinen Vordergrund-Thread mehr hat.

Ändern Sie den Event-Handler der Schaltfläche, um die Berechnung in einem **Threadpool-Thread** auszuführen, anstatt einen neuen Thread zu starten. Um dies zu tun, schreiben Sie einfach den Event-Handler für das Drücken der Schaltfläche um.

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

Probieren wir die Anwendung aus und stellen fest, dass die Anwendung sofort anhält, wenn das Fenster geschlossen wird, ohne sich um eventuell noch laufende Threads zu kümmern (denn Threadpool-Threads sind Hintergrund-Threads).

## 5. Aufgabe - Erzeuger-Verbraucher-basierte Lösung

Allein durch die Lösung der vorangegangenen Probleme erhielten wir eine vollständige und gut funktionierende Lösung für das ursprüngliche Problem, die es ermöglicht, dass mehrere Threads parallel im Hintergrund arbeiten, wenn die Taste viele Male hintereinander gedrückt wird. Im Folgenden werden wir unsere Anwendung so modifizieren, dass ein Tastendruck nicht immer einen neuen Thread erzeugt, sondern die Aufgaben in eine Aufgabenwarteschlange stellt, aus der mehrere im Hintergrund laufende Threads sie nacheinander auswählen und ausführen. Bei dieser Aufgabe handelt es sich um das klassische Erzeuger-Verbraucher-Problem, das in der Praxis häufig auftritt und in der folgenden Abbildung dargestellt ist.

![Produzierender Verbraucher](images/termelo-fogyaszto.png)

!!! tip "Producer-Consumer vs `ThreadPool`"
    Wenn Sie darüber nachdenken, ist `ThreadPool` auch ein spezieller Producer-Consumer- und Scheduler-Mechanismus, der uns von .NET zur Verfügung gestellt wird. Im Folgenden entwickeln wir eine andere Art von Erzeuger-Verbraucher-Lösung für einige der mit der Faserbewirtschaftung verbundenen Wettbewerbsprobleme.

Der Hauptthread ist der Producer, der eine neue Aufgabe erstellt, indem er auf die Schaltfläche *Ergebnis berechnen* klickt. Wir werden mehr Threads in der konsumierenden/verarbeitenden Arbeitslast starten, da wir mehr CPU-Kerne verwenden und die Ausführung von Aufgaben parallelisieren können.

Für die Zwischenspeicherung von Aufgaben können wir die Klasse `DataFifo` (im Ordner `Data` im Projektmappen-Explorer) verwenden, die in unserem ursprünglichen Projekt bereits etwas vorbereitet ist. Schauen wir uns den Quellcode an. Es implementiert eine einfache FIFO-Warteschlange, um `double[]` zu speichern. Die Methode `Put` hängt die neuen Paare an das Ende der internen Liste an, während die Methode `TryGet` das erste Element der internen Liste zurückgibt (und entfernt). Wenn die Liste leer ist, kann die Funktion kein Element zurückgeben. In diesem Fall zeigt `false` dies durch einen Rückgabewert an.

1. Ändern Sie den Event-Handler der Schaltfläche so, dass er nicht in `ThreadPool`, sondern in FIFO arbeitet:

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

2. Erstellen Sie eine naive Implementierung der neuen Thread-Handler-Funktion in Ihrer Formularklasse:

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

    Der Grund für die Einführung von `Thread.Sleep` ist, dass sich die Threads sonst unnötigerweise die ganze Zeit mit einem leeren FIFO drehen würden, ohne irgendeinen nützlichen Vorgang auszuführen, und einen CPU-Kern zu 100% überlasten würden. Unsere Lösung ist nicht ideal, wir werden sie später verbessern.

3. Erstellen und starten Sie die Verarbeitungs-Threads im Konstruktor:

    ```cs
    new Thread(WorkerThread) { Name = "Worker thread 1" }.Start();
    new Thread(WorkerThread) { Name = "Worker thread 2" }.Start();
    new Thread(WorkerThread) { Name = "Worker thread 3" }.Start();
    ```

4. Starten Sie die Anwendung und schließen Sie sie sofort, ohne auf die Schaltfläche *Ergebnis berechnen* zu klicken. Unser Fenster wird geschlossen, aber unser Prozess läuft weiter, und die einzige Möglichkeit, die Anwendung zu schließen, ist über Visual Studio oder den Task-Manager:

    ![Fehlersuche beenden](images/stop-debugging.png)

    Bei den Verarbeitungsfasern handelt es sich um Vorfilamente, die verhindern, dass der Prozess am Ausgang abbricht. Eine Lösung könnte darin bestehen, die Eigenschaft `IsBackground` der Threads auf `true`zu setzen, nachdem sie erstellt wurden. Die andere Lösung besteht darin, sicherzustellen, dass die Verarbeitungs-Threads beim Beenden beendet werden. Lassen wir dieses Thema erst einmal beiseite, wir kommen später darauf zurück.

5. Starten Sie die Anwendung und Sie werden feststellen, dass Sie nach dem Klicken auf die Schaltfläche *Ergebnis berechnen* (nur einmal klicken) höchstwahrscheinlich eine Ausnahme erhalten. Das Problem ist, dass `DataFifo` nicht thread-sicher ist, es ist inkonsistent geworden. Hierfür gibt es zwei Ursachen:

### Problem 1

Betrachten wir das folgende Szenario:

1. Die Zeile ist leer. Die verarbeitenden Threads fragen den FIFO kontinuierlich in einer `while` -Schleife ab, d. h. sie rufen die Methode `TryGet` auf.
2. Der Benutzer fügt der Warteschlange eine Aufgabe hinzu.
3. Einer der Verarbeitungsstränge in der Methode `TryGet` stellt fest, dass Daten in der Zeile vorhanden sind, d. h. die Bedingung `if ( _innerList.Count > 0 )` code line ist erfüllt, und geht zur nächsten Codezeile über. Angenommen, dieser Thread verliert an dieser Stelle seine Laufzeit, dann hat er keine Zeit mehr, die Daten aus der Warteschlange zu nehmen.
4. Ein anderer Verarbeitungsthread lässt die Prüfung von `if ( _innerList.Count > 0 )` zu diesem Zeitpunkt ebenfalls fallen, die Bedingung ist ebenfalls erfüllt, und dieser Thread nimmt die Daten aus der Warteschlange.
5. Der erste Thread wird neu geplant, wacht auf und versucht, die Daten aus der Warteschlange zu nehmen: die Warteschlange ist leer, der andere Thread hat die einzigen Daten aus der Warteschlange vor ihm genommen. Der Zugriff auf `_innerList[0]` führt daher zu einer Ausnahme.

Die einzige Möglichkeit, dieses Problem zu vermeiden, besteht darin, die Prüfung der Zeilenleere und die Elementausnahme unteilbar zu machen.

!!! note "Thread.Sleep(500)"
    Die Rolle der Code-Zeile `Thread.Sleep(500);`, die auf die Code-Zeile folgt, die die Leere-Prüfung in unserem Beispielcode überwacht, besteht nur darin, die Wahrscheinlichkeit zu erhöhen, dass das obige unglückliche Szenario eintritt, und somit das Beispiel anschaulicher zu machen (da es fast sicher ist, dass der Thread neu geplant wird). Wir werden dies in Zukunft herausnehmen, aber vorläufig lassen wir es drin.

### Problem 2

Die Klasse `DataFifo` kann von mehreren Threads gleichzeitig auf die Mitgliedsvariable `_innerList` `List<double[]>` zugreifen. Wenn Sie sich jedoch die Dokumentation zu `List<T>` ansehen, werden Sie feststellen, dass die Klasse nicht thread-sicher ist. Aber in diesem Fall können wir das nicht tun, wir müssen Sperren verwenden, um sicherzustellen, dass unser Code nur auf eine Methode/Eigenschaft/Mitgliedsvariable zur gleichen Zeit zugreifen kann (genauer gesagt, kann Inkonsistenz nur im Fall von gleichzeitigen Schreib- oder Lesevorgängen auftreten, aber wir unterscheiden in den meisten Fällen nicht zwischen Lesern und Schreibern, und wir tun es hier auch nicht).

Der nächste Schritt besteht darin, unsere Klasse `DataFifo` thread-sicher zu machen, wodurch die beiden oben genannten Probleme vermieden werden.

## 6. problem 2 - Die DataFifo-Klasse sicher machen

Um die Klasse `DataFifo` thread-sicher zu machen, benötigen wir ein Objekt (dies kann ein beliebiges Objekt vom Referenztyp sein), das als Schlüssel zum Sperren verwendet wird. Mit dem Schlüsselwort `lock` können wir dann sicherstellen, dass sich jeweils nur ein Thread in den durch diesen Schlüssel geschützten Blöcken aufhält.

1.	Fügen Sie ein Feld vom Typ `object` mit dem Namen `_syncRoot` zur Klasse `DataFifo` hinzu.

    ```cs
    private object _syncRoot = new object();
    ```

2. Füllen Sie die Funktionen `Put` und `TryGet` mit dem Schloss aus.

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
        Verwenden Sie die Funktion *"Surround with"* von Visual Studio, indem Sie STRG + K, STRG + S auf dem ausgewählten Codeschnipsel drücken, den Sie umschließen möchten.


Jetzt dürfen wir keine Ausnahme bekommen.

Sie können die künstliche Verzögerung auch aus der Methode `TryGet` entfernen ( Zeile`Thread.Sleep(500);` ).

!!! error "Locking on `this`"
    Es stellt sich die Frage, warum wir eine separate Membervariable `_syncRoot` eingeführt und diese als Locking-Parameter für `lock` verwendet haben, wenn wir stattdessen auch `this`hätten verwenden können ( `DataFifo` ist der Referenztyp, daher wäre dies kein Problem). Die Verwendung von `this` **würde** jedoch **gegen das Unit Lock-in unserer Abteilung verstoßen**! Erinnern Sie sich: `this` ist ein Verweis auf unser Objekt, aber andere Klassen haben Verweise auf dasselbe Objekt (z.B. in unserem Fall `MainWindow`hat einen Verweis auf `DataFifo`), und wenn diese externen Klassen eine Sperre auf das Objekt setzen, indem sie `lock` verwenden, wird dies die Sperre "stören", die wir auf die Klasse darin verwenden (da die Verwendung von `this` dazu führt, dass die externen und internen `lock`denselben Parameter haben). Zum Beispiel kann eine externe Sperre verwendet werden, um die Operationen `TryGet` und `Put` vollständig "lahmzulegen". Im Gegensatz dazu ist in unserer Lösung der Parameter `lock`, die Variable `_syncRoot`, privat und kann nicht von externen Klassen aufgerufen werden, so dass sie die internen Abläufe unserer Klasse nicht beeinträchtigen kann.

## 7. aufgabe 1 - Umsetzung einer wirksamen Signalisierung

### ManualResetEvent verwenden

Die Schleife `while`, die in `WorkerThread`ständig läuft, implementiert ein sogenanntes aktives Warten, das immer vermieden werden sollte. Wäre `Thread.Sleep`nicht in den Schleifenkern eingebaut worden, wäre der Prozessor überlastet gewesen.  `Thread.Sleep` löst zwar das Problem der CPU-Belastung, führt aber ein weiteres ein: Wenn sich alle drei Arbeitsstationen im Ruhezustand befinden, wenn neue Daten empfangen werden, warten wir unnötigerweise 500 ms, bevor wir mit der Verarbeitung der Daten beginnen.

Im Folgenden wird die Anwendung so geändert, dass sie in einem blockierten Zustand wartet, bis Daten zum FIFO hinzugefügt werden (aber wenn Daten hinzugefügt werden, beginnt sie sofort mit der Verarbeitung). Um anzuzeigen, ob sich Daten in der Warteschlange befinden, wird `ManualResetEvent`verwendet.

1. Fügen Sie eine Instanz von `MaunalResetEvent` zu Ihrer Klasse `DataFifo` als `_hasData` hinzu.

    ```cs
    // A false konstruktor paraméter eredményeképpen kezdetben az esemény nem jelzett (kapu csukva)
    private ManualResetEvent _hasData = new ManualResetEvent(false);
    ```

2. Es fungiert als Gateway in unserer Anwendung `_hasData`.  Wenn der Liste Daten hinzugefügt werden, wird sie "geöffnet", und wenn die Liste geleert wird, wird sie "geschlossen".

    !!! tip "Semantik und Namensgebung der Veranstaltung"
        Es ist wichtig, die Semantik Ihrer Veranstaltung gut zu wählen und sie im Namen Ihrer Veranstaltung präzise auszudrücken. In unserem Beispiel drückt der Name `_hasData` aus, dass unser Ereignis genau dann und nur dann signalisiert wird, wenn es Daten zu verarbeiten gibt (Gateway geöffnet). Jetzt müssen wir "nur" noch diese Semantik implementieren: das Ereignis in flagged setzen, wenn Daten in den FIFO eingegeben werden, und in unsigned, wenn der FIFO geleert wird.

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

### Warten auf Signal (Blockieren des Get)

Der vorherige Punkt wurde gelöst, aber das ist an sich nicht viel wert, da es nicht erwartet wird. Diese Erkenntnis kommt jetzt.

1. Ändern Sie die Methode wie folgt: Streichen Sie den Leere-Test und ersetzen Sie ihn durch Warten auf das Ereignis.

    ```cs hl_lines="5"
    public bool TryGet(out double[] data)
    {
        lock (_syncRoot)
        {
            if (_hasData.WaitOne())
            {
                // ...
    ```
   
    !!! note "Überprüfung des Rückgabewerts der Operation WaitOne"
        Die Operation `WaitOne` gibt den Wert `bool` zurück, der wahr ist, wenn sich das Ereignis vor der im Parameter `WaitOne` angegebenen Zeitspanne in dem angegebenen Zustand befindet (und entsprechend falsch, wenn die Zeitspanne abgelaufen ist). In unserem Beispiel haben wir im Parameter kein Zeitlimit angegeben, was eine unendliche Zeitspanne bedeutet. Dementsprechend ist die Prüfung der Bedingung `if` überflüssig, da in unserem Fall `WaitOne()` immer einen wahren Wert liefert. Dies ist der einzige Grund, warum wir dennoch die Konditionstests verwendet haben: Sie erfordern weniger Änderungen für die nächste und eine zukünftige Übung.

2. Dies macht `Thread.Sleep` in `WorkerThread`überflüssig, kommentieren Sie es aus!

    Wenn Sie die obige Lösung ausführen, werden Sie feststellen, dass die Oberfläche Ihrer Anwendung nach dem ersten Tastendruck einfriert. Bei unserer vorherigen Lösung haben wir einen Anfängerfehler gemacht. In dem gesperrten Codeschnipsel warten wir darauf, dass `_hasData` gesendet wird, so dass der Hauptthread keine Gelegenheit hat, `_hasData`in der Operation `Put` zu senden (ebenfalls geschützt durch `lock`). **In der Praxis hat sich eine festgefahrene Situation ergeben.**

    Wir könnten versuchen, ein Zeitlimit (ms) für die Wartezeit festzulegen:

    ```cs
    if (_hasData.WaitOne(100))
    ```

    Dies wäre an sich keine elegante Lösung, außerdem würden die ständig verschmutzenden Arbeits-Threads den Thread, der Put aufruft, erheblich aushungern! Stattdessen ist das elegante Muster zu folgen, um zu vermeiden, dass man innerhalb einer Sperre blockiert wartet.

    Ersetzen Sie `lock`und `WaitOne`und entfernen Sie die Wartezeitbegrenzung, indem Sie den Parameter `WaitOne` entfernen:

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

    Probieren wir die App aus. Wenn Sie die Taste zum ersten Mal drücken, erhalten Sie eine Ausnahme. Dadurch wird zwar ein Deadlock vermieden, **aber die Threadsicherheit ist beeinträchtigt**, da zu dem Zeitpunkt, zu dem Sie in `lock`gelangen, möglicherweise keine Elemente mehr in der Liste vorhanden sind. Es kann mehrere Threads geben, die darauf warten, dass ein Element zum Vorgang `_hasData.WaitOne()` hinzugefügt wird. Wenn dies geschieht, wird unser `ManualResetEvent` Objekt alle durchlassen (es sei denn, ein Thread schließt es schnell, aber das ist nicht garantiert).

    !!! note "The difficulties of programming in a concurrent, multi-threaded environment"
        Diese Übung veranschaulicht, wie sorgfältig man bei der Programmierung in einer gleichzeitigen Multi-Thread-Umgebung vorgehen muss. Bei den vorherigen hatten wir sogar noch Glück, denn der Fehler war reproduzierbar. In der Praxis ist dies jedoch selten der Fall. Leider ist es viel häufiger der Fall, dass wettbewerbsbedingte Ausfälle gelegentliche, nicht reproduzierbare Probleme verursachen. Die Lösung einer solchen Aufgabe muss immer sehr sorgfältig durchdacht sein und kann nicht nach dem Motto "Probieren geht über Studieren" programmiert werden.


3. Als Abhilfe sollten wir die Ungültigkeitsprüfung in `lock`wieder einführen.

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
    Im .NET-Framework gibt es mehrere eingebaute thread-sichere Klassen im Namensraum `System.Collections.Concurrent`.  In dem obigen Beispiel hätte die Klasse `DataFifo` durch `System.Collections.Concurrent.ConcurrentQueue` ersetzt werden können.

## 8. aufgabe 1 - Kultivierter Stillstand

Bisher haben wir das Problem, dass unser Prozess beim Schließen des Fensters "stecken bleibt", beiseite gelassen, weil die Verarbeitungsthreads Vorverarbeitungsthreads sind und wir das Problem des Beendens dieser Threads nicht gelöst haben. Unser Ziel ist es, den unendlichen `while` -Zyklus auszulösen, so dass unsere Arbeits-Threads auf zivilisierte Weise beendet werden, wenn die Anwendung geschlossen wird.

1. Ein `ManualResetEvent` wird verwendet, um einen Stopp im FIFO anzuzeigen, während in `TryGet`gewartet wird. Fügen Sie im FIFO ein neues `ManualResetEvent`hinzu und führen Sie eine `Release` -Operation ein, um unsere Wartezeiten zu verkürzen (unser neues Ereignis kann auf einen markierten Zustand gesetzt werden).

    ```cs
    private ManualResetEvent _releaseTryGet = new ManualResetEvent(false);

    public void Release()
    {
        _releaseTryGet.Set();
    }
    ```

2.	Bleiben Sie auf `TryGet`für diese Veranstaltung. Die Methode `WaitAny` darf die Ausführung fortsetzen, wenn sich eines der als Parameter angegebenen Objekte vom Typ `WaitHandle` in dem angegebenen Zustand befindet, und gibt dessen Massenindex zurück. Und wir wollen die tatsächliche Verarbeitung nur, wenn `_hasData` markiert ist (wenn `WaitAny` 0 zurückgibt).

    ```cs hl_lines="3"
    public bool TryGet(out double[] data)
    {
        if (WaitHandle.WaitAny(new[] { _hasData, _releaseTryGet }) == 0)
        {
            lock (_syncRoot)
            {
    ```

3. `MainWindow.xaml.cs`-eine Flaggenvariable hinzufügen, um den Abschluss anzuzeigen:

    ```cs
    private bool _isClosed = false;
    ```

4. Wenn das Hauptfenster geschlossen wird, setzen Sie das neue Ereignis auf "flagged" und setzen Sie auch das Flag: abonnieren Sie das Ereignis `Closed` der Klasse `MainWindow` im Konstruktor und schreiben Sie die entsprechende Ereignisbehandlungsfunktion:

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

5. Schreiben wir die while-Schleife so um, dass sie auf das im vorigen Abschnitt aufgegriffene Flag wartet.

    ```cs hl_lines="3"
    private void WorkerThread()
    {
        while (!_isClosed)
        {
    ```

6. Stellen Sie sicher, dass Sie nicht versuchen, Nachrichten für ein Fenster zu drucken, das bereits geschlossen ist

    ```cs hl_lines="3-4"
    private void ShowResult(double[] parameters, double result)
    {
        if (_isClosed)
		    return;
    ```

7. Führen Sie die Anwendung aus und überprüfen Sie, ob unser Prozess tatsächlich beendet wird, wenn Sie ihn beenden.

## Ausblick: Task, async, await

Ziel der Übung war es, die Techniken für das Management von Fasern auf unterer Ebene kennen zu lernen. Wir hätten unsere Lösung jedoch (zumindest teilweise) auf den übergeordneten Werkzeugen und Mechanismen aufbauen können, die die asynchrone Programmierung in .NET unterstützen, z. B. die Klassen `Task`/`Task<T>` und die Schlüsselwörter `async`/`await`. 
