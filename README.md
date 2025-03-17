# libui-Beef
A Beef language binding for [libui-ng](https://github.com/libui-ng/libui-ng)

## Screenshots

| From examples/controlgallery |
|-------|
| <img src="examples/controlgallery/screenshots/cg1.png" alt="base controls" width="33%" /> <img src="examples/controlgallery/screenshots/cg2.png" alt="numbers and lists" width="33%" /> <img src="examples/controlgallery/screenshots/cg3.png" alt="data choosers" width="33%" /> |

| From examples/drawtext | From examples/histogram | From examples/edittable |
|-------|------|------|
| <img src="examples/drawtext/screenshots/dt1.png" alt="draw text" width="90%" /> | <img src="examples/histogram/screenshots/h1.png" alt="histogram" width="90%" /> | <img src="examples/edittable/screenshots/et1.png" alt="editable table" width="90%" /> |



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

  <img src="images/from_remote1.png" alt="add from remote" width="50%" />

  2. In opened dialog, inputs project URL for libui-beef.

  <img src="images/from_remote2.png" alt="input remote url" width="50%" />

  3. You can refresh newest libui-beef by right clicking "libui-beef" node, then selecting "Update Version Lock".

  <img src="images/update_lock.png" alt="update version lock" width="50%" />

## Links
 - [libui](https://github.com/andlabs/libui)
 - [libui-ng](https://github.com/libui-ng/libui-ng)
 - [Beef Lang](https://www.beeflang.org/)
