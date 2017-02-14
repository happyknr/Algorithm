<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="dbConnection.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%
	StringBuffer sb = new StringBuffer();
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	try
	{
		sb.append(" SELECT * FROM E2E WHERE package_name = ? ");
		ps = conn.prepareStatement(sb.toString());
		ps.setString(1, "com.skp.launcher");
		
		rs = ps.executeQuery();
		
		while(rs.next())
		{
			out.print(rs.getString("id")+"<br/>");
		}
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
%>
</body>
</html>