---
authors: BenceKovari,bzolka
---

# 4th Homework – Developing multithreaded applications

## Introduction

This independent homework builds upon the content covered in the lectures on concurrent/multithreaded application development.
Its practical background is based on the lab session: [Lab 4 – Developing multithreaded applications](../../labor/4-tobbszalu/index_eng.md).

With this foundation, the tasks in this assignment can be completed using the short guidelines following each task description. The purpose of this homework is to deepen your understanding of the following concepts:

- Starting and stopping threads, thread functions
- Signaling and waiting for signals (`ManualResetEvent`, `AutoResetEvent`)
- Mutual exclusion using `lock`
- Accessing WinUI UI elements from worker threads
- Practicing the use of delegates (`Action<T>`)
- Practicing UI design: using timers, manipulating UI elements from code-behind (not directly related to threading)

The required development environment is the usual one, described [here](../fejlesztokornyezet/index_eng.md) — including the required Windows App SDK.

!!! warning "Checker Information"
    There is no functional automatic pre-checker for this homework: although a check runs after each push, it only verifies that neptun.txt is filled out and that there are no compile errors. The actual evaluation will be carried out by the lab instructors after the deadline.

## Submission process

- The process is similar to previous homework assignments. Use GitHub Classroom to create your repository. The invitation link is available on Teams and Aut portal on the course homepage. Make sure to use the correct invitation link for this specific assignment (each homework has a different URL). Clone the repository that is created — it will contain the expected structure for your solution. After completing the tasks, commit and push your work.
- Fill in your Neptun code in the neptun.txt file!
- Open and work in the provided `MultiThreadedApp.sln` file from the cloned folder.
- :exclamation: Some tasks require you to submit **screenshots** showing parts of your solution. These screenshots serve as proof that the work is your own. **The exact content expected in each screenshot is described in the task instructions.** Screenshots must be included in your submission and placed in the root folder of your repository (next to neptun.txt). These will be uploaded to GitHub along with the rest of the repository. Since your repository is private, only instructors will have access to it. If a screenshot contains any information you do not wish to share, you may blur or redact that part before uploading.

Task 0 – Overview of the starter solution

In this assignment, you'll be developing an application that simulates a bicycle race. A core design principle of the implementation is **the separation of application logic and UI**: The application logic must not depend on the UI in any way. The UI, naturally, does depend on the application logic, as it reflects its current state.

The provided starter solution already includes some logic related to both the application and the UI. Let’s run the application and take a look at its interface:

![Initial UI](images/app-ui.png)

-The top section of the window displays the race track. On the left, bicycles are lined up. The start line, a mid-race checkpoint (depot), and the finish line are shown further to the right. 
- The bottom section contains buttons for controlling the race. These buttons are not yet functional, but the following behavior will be implemented:
    - `Prepare Race`: Prepares the race by creating bicycle objects and lining them up at the start line.
    - `Start Race`: Starts the race, causing bicycles to compete and advance toward the depot, where they will wait.
    - `Start Next Bike From Depot`: Releases one bicycle from the depot toward the finish line. This button can be pressed multiple times—each press allows one more bicycle to continue.

The following animation illustrates what the final working simulation should look like:

![Target UI](images/app-ui-anim.gif)

Simulation mechanics work as folloes (not yet implemented):
- Each bicycle will be associated with its own separate thread.
- The race simulation is structured into iterations: in each iteration, a thread (if not waiting at the starting gate or in the depot) will advance its bicycle forward by a random value. This continues until the bicycle reaches the finish line.

You can toggle between light and dark themes using the keyboard shortcut ++Ctrl+T++. This function is already implemented.

### Application logic

In the starter framework, the **application logic** classes are only partially implemented. These classes are located in the `AppLogic` folder/namespace. Here's an overview of their structure and current functionality:

- `Bike`: Represents a single bicycle in the race, with the following properties: start number, current position on the track, an a flag that indicates whether this bike won the race. The `Step` method is implemented to step the bike by a random distance during the race.
- `Game`: Handles the core logic for controlling the game (this could be split into smaller parts, but for simplicity, we will primarily work in this class).
    - Constants defining the positions of the race track elements: `StartLinePosition`,  `DepoPosition`, `FinishLinePosition`
    - A list of bicycles in the race: `Bikes`
    - `PrepareRace` method: Prepares the race by creating the bikes. Currently uses a helper method CreateBike() to create 3 bikes. This method will also be responsible for lining the bikes up at the start line.
    - `StartBikes` method: Not yet implemented. Starts the race. Each bike thread competes to reach the depot, where they will then wait.
    - `StartNextBikeFromDepo`: Not yet implemented. Starts one bike from the depot toward the finish line. Only a single bike is started per button click.

### Display

The **UI layer** in the starter project is already well-prepared, though you’ll still be making adjustments and enhancements.

The UI is defined in `MainWindow.xaml`, following these key principles:

- The main layout uses a standard `Grid` with two rows. The first row (with `*` height) contains the race track and bikes. The second row (with `Auto` height) contains a `StackPanel` holding the control buttons.
- The race track is composed of `Rectangle` objects (background, start line, depot, finish line), and text labels use `TextBlock` elements — some of which are rotated.
- All bicycles are placed inside a vertical `StackPanel`, with each bike represented by a `TextBlock` (Font: `Webdings`, character: `b`). (A FontIcon could have been used, but TextBlock was chosen for simplicity and familiarity.)
- All UI elements (track and bikes container) are positioned in row 0 of the Grid. Drawing order follows the declaration order in XAML. Elements are positioned using alignment and margins. The bike positions will be updated by setting the left margin on each `TextBlock`. An alternative layout approach would have been to use a `Canvas`, positioning elements using Left, Top, Width, and Height — but the current solution uses margin-based layout.

Check the MainWindow.cs code-behind file as well. Key members and methods:

- `game` field: A reference to the Game object, which holds the simulation state.
- `bikeTextBlocks` field: A list for storing the `TextBlock` objects representing the bikes. Initially empty — you will manage this list as part of the implementation.
- Constructor: Sets the X positions of the start line, depot, and finish line using constants from the Game class. This is done by adjusting the left margin (`Margin`) of each rectangle (since the elements are left-aligned within their container). Registers the ++Ctrl+t++ keyboard shortcut via the `AddKeyboardAcceleratorToChangeTheme()` helper method to toggle between light and dark themes.
- `PrepareRaceButton_Click`, 
`StartRaceButton_Click`, 
`StartNextFromDepoButton_Click`:  these are wired to the respective control buttons in the UI.
- `UpdateUI` method: This method is crucial: it updates the UI based on the current state of the game. Iterates through all bikes and updates the TextBlock positions based on the bikes’ Position values. This is done by adjusting the left margin of each bike's `TextBlock`. This method is not yet called anywhere, so the UI currently does not update during the simulation — you'll need to invoke this method later to reflect changes on screen.

## Task 1 – Updating the UI

Right now, even if the game state changes during execution, the UI doesn't reflect it. The three bicycles are hardcoded in `MainWindow.xaml`, and the `UpdateUI()` method is never called. Before implementing the game logic, let’s modify the UI logic so it can dynamically reflect the game's current state.

### Dynamically handling any number of bicycles

Currently, the XAML has three hardcoded `TextBlock` elements for bikes. This only allows three racers, which is limiting. Let’s refactor the UI to support any number of bicycles. As a first step, remove the three hardcoded TextBlock definitions for the bicycles from `MainWindow.xaml` (comment out the three lines). After that, in the code-behind file, in the `PrepareRaceButton_Click` event handler, after preparing the race (the `game.PrepareRace()` call):

1. Dynamically create a corresponding `TextBlock` object for each bicycle in the game object (`game.Bikes` property). The properties of the created TextBlock should exactly match those that were removed from the XAML file (`FontFamily`, `FontSize`, `Margin`, `Text`).
2. Add the created `TextBlock` objects as children of the `StackPanel` named `bikesPanel` (the `TextBlock`s you commented out in the XAML were also children of this panel — check this!). Use `bikesPanel.Children.Add` to add them.
3. Also add the created `TextBlock` objects to the `bikeTextBlocks` list. This is important — as seen in the code — because the `UpdateUI` method uses the `bikeTextBlocks` list to locate the `TextBlock` corresponding to each bike (it matches them by array index).

The application's behavior will change slightly (this is intentional): no bicycles will appear at startup — they will only be displayed after clicking the `Prepare Race` button.

Try to implement the solution yourself by following the steps above, then verify that your implementation generally matches the solution described.

??? tip "Solution"

    ```csharp
    foreach (var bike in game.Bikes)
    {
        var bikeTextBlock = new TextBlock()
        {
            Text = "b",
            FontFamily = new FontFamily("Webdings"),
            FontSize = 64,
            Margin = new Thickness(10, 0, 0, 0)
        };

        bikesPanel.Children.Add(bikeTextBlock);
        bikeTextBlocks.Add(bikeTextBlock);
    }
    ```

### Implementing UI refresh


Now we have exactly as many `TextBlock` elements as there are bikes in the game object.
And we can refresh the display at any time using the `UpdateUI` method — to reflect the current state of `game`. The key question now is: when should we call this function? In other words, when should we update the UI? There are several possible strategies:

- a) Every time the `Game` state changes.
- b) At regular intervals (e.g., every 100 ms), using a timer to update the UI "continuously."

Both approaches have their pros and cons. Option b) is often simpler — you don’t need to track exactly when the `Game` state changes. However, it may trigger unnecessary updates if nothing changed. On the other hand, it's more efficient in cases where changes are frequent — we don’t need to refresh the UI for every little update; just refresh periodically, which is good enough visually. For simplicity, we'll go with option b) — periodic updates using a timer.

In WinUI 3, for handling periodic events (especially when UI elements need to be accessed from the timer), it is recommended to use the `DispatcherTimer` class.

Add a field to `MainWindow`:

```csharp
    private DispatcherTimer timer;
```

Next, in the constructor of MainWindow, instantiate the timer, assign an event handler to its `Tick` event (this will be called periodically), set the interval to 100 milliseconds using the `Interval` property, and start the timer:

```csharp
public MainWindow()
{
    ...

    timer = new DispatcherTimer();
    timer.Tick += Timer_Tick;
    timer.Interval = TimeSpan.FromMilliseconds(100);
    timer.Start();
}

private void Timer_Tick(object sender, object e)
{
    UpdateUI();
}
```
 
 As you can see, the UI is refreshed in the timer’s event handler by calling `UpdateUI`.

The question is: how can we test whether our solution is working correctly — specifically, whether the `Timer_Tick` event handler is actually being called every 100 ms? To verify this, temporarily trace the current time (formatted appropriately) to the Visual Studio Output window from within the event handler:

```csharp
private void Timer_Tick(object sender, object e)
{
    System.Diagnostics.Trace.WriteLine($"Time: {DateTime.Now.ToString("hh:mm:ss.fff")}");

    UpdateUI();
}
```

The `Trace.WriteLine` method writes a line to the Visual Studio Output window, and `DateTime.Now` is used to get the current time. We format it into a readable string using the `ToString` method. Run the application (make sure to run it in debug mode, i.e. by pressing ++F5++), and check the Visual Studio Output window to confirm that a new line appears every 100 ms.
If everything works correctly, comment out the trace line.

!!! note "Precision of DispatcherTimer" 
    You may observe that the `DispatcherTimer` is not particularly precise, but it is perfectly suitable for our needs. One important characteristic is that it runs on the UI thread (its `Tick` event is raised there), which means we can access and modify UI elements directly from within the handler (`Timer_Tick`).

### Main window header

:exclamation: The title of the main window must be "Tour de France - [YOUR NEPTUN CODE]". For example, if your Neptun code is ABCDEF, the full title should be: Tour de France - ABCDEF. To do this, set the `Title` property in the `MainWindow.xaml` file to that string.

## Task 2 – Preparing the race

Now that the display logic is complete, we shift our focus to application logic and thread management. From here on, we will primarily work in the `Game` class.

Reminder:

- Each bicycle will have its own separate thread.
- The game/simulation runs in iterations: in each iteration, the thread: step the bike by a random distance (if not waiting at start or in depot), an continues until it reaches the finish line.

Steps to implement:

1. At the end of the `CreateBike` method in the `Game` class, start a new thread for the newly created bike.
2. The thread function should be defined in the `Game` class.
3. The `CreateBike` method should pass the bike object as a parameter to the thread function — this is the bike the thread will control.
4. Ensure that threads do not prevent the application from closing. This means threads must be marked as background threads, so they don’t block the process from exiting when the window is closed.
5. The thread function, for now, should implement the following loop:

    In each iteration:

        - Move the bike using a random step by calling its `Step()` method.
        - Sleep the thread for 100 milliseconds.

    This motion should continue until the bike reaches the start line, i.e., its position is equal to or greater than `StartLinePosition`.

Try to implement the above steps on your own based on what you learned in the lectures and lab sessions. You can test your solution using the debugger, or simply by running the application and clicking the `Prepare Race` button: if everything is working correctly, the bikes should gradually roll forward until they reach the start line.

We will provide a solution for these steps as well,
but you will learn much more if you try to solve it yourself first — use the provided solution only for verification purposes.

??? tip "Solution"
    The thread method in the `Game` class:

    ```csharp
    void BikeThreadFunction(object bikeAsObject)
    {
        Bike bike = (Bike)bikeAsObject;
        while (bike.Position <= StartLinePosition)
        {
            bike.Step();

            Thread.Sleep(100);
        }
    }
    ```

    As you can see, for the thread function, we used the overload that takes an object parameter, not the parameterless version. This is because the thread function needs to receive the bike instance it will control.

    Starting the thread at the end of the `CreateBike` method:

    ```csharp
    private void CreateBike()
    {
        ...

        var thread = new Thread(BikeThreadFunction);
        thread.IsBackground = true; // The thread must not block exiting the process
        thread.Start(bike); // Giving the bike object as a parameter
    }
    ```

!!! example "TO BE SUBMITTED"
    Before moving on to the next task, you need to take a screenshot.

    Create a screenshot named `Task1.png` with the following setup:

    - Start the application. If necessary, resize the window so it doesn’t take up too much space on the screen.
    - In the background, Visual Studio should be open with `Game.cs` visible.
    - In Visual Studio, zoom so that both the `CreateBike` and `BikeThreadFunction` methods of the `Game` class are visible. In the foreground, your application window should be shown.

## Task 2 – Starting the race

Implement the race start from the start line and let it run until the bikes reach the depot, following these guidelines:

- The race should be started by the `StartBikes` method in the `Game` class, which is already called when the `Start Race` button is clicked.
- It is important that `StartBikes` does not start new threads. Instead, existing threads should be waiting, and they should resume execution as a result of the `StartBikes` method being called.
- If the user clicks the `Start Race` button before the bikes have reached the start line, the bikes do not need to stop at the start line anymore (but it is also acceptable if the application simply ignores the button press in such a case).
- The bikes should move all the way to the depot (until their position reaches the value defined by the `DepoPosition` field).
- Make your changes in the `Game` class.

!!! tip "Hint for the solution" 
    Since all racers should start at the same time after waiting, it is recommended to use a `ManualResetEvent` object to handle the wait and starting mechanism.

!!! example "TO BE SUBMITTED"
    Before moving on to the next task, you need to take a screenshot.

    Create a screenshot named `Task2.png` with the following setup:

    - Start the application. If necessary, resize the window so it doesn’t take up too much space on the screen.
    - In the background, Visual Studio should be open with `Game.cs` visible.
    - In Visual Studio, zoom so that the `BikeThreadFunction` method of the `Game` class is visible. In the foreground, your application window should be shown.

## Task 3 – Releasing racers from the depot

Implement the logic for releasing racers from the depot and allowing them to race to the finish line, following these guidelines:

- Each racer should be released from the depot by the `StartNextBikeFromDepo` method in the `Game` class, which is already called when the `Start Next Bike From Depo` button is clicked.
- Each button click should allow only one racer to leave the depot.
- It is important that `StartNextBikeFromDepo` does not create new threads. Instead, existing threads should wait, and resume execution as a result of calling `StartNextBikeFromDepo`.
- If the user clicks the `Start Next Bike From Depo` button before any bikes have reached the depot, then a bike may continue as soon as it arrives (but it's also perfectly acceptable if the app simply ignores the button click in such cases).
- The bikes should move all the way to the finish line (until their position reaches the value defined by `FinishLinePosition`). Once a bike reaches the finish line, its associated thread should terminate.
- Make your changes in the `Game` class.

!!! tip "Hint for the solution" 
    The solution is similar to the previous task, but this time, instead of using a `ManualResetEvent`, you should use a different (but similar) type of synchronization object...

!!! example "TO BE SUBMITTED" 
    Before moving on to the next task, you need to take a screenshot.
    
    Create a screenshot named `Task3.png` with the following setup:
    
    - Start the application. If necessary, resize the window so it doesn’t take up too much space on the screen.
    - In the background, Visual Studio should be open with `Game.cs` visible.
    - In Visual Studio, zoom so that the `BikeThreadFunction` method of the `Game` class is visible. In the foreground, your application window should be shown.

## Task 4 – Implementing the winning bicycle

Implement the logic for determining and displaying the winning bicycle according to the following guidelines:

- The winner is the first bike to reach the finish line (its position first reaches the value defined by the `FinishLinePosition` field).
- In your solution, use the fact that the `Bike` class already contains a `isWinner` field, which is initially false. It can be set to true using the `SetAsWinner` method, and its value can be queried using the `IsWinner` property.
- The decision as to whether a bike is the winner should be made within the thread function associated with that bike in the `Game` class — place the winner selection logic there.
- :exclamation: It is critical that only one winner exists.
If more than one bike is marked as the winner (i.e., `SetAsWinner` is called for multiple bikes), this is a serious error.
- Work in the `Game` class.

Before implementing the logic, we’ll improve the display slightly to make the winning bike visually distinct.
In the `UpdateUI` method of the `MainWindow` class, add a small extra logic: If the given bike is a winner, change its display to a trophy icon. To do this, set the Text property of the corresponding `TextBlock` to "%":

```csharp
private void UpdateUI()
{
    for (int i = 0; i < game.Bikes.Count;i++)
    {
        ...

        if (bike.IsWinner)
            tbBike.Text = "%";
    }
}
```

Implement the logic yourself based on the following guidelines and tips.

!!! tip "Guidelines and tips for the solution"

    - To determine whether a winner has already been declared, add a helper variable `bool hasWinner` in the `Game` class (this should indicate whether a winner has already been assigned).
    - A very similar example was shown during the lecture in the topic "Using lock", with a detailed explanation.
    - Your solution must still function correctly — meaning only one winner — even if a long artificial delay is introduced between checking `hasWinner` and setting it to true. This simulates a scenario where the thread unluckily loses execution time right at that point, and bikes are released from the depot almost simultaneously, reaching the finish line close together.
    - For testing, insert a line like `Thread.Sleep(2000)` between the check and the assignment to `hasWinner`. After testing, comment this line out. During testing, release bikes from the depot as close to each other as possible (e.g., rapid button clicks) so they arrive at the finish nearly at the same time. If more than one bike becomes a winner (i.e., turns into a trophy), then your solution is incorrect and not properly synchronized.

!!! example "TO BE SUBMITTED" 
    Before moving on to the next task, you need to take a screenshot.

    Create a screenshot named `Task4.png` with the following setup:

    - Start the application. If necessary, resize the window so it doesn’t take up too much space on the screen.
    - In the background, Visual Studio should be open with `Game.cs` visible.
    - In Visual Studio, zoom so that the `BikeThreadFunction` method of the `Game` class is visible. 
    - In the foreground, your application window should be shown.

## Task 5 – Mutual exclusion and volatile

In the previous task, we saw that checking and setting `hasWinner` needed to be made atomic, meaning we had to ensure mutual exclusion during this process. Now, the question is: are there any other parts of the application where mutual exclusion should have been applied to maintain consistency? To answer this, we need to examine which variables are accessed from multiple threads (i.e., written by one and read by another). The following variables are involved:

- The `position` field in the `Bike` class. This is modified by the bike’s thread using the `+=` operator, and read by the main thread via the `Position` property during rendering. The question is: could this cause any inconsistency?
Reading and writing int variables with the `=` operator is atomic — so that would be fine. However, the `+=` operator is not atomic — it consists of multiple steps: read, increment, write. (If it’s unclear why this is a problem, be sure to review the lecture slides on this topic.) If multiple threads used `+=` on the same variable at the same time, that could cause inconsistency. But let’s think carefully: in our case, only one thread at a time uses `+=`, and the other thread only reads position. This means the reading thread may get either the before or after value of the increment, but that's acceptable. Conclusion: No need to implement mutual exclusion here.
- The `isWinner` field in the `Bike` class: It is set by the bike’s thread using `SetAsWinner`, and read by the main thread using the `IsWinner` property during rendering. Its type is `bool`, and reading/writing a bool is atomic, so no need for mutual exclusion.
- The `hasWinner` field in the `Game` class: Also a bool, so its read/write operations are atomic. However, we had an additional requirement: only one bike can win. Because of that, mutual exclusion was necessary, and we implemented it in the previous task using lock.

You might now think all is fine — but it's not case. **Even when atomicity is guaranteed, a thread may not see the updated value of a shared variable due to caching (e.g., in a CPU register).
This means a thread might still see an old value even after the variable has been changed by another thread.** To prevent this, such shared variables should be marked as `volatile`. This keyword ensures the variable is always read from and written to main memory, not a cached copy. (The behavior of volatile is a bit more complex, and it's explained in more detail in the lectures.)
Important Note: there is no need to use `volatile` if the variable is only accessed within `lock` blocks or if it's modified via the `Interlocked` class. Therefore, mark the following fields as volatile: `position` and `isWinner`.

```csharp
class Bike
{
    private volatile int position = 65;
    private volatile bool isWinner;
```

## Task 5 – Step logging (non-thread-safe .NET collections)

Implement logging of every single step taken by the bikes during the race. In the `Game` class, store these steps in a single shared `List<int>` variable (common for all bikes).
You don't need to do anything with the logged values (e.g., no need to display them). Use the fact that the `Step` method in the `Bike` class returns the step size as an int — this is the value that should be logged (just add it to the list).

??? tip "Hint for the solution" 
    The `List<T>` class is not thread-safe, and since it will be written to from multiple threads, you must ensure mutual exclusion when accessing it. Use the `lock` statement to safely add to the list.

!!! Note "Thread-safe collections in System.Collections.Concurrent" 
    If you used a suitable collection from the `System.Collections.Concurrent` namespace (e.g., `ConcurrentQueue` instead of `List<T>`), then explicit locking would not be necessary. This namespace contains collection types designed to be thread-safe.

## Task 6 – Refreshing the UI on every change (Accessing UI elements from worker threads)

In the current implementation, the UI is refreshed periodically at fixed intervals using a timer. Now, we will replace this solution. Refactor your implementation so that the UI is updated immediately whenever the state of the `Game` changes. The timer-based updates should no longer be used.

The next section will present an overview of possible solutions and select one of them. But before reading on, try to think about it yourself — what kind of approach would be most appropriate here? A key requirement is that no solution is acceptable if it introduces a dependency from the application logic (`Game` class) to the UI. Remember our core principle: the application logic must not depend in any way on the presentation logic (the UI).

### Implementing UI notification

Alternatives:

1. We could apply the Observer design pattern. This will be covered later in the semester, although it's worth noting that C# events are based on the core concepts of the Observer pattern.
2. A straightforward solution would be to introduce a C# event (e.g., `BikeStateChanged`), raised by the Game class whenever a bike’s state changes, passing the Bike object as a parameter. This would be a clean, general-purpose solution: any class could subscribe to the event at any time. Following Microsoft’s recommendations, this would require defining a custom `EventArgs` subclass and a new delegate type (or using the built-in `EventHandler<TEventArgs>` generic delegate).
3. While the C# event-based approach in the previous paragraph is fully "correct", our needs are more specific — we don’t necessarily want arbitrary classes to subscribe to the event. Therefore, we’ll implement a more targeted solution (and this is the approach we'll use). This approach still uses a delegate, but it does not introduce a C# event, and is designed to notify only a single object — the `MainWindow`, which is responsible for updating the UI whenever a bike’s state changes. This approach consists of the following components:

    - `Game` class as the "notifier":
        - The function (delegate object) that the `Game` class will invoke when a bike’s state changes is passed to it as a parameter to the `PrepareRace` method. The `Game` class stores it in a member variable.
        - This parameter and field should be of type `Action<Bike>` (we’ve already learned about `Action` and `Action<T>`).
        - Whenever a bike’s state changes (position or winner status inside the thread function), the `Game` class invokes the stored delegate — but only if it is not null (use `?.Invoke`) — passing the updated Bike object as a parameter. This is how it notifies the subscriber.
    - `MainWindow` as the "subscriber":
        - In the `MainWindow` class, implement a method called `UpdateBikeUI(Bike bike)`, and pass this method as a delegate when calling `Game.PrepareRace`. In `UpdateBikeUI`, make sure the `TextBlock` corresponding to the given bike object is updated accordingly.
        - This is why we use an `Action<Bike>` delegate rather than just `Action`: it allows the Game to specify which bike changed, so that `MainWindow.UpdateBikeUI` can update only that bike’s display.
    - Comment out the timer startup (`timer.Start()` in the `MainWindow` constructor) — because now UI updates are handled using the delegate-based notification (`Action<Bike>`), and we no longer need periodic updates.

Implement the notification mechanism described in point 3 above!
Below, we'll provide the implementation of `MainWindow.UpdateBikeUI`, which updates the `TextBlock` display for the given `Bike` object:

```csharp
private void UpdateBikeUI(Bike bike)
{
    // It may happen that UpdateBikeUI is called so early that
    // bikeTextBlocks has not yet been populated — in that case,
    // we can’t update the UI yet, so just return.
    if (bikeTextBlocks.Count != game.Bikes.Count)
        return;

    int marginAdjustmentForWheel = 8;

    // Find the TextBlock corresponding to the bike (by using the same index).
    var tbBike = bikeTextBlocks[game.Bikes.IndexOf(bike)];
    
    // Do not set the bike's position yet if its size has not been
    // determined by the layout system (otherwise the bike would "jump,"
    // since in the margin calculation below, we'd use an invalid width of 0).
    if (tbBike.ActualWidth == 0)
        return;

    // The window’s (0,0) point is the origin — positions like start/depot/finish are
    // measured relative to this.  
    // The right side of the icon is the wheel, but we want to align that with the left edge,
    // so we need to subtract ActualWidth.
    tbBike.Margin = new Thickness(bike.Position - tbBike.ActualWidth + marginAdjustmentForWheel, 0, 0, 0);

    if (bike.IsWinner)
        tbBike.Text = "%"; // display a cup
}
```

!!! danger "Important"
    Even if you follow the above steps/principles correctly, your solution may still not work as expected. When starting the race, the following exception may be thrown in the `UpdateBikeUI` method when accessing the `TextBlock` associated with the bike: `System.Runtime.InteropServices.COMException: 'The application called an interface that was marshalled for a different thread. (0x8001010E (RPC_E_WRONG_THREAD))'`

What is the reason for this error? Before opening the reminder below, try to figure it out yourself based on what you've learned in lectures/labs.

??? tip "Reminder"
    **In WinUI, you may only access a UI element/control from the same thread that created it — UI elements are not thread-safe, and they will throw exceptions if you attempt to access them "incorrectly" from another thread.**

The solution will be developed in the next subtask.

### Using the DispatcherQueue

In our case, the specific issue is caused by the fact that when the Game's state changes, the notification delegate in the `Game` class is called from the worker threads associated with the bikes. As a result, the registered handler `MainWindow.UpdateBikeUI` is also called from these worker threads. However, inside `UpdateBikeUI`, we access UI elements (such as the `TextBlock` representing a bike), which were created on the main (UI) thread — and therefore should only be accessed from the main thread.

:exclamation: The solution is to use the `DispatcherQueue`, **which allows us to "forward" a method call from a background thread to the main UI thread, where UI elements can safely be accessed.** The use of `DispatcherQueue` has been covered in detail during lectures and in the corresponding lab.

Task: Modify the `MainWindow.UpdateBikeUI` method so that UI element access is done from the correct thread using `DispatcherQueue`. This will prevent the exception you've been encountering.

!!! example "TO BE SUBMITTED" 
    Before proceeding to the next task, you must take a screenshot.

    Create a screenshot named `Task6.png` as follows:

    - Start the application. If needed, resize the window to take up less screen space.
    - In the background, Visual Studio should be open with MainWindow.xaml.cs visible.
    - Zoom in so that the `UpdateBikeUI` method of the `MainWindow` class is visible. In the foreground, the application window should be shown.

!!! warning "Implementing a similar game in real-world scenarios" 
    In practice, we would not use threads to implement a game like this. Using a timer to update bike positions would be much more practical, allowing the whole game to remain single-threaded, thus avoiding many of the challenges introduced by multithreading. (In this assignment, however, our goal is specifically to practice multithreading techniques.)


<!-- 
## Optional task (not mandatory)

### Task

Enable stopping the bicycles via a button click:

- Add a button to the right of the others with the label *Stop Race*.
- Clicking the *Stop Race* button should stop all bicycles and terminate the threads running them. Introduce a public method called `StopRace` in the `Game` class for this purpose.
- The race should be stoppable even before it is started.
- After stopping the race, the `StopRace` method should wait until all threads have actually finished executing.
- Once the race has been stopped (*Stop Race* clicked), no other button should be clickable (set the `IsEnabled` property of all buttons to false).

### Solution

Below are some key elements of the solution:

- Add a *Stop Race* button to the UI, implement a click handler, and from there call the newly introduced `Game.StopRace` method.
- To stop the threads, introduce a flag variable that the bike thread loops can monitor. Use a `bool` variable named `raceEnded`, and modify the thread function so that if it becomes true, the thread exits (use return).
- However, the boolean variable alone is not sufficient.
When a bike is waiting at the starting line or in the depot, its thread is blocked, waiting on an event — and therefore it cannot check the `raceEnded` flag. Thus, you must also introduce a new `ManualResetEvent` to signal the stop event (this can be awaited too).
- In the *Stop Race* button click (inside `Game.StopRace`), set both the boolean flag and the `ManualResetEvent` to a signaled state.
- In the bike thread function, comment out (but don't delete!) the existing event wait logic, and replace it with a new implementation using the `ManualResetEvent` you just created.
The bikes will still need to wait, but now the wait should also break immediately if the stop signal is received.
- If stopping was requested, the thread must exit (e.g. with a `return`).
- In the `Game.StopRace` method, after signaling the threads, wait for them to finish using `Join()` on each thread. For this, you need to store the thread objects when they are started — use a member variable like `List<Thread>`.

Note: An alternative solution for stopping threads — instead of using a boolean and `ManualResetEvent` — would be to call `Interrupt` on each thread and handle the resulting `ThreadInterruptedException` in the thread function. This technique was covered in the lecture.

!!! example "TO BE SUBMITTED" 
    Take a screenshot named `Task_Optional.png` as follows:

    - Start the application. If necessary, resize the window so it takes up less screen space.
    - In the background, Visual Studio should be open with Game.cs visible.
    - Zoom in so the thread function of the Game class is visible. In the foreground, the application window should be visible.
-->
