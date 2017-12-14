unit tour;

interface

uses commun, affichage, choix, calcul;

procedure unTour (var game : PJeu; var joueur1, joueur2 : PJoueur);

implementation

procedure unTour (var game : PJeu; var joueur1, joueur2 : PJoueur);

var saisie:PAction;
	nbBateauxDepl,nbBateauxTir,i:Integer;
	
begin
	New(saisie);
	resetQuota (game,joueur1,joueur2);
	majProchainTir(game^.joueur1joue,True,joueur1,joueur2,nbBateauxTir);
//déplacement	
	if game^.joueur1joue then nbBateauxDepl:=joueur1^.nbBateaux else nbBateauxDepl:=joueur2^.nbBateaux;
	repeat //jusqu'à ce que le joueur ait déplacé tous ses bateaux ou qu'il veuille terminer son tour
		affichageJeu (game, saisie, joueur1, joueur2);
		saisie^.nature:=deplacement;
		choixBateau (game^.joueur1Joue,nbBateauxDepl,joueur1,joueur2,game,saisie);
		if (saisie^.nature<>finTour) and (saisie^.statut<>overquota) then
		begin
			repeat //pour chaque déplacement
				affichageJeu (game,saisie, joueur1, joueur2);
				repeat
					choixDeplacement(saisie)
				until saisie^.nature<>nonValide;
				gestionDeplacement (game, saisie, joueur1, joueur2,nbBateauxDepl);
			until ((saisie^.statut=overquota) or saisie^.boat.coule or (saisie^.nature=finDeplacement));
			detect(joueur1,joueur2); //mise à jour de la détection pour tous les bateaux des deux joueurs
			nbBateauxDepl:=nbBateauxDepl-1;
			affichageJeu (game, saisie, joueur1, joueur2);	
			if nbBateauxDepl=0 then saisie^.nature:=finTour;
		end;
	until (saisie^.nature=finTour);
//tir
	majProchainTir(game^.joueur1joue,False,joueur1,joueur2,nbBateauxTir);
	if nbBateauxTir>0 then 
	repeat //jusqu'à ce que le joueur ait fait tirer tous ses bateaux ou qu'il veuille terminer son tour
		saisie^.statut:=allowed;
		affichageJeu (game, saisie, joueur1, joueur2);
		saisie^.nature:=tir;
		choixBateau (game^.joueur1Joue,nbBateauxTir,joueur1,joueur2,game,saisie);
		if saisie^.statut<>overquota then
		begin
			if (saisie^.nature=finTour) then 
			begin
				if game^.joueur1joue then
					for i:=1 to NBOAT do joueur1^.boat[i].prochainTir:=joueur1^.boat[i].prochainTir+1
				else
					for i:=1 to NBOAT do joueur2^.boat[i].prochainTir:=joueur2^.boat[i].prochainTir+1;
			end
			else
			begin
				repeat //pour chaque tir
					affichageJeu (game, saisie, joueur1, joueur2);
					choixTir(saisie);
					gestionTir (game, saisie, joueur1, joueur2, nbBateauxTir);
				until ((saisie^.statut=allowed) or (saisie^.statut=cancelled));
				nbBateauxTir:=nbBateauxTir-1;
				if nbBateauxTir<=0 then saisie^.nature:=finTour;
			end;
		end;
	until (saisie^.nature=finTour);
		
	saisie^.nature:=nonValide; //reset saisie.nature
	changementJoueur(game^.joueur1Joue);
	Dispose(saisie);
end;

begin
end.
