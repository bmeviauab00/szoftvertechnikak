
# Development environment for homework tasks

## Introduction

During the semester, **Visual Studio 2026** must be used to complete the homework tasks. To run it, you need the Windows operating system. If Visual Studio 2026 is already installed on your machine, you can launch the "Visual Studio Installer" from the Start menu. Upon launching, it will check if a newer version of Visual Studio is available online, and if so, click the "Update" button to install the latest version.

??? note "Why do we need Visual Studio and Windows?"
    VS Code or JetBrains Rider are not usable due to the following reasons:

    - They do not support UML (similar) modeling, that is required for the first homework task.
    - They do not properly support the development of .NET applications with a *WinUI3* user interface (starting from the 3rd homework task, certain tasks will build on this feature).
    - The lab materials and homework tasks are written for a supported development environment, so we use the same familiar environment both in labs and at home.

### Visual Studio editions

There are several editions of Visual Studio:

- For the course, the free *Community* edition is sufficient, that can be downloaded from the Microsoft website.
- Of course, the *Professional* and *Enterprise* editions can also be used, but they do not provide significant additional benefits for the course. These paid versions are available for free to university students (through the Azure Dev Tools for Teaching program on <https://azureforeducation.microsoft.com/devtools>).

### Components to be Installed

The first lecture of the course briefly covers the different versions of .NET (.NET Framework 4.x, .NET 5-10, etc.). .NET 10 will be used for the tasks during the semester. Visual Studio will install this version, but you also need to install the ".NET desktop development" Visual Studio Workload:

1. Launch the Visual Studio Installer (e.g., type "Visual Studio Installer" in the Windows Start menu).
2. Click on the Modify button.
3. In the window that appears, check if the **".NET desktop development"** card is checked.
4. If not, check it, and then click *Modify* in the bottom-right corner to install it.

#### Class Diagram support

For certain homework tasks (including the first one), Visual Studio Class Diagram support is required. You can install it as follows:

1. Launch the Visual Studio installer (e.g., type "Visual Studio Installer" in the Windows Start menu).
2. Click the Modify button.
3. In the window that appears, select the "Individual components" tab.
4. In the search box, type "class designer", and ensure that the "Class Designer" item is checked in the filtered list.
5. If not, check it and then click *Modify* in the bottom-right corner to install it.

    ![Class Diagram support installation](images/install-vs-class-diagram.png)

#### WinUI support

For tasks related to XAML/WinUI technologies (starting from the 3rd homework task), you will need to pre-install the Windows App SDK and modify certain low-level system settings.

1. Enable "Developer mode" on the computer. You should search for "Developer settings".

2. In the Visual Studio installer, make sure that the ".NET Desktop Development" workload is installed (if not, check and install it).

3. Install the "Windows App SDK C# templates" Visual Studio component.

    In the Visual Studio installer, select the ".NET Desktop Development" workload, then in the "Installation details" panel on the right, scroll down and check the "Windows App SDK C# Templates" component, then click "Modify" in the bottom-right corner.

4. Install the Windows App SDK

    The latest version can be downloaded from here: <https://learn.microsoft.com/en-us/windows/apps/windows-app-sdk/downloads>. However, during the semester, we will use the "1.6.4 (1.6.250108002)" version for labs and homework, so it is recommended to install this version, even if a newer version is released. It can be found here: <https://learn.microsoft.com/en-us/windows/apps/windows-app-sdk/older-downloads>. You should install the x64 version for a modern machine.

5. If Windows 11 does not work after these steps, you may need to install version 10.0.19041 or later of the Windows 10 SDK (found under Individual Components in the Visual Studio installer).

### Information for MacBook and Linux Users

The lecturer (Dr. Mohammad Saleem, <msaleem@aut.bme.hu>) can be contacted via email to request BME Cloud access.
