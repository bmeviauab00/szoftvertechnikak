# Git, GitHub, GitHub Classroom

In this course, our goal is not to learn Git and GitHub in detail, but to focus on the most essential steps and use the most important commands to allow students to download the starting framework of their assignments from a dedicated GitHub repository and upload their completed work to GitHub.

## Git

Git is a widely used, feature-rich, freely downloadable, and installable distributed version control system. Unlike centralized systems (TFS, SVN), in Git, developers do not work in a single central repository but each has their own local repository instance.

A Git **repository** (repo) is essentially a regular directory in the file system containing files (such as source code) and subdirectories, along with a ".git" subdirectory that stores all additional information related to version control.

The essential steps in a Git-based workflow—simplified—are as follows (assuming there is a central repository where the version-controlled code is available):

1. The developer clones (`clone`) the central repository, creating a local copy on their computer. This step only needs to be done once.
2. The developer makes changes to the code in their local repository’s working directory: adding new files, modifying, and deleting existing ones.
3. Once a meaningful task is completed, the developer commits (`commit`) the changes to their local repository. It is advisable to include a descriptive message summarizing the nature of the changes.
4. The developer then pushes (`push`) the changes from the local repository to the central repository, making them visible to others.

Each **commit** is essentially a set of code changes with a timestamp, the developer's username, and email address. The repository's version history is formed by the sequence of these commits.

Since developers usually work in teams, they need to periodically download and merge others' changes from the central repository into their local repository. This is done using the `pull` command. A key rule is that pushing (`push`) to the central repository is only possible if all prior changes from others have been merged via `pull`.

In this course, the `pull` command is not required because each student works independently in their own repository. However, if changes are made directly on GitHub or in multiple clones, then `pull` is necessary.

Beyond these basics, Git offers many additional features, such as viewing the complete version history for each file, reviewing commit history, reverting to past versions, and managing branches.

## GitHub

GitHub is an online service and platform (https://github.com) that provides comprehensive Git support. For public repositories (accessible to everyone), it is completely free. Over time, GitHub has become the leading platform for version-controlled code storage and the home of most open-source projects.

## GitHub Classroom

GitHub Classroom is a free, GitHub-integrated service that enables educational institutions to create unique GitHub repositories for each student for individual assignments. It facilitates the distribution of starter code and the collection of completed assignments.

## Git, GitHub, and GitHub Classroom in the Course Context

For this course, each student receives a dedicated GitHub-hosted repository for each assignment via GitHub Classroom. These repositories are initialized with the necessary starting environment (such as Visual Studio solutions). Each student must clone their dedicated repository, commit their changes, and push the completed solution before the deadline so that it is available on GitHub. The specific steps will be detailed shortly.

## Visual Studio and Git

Git is a distributed version control system. To use it on a local computer, Git must be installed. There are two ways to use Git:

- Git can be installed as a standalone tool, and commands like `clone`, `commit`, and `push` can be executed via the command line.
- A graphical interface tool can be used for executing these commands. Examples include GitHub Desktop, GitExtensions, or Visual Studio (which provides integrated graphical Git support).

In practice, both approaches are often combined. Cloning a repository is often quickest via the command line, while committing changes, synchronizing with the central repository (push, pull), and viewing version history are easier with a graphical tool, especially for beginners. In this course, cloning is recommended via the command line or Visual Studio, while other commands should be executed using Visual Studio. More information on using Git in the context of assignments can be found [here](../hf-folyamat/index_eng.md).

## Installing Git

If Git is not yet installed on your computer and you want to use it from the command line, you can download it for Windows from: https://git-scm.com/download/win. For other operating systems, visit: https://git-scm.com/downloads.

!!! warning "Installing Git Credential Manager"
    GitHub no longer supports simple username/password authentication. If you receive the error message "Support for password authentication was removed" when logging in via the command line, this is the reason. There are two ways to resolve this issue:
    
    * The simplest solution is to install "Git Credential Manager." It can be selected during Git installation by checking the appropriate box, or it can be installed separately from [here](https://github.com/git-ecosystem/git-credential-manager/releases). After installation, no additional configuration is needed; Git will automatically use it and guide the user through a browser-based (OAuth) authentication process, also storing credentials for convenience.
    * Alternatively, you can use a PAT (Personal Access Token). More information is available [here](https://stackoverflow.com/questions/68775869/message-support-for-password-authentication-was-removed).