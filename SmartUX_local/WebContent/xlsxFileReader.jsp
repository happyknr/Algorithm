<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.lang.reflect.Array"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.LinkedHashMap"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFCell"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFRow"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFSheet"%>
<%@ page import="org.apache.poi.xssf.usermodel.XSSFWorkbook"%>

<%! 
	static final int MAX_OVERVIEW_CELL = 2;
	static final String MP4_FILENAME = "test_";
%>

<%
	request.setCharacterEncoding("utf-8");
	String filePath = request.getParameter("filePath");
	//System.out.println("filePath : " + filePath);
	String excelFileName = null;
	String mp4FilePath = null;
	
	File file = null;
	String[] files = {};
	
	try
	{
		if(filePath != null && filePath != "" && filePath.length() > 0)
		{
			mp4FilePath = filePath.substring(filePath.indexOf("SmartUX/logs/"), filePath.length());
			file = new File(filePath);
		
			if(file.exists())
			{
				files = file.list();
				for(int i = 0; i < files.length; i++)
				{
					if(files[i].substring(files[i].lastIndexOf(".")+1, files[i].length()).equals("xlsx"))
					{
						excelFileName = files[i];
						//System.out.println(excelFileName);
					}
				}
			}
		}
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}

Map<String, String> overviewHashmap = new LinkedHashMap<String, String>();
Map<String, Object> testcaseHashmap = new LinkedHashMap<String, Object>();
ArrayList<Map<String, Object>> allTestcaseList = new ArrayList<Map<String, Object>>(); 
ArrayList<String[]> allData = new ArrayList<String[]>();
ArrayList<String> testcaseList = new ArrayList<String>();
String[] rowData = null;
String[] tmpArr = null;
int maxCol = 0;
try
{
	if(excelFileName != null && excelFileName != "" && excelFileName.length() > 0)
	{
		FileInputStream fis = new FileInputStream(filePath+excelFileName);
		XSSFWorkbook workbook = new XSSFWorkbook(fis);
		int rowindex = 0;
		int columnindex = 0;
		XSSFSheet sheet=workbook.getSheetAt(0);
		int rows = sheet.getLastRowNum(); 
		
		for(rowindex = 0; rowindex <= rows; rowindex++)
		{
		    XSSFRow row = sheet.getRow(rowindex);
		    if(row != null)
		    {
		        int cells = row.getLastCellNum(); 
	            rowData = new String[cells];
		        for(columnindex = 0; columnindex < cells; columnindex++)
		        {
		            //셀값을 읽는다
		            XSSFCell cell = row.getCell(columnindex);
		            String value = "";
		            //셀이 빈값일경우를 위한 널체크
		            if(cell == null)
		            {
		            	continue;
		            }
		            else
		            {
		                //타입별로 내용 읽기
		                switch (cell.getCellType())
		                {
		                	case XSSFCell.CELL_TYPE_FORMULA:
		                		value = cell.getCellFormula();
		                		break;
		                	case XSSFCell.CELL_TYPE_NUMERIC:
		                		value = cell.getNumericCellValue()+"";
		                		if(value.substring(value.length()-2, value.length()).equals(".0"))
		                		{
		                			value = value.substring(0, value.length()-2);
		                		}
		                		break;
		                	case XSSFCell.CELL_TYPE_STRING:
		                		value = cell.getStringCellValue()+"";
		                		break;
		                	case XSSFCell.CELL_TYPE_BLANK:
		                		value = cell.getBooleanCellValue()+"";
		                		break;
		                	case XSSFCell.CELL_TYPE_ERROR:
		                		value = cell.getErrorCellValue()+"";
		                		break;
		                }
		            }
		            if(!value.equals("false"))
		            {
		            	rowData[columnindex] = value;
		            }
		        }
			    allData.add(rowData);
		    }
		}
	}
	
	String testName = null;
	for(int i = 0 ; i < allData.size(); i++)
	{
		
		tmpArr = allData.get(i);
		
		if(tmpArr.length == MAX_OVERVIEW_CELL)
		{
			String key = tmpArr[0];
			String value = tmpArr[1];
			overviewHashmap.put(key, value);
		}
		else
		{
			if((testName != null && tmpArr[0].equals("TEST CASE") && !tmpArr[1].equals(testName) ))
			{
				//System.out.println("===============================================");
				testcaseHashmap.put("list", testcaseList);
				allTestcaseList.add(testcaseHashmap);
				testcaseList = new ArrayList<String>();
				testcaseHashmap = new LinkedHashMap<String, Object>();
				testName = tmpArr[1];
			}
			
			if(tmpArr[0].equals("TEST CASE"))
			{
				//System.out.println(">> "+ tmpArr[1]);
				//System.out.println(">> "+ tmpArr[2]);
				
				if(testName == null) testName = tmpArr[1];
				testcaseHashmap.put("testcase", tmpArr[1]);
				testcaseHashmap.put("result", tmpArr[2]);
			}
			else
			{
				String tmp = "";
				//System.out.printf("["+i+"] ");
				for(int j = 0; j < tmpArr.length; j++)
				{
					//System.out.printf(tmpArr[j] + ", ");
					tmp += tmpArr[j];
					if(j != (tmpArr.length-1))
					{
						tmp += "/";
					}
					if(maxCol < tmpArr.length)
					{
						maxCol = tmpArr.length;
					}
					
				}
				testcaseList.add(tmp);
			}
			//System.out.println();
			if(i == (allData.size()-1))
			{
				//System.out.println("===============================================");
				testcaseHashmap.put("list", testcaseList);
				allTestcaseList.add(testcaseHashmap);
			}
		}
	}
	
	for(int i = 0; i < allTestcaseList.size(); i++)
	{
		//System.out.println(allTestcaseList.get(i));
		ArrayList<String> tmpList = (ArrayList<String>)allTestcaseList.get(i).get("list");
		Iterator<String> iter = tmpList.iterator();
		while(iter.hasNext())
		{
			String[] arr = iter.next().split("/");
				//for(int j = 0; j < arr.length; j++)
				//System.out.println(arr[j]);
		}
	} 
}
catch(Exception e)
{
	e.printStackTrace();
}
%>
<html>
<head>
<link href="css/style.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
	function display(status)
	{
		if(status == 'none')
		{
			document.getElementById("testCaseDiv").style.display = 'none';
			document.getElementById("overviewDiv").style.display = '';
			
			var div = document.getElementById("testCaseDiv").getElementsByTagName("div");
			for(var i = 1; i < div.length; i++)
			{
				div[i].style.display = 'none';
			}
		}
		else
		{
			var div = document.getElementById("testCaseDiv").getElementsByTagName("div");
			for(var i = 1; i < div.length; i++)
			{
				div[i].style.display = 'none';
			}
			
			document.getElementById("overviewDiv").style.display = 'none';
			document.getElementById(status).style.display = '';
			document.getElementById("testCaseDiv").style.display = '';
		}
	}
	
</script>
</head>
<body>
<div id="mainDiv" >
 	<div id='resultDiv' class='divStyle' style='width: 30%; float: left;'>
		<h3>Result</h3>
<%
 		out.print("<table class='type05'>");
		out.print("<tr>");
		out.print("<th>Test Case</th>");
		out.print("<th>Result</th>");
		out.print("</tr>");
		int idx = 0;
		for(int i = 0; i < allData.size(); i++)
		{
			tmpArr = allData.get(i);
			if(tmpArr.length > 0)
			{
				if(tmpArr[0].equals("TEST CASE"))
				{
					//System.out.println(">> "+ tmpArr[1]);
					//System.out.println(">> "+ tmpArr[2]);
					out.print("<tr>");
					out.print("<td style='cursor: pointer;' onClick="+"display('body"+idx+"')"+">"+ tmpArr[1] + "</td>");
					if(tmpArr[2].equals("FAIL"))
					{
						String mp4FileName = null;
						for(int j = 0; j < files.length; j++)
						{
							if(files[j].equals(MP4_FILENAME+(idx+1)+".mp4"))
							{
								mp4FileName = files[j];
							}
						}
						
						if(mp4FileName != null && mp4FileName.length() > 0)
						{
							out.print("<td>"+ tmpArr[2] + "&nbsp;<a href='"+mp4FilePath+mp4FileName+"' target='_blank'><img src='icon/mp4.PNG'/></a></td>");
						}
						else
						{
							out.print("<td>"+ tmpArr[2] + "</td>");
						}
					}
					else
					{
						out.print("<td>"+ tmpArr[2] +"</td>");
					}
					out.print("<tr>");
					idx++;
				}
			}
		}
		out.print("</table>"); 
%>		
	</div>
	<div id='overviewDiv' class='divStyle' style='width: 30%; float: left; /* border: 1px solid black */'>
		<h3>Overview</h3>
<%

		Iterator<String> iterator = overviewHashmap.keySet().iterator();
		out.print("<table class='type05'>");
		while(iterator.hasNext())
			
		{
			String key = iterator.next();
			//System.out.println(">>>>>>>> " + key + ", " + overviewHashmap.get(key));
			out.print("<tr><th>"+key+"</th>");
			out.print("<td>"+overviewHashmap.get(key)+"</td></tr>");
		}
		out.print("</table>"); 
%>		
	</div>
	<div id='testCaseDiv' class='divStyle' style='width: 30%; float: left; display: none; /* border: 1px solid black */'> 
		<div id='header' style='margin: 0px;'>
			<h3 style='float: left;'>Test Case</h3>
			<h5 style='float: right; cursor: pointer;' onClick="display('none')">X</h5>
		</div>
<%
 		for(int i = 0; i < allTestcaseList.size(); i++) 
		{
			out.print("<div id='body"+i+"' style='display: none; float: left; margin: 0px;'>");
			out.print("<table class='type05'>");
			out.print("<tr><th>Description</th><th colspan='"+maxCol+"'>Result</th></tr>");
			//System.out.println(allTestcaseList.get(i));
			ArrayList<String> tmpList = (ArrayList<String>)allTestcaseList.get(i).get("list");
			Iterator<String> iter = tmpList.iterator(); 
			while(iter.hasNext())
			{
				out.print("<tr>");
				String[] arr = iter.next().split("/");
				for(int j = 1; j < arr.length; j++)
				{
					//System.out.println(arr[j]);
					out.print("<td>"+arr[j]+"</td>");
				}
				out.print("</tr>");
			}
			out.print("</table>");
			out.print("</div>");
		} 
%>		
	</div>
</div>	
</body>
</html>