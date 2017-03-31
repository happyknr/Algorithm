package com.common;

import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

public class DBUtils {
	
	private static final String UX_TABLE_NAME = "UX";
	private static final String DEFUALT_PATH = "SmartUX\\logs\\";

	private static final int SUCCESS = 1;
	private static final int FAIL = 0;
	
	private Connection conn = null;
	private PrintWriter out = null;
	
	protected int dbConn()
	{
		try
		{
			String url = "jdbc:mysql://172.21.85.68:3306/qadb";
			String id = "qadb_svc";
		  	String pw = "!qad.blxc2#";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(url,id,pw);
		}
		catch(Exception e)
		{
			e.printStackTrace();
			return FAIL;
		}
		return SUCCESS;
	}
	
	public int disconnect()
	{
		if(conn!=null)
		{
			try
			{
				conn.close();
			} 
			catch (SQLException e)
			{
				e.printStackTrace();
				return FAIL;
			}
		}
		return SUCCESS;
	}
	
	public int insertReport(String contents)
	{
		Statement stmt = null;
		String query = null;
		
		try
		{
			dbConn();
			stmt = conn.createStatement();
			
			query = "insert into test(contents) values ('"+contents+"')";
			
			stmt.executeQuery(query);
		}
		catch(Exception e)
		{
			e.printStackTrace();
			return FAIL;
		}
		
		return SUCCESS;
	}
	
	public ArrayList<Map<String, String>> getErrorList(String packageName, String psubMenu)
	{
		ArrayList<Map<String, String>> errorList = new ArrayList<Map<String, String>>();
		Map<String, String> map = null;
		Statement stmt = null;
		ResultSet rs = null;
		String query = null;
		
		try
		{
			dbConn();
			
			stmt = conn.createStatement();
			
			query = " SELECT E2E_ERROR.ID, E2E.VERSION, E2E_ERROR.DATE, ROUND(E2E_ERROR.VALUE,3) AS VALUE, E2E_ERROR.LOG_PATH FROM E2E_ERROR LEFT JOIN E2E	";
			query += "   ON E2E_ERROR.PACKAGE_NAME = E2E.package_name COLLATE utf8_unicode_ci ";
			query += "     AND E2E_ERROR.DATE = E2E.date   ";
			query += "     WHERE E2E_ERROR.PACKAGE_NAME = '"+packageName+"'  ";
			if(psubMenu != null && psubMenu.length() > 0 && !psubMenu.equals("all"))
			{
				query += "     AND E2E_ERROR.SCENARIO = '"+psubMenu+"' ";
			}
			query += "     AND E2E_ERROR.STATUS = 'C' ";
			query += " GROUP BY E2E_ERROR.ID  ";
			
			rs = stmt.executeQuery(query);
			
			while(rs.next())
			{
				map = new HashMap<String, String>();
				map.put("idx", rs.getString("id"));
				map.put("version", rs.getString("version"));
				map.put("date", rs.getString("date"));
				map.put("value", rs.getString("value"));
				map.put("log_path", rs.getString("log_path"));
				
				errorList.add(map);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			try 
			{
				if(stmt != null) stmt.close();
			} 
			catch (SQLException e) 
			{
				e.printStackTrace();
			}
		}
		
		return errorList;
	}
	
	public ArrayList<Map<String, String>> getScenario(String packageName, String tabName, String pappVersion, String sdate, String edate)
	{
		ArrayList<Map<String, String>> subMenuArr = new ArrayList<Map<String, String>>();
		Map<String, String> subMenuMap = null;
		Statement stmt = null;
		ResultSet rs = null;
		String query = null;
		
		try
		{
			dbConn();
			stmt = conn.createStatement();
			
			query = "SELECT DISTINCT(SCENARIO) AS SUBMENU \n";
			query += "		, ROUND(AVG(VALUE), 3) AS AVG \n";
			query += " 		, COUNT(SCENARIO) CNT \n";
			query += "	FROM "+tabName+" WHERE PACKAGE_NAME = '"+packageName+"'";
			query += "			AND value != 0 \n";
			if(pappVersion != null && pappVersion != "" && !pappVersion.equals("all"))
			{
				query += "	 	AND VERSION = '" +pappVersion+"'  \n";
			}
			if(sdate != null && sdate != "")
			{
				query += "		AND DATE_FORMAT(date, '%Y-%m-%d') >= DATE_FORMAT('"+sdate+"', '%Y-%m-%d') \n";
			}
			if(edate != null && edate != "")
			{
				query += "		AND DATE_FORMAT(date, '%Y-%m-%d') <= DATE_FORMAT('"+edate+"', '%Y-%m-%d') \n";
			}
			query += " 	GROUP BY SCENARIO \n";
			query += "  ORDER BY CNT DESC \n";
			
			rs = stmt.executeQuery(query);
			
			while(rs.next())
			{
				if(rs.getString("SUBMENU") != null && rs.getString("SUBMENU").length() > 0)
				{
					subMenuMap = new HashMap<String, String>();
					subMenuMap.put("SCENARIO", rs.getString("SUBMENU"));
					subMenuMap.put("AVERAGE", rs.getString("AVG"));
					subMenuArr.add(subMenuMap);
				}
			} 
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			try 
			{
				if(stmt != null) stmt.close();
			} 
			catch (SQLException e) 
			{
				e.printStackTrace();
			}
		}
		
		return subMenuArr;
	}
	
	public ArrayList<String> getRealtimeVersion(String packageName, String tableName)
	{
		ArrayList<String> appVersionArr = new ArrayList<String>();
		
		String query = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		try
		{
			dbConn();
			stmt = conn.createStatement();
			
			query = "SELECT DISTINCT(VERSION) AS VERSION FROM "+tableName+" WHERE PACKAGE_NAME='"+packageName+"' AND ( pull_request_id is null or pull_request_id = '' )";
			
			rs = stmt.executeQuery(query);
			
			while(rs.next())
			{
				if(rs.getString("VERSION") != null && rs.getString("VERSION").length() > 0)
				{
					appVersionArr.add(rs.getString("VERSION"));
				}
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			try 
			{
				if(stmt != null) stmt.close();
			} 
			catch (SQLException e) 
			{
				e.printStackTrace();
			}
		}
		
		return appVersionArr;
	}
	
	public ArrayList<String> getBuildVersion(String packageName, String tableName)
	{
		ArrayList<String> appVersionArr = new ArrayList<String>();
		
		String query = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		try
		{
			dbConn();
			stmt = conn.createStatement();
			
			query = "SELECT DISTINCT(VERSION) AS VERSION FROM "+tableName+" WHERE PACKAGE_NAME='"+packageName+"' AND ( pull_request_id is not null and pull_request_id != '' )";
			
			rs = stmt.executeQuery(query);
			
			while(rs.next())
			{
				if(rs.getString("VERSION") != null && rs.getString("VERSION").length() > 0)
				{
					appVersionArr.add(rs.getString("VERSION"));
				}
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			try 
			{
				if(stmt != null) stmt.close();
			} 
			catch (SQLException e) 
			{
				e.printStackTrace();
			}
		}
		
		return appVersionArr;
	}
	
	public ArrayList<HashMap<String, String>> selectValue(Connection conn, String tableName, String pullRequestId, String buildCount, ArrayList<HashMap<String, String>> array)
	{
		Statement stmt = null;
		ResultSet rs = null;
		String query = null;
		HashMap<String, String> hashmap = null;
		
		try
		{
			stmt = conn.createStatement();
			
			query = "select scenario, round(value, 3) value, date, concat(pull_request_id,'_',build_count) AS build_count from "+tableName+"\n";
			query += "  where pull_request_id = '"+pullRequestId+"' \n";
			if(buildCount != null && buildCount.length() > 0)
			{
				query += "  and build_count = '"+buildCount+"' \n"; 
			}
			query += "  order by pull_request_id, build_count";
			
			rs = stmt.executeQuery(query);
			
			while(rs.next())
			{
				hashmap = new HashMap<String, String>();
				hashmap.put("scenario", rs.getString("scenario"));
				hashmap.put("value", rs.getString("value"));
				hashmap.put("date", rs.getString("date"));
				hashmap.put("build_count", rs.getString("build_count"));
				array.add(hashmap);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			try
			{
				if(stmt != null) stmt.close();
			}
			catch(SQLException e2)
			{
				e2.printStackTrace();
			}
		}
		
		return array;
				
	}
	
	public ArrayList<HashMap<String, String>> SelectBuildInfo(Connection conn, String tableName, String packageName, ArrayList<HashMap<String, String>> arrName)
	{
		String query = "";
		Statement stmt = null;
		ResultSet rs = null;
		
		HashMap<String, String> tmpMap = null;
		
		try
		{
			stmt = conn.createStatement();
			
			query = " select distinct("+tableName+".pull_request_id), \n";
			if(tableName.equals(UX_TABLE_NAME))
			{
				query += " log_path,  \n";
			}
			query += " "+tableName+".build_count  from    \n";
			query += " ( \n";
			query += " 	select @rownum := @rownum+1 as rownum, pull_request_id, build_count, start_time \n";
			query += " 	from  \n";
			query += " 	( \n";
			query += " 	select build.* from build,  \n";
			query += " 		(select pull_request_id, max(build_count), max(start_time) start_time from build group by pull_request_id order by max(start_time) desc) build_idx \n";
			query += " 		where build.pull_request_id = build_idx.pull_request_id \n";
			query += "			and package_name = '"+packageName+"'\n";
			query += " 		order by build_idx.start_time desc, build.build_count desc \n";
			query += " 	) build, (select @rownum := 0) R \n";
			query += " ) build, "+tableName+" \n";
			query += " where build.pull_request_id = "+tableName+".pull_request_id COLLATE utf8_unicode_ci  \n";
			query += " and build.build_count = "+tableName+".build_count COLLATE utf8_unicode_ci \n";
			query += " order by rownum \n";
			
			//System.out.println(query);
			
			rs = stmt.executeQuery(query);

			while(rs.next())
			{
				tmpMap = new LinkedHashMap<String, String>();
				tmpMap.put("pull_request_id", rs.getString("pull_request_id"));
				tmpMap.put("build_count", rs.getString("build_count"));
				if(tableName.equals(UX_TABLE_NAME) && rs.getString("log_path") != null && rs.getString("log_path").length() > 0)
				{
					String log_Path = rs.getString("log_path");
					//System.out.println(log_Path);
					tmpMap.put("log_path", log_Path.substring(log_Path.lastIndexOf(DEFUALT_PATH)+DEFUALT_PATH.length(), log_Path.length()));
				}
				arrName.add(tmpMap);
			} 
			
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		finally
		{
			try 
			{
				stmt.close();
			}
			catch (SQLException e) 
			{
				e.printStackTrace();
			}
		}
			
		return arrName;
	}
 	
 	public ArrayList<HashMap<String, String>> getScenario(Connection conn, String tableName, String packageName, ArrayList<HashMap<String, String>> arrName)
	{
		String query = "";
		Statement stmt = null;
		ResultSet rs = null;
		
		HashMap<String, String> tmpMap = null;
		
		try
		{
			stmt = conn.createStatement();
			
			query = "select distinct(scenario) scenario, round(avg(value), 3) average, count(scenario) from "+tableName+" where package_name = '"+packageName+"' and pull_request_id != '' group by scenario order by count(scenario) desc";
			//System.out.println(tableName + " query : " + query);
			rs = stmt.executeQuery(query);
			
			while(rs.next())
			{
				tmpMap = new HashMap<String, String>();
				tmpMap.put("scenario", rs.getString("scenario"));
				tmpMap.put("average", "("+rs.getString("average")+")");
				//System.out.println("["+tableName+"] scenario : " + rs.getString("scenario") + " / average : " + rs.getString("average"));
				arrName.add(tmpMap);
				
				/* 	System.out.println("-------------------------");
					System.out.println(tmpMap.get("scenario"));
					System.out.println(tmpMap.get("average"));
					System.out.println("-------------------------"); */
			}
			
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		finally
		{
			try 
			{
				stmt.close();
			}
			catch (SQLException e) 
			{
				e.printStackTrace();
			}
		}
		
		return arrName;
	}
}
