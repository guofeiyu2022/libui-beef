using libui;
using System;
using System.Collections;
namespace edittable;

class Program
{
    class Data
    {
        public struct Rgba
        {
        	public double r, g, b, a;
            public this(double e_r, double e_g, double e_b, double e_a)
            {
                r = e_r;
                g = e_g;
                b = e_b;
                a = e_a;
            }
        }

        public class Row
        {
        	public String rowxx ~ delete _;
        	public String partEditable ~ delete _;
        	public Rgba bgColor;
        	public Rgba textColor;
        	public UiImage image;
        	public int checkbox;
        	public int progress;
        }

    	public int numRows => rows.Count;
    	public List<Row> rows = new List<Row>() ~ DeleteContainerAndItems!(_);
    }

    enum MCOL {
    	MCOL_ROWXX,
    	MCOL_PART,
    	MCOL_PART_EDITABLE,
    	MCOL_BG_COLOR,
    	MCOL_TEXT_COLOR,
    	MCOL_IMAGE,
    	MCOL_BUTTON_TEXT,
    	MCOL_CHECKBOX,
    	MCOL_PROGRESS,
    	MCOL_SIZE
    }

    static UiImage[2] img;
    static UiEntry input;
    static UiEntry col1Text;
    static UiTableModel m;
    static Data data;
    static UiTableModelHandler mh;

    static int32 ModelNumColumns(__IntPtr mh, __IntPtr m)
    {
    	return (int32)MCOL.MCOL_SIZE;
    }

    static uint32 ModelColumnType(__IntPtr mh, __IntPtr m, int32 column)
    {
    	switch ((MCOL)column)
        {
    		case MCOL.MCOL_ROWXX:
    		case MCOL.MCOL_PART:
    		case MCOL.MCOL_PART_EDITABLE:
    		case MCOL.MCOL_BUTTON_TEXT:
    			return (uint32)UiTableValueType.UiTableValueTypeString;
    		case MCOL.MCOL_BG_COLOR:
    		case MCOL.MCOL_TEXT_COLOR:
    			return (uint32)UiTableValueType.UiTableValueTypeColor;
    		case MCOL.MCOL_IMAGE:
    			return (uint32)UiTableValueType.UiTableValueTypeImage;
    		case MCOL.MCOL_CHECKBOX:
    		case MCOL.MCOL_PROGRESS:
    			return (uint32)UiTableValueType.UiTableValueTypeInt;
    		default:
    	}
        return 0;
    }

    static int32 ModelNumRows(__IntPtr mh, __IntPtr m)
    {
    	return (int32)data.numRows;
    }

    static __IntPtr ModelCellValue(__IntPtr mh, __IntPtr m, int32 row, int32 column)
    {
        UiTableValue ret = null;
    	switch ((MCOL)column) {
    		case MCOL.MCOL_ROWXX:
    			ret = ui.UiNewTableValueString(data.rows[row].rowxx);
    		case MCOL.MCOL_PART:
    			ret = ui.UiNewTableValueString("Part");
    		case MCOL.MCOL_PART_EDITABLE:
    			ret = ui.UiNewTableValueString(data.rows[row].partEditable);
    		case MCOL.MCOL_BG_COLOR:
    			if (data.rows[row].bgColor.a == 0)
    				ret = null;
    			else
    				ret = ui.UiNewTableValueColor(data.rows[row].bgColor.r, data.rows[row].bgColor.g,
    					data.rows[row].bgColor.b, data.rows[row].bgColor.a);
    		case MCOL.MCOL_TEXT_COLOR:
    			if (data.rows[row].textColor.a == 0)
    				ret = null;
    			else
    				ret = ui.UiNewTableValueColor(data.rows[row].textColor.r, data.rows[row].textColor.g,
    					data.rows[row].textColor.b, data.rows[row].textColor.a);
    		case MCOL.MCOL_IMAGE:
    			ret = ui.UiNewTableValueImage(data.rows[row].image);
    		case MCOL.MCOL_BUTTON_TEXT:
    			ret = ui.UiNewTableValueString("Make Yellow");
    		case MCOL.MCOL_CHECKBOX:
    			ret = ui.UiNewTableValueInt((int32)data.rows[row].checkbox);
    		case MCOL.MCOL_PROGRESS:
    			ret = ui.UiNewTableValueInt((int32)data.rows[row].progress);
    		default:
    	}

        return ret == null ? null : ret.__Instance;
    }

    static void ModelSetCellValue(__IntPtr mh, __IntPtr p_m, int32 row, int32 column, __IntPtr p_val)
    {
    	var yellow = Data.Rgba(1, 1, 0, 1);
        var val = UiTableValue.FromInternalPtr(p_val);
        var m = UiTableModel.FromInternalPtr(p_m);

    	switch ((MCOL)column) {
    		case MCOL.MCOL_CHECKBOX:
    			data.rows[row].checkbox = ui.UiTableValueInt(val);
    			return;
    		case MCOL.MCOL_PART_EDITABLE:
                delete data.rows[row].partEditable;
    			data.rows[row].partEditable = new String(ui.UiTableValueString(val));
    			return;
    		case MCOL.MCOL_BUTTON_TEXT:
    			data.rows[row].bgColor = yellow;
    			ui.UiTableModelRowChanged(m, row);
    			return;
    		default:
    	}
    }

    static void PopulateRow(int row, String text)
    {
    	var purple = Data.Rgba(0.5, 0, 0.75, 1);
    	var transparent = Data.Rgba(0, 0, 0, 0);

    	data.rows[row].rowxx = text;
    	data.rows[row].partEditable = new String("Editable");
    	data.rows[row].bgColor = transparent;
    	data.rows[row].textColor = (row%2 ==1) ? purple : transparent;
    	data.rows[row].image = (row/10%2 == 1) ? img[0] : img[1];
    	data.rows[row].checkbox = 0;
    	data.rows[row].progress = scope Random().NextI32() % 101;
    }

    static void PopulateData()
    {
    	var numRows = 10;
    	for (int row = 0; row < numRows; ++row) {
            var item = new Data.Row();
            data.rows.Add(item);
    		PopulateRow(row, new $"Row {row}");
    	}
    }

    static void InsertRow(__IntPtr b, __IntPtr _data)
    {
    	var text = ui.UiEntryText(input);

    	int32 index;
        if (!(int32.Parse(StringView(text)) case .Ok(out index)))
            index = 0;
    	ui.UiFreeText(text);

    	if (index < 0 || index > data.numRows)
    		return;

        data.rows.Insert(index, new Data.Row());

    	text = ui.UiEntryText(col1Text);
    	PopulateRow(index, new String(text));
    	ui.UiFreeText(text);

    	ui.UiTableModelRowInserted(m, index);
    }

    static void DeleteRow(__IntPtr b, __IntPtr _data)
    {
    	var text = ui.UiEntryText(input);
        int32 index;
    	if (!(int32.Parse(StringView(text)) case .Ok(out index)))
	        index = 0;
    	ui.UiFreeText(text);

    	if (index < 0 || index >= data.numRows)
    		return;

        var row =  data.rows[index];
        data.rows.RemoveAt(index);
        delete row;

    	ui.UiTableModelRowDeleted(m, index);
    }

    static UiBox MakePage()
    {
    	UiTableParams p = scope UiTableParams();
    	UiTableTextColumnOptionalParams tp = scope UiTableTextColumnOptionalParams();

        var images = scope Images();
    	img[0] = ui.UiNewImage(16, 16);
        images.appendImageNamed(img[0], "andlabs_16x16test_24june2016.png");
        images.appendImageNamed(img[0], "andlabs_32x32test_24june2016.png");
    	img[1] = ui.UiNewImage(16, 16);
    	images.appendImageNamed(img[1], "tango-icon-theme-0.8.90_16x16_x-office-spreadsheet.png");
    	images.appendImageNamed(img[1], "tango-icon-theme-0.8.90_32x32_x-office-spreadsheet.png");

    	var page = ui.UiNewVerticalBox();
    	var controls = ui.UiNewHorizontalBox();
        ui.UiBoxAppend(page, (UiControl)controls, 0);
    	input = ui.UiNewEntry();
    	ui.UiEntrySetText(input, "Index #");
    	ui.UiBoxAppend(controls, (UiControl)input, 0);
    	col1Text = ui.UiNewEntry();
    	ui.UiEntrySetText(col1Text, "Column 1 Text");
    	ui.UiBoxAppend(controls, (UiControl)col1Text, 0);
    	var insert = ui.UiNewButton("Insert");
    	ui.UiButtonOnClicked(insert, scope => InsertRow, null);
    	ui.UiBoxAppend(controls, (UiControl)insert, 0);
    	var @delete = ui.UiNewButton("Delete");
    	ui.UiButtonOnClicked(@delete, scope => DeleteRow, null);
    	ui.UiBoxAppend(controls, (UiControl)@delete, 0);

    	PopulateData();

    	m = ui.UiNewTableModel(mh);

    	p.Model = m;
    	p.RowBackgroundColorModelColumn = 3;
    	var t = ui.UiNewTable(p);
    	ui.UiBoxAppend(page, (UiControl)t, 1);

    	ui.UiTableAppendTextColumn(t, "Column 1",
    		0,  ui.UiTableModelColumnNeverEditable, null);

    	tp.ColorModelColumn = 4;
    	ui.UiTableAppendImageTextColumn(t, "Column 2",
    		5,
    		1, ui.UiTableModelColumnNeverEditable, tp);
    	ui.UiTableAppendTextColumn(t, "Editable",
    		2, ui.UiTableModelColumnAlwaysEditable, null);

    	ui.UiTableAppendCheckboxColumn(t, "Checkboxes",
    		7, ui.UiTableModelColumnAlwaysEditable);
    	ui.UiTableAppendButtonColumn(t, "Buttons",
    		6, ui.UiTableModelColumnAlwaysEditable);

    	ui.UiTableAppendProgressBarColumn(t, "Progress Bar",
    		8);

    	var t2 = ui.UiNewTable(p);
    	ui.UiBoxAppend(page, (UiControl)t2, 1);
    	ui.UiTableAppendTextColumn(t2, "Column 1",
    		0, ui.UiTableModelColumnNeverEditable, null);
    	ui.UiTableAppendImageTextColumn(t2, "Column 2",
    		5,
    		1, ui.UiTableModelColumnNeverEditable, tp);
    	ui.UiTableAppendTextColumn(t2, "Editable",
    		2, ui.UiTableModelColumnAlwaysEditable, null);
    	ui.UiTableAppendCheckboxColumn(t2, "Checkboxes",
    		7, ui.UiTableModelColumnAlwaysEditable);

    	return page;
    }

    static int32 OnClosing(__IntPtr w, __IntPtr data)
    {
    	ui.UiQuit();
    	return 1;
    }

    static int Main()
    {
        mh = scope UiTableModelHandler();
        mh.NumColumns = scope => ModelNumColumns;
        mh.ColumnType = scope => ModelColumnType;
        mh.NumRows = scope => ModelNumRows;
        mh.CellValue = scope => ModelCellValue;
        mh.SetCellValue = scope => ModelSetCellValue;

        data = scope Data();

        var o = scope UiInitOptions();
        var err = ui.UiInit(o);
        if (err != null) {
            Console.Error.WriteLine("Error initializing libui-ng: {0}", scope String(err));
         	ui.UiFreeInitError(err);
        	return 1;
        }

        var w = ui.UiNewWindow("Editable Table", 800, 480, 1);
        ui.UiWindowOnClosing(w, scope => OnClosing, null);

        var mainBox = ui.UiNewHorizontalBox();
        ui.UiWindowSetChild(w, (UiControl)mainBox);

        var page = MakePage();
        ui.UiBoxAppend(mainBox, (UiControl)page, 1);

        ui.UiControlShow((UiControl)w);
        ui.UiMain();
        ui.UiFreeTableModel(m);
        ui.UiFreeImage(img[1]);
        ui.UiFreeImage(img[0]);
        ui.UiUninit();
        return 0;
    }
}