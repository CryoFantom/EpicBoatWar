program EpicBoatWar;

uses commun, crt, generation, calcul;

var i, t: Integer;
var test : Boolean;
var game:Jeu;
	boat:Bateau;
var joueur1, joueur2 : Joueur;
	
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
	
	genGrille(game, joueur1, joueur2);
	
	t:=1;
	
	while (t<TAILLE_X) do
	begin
			if (t>1) then
				begin
					//effaçage des zones précédentes
					for i:=1 to boat.deplacement.nbCases do
						begin
							GotoXY(boat.deplacement.tabZone[i].x,boat.deplacement.tabZone[i].y);
							if boat.deplacement.tabZone[i].visible then
								begin
									TextBackground(Black);
									write(' ');
								end;
						end;

					for i:=1 to boat.detection.nbCases do
						begin
							GotoXY(boat.detection.tabZone[i].x,boat.detection.tabZone[i].y);
							if boat.detection.tabZone[i].visible then
								begin
									TextBackground(Black);
									write(' ');
								end;
						end;

					for i:=1 to boat.tir.nbCases do
						begin
							GotoXY(boat.tir.tabZone[i].x,boat.tir.tabZone[i].y);
							if boat.tir.tabZone[i].visible then
								begin
									TextBackground(Black);
									write(' ');
								end;
						end;				
				end;

	
		//création du bateau
		boat.taille:=4;
		for i:=1 to boat.taille do
			begin
				boat.pos[i].y:=10;
				boat.pos[i].x:=i+t;
			end;
		boat.tir.distance:=4;
		boat.detection.distance:=8;
		boat.deplacement.distance:=12;
	
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
		
		delay(1000);
		t:=t+1;
		end;
	end;
end.
