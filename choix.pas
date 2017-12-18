unit choix;

interface

uses commun, Crt, Keyboard, affichage, calcul;

procedure choixDeplacement (var choix : PAction);
procedure choixBateau (joueur1joue : Boolean; nbBateaux : Integer ; var joueur1, joueur2: PJoueur; game : PJeu; var choixBat : PAction);
procedure choixTir (var choix : PAction);
procedure exitgame();
procedure menu (var nomJ1, nomJ2: String; var veutJouer: Boolean);

implementation

procedure choixNom (var nomJ1, nomJ2: String; var veutJouer: Boolean);

var i:Byte;

begin 
	veutjouer:= True;
	ClrScr;
	GoToXY(trunc(TAILLE_X*0.4),trunc(TAILLE_Y/2));
		write('Joueur 1, saisissez votre nom puis appuyez sur Entrée');
	GoToXY(trunc(TAILLE_X/2),trunc(TAILLE_Y/2)+1);
		readln(nomJ1);
	GoToXY(trunc(TAILLE_X*0.4),trunc(TAILLE_Y/2)+3);
		write('Joueur 2, saisissez votre nom puis appuyez sur Entrée');
	GoToXY(trunc(TAILLE_X/2),trunc(TAILLE_Y/2)+4);
		i:=0;
		repeat
			readln(nomJ2);
			GoToXY(trunc(TAILLE_X/2)+10,trunc(TAILLE_Y/2)+4+i);
			if nomJ2=nomJ1 then write('Vous ne pouvez pas utiliser le même nom que le joueur 1 !');
			i:=i+1;
			GoToXY(trunc(TAILLE_X/2),trunc(TAILLE_Y/2)+4+i);
		until nomJ2<>nomJ1;
end;

procedure menu (var nomJ1, nomJ2: String; var veutJouer: Boolean);

var sousMenu : Array [1..3] of String;
	i,j : Integer;
	saisie : String;
	k : TKeyEvent;

begin
	veutjouer:=False;
	sousMenu[1]:= 'Jouer';
	sousMenu[2]:= 'Comment jouer ?';
	sousMenu[3]:= 'Crédits';
	
	ClrScr;
	
	GoToXY(trunc(TAILLE_X/2-15),10);
		writeln('  _____       _        ____              _    __        __         ');
	GoToXY(trunc(TAILLE_X/2-15),11);
		writeln(' | ____|_ __ (_) ___  | __ )  ___   __ _| |_  \ \      / /_ _ _ __ ');
	GoToXY(trunc(TAILLE_X/2-15),12);
		writeln(' |  _| | ''_ \| |/ __| |  _ \ / _ \ / _` | __|  \ \ /\ / / _` | ''__|');
	GoToXY(trunc(TAILLE_X/2-15),13);
		writeln(' | |___| |_) | | (__  | |_) | (_) | (_| | |_    \ V  V / (_| | |   ');
	GoToXY(trunc(TAILLE_X/2-15),14);
		writeln(' |_____| .__/|_|\___| |____/ \___/ \__,_|\__|    \_/\_/ \__,_|_|   ');
	GoToXY(trunc(TAILLE_X/2-15),15);
		writeln('       |_|                                                         ');

	GoToXY(trunc(TAILLE_X*0.4),trunc(TAILLE_Y/2)-1);
	writeln('Utilisez ↑ et ↓ pour vous déplacer dans le Menu, appuyez sur Entrée pour valider');
	i:=1;
	saisie:='init';
	while saisie <> 'Enter' do
	begin
		for j:=1 to 3 do
		begin
			GoToXY(trunc(TAILLE_X*0.4),trunc(TAILLE_Y/2)+j);
			if j=i then
			begin
				textcolor(Black);
				textbackground(White);
				write(sousMenu[j]);
				textcolor(White);
				textbackground(Black);
			end
			else
				write(sousMenu[j]);
		end;
		GoToXY(1,1);
		InitKeyBoard;
		K:=GetKeyEvent;
		K:=TranslateKeyEvent(K);
		saisie:=KeyEventToString(K);
		if GetKeyEventCode(K)=7181 then saisie:='Enter';
		if getkeyeventcode(k)=283 then saisie:='Escape';
		DoneKeyBoard;
		case saisie of
			'Up' : if i=1 then i:=3 else i:=i-1;
			'Down' : if i=3 then i:=1 else i:=i+1;
			'Escape' :begin
							exitgame();
							GoToXY(trunc(TAILLE_X*0.4),trunc(TAILLE_Y/2));
							writeln('Utilisez ↑ et ↓ pour vous déplacer dans le Menu, appuyez sur Entrée pour valider');
					  end;
		end;
	end;
	case sousMenu[i] of
		'Jouer' : choixNom(nomJ1,nomJ2,veutJouer);
		'Comment jouer ?' :begin
								reglesDuJeu();
								repeat
									K:=GetKeyEvent;
									K:=TranslateKeyEvent(K);
									saisie:=KeyEventToString(K);
									if GetKeyEventCode(K)=7181 then saisie:='Enter';
								until saisie = 'Enter';
								menu (nomJ1, nomJ2, veutJouer);
							end;
		'Crédits' : begin
						credits();
						repeat
							K:=GetKeyEvent;
							K:=TranslateKeyEvent(K);
							saisie:=KeyEventToString(K);
							if GetKeyEventCode(K)=7181 then saisie:='Enter';
						until saisie = 'Enter';
						menu (nomJ1, nomJ2, veutJouer);
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
	write('Entrée pour quitter la partie / Une autre touche pour revenir au jeu');
	InitKeyBoard;
	K:=GetKeyEvent;
	if GetKeyEventCode(K)=7181 then Halt;
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

procedure choixCapacite(player : PJoueur; var choix:Capacite);

var sousMenu : Array [1..5] of String;
	i,j:Byte;
	saisie:String;
	K : TKeyEvent;

begin
	sousMenu[1]:= 'Détecter tous les bateaux de l''adversaire';
	sousMenu[2]:= 'Doubler le quota de déplacement du bateau';
	sousMenu[3]:= 'Doubler la portée de tir du bateau';
	sousMenu[4]:= 'Rechargement express';
	sousMenu[5]:= 'Je les garde pour plus tard';
	
	GotoXY(1,TAILLE_Y);
	writeln('Utilisez ↑ et ↓ pour choisir une capacité puis appuyez sur Entrée pour valider');
	writeln('Attention, une fois la capacité utilisée, vous ne pourrez plus l''utiliser jusqu''à la fin de la partie');
	i:=1;
	saisie:='init';
	while saisie <> 'Enter' do
	begin
		for j:=1 to 5 do
		begin
			GotoXY(TAILLE_X+1,35+j);
			if (j=i) and (j=5) then begin
											GotoXY(TAILLE_X+1,35+j+1);
											textcolor(Black);
											textbackground(White);
											write(sousMenu[j]);
											textcolor(White);
											textbackground(Black);
										 end
			else if j=5 then begin
							GotoXY(TAILLE_X+1,35+j+1);
							write(sousMenu[j]);
						end
			else if (j=i) and (player^.tabCapacite[j]= true) then
			begin
				textcolor(Black);
				textbackground(White);
				write(sousMenu[j]);
				textcolor(White);
				textbackground(Black);
			end
			else if (j=i) and (player^.tabCapacite[j]= false) then
			begin
				textcolor(Red);
				textbackground(White);
				write(sousMenu[j]);
				textcolor(White);
				textbackground(Black);
			end
			else if player^.tabCapacite[j]= false then begin
															textcolor(Red);
															write(sousMenu[j]);
															textcolor(White);
														  end
			else write(sousMenu[j]);
		end;
		GoToXY(1,1);
		InitKeyBoard;
		K:=GetKeyEvent;
		K:=TranslateKeyEvent(K);
		saisie:=KeyEventToString(K);
		if GetKeyEventCode(K)=7181 then saisie:='Enter';
		DoneKeyBoard;
		case saisie of
			'Up' : if i=1 then i:=5 else i:=i-1;
			'Down' : if i=5 then i:=1 else i:=i+1;
		end;
	end;
	case i of
		1 : choix:=detectAll;
		2 : choix:=doubleDeplacement;
		3 : choix:=doubleTir;
		4 : choix:=rechargementExpress;
		5 : choix:=plusTard;
	end;
end;


procedure choixBateau (joueur1joue : Boolean; nbBateaux : Integer ; var joueur1, joueur2: PJoueur; game : PJeu; var choixBat : PAction);

var joueur : PJoueur;
	saisie : String;
	choix : Capacite;
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
		deplacement : repeat i:=i+1 until ((i=NBOAT) or (not(joueur^.boat[i].coule) and (joueur^.boat[i].quota>0)));
		tir : repeat i:=i+1 until ((i=NBOAT) or (joueur^.boat[i].peutTirer));
	end;
	
	//après avoir testé tous les bateaux, si le dernier bateau (NBOAT) ne peut pas se déplacer ou tirer, i passe à NBOAT+1
	//Le joueur ne peut plus effectuer de tir ou de déplacement
	if ((i=NBOAT) and (choixBat^.nature=deplacement) and ((joueur^.boat[i].coule) or (joueur^.boat[i].quota<=0))) then i:=NBOAT+1;
	if ((i=NBOAT) and (choixBat^.nature=tir) and not(joueur^.boat[i].peutTirer)) then i:=NBOAT+1;
	
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
				'Escape' : begin
						exitgame();
						affichageJeu (game, choixBat, joueur1, joueur2); //si le joueur revient dans le jeu
						end;
				'c','C' : if joueur^.tabCapacite[0] then
						begin
							choixCapacite(joueur, choix);
							gestionCapacite(game,choix,choixBat,joueur1,joueur2);
							saisie:='capacité';
							choixBat^.boat:=joueur^.boat[i];
							choixBat^.noBateau:=i;
							choixBat^.statut:=allowed;
						end
						else 
						begin
							GotoXY(TAILLE_X+1,36);
							write('Vous avez déjà utilisé toutes vos capacités');
						end;				
			end;
			affBateaux (game, joueur1, joueur2);
			affunBat(joueur^.boat[i]);
		until (saisie='Enter') or (saisie='capacité');
		if saisie='Enter' then
		begin
			choixBat^.boat:=joueur^.boat[i];
			choixBat^.noBateau:=i;
			choixBat^.statut:=allowed;
		end;
	end
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
				'Right': if not(choix^.coord.x+1>TAILLE_X) then choix^.coord.x:= choix^.coord.x+1;
				'Left': if not(choix^.coord.x-1<0) then choix^.coord.x:= choix^.coord.x-1;
				'Up': if not(choix^.coord.y-1<0) then choix^.coord.y:= choix^.coord.y-1;
				'Down': if not(choix^.coord.y+1>TAILLE_X) then choix^.coord.y:= choix^.coord.y+1;
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
