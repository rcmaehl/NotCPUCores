## How would you best describe NotCPUCores?

NotCPUCores is a GUI for quick CPU Resource Assignment and Priority adjustment, along with other minor tweaks. NotCPUCores uses Windows' own tools to tell it how to give CPU cores, disk usage priority, and other tasks to a game or application, compared to how it handles them by default. NotCPUCores is made to take the hassle out of manually adjusting CPU threads, priority, and other resources, and to give you more control over your PC.

## Who all benefits from using NotCPUCores?

* Anyone that doesn't want to reinstall Windows
* Anyone that doesn't want to do a couple hours of PC cleanup
* Streamers that run multiple CPU intensive tasks at once as of 1.6.0.0

## Where does the increase in FPS, quicker loading, more stability, etc come from?

By taking it away from other processes on your system. For every second that your CPU isn't causing your game to lag it's causing something else, somewhere on your system, to lag. For every second your file loads faster, something on your system had to wait to be able to access it's own files. Sometimes it's visable, especially if the resources were adjusted improperly, most of the time it isn't.

## Is it possible to get the benefits of NotCPUCores WITHOUT installing it?

**ABSOLUTELY!** Manually do what NotCPUCores does using the "Details" tab of Windows Task Manager:

1. Find all the processes of the game or application you want to ensure gets the maximum resources
2. For each process, use "Change Priority" to change it's priority to something higher, be careful with Realtime!
3. For each process, use "Change Affinity" to change what cores you want it to run on, leave some for other processes though!
4. Find all the processes that aren't the game or application you want
5. For each process, use "Change Affinity" to change them to cores you left for other processes in step 3
6. Every so often follow steps 1-5 again to ensure new processes don't touch the system resources you gave to your game or application

Additionally using the "Services" tab of Windows Task Manager:

1. Find Services that you won't be using during gameplay such as the Print Spooler (used for printing) and stop them.

Additionally, using the "Power Options" in Control Panel 

1. Change your Power Plan to "High Performance"

**WEW!** That's 5-10 minutes of manual work for potentially not much return, isn't it?

## What if I want more performance than what I get with NotCPUCores?

* If you haven't in a long time, do a fresh install of Windows. 
* Uninstall any programs you don't use, haven't used in a long time, or look into portable versions that won't automatically run with your computer
* Disable programs from running on your computer booting up.
* Defragment your harddrive if you have one
* Enable Windows Game Mode
* Switch to a less resource hungry OS like Linux

And for the **BIGGEST IMPROVEMENT**:

* Replace your Computer's Hardware with new and faster components
