main()
{
	//zombies\server_provider::main();
	
	precacheString( &"^1zomb^7ies ^2rev^712" );
	precacheString( &"mod by ^3cheese" );
	precacheString( &"xfire^2:^7 thecheeseman999" );
	
	thread setupValues();
	thread setupServerMessages();
	thread setupWelcomeMessages();
	thread logo();
}


logo()
{
	level.logo = newHudElem();
	level.logo.x = 15;
	level.logo.y = 15;
	level.logo.alignx = "left";
	level.logo.aligny = "middle";
	level.logo.fontscale = 0.9;
	level.logo.archived = true;
	/*
	level.serverprovider = newHudElem();
	level.serverprovider.x = 320;
	level.serverprovider.y = 470;
	level.serverprovider.alignx = "center";
	level.serverprovider.aligny = "middle";
	level.serverprovider.fontscale = 0.9;
	level.serverprovider.alpha = 0;
	level.serverprovider.archived = true;
	level.serverprovider setText( level.provider );
	*/
	while ( 1 )
	{
		level.logo.alpha = 0;
		level.logo setText( &"^1zomb^7ies ^2rev^712" );
		level.logo fadeOverTime( 2 );
		level.logo.alpha = 1;
		
		wait 8;
		
		level.logo fadeOverTime( 2 );
		level.logo.alpha = 0;
		
		wait 2;
		
		level.logo setText( &"mod by ^3cheese" );
		level.logo fadeOverTime( 2 );
		level.logo.alpha = 1;
		
		wait 8;
		
		level.logo fadeOverTime( 2 );
		level.logo.alpha = 0;
		
		wait 2;
		
		level.logo setText( &"xfire^2:^7 thecheeseman999" );
		level.logo fadeOverTime( 2 );
		level.logo.alpha = 1;
		
		wait 8;
		
		level.logo fadeOverTime( 2 );
		level.logo.alpha = 0;
		
		wait 2;
	}
}

setupValues()
{
	level.debug = (int)cvardef( "zom_debug", 0, 0, 1, "int" );
	level.doublepointday = (int)cvardef( "zom_xp_doublepointday", 0, 0, 1, "int" );
	
	increase = 1;
	if ( level.doublepointday )
		increase = 2;
		
	level.xpvalues = [];
	level.xpvalues[ "MOD_EXPLOSIVE" ] = ( (int)cvardef( "zom_xp_explosive", 25, 0, 100000, "int" ) ) * increase;
	level.xpvalues[ "MOD_EXPLOSIVE_SPLASH" ] = ( (int)cvardef( "zom_xp_explosive_splash", 25, 0, 100000, "int" ) ) * increase;
	level.xpvalues[ "MOD_GRENADE" ] = ( (int)cvardef( "zom_xp_grenade", 25, 0, 100000, "int" ) ) * increase;
	level.xpvalues[ "MOD_GRENADE_SPLASH" ] = ( (int)cvardef( "zom_xp_grenade_splash", 25, 0, 100000, "int" ) ) * increase;
	level.xpvalues[ "MOD_HEAD_SHOT" ] = ( (int)cvardef( "zom_xp_headshot", 20, 0, 100000, "int" ) ) * increase;
	level.xpvalues[ "MOD_MELEE" ] = ( (int)cvardef( "zom_xp_melee", 30, 0, 100000, "int" ) ) * increase;
	level.xpvalues[ "MOD_PROJECTILE" ] = ( (int)cvardef( "zom_xp_projectile", 25, 0, 100000, "int" ) ) * increase;
	level.xpvalues[ "MOD_PROJECTILE_SPLASH" ] = ( (int)cvardef( "zom_xp_projectile_splash", 25, 0, 100000, "int" ) ) * increase;
	level.xpvalues[ "MOD_RIFLE_BULLET" ] = ( (int)cvardef( "zom_xp_rifle_bullet", 10, 0, 100000, "int" ) ) * increase;
	level.xpvalues[ "MOD_PISTOL_BULLET" ] = ( (int)cvardef( "zom_xp_pistol_bullet", 20, 0, 100000, "int" ) ) * increase;
	level.xpvalues[ "ASSISTS" ] = ( (int)cvardef( "zom_xp_assists", 10, 0, 100000, "int" ) ) * increase;
	level.xpvalues[ "HUNTER_WIN" ] = ( (int)cvardef( "zom_xp_hunter_win", 5000, 0, 100000, "int" ) ) * increase;
	level.xpvalues[ "LASTHUNTER" ] = ( (int)cvardef( "zom_xp_lasthunter", 500, 0, 100000, "int" ) ) * increase;
	level.xpvalues[ "TIMEALIVE" ] = ( (int)cvardef( "zom_xp_timealive", 10, 0, 100000, "int" ) ) * increase;
	level.xpvalues[ "enfield_mp" ] = ( (int)cvardef( "zom_xp_enfield_mp", 25, 0, 100000, "int" ) ) * increase;
	level.xpvalues[ "sten_mp" ] = ( (int)cvardef( "zom_xp_sten_mp", 10, 0, 100000, "int" ) ) * increase;
	level.xpvalues[ "bren_mp" ] = ( (int)cvardef( "zom_xp_bren_mp", 35, 0, 100000, "int" ) ) * increase;
	level.xpvalues[ "springfield_mp" ] = ( (int)cvardef( "zom_xp_springfield_mp", 20, 0, 100000, "int" ) ) * increase;
	level.xpvalues[ "colt_mp" ] = ( (int)cvardef( "zom_xp_colt_mp", 10, 0, 100000, "int" ) ) * increase;
	level.xpvalues[ "mk1britishfrag_mp" ] = ( (int)cvardef( "zom_xp_mk1britishfrag_mp", 10, 0, 100000, "int" ) ) * increase;
	
	level.pointvalues = [];
	level.pointvalues[ "KILL" ] = ( (int)cvardef( "zom_point_kill", 10, 0, 100000, "int" ) ) * increase;
	level.pointvalues[ "ASSISTS" ] = ( (int)cvardef( "zom_point_assists", 5, 0, 100000, "int" ) ) * increase;
	level.pointvalues[ "HUNTER_WIN" ] = ( (int)cvardef( "zom_point_hunter_win", 500, 0, 100000, "int" ) ) * increase;
	level.pointvalues[ "LASTHUNTER" ] = ( (int)cvardef( "zom_point_lasthunter", 50, 0, 100000, "int" ) ) * increase;
	level.pointvalues[ "RANKUP" ] = ( (int)cvardef( "zom_point_rankup", 25, 0, 100000, "int" ) ) * increase;
	
	level.cvars = [];
	level.cvars[ "BOMB_DAMAGE_MAX" ] = (int)cvardef( "zom_bomb_damage_max", 75, 0, 100000, "int" );
	level.cvars[ "BOMB_DAMAGE_MIN" ] = (int)cvardef( "zom_bomb_damage_min", 10, 0, 100000, "int" );
	level.cvars[ "BOMB_TIME" ] = (int)cvardef( "zom_bomb_time", 8, 0, 100000, "int" );
	
	level.cvars[ "MAX_BARRICADES" ] = (int)cvardef( "zom_max_barricades", 200, 0, 10000, "int" );
}

setupServerMessages()
{
	level.servermessages = [];
	i = 0;
	while ( getCvar( "zom_servermessage" + i ) != "" )
	{
		level.servermessages[ i ] = getCvar( "zom_servermessage" + i );
		i++;
		wait 0.02;
	}
	
	thread runServerMessages();
}

runServerMessages()
{
	if ( level.servermessages.size == 0 )
		return;
		
	level endon( "endgame" );
	level endon( "intermission" );
		
	i = 0;
	while ( 1 )
	{
		if ( i > level.servermessages.size )
			i = 0;
			
		iPrintLn( level.servermessages[ i ] );
			
		wait 20;
		
		i++;
	}
}

setupWelcomeMessages()
{
	level.welcomemessages = [];
	i = 0;
	while ( getCvar( "zom_welcomemessage" + i ) != "" )
	{
		level.welcomemessages[ i ] = getCvar( "zom_welcomemessage" + i );
		i++;
		wait 0.02;
	}
}

welcomeMessage()
{
	for ( i = 0; i < level.welcomemessages.size; i++ )
	{
		self iPrintLnBold( level.welcomemessages[ i ] );
		wait 2;
	}
}

/*
USAGE OF "cvardef"
cvardef replaces the multiple lines of code used repeatedly in the setup areas of the script.
The function requires 5 parameters, and returns the set value of the specified cvar
Parameters:
	varname - The name of the variable, i.e. "scr_teambalance", or "scr_dem_respawn"
		This function will automatically find map-sensitive overrides, i.e. "src_dem_respawn_mp_brecourt"

	vardefault - The default value for the variable.  
		Numbers do not require quotes, but strings do.  i.e.   10, "10", or "wave"

	min - The minimum value if the variable is an "int" or "float" type
		If there is no minimum, use "" as the parameter in the function call

	max - The maximum value if the variable is an "int" or "float" type
		If there is no maximum, use "" as the parameter in the function call

	type - The type of data to be contained in the vairable.
		"int" - integer value: 1, 2, 3, etc.
		"float" - floating point value: 1.0, 2.5, 10.384, etc.
		"string" - a character string: "wave", "player", "none", etc.
*/
cvardef(varname, vardefault, min, max, type)
{
	switch(type)
	{
		case "int":
			if(getcvar(varname) == "")
				definition = vardefault;
			else
				definition = getcvarint(varname);
			break;
		case "float":
			if(getcvar(varname) == "")
				definition = vardefault;
			else
				definition = getcvarfloat(varname);
			break;
		case "string":
		default:
			if(getcvar(varname) == "")
				definition = vardefault;
			else
				definition = getcvar(varname);
			break;
	}

	if((type == "int" || type == "float") && min != "" && definition < min)
		definition = min;

	if((type == "int" || type == "float") && max != "" && definition > max)
		definition = max;

	return definition;
}