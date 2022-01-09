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
		
		var rset = cnx.request("UPDATE servers_status set servers_online = servers_online - 1");
		
		if (id == 1)
		cnx.request("UPDATE servers_status set connected_1=0, disconnect_1=0");
		if (id == 2) 
		cnx.request("UPDATE servers_status set connected_2=0, disconnect_2=0");
		if (id == 3) 
		cnx.request("UPDATE servers_status set connected_3=0, disconnect_3=0");
		if (id == 4) 
		cnx.request("UPDATE servers_status set connected_4=0, disconnect_4=0");
		if (id == 5)
		cnx.request("UPDATE servers_status set connected_5=0, disconnect_5=0");
		if (id == 6)
		cnx.request("UPDATE servers_status set connected_6=0, disconnect_6=0");
		if (id == 7)
		cnx.request("UPDATE servers_status set connected_7=0, disconnect_7=0");
		if (id == 8)
		cnx.request("UPDATE servers_status set connected_8=0, disconnect_8=0");
		if (id == 9) 
		cnx.request("UPDATE servers_status set connected_9=0, disconnect_9=0");
		if (id == 10)
		cnx.request("UPDATE servers_status set connected_10=0, disconnect_10=0");
		if (id == 11)
		cnx.request("UPDATE servers_status set connected_11=0, disconnect_11=0");
		if (id == 12)
		cnx.request("UPDATE servers_status set connected_12=0, disconnect_12=0");
		if (id == 13)
		cnx.request("UPDATE servers_status set connected_13=0, disconnect_13=0");
		if (id == 14)
		cnx.request("UPDATE servers_status set connected_14=0, disconnect_14=0");
		if (id == 15)
		cnx.request("UPDATE servers_status set connected_15=0, disconnect_15=0");
		if (id == 16)
		cnx.request("UPDATE servers_status set connected_16=0, disconnect_16=0");
		if (id == 17)
		cnx.request("UPDATE servers_status set connected_17=0, disconnect_17=0");
		if (id == 18) 
		cnx.request("UPDATE servers_status set connected_18=0, disconnect_18=0");
		if (id == 19)
		cnx.request("UPDATE servers_status set connected_19=0, disconnect_19=0");
		if (id == 20)
		cnx.request("UPDATE servers_status set connected_20=0, disconnect_20=0");
		
		cnx.close();
	}
}