mousedrag_treshold := 20 ; en pixels
middleclick_available := 15 ; en secondes

; On affecte le clic-molette à la fonction 'paste_selection'
Hotkey mbutton, paste_selection
; On désactive le clic-molette
Hotkey mbutton, off


#IfWinNotActive ahk_class ConsoleWindowClass
~lButton::
	MouseGetPos, mousedrag_x, mousedrag_y
	keywait lbutton
	mousegetpos, mousedrag_x2, mousedrag_y2
	if (abs(mousedrag_x2 - mousedrag_x) > mousedrag_treshold
		or abs(mousedrag_y2 - mousedrag_y) > mousedrag_treshold)
	{
		wingetclass class, A
		MsgBox %class%
		if (class <> "Emacs") and (class <> "mintty") and (class <> "TaskListThumbnailWnd") and (class <> "PuTTYConfigBox") and (class <> "PuTTY")
		{
			; On sauvegarde le contenu du clipboard
			clip_save := clipboard
			; On fait un Ctrl-C
			send, ^c
			clipwait
			; On sauvegarde la nouvelle valeur
			temp_clip := clipboard 
			; On restaure le clipboard avant le Ctrl-C
			clipboard := clip_save
		}
		hotkey mbutton, on
	}
	return
#IfWinNotActive

paste_selection:
	sendinput {lbutton}
	WinGetClass class, A
	if (class <> "Emacs")
	{
		;On remplace le clipboard par le tampon
		clipboard := temp_clip
		; On fait Ctrl-V
		sendinput ^v
		; On restore le clipboard du Ctrl-C
		clipboard := clip_save
	}
	return