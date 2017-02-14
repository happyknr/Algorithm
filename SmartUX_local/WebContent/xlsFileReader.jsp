<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Date" %>
<%-- <%@ page import="org.apache.poi.xssf.usermodel.*" %> --%>
<%@ page import="jxl.*" %>

<%
	try
	{
		/* =========================================================================================================== */
		Workbook workbook = Workbook.getWorkbook(new File("C:/Users/knr/Downloads/SmartUX_결과페이지_170102.xls"));
		
		Sheet sheet = workbook.getSheet(0);
		int col = 0;
		Cell cell;
		String string1 = "", string2 = "", string3 = "";
		System.out.println("rows : " + sheet.getRows());
		out.print("<table style='border-collapse:collapse; border:1px solid;' border='1'>");
		for(int i = 1; i < sheet.getRows(); i++)
		{
			col = 0;
			cell = sheet.getCell(col, i);
			string1 = cell.getContents();
			col = 1;
			cell = sheet.getCell(col, i);
			string2 = cell.getContents();
			col = 2;
			cell = sheet.getCell(col, i);
			string3 = cell.getContents();
			System.out.println(string1 + "/" + string2 + "/" + string3);
			out.print("<tr><td>"+string1+"</td><td>"+string2+"</td><td>"+string3+"</td></tr>");
		}
		out.print("</table>");
		
		workbook.close();
		/* =========================================================================================================== */
	}
	catch(Exception e)
	{
		e.printStackTrace();		
	}
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>

</body>
</html>