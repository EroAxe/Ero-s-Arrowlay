# Ero's Arrowlay
An Interactive Stream Overlay utilizing the [Heat Twitch Extension](https://github.com/scottgarner/Heat) to allow your viewers to place arrows around your screen.  Whether that's to mess with you, or just to point something out, since the arrow is on *your* screen.

If you'd like to support me feel free to check out my Ko-Fi!

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/M4M0M90JU)

## Building the Overlay

You don't need to!  There's actually already a built version over on my Ko-Fi [(here)](https://ko-fi.com/s/a0ca1952fe) for members of the $1 tier and up.  _But_ if you'd like to build it on the dev side, there's a couple things to keep in mind.
- First off, the program is using a client ID I have setup for it specifically, meaning you can't add any more redirect URIs on your end.  You can easily switch it to your own ID if you'd like though by changing Globals.client_id
- Second the program heavily relies on an [AutoHotkey](https://www.autohotkey.com/) exe held in the "Extras" folder for the Always on Top and Click through functionality (AKA how it stays on your screen without getting in the way).  And that AutoHotkey exe **needs** to be in the same directory as the program exe to be accessed.  It's name also needs to remain unchanged.

With those sorted though you can export the project as normal, though I'd appreciate changing the export configs.

### Running the Overlay + Setup

1. Ensure you have the [Heat](https://github.com/scottgarner/Heat) extension installed on your stream to allow the Overlay to receive inputs.
2. Run the exe file named "Ero's Arrowlay".
3. Click the "Connect Twitch Account" Button* and it will open a tab in your default browser allowing you to authorize the program to read information from your channel for the extension.
4. Hit "Ctrl + T" with the Arrowlay focused to toggle click through and always on top for the Arrowlay.

And with that you're done.  You'll need to re-authorize the program every month or so since it's running the authorization entirely locally.  But otherwise that's it, the "Connect Twitch Account" button will become a "Start Overlay" button on all subsequent boots with viable authorization allowing you to get right into it.

*There are some issues with the current connection process relating to the ports that are or are not available on your PC.  The 3 options that are mainly supported as of now are 80, 8000 and 1338. If you run into any issues authorizing the program you can set one of those and repeat step 3.  Though if none of the ports work you may need to find another port depending upon your specific system that is currently unused.
