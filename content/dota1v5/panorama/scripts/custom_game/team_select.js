"use strict";

var playerPanels = {};

/* Select a hero, called when a player clicks a hero panel in the layout */
function SelectHero( heroName ) {
	//Send the pick to the server
	//GameEvents.SendCustomGameEventToServer( "hero_selected", { HeroName: heroName } );
	$.Msg(heroName);
}


