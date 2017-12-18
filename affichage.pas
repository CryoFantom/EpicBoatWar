unit affichage;

interface 

uses commun,Crt,keyboard;

procedure affBateaux  (game: PJeu; joueur1, joueur2: PJoueur);
procedure affichageJeu (game:PJeu; saisie:PAction; joueur1, joueur2: PJoueur);
procedure changementJoueur(var joueur1Joue : Boolean; nomJ1,nomJ2 : String);
procedure finJeu(joueur1,joueur2:PJoueur);
procedure reglesDuJeu();
procedure credits();

implementation

procedure reglesDuJeu();
begin
begin
	ClrScr;
	writeln('Règles du jeu :');
	writeln('Pour gagner la partie détruisez tous les bateaux de votre adversaire, pour cela utilisez votre artillerie ou bien lancez vos navires contre ceux de votre adversaire,  tous les coups sont permis !');
	writeln(' ');
	writeln('Informations utiles :');
	writeln('Votre flotte est composée de :');
	writeln('- 1 cuirassé');
	writeln('- 1 croiseur lourd');
	writeln('- 2 destroyers');
	writeln('- 2 croiseurs légers');
	writeln('Chacune de ces 4 classes de navires a des caractéristiques différentes :');
	writeln('Les cuirassés mesurent 5 cases, ont: 9 PV, 6 de dégât, 4 tours de temps de rechargement, une distance de détection de 35 cases, une distance de déplacement de 30 cases et une distance de tir de 25 cases');
	writeln('Les croiseurs lourds mesurent 4 cases, ont: 7 PV, 4 de dégât, 3 tours de temps de rechargement, une distance de détection de 40 cases, une distance de déplacement de 35 cases et une distance de tir de 20 cases');
	writeln('Les croiseurs légers mesurent 3 cases, ont: 6 PV, 3 de dégât, 2 tours de temps de rechargement, une distance de détection de 50 cases, une distance de déplacement de 40 cases et une distance de tir de 15 cases');
	writeln('Les destroyers mesurent 2 cases, ont: 4 PV, 2 de dégât, 1 tours de temps de rechargement, une distance de détection de 60 cases, une distance de déplacement de 45 cases et une distance de tir de 10 cases');
	writeln(' ');
	writeln('Utilisez le terrain à votre avantage, les montagnes (#) bloquent la vision et les tirs et les récifs (*) empêchent les bateaux de se déplacer mais ne bloquent ni la vision ni les tirs.');
	writeln(' ');
	writeln('Le tour se découpe en deux phases, une phase de déplacement et une phase de tir.');
	writeln(' ');
	writeln('Phase de déplacement :');
	writeln('- Utilisez les flèches droite et gauche afin de sélectionner le bateau que vous voulez déplacer puis valider avec la touche « Entrer ».');
	writeln('- Utilisez les flèches directionnelles pour orienter et déplacer votre bateaux (attention toute collision avec des bateaux de votre flotte entraînera une perte de PV).');
	writeln('Pour terminer le déplacement d’un bateau ou terminer la phase de tir appuyez sur « T ».');
	writeln(' ');
	writeln('Phase de tir :');
	writeln('- Utilisez les flèches droite et gauche afin de sélectionner le bateau avec lequel vous voulez tirer puis validez avec la touche « Entrer ».');
	writeln('- Utilisez les flèches directionnelles pour déplacer le curseur et appuyez sur « Entrer » pour tirer. Pour annuler le tir appuyez sur « T » (cela ne déclenchera pas le rechargement de votre navire).');
	writeln('Pour terminer la phase de tir appuyez sur « T ».');
	writeln(' ');
	writeln('Appuyez sur Entrer pour revenir au menu');
end;	
end;

procedure credits();
begin
	ClrScr;
	GoToXY(trunc(TAILLE_X*0.4),trunc(TAILLE_Y/2));
	write('Bientôt disponible !');
end;

procedure finJeu(joueur1,joueur2:PJoueur);
begin
	GoToXY(trunc(TAILLE_X*0.4),trunc(TAILLE_Y/2));
	if (joueur1^.nbBateaux=0) and (joueur2^.nbBateaux=0) then write ('Égalité !');
	if (joueur1^.nbBateaux=0) and (joueur2^.nbBateaux<>0) then write (joueur2^.nom,' a gagné !');
	if (joueur2^.nbBateaux=0) and (joueur1^.nbBateaux<>0)then write(joueur1^.nom,' a gagné !');
	GoToXY(trunc(TAILLE_X*0.4),trunc(TAILLE_Y/2)+2);
	write(joueur1^.nom,' : ',joueur1^.score,' pts');
	GoToXY(trunc(TAILLE_X*0.4),trunc(TAILLE_Y/2)+4);
	write(joueur2^.nom,' : ',joueur2^.score,' pts');
end;

procedure PVtoColor(touche, coule: Boolean);
begin
		textbackground(Black);			
		if coule then textcolor(Red)
			else textcolor(White);
		if touche and not(coule) then textbackground(Yellow)
			else if not(coule) then textbackground(Green);
end;

procedure affObstacle ( montagne, recif: Obstacle);

var i: Integer;

begin
	for i:=1 to montagne.npos do
		begin
			GotoXY(montagne.tab[i].x,montagne.tab[i].y);
			writeln('#');
		end;
	for i:=1 to recif.npos do
		begin
			GotoXY(recif.tab[i].x,recif.tab[i].y);
			writeln('*');
		end;
	GotoXY(1,TAILLE_Y+1);
end;

procedure affBateaux  (game: PJeu; joueur1, joueur2: PJoueur);

var i,j:Integer;
	joueur,adversaire:PJoueur;

begin
	if game^.joueur1joue then joueur:=joueur1 else joueur:=joueur2;
	if game^.joueur1joue then adversaire:=joueur2 else adversaire:=joueur1;
	
	for i:=1 to NBOAT do
	begin
		GotoXY(joueur^.boat[i].pos[1].x,joueur^.boat[i].pos[1].y);
		PVtoColor(joueur^.boat[i].touche, joueur^.boat[i].coule);
		write('O');
		j:=2;
		repeat
			GotoXY(joueur^.boat[i].pos[j].x,joueur^.boat[i].pos[j].y);
			write('B');
			j:=j+1;
		until j= joueur^.boat[i].taille+1;
		end;
		
	for i:=1 to NBOAT do
	begin
		if adversaire^.boat[i].detecte[0] then
		begin
			GotoXY(adversaire^.boat[i].pos[1].x,adversaire^.boat[i].pos[1].y);
			textcolor(red);
			if adversaire^.boat[i].coule then textbackground(Black)
				else textbackground(White);
			write('O');
			j:=2;
			repeat
				GotoXY(adversaire^.boat[i].pos[j].x,adversaire^.boat[i].pos[j].y);
				write('X');
				j:=j+1;
			until j= adversaire^.boat[i].taille+1;
		end;
	end;
	
	textbackground(Black);
	textcolor(White);
	GotoXY(1,TAILLE_Y+1);
end;


procedure affZone (boat: Bateau; deplacement, detection, tir : Boolean);

var i,j : Integer;
	ordre : Boolean;

begin 
	//détection
	if detection then
	for i:=1 to boat.detection.nbCases do
		begin
		GotoXY(boat.detection.tabZone[i].x,boat.detection.tabZone[i].y);
		if boat.detection.tabZone[i].visible then
			begin
			TextBackground(Blue);
			write(' ');
			end;
		end;
	
	if boat.quota<boat.tir.distance then ordre:=False {deplacement affiché sur tir} else ordre:=True {tir affiché sur deplacement};
	
	for j:=1 to 2 do
	begin
		//déplacement
		if deplacement and ordre then
		for i:=1 to boat.deplacement.nbCases do
			begin
			GotoXY(boat.deplacement.tabZone[i].x,boat.deplacement.tabZone[i].y);
			if boat.deplacement.tabZone[i].visible then
				begin
				TextBackground(Green);
				write(' ');
				end;
			end;
		
		//tir
		if tir and not(ordre) then
		for i:=1 to boat.tir.nbCases do
			begin
			GotoXY(boat.tir.tabZone[i].x,boat.tir.tabZone[i].y);
			if boat.tir.tabZone[i].visible then
				begin
				TextBackground(Red);
				write(' ');
				end;
			end;
		TextBackground(Black);
		
		if ordre then ordre:=False else ordre:=True;
	end;
	GotoXY(1,TAILLE_Y+1);
end;

procedure affInfosJeu (joueur1joue: Boolean; joueur1, joueur2: PJoueur);
var i,j: integer;

begin
	GotoXY(TAILLE_X+1,1);
	writeln(joueur1^.nom,' - score : ',joueur1^.score,' pts');
	j:=1;
	i:=2;
	for j:=1 to NBOAT do
	begin
		GotoXY(TAILLE_X+1,i);
		PVtoColor(joueur1^.boat[j].touche,joueur1^.boat[j].coule);
		write(joueur1^.boat[j].nom);
		textbackground(Black);
		textcolor(white);
		GotoXY(TAILLE_X+18,i);
		if joueur1^.boat[j].coule then writeln(' coulé !') 
		else case joueur1^.boat[j].prochainTir of 
				0: write(' ',joueur1^.boat[j].ptDeVie,' PV', ' - tir disponible');
				1: write(' ',joueur1^.boat[j].ptDeVie,' PV',' - tir dans 1 tour');
				2,3,4,5: write(' ',joueur1^.boat[j].ptDeVie,' PV',' - tir dans ',joueur1^.boat[j].prochainTir,' tours');
			end;
			i:=i+1;
		end;
	i:=i+2;
	GotoXY(TAILLE_X+1,i);
	writeln(joueur2^.nom,' - score : ',joueur2^.score,' pts');
	i:=i+1;
	j:=1;
	for j:=1 to NBOAT do
	begin
		GotoXY(TAILLE_X+1,i);
		PVtoColor(joueur2^.boat[j].touche,joueur2^.boat[j].coule);
		write(joueur2^.boat[j].nom);
		textbackground(Black);
		textcolor(white);
		GotoXY(TAILLE_X+18,i);
		if joueur2^.boat[j].coule then writeln(' coulé !') 
		else case joueur2^.boat[j].prochainTir of 
				0: write(' ',joueur2^.boat[j].ptDeVie,' PV', ' - tir disponible');
				1: write(' ',joueur2^.boat[j].ptDeVie,' PV',' - tir dans 1 tour');
				2,3,4: write(' ',joueur2^.boat[j].ptDeVie,' PV',' - tir dans ',joueur2^.boat[j].prochainTir,' tours');
			end;
		i:=i+1;
	end;
			
	GotoXY(1,TAILLE_Y+1);
end;

procedure affichageJeu (game:PJeu; saisie:PAction; joueur1, joueur2: PJoueur);

begin
		textcolor(White);
		clrscr;
		case saisie^.nature of
			deplacement,rotation : if saisie^.boat.quota>0 then affZone(saisie^.boat,True,True,True);
			tir : if saisie^.boat.peutTirer then affZone(saisie^.boat,False,True,True);
		end;
		affObstacle (game^.montagne, game^.recifs);
		affBateaux(game,joueur1,joueur2);
		affInfosJeu(game^.joueur1joue,joueur1,joueur2);
		
		if (((saisie^.nature=deplacement) or (saisie^.nature=rotation)) and (saisie^.boat.quota>0)) then
		begin
			GotoXY(TAILLE_X+1,30);
			write('Quota de déplacement : ');
			GotoXY(TAILLE_X+1,31);
			write(saisie^.boat.quota:3:2);
		end;
end;

procedure changementJoueur(var joueur1Joue : Boolean; nomJ1,nomJ2 : String);

var K : TKeyEvent;

begin
	if joueur1Joue then joueur1Joue:=False else joueur1Joue:=True; 
	
	clrscr;
	GotoXY(trunc(TAILLE_X/2-5),trunc(TAILLE_Y/2));
	if joueur1Joue then write(nomJ1) else write(nomJ2);
	GotoXY(trunc(TAILLE_X/2-15),trunc(TAILLE_Y/2+1));
	write('Appuyez sur Entrée pour continuer');
	InitKeyboard;
	repeat
		K:=GetKeyEvent;
		K:=TranslateKeyEvent(K)
	until GetKeyEventCode(K)=7181;
	DoneKeyboard;
end;

begin
end.
