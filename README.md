# Eclipse Launcher
AutoHotkey based quick launcher for many [Eclipse](https://www.eclipse.org/)  installations. Add this to your startup folder, and invoke it via <kbd>Ctrl</kbd>+<kbd>Win</kbd>+<kbd>E</kbd>. Opens a context menu at your current mouse position to launch all installed Eclipse IDEs.

![Top level menu](menu.png "Top level menu")
![Nested menu](menu_nested.png "Nested menu")

# Installation

* Make sure your machine has [AutoHotkey](https://www.autohotkey.com/) installed.
* Use Win-R to open the _Run_ menu.
* Enter `shell:startup`, which will open your personal startup folder.
* Paste the raw file [`eclipse-launcher.ahk`](https://github.com/Bananeweizen/eclipse-launcher/raw/main/eclipse-launcher.ahk) file into that folder. That way, it will be executed on each Windows start.
* Edit and configure (at least the root directory variable). See next section for details.
* To immediately start it now, double-click the `eclipse-launcher.ahk`.

# Configuration

* Set the `RootFolder` variable to the directory that contains your different eclipse installations.
* If you have too many installations, you can restrict what is shown on the top level menu by changing the `TopLevelPattern` variable. All other installations will be moved to a sub menu then.
* Unwanted installations can be filtered via the `IgnorePattern`.

# Troubleshooting

* The menu is only created once, immediately after starting the script, to avoid excessive disk access. After installation of yet another Eclipse IDE, you may want to use the _Reload_ menu item to have the script discover that new installation.
* The script requires that the different IDE installations follow the pattern `RootFolder\SomeInstallation\eclipse\eclipse.exe`, as used by the [Eclipse Oomph installer](https://projects.eclipse.org/projects/tools.oomph) by default.