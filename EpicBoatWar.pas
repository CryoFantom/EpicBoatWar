program EpicBoatWar;

uses commun, generation, calcul, affichage, crt;

var game:Jeu;
	joueur1,joueur2 : Joueur;
	choix:Action;
	
begin
		genGrille(game,joueur1,joueur2);
		
		choix.boat:=joueur1.boat[1]; //en attendant que la procédure de choix du bateau soit développée ...
		
		choix.boat.quota:=choix.boat.deplacement.distance;
		calculZone(game,choix.boat);
		
	repeat //pour chaque déplacement
		affichageJeu(game,choix.boat, joueur1, joueur2);
		controle(choix);
		gestionDeplacement (game, choix, joueur1, joueur2);
	until (choix.statut=overquota);
end.
