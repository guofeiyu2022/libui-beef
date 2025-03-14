namespace libui
{
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
