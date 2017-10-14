program EpicBoatWar;

uses commun, crt, generation, calcul, affichage, keyboard;

var i: Integer;
var game:Jeu;
	K : TKeyEvent;
	joueur1,joueur2 : Joueur;
	saisie:String;
	choix:Action;
	
begin
	writeln('Merci de mettre la fenêtre en plein écran');
	
	//création d'un bateau au milieu de l'écran
		joueur1.boat[1].taille:=5;
		for i:=1 to joueur1.boat[1].taille do
			begin
			joueur1.boat[1].pos[i].y:=25;
			joueur1.boat[1].pos[i].x:=70+i;
			end;
		Joueur1.boat[1].tir.distance:=10;
		joueur1.boat[1].detection.distance:=20;
		joueur1.boat[1].deplacement.distance:=30;
		game.joueur1Joue:=True;
		joueur1.nbBateaux:=1;
		joueur2.nbBateaux:=0;
		joueur1.boat[1].sens:=O;
		joueur1.boat[1].quota:=150;
		
		genObstacles(game.grille, game.montagne, game.recifs);
		
repeat
		clrscr;
		
		affZone(joueur1.boat[1],True);
		
		affObstacle (game.montagne, game.recifs);
		
		affBateaux(game,joueur1,joueur2);
		
		GotoXY(TAILLE_X-70,TAILLE_Y+1);
		write('Quota de déplacement : ',joueur1.boat[1].quota:3:2);
		
		choix.boat:=joueur1.boat[1];
		GotoXY(1,TAILLE_Y+1);
		write('Utilisez les flèches pour déplacer le bateau');
		InitKeyboard;
		K:=GetKeyEvent;
		K:=TranslateKeyEvent(K);
		saisie:=KeyEventToString(K);
		DoneKeyboard;
		if (saisie='Right') or (saisie='Up') then choix.coord.x:=1;
		if (saisie='Left') or (saisie='Down') then choix.coord.x:=-1;
		
		if (saisie='Right') or (saisie='Left') then choix.nature:=rotation;
		if (saisie='Up') or (saisie='Down') then choix.nature:=deplacement;
		
		gestionDeplacement (choix, game, 1, joueur1, joueur2);
	
	until (choix.statut=overquota);
end.
