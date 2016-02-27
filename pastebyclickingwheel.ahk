mousedrag_treshold := 20 ; en pixels

; On affecte le clic-molette à la fonction 'paste_selection'
Hotkey mbutton, paste_selection
; On désactive le clic-molette
Hotkey mbutton, off

/************************************************
	Sélection par clic gauche
***********************************************/
#IfWinNotActive ahk_class ConsoleWindowClass
~lButton::
	; Récupération des coordonnées de la souris
	MouseGetPos, mousedrag_x, mousedrag_y
	keywait lbutton
	mousegetpos, mousedrag_x2, mousedrag_y2
	; Si on fait une sélection d'au moins 20 pixels
	if (abs(mousedrag_x2 - mousedrag_x) > mousedrag_treshold
		or abs(mousedrag_y2 - mousedrag_y) > mousedrag_treshold)
	{
		; On récupère le nom de la fenêtre active
		wingetclass class, A
		; [DEBUGGING] Commenter la ligne suivante pour éviter d'avoir une pop-up à chaque clic
		;MsgBox %class%
		; On n'exécute pas la copie de la sélection si la fenêtre active est :
		;	Emacs | Git Bash | Barre des tâches Windows | PuTTY
		if (class <> "Emacs") and (class <> "mintty") and (class <> "TaskListThumbnailWnd") and (class <> "PuTTYConfigBox") and (class <> "PuTTY")
		{
			; On sauvegarde le contenu du clipboard
			clip_save := clipboard
			; On fait un Ctrl-C
			send, ^c
			; On sauvegarde la nouvelle valeur
			temp_clip := clipboard
			; On restaure le clipboard avant le Ctrl-C
			clipboard := clip_save
		}
		hotkey mbutton, on
	}
	return
#IfWinNotActive

/************************************************
	Collage par clic molette
***********************************************/
paste_selection:
	; Clic gauche pour pouvoir coller à l'endroit de la souris
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