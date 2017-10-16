unit affichage;

interface 

uses commun,Crt;

procedure affObstacle ( montagne, recif: Obstacle);
procedure affBateaux  ( game: Jeu; joueur1, joueur2: Joueur);
//procedure affInfosJeu ( joueur1joue: Boolean; joueur1, joueur2: Joueur);
procedure affZone (boat: Bateau; affiche: Boolean);

implementation

procedure affObstacle ( montagne, recif: Obstacle);

var i: Integer;

begin
	for i:=1 to montagne.npos do
		begin
			GotoXY(montagne.tab[i].x,montagne.tab[i].y);
			writeln('M');
		end;
	for i:=1 to recif.npos do
		begin
			GotoXY(recif.tab[i].x,recif.tab[i].y);
			writeln('R');
		end;
end;

procedure affBateaux  ( game: Jeu; joueur1, joueur2: Joueur);

var i,j:Integer;

begin
	if game.joueur1Joue then
	begin
		for i:=1 to joueur1.nbBateaux do
		begin
			j:=1;
			repeat
				GotoXY(joueur1.boat[i].pos[j].x,joueur1.boat[i].pos[j].y);
				textcolor(blue);
				textbackground(White);
				write('B');
				j:=j+1;
			until j= joueur1.boat[i].taille+1;
		end;
	for i:=1 to joueur2.nbBateaux do
		begin
			if joueur2.boat[i].detecte then
				begin
				j:=1;
				repeat
					GotoXY(joueur2.boat[i].pos[j].x,joueur2.boat[i].pos[j].y);
					textcolor(red);
					textbackground(White);
					write('B');
					j:=j+1;
				until j= joueur2.boat[i].taille+1;
				end;
		end;	
	end
	else
	begin
		for i:=1 to joueur2.nbBateaux do
			j:=1;
			repeat
				GotoXY(joueur2.boat[i].pos[j].x,joueur2.boat[i].pos[j].y);
				textcolor(blue);
				textbackground(White);
				write('B');
				j:=j+1;
			until j= joueur2.boat[i].taille;
		for i:=1 to joueur2.nbBateaux do
		begin
			if joueur1.boat[i].detecte then
				begin
				j:=1;
				repeat
					GotoXY(joueur2.boat[i].pos[j].x,joueur2.boat[i].pos[j].y);
					textcolor(red);
					textbackground(White);
					write('B');
					j:=j+1;
				until j= joueur2.boat[i].taille+1;
				end;
		end;
	end;
	textbackground(Black);
	textcolor(White);
end;


procedure affZone (boat: Bateau; affiche: Boolean);

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
end;
begin
end.