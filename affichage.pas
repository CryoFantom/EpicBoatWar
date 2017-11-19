unit affichage;

interface 

uses commun,Crt,keyboard;

procedure affichageJeu (game:Jeu; boat:Bateau; joueur1, joueur2: Joueur);
procedure affBateaux  (game: Jeu; joueur1, joueur2: Joueur);
procedure affInfosJeu (joueur1joue: Boolean; joueur1, joueur2: Joueur);
procedure affichageDebutTour (game:Jeu; joueur1, joueur2: Joueur);
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

procedure affBateaux  (game: Jeu; joueur1, joueur2: Joueur);

var i,j:Integer;

begin
	if game.joueur1Joue then
	begin
		for i:=1 to joueur1.nbBateaux do
		begin
			GotoXY(joueur1.boat[i].pos[1].x,joueur1.boat[i].pos[1].y);
			textcolor(blue);
			textbackground(White);
			write('P');
			j:=2;
			repeat
				GotoXY(joueur1.boat[i].pos[j].x,joueur1.boat[i].pos[j].y);
				write('B');
				j:=j+1;
			until j= joueur1.boat[i].taille+1;
		end;
	for i:=1 to joueur2.nbBateaux do
		begin
			if joueur2.boat[i].detecte then
				begin
				GotoXY(joueur2.boat[i].pos[1].x,joueur2.boat[i].pos[1].y);
				textcolor(red);
				textbackground(White);
				write('P');
				j:=2;
				repeat
					GotoXY(joueur2.boat[i].pos[j].x,joueur2.boat[i].pos[j].y);
					write('B');
					j:=j+1;
				until j= joueur2.boat[i].taille+1;
				end;
		end;	
	end
	else
	begin
		for i:=1 to joueur2.nbBateaux do
		begin
			GotoXY(joueur2.boat[i].pos[1].x,joueur2.boat[i].pos[1].y);
			textcolor(blue);
			textbackground(White);
			write('P');
			j:=2;
			repeat
				GotoXY(joueur2.boat[i].pos[j].x,joueur2.boat[i].pos[j].y);
				write('B');
				j:=j+1;
			until j= joueur2.boat[i].taille+1;
		end;
	for i:=1 to joueur1.nbBateaux do
		begin
			if joueur1.boat[i].detecte then
				begin
				GotoXY(joueur1.boat[i].pos[1].x,joueur1.boat[i].pos[1].y);
				textcolor(red);
				textbackground(White);
				write('P');
				j:=2;
				repeat
					GotoXY(joueur1.boat[i].pos[j].x,joueur1.boat[i].pos[j].y);
					write('B');
					j:=j+1;
				until j= joueur1.boat[i].taille+1;
				end;
		end;
	end;
	textbackground(Black);
	textcolor(White);
	GotoXY(1,TAILLE_Y+1);
end;


procedure affZone (boat: Bateau);

var i : Integer;

begin 
	//déplacement
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

procedure affInfosJeu (joueur1joue: Boolean; joueur1, joueur2: Joueur);
var i,j: integer;

begin
	GotoXY(TAILLE_X+1,1);
	writeln(joueur1.nom);
	j:=1;
	i:=2;
	repeat
		GotoXY(TAILLE_X+1,i);
		writeln(joueur1.boat[j].nom,' ',joueur1.boat[j].ptDeVie,' PV');
		i:=i+1;
		j:=j+1;
	until j=joueur1.nbBateaux+1;
	i:=i+2;
	GotoXY(TAILLE_X+1,i);
	writeln(joueur2.nom);
	i:=i+1;
	j:=1;
	repeat
		GotoXY(TAILLE_X+1,i);
		writeln(joueur2.boat[j].nom,' ',joueur2.boat[j].ptDeVie,' PV');
		i:=i+1;
		j:=j+1;
	until j=joueur2.nbBateaux+1;

	GotoXY(1,TAILLE_Y+1);
end;

procedure affichageJeu (game:Jeu; boat:Bateau; joueur1, joueur2: Joueur);

begin
		clrscr;
		affZone(boat);
		affObstacle (game.montagne, game.recifs);
		//affBateaux(game,joueur1,joueur2);
		//affInfosJeu(game.joueur1joue,joueur1,joueur2);
		
		GotoXY(TAILLE_X+1,30);
		write('Quota de déplacement : ');
		GotoXY(TAILLE_X+1,31);
		write(boat.quota:3:2);
end;

procedure affichageDebutTour (game:Jeu; joueur1, joueur2: Joueur);

begin
		clrscr;
		affObstacle (game.montagne, game.recifs);
		//affBateaux(game,joueur1,joueur2);
		//affInfosJeu(game.joueur1joue,joueur1,joueur2);
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
