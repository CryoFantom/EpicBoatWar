unit choix;

interface

uses commun, Crt, Keyboard, affichage, calcul;

procedure choixDeplacement (var choix : PAction);
procedure choixBateau (joueur1joue : Boolean; nbBateaux : Integer ; joueur1, joueur2: PJoueur; game : PJeu; var choixBat : PAction);
procedure choixTir (var choix : PAction);
procedure exitgame();
procedure menu (var nomJ1, nomJ2: String; var veutjouer: Boolean);

implementation

procedure menu (var nomJ1, nomJ2: String; var veutjouer: Boolean);
var sousMenu : Array [1..3] of string;
	i,j : Integer;
	saisie : String;
	k : TKeyEvent;
	
begin
	ClrScr;
	GoToXY(trunc(TAILLE_X*0.4),trunc(TAILLE_Y/2));
	sousMenu[1]:= 'Jouer';
	sousMenu[2]:= 'Comment jouer?';
	sousMenu[3]:= 'Meilleur scores';
	writeln('Utilisez ↑ et ↓ pour vous déplacer dans le Menu, appuyez sur Entrée pour valider');
	i:=1;
	saisie:='init';
	while saisie <> 'Enter' do
	begin
		for j:=1 to 3 do
		begin
			if j=i then
			begin			
				textcolor(Black);
				textbackground(White);
				writeln(sousMenu[j]);
				textcolor(White);
				textbackground(Black);
			end
			else
				writeln(sousMenu[j]);
		end;
			K:=GetKeyEvent;
			K:=TranslateKeyEvent(K);
			saisie:=KeyEventToString(K);
			if GetKeyEventCode(K)=7181 then saisie:='Enter';
			if getkeyeventcode(k)=283 then saisie:= 'Escape';
			case saisie of
				'Down' : if i=1 then i:=3 else i:=i-1;
				'Up' : if i=3 then i:=1 else i:=i+1;
				'Escape' : exitgame();
			end;
	end;
	case sousMenu[j] of
		'Jouer' : begin 
					veutjouer:= true;
					ClrScr;
					GoToXY(trunc(TAILLE_X*0.4),trunc(TAILLE_Y/2));
					writeln('Joueur 1, entrez votre nom puis appuyez sur Entrée');
					readln(nomJ1);
					writeln('Joueur 2, entrez votre nom puis appuyez sur Entrée');
					readln(nomJ2);
			      end;
	end;
end;

procedure exitgame();

var K : TKeyEvent;

begin
	ClrScr;
	GoToXY(trunc(TAILLE_X*0.4),trunc(TAILLE_Y/2));
	writeln('Voulez vous vraiment quitter cette partie ?');
	GoToXY(trunc(TAILLE_X*0.3),trunc(TAILLE_Y/2)+2);
	write('Entrée pour quitter la partie / Échap pour revenir au jeu');
	InitKeyBoard;
	K:=GetKeyEvent;
	case GetKeyEventCode(K) of 
		7181 : Halt;
		//283 : Exit;
	end;
	DoneKeyBoard;
	ClrScr;
	//à améliorer
end;


procedure affUnBat (boat : Bateau);
var i : Integer;

begin
	GotoXY(boat.pos[1].x,boat.pos[1].y);
	textcolor(Black);
	textbackground(Blue);
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


procedure choixBateau (joueur1joue : Boolean; nbBateaux : Integer ; joueur1, joueur2: PJoueur; game : PJeu; var choixBat : PAction);

var joueur : PJoueur;
	saisie : String;
	K : TKeyEvent;
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
	case choixBat^.nature of
		deplacement : write('faire tirer vos bateaux');
		tir : write('terminer votre tour');
	end;

	
	if joueur1joue then joueur:=joueur1 else joueur:=joueur2;
	
	GotoXY(TAILLE_X+1,33);
	write('Vous pouvez encore');
	GotoXY(TAILLE_X+1,34);
	case choixBat^.nature of
		deplacement : write('déplacer ',nbBateaux,' bateaux');
		tir : write('faire tirer ',nbBateaux,' bateaux');
	end;

	
	InitKeyboard;
	saisie := ' ';
	i:=0;
	case choixBat^.nature of
		deplacement : repeat i:=i+1 until ((i=NBOAT+1) or (not(joueur^.boat[i].coule) and (joueur^.boat[i].quota>0)));
		tir : repeat i:=i+1 until ((i=NBOAT+1) or (joueur^.boat[i].peutTirer));
	end;
	if (i<=NBOAT) then
	begin
		affunBat(joueur^.boat[i]);
		repeat
			K:=GetKeyEvent;
			K:=TranslateKeyEvent(K);
			saisie:=KeyEventToString(K);
			if GetKeyEventCode(K)=7181 then saisie:='Enter';
			if getkeyeventcode(k)=283 then saisie:= 'Escape';
			case saisie of 
				'Right' : case choixBat^.nature of
							deplacement : repeat if i = NBOAT then i:=1 else i:=i+1 until (not(joueur^.boat[i].coule) and (joueur^.boat[i].quota>0));
							tir : repeat if i = NBOAT then i:=1 else i:=i+1 until joueur^.boat[i].peutTirer;
						end;
				'Left' : case choixBat^.nature of
							deplacement : repeat if i=1 then i:=NBOAT else i:=i-1 until (not(joueur^.boat[i].coule) and (joueur^.boat[i].quota>0));
							tir : repeat if i=1 then i:=NBOAT else i:=i-1 until joueur^.boat[i].peutTirer;
						end;
				't','T' : begin
							choixBat^.nature:=finTour;
							saisie:='Enter';
						  end;
				'Escape' : exitgame();					
			end;
			affBateaux (game, joueur1, joueur2);
			affunBat(joueur^.boat[i]);
		choixBat^.boat:=joueur^.boat[i];
		choixBat^.noBateau:=i;
		choixBat^.statut:=allowed;
	until saisie = 'Enter';
	end;
	else choixBat^.statut:=overquota;
	DoneKeyboard;

end;

procedure choixDeplacement (var choix : PAction);

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
	
	if (saisie='Right') or (saisie='Up') then choix^.coord.x:=1;
	if (saisie='Left') or (saisie='Down') then choix^.coord.x:=-1;
	if (saisie='Right') or (saisie='Left') then choix^.nature:=rotation;
	if (saisie='Up') or (saisie='Down') then choix^.nature:=deplacement;
	if (saisie='T') or (saisie='t') then choix^.nature:=finDeplacement else
	if not ((saisie='Up') or (saisie='Down') or (saisie='Right') or (saisie='Left')) then choix^.nature:=nonValide;
end;

procedure choixTir (var choix: PAction);
var saisie: String;
	K: TKeyEvent;
	coord:Position;


Begin
	GotoXY(TAILLE_X+1,20);
	write('Utilisez les flèches');
	GotoXY(TAILLE_X+1,21);
	write('← ou → ou ↑ ou ↓ ');
	GotoXY(TAILLE_X+1,22);
	write('pour choisir votre cible');
	GotoXY(TAILLE_X+1,24);
	write('Puis appuyez sur Entrer');
	GotoXY(TAILLE_X+1,28);
	write('Appuyez sur T pour');
	GotoXY(TAILLE_X+1,29);
	write('ne pas tirer');
	InitKeyboard;
	saisie := ' ';
	choix^.coord.x:= choix^.boat.pos[1].x;
	choix^.coord.y:= choix^.boat.pos[1].y;
	GotoXY(choix^.coord.x,choix^.coord.y);
	while saisie <> 'Enter' do
		Begin
			K:=GetKeyEvent;
			K:=TranslateKeyEvent(K);
			saisie:=KeyEventToString(K);
			coord:=choix^.coord;
			if GetKeyEventCode(K)=7181 then saisie:='Enter';
			case saisie of
				'Right': choix^.coord.x:= choix^.coord.x+1;
				'Left': choix^.coord.x:= choix^.coord.x-1;
				'Up': choix^.coord.y:= choix^.coord.y-1;
				'Down': choix^.coord.y:= choix^.coord.y+1;
				't','T': choix^.nature := finTir;
			end;
			if choix^.nature=finTir then saisie:='Enter';
			if not(choix^.boat.tabTir[choix^.coord.x,choix^.coord.y]) {la position n'est pas dans la zone de tir} then 
				choix^.coord:=coord;
			GotoXY(choix^.coord.x,choix^.coord.y);
		end;
	DoneKeyboard;
end;

end.
