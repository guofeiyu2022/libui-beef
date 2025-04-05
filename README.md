# libui-Beef
A Beef language binding for [libui-ng](https://github.com/libui-ng/libui-ng)

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
        let err = ui.UiInit(scope .());
        if (err != null) {
            Console.Error.WriteLine("Error initializing libui-ng: {0}", scope String(err));
            ui.UiFreeInitError(err);
            return 1;
        }
        defer ui.UiUninit();

        // Create a new window
        let w = ui.UiNewWindow("Hello World!", 300, 200, 0);
        ui.UiWindowOnClosing(w, scope => OnClosing, null);

        ui.UiControlShow((UiControl)w);
        ui.UiMain();
        return 0;
    }
}
```

## Supported Platforms
- Windows x86
- Windows x64
- Linux x64 (GNOME)

## Screenshots

- Windows

<table style="table-layout:fixed">
  <tr>
    <td colspan="3">controlgallery</td>
  </tr>
  <tr>
    <td width="33.33%"><img src="examples/controlgallery/screenshots/cg1.png" alt="base controls" /></td>
    <td width="33.33%"><img src="examples/controlgallery/screenshots/cg2.png" alt="numbers and lists" /></td>
    <td width="33.33%"><img src="examples/controlgallery/screenshots/cg3.png" alt="data choosers" /></td>
  </tr>
  <tr>
    <td>drawtext</td>
    <td>histogram</td>
    <td>edittable</td>
  </tr>
  <tr>
    <td><img src="examples/drawtext/screenshots/dt1.png" alt="draw text" /></td>
    <td><img src="examples/histogram/screenshots/h1.png" alt="histogram" /></td>
    <td><img src="examples/edittable/screenshots/et1.png" alt="editable table" /></td>
  </tr>
</table>

- Ubuntu Linux

<table style="table-layout:fixed">
  <tr>
    <td colspan="3">controlgallery</td>
  </tr>
  <tr>
    <td width="33.33%"><img src="examples/controlgallery/screenshots/cg1_l.png" alt="base controls" /></td>
    <td width="33.33%"><img src="examples/controlgallery/screenshots/cg2_l.png" alt="numbers and lists" /></td>
    <td width="33.33%"><img src="examples/controlgallery/screenshots/cg3_l.png" alt="data choosers" /></td>
  </tr>
  <tr>
    <td>drawtext</td>
    <td>histogram</td>
    <td>edittable</td>
  </tr>
  <tr>
    <td><img src="examples/drawtext/screenshots/dt1_l.png" alt="draw text" /></td>
    <td><img src="examples/histogram/screenshots/h1_l.png" alt="histogram" /></td>
    <td><img src="examples/edittable/screenshots/et1_l.png" alt="editable table" /></td>
  </tr>
</table>

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
