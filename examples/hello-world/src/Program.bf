using libui;
using System;

namespace hello_world;

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

        // Create a new window
        var w = ui.UiNewWindow("Hello World!", 300, 30, 0);
        ui.UiWindowOnClosing(w, scope => OnClosing, null);

        var l = ui.UiNewLabel("Hello, World!");
        ui.UiWindowSetChild(w, (UiControl)l);

        ui.UiControlShow((UiControl)w);
        ui.UiMain();
        ui.UiUninit();
        return 0;
    }
}