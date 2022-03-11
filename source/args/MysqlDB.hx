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
import sys.db.Connection;
import sys.db.Mysql;

typedef MysqlData = {
	
}

/**
 *
 * @author kboardgames.com
 */
class MysqlDB
{
	public var cnx:Connection;	
	public var _mysqlData:MysqlData;
			
	public function new() 
	{
		_mysqlData = 
		{
			// need to initialize these array before using them. 
			
		};
		
		tryMysqlConnectDatabase();
	}
	
	private function tryMysqlConnectDatabase():Void
	{
		try {
				var cnx2 = Mysql.connect(
				{ 
					host : Reg._dbHost,
					port : Reg._dbPort,
					user : Reg._dbUser,
					pass : Reg._dbPass,
					socket : null,
					database : Reg._dbName
				});	
				
				cnx = cnx2;
				
			}	
			
			catch (e:Dynamic)
			{
				trace ("Cannot connect to mysql");
				while (true) {};
			}	
	}
	
	public function server_now_offline_at_servers_status (id:Int):Void
	{
		tryMysqlConnectDatabase();
		
		cnx.request("UPDATE servers_status set connected=0, disconnect=0 WHERE id=" + id);
		
		cnx.close();
	}
}