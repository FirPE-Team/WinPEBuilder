rem some features are dependence on this.
rem like: SnippingTool, TermService, etc.

rem use install.wim's ProductOptions (show version watermark on desktop)
call RegCopy HKLM\SYSTEM\ControlSet001\Control\ProductOptions
reg delete "HKLM\Tmp_SYSTEM\ControlSet001\Control\ProductOptions" /v OSProductContentId /f
reg delete "HKLM\Tmp_SYSTEM\ControlSet001\Control\ProductOptions" /v OSProductPfn /f
reg delete "HKLM\Tmp_SYSTEM\ControlSet001\Control\ProductOptions" /v SubscriptionPfnList /f

reg import ProductOptions.reg
