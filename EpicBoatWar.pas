program EpicBoatWar;

uses commun, generation, tour, choix, affichage;

var	joueur1,joueur2:PJoueur;
	game:PJeu;
	veutJouer:Boolean;
	
begin
		New(game);
		New(joueur1);
		New(joueur2);
		
		menu(joueur1^.nom,joueur2^.nom,veutJouer);
		
		if veutJouer then
		begin
			genGrille(game,joueur1,joueur2);
			changementJoueur(game^.joueur1Joue,joueur1^.nom,joueur2^.nom);
			repeat //pour chaque tour
				unTour(game,joueur1,joueur2);
			until (joueur1^.nbBateaux=0) or (joueur2^.nbBateaux=0);
			finJeu(joueur1,joueur2);
		end;
end.
