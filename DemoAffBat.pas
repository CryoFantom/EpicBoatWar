program DemoAffBateaux;

uses commun, affichage, Crt;

var joueur1, joueur2: Joueur;
	game: Jeu;


begin
	joueur1.nbBateaux:=1;
	joueur2.nbBateaux:=1;
	game.joueur1joue:= true;
	joueur2.boat[1].pos[1].x:=2;
	joueur2.boat[1].pos[1].y:=2;
	joueur2.boat[1].pos[2].x:=3;
	joueur2.boat[1].pos[2].y:=2;
	joueur1.boat[1].pos[1].x:=4;
	joueur1.boat[1].pos[1].y:=4;
	joueur1.boat[1].pos[2].x:=3;
	joueur1.boat[1].pos[2].y:=4;
	joueur1.boat[1].taille:=2;
	joueur2.boat[1].taille:=2;
	joueur2.boat[1].detecte:=true;
	affBateaux(game, joueur1, joueur2);
end.
