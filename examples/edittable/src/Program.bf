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
            public double R, G, B, A;
            public this(double e_r, double e_g, double e_b, double e_a)
            {
                R = e_r;
                G = e_g;
                B = e_b;
                A = e_a;
            }
        }

        public class Row
        {
            public String Rowxx ~ delete _;
            public String PartEditable ~ delete _;
            public Rgba BgColor;
            public Rgba TextColor;
            public UiImage Image;
            public int Checkbox;
            public int Progress;
        }

        public int NumRows => Rows.Count;
        public List<Row> Rows = new List<Row>() ~ DeleteContainerAndItems!(_);
    }

    enum MCOL
    {
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
            case MCOL.MCOL_ROWXX: fallthrough;
            case MCOL.MCOL_PART: fallthrough;
            case MCOL.MCOL_PART_EDITABLE: fallthrough;
            case MCOL.MCOL_BUTTON_TEXT:
                return (uint32)UiTableValueType.UiTableValueTypeString;
            case MCOL.MCOL_BG_COLOR: fallthrough;
            case MCOL.MCOL_TEXT_COLOR:
                return (uint32)UiTableValueType.UiTableValueTypeColor;
            case MCOL.MCOL_IMAGE:
                return (uint32)UiTableValueType.UiTableValueTypeImage;
            case MCOL.MCOL_CHECKBOX: fallthrough;
            case MCOL.MCOL_PROGRESS:
                return (uint32)UiTableValueType.UiTableValueTypeInt;
            default:
        }
        return 0;
    }

    static int32 ModelNumRows(__IntPtr mh, __IntPtr m)
    {
        return (int32)data.NumRows;
    }

    static __IntPtr ModelCellValue(__IntPtr mh, __IntPtr m, int32 row, int32 column)
    {
        UiTableValue ret = null;
        defer UiTableValue.Delete(ret);
        switch ((MCOL)column)
        {
            case MCOL.MCOL_ROWXX:
                ret = ui.UiNewTableValueString(data.Rows[row].Rowxx);
            case MCOL.MCOL_PART:
                ret = ui.UiNewTableValueString("Part");
            case MCOL.MCOL_PART_EDITABLE:
                ret = ui.UiNewTableValueString(data.Rows[row].PartEditable);
            case MCOL.MCOL_BG_COLOR:
                if (data.Rows[row].BgColor.A == 0)
                    ret = null;
                else
                    ret = ui.UiNewTableValueColor(data.Rows[row].BgColor.R, data.Rows[row].BgColor.G,
                        data.Rows[row].BgColor.B, data.Rows[row].BgColor.A);
            case MCOL.MCOL_TEXT_COLOR:
                if (data.Rows[row].TextColor.A == 0)
                    ret = null;
                else
                    ret = ui.UiNewTableValueColor(data.Rows[row].TextColor.R, data.Rows[row].TextColor.G,
                        data.Rows[row].TextColor.B, data.Rows[row].TextColor.A);
            case MCOL.MCOL_IMAGE:
                ret = ui.UiNewTableValueImage(data.Rows[row].Image);
            case MCOL.MCOL_BUTTON_TEXT:
                ret = ui.UiNewTableValueString("Make Yellow");
            case MCOL.MCOL_CHECKBOX:
                ret = ui.UiNewTableValueInt((int32)data.Rows[row].Checkbox);
            case MCOL.MCOL_PROGRESS:
                ret = ui.UiNewTableValueInt((int32)data.Rows[row].Progress);
            default:
        }

        return ret == null ? null : ret.__Instance;
    }

    static void ModelSetCellValue(__IntPtr mh, __IntPtr p_m, int32 row, int32 column, __IntPtr p_val)
    {
        var yellow = Data.Rgba(1, 1, 0, 1);
        var val = UiTableValue.FromInternalPtr(p_val);
        var m = UiTableModel.FromInternalPtr(p_m);

        switch ((MCOL)column)
        {
            case MCOL.MCOL_CHECKBOX:
                data.Rows[row].Checkbox = ui.UiTableValueInt(val);
                return;
            case MCOL.MCOL_PART_EDITABLE:
                delete data.Rows[row].PartEditable;
                data.Rows[row].PartEditable = new String(ui.UiTableValueString(val));
                return;
            case MCOL.MCOL_BUTTON_TEXT:
                data.Rows[row].BgColor = yellow;
                ui.UiTableModelRowChanged(m, row);
                return;
            default:
        }
    }

    static void PopulateRow(int row, String text)
    {
        var purple = Data.Rgba(0.5, 0, 0.75, 1);
        var transparent = Data.Rgba(0, 0, 0, 0);

        data.Rows[row].Rowxx = text;
        data.Rows[row].PartEditable = new String("Editable");
        data.Rows[row].BgColor = transparent;
        data.Rows[row].TextColor = (row%2 ==1) ? purple : transparent;
        data.Rows[row].Image = (row/10%2 == 1) ? img[0] : img[1];
        data.Rows[row].Checkbox = 0;
        data.Rows[row].Progress = scope Random().NextI32() % 101;
    }

    static void PopulateData()
    {
        var numRows = 10;
        for (int row = 0; row < numRows; ++row)
        {
            var item = new Data.Row();
            data.Rows.Add(item);
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

        if (index < 0 || index > data.NumRows)
            return;

        data.Rows.Insert(index, new Data.Row());

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

        if (index < 0 || index >= data.NumRows)
            return;

        var row =  data.Rows[index];
        data.Rows.RemoveAt(index);
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
        if (err != null)
        {
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