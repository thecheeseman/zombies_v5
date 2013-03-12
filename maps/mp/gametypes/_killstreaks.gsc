init()
{
	level.killstreaks = [];
	
	precacheString( &"^3Press [{+melee}]x4 to activate" );
	precacheString( &"Feet to target: " );
	
	addKillStreak( "armor", 10, &"^310 Killstreak : Armor", ::armor );
	addKillStreak( "rocket", 20, &"^320 Killstreak : Rocket Attack", ::rocket );
	addKillStreak( "mortar", 30, &"^330 Killstreak : Mortar Strike", ::mortar, false );
	addKillStreak( "artillery", 40, &"^340 Killstreak : Artillery Barrage", ::mortar, true );
	addKillStreak( "gatlin", 50, &"^350 Killstreak : Gatlin Gun", ::gatlin );
	addKillStreak( "airstrike", 75, &"^375 Killstreak : Airstrike", ::airstrike );
	addKillStreak( "carpetbomb", 100, &"^3100 Killstreak : Carpet Bomb", ::carpetbomb );
	addKillStreak( "nuke", 200, &"^3200 Killstreak : Nuke", ::nuke );

	precacheModel( "xmodel/v2rocket" );
	precacheModel( "xmodel/vehicle_plane_stuka" );
	precacheModel( "xmodel/vehicle_german_condor" );
	precacheModel( "xmodel/105" );
	
	level._effect[ "mortar" ] = loadfx( "fx/impacts/mortar1.efx" );
	level._effect[ "artillery" ] = loadfx( "fx/impacts/largemortar_dirt3.efx" );
	level._effect[ "airstrike" ] = loadfx( "fx/explosions/mutha1.efx" );
}

addKillStreak( sName, iKills, sKillString, fFunc, oArgs )
{
	precacheString( sKillString );

	killstreak = spawnstruct();
	killstreak.sName = sName;
	killstreak.iKills = iKills;
	killstreak.sKillString = sKillString;
	killstreak.fFunc = fFunc;
	
	if ( isDefined( oArgs ) )
		killstreak.oArgs = oArgs;
		
	level.killstreaks[ level.killstreaks.size ] = killstreak;
}

getKillStreakText( sName )
{
	sText = &"";
	
	for ( i = 0; i < level.killstreaks.size; i++ )
	{
		killstreak = level.killstreaks[ i ];
		if ( sName == killstreak.sName )
		{
			sText = killstreak.sKillString;
			break;
		}
	}
	
	return sText;
}

checkPowerup()
{
	bGave = false;

	for ( i = 0; i < level.killstreaks.size; i++ )
	{
		killstreak = level.killstreaks[ i ];
		if ( self.killstreak == killstreak.iKills )
		{
			self.powerup = killstreak.sName;
			bGave = true;
			break;
		}
	}
	
	if ( bGave )
		self notifyPowerup();
}

doPowerup()
{
	powerup = self.powerup;
	self.powerup = undefined;
	
	for ( i = 0; i < level.killstreaks.size; i++ )
	{
		killstreak = level.killstreaks[ i ];
		if ( powerup == killstreak.sName )
		{
			if ( isDefined( killstreak.oArgs ) )
				self thread [[ killstreak.fFunc ]]( killstreak.oArgs );
			else
				self thread [[ killstreak.fFunc ]]();
				
			break;
		}
	}
}

notifyPowerup()
{
	self endon( "disconnect" );
	
	notifytext = "";
	smallnotify = &"^3Press [{+melee}]x4 to activate";
	notifytext = getKillStreakText( self.powerup );

	largehud = newClientHudElem( self );
	largehud.x = 320;
	largehud.y = 100;
	largehud.alignx = "center";
	largehud.aligny = "middle";
	largehud.font = "fonts/consoleFont";
	largehud.fontscale = 1.25;
	largehud.alpha = 0;
	largehud setText( notifytext );
	smallhud = newClientHudElem( self );
	smallhud.x = 320;
	smallhud.y = 135;
	smallhud.alignx = "center";
	smallhud.aligny = "middle";
	smallhud.fontscale = 1;
	smallhud.alpha = 0;
	smallhud setText( smallnotify );
	
	largehud fadeOverTime( 1 );
	smallhud fadeOverTime( 1 );
	largehud.alpha = 1;
	smallhud.alpha = 1;
	
	wait 4;
	
	largehud fadeOverTime( 4 );
	smallhud fadeOverTime( 4 );
	largehud.alpha = 0;
	smallhud.alpha = 0;
	
	wait 4;
	
	largehud destroy();
	smallhud destroy();
}	

giveScoreForStreak( iXP, iPoints )
{
	self iPrintLn( "^3+" + iXP + " XP!" );
	self.xp += iXP;
	self.score += iXP;
	self.points += iPoints;
	self.pointscore += iPoints;
	
	self thread maps\mp\gametypes\_zombie::checkRank();
}

armor()
{
	self iPrintLnBold( "^3Armor Activated" );
	//self.armored = true;
	
	self giveScoreForStreak( 50, 10 );
	/*
	self.armorhud = newClientHudElem( self );
	self.armorhud.x = 0;
	self.armorhud.y = 0;
	self.armorhud.sort = 1;
	self.armorhud setShader( "white", 640, 480 );
	self.armorhud.alpha = 0.05;*/
	
	self.bodyarmor += 100;
	self.exploarmor += 50;
}

rocket()
{
	self endon( "disconnect" );
	
	trace = bullettrace( self.origin, self.origin + ( 0, 0, 328 ), false, self );
	if ( trace[ "fraction" ] != 1 )
	{
		self iPrintLnBold( "Rocket Attack can only be activated outside." );
		self.powerup = "rocket";
		return;
	}
	
	self giveScoreForStreak( 100, 20 );
	
	startbody = self.bodyarmor;
	startexplo = self.exploarmor;
	
	self.bodyarmor += 100;
	self.exploarmor += 50;
	
	self.rocketattack = true;
	
	self iPrintLnBold( "^3Rocket Attack Activated" );
	
	self.lol = spawn( "script_origin", self.origin );
	self linkto( self.lol );
	
	self.lol movez( 256, 2 );
	wait 2;
	
	self setWeaponSlotWeapon( "primaryb", "panzerfaust_mp" );
	self setWeaponSlotAmmo( "primaryb", 10 );
	self switchToWeapon( "panzerfaust_mp" );
	
	self thread rocket_waittimer();
	self thread rocket_doneammo();
	self thread rocket_death();
	self waittill( "rocket is done" );
	
	if ( isAlive( self ) )
	{
		if ( self hasWeapon( "panzerfaust_mp" ) )
		{
			self setWeaponSlotAmmo( "primaryb", 0 );
			self setWeaponSlotWeapon( "primaryb", "none" );
			self switchToWeapon( self.pers[ "weapon" ] );
		}

		self.lol movez( -256, 2 );
		wait 2;
		self.lol delete();
	}
	
	self.rocketattack = false;
	
	if ( startbody == 0 && self.bodyarmor > 0 )
		self.bodyarmor = 0;
	else if ( startexplo == 0 && self.exploarmor > 0 )
		self.exploarmor = 0;
}

rocket_waittimer()
{
	self endon( "disconnect" );
	self endon( "rocket is done" );

	i = 0;
	while ( i < 30 )
	{
		wait 1;
		i++;
	}
	
	self notify( "rocket is done" );
}

rocket_doneammo()
{
	self endon( "disconnect" );
	self endon( "rocket is done" );
	
	while ( 1 )
	{
		ammo = self getWeaponSlotClipAmmo( "primaryb" );
		if ( ammo < 1 )
			break;
		wait 0.05;
	}
	
	self notify( "rocket is done" );
}

rocket_death()
{
	self endon( "disconnect" );
	self endon( "rocket is done" );
	
	while ( isAlive( self ) )
		wait 0.05;
		
	self notify( "rocket is done" );
}

mortar( isArtillery )
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "spawn_spectator" );
	
	if ( isArtillery )
		self iPrintLnBold( "^3Artillery Barrage Activated" );
	else
		self iPrintLnBold( "^3Mortar Strike Activated" );
		
	self iPrintLnBold( "Aim at a location and hold [{+activate}] to target." );
	
	pos = self getUserLocation();
	
	if ( isArtillery )
	{
		self giveScoreForStreak( 300, 40 );
		
		iPrintLn( "Artillery incoming!" );
		amount = randomInt( 9 ) + 18;
		waitadd = 0.3;
	}
	else
	{
		self giveScoreForStreak( 200, 30 );
		
		iPrintLn( "Mortars incoming!" );
		amount = randomInt( 5 ) + 7;
		waitadd = 0.6;
	}
	
	wait 3;
	
	for ( i = 0; i < amount; i++ )
	{
		if ( isArtillery )
			thread domortar( self, pos, "artillery" );
		else
			thread domortar( self, pos, "mortar" );
			
		wait randomFloat( 1.3 ) + waitadd;
	}
}

doMortar( owner, pos, fx )
{
	owner endon( "death" );
	owner endon( "disconnect" );
	owner endon( "spawn_spectator" );
	
	spread = 256;
	if ( fx == "artillery" )
		spread = 512;
	
	x = randomInt( spread );
	y = randomInt( spread );
	
	wait 0.05;
	
	if ( randomFloat( 1.0 ) > 0.5 )
		x *= -1;
	if ( randomFloat( 1.0 ) > 0.5 )
		y *= -1;
		
	newpos = pos + ( x, y, 0 );
	trace = bullettrace( newpos + ( 0, 0, 1024 ), newpos + ( 0, 0, -1024 ), true, undefined );
	newpos[ 2 ] = trace[ "position" ][ 2 ];
	
	mod = spawn( "script_model", newpos + ( 0, 0, 512 ) );
	wait 0.05;
	mod playSound( "mortar_incoming" + ( randomInt( 5 ) + 1 ) );
	mod moveZ( -512, 1.3 );
	wait 1.3;
	mod playSound( "mortar_explosion" + ( randomInt( 5 ) + 1 ) );
	playFx( level._effect[ fx ], newpos );
	
	range = 192;
	if ( fx == "artillery" )
		range = 640;
		
	if ( fx == "artillery" )
		earthquake( 0.9, 3, newpos + ( 0, 0, 8 ), range );
	else
		earthquake( 0.4, 2, newpos + ( 0, 0, 8 ), range );
		
	thread artilleryline( newpos + ( 0, 0, 8 ), 2 );

	maps\mp\gametypes\_zombie::scriptedRadiusDamage( newpos + ( 0, 0, 8 ), range, 1500, 50, owner, undefined );
	wait 2;
	mod delete();
}

artilleryline( pos, time )
{
	if ( !level.zomdebug )
		return;
		
	up = 0.00;
	while ( up < time )
	{
		up += 0.02;
		line( pos + ( 0, 0, 512 ), pos, ( 1, 1, 1 ) );
		wait 0.02;
	}
}

gatlin()
{
	self endon( "death" );
	
	self giveScoreForStreak( 400, 50 );
	
	self setWeaponSlotWeapon( "primaryb", "fg42_mp" );
	self setWeaponSlotAmmo( "primaryb", 999 );
	self setWeaponSlotClipAmmo( "primaryb", 999 );
	
	self switchToWeapon( "fg42_mp" );
	
	while ( 1 )
	{
		ammo = self getWeaponSlotAmmo( "primaryb" );
		ammo2 = self getWeaponSlotClipAmmo( "primaryb" );
		if ( !ammo && !ammo2 )
		{
			self setWeaponSlotWeapon( "primaryb", "none" );
			return;
		}
		
		wait 1;
	}
}

airstrike()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "spawn_spectator" );
	
	self iPrintLnBold( "^3Airstrike Activated" );
	self iPrintLnBold( "Aim at a location and hold [{+activate}] to target." );
	
	pos = self getUserLocation();
	
	self giveScoreForStreak( 500, 75 );
	
	iPrintLn( "Airstrike incoming!" );
	
	trace = bullettrace( pos, pos + (0,0,-10000), false, undefined );
	targetpos = trace[ "position" ];
	
	for ( i = 0; i < 9; i++ )
	{
		rndy = maps\mp\gametypes\_zombie::_randomint( 1024 );
		rndx = maps\mp\gametypes\_zombie::_randomint( 1024 );
		
		if ( maps\mp\gametypes\_zombie::_randomint( 100 ) > 50 )
			rndy *= -1;
		if ( maps\mp\gametypes\_zombie::_randomint( 100 ) > 50 )
			rndx *= -1;
		
		yaw = getBestPlaneDirection( targetpos + ( rndx, rndy, 0 ) );
		thread callStrike( self, targetpos + ( rndx, rndy, 0 ) , yaw, ( maps\mp\gametypes\_zombie::_randomInt( 3 ) + 3 ), "stuka" );
		wait randomFloat( 0.5 ) + 0.5;
	}
}

carpetbomb()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "spawn_spectator" );
	
	self iPrintLnBold( "^3Carpet Bomb Activated" );
	self iPrintLnBold( "Aim at a location and hold [{+activate}] to target." );
	
	pos = self getUserLocation();
	
	self giveScoreForStreak( 750, 100 );
	
	iPrintLn( "Carpet bomb incoming!" );
	
	trace = bullettrace( pos, pos + (0,0,-10000), false, undefined );
	targetpos = trace[ "position" ];
	
	for ( i = 0; i < 51; i++ )
	{
		rndy = maps\mp\gametypes\_zombie::_randomint( 1568 );
		rndx = maps\mp\gametypes\_zombie::_randomint( 1568 );
		
		if ( maps\mp\gametypes\_zombie::_randomint( 100 ) > 50 )
			rndy *= -1;
		if ( maps\mp\gametypes\_zombie::_randomint( 100 ) > 50 )
			rndx *= -1;
		
		yaw = getBestPlaneDirection( targetpos + ( rndx, rndy, 0 ) );
		thread callStrike( self, targetpos + ( rndx, rndy, 0 ) , yaw, 3, "condor" );
		wait randomFloat( 0.2 ) + 0.1;
	}
}

callStrike( owner, coord, yaw, num, plane )
{	
	direction = ( 0, yaw, 0 );
	planeHalfDistance = 24000;
	planeBombExplodeDistance = 1500;
	planeFlyHeight = 850;
	planeFlySpeed = 7000;

	startPoint = coord + maps\mp\_utility::vectorscale( anglestoforward( direction ), -1 * planeHalfDistance );
	startPoint += ( 0, 0, planeFlyHeight );

	endPoint = coord + maps\mp\_utility::vectorscale( anglestoforward( direction ), planeHalfDistance );
	endPoint += ( 0, 0, planeFlyHeight );
	
	d = length( startPoint - endPoint );
	flyTime = ( d / planeFlySpeed );

	d = abs( d/2 + planeBombExplodeDistance  );
	bombTime = ( d / planeFlySpeed );
	
	if ( flytime < bombtime )
		return;
	
	owner endon( "death" );
	owner endon( "disconnect" );
	owner endon( "spawn_spectator" );
	
	for ( i = 0; i < num; i++ )
	{
		level thread doPlaneStrike( owner, coord, startPoint+(0,0,randomInt(500)), endPoint+(0,0,randomInt(500)), bombTime, flyTime, direction, yaw, plane );
		wait randomfloat( 1.0 ) + 0.2;
	}
}

doPlaneStrike( owner, bombsite, startPoint, endPoint, bombTime, flyTime, direction, yaw, planeasdf )
{
	if ( !isDefined( owner ) ) 
		return;

	startPathRandomness = 100;
	endPathRandomness = 400;
	
	pathStart = startPoint + ( (randomfloat(2) - 1)*startPathRandomness, (randomfloat(2) - 1)*startPathRandomness, 0 );
	pathEnd   = endPoint   + ( (randomfloat(2) - 1)*endPathRandomness  , (randomfloat(2) - 1)*endPathRandomness  , 0 );
	
	plane = spawn( "script_model", pathStart );
	if ( planeasdf == "condor" ) plane setModel( "xmodel/vehicle_german_condor" );
	else plane setModel( "xmodel/vehicle_plane_stuka" );
	plane.angles = direction;
	
	plane playLoopSound( "truck_idle_high" );
	plane moveTo( pathEnd, flyTime, 0, 0 );
	thread callStrike_bombEffect( plane, bombTime - 1.0, owner, yaw );

	wait flyTime;
	plane delete();
}

callStrike_bombEffect( plane, launchTime, owner, yaw )
{
	owner endon( "death" );
	owner endon( "disconnect" );
	owner endon( "spawn_spectator" );
	
	wait ( launchTime );
	
	snd = spawn( "script_model", plane.origin );
	
	bomb = spawn( "script_model", plane.origin );
	bomb.angles = plane.angles;
	bomb setModel( "xmodel/105" );
	bomb moveGravity( maps\mp\_utility::vectorscale( anglestoforward( plane.angles ), 7000/1.5 ), 3.0 );
	bomb rotateVelocity( maps\mp\_utility::vectorscale( anglestoforward( plane.angles ), 7000/1.5 ), 3.0 );
	
	bomb thread removelater( 6 );
	snd thread removelater( 6 );

	wait 1.1;
	
	trace = bullettrace( bomb.origin, bomb.origin + ( 0, 0, -10000 ), false, undefined );
	traceHit = trace[ "position" ];

	snd.origin = traceHit + ( 0, 0, 8 );
	wait 0.05;
	bomb hide();
	snd playSound( "mortar_explosion" + ( randomInt( 5 ) + 1 ) );
	playfx( level._effect[ "airstrike" ], traceHit );

	wait 0.05;
	
	maps\mp\gametypes\_zombie::scriptedRadiusDamage( traceHit + ( 0, 0, 8 ), 900, 1500, 50, owner, undefined );
}

removelater( time )
{
	wait ( time );
	self delete();
}

abs( value )
{
	if ( value < 0 )
		value *= -1;
		
	return (float)value;
}

getBestPlaneDirection( hitpos )
{
	checkPitch = -25;
	numChecks = 15;
	
	startpos = hitpos + (0,0,64);
	bestangle = randomfloat( 360 );
	bestanglefrac = 0;
	
	for ( i = 0; i < numChecks; i++ )
	{
		yaw = ((i * 1.0 + randomfloat(1)) / numChecks) * 360.0;
		angle = (checkPitch, yaw + 180, 0);
		dir = anglesToForward( angle );
		
		endpos = startpos + dir * 1500;
		
		trace = bullettrace( startpos, endpos, false, undefined );
		
		if ( trace["fraction"] > bestanglefrac )
		{
			bestanglefrac = trace["fraction"];
			bestangle = yaw;
		}
		
		if ( i % 3 == 0 )
			wait .05;
	}
	
	return bestangle;
}

nuke()
{
	iPrintLnBold( "INCOMING NUKE!" );
	
	level.nuked = true;
	
	players = getEntArray( "player", "classname" );
	self giveScoreForStreak( ( players.size * 1000 ), ( players.size * 100 ) );
	
	wait 2;
	
	if ( level.mapended )
	{
		level.nuked = false;
		return;
	}
	
	nukehud = newHudElem();
	nukehud.x = 0;
	nukehud.y = 0;
	nukehud setShader( "white", 640, 480 );
	nukehud.alpha = 0;
	nukehud.sort = 5;
	
	org = self.origin;
	
	v2 = spawn( "script_model", org + ( 0, 0, 7500 ) );
	v2 setModel( "xmodel/v2rocket" );
	v2.angles = ( 360, 180, 180 );
	v2 movez( -7300, 2 );
	
	setCullFog( 0, 2500, 1, 1, 1, 2 );
	thread maps\mp\gametypes\_zombie::slowMo( 3 );
	wait 1.8;
	setCullFog( 0, 20, 1, 1, 1, 0.2 );
	wait 0.2;
	v2 delete();
	nukehud.alpha = 1;	
	
	players = getEntArray( "player", "classname" );
	
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[ i ].sessionstate != "playing" )
			continue;

		thread maps\mp\_fx::loopfx( "zombieFire", players[ i ].origin, 0.1 );
		
		if ( players[ i ].pers[ "team" ] == "axis" )
			players[ i ] suicide();
		else
			players[ i ] finishPlayerDamage( self, self, 9999, 0, "MOD_GRENADE", "stielhandgranate_mp", ( players[ i ].origin + (0,0,32) ), vectornormalize( players[ i ].origin - ( players[ i ].origin + (0,0,32) ) ), "none" );
		wait 0.02;
	}

	if ( !level.mapended )
		thread maps\mp\gametypes\_zombie::endGame( "nuke" );
	
	wait 2;
	
	setCullFog( 0, 3500, .45, .95, .18, 3 );
	
	nukehud fadeOverTime( 8 );
	nukehud.alpha = 0;
	wait 10;
	nukehud destroy();
}

getUserLocation()
{
	pos = ( 0, 0, 0 );
	
	self.distancehud = newClientHudElem( self );
	self.distancehud.x = 320;
	self.distancehud.y = 420;
	self.distancehud.alignx = "center";
	self.distancehud.aligny = "middle";
	self.distancehud.alpha = 1;
	self.distancehud.label = &"Feet to target: ";
	self.distancehud.color = ( 0, 1, 0 );
	
	while ( isAlive( self ) )
	{
		traceDir = anglesToForward( self.angles );
		traceEnd = self.origin + ( 0, 0, 64 );
		traceEnd += maps\mp\_utility::vectorScale( traceDir, 10000 );
		trace = bulletTrace( self.origin + ( 0, 0, 64 ), traceEnd, false, undefined );
		
		pos = trace[ "position" ];
		dist = ( distance( self.origin, pos ) / 12 );
		self.distancehud setValue( (int)dist );
		
		if ( self usebuttonpressed() )
		{
			times = 0;
			while ( self usebuttonpressed() && times < 1 )
			{
				wait 0.05;
				times += 0.05;
			}
			break;
		}
		
		wait 0.05;
	}
	
	self.distancehud destroy();
	
	return pos;
}