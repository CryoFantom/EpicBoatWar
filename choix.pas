unit choix;

interface

uses commun, Crt, Keyboard, affichage;

procedure choixDeplacement (var choix : Action);
procedure choixbateau (joueur1joue : Boolean; joueur1, joueur2: PJoueur; game : PJeu; var choixBat : Action);
procedure choixtir (boat: Bateau; var tir: Action);

implementation

procedure affunBat (boat : Bateau);
var i : Integer;

begin
	GotoXY(boat.pos[1].x,boat.pos[1].y);
	textcolor(Black);
	textbackground(LightGray);
	write('O');
	for i:=2 to boat.taille do
	begin;
		GotoXY(boat.pos[i].x,boat.pos[i].y);
		write('B');
	end;
	textcolor(white);
	textbackground(Black);
	GoToXY(1,TAILLE_Y+1);
end;


procedure choixBateau (joueur1joue : Boolean; joueur1, joueur2: PJoueur; game : PJeu; var choixBat : Action);
var saisie : String;
	k : TKeyEvent;
	i : Integer;

Begin
	GotoXY(TAILLE_X+1,20);
	write('Utilisez les flèches');
	GotoXY(TAILLE_X+7,21);
	write('← ou → ');
	GotoXY(TAILLE_X+1,22);
	write('pour choisir le bateau');
	GotoXY(TAILLE_X+1,24);
	write('Puis appuyez sur Entrer');
	GotoXY(TAILLE_X+1,28);
	write('Appuyez sur T pour');
	GotoXY(TAILLE_X+1,29);
	write('terminer votre tour');
	InitKeyboard;
	if joueur1joue then
		begin
			saisie := 'Right';
			i:=0;
			repeat i:=i+1 until (not(joueur1^.boat[i].coule) and (joueur1^.boat[i].quota>0));
			affunBat(joueur1^.boat[i]);
			while saisie <> 'Enter' do
				begin
					K:=GetKeyEvent;
					K:=TranslateKeyEvent(K);
					saisie:=KeyEventToString(K);
					if GetKeyEventCode(K)=7181 then saisie:='Enter';
					case saisie of 
						'Right' : repeat if i = NBOAT then i:=1 else i:=i+1 until (not(joueur1^.boat[i].coule) and (joueur1^.boat[i].quota>0));
						'Left' : repeat if i=1 then i:=NBOAT else i:=i-1 until (not(joueur1^.boat[i].coule) and (joueur1^.boat[i].quota>0));
						't','T' : begin
								choixBat.nature:=finTour;
								saisie:='Enter';
								end;
					end;
					affBateaux (game, joueur1, joueur2);
					affunBat(joueur1^.boat[i]);
				end;
			choixBat.boat:=joueur1^.boat[i];
			choixBat.noBateau:=i;
		end
	else
		begin
			i:=0;
			repeat i:=i+1 until (not(joueur2^.boat[i].coule) and (joueur2^.boat[i].quota>0));
			affunBat(joueur2^.boat[i]);
			while saisie <> 'Enter' do
				Begin
					K:=GetKeyEvent;
					K:=TranslateKeyEvent(K);
					saisie:=KeyEventToString(K);
					if GetKeyEventCode(K)=7181 then saisie:='Enter';
					Case saisie of 
					'Right' : repeat if i=NBOAT then i:=1 else i:=i+1 until (not(joueur2^.boat[i].coule) and (joueur2^.boat[i].quota>0));
					'Left' : repeat if i=1 then i:=NBOAT else i:=i-1  until (not(joueur2^.boat[i].coule) and (joueur2^.boat[i].quota>0));
					't','T' : begin
								choixBat.nature:=finTour;
								saisie:='Enter';
								end;
					end;
					affBateaux (game, joueur1, joueur2);
					affunBat(joueur2^.boat[i]);
				end;
			choixBat.boat:=joueur2^.boat[i];
			choixBat.noBateau:=i;
		end;
	DoneKeyboard;
end;

procedure choixDeplacement (var choix : Action);

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
	write('→ pivoter vers la droite');
	GotoXY(TAILLE_X+1,25);
	write('← pivoter vers la gauche');
	GotoXY(TAILLE_X+1,27);
	write('T abandonner le déplacement');
	GoToXY(1,TAILLE_Y+1);
	
	InitKeyboard;
	K:=GetKeyEvent;
	K:=TranslateKeyEvent(K);
	saisie:=KeyEventToString(K);
	DoneKeyboard;
	
	if (saisie='Right') or (saisie='Up') then choix.coord.x:=1;
	if (saisie='Left') or (saisie='Down') then choix.coord.x:=-1;
	if (saisie='Right') or (saisie='Left') then choix.nature:=rotation;
	if (saisie='Up') or (saisie='Down') then choix.nature:=deplacement;
	if (saisie='T') or (saisie='t') then choix.nature:=finDeplacement else
	if not ((saisie='Up') or (saisie='Down') or (saisie='Right') or (saisie='Left')) then choix.nature:=nonValide;
end;

procedure choixtir (boat: Bateau; var tir: Action);
var saisie: String;
	K: TKeyEvent;


Begin
	tir.boat:=boat;
	GotoXY(TAILLE_X+1,20);
	write('Utilisez les flèches');
	GotoXY(TAILLE_X+7,21);
	write('← ou → ou ↑ ou ↓');
	GotoXY(TAILLE_X+1,22);
	write('pour choisir votre cible');
	GotoXY(TAILLE_X+1,24);
	write('Puis appuyez sur Entrer');
	GotoXY(TAILLE_X+1,28);
	write('Appuyez sur T pour');
	GotoXY(TAILLE_X+1,29);
	write('ne pas tirer');
	InitKeyboard;
	saisie := 'Enter';
	tir.coord.x:= boat.pos[1].x;
	tir.coord.y:= boat.pos[1].y;
	GotoXY(boat.pos[1].x,boat.pos[1].y);
	while saisie <> 'Enter' do
		Begin
			K:=GetKeyEvent;
			K:=TranslateKeyEvent(K);
			saisie:=KeyEventToString(K);
			if GetKeyEventCode(K)=7181 then saisie:='Enter';
			case saisie of
				'Right': tir.coord.x:= tir.coord.x+1;
				'Left': tir.coord.x:= tir.coord.x-1;
				'Up': tir.coord.y:= tir.coord.y-1;
				'Down': tir.coord.y:= tir.coord.y-1;
				't' , 'T':tir.nature := finTir;
			end;
		end;
	DoneKeyboard;
end;

end.
