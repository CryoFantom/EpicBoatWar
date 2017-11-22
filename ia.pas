unit ia;

interface

uses commun, calcul, crt;

Const NNOEUDSMAX = 1000000;

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
			
	calculNoeuds := listeNoeuds;
	

end;



begin
end.

