program EpicBoatWar;

uses commun, crt, generation, calcul;

var plat : Plateau;
var i: Integer;
var test : Boolean;
var game:Jeu;
	boat:Bateau;
	
begin
	clrscr;
	
	test:=True;
	
	while (test) do
	begin
		clrscr;
	//initialisation tableaux	
		for i:=1 to NMAXPOS do
		begin
			game.montagne.tab[i].nature := libre;
			game.montagne.tab[i].x := 0;
			game.montagne.tab[i].y := 0;
			game.montagne.tab[i].visible := True;
			game.recifs.tab[i].nature := libre;
			game.recifs.tab[i].x := 0;
			game.recifs.tab[i].y := 0;
			game.recifs.tab[i].visible := True;
		end;
	
	genObstacles(plat, game.montagne, game.recifs);

	//création d'un bateau au milieu de l'écran
	boat.taille:=4;
	for i:=1 to boat.taille do
		begin
		boat.pos[i].y:=25;
		boat.pos[i].x:=70+i;
		end;
	boat.tir.distance:=10;
	boat.detection.distance:=30;
	boat.deplacement.distance:=60;
	
	//calcul des zones
	calculZone (game,boat); 
	
	//affichage des zones
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
		
	//affichage du bateau
	for i:=1 to boat.taille do
		begin
		GotoXY(boat.pos[i].x,boat.pos[i].y);
		write('b');
		end;
		
	//affichage des montagnes
	for i:=1 to game.montagne.npos do
		begin
		GotoXY(game.montagne.tab[i].x,game.montagne.tab[i].y);
		write('m');
		end;
		
	//affichage des récifs
	for i:=1 to game.recifs.npos do
		begin
		GotoXY(game.recifs.tab[i].x,game.recifs.tab[i].y);
		write('r');
		end;
	
	GotoXY(1,TAILLE_Y+1);
		
	delay(1200);
	end;
end.
