unit choix

interface

uses commun,Crt, Keyboard;
procedure controle (var choix : Action);
procedure choixbat(player: Joueur; var boat: Bateau);

implementation

procedure affunbateau(boat: Bateau);
var i: Integer;

begin
	i:=1;
	GotoXY(boat.pos[i].x,boat.pos[i].y)
	write('
procedure choixbat(player: Joueur; var boat: Bateau);

var K : TKeyEvent;
	saisie : String;
	i : Integer;
begin
	boat:=payer.boat[1];
	i:=1
	repeat 
		K;= GetKeyEvent;
		K:=TranslateKeyEvent(K);
		saisie:=KeyEventToString(K);
		doneKeyBoard;
		if saisie='Right' do
			begin
				i:=i+1;
				if i > player.nbBateaux do
					i:=1;
			end;
		else if saisie= 'Left' do
			begin
				i:= i-1
				if i=0 do
					i:= player.nbBateaux;
			end;
		boat:= player.boat[i];
end;





begin
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
	if (saisie='Up') or (saisie='Down') then choix.nature:=deplacement
	else choix.nature:=nonValide;
end;
