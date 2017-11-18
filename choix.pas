unit choix;

interface

uses commun,Crt, Keyboard;
procedure controle (var choix : Action);
procedure choixbat(player: Joueur; var boat: Bateau);

implementation

{procedure affunbateau(boat: Bateau);
var i: Integer;

begin
	i:=1;
	GotoXY(boat.pos[i].x,boat.pos[i].y)
	write('
}

procedure choixbat(player: Joueur; var boat: Bateau);

var K : TKeyEvent;
	saisie : String;
	i : Integer;
begin
	boat:=player.boat[1];
	i:=1;
	repeat 
		InitKeyboard;
		K:=GetKeyEvent;
		K:=TranslateKeyEvent(K);
		saisie:=KeyEventToString(K);
		doneKeyBoard;
		if (saisie='Right') then
			begin
				i:=i+1;
				if i > player.nbBateaux then
					i:=1;
			end
		else if (saisie='Left') then
			begin
				i:= i-1;
				if i=0 then
					i:= player.nbBateaux;
			end;
		boat:= player.boat[i];
	until saisie='B';
end;

procedure controle (var choix : Action);

var saisie:String;
	K : TKeyEvent;
begin
	GotoXY(1,TAILLE_Y+1);
	write('Utilisez les flèches pour déplacer le bateau');
	InitKeyboard;
	K:=GetKeyEvent;
	K:=TranslateKeyEvent(K);
	saisie:=KeyEventToString(K);
	DoneKeyboard;
	if (saisie='Right') or (saisie='Up') then choix.coord.x:=1;
	if (saisie='Left') or (saisie='Down') then choix.coord.x:=-1;
	
	if (saisie='Right') or (saisie='Left') then choix.nature:=rotation;
	if (saisie='Up') or (saisie='Down') then choix.nature:=deplacement;
	if not ((saisie='Up') or (saisie='Down') or (saisie='Right') or (saisie='Left')) then 
		begin
			choix.nature:=nonValide;
			write('Saisie non valide');
		end;
end;

end.
