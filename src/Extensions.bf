namespace libui
{
    extension ui
    {
        #region consts
        // This constant is provided because M_PI is nonstandard.
        // This comes from Go's math.Pi, which in turn comes from http://oeis.org/A000796.
        public const double UiPi = 3.14159265358979323846264338327950288419716939937510582097494459;

        // this is the default for botoh cairo and Direct2D (in the latter case, from the C++ helper functions)
        // Core Graphics doesn't explicitly specify a default, but NSBezierPath allows you to choose one, and this is the initial value
        // so we're good to use it too!
        public const double UiDrawDefaultMiterLimit = 10.0;

        /** Parameter to editable model columns to signify all rows are never editable. */
        public const int32 UiTableModelColumnNeverEditable = -1;

        /** Parameter to editable model columns to signify all rows are always editable. */
        public const int32 UiTableModelColumnAlwaysEditable = -2;
        #endregion
    }

    // refer to https://libui-ng.github.io/libui-ng/structui_control.html
    extension UiControl
    {
        private static TTo Cast<TTo, TFrom>(TFrom val)
        {
            var val;
            return *(TTo*)&val;
        }

        public static operator UiControl(UiBox val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiButton val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiCheckbox val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiColorButton val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiCombobox val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiDateTimePicker val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiEditableCombobox val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiEntry val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiFontButton val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiForm val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiGrid val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiGroup val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiLabel val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiMultilineEntry val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiProgressBar val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiRadioButtons val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiSeparator val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiSlider val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiSpinbox val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiTab val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiTable val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiWindow val)
        {
            var val;
            return Cast<UiControl...>(val);
        }

        public static operator UiControl(UiArea val)
        {
            var val;
            return Cast<UiControl...>(val);
        }
    }
}
