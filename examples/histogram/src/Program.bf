using libui;
using System;

namespace histogram;

class Program
{
    static UiWindow mainwin;
    static UiArea histogram;
    static UiAreaHandler handler;
    static UiSpinbox[10] datapoints;
    static UiColorButton colorButton;
    static int currentPoint = -1;

    // some metrics
    const double xoffLeft = 20;			/* histogram margins */
    const double yoffTop = 20;
    const double xoffRight = 20;
    const double yoffBottom = 20;
    const double pointRadius = 5;

    // helper to quickly set a brush color
    static void SetSolidBrush(UiDrawBrush brush, uint32 color, double alpha)
    {
    	uint8 component;

    	brush.Type = (uint32)UiDrawBrushType.UiDrawBrushTypeSolid;
    	component = (uint8) ((color >> 16) & 0xFF);
    	brush.R = ((double) component) / 255;
    	component = (uint8) ((color >> 8) & 0xFF);
    	brush.G = ((double) component) / 255;
    	component = (uint8) (color & 0xFF);
    	brush.B = ((double) component) / 255;
    	brush.A = alpha;
    }

    // and some colors
    // names and values from https://msdn.microsoft.com/en-us/library/windows/desktop/dd370907%28v=vs.85%29.aspx
    const uint32 colorWhite = 0xFFFFFF;
    const uint32 colorBlack = 0x000000;
    const uint32 colorDodgerBlue = 0x1E90FF;

    static void PointLocations(double width, double height, double[] xs, double[] ys)
    {
    	double xincr, yincr;
    	int i, n;

    	xincr = width / 9;		// 10 - 1 to make the last point be at the end
    	yincr = height / 100;

    	for (i = 0; i < 10; i++) {
    		// get the value of the point
    		n = ui.UiSpinboxValue(datapoints[i]);
    		// because y=0 is the top but n=0 is the bottom, we need to flip
    		n = 100 - n;
    		xs[i] = xincr * i;
    		ys[i] = yincr * n;
    	}
    }

    static UiDrawPath ConstructGraph(double width, double height, int extend)
    {
    	UiDrawPath path;
        var xs = scope double[10];
        var ys = scope double[10];
    	int i;

    	PointLocations(width, height, xs, ys);

    	path = ui.UiDrawNewPath((uint32)UiDrawFillMode.UiDrawFillModeWinding);

    	ui.UiDrawPathNewFigure(path, xs[0], ys[0]);
    	for (i = 1; i < 10; i++)
    		ui.UiDrawPathLineTo(path, xs[i], ys[i]);

    	if (extend != 0) {
    		ui.UiDrawPathLineTo(path, width, height);
    		ui.UiDrawPathLineTo(path, 0, height);
    		ui.UiDrawPathCloseFigure(path);
    	}

    	ui.UiDrawPathEnd(path);
    	return path;
    }

    static void GraphSize(double clientWidth, double clientHeight, out double graphWidth, out double graphHeight)
    {
    	graphWidth = clientWidth - xoffLeft - xoffRight;
    	graphHeight = clientHeight - yoffTop - yoffBottom;
    }

    static void HandlerDraw(__IntPtr p_a, __IntPtr p_area, __IntPtr p_p)
    {
        var p = UiAreaDrawParams.FromInternalPtr(p_p);

    	UiDrawPath path;
    	UiDrawBrush brush = scope UiDrawBrush();
    	UiDrawStrokeParams sp = scope UiDrawStrokeParams();
    	UiDrawMatrix m = scope UiDrawMatrix();
    	double graphWidth, graphHeight;
    	double graphR = 0, graphG = 0, graphB = 0, graphA = 0;

    	// fill the area with white
    	SetSolidBrush(brush, colorWhite, 1.0);
    	path = ui.UiDrawNewPath((uint32)UiDrawFillMode.UiDrawFillModeWinding);
    	ui.UiDrawPathAddRectangle(path, 0, 0, p.AreaWidth, p.AreaHeight);
    	ui.UiDrawPathEnd(path);
    	ui.UiDrawFill(p.Context, path, brush);
    	ui.UiDrawFreePath(path);

    	// figure out dimensions
    	GraphSize(p.AreaWidth, p.AreaHeight, out graphWidth, out graphHeight);

    	// clear sp to avoid passing garbage to uiDrawStroke()
    	// for example, we don't use dashing
    	Internal.MemSet(sp.__Instance, 0, sizeof(UiDrawStrokeParams.__Internal));

    	// make a stroke for both the axes and the histogram line
    	sp.Cap = (uint32)UiDrawLineCap.UiDrawLineCapFlat;
    	sp.Join = (uint32)UiDrawLineJoin.UiDrawLineJoinMiter;
    	sp.Thickness = 2;
    	sp.MiterLimit = 10.0; //(uint32)UiDrawDefaultMiterLimit;

    	// draw the axes
    	SetSolidBrush(brush, colorBlack, 1.0);
    	path = ui.UiDrawNewPath((uint32)UiDrawFillMode.UiDrawFillModeWinding);
    	ui.UiDrawPathNewFigure(path,
    		xoffLeft, yoffTop);
    	ui.UiDrawPathLineTo(path,
    		xoffLeft, yoffTop + graphHeight);
    	ui.UiDrawPathLineTo(path,
    		xoffLeft + graphWidth, yoffTop + graphHeight);
    	ui.UiDrawPathEnd(path);
    	ui.UiDrawStroke(p.Context, path, brush, sp);
    	ui.UiDrawFreePath(path);

    	// now transform the coordinate space so (0, 0) is the top-left corner of the graph
    	ui.UiDrawMatrixSetIdentity(m);
    	ui.UiDrawMatrixTranslate(m, xoffLeft, yoffTop);
    	ui.UiDrawTransform(p.Context, m);

    	// now get the color for the graph itself and set up the brush
    	ui.UiColorButtonColor(colorButton, ref graphR, ref graphG, ref graphB, ref graphA);
    	brush.Type = (uint32)UiDrawBrushType.UiDrawBrushTypeSolid;
    	brush.R = graphR;
    	brush.G = graphG;
    	brush.B = graphB;
    	// we set brush->A below to different values for the fill and stroke

    	// now create the fill for the graph below the graph line
    	path = ConstructGraph(graphWidth, graphHeight, 1);
    	brush.A = graphA / 2;
    	ui.UiDrawFill(p.Context, path, brush);
    	ui.UiDrawFreePath(path);

    	// now draw the histogram line
    	path = ConstructGraph(graphWidth, graphHeight, 0);
    	brush.A = graphA;
    	ui.UiDrawStroke(p.Context, path, brush, sp);
    	ui.UiDrawFreePath(path);

    	// now draw the point being hovered over
    	if (currentPoint != -1) {
            var xs = scope double[10];
    		var ys = scope double[10];

    		PointLocations(graphWidth, graphHeight, xs, ys);
    		path = ui.UiDrawNewPath((uint32)UiDrawFillMode.UiDrawFillModeWinding);
    		ui.UiDrawPathNewFigureWithArc(path,
    			xs[currentPoint], ys[currentPoint],
    			pointRadius,
    			0, 6.23,		// TODO pi
    			0);
    		ui.UiDrawPathEnd(path);
    		// use the same brush as for the histogram lines
    		ui.UiDrawFill(p.Context, path, brush);
    		ui.UiDrawFreePath(path);
    	}
    }

    static bool InPoint(double x, double y, double xtest, double ytest)
    {
    	// TODO switch to using a matrix
        var x, y;
    	x -= xoffLeft;
    	y -= yoffTop;
    	return (x >= xtest - pointRadius) &&
    		(x <= xtest + pointRadius) &&
    		(y >= ytest - pointRadius) &&
    		(y <= ytest + pointRadius);
    }

    static void HandlerMouseEvent(__IntPtr p_a, __IntPtr p_area, __IntPtr p_e)
    {
        var e = UiAreaMouseEvent.FromInternalPtr(p_e);
    	double graphWidth, graphHeight;
        var xs = scope double[10];
        var ys = scope double[10];
    	int i;

    	GraphSize(e.AreaWidth, e.AreaHeight, out graphWidth, out graphHeight);
    	PointLocations(graphWidth, graphHeight, xs, ys);

    	for (i = 0; i < 10; i++)
    		if (InPoint(e.X, e.Y, xs[i], ys[i]))
    			break;
    	if (i == 10)		// not in a point
    		i = -1;

    	currentPoint = i;
    	// TODO only redraw the relevant area
    	ui.UiAreaQueueRedrawAll(histogram);
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

    static void OnDatapointChanged(__IntPtr s, __IntPtr data)
    {
    	ui.UiAreaQueueRedrawAll(histogram);
    }

    static void OnColorChanged(__IntPtr b, __IntPtr data)
    {
    	ui.UiAreaQueueRedrawAll(histogram);
    }

    static int32 OnClosing(__IntPtr w, __IntPtr data)
    {
    	ui.UiControlDestroy((UiControl)mainwin);
    	ui.UiQuit();
    	return 0;
    }

    static int32 ShouldQuit(__IntPtr data)
    {
    	ui.UiControlDestroy((UiControl)mainwin);
    	return 1;
    }

    static int Main()
    {
        var o = scope UiInitOptions();
        UiBox hbox, vbox;
        int i;
        UiDrawBrush brush = scope UiDrawBrush();

        handler = scope UiAreaHandler();
        handler.Draw = scope => HandlerDraw;
        handler.MouseEvent = scope => HandlerMouseEvent;
        handler.MouseCrossed = scope => HandlerMouseCrossed;
        handler.DragBroken = scope => HandlerDragBroken;
        handler.KeyEvent = scope => HandlerKeyEvent;

        var err = ui.UiInit(o);
        if (err != null) {
            Console.Error.WriteLine("Error initializing libui-ng: {0}", scope String(err));
         	ui.UiFreeInitError(err);
        	return 1;
        }

        ui.UiOnShouldQuit(scope => ShouldQuit, null);

        mainwin = ui.UiNewWindow("libui Histogram Example", 640, 480, 1);
        ui.UiWindowSetMargined(mainwin, 1);
        ui.UiWindowOnClosing(mainwin, scope => OnClosing, null);

        hbox = ui.UiNewHorizontalBox();
        ui.UiBoxSetPadded(hbox, 1);
        ui.UiWindowSetChild(mainwin, (UiControl)hbox);

        vbox = ui.UiNewVerticalBox();
        ui.UiBoxSetPadded(vbox, 1);
        ui.UiBoxAppend(hbox, (UiControl)vbox, 0);

        //srand(time(NULL));
        for (i = 0; i < 10; i++) {
        	datapoints[i] = ui.UiNewSpinbox(0, 100);
        	ui.UiSpinboxSetValue(datapoints[i], scope Random().NextI32() % 101);
        	ui.UiSpinboxOnChanged(datapoints[i], scope => OnDatapointChanged, null);
        	ui.UiBoxAppend(vbox, (UiControl)datapoints[i], 0);
        }

        colorButton = ui.UiNewColorButton();
        // TODO inline these
        SetSolidBrush(brush, colorDodgerBlue, 1.0);
        ui.UiColorButtonSetColor(colorButton,
        	brush.R,
        	brush.G,
        	brush.B,
        	brush.A);
        ui.UiColorButtonOnChanged(colorButton, scope => OnColorChanged, null);
        ui.UiBoxAppend(vbox, (UiControl)colorButton, 0);

        histogram = ui.UiNewArea(handler);
        ui.UiBoxAppend(hbox, (UiControl)histogram, 1);

        ui.UiControlShow((UiControl)mainwin);
        ui.UiMain();
        ui.UiUninit();
        return 0;
    }
}