<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>레코드상세팝업</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");

	var fileSeq    = "";
	var columnInfo = "";
	var titleList  = new Array();
	var dataList   = new Array();
	var dataList2   = new Array();
	var searchTable = "";
	$(function() {

		var arg = p.window.dialogArguments;

		if( arg != undefined ) {
			$("#popTitle").text(arg["popTitle"]) ;
			$("#declClass").val(arg["declClass"]) ;
			$("#gubun").val(arg["gubun"]) ;
			$("#declYmdTemp").val(arg["declYmdTemp"]);
			$("#workYy").val(arg["workYy"]) ;
		}else{
			$("#popTitle").text(p.popDialogArgument("popTitle"));
			$("#declClass").val(p.popDialogArgument("declClass"));
			$("#gubun").val(p.popDialogArgument("gubun"));
			$("#declYmdTemp").val(p.popDialogArgument("declYmdTemp"));
			$("#workYy").val(p.popDialogArgument("workYy"));
		}

		//시트
		if($("#declClass").val() == "1") setInitSheet1($("#gubun").val());
		else setInitSheet2($("#gubun").val());

		//닫기
	    $(".close").click(function() {
	    	p.self.close();
	    });
	});

	//근로소득 파라메타 세팅
	function setInitSheet1(rec){
		switch (rec) {
			case "A":
				fileSeq = "9";
				break;
			case "B":
				fileSeq = "12";
				break;
			case "C":
				fileSeq = "15";
				break;
			case "D":
				fileSeq = "18";
				break;
			case "E":
				fileSeq = "20";
				break;
			case "F":
				fileSeq = "24";
				break;
			case "G":
				fileSeq = "100";
				break;
			case "H":
				fileSeq = "110";
				break;
			case "I":
				fileSeq = "120";
				break;
			case "A1":
				fileSeq = "22";
				break;
		}
		searchTable = "TCPN_DISK"+rec;
		$("#searchTable").val(searchTable);
		initSheet();
	}
	
	//퇴직소득 파라메타 세팅
	function setInitSheet2(rec){
		switch (rec) {
			case "A":
				fileSeq = "10";
				break;
			case "B":
				fileSeq = "13";
				break;
			case "C":
				fileSeq = "16";
				break;
			case "D":
				fileSeq = "19";
				break;
			case "A1":
				fileSeq = "22";
				break;
		}
		searchTable = "TCPN_DISK"+rec;
		$("#searchTable").val(searchTable);
		initSheet();
	}

	//동적 시트세팅
	function initSheet(){
		//시트 세팅
		$("#fileSeq").val(fileSeq);

		//헤더,데이터 조회
		var header  = ajaxCall("<%=jspPath%>/yeaNtsTax/yeaNtsTaxPopupRst.jsp?cmd=selectRecordTitleList", $("#sheetForm").serialize(), false);
		var colData = ajaxCall("<%=jspPath%>/yeaNtsTax/yeaNtsTaxPopupRst.jsp?cmd=selectRecordList", $("#sheetForm").serialize(), false);

		//헤더 세팅
 		if (header != null && header.Data != null) {
			var v = 0;
			var initdata1 = {};
			initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:4};
			initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1};

			initdata1.Cols = [];
			initdata1.Cols[v++] = {Header:"No",			Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
			initdata1.Cols[v++] = {Header:"귀속년도",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workYy",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
			initdata1.Cols[v++] = {Header:"구분",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"declClass",	KeyField:0,	Format:"",  PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
			initdata1.Cols[v++] = {Header:"제출일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sendYmd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };

			//헤더명 추출
			for(var i=0; i < header.Data.length; i++) {
				titleList["headerListCd"] = header.Data[i].code.split("|");
				titleList["headerListNm"] = header.Data[i].code_nm.split("|");	//헤더명
				titleList["editLen"] 	  = header.Data[i].ele_len.split("|");	//TEXT파일항목길이
				titleList["align"] 		  = header.Data[i].ele_alg.split("|");	//좌우정렬
			}

			//레코드별 시트 동적생성
			for(var i=0; i<titleList["headerListCd"].length; i++){
				initdata1.Cols[v++]  = { Header:titleList["headerListNm"][i],	Type:"Text",	Hidden:0,	Width:100,	Align:titleList["align"][i],	ColMerge:0,	SaveName:"col"+[i],	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:titleList["editLen"][i] };
			}
			IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(4);

			//구분
			var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear="+p.popDialogArgument("workYy"),"C00327"), "");

			if (colData != null && colData.Data != null) {
				if(colData.Data.length > 0 ){
					for(var k=1; k<colData.Data.length+1; k++){
						//레코드 값 추출
				 		dataList2 = colData.Data[k-1].d_content.split("|");
				 		//구분
						sheet1.SetColProperty("declClass",	{ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]} );
				 		//추출한 데이터 세팅
						sheet1.DataInsert(k);
				 		sheet1.SetCellValue(k,"workYy"		,colData.Data[0].work_yy);
				 		sheet1.SetCellValue(k,"declClass"	,$("#declClass").val());
				 		sheet1.SetCellValue(k,"sendYmd"		,colData.Data[0].send_ymd);

						for(var i=0; i < dataList2.length; i++) {
							if(dataList2[i] != null && dataList2[i] != ""){
								//sheet1.SetCellValue(1,"col"+i,dataList2[i].trim());
								sheet1.SetCellValue(k,"col"+i,dataList2[i]);
							}
						}
					}
				}
			}
 		}
	}

	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
			sheet1.DoSearch( "<%=jspPath%>/yeaNtsTax/yeaCalcRst.jsp?cmd=selectCalcRetiree", $("#sheetForm").serialize() );
        	break;
		case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
            sheet1.Down2Excel(param);
            break;
		}
    }

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

</script>

</head>
<body class="bodywrap">
<form id="sheetForm" name="sheetForm">
	<input type="hidden" id="declClass" 	name="declClass" 	value="">
	<input type="hidden" id="gubun" 	  	name="gubun" 	    value="">
	<input type="hidden" id="fileSeq"  	 	name="fileSeq"  	value="">
	<input type="hidden" id="declYmdTemp"  	name="declYmdTemp"  value="">
	<input type="hidden" id="searchTable"  	name="searchTable"  value="">
	<input type="hidden" id="workYy"  	 	name="workYy"  	 	value="">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li id="popTitle"></li>
                <li class="close"></li>
            </ul>
        </div>
        <div class="popup_main">
        	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
        		<tr>
        			<td>
        				<div class="sheet_title">
							<ul>
								<li class="txt"></li>
								<li class="btn">
									<a href="javascript:doAction1('Down2Excel')"	class="basic btn-download authR">다운로드</a>
								</li>
							</ul>
						</div>	
					</td>
				</tr>
			</table>
			
	        <script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
        </div>
	</div>
</form>
</body>
</html>
