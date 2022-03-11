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
import haxe.Int64;

/**
 *
 * @author kboardgames.com
 */
class DB_Insert extends DB_Parent
{
	
	public function user_at_user_actions(_user:String, _actionWho:String, _actionNumber:Int):Void
	{
		tryMysqlConnectDatabase();		
		//var _timestamp:Int = Std.int(Sys.time());
		
		try {
			var rset = cnx.request("INSERT INTO user_actions SET user = " + cnx.quote(_user) + ",
			action_who = " + cnx.quote(_actionWho) + ",
			action_number = " + _actionNumber + ",
			timestamp = UNIX_TIMESTAMP()");
				
		}
		catch (e:Dynamic)
		{	
			trace("MySql error.");		
		}
		
		cnx.close();	
	}
	
	public function save_is_locked_for_user_at_room_lock(_user:String, _room:Int):Void
	{
		tryMysqlConnectDatabase();
		
		cnx.request("INSERT IGNORE INTO room_lock set room = " + _room + ", is_locked = 1, user = " + cnx.quote(_user));
		
		cnx.close();
	}
	
	/******************************
	 * this function is called every so many clicks at waiting room.
	 */
	public function room_and_user_at_who_is_host(_user:String, _gid:String, _room:Int):Void
	{
		tryMysqlConnectDatabase();		
		
		try {
			var rset = cnx.request("DELETE FROM who_is_host WHERE room = " + _room);	
			
			var _var = cnx.request("INSERT INTO who_is_host SET 
			user = " + cnx.quote(_user) + ", gid = " + cnx.quote(_gid) + ", room = " + _room);
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();	
	}
	
	/******************************
	 * at hostname to logged_in_hostname table. stores the hostname not the ip address.
	 */
	public function hostname_to_logged_in_hostname(_user:String, _hostname:String):Bool
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("SELECT COUNT(*) FROM logged_in_hostname WHERE hostname = " + cnx.quote(_hostname));
		
		var rset2 = cnx.request("INSERT IGNORE INTO logged_in_hostname (user, hostname, timestamp) VALUES (" + cnx.quote(_user) + " , " + cnx.quote(_hostname) + ", UNIX_TIMESTAMP())" ); 
		
		
		cnx.close();
	
		if (rset.getIntResult(0) == 0) return false;
		else return true;
	}
	
	/******************************
	 * when user logs in, temp data is written to mysql database. this table has data such as the ip, host, and roomState of the user.
	 */
	public function user_at_logged_in_user(_user:String, _ip:String, _hostname:String, _roomState:Int):Void
	{
		tryMysqlConnectDatabase();

		var rset = cnx.request("INSERT IGNORE INTO logged_in_users (user, ip, hostname, room_state) VALUES (" + cnx.quote(_user) + ", " + cnx.quote(_ip) + ", " + cnx.quote(_hostname) + ", " + _roomState + ")");
		
		cnx.close();
	}
	
	/******************************
	 * create the room_data row for the user that logged in.
	 */
	public function user_and_id_at_room_data(_user:String, _userId:String):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("INSERT IGNORE INTO room_data (user, user_id) VALUES (" + cnx.quote(_user) + ", " + cnx.quote(_userId) + ")");
		
		cnx.close();
	}
	
	/******************************
	 * create the user table row for the user that logged in.
	 */
	public function user_and_data_to_users(_user:String, _password_hash:String, _ip:String, _hostname:String):Void
	{	
		tryMysqlConnectDatabase();
		
		var _timestamp:Int = Std.int(Sys.time());
		
		try {
			var rset = cnx.request("INSERT IGNORE INTO users (user, password_hash, ip, hostname, timestamp) VALUES (" + cnx.quote(_user) + "," + cnx.quote(_password_hash) + "," + cnx.quote(_ip) + "," + cnx.quote(_hostname) + "," + _timestamp + ")");
					
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		try {
			var _var = cnx.request("UPDATE users SET ip = " + cnx.quote(_ip) + " WHERE user = " + cnx.quote(_user));					
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	}
	
	/******************************
	 * create the user table row for the user that logged in.
	 */
	public function user_data_to_daily_quests(_user:String):Void
	{	
		tryMysqlConnectDatabase();
		
		var _now = Date.now();
		var _dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saterday"];
		var _day_name = _dayNames[_now.getDay()];
		
		try {
			var rset = cnx.request("SELECT COUNT(*) FROM daily_quests WHERE user = " + cnx.quote(_user));
				
			if (rset.getIntResult(0) == 0) 
			{
				var rset2 = cnx.request("INSERT IGNORE INTO daily_quests (user, day_name, timestamp) VALUES (" + cnx.quote(_user) + "," + cnx.quote(_day_name) + ", UNIX_TIMESTAMP())" );
			}
				
		}		
		
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	}
	
	public function user_to_statistics(_user:String):Void
	{	
		tryMysqlConnectDatabase();
		
		var _timestamp:Int = Std.int(Sys.time());
		
		try {
			var rset = cnx.request("INSERT IGNORE INTO statistics (user) VALUES (" + cnx.quote(_user) +")");
					
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	}
	
	
	public function user_to_house(_user:String):Void
	{	
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("INSERT IGNORE INTO house (user) VALUES (" + cnx.quote(_user) +")");
					
		}
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	}
	
	public function tournament_chess_standard_8(_user:String, _uid:String, _email_address:String):Void
	{	
		tryMysqlConnectDatabase();
		
		try 
		{
			var rset = cnx.request("INSERT IGNORE INTO tournament_chess_standard_8 SET 
			player1 = " + cnx.quote(_user) + ", 
			uid = " + _uid + ", 
			email_address = " + cnx.quote(_email_address));
		}		
		
		catch (e:Dynamic)
		{
			trace("MySql error.");		
		}
		
		cnx.close();
	}
}