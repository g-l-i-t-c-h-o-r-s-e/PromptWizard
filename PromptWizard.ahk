;Pandela 2022
IgnoreAmount := 3 ;defalt amount of ignored tags
SetBatchLines,-1
#SingleInstance,Force
#IfWinActive,Prompt Wizard

DrawGui:
;=================
array := []
array2 := []
Element_Pos := 10
Element_Pos2 := 111
;=================

array :=  Clipboard ;"e621, explict content, ((wide shot)), detailed fur, digital media, female anthro, nude, oral, blowjob, oral creampie,rainbow neck fluff, [ahegao], open mouth, dark background, solo, cum, penis, pussy, balls, anus"
if !RegExMatch(array,", ") {
	msgbox, no prompt detected
	exitapp
}
array := StrSplit(array,",")


gui, +resize
Gui Font, s9, Segoe UI
loop % array.Length() {
	if (A_Index < 6) {
		
		Gui Add,CheckBox, y-20,
		Gui Add, Edit,w100 h20 vTag_%A_Index% +Center,% array[A_Index]
	}
	
	if (A_Index >= 6) && (A_Index < 11) {
		;msgbox % Element_Pos2
		Gui Add, Edit, x%Element_Pos% y27 w100 h20 vTag_%A_Index% +Center,% array[A_Index]
		Element_Pos := Element_Pos2 + Element_Pos
		continue
	}
	
	
	if (A_Index >= 11) && (A_Index < 16) {
		if (A_Index = 11) {
			Element_Pos := 10
			Element_Pos2 := 111		
		}
		
		Gui Add, Edit, x%Element_Pos% y57 w100 h20 vTag_%A_Index% +Center,% array[A_Index]
		Element_Pos := Element_Pos2 + Element_Pos
		continue
	}
	
	if (A_Index >= 16) && (A_Index < 21) {
		if (A_Index = 16) {
			Element_Pos := 10
			Element_Pos2 := 111		
		}
		
		Gui Add, Edit, x%Element_Pos% y87 w100 h20 vTag_%A_Index% +Center,% array[A_Index]
		Element_Pos := Element_Pos2 + Element_Pos
		continue
	}
	
}
Gui Add, Button, x10 vButtonz gClipBoardCopy, Copy Prompt To Clipboard

Gui Show,, Prompt Wizard
WinGetActiveStats,A,wid,hi,xx,yy
wid := wid - 35
GuiControl, Move, Buttonz, w%wid% ; set the width to the edit control whose associated variable is MyEdit to be that of the GUI which lunch the current thread
return


ClipboardCopy:
gui, Submit,NoHide
New_Prompt := ""

loop % array.Length() {
	New_Prompt .= Tag_%A_Index% ","
}
msgbox % New_Prompt
Clipboard := New_Prompt
Return


;Randomize Prompts
F2::
array2 := []
For each, item in sortArray(array,"Random") {
	array2.Push(item)
}

loop % array.Length() {
	if (A_Index > IgnoreAmount) {
	GuiControl,,Tag_%A_Index%,% array2[A_Index]
	}
}
return



;Update GUI with new prompt, from clipboard
F1::
Gui,Destroy
Gosub, DrawGui
Return

;Adjust amount of ignored tags
^Up::
IgnoreAmount := (IgnoreAmount + 1)
tooltip, Ignore Amount: %IgnoreAmount%
sleep, 400
tooltip
return

;Adjust amount of ignored tags
^Down::
IgnoreAmount := (IgnoreAmount - 1)
if (IgnoreAmount < 0) {
	IgnoreAmount := 0
}
tooltip, Ignore Amount: %IgnoreAmount%
sleep, 400
tooltip
return



;https://www.autohotkey.com/board/topic/93570-sortarray/
sortArray(arr,options="") {	; specify only "Flip" in the options to reverse otherwise unordered array items
	
	if	!IsObject(arr)
		return	0
	new :=	[]
	if	(options="Flip") {
		While	(i :=	arr.MaxIndex()-A_Index+1)
			new.Insert(arr[i])
		return	new
	}
	For each, item in arr
		list .=	item "`n"
	list :=	Trim(list,"`n")
	Sort, list, %options%
	Loop, parse, list, `n, `r
		new.Insert(A_LoopField)
	return	new
	
}