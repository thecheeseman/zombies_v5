main()
{
	mapname = maps\mp\gametypes\_zombie::toLower( getCvar( "mapname" ) );
	switch ( mapname )
	{
		case "mp_harbor":
			thread scanner( -115 );
			thread add_block( "xmodel/barrel_black1", ( -10063, -8608, 168 ), 1, 40 );
			thread add_block( "xmodel/barrel_black1", ( -11848, -7969, 168 ), 1, 40 );
			thread add_block( "xmodel/barrel_black1", ( -11817, -7504, 168 ), 1, 40 );
			break;
		case "quarantine":
			thread scanner( -127 );
			break;
		case "alcatraz":
			thread scanner( -207 );
			break;
	}
}

scanner( z )
{
	level endon( "intermission" );
	
	while ( 1 )
	{
		players = getEntArray( "player", "classname" );
		for ( i = 0; i < players.size; i++ )
		{
			if ( players[ i ].sessionstate != "playing" )
				continue;
				
			myorg = players[ i ] getOrigin();
			if ( myorg[ 2 ] <= z )
			{
				players[ i ] suicide();
				iPrintLn( players[ i ].name + "^7 was killed for being a shark." );
			}
		}
		
		wait 0.05;
	}
}

add_block( modelName, origin, clipAmount, clipAdd )
{
	model = spawn( "script_model", origin );
	model setModel( modelName );
	model setContents( 1 );
	model hide();
	
	cur = clipAdd;
	
	for ( i = 0; i < clipAmount; i++ )
	{
		clip = spawn( "script_model", origin );
		clip.origin += ( 0, 0, cur );
		cur += clipAdd;
		clip setModel( modelName );
		clip setContents( 1 );
		clip hide();
	}
}