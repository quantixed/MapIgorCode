#pragma TextEncoding = "MacRoman"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Function MakeJSONFromFuncFile()
	CoastClear()
	
	LoadWave/Q/O/J/V={"\t","",0,0}/K=2/A=colW/L={0,0,0,0,0} "funcfile.txt"
	NewPath/O/Q/Z diskFolder, S_path
	
	WAVE/Z/T colW0,colW1
	Sort colW0,colW0,colW1
	Variable nProcs = numpnts(colW0)
	String ipfName = "", funcName = ""
	
	KillWindow/Z funcBook
	NewNotebook/F=0/N=funcBook
	String wSpace = ""
	
	Variable i
	
	for(i = 0; i < nProcs; i += 1)
		if(i == 0)
			// open with
			Notebook funcBook, text="{\r"
			wSpace += " "
			Notebook funcBook, text=wSpace, text="\"name\": \"Functions\",\r"
			Notebook funcBook, text=wSpace, text="\"children\": [\r"
			wSpace += " "
		endif
		ipfName = colW0[i]
		funcName = colW1[i]
		if(i == 0)
			// write the first node
			Notebook funcBook, text=wSpace, text="{\r"
			wSpace += " "
			Notebook funcBook, text=wSpace, text="\"name\": \"", text=ipfName, text="\",\r"
			Notebook funcBook, text=wSpace, text="\"children\": [\r"
			wSpace += " "
		endif
		if(i > 0 && cmpstr(ipfName, colw0[i-1]) != 0)
			// write subsequent nodes
			Notebook funcBook, text=wSpace, text="{\r"
			wSpace += " "
			Notebook funcBook, text=wSpace, text="\"name\": \"", text=ipfName, text="\",\r"
			Notebook funcBook, text=wSpace, text="\"children\": [\r"
			wSpace += " "
//			Notebook funcBook, text=wSpace, text="{\"name\": \"", text=funcName, text="\"},\r"
		endif
		if(i < nProcs - 1 && cmpstr(ipfName, colw0[i+1]) == 0)
			// write the child
			Notebook funcBook, text=wSpace, text="{\"name\": \"", text=funcName, text="\"},\r"
		elseif(i < nProcs - 1 && cmpstr(ipfName, colw0[i+1]) != 0)
			Notebook funcBook, text=wSpace, text="{\"name\": \"", text=funcName, text="\"}\r"
			wSpace = RemoveEnding(wSpace)
			Notebook funcBook, text=wSpace, text="]\r"
			wSpace = RemoveEnding(wSpace)
			Notebook funcBook, text=wSpace, text="},\r"
		endif
		// now at the end
		if(i == nProcs - 1)
			Notebook funcBook, text=wSpace, text="{\"name\": \"", text=funcName, text="\"}\r"
			wSpace = RemoveEnding(wSpace)
			Notebook funcBook, text=wSpace, text="]\r"
			wSpace = RemoveEnding(wSpace)
			Notebook funcBook, text=wSpace, text="}\r"
		endif
	endfor
	wSpace = RemoveEnding(wSpace)
	Notebook funcBook, text=wSpace, text="]\r"
	Notebook funcBook, text="}"
	SaveNotebook/P=diskFolder funcBook as "funcMap.json"
End


///////////////////////////////////////////////
Function CoastClear()
	String fullList = WinList("*", ";","WIN:3")
	Variable allItems = ItemsInList(fullList)
	String name
	Variable i
 
	for(i = 0; i < allItems; i += 1)
		name = StringFromList(i, fullList)
		DoWindow/K $name		
	endfor
	
	// Look for data folders
	DFREF dfr = GetDataFolderDFR()
	allItems = CountObjectsDFR(dfr, 4)
	for(i = 0; i < allItems; i += 1)
		name = GetIndexedObjNameDFR(dfr, 4, i)
		KillDataFolder $name		
	endfor
	
	KillWaves/A/Z
End