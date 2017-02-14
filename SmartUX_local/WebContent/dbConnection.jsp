<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<%
	Connection conn=null;

	try
	{
		//String url = "jdbc:mysql://localhost:3306/test";
		String url = "jdbc:mysql://192.168.0.35:3306/test";
		String id = "knr";
		String pw = "skfo1234"; 
		Class.forName("com.mysql.jdbc.Driver");
		conn=DriverManager.getConnection(url,id,pw);
	}
	catch(Exception e)
	{
		e.printStackTrace();
		System.out.println("Not connected");
		if(conn!=null)
		{
			conn.close();
		}
	}
%>
<html>
<head>
</head>
<body>

</body>
</html>