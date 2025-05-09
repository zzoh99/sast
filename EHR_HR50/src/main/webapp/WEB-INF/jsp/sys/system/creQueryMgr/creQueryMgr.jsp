<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden"> <head><title>쿼리자동생성(개발시 사용)</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<!-- Bootstrap -->
<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript" src="/common/js/cookie.js"></script>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {
	
		$("#searchTable").val("${cookie.hrQueryMgrTable.value}");
		
		$("input[type='text']").keydown(function(event){
			if(event.keyCode == 13){
				doAction1("Search");
			}
		});
		$("#chk").change(function(){
			if( sheet1.RowCount() > 0 ){
				makeInitSheet();
			}
		});
	
		//Sheet 초기화
		init_sheet1();
		$(window).smartresize(sheetResize); sheetInit();
		

		var sh = sheet1.GetSheetHeight() - 308;
				
		console.log("left SheetHeight:" );
		$("#selectQry").height(sh);
		$("#mergeQry").height(sh); 
		$("#deleteQry").height(sh);
		$("#initSheet").height(150);
	}); 


	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

			{Header:"COLUMN",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"columnName", Edit:0 },
			{Header:"COLUMN",		Type:"Text",		Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"columnName2", Edit:0 },
			{Header:"COMMENTS",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"comments", Edit:0 },
			{Header:"PK",			Type:"Text",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"pkYn", Edit:0 },
			{Header:"DATA_TYPE",	Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"dataType", Edit:0 },
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

	}

	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":  
			
			setCookie("hrQueryMgrTable",$("#searchTable").val(),1000);
			
			sheet1.DoSearch( "${ctx}/CreQueryMgr.do?cmd=getCreQueryMgrList", $("#sheet1Form").serialize()); 
			break;
		}
    }
	
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( sheet1.RowCount() > 0 ){
				makeSelectQry();
				makeMergeQry();
				makeDeleteQry();
				makeInitSheet();
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	
	function sheet1_OnClick(Row, Col, Value) {
		try{
		    
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	var en = "\n";
	function makeSelectQry(){
		try{

			var tableNm = $("#searchTable").val().trim().toUpperCase();
			
			var query = "SELECT A.ENTER_CD"+en;
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
				query += "     , A."+sheet1.GetCellValue(i, "columnName")+en;
			}
			query += "  FROM "+ tableNm+" A "+en;
			query += " WHERE A.ENTER_CD = TRIM(#"+"{ssnEnterCd})"+en;
			$("#selectQry").html(query);
			
	  	}catch(ex){alert("makeSelectQry() Error : " + ex);}
		
	}
	function makeMergeQry(){

		try{
			var tableNm = $("#searchTable").val().trim().toUpperCase();
			var query ="";
				query += "\t\t MERGE INTO "+tableNm+" T "+en;
				query += "\t\t USING "+en;
				query += "\t\t( "+en;
				query += '<foreach item="rm" collection="mergeRows" index="idx" separator=" UNION ALL ">'+en;
				query += "\t\t       SELECT TRIM(#"+"{ssnEnterCd}) AS ENTER_CD "+en+en+en;
				query += "\t\t            , CASE WHEN TRIM(#"+"{rm.seq}) IS NULL OR TRIM(#"+"{rm.seq}) = '0' THEN"+en;
				query += "\t\t                (SELECT (NVL(MAX(SEQ),0) + (#"+"{idx} + 1)) FROM "+tableNm+" WHERE ENTER_CD = #"+"{ssnEnterCd} )"+en;
				query += "\t\t              ELSE TO_NUMBER(#"+"{rm.seq})  AS SEQ "+en;
				
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
				query += "\t\t            , TRIM(#"+"{rm."+sheet1.GetCellValue(i, "columnName2")+"}) AS "+sheet1.GetCellValue(i, "columnName")+en;
			}
			    query += "\t\t        FROM DUAL"+en;
				query += "</foreach>"+en;
				query += "\t\t) S "+en;
				query += "\t\tON ( "+en;
				query += "\t\t          T.ENTER_CD = S.ENTER_CD "+en;

			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {				
				if( sheet1.GetCellValue(i, "pkYn") == "Y" ){
				query += "\t\t     AND  T."+sheet1.GetCellValue(i, "columnName")+" = S."+sheet1.GetCellValue(i, "columnName")+" "+en;
				}
			}
				query += "\t\t) "+en;
				query += "\t\tWHEN MATCHED THEN "+en;
				query += "\t\t   UPDATE SET T.CHKDATE	= sysdate "+en;
				query += "\t\t            , T.CHKID	    = #"+"{ssnSabun} "+en;
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {				
				if( sheet1.GetCellValue(i, "pkYn") == "N" ){
				query += "\t\t            , T."+sheet1.GetCellValue(i, "columnName")+" = S."+sheet1.GetCellValue(i, "columnName")+" "+en;
				}
			}
				query += "\t\tWHEN NOT MATCHED THEN "+en;
				query += "\t\t   INSERT "+en;
				query += "\t\t   ( "+en;
				query += "\t\t              T.ENTER_CD"+en;
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {		
				query += "\t\t            , T."+sheet1.GetCellValue(i, "columnName")+""+en;
			}
				query += "\t\t            , T.CHKDATE"+en;
				query += "\t\t            , T.CHKID"+en;
				query += "\t\t   ) "+en;
				query += "\t\t   VALUES "+en;
				query += "\t\t   ( "+en;
				query += "\t\t              S.ENTER_CD"+en;
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {		
				query += "\t\t            , S."+sheet1.GetCellValue(i, "columnName")+""+en;
			}
				query += "\t\t            , sysdate"+en;
				query += "\t\t            , #"+"{ssnSabun}"+en;
				query += "\t\t   ) "+en;
			
			$("#mergeQry").html(query);
			
	  	}catch(ex){alert("makeMergeQry() Error : " + ex);}
	}
	
	function makeDeleteQry(){
		try{
			var query = "", tmp1 = "", tmp2 = "", tmp3 = "", tmp4 = "";

			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {	
				if( sheet1.GetCellValue(i, "pkYn") == "Y" ){
					var colnm= sheet1.GetCellValue(i, "columnName2");
					tmp1 += sheet1.GetCellValue(i, "columnName")+",";
					tmp2 += "NULL,";
					tmp3 += "rm." + colnm + " != null and !rm."+ colnm + " neq '' and ";
					tmp4 += "TRIM( #"+"{rm." + colnm +"} ),";
				}
			}
			if( tmp1 == "" ) {
				$("#deleteQry").html("");
				return;
			}
			tmp1 = tmp1.substring(0, tmp1.length-1);
			tmp2 = tmp2.substring(0, tmp2.length-1);
			tmp3 = tmp3.substring(0, tmp3.length-4);
			tmp4 = tmp4.substring(0, tmp4.length-1);
			
			query += "\t\tDELETE FROM "+$("#searchTable").val().toUpperCase()+en;
			query += "\t\t WHERE ENTER_CD = TRIM(#"+"{ssnEnterCd}) "+en;
			query += "\t\t   AND ( " + tmp1 + " ) IN ( ( " + tmp2 + ") "+en;
			query += '<foreach item="rm" collection="deleteRows"> '+en;
			query += '    <if test="' + tmp3 + '">'+en;
			query += "\t\t     , ( " + tmp4 + " ) "+en;
			query += "    </if>"+en;
			query += "</foreach>"+en;
			query += "\t\t       )"+en;
			
			$("#deleteQry").html(query);
			
	  	}catch(ex){alert("makeDeleteQry() Error : " + ex);}
		
	}

	function makeInitSheet(){
		try{
			//{Header:"비고|비고", Type:"Text", Hidden:0, Width:100, Align:"Center", SaveName:"note", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			var query = "";
            
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
				var title = sheet1.GetCellValue(i, "comments");
				var colnm = sheet1.GetCellValue(i, "columnName2");
				if( $("#chk").is(":checked") ){
					title = title +"|"+ title; 
				}

				query += '{Header:"'+title+'", Type:"Text", Hidden:0, Width:100, Align:"Center", SaveName:"'+colnm+'", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },'+en;
				
			}
			
			$("#initSheet").html(query);
			
	  	}catch(ex){alert("makeInitSheet() Error : " + ex);}
		
	}
	

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="srchUseYn" name="srchUseYn" value="Y" />
	<input type="hidden" id="fileSeq" name="fileSeq"/>
	<!-- 조회조건 -->
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>테이블명</th>
			<td>
				<input type="text" id="searchTable" name="searchTable" class="text" value=""/>
			</td>
			<td>
				<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
	</div>
	</form>
	
	<table class="sheet_main">
	<colgroup>
		<col width="500px" />
		<col width="" />
	</colgroup>
	<tr>
		<td>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_right">
			<div class="row">
				<div class="col-4">
					<div class="sheet_title"> 
						<ul><li class="txt">SELECT Query</li></ul>
					</div>
					<textarea id="selectQry" name="selectQry" class="text required w100p" rows="30"></textarea>
				</div>
				<div class="col-4">
					<div class="sheet_title">
						<ul><li class="txt">MERGE Query</li></ul>
					</div>
					<textarea id="mergeQry" name="mergeQry" class="text required w100p" rows="30"></textarea>
				</div>
				<div class="col-4">
					<div class="sheet_title">
						<ul><li class="txt">DELETE Query</li></ul> 
					</div>
					<textarea id="deleteQry" name="deleteQry" class="text required w100p" rows="30"></textarea>
				</div>
			</div> 
			<div class="sheet_title"> 
			<ul><li class="txt">Init Sheet &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<label for="chk">2줄헤더 : </label><input type="checkbox" id="chk" name="chk" /></li>
			</ul>
			</div>
			<textarea id="initSheet" name="initSheet" class="text required" rows="10"></textarea>
		</td>
	</tr>
	</table>

</div>
</body>
</html>



