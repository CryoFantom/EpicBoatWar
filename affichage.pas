unit affichage;

interface 

uses commun,Crt,keyboard;

procedure affBateaux  (game: PJeu; joueur1, joueur2: PJoueur);
procedure affichageDebutTour (game:PJeu; joueur1, joueur2: PJoueur);
procedure affichageDepl (game:PJeu; boat:Bateau; joueur1, joueur2: PJoueur);
procedure affichageTir (game:PJeu; boat:Bateau; joueur1, joueur2: PJoueur);
procedure changementJoueur(var joueur1Joue : Boolean);

implementation

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
		textbackground(Black);			
		if joueur^.boat[i].coule then textcolor(Red)
			else textcolor(White);
		if (joueur^.boat[i].touche and not(joueur^.boat[i].coule)) then textbackground(Yellow)
			else if not(joueur^.boat[i].coule) then textbackground(Green);
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
		if adversaire^.boat[i].detecte then
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

var i : Integer;

begin 
	//déplacement
	if deplacement then
	for i:=1 to boat.deplacement.nbCases do
		begin
		GotoXY(boat.deplacement.tabZone[i].x,boat.deplacement.tabZone[i].y);
		if boat.deplacement.tabZone[i].visible then
			begin
			TextBackground(Green);
			write(' ');
			end;
		end;
	
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
	
	//tir
	if tir then
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
	GotoXY(1,TAILLE_Y+1);
end;

procedure affInfosJeu (joueur1joue: Boolean; joueur1, joueur2: PJoueur);
var i,j: integer;

begin
	GotoXY(TAILLE_X+1,1);
	writeln(joueur1^.nom);
	j:=1;
	i:=2;
	for j:=1 to NBOAT do
	begin
		GotoXY(TAILLE_X+1,i);
		if joueur1^.boat[j].coule then writeln(joueur1^.boat[j].nom,' coulé !') 
		else writeln(joueur1^.boat[j].nom,' ',joueur1^.boat[j].ptDeVie,' PV');
		i:=i+1;
	end;
	i:=i+2;
	GotoXY(TAILLE_X+1,i);
	writeln(joueur2^.nom);
	i:=i+1;
	j:=1;
	for j:=1 to NBOAT do
	begin
		GotoXY(TAILLE_X+1,i);
		if joueur2^.boat[j].coule then writeln(joueur2^.boat[j].nom,' coulé !')
		else writeln(joueur2^.boat[j].nom,' ',joueur2^.boat[j].ptDeVie,' PV');
		i:=i+1;
	end;
			
	GotoXY(1,TAILLE_Y+1);
end;

procedure affichageDepl (game:PJeu; boat:Bateau; joueur1, joueur2: PJoueur);

begin
		clrscr;
		affZone(boat,True,True,True);
		affObstacle (game^.montagne, game^.recifs);
		affBateaux(game,joueur1,joueur2);
		affInfosJeu(game^.joueur1joue,joueur1,joueur2);
		
		if boat.quota>0 then
		begin
			GotoXY(TAILLE_X+1,30);
			write('Quota de déplacement : ');
			GotoXY(TAILLE_X+1,31);
			write(boat.quota:3:2);
		end;
end;

procedure affichageTir (game:PJeu; boat:Bateau; joueur1, joueur2: PJoueur);

begin
		clrscr;
		affZone(boat,False,True,True);
		affObstacle (game^.montagne, game^.recifs);
		affBateaux(game,joueur1,joueur2);
		affInfosJeu(game^.joueur1joue,joueur1,joueur2);
end;

procedure affichageDebutTour (game:PJeu; joueur1, joueur2: PJoueur);

begin
		clrscr;
		affObstacle (game^.montagne, game^.recifs);
		affBateaux(game,joueur1,joueur2);
		affInfosJeu(game^.joueur1joue,joueur1,joueur2);
end;

procedure changementJoueur(var joueur1Joue : Boolean);

var K : TKeyEvent;

begin
	if joueur1Joue then joueur1Joue:=False else joueur1Joue:=True; 
	
	clrscr;
	GotoXY(trunc(TAILLE_X/2-5),trunc(TAILLE_Y/2));
	if joueur1Joue then write('Joueur 1') else write('Joueur 2');
	GotoXY(trunc(TAILLE_X/2-15),trunc(TAILLE_Y/2+1));
	write('Appuyez sur Entrer pour continuer');
	InitKeyboard;
	repeat
		K:=GetKeyEvent;
		K:=TranslateKeyEvent(K)
	until GetKeyEventCode(K)=7181;
	DoneKeyboard;
end;

begin
end.
