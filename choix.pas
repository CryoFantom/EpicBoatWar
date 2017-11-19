unit choix;

interface

uses commun, Crt, Keyboard, affichage;
procedure controle (var choix : Action);
procedure choixbateau (joueur1joue : Boolean; joueur1, joueur2: Joueur; var choixBat : Action);

implementation

procedure affunBat (boat : Bateau);
var i : Integer;

begin
	GotoXY(boat.pos[1].x,boat.pos[1].y);
	textcolor(green);
	textbackground(white);
	write('P');
	for i:=2 to boat.taille do
	begin;
		GotoXY(boat.pos[i].x,boat.pos[i].y);
		write('B');
	end;
	textcolor(white);
	textbackground(Black);
end;


procedure choixBateau (joueur1joue : Boolean; joueur1, joueur2: Joueur; var choixBat : Action);
var saisie : String;
	k : TKeyEvent;
	i : Integer;

Begin
	GotoXY(TAILLE_X+1,20);
	write('Utilisez les flèches');
	GotoXY(TAILLE_X+7,21);
	write('<- ou -> ');
	GotoXY(TAILLE_X+1,22);
	write('pour choisir le bateau');
	GotoXY(TAILLE_X+1,24);
	write('Puis appuyez sur Entrer');
	InitKeyboard;
	if joueur1joue then
		begin
			saisie := 'Right';
			i:=1;
			while saisie <> 'Enter' do
				begin
					K:=GetKeyEvent;
					K:=TranslateKeyEvent(K);
					saisie:=KeyEventToString(K);
					if GetKeyEventCode(K)=7181 then saisie:='Enter';
					case saisie of 
						'Right' : begin
									if i = joueur1.nbBateaux then
										i:=1
									else
										i:=i+1;
									end;
						'Left' : begin
									if i=1 then
										i:=joueur1.nbBateaux
									else
										i:=i-1
								end;
					end;
					affunBat(joueur1.boat[i]);
				end;
			choixBat.boat:=joueur1.boat[i];
			choixBat.noBateau:=i;
		end
	else
		begin
			i:=1;
			while saisie <> 'Enter' do
				Begin
					K:=GetKeyEvent;
					K:=TranslateKeyEvent(K);
					saisie:=KeyEventToString(K);
					if GetKeyEventCode(K)=7181 then saisie:='Enter';
					Case saisie of 
					'Right' : begin
									if i = joueur2.nbBateaux then
										i:=1
									Else
										i:=i+1;
								  end;
						'Left' :begin
									if i=1 then
										i:=joueur2.nbBateaux
									Else
										i:=i-1
								end;
					end;
					affunBat(joueur2.boat[i]);
				end;
			choixBat.boat:=joueur2.boat[i];
			choixBat.noBateau:=i;
		end;
end;

procedure controle (var choix : Action);

var saisie:String;
	K : TKeyEvent;
begin
	GotoXY(TAILLE_X+1,20);
	write('Rappel des commandes :');
	GotoXY(TAILLE_X+1,22);
	write('↑ avancer');
	GotoXY(TAILLE_X+1,23);
	write('↓ reculer');
	GotoXY(TAILLE_X+1,24);
	write('-> pivoter vers la droite');
	GotoXY(TAILLE_X+1,25);
	write('<- pivoter vers la gauche');
	
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
