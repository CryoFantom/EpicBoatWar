program DemoAffInfo;

uses commun, affichage;
var joueur1, joueur2: Joueur;

begin
joueur1.nom:='Hugo';
joueur2.nom:='yves';
joueur1.nbBateaux:=2;
joueur2.nbBateaux:=2;
joueur1.boat[1].nom:='cuirasse';
joueur1.boat[2].nom:='destroyer';
joueur2.boat[1].nom:='croiseurlg';
joueur2.boat[2].nom:='croiseurlrd';
joueur1.boat[1].ptDeVie:=23;
joueur1.boat[2].ptDeVie:=12;
joueur2.boat[1].ptDeVie:=15;
joueur2.boat[2].ptDeVie:=16;
affInfosJeu(true, joueur1, joueur2);
end.
