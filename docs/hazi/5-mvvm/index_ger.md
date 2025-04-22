---
authors: bzolka
---

# 5. HA - Verwendung der MVVM-Muster und des MVVM-Toolkits

## Einführung

In dieser Hausaufgabe werden wir die während der 3. Laborübung (XAML) implementierte Anwendung für Personenregistrierung so verändern, dass sie auf dem MVVM-Muster basiert, und wir werden das MVVM-Toolkit kennenlernen.

Die Hausaufgabe baut auf dem MVVM-Thema auf, das am Ende der WinUI-Vorlesungsreihe behandelt wurde.
Die praktische Grundlage für die Aufgaben bildet die [5. Laborübung – MVVM](../../labor/5-mvvm/index.md).

Durch das Durcharbeiten des zugehörigen Vorlesungsmaterials können die Aufgaben dieser eigenständigen Übung mit Hilfe der kürzeren Leitfäden, die auf die Aufgabenbeschreibung folgen (manchmal standardmäßig eingefaltet), selbständig bearbeitet werden.

Das Ziel der Hausaufgabe:

- Üben Sie die Verwendung der MVVM-Muster
- NuGet-Referenzen verwenden
- Kennenlernen der Grundlagen des MVVM-Toolkits
- Üben von XAML-Techniken

Die erforderliche Entwicklungsumgebung wird [hier](.../fejlesztokornyezet/index_ger.md) beschrieben, identisch mit Hausaufgabe 3 (XAML-Grundlagen).

## Das Verfahren für die Einreichung

Auf das Moodle soll ein ZIP-Archiv hochgeladen werden, das die folgenden Anforderungen entspricht:

- Die Aufgaben sind aufeinander basiert, deshalb ist es genügend den resultierenden Quellcode am Ende der letzten Aufgabe hochzuladen (Visual Studio Solution Verzeichnis). Der Name des Verzeichnisses soll "MVVM_NEPTUN" sein (wo NEPTUN Ihre Neptun-Code ist).
- Wir erwarten keine schriftliche Begründung oder Beschreibung, aber die komplexe Codeteile sollen mit Kommentaren versehen werden
- Das ZIP-Archiv darf die Ausgangsdaten (.exe) und die temporären Dateien nicht enthalten. Um diese Bestände zu löschen, Visual Studio soll geöffnet werden und in dem Solution Explorer Rechtsklick an dem „Clean Solution” Menüelement. Das manuelle Löschen von den "obj" und "bin" Verzeichnissen kann auch nötig sein.
- :exclamation: In den Aufgaben werden Sie aufgefordert, einen **Screenshot** von einem Teil Ihrer Lösung zu machen, da dies beweist, dass Sie Ihre Lösung selbst erstellt haben. **Der erwartete Inhalt der Screenshots ist immer in der Aufgabe angegeben.** Die Screenshots sollten als Teil der Lösung eingegeben, also innerhalb dem ZIP-Archiv auf das Moodle hochgeladen werden.
Wenn Sie Inhalte im Screenshot haben, die Sie nicht hochladen möchten, können Sie diese aus dem Screenshot ausblenden.

## Bedingungen

:warning: **Obligatorische Verwendung der MVVM-Muster!**  
  In dieser Hausaufgabe üben wir das MVVM-Muster, daher ist das MVVM-Muster für die Lösung der Aufgaben obligatorisch erforderlich. Andernfalls wird die Bewertung der Aufgaben verweigert.

## Aufgabe 0 - Überblick über den Ausgangszustand

Der Ausgangszustand ist im Grunde derselbe wie die Endzustand von der Laborübung [3. Entwurf der Benutzeroberfläche](../../labor/3-users-felulet/index_ger.md). Also eine solche Anwendung, die die Speicherung der Daten von Personen in einer Liste ermöglicht. Sie enthält eine kleinere Änderung im Vergleich zum Endzustand des Labors. Im Labor war die vollständige Beschreibung der Oberfläche in `MainWindow.xaml` (und die zugehörige Code-Behind-Datei) verfügbar. Der Unterschied zu dieser ursprünglichen Lösung besteht darin, dass sie nach `PersonListPage.xaml` (und in den Code dahinter) im Ordner `Views` verschoben wurde.  `PersonListPage` ist keine `Window`, sondern eine von `Page` abgeleitete Klasse (siehe den Code hinter der Datei). Aber sonst hat sich nichts geändert! Wie der Name schon sagt, stellt `Page` eine "Seite" in der Anwendung dar: Sie kann nicht selbst angezeigt werden, sondern muss z. B. in einem Fenster platziert werden. Der Vorteil dieses Fensters ist, dass es möglich ist, zwischen den Seiten (verschiedene `Page` Nachkommen) zu navigieren, indem man die entsprechende Navigation verwendet. Wir werden das nicht ausnutzen, wir werden nur eine Seite haben. Der Zweck der Einführung dieser Seite war nur zu veranschaulichen, dass in der MVVM-Architektur, Ansichten können nicht nur mit `Window` (full window), sondern auch mit Objekten wie `Page` implementiert werden. 

Da alles von `MainWindow` nach `PersonListPage` verschoben wurde, gibt es auf `MainWindow.xaml` nichts anderes als eine Kopie eines solchen `PersonListPage` Objekts:

``` csharp
<views:PersonListPage/>
```

Prüfen Sie im Code, ob dies tatsächlich der Fall ist!

## Kopfzeile des Hauptfensters

:exclamation: Die Überschrift des Hauptfensters sollte "MVVM" sein, angehängt mit Ihrem Neptun-Code: (z.B."MVVM - ABCDEF" im Falle des Neptun-Codes "ABCDEF"), ist es wichtig, dass dies der Text ist! Setzen Sie dazu die Eigenschaft `Title` Ihres Hauptfensters auf diesen Text in der Datei `MainWindow.xaml`. 

## Aufgabe 1 - Verwendung des MVVM-Toolkits

In der bestehenden Anwendung implementiert die Klasse `Person` im Ordner `Models` bereits die Schnittstelle `INotifyPropertyChanged` (Spitzname INPC) (sie hat also ein Ereignis `PropertyChanged` ) und zeigt außerdem eine Eigenschaftsänderung in den Settern `Name` und `Age` an, indem sie das Ereignis `PropertyChanged` auslöst (siehe `Person.cs` für eine detaillierte Betrachtung).

Zum Aufwärmen/Wiederholen - nachdem Sie sich den Code (`PersonListPage.xaml` und `PersonListPage.xaml.cs`) genau angesehen und die Anwendung ausgeführt haben - sagen Sie sich, warum dies in der Anwendung erforderlich war!

??? "Die Antwort (Wiederholung)"
    In der Anwendung ist die Eigenschaft `Text` von `TextBox` (dies ist die Zieleigenschaft) in `PersonListPage.xaml` an die Eigenschaften `Age` und `Name` des Members `NewPerson` mit dem Typ `Person` im Code-Behind-Datei gebunden (dies sind die Quellen in den beiden Datenverbindungen). Beachten Sie im Code, dass die Quelleneigenschaften `NewPerson.Name` und `NewPerson.Age` **ebenfalls im Code geändert werden**: Der Controller kann nur über diese Änderungen informiert werden (und somit mit der Quelle synchron bleiben), wenn er über diese Änderungen an `Name` und `Age` informiert wird. Aus diesem Grund muss die Klasse, die die Eigenschaften `Age` und `Name` enthält, d.h. `Person`, die Schnittstelle `INotifyPropertyChanged` implementieren und das Ereignis `PropertyChanged` auslösen, wenn sich die Eigenschaften ändern, wobei das Ereignis entsprechend parametrisiert sein muss.
    
 Wenn Sie die Anwendung ausführen, überprüfen Sie, ob die Änderungen, die Sie auf `NewPerson.Age` durch Drücken der Tasten "+" und "-" vornehmen, tatsächlich in der `TextBox`, die das Alter anzeigt, wiedergegeben werden. 

In der Klasse `Person` können Sie sehen, dass die Implementierung von `INotifyPropertyChanged` und der dazugehörige Code recht umfangreich ist. Schauen Sie sich die Vorlesungsunterlagen an, um zu sehen, welche Alternativen es für die Implementierung der Schnittstelle gibt (ausgehend von der Folie "INPC Beispiel 1", etwa vier Folien zur Veranschaulichung der vier Möglichkeiten)! Die kompakteste Lösung ist das MVVM-Toolkit. Im nächsten Schritt werden wir die derzeitige umfangreichere "manuelle" INPC-Implementierung in ein MVVM-Toolkit umwandeln.

### Aufgabe 1/a - Aufnahme des MVVM Toolkit NuGet Referenzes

Zunächst muss eine NuGet-Referenz auf das MVVM-Toolkit erstellt werden, damit es im Projekt verwendet werden kann. 

**Aufgabe**: Fügen Sie eine NuGet-Referenz für das NuGet-Paket "CommunityToolkit.Mvvm" in das Projekt ein. Auf dieser Visual Studio-Seite wird beschrieben, wie eine NuGet-Referenz mit dem [NuGet Package Manager](https://learn.microsoft.com/de-de/nuget/quickstart/install-and-use-a-package-in-visual-studio#nuget-package-manager) zu einem Projekt hinzugefügt wird. Der vorhergehende Link auf der Seite führt Sie zum Abschnitt "NuGet Package Manager". Folgen Sie den vier hier angegebenen Schritten (mit dem Unterschied, dass Sie auf das Paket "CommunityToolkit.Mvvm" statt auf "Newtonsoft.Json" verweisen müssen).

Nachdem wir nun diese NuGet-Referenz zu unserem Projekt hinzugefügt haben, wird der nächste Build (da er einen  NuGet restore Schritt enthält!) das NuGet-Paket herunterladen, die darin enthaltenen DLLs in den Ausgabeordner entpacken und sie zu einem integralen Bestandteil der Anwendung machen (ein NuGet-Paket ist eigentlich eine Zip-Datei). Es ist wichtig zu beachten, dass weder die NuGet-Zipdatei noch die darin enthaltenen DLLs in Git enthalten sind. Sie werden von der Datei `.gitignore` im Stammverzeichnis der Lösung herausgefiltert. Dies ist der eigentliche Kern des NuGet-Konzepts: Das Repository kann klein bleiben, da die Projektdatei nur Verweise auf NuGet-Pakete enthält, und wenn jemand eine frisch geklonte Lösung erstellt, werden die referenzierten NuGet-Pakete erst dann aus den Online-NuGet-Ressourcen heruntergeladen.

:warning: Die Kenntnis der oben genannten NuGet-Konzepte ist wichtig, sie sind ein wichtiger Teil des Lehrmaterials!

Eine NuGet-Referenz ist eigentlich nur eine Zeile in der Projektbeschreibungsdatei `.csproj`.  Klicken Sie im Solution Explorer auf den Projektknoten "HelloXaml", öffnen Sie die Projektdatei `.csproj` und überprüfen Sie, ob diese Zeile enthalten ist (die Version kann unterschiedlich sein):

``` csharp
    <PackageReference Include="CommunityToolkit.Mvvm" Version="8.2.2" />
```

Sie können unsere NuGet-Referenz überprüfen, ohne die Datei `csproj` zu öffnen: Öffnen Sie im Solution Explorer den Knoten "HelloXaml"/"Dependencies"/"Packages": Wenn alles in Ordnung ist, sehen Sie darunter einen Knoten "CommunityToolkit.Mvvm (Version)".

### Aufgabe 1/b - INPC-Implementierung auf Basis des MVVM-Toolkits

Jetzt können wir die Klassen, Schnittstellen, Attribute usw. im MVVM Toolkit NuGet-Paket verwenden, so dass wir zur MVVM Toolkit-basierten INPC-Implementierung wechseln können.

* Kommentieren Sie die ganze Klasse `Person` aus. 
* Fügen Sie oberhalb des auskommentierten Teils die Klasse als neu hinzu, aber mit einer MVVM-Toolkit-basierten INPC-Implementierung.
    * Die Präsentation "INPC Beispiel 4 - MVVM Toolkit" wird Ihnen bei der Umsetzung helfen.
    * Es muss sich um eine partielle Klasse handeln (d.h. Teile der Klasse können in mehreren Dateien definiert sein).
    * Sie stammt von `ObservableObject` aus dem Toolkit: Dieser Vorgänger implementiert die Schnittstelle `INotifyPropertyChanged`, so dass wir sie nicht mehr benötigen.
    * Ersetzen Sie die Eigenschaften `Name` und `Age` mit Mitgliedsvariablen `name` und `age`, die auch die Attribute `ObservableProperty` besitzen. 
  
Wir sind fertig.

??? note "Überprüfung der Lösung"
    ```` csharp
    public partial class Person : ObservableObject
    {
        [ObservableProperty]
        private string name;

        [ObservableProperty]
        private int age;
    }
    ```

Dieser Code ergibt nach einer Übersetzung im Wesentlichen die gleiche Lösung wie die frühere, viel ausführlichere und jetzt auskommentierte Lösung. Das heißt (auch wenn wir es noch nicht sehen), es werden die Eigenschaften `Name` und `Age` erstellt, mit entsprechenden `PropertyChanged` Ereignisauslösern. Wie ist das möglich? 

* Einerseits implementiert der Vorfahre `ObservableObject` bereits die Schnittstelle `INotifyPropertyChanged`, enthält also auch das Ereignis `PropertyChanged`, das durch Ableitung an unsere Klasse "vererbt" wird.
* Während der Kompilierung wird der MVVM-Toolkit-Codegenerator ausgeführt, der für jede Membervariable mit dem Attribut `ObservableProperty` in der Klasse eine Eigenschaft mit dem gleichen Namen, aber mit einem Großbuchstaben beginnend, erzeugt, die unter den richtigen Bedingungen und mit den richtigen Parametern das Ereignis `PropertyChanged` auslöst. Hurra, wir müssen diesen Code nicht schreiben.
* Die Frage ist, wo dieser Code generiert wird. In einem anderen "partiellen" Teil unserer Klasse. Nach einer Übersetzung in Visual Studio klicken Sie mit der rechten Maustaste auf den Klassennamen `Person` und wählen im Popup-Menü "Go to Definition". In einem unteren Fenster erhalten wir zwei Ergebnisse: das eine ist der Code, den wir oben geschrieben haben, das andere ("public class Person") springt nach einem Doppelklick zum generierten Teil des Codes: Sie sehen, dass der Code-Generator einen relativ ausführlichen Code generiert hat, aber was für uns wichtig ist, ist, dass die Eigenschaften `Name` und `Age` hier stehen, darunter - unter anderem - die Eigenschaft `OnPropertyChanged`. 

:exclamation: Der Code-Generator arbeitet in der Regel in der anderen "partiellen" Hälfte unserer Klasse, um den von uns geschriebenen und den von uns generierten Code nicht zu verwechseln! Teilklassen werden am häufigsten verwendet, um handgeschriebenen Code von generiertem Code zu "trennen".

Da viel weniger Code geschrieben werden muss, verwenden wir in der Praxis die auf dem MVVM-Toolkit basierende Lösung (aber Sie müssen auch die manuelle Lösung kennen, damit Sie verstehen können, was hinter den Kulissen geschieht).

!!! example "EINGABE"
    Machen Sie einen Screenshot mit dem Namen `f1b.png` wie folgt:

    - Starten Sie die App. Verkleinern Sie sie gegebenenfalls, damit sie nicht zu viel Platz auf dem Bildschirm einnimmt,
    - Im "Hintergrund" sollte Visual Studio mit "Person.cs" geöffnet sein.
  
## Aufgabe 2 - Umstellung auf eine MVVM-basierte Lösung

Im vorherigen Schritt haben wir zwar das MVVM-Toolkit verwendet, sind aber noch nicht zu einer MVVM-basierten Lösung gewechselt (das Toolkit wurde nur für eine einfachere Implementierung von INPC verwendet). 

Im Folgenden werden wir die Architektur unserer Anwendung so anpassen, dass sie dem MVVM-Konzept folgt. Wir bauen auf dem MVVM-Toolkit auf, um die Implementierung zu erleichtern.

**Aufgabe**: Arbeiten Sie das entsprechende Vorlesungsmaterial durch (am Ende des WinUI-Abschnitts):
 
 * Verstehen Sie der grundlegenden Konzepte des MVVM-Musters.
 * Der vollständige Code für die Beispiele in den Folien ist im Ordner "04-05 WinUI\DancerProfiles" ("RelaxedMVVM" und "StrictMVVM") von [GitHub Repository](https://github.com/bmeviauab00/eloadas-demok) verfügbar und kann Ihnen helfen, die zu verstehen und die Aufgaben später zu lösen. 

Was bedeutet das MVVM-Muster für unser Beispiel:

* Die Modellklasse ist die Klasse `Person` im Ordner `Models`, die die Daten einer Person repräsentiert (sie enthält KEINE UI-Logik und ist unabhängig von der Anzeige).
* Im Moment sind alle Beschreibungen/Logiken im Zusammenhang mit der Visualisierung in `PersonListPage`. :exclamation: Die aktuelle  `PersonListPage` **wird in zwei Teile aufgeteilt**:
    *  `PersonListPage.xaml` und seiner Code-Behind-Datei wird die Ansicht.
    * Wir führen ein ViewModel für `PersonListPage` mit dem Namen `PersonListPageViewModel` ein.
        * :exclamation: Sehr wichtig: Die gesamte Anzeigelogik wird von `PersonListPage` Code-Behind-Datei ins `PersonListPageViewModel` bewegt. **Der Sinn des Musters ist, dass die View nur eine reine Beschreibung der Oberfläche enthält, die Anzeigelogik befindet sich im ViewModel.** 
* Eine weitere Säule des Musters: Unsere View enthält einen Verweis auf ihr ViewModel (in Form einer Eigenschaft).
    * In unserem Beispiel bedeutet dies, dass `PersonListPage` eine `PersonListPageViewModel` Eigenschaft haben muss. 
    * :exclamation: Dies ist sehr wichtig, da wir in unserer `PersonListPage` Xaml-Datei diese Eigenschaft verwenden können, um die Datenverbindung an Eigenschaften und Ereignishandler zu implementieren, die in das ViewModel verschoben wurden! 
*  `PersonListPageViewModel` "arbeitet" mit dem Modell und behandelt die Benutzerinteraktionen (Ereignishandler).
* Da wir eher das Relaxed- als das Strict-MVVM-Muster verwenden, führen wir keinen `PersonViewModel`-Wrapper noch um unsere `Person`-Modellklasse herum ein.

Aufgabe: Ändern Sie die bestehende Logik so, dass sie dem MVVM-Muster folgt und den oben genannten Grundsätzen entspricht. Legen Sie die Klasse `PersonListPageViewModel` in einem neu erstellten Ordner `ViewModels` ab. Versuchen Sie, die Lösung anhand der obigen Hilfe selbst zu bearbeiten! Dazu geben wir einen vorherigen Hinweis, da das schwieriger herauszufinden ist: Sie können auch Ereignishandler für Ereignisse durch Datenverbindung angeben: siehe die Folie "Bindung von Ereignissen und Funktionen" (nach der Modifikation ist dies die einzige Möglichkeit, Ereignishandler anzugeben). Es ist auch wichtig zu beachten, dass Daten nur an öffentliche Eigenschaften/Operationen gebunden werden können, so dass auch dies geändert werden muss!

??? "Tipps/Prüfung der Lösung"
    1. Aus der `PersonListPage.xaml.cs` Code-Behind-Datei sollte fast alles (außer `this.InitializeComponent()` Aufruf im Konstruktor) in die neu eingeführte `PersonListPageViewModel` verschoben werden, da es sich um UI-Logik handelt.
    2. `PersonListPageViewModel` sollte eine öffentliche Klasse sein.
    3. In der `PersonListPage` Code-Behind-Datei müssen Sie eine automatisch implementierte Eigenschaft namens ViewModel vom Typ `PersonListPageViewModel` mit nur Getter einfügen und diese auf ein neues Objekt initialisieren. Mit anderen Worten, die Ansicht erstellt und enthält das ViewModel!
    4. In `PersonListPage.xaml` müssen die beiden Datenverbindungen der zwei `TextBox` entsprechend korrigiert werden ( `NewPerson.Name` und `NewPerson.Age` sind jetzt eine Ebene tiefer verfügbar, über die ViewModel-Eigenschaft der Code-Behind-Datei).
    5. In `PersonListPage.xaml` müssen die Ereignishandler (`Click`) an drei Stellen korrigiert werden. Dies ist komplizierter. Die Ereignishandler-Funktion kann nicht mehr mit der bisher verwendeten Syntax angegeben werden, da die Ereignishandler nicht mehr in der Code-Behind-Datei liegen (sie wurden in das ViewModel verschoben). 
         * Ereignishandler können für Ereignisse durch Datenverbindung angegeben werden! Siehe Präsentationsfolie "Binden von Ereignissen und Funktionen". Das ist gut für uns, denn in der ViewModel-Eigenschaft der Code-Behind-Datei ist das `PersonListPageViewModel`-Objekt, das die Ereignishandler enthält (`AddButton_Click`, `IncreaseButton_Click`, `DecreaseButton_Click`), und diese müssen als gebundene Eigenschaften in der Datenverbindung angegeben werden (z.B. `ViewModel.AddButton_Click` usw.).
         * Es ist wichtig, dass die Ereignishandler-Funktionen öffentlich sind, sonst funktioniert die Datenverbindung nicht (muss von privat konvertiert werden).

Andere wichtige Modifikationen:

* Die aktuellen Namen der Ereignishandler von `Click` in ViewModel lauten `AddButton_Click`, `IncreaseButton_Click` und `DecreaseButton_Click`. Das ist nicht glücklich. Im ViewModel denken wir "semantisch" nicht im Sinne von Ereignishandlern. Stattdessen werden im Sinne von Modifizierungsoperationen denken, die den Zustand des ViewModel ändern. Also statt dem oberen Namen werden wir die folgenden, sehr viel geignetere und aussagekräftigere Namen verwenden:  `AddPersonToList`, `IncreaseAge` und `DecreaseAge`. Benennen Sie die Funktionen entsprechend um! Natürlich müssen Sie diese noch an die `Click` Ereignisse in der XAML-Datei binden.
* Die Parameterliste für die oben genannten Funktionen lautet zunächst "`object sender, RoutedEventArgs e`". Diese Parameter werden jedoch nicht für irgendetwas verwendet. Glücklicherweise ist die x:Bind-Ereignisbindung so flexibel, dass Sie auch eine Operation ohne Parameter angeben können, und das funktioniert auch problemlos. Entfernen Sie daher die oben genannten unnötigen Parameter aus den drei Funktionen unseres ViewModel. Dies führt zu einer schlankeren Lösung.

Prüfen Sie, ob die Anwendung nach den Änderungen genauso funktioniert wie vorher!

Was haben wir durch die Umstellung unserer bisherigen Lösung auf eine MVVM-Basis gewonnen? Die Antwort finden Sie in den Vorlesungsmaterial! Ein paar Dinge sind hervorzuheben:

* Die verschiedenen Zuständigkeiten sind gut voneinander getrennt (nicht vermischt), so dass es leichter zu verstehen ist:
    * UI-unabhängige Logik (Modell und zugehörige Klassen).
    * UI-Logik (ViewModel)
    * Nur UI-Erscheinung (View)
* Da die UI-Logik separat ist, könn(t)en Sie Unit-Tests für sie schreiben.

Je komplexer eine Anwendung ist, desto mehr sind diese wahr.

!!! example "EINGABE"
    Machen Sie einen Screenshot mit dem Namen `f2.png` wie folgt:

    - Starten Sie die App. Verkleinern Sie sie gegebenenfalls, damit sie nicht zu viel Platz auf dem Bildschirm einnimmt,
    - Im "Hintergrund" sollte Visual Studio mit `PersonListPageViewModel.cs` geöffnet sein.

## Aufgabe 3 - Deaktivieren/Aktivieren von Controllern

In diesem Stadium verhält sich die Anwendung etwas komisch: Sie können die Taste "-" verwenden, um ein Alter in den negativen Bereich zu verschieben, oder die Taste "+", um es über 150 zu verschieben, oder die Taste "+Add", um eine Person mit sinnlosen Attributen hinzuzufügen. Diese Tasten sollten deaktiviert werden, wenn die von ihnen ausgelöste Aktion keinen Sinn ergibt, und aktiviert werden, wenn sie Sinn hat.

Im nächsten Schritt deaktivieren/aktivieren Sie die Taset "-" entsprechend. Die Taste sollte nur aktiviert werden, wenn das Alter der Person größer als 0 ist.

Versuchen Sie, es zuerst selbst zu lösen, zumindest um die Grundlagen zu schaffen! Denken Sie unbedingt über eine Lösung mit Datenverbindung, nur diese ist akzeptabel! Wenn Sie nicht weiterkommen kann, Ihre Lösung nicht funktionieren "will", überdenken Sie, was der Grund dafür sein könnte, und konstruiren Sie Ihre Lösung wie folgt.

Es gibt mehrere mögliche Lösungen für dieses Problem. In allen gemeinsam ist, dass die Eigenschaft `IsEnabled` der Taste "-" in irgendeiner Weise gebunden ist. In unserer Lösung binden wir sie an eine bool-Eigenschaft, die in `PersonListPageViewModel` neu eingeführt wurde. 

``` csharp title="PersonListPageViewModel.cs"
    public bool IsDecrementEnabled
    {
        get { return NewPerson.Age > 0; }
    }
```

``` xml title="In PersonListPage.xaml zu der Taste '-'"
    IsEnabled="{x:Bind ViewModel.IsDecrementEnabled, Mode=OneWay}"
```

Probieren wir es aus! Leider funktioniert es nicht, die "-"-Taste wird nicht deaktiviert, wenn das Alter auf 0 oder weniger gesetzt wird (z.B. durch wiederholtes Anklicken der Taste). Wenn Sie einen Haltepunkt in `IsDecrementEnabled` setzen und die Anwendung auf diese Weise starten, werden Sie feststellen, dass der Wert der Eigenschaft nur einmal vom gebundenen Steuerelement abgefragt wird, wenn die Anwendung startet: Danach können Sie auf die Taste "-" mehrmals klicken, aber es wird nicht mehr als einmal abgefragt. Probieren Sie es aus!

Überdenken Sie, was die Ursache dafür ist, und lesen Sie erst dann der Leitfaden weiter!

??? tip "Begründung"
    Wie wir bereits gelernt haben, ruft die Datenverbindung den Wert der Quelleigenschaft (in diesem Fall `IsDecrementEnabled`) nur ab, wenn sie über `INotifyPropertyChanged` über eine Änderung informiert wird! Aber in unserer Lösung gibt es jedoch, selbst wenn sich die Eigenschaft `Age` des Objekts `NewPerson` ändert, keine Benachrichtigung über die Änderung der darauf basierenden Eigenschaft `IsDecrementEnabled`!

Im nächsten Schritt implementieren Sie die entsprechende Änderungsmeldung in der Klasse `PersonListPageViewModel`: 

* Implementieren Sie die `INotifyPropertyChanged` Schnittstelle auf MVVM Toolkit "Grundlagen"!
* Die Eigenschaft `IsDecrementEnabled` kann so bleiben, wie sie ist (get only property), sie muss nicht auf `[ObservableProperty]` umgeschrieben werden (aber das ist auch eine gute Lösung und für Hausaufgaben durchaus akzeptabel, sie muss nur in den nächsten Schritten etwas anders bearbeitet werden).
* Versuchen Sie, Folgendes in der ViewModel-Klasse selbst zu implementieren (die Klasse `Person` bleibt unverändert): Wenn sich `NewPerson.Age` ändert, wird die vom Vorgänger geerbte Eigenschaft `OnPropertyChanged` aufgerufen, um die Änderung der Eigenschaft `IsDecrementEnabled` anzuzeigen. Hinweis: Die Klasse `Person` hat bereits ein Ereignis `PropertyChanged`, da sie selbst die Schnittstelle `INotifyPropertyChanged` implementiert, können Sie dieses Ereignis abonnieren! Wegen der Einfachheit haben wir nichts dagegen, wenn wir eine Änderung an `IsDecrementEnabled` melden, auch wenn sie sich nicht wirklich "logisch" ändert.
* Die obigen Schritte können auch ohne die Implementierung einer separaten Ereignishandler-Funktion durchgeführt werden: Dies wird empfohlen, ist aber nicht zwingend erforderlich (Tipp: Geben Sie eine Ereignishandler-Funktion mit einem Lambda-Ausdruck an).

Testen Sie Ihre Lösung! Wenn Sie richtig gearbeitet haben, sollte die Taste auch dann deaktiviert sein, wenn Sie manuell einen negativen Alterswert in die Textbox eingeben (und dann aus der Textbox herausklicken). Denken Sie darüber nach, warum das so ist!

Erarbeiten Sie eine ähnliche Lösung für die Taste "+" und die Taste "+Add"!

* Das "akzeptable" Höchstalter sollte 150 Jahre sein.
* Der Name ist nur akzeptabel, wenn er mindestens ein Zeichen enthält, das kein Leerzeichen ist (um letzteres zu prüfen, verwenden Sie die statische Operation der String-Klasse `IsNullOrWhiteSpace`).
* Der Fall, dass der Benutzer eine ungültige Zahl in die Alters-Textbox eingibt (was bei dieser Lösung nicht möglich ist), muss nicht behandelt werden.

Beim Testen haben wir festgestellt, dass sich der Zustand der Taste "+Add" nicht sofort ändert, wenn wir beispielsweise den Namen in der Textbox "Name" löschen, sondern erst, wenn wir die Textbox verlassen? Warum ist das so? Ändern Sie Ihre Lösung so, dass dies bei jeder Textänderung geschieht, ohne die TextBox zu verlassen. Hinweis: siehe die Folie "x:Bind wann werden die Daten aktualisiert?" in der Vorlesungsmaterial.

!!! example "EINGABE"
    Machen Sie einen Screenshot mit dem Namen `f3.png` wie folgt:

    - Starten Sie die App. Verkleinern Sie sie gegebenenfalls, damit sie nicht zu viel Platz auf dem Bildschirm einnimmt,
    - sollte das Alter in der Anwendung auf 0 reduziert werden,
    - im "Hintergrund" sollte Visual Studio mit `PersonListPageViewModel.cs` geöffnet sein.

## Aufgabe 4 - Command verwenden

Derzeit haben wir zwei Aufgaben für die Taste "-":

* Für `Click`, die Ausführung der Ereignishandler-Funktion
* Deaktivieren/Aktivieren der Taste mit der Eigenschaft `IsEnabled` 

Einige Controller, wie z. B. die Taste, unterstützen die Möglichkeit, beide Aufgaben, aufbauend auf dem Command-Muster, mit einem Command-Objekt zu machen. Das Konzept des Command-Entwurfsmusters kann in der Vorlesung "Design Patterns 3" ausführlicher behandelt werden (obwohl wir dort nur das grundlegende Command-Muster kennengelernt haben, das die Ausführung von Befehlen unterstützt, nicht aber das Verbieten/Erlauben). Die MVVM-spezifische Umsetzung des Command-Patterns finden Sie gegen Ende der WinUI-Vorlesungsreihe, beginnend mit der Folie "Command-Muster".

Das Grundprinzip ist: Anstatt die "Angaben" von `Click` und `IsEnabled` für die Taste, setzen wir die Eigenschaft `Command` der Taste auf ein Befehlsobjekt, das die Schnittstelle `ICommand` implementiert. Es liegt an diesem Befehlsobjekt, den Befehl auszuführen oder zu deaktivieren/aktivieren.

Standardmäßig sollte eine Anwendung für jeden Befehl eine eigene `ICommand` Implementierung haben. Dies erfordert jedoch die Einführung vieler Klassen für viele Befehle. Das MVVM-Toolkit ist hier, um zu helfen. Stellt eine Klasse `RelayCommand` zur Verfügung, die die Schnittstelle `ICommand` implementiert. Diese Klasse kann zur Ausführung beliebiger Befehle/Codes verwendet werden, so dass keine zusätzlichen Befehlsklassen eingeführt werden müssen. Wie ist das möglich? So, dass `RelayCommand` hat den Code für die Ausführung und deaktivieren/aktivieren in Konstruktor-Parameter, in Form von zwei Delegaten:

* Der erste Parameter gibt den Code an, der ausgeführt werden soll, wenn der Befehl ausgeführt wird.
* Der zweite Parameter (optional) ist der Code, den der Befehl aufruft, um zu prüfen, ob er sich selbst zulassen oder verbieten soll (die hier angegebene Funktion muss einen booleschen Wert zurückgeben, im wahren Fall wird der Befehl zugelassen).

Der nächste Schritt besteht darin, die Behandlung der Taste "-" auf command basierende umzustellen. Versuchen Sie zuerst, das meiste davon selbst zu implementieren, basierend auf dem zugehörigen WinUI-Vorlesungen. Das Ausführen des Befehls ist einfacher, aber Sie müssen etwas Arbeit investieren, um den Befehl zu deaktivieren und zu aktivieren. Die wichtigsten Schritte:

* Fügen Sie eine öffentliche `RelayCommand` Eigenschaft mit nur Getter zum ViewModel hinzu, z.B. `DecreaseAgeCommand`.  Anders als in den Vorlesungsmaterial brauchen wir in unserem Fall `RelayCommand` keinen allgemeinen Parameter zu geben, da unsere Befehlsbehandlungsfunktion (`DecreaseAge`) keinen Parameter hat.
* Geben Sie der neu eingeführten Eigenschaft im ViewModel-Konstruktor einen Wert. Geben Sie die Parameter des `RelayCommand` Konstruktors entsprechend an.
* In `PersonListPage.xaml` muss die Taste "-" nicht mehr `Click` und `IsEnabled` binden, sie werden gelöscht. Binden Sie stattdessen die Eigenschaft `Command` der Taste an die Eigenschaft `DecreaseAgeCommand`, die im vorherigen Schritt im ViewModel eingeführt wurde.

Wenn Sie es ausprobieren, funktioniert die Ausführund des Befehls, aber das Deaktivieren/Aktivieren nicht: Wenn Sie es gut beobachten, bleibt die Taste in ihrem Aussehen immer aktiviert. Es gibt einen logischen Grund dafür, wenn man darüber nachdenkt: `RelayCommand` kann die Aktion im zweiten Konstruktorparameter aufrufen, um den Zustand zu überprüfen, aber es weiß nicht, dass es dies jedes Mal tun sollte, wenn `NewPerson.Age` sich ändert! Wir können dabei helfen. In unserem ViewModel-Konstruktor haben wir bereits das `NewPerson.PropertyChanged` -Ereignis abonniert: Darauf aufbauend rufen wir, wenn sich das Alter ändert (oder wenn es sich ändern könnte, es ist kein Problem, dies manchmal unnötigerweise zu tun), die Method `NotifyCanExecuteChanged` von `DecreaseAgeCommand` auf. Diese Operation hat einen sehr aussagekräftigen Namen: Sie teilt dem Befehl mit, dass sich der Zustand, auf dem der verbotene/erlaubte Zustand des Befehls aufgebaut ist, geändert hat. Auf diese Weise wird der Befehl selbst aktualisiert, genauer gesagt der Zustand der mit dem Befehl verbundenen Taste.

Ändern Sie die Behandlung der "+"-Taste auf ähnliche Weise auf Befehlsbasis! Ändern Sie **nicht** die Behandlung der Taste "+Add"!

!!! example "EINGABE"
    Machen Sie einen Screenshot mit dem Namen `f4.png` wie folgt:

    - Starten Sie die App. Verkleinern Sie sie gegebenenfalls, damit sie nicht zu viel Platz auf dem Bildschirm einnimmt,
    - der Name TextBox sollte in der Anwendung leer sein,
    - im "Hintergrund" sollte Visual Studio mit `PersonListPageViewModel.cs` geöffnet sein.

## Aufgabe 5 - Verwendung von Command mit MVVM Toolkit-basierter Codegenerierung

In der vorigen Aufgabe wurde die Einführung von Command-Eigenschaften und deren Instanziierung "manuell" gemacht. Das MVVM Toolkit kann dies vereinfachen: Wenn das richtige Attribut verwendet wird, können die Eigenschaft und die Instanziierung automatisch generiert werden.

 Ändern wir die Behandlung von `DecreaseAgeCommand` (nur dieses, `IncreaseAgeCommand` soll unverändert bleiben! ) auf eine generierte Codebasis:

1. Ergänzen Sie die Klasse `PersonListPageViewModel` mit dem Schlüsselwort `partial`. 
2. Entfernen Sie die Eigenschaft `DecreaseAgeCommand` und ihre Instanziierung aus dem Konstruktor.
3. Ergänzen Sie `DecreaseAge` mit diesem Attribut: `[RelayCommand(CanExecute = nameof(IsDecrementEnabled))]`. 
    * Als Ergebnis führt der Codegenerator eine Eigenschaft `RelayCommand` in die Klasse ein, die mit dem Namen unserer Operation (`DecreaseAge`) benannt ist und an die die Zeichenfolge "Command" angehängt ist. So erhalten wir die Eigenschaft `DecreaseAgeCommand`, die wir zuvor manuell eingeführt haben.
    * Die Attributeigenschaft `CanExecute` kann verwendet werden, um in Form einer Zeichenkette den Namen der Operation oder Eigenschaft  mit booleschen Rückgabewert anzugeben, die der generierte Code verwenden wird, wenn er den Befehl verbietet/erlaubt (er ist der zweite Parameter des Konstruktors RelayCommand). Wir haben bereits eine solche Eigenschaft, die "IsDecrementEnabled" heißt. Sie wird nicht als einfache Zeichenkette angegeben, denn wenn jemand die Operation `IsDecrementEnabled` nachträglich umbenennt, würde die aktuelle "IsDecrementEnabled" nicht auf die richtige Operation verweisen. Die Verwendung des Ausdrucks `nameof` vermeidet dieses Problem. Die Angabe von `CanExecute` ist im Allgemeinen optional (geben Sie es nicht an, wenn Sie den Befehl niemals deaktivieren wollen).

Testen Sie die Lösung (Verkleinerung des Alters), sie sollte genauso funktionieren wie zuvor.

!!! example "EINGABE"
    Machen Sie einen Screenshot mit dem Namen `f5.png` wie folgt:

    - Starten Sie die App. Verkleinern Sie sie gegebenenfalls, damit sie nicht zu viel Platz auf dem Bildschirm einnimmt,
    - im "Hintergrund" sollte Visual Studio mit `PersonListPageViewModel.cs` geöffnet sein.