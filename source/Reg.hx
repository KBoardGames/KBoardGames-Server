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
//############################# NOTES
// The invalid operation errors on Neko come from uninitialized variables (int, bool, float), since these are by default null on Neko.

// Checking for null errors are important. The build error on neko, the invalid operation, come from uninitialized variables. To fix do var foo:int = 0. The 0 initializes that variable.
//#############################

/******************************
* all game data for all games are here.
*/
typedef DataGame =
{

	/******************************
	 * player instance. this tells one player from another.
	 */
	id: String,
	
	/******************************
	 * typedef id.
	 * when server sends a message to client, client needs to know what typedef it is. so when creating a typedef at this class, go to PlayState _websocket.onmessage and add the typedef there. tid starts at 10 and ends at 99. 10 to 40 is reserved for games.
	 */
	tid: Int,
	
	/******************************
	 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
	 */
	_event_name: String,
	
	/******************************
	 * current room that the user is in. zero equals lobby.
	 */
	_room: Int,
	
}

typedef DataGame0 = 
{
	/******************************
	 * player instance. this tells one player from another.
	 */
	id: String,
	
	/******************************
	 * typedef id.
	 * when server sends a message to client, client needs to know what typedef it is. so when creating a typedef at this class, go to PlayState _websocket.onmessage and add the typedef there. tid starts at 10 and ends at 99. 10 to 40 is reserved for games.
	 */
	tid: Int,
	
	/******************************
	 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
	 */
	_event_name: String,
	
	/******************************
	 * the username of the player.
	 */
	_username: String,
	
	/******************************
	 * unit number. 0-64
	 */
	_gameUnitNumberNew: Int,
	
	/******************************
	 * unit number. 0-64
	 */
	_gameUnitNumberOld: Int,
	
	/******************************
	 * unit x coordinate. this is the unit that you moved from.
	 */
	_gameXXold:Int,
	
	/******************************
	 * unit y coordinate. this is the unit that you moved from.
	 */
	_gameYYold:Int,
	
	/******************************
	 * unit x coordinate. this is the unit that you moved to.
	 */
	_gameXXnew:Int,
	
	/******************************
	 * unit y coordinate. this is the unit that you moved to.
	 */
	_gameYYnew:Int,
	
	/******************************
	 * unit x coordinate. this is the unit that you moved from.
	 */
	_gameXXold2:Int,
	
	/******************************
	 * unit y coordinate. this is the unit that you moved from.
	 */
	_gameYYold2:Int,
	
	/******************************
	 * used to determine if the pawn is En Passant.
	 */
	_triggerNextStuffToDo:Int,
	
	/******************************
	 * current room that the user is in. zero equals lobby.
	 */
	_room: Int,
	
	/******************************
	 * each board game should use this for only one var.
	 */
	_isThisPieceAtBackdoor:Bool,
}

typedef DataGame1 = 
{
	/******************************
	 * player instance. this tells one player from another.
	 */
	id: String,
	
	/******************************
	 * typedef id.
	 * when server sends a message to client, client needs to know what typedef it is. so when creating a typedef at this class, go to PlayState _websocket.onmessage and add the typedef there. tid starts at 10 and ends at 99. 10 to 40 is reserved for games.
	 */
	tid: Int,
	
	/******************************
	 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
	 */
	_event_name: String,
	
	/******************************
	 * the username of the player.
	 */
	_username: String,
	
	/******************************
	 * this is the point value of each piece on the standard game board
	 */
	_pieceValue: Int,
	
	/******************************
	 * unique value of a piece.
	 */
	_uniqueValue: Int,
	
	/******************************
	 * unit number. 0-64
	 */
	_gameUnitNumberNew: Int,
	
	/******************************
	 * unit number. 0-64
	 */
	_gameUnitNumberOld: Int,
	
	/******************************
	 * unit number. 0-64
	 */
	_gameUnitNumberNew2: Int,
	
	/******************************
	 * unit number. 0-64
	 */
	_gameUnitNumberOld2: Int,
	
	/******************************
	 * unit x coordinate. this is the unit that you moved from.
	 */
	_gameXXold:Int,
	
	/******************************
	 * unit y coordinate. this is the unit that you moved from.
	 */
	_gameYYold:Int,
	
	/******************************
	 * unit x coordinate. this is the unit that you moved to.
	 */
	_gameXXnew:Int,
	
	/******************************
	 * unit y coordinate. this is the unit that you moved to.
	 */
	_gameYYnew:Int,
	
	/******************************
	 * unit x coordinate. this is the unit that you moved from.
	 */
	_gameXXold2:Int,
	
	/******************************
	 * unit y coordinate. this is the unit that you moved from.
	 */
	_gameYYold2:Int,
	
	/******************************
	 * unit x coordinate. this is the unit that you moved to.
	 */
	_gameXXnew2:Int,
	
	/******************************
	 * unit y coordinate. this is the unit that you moved to.
	 */
	_gameYYnew2:Int,
	
	/******************************
	 * is pawn En passant?
	 */
	_isEnPassant:Bool, 
	
	/******************************
	 * the most recent pawn in En passant.
	 */
	_isEnPassantPawnNumber:Array<Int>,
	
	/******************************
	 * used to determine if the pawn is En Passant.
	 */
	_triggerNextStuffToDo:Int,
	
	/******************************
	 * castling vars to move the rook.
	 */
	_pointValue2:Int,
	
	/******************************
	 * castling vars.
	 */
	_uniqueValue2:Int,
	
	/******************************
	 * this is the letter used in notation of a promoted piece selected.
	 */
	_promotePieceLetter:String,
	
	/******************************
	 * for notation.
	 */
	_doneEnPassant:Bool,
	
	/******************************
	 * current room that the user is in. zero equals lobby.
	 */
	_room: Int,
	
	/******************************
	 * capturing unit image value for history when using the backwards button.
	 */
	_piece_capturing_image_value: Int,
}

typedef DataGame2 =
{
	/******************************
	 * player instance. this tells one player from another.
	 */
	id: String,
	
	/******************************
	 * typedef id.
	 * when server sends a message to client, client needs to know what typedef it is. so when creating a typedef at this class, go to PlayState _websocket.onmessage and add the typedef there. tid starts at 10 and ends at 99. 10 to 40 is reserved for games.
	 */
	tid: Int,
	
	/******************************
	 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
	 */
	_event_name: String,
	
	/******************************
	 * the username of the player.
	 */
	_username: String,
	
	/******************************
	 * unit x coordinate. this is the unit that you moved from.
	 */
	_gameXXold:Int,
	
	/******************************
	 * unit y coordinate. this is the unit that you moved from.
	 */
	_gameYYold:Int,
	
	/******************************
	 * used to determine if the pawn is En Passant.
	 */
	_triggerNextStuffToDo:Int,
	
	/******************************
	 * castling vars to move the rook.
	 */
	_pointValue2:Int,
	
	/******************************
	 * current room that the user is in. zero equals lobby.
	 */
	_room: Int,
	
}

typedef DataGame3 = 
{
	/******************************
	 * player instance. this tells one player from another.
	 */
	id: String,	
	
	/******************************
	 * typedef id.
	 * when server sends a message to client, client needs to know what typedef it is. so when creating a typedef at this class, go to PlayState _websocket.onmessage and add the typedef there. tid starts at 10 and ends at 99. 10 to 40 is reserved for games.
	 */
	tid: Int,
	
	/******************************
	 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
	 */
	_event_name: String,
	
	/******************************
	 * the username of the player.
	 */
	_username: String,
	
	/******************************
	 * unit number. 0-64
	 */
	_gameUnitNumberNew: Int,
	
	_triggerEventForAllPlayers:Bool, 
	
	/******************************
	 * used to update the other piece on the board. in an online 2 player game, if player 1 moves a piece then this var is used to update that piece at player 2's board.
	 */
	_triggerNextStuffToDo:Int,
	
	/******************************
	 * move again if true. 
	 */
	_rolledA6:Bool,
	
	/******************************
	 * current room that the user is in. zero equals lobby.
	 */
	_room: Int,
	
}

typedef DataGame4 =
{
	/******************************
	 * player instance. this tells one player from another.
	 */
	id: String,
	
	/******************************
	 * typedef id.
	 * when server sends a message to client, client needs to know what typedef it is. so when creating a typedef at this class, go to PlayState _websocket.onmessage and add the typedef there. tid starts at 10 and ends at 99. 10 to 40 is reserved for games.
	 */
	tid: Int,
	
	/******************************
	 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
	 */
	_event_name: String,
	
	/******************************
	 * the username of the player.
	 */
	_username: String,
	
	/******************************
	 * unit x coordinate. this is the unit that you moved from.
	 */
	_gameXXold:Int,
	
	/******************************
	 * unit y coordinate. this is the unit that you moved from.
	 */
	_gameYYold:Int,
	
	/******************************
	 * unit x coordinate. this is the unit that you moved to.
	 */
	_gameXXnew:Int,
	
	/******************************
	 * unit y coordinate. this is the unit that you moved to.
	 */
	_gameYYnew:Int,
	
	/******************************
	 * used in trade unit. this is the player that is moving piece. player would like to trade this unit.
	 */
	_gameXXold2:Int,
	
	/******************************
	 * used in trade unit. this is the player that is moving piece. player would like to trade this unit.
	 */
	_gameYYold2:Int,
	
	/******************************
	 * used in trade unit. this is the other player's unit. player moving would like to trade other player's unit.
	 */
	_gameXXnew2:Int,
	
	/******************************
	 * used in trade unit. this is the other player's unit. player moving would like to trade other player's unit.
	 */
	_gameYYnew2:Int,
	
	/******************************
	 * current room that the user is in. zero equals lobby.
	 */
	_room: Int,
	
	/******************************
	 * total rent bonus in game.
	 */
	_rentBonus:Array<Float>,
	
	/******************************
	 * -1 = not used. 0 = nobody owns this unit. 1 = player 1's unit. 2:player 2's unit. 3:player 3's unit. 4:player 4's unit.
	 */
	_gameUniqueValueForPiece:Array<Array<Int>>,
	
	/******************************
	 * amount of houses on each unit.
	 */
	_gameHouseAmountPerPiece:Array<Array<Int>>,
	
	/******************************
	 * Undeveloped units. no houses, nobody owns this unit when a value for that unit equals not 1.
	 */
	_gameUndevelopedValueOfUnit:Array<Int>,
	
	/******************************
	 * used when trading units. this holds the value of a unit number. this var is useful. it can change an ownership of a unit. see Reg._gameUniqueValueForPiece.
	 */
	_unitNumberTrade:Array<Int>
}

// movement.
typedef DataMovement = 
{
	/******************************
	 * player instance. this tells one player from another.
	 */
	id: String,
		
	/******************************
	 * typedef id.
	 * when server sends a message to client, client needs to know what typedef it is. so when creating a typedef at this class, go to PlayState _websocket.onmessage and add the typedef there. tid starts at 10 and ends at 99. 10 to 40 is reserved for games.
	 */
	tid: Int,
	
	/******************************
	 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
	 */
	_event_name: String,
	
	/******************************
	 * the username of the player.
	 */
	_username: String,
	
	/******************************
	 * game id. move_history fields are not deleted from the MySQL database. so this id is used so that a user accesses that correct move_history data.
	 */
	_gid: String,
	
	/******************************
	 * true if the spectator is watching the game.
	 */
	_spectatorWatching: Int,
	
	/******************************
	 * used to get the history from the room host.
	 */
	_username_room_host :String,
	
	/******************************
	 * used to get all history but only once per game room session. when all history is retrieved the normal next entry event will be called.
	 */
	_history_get_all: Int,
	
	/******************************
	 * unit number. 0-64
	 */
	_gameDiceMaximumIndex: Int,
	
	/******************************
	 * used to determine if the pawn is En Passant. also in Reversi, if all 4 discs have been placed on the board.
	 */
	_triggerNextStuffToDo:Int,
		
	/******************************
	 * current room that the user is in. zero equals lobby.
	 */
	_room: Int,
	
	/******************************
	 * you can pass any text here. The text is sent to server and at server if text matches then do something. clear the text after sending the event to server.
	 * for example, this is needed for game room. without a "sender" code, each player will go to this event at client the total amount of users in this room. so if there are two players and one spectator watching, each player will go to this event, at client, three times. however, at server, if this var text is "sender" then instead of a broadcast to room, _sender.send is used.
	 */
	_triggerEvent: String,
	
	/******************************
	 * the point value of a gameboard piece.
	 */
	_point_value: String,
	
	/******************************
	 * the unique value of a gameboard piece.
	 */
	_unique_value: String,
	
	/******************************
	 * move history, the selected first piece
	 */
	_moveHistoryPieceLocationOld1: String,
	
	/******************************
	 * moved the first piece to selected location.
	 */
	_moveHistoryPieceLocationNew1: String,
	
	/******************************
	 * second piece, such as, the rook when castling. the second piece selected for that game move.
	 */
	_moveHistoryPieceLocationOld2: String,
	
	/******************************
	 * moved the second piece to selected location.
	 */
	_moveHistoryPieceLocationNew2: String,
	
	/******************************
	 * image value of the selected first piece. if its a rook that first player selected then its a value of 4 else for second player then its a value of 14. normally this value is 0 because after the move, no piece is at that location.
	 */
	_moveHistoryPieceValueOld1: String,
	
	/******************************
	 * this refers to the value of the piece at the new selected moved to location.
	 */
	_moveHistoryPieceValueNew1: String,
	
	/******************************
	 * the second piece value, or piece image, normally this unit is empty because the second piece was moved to a new unit.
	 */
	_moveHistoryPieceValueOld2: String,
	
	/******************************
	 * this is the second piece moved to value of the image, so that the image can be moved to the new location.
	 */
	_moveHistoryPieceValueNew2: String,
	
	/******************************
	 * the captured piece value, its image.
	 */
	_moveHistoryPieceValueOld3: String,
	
	/******************************
	 * the total amount of all moves from all player playing gaming game.
	 */
	_moveHistoryTotalCount: Int,
}

typedef DataGameMessage = 
{
	/******************************
	 * player instance. this tells one player from another.
	 */
	id: String,	
	
	/******************************
	 * typedef id.
	 * when server sends a message to client, client needs to know what typedef it is. so when creating a typedef at this class, go to PlayState _websocket.onmessage and add the typedef there. tid starts at 10 and ends at 99. 10 to 40 is reserved for games.
	 */
	tid: Int,
	
	/******************************
	 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
	 */
	_event_name: String,
	
	/******************************
	 * the username of the player.
	 */
	_username: String,
	
	/******************************
	 * current room that the user is in. zero equals lobby.
	 */
	_room: Int,
	
	/******************************
	 * you can pass any text here. The text is sent to server and at server if text matches then do something. clear the text after sending the event to server.
	 * for example, this is needed for game room. without a "sender" code, each player will go to this event at client the total amount of users in this room. so if there are two players and one spectator watching, each player will go to this event, at client, three times. however, at server, if this var text is "sender" then instead of a broadcast to room, _sender.send is used.
	 */
	_triggerEvent: String,
	
	/******************************
	 * an example of this would be a chess game where a player just received a message saying that the king is in check. this event sends that same message to the other party.
	 */
	_gameMessage:String,
	
	_userTo: String,
	
	_userFrom: String,
	
	/******************************
	 * this var can hold any message.
	 */
	_questionAnsweredAs: Bool,
}

/******************************
 * compete these daily quests for rewards.
 */
typedef DataDailyQuests = 
{
	/******************************
	 * player instance. this tells one player from another.
	 */
	id: String,	
	
	/******************************
	 * typedef id.
	 * when server sends a message to client, client needs to know what typedef it is. so when creating a typedef at this class, go to PlayState _websocket.onmessage and add the typedef there. tid starts at 10 and ends at 99. 10 to 40 is reserved for games.
	 */
	tid: Int,
	
	/******************************
	 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
	 */
	_event_name: String,
	
	/******************************
	 * the username of the player.
	 */
	_username: String,
	
	/******************************
	 * Win three board games in a row.
	 */
	_three_in_a_row: String,
	
	/******************************
	 * Win a chess game in 5 moves or under.
	 */
	_chess_5_moves_under: String,
	
	/******************************
	 * Win a snakes and ladders game in under 4 moves.
	 */
	_snakes_under_4_moves: String,
	
	/******************************
	 * Win a 5 minute game
	 */
	_win_5_minute_game: String,
	
	/******************************
	 * Buy any four house items
	 */
	_buy_four_house_items: String,
	
	/******************************
	 * Finish playing a signature game
	 */
	_finish_signature_game: String,
	
	/******************************
	 * Occupy a total of 50 units in Reversi
	 */
	_reversi_occupy_50_units: String,
	
	/******************************
	 * Get 6 Kinged pieces in 1 checkers game
	 */
	_checkers_get_6_kings: String, 
	
	/******************************
	 * play all 5 games.
	 */
	_play_all_5_board_games: String,
	
	/******************************
	 * a gauge is dashed lines that runs horizontally across the top part of the dailyQuests.hx scene. There are three reward icons. then the dash filled line reaches a reward icon then a claim reward button will appear.
	 * the third dashed line refers to the first value is this string. the second value in this var refers to the sixth dashed line and the last dash lined (ninth) refers to the third value. therefore three quests need to be completed before a reward can be given. so there is 9 dashed lines, an every third line that is highlighted means that a quest reward can be given.
	 * this string look like this... "2,1,0". a zero means that no prize is available, the 1 means that a rewards can be claimed and 2 means that the reward for those quests have been claimed. remember that 2 quests are needed for every reward and that the dashed lines refer to those quests.
	 */
	_rewards: String,
}

/******************************
 * all game buttons, chat, restart, etc.
 */
typedef DataQuestions = 
{
	/******************************
	 * player instance. this tells one player from another.
	 */
	id: String,
	
	/******************************
	 * typedef id.
	 * when server sends a message to client, client needs to know what typedef it is. so when creating a typedef at this class, go to PlayState _websocket.onmessage and add the typedef there. tid starts at 10 and ends at 99. 10 to 40 is reserved for games.
	 */
	tid: Int,
	
	/******************************
	 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
	 */
	_event_name: String,
	
	/******************************
	 * the username of the player.
	 */
	_username: String,
	
	/******************************
	 * an example of this would be a chess game where a player just received a message saying that the king is in check.
	 */
	_gameMessage:String,
	
	/******************************
	 * chess draw offer. false:not yet asked. true:yes.
	 */
	_drawOffer:Bool,
	
	/******************************
	 * chess draw was answered as, false:no, true:yes 
	 */
	_drawAnsweredAs:Bool,
	
	/******************************
	 * restart game offer. false:not yet asked. true:yes.
	 */
	_restartGameOffer:Bool,
	
	/******************************
	 * restart game was answered as, false:no, true:yes.
	 */
	_restartGameAnsweredAs:Bool,
	
	/******************************
	 * current room that the user is in. zero equals lobby.
	 */
	_room: Int,
	
	/******************************
	 * you can pass any text here. The text is sent to server and at server if text matches then do something. clear the text after sending the event to server.
	 * for example, this is needed for game room. without a "sender" code, each player will go to this event at client the total amount of users in this room. so if there are two players and one spectator watching, each player will go to this event, at client, three times. however, at server, if this var text is "sender" then instead of a broadcast to room, _sender.send is used.
	 */
	_triggerEvent: String,
	
	/******************************
	 * is the game over?
	 */
	_gameOver: Bool,
}

/******************************
 * every player's name, win, lose, draw, etc.
 */
typedef DataOnlinePlayers = 
{
	/******************************
	 * player instance. this tells one player from another.
	 */
	id: String,
	
	/******************************
	 * typedef id.
	 * when server sends a message to client, client needs to know what typedef it is. so when creating a typedef at this class, go to PlayState _websocket.onmessage and add the typedef there. tid starts at 10 and ends at 99. 10 to 40 is reserved for games.
	 */
	tid: Int,
	
	/******************************
	 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
	 */
	_event_name: String,
	
	/******************************
	 * the username of the player.
	 */
	_username: String,
	
	/******************************
	 * current room that the user is in. zero equals lobby.
	 */
	_room: Int,
	
	/******************************
	 * you can pass any text here. The text is sent to server and at server if text matches then do something. clear the text after sending the event to server.
	 * for example, this is needed for game room. without a "sender" code, each player will go to this event at client the total amount of users in this room. so if there are two players and one spectator watching, each player will go to this event, at client, three times. however, at server, if this var text is "sender" then instead of a broadcast to room, _sender.send is used.
	 */
	_triggerEvent: String,
	
	/******************************
	 * players names that are online.
	 */
	_usernamesOnline:Array<String>,
	
	/******************************
	 * any game played. players game wins of players online.
	 */
	_gameAllTotalWins:Array<Int>,
	
	/******************************
	 * any game played. players game losses of players online.
	 */
	_gameAllTotalLosses:Array<Int>,
	
	/******************************
	 * any game played. players game draws of players online.
	 */
	_gameAllTotalDraws:Array<Int>,
	
	/******************************
	 * chess Elo rating for every player online.
	 */
	_chess_elo_rating:Array<Float>
}

typedef DataTournaments =
{
	/******************************
	 * player instance. this tells one player from another.
	 */
	id:String,
	
	/******************************
	 * typedef id.
	 * when server sends a message to client, client needs to know what typedef it is. so when creating a typedef at this class, go to PlayState _websocket.onmessage and add the typedef there. tid starts at 10 and ends at 99. 10 to 40 is reserved for games.
	 */
	tid: Int,
	
	/******************************
	 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
	 */
	_event_name: String,
	
	/******************************
	 * the username of the player.
	 */
	_username: String,
	
	/******************************
	 * the email address of player 1 if set. it is used for tournament.
	 */
	_email_address: String,
	
	/******************************
	 * if this name is not empty then its the name of the user in the tournament.
	 */
	_player1: String,
	
	/******************************
	 * if this var is not empty and username is _player1 then player1 maybe be playing against player 2,
	 */
	_player2: String,
	
	/******************************
	 * game id. move_history fields are not deleted from the MySQL database. so this id is used so that a user accesses that correct move_history data.
	 */
	_gid: String,
	
	/******************************
	 * 0:not started 1:started.
	 */
	_tournament_started: Bool,
	
	/******************************
	 * maximum total players in the current tournament. the current tournament is select with the _game_id var. see below.
	 */
	_player_maximum: Int,
	
	/******************************
	 * current player count in the current tournament. the current tournament is select with the _game_id var. see below.
	 */
	_player_current: Int,
	
	/******************************
	 * current room that the user is in. zero equals lobby.
	 */
	_room: Int,
	
	/******************************
	 * used to determine what tournament is being referenced. a value of 1 and the chess tournament standard was selected. that value of 1, is the id at the MySQL database "tournament data" table. a value of 0 means that no tournament game was selected.
	 */
	_game_id: Int,
	
	/******************************
	 * current round of the tournament. 16 player tournament = this value of 0. 8 players has this value set at 1.
	 */
	_round_current: Int,
	
	/******************************
	 * when the round_current equals this value then the tournament is at its last round.
	 */
	_rounds_total: Int,
	
	/******************************
	 * game move total for player
	 */
	_move_total: Int,
	
	/******************************
	 * game move total for player
	 */
	_won_game: Int,
	
	/******************************
	 * a value of 1 means the game is over.
	 * if value is 0 then this player is a tournament player.
	 */
	_game_over: Int,
	
	/******************************
	 * 0:cannot move piece 1:player can move piece.
	 */
	_move_piece: Bool,
	
	/******************************
	 * time is seconds you have to move a piece. failing to move piece within time allowed will result in losing the game.
	 */
	_time_remaining_player1: String,
	_time_remaining_player2: String,
	
	/******************************
	 * is it the players turn to move. a value of 1 = player1, 2=player2, etc.
	 */
	_move_number_current: Int,
		
	/******************************
	 * timestamp for player 1. 
	 * player 2 is not needed. the time might not be actuate when working with another players timestamp. the reason might be that a few seconds might be off from the time it takes to get and display the time. within that time, a player might have moved piece when instead we forfeit the game based on no activity from the user.
	 * for player 1, we use a lock so that the mailer knows that the player is in the process of moving a piece.
	 */
	_timestamp: Int,
	
	/******************************
	 * is the player subscribed to tournament mail. every game board peice moved will be sent by email to the player.
	 */
	_reminder_by_mail: Bool,
}

// anything account related us here.
typedef DataAccount = 
{
	/******************************
	 * player instance. this tells one player from another.
	 */
	id: String,
	
	/******************************
	 * typedef id.
	 * when server sends a message to client, client needs to know what typedef it is. so when creating a typedef at this class, go to PlayState _websocket.onmessage and add the typedef there. tid starts at 10 and ends at 99. 10 to 40 is reserved for games.
	 */
	tid: Int,
	
	/******************************
	 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
	 */
	_event_name: String,
	
	/******************************
	 * the username of the player.
	 */
	_username: String,
	
	/******************************
	 * if this field is not empty then the username has matched one of the names from the bad list. the user cannot login with a bad word.
	 */
	_username_banned: String,
	
	/******************************
	 * password hash encrypted with md5.
	 */
	_password_hash: String,
	
	/******************************
	 * user's email address.
	 */
	_email_address: String,
	
	/******************************
	 * code sent to email address. validated email addresses receive tournament email if subscribed. 
	 */
	_send_email_address_validation_code: Bool,
	
	/******************************
	 * the current message to be displayed as a dialog or popup box.
	 */
	_popupMessage: String,
	
	/******************************
	 * used to return the this local hosts name.
	 */
	_hostname: String,
	
	/******************************
	 * IP address of player.
	 */
	_ip:String,
	
	/******************************
	 * outputs if server is blocking
	 */
	_server_blocking: Bool,
	
	/******************************
	 * outputs if server is using fast send.
	 */
	_server_fast_send: Bool,
	
	/******************************
	 * amount of clients connected.
	 */
	_clients_connected: Int,
	
	/******************************
	 * if true then player is using the html5 client.
	 */
	_guest_account: Bool,
	
	/******************************
	 * This is the profile avatar image number used to display the image.
	 */
	_avatarNumber:String,
}

// what sets this typedef apart is the room data. here is room, roomState, _roomPlayerLimit, etc.
typedef DataMisc =
{
	/******************************
	 * player instance. this tells one player from another.
	 */
	id: String,
	
	/******************************
	 * typedef id.
	 * when server sends a message to client, client needs to know what typedef it is. so when creating a typedef at this class, go to PlayState _websocket.onmessage and add the typedef there. tid starts at 10 and ends at 99. 10 to 40 is reserved for games.
	 */
	tid: Int,
	
	/******************************
	 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
	 */
	_event_name: String,
	
	/******************************
	 * the username of the player.
	 */
	_username: String,
	
	/******************************
	 * current room that the user is in. zero equals lobby.
	 */
	_room: Int,
	
	/******************************
	 * you can pass any text here. The text is sent to server and at server if text matches then do something. clear the text after sending the event to server.
	 * for example, this is needed for game room. without a "sender" code, each player will go to this event at client the total amount of users in this room. so if there are two players and one spectator watching, each player will go to this event, at client, three times. however, at server, if this var text is "sender" then instead of a broadcast to room, _sender.send is used.
	 */
	_triggerEvent: String,
	
	/******************************
	 * this user entered the game from the lobby when clicking the "watch game" button. this user can only watch the game. this player cannot play the game even when game ends.
	 */
	_spectatorWatching:Bool, 
	
	/******************************
	 * 0 = empty, 1 computer game, 2 creating room, 3 = firth player waiting to play game. 4 = second player in waiting room. 5 third player in waiting room if any. 6 - forth player in waiting room if any. 7 - room full, 8 - game room.
	 */
	_roomState: Array<Int>,
	
	/******************************
	 * maximum number of players that can play the selected game.
	 */
	_roomPlayerLimit: Array<Int>,
	
	/******************************
	 * current total of players in a room.
	// used to list the games at lobby. see Reg.gameName(). also, for not a host player, the data from here will populate _miscState._data._gameId for that player. 
	//-1: no data, 0:checkers, 1:chess, etc.
	 */
	_roomPlayerCurrentTotal: Array<Int>,
	
	/******************************
	 * 0:checkers, 1:chess, 2:reversi, 3:snakes and ladders, 4: wheel estate.
	 */
	_roomGameIds: Array<Int>,
	
	/******************************
	 * a list of every username that is a host of a room.
	 */
	_roomHostUsername: Array<String>,
	
	/******************************
	 * game id. move_history fields are not deleted from the MySQL database. so this id is used so that a user accesses that correct move_history data.
	 */
	_gid: Array<String>,
	
	/******************************
	 * if this vars value is true then a different player will not be able change the room state until the player has finished the "Greater RoomState Value" event at "Get Room Data" event. Note: that when a player leaves the game room, since that userLocation will always be a value of zero, a _roomIsLocked is not needed.
	 */
	_roomIsLocked: Array<Int>,
	
	/******************************
	 * If vars value is true then a check for a room lock will be made. This is used only when entering a room. If mouse clicked the "refresh room" button or leaving a game room then a check will not be made because in these cases a check is not needed. See Note: at _roomIsLocked for the reason why.
	 */
	_roomCheckForLock: Array<Int>,
	
	/******************************
	 * When a room lock is true then this room cannot be entered by the current player and this is the message saying that someone is already accessing the room so try again shortly.
	 */
	_roomLockMessage: String,
	
	/******************************
	 * if this value is true than player is in a rated game.
	 */
	_rated_game: Array<Int>,
	
	/******************************
	 * if true then this room allows spectators.
	 */
	_allowSpectators: Array<Int>,
	
	/******************************
	 * currently where the user is at. 0:lobby, 1:creating room, 2:scene_waiting_room, 3:room game playing.
	 */
	_userLocation: Int,
	
	/******************************
	 * chat text of the player.
	 */
	_chat: String,
	
	/******************************
	 * should player enter the game room?
	 */
	_gameRoom: Bool,
	
	/******************************
	 * kick, ban or some message. player blocked other player for some time or from playing again at that room for that session.
	 */
	_clientCommandMessage: String,
	
	_clientCommandUsers: String,
	_clientCommandIPs: String,
	
	/******************************
	 * value is true if the dummy data is in use. when the admin enters the waiting room or game room, the admin's name will be displayed instead with one name from the dummy list of names. stats will not be saved and a dummy name will be displayed for player two.
	 * the idea is to take a screenshot of a scene so that people viewing your website can get motivated to participate in the games. do not move a piece at the game room. You cannot play a game using dummy data because player two really does not exist. only at the hud can you see the dummy data of player two.
	 */
	_dummy_data_in_use: Bool,
}

/******************************
 * if a playersState event is sending data to the server then remember that the server broadcasts to a room depending on the value of _room. therefore, before that event is sent from client, at client the _playersState room must equal _gameState._data._room.
 * note that id and room vars exists at each of these typedef containers. room var value must be taken from the _gameState. so if you are passing _miscState, remember to get the room state from _miscState first or _miscState if that was the last typedef used. by default, the id's are all the same value. you do not need to be concerned with typedef ID's.
 * if you forget to get the value of a room before sending to the client, the server will not return the data to the client at the correct room. either no data will be sent to the client event or a different player will get the data.
 */
typedef DataPlayers = 
{
	/******************************
	 * player instance. this tells one player from another.
	 */
	id: String,
	
	/******************************
	 * typedef id.
	 * when server sends a message to client, client needs to know what typedef it is. so when creating a typedef at this class, go to PlayState _websocket.onmessage and add the typedef there. tid starts at 10 and ends at 99. 10 to 40 is reserved for games.
	 */
	tid: Int,
	
	/******************************
	 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
	 */
	_event_name: String,
	
	/******************************
	 * the username of the player.
	 */
	_username: String,
	
	/******************************
	* one to four usernames of the players in the waiting room or game room.
	*/
	_usernamesDynamic:Array<String>,
	
	/******************************
	* one to four usernames of the players in the waiting room or game room.
	*/
	_usernamesStatic:Array<String>,
	
	/******************************
	* current total of players playing the game.
	*/
	_usernamesTotalDynamic:Int,
	
	/******************************
	* total players that can play a game in that game room.
	*/
	_usernamesTotalStatic:Int,
	
	/******************************
	* user watching the game being played. quit game or time ran out for this player. this player was once playing a game. when doing spectators for anyone to watch, that must be a different name.
	*/
	_spectatorPlaying:Bool,
	
	/******************************
	* this user entered the game from the lobby when clicking the "watch game" button. this user can only watch the game. this player cannot play the game even when game ends.
	*/
	_spectatorWatching:Bool,
	
	/******************************
	* 0: = not playing but still at game room. 1: playing a game. 2: left game room while still playing it. 3: left game or game room when game was over.4: quit game.
	// is it the players turn to move. a value of 1 = player1, 2=player2, etc.
	*/
	_gamePlayersValues:Array<Int>,
	
	_moveNumberDynamic:Array<Int>,
	
	/******************************
	 * current room that the user is in. zero equals lobby.
	 */
	_room: Int,
	
	/******************************
	 * This is the profile avatar image number used to display the image.
	 */
	_avatarNumber:Array<String>,
	
	/******************************
	 * you can pass any text here. The text is sent to server and at server if text matches then do something. clear the text after sending the event to server.
	 * for example, this is needed for game room. without a "sender" code, each player will go to this event at client the total amount of users in this room. so if there are two players and one spectator watching, each player will go to this event, at client, three times. however, at server, if this var text is "sender" then instead of a broadcast to room, _sender.send is used.
	 */
	_triggerEvent: String,
	
	/******************************
	* 
	*/// this is needed to save a game win to the game being played. if chess is being played and player won that game then this var will be used to save a win to chess, not just the overall wins of any game played.
	_gameId: Int,
	
	/******************************
	* total game wins of host player.
	*/
	_gameAllTotalWins:Array<Int>,
	
	/******************************
	* total game losses of host player.
	*/
	_gameAllTotalLosses:Array<Int>,
	
	/******************************
	* total game draws of host player.
	*/
	_gameAllTotalDraws:Array<Int>,	
	
	/******************************
	 * value is true if the dummy data is in use. when the admin enters the waiting room or game room, the admin's name will be displayed instead with one name from the dummy list of names. stats will not be saved and a dummy name will be displayed for player two.
	 * the idea is to take a screenshot of a scene so that people viewing your website can get motivated to participate in the games. do not move a piece at the game room. You cannot play a game using dummy data because player two really does not exist. only at the hud can you see the dummy data of player two.
	 */
	_dummy_data_in_use: Bool,
	
	/******************************
	* the game being played.
	*/
	_gameName:String,
	
	/******************************
	* username of the sent room invite.
	*/
	_usernameInvite:String,
	
	/******************************
	* an example of this would be a chess game where a player just received a message saying that the king is in check. 
	*/
	_gameMessage:String,
	
	/******************************
	* player that you want something done to.
	*/
	_actionWho:String,
	
	/******************************
	* refers to an action, eg, 1 = kick. see the "Action By Player" event at server.
	*/
	_actionNumber:Int,
	
	/******************************
	* targeted player must do an action of _actionNumber. this var can be a time remaining var or whatever is needed for an Int.
	*/
	_actionDo:Int,
	
	/******************************
	* time remaining to make a move. when time reaches 0, the game ends and that player losses.
	*/
	_moveTimeRemaining:Array<Int>,
	
	/******************************
	* total score in game.
	*/
	_score:Array<Int>,
	
	/******************************
	* total cash in game.
	*/
	_cash:Array<Float>,
	
	/******************************
	* while playing the game, a player has clicked the quit game button if true.
	*/
	_quitGame:Bool,
	
	/******************************
	* false if game is still being played. defaults to true because when entering the game room the game for those players has not started yet.
	*/
	_isGameFinished: Bool,
	
	/******************************
	* SAVE A VAR TO MYSQL SO THAT SOMEONE CANNOT INVITE WHEN STILL IN GAME ROOM. ALSO USED TO PASS A VAR TO USER SPECTATOR WATCHING. THAT VAR IS USED TO START A GAME FOR THAT SPECTATOR IF THE _gameIsFinished VALUE IS FALSE.
	*/
	_gameIsFinished: Bool,
	
	/******************************
	* send the current move number to the watching spectator so that the timer and white box underneath the P1, P2, P3 or P4 moves, can be updated.
	*/
	_spectatorWatchingGetMoveNumber: Int,
	
	/******************************
	* how many times a player moved a piece.
	*/
	_moveTotal: Int,
	
	/******************************
	* this is the time when game is started.
	*/
	_timeTotal: Int,
	
	/******************************
	* total house items bought within 24 houses. this var is for the daily quest. see _buy_four_house_items
	*/
	_house_items_daily_total: Int,
	
	/******************************
	 * this is the piece total for the winner at the end of a game.
	 * currently only used in Reversi.
	 */
	_piece_total_for_winner: Int, 
	
	/******************************
	 *	this is a daily quest var. This is the amount of kings that a player has while playing a game. this var is used at DailyQuests.hx to determine if a reward should be given to player.
	 */
	_checkers_king_total: Int,
	
	/******************************
	 * this is a daily quest var. when a game is won, at server main.hx, at the update_win_at_statistics() function, a value of 1 will be given to that array element for that board game played. so if playing a Reversi game then the array element of 2 will be set to a value of 1. when all array elements in this var has a value of 1 then all board games has been played.
	 */
	_all_boardgames_played_total: Array<Int>,
}


// credits, experience points, wins, losses, draws. all player statistics.
typedef DataStatistics = 
{
	/******************************
	 * player instance. this tells one player from another.
	 */
	id: String,
	
	/******************************
	 * typedef id.
	 * when server sends a message to client, client needs to know what typedef it is. so when creating a typedef at this class, go to PlayState _websocket.onmessage and add the typedef there. tid starts at 10 and ends at 99. 10 to 40 is reserved for games.
	 */
	tid: Int,
	
	/******************************
	 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
	 */
	_event_name: String,
	
	/******************************
	 * the username of the player.
	 */
	_username: String,
	
	/******************************
	 * current room that the user is in. zero equals lobby.
	 */
	_room: Int,
	
	/******************************
	* this is the time when game is started.
	*/
	_timeTotal: Int,
	
	/******************************
	* time since game has started.
	*/
	_moveTimeRemaining: Array<Int>,
	
	/******************************
	* current chess Elo rating a player has.
	*/
	_chess_elo_rating:Float,
	
	/******************************
	 * you can pass any text here. The text is sent to server and at server if text matches then do something. clear the text after sending the event to server.
	 * for example, this is needed for game room. without a "sender" code, each player will go to this event at client the total amount of users in this room. so if there are two players and one spectator watching, each player will go to this event, at client, three times. however, at server, if this var text is "sender" then instead of a broadcast to room, _sender.send is used.
	 */
	_triggerEvent: String,
	
	_total_games_played:Int,
	_highest_experience_points:Int,
	_highest_credits:Int,
	_highest_house_coins:Int,
	_shortest_time_game_played:Int,
	_longest_time_game_played:Int,
	_longest_current_winning_streak:Int,
	
	/******************************
	 * any games played.
	 */
	_highest_winning_streak:Int,
	
	/******************************
	 * any games played.
	 */
	_longest_current_losing_streak:Int,
	
	/******************************
	 * any games played.
	 */
	_highest_losing_streak:Int,
	
	/******************************
	 * any games played.
	 */
	_longest_current_draw_streak:Int,
	
	/******************************
	 * any games played.
	 */
	_highest_draw_streak:Int,	
	
	/******************************
	 * all game wins for player.
	 */
	_gamesAllTotalWins: Int,
	
	/******************************
	 * all game losses for player.
	 */
	_gamesAllTotalLosses: Int,
	
	/******************************
	 * all game draws for player.
	 */
	_gamesAllTotalDraws: Int,
	
	_checkersWins: Int,
	_checkersLosses: Int,
	_checkersDraws: Int,
	_chessWins: Int,
	_chessLosses: Int,
	_chessDraws: Int,
	_reversiWins: Int,
	_reversiLosses: Int,
	_reversiDraws: Int,
	_snakesAndLaddersWins: Int,
	_snakesAndLaddersLosses: Int,
	_snakesAndLaddersDraws: Int,
	_signatureGameWins: Int,
	_signatureGameLosses: Int,
	_signatureGameDraws: Int,
	
	/******************************
	 * credits given on event day. credits can be redeemed for a month of paid membership. Maximum of 5 credits per event day.
	 */
	_creditsToday: Int,
	
	/******************************
	 * each credit_today value is written to this value. this value only decreases when credits are used to redeem something, such as 1 month of membership.
	 */
	_creditsTotal: Int,
	
	/******************************
	 * each game played gives some XP points. get enough XP point to increase players level.
	 */
	_experiencePoints: Int,
	
	/******************************
	 * at the house event, after a game is played, some coins will be given. Use those coins to buy house furniture. Access your house from the house button at lobby.
	 */
	_houseCoins: Int,
}

/******************************
 * players house where they buy items, place items in room and vote for best house for prizes.
 */
typedef DataHouse = 
{
	/******************************
	 * player instance. this tells one player from another.
	 */
	id: String,
	
	/******************************
	 * typedef id.
	 * when server sends a message to client, client needs to know what typedef it is. so when creating a typedef at this class, go to PlayState _websocket.onmessage and add the typedef there. tid starts at 10 and ends at 99. 10 to 40 is reserved for games.
	 */
	tid: Int,
	
	/******************************
	 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
	 */
	_event_name: String,
	
	/******************************
	 * the username of the player.
	 */
	_username: String,
		
	/******************************
	 * refers to a sprite that was bought to display at house. eg, 1.png
	 */
	_sprite_number: String,
	
	/******************************
	 * this is the name of the sprite in the order it was bought and then after, in the order of was changed using the z-order buttons of bring to front and bring to back.
	 */
	_sprite_name: String,
	
	/******************************
	 * all items x position that is separated by a comma.
	 */
	_items_x: String,
	
	/******************************
	 * all items y position that is separated by a comma.
	 */
	_items_y: String,

	/******************************
	 * map x coordinates on scene at the time the item was bought or mouse dragged then mouse released.
	 */
	_map_x: String,
	
	/******************************
	 * map y coordinates on scene at the time the item was bought or mouse dragged then mouse released.
	 */
	_map_y: String,
	
	/******************************
	 * when the map is moved up, down, left or right, this value increases in size by those pixels. this var is used at House update() so that the map hover can be displayed when outside of its default map boundaries. it is also added or subtracted to the mouse coordinates at other classes so that the map or panel items can correctly be detected by the mouse. for example, the mouse.x cannot be at a value of 2000 when the stage has a width of 1400 and the map changes in width, but it can be there when this offset is added to mouse.x.
	 */
	_map_offset_x: String,
 	_map_offset_y: String,
	
	/******************************
	 * is this item hidden?
	 */
	_item_is_hidden: String,
	
	/******************************
	 * a list of 1 and 0's separated by a comma. the first value in this list refers to item 1. if that value is 1 then that item was purchased.
	 */
	_is_item_purchased: String,
	
	/******************************
	 * stores the direction that the furniture item is facing.
	 * values of 0=SE, 1:SW, 2:NE, 3:NW
	 */
	_item_direction_facing: String,
	
	/******************************
	 * the order of the furniture items displayed.
	 */
	_item_order: String,
	
	/******************************
	* when value is true the furniture item will be displayed on the map behind a wall. This string contains true and false values up to 200 furniture items separated by a comma.
	*/
	_item_behind_walls: String,
	
	/******************************
	 * this holds all floor tiles on the map. This var is read from left to right but that data is placed on the map starting from the top left of map and then moving right and similar to reading words in a book.
	 */
	_floor: String,
	
	/******************************
	 * this holds all wall tiles in the left position on the map. This var is read from left to right but that data is placed on the map starting from the top left of map and then moving right and similar to reading words in a book.
	 */
	_wall_left: String,
	
	/******************************
	 * this holds all wall tiles in the upward position on the map. This var is read from left to right but that data is placed on the map starting from the top left of map and then moving right and similar to reading words in a book.
	 * this var is shown under a left tile. so the wall is up but behind a left wall.
	 */
	_wall_up_behind: String,
	_wall_up_in_front: String,
	
	/******************************
	 * the visibility state of all floor tiles.
	 */
	_floor_is_hidden: String,
	
	/******************************
	 * the visibility state of all left wall tiles.
	 */
	_wall_left_is_hidden: String,
	
	/******************************
	 * the visibility state of all up wall tiles.
	 */
	_wall_up_behind_is_hidden: String,
	_wall_up_in_front_is_hidden: String,
}

// string is needed for all fields because at client this data will be .split(",")
typedef Leaderboards = 
{
	/******************************
	 * player instance. this tells one player from another.
	 */
	id: String,
	
	/******************************
	 * typedef id.
	 * when server sends a message to client, client needs to know what typedef it is. so when creating a typedef at this class, go to PlayState _websocket.onmessage and add the typedef there. tid starts at 10 and ends at 99. 10 to 40 is reserved for games.
	 */
	tid: Int,
	
	/******************************
	 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
	 */
	_event_name: String,
	
	/******************************
	 * the username of the player.
	 */
	_username: String,
	
	/******************************
	 * this holds all players in a top leaderboard list. the usernames in the list is separated with a comma.

	 */
	_usernames: String, 	
	/******************************
	 * total XP for all players. each XP is separated by a comma.
	 */
	_experiencePoints: String,
	
	_houseCoins: String,
	
	_worldFlag: String,
}

typedef DataServerMessage = 
{
	/******************************
	 * player instance. this tells one player from another.
	 */
	id: String,
	
	/******************************
	 * typedef id.
	 * when server sends a message to client, client needs to know what typedef it is. so when creating a typedef at this class, go to PlayState _websocket.onmessage and add the typedef there. tid starts at 10 and ends at 99. 10 to 40 is reserved for games.
	 */
	tid: Int,
	
	/******************************
	 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
	 */
	_event_name: String,
	
	/******************************
	 * a message about the server will go offline.
	 */
	_message_offline: String,
	
	/******************************
	 * send a message to all clients.
	 */
	_message_online: String,
}

typedef DataDisconnect = 
{
	/******************************
	 * 
	 */
	var id: String;
	
	/******************************
	 * typedef id.
	 * when server sends a message to client, client needs to know what typedef it is. so when creating a typedef at this class, go to PlayState _websocket.onmessage and add the typedef there. tid starts at 10 and ends at 99. 10 to 40 is reserved for games.
	 */
	var tid: Int;
	
	/******************************
	 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
	 */
	var _event_name: String;
	
	/******************************
	 * the username of the player.
	 */
	var _username:String;
	
	/******************************
	 * one to four usernames of the players in the waiting room or game room.
	 */
	var _usernamesDynamic:Array<String>;	
		
	/******************************
	 * the difference between _usernamesDynamic and _usernamesStatic is that a username can get removed from the list of _usernamesDynamic, but the _usernamesStatic will always have the same names through the actions within the game room.
	 */
	var	_usernamesStatic:Array<String>;
	
	/******************************
	 * current total of players playing the game.
	 */
	var _usernamesTotalDynamic:Int;
	
	/******************************
	 * total players that can play a game in that game room.
	 */
	var _usernamesTotalStatic:Int;
	
	/******************************
	 * user who was once playing but is now watching the game being played. 
	 */
	var _spectatorPlaying:Bool;
	
	/******************************
	 * this user entered the game from the lobby when clicking the "watch game" button. this user can only watch the game. this player cannot play the game even when game ends.
	 */
	var _spectatorWatching:Bool; 	
	
	/******************************
	 * send the current move number to the watching spectator so that the timer and white box underneath the P1, P2, P3 or P4 moves, can be updated.
	 */
	var _spectatorWatchingGetMoveNumber: Int;
	
	/******************************
	 * This is the profile avatar image number used to display the image.
	 */
	var _avatarNumber:Array<String>;
		 
	/******************************
	 * save the player's game player state to the database. is the player playing a game or waiting to play. 
	 * 0: = not playing but still at game room. 
	 * 1: playing a game. 
	 * 2: left game room while still playing it. 
	 * 3: left game room when game was over. 
	 * 4: quit game.
	 * this var is used to display players who are waiting for a game at the game room and to get the _count of how many players are waiting at game room.
	*/
	var _gamePlayersValues:Array<Int>;
	
	/******************************
	 * is it the players turn to move. a value of 1 = player1, 2=player2, etc.
	 */
	var _moveNumberDynamic:Array<Int>;
	
	/******************************
	 * current room that the user is in. zero equals no room.
	 */
	var _room: Int;
	
	/******************************
	 * you can pass any text here. The text is sent to server and at server if text matches then do something. clear the text after sending the event to server.
	 * for example, this is needed for game room. without a "sender" code, each player will go to this event at client the total amount of users in this room. so if there are two players and one spectator watching, each player will go to this event, at client, three times. however, at server, if this var text is "sender" then instead of a broadcast to room, _sender.send is used. 
	 */
	var _triggerEvent: String;
	
	/******************************
	 * this is needed to save a game win to the game being played. if chess is being played and player won that game then this var will be used to save a win to chess, not just the overall wins of any game played.
	 */
	var _gameId: Int;
	
	/******************************
	 * any game played. total game wins.
	 */
	var _gamesAllTotalWins:Array<Int>;
	
	/******************************
	 * any game played. total game losses.
	 */
	var _gamesAllTotalLosses:Array<Int>;
	
	/******************************
	 * any game played. total game draws.
	 */
	var _gamesAllTotalDraws:Array<Int>;
	
	/******************************
	 * the game being played.
	 */
	var _gameName:String;
	
	/******************************
	 * username of the sent room invite.
	 */
	var _usernameInvite:String;
	
	/******************************
	 * game win, lose or draw messages.
	 */
	var _gameMessage:String;
	
	/******************************
	 * player that you want something done to.
	 */
	var _actionWho:String;
	
	/******************************
	 * refers to an action, eg, 1 = kick. see the "Action By Player" event at server.
	 */
	var _actionNumber:Int;
	
	/******************************
	 * targeted player must do an action of _actionNumber. this var can be a time remaining var or whatever is needed for an Int.
	 */
	var _actionDo:Int;
	
	/******************************
	 * time remaining to make a move. when time reaches 0, the game ends and that player losses.
	 */
	var _moveTimeRemaining:Array<Int>;
	
	/******************************
	 * total score in game.
	 */
	var _score:Array<Int>;
	
	/******************************
	* total cash in game.
	*/
	var _cash:Array<Float>;				

	/******************************
	 * while playing the game, a player has clicked the quit game button if true.
	 */
	var _quitGame:Bool;
		
	/******************************
	 * false if game is still being played. defaults to true because when entering the game room the game for those players has not started yet.
	 */
	var _isGameFinished: Bool;
	
	/******************************
	 * SAVE A VAR TO MYSQL SO THAT SOMEONE CANNOT INVITE WHEN STILL IN GAME ROOM. ALSO USED TO PASS A VAR TO USER SPECTATOR WATCHING. THAT VAR IS USED TO START A GAME FOR THAT SPECTATOR IF THE _gameIsFinished VALUE IS FALSE.
	 */
	var _gameIsFinished: Bool;
	
	/******************************
	 * how many times a player moved a piece.
	 */
	var _moveTotal: Int;
	
	/******************************
	 * this is the time when game is started.
	 */
	var _timeTotal: Int;
	
	/******************************
	 * total house items bought within 24 houses. this var is for the daily quest. see _buy_four_house_items
	 */
	var _house_items_daily_total: Int;
	
	/******************************
	 * this is the piece total for the winner at the end of a game.
	 * currently only used in Reversi.
	 */
	var _piece_total_for_winner: Int;
	
	/******************************
	 *	this is a daily quest var. This is the amount of kings that a player has while playing a game. this var is used at DailyQuests.hx to determine if a reward should be given to player.
	 */
	var _checkers_king_total: Int;
	
	/******************************
	 * this is a daily quest var. when a game is won, at server main.hx, at the saveWinStats() function, a value of 1 will be given to that array element for that board game played. so if playing a Reversi game then the array element of 2 will be set to a value of 1. when all array elements in this var has a value of 1 then all board games has been played.
	 */
	var _all_boardgames_played_total: Array<Int>;
	
}

class Reg
{
	public static var _dataServerMessage:DataServerMessage = 
	{
		id: "1", // TODO this should be server id.
		
		tid: 52,
		
		/******************************
		 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
		 */
		_event_name: "Disconnect All By Server",
		_message_offline: "",
		_message_online: "",
	}
	
	public static var _dataDisconnect:DataDisconnect = 
	{
		id: "100000000999999999100000000999999999",
	
		tid: 48,
			
		/******************************
		 * the name of the event at server -> Events.hx or client -> NetworkEventsMain.hx that this typedef can be sent to.
		 */
		_event_name: "",
		
		/******************************
		 * the username of the player.
		 */
		_username: "",
		
		_usernamesDynamic: ["", "", "", ""],
				
		_usernamesStatic: ["", "", "", ""], 
		
		/******************************
		 * current total of players playing the game.
		 */
		_usernamesTotalDynamic: 0,
		
		/******************************
		 * total players that can play a game in that game room.
		 */
		_usernamesTotalStatic: 0,
		
		/******************************
		 * user who was once playing but is now watching the game being played.
		 */
		_spectatorPlaying: false,
		
		/******************************
		 * this user entered the game from the lobby when clicking the "watch game" button. this user can only watch the game. this player cannot play the game even when game ends.
		 */
		_spectatorWatching: false,
		
		/******************************
		 * send the current move number to the watching spectator so that the timer and white box underneath the P1, P2, P3 or P4 moves, can be updated.
		 */
		_spectatorWatchingGetMoveNumber: 0,		
		
		/******************************
		 * This is the profile avatar image number used to display the image.
		 */
		_avatarNumber: ["0.png", "0.png", "0.png", "0.png"],
		
		/******************************
		 * save the player's game player state to the database. is the player playing a game or waiting to play. 
		 * 0: = not playing but still at game room. 
		 * 1: playing a game. 
		 * 2: left game room while still playing it. 
		 * 3: left room when game was over. 
		 * 4: quit game.
		 * this var is used to display players who are waiting for a game at the game room and to get the _count of how many players are waiting at game room.
		 */		
		_gamePlayersValues: [0, 0, 0, 0],		
		
		_moveNumberDynamic: [0, 0, 0, 0],
		
		/******************************
		 * current room that the user is in. zero equals lobby.
		 */
		_room: 0,
		
		/******************************
		 * you can pass any text here. The text is sent to server and at server if text matches then do something. clear the text after sending the event to server.
		* for example, this is needed for game room. without a "sender" code, each player will go to this event at client the total amount of users in this room. so if there are two players and one spectator watching, each player will go to this event, at client, three times. however, at server, if this var text is "sender" then instead of a broadcast to room, _sender.send is used.
		 */
		_triggerEvent: "",
		
		_gameId: -1,		
		
		/******************************
		 * any game played. total game wins for player.
		 */
		_gamesAllTotalWins: [0, 0, 0, 0],
		
		/******************************
		 * any game played. total game losses for player.
		 */
		_gamesAllTotalLosses: [0, 0, 0, 0],
		
		/******************************
		 * any game played. total game draws for player.
		 */
		_gamesAllTotalDraws: [0, 0, 0, 0],
		
		/******************************
		 * the game being played.
		 */
		_gameName: "",
		
		/******************************
		 * username of the sent room invite.
		 */
		_usernameInvite: "",
		
		/******************************
		 * game win, lose or draw messages.
		 */
		_gameMessage: "",
		
		/******************************
		 * player that you want something done to.
		 */
		_actionWho: "",
		
		/******************************
		 * refers to an action, eg, 1 = kick. see the "Action By Player" event at server.
		 */
		_actionNumber: 0,
		
		/******************************
		 * targeted player must do an action of _actionNumber. this var can be a time remaining var or whatever is needed for an Int.
		 */
		_actionDo: -1,
		
		/******************************
		 * time remaining to make a move. when time reaches 0, the game ends and that player losses.
		 */
		_moveTimeRemaining: [0, 0, 0, 0],
		
		/******************************
		 * total score in game.
		 */
		_score: [0, 0, 0, 0],
		
		/******************************
		 * total cash in game.
		 */
		_cash: [0, 0, 0, 0],
		
		/******************************
		 * player had quit game.
		 */
		_quitGame: false,
		
		/******************************
		 * false if game is still being played. defaults to true because when entering the game room the game for those players has not started yet.
		 */
		_isGameFinished: true,
		
		/******************************
		 * SAVE A VAR TO MYSQL SO THAT SOMEONE CANNOT INVITE WHEN STILL IN GAME ROOM. ALSO USED TO PASS A VAR TO USER SPECTATOR WATCHING. THAT VAR IS USED TO START A GAME FOR THAT SPECTATOR IF THE _gameIsFinished VALUE IS FALSE.
		 */
		_gameIsFinished: false,
		
		/******************************
		 * how many times a player moved a piece.
		 */
		_moveTotal: 0,
		
		/******************************
		* this is the time when game is started.
		*/
		_timeTotal: 0,
		
		/******************************
		* this is a daily quest var. total house items bought within 24 houses. see _buy_four_house_items
		*/
		_house_items_daily_total: 0,
		
		/******************************
		 * this is the piece total for the winner at the end of a game.
		 * currently only used in Reversi.
		 */
		_piece_total_for_winner: 0,		
		
		/******************************
		 *	this is a daily quest var. This is the amount of kings that a player has while playing a game. this var is used at DailyQuests.hx to determine if a reward should be given to player.
		 */
		_checkers_king_total: 0,
				 
		/******************************
		 * this is a daily quest var. when a game is won, at server main.hx, at the saveWinStats() function, a value of 1 will be given to that array element for that board game played. so if playing a Reversi game then the array element of 2 will be set to a value of 1. when all array elements in this var has a value of 1 then all board games has been played.
		 */
		_all_boardgames_played_total: [0, 0, 0, 0, 0],
	}
	/******************************
	 * these vars are populated from the config.bat file at /subs. 
	 */
	public static var _dbHost:String = "";
	public static var _dbPort:Int = 0;
	public static var _dbUser:String = "";
	public static var _dbPass:String = "";
	public static var _dbName:String = "";
	public static var _username:String = "";
	public static var _domain:String = "";
	public static var _domain_path:String = "";
	public static var _smtpFrom:String = "";
	public static var _smtpHost:String = "";
	public static var _smtpPort:Int = 0;
	public static var _smtpUsername:String = "";
	public static var _smtpPassword:String = "";
	public static var _dummyData:Bool = false;

	/******************************
	 * is the server connected to the MySQL database?
	 */
	public static var _mysqlConnected:Bool = false;
	
	/******************************
	 * used to connect to server once.
	 */
	public static var _doOnce:Bool = false;
	
	/******************************
	 * only change the version number here. this value must be changed every time this complete program with dll's are copied to the localhost/files/windows folder.
	 * no need to copy this var then paste to the bottom of this class because this value does not change while client is running.
	 */
	public static var _version:String = "2.0.5";
	
	/******************************
	 * these are the computer player names for room a and b. those rooms are reserved for playing a game against the computer. these names are displayed at the hub.
	 * when the server first starts, the two of the names, randomly selected, will be assigned to room a and b.
	 */
	public static var _cpu_host_names:Array<String> = ["bot piper", "bot ben", "bot tina", "bot zak", "bot amy"];
	
	/******************************
	 * this name will be seen at lobby a. two names from the Reg._cpu_names will be selected when server starts. one of those names will be saved to this var.
	*/
	public static var _cpu_host_name1:String = "";
	
	/******************************
	 * this name will be seen at lobby a. two names from the Reg._cpu_names will be selected when server starts. one of those names will be saved to this var.
	*/
	public static var _cpu_host_name2:String = "";
	
	/*********************************
	 * when doing a request to see if a file exists at the website, this is the result of that search.
	 * also, this var is used to compare the server's Reg._version with the localhost/files/versionServer.txt. if they do not match then a software update will happen.
	 */
	public static var _messageFileExists:String = "";
	
	/******************************
	 * website house url that ends in "/".
	 */
	public static var _websiteHomeUrl:String = "http://kboardgames.com/";	
	public static var _websiteName:String = "K Board Games";

	/******************************
	 * this is the event calendar names, event are limited to no more than 40 events for the board games.
	 */
	public static var _eventName:Array<String> = 
	[for (p in 0...40) "" ];
	
	public static var _eventDescription:Array<String> = 
	[for (p in 0...40) "" ];
	
	 /******************************
	  * months start at element 0.
	  */
	 public static var _eventMonths:Array<Array<Int>> = 
	[for (p in 0...40) [for (d in 0...12) 0]];
	
	/******************************
	* days start at element 0.
	*/
	public static var _eventDays:Array<Array<Int>> = 
	[for (p in 0...40) [for (d in 0...28) 0]];
	
	public static var _eventBackgroundColour:Array<Int> =  
	[for (p in 0...40) 0 ];
	
	/******************************
	 * the IP address of the client connecting to the server.
	 */
	public static var _ip:String;
	
	public static function resetRegVarsOnce():Void
	{
		//############################# START CONFIG
		// change these values below this line.
		
		_websiteHomeUrl = "http://kboardgames.com/"; // end in trail "/"
		_messageFileExists = "";
		_cpu_host_name1 = "";
		_cpu_host_name2 = "";
	}
}