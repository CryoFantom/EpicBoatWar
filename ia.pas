unit ia;

interface

uses commun;

Const NNOEUDSMAX = 1000000;

type Coordos = record
	x : Integer;
	y : Integer;
end;

Type tabNoeuds = record
	tab : Array [1..NNOEUDSMAX] of Coordos;
	taille : Integer;
end;

implementation

function calculNoeuds(plat : Plateau) : tabNoeuds;

var i, j, a, b, k, l, t : Integer;
var tabTampon : Array [1..10000] of coordos;
var tailleTampon : Integer;
var listeNoeuds : tabNoeuds;

begin
	
	tailleTampon := 0;
	listeNoeuds.taille := 0;

	for i:=1 to TAILLE_X do
		for j:=1 to TAILLE_Y do
			begin
				if ((plat[i][j] = centreMontagne) or (plat[i][j] = centreRecifs)) then
					begin
						tailleTampon := tailleTampon+1;
						tabTampon[tailleTampon].x := i;
						tabTampon[tailleTampon].y := j;
					end;					
			end;
		
	for i := 1 to tailleTampon do
		for j:= 1 to tailleTampon do
			begin
				if (i <> j) then
					begin
						a := round((tabTampon[i].x+tabTampon[j].y)/2);
						b := round((tabTampon[i].y+tabTampon[j].y)/2);
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
		calculNoeuds := listeNoeuds;
	end;
end;

begin
end.
