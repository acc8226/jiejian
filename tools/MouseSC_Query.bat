@Echo Off

Set tApp=MouseSC.exe
If Not %PROCESSOR_ARCHITECTURE% == x86 Set tApp=MouseSC_x64.exe

CD /D %~dp0\
If Not Exist "%tApp%" (
    Echo The file %tApp% was not found
	pause & exit
)

Call :Query /PrimaryButton
Echo Mouse Primary Button: %tRESULT%

Call :Query /Speed
Echo Mouse Speed: %tRESULT%

Call :Query /PointerPrecision
Echo Enhance Pointer Precision: %tRESULT%

Call :Query /VerticalScroll
Echo Mouse Vertical Scroll: %tRESULT%

Call :Query /HorizontalScroll
Echo Mouse Horizontal Scroll: %tRESULT%

:Query
for /f "tokens=*" %%q in ('"%tApp%" /Query %1') do set tRESULT=%%q
