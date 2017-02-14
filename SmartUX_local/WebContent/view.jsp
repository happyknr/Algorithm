<%@page import="java.net.SocketException"%>
<%@page import="java.net.NetworkInterface"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.io.File"%>
<%@ page language="java" import="java.net.InetAddress" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	
<%
	InetAddress inet = InetAddress.getLocalHost();
	String svrIP = inet.getHostAddress();
	
	String filePath = "";
	
	if(svrIP.equals("192.168.0.35"))
	{
 		filePath = application.getRealPath("/")+"SmartUX\\logs\\com_skt_skaf_l001mtm091\\BAT\\170103_175632\\";
	}
	else
	{
		filePath = application.getRealPath("/")+"../SmartUX/logs/com_skt_skaf_l001mtm091/BAT/170124_163114/";
	}
//http://172.21.85.67/SmartEX/logs/170131_094712_theme_4/test_4.mp4
	File file = new File(filePath);
	String[] files = null;

	if(file.exists())
	{
		files = file.list();
		for(int i = 0; i < files.length; i++)
		{
			if(files[i].substring(files[i].lastIndexOf(".")+1, files[i].length()).equals("mp4"))
			{
				
				if(svrIP.equals("192.168.0.35"))
				{
					System.out.println("http://"+svrIP+":8080/SmartUX/logs/com_skt_skaf_l001mtm091/BAT/170103_175632/"+files[i]);
					out.print("<video src='"+"http://"+svrIP+":8080/SmartUX_local/SmartUX/logs/com_skt_skaf_l001mtm091/BAT/170103_175632/"+files[i]+"' type='video/mp4' width='250' height='400' controls='controls'></video>");
					out.print("<embed src='"+"SmartUX\\logs\\com_skt_skaf_l001mtm091\\BAT\\170103_175632\\"+files[i]+"' width=250 height=400/>");
					//out.print("<video href='"+filePath+files[i]+"' type='video/mp4' width='500' height='500' controls='controls'></video>");
				}
				else
				{
					/* try
					{
						boolean isLoopBack = true;
					    Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces();
					    
					    while(en.hasMoreElements()) 
					    {
					    	NetworkInterface ni = en.nextElement();
					    	if (ni.isLoopback())
					    		continue;
					     
							Enumeration<InetAddress> inetAddresses = ni.getInetAddresses();
							while(inetAddresses.hasMoreElements()) 
							{
								InetAddress ia = inetAddresses.nextElement();
								if (ia.getHostAddress() != null && ia.getHostAddress().indexOf(".") != -1) 
								{
									svrIP = ia.getHostAddress();
									isLoopBack = false;
									break;
								}
							}
							
							if (!isLoopBack)
								break;
						}
					} 
					catch (SocketException e1) 
					{
						e1.printStackTrace();
					} */
					
					//System.out.println("http://"+svrIP+"/SmartUX/logs/com_skt_skaf_l001mtm091/BAT/170124_163114/"+files[i]);
//					out.print("<video src='"+"http://"+svrIP+"/SmartUX/logs/com_skt_skaf_l001mtm091/BAT/170124_163114/"+files[i]+"' type='video/mp4' width='500' height='500' controls='controls'></video>");
					out.print("<embed src='../SmartUX/logs/com_skt_skaf_l001mtm091/BAT/170124_163114/"+files[i]+"' width=250 height=400/>");
//					out.print("<video src='"+filePath+files[i]+"' type='video/mp4' width='500' height='500' controls='controls'></video>");
				}
			} 
		}
	}
	
%>

</body>
</html>