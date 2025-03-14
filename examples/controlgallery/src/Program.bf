using libui;
using System;
using System.Collections;

namespace controlgallery;

class Program
{
    static UiWindow mainWin;
    static UiSpinbox spinbox;
    static UiSlider slider;
    static UiProgressBar pbar;
    static UiEntry entry1, entry2, entry3;

    static UiControl MakeBasicControlsPage()
    {
        var vbox = ui.UiNewVerticalBox();
        ui.UiBoxSetPadded(vbox, 1);

        var hbox = ui.UiNewHorizontalBox();
        ui.UiBoxSetPadded(hbox, 1);
        ui.UiBoxAppend(vbox, (UiControl)hbox, 0);

        ui.UiBoxAppend(hbox, (UiControl)ui.UiNewButton("Button"), 0);
        ui.UiBoxAppend(hbox, (UiControl)ui.UiNewCheckbox("Checkbox"), 0);

        ui.UiBoxAppend(vbox, (UiControl)ui.UiNewLabel("This is a label.\nLabels can span multiple lines."), 0);

        ui.UiBoxAppend(vbox, (UiControl)ui.UiNewHorizontalSeparator(), 0);

        var group = ui.UiNewGroup("Entries");
        ui.UiGroupSetMargined(group, 1);
        ui.UiBoxAppend(vbox, (UiControl)group, 1);

        var entryForm = ui.UiNewForm();
        ui.UiFormSetPadded(entryForm, 1);
        ui.UiGroupSetChild(group,  (UiControl)entryForm);

        ui.UiFormAppend(entryForm, "Entry", (UiControl)ui.UiNewEntry(), 0);
        ui.UiFormAppend(entryForm, "Password Entry", (UiControl)ui.UiNewPasswordEntry(), 0);
        ui.UiFormAppend(entryForm, "Search Entry", (UiControl)ui.UiNewSearchEntry(), 0);
        ui.UiFormAppend(entryForm, "Multiline Entry", (UiControl)ui.UiNewMultilineEntry(), 1);
        ui.UiFormAppend(entryForm, "Multiline Entry No Wrap", (UiControl)ui.UiNewNonWrappingMultilineEntry(), 1);

        return (UiControl)vbox;
    }

    static UiControl MakeNumbersPage()
    {
        var hbox = ui.UiNewHorizontalBox();
        ui.UiBoxSetPadded(hbox, 1);

        var group = ui.UiNewGroup("Numbers");
        ui.UiGroupSetMargined(group, 1);
        ui.UiBoxAppend(hbox, (UiControl)group, 1);

        var vbox = ui.UiNewVerticalBox();
        ui.UiBoxSetPadded(vbox, 1);
        ui.UiGroupSetChild(group,  (UiControl)vbox);

        spinbox = ui.UiNewSpinbox(0, 100);
        slider = ui.UiNewSlider(0, 100);
        pbar = ui.UiNewProgressBar();
        ui.UiSpinboxOnChanged(spinbox, scope => OnSpinboxChanged, null);
        ui.UiSliderOnChanged(slider, scope => OnSliderChanged, null);
        ui.UiBoxAppend(vbox, (UiControl)spinbox, 0);
        ui.UiBoxAppend(vbox, (UiControl)slider, 0);
        ui.UiBoxAppend(vbox, (UiControl)pbar, 0);

        var ip = ui.UiNewProgressBar();
        ui.UiProgressBarSetValue(ip, -1);
        ui.UiBoxAppend(vbox, (UiControl)ip, 1);

        group = ui.UiNewGroup("Lists");
        ui.UiGroupSetMargined(group, 1);
        ui.UiBoxAppend(hbox, (UiControl)group, 1);

        vbox = ui.UiNewVerticalBox();
        ui.UiBoxSetPadded(vbox, 1);
        ui.UiGroupSetChild(group,  (UiControl)vbox);

        var cbox = ui.UiNewCombobox();
        ui.UiComboboxAppend(cbox, "Combobox Item 1");
        ui.UiComboboxAppend(cbox, "Combobox Item 2");
        ui.UiComboboxAppend(cbox, "Combobox Item 3");
        ui.UiBoxAppend(vbox, (UiControl)cbox, 0);

        var ecbox = ui.UiNewEditableCombobox();
        ui.UiEditableComboboxAppend(ecbox, "Editable Item 1");
        ui.UiEditableComboboxAppend(ecbox, "Editable Item 2");
        ui.UiEditableComboboxAppend(ecbox, "Editable Item 3");
        ui.UiBoxAppend(vbox, (UiControl)ecbox, 0);

        var rb = ui.UiNewRadioButtons();
        ui.UiRadioButtonsAppend(rb, "Radio Button 1");
        ui.UiRadioButtonsAppend(rb, "Radio Button 2");
        ui.UiRadioButtonsAppend(rb, "Radio Button 3");
        ui.UiBoxAppend(vbox, (UiControl)rb, 1);

        return (UiControl)hbox;
    }

    static UiControl MakeDataChoosersPage()
    {
        var hbox = ui.UiNewHorizontalBox();
        ui.UiBoxSetPadded(hbox, 1);

        var vbox = ui.UiNewVerticalBox();
        ui.UiBoxSetPadded(vbox, 1);
        ui.UiBoxAppend(hbox,  (UiControl)vbox, 0);

        ui.UiBoxAppend(vbox, (UiControl)ui.UiNewDatePicker(), 0);
        ui.UiBoxAppend(vbox, (UiControl)ui.UiNewTimePicker(), 0);
        ui.UiBoxAppend(vbox, (UiControl)ui.UiNewDateTimePicker(), 0);

        ui.UiBoxAppend(vbox, (UiControl)ui.UiNewFontButton(), 0);
        ui.UiBoxAppend(vbox, (UiControl)ui.UiNewColorButton(), 0);

        ui.UiBoxAppend(hbox, (UiControl)ui.UiNewVerticalSeparator(), 0);

        vbox = ui.UiNewVerticalBox();
        ui.UiBoxSetPadded(vbox, 1);
        ui.UiBoxAppend(hbox,  (UiControl)vbox, 1);

        var grid = ui.UiNewGrid();
        ui.UiGridSetPadded(grid, 1);
        ui.UiBoxAppend(vbox,  (UiControl)grid, 0);

        var button = ui.UiNewButton("  Open File  ");
        entry1 = ui.UiNewEntry();
        ui.UiEntrySetReadOnly(entry1, 1);
        ui.UiButtonOnClicked(button, scope => OnOpenFileClicked, entry1.__Instance);
        ui.UiGridAppend(grid, (UiControl)button,
        	0, 0, 1, 1,
        	0, (uint32)UiAlign.UiAlignFill, 0, (uint32)UiAlign.UiAlignFill);
        ui.UiGridAppend(grid, (UiControl)entry1,
        	1, 0, 1, 1,
        	1, (uint32)UiAlign.UiAlignFill, 0, (uint32)UiAlign.UiAlignFill);

        button = ui.UiNewButton("  Open Folder  ");
        entry2 = ui.UiNewEntry();
        ui.UiEntrySetReadOnly(entry2, 1);
        ui.UiButtonOnClicked(button, scope => OnOpenFolderClicked, entry2.__Instance);
        ui.UiGridAppend(grid, (UiControl)button,
        	0, 1, 1, 1,
        	0, (uint32)UiAlign.UiAlignFill, 0, (uint32)UiAlign.UiAlignFill);
        ui.UiGridAppend(grid, (UiControl)entry2,
        	1, 1, 1, 1,
        	1, (uint32)UiAlign.UiAlignFill, 0, (uint32)UiAlign.UiAlignFill);

        button = ui.UiNewButton("  Save File  ");
        entry3 = ui.UiNewEntry();
        ui.UiEntrySetReadOnly(entry3, 1);
        ui.UiButtonOnClicked(button, scope => OnSaveFileClicked, entry3.__Instance);
        ui.UiGridAppend(grid, (UiControl)button,
        	0, 2, 1, 1,
        	0, (uint32)UiAlign.UiAlignFill, 0, (uint32)UiAlign.UiAlignFill);
        ui.UiGridAppend(grid, (UiControl)entry3,
        	1, 2, 1, 1,
        	1, (uint32)UiAlign.UiAlignFill, 0, (uint32)UiAlign.UiAlignFill);

        var msggrid = ui.UiNewGrid();
        ui.UiGridSetPadded(msggrid, 1);
        ui.UiGridAppend(grid, (UiControl)msggrid,
        	0, 3, 2, 1,
        	0, (uint32)UiAlign.UiAlignCenter, 0, (uint32)UiAlign.UiAlignStart);

        button =  ui.UiNewButton("Message Box");
        ui.UiButtonOnClicked(button, scope => OnMsgBoxClicked, null);
        ui.UiGridAppend(msggrid, (UiControl)button,
        	0, 0, 1, 1,
        	0, (uint32)UiAlign.UiAlignFill, 0, (uint32)UiAlign.UiAlignFill);
        button = ui.UiNewButton("Error Box");
        ui.UiButtonOnClicked(button, scope => OnMsgBoxErrorClicked, null);
        ui.UiGridAppend(msggrid, (UiControl)button,
        	1, 0, 1, 1,
        	0, (uint32)UiAlign.UiAlignFill, 0, (uint32)UiAlign.UiAlignFill);

        return (UiControl)hbox;
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

        var menu = ui.UiNewMenu("File");
        var item = ui.UiMenuAppendItem(menu, "Open");
        ui.UiMenuItemOnClicked(item, scope => OpenClicked, null);
        item = ui.UiMenuAppendItem(menu, "Open Folder");
        ui.UiMenuItemOnClicked(item, scope => OpenFolderClicked, null);
        item = ui.UiMenuAppendItem(menu, "Save");
        ui.UiMenuItemOnClicked(item, scope => SaveClicked, null);
        item = ui.UiMenuAppendQuitItem(menu);

        menu = ui.UiNewMenu("Edit");
        item = ui.UiMenuAppendCheckItem(menu, "Checkable Item");
        ui.UiMenuAppendSeparator(menu);
        item = ui.UiMenuAppendItem(menu, "Disabled Item");
        ui.UiMenuItemDisable(item);
        item = ui.UiMenuAppendPreferencesItem(menu);

        menu = ui.UiNewMenu("Help");
        item = ui.UiMenuAppendItem(menu, "Help");
        item = ui.UiMenuAppendAboutItem(menu);

        mainWin = ui.UiNewWindow("libui Control Gallery", 640, 480, 1);
        ui.UiWindowOnClosing(mainWin, scope => OnClosing, null);
        ui.UiOnShouldQuit(scope => ShouldQuit, mainWin.__Instance);

        var tab = ui.UiNewTab();
        ui.UiWindowSetChild(mainWin, (UiControl)tab);
        ui.UiWindowSetMargined(mainWin, 1);

        ui.UiTabAppend(tab, "Basic Controls", MakeBasicControlsPage());
    	ui.UiTabSetMargined(tab, 0, 1);
    
    	ui.UiTabAppend(tab, "Numbers and Lists", MakeNumbersPage());
    	ui.UiTabSetMargined(tab, 1, 1);
    
    	ui.UiTabAppend(tab, "Data Choosers", MakeDataChoosersPage());
    	ui.UiTabSetMargined(tab, 2, 1);

        ui.UiControlShow((UiControl)mainWin);
        ui.UiMain();
        ui.UiUninit();
        return 0;
    }

    #region control events
    static int32 OnClosing(__IntPtr w, __IntPtr data)
    {
        ui.UiQuit();
        return 1;
    }

    static void OpenClicked(__IntPtr item, __IntPtr w, __IntPtr data)
    {
        var wind = UiWindow.FromInternalPtr(w);
    	var filename = ui.UiOpenFile(wind);
    	if (filename == null) {
    		ui.UiMsgBoxError(mainWin, "No file selected", "Don't be alarmed!");
    		return;
    	}
    	ui.UiMsgBox(mainWin, "File selected", filename);
    	ui.UiFreeText(filename);
    }

    static void OpenFolderClicked(__IntPtr item, __IntPtr w, __IntPtr data)
    {
    	var filename = ui.UiOpenFolder(mainWin);
    	if (filename == null) {
    		ui.UiMsgBoxError(mainWin, "No folder selected", "Don't be alarmed!");
    		return;
    	}
    	ui.UiMsgBox(mainWin, "Folder selected", filename);
    	ui.UiFreeText(filename);
    }

    static void SaveClicked(__IntPtr item, __IntPtr w, __IntPtr data)
    {
    	var filename = ui.UiSaveFile(mainWin);
    	if (filename == null) {
    		ui.UiMsgBoxError(mainWin, "No file selected", "Don't be alarmed!");
    		return;
    	}
    	ui.UiMsgBox(mainWin, "File selected (don't worry, it's still there)", filename);
    	ui.UiFreeText(filename);
    }

    static int32 ShouldQuit(__IntPtr data)
    {
    	var win = UiWindow.FromInternalPtr(data);
        ui.UiControlDestroy((UiControl)win);
        return 1;
    }

    static void OnSpinboxChanged(__IntPtr s, __IntPtr data)
    {
        var sb = UiSpinbox.FromInternalPtr(s);
        ui.UiSliderSetValue(slider, ui.UiSpinboxValue(sb));
        ui.UiProgressBarSetValue(pbar, ui.UiSpinboxValue(sb));
    }

    static void OnSliderChanged(__IntPtr s, __IntPtr data)
    {
        var sl = UiSlider.FromInternalPtr(s);
        ui.UiSpinboxSetValue(spinbox, ui.UiSliderValue(sl));
    	ui.UiProgressBarSetValue(pbar, ui.UiSliderValue(sl));
    }

    static void OnOpenFileClicked(__IntPtr b, __IntPtr data)
    {
    	var entry = UiEntry.FromInternalPtr(data);
    	var filename = ui.UiOpenFile(mainWin);
    	if (filename == null) {
    		ui.UiEntrySetText(entry, "(cancelled)");
    		return;
    	}
    	ui.UiEntrySetText(entry, filename);
    	ui.UiFreeText(filename);
    }

    static void OnOpenFolderClicked(__IntPtr b, __IntPtr data)
    {
    	var entry = UiEntry.FromInternalPtr(data);

    	var filename = ui.UiOpenFolder(mainWin);
    	if (filename == null) {
    		ui.UiEntrySetText(entry, "(cancelled)");
    		return;
    	}
    	ui.UiEntrySetText(entry, filename);
        ui.UiFreeText(filename);
    }

    static void OnSaveFileClicked(__IntPtr b, __IntPtr data)
    {
    	var entry = UiEntry.FromInternalPtr(data);

    	var filename = ui.UiSaveFile(mainWin);
    	if (filename == null) {
    		ui.UiEntrySetText(entry, "(cancelled)");
    		return;
    	}
        ui.UiEntrySetText(entry, filename);
        ui.UiFreeText(filename);
    }

    static void OnMsgBoxClicked(__IntPtr b, __IntPtr data)
    {
    	ui.UiMsgBox(mainWin,
    		"This is a normal message box.",
    		"More detailed information can be shown here.");
    }

    static void OnMsgBoxErrorClicked(__IntPtr b, __IntPtr data)
    {
    	ui.UiMsgBoxError(mainWin,
    		"This message box describes an error.",
    		"More detailed information can be shown here.");
    }
    #endregion
}