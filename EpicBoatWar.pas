program EpicBoatWar;

uses commun, generation, tour;

var	joueur1,joueur2:PJoueur;
	game:PJeu;
	
begin
		New(game);
		New(joueur1);
		New(joueur2);
		genGrille(game,joueur1,joueur2);
		
	repeat //pour chaque tour
		unTour(game,joueur1,joueur2);
	until (joueur1^.nbBateaux=0) or (joueur2^.nbBateaux=0);
	
end.
