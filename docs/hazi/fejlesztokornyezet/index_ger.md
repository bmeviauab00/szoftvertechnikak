# Entwicklungsumgebung für Hausaufgaben

## Einführung

Für die Hausaufgaben während des Semesters muss die Entwicklungsumgebung **Visual Studio 2022** verwendet werden (Visual Studio für Mac ist nicht geeignet). Zum Ausführen benötigen Sie ein Windows-Betriebssystem.  Wenn Sie Visual Studio 2022 bereits auf Ihrem Computer installiert haben, starten Sie den "Visual Studio Installer" über das Startmenü. Dadurch wird beim Start geprüft, ob eine neuere Version von Visual Studio online verfügbar ist. Ist dies der Fall, klicken Sie auf Aktualisieren, um die Installation der neuesten Version zu starten.

??? Hinweis "Warum brauche ich Visual Studio und Windows?"
    VS Code oder Visual Studio für Mac kann aus folgenden Gründen nicht verwendet werden:
    
    - Sie unterstützen keine UML-ähnliche Modellierung, die für die erste Hausaufgabe benötigt wird.
    - Sie unterstützen nicht die Entwicklung von .NET-Anwendungen mit der Benutzeroberfläche *WinUI3* (einige Hausaufgaben ab Hausaufgabe 3 bauen darauf auf).

### Visual Studio Ausgabe-ök

Es gibt verschiedene Editionen von Visual Studio:

- Um den Kurs zu absolvieren, können Sie die kostenlose *Community-Edition* von der Microsoft-Website herunterladen.
- Die *Professional-* und *Enterprise-Versionen* können natürlich auch verwendet werden, bieten aber keinen inhaltlichen Mehrwert. Diese kostenpflichtigen Versionen sind für Universitätsstudenten kostenlos erhältlich (unter https://azureforeducation.microsoft.com/devtools, als Teil des Azure Dev Tools for Teaching Programms).

### Zu installierende Komponenten

In der ersten Vorlesung des Kurses werden kurz die verschiedenen Versionen von .NET (.NET Framework, .NET Core, .NET 5-8 usw.) behandelt. Wir werden .NET 8 verwenden, um die Probleme während des Semesters zu lösen. Visual Studio installiert dies, aber Sie müssen den ".NET Desktop Development" Visual Studio Workload installieren:

1. Starten Sie das Visual Studio-Installationsprogramm (z. B. durch Eingabe von "Visual Studio Installer" im Windows-Startmenü).
2. Klicken Sie auf die Schaltfläche Ändern
3. Vergewissern Sie sich in dem nun erscheinenden Fenster, dass die Karte **".NET-Desktop-Entwicklung"** aktiviert ist.
4. Wenn nicht, entfernen Sie das Häkchen und klicken Sie unten rechts auf *Ändern*, um es zu installieren.

#### Unterstützung von Klassendiagrammen

Für bestimmte Hausaufgaben (sogar für die erste) benötigen Sie die Unterstützung von Visual Studio Class Diagram. Diese kann unter Visual Studio wie folgt installiert werden:

1. Starten Sie das Visual Studio-Installationsprogramm (z. B. durch Eingabe von "Visual Studio Installer" im Windows-Startmenü).
2. Klicken Sie auf die Schaltfläche Ändern
3. Wählen Sie in dem nun erscheinenden Fenster die Registerkarte "Einzelne Komponenten"
4. Geben Sie in das Suchfeld "Klassendesigner" ein und vergewissern Sie sich, dass "Klassendesigner" in der gefilterten Liste nicht angekreuzt ist.
5. Wenn nicht, entfernen Sie das Häkchen und klicken Sie unten rechts auf *Ändern*, um es zu installieren.
    
    ![TableDiagram Unterstützung Installation](images/install-vs-class-diagram.png)

#### WinUI-Unterstützung

Für Aufgaben, die sich auf XAML/WinUI-Technologien beziehen (ab Hausaufgabe 3), ist eine vorherige Installation des Windows App SDK erforderlich. Es kann installiert werden von: https://learn.microsoft.com/en-us/windows/apps/windows-app-sdk/downloads. Während des Semesters werden wir "1.4.4 (1.4.231219000)" in Übungen und Tutorien verwenden. Es wird empfohlen, diese Version zu installieren, auch wenn eine neuere Version veröffentlicht wird.

### Informationen für MacBook- und Linux-Benutzer

Sie können den Zugang zur BME-Cloud beim zuständigen Dozenten (Zoltán Benedek) per E-Mail anfordern.