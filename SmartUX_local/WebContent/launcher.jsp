<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<style type="text/css">
.layer{
  position:absolute;
  top:30%;
  left:30%;
  width:700px;
  height:300px;
  /* border:1px solid black; */
  margin:-50px 0 0 -50px;
}

.button {
	width: 250px;
	height: 250px;
	border: 1px solid gray; 
	background-color: #D8D8D8;
	margin: 10px 10px 10px 10px;
	line-height: 200px;
	cursor: pointer;
}
</style>
<script type="text/javascript">
	function popup()
	{
		alert("페이지 준비중입니다.");
	}
</script>
</head>
<body>

	<div class="layer">
		<div class="button" style="float: left;" onclick="location.href='realtimePage.jsp'">
			<center><h1>실시간</h1></center>
		</div>
		<div class="button" style="float: right;" onclick="location.href='buildPage.jsp'">
			<center><h1>빌드</h1></center>
		</div>
	</div>
</body>
</html>