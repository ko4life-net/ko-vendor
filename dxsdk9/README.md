# DirectX 9 SDK and Runtime dlls

Portable DirectX 9 June 2010 SDK extracted from the lastest 9.29.1962.1 release: https://www.microsoft.com/en-us/download/details.aspx?id=6812

Note that additionally I added to the `bin` directory the runtime dlls that matches with the June 2010 SDK libs, so that if one didn't already install the redistributables, Visual Studio debugger will use them from within the `bin` directory. These runtime dlls originally downloaded from here: https://www.microsoft.com/en-us/download/details.aspx?id=8109

but can also be found under the Redist directory from the DirectX 9 June 2010 SDK archive. Ideally one should install the redistributables as other old DirectX 9 games may need it on the system, but it is added here as well just for simplifying the setup. The dlls in the `bin` dir will be picked up unless the application can't find it in the system.
