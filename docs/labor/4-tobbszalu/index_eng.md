---
authors: Szabó Zoltán,kszicsillag,bzolka
---
# 4. Developing multithreaded applications

## The aim of the laboratory

The aim of the laboratory is to familiarize students with the fundamental principles of multithreading. Covered topics include (among others):

- Starting threads (`Thread`)
- Stopping threads
- Creating thread-safe classes using the `lock` keyword
- Using `ThreadPool`
- Signaling and waiting for signals with thread synchronization using `ManualResetEvent` (`WaitHandle`)
- WinUI-specific threading features (`DispatcherQueue`)

Naturally, since this topic has a huge range, we will only gain basic knowledge, but with this foundation, we will be able to independently tackle more complex tasks.

Related lectures: Developing concurrent (multithreaded) applications.

## Prerequisites

Tools needed to complete the laboratory:

- Visual Studio 2022
    - Windows Desktop Development Workload
- Windows 10 or Windows 11 operating system (Linux and macOS are not suitable)

## Solution

??? success "Download the completed solution"
    :exclamation: It is essential to work following the instructor during the lab, it is forbidden (and pointless) to download the final solution. However, during subsequent independent practice, it can be useful to review the final solution, so we make it available.

    The solution is available on [GitHub](https://github.com/bmeviauab00/lab-tobbszalu-kiindulo/tree/megoldas). The easiest way to download it is by cloning the `megoldas` branch using the `git clone` command in the terminal:

    `git clone https://github.com/bmeviauab00/lab-tobbszalu-kiindulo -b megoldas`

    For this, command-line Git must be installed on your system. More information is available [here](../../hazi/git-github-github-classroom/index_eng.md#installing-git).

## Introduction

Managing concurrently running threads is a crucial topic that every software developer should be familiar with at least at a basic level. During this laboratory, we will solve fundamental but critical problems, so we should strive not only to achieve the final result but also to understand the purpose and reasoning behind the modifications made.

In this task, we will enhance a simple WinUI application with multithreading capabilities, solving increasingly complex problems. The initial problem is the following: we have a function that takes a long time to execute, and as we will see, calling it "directly" from the UI leads to unpleasant consequences. As part of the solution, we will extend an existing application with custom code snippets. The newly inserted lines will be highlighted in the guide.

## Task 0 - Getting familiar with the starter application and preparation

Clone the [repository](https://github.com/bmeviauab00/lab-tobbszalu-kiindulo) for the 4th laboratory:

- Open a command prompt.
- Navigate to any folder, e.g., `c:\work\NEPTUN`.
- Execute the following command: `git clone https://github.com/bmeviauab00/lab-tobbszalu-kiindulo.git`.
- Open the _SuperCalculator.sln_ solution in Visual Studio.

Our task is to create a user interface in WinUI to execute an algorithm provided in binary form. In .NET, binary format means a _.dll_ file, which, from a programming perspective, is a class library. The file we will use is _Algorithms.dll_, located in the cloned Git repository (_External_ folder).

The user interface in the starter application is already prepared. Run the application:

![starter](images/starter.png)

In the application interface, we can specify the input parameters of the algorithm (an array of `double` numbers): in our example, the algorithm always takes two `double` numbers as parameters, which can be entered in the two upper text boxes.
Our task is to execute the algorithm with the given parameters when clicking the _Calculate Result_ button and then display the result along with the input parameters in a new row of the `ListBox` under _Result_.

Next, let's get familiar with the downloaded Visual Studio solution:

The framework application is a WinUI 3-based application. The interface is mostly complete, and its definition is in the `MainWindow.xaml` file. This aspect is less relevant for us according to the aim of the laboratory, but it is worth reviewing at home for further practice.

??? note "User interface setup in `MainWindow.xaml`"

       The basic structure of the window interface:
       
       - The root element is a `Grid`, which is a common practice.
       - The top row of the root `Grid` contains a `StackPanel` with two `TextBox` elements and a `Button`.
       - The bottom row of the root `Grid` contains another `Grid`. Unlike `TextBox`, `ListBox` does not have a `Header` property, so we introduced a separate `TextBlock` labeled "Result" for this purpose. Using a `Grid` instead of a simpler `StackPanel` allows us to fix the height of the top row while letting the `ListBox` fill the remaining space (`Auto` height for the top row, `*` height for the bottom row).
       - The "Calculate Result" button demonstrates that the `Content` property of a `Button` is often more than just plain text. In this example, it consists of a `SymbolIcon` and a `TextBlock` combined using a `StackPanel`, enhancing its appearance with an appropriate icon.
       - We also see an example of how to make a `ListBox` scrollable if it already contains many items (or if the items are too wide). This is achieved by properly setting its `ScrollViewer`.
       - The `ItemContainerStyle` property of `ListBox` is used to apply styles to its items. In this example, the `Padding` was reduced from its default value to avoid excessive spacing.

The `MainWindow.xaml.cs` source file contains the code-behind for the main window. Key elements include:

- The `ShowResult` helper function, which logs results and parameters into the `ListBox`.
- The `CalculateResultButton_Click` event handler for the _Calculate Result_ button. This reads values from the text boxes and attempts to convert them to numbers. If successful, this is where the algorithm will be called (not yet implemented). If conversion fails, the `DisplayInvalidElementDialog` function shows a message box informing the user about invalid parameters.
- The `AddKeyboardAcceleratorToChangeTheme` function, called from the constructor, is not relevant to us — it enables switching between light and dark themes (try pressing ++ctrl+t++ during execution).

### Using the code in the DLL

The _Algorithm.dll_ file is included in the starter project. It contains a `SuperAlgorithm` class within the `Algorithms` namespace, which provides a static method called `Calculate`. To use classes from a DLL in a project, we need to add a reference to it.

1. In Solution Explorer, right-click the _Dependencies_ node of the project and select _Add Project Reference_.

    ![Add project reference](images/add-project-ref.png)

    !!! note "External references"

        Although we are not referencing another Visual Studio project, this is the easiest way to access this window.

        In real projects, external class libraries are typically not referenced as DLL files directly. Instead, they are obtained from NuGet, .NET's package management system. Since _Algorithm.dll_ is not published on NuGet, we need to manually add it.

2. In the pop-up window, use the _Browse_ button in the bottom right corner to locate and select the _Algorithms.dll_ file from the project's _External_ subfolder. Confirm by clicking OK.

In Solution Explorer, under the project's _Dependencies_ node, we can see the referenced external dependencies. The previously added `Algorithms` reference now appears under _Assemblies_. The _Frameworks_ category lists .NET framework packages, and _Analyzers_ contain static code analysis tools used during compilation. Normally, project or NuGet references would also appear here.

![Dependencies](images/dependencies.png)

Right-click the `Algorithms` reference and select _View in Object Browser_. This opens the Object Browser tab, where we can inspect the namespaces, classes, and their members (fields, methods, properties, events) within the DLL. Visual Studio extracts this from metadata of the DLL using the reflection mechanism (which we can also use in our own code).

In the Object Browser, expand the `Algorithms` node on the left, revealing a `SuperAlgorithm` class inside the `Algorithms` namespace. Selecting this class displays its methods in the middle panel, and choosing a method shows its exact signature:

![Object browser](images/object-browser.png)

## Task 1 – Running the operation on the main thread

Now we can move on to executing the algorithm. As a first step, we will run it on the main thread of our application.

1. Call the `Calculate` function within the `Click` event handler of the button on the main window. To do this, open the `MainWindow.xaml.cs` code-behind file in Solution Explorer and find the `CalculateResultButton_Click` event handler. Extend the code by calling the newly referenced algorithm.

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

2. Run and try the application! Notice that the window does not respond to movements or resizing during the calculation. The interface practically freezes.

Our application, like all Windows applications, is event-driven. The operating system notifies our application of various interactions (e.g., movement, resizing, mouse clicks). However, since the application’s single thread is occupied with computation after pressing the button, it cannot immediately process additional user commands. Once the computation completes (and the results appear in the list), any previously issued commands will then be executed.

## Task 2 – Perform the calculation in a separate thread

The next step is to run the computation on a separate thread so that it does not block the user interface.

1. Create a new function in the `MainWindow` class, which will serve as the entry point for the worker thread.

    ```cs
    private void CalculatorThread(object arg)
    {
        var parameters = (double[])arg;
        var result = Algorithms.SuperAlgorithm.Calculate(parameters);
        ShowResult(parameters, result);
    }
    ```

2. Start the thread within the button's `Click` event handler. Replace the previously added code with the following:

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

    The `CalculatorThread` function receives the parameter passed via the `Start` method of the `Thread` object.

3. Run the application using ++f5++ (it is important to run it with the debugger now). We receive the error message:  
   _The application called an interface that was marshalled for a different thread. (0x8001010E (RPC_E_WRONG_THREAD))_  
   This error occurs in the `ShowResult` method because we are trying to access a UI element from a thread that did not create it. In the next task, we will analyze and resolve this issue.

## Task 3 – Using `DispatcherQueue.HasThreadAccess` and `DispatcherQueue.TryEnqueue`

In the previous section, the issue is caused by the following rule in WinUI applications:  
Windows/UI elements/controls are by default **not thread-safe** objects. This means that **a Window/UI element/control must only be accessed (e.g., reading/writing properties, invoking methods) from the thread that created it**, otherwise, an exception will be thrown. In our application, the exception occurred because the `resultListBox` control was created on the main thread, but we tried to access it from a different thread within the `ShowResult` method (specifically, in the `resultListBox.Items.Add` call).  

The question is how we can access these UI elements/controls from another thread. The solution is the use of `DispatcherQueue`, which helps ensure that access to the controls always occurs from the correct thread:

- The `TryEnqueue` function of the `DispatcherQueue` object runs the function provided as a parameter on the thread that created the control (so we can directly access the control from this function).
- The `HasThreadAccess` property the `DispatcherQueue` object helps determine whether it is necessary to use the `TryEnqueue` mentioned in the previous point. If the property value is:
    - true, then we can access the control directly (because the current thread is the same as the thread that created the control), but if it is
    - false, then the control can only be accessed indirectly, through the `TryEnqueue` of the `DispatcherQueue` object (because the current thread is NOT the same as the thread that created the control).

With the help of `DispatcherQueue`, we can avoid the previous exception (we can "redirect" access to the control, in this case, `resultListBox`, to the appropriate thread). This is what we will do next.

!!! Note
    The `DispatcherQueue` object is available in subclasses of the `Window` class through the `DispatcherQueue` property (in other classes, it can be obtained using the `DispatcherQueue.GetForCurrentThread()` static method).

We need to modify the `ShowResult` method to ensure that it does not throw an exception when called from a worker thread.

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

Let's try it!

This solution is now working, and its main elements are the followings:

- The role of the `DispatcherQueue` `null` check: after the main window is closed, the `DispatcherQueue` is `null` and cannot be used.
- Using `DispatcherQueue.HasThreadAccess`, we check whether the calling thread can directly access the controls (in our case, the `ListBox`):
    - If yes, everything happens as before, and the code handling the `ListBox` remains unchanged.
    - If not, we access the control through `DispatcherQueue.TryEnqueue`. The following trick is used. We pass a parameterless, single-line function as a lambda expression to the `TryEnqueue` function, which invokes our `ShowResult` function (practically recursively), passing the parameters along. This is beneficial for us because this `ShowResult` call occurs on the thread that created the control (the main thread of the application), where the `HasThreadAccess` value is now `true`, and we can directly access our `ListBox`. This recursive approach is a common pattern for avoiding redundant code.

Let's set a breakpoint on the first line of the `ShowResult` method and, by running the application, make sure that when the `ShowResult` method is called for the first time, `HasThreadAccess` is still false (so the `TryEnqueue` is called), and as a result, `ShowResult` is called again, but this time `HasThreadAccess` is true.

Now, remove the breakpoint and run the application again: notice that while one computation is running, we can start new ones as well, since our interface remains responsive throughout (and the previously experienced error no longer occurs).

## Task 4 – Performing an operation on a ThreadPool thread

A characteristic of the previous solution is that it always creates a new thread for the operation. In our case, this is not particularly significant, but this approach can be problematic for a server application that handles a large number of requests while creating a separate thread for each request. There are two main reasons for this:

- If the thread function completes quickly (i.e., serving a client is fast), a large portion of the CPU is wasted on creating and terminating threads, as these operations themselves are resource-intensive.
- Too many threads might be created, which the operating system must schedule, leading to unnecessary resource wastage.

Another issue with our current solution is that, since the computation runs on a **foreground thread** (newly created threads are foreground threads by default), closing the application does not stop the program. It continues running in the background until the last computation completes. This happens because a process only terminates when no foreground threads are left running.

Let's modify the button event handler so that, instead of starting a new thread, it runs the computation on a **ThreadPool** thread. To do this, we only need to rewrite the button click event handler again.

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

Try running the application, and notice that when the window is closed, the application shuts down immediately, without dealing with any threads that may still be running (because the thread pool threads are background threads).

## Task 5 – Producer-Consumer based solution

In the previous tasks, we arrived at a fully functional solution to the original problem, allowing multiple worker threads to run calculations in parallel if the button is pressed multiple times. Now, we will modify the application so that pressing the button does not always create a new thread. Instead, tasks will be added to a task queue, from which multiple, in the background continuously running, threads will sequentially retrieve and execute them. This problem is a classic producer-consumer scenario, which occurs frequently in practice. The following diagram illustrates how it works.

![Producer-Consumer](images/termelo-fogyaszto.png)

!!! tip "Producer-Consumer vs. `ThreadPool`"
    If we think about it, the `ThreadPool` itself is a specialized producer-consumer and scheduling mechanism provided by .NET. In the following, we will develop a different type of producer-consumer solution to encounter specific concurrency issues related to thread management.

Our main thread acts as the producer, creating a new task whenever the _Calculate result_ button is clicked. We will launch multiple consumer/worker threads to take advantage of multiple CPU cores and parallelize task execution.

For temporary task storage, we can use the `DataFifo` class, which has already been partially prepared in our base project (found in the `Data` folder in the Solution Explorer). Let's examine its source code. It implements a simple FIFO queue that stores `double[]` elements. The `Put` method appends new items to the end of the internal list, while the `TryGet` method retrieves (and removes) the first element of the list. If the list is empty, the function cannot return an item and indicates this by returning `false`.

1. Modify the button event handler so that tasks are added to the FIFO queue instead of using the `ThreadPool`:

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

2. Implement the new worker thread function in our form class:

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

    The `Thread.Sleep` statement is necessary because, without it, worker threads would continuously spin when the FIFO is empty, unnecessarily consuming 100% of a CPU core without performing any useful work. Our solution is not ideal; we will improve it later.

3. Create and start the worker threads in the constructor:

    ```cs
    new Thread(WorkerThread) { Name = "Worker thread 1" }.Start();
    new Thread(WorkerThread) { Name = "Worker thread 2" }.Start();
    new Thread(WorkerThread) { Name = "Worker thread 3" }.Start();
    ```

4. Run the application and close it immediately without clicking the _Calculate Result_ button. We observe that while the window closes, the process continues running. The application can only be terminated through Visual Studio or the Task Manager:

    ![Stop Debugging](images/stop-debugging.png)

    The worker threads are foreground threads, preventing the process from terminating upon exit. One possible solution is to set their `IsBackground` property to `true` after creation. Another solution is to explicitly ensure worker threads exit upon application shutdown. We will revisit this issue later.

5. Run the application again, and after clicking the _Calculate Result_ button (just once), we are likely to encounter an exception. The problem is that `DataFifo` is not thread-safe and has become inconsistent. Two underlying reasons contribute to this:

### Problem 1

Let's consider the following scenario:

1. The queue is empty. The worker threads continuously poll the FIFO in a `while` loop, i.e., they call the `TryGet` method.
2. The user puts a task into the queue.
3. One of the worker threads sees that there is data in the queue in the `TryGet` method, i.e., the condition `if (_innerList.Count > 0)` is satisfied, and it proceeds to the next line of code. Let's assume this thread loses its execution right at this point and doesn't have time to remove the data from the queue.
4. Another worker thread also evaluates the `if (_innerList.Count > 0)` condition at the same time, and since the condition is still satisfied, it removes the data from the queue.
5. The first thread is re-scheduled, it wakes up, and tries to remove data from the queue, but the queue is already empty as the second thread has already removed the only data. This results in an exception when accessing `_innerList[0]`.

We can only avoid this problem by making the check for the emptiness of the queue and the removal of the item "atomic": **this means that while one thread has not finished both operations, the other threads must wait!**

!!! note "Thread.Sleep(500)"
    The `Thread.Sleep(500);` line following the emptiness check is only there to increase the likelihood of the above unfortunate scenario happening in our example (as this makes it almost certain that the thread will be rescheduled). We will remove it later, but for now, let's leave it in.

### Problem 2

The `DataFifo` class allows concurrent access to the `_innerList` member variable, which is of type `List<double[]>`, from multiple threads. However, if we look at the `List<T>` documentation, we find that the class is not thread-safe. In this case, we cannot allow this; we need to ensure **mutual exclusion** with locks: we must ensure that only one thread can access a method/property/member variable at a time (specifically, inconsistency can occur only in cases of simultaneous writing or simultaneous writing and reading, but we usually don't differentiate between writers and readers, and we won't do that here either).

In the next step, we will make the `DataFifo` class thread-safe, which will prevent the two problems described above from occurring.

## Task 6 – Make the `DataFifo` class thread-safe

To make the `DataFifo` class thread-safe, we need an object (which can be any reference type object) that we can use as a key for locking. We can then use the `lock` keyword to ensure that only one thread is inside the locked code block at a time.

1. Add an `object` field named `_syncRoot` to the `DataFifo` class.

    ```cs
    private object _syncRoot = new object();
    ```

2. Modify the `Put` and `TryGet` methods to use locking.

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
        Use Visual Studio's _Surround with_ feature by pressing CTRL + K, CTRL + S to wrap the selected code block.

Now, we should no longer receive exceptions.

We can also remove the artificial delay (`Thread.Sleep(500);`) from the `TryGet` method.

!!! error "Locking on `this`"
    One might wonder why we introduced a separate `_syncRoot` field and used it for locking instead of using `this` (since `DataFifo` is a reference type, there would be no issue with that). However, using `this` **would violate the encapsulation** of our class! Remember: `this` is a reference to our object, but other classes may also have a reference to this same object (for example, in our case, `MainWindow` has a reference to `DataFifo`), and if these external classes place a lock on the object using `lock`, it will "interfere" with the internal locking mechanism (since using `this` the `lock` parameter will be the same for both the external and internal `lock`). For example, an external lock could completely "freeze" the `TryGet` and `Put` operations. In contrast, in our chosen solution, the `lock` parameter, the `_syncRoot` variable, is private, meaning external classes cannot access it and thus cannot disrupt the internal workings of our class.

## Task 7 – Efficient signaling implementation

### Using `ManualResetEvent`

The continuous `while` loop running in the `WorkerThread` implements active waiting, which should always be avoided. Without `Thread.Sleep`, it would max out the CPU. While `Thread.Sleep` solves the CPU overload problem, it introduces another issue: if all three worker threads are asleep when new data arrives, there is unnecessary waiting (500ms) before processing the new data.

Next, we will modify the application to wait blocked data is added to the FIFO (but start processing immediately once data is available). To signal whether there is data in the queue, we will use a `ManualResetEvent`.

1. Add a `ManualResetEvent` instance named `_hasData` to the `DataFifo` class.

    ```cs
    // The 'false' constructor parameter means the event is initially non-signaled (gate closed)
    private ManualResetEvent _hasData = new ManualResetEvent(false);
    ```

2. The `_hasData` event acts as a gate in our application. When data is added to the list, we "open" it, and when the list becomes empty, we "close" it.

    !!! tip "The semantics and naming of the event"  
        It is essential to choose the semantics of our event correctly and to express this clearly with the variable name. In our example, the `_hasData` name accurately conveys that our event is signaled (gate open) precisely when and only when there is data to be processed. Now, our "only" task is to implement this semantics: set the event to signaled when data is added to the FIFO and reset it when the FIFO is emptied.


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

### Waiting for signal (Blocking Get)

In the previous step, we implemented signaling, but this alone is not very useful since there are no waiting threads. Now, we will implement this.

1. Modify the method as follows: insert a wait for the `_hasData` event.

    ```cs hl_lines="5"
    public bool TryGet(out double[] data)
    {
        lock (_syncRoot)
        {
            _hasData.WaitOne();
            
            if (_innerList.Count > 0)
                // ...
    ```

    !!! note "Return value of the WaitOne method"  
        The `WaitOne` method returns a `bool` value, which is `true` if the event is signaled before the timeout specified in the `WaitOne` parameter (or `false` if the timeout expires). In our example, we did not specify a timeout parameter, which means an infinite timeout is applied. Accordingly, we do not check the return value (since it will wait indefinitely for a signal).

2. This makes the `Thread.Sleep` in `WorkerThread` unnecessary, so comment it out!

    When running the above solution, we notice that the application's interface freezes after the first button press. This happens because we made a rookie mistake in our previous solution. We are waiting for the `_hasData` signal inside a locked section of code, which means the main thread has no chance to send a signal with `_hasData` in the `Put` method (which is also within a `lock`-protected section).  **This results in a deadlock situation.**  It's important to carefully analyze the code to understand why this happens:

    * In `TryGet`, one of the worker threads (that entered the `lock` block among the three) waits at `_hasData.WaitOne()` for the main thread to signal `_hasData` in `Put`.
    * Meanwhile, in `Put`, the main thread waits at the `lock` statement for the worker thread in `TryGet` to exit its `lock` block.

    They are mutually waiting for each other indefinitely, which is a classic deadlock scenario.

    We could try adding a timeout (in milliseconds) when waiting (this is just for illustration, not required to implement):

    ```cs
    if (_hasData.WaitOne(100))
    ```

    However, this would not be an elegant solution. Moreover, continuously polling worker threads would significantly starve the thread calling `Put`. Instead, the proper and recommended approach is to avoid blocking waits inside a `lock`.

    As a fix, swap the positions of `lock` and `WaitOne`:

    ```cs hl_lines="3-6"
    public bool TryGet(out double[] data)
    {
        _hasData.WaitOne();

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

    Try running the application again, now it works correctly.

3. The role of the empty check inside the `lock` block.

    In the previous step, we introduced a `ManualResetEvent` object named `_hasData` in `TryGet`. This is in a signaled state exactly when there is data in the FIFO. The question is: is the empty check (`if (_innerList.Count > 0)`) still needed inside the `lock` block? At first glance, we might think it's redundant. Let's try replacing the empty check inside the `if` with a fixed `true` value, effectively neutralizing the `if` condition (we're doing it this way so that it's easy to reverse):

    ```cs hl_lines="4"
    ...
    lock (_syncRoot)
    {
        if (true)
        {
            data = _innerList[0];
            ...
    }
    ```

    Let's try it. We will encounter an exception when we click the button: the solution is now **not thread-safe**. Let's break down why:

    * When the application starts, all three worker threads wait for data to be placed in the FIFO at `_hasData.WaitOne()`.
    * When the button is clicked, the `Put` method signals `_hasData`.
    * In `TryGet`, all three threads pass through the line `_hasData.WaitOne();` (since this is a `ManualResetEvent`, once it's signaled, all threads can continue).
    * Only one thread enters the `lock` block; the other two are waiting (only one thread can be inside the `lock` block at a time). This thread removes the first and only element from `_innerList` and then exits the `lock` block.
    * Now, one of the two threads that was waiting at the `lock` can enter the block (they've already passed the `_hasData.WaitOne()`!!!), and it tries to remove the 0th element from `_innerList`. But it's no longer there (the first thread already took it), which results in an exception.

    The solution: We need to ensure inside the `lock` block that if another thread empties the list in the meantime, our thread does not try to remove an element. So, we need to reintroduce the previous empty check. Let's do that! Now our solution works correctly. It might still happen that we check the list unnecessarily, but for now, we're okay with that.

In summary:

* The empty check is still necessary even after introducing the `ManualResetEvent`.
* The purpose of the `ManualResetEvent` is to prevent unnecessary polling of the list when it's empty, thus avoiding active waiting.

    !!! note "The challenges of programming in a concurrent, multithreaded environment"
        This task clearly illustrates the careful thought required for programming in a concurrent, multithreaded environment. In fact, we were somewhat fortunate earlier because the error was reproducible. In practice, however, this is rarely the case. Unfortunately, it’s much more common for concurrency errors to cause intermittent, non-reproducible problems. Solving tasks like this always requires a lot of consideration, and they cannot be coded following the "I’ll keep trying until it works in manual testing" approach.

    !!! note "System.Collections.Concurrent"
        The .NET framework includes several built-in thread-safe classes in the `System.Collections.Concurrent` namespace. In the above example, we could have replaced the `DataFifo` class with the `System.Collections.Concurrent.ConcurrentQueue` class.

## Task 8 – Elegant shutdown

Earlier, we put aside the problem where our process "hangs" when the window is closed, because the worker threads were foreground threads, and we hadn't solved how to exit them properly. Our goal now is to ensure that the worker threads shut down gracefully when the application is closed, replacing the infinite `while` loop.

1. Use a `ManualResetEvent` to signal the shutdown in `TryGet` during the wait. We will add a new `ManualResetEvent` to the FIFO and introduce a `Release` method that can be used to end the waiting state (by setting our new event to the signaled state).

    ```cs
    private ManualResetEvent _releaseTryGet = new ManualResetEvent(false);

    public void Release()
    {
        _releaseTryGet.Set();
    }
    ```

2. In `TryGet`, wait for this new event as well. The `WaitAny` method will allow the execution to proceed when any of the `WaitHandle` objects provided in its parameters are signaled. It returns the index of the signaled object in the array. Actual data processing should only occur when `_hasData` is signaled (which will cause `WaitAny` to return 0).

    ```cs hl_lines="3"
    public bool TryGet(out double[] data)
    {
        if (WaitHandle.WaitAny(new[] { _hasData, _releaseTryGet }) == 0)
        {
            lock (_syncRoot)
            {
    ```

3. In `MainWindow.xaml.cs`, add a flag variable to indicate when the window is closed.

    ```cs
    private bool _isClosed = false;
    ```

4. When the main window is closed, signal the new event and toggle the flag. Subscribe to the `Closed` event in the `MainWindow` class constructor and implement the event handler function:

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

5. Rewrite the `while` loop to monitor the flag from the previous step.

    ```cs hl_lines="3"
    private void WorkerThread()
    {
        while (!_isClosed)
        {
    ```

6. Finally, ensure that no messages are displayed after the window is closed.

    ```cs hl_lines="3-4"
    private void ShowResult(double[] parameters, double result)
    {
        if (_isClosed)
            return;
    }
    ```

7. Run the application and check if the process indeed terminates properly when we exit the application.


## Outlook: Task, async, await

In this laboratory, we aimed to familiarize ourselves with low-level thread management techniques. However, we could have (partially) implemented our solution using higher-level tools and mechanisms provided by .NET for asynchronous programming, such as the `Task`/`Task<T>` classes and the `async`/`await` keywords.
