main()
{
	level.loadingstats = true;
	
	level.loadingmessage = newHudElem();
	level.loadingmessage.x = 320;
	level.loadingmessage.y = 200;
	level.loadingmessage.fontscale = 1;
	level.loadingmessage.alignx = "center";
	level.loadingmessage.aligny = "middle";
	level.loadingmessage setText( &"LOADING STATS" );
	level.loadingmessage.alpha = 1;
	
	level.stats = [];
	hunters = loadstats( "hunters" );
	level.stats[ "hunters" ] = maps\mp\gametypes\_zombie::explode( hunters, ";" );
	zombies = loadstats( "zombies" );
	level.stats[ "zombies" ] = maps\mp\gametypes\_zombie::explode( zombies, ";" );
	points = loadstats( "points" );
	level.stats[ "points" ] = maps\mp\gametypes\_zombie::explode( points, ";" );
	
	wait 1;
	
	level.loadingstats = false;
	level.loadingmessage destroy();
}

saveAll()
{
	thread saveHunterStats();
	thread saveZombieStats();
	thread savePoints();
}


getMyStats()
{
	self.guid = maps\mp\gametypes\_zombie::getNumberedName( self.oldname );
	stats = getPlayerStats( self.guid );

	if ( isDefined( stats ) )
	{
		array = maps\mp\gametypes\_zombie::explode( stats, "," );
		self.xp = (int)array[ 1 ];
		self.rank = (int)array[ 2 ];
	}
	
	zomstats = getZomPlayerStats( self.guid );
		
	if ( isDefined( zomstats ) )
	{
		array = maps\mp\gametypes\_zombie::explode( zomstats, "," );
		self.zomxp = (int)array[ 1 ];
		self.zomrank = (int)array[ 2 ];
	}
	
	points = getPointStats( self.guid );
	if ( isDefined( points ) )
	{
		array = maps\mp\gametypes\_zombie::explode( points, "," );
		self.points = (int)array[ 1 ];
	}
}

getPlayerStats( guid )
{
	array = level.stats[ "hunters" ];
	
	thisguysstats = undefined;
	for ( i = 0; i < array.size; i++ )
	{
		miniarray = maps\mp\gametypes\_zombie::explode( array[ i ], "," );
		if ( guid == miniarray[ 0 ] )
		{
			thisguysstats = array[ i ];
			break;
		}
	}
	
	return thisguysstats;
}

getZomPlayerStats( guid )
{
	array = level.stats[ "zombies" ];
	
	thisguysstats = undefined;
	for ( i = 0; i < array.size; i++ )
	{
		miniarray = maps\mp\gametypes\_zombie::explode( array[ i ], "," );
		if ( guid == miniarray[ 0 ] )
		{
			thisguysstats = array[ i ];
			break;
		}
	}
	
	return thisguysstats;
}

getPointStats( guid )
{
	array = level.stats[ "points" ];
	
	thisguysstats = undefined;
	for ( i = 0; i < array.size; i++ )
	{
		miniarray = maps\mp\gametypes\_zombie::explode( array[ i ], "," );
		if ( guid == miniarray[ 0 ] )
		{
			thisguysstats = array[ i ];
			break;
		}
	}
	
	return thisguysstats;
}

loadStats( team )
{	
	mystats = "";
	if ( team == "hunters" )
	{
		mystats = getCvar( "stats" );
		for ( i = 2; i < 11; i++ )
		{
			mystats += getCvar( "stats" + i );
			wait 0.02;
		}
	}
	else if ( team == "zombies" )
	{	
		mystats = getCvar( "zomstats" );
		for ( i = 2; i < 11; i++ )
		{
			mystats += getCvar( "zomstats" + i );
			wait 0.02;
		}
	}
	else if ( team == "points" )
	{
		mystats = getCvar( "points" );
		for ( i = 2; i < 6; i++ )
		{
			mystats += getCvar( "points" + i );
			wait 0.02;
		}
	}
	
	return mystats;
}

resetStatsVars()
{
/*
	setCvar( "points", "" );
	setCvar( "points2", "" );
	setCvar( "points3", "" );
	setCvar( "points4", "" );
	setCvar( "points5", "" );
	
	setCvar( "stats", "" );
	setCvar( "stats2", "" );
	setCvar( "stats3", "" );
	setCvar( "stats4", "" );
	setCvar( "stats5", "" );
	setCvar( "stats6", "" );
	setCvar( "stats7", "" );
	setCvar( "stats8", "" );
	setCvar( "stats9", "" );
	setCvar( "stats10", "" );
	setCvar( "stats11", "" );
	setCvar( "stats12", "" );
	setCvar( "stats13", "" );
	
	setCvar( "zomstats", "" );
	setCvar( "zomstats2", "" );
	setCvar( "zomstats3", "" );
	setCvar( "zomstats4", "" );
	setCvar( "zomstats5", "" );
	setCvar( "zomstats6", "" );
	setCvar( "zomstats7", "" );
	setCvar( "zomstats8", "" );
	setCvar( "zomstats9", "" );
	setCvar( "zomstats10", "" );	
*/
}

saveHunterStats()
{
	level.statshunters = newHudElem();
	level.statshunters.x = 320;
	level.statshunters.y = 360;
	level.statshunters.alignx = "center";
	level.statshunters.aligny = "middle";
	level.statshunters.alpha = 1;
	level.statshunters.fontscale = 0.9;
	level.statshunters setText( &"saving hunter stats..." );
	
	oldstats = level.stats[ "hunters" ];
	
	players = getEntArray( "player", "classname" );
	
	stats = "";
	stats2 = "";
	stats3 = "";
	stats4 = "";
	stats5 = "";
	stats6 = "";
	stats7 = "";
	stats8 = "";
	stats9 = "";
	stats10 = "";
	stats11 = "";
	stats12 = "";
	stats13 = "";

	for ( i = 0; i < players.size; i++ )
	{
		playername = maps\mp\gametypes\_zombie::getNumberedName( players[ i ].oldname, true );

		xp = players[ i ].xp;
		rank = players[ i ].rank;
		
		string = playername + "," + xp + "," + rank + ";";
		
		if ( xp < 200 )
			continue;

		if ( stats.size > 1000 && stats2.size > 1000 && stats3.size > 1000 && stats4.size > 1000 && stats5.size > 1000 && stats6.size > 1000 && stats7.size > 1000 && stats8.size > 1000 && stats9.size > 1000 && stats10.size > 1000 && stats11.size > 1000 && stats12.size > 1000 )
			stats13 += string;
		else if ( stats.size > 1000 && stats2.size > 1000 && stats3.size > 1000 && stats4.size > 1000 && stats5.size > 1000 && stats6.size > 1000 && stats7.size > 1000 && stats8.size > 1000 && stats9.size > 1000 && stats10.size > 1000 && stats11.size > 1000 )
			stats12 += string;
		else if ( stats.size > 1000 && stats2.size > 1000 && stats3.size > 1000 && stats4.size > 1000 && stats5.size > 1000 && stats6.size > 1000 && stats7.size > 1000 && stats8.size > 1000 && stats9.size > 1000 && stats10.size > 1000 )
			stats11 += string;			
		else if ( stats.size > 1000 && stats2.size > 1000 && stats3.size > 1000 && stats4.size > 1000 && stats5.size > 1000 && stats6.size > 1000 && stats7.size > 1000 && stats8.size > 1000 && stats9.size > 1000 )
			stats10 += string;
		else if ( stats.size > 1000 && stats2.size > 1000 && stats3.size > 1000 && stats4.size > 1000 && stats5.size > 1000 && stats6.size > 1000 && stats7.size > 1000 && stats8.size > 1000 )
			stats9 += string;
		else if ( stats.size > 1000 && stats2.size > 1000 && stats3.size > 1000 && stats4.size > 1000 && stats5.size > 1000 && stats6.size > 1000 && stats7.size > 1000 )
			stats8 += string;			
		else if ( stats.size > 1000 && stats2.size > 1000 && stats3.size > 1000 && stats4.size > 1000 && stats5.size > 1000 && stats6.size > 1000 )
			stats7 += string;
		else if ( stats.size > 1000 && stats2.size > 1000 && stats3.size > 1000 && stats4.size > 1000 && stats5.size > 1000 )
			stats6 += string;
		else if ( stats.size > 1000 && stats2.size > 1000 && stats3.size > 1000 && stats4.size > 1000 )
			stats5 += string;
		else if ( stats.size > 1000 && stats2.size > 1000 && stats3.size > 1000 )
			stats4 += string;
		else if ( stats.size > 1000 && stats2.size > 1000 )
			stats3 += string;
		else if ( stats.size > 1000 )
			stats2 += string;
		else
			stats += string;
			
		wait 0.02;
	}
	
	for ( i = 0; i < oldstats.size; i++ )
	{
		miniarray = maps\mp\gametypes\_zombie::explode( oldstats[ i ], "," );
		found = false;
		
		for ( j = 0; j < players.size; j++ )
		{
			if ( maps\mp\gametypes\_zombie::getNumberedName( players[ j ].oldname, true ) == miniarray[ 0 ] )
			{
				found = true;
				break;
			}
		}
				
		if ( !found && ( isDefined( miniarray[ 1 ] ) && isDefined( miniarray[ 2 ] ) ) )
		{
			rawr = miniarray[ 0 ] + "," + miniarray[ 1 ] + "," + miniarray[ 2 ] + ";";
			
			if ( stats.size > 1000 && stats2.size > 1000 && stats3.size > 1000 && stats4.size > 1000 && stats5.size > 1000 && stats6.size > 1000 && stats7.size > 1000 && stats8.size > 1000 && stats9.size > 1000 && stats10.size > 1000 && stats11.size > 1000 && stats12.size > 1000 )
				stats13 += rawr;
			else if ( stats.size > 1000 && stats2.size > 1000 && stats3.size > 1000 && stats4.size > 1000 && stats5.size > 1000 && stats6.size > 1000 && stats7.size > 1000 && stats8.size > 1000 && stats9.size > 1000 && stats10.size > 1000 && stats11.size > 1000 )
				stats12 += rawr;
			else if ( stats.size > 1000 && stats2.size > 1000 && stats3.size > 1000 && stats4.size > 1000 && stats5.size > 1000 && stats6.size > 1000 && stats7.size > 1000 && stats8.size > 1000 && stats9.size > 1000 && stats10.size > 1000 )
				stats11 += rawr;	
			else if ( stats.size > 1000 && stats2.size > 1000 && stats3.size > 1000 && stats4.size > 1000 && stats5.size > 1000 && stats6.size > 1000 && stats7.size > 1000 && stats8.size > 1000 && stats9.size > 1000 )
				stats10 += rawr;
			else if ( stats.size > 1000 && stats2.size > 1000 && stats3.size > 1000 && stats4.size > 1000 && stats5.size > 1000 && stats6.size > 1000 && stats7.size > 1000 && stats8.size > 1000 )
				stats9 += rawr;
			else if ( stats.size > 1000 && stats2.size > 1000 && stats3.size > 1000 && stats4.size > 1000 && stats5.size > 1000 && stats6.size > 1000 && stats7.size > 1000 )
				stats8 += rawr;
			else if ( stats.size > 1000 && stats2.size > 1000 && stats3.size > 1000 && stats4.size > 1000 && stats5.size > 1000 && stats6.size > 1000 )
				stats7 += rawr;
			else if ( stats.size > 1000 && stats2.size > 1000 && stats3.size > 1000 && stats4.size > 1000 && stats5.size > 1000 )
				stats6 += rawr;
			else if ( stats.size > 1000 && stats2.size > 1000 && stats3.size > 1000 && stats4.size > 1000 )
				stats5 += rawr;
			else if ( stats.size > 1000 && stats2.size > 1000 && stats3.size > 1000 )
				stats4 += rawr;
			else if ( stats.size > 1000 && stats2.size > 1000 )
				stats3 += rawr;
			else if ( stats.size > 1000 )
				stats2 += rawr;
			else
				stats += rawr;
		}
		
		wait 0.02;
	}

	setCvar( "stats", stats );
	setCvar( "stats2", stats2 );
	setCvar( "stats3", stats3 );
	setCvar( "stats4", stats4 );
	setCvar( "stats5", stats5 );
	setCvar( "stats6", stats6 );
	setCvar( "stats7", stats7 );
	setCvar( "stats8", stats8 );
	setCvar( "stats9", stats9 );
	setCvar( "stats10", stats10 );
	setCvar( "stats11", stats11 );
	setCvar( "stats12", stats12 );
	setCvar( "stats13", stats13 );
	
	level.statshunters destroy();
}		

saveZombieStats()
{
	level.statszombies = newHudElem();
	level.statszombies.x = 320;
	level.statszombies.y = 375;
	level.statszombies.alignx = "center";
	level.statszombies.aligny = "middle";
	level.statszombies.alpha = 1;
	level.statszombies.fontscale = 0.9;
	level.statszombies setText( &"saving zombie stats..." );
	
	oldzomstats = level.stats[ "zombies" ];
	
	players = getEntArray( "player", "classname" );
	
	zomstats = "";
	zomstats2 = "";
	zomstats3 = "";
	zomstats4 = "";
	zomstats5 = "";
	zomstats6 = "";
	zomstats7 = "";
	zomstats8 = "";
	zomstats9 = "";
	zomstats10 = "";

	for ( i = 0; i < players.size; i++ )
	{
		playername = maps\mp\gametypes\_zombie::getNumberedName( players[ i ].oldname, true );

		zomxp = players[ i ].zomxp;
		zomrank = players[ i ].zomrank;
		zomstring = playername + "," + zomxp + "," + zomrank + ";";
		
		if ( zomxp < 2 )
			continue;

		if ( zomstats.size > 1000 && zomstats2.size > 1000 && zomstats3.size > 1000 && zomstats4.size > 1000 && zomstats5.size > 1000 && zomstats6.size > 1000 && zomstats7.size > 1000 && zomstats8.size > 1000 && zomstats9.size > 1000 )
			zomstats10 += zomstring;
		else if ( zomstats.size > 1000 && zomstats2.size > 1000 && zomstats3.size > 1000 && zomstats4.size > 1000 && zomstats5.size > 1000 && zomstats6.size > 1000 && zomstats7.size > 1000 && zomstats8.size > 1000 )
			zomstats9 += zomstring;
		else if ( zomstats.size > 1000 && zomstats2.size > 1000 && zomstats3.size > 1000 && zomstats4.size > 1000 && zomstats5.size > 1000 && zomstats6.size > 1000 && zomstats7.size > 1000 )
			zomstats9 += zomstring;
		else if ( zomstats.size > 1000 && zomstats2.size > 1000 && zomstats3.size > 1000 && zomstats4.size > 1000 && zomstats5.size > 1000 && zomstats6.size > 1000 )
			zomstats7 += zomstring;
		else if ( zomstats.size > 1000 && zomstats2.size > 1000 && zomstats3.size > 1000 && zomstats4.size > 1000 && zomstats5.size > 1000 )
			zomstats6 += zomstring;
		else if ( zomstats.size > 1000 && zomstats2.size > 1000 && zomstats3.size > 1000 && zomstats4.size > 1000 )
			zomstats5 += zomstring;
		else if ( zomstats.size > 1000 && zomstats2.size > 1000 && zomstats3.size > 1000 )
			zomstats4 += zomstring;
		else if ( zomstats.size > 1000 && zomstats2.size > 1000 )
			zomstats3 += zomstring;
		else if ( zomstats.size > 1000 )
			zomstats2 += zomstring;
		else
			zomstats += zomstring;
			
		wait 0.02;
	}
	
	for ( i = 0; i < oldzomstats.size; i++ )
	{
		miniarray = maps\mp\gametypes\_zombie::explode( oldzomstats[ i ], "," );
		found = false;
		
		for ( j = 0; j < players.size; j++ )
		{
			if ( maps\mp\gametypes\_zombie::getNumberedName( players[ j ].oldname, true ) == miniarray[ 0 ] )
			{
				found = true;
				break;
			}
		}
		
				
		if ( !found && ( isDefined( miniarray[ 1 ] ) && isDefined( miniarray[ 2 ] ) ) )
		{
			rawr = miniarray[ 0 ] + "," + miniarray[ 1 ] + "," + miniarray[ 2 ] + ";";
			
			if ( zomstats.size > 1000 && zomstats2.size > 1000 && zomstats3.size > 1000 && zomstats4.size > 1000 && zomstats5.size > 1000 && zomstats6.size > 1000 && zomstats7.size > 1000 && zomstats8.size > 1000 && zomstats9.size > 1000 )
				zomstats10 += rawr;
			else if ( zomstats.size > 1000 && zomstats2.size > 1000 && zomstats3.size > 1000 && zomstats4.size > 1000 && zomstats5.size > 1000 && zomstats6.size > 1000 && zomstats7.size > 1000 && zomstats8.size > 1000 )
				zomstats9 += rawr;
			else if ( zomstats.size > 1000 && zomstats2.size > 1000 && zomstats3.size > 1000 && zomstats4.size > 1000 && zomstats5.size > 1000 && zomstats6.size > 1000 && zomstats7.size > 1000 )
				zomstats8 += rawr;
			else if ( zomstats.size > 1000 && zomstats2.size > 1000 && zomstats3.size > 1000 && zomstats4.size > 1000 && zomstats5.size > 1000 && zomstats6.size > 1000 )
				zomstats7 += rawr;
			else if ( zomstats.size > 1000 && zomstats2.size > 1000 && zomstats3.size > 1000 && zomstats4.size > 1000 && zomstats5.size > 1000 )
				zomstats6 += rawr;
			else if ( zomstats.size > 1000 && zomstats2.size > 1000 && zomstats3.size > 1000 && zomstats4.size > 1000 )
				zomstats5 += rawr;
			else if ( zomstats.size > 1000 && zomstats2.size > 1000 && zomstats3.size > 1000 )
				zomstats4 += rawr;
			else if ( zomstats.size > 1000 && zomstats2.size > 1000 )
				zomstats3 += rawr;
			else if ( zomstats.size > 1000 )
				zomstats2 += rawr;
			else
				zomstats += rawr;
		}
		
		wait 0.02;
	}

	setCvar( "zomstats", zomstats );
	setCvar( "zomstats2", zomstats2 );
	setCvar( "zomstats3", zomstats3 );
	setCvar( "zomstats4", zomstats4 );
	setCvar( "zomstats5", zomstats5 );
	setCvar( "zomstats6", zomstats6 );
	setCvar( "zomstats7", zomstats7 );
	setCvar( "zomstats8", zomstats8 );
	setCvar( "zomstats9", zomstats9 );
	setCvar( "zomstats10", zomstats10 );
	
	level.statszombies destroy();
}

savePoints()
{
	level.statspoints = newHudElem();
	level.statspoints.x = 320;
	level.statspoints.y = 390;
	level.statspoints.alignx = "center";
	level.statspoints.aligny = "middle";
	level.statspoints.alpha = 1;
	level.statspoints.fontscale = 0.9;
	level.statspoints setText( &"saving point stats..." );
	
	oldpoints = level.stats[ "points" ];
	
	players = getEntArray( "player", "classname" );
	
	points = "";
	points2 = "";
	points3 = "";
	points4 = "";
	points5 = "";

	for ( i = 0; i < players.size; i++ )
	{
		playername = maps\mp\gametypes\_zombie::getNumberedName( players[ i ].oldname, true );

		mypoints = players[ i ].points;
		string = playername + "," + mypoints + ";";
		
		if ( mypoints < 10 )
			continue;
	
		if ( points.size > 1000 && points2.size > 1000 && points3.size > 1000 && points4.size > 1000 )
			points5 += string;
		else if ( points.size > 1000 && points2.size > 1000 && points3.size > 1000 )
			points4 += string;
		else if ( points.size > 1000 && points2.size > 1000 )
			points3 += string;
		else if ( points.size > 1000 )
			points2 += string;
		else
			points += string;
			
		wait 0.02;
	}
	
	for ( i = 0; i < oldpoints.size; i++ )
	{
		miniarray = maps\mp\gametypes\_zombie::explode( oldpoints[ i ], "," );
		found = false;
		
		for ( j = 0; j < players.size; j++ )
		{
			if ( maps\mp\gametypes\_zombie::getNumberedName( players[ j ].oldname, true ) == miniarray[ 0 ] )
			{
				found = true;
				break;
			}
		}
	
		if ( !found && isDefined( miniarray[ 1 ] ) )
		{
			rawr = miniarray[ 0 ] + "," + miniarray[ 1 ] + ";";
			
			if ( points.size > 1000 && points2.size > 1000 && points3.size > 1000 && points4.size > 1000 )
				points5 += rawr;
			else if ( points.size > 1000 && points2.size > 1000 && points3.size > 1000 )
				points4 += rawr;
			else if ( points.size > 1000 && points2.size > 1000 )
				points3 += rawr;
			else if ( points.size > 1000 )
				points2 += rawr;
			else
				points += rawr;
		}
		
		wait 0.02;
	}

	setCvar( "points", points );
	setCvar( "points2", points2 );
	setCvar( "points3", points3 );
	setCvar( "points4", points4 );
	setCvar( "points5", points5 );
	
	level.statspoints destroy();
}	