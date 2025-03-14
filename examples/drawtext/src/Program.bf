using libui;
using System;

namespace drawtext;

class Program
{
    static UiWindow mainwin;
    static UiArea area;
    static UiAreaHandler handler;
    static UiFontButton fontButton;
    static UiCombobox alignment;
    static UiCheckbox systemFont;

    static UiAttributedString attrstr;

    static void AppendWithAttribute(String what, UiAttribute attr, UiAttribute attr2)
    {
    	uint64 start, end;

    	start = ui.UiAttributedStringLen(attrstr);
    	end = start + (uint64)what.Length;
    	ui.UiAttributedStringAppendUnattributed(attrstr, what);
    	ui.UiAttributedStringSetAttribute(attrstr, attr, start, end);
    	if (attr2 != null)
    		ui.UiAttributedStringSetAttribute(attrstr, attr2, start, end);
    }

    static void MakeAttributedString()
    {
    	UiAttribute attr, attr2;
    	UiOpenTypeFeatures otf;

    	attrstr = ui.UiNewAttributedString(
    		"Drawing strings with libui is done with the uiAttributedString and uiDrawTextLayout objects.\n" +
    		"uiAttributedString lets you have a variety of attributes: ");

    	attr = ui.UiNewFamilyAttribute("Courier New");
    	AppendWithAttribute("font family", attr, null);
    	ui.UiAttributedStringAppendUnattributed(attrstr, ", ");

    	attr = ui.UiNewSizeAttribute(18);
    	AppendWithAttribute("font size", attr, null);
    	ui.UiAttributedStringAppendUnattributed(attrstr, ", ");

    	attr = ui.UiNewWeightAttribute((uint32)UiTextWeight.UiTextWeightBold);
    	AppendWithAttribute("font weight", attr, null);
    	ui.UiAttributedStringAppendUnattributed(attrstr, ", ");

    	attr = ui.UiNewItalicAttribute((uint32)UiTextItalic.UiTextItalicItalic);
    	AppendWithAttribute("font italicness", attr, null);
    	ui.UiAttributedStringAppendUnattributed(attrstr, ", ");

    	attr = ui.UiNewStretchAttribute((uint32)UiTextStretch.UiTextStretchCondensed);
    	AppendWithAttribute("font stretch", attr, null);
    	ui.UiAttributedStringAppendUnattributed(attrstr, ", ");

    	attr = ui.UiNewColorAttribute(0.75, 0.25, 0.5, 0.75);
    	AppendWithAttribute("text color", attr, null);
    	ui.UiAttributedStringAppendUnattributed(attrstr, ", ");

    	attr = ui.UiNewBackgroundAttribute(0.5, 0.5, 0.25, 0.5);
    	AppendWithAttribute("text background color", attr, null);
    	ui.UiAttributedStringAppendUnattributed(attrstr, ", ");


    	attr = ui.UiNewUnderlineAttribute((uint32)UiUnderline.UiUnderlineSingle);
    	AppendWithAttribute("underline style", attr, null);
    	ui.UiAttributedStringAppendUnattributed(attrstr, ", ");

    	ui.UiAttributedStringAppendUnattributed(attrstr, "and ");
    	attr = ui.UiNewUnderlineAttribute((uint32)UiUnderline.UiUnderlineDouble);
    	attr2 = ui.UiNewUnderlineColorAttribute((uint32)UiUnderlineColor.UiUnderlineColorCustom, 1.0, 0.0, 0.5, 1.0);
    	AppendWithAttribute("underline color", attr, attr2);
    	ui.UiAttributedStringAppendUnattributed(attrstr, ". ");

    	ui.UiAttributedStringAppendUnattributed(attrstr, "Furthermore, there are attributes allowing for ");
    	attr = ui.UiNewUnderlineAttribute((uint32)UiUnderline.UiUnderlineSuggestion);
    	attr2 = ui.UiNewUnderlineColorAttribute((uint32)UiUnderlineColor.UiUnderlineColorSpelling, 0, 0, 0, 0);
    	AppendWithAttribute("special underlines for indicating spelling errors", attr, attr2);
    	ui.UiAttributedStringAppendUnattributed(attrstr, " (and other types of errors) ");

    	ui.UiAttributedStringAppendUnattributed(attrstr, "and control over OpenType features such as ligatures (for instance, ");
    	otf = ui.UiNewOpenTypeFeatures();
    	ui.UiOpenTypeFeaturesAdd(otf, 'l', 'i', 'g', 'a', 0);
    	attr = ui.UiNewFeaturesAttribute(otf);
    	AppendWithAttribute("afford", attr, null);
    	ui.UiAttributedStringAppendUnattributed(attrstr, " vs. ");
    	ui.UiOpenTypeFeaturesAdd(otf, 'l', 'i', 'g', 'a', 1);
    	attr = ui.UiNewFeaturesAttribute(otf);
    	AppendWithAttribute("afford", attr, null);
    	ui.UiFreeOpenTypeFeatures(otf);
    	ui.UiAttributedStringAppendUnattributed(attrstr, ").\n");

    	ui.UiAttributedStringAppendUnattributed(attrstr, "Use the controls opposite to the text to control properties of the text.");
    }

    static void HandlerDraw(__IntPtr p_a, __IntPtr p_area, __IntPtr p_p)
    {
        var p = UiAreaDrawParams.FromInternalPtr(p_p);

    	UiDrawTextLayout textLayout;
    	UiFontDescriptor defaultFont = scope UiFontDescriptor();
    	UiDrawTextLayoutParams @params = scope UiDrawTextLayoutParams();
    	var useSystemFont = ui.UiCheckboxChecked(systemFont);

    	@params.String = attrstr;
    	if (useSystemFont > 0)
    		ui.UiLoadControlFont(defaultFont);
    	else
    		ui.UiFontButtonFont(fontButton, defaultFont);
    	@params.DefaultFont = defaultFont;
    	@params.Width = p.AreaWidth;
    	@params.Align = (uint32)ui.UiComboboxSelected(alignment);
    	textLayout = ui.UiDrawNewTextLayout(@params);
    	ui.UiDrawText(p.Context, textLayout, 0, 0);
    	ui.UiDrawFreeTextLayout(textLayout);

    	//TODO RENAME?
    	ui.UiFreeFontButtonFont(defaultFont);
    }

    static void HandlerMouseEvent(__IntPtr a, __IntPtr area, __IntPtr e)
    {
    	// do nothing
    }

    static void HandlerMouseCrossed(__IntPtr ah, __IntPtr a, int32 left)
    {
    	// do nothing
    }

    static void HandlerDragBroken(__IntPtr ah, __IntPtr a)
    {
    	// do nothing
    }

    static int32 HandlerKeyEvent(__IntPtr ah, __IntPtr a, __IntPtr e)
    {
    	// reject all keys
    	return 0;
    }

    static void OnFontChanged(__IntPtr b, __IntPtr data)
    {
    	ui.UiAreaQueueRedrawAll(area);
    }

    static void OnComboboxSelected(__IntPtr b, __IntPtr data)
    {
    	ui.UiAreaQueueRedrawAll(area);
    }

    static void OnCheckboxToggled(__IntPtr b, __IntPtr data)
    {
    	ui.UiAreaQueueRedrawAll(area);
    }

    static int32 OnClosing(__IntPtr w, __IntPtr data)
    {
    	ui.UiControlDestroy((UiControl)mainwin);
    	ui.UiQuit();
    	return 0;
    }

    static int32 ShouldQuit(void *data)
    {
    	ui.UiControlDestroy((UiControl)mainwin);
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

    	UiBox hbox, vbox;
    	UiForm form;

        handler = scope UiAreaHandler();
    	handler.Draw = scope => HandlerDraw;
    	handler.MouseEvent = scope => HandlerMouseEvent;
    	handler.MouseCrossed = scope => HandlerMouseCrossed;
    	handler.DragBroken = scope => HandlerDragBroken;
    	handler.KeyEvent = scope => HandlerKeyEvent;

    	ui.UiOnShouldQuit(scope => ShouldQuit, null);

    	MakeAttributedString();

    	mainwin = ui.UiNewWindow("libui Text-Drawing Example", 640, 480, 1);
    	ui.UiWindowSetMargined(mainwin, 1);
    	ui.UiWindowOnClosing(mainwin, scope => OnClosing, null);

    	hbox = ui.UiNewHorizontalBox();
    	ui.UiBoxSetPadded(hbox, 1);
    	ui.UiWindowSetChild(mainwin, (UiControl)hbox);

    	vbox = ui.UiNewVerticalBox();
    	ui.UiBoxSetPadded(vbox, 1);
    	ui.UiBoxAppend(hbox, (UiControl)vbox, 0);

    	fontButton = ui.UiNewFontButton();
    	ui.UiFontButtonOnChanged(fontButton, scope => OnFontChanged, null);
    	ui.UiBoxAppend(vbox, (UiControl)fontButton, 0);

    	form = ui.UiNewForm();
    	ui.UiFormSetPadded(form, 1);
    	// TODO on OS X if this is set to 1 then the window can't resize; does the form not have the concept of stretchy trailing space?
    	ui.UiBoxAppend(vbox, (UiControl)form, 0);

    	alignment = ui.UiNewCombobox();
    	// note that the items match with the values of the uiDrawTextAlign values
    	ui.UiComboboxAppend(alignment, "Left");
    	ui.UiComboboxAppend(alignment, "Center");
    	ui.UiComboboxAppend(alignment, "Right");
    	ui.UiComboboxSetSelected(alignment, 0);		// start with left alignment
    	ui.UiComboboxOnSelected(alignment, scope => OnComboboxSelected, null);
    	ui.UiFormAppend(form, "Alignment", (UiControl)alignment, 0);

    	systemFont = ui.UiNewCheckbox("");
    	ui.UiCheckboxOnToggled(systemFont, scope => OnCheckboxToggled, null);
    	ui.UiFormAppend(form, "System Font", (UiControl)systemFont, 0);

    	area = ui.UiNewArea(handler);
    	ui.UiBoxAppend(hbox, (UiControl)area, 1);

    	ui.UiControlShow((UiControl)mainwin);
    	ui.UiMain();
    	ui.UiFreeAttributedString(attrstr);
    	ui.UiUninit();
    	return 0;
    }
}