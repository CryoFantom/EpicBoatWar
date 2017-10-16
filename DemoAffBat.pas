program DemoAffBateaux;

uses commun, affichage, Crt;

var joueur1, joueur2: Joueur;
	game: Jeu;


begin
	joueur1.nbBateaux:=2;
	joueur2.nbBateaux:=2;
	game.joueur1joue:= false;
	joueur2.boat[1].pos[1].x:=2;
	joueur2.boat[1].pos[1].y:=2;
	joueur2.boat[1].pos[2].x:=3;
	joueur2.boat[1].pos[2].y:=2;
	joueur1.boat[1].pos[1].x:=1;
	joueur1.boat[1].pos[1].y:=1;
	joueur1.boat[1].pos[2].x:=1;
	joueur1.boat[1].pos[2].y:=2;
	joueur2.boat[2].pos[1].x:=6;
	joueur2.boat[2].pos[1].y:=6;
	joueur2.boat[2].pos[2].x:=6;
	joueur2.boat[2].pos[2].y:=7;
	joueur1.boat[2].pos[1].x:=5;
	joueur1.boat[2].pos[1].y:=1;
	joueur1.boat[2].pos[2].x:=5;
	joueur1.boat[2].pos[2].y:=2;
	joueur1.boat[1].taille:=2;
	joueur2.boat[1].taille:=2;
	joueur2.boat[2].taille:=2;
	joueur1.boat[2].taille:=2;
	joueur2.boat[1].detecte:=true;
	joueur2.boat[2].detecte:=true;
	joueur1.boat[1].detecte:=true;
	joueur1.boat[2].detecte:=true;
	affBateaux(game, joueur1, joueur2);
end.
