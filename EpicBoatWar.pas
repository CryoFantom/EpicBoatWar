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
		
	repeat //pour chaque déplacement
		saisie.boat:=joueur1.boat[1]; //en attendant que la procédure de saisie du bateau soit terminée
		saisie.noBateau:=1;
		affichageJeu(game,saisie.boat, joueur1, joueur2);
		affBateaux(game,joueur1,joueur2); //!
		affInfosJeu(game.joueur1joue,joueur1,joueur2); //!
		repeat
			controle(saisie)
		 until saisie.nature<>nonValide;
		gestionDeplacement (game, saisie, joueur1, joueur2);
	until (saisie.statut=overquota);
end.
