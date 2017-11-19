unit choixbat;
interface

uses commun, Crt, Keyboard, affichage;
procedure choixboat (game: jeu; joueur1, joueur2: Joueur);
procedure choixbateau ( game: Jeu; joueur1, joueur2: Joueur; var bat: Bateau);

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




procedure choixbateau (game: Jeu; joueur1, joueur2: Joueur; var bat: Bateau);
var saisie : String;
	k : TKeyEvent;
	i : Integer;

Begin
	InitKeyboard;
	if game.joueur1joue = true then
		begin
			bat:=joueur1.boat[1];
			saisie := 'Right';
			i:=1;
			while saisie <> 'Enter' do
				Begin
					K:=GetKeyEvent;
					K:=TranslateKeyEvent(K);
					saisie:=KeyEventToString(K);
					Case saisie of 
						'Right' : begin
									if i = joueur1.nbBateaux then
										i:=1
									Else
										i:=i+1;
								  end;
						'Left' :begin
									if i=1 then
										i:=joueur1.nbBateaux
									Else
										i:=i-1
								end;
					end;
					bat:=joueur1.boat[i];
					affunBat(bat);
				end;
		end
	Else
		begin
			bat:=joueur2.boat[1];
			i:=1;
			while saisie <> 'Enter' do
				Begin
					K:=GetKeyEvent;
					K:=TranslateKeyEvent(K);
					saisie:=KeyEventToString(K);
					Case saisie of 
					'Right' : begin
									if i = joueur1.nbBateaux then
										i:=1
									Else
										i:=i+1;
								  end;
						'Left' :begin
									if i=1 then
										i:=joueur1.nbBateaux
									Else
										i:=i-1
								end;
					end;
					bat:=joueur1.boat[i];
					affunBat(bat);
				end;
		end
end;

procedure choixboat (game: jeu; joueur1, joueur2: Joueur; var bat: Bateau);
begin
choixbateau ( game: Jeu; joueur1, joueur2: Joueur; var bat: Bateau);
affBateaux (game: Jeu; joueur1, joueur2: Joueur);
end;
end.
