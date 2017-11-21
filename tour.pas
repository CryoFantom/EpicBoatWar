unit tour;

interface

uses commun, affichage, choix, calcul;

procedure unTour (var game : PJeu; var joueur1, joueur2 : PJoueur);

implementation

procedure unTour (var game : PJeu; var joueur1, joueur2 : PJoueur);

var saisie:Action;
	nbBateaux:Integer;
	
begin
	resetQuota (joueur1,joueur2);
		if game^.joueur1joue then nbBateaux:=joueur1^.nbBateaux else nbBateaux:=joueur2^.nbBateaux;
		repeat //jusqu'à ce que le joueur ait déplacé tous ses bateaux ou qu'il veuille terminer son tour
			affichageDebutTour (game, joueur1, joueur2);
			choixBateau (game^.joueur1Joue,joueur1,joueur2,game,saisie);
			
			if saisie.nature<>finTour then
			begin
				repeat //pour chaque déplacement
					affichageJeu(game,saisie.boat, joueur1, joueur2);
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
		changementJoueur(game^.joueur1Joue); 
end;

begin
end.
