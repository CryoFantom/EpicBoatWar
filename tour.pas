unit tour;

interface

uses commun, affichage, choix, calcul;

procedure unTour (var game : PJeu; var joueur1, joueur2 : PJoueur);

implementation

procedure unTour (var game : PJeu; var joueur1, joueur2 : PJoueur);

var saisie:PAction;
	nbBateaux:Integer;
	
begin
	New(saisie);
//déplacement	
	resetQuota (joueur1,joueur2);
	if game^.joueur1joue then nbBateaux:=joueur1^.nbBateaux else nbBateaux:=joueur2^.nbBateaux;
	repeat //jusqu'à ce que le joueur ait déplacé tous ses bateaux ou qu'il veuille terminer son tour
		affichageDebutTour (game, joueur1, joueur2);
		saisie^.nature:=deplacement;
		choixBateau (game^.joueur1Joue,nbBateaux,joueur1,joueur2,game,saisie);
		if saisie^.nature<>finTour then
		begin
			repeat //pour chaque déplacement
				affichageDepl(game,saisie^.boat, joueur1, joueur2);
				repeat
					choixDeplacement(saisie)
				 until saisie^.nature<>nonValide;
				gestionDeplacement (game, saisie, joueur1, joueur2,nbBateaux);
			until ((saisie^.statut=overquota) or saisie^.boat.coule or (saisie^.nature=finDeplacement));
			nbBateaux:=nbBateaux-1;
			affichageDepl(game,saisie^.boat, joueur1, joueur2);	
			if nbBateaux=0 then saisie^.nature:=finTour;
		end;
	until (saisie^.nature=finTour);
//tir
	majProchainTir(game^.joueur1joue,joueur1,joueur2,nbBateaux);
	if nbBateaux>0 then 
	repeat //jusqu'à ce que le joueur ait fait tirer tous ses bateaux ou qu'il veuille terminer son tour
		affichageDebutTour (game, joueur1, joueur2);
		saisie^.nature:=tir;
		choixBateau (game^.joueur1Joue,nbBateaux,joueur1,joueur2,game,saisie);
		if saisie^.nature<>finTour then
		begin
			repeat //pour chaque tir
				affichageTir(game,saisie^.boat, joueur1, joueur2);
				choixTir(saisie);
				//gestionTir (game, saisie, joueur1, joueur2,nbBateaux);
				saisie^.statut:=allowed; //en attendant l'implémentation de gestionTir
			until ((saisie^.statut=allowed) or (saisie^.nature=finTir));
			nbBateaux:=nbBateaux-1;
			if nbBateaux=0 then saisie^.nature:=finTour;
		end;
	until (saisie^.nature=finTour);
		
	saisie^.nature:=nonValide; //reset saisie.nature
	changementJoueur(game^.joueur1Joue);
	Dispose(saisie);
end;

begin
end.
