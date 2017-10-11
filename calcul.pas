unit calcul;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
interface 

uses commun, math;

////////////////

const distanceZoneMax=75; //(908 cases environ) 	(max 75)
	
Type Cases=Record
	x : Integer; 
	y : Integer; //coordonnées cartésiennes de la case
	distance : Float;
	angle : Float; //coordonnées polaires de la case (origine : bateau, angle : en radians, conventions trigo)
	visible : Boolean;
	cause : Nature; //pourquoi la case n'est pas visible (montagne, récifs - si les deux -> montagne)
end;

Type ZoneG=Record
	nbCases : Integer; //nombre de cases de la zone
	grille : Array[1..NMAXPOS] of Cases;
	xc : Float;
	yc : Float; //position du centre du bateau et de la zone
	end;


//////////////////

procedure obstacleDansZone (obst : Obstacle; var zone:ZoneG);

procedure calculZone (game : Jeu; var boat : Bateau); 


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

implementation
///////////////

procedure obstacleDansZone (obst : Obstacle; var zone:ZoneG);

Type Obstacles=record
	nature : Nature;
	x:Integer;
	y:Integer;
	distance:Float;
	angleMin:Float;
	angleMax:Float; //angle min et max entre le centre du bateau et les coins de l'obstacle
	end;

var angle:Array[1..5] of Float; //pour la recherche de angleMin et angleMax
	x,y,distance:Float; //pour simplifier la notation des coordonnées de l'obstacle
	obstZone : Array [1..100] of Obstacles; //tableau des obstacles situés dans la zone
	i,j,k,nb:Integer;

begin
	//pour chaque obstacle dans la zone, on calcule angleMin et angleMax
	nb:=0;
	for i:=1 to obst.npos do
	begin
		x:=obst.tab[i].x;
		y:=obst.tab[i].y;
		distance:=sqrt((x-zone.xc)**2+(y-zone.yc)**2);
		//si l'obstacle est dans la zone
		if distance<=distanceZoneMax then
		begin
			nb:=nb+1;
			obstZone[nb].x:=obst.tab[i].x;
			obstZone[nb].y:=obst.tab[i].y;
			obstZone[nb].distance:=distance;
			obstZone[nb].nature:=obst.tab[i].nature;
			//calcul des 4 angles possibles
			for j:=1 to 4 do
			begin
				x:=obst.tab[i].x;
				y:=obst.tab[i].y; //pour rétablir les valeurs de départ si elles ont changé
				//position des 4 coins de l'obstacle
				case j of
					1,4 : x:=x-0.5;
					2,3 : x:=x+0.5;
				end;
				
				case j of
					1,2 : y:=y-0.5;
					3,4 : y:=y+0.5;
				end;
			
				angle[j]:=arctan2(y-zone.yc,x-zone.xc);
			end;
			
			//tri du tableau des angles
			for k:=4 downto 2 do
				for j:=1 to k-1 do
					if angle[j]>angle[j+1] then
						begin
						angle[5]:=angle[j];
						angle[j]:=angle[j+1];
						angle[j+1]:=angle[5];
						end;
			
			//attribution de angleMin et angleMax
			obstZone[nb].angleMin:=angle[1];
			obstZone[nb].angleMax:=angle[4];
		end; //obsctacle dans la zone
	end; //tous les obstacles
	
	//pour chaque case de la zone, on regarde si elle est impactée par la présence d'un obstacle
	for i:=1 to zone.nbCases do //toutes les cases
		for j:=1 to nb do //tous les obstacles dans la zone
			if zone.grille[i].distance>=obstZone[j].distance then //si la case est plus loin que l'obstacle
				//si la case est dans la même direction que l'obstacle (délimité par angleMin et angleMax)		
				if (not(obstZone[j].angleMin=-obstZone[j].angleMax) and (obstZone[j].angleMin<=zone.grille[i].angle) and (obstZone[j].angleMax>=zone.grille[i].angle))
				or ((obstZone[j].angleMin=-obstZone[j].angleMax) {obstacle aligné à gauche} and (obstZone[j].angleMax>pi()/2) and (abs(zone.grille[i].angle)>=obstZone[j].angleMax))
				or ((obstZone[j].angleMin=-obstZone[j].angleMax) {obstacle aligné à gauche} and (obstZone[j].angleMax<pi()/2) and (abs(zone.grille[i].angle)<=obstZone[j].angleMax))
				//pour compenser l'erreur résultant du passage de la valeur de l'angle de pi à -pi
				then zone.grille[i].cause:=obstZone[j].nature; //à cause de ce type d'obstacle
end;

///////////////

procedure calculZone (game : Jeu; var boat : Bateau);

var proue, poupe : Position; //position de l'avant et de l'arrière du bateau
	zone : ZoneG;
	x,y : Integer; //pour parcours de toute les cases
	i,nb : Integer; //pour stockage dans le tableau de la zone
	distance:Float;
	
begin
	//calcul de la position du centre du bateau (et de la zone)
	proue:=boat.pos[1];
	poupe:=boat.pos[boat.taille];
	zone.xc:=(proue.x+poupe.x)/2;
	zone.yc:=(proue.y+poupe.y)/2;
	
	//calcul de la distance entre chaque case et le centre du bateau
	i:=0;
	for y:=1 to TAILLE_Y do
		for x:=1 to TAILLE_X do
			begin
			distance:=sqrt((x-zone.xc)**2+(y-zone.yc)**2);
			//si le point est dans la zone, on l'ajoute dans le tableau, on calcule l'angle, et on vérifie s'il est masqué par un obstacle
			if distance<=distanceZoneMax then
				begin
				i:=i+1;
				zone.grille[i].x:=x;
				zone.grille[i].y:=y;
				zone.grille[i].distance:=distance;
				zone.grille[i].angle:=arctan2(y-zone.yc,x-zone.xc); //usage : arctan2(y/x) -> renvoi l'angle en radians compris entre -pi et pi
				zone.grille[i].cause:=libre;
				end;
			end;
	
	zone.nbCases:=i;
		
	obstacleDansZone (game.recifs,zone); 	//quelles cases sont rendues inaccessibles par un récif
			
	obstacleDansZone (game.montagne,zone); 	//quelles cases sont cachées par une montagne
				
	//génération de la zone de tir
	nb:=0;
	boat.tir.typeZone:=tir;
	for i:=1 to zone.nbCases do
			if zone.grille[i].distance<=boat.tir.distance then
				begin
				nb:=nb+1;
				case zone.grille[i].cause of
					montagne : boat.tir.tabZone[nb].visible:=False; //tir bloqué par montagne
					recifs : boat.tir.tabZone[nb].visible:=True; //tir non bloqué par récifs
					libre : boat.tir.tabZone[nb].visible:=True;
				end;
				boat.tir.tabZone[nb].x:=zone.grille[i].x;
				boat.tir.tabZone[nb].y:=zone.grille[i].y;
				end;
	boat.tir.nbCases:=nb;
	
	//génération de la zone de déplacement
	nb:=0;
	boat.tir.typeZone:=deplacement;
	for i:=1 to zone.nbCases do
			if zone.grille[i].distance<=boat.deplacement.distance then
				begin
				nb:=nb+1;
				case zone.grille[i].cause of
					montagne : boat.deplacement.tabZone[nb].visible:=False; //déplacement bloqué par montagne
					recifs : boat.deplacement.tabZone[nb].visible:=False; //déplacement bloqué par récifs
					libre : boat.deplacement.tabZone[nb].visible:=True;
				end;
				boat.deplacement.tabZone[nb].x:=zone.grille[i].x;
				boat.deplacement.tabZone[nb].y:=zone.grille[i].y;
				end;
	boat.deplacement.nbCases:=nb;
	
	//génération de la zone de détection
	nb:=0;
	boat.detection.typeZone:=detection;
	for i:=1 to zone.nbCases do
			if zone.grille[i].distance<=boat.detection.distance then
				begin
				nb:=nb+1;
				case zone.grille[i].cause of
					montagne : boat.detection.tabZone[nb].visible:=False; //visibilité bloquée par montagne
					recifs : boat.detection.tabZone[nb].visible:=True; //visibilité non bloquée par récifs
					libre : boat.detection.tabZone[nb].visible:=True;
				end;
				boat.detection.tabZone[nb].x:=zone.grille[i].x;
				boat.detection.tabZone[nb].y:=zone.grille[i].y;
				end;
	boat.detection.nbCases:=nb;
end;

end.
