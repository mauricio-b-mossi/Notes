### Extension Files
- The manifest is just like the android manifest, here you specify
configurations, permissions, etc. It is a configuration file.

- The service worker is an event listener for browser events.
Unlike Content scripts, it cannot interact with the DOM.

- The content script executes JavaScript in the context of a webpage.
It can modify the DOM.

- The popup and other pages are HTML files that are UI.

All of the above mentioned files, but manifest, can access the ChromeApi. 

### Commands
The command API lets you declare and use keybindings. You declare your keybindings
in `manifest.json`. It is compulury for you to include a `suggested_key` and `description`.
The description will appear in the `chrome://extensions/shortcuts` menu. You can receive the commands
via `chrome.commands.onCommand`, the event receives the name of the command. You can `switch`,
depending on the action to do something with the command.  

If you add the global property to the command property, the command is listened even 
when chrome is not focused.
```js
"commands":{
    "mycommand":{
        "suggested_key" : "Ctrl+Y",
        "description" : "Does somethign great",
        "global" : true
    }
}
```

### Tabs 
The tabs API allows you to do anything related to tabs, like creating removing etc. Tabs represent 
all open tabs from the Chrome Browser, it does not matter wether you are using two separate broser
Windows. Windows are the applications that display the content, Windows contain tabs. Each session 
generates a unique Id per Window.

