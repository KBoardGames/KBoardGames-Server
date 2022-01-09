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
 *
 * @author kboardgames.com
 */
class DB_Delete extends DB_Parent
{
	
	/******************************
	 * delete all logged in users because server is starting. we do this at starting not stopping because server may have crashed.
	 */
	public function logged_in_tables():Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("DELETE FROM logged_in_users"); 
		var rset = cnx.request("DELETE FROM logged_in_hostname"); 
		var rset = cnx.request("DELETE FROM room_data"); 
		var rset = cnx.request("DELETE FROM user_actions"); 
		var rset = cnx.request("DELETE FROM who_is_host"); 
		var rset = cnx.request("DELETE FROM room_lock");
		
		cnx.close();
	}

	/******************************
	 * delete user action table for user.
	 */
	public function user_from_user_action(_user:String, _actionWho:String):Void
	{			
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("DELETE FROM user_actions WHERE user = " + cnx.quote(_user) + "AND action_who = " + cnx.quote(_actionWho));
			
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	}
	
	/******************************
	 * user logged off. delete this table row.
	 */
	public function user_at_logged_in_user(_user:String):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("DELETE FROM logged_in_users WHERE user = " + cnx.quote(_user));
		
		cnx.close();
	}
	
	public function user_no_kicked_or_banned(_user:String):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("DELETE FROM user_actions WHERE user = " + cnx.quote(_user) + " AND action_number < 3"); //  action_number 1 and 2 is kicked / banned. 0 = nothing.
		
		cnx.close();
	}
	
	/******************************
	 * user logged off. delete this table row.
	 */
	public function tables_user_logged_off(_user:String):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("DELETE FROM room_data WHERE user = " + cnx.quote(_user));
		var rset = cnx.request("DELETE FROM who_is_host WHERE user = " + cnx.quote(_user));
		var rset = cnx.request("DELETE FROM room_lock WHERE user = " + cnx.quote(_user));
		
		cnx.close();
	}
	
	// TODO this table is not used. verify if this table is needed.
	public function room_from_room_data(_room:Int):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("DELETE FROM room_data WHERE room = " + _room);
		
		cnx.close();
	}
	
	/******************************
	 * user logged off. delete this table row.
	 */
	public function hostname_at_logged_in_hostname(_user:String):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("DELETE FROM logged_in_hostname WHERE user = " + cnx.quote(_user));
		
		cnx.close();
	}
		
	/******************************
	 * create the user table row for the user that logged in. this function is called when the user logs into the quest quests and the time is the next day or greater.
	 */
	public function then_recreate_user_data_daily_quests(_user:String):Void
	{	
		tryMysqlConnectDatabase();
		
		var _now = Date.now();
		var _dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saterday"];
		var _day_name = _dayNames[_now.getDay()];
		
		try 
		{
			var rset = cnx.request("DELETE FROM daily_quests WHERE user = " + cnx.quote(_user));
			
			var rset2 = cnx.request("INSERT IGNORE INTO daily_quests (user, day_name, timestamp) VALUES (" + cnx.quote(_user) + "," + cnx.quote(_day_name) + ", UNIX_TIMESTAMP())" );
				
		}		
		
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	}
	
	public function user_at_who_is_host(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try {
			var rset = cnx.request("DELETE FROM who_is_host WHERE user = " + cnx.quote(_user));		
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}
	
	/******************************
	 * userLocation was 7 but a player is ending a game and returning to lobby, so nobody should be host of the room.
	 */
	public function room_at_who_is_host(_room:Int):Void
	{
		tryMysqlConnectDatabase();		
	
		try {
			var rset = cnx.request("DELETE FROM who_is_host WHERE room = " + _room);				
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	
	}	
	
	public function user_at_room_lock(_user:String, _room:Int):Void
	{
		tryMysqlConnectDatabase();
		
		try
		{
			cnx.request("DELETE FROM room_lock WHERE user = " + cnx.quote(_user)); 		
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	}
	
	public function tournament_chess_standard_8(_player1:String):Void
	{
		tryMysqlConnectDatabase();
		
		try
		{
			cnx.request("DELETE FROM tournament_chess_standard_8 WHERE player1 = " + cnx.quote(_player1)); 		
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	}
	
}