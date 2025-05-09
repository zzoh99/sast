<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산항목관리 팝업</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");
	var workYy  	 = "" ;
	var adjProcessCd = "" ;
	var adjProcessNm = "" ;
	var seq  		 = "" ;
	var helpText1  	 = "" ;
	var helpText2  	 = "" ;
	var helpText3  	 = "" ;
	var sheet1 = null;
	var sRow = "";

	$(function(){
		var arg = p.window.dialogArguments;

		if( arg != undefined ) {
		/*
			workYy  		= arg["workYy"];
			adjProcessCd  	= arg["adjProcessCd"];
			adjProcessNm  	= arg["adjProcessNm"];
			seq  			= arg["seq"];
			helpText1  		= arg["helpText1"];
			helpText2  		= arg["helpText2"];
			helpText3  		= arg["helpText3"];
		*/
			sheet1  		= arg["sheet1"];

		}else{
		/*
			if(p.window.workYy)			workYy 	  		= p.window.workYy.value;
			if(p.window.adjProcessCd)	adjProcessCd  	= p.window.adjProcessCd.value;
			if(p.window.adjProcessNm)	adjProcessNm    = p.window.adjProcessNm.value;
			if(p.window.seq)			seq 			= p.window.seq.value;
			if(p.window.helpText1)		helpText1 		= p.window.helpText1.value;
			if(p.window.helpText2)		helpText2 		= p.window.helpText2.value;
			if(p.window.helpText3)		helpText3 		= p.window.helpText3.value;
		*/
			sheet1 			= p.window.opener.sheet1;
		}

		sRow 		= sheet1.GetSelectRow();

		workYy = sheet1.GetCellValue(sRow,"work_yy");
		adjProcessCd = sheet1.GetCellValue(sRow,"adj_process_cd");
		adjProcessNm = sheet1.GetCellValue(sRow,"adj_process_nm");
		seq = sheet1.GetCellValue(sRow,"seq");
		helpText1 = sheet1.GetCellValue(sRow,"help_text1");
		helpText2 = sheet1.GetCellValue(sRow,"help_text2");
		helpText3 = sheet1.GetCellValue(sRow,"help_text3");

		getValue() ;

		//Cancel 버튼 처리
		$(".close").click(function(){
			p.self.close();
		});
	});

	function getValue() {
		var param = "srchYear="+workYy
					+"&srchAdjProcessCd="+adjProcessCd;

		var result = ajaxCall("<%=jspPath%>/yearEndItemMgr/yearEndItemMgrRst2.jsp?cmd=selectYearEndItemMgrPopup",param,false);
		 $("#helpText1").val(result["Data"]["help_text1"]) ;
		 $("#helpText2").val(result["Data"]["help_text2"]) ;
		 $("#helpText3").val(result["Data"]["help_text3"]) ;
	}

	function setValue() {
		/*
		var rv = new Array(6);

		rv["workYy"] 		= workYy ;
		rv["adjProcessCd"]	= adjProcessCd ;
		rv["adjProcessNm"] 	= adjProcessNm ;
		rv["seq"] 			= seq ;
		rv["helpText1"]		= $("#helpText1").val() ;
		rv["helpText2"]		= $("#helpText2").val() ;
		rv["helpText3"]		= $("#helpText3").val() ;

		//p.window.returnValue = rv;

		if(p.popReturnValue) p.popReturnValue(rv);
		*/
		sheet1.SetCellValue(sRow, "work_yy", 			workYy );
		sheet1.SetCellValue(sRow, "adj_process_cd", 	adjProcessCd );
		sheet1.SetCellValue(sRow, "adj_process_nm", 	adjProcessNm );
		sheet1.SetCellValue(sRow, "seq", 				seq );
		sheet1.SetCellValue(sRow, "help_text1", 		$("#helpText1").val() );
		sheet1.SetCellValue(sRow, "help_text2", 		$("#helpText2").val() );
		sheet1.SetCellValue(sRow, "help_text3", 		$("#helpText3").val() );

		p.window.close();
	}

</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li>도움말 관리</li>
			<!--<li class="close"></li>-->
		</ul>
	</div>

	<div class="popup_main">
		<table class="table">
			<colgroup>
				<col width="20%" />
				<col width="80%" />
			</colgroup>
			<tr>
				<th>도움말_1</th>
				<td>
					<textarea id="helpText1" name="helpText1"rows="11" class="w100p"></textarea>
				</td>
			</tr>

			<tr>
				<th>도움말_2</th>
				<td>
					<textarea id="helpText2" name="helpText2"rows="11" class="w100p"></textarea>
				</td>
			</tr>

			<tr>
				<th>도움말_3</th>
				<td>
					<textarea id="helpText3" name="helpText3"rows="11" class="w100p"></textarea>
				</td>
			</tr>

		</table>
		<div class="popup_button">
			<ul>
				<li>
					<a href="javascript:setValue();" class="pink large authA">확인</a>
					<a href="javascript:p.self.close();" class="gray large authR">닫기</a>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>