/*
    Copyright (c) 2021 KBoardGames.com
    This program is part of KBoardGames server software.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

package;

/**
 * ...
 * @author kboardgames.com
 */
//######################## NOTES ################################
// The invalid operation errors on Neko come from uninitialized variables (int, bool, float), since these are by default null on Neko.

// Checking for null errors are important. The build error on neko, the invalid operation, come from uninitialized variables. To fix do var foo:int = 0. The 0 initializes that variable.
//###############################################################

/************************************************************************************
* all game data for all games are here.
*/
typedef DataGame = {
	id: String,					// id refers to a particular player.
	_room: Int					// current room that the user is in. zero 
}

typedef DataGame0 = {
	id: String,					// id refers to a particular player.
	_gameUnitNumberNew: Int,		// unit number. 0-64
	_gameUnitNumberOld: Int,		// unit number. 0-64
	_gameXXold:Int,				// unit x coordinate. you have requested this gameboard piece.
	_gameYYold:Int,				// unit y coordinate. you have requested this gameboard piece.
	_gameXXnew:Int,				// unit x coordinate. you have requested a piece be moved here.
	_gameYYnew:Int,				// unit y coordinate. you have requested a piece be moved here.
	_gameXXold2:Int,				// unit x coordinate. you have requested this gameboard piece.
	_gameYYold2:Int,				// unit y coordinate. you have requested this gameboard piece.
	_triggerNextStuffToDo:Int,	// used to determine if the pawn is En Passant.
	_room: Int,					// current room that the user is in. zero equals no room.
	_isThisPieceAtBackdoor:Bool,			// each board game should use this for only one var.
}

typedef DataGame1 = {
	id: String,					// id refers to a particular player.
	_pieceValue: Int,				// this is the point value of each piece on the standard game board
	_uniqueValue: Int,			// unique value of a piece.
	_gameUnitNumberNew: Int,		// unit number. 0-64
	_gameUnitNumberOld: Int,		// unit number. 0-64
	_gameUnitNumberNew2: Int,		// unit number. 0-64
	_gameUnitNumberOld2: Int,		// unit number. 0-64
	_gameXXold:Int,				// unit x coordinate. you have requested this gameboard piece.
	_gameYYold:Int,				// unit y coordinate. you have requested this gameboard piece.
	_gameXXnew:Int,				// unit x coordinate. you have requested a piece be moved here.
	_gameYYnew:Int,				// unit y coordinate. you have requested a piece be moved here.
	_gameXXold2:Int,				// unit x coordinate. you have requested this gameboard piece.
	_gameYYold2:Int,				// unit y coordinate. you have requested this gameboard piece.
	_gameXXnew2:Int,				// unit x coordinate. you have requested a piece be moved here.
	_gameYYnew2:Int,				// unit y coordinate. you have requested a piece be moved here.
	_isEnPassant:Bool,			// is pawn En passant? 
	_isEnPassantPawnNumber:Array<Int>,// the most recent pawn in En passant.
	_triggerNextStuffToDo:Int,	// used to determine if the pawn is En Passant.
	_pointValue2:Int,				// castling vars to move the rook.
	_uniqueValue2:Int,			// castling vars.
	_promotePieceLetter:String,// this is the letter used in notation of a promoted piece selected.
	_doneEnPassant:Bool,		// for notation.
	_room: Int,					// current room that the user is in. zero equals no room.
}

typedef DataGame2 = {
	id: String,					// id refers to a particular player.
	_gameXXold:Int,				// unit x coordinate. you have requested this gameboard piece.
	_gameYYold:Int,				// unit y coordinate. you have requested this gameboard piece.
	_triggerNextStuffToDo:Int,	// used to determine if the pawn is En Passant.
	_pointValue2:Int,				// castling vars to move the rook.
	_room: Int,					// current room that the user is in. zero equals no room.
}

typedef DataGame3 = {
	id: String,	
	_gameUnitNumberNew: Int,		// unit number. 0-64
	_triggerEventForAllPlayers:Bool,			// is pawn En passant? 
	// the most recent pawn in En passant.
	_triggerNextStuffToDo:Int,	// used to determine if the pawn is En Passant. also in reversi, if all 4 discs have been placed on the board.
	_rolledA6:Bool,		// move again.
	_room: Int,					// current room that the user is in. zero equals no room.
}

typedef DataGame4 = {
	id: String,					// id refers to a particular player.
	_gameXXold:Int,				// unit x coordinate. you have requested this gameboard piece.
	_gameYYold:Int,				// unit y coordinate. you have requested this gameboard piece.
	_gameXXnew:Int,				// unit x coordinate. you have requested a piece be moved here.
	_gameYYnew:Int,				// unit y coordinate. you have requested a piece be moved here.
	_gameXXold2:Int,			// used in trade unit. this is the player that is moving piece. player would like to trade this unit.
	_gameYYold2:Int,			// used in trade unit. this is the player that is moving piece. player would like to trade this unit.
	_gameXXnew2:Int,			// used in trade unit. this is the other player's unit. player moving would like to trade other player's unit.
	_gameYYnew2:Int,			// used in trade unit. this is the other player's unit. player moving would like to trade other player's unit.
	_room: Int,					// current room that the user is in. zero equals no room.
	_rentBonus:Array<Float>,		// total rent bonus in game.
	_gameUniqueValueForPiece:Array<Array<Int>>, // -1 = not used. 0 = nobody owns this unit. 1 = player 1's unit. 2:player 2's unit. 3:player 3's unit. 4:player 4's unit.
	_gameHouseAmountPerPiece:Array<Array<Int>>,	//amount of houses on each unit.
	_gameUndevelopedValueOfUnit:Array<Int>, // Undeveloped units. no houses, nobody owns this unit when a value for that unit equals not 1.
	_unitNumberTrade:Array<Int> // used when trading units. this holds the value of a unit number. this var is useful. it can change an ownership of a unit. see Reg._gameUniqueValueForPiece.
}

// sync movement.
typedef DataSyncMovement = 
{
	id: String, // player instance. this tells one player from another. 
	_gameDiceMaximumIndex: Int, // unit number. 0-64
	_triggerNextStuffToDo:Int, // used to determine if the pawn is En Passant. also in reversi, if all 4 discs have been placed on the board.
	_room: Int, // current room that the user is in. zero equals no room.
}

typedef DataGameMessage = {
	id: String,	
	_room: Int,					// current room that the user is in. zero equals no room.
	_gameMessage:String,		// an example of this would be a chess game where a player just received a message saying that the king is in check. this event sends that same message to the other party.	
	_userTo: String,
	_userFrom: String,
	_questionAnsweredAs: Bool, // this var can hold any message.
}
/************************************************************************************
 * all game buttons, chat, restart, etc.
 */
typedef DataQuestions = {
	id: String,					// id refers to a particular player.
	_drawOffer:Bool,				// chess draw offer. false=not yet asked. true=yes.
	_drawAnsweredAs:Bool,			// chess draw was answered as, false:no, true:yes 
	_restartGameOffer:Bool,			// restart game offer. false=not yet asked. true=yes.
	_restartGameAnsweredAs:Bool,		// restart game was answered as, false:no, true:yes.
	_room: Int,					// current room that the user is in. zero equals no room.
}

// every player's name, win, lose, draw, etc data.
typedef DataOnlinePlayers = 
{
	id:String,
	_room: Int,					// current room that the user is in. zero equals no room.
	_usernamesOnline:Array<String>,	// players names that are online.
	_gameAllTotalWins:Array<Int>,			// any game played. players game wins of players online.
	_gameAllTotalLosses:Array<Int>,			// any game played. players game losses of players online.
	_gameAllTotalDraws:Array<Int>			// any game played. players game draws of players online.		
}

// anything account related us here.
typedef DataAccount = {
	id: String,
	_popupMessage: String, 			// the current message to be displayed as a dialog or popup box.
	_username: String,			// the username of the player.
	_salt: String,				// the encrypted password.
	_password: String,			// the unencrypted password.
	_host: String,				// used to return the this local hosts name.
	_ip:String,					// ip of player.
	_alreadyOnlineHost: Bool,		// is there two computers with the same host name connected to server?
	_alreadyOnlineUser: Bool		// is there already a user with that username online?
	
}

// what sets this typedef apart is the room data. here is room, roomState, _roomPlayerLimit, etc.
typedef DataMisc = {
	id: String,
	_room: Int,							// current room that the user is in. zero equals no room.
	_username: String,					// the username of the player.
	_roomState: Array<Int>,				// 0 = empty, 1 creating room, 2 = waiting to play game. 3 = second player in room. 4 third player if any. 5 - forth player if any. 6 - room full, 7 playing game. 8 game ended.
	_roomPlayerLimit: Array<Int>,		// maximum number of players that can play the selected game.
	_roomPlayerCurrentTotal: Array<Int>,// current total of players in a room.
	// used to list the games at lobby. see Reg.gameName(). also, for not a host player, the data from here will populate _miscState._data._gameId for that player. 
	//-1: no data, 0:checkers, 1:chess, etc.
	_roomGameIds: Array<Int>,
	_roomHostUsername: Array<String>,	// a list of every username that is a host of a room.
	_userLocation: Int,					// currently where the user is at. lobby, roomID, etc. 0:lobby, 1:creating room, 2:roomID, 3:room game playing.
	_chat: String,						// chat text of the player.
	_gameRoom: Bool,					// should player enter the game room?
	_clientCommandMessages: String,				// kick or ban message. player blocked other player for some time or from playing again at that room for that session.
	_clientCommandUsers: String,
	_clientCommandIPs: String,
	
}

	// if a playersState event is sending data to the server then remember that the server broadcasts to a room depending on the value of _room. therefore, before that event is sent from client, at client the _playersState room must equal _gameState._data._room.
	
	// note that id and room vars exists at each of these typedef containers. room var value must be taken from the _gameState. so if you are passing _miscState, remember to get the room state from _miscState first or _miscState if that was the last typedef used. by default, the id's are all the same value. you do not need to be concerned with typedef ID's.
	
	// if you forget to get the value of a room before sending to the client, the server will not return the data to the client at the correct room. either no data will be sent to the client event or a different player will get the data.
typedef DataPlayers = {
	id: String,
	_username: String,				// username of the cilent.
	_usernames:Array<String>,		// the player in a room or playing a game.
	_usernamesFromRoomID:Array<String>,
	_spectator:Bool,				// user watching the game being played. quit game or time ran out for this player. this player was once playing a game. when doing spectators for anyone to watch, that must be a different name.
	_gamePlayersValues:Int,			// 0: = not playing but still at game room. 1: playing a game. 2: left game room while still playing it. 3: left game or game room when game was over.4: quit game.
	// this var is used to display players who are waiting for a game at the game room and to get the _count of how many players are waiting at game room.
	_moveNumberDynamic:Array<Int>,
	_room: Int,						// current room that the user is in. zero equals no room.
	// this is needed to save a game win to thw game being played. if chess is being played and player won that game then this var will be used to save a win to chess, not just the overall wins of any game played.
	_gameId: Int,
	_gameAllTotalWins:Array<Int>,			// total game wins of host player.
	_gameAllTotalLosses:Array<Int>,			// total game losses of host player.
	_gameAllTotalDraws:Array<Int>,			// total game draws of host player.
	_gameName:String,				// the game being played.
	_usernameInvite:String,			// username of the sent room invite.
	_gameMessage:String,			// an example of this would be a chess game where a player just received a message saying that the king is in check. 
	_actionWho:String,				// player that you want something done to.
	_actionNumber:Int,				// refers to an action, eg, 1 = kick. see the "Action By Player" event at server.
	_actionDo:Int,					// targeted player must do an action of _actionNumber. this var can be a time remaining var or whatever is needed for an Int.
	_moveTimeRemaining:Array<Int>,	// time remaining to make a move. when time reaches 0, the game ends and that player losses.
	_score:Array<Int>,				// total score in game.
	_cash:Array<Float>,				// total cash in game.
	_quitGame:Bool,					// while playing the game, a player has clicked the quit game button if true.
}

class Reg
{
	public static var _dbHost:String = "";
	public static var _dbPort:Int = 0;
	public static var _dbUser:String = "";
	public static var _dbPass:String = "";
	public static var _dbName:String = "";
	public static var _domain_path:String = "";
	
	/*********************************************************************************
	 * is the server connected to the mysql database?
	 */
	public static var _mysqlConnected:Bool = false;
	
	/*********************************************************************************
	 * used to connect to server once.
	 */
	public static var _doOnce:Bool = false;
	
	/*************************************************************************
	 * only change the version number here. this value must be changed everytime this complete program with dlls are copied to the localhost/files/windows folder.
	 * no need to copy this var then paste to the bottom of this class because this value does not change while client is running.
	 */
	public static var _version:String = "1.16.1";

	/********************************************************************************
	 * when doing a request to see if a file exists at the website, this is the result of tht search.
	 * also, this var is used to compare the client's version.txt with the localhost/files/version.txt. if they do not match then a software update will happen.
	 */
	public static var _messageFileExists:String = "";
	
	/*************************************************************************
	 * website house url that ends in "/".
	 */
	public static var _websiteHomeUrl:String = "http://kboardgames.com/";	
	public static var _websiteName:String = "K Board Games.";

	
	
	public static function resetRegVarsOnce():Void
	{
		//############################ START CONFIG ###########################
		// change these values below this line.
		
		_websiteHomeUrl = "http://kboardgames.com/"; // end in trail "/"
		_messageFileExists = "";
	}
}