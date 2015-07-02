What is this?
=============

Safari Tab Switching is a Safari SIMBL plugin which allow switching between tabs using Cmd+1-9.

NOTE: Good news! The feature provided by this plugin has been integrated by Apple in El Capitain. Go to Safari preferences > tabs and check "⌘-1 through ⌘-9 switches tabs".

Requirement
===========

- Safari 5.0 (Snow Leopard) - May work with older version of Safari, but this is not tested
- [SIMBL](http://www.culater.net/software/SIMBL/SIMBL.php) 1.9.9 (packaged with the installer)

Installation
============

Download our [installer](https://github.com/rs/SafariTabSwitching/releases/latest) and run it then restart Safari.

Usage
=====

Use the command + <num> keyboard shortcut to switch between the 9 first tabs of your Safari windows.

NOTE: This plugin replaces the default behavior of those hotkeys which is to open the 9 first Bookmark Bar links.

As a bonus, this plugin also ad Cmd+Shift+T to reopen last closed tab.

Uninstall
=========

Run the following command in the terminal and then restart Safari.

```sh
sudo rm -r "/Library/Application Support/SIMBL/Plugins/SafariTabSwitching.bundle"
```
