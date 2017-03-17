<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.net.HttpURLConnection"%>
<%@page import="java.util.Base64"%>
<%@page import="java.net.URL"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%!
	public static final String ID = null; //"p001005";
	public static final String PASSWORD = null; //"Kimnal0924";
%>
<%
request.setCharacterEncoding("utf-8");
String params = request.getParameter("params");
//System.out.println("startToBuild.jsp] params : " + params + "-----------------------------------------------");
String building = null;
String result = null;
HttpURLConnection connection = null;

try
{
	//System.out.println("startToBuild.jsp");
	
	String json = null, line = null, path = null;
	// String path = "http://10.211.23.122:8080/job/AgingTestProjectForHana/build"; //build start
	
	//String path = "http://10.211.22.36:8080/view/Test%20Job/job/E2E_Datasoda/lastBuild/api/json"; //response Tmap_APKDownloadTest
	//String path = "http://192.168.0.2:8080/job/JenkinsStateTest/lastBuild/api/json"; //response
	
	StringBuffer buffer = new StringBuffer();
	JSONObject jsonObject = null;
	JSONParser jsonParser = null;

	
	if(params == null)
	{
		//path = "http://10.211.22.36:8080/view/Test%20Job/job/E2E_tmaptaxi/lastBuild/api/json";
		path = "http://10.211.23.122:8080/job/AgingTestProjectForHana/lastBuild/api/json";
	}
	else
	{
		path = "http://10.211.23.122:8080/job/AgingTestProjectForHana/build"+params;
	}
	
	URL url = new URL(path);
	String encoding = Base64.getEncoder().encodeToString((ID + ":" + PASSWORD).getBytes());
	json = "{\"text\":\""+params+"\"}";
	//System.out.println(encoding);

	connection = (HttpURLConnection) url.openConnection();
	connection.setRequestMethod("POST");
	connection.setDoOutput(true);
	connection.setRequestProperty("Authorization", "Basic " + encoding);
	connection.setConnectTimeout(5000);
	connection.setRequestProperty("Content-Type", "application/json");
	
	if(json != null && json.length() > 0)
	{
		OutputStream os = connection.getOutputStream();
        os.write(json.getBytes("UTF-8"));
        os.close();
	}
	
	InputStream content = (InputStream)connection.getInputStream();
	BufferedReader in = new BufferedReader (new InputStreamReader (content));
	
	while ((line = in.readLine()) != null) 
	{
		buffer.append(line);
		System.out.println(line);
	}
	
	jsonObject = new JSONObject();
	jsonParser = new JSONParser();
	
	if(buffer != null && buffer.length() > 0)
	{
		jsonObject = (JSONObject) jsonParser.parse(buffer.toString());
		
		System.out.println("building : " + jsonObject.get("building"));
		System.out.println("displayName : " + jsonObject.get("displayName"));
		System.out.println("estimatedDuration : " + jsonObject.get("estimatedDuration"));
		System.out.println("fullDisplayName : " + jsonObject.get("fullDisplayName"));
		System.out.println("result : " + jsonObject.get("result"));
		System.out.println("builtOn : " + jsonObject.get("builtOn"));
		
		building = jsonObject.get("building").toString();
		
		if(jsonObject.get("result") == null)
		{
			result = null;
		}
		else
		{
			result = jsonObject.get("result").toString();
		}
	}
}
catch(Exception e)
{
	e.printStackTrace();
}
finally
{
	connection.disconnect();
}
%>
<html>
<head>
<style type="text/css">
text {
	font-size: 80px;
	/* padding-top: 15px; */
}
</style>
<script type="text/javascript">
	<%
		if(params != null && params.length() > 0)
		{
			out.print("location.href='jenkinsTrigger.jsp'");
		}
	%>
</script>
</head>
<body>
	<%
	
	if("true".equals(building)) //빌드중
	{
		/* out.print("<text style='color: red;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;● 빌드중</text>"); */
		out.print("<text style='color: red;'>&nbsp;&nbsp;●</text>");
		out.print("<text style='color: #E0F8F7;'>&nbsp;●</text>");
		//out.print("<text style='color: #F2F2F2;'>●</text>");
	}
	else
	{
		if("SUCCESS".equals(result) || "ABORTED".equals(result) || "FAILURE".equals(result)) //정상완료
		{
			/* out.print("<text style='color: blue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;● 빌드 완료 </text>"); */
			out.print("<text style='color: #F6CECE;'>&nbsp;&nbsp;●</text>");
			out.print("<text style='color: blue;'>&nbsp;●</text>");
			//out.print("<text style='color: #F2F2F2;'>●</text>");
		}
		/* else if("ABORTED".equals(result)) //강제종료
		{
			//out.print("<text style='color: light-gray;'>aborted</text>");
			out.print("<text style='color: #F6CECE;'>&nbsp;● </text>");
			out.print("<text style='color: #E0F8F7;'>● </text>");
			out.print("<text style='color: light-gray;'>●</text>");
		}
		else if("FAILURE".equals(result)) //빌드 실패
		{
			
		}  */
		else
		{
			
		}
	}
	%>
</body>
</html>
