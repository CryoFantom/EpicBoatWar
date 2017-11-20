program EpicBoatWar;

uses commun, generation, calcul, affichage, choix;

var game:Jeu;
	joueur1,joueur2 : Joueur;
	saisie:Action;
	nbBateaux:Integer;
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
		if game.joueur1joue then nbBateaux:=joueur1.nbBateaux else nbBateaux:=joueur2.nbBateaux;
		repeat //jusqu'à ce que le joueur ait déplacé tous ses bateaux ou qu'il veuille terminer son tour
			affichageDebutTour (game, joueur1, joueur2);
			affBateaux(game,joueur1,joueur2); //!
			affInfosJeu(game.joueur1joue,joueur1,joueur2); //!
			choixBateau (game.joueur1Joue,joueur1,joueur2,saisie);
			
			if saisie.nature<>finTour then
			begin
				repeat //pour chaque déplacement
					affichageJeu(game,saisie.boat, joueur1, joueur2);
					affBateaux(game,joueur1,joueur2); //!
					affInfosJeu(game.joueur1joue,joueur1,joueur2); //!
					repeat
						controle(saisie)
					 until saisie.nature<>nonValide;
					gestionDeplacement (game, saisie, joueur1, joueur2);
				until ((saisie.statut=overquota) or saisie.boat.coule or (saisie.nature=finDeplacement));
				nbBateaux:=nbBateaux-1;
				if nbBateaux=0 then saisie.nature:=finTour;
			end;
		until (saisie.nature=finTour);
		
		saisie.nature:=nonValide; //reset saisie.nature
		changementJoueur(game.joueur1Joue); 
		
	until (joueur1.nbBateaux=0) or (joueur2.nbBateaux=0);
end.
