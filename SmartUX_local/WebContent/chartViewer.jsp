<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@ page import="com.common.*" %>
<%@ include file="dbConnection.jsp" %>
<%!
	static final String PACKAGE_NAME = "com.skp.launcher";
%>
<%
	request.setCharacterEncoding("utf-8");
	String tableName = request.getParameter("tableName");
	String scenario = request.getParameter("scenario");
	String version = request.getParameter("version");
	String sdate = request.getParameter("sdate");
	String edate = request.getParameter("edate");
	String pullRequestId = request.getParameter("pullRequestId");
	String buildCount = request.getParameter("buildCount");
	String[] scenarioArr = {};
	
	DBUtils db = new DBUtils();
	
	/* buildnumber 해당 값 */
	ArrayList<HashMap<String, String>> buildNumberList = new ArrayList<HashMap<String, String>>();
	ArrayList<Map<String, String>> subMenuArr = db.getScenario(PACKAGE_NAME, tableName, version, sdate, edate);
	
	for(int i = 0; i < subMenuArr.size(); i++) 
	System.out.println(subMenuArr.get(i).get("SCENARIO"));
	//System.out.println("chartViewer.jsp ] scenario : " + scenario);
	
	if(scenario != null && scenario != "")
	{
		if(scenario.substring(0, 3).equals("all"))
		{
			scenarioArr = scenario.split(",");
		}
	}
	
	PreparedStatement ps = null;
	StringBuffer sb = new StringBuffer();
	ResultSet rs = null;
	
	String deviceInfo = "";
	
	if(pullRequestId != null && pullRequestId.length() > 0)
	{
		db.selectValue(conn, tableName, pullRequestId, buildCount, buildNumberList);
	}
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.6.4.min.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">

	/* chart tooltip */
	function tooltipContents(date, pullRequestId, value, version)
	{
		return '<div style="padding:5px 5px 5px 5px;"><b>'+date+'</b><br/><b>['+pullRequestId+'] '+value.toFixed(3)+'</b></br><b>'+version+'</div>';
	}

	/* google chart */
	google.charts.load('current', {packages: ['corechart', 'line']});
	google.charts.setOnLoadCallback(drawBasic);
	
	function drawBasic() {

		var data = new google.visualization.DataTable();

		data.addColumn('number', 'index');
		<%
		if(scenarioArr != null && scenarioArr.length > 0)
		{
			for(int i = 1; i < scenarioArr.length; i++)
			{
		%>
				data.addColumn('number', '<%=scenarioArr[i]%>');
				data.addColumn({type:'string', role:'annotation'});
				data.addColumn({type:'string', role:'tooltip', 'p':{'html':true}});
		<%
			}
		}
		else
		{
		%>
			data.addColumn('number', '<%=scenario%>');
			data.addColumn({type:'string', role:'annotation'});
			data.addColumn({type:'string', role:'tooltip', 'p':{'html':true}});
		<%
		}
		%>

		data.addRows([
		<%
    		try
    		{
    			if(scenario != null && scenario != "" && scenario.length() > 0)
    			{
    				if(scenario.substring(0, 3).equals("all"))
    				{
    					//---------------------------------
    					int on = 1;
						sb.append(" SELECT @ROWNUM := @ROWNUM+1 AS rownum	\n");
						/* sb.append("        , build.pull_request_id  \n"); */
						for(int i = 1; i < scenarioArr.length; i++)
						{
							sb.append("		 , TBL"+i+".device_info AS device_info	\n");
							sb.append("		 , TBL"+i+".value AS value"+i+"	\n");
							sb.append("      , TBL"+i+".date AS date"+i+"	\n");
							sb.append("      , TBL"+i+".version AS version"+i+"	\n");
							sb.append("      , TBL"+i+".pull_request_id AS pull_request_id"+i+"	\n");
							sb.append("      , TBL"+i+".build_count	AS build_count"+i+"		\n");
							sb.append("      , ( SELECT MAX(value) FROM "+tableName+"	\n");
							sb.append("			WHERE PACKAGE_NAME = '"+PACKAGE_NAME+"'	\n");
							sb.append("			AND SCENARIO = '"+scenarioArr[i].substring(0, scenarioArr[i].indexOf("("))+"'	\n");
							sb.append("			AND pull_request_id != ''	\n");
							if(version != null && version != "" && !version.equals("all"))
							{
								sb.append("		 			AND VERSION = '" +version+"'  \n");
							}
							if(sdate != null && sdate != "")
							{
								sb.append("					AND DATE_FORMAT(date, '%Y-%m-%d') >= DATE_FORMAT('"+sdate+"', '%Y-%m-%d') \n");
							}
							if(edate != null && edate != "")
							{
								sb.append("					AND DATE_FORMAT(date, '%Y-%m-%d') <= DATE_FORMAT('"+edate+"', '%Y-%m-%d') \n");
							}
							sb.append("		)"+i+"_MAX    								\n");
							sb.append("     , ( SELECT MIN(value) FROM "+tableName+" 			\n");
							sb.append("			WHERE PACKAGE_NAME = '"+PACKAGE_NAME+"' 	\n");
							sb.append("			AND SCENARIO = '"+scenarioArr[i].substring(0, scenarioArr[i].indexOf("("))+"' 	\n");
							sb.append("			AND pull_request_id != '' 	\n");
							if(version != null && version != "" && !version.equals("all"))
							{
								sb.append("		 			AND VERSION = '" +version+"'  \n");
							}
							if(sdate != null && sdate != "")
							{
								sb.append("					AND DATE_FORMAT(date, '%Y-%m-%d') >= DATE_FORMAT('"+sdate+"', '%Y-%m-%d') \n");
							}
							if(edate != null && edate != "")
							{
								sb.append("					AND DATE_FORMAT(date, '%Y-%m-%d') <= DATE_FORMAT('"+edate+"', '%Y-%m-%d') \n");
							}
							sb.append("			AND value != 0 						\n");
							sb.append("		) "+i+"_MIN    								\n");
						}
						sb.append("	FROM                                              	\n");
						sb.append(" ( select * from build group by pull_request_id order by start_time ) build \n");
						sb.append(" left join \n");
						for(int i = 1; i < scenarioArr.length; i++)
						{
							sb.append("	(                                               \n");
							sb.append("		SELECT "+tableName+".device_info                               	\n");
							sb.append("			 , "+tableName+".value                               	\n");
							sb.append("			 , "+tableName+".date                                	\n");
							sb.append("			 , "+tableName+".version                                	\n");
							sb.append("      	 , "+tableName+".pull_request_id				\n");
							sb.append("      	 , "+tableName+".build_count				\n");
							sb.append("			FROM "+tableName+"      	\n");
							sb.append(" 	, ( SELECT scenario, version, date, pull_request_id, MAX(BUILD_COUNT) build_count \n");
	    					sb.append(" 		FROM "+tableName);
	    					sb.append("         WHERE  PACKAGE_NAME='"+PACKAGE_NAME+"'  \n");
	    					sb.append("			AND SCENARIO = '"+scenarioArr[i].substring(0, scenarioArr[i].indexOf("("))+"' 	\n");
	    					sb.append(" 					AND pull_request_id != ''  \n");
	    					if(version != null && version != "" && !version.equals("all"))
							{
								sb.append("		 			AND VERSION = '" +version+"'  \n");
							}
	    					if(sdate != null && sdate != "")
	    					{
	    						sb.append("		AND DATE_FORMAT(date, '%Y-%m-%d') >= DATE_FORMAT('"+sdate+"', '%Y-%m-%d') \n");
	    					}
	    					if(edate != null && edate != "")
	    					{
	    						sb.append("		AND DATE_FORMAT(date, '%Y-%m-%d') <= DATE_FORMAT('"+edate+"', '%Y-%m-%d') \n");
	    					}
	    					sb.append("         GROUP by pull_request_id  \n");
	    					sb.append("     ) "+tableName+"2  \n");
	    					sb.append("	WHERE "+tableName+"2.pull_request_id = "+tableName+".pull_request_id  \n");
	    					sb.append("		AND "+tableName+"2.build_count = "+tableName+".build_count  \n");
	    					sb.append("		AND "+tableName+"2.SCENARIO = "+tableName+".SCENARIO  \n");
	    					sb.append("		GROUP BY "+tableName+".pull_request_id  \n");
	    					sb.append("	ORDER BY "+tableName+".date ASC , "+tableName+".build_count desc \n");
							sb.append("	) TBL"+i+"  \n");
							if(on == i)
							{
								if(on == 1)
								{
									sb.append(" ON BUILD.pull_request_id = TBL1.pull_request_id COLLATE utf8_unicode_ci \n");
								}
								else
								{
									sb.append("	ON	TBL"+(i-1)+".pull_request_id = TBL"+i+".pull_request_id      \n");
								}
								on++;
							}
							if(i < scenarioArr.length-1)
							{
								sb.append(" LEFT JOIN 		\n");
							}
						}
						sb.append("  , (SELECT @ROWNUM := 0) R");
    					//---------------------------------
    				}
    				else
    				{
    					sb.append("SELECT @ROWNUM := @ROWNUM +1 AS ROWNUM \n");
    					sb.append("		 , "+tableName+".*  \n");
    					sb.append("		 , ( SELECT MAX(value) FROM "+tableName+"  \n");
    					sb.append("		 			WHERE PACKAGE_NAME='"+PACKAGE_NAME+"' \n"); 
    					sb.append("		 				AND SCENARIO = '"+scenario.substring(0, scenario.indexOf("("))+"' \n");
    					sb.append("						AND pull_request_id != ''  \n");
    					if(version != null && version != "" && !version.equals("all"))
						{
							sb.append("		 			AND VERSION = '" +version+"'  \n");
						}
    					if(sdate != null && sdate != "")
    					{
    						sb.append("					AND DATE_FORMAT(date, '%Y-%m-%d') >= DATE_FORMAT('"+sdate+"', '%Y-%m-%d') \n");
    					}
    					if(edate != null && edate != "")
    					{
    						sb.append("					AND DATE_FORMAT(date, '%Y-%m-%d') <= DATE_FORMAT('"+edate+"', '%Y-%m-%d') \n");
    					}
    					sb.append("		 ) maxVal \n");
    					sb.append("		 , ( SELECT MIN(value) FROM "+tableName+"  \n");
    					sb.append("		 			WHERE PACKAGE_NAME='"+PACKAGE_NAME+"'   \n");
    					sb.append("		 				AND SCENARIO = '"+scenario.substring(0, scenario.indexOf("("))+"'  \n");
    					sb.append("						AND pull_request_id != ''  \n");
    					if(version != null && version != "" && !version.equals("all"))
						{
							sb.append("		 			AND VERSION = '" +version+"'  \n");
						}
    					if(sdate != null && sdate != "")
    					{
    						sb.append("					AND DATE_FORMAT(date, '%Y-%m-%d') >= DATE_FORMAT('"+sdate+"', '%Y-%m-%d') \n");
    					}
    					if(edate != null && edate != "")
    					{
    						sb.append("					AND DATE_FORMAT(date, '%Y-%m-%d') <= DATE_FORMAT('"+edate+"', '%Y-%m-%d') \n");
    					}
    					sb.append("		 				AND value != 0  \n");
    					sb.append("		 ) minVal  \n");
    					sb.append("	FROM "+tableName+" \n");
    					sb.append("		, (SELECT @ROWNUM := 0) R  \n");
    					sb.append(" 	, ( SELECT scenario, date, version, pull_request_id, MAX(BUILD_COUNT) build_count \n");
    					sb.append(" 		FROM "+tableName);
    					sb.append("         WHERE  PACKAGE_NAME='"+PACKAGE_NAME+"'  \n");
    					sb.append("			AND SCENARIO = '"+ scenario.substring(0, scenario.indexOf("(")) +"'  \n");
    					sb.append(" 					AND pull_request_id != ''  \n");
    					if(sdate != null && sdate != "")
    					{
    						sb.append("		AND DATE_FORMAT(date, '%Y-%m-%d') >= DATE_FORMAT('"+sdate+"', '%Y-%m-%d') \n");
    					}
    					if(edate != null && edate != "")
    					{
    						sb.append("		AND DATE_FORMAT(date, '%Y-%m-%d') <= DATE_FORMAT('"+edate+"', '%Y-%m-%d') \n");
    					}
    					sb.append("         GROUP by pull_request_id  \n");
    					sb.append("     ) "+tableName+"2  \n");
    					sb.append("	WHERE "+tableName+"2.pull_request_id = "+tableName+".pull_request_id  \n");
    					sb.append("		AND "+tableName+"2.build_count = "+tableName+".build_count  \n");
    					sb.append("		AND "+tableName+"2.SCENARIO = "+tableName+".SCENARIO  \n");
    					sb.append("		GROUP BY "+tableName+".pull_request_id  \n");
    					sb.append("	ORDER BY "+tableName+".date ASC , "+tableName+".build_count desc \n");
    				}
    				
	    			//System.out.println(sb.toString());	    			
	    			ps = conn.prepareStatement(sb.toString());
	    			rs = ps.executeQuery();
    			}
    			
    			if(rs != null)
    			{
		    	 	while(rs.next())
		    	 	{
		    	 		if(rs.getString("device_info") != null)
		    	 		{
		    	 			deviceInfo = rs.getString("device_info");
		    	 		}
		    	 		//System.out.println("deviceInfo : " + deviceInfo);
		    	 		
		    	 		if(scenario != null && scenario.length() > 0)
		    	 		{
		    	 			if(scenario.substring(0, 3).equals("all"))
		    	 			{
		    	 				out.print("["+rs.getString("rownum")+",");
		    	 				
		    	 				//out.print("1, 12.123, 'MAX', tooltipContents('2017-02-07',1,12.123)");
		    	 				for(int i = 1; i < scenarioArr.length; i++)
		    	 				{
		    	 					if(rs.getString("value"+i) != null)
		    	 					{
	//		    	 					System.out.println("value"+i+" : " + rs.getString("value"+i) + ", " + "max"+i+" : "+rs.getString(i+"_MAX")+rs.getString("date"+i)+rs.getString("build_number"+i)+rs.getString("value"+i));
			    	 					if(rs.getString("value"+i).equals(rs.getString(i+"_MAX")))
			    	 					{
			    	 						out.print(rs.getString("value"+i)+", 'MAX', tooltipContents('"+rs.getString("date"+i)+"','"+rs.getString("pull_request_id"+i)+"_"+rs.getString("build_count"+i)+"',"+rs.getString("value"+i)+", '"+rs.getString("version"+i)+"')");
			    	 					}
			    	 					else if(rs.getString("value"+i).equals(rs.getString(i+"_MIN")))
			    	 					{
			    	 						out.print(rs.getString("value"+i)+", 'MIN', tooltipContents('"+rs.getString("date"+i)+"','"+rs.getString("pull_request_id"+i)+"_"+rs.getString("build_count"+i)+"',"+rs.getString("value"+i)+",'"+rs.getString("version"+i)+"')");
			    	 					}
			    	 					else
			    	 					{
			    	 						out.print(rs.getString("value"+i)+", "+null+", tooltipContents('"+rs.getString("date"+i)+"','"+rs.getString("pull_request_id"+i)+"_"+rs.getString("build_count"+i)+"',"+rs.getString("value"+i)+",'"+rs.getString("version"+i)+"')");
			    	 					}
		    	 					}
		    	 					else
		    	 					{
		    	 						out.print(null + ", "+ null + ", " + null);
		    	 					}
		    	 					
		    	 					if(i < scenarioArr.length)
		    	 					{
		    	 						out.print(",");
		    	 					}
		    	 				}
		    	 			}
		    	 			else
		    	 			{
		    	 				out.print("[");
		    	 				
		    	 				if(rs.getString("value").equals(rs.getString("maxVal")))
		    	    	 		{
		    		    	 		out.print(rs.getString("rownum")+","+rs.getString("value")+", 'MAX', tooltipContents('"+rs.getString("date")+"','"+rs.getString("pull_request_id")+"_"+rs.getString("build_count")+"',"+rs.getString("value")+",'"+rs.getString("version")+"')");
		    	    	 		}
		    	    	 		else if(rs.getString("value").equals(rs.getString("minVal")))
		    	    	 		{
		    	    	 			out.print(rs.getString("rownum")+","+rs.getString("value")+", 'MIN', tooltipContents('"+rs.getString("date")+"','"+rs.getString("pull_request_id")+"_"+rs.getString("build_count")+"',"+rs.getString("value")+",'"+rs.getString("version")+"')");
		    	    	 		}
		    	    	 		else
		    	    	 		{
		    	    	 			out.print(rs.getString("rownum")+","+rs.getString("value") +", "+null+", tooltipContents('"+rs.getString("date")+"','"+rs.getString("pull_request_id")+"_"+rs.getString("build_count")+"',"+rs.getString("value")+",'"+rs.getString("version")+"')");
		    	    	 		}
		    	 			}
		    	 		}
		    	 		
		    	 		out.print("]");
		    	 		
		    	 		if(!rs.isLast())
		    	 		{
		    	 			out.print(",");
		    	 		}
		    	 	}
    			}
    			else
    			{
    				//System.out.println("chart data is null");
    			}
    		}
    	 	catch(Exception e)
    		{
    			e.printStackTrace();
    		}
    		finally
    		{
    			if(rs != null) rs.close();
    			if(ps != null) ps.close();
    		}
    	 %>
	      ]);
    					
	var maxY = 0;
<%
	if(scenario != null && scenario != "")
	{
		if(tableName.equals("aging"))
		{
%>
			maxY = 500;
<%
		}
		else
		{
%>
			maxY = 20.0;
<%
		}
	}
%>
	      var options = {
				title: '런처플래닛 <%=deviceInfo %>',
				titleTextStyle:
				{
					fontSize: 30
				},
				fontSize: 12,
				interpolateNulls: false,
				tooltip: {isHtml: true},
		    	width: 1400, /*'100%'*/
		    	height: 500,
		    	colors: ['#DC3912','#3366CC','#FF9900'],
		    	hAxis:
				{
					gridlines: {count:0}
				},
				vAxis:
				{
					viewWindowMode : 'explicit',
					viewWindow :
					{
						min : 0.0,
						max : maxY
					}
				}
	      };

	      var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
	      chart.draw(data, options);

	}	  

	window.onload = function(){
		<%
		if(scenario != null)
		{
		%>
			document.getElementById("chart_div").style.display = "";
			document.getElementById("tableDiv").style.display = "";
		<%
		}
		%>
	}
</script>
</head>
<body>
	<div id="chart_div" style="display: none;"></div>
	
	<div id="tableDiv" style="display: none;">
		<table style="border-collapse:collapse; width:45%; font-size:14px;" border="1">
			<tr style=" background: #efefef;">
				<th width="33.3%">scenario</th>
				<th width="33.3%">datetime</th>
				<th width="33.3%">value</th>
			</tr>
			<%
			for(int i = 0 ; i < buildNumberList.size(); i++)
			{
			%>
			<tr>
				<td align="center"><%=buildNumberList.get(i).get("scenario") %></td>
				<td align="center">[<%=buildNumberList.get(i).get("build_count")%>]&nbsp;<%=buildNumberList.get(i).get("date") %></td>
				<td align="center"><%=buildNumberList.get(i).get("value") %></td>
			</tr>
			<%
			}
			%>
		</table>
	</div>
</body>
</html>