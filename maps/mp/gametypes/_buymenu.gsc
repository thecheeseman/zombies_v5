init()
{
	level.points = [];
	level.points[ "buy_armor_10" ] = 100;
	level.points[ "buy_armor_25" ] = 250;
	level.points[ "buy_armor_50" ] = 500;
	level.points[ "buy_explo_10" ] = 100;
	level.points[ "buy_explo_25" ] = 250;
	level.points[ "buy_explo_50" ] = 500;
	level.points[ "buy_damage_10" ] = 100;
	level.points[ "buy_damage_25" ] = 250;
	level.points[ "buy_healthpack" ] = 100;
	level.points[ "buy_proxy" ] = 100;
	level.points[ "buy_crate" ] = 100;
	level.points[ "buy_barrel" ] = 200;
	level.points[ "rocket" ] = 2500;
	level.points[ "mortar" ] = 5000;
	level.points[ "artillery" ] = 7500;
	level.points[ "gatlin" ] = 10000;
	level.points[ "airstrike" ] = 15000;
	level.points[ "carpetbomb" ] = 20000;
	level.points[ "nuke" ] = 25000;
	level.points[ "random" ] = 100;
	level.points[ "buy_panzer" ] = 1000;
	level.points[ "buy_flashnades" ] = 500;
	level.points[ "buy_nightvision" ] = 500;
	level.points[ "nothing" ] = 0;
	
	level.pointsnames = [];
	level.pointsnames[ "buy_armor_10" ] = "100 Armor";
	level.pointsnames[ "buy_armor_25" ] = "250 Armor";
	level.pointsnames[ "buy_armor_50" ] = "500 Armor";
	level.pointsnames[ "buy_explo_10" ] = "100 Explosion Armor";
	level.pointsnames[ "buy_explo_25" ] = "250 Explosion Armor";
	level.pointsnames[ "buy_explo_50" ] = "500 Explosion Armor";
	level.pointsnames[ "buy_damage_10" ] = "10% Damage Increase";
	level.pointsnames[ "buy_damage_25" ] = "25% Damage Increase";
	level.pointsnames[ "buy_healthpack" ] = "a Healthpack";
	level.pointsnames[ "buy_proxy" ] = "a Proxy";
	level.pointsnames[ "buy_crate" ] = "a Crate";
	level.pointsnames[ "buy_barrel" ] = "a Barrel";
	level.pointsnames[ "rocket" ] = "Rocket Attack";
	level.pointsnames[ "mortar" ] = "Mortar Strike";
	level.pointsnames[ "artillery" ] = "Artillery Barrage";
	level.pointsnames[ "airstrike" ] = "Airstrike";
	level.pointsnames[ "gatlin" ] = "a Gatlin Gun";
	level.pointsnames[ "carpetbomb" ] = "a Carpet Bomb";
	level.pointsnames[ "nuke" ] = "a Nuke";
	level.pointsnames[ "buy_panzer" ] = "a Panzerfaust";
	level.pointsnames[ "buy_flashnades" ] = "Flashbangs";
	level.pointsnames[ "buy_nightvision" ] = "Nightvision";
	level.pointsnames[ "nothing" ] = "absolutely nothing";
	
	precacheModel( "xmodel/barrel_black1" );
	precacheModel( "xmodel/crate_misc_red2" );
	
	level.barricades = 0;
}

buymenu( response )
{
	if ( self.pers[ "team" ] != "axis" )
		return;
		
	if ( self.sessionstate != "playing" )
		return;
		
	if ( !isDefined( level.points[ response ] ) )
	{
		self iPrintLnBold( "No such item exists." );
		return;
	}
	
	if ( self.points < level.points[ response ] )
	{
		self iPrintLnBold( "You don't have enough points to buy that item." );
		return;
	}
	
	if ( response == "random" )
	{
		self.points -= level.points[ response ];
		self thread doRandom();
	}
	else
	{
		if ( self doItem( response ) )
		{		
			self iprintlnbold( "You bought ^2" + level.pointsnames[ response ] + "^7 for " + level.points[ response ] + " points." );
			self.points -= level.points[ response ];
		}
	}
}

doItem( response )
{
	switch ( response )
	{
		case "buy_armor_10":
			if ( self.bodyarmor >= 1500 )
			{
				self iprintlnbold( "You cannot hold any more ^2Body Armor^7!" );
				return false;
			}
			self.bodyarmor += 100;
			break;
		case "buy_armor_25":
			if ( self.bodyarmor >= 1500 )
			{
				self iprintlnbold( "You cannot hold any more ^2Body Armor^7!" );
				return false;
			}
			self.bodyarmor += 250;
			break;
		case "buy_armor_50":
			if ( self.bodyarmor >= 1500 )
			{
				self iprintlnbold( "You cannot hold any more ^2Body Armor^7!" );
				return false;
			}
			self.bodyarmor += 500;
			break;
		case "buy_explo_10":
			if ( self.exploarmor >= 1500 )
			{
				self iprintlnbold( "You cannot hold any more ^2Explosion Armor^7!" );
				return false;
			}
			self.exploarmor += 100;
			break;
		case "buy_explo_25":
			if ( self.exploarmor >= 1500 )
			{
				self iprintlnbold( "You cannot hold any more ^2Explosion Armor^7!" );
				return false;
			}
			self.explormor += 250;
			break;
		case "buy_explo_50":
			if ( self.exploarmor >= 1500 )
			{
				self iprintlnbold( "You cannot hold any more ^2Explosion Armor^7!" );
				return false;
			}
			self.exploarmor += 500;
			break;
		case "buy_damage_10":
			if ( self.damagearmor == 0.10 )
			{
				self iprintlnbold( "You already have ^210% Damage Increase^7." );
				return false;
			}
			if ( self.damagearmor > 0.10 )
			{
				self iprintlnbold( "You already have a HIGHER value Damage Increase." );
				return false;
			}
			
			self.damagearmor = 0.10;
			break;
		case "buy_damage_25":
			if ( self.damagearmor == 0.25 )
			{
				self iprintlnbold( "You already have ^225% Damage Increase^7." );
				return false;
			}
			
			self.damagearmor = 0.25;
			break;
		case "buy_healthpack":
			self.healthpacks++;
			break;
		case "buy_proxy":
			self.stickynades++;
			break;
		case "buy_crate":
		case "buy_barrel":
			if ( level.barricades > level.cvars[ "MAX_BARRICADES" ] )
			{
				self iPrintLnBold( "Too many barricades in map." );
				self.points += level.points[ response ];
				return false;
			}
			
			self thread barricade( response );
			break;
		case "rocket":
		case "mortar":
		case "artillery":
		case "gatlin":
		case "airstrike":
		case "carpetbomb":
		case "nuke":
			self.powerup = response;
			self thread maps\mp\gametypes\_killstreaks::notifyPowerup();
			break;
		case "buy_panzer":
			self setWeaponSlotWeapon( "primaryb", "panzerfaust_mp" );
			self setWeaponSlotAmmo( "primaryb", 5 );
			self switchToWeapon( "panzerfaust_mp" );
			break;
		case "buy_flashnades":
			self setWeaponSlotWeapon( "grenade", "fraggrenade_mp" );
			if ( level.gamestarted ) 
				self setWeaponSlotAmmo( "grenade", self.stickynades );
			self switchToWeapon( "fraggrenade_mp" );
			break;
		case "buy_nightvision":
			if ( self.nightvision )
			{
				self iPrintLnBold( "You already have Nightvision!" );
				self.points += level.points[ response ];
				return false;
			}
			
			self thread maps\mp\gametypes\_hud::nightvision();
			break;
	}
	
	return true;
}

doRandom()
{
	i = maps\mp\gametypes\_zombie::_randomInt( 10000 );
	
	self iPrintLnBold( "You spent 100 points for a random item and got..." );
	
	if ( i < 7875 )
		resp = "nothing";
	else if ( i >= 7875 && i < 8000 )
		resp = "buy_healthpack";
	else if ( i >= 8000 && i < 8125 )
		resp = "buy_proxy";
	else if ( i >= 8125 && i < 8250 )
		resp = "airstrike";
	else if ( i >= 8250 && i < 8375 )
		resp = "carpetbomb";
	else if ( i >= 8375 && i < 8500 )
		resp = "buy_damage_10";
	else if ( i >= 8500 && i < 8625 )
		resp = "buy_damage_25";
	else if ( i >= 8625 && i < 8750 )
		resp = "buy_armor_10";
	else if ( i >= 8750 && i < 8875 )
		resp = "buy_armor_25";
	else if ( i >= 8875 && i < 9000 )
		resp = "buy_armor_50";
	else if ( i >= 9000 && i < 9125 )
		resp = "buy_explo_10";
	else if ( i >= 9125 && i < 9250 )
		resp = "buy_explo_25";
	else if ( i >= 9250 && i < 9375 )
		resp = "buy_explo_50";
	else if ( i >= 9375 && i < 9500 )
		resp = "rocket";
	else if ( i >= 9500 && i < 9625 )
		resp = "mortar";
	else if ( i >= 9625 && i < 9750 )
		resp = "artillery";
	else if ( i >= 9750 && i < 9950 )
		resp = "gatlin";
	else if ( i >= 9950 && i < 10000 )
		resp = "nuke";
		
	self iPrintLnBold( "^2" + level.pointsnames[ resp ] + "!" );
		
	if ( resp != "nothing" )
		self thread doItem( resp );
}

barricade( item )
{
	switch ( item )
	{
		case "buy_barrel":
			model = "xmodel/barrel_black1";
			clip = [];
			clip[ 0 ] = ( 0, 0, 40 );
			trigdistance = 40;
			break;
		case "buy_crate":
			model = "xmodel/crate_misc_red2";
			clip = [];
			clip[ 0 ] = ( 0, 0, 24 );
			trigdistance = 32;
			break;
	}
	
	if ( isDefined( model ) )
		self thread spawn_barricade( model, clip, trigdistance );
}

spawn_barricade( model, clip, trigdistance )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "spawn_spectator" );
	
	num = self.barricades.size;
	org = self.origin;
	totalmodels = 1;
	
	self.barricades[ num ] = spawnstruct();
	self.barricades[ num ].model = spawn( "script_model", org );
	self.barricades[ num ].model setModel( model );
	self.barricades[ num ].model enablelinkto();
	wait 0.05;
	
	self.barricades[ num ].clip = [];
	
	for ( i = 0; i < clip.size; i++ )
	{
		self.barricades[ num ].clip[ i ] = spawn( "script_model", org + clip[ i ] );
		self.barricades[ num ].clip[ i ] setModel( model );
		self.barricades[ num ].clip[ i ] linkto( self.barricades[ num ].model );
		self.barricades[ num ].clip[ i ] hide();
		totalmodels++;
		wait 0.05;
	}
	
	level.barricades += totalmodels;
	
	self.barricades[ num ].model thread maps\mp\gametypes\_physics::doPhysics();
	
	while ( distance( self.origin, org ) < trigdistance )
		wait 0.05;
		
	self.barricades[ num ].model setContents( 1 );
	for ( i = 0; i < clip.size; i++ )
		self.barricades[ num ].clip[ i ] setContents( 1 );
}

cleanUp()
{
	totalmodels = 0;
	for ( i = 0; i < self.barricades.size; i++ )
	{
		self.barricades[ i ] notify( "stop_physics" );
		self.barricades[ i ].model delete();
		totalmodels++;
		
		for ( j = 0; j < self.barricades[ i ].clip.size; j++ )
		{
			self.barricades[ i ].clip[ j ] delete();
			totalmodels++;
		}
	}
	
	level.barricades -= totalmodels;
}