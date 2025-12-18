---
autoren: kaszomark,kszicsillag
---
# 7. Datenverwaltung

## Das Ziel der Übung

Das Ziel der Übung ist, das Programmierungsmodell von ADO.NET zu erlernen und die häufigsten Datenverwaltungsprobleme und Fallstricke durch das Schreiben grundlegender CRUD-Operationen zu veranschaulichen.

Zugehörige Präsentationen: Datenverwaltung, ADO.NET-Grundlagen.

## Voraussetzungen

Die für die Durchführung der Übung benötigten Werkzeuge:

- Visual Studio 2026
- Betriebssystem Windows 11
- In dieser Übung werden wir den *SQL Server Object Explorer* in Visual Studio verwenden, um zwischen Datenbankobjekten zu navigieren und Abfragen auszuführen. Dazu ist möglicherweise die Komponente *SQL Server Data Tools* erforderlich, die am einfachsten auf der Seite *Individual Components* im Visual Studio Installer installiert wird, aber auch im Workload *Data Storage and Processing* enthalten ist.

!!! tip "Übung unter Linux oder Mac"
    Das Übungsmaterial ist grundsätzlich für Windows und Visual Studio gedacht, kann aber - auf eine etwas andere Weise - auch auf anderen Betriebssystemen durchgeführt werden, da das .NET SDK auch unter Linux und Mac unterstützt ist. Unter Linux:

    - Verwenden Sie anstelle von Visual Studio einen Texteditor (z. B.: VSCode) und CLI-Tools.
    - Es gibt eine Linux-Version von SQL Server, und auf dem Mac kann er in Docker ausgeführt werden (aber Docker ist wahrscheinlich der bequemste Weg, um ihn auch unter Linux auszuführen).
    - Zur Visualisierung der Daten kann das ebenfalls plattformübergreifende Tool *Azure Data Studio* verwendet werden.

## Lösung

??? "Laden Sie die fertige Lösung herunter"
    :exclamation: Es ist wichtig, dass Sie sich während des Praktikums an die Anleitung halten. Es ist verboten (und sinnlos), die fertige Lösung herunterzuladen. Allerdings kann es bei der anschließenden Selbsteinübung nützlich sein, die fertige Lösung zu überprüfen, daher stellen wir sie zur Verfügung.

    Die Lösung ist auf GitHub [hier](https://github.com/bmeviauab00/lab-adatkezeles-megoldas) verfügbar. Der einfachste Weg, es herunterzuladen, ist, es von der Kommandozeile aus mit dem Befehl `git clone` auf Ihren Computer zu klonen:

    `git clone https://github.com/bmeviauab00/lab-adatkezeles-megoldas`

    Sie müssen Git auf Ihrem Rechner installiert haben, weitere Informationen [hier](../../hazi/git-github-github-classroom/index.md#git-telepitese).

## Einführung

??? warning "Bemerkung für Übungsleiter/in"
    Dieses Kapitel muss in der Übung nicht so ausführlich erklärt werden wie es geschrieben ist, aber die wichtigsten Begriffe sollten kurz erläutert werden.

### ADO.NET

Für die Datenbankverwaltung auf niedriger Ebene auf der .NET-Plattform ist ADO.NET verfügbar, mit dessen Hilfe relationale Datenbanken zugegriffen werden können.

Bei der Verwendung von ADO.NET können Sie zwei verschiedene Datenzugriffsmodelle verwenden:

- Verbindungsbasiertes Modell
- Verbindungsloses Modell

Wenn Sie auf die zwei Blöcke unten klicken, können Sie sich einen Überblick über die Grundsätze der zwei Modelle verschaffen.

??? abstract "Grungprinzipen der Verbindungsbasiertes Modell"
    Die Idee ist, die Datenbankverbindung die ganze Zeit über offen zu halten, während die Daten abgefragt und geändert werden und die Änderungen dann in die Datenbank zurückgeschrieben werden. DataReader-Objekte können zur Lösung verwendet werden (siehe später). Der Vorteil dieser Lösung liegt in ihrer Einfachheit (einfacheres Programmierungsmodell und Konkurenzmanagement). Der Nachteil dieser Lösung ist, dass aufgrund der ständig offen gehaltene Netzwerkverbindung Skalierbarkeitsprobleme auftreten können. Dies bedeutet, dass bei einer großen Anzahl von gleichzeitigen Benutzerzugriffen auf den Dataverwalter eine große Anzahl von Datenbankverbindungen ständig aktiv ist, was eine kostspielige Ressource in Bezug auf die Leistung von Dataverwaltungssystemen darstellt. Daher ist es ratsam, während der Entwicklung zu versuchen, die Datenbankverbindungen so bald wie möglich zu schließen.

    Vorteile des Modells:

    - Einfachere Verwaltung des Wettbewerbs (Konkurenz)
    - Die Daten sind überall am neuesten

    Bemerkung: Diese Vorteile gelten nur, wenn der Datenverwalter für den Datenbankzugriff strikten Sperren benutzt - wir können dies mit dem Angabe des entsprechenden Transaktionsisolierungsgrades während des Zugriffs steuern. (Die Techniken dafür werden in späteren Studien beschrieben.)

    Nachteile:

    - Kontinuierliche Netzwerkverbindung
    - Mangelnde Skalierbarkeit

??? abstract "Grungprinzipen der Verbindungsloses Modell"
    Im Gegensatz zum verbindungsbasierten Modell wird keine Datenbankverbindung aufrechterhalten, wenn Daten angezeigt und im Speicher geändert werden. Die wichtigsten Schritte sind demnach folgende: Nach dem Aufbau der Verbindung und dem Abfrage der Daten wird die Verbindung sofort wieder geschlossen. Die Daten werden dann in der Regel angezeigt, und der Benutzer hat die Möglichkeit, die Daten zu ändern (Datensätze hinzuzufügen, zu ändern oder zu löschen, je nach Bedarf). Wenn wir Änderungen speichern, stellen wir die Datenverbindung wieder her, speichern die Änderungen in der Datenbank und schließen die Verbindung. Natürlich setzt das Modell voraus, dass wir zwischen der Abfrage der Daten und dem Zurüchschreiben der Änderungen - wenn wir keine Verbindung mit der Datenbank haben - die Daten und Änderungen im Speicher halten. Eine sehr bequeme Lösung dafür ist in der ADO.NET-Umgebung die Verwendung von `DataSet`-Objekten.

    Vorteile des Modells:

    - Keine ständige Netzwerkverbindung erforderlich
    - Skalierbarkeit

    Nachteile:

    - Die Daten sind nicht immer am neuesten
    - Kollisionen sind möglich
      
    Bemerkung: Es gibt mehrere Möglichkeiten, Objekte und damit verbundene Änderungen im Speicher zu speichern. Das `DataSet` ist nur eine der möglichen Techniken. Sie können aber auch gewöhnliche Objekte und .NET-Technologien (z. B. Entity Framework Core) verwenden, die die Verwaltung dieser Objekte erleichtern und fortschrittlicher sind als ADO.NET.

### Das verbindungsbasierte Modell

Im Labor werden wir das verbindungsbasierte Modell kennenlernen.

Das grundlegende Verfahren ist wie folgt:

1. Erstellen wir eine Verbindung zwischen der Anwendung und dem Datenbankmanagementsystem (mit dem Objekt `Connection`).
2. Erstellen wir die auszuführende SQL-Anweisung (unter Verwendung des Objekts `Command`).
3. Führen wir einen Befehl aus (unter Verwendung des Objekts `Command`).
4. Verarbeitung des zurückgegebenen Datensatzes für Abfragen (unter Verwendung des `DataReader`-Objekts). Für Modifikatorbefehle ist dies natürlich nicht notwendig.
5. Schließen der Verbindung.

Wie oben zu sehen ist, hat die Kommunikation mit der Datenbank in diesem Modell drei Hauptkomponenten:

- Connection
- Command
- DataReader

Diese Komponenten werden als Klasse dargestellt, deren datenbankunabhängiger Teil im BCL-Namensraum *System.Data.Common* unter Namen `DbConnection`, `DbCommand` und `DbDataReader` zu finden ist. Es handelt sich um abstrakte Klassen, und es ist die Aufgabe der Anbieter von Datenbankmanagern, Versionen zu schreiben, die bestimmte von ihnen abgeleitete Datenbankmanager unterstützen.

Alle drei ADO.NET-Komponenten unterstützen das *Dispose-Muster*, so dass sie im `using`-Block verwendet werden können - lassen wir uns sie auf diese Weise verwenden, wann immer wir können. Der Datenbankmanager befindet sich in der Regel auf einem anderen Rechner als der, auf dem unser Code läuft (nicht im Labor :)), also betrachten wir sie als entfernte Netzwerkressourcen.

Die Version, die Microsoft SQL Server unterstützt, finden wir im NuGet-Paket *Microsoft.Data.SqlClient* in Klassen mit dem Präfix "Sql" (`SqlConnection`, `SqlCommand` und `SqlDataReader`).

Andere Anbieter packen ihre eigene Version je in eine separate DLL(s), die daraus resultierende Komponente wird als *data provider* bezeichnet. Einige Beispiele ohne Anspruch auf Vollständigkeit:

- [PostgreSQL](https://www.npgsql.org/)
- [SQLite](https://learn.microsoft.com/en-us/dotnet/standard/data/sqlite/?tabs=netcore-cli) 
- [Oracle](https://www.oracle.com/database/technologies/appdev/dotnet/odp.html)

#### Connection

Dies ist die Verbindung zwischen unserem Programm und dem Datenbankverwaltungssystem.
Um sie zu initialisieren, benötigen wir einen Verbindungsstring (connection string), der dem Treiber (driver) die notwendigen Informationen zum Aufbau der Verbindung gibt. Das interne Format variiert von Datenbankanbieter zu Datenbankanbieter [(weitere Informationen](http://www.connectionstrings.com)).

Wenn eine neue `Connection` instanziiert wird, ist nicht garantiert, dass tatsächlich eine neue Verbindung zur Datenbank hergestellt wird. Die Treiber verwenden in der Regel Connection-Pooling, ähnlich wie Thread-Pooling, um frühere (derzeit nicht verwendete) Verbindungen wieder zu verwenden.

 `Connection` ist eine besonders teure, nicht verwaltete Ressource, daher muss **sichergestellt werden, dass sie so schnell wie möglich geschlossen wird**, wenn sie nicht mehr benötigt wird (z. B. durch den Aufruf von `Dispose()`, was in den meisten Fällen am einfachsten mit dem `using`-Block geschieht).

#### Command

So können wir "Anweisungen" für den Datenbankmanager formulieren. Diese müssen wir in SQL bestimmen.
Für `Command` muss eine Verbindung eingestellt werden - hier wird der Befehl ausgeführt. Der Befehl kann verschiedene Ergebnisse haben, dementsprechend wird der Befehl mit verschiedenen Funktionen ausgeführt:

- **ExecuteReader**: Abfrage einer Ergebnismenge (result set)
- **ExecuteScalar**: Abfrage des Skalar
- **ExecuteNonQuery**: Kein Rückgabewert (z.B: INSERT, UPDATE und DELETE), aber die Anzahl der von der Operation betroffenen Datensätze wird zurückgegeben

#### DataReader

Wenn das Ergebnis des Befehls eine Ergebnismenge ist, können wir diese Komponente verwenden, um die Daten zu lesen. Die Ergebnismenge kann als Tabelle angezeigt werden, `Data Reader` kann Zeile für Zeile (nur eine nach der anderen und vorwärts!) durch sie navigieren. Der Cursor befindet sich jeweils in einer Zeile. Sobald die gewünschten Daten aus der Zeile gelesen wurden, kann der Cursor eine Zeile weiterbewegt werden. Wir können nur aus der aktuellen Zeile lesen. Zu Beginn steht der Cursor nicht in der ersten Zeile, wir müssen ihn einmal bewegen, um ihn in die erste Zeile zu setzen.

Bemerkung: Die Navigation erfolgt im Speicher auf der Seite der Client, sie hat nichts mit den serverseitigen Cursors zu tun, die von jedem Datenverwaltern unterstützt werden.

## 1. Aufgabe - Vorbereitung der Datenbank

Zuerst brauchen wir einen Datenbankmanager. In einer realen Umgebung wird dies durch voll funktionsfähige Datenbankmanager erreicht, die auf dedizierten Servern laufen und von Datenbankadministratoren überwacht werden. Während der Entwicklungszeit, für lokale Tests, ist es jedoch bequemer, einen Datenbankmanager für Entwickler zu verwenden.
Als Teil der Visual Studio-Installation erhalten wir eine solche Datenbank-Engine, LocalDB, die eine vereinfachte Version des voll funktionsfähigen SQL Servers ist. Seine Hauptmerkmale sind:

- kann nicht nur mit Visual Studio, sondern auch separat installiert werden,
- die Datenbank-Engine ist fast vollständig kompatibel mit dem vollwertigen Microsoft SQL Server,
- ist grundsätzlich auf dem Rechner verfügbar, auf dem es installiert ist,
- mehrere Instanzen können bei Bedarf erstellt werden, die Instanzen stehen im Wesentlichen dem Benutzer des erstellenden Betriebssystems zur Verfügung (eine Instanz kann bei Bedarf von mehreren Benutzern gemeinsam genutzt werden),
- für die Verwaltung eigener Instanzen (Erstellen, Löschen usw.) sind keine Administratorrechte erforderlich.
  
??? note "ssqllocaldb Kommandozeilenwerkzeug"
    In der Übung brauchen wir das nicht, aber wir können das `sqllocaldb` Kommandozeilenwerkzeug verwenden, um Instanzen zu verwalten.  Einige Befehle, die durch Eingabe nach `sqllocaldb` verwendet werden können:

    | Befehl | Beschreibung |
    |----------------|------------------------------------------------------------|
    | info | Liste der Instanzen, die für den aktuellen Benutzer sichtbar sind |
    | create "locdb" | Erstellen einer neuen Instanz mit dem Namen "locdb" |
    | delete "locdb" | Löschen der Instanz mit dem Namen "locdb" |
    | start "locdb" | Starten der Instanz mit dem Namen "locdb" |
    | stopp "locdb" | Stoppen der Instanz mit dem Namen "locdb" |

Visual Studio installiert und startet auch LocalDB-Instanzen, so dass es sich lohnt, zu überprüfen, was Visual Studio standardmäßig sieht.

1. Starten Sie Visual Studio und wählen Sie SQL Server Object Explorer (SSOE) aus dem Menü Ansicht.
2. Öffnen Sie den SQL Server-Knoten. Wenn Sie andere Knoten darunter sehen, haben Sie einen erfolgreichen Fall, öffnen Sie einen davon (dadurch wird die Instanz gestartet, falls sie noch nicht gestartet ist, Sie müssen also möglicherweise etwas warten).
3. Wenn nichts erscheint, gibt der Befehl `mssqllocaldb info` in der Befehlszeile die vorhandenen Instanzen zurück. Klicken Sie mit der rechten Maustaste auf den Knoten SQL Server und wählen Sie *Add SQL Server*, dann geben Sie eine vorhandene Instanz an, z. B. *(localdb)MSSQLLocalDB*
4. Wählen Sie im erscheinenden Knoten *Databases* die Option *New Database* und geben Sie einen Datenbanknamen ein. (Da in der Übungen mehrere Schüler denselben Betriebssystembenutzer verwenden können, empfiehlt es sich, den Neptun-Code als Namen zu verwenden).
5. Klicken Sie mit der rechten Maustaste auf den neuen Datenbankknoten und wählen Sie *New Query*, wodurch sich ein neues Abfragefenster öffnet.
6. Öffnen Sie oder laden herunter das *Northwind* [Datenbankinitialisierungsskript](northwind.sql).
7. Kopieren Sie das vollständige Skript in das Abfragefenster.
8. Führen Sie das Skript aus, indem Sie auf den kleinen grünen Pfeil (*Execute*) klicken. Beobachten Sie darauf, dass **die gute Datenbank (die in Schritt 4 oben erstellt wurde) oben im Abfragefenster in der Dropdown-Liste ausgewählt** ist!
9. Prüfen Sie, ob Tabellen und Ansichten in unserer Datenbank erzeugt werden.
10. Sehen wir uns die wichtigsten Funktionen von SSOE an (Abruf von Daten aus Tabellen, Schemata usw.).

!!! note "MSSQL-Verwaltungstools"
    In Visual Studio können Sie Datenbanken mit zwei Tools verwalten: dem Server Explorer und dem SQL Server Object Explorer. Ersteres ist ein allgemeineres Tool, das nicht nur Datenbanken, sondern auch andere Serverressourcen (z. B. Azure-Server) verwalten kann, während letzteres speziell auf die Datenbankverwaltung ausgerichtet ist. Auf beide kann über das Menü View zugegriffen werden, und beide bieten ähnliche Datenbankverwaltungsfunktionen, weshalb wir in dieser Übung nur einen (SQL Server Object Explorer) verwenden werden.

    Wenn die Visual Studio-Entwicklungsumgebung nicht für unsere Verfügung steht, können wir das (kostenlose) SQL Server Management Studio oder das kostenlose und plattformübergreifende Azure Data Studio verwenden, um unsere Datenbank zu verwalten.

## 2. Aufgabe - Abfrage mit ADO.NET SqlDataReader

Die Aufgabe ist eine C#-Konsolenanwendung zu erstellen, die die Datensätze der Northwind-Datenbanktabelle `Shippers` verwendet.

1. Erstellen Sie eine Konsolenanwendung in C#. Der Projekttyp sollte *Console App* und **NICHT** *Console App (.NET Framework)* sein:
    - Der Projektname sollte *AdoExample* lauten
    - Das Target Framework sollte *.NET 10* sein
    - Aktivieren Sie die Option *Do not use top-level statements*
  
2. Suchen Sie die Verbindungsstring (connection string) aus der SSOE: Klicken Sie mit der rechten Maustaste auf unsere Datenbankverbindung (in der Abbildung unten rot markiert) / Properties.

    ![SSOE Database](images/SSOS-database.png)

3. Kopieren Sie die Eigenschaft *Connection String* aus dem Fenster Properties in eine Variable der Klasse `Program`. 

    ```cs
    private const string ConnString = @"Data Source=(localdb)MSSQLLocalDB;Initial Catalog=neptun;Integrated Security=True;Connect Timeout=30;Encrypt=False;TrustServerCertificate=False;ApplicationIntent=ReadWrite;MultiSubnetFailover=False";
    ```

    !!! tip "SQL Server-Verbindungsstringformat"
        Bei MSSQL enthält das Verbindungsstrings Schlüssel-Wert Paare, die durch Semikolon getrennt sind.
        Unter dem Schlüssel `Data Source` steht der Name der SQL-Server-Instanz und unter dem Schlüssel `Initial Catalog` der Name der Datenbank.
        Die Option `Integrated Security=true` steht für die Windows-Authentifizierung.

    !!! tip "String mit @ (C# verbatim string)"
         `@` ist ein Sonderzeichen (verbatim identifier), das hier verwendet wird, um zu vermeiden, dass das Backslash-Zeichen (`\`) in der Verbindungszeichenfolge als Escape-Zeichen interpretiert wird.

4. Fügen Sie das NuGet-Paket `Microsoft.Data.SqlClient` zum Projekt hinzu. Es gibt zwei Möglichkeiten, dies zu tun:
  
      - A) in NuGet-Manager von Visual Studio:
        1. Auf dem Projekt rechte Taste / *Manage NuGet Packages*..., auf der erscheinenden Seite wechseln Sie zu *Browse*.
        2. Geben Sie in das Suchfeld *Microsoft.Data.SqlClient*.
        3. Wählen Sie im Feld *Version* die Version 5.0.1 aus (im Labor wählen wir diese Version, weil sie sich im NuGet-Cache auf den Rechnern befindet; für Üben zu Hause wählen Sie die *Latest stable* Version).
      - B) Wir kopieren den folgenden Paketverweis in die Projektdatei:

        ```xml
        <ItemGroup>
            <PackageReference Include="Microsoft.Data.SqlClient" Version="5.0.1" />
        </ItemGroup>
        ```

    !!! note "NuGet Package Manager"
        NuGet ist ein Online-Paketverwaltungssystem, mit dem Sie externe Abhängigkeiten und Klassenbibliotheken in versionierter Form mit Ihren .NET-basierten Projekten verknüpfen können. Mehr Information über es war in der ersten Vorlesung.

5. Schreiben Sie eine Abfragefunktion, die alle Lieferer abfragt:

    ```cs
    private static void GetShippers()
    {
        using (var conn = new SqlConnection(ConnString))
        using (var command = new SqlCommand("SELECT ShipperID, CompanyName, Phone FROM Shippers", conn))
        {
            conn.Open();
            Console.WriteLine("{0,-10}{1,-20}{2,-20}", "ShipperID", "CompanyName", "Phone");
            Console.WriteLine(new string('-', 60));
            using (SqlDataReader reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    Console.WriteLine(
                        $"{reader["ShipperID"],-10}" +
                        $"{reader["CompanyName"],-20}" +
                        $"{reader["Phone"],-20}");
                }
            }
        }
    }
    ```

    Das Verfahren des verbindungsbasierten Modells:

    - Verbindung und Befehl initialisieren
    - Verbindung öffnen
    - Ausführen eines Befehls
    - Verarbeitung des Ergebnisses
    - Verbindung schließen, Reinigung

    !!! tip "Einige Bemerkungen zum Code"
        - `DataReader`erhält man als Ergebnis der Ausführung des Befehls, nicht durch direkte Instanziierung
        - Die Verbindung muss vor der Ausführung des Befhels geöffnet werden.
        - Bei der Instanziierung von `DbConnection` wird die Verbindung nicht geöffnet (keine Netzwerkkommunikation)
        - Die Funktion `DataReader.Read()` zeigt an, ob noch Daten in der Ergebnismenge vorhanden sind
        - Sie können `DataReader` mit den Namen der Spalten in der Ergebnismenge indizieren - das Ergebnis wird `object` sein, wenn Sie also einen spezifischeren Typ benötigen, müssen Sie einen Cast durchführen
        - Der Compiler interpretiert den SQL-Befehlstext nicht (es ist nur ein String), nur die Datenbank tut dies, daher erhalten Sie im Falle eines SQL-Fehlers eine Laufzeitausnahme
        - Beachten Sie, dass, an wie viele Stellen im Code Strings manuell umgeschrieben werden soll, wenn sich das Datenbankschema ändert, z.B. nach der Umbenennung einer Spalte. 
        - Mit `$` können Sie String-Interpolation verwenden, d. h. Ausdrücke einbetten, die direkt im String ausgewertet werden (C# 6-Fähigkeit). `$@` ermöglicht es Ihnen, mehrzeilige String-Interpolationsausdrücke zu schreiben (Sie müssen den Zeilenumbruch zwischen {} einfügen, sonst wird er in der Ausgabe angezeigt). Interessante Tatsache: Ab C# 8 können Sie $- und @-Zeichen in beliebiger Reihenfolge schreiben, daher sind auch `$@` und `@$` korrekt.
        - Das using-Schlüsselwort kann als einzeiliger Ausdruck anstelle einer Blockanweisung verwendet werden. In diesem Fall reicht das Ende des using-Blocks bis zum Ende des enthaltenden Blocks (in unserem Fall das Ende der Funktion). Dies reduziert die Anzahl der Einzüge, sollte aber seine Benutzung kein automatischer Reflex sein, da es sinnvoll sein kann, die Freigabe von Ressourcen früher als am Ende des enthaltenden Blocks zu erzwingen.

            ```cs
            private static void GetShippers()
            {
                using var conn = new SqlConnection(ConnString);
                using var command = new SqlCommand("SELECT ShipperID, CompanyName, Phone FROM Shippers", conn);

                conn.Open();

                Console.WriteLine("{0,-10}{1,-20}{2,-20}","ShipperID", "CompanyName", "Phone");
                Console.WriteLine(new string('-', 60));

                using var reader = command.ExecuteReader();
                while (reader.Read())
                {
                    Console.WriteLine(
                        $"{reader["ShipperID"],-10}" +
                        $"{reader["CompanyName"],-20}" +
                        $"{reader["Phone"],-20}");
                }
            }
            ``` 

            Diese Methode wird im Folgenden verwendet, um Einzüge und Klammern zu speichern.

6. Rufen Sie unsere neue Funktion von `Main` aus auf.

    ```cs hl_lines="3"
    private static void Main(string[] args)
    {
        GetShippers();
    }
    ```

7. Probieren wir die App aus. Wir sollten SQL zerstören und es auf diese Weise versuchen.

## 3. Aufgabe - Einfügen mit SQL-Anweisung

1. Schreiben Sie eine Funktion zum Einfügen eines neuen Lieferer in die Datenbank:

    ```cs
    private static void InsertShipper(string companyName, string phone)
    {
        using var conn = new SqlConnection(ConnString);
        using var command = new SqlCommand(
            "INSERT INTO Shippers(CompanyName, Phone) VALUES(@name,@phone)", conn);
        command.Parameters.AddWithValue("@name", companyName);
        command.Parameters.AddWithValue("@phone", phone);

        conn.Open();

        int affectedRows = command.ExecuteNonQuery();

        Console.WriteLine($"{affectedRows} rows affected");
    }
    ```

    Hier müssen wir solches SQL schreiben, für dessen Erstellung auch solche Variablenwerten verwendet werden, die wir von außen erhalten haben. Um die Zeichenkette zusammenzusetzen, hätten wir einfach den Operator für die Zeichenkettenverkettung, die Zeichenketteninterpolation oder `string.Format` verwenden können, aber das hat ein Sicherheitsrisiko (SQL Injection - siehe unten für weitere Details) - **NIEMALS!!! darf SQL mit einer Zeichenkettenoperation zusammengesetzt werden**. Stattdessen sollten wir SQL so schreiben, dass wir an die Stelle der Werte von Variablen, Parameterreferenzen setzen. Bei SQL Server lautet die Syntax des Verweises @parametername.

    Um den Befehl auszuführen, müssen wir auch die Werte der Parameter an die Datenbank übergeben, da diese die Ersetzung der Werte für die Parameter vornimmt.

    Die Ausgabe des Einfügebefehls ist keine Ergebnismenge, daher muss er mit `ExecuteNonQuery` ausgeführt werden, das die Anzahl der eingefügten Zeilen zurückgibt.

2. Rufen Sie unsere neue Funktion von `Main` aus auf.

    ```cs hl_lines="2-3"
    GetShippers();
    InsertShipper("Super Shipper","49-98562");
    GetShippers();
    ```

3. Probieren wir die Anwendung aus und prüfen wir in der Konsole und in der SSOE, ob die neue Zeile eingefügt wurde. Für eine schnelle und bequeme Überprüfung in SSOE wählen Sie *View Data* aus dem Kontextmenü der Tabelle `Shippers`. 

## 4. Aufgabe - Modifikation durch gespeicherte Prozedur

1. Schauen Sie den Code des gespeicherten Verfahrens `Product_Update` in SSOE an. Öffnen Sie dazu den Knoten *Programmability* / *Stored Procedures*, und wählen Sie dann *View Code* aus dem Kontextmenü der gespeicherten Prozedur `Product_Update`. 

    !!! note "Programmcode in der Datenbank"
        Die großen Datenverwaltungssysteme bieten die Möglichkeit, Programmcode in der Datenbank des Datenverwalters selbst zu definieren. Diese werden als gespeicherte Verfahren bezeichnet. Die Sprache ist abhängig von der Datensteuerung, aber für MSSQL ist es T-SQL.

        Heutzutage wird die Praxis, ernsthafte Geschäftslogik in die Datenbank zu packen, immer mehr aus der Industrie verdrängt, da der Werkzeugsatz dieser SQL-Dialekte nun viel begrenzter ist als der einer höheren Programmiersprache (C#, Java). Darüber hinaus wird die Testbarkeit des Systems durch die Verwendung von gespeicherten Prozeduren stark beeinträchtigt. Dennoch kann es manchmal sinnvoll sein, einen Teil der Logik in der Datenbank zu belassen, wenn wir den Vorteil nutzen wollen, dass unser Code in der Nähe der Daten läuft, z. B. wenn wir für eine einfache Massenpflege von Daten nicht über das Netz gehen wollen.

2. Schreiben Sie eine Funktion, die diese gespeicherte Prozedur aufruft

    ```cs
    private static void UpdateProduct(int productID, string productName, decimal price)
    {
        using var conn = new SqlConnection(ConnString);
        using var command = new SqlCommand("Product_Update", conn);

        command.CommandType = CommandType.StoredProcedure;

        command.Parameters.AddWithValue("@ProductID", productID);
        command.Parameters.AddWithValue("@ProductName", productName);
        command.Parameters.AddWithValue("@UnitPrice", price);

        conn.Open();

        int affectedRows = command.ExecuteNonQuery();
        
        Console.WriteLine($"{affectedRows} rows affected");
    }
    ```

    Der `Command` musste der Name der gespeicherten Prozedur gegeben werden und der Typ des Befehls musste geändert werden, ansonsten ist er strukturell ähnlich wie der vorherige Einfügecode.

3. Rufen Sie unsere neue Funktion von `Main` aus auf, z. B. mit den folgenden Parametern:

    ```cs
    UpdateProduct(1, "MyProduct", 50);
    ```

4. Probieren wir die Anwendung aus und prüfen in der Konsole und in SSOE, ob das Produkt mit der ID 1 geändert wurde.

## 5. Aufgabe - SQL-Injektion

1. Schreiben wir die Einfügefunktion so, dass der SQL-Befehl mit Hilfe der String-Interpolation zusammengefügt wird.

    ```cs
    private static void InsertShipper2(string companyName, string phone)
    {
        using var conn = new SqlConnection(ConnString);
        using var command = new SqlCommand(
            $"INSERT INTO Shippers(CompanyName, Phone) VALUES('{companyName}','{phone}')",
            conn);

        conn.Open();

        int affectedRows = command.ExecuteNonQuery();
        Console.WriteLine($"{affectedRows} row(s) inserted");
    }
    ```

2. Rufen Sie unsere neue Funktion von `Main` mit "speziellen" Parametern auf.

    ```cs
    InsertShipper2("Super Shipper", "49-98562'); DELETE FROM Shippers;--");
    ```

    Der zweite Parameter wird so gesetzt, dass die ursprüngliche Anweisung geschlossen wird, dann können wir beliebiges **(!!!)** SQL schreiben und schließlich den Rest der ursprünglichen Anweisung auskommentieren, (`--`).

3. Probieren Sie die Anwendung aus, sollten Sie einen Fehler erhalten, der angibt, dass ein Lieferant aufgrund eines Fremdschlüsselverweises nicht gelöscht werden kann.

    Also `DELETE FROM` ist auch gelaufen! Prüfen wir mit dem Debugger (z. B. durch Anhalten bei der Anweisung `conn.Open` ), wie das endgültige SQL (`command.CommandText`) lautet.

    Lehre gelernt:

    - Fügen Sie SQL NIE programmatisch zusammen (egal mit welcher Methode), da dies Ihren Code für SQL-Injection-basierte Angriffe anfällig macht.
    - Die Datenbank sollte das endgültige SQL auf der Grundlage der SQL-Parameter zusammensetzen, denn dann ist gewährleistet, dass die Parameterwerte nicht als SQL interpretiert werden (selbst wenn SQL eingegeben wird). Verwenden Sie parametrisiertes SQL oder gespeicherte Prozeduren.
    - Verwenden Sie Datenbankbeschränkungen, z. B. zum Schutz vor versehentlichem Löschen.
    - Konfigurieren Sie Benutzer in der Datenbank mit unterschiedlichen Rechten. Der in der Verbindungszeichenfolge Ihres Programms angegebene Benutzer sollte nur die für den Betrieb erforderlichen Mindestrechte haben. In unserem Fall haben wir keinen Benutzer angegeben, wir werden uns als Windows-Benutzer verbinden.

4. Rufen wir nun die ursprüngliche (d.h. die sichere, mit SQL-Parametern versehene) Einfügefunktion mit der "speziellen" Parametrisierung auf, um zu sehen, ob der Schutz funktioniert:

    ```cs
    InsertShipper("Super Shipper", "49-98562'); DELETE FROM Shippers;--");
    InsertShipper("XXX');DELETE FROM Shippers;--", "49-98562");
    ```

    Der erste passt nicht in die Größenbeschränkung, der zweite läuft, aber nur ein "seltsam" benannter Anbieter ist enthalten. Der Parameterwert wurde tatsächlich als Wert und nicht als SQL interpretiert. Nicht so wie hier:

    ![XKCD](images/xkcd-sql-injection.png)

## 6. Aufgabe - Löschen

1. Schreiben Sie eine neue Funktion zum Löschen eines bestimmten Lieferanten.

    ```cs
    private static void DeleteShipper(int shipperID)
    {
        using var conn = new SqlConnection(ConnString);
        using var command = new SqlCommand("DELETE FROM Shippers WHERE ShipperID = @ShipperID", conn);
        command.Parameters.AddWithValue("@ShipperID", shipperID);

        conn.Open();

        int affectedRows = command.ExecuteNonQuery();

        Console.WriteLine($"{affectedRows} row(s) affected");
    }
    ```

2. Rufen wir unsere neue Funktion von `Main` auf, parametrisiert mit, sagen wir, 1.
3. Probieren wir die App aus. Sie werden wahrscheinlich eine Ausnahme erhalten, da ein Verweis (mit Fremdschlüssel-Beschränkung) auf den Datensatz besteht.
4. In SSOE suchen wir nach der ID eines Lieferanten, den wir beauftragt haben. Übergeben wir diesen Bezeichner an die Löschfunktion - sie kann ihn löschen, da es keinen Verweis auf ihn gibt.

!!! tip "Löschstrategien"
    Es zeigt sich, dass das Löschen aufgrund der Fremdschlüssel-Beschränkungen eine sehr riskante und unvorhersehbare Operation ist. Einige Möglichkeiten, die Löschung zu verwalten:

    - **Wir erlauben keine Löschung**: Wenn der zu löschende Datensatz referenziert ist, gibt die Datenbank einen Fehler zurück (wie oben gezeigt).
    - **Löschkaskade** - die Fremdschlüssel-Beschränkung kann so eingestellt werden, dass der referenzierte Datensatz (die das Referenz auf die anderen hat) gelöscht wird, wenn der referenzierte Datensatz (wo das Referenz zeigt) gelöscht wird. Dies führt oft dazu, dass alle unsere Fremdschlüssel-Beschränkungen so aussehen, und eine (versehentliche) Löschung kann die gesamte Datenbank auslöschen, d.h. die Auswirkungen der Löschung sind schwer vorherzusagen.
    - **NULL der Referenz** - die Fremdschlüssel-Beschränkung kann so eingestellt werden, dass das Fremdschlüsselfeld des referenzierten Datensatzes auf `NULL` gesetzt wird, wenn der referenzierte Datensatz gelöscht wird. Nur anwendbar, wenn das Fremdschlüsselfeld in Ihrem Modell auf `NULL` gesetzt werden kann.
    - **logisches Löschen** (soft delete) - anstelle eines Löschvorgangs wird nur eine Flaggenspalte (z.B. `IsDeleted`) gesetzt. Der Vorteil ist, dass Sie sich nicht mit Fremdschlüssel-Beschränkungen befassen müssen und die gelöschten Daten bei Bedarf verfügbar sind (z. B. beim Rückgängigmachen des Löschvorgangs). Der Vorgang ist jedoch kompliziert, da man sich damit befassen muss, wie und wann gelöschte Datensätze gefiltert werden sollen (z. B. damit sie nicht in der Schnittstelle oder in der Statistik erscheinen) oder wie man damit umgeht, wenn ein nicht gelöschter Datensatz auf einen gelöschten Datensatz verweist.

## Ausblick

Die oben genannten grundlegenden ADO.NET-Operationen in der hier gezeigten Form werden aus zwei Gründen selten verwendet (auch wenn dieser Ansatz die beste Leistung bietet):

- Schlechte Typisierung (das Einlesen der Daten eines Datensatzes in die Eigenschaften einer Klasse ist sehr umständlich, Cast usw.)
- SQL kodiert in Strings (Fehler aufgrund von Tippfehlern werden erst zur Laufzeit erkannt)
  
Ersteres kann durch verschiedene Komponenten gelöst werden, die ADO.NET ergänzen, wie z.B.:

- [Dapper](https://github.com/DapperLib/Dapper)
- [PetaPoco](https://github.com/CollaboratingPlatypus/PetaPoco)

Diese Lösungen bieten mehr Komfort bei minimalen Leistungseinbußen.

Beide Probleme werden durch ORM-Systeme (Object-Relational-Mapping) gelöst, die jedoch einen höheren Overhead haben als die oben genannten Lösungen. ORMs erstellen ein Mapping zwischen der Datenbank und unseren OO-Klassen und verwenden dieses Mapping, um Datenbankoperationen zu vereinfachen. Unsere in Typcode geschriebenen Operationen mit unseren Klassen werden automatisch in die entsprechenden Datenbankoperationen übersetzt, so dass unser In-Memory-Objektmodell mit der Datenbank synchronisiert wird. ORMs verwenden daher ein verbindungsloses Modell. Besser bekannte .NET ORMs:

- ADO.NET DataSet - ORM der ersten Generation, jetzt sehr selten verwendet
- Entity Framework 6.x - das am häufigsten verwendete ORM-Framework im (alten) .NET Framework
- [Entity Framework Core](https://learn.microsoft.com/en-us/ef/core/) (EF Core) - derzeit das wichtigste .NET ORM (Open Source)
- [NHibernate](https://nhibernate.info/) - die .NET-Portierung von Hibernate für Java (Open Source)

Das Entity Framework Core wird in der Spezialisierung *Adatvezérelt rendszerek* und im Wahlfach *Szoftverfejlesztés .NET platformon* ausführlicher behandelt.
