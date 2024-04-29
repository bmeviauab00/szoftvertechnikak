---
authors: bzolka
---

# 5. HF - Verwendung der MVVM-Vorlage und des MVVM-Toolkits

## Einführung

Bei den Hausaufgaben 3. Wir werden die im XAML-Labor implementierte Anwendung zur Personenregistrierung so anpassen, dass sie auf dem MVVM-Template basiert, und wir werden das MVVM-Toolkit kennenlernen.

Die eigenständige Übung baut auf dem MVVM-Thema auf, das am Ende der WinUI-Vorlesungsreihe behandelt wurde.
Hinweis: [Labor 5 - MVVM-Labor](../../labor/5-mvvm/index_ger.md) ist sehr abwechslungsreich und zeigt neben vielen anderen Themen ein Beispiel für das MVVM-Pattern im Kontext einer komplexeren Anwendung. Die vorliegende Hausaufgabe ist fokussierter, in kleineren Schritten aufgebaut: In unserem Fall ist es die Lösung der vorliegenden Hausaufgabe, die Ihnen helfen wird, die verwandten Teile von [Lab 5 - MVVM](../../labor/5-mvvm/index_ger.md) zu verstehen.

Durch das Durcharbeiten des zugehörigen Vorlesungsmaterials können die Aufgaben dieser eigenständigen Übung mit Hilfe der kürzeren Leitfäden, die auf die Aufgabenbeschreibung folgen (manchmal standardmäßig eingefaltet), selbständig bearbeitet werden.

Das Ziel der unabhängigen Übung:

- Üben Sie die Verwendung der MVVM-Vorlage
- NuGet-Referenzen verwenden
- Kennenlernen der Grundlagen des MVVM-Toolkits
- Üben von XAML-Techniken

Die erforderliche Entwicklungsumgebung wird [hier](.../fejlesztokornyezet/index_ger.md) beschrieben, identisch mit Hausaufgabe 3 (XAML-Grundlagen).

## Das Verfahren für die Einreichung

- Der grundlegende Prozess ist derselbe wie zuvor. Erstellen Sie mit GitHub Classroom ein Repository für sich selbst. Sie finden die Einladungs-URL in Moodle (Sie können sie sehen, indem Sie auf den Link*"GitHub classroom links for homework*" auf der Startseite des Fachs klicken). Es ist wichtig, dass Sie die richtige Einladungs-URL für diese Hausaufgabe verwenden (jede Hausaufgabe hat eine andere URL). Klonen Sie das resultierende Repository. Dazu gehört auch die erwartete Struktur der Lösung. Nachdem Sie die Aufgaben erledigt haben, übergeben Sie Ihre Lösung alt und drücken Sie sie alt.
- Um mit den geklonten Dateien zu arbeiten, öffnen Sie `HelloXaml.sln`.
- :exclamation: In den Übungen werden Sie aufgefordert, **einen Screenshot von** einem Teil Ihrer Lösung zu machen, da dies beweist, dass Sie Ihre Lösung selbst erstellt haben. **Der erwartete Inhalt der Screenshots ist immer in der Aufgabe angegeben.
**Die Screenshots sollten als Teil der Lösung eingereicht werden, legen Sie sie in den Stammordner Ihres Repositorys (neben neptun.txt).
Die Screenshots werden dann zusammen mit dem Inhalt des Git-Repositorys auf GitHub hochgeladen.
Da das Repository privat ist, ist es für niemanden außer den Ausbildern sichtbar.
Wenn Sie Inhalte im Screenshot haben, die Sie nicht hochladen möchten, können Sie diese aus dem Screenshot ausblenden.
- :exclamation: Diese Aufgabe enthält keinen sinnvollen Pre-Checker: Sie wird nach jedem Push ausgeführt, prüft aber nur, ob neptun.txt gefüllt ist. Die inhaltliche Überprüfung wird von den Laborleitern nach Ablauf der Frist durchgeführt.

## Verbindungen

:warning: **Obligatorische Verwendung des MVVM-Beispiels!**  
  In dieser Hausaufgabe üben wir das MVVM-Pattern, daher ist das MVVM-Pattern für die Lösung der Aufgaben zwingend erforderlich. Andernfalls wird die Bewertung der Aufgaben verweigert.

## Aufgabe 0 - Überblick über den Ausgangszustand

Der Ausgangszustand ist im Grunde derselbe wie bei [3. Gestaltung der Benutzeroberfläche im Endzustand von](../../labor/3-users-felulet/index_ger.md).  Mit anderen Worten, eine Anwendung zur Erfassung der Details von Personen in einer Liste. 
Enthält eine geringfügige Änderung gegenüber dem endgültigen Zustand des Labors. Im Labor war die vollständige Beschreibung der Schnittstelle unter `MainWindow.xaml` (und die zugehörige Code-Behind-Datei) verfügbar. Der Unterschied zu dieser ursprünglichen Lösung besteht darin, dass sie nach `PersonListPage.xaml` (und in den Code dahinter) im Ordner `Views` verschoben wurde.  `PersonListPage` ist keine `Window`, sondern eine von `Page` abgeleitete Klasse (siehe den Code hinter der Datei). Aber sonst hat sich nichts geändert! Wie der Name schon sagt, stellt `Page` eine "Seite" in der Anwendung dar: Sie kann nicht selbst angezeigt werden, sondern muss z. B. in einem Fenster platziert werden. Der Vorteil dieses Fensters ist, dass es möglich ist, zwischen den Seiten (verschiedene `Page` Nachkommen) zu navigieren, indem man die entsprechende Navigation verwendet. Wir werden das nicht ausnutzen, wir werden nur eine Seite haben. Der Zweck der Einführung dieser Seite war nur zu veranschaulichen, dass in der MVVM-Architektur, Ansichten können nicht nur mit `Window` (full window), sondern auch mit Objekten wie `Page` implementiert werden. 

Da alles von `MainWindow`nach `PersonListPage`verschoben wurde, gibt es auf `MainWindow.xaml`nichts anderes als eine Kopie eines solchen `PersonListPage` Objekts:

``` csharp
<views:PersonListPage/>
```

Prüfen Sie im Code, ob dies tatsächlich der Fall ist!

## Kopfzeile des Hauptfensters

:exclamation: Die Überschrift des Hauptfensters sollte "MVVM" lauten, angehängt mit Ihrem Neptun-Code: (z.B. "ABCDEF" im Falle des Neptun-Codes "MVVM - ABCDEF"), ist es wichtig, dass dies der Text ist! Setzen Sie dazu die Eigenschaft `Title` Ihres Hauptfensters auf diesen Text in der Datei `MainWindow.xaml`. 

## Aufgabe 1 - Verwendung des MVVM-Toolkits

In der bestehenden Anwendung implementiert die Klasse `Person` im Ordner `Models` bereits die Schnittstelle `INotifyPropertyChanged` (Spitzname INPC) (sie hat also ein Ereignis `PropertyChanged` ) und zeigt außerdem eine Eigenschaftsänderung in den Settern `Name` und `Age` an, indem sie das Ereignis `PropertyChanged` auslöst (siehe `Person.cs` für eine detaillierte Betrachtung).

Zum Aufwärmen/Wiederholen - nachdem Sie sich den Code (`PersonListPage.xaml` und `PersonListPage.xaml.cs`) genau angesehen und die Anwendung ausgeführt haben - sagen Sie sich, warum dies in der Anwendung erforderlich war!

??? "Die Antwort (Wiederholung)"
    In der Anwendung ist die Eigenschaft `Text` von `TextBox`in `PersonListPage.xaml`(dies ist die Zieleigenschaft) an die Eigenschaften `Age` und `Name` des Tags `NewPerson` `Person` im Code hinter und gebunden (dies sind die Quellen in den beiden Datenbindungen). Beachten Sie im Code, dass die Quelleneigenschaften `NewPerson.Name` und `NewPerson.Age` **ebenfalls im Code geändert werden**: Der Controller kann nur über diese Änderungen informiert werden (und somit mit der Quelle synchron bleiben), wenn er über diese Änderungen an `Name` und `Age` informiert wird. Aus diesem Grund muss die Klasse, die die Eigenschaften `Age` und `Name` enthält, d.h. `Person`, die Schnittstelle `INotifyPropertyChanged` implementieren und das Ereignis `PropertyChanged` auslösen, wenn sich die Eigenschaften ändern, wobei das Ereignis entsprechend parametrisiert sein muss.
    
 Wenn Sie die Anwendung ausführen, überprüfen Sie, ob die Änderungen, die Sie auf `NewPerson.Age` durch Drücken der Schaltflächen "+" und "-" vornehmen, tatsächlich in der `TextBox`, die das Alter anzeigt, wiedergegeben werden. 

In der Klasse `Person` können Sie sehen, dass die Implementierung von `INotifyPropertyChanged` und der dazugehörige Code recht umfangreich ist. Schauen Sie sich die Vorlesungsunterlagen an, um zu sehen, welche Alternativen es für die Implementierung der Schnittstelle gibt (ausgehend von der Folie "INPC Beispiel 1", etwa vier Folien zur Veranschaulichung der vier Möglichkeiten) Die kompakteste Lösung ist das MVVM-Toolkit. Im nächsten Schritt werden wir die derzeitige umfangreichere "manuelle" INPC-Implementierung in ein MVVM-Toolkit umwandeln.

### Aufgabe 1/a - MVVM Toolkit NuGet Referenzaufnahme

Zunächst muss eine NuGet-Referenz auf das MVVM-Toolkit erstellt werden, damit es im Projekt verwendet werden kann. 

**Aufgabe**: Fügen Sie eine NuGet-Referenz für das NuGet-Paket "CommunityToolkit.Mvvm" in das Projekt ein. Auf dieser Visual Studio-Seite wird beschrieben, wie eine NuGet-Referenz mit dem [NuGet Package Manager](https://learn.microsoft.com/en-us/nuget/quickstart/install-and-use-a-package-in-visual-studio#nuget-package-manager)zu einem Projekt hinzugefügt wird. Der vorhergehende Link auf der Seite führt Sie zum Abschnitt "NuGet Package Manager". Folgen Sie den vier hier angegebenen Schritten (mit dem Unterschied, dass Sie auf das Paket "CommunityToolkit.Mvvm" statt auf "Newtonsoft.Json" verweisen müssen).

Nachdem wir nun diese NuGet-Referenz zu unserem Projekt hinzugefügt haben, wird der nächste Build (da er einen NuGet-Wiederherstellungsschritt enthält!) das NuGet-Paket herunterladen, die darin enthaltenen DLLs in den Ausgabeordner entpacken und sie zu einem integralen Bestandteil der Anwendung machen (ein NuGet-Paket ist eigentlich eine Zip-Datei). Es ist wichtig zu beachten, dass weder die NuGet-Zipdatei noch die darin enthaltenen DLLs in Git enthalten sind. Sie werden von der Datei `.gitignore` im Stammverzeichnis der Lösung herausgefiltert. Dies ist der eigentliche Kern des NuGet-Konzepts: Das Repository kann klein bleiben, da die Projektdatei nur Verweise auf NuGet-Pakete enthält, und wenn jemand eine frisch geklonte Lösung erstellt, werden die referenzierten NuGet-Pakete erst dann aus den Online-NuGet-Ressourcen heruntergeladen.

:warning: Die Kenntnis der oben genannten NuGet-Konzepte ist wichtig, sie sind ein wichtiger Teil des Lehrplans!

Eine NuGet-Referenz ist eigentlich nur eine Zeile in der Projektbeschreibungsdatei `.csproj`.  Klicken Sie im Projektmappen-Explorer auf den Projektknoten "HelloXaml", öffnen Sie die Projektdatei `.csproj` und überprüfen Sie, ob diese Zeile enthalten ist (die Version kann unterschiedlich sein):

``` csharp
    <PackageReference Include="CommunityToolkit.Mvvm" Version="8.2.2" />
```

Sie können unsere NuGet-Referenz überprüfen, ohne die Datei `csproj` zu öffnen: Öffnen Sie im Projektmappen-Explorer den Knoten "HelloXaml"/"Abhängigkeiten"/"Pakete": Wenn alles in Ordnung ist, sehen Sie darunter einen Knoten "CommunityToolkit.Mvvm (Version)".

### Aufgabe 1/b - INPC-Implementierung auf Basis des MVVM-Toolkits

Jetzt können wir die Klassen, Schnittstellen, Attribute usw. im MVVM Toolkit NuGet-Paket verwenden, so dass wir zur MVVM Toolkit-basierten INPC-Implementierung wechseln können.

* Kommentieren Sie die Klasse `Person` in ihrer Gesamtheit. 
* Fügen Sie oberhalb des auskommentierten Teils die Klasse als neu hinzu, aber mit einer MVVM-Toolkit-basierten INPC-Implementierung.
    * Die Präsentation "INPC Beispiel 4 - MVVM Toolkit" wird Ihnen bei der Umsetzung helfen.
    * Es muss sich um eine partielle Klasse handeln (d.h. Teile der Klasse können in mehreren Dateien definiert sein).
    * Sie stammt von `ObservableObject`aus dem Toolkit: Dieser Vorgänger implementiert die Schnittstelle `INotifyPropertyChanged`, so dass wir sie nicht mehr benötigen.
    * `Name` und `Age`, ersetzen Sie die Attribute `name` und `age` durch die Attribute `ObservableProperty`. 
  
  Jetzt geht's los.

??? note "Überprüfen Sie die Lösung"
    ```` csharp
    public partial class Person : ObservableObject
    {
        [ObservableProperty]
        private string name;

        [ObservableProperty]
        private int Alter;
    }
    ```

Dieser Code ergibt nach einer Übersetzung im Wesentlichen die gleiche Lösung wie die frühere, viel ausführlichere und jetzt auskommentierte Form. Das heißt (auch wenn wir es noch nicht sehen), es werden die Eigenschaften `Name` und `Age` erstellt, mit entsprechenden `PropertyChanged` Ereignisauslösern. Wie ist das möglich? 

* Zum einen implementiert der Vorfahre `ObservableObject` bereits die Schnittstelle `INotifyPropertyChanged`, enthält also auch das Ereignis-Tag `PropertyChanged`, das durch Ableitung an unsere Klasse "vererbt" wird.
* Während der Kompilierung wird der MVVM-Toolkit-Codegenerator ausgeführt, der für jede Membervariable mit dem Attribut `ObservableProperty` in der Klasse eine Eigenschaft mit dem gleichen Namen, aber mit einem Großbuchstaben beginnend, erzeugt, die unter den richtigen Bedingungen und mit den richtigen Parametern das Ereignis `PropertyChanged` auslöst. Hurra, wir müssen diesen Code nicht schreiben.
* Die Frage ist, wo dieser Code generiert wird. In einem anderen "partiellen" Teil unserer Klasse. Nach einer Übersetzung in Visual Studio klicken Sie mit der rechten Maustaste auf den Klassennamen `Person` und wählen im Popup-Menü "Go to Definition". In einem unteren Fenster erhalten wir zwei Ergebnisse: das eine ist der Code, den wir oben geschrieben haben, das andere ("public class Person") springt nach einem Doppelklick zum generierten Teil des Codes: Sie sehen, dass der Code-Generator einen relativ ausführlichen Code generiert hat, aber was für uns wichtig ist, ist, dass die Eigenschaften `Name` und `Age` hier stehen, darunter - unter anderem - die Eigenschaft `OnPropertyChanged`. 

:exclamation: Der Code-Generator arbeitet in der Regel in der anderen "partiellen" Hälfte unserer Klasse, um den von uns geschriebenen und den von uns generierten Code nicht zu verwechseln! Teilklassen werden am häufigsten verwendet, um handgeschriebenen Code von generiertem Code zu "trennen".

Da viel weniger Code geschrieben werden muss, verwenden wir in der Praxis die auf dem MVVM-Toolkit basierende Lösung (aber Sie müssen auch die manuelle Lösung kennen, damit Sie verstehen können, was hinter den Kulissen geschieht).

!!! example "SUBMITTER"
    Machen Sie einen Screenshot von `f1b.png` wie folgt:

    - Starten Sie die App. Verkleinern Sie sie gegebenenfalls, damit sie nicht zu viel Platz auf dem Bildschirm einnimmt,
    - im "Hintergrund" sollte Visual Studio mit "Person.cs" geöffnet sein.
  
## Aufgabe 2 - Migration zu einer MVVM-basierten Lösung

Im vorherigen Schritt haben wir zwar das MVVM-Toolkit verwendet, sind aber noch nicht zu einer MVVM-basierten Lösung übergegangen (das Toolkit wurde nur für eine einfachere Implementierung von INPC verwendet). 

Im Folgenden werden wir die Architektur unserer Anwendung so anpassen, dass sie dem MVVM-Konzept folgt. Wir bauen auf dem MVVM-Toolkit auf, um die Implementierung zu erleichtern.

**Aufgabe**: Arbeiten Sie das entsprechende Vorlesungsmaterial durch (am Ende des WinUI-Abschnitts):
 
 * Verstehen der grundlegenden Konzepte des MVVM-Musters.
 * Der vollständige Code für die Beispiele in den Folien ist im Ordner "04-05 WinUIDancerProfiles" ("RelaxedMVVM" und "StrictMVVM") im Slideshow [GitHub Repository](https://github.com/bmeviauab00/eloadas-demok) verfügbar und kann Ihnen helfen, die Übungen später zu verstehen und zu lösen. 

Was bedeutet das MVVM Beispiel für unser Beispiel:

* Die Modellklasse ist die Klasse `Person` im Ordner `Models`, die die Daten einer Person repräsentiert (sie enthält KEINE UI-Logik und ist unabhängig von einer Anzeige).
* Im Moment sind alle Beschreibungen/Logiken im Zusammenhang mit der Visualisierung in `PersonListPage`. :Ausrufezeichen: Die derzeitige Website `PersonListPage`**wird in zwei Teile aufgeteilt**:
    *  `PersonListPage.xaml` und der dahinter liegende Code wird die Ansicht sein.
    * Wir führen ein ViewModel für `PersonListPage`mit dem Namen `PersonListPageViewModel` ein.
        * :exclamation: Wichtigster Punkt: Die gesamte Anzeigelogik wird von `PersonListPage` Code auf `PersonListPageViewModel`verlagert. **Der Sinn des Musters ist, dass die View nur eine reine Beschreibung der Schnittstelle enthält, die Anzeigelogik befindet sich im ViewModel.** 
* Eine weitere Säule des Musters: Unsere View enthält einen Verweis auf ihr ViewModel (in Form einer Eigenschaft).
    * In unserem Beispiel bedeutet dies, dass `PersonListPage`eine `PersonListPageViewModel` Eigenschaft haben muss. 
    * :exclamation: Dies ist von entscheidender Bedeutung, da wir in unserer `PersonListPage` xaml-Datei diese Eigenschaft verwenden können, um die Datenbindung an Eigenschaften und Ereignisbehandler zu implementieren, die in das ViewModel verschoben wurden! 
*  `PersonListPageViewModel` "arbeitet" das Modell und behandelt die Benutzerinteraktionen (Event-Handler).
* Da wir eher das Relaxed- als das Strict-MVVM-Muster verwenden, führen wir keinen `PersonViewModel` -Wrapper mehr um unsere `Person` -Modellklasse herum ein.

Aufgabe: Ändern Sie die bestehende Logik so, dass sie dem MVVM-Muster folgt und den oben genannten Grundsätzen entspricht. Legen Sie die Klasse `PersonListPageViewModel` in einem neu erstellten Ordner `ViewModels` ab. Versuchen Sie, die Lösung mithilfe der obigen Hilfe selbst zu finden! Hier ist ein vorläufiger Hinweis, denn das ist schwieriger herauszufinden: Sie können auch Ereignisbehandler für Ereignisse durch Datenbindung angeben: siehe die Folie "Bindung von Ereignissen und Funktionen" (nach der Konvertierung ist dies die einzige Möglichkeit, Ereignisbehandler anzugeben). Es ist auch wichtig zu beachten, dass Daten nur an öffentliche Eigenschaften/Operationen gebunden werden können, so dass auch dies geändert werden muss!

??? "Tipps/Lösungs-Back-Check"
    1. `PersonListPage.xaml.cs` Code-Behind-Datei sollte von fast allem (außer `this.InitializeComponent()` Aufruf im Konstruktor) in die neu eingeführte `PersonListPageViewModel`verschoben werden, da es sich um UI-Logik handelt.
    2. `PersonListPageViewModel` sollte eine öffentliche Klasse sein.
    3. In den `PersonListPage` Code dahinter müssen Sie eine automatisch implementierte Eigenschaft namens ViewModel vom Typ `PersonListPageViewModel` mit nur Getter einfügen und diese auf ein neues Objekt initialisieren. Mit anderen Worten, die Ansicht erstellt und enthält das ViewModel!
    4. In `PersonListPage.xaml`müssen die beiden Datenbindungen `TextBox` entsprechend ausgerichtet werden ( `NewPerson.Name` und `NewPerson.Age` sind jetzt eine Ebene tiefer verfügbar, über die ViewModel-Eigenschaft des dahinter liegenden Codes).
    5. In `PersonListPage.xaml`müssen die Ereignisbehandler (`Click`) an drei Stellen ausgerichtet werden. Dies ist komplizierter. Die Event-Handler-Funktion kann nicht mehr mit der bisher verwendeten Syntax angegeben werden, da die Event-Handler nicht mehr im dahinter liegenden Code liegen (sie wurden in das ViewModel verschoben). 
         * Event-Handler können für Ereignisse durch Datenbindung angegeben werden! Siehe Präsentationsfolie "Binden von Ereignissen und Funktionen". Das ist gut für uns, denn im Code hinter der ViewModel-Eigenschaft gibt es das `PersonListPageViewModel` -Objekt, das die Event-Handler enthält (`AddButton_Click`, `IncreaseButton_Click`, `DecreaseButton_Click`), diese müssen als gebundene Eigenschaften in der Datenbindung angegeben werden (z.B. `ViewModel.AddButton_Click` usw.).
         * Es ist wichtig, dass die Event-Handler-Funktionen öffentlich sind, sonst funktioniert die Datenbindung nicht (muss von privat konvertiert werden).

Andere wichtige Konverter:

* Die aktuellen Namen der Event-Handler `Click` in ViewModel lauten `AddButton_Click`, `IncreaseButton_Click` und `DecreaseButton_Click`. Das ist bedauerlich. Im ViewModel denken wir nicht "semantisch" im Sinne von Event-Handlern. Stattdessen werden bei Modifizierungsoperationen, die den Zustand des ViewModel ändern, die Dementsprechend sind `AddPersonToList`, `IncreaseAge` und `DecreaseAge`geeignetere und aussagekräftigere Namen als die oben genannten. Benennen Sie die Funktionen entsprechend um! Natürlich müssen Sie diese noch an die `Click` Ereignisse in der XAML-Datei binden.
* Die Parameterliste für die oben genannten Funktionen lautet vorläufig "`object sender, RoutedEventArgs e`". Diese Parameter werden jedoch nicht für irgendetwas verwendet. Glücklicherweise ist die x:Bind-Ereignisbindung so flexibel, dass Sie auch eine Operation ohne Parameter angeben können, und das funktioniert auch problemlos. Entfernen Sie daher die oben genannten unnötigen Parameter aus den drei Funktionen unseres ViewModel. Dies führt zu einer schlankeren Lösung.

Prüfen Sie, ob die Anwendung nach den Änderungen genauso funktioniert wie vorher!

Was haben wir durch die Umstellung unserer bisherigen Lösung auf eine MVVM-Basis gewonnen? Die Antwort finden Sie in den Vorlesungsunterlagen! Ein paar Dinge sind hervorzuheben:

* Die verschiedenen Zuständigkeiten sind gut voneinander getrennt (nicht vermischt), so dass es leichter zu verstehen ist:
    * UI-unabhängige Logik (Modell und zugehörige Klassen).
    * UI-Logik (ViewModel)
    * Nur UI-Erscheinung (Ansicht)
* Da die UI-Logik separat ist, können Sie (nicht) Unit-Tests für sie schreiben

Je komplexer eine Anwendung ist, desto mehr trifft dies zu.

!!! example "SUBMITTER"
    Machen Sie einen Screenshot von `f2.png` wie folgt:

    - Starten Sie die App. Verkleinern Sie sie gegebenenfalls, damit sie nicht zu viel Platz auf dem Bildschirm einnimmt,
    - im "Hintergrund" sollte Visual Studio mit `PersonListPageViewModel.cs` geöffnet sein.

## Aufgabe 3 - Deaktivieren/Aktivieren von Controllern

In diesem Stadium verhält sich die Anwendung etwas seltsam: Sie können die Schaltfläche "-" verwenden, um ein Alter in den negativen Bereich zu verschieben, oder die Schaltfläche "+", um es über 150 zu verschieben, oder die Schaltfläche "+Hinzufügen", um eine Person mit sinnlosen Attributen hinzuzufügen. Diese Schaltflächen sollten deaktiviert werden, wenn die von ihnen ausgelöste Aktion keinen Sinn ergibt, und aktiviert werden, wenn sie Sinn ergibt.

Im nächsten Schritt deaktivieren/aktivieren Sie die Schaltfläche "-" entsprechend. Die Schaltfläche sollte nur aktiviert werden, wenn das Alter der Person größer als 0 ist.

Versuchen Sie, es zuerst selbst zu tun, zumindest um die Grundlagen zu schaffen! Ziehen Sie unbedingt eine Lösung mit Datenbindung in Betracht, nur diese ist akzeptabel! Wenn Sie nicht weiterkommen und Ihre Lösung nicht funktionieren "will", überlegen Sie, was der Grund dafür sein könnte, und entwerfen Sie Ihre Lösung wie folgt.

Es gibt mehrere mögliche Lösungen für dieses Problem. Allen gemeinsam ist, dass die Eigenschaft `IsEnabled` der Schaltfläche "-" in irgendeiner Weise gebunden ist. In unserer Lösung binden wir sie an eine bool-Eigenschaft, die in `PersonListPageViewModel`neu eingeführt wurde. 

``` csharp title="PersonListPageViewModel.cs"
    public bool IsDecrementEnabled
    {
        get { return NewPerson.Age > 0; }
    }
```

``` xml title="PersonListPage.xaml-be a '-' gombhoz"
    IsEnabled="{x:Bind ViewModel.IsDecrementEnabled, Mode=OneWay}"
```

Probieren wir es aus! Leider funktioniert es nicht, die "-"-Schaltfläche wird nicht deaktiviert, wenn das Alter auf 0 oder weniger gesetzt wird (z.B. durch wiederholtes Anklicken der Schaltfläche). Wenn Sie einen Haltepunkt in `IsDecrementEnabled` setzen und die Anwendung auf diese Weise starten, werden Sie feststellen, dass der Wert der Eigenschaft nur einmal vom gestrickten Steuerelement abgefragt wird, wenn die Anwendung startet: Danach können Sie auf die Schaltfläche "-" klicken, aber nicht mehr als einmal. Probieren Sie es aus!

Überlegen Sie, was die Ursache dafür ist, und folgen Sie dann dem Leitfaden

??? tip "Reason"
    Wie wir bereits gelernt haben, ruft die Datenbindung den Wert der Quelleigenschaft (in diesem Fall `IsDecrementEnabled`) nur ab, wenn sie über `INotifyPropertyChanged` über eine Änderung informiert wird! In unserer Lösung wird jedoch, selbst wenn sich die Eigenschaft `Age` des Objekts `NewPerson` ändert, keine Mitteilung über die Änderung der darauf basierenden Eigenschaft `IsDecrementEnabled` gemacht!

Im nächsten Schritt implementieren Sie die entsprechende Änderungsmeldung in der Klasse `PersonListPageViewModel`: 

* Implementieren Sie die `INotifyPropertyChanged` Schnittstelle auf MVVM Toolkit "Grundlagen"!
* Die Eigenschaft `IsDecrementEnabled` kann so bleiben, wie sie ist (eine reine Getter-Eigenschaft), sie muss nicht auf `[ObservableProperty]` umgeschrieben werden (aber das ist eine gute Lösung und für Hausaufgaben durchaus akzeptabel, sie muss nur in den nächsten Schritten etwas anders bearbeitet werden).
* Versuchen Sie, Folgendes in der ViewModel-Klasse selbst zu implementieren (die Klasse `Person` bleibt unverändert): Wenn sich `NewPerson.Age` ändert, wird die vom Vorgänger geerbte Eigenschaft `OnPropertyChanged` aufgerufen, um die Änderung der Eigenschaft `IsDecrementEnabled` anzuzeigen. Hinweis: Die Klasse `Person` hat bereits ein Ereignis `PropertyChanged`, da sie selbst die Schnittstelle `INotifyPropertyChanged` implementiert, können Sie dieses Ereignis abonnieren! Der Einfachheit halber haben wir nichts dagegen, wenn wir eine Änderung an `IsDecrementEnabled` melden, auch wenn sie sich nicht wirklich "logisch" ändert.
* Die obigen Schritte können auch ohne die Implementierung einer separaten Ereignisbehandlungsfunktion durchgeführt werden: Dies wird empfohlen, ist aber nicht zwingend erforderlich (Tipp: Geben Sie eine Ereignisbehandlungsfunktion mit einem Lambda-Ausdruck an).

Testen Sie Ihre Lösung! Wenn Sie richtig gearbeitet haben, sollte die Schaltfläche auch dann deaktiviert sein, wenn Sie manuell einen negativen Alterswert in die Textbox eingeben (und dann aus der Textbox herausklicken). Denken Sie darüber nach, warum das so ist!

Erarbeiten Sie eine ähnliche Lösung für die Schaltfläche "+" und die Schaltfläche "+Hinzufügen"!

* Das "akzeptable" Höchstalter sollte 150 Jahre betragen.
* Der Name ist nur akzeptabel, wenn er mindestens ein Zeichen enthält, das kein Leerzeichen ist (um letzteres zu prüfen, verwenden Sie die statische Operation der String-Klasse `IsNullOrWhiteSpace` ).
* Der Fall, dass der Benutzer eine ungültige Zahl in die Alters-Textbox eingibt (was bei dieser Lösung nicht möglich ist), muss nicht behandelt werden.

Beim Testen haben wir festgestellt, dass sich der Zustand der Schaltfläche "+Hinzufügen" nicht sofort ändert, wenn wir beispielsweise den Namen in der Textbox "Name" löschen, sondern erst, wenn wir die Textbox verlassen? Warum ist das so? Ändern Sie Ihre Lösung so, dass dies bei jeder Textänderung geschieht, ohne die TextBox zu verlassen. Hinweis: siehe die Folie "Wann wird x:Bind aktualisiert?" in der Präsentation.

!!! example "SUBMITTER"
    Machen Sie einen Screenshot von `f3.png` wie folgt:

    - Starten Sie die App. Verkleinern Sie sie gegebenenfalls, damit sie nicht zu viel Platz auf dem Bildschirm einnimmt,
    - sollte das Alter im Antrag auf 0 reduziert werden,
    - im "Hintergrund" sollte Visual Studio mit `PersonListPageViewModel.cs` geöffnet sein.

## Aufgabe 4 - Befehl verwenden

Derzeit haben wir zwei Aufgaben für die Schaltfläche "-":

* Für `Click`, führen Sie den Ereignisbehandlungsvorgang aus
* Deaktivieren/aktivieren Sie die Schaltfläche mit der Eigenschaft `IsEnabled` 

Einige Controller, wie z. B. die Schaltfläche, unterstützen die Möglichkeit, beide Angaben, aufbauend auf dem Command-Muster, mit einem Command-Objekt zu machen. Das Konzept des Command-Entwurfsmusters kann in der Vorlesung "Design Patterns 3" ausführlicher behandelt werden (obwohl wir dort nur das grundlegende Command-Muster kennengelernt haben, das die Ausführung von Befehlen unterstützt, nicht aber das Verbieten/Freigeben). Die MVVM-spezifische Umsetzung des Command-Patterns finden Sie gegen Ende der WinUI-Vorlesungsreihe, beginnend mit der Folie "Command-Pattern".

Das Grundprinzip ist: Anstatt `Click` und `IsEnabled` für die Schaltfläche zu "spezifizieren", setzen wir die Eigenschaft `Command` der Schaltfläche auf ein Befehlsobjekt, das die Schnittstelle `ICommand` implementiert. Es liegt an diesem Befehlsobjekt, den Befehl auszuführen oder zu deaktivieren/aktivieren.

Standardmäßig sollte eine Anwendung für jeden Befehl eine eigene `ICommand` Implementierung haben. Dies erfordert jedoch die Einführung vieler Klassen für viele Befehle. Das MVVM-Toolkit ist hier, um zu helfen. Stellt eine Klasse `RelayCommand` zur Verfügung, die die Schnittstelle `ICommand` implementiert. Diese Klasse kann zur Ausführung beliebiger Befehle/Codes verwendet werden, so dass keine zusätzlichen Befehlsklassen eingeführt werden müssen. Wie ist das möglich? So, dass `RelayCommand`hat den Code für die Ausführung und deaktivieren/aktivieren in Konstruktor-Parameter, in Form von zwei Delegaten:

* Der erste Parameter gibt den Code an, der ausgeführt werden soll, wenn der Befehl ausgeführt wird.
* Der zweite Parameter (optional) ist der Code, den der Befehl aufruft, um zu prüfen, ob er sich selbst zulassen oder verbieten soll (die hier angegebene Funktion muss einen booleschen Wert zurückgeben, im wahren Fall wird der Befehl zugelassen).

Der nächste Schritt besteht darin, die Handhabung der "-"-Schaltfläche auf eine Befehlsbasis umzustellen. Versuchen Sie zunächst, das meiste davon selbst zu implementieren, basierend auf dem zugehörigen WinUI-Tutorial. Das Ausführen des Befehls ist einfacher, aber Sie müssen etwas Arbeit investieren, um den Befehl zu deaktivieren und zu aktivieren. Die wichtigsten Schritte:

* Fügen Sie eine öffentliche `RelayCommand` Eigenschaft mit nur Getter zum ViewModel hinzu, z.B. `DecreaseAgeCommand`.  Anders als in den Vorlesungsunterlagen brauchen wir in unserem Fall `RelayCommand`keinen allgemeinen Parameter zu geben, da unsere Befehlszeilenfunktion (`DecreaseAge`) keinen Parameter hat.
* Geben Sie der neu eingeführten Eigenschaft im ViewModel-Konstruktor einen Wert. Geben Sie die Parameter des `RelayCommand` Konstruktors entsprechend an.
* In `PersonListPage.xaml`muss die Schaltfläche "-" nicht mehr `Click` und `IsEnabled` binden, sie werden gelöscht. Binden Sie stattdessen die Eigenschaft `Command` der Schaltfläche an die Eigenschaft `DecreaseAgeCommand`, die im vorherigen Schritt im ViewModel eingeführt wurde.

Wenn Sie es ausprobieren, funktioniert der Befehl run, aber das Deaktivieren/Aktivieren nicht: Wenn Sie es gut beobachten, bleibt die Schaltfläche in ihrem Aussehen immer aktiviert. Es gibt einen logischen Grund dafür, wenn man darüber nachdenkt: `RelayCommand` kann die Aktion im zweiten Konstruktorparameter aufrufen, um den Zustand zu überprüfen, aber es weiß nicht, dass es dies jedes Mal tun sollte, wenn `NewPerson.Age` sich ändert! Wir können dabei helfen. In unserem ViewModel-Konstruktor haben wir bereits das `NewPerson.PropertyChanged` -Ereignis abonniert: Darauf aufbauend rufen wir, wenn sich das Alter ändert (oder wenn es sich ändern könnte, es ist kein Problem, dies manchmal unnötigerweise zu tun), die Aktion `DecreaseAgeCommand` `NotifyCanExecuteChanged` auf. Diese Operation hat einen sehr aussagekräftigen Namen: Sie teilt dem Befehl mit, dass sich der Zustand, unter dem der verbotene/erlaubte Zustand des Befehls aufgebaut ist, geändert hat. Auf diese Weise wird der Befehl selbst aktualisiert, genauer gesagt der Zustand der mit dem Befehl verbundenen Schaltfläche.

Ändern Sie die Handhabung der "+"-Schaltfläche auf ähnliche Weise auf Befehlsbasis Ändern Sie nicht die Handhabung der Schaltfläche "+Hinzufügen"!

!!! example "SUBMITTER"
    Machen Sie einen Screenshot von `f4.png` wie folgt:

    - Starten Sie die App. Verkleinern Sie sie gegebenenfalls, damit sie nicht zu viel Platz auf dem Bildschirm einnimmt,
    - der Name TextBox sollte in der Anwendung leer sein,
    - im "Hintergrund" sollte Visual Studio mit `PersonListPageViewModel.cs` geöffnet sein.

## Aufgabe 5 - Verwendung von Command mit MVVM Toolkit-basierter Codegenerierung

In der vorangegangenen Übung wurde die Einführung von Befehlseigenschaften und deren Instanziierung "manuell" vorgenommen. Das MVVM Toolkit kann dies vereinfachen: Wenn das richtige Attribut verwendet wird, können die Eigenschaft und die Instanziierung automatisch generiert werden.

Konvertieren wir die Handhabung von `DecreaseAgeCommand` (nur dieses eine, lassen Sie `IncreaseAgeCommand`! ) in eine generierte Codebasis:

1. Siehe die Klasse `PersonListPageViewModel` mit dem Schlüsselwort `partial`. 
2. Entfernen Sie die Eigenschaft `DecreaseAgeCommand` und ihre Instanziierung aus dem Konstruktor.
3. Siehe `DecreaseAge` mit diesem Attribut: `[RelayCommand(CanExecute = nameof(IsDecrementEnabled))]`. 
    * Als Ergebnis führt der Codegenerator eine Eigenschaft `RelayCommand` in die Klasse ein, die mit dem Namen unserer Operation (`DecreaseAge`) benannt ist und an die die Zeichenfolge "Command" angehängt ist. So erhalten wir die Eigenschaft `DecreaseAgeCommand`, die wir zuvor manuell eingeführt haben.
    * Die Attributeigenschaft `CanExecute` kann verwendet werden, um in Form einer Zeichenkette den Namen der booleschen Rückgabeoperation oder -eigenschaft anzugeben, die der generierte Code verwenden wird, wenn er den Befehl nicht zulässt/erlaubt (er ist der zweite Parameter des Konstruktors RelayCommand). Wir haben bereits eine solche Eigenschaft, die "IsDecrementEnabled" heißt. Sie wird nicht als einfache Zeichenkette angegeben, denn wenn jemand die Operation `IsDecrementEnabled` nachträglich umbenennt, würde die aktuelle "IsDecrementEnabled" nicht auf die richtige Operation verweisen. Die Verwendung des Ausdrucks `nameof` vermeidet dieses Problem. Die Angabe von `CanExecute` ist im Allgemeinen optional (geben Sie es nicht an, wenn Sie den Befehl niemals deaktivieren wollen).

Testen Sie die Lösung (Herabsetzung des Alters), sie sollte genauso funktionieren wie zuvor.

!!! example "SUBMITTER"
    Machen Sie einen Screenshot von `f5.png` wie folgt:

    - Starten Sie die App. Verkleinern Sie sie gegebenenfalls, damit sie nicht zu viel Platz auf dem Bildschirm einnimmt,
    - im "Hintergrund" sollte Visual Studio mit `PersonListPageViewModel.cs` geöffnet sein.