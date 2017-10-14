program EpicBoatWar;

uses commun, crt, generation, calcul, affichage;

var i: Integer;
var game:Jeu;
	joueur1,joueur2 : Joueur;
	saisie:Char;
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
		joueur1.boat[1].quota:=100;
		
repeat
		clrscr;
		
		write('Quota de déplacement : ',joueur1.boat[1].quota:3:2);
		
		affBateaux(game,joueur1,joueur2);
		
		choix.boat:=joueur1.boat[1];
		GotoXY(1,TAILLE_Y+1);
		write('Rotation bateau : D ou G / Déplacement bateau : A ou R ');
		readln(saisie);
		if (saisie='D') or (saisie='A') then choix.coord.x:=1;
		if (saisie='G') or (saisie='R') then choix.coord.x:=-1;
		
		if (saisie='D') or (saisie='G') then choix.nature:=rotation;
		if (saisie='A') or (saisie='R') then choix.nature:=deplacement;
		
		gestionDeplacement (choix, game, 1, joueur1, joueur2);

		clrscr;
		
		affBateaux(game,joueur1,joueur2);
		
		GotoXY(1,TAILLE_Y+1);	
	
	until (joueur1.boat[1].quota<=0) or (saisie='F');
end.
