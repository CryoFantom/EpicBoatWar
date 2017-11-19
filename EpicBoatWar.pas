program EpicBoatWar;

uses commun, generation, calcul, affichage, choix;

var game:Jeu;
	joueur1,joueur2 : Joueur;
	saisie:Action;
	i:Integer;
	
begin
		genGrille(game,joueur1,joueur2);
		
		//calcul des zones de chaque bateau
		for i:= 1 to NBOAT do //!
		begin
			calculZone(game,joueur1.boat[i]);
			calculZone(game,joueur2.boat[i]);
		end;
		
	repeat //pour chaque tour
			resetQuota (joueur1,joueur2);
			affichageDebutTour (game, joueur1, joueur2);
			affBateaux(game,joueur1,joueur2); //!
			affInfosJeu(game.joueur1joue,joueur1,joueur2); //!
			choixBateau (game.joueur1Joue,joueur1,joueur2,saisie);
			
		repeat //pour chaque déplacement
			affichageJeu(game,saisie.boat, joueur1, joueur2);
			affBateaux(game,joueur1,joueur2); //!
			affInfosJeu(game.joueur1joue,joueur1,joueur2); //!
			repeat
				controle(saisie)
			 until saisie.nature<>nonValide;
			gestionDeplacement (game, saisie, joueur1, joueur2);
		until ((saisie.statut=overquota) or saisie.boat.coule);
		
		changementJoueur(game.joueur1Joue); 
		
	until (joueur1.nbBateaux=0) or (joueur2.nbBateaux=0);
end.
