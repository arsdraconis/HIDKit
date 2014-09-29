HIDKit
======

An Objective-C wrapper around OS X's HID Manager API.

Currently, this is a work in progress and the code is untested. There is no license, although I'm
leaning toward the [WTFPL](http://www.wtfpl.net/txt/copying/ "Do What The Fuck You Want To Public License").

Feel free to download and try it. Pull requests are welcome.

## Usage

`HIDManager` is the principal class. It is lazily initialized when needed, but you can explicitly initialize it by retrieving the shared instance with `[HIDManager sharedManager]`.

Use `[HIDManager devices]` to retrieve an NSArray of HID devices found on the system. As devices are connected and disconnected, `HIDManager` will send `HIDManagerDeviceDidConnectNotification`/`HIDManagerDeviceDidDisconnectNotification` notifications with the `HIDDevice` in question as the sender.

Once you retrieve a `HIDDevice`, send it an `open` message to open the interface. Be sure to send a `close` message whenever you're done with it.
