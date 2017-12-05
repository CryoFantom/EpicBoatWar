unit ia;

interface

uses commun, calcul, crt;

Const NNOEUDSMAX = 1000000;

type TabTir = record
	tab : array[1..NBOAT] of Boolean;
	nbBateaux : Integer;
end;

type Coordos = record
	x : Integer;
	y : Integer;
end;

Type TabNoeuds = record
	tab : Array [1..NNOEUDSMAX] of Coordos;
	taille : Integer;
end;

function calculNoeuds(plat : Plateau; centres : Obstacle) : TabNoeuds;

implementation

function calculNoeuds(plat : Plateau; centres : Obstacle) : TabNoeuds;

var i, j, a, b, k, l, t : Integer;
var listeNoeuds : TabNoeuds;

begin
	
	listeNoeuds.taille := 0;
		
	for i := 1 to centres.npos do
		for j:= 1 to centres.npos do
			begin
				if (i<j) then
					begin
						a := round((centres.tab[i].x+centres.tab[j].x)/2);
						b := round((centres.tab[i].y+centres.tab[j].y)/2);
						t:=0;
						for k:=-1 to 1 do
							for l:=-1 to 1 do
								if ((a+k > 0) and (a+k < TAILLE_X) and (b+l > 0) and (b+l < TAILLE_Y)) then
									if (not(plat[a+k][b+l] = libre)) then
										t:=t+1;
						if (t = 0) then
							begin
								listeNoeuds.taille := listeNoeuds.taille+1;
								listeNoeuds.tab[listeNoeuds.taille].x := a;
								listeNoeuds.tab[listeNoeuds.taille].y := b;
							end;
					end;
			end;
	for i:=1 to listeNoeuds.Taille do
	begin
		gotoxy(listeNoeuds.tab[i].x, listeNoeuds.tab[i].y);
		write('O');
	end;
			
	calculNoeuds := listeNoeuds;
	

end;

function listageBateau(listeBateaux : listeBateaux; leBateau : Bateau) : TabTir;

var i, j, k, x, y : Integer;
var tir : TabTir;

begin
	
	tir.nbBateaux:=0;

	for i:=1 to NBOAT do
		tir.tab[i] := False;
	
	for i:=1 to leBateau.tir.nbCases do
		if (leBateau.tir.tabZone[i].nature = bateauJ1) then
		begin
			x := leBateau.tir.tabZone[i].x;
			y := leBateau.tir.tabZone[i].y;
			for j:=1 to NBOAT do
			for k:=1 to listeBateaux[j].taille do
				if (not(listeBateaux[j].coule) and (listeBateaux[j].pos[k].x=x) and (listeBateaux[j].pos[k].y=y)) then
				begin
					tir.tab[j]:=True;
					tir.nbBateaux := tir.nbBateaux +1;
				end;	
		end;
	listageBateau := tir;
end;

function choixAction (listeBateaux : listeBateaux; leBateau : Bateau; unTir : TabTir) : TypeAction;
 var i : Integer;
 var action : TypeAction;

begin
	if unTir.nbBateaux = 0 then
		action := deplacement;
	for i:= 1 to NBOAT do
		action := tir;
	
	choixAction:= action;

end;

begin
end.

