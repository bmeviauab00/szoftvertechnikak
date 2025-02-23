# Homework workflow and using Git/GitHub

If you haven't read it yet, it's advisable to start here: [Git, GitHub, GitHub Classroom](../git-github-github-classroom/index_eng.md)

## Steps

The initial framework of each homework assignment is published using GitHub/GitHub Classroom. The steps for downloading and submitting the homework from this published environment are as follows:

1. :exclamation: Do not wait until the deadline approaches to start. At least get to the point of creating your repository as soon as possible. This way, if you run into any issues, we can assist you in time.
2. Register a GitHub account (<https://github.com/>) if you haven’t already, and log in to GitHub.
3. Open the link corresponding to the assignment. Each assignment will have a different link, which will be gradually announced on the subject webpage throughout the semester. The format will be similar to: <https://classroom.github.com/abcdefgh>. If you encounter an authentication error ("There was a problem authenticating with GitHub, please try again."), try copying and pasting the link directly into the browser's address bar.
4. If prompted, grant GitHub Classroom permission to use your account information.
5. You will see a page where you can accept the assignment ("Accept this assignment"). Click the button.
6. Wait for the repository to be created. GitHub does not always refresh the page automatically, so manually refreshing (e.g., pressing F5) may be necessary. Once the repository is ready, the page will display its URL, which you can click to access the repository (e.g., <https://github.com/bmeviauab00/hazi1-2024-username>). However, saving the URL is not strictly necessary, as you can always find it later among your repositories on the GitHub homepage (<https://github.com/>).
7. Clone the repository (we will discuss how to do this shortly). Inside, you will find a framework or starter code. Work on this and modify it as needed. Stay on the default Git branch (if this doesn't mean anything to you, don't worry—this note is primarily for those who are experienced in Git and usually work with multiple branches).
8. :exclamation: Do not modify, delete, or alter the content of the `.github/workflows` folder within the project.
9. :exclamation: You must work within the provided solution/project from the initial repository. Do not create a new project/solution.
10. :exclamation: Enter your *Neptun code* in the `neptun.txt` file located in the root directory of the repository. The file should contain **only these six uppercase characters** and nothing else.
11. Solve the assignment and push your changes before the deadline. Work directly on the default "Main" branch—there are no pull requests. You can have as many commits as needed; we will evaluate the latest state at the deadline.
12. Results will be announced on Aut webpage. Expect results within a few days after the submission deadline.
13. There is no need to explicitly submit the assignment separately—just make sure it is available on GitHub by the deadline.
14. :exclamation: Before considering your homework as submitted, it is advisable to check your repository on GitHub's web interface to ensure that all changes have been pushed and that the `neptun.txt` file has been properly filled out.


The following steps raise two remaining questions:

- How do we clone our repository (which contains the initial framework for the homework)?
- How do we commit and push to GitHub?

Most of these topics have already been covered in the Software Technology course. However, if you don’t remember all the details or want to learn how to use these features not only from the command line but also in Visual Studio, be sure to read the following. We will briefly cover all the Git-related aspects needed to complete the homework (even for those who have never used Git before and are just starting the course).

If you encounter the error message "Support for password authentication was removed" during Git login, check the section on the Git Credential Manager at the bottom of the [Git installation guide](../git-github-github-classroom/index_eng.md#git-installation).

## Cloning a GitHub Repository

We will explore two options:

- Cloning from the GitHub web interface using Visual Studio (or directly from Visual Studio)
- Cloning from the command line

### Cloning from the GitHub Web Interface in Visual Studio

There are several ways to clone a repository for a homework assignment. One option is as follows:

Open the repository’s online page. There are several ways to access it:

- When creating the repository, GitHub provides a URL—simply click on it.
- On the GitHub homepage (<https://github.com>), if logged in, your accessible repositories are listed on the left; just click on the correct one.
- When the repository is created (after accepting the GitHub Classroom assignment), you receive an email notification containing the link.

The page should look something like this (though the URL will end with your username):

![GitHub repo page](images/github-repo-page.png)

Click the green *Code* button, then select *"Open in Visual Studio"* from the dropdown menu:

![GitHub repo page - Code button](images/github-code-button-open.png)

At this point, your browser may prompt a window (e.g., in Chrome/Edge, below the address bar) where you need to click *Open…* to launch Visual Studio. If the prompt appears as *"Microsoft Visual Studio Web Protocol Handler Selector"*, allow it. Additionally, you may want to check the box saying "Always allow github.com to open links ...".

If everything goes well, Visual Studio will start and display a window with the "Repository location" field pre-filled with your repository’s URL. Specify where you want to clone the repository on your system, then click *Clone*:

![Repository clone in Visual Studio](images/vs-clone-a-repository.png)

#### Alternative Cloning in Visual Studio

If *"Open in Visual Studio"* or *"Microsoft Visual Studio Web Protocol Handler Selector"* does not work in the browser, you can start directly from Visual Studio. Simply launch Visual Studio, and in the startup window, click *"Clone Repository"* (or, if the startup window is skipped, select *"Git/Clone Repository"* from the main menu). Enter your repository’s URL and click *Clone*.

Once cloned, you can check the created folders and files in Windows Explorer:

![Git repository in the file system](images/git-folder-in-explorer.png)

From this, it is clear that a Git repository is nothing more than a collection of folders and files, along with a .git folder located in the root directory, which (in simple terms) contains the version history of individual files. To start working, you only need to open the .sln solution file associated with the given homework assignment (e.g., by double-clicking it in Windows Explorer).

!!!note "The first homework assignment is special (it contains two solutions)!"
    The first homework assignment consists of two main parts, each with a different solution file. For the first part, open the MusicApp.sln file located in the Feladat1 folder, and for the second part, open the Shapes.sln file in the Feladat2 folder. You can open these files by double-clicking the respective .sln file in Windows Explorer. However, there is an alternative method: If you have opened the Git root folder in Visual Studio (which is the case right after cloning), you can click the "Switch View" button in the Solution Explorer header. This will list all solutions under the Git root folder, and you can open any of them by double-clicking it.

    ![Visual Studio Solution Explorer Switch View](images/vs-switch-view.png)

### Cloning from the Command Line

Another option is using the command line. Navigate to the folder where you want to clone the repository and run:

`git clone <repo url>`

where `<repo url>` is your repository's URL (copied from the browser, e.g., `https://github.com/bmeviauab00/hazi1-2024-myusername`). After running the command, the repository will be cloned into a folder named after the repository.

!!! note "Command-line Git"
    Don't be afraid to use Git in the command line—cloning a repository this way is actually the simplest method.

    If you encounter an error stating that the git command is not recognized, it is likely because Git has not been installed on your system yet. You can find more details about installing Git [here](../git-github-github-classroom/index.md#git-telepitese).


## Daily Git Workflow in Visual Studio (Commit, Push)

After cloning the GitHub repository for the assignment to our computer, a local Git repository is created. Opening the `.sln` files in Visual Studio, we work with them as usual—adding, modifying, and deleting files—just as if they were not part of a Git repository. However, before submitting the assignment, we must commit our changes and push them to GitHub. We can commit and push our changes multiple times during the assignment, but at the deadline, the state of the repository on GitHub will be evaluated, regardless of how many commits it contains.
To perform the commit and push operations, use the commands in the **"Git"** menu in Visual Studio.

### Commit

To view the changes made since the last commit, select **"View\Git Changes"**. This will open the **"Git Changes"** panel showing the list of changes:

![VS Git changes](images/vs-git-changes.png)

To commit the changes, enter a short description (e.g., "Final solution", "Fixed xyz bug") in the text box. The available options are:

- **"Commit All"**: Commits changes locally (but does not push them to the central Git repository until a separate **Push** command is executed).
- **"Commit All and Push"**: Available from the dropdown next to the "Commit All" button. It first commits the changes and then pushes them to GitHub. **This is recommended for homework submissions, as it eliminates the need for a separate push operation.**  
  If the command results in an error **"Unable to push to the remote repository because your local branch is behind the remote branch"**, perform a pull first, then retry the push.
- **"Commit All and Sync"**: Also available from the dropdown. This commits, then pulls any changes from the remote repository before pushing. It ensures that local changes are merged with any modifications in the central repository.

!!! note
    A commit must always be preceded by a **stage** step, where we select which changes to include in the commit. This places selected changes in the **staging area** (without physically moving files). This approach provides flexibility, allowing us to exclude certain modifications from a commit if necessary. The "Commit All" commands automatically stage all changes before committing.

### Push, Pull

The commit operation only applies changes locally. To update the GitHub repository, use the **Push** operation. This step is necessary only if "Commit All and Push" or "Commit All and Sync" were not used earlier. The push command can be executed from the **Git/Push** menu in Visual Studio.

If working collaboratively, there might be remote changes that have not yet been downloaded. Use **Pull** from the **Git/Pull** menu to merge these updates into the local repository. However, for individual homework assignments, this is usually unnecessary.

!!! note
    A push can only be performed if there are no unmerged remote changes. If there are, an error message such as **"Unable to push to the remote repository because your local branch is behind the remote branch"** will appear. In this case, perform a **Pull**, then retry the push.

!!! note
    A pull operation can only proceed if there are no uncommitted local changes. If necessary, commit or temporarily store changes before pulling.

!!! tip
    The **Pull** and **Push** commands can also be accessed via the **Git Changes** panel:

    ![VS pull push](images/vs-git-changes-push-pull.png)

### Git History

Git tracks all changes in the repository as **commits**. Each commit has a unique identifier (commit hash), a timestamp, and an author. To view the commit history, use **View/Git Repository** in Visual Studio. The commit history can also be viewed on GitHub.

- **Outgoing commits**: Shows locally committed changes that have not yet been pushed to the remote repository.  
- **Incoming commits**: Shows remote changes that have been fetched but not yet merged. Use **Pull** to merge them.

Example:

![VS git history](images/vs-git-history.png)

!!! tip
    If you are new to Visual Studio’s Git integration, after pushing changes (especially before submitting an assignment), verify that all updates appear in the GitHub repository.

### Additional Guidelines

Git does not include intermediate and output files (such as `.dll` and `.exe`) in commits. These files are generated during the build process and do not need to be version-controlled. Git determines which files to ignore using the **`.gitignore`** file, which lists file types and directories that should not be committed. Each assignment repository includes a pre-configured `.gitignore` file—**do not modify its contents**. This ensures that unnecessary files are not uploaded to GitHub.

Throughout the semester, each class, interface, etc., should be placed in its own file, meaning that a **C# source file should contain only one class, interface, or other definition**.

#### Using Git in the Command Line

Even if you're not used to it, using Git in the command line can often be faster than navigating through GUI menus. Here’s a simple workflow:

1. Clone the repository (only needed once):
   `git clone https://github.com/bmeviauab00/hazi1-2022-myusername`

2. Make changes in your local repository.

3. View changes (optional, just to check modifications):
   `git status`

4. Stage all changes:
   `git add -A`

5. Commit changes:
   `git commit -m "Commit message"`

6. Push changes to GitHub:
   `git push`

Notes:


- If multiple people are working on the same Git branch, before step 6 (push), a `git pull` may be necessary to incorporate changes made by others into your local repository (without this, you won't be able to push). It may be useful to add the `--rebase` option to the pull command to avoid creating an additional merge commit, but we won’t go into the explanation here.

- As mentioned earlier, every commit is associated with a username and an email address. If these are not configured in Git, an error message will appear when committing. You can set them in Git’s global configuration using the following commands (you only need to do this once, replacing the placeholders with your actual information):

    ```
    git config --global user.email "you@example.com"
    git config --global user.name "myusername"
    ```

- In the Windows command prompt, multiple commands can be combined into a single line. For example, to stage, commit, and push all changes in one step:

    `git add -A & git commit -m "All tests run" & git push`

    If using PowerShell, replace `&` with `;` as the separator.

