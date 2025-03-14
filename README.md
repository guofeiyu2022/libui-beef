# libui-Beef
A Beef language binding for [libui-ng](https://github.com/libui-ng/libui-ng)

## Screenshots

From examples/controlgallery:

![base controls](examples/controlgallery/screenshots/cg1.png)

![numbers and lists](examples/controlgallery/screenshots/cg2.png)

![data choosers](examples/controlgallery/screenshots/cg3.png)

From examples/drawtext:

![draw text](examples/drawtext/screenshots/dt1.png)

From examples/histogram:

![draw text](examples/histogram/screenshots/h1.png)

## Simple Example
Below example displays a blank window.

```cs
using libui;
using System;

namespace libuitest1;

class Program
{
    static int32 OnClosing(__IntPtr w, __IntPtr data)
    {
        ui.UiQuit();
        return 1;
    }

    static int Main()
    {
        var o = scope UiInitOptions();
        var err = ui.UiInit(o);
        if (err != null) {
            Console.Error.WriteLine("Error initializing libui-ng: {0}", scope String(err));
            ui.UiFreeInitError(err);
            return 1;
        }
        defer ui.UiUninit();

        // Create a new window
        var w = ui.UiNewWindow("Hello World!", 300, 200, 0);
        ui.UiWindowOnClosing(w, scope => OnClosing, null);

        ui.UiControlShow((UiControl)w);
        ui.UiMain();
        return 0;
    }
}
```

## Tips
- libui-beef supports importing from remote, follow below steps:
  1. In IDE, right clicks "Workspace" node, selects "Add From Remote...".
    ![from_remote1](images/from_remote1.png)
  2. In opened dialog, inputs project URL for libui-beef.
    ![from_remote2](images/from_remote2.png)
  3. You can refresh newest libui-beef by right clicking "libui-beef" node, then selecting "Update Version Lock".
    ![update_lock](images/update_lock.png)
