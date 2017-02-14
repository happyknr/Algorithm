<%@ page language="java" contentType="text/plain; charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.*" %>
<%@ page import="java.text.ParseException" %>
<%
request.setCharacterEncoding("UTF-8");
String text = request.getParameter("json");
if (text != null && text.length() > 0)
	System.out.println("text : " + text);

try 
{
	JSONParser jsonParser = new JSONParser();
	JSONArray jsonArr = (JSONArray) jsonParser.parse(text);

 	for (int i = 0; i < jsonArr.size(); i++) 
	{
		JSONObject object = (JSONObject) jsonArr.get(i);
		if (object != null && object.toString().trim().length() > 0) 
		{
			System.out.println(object.get("Type"));
			System.out.println(object.get("Description"));
			System.out.println(object.get("Event"));
			System.out.println(object.get("Value"));
			System.out.println(object.get("Node-Index"));
			System.out.println(object.get("Node-Resource ID"));
			System.out.println(object.get("Node-Content Desc"));
		}
	}  
} 
catch (Exception e2) 
{
	e2.printStackTrace();
}
%>