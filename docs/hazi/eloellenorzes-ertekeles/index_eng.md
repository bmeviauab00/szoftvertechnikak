# Homework pre-check and official evaluation

Each time you push code to GitHub, an automatic pre-check runs on the uploaded code, and you can view the output! The verification is executed by GitHub itself. After pushing, the task enters a queue and, after a certain time, the verification tests run. The exact waiting time is unknown and depends on GitHub. When only a few tasks are in the queue, verification typically starts within 1-2 minutes. However, if many students start uploading solutions simultaneously, the process may slow down. Therefore, it is advisable not to leave submission to the last minute, as delays might prevent you from receiving feedback in time.

:exclamation: **Officially, the state of the task at the deadline on GitHub will be evaluated.** The official evaluation is conducted in the instructor's environment and published on Aut webpage. This means that for the official result, it does not matter whether any pre-checks have already run before the deadline or if they started only later. The GitHub pre-check is solely intended to provide feedback before the deadline. The official post-deadline evaluation includes additional steps beyond GitHub's pre-check, making the pre-check partial, though it can still help catch many issues.

:exclamation: **Please do not push in small increments—only upload the completed, reviewed, and compilable solution!** The reason is that GitHub provides limited time for running verification tests; if the monthly quota runs out, you will not receive any feedback except for the official post-deadline evaluation.

The (semi-)automated pre-check is still a partially experimental project. If you find inconsistencies in the guide or encounter a situation that the checker does not handle and unjustifiably complains about, please report it to (Benedek Zoltán)[https://www.aut.bme.hu/staff/bzolka]! However, we may not be able to handle such reports in large volumes. If your solution is correct but the pre-check falsely reports an issue, the official evaluation will accept it.

Especially for the first homework, the pre-check messages may be quite "machine-like" in wording. If you cannot understand them, message Benedek Zoltán on Teams with the error message and **a link to your GitHub repository :exclamation:** (otherwise, we cannot find your code).

The depth of verification performed by the pre-check depends on the homework task. For tasks 1-3, it is quite thorough, while for tasks 4-5, it only checks if the Neptun.txt file is filled out and whether there are compilation errors (the substantive evaluation happens later).

### Viewing GitHub's verification results

1. Navigate to the repository on GitHub.
2. Switch to the *Actions* tab.
3. A table appears showing a row for each verification triggered by a push, with the latest at the top. The icon at the beginning of each row indicates the status: pending, running, successful, or failed. The row text shows the Git commit name.
4. Clicking on a row’s commit name opens an overview page of the verification process. This page does not contain much information. On the left side of this page, click on the *"build"* or *"build-and-check"* (or similar) link, which navigates to the detailed verification view. This is a "live" view, updating continuously while tests run. When completed, expand the nodes to review the output of each step. If everything is successful, you should see a view like this:

    ![GitHub actions output](images/eloellenorzo-github-actions.png)

5. The most crucial step here is *"Run tests"*.  
   If a step fails, a red X appears instead of a checkmark, and expanding the node reveals the test output with details about the failure. For the first homework, it is useful to search (Ctrl+F) for "Error Message" or "Assert" in the output, as these usually indicate the cause of the failure.
