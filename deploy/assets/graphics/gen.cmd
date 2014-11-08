@echo off
set out_file=../AssetsAuto.as
set path = C:/Shared/Work/svn/CH400646_-_Appetite/deploy/assets/graphics/*
echo     // script generated file 							> %out_file%
echo		package assets 								>> %out_file% >> %out_file%						
echo		{									>> %out_file% >> %out_file%	
echo			import com.p3.bundles.P3InternalBundle;				>> %out_file% >> %out_file%	
echo			public class AssetsAuto extends P3InternalBundle  		>> %out_file% >> %out_file%	
echo			{ 								>> %out_file% >> %out_file%
for /d %%x in (C:/Shared/Work/svn/CH400646_-_Appetite/deploy/assets/graphics/* *.png) do for /f %%a IN ('dir %%x /b  *.png') do ( 
echo     	[Embed^(source="graphics/%%~nx/%%a"^)] public var img_%%~na:Class; >> %out_file% >> %out_file%)	
echo				public function AssetsAuto() 				>> %out_file% >> %out_file%
echo				{							>> %out_file% >> %out_file%
echo					super();					>> %out_file% >> %out_file%
echo				}							>> %out_file% >> %out_file%
echo			} 								>> %out_file% >> %out_file%	
echo		} 									>> %out_file% >> %out_file%

