<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata = {};
		var param = "&searchCodeNm=1";
		
		$(window).smartresize(sheetResize); sheetInit();
		
		$("#searchYmd").datepicker2();
		
		$("#searchSabunName, #searchYmd").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		
		$("#searchYear").bind("keyup",function(event){
        	makeNumber(this,"A");
    		if( event.keyCode == 13){
    			doAction1("Search");
    		}
    	});
		
		doAction1("Search");
		
		// 이름 입력 시 자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name",		rv["name"]);
						sheet1.SetCellValue(gPRow, "enterCd",	rv["enterCd"]);
					}
				}
			]
		});		
	});
	
	function makeSearchTitleList() {
		sheet1.Reset();
		var initdata = {};
		initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22,MergeSheet:8}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			 {Header:"No|No",									Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", 	ColMerge:0,  	SaveName:"sNo" },
			 {Header:"본부|본부",									Type:"Text",       	Hidden:0,  					Width:120,  		Align:"Center",    	ColMerge:0,   	SaveName:"bonbu",      		KeyField:0, Format:"",  		UpdateEdit:0, InsertEdit:0,	 PointCount:0,   EditLen:100, ColMerge:1 },
			 {Header:"실|실",										Type:"Text",       	Hidden:0,  					Width:120,  		Align:"Center",    	ColMerge:0,   	SaveName:"sil",      		KeyField:0, Format:"",  		UpdateEdit:0, InsertEdit:0,	 PointCount:0,   EditLen:100, ColMerge:1 },
			 {Header:"팀|팀",										Type:"Text",       	Hidden:0,  					Width:120,  		Align:"Center",    	ColMerge:0,   	SaveName:"team",      		KeyField:0, Format:"",  		UpdateEdit:0, InsertEdit:0,	 PointCount:0,   EditLen:100, ColMerge:1 },
			 {Header:"사번|사번",									Type:"Text",  	    Hidden:0,  					Width:80,   		Align:"Center",  	ColMerge:0,   	SaveName:"sabun",      		KeyField:1, Format:"",  		UpdateEdit:0, InsertEdit:0,	 PointCount:0,   EditLen:13 },
			 {Header:"이름|이름",									Type:"Text",  		Hidden:0,  					Width:80,   		Align:"Center",  	ColMerge:0,   	SaveName:"name",       		KeyField:1, Format:"",  		UpdateEdit:0, InsertEdit:0,	 PointCount:0,   EditLen:100 },
			 {Header:"그룹직급|그룹직급",							Type:"Text",       	Hidden:0,  					Width:70,  			Align:"Center",    	ColMerge:0,   	SaveName:"grpGikgub",  		KeyField:0, Format:"",  		UpdateEdit:0, InsertEdit:0,	 PointCount:0,   EditLen:100 },
			 {Header:"직책|직책",									Type:"Text",       	Hidden:0,  					Width:100,  		Align:"Center",    	ColMerge:0,   	SaveName:"jikchakNm",     	KeyField:1, Format:"",  		UpdateEdit:0, InsertEdit:0,	 PointCount:0,   EditLen:100 },
			 
			 {Header:($("#searchYear").val() - 1)+"|역량총점", 	Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"prevCollScr05", 	KeyField:0, Format:"NullFloat", UpdateEdit:0, InsertEdit:0 },
			 {Header:($("#searchYear").val() - 1)+"|리더만족도", 	Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"prevLeaderScr", 	KeyField:0, Format:"NullFloat", UpdateEdit:0, InsertEdit:0 },
			 {Header:($("#searchYear").val())+"|역량총점", 		Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"currCollScr05", 	KeyField:0, Format:"NullFloat", UpdateEdit:0, InsertEdit:0 },
			 {Header:($("#searchYear").val())+"|리더만족도", 		Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"currLeaderScr", 	KeyField:0, Format:"NullFloat", UpdateEdit:0, InsertEdit:0 },
			 {Header:"전년대비|역량총점", 							Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"comCollScr05", 	KeyField:0, Format:"NullFloat", UpdateEdit:0, InsertEdit:0 },
			 {Header:"전년대비|리더만족도", 							Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"comLeaderScr", 	KeyField:0, Format:"NullFloat", UpdateEdit:0, InsertEdit:0 },
			 {Header:"리더십유형|리더십유형", 						Type:"Text", 		Hidden:0, 					Width:100, 			Align:"Center", 	ColMerge:0,		SaveName:"leaderDiv01", 	KeyField:0, Format:"", 			UpdateEdit:0, InsertEdit:0, 				 EditLen:30},
			 {Header:"평가자|평가자수", 							Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"apprCnt01", 		KeyField:0, Format:"NullFloat", UpdateEdit:0, InsertEdit:0 },
			 {Header:"평가자|참여평가자수", 							Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"apprCntSum", 		KeyField:0, Format:"NullFloat", UpdateEdit:0, InsertEdit:0 },
			 {Header:"평가자|참여참여율", 							Type:"Float", 		Hidden:0, 					Width:60, 			Align:"Right", 		ColMerge:0,		SaveName:"apprCntPerc", 	KeyField:0, Format:"#\\%", UpdateEdit:0, InsertEdit:0 },
			 
			 {Header:"<sht:txt mid='btnFile' mdef='첨부파일|첨부파일'/>",	
				 												Type:"Html",		Hidden:0,					Width:80,			Align:"Center",		ColMerge:0,		SaveName:"btnFile",			KeyField:0,	Format:"",			PointCount:0, UpdateEdit:0,	 InsertEdit:0,	 EditLen:35 },
			 {Header:"파일순번", 									Type:"Text", 		Hidden:1, 					Width:100, 			Align:"Center", 	ColMerge:0,		SaveName:"fileSeq", 		KeyField:0, Format:"", 			UpdateEdit:0, InsertEdit:0 },
			 {Header:"비고", 										Type:"Text", 		Hidden:1, 					Width:100, 			Align:"Center", 	ColMerge:0,		SaveName:"note", 			KeyField:0, Format:"", 			UpdateEdit:0, InsertEdit:0 },
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(4);
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if($("#searchYear").val() == ""){
				alert("<msg:txt mid='109901' mdef='평가년도를 입력하세요.'/>");
				return;
			}			
			var year = $("#searchYear").val();
			makeSearchTitleList(); 
			sheet1.DoSearch( "${ctx}/ExecCompAppMngResultSrh.do?cmd=getExecCompAppMngResultSrhList", $("#sheetForm").serialize());
			break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			var d = new Date();
			var fName = "excel_" + d.getTime() + ".xlsx";
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 })); 
			break;
		case "LoadExcel":	
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; 
			sheet1.LoadExcel(params); 
			break;
		}
	}
	

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{ 
			if (Msg != ""){ 
				alert(Msg); 
			} 
			
            for(var i=sheet1.HeaderRows();i<sheet1.RowCount()+sheet1.HeaderRows();i++){
            	sheet1.SetCellValue(i, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>', false);
				sheet1.SetCellValue(i, "sStatus", 'R', false);
            	//sheet1.GetCellValue(i,"");
            }			
			
			sheetResize(); 
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{ 
			if(Msg != ""){ 
				alert(Msg); 
			} 
			if( Code > -1 ) doAction1("Search");
		}catch(ex){ 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	}
	
	function sheet1_OnPopupClick(Row, Col) {
		try{
		
			var colName = sheet1.ColSaveName(Col);
			if (Row >= sheet1.HeaderRows()) {
				if (colName == "name") {
					// 사원검색 팝입
					empSearchPopup(Row, Col);
				}
			}
		} catch(ex) {alert("OnPopupClick Event Error : " + ex);}
	}
	
	var gPRow = "";
	// 사원검색 팝입
	function empSearchPopup(Row, Col) {
		if(!isPopup()) {return;}

		var w		= 840;
		var h		= 520;
		var url		= "/Popup.do?cmd=employeePopup";
		var args	= new Array();
		args["sType"] = "G";

		gPRow = Row;
		pGubun = "employeePopup";

		openPopup(url+"&authPg=R", args, w, h);
	}
	
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');
		if (rv) {
			sheet1.SetCellValue(gPRow, "enterCd", rv["enterCd"]);
			sheet1.SetCellValue(gPRow, "enterNm", rv["enterNm"]);
			
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow, "name", rv["name"]);
			sheet1.SetCellValue(gPRow, "orgCd", rv["orgCd"]);
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			
			sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
			sheet1.SetCellValue(gPRow, "jikgubCd", rv["jikgubCd"]);
			sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
			sheet1.SetCellValue(gPRow, "jikchakCd", rv["jikchakCd"]);
			sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
			sheet1.SetCellValue(gPRow, "jikweeCd", rv["jikweeCd"]);
			
			sheet1.SetCellValue(gPRow, "handPhone", rv["handPhone"]);
			sheet1.SetCellValue(gPRow, "mailId", rv["mailId"]);
			
		}

	}

	//파일 신청 시작
	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "btnFile" && Row >= sheet1.HeaderRows()){
				var param = [];
				param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");
				if(sheet1.GetCellValue(Row,"btnFile") != ""){

					gPRow = Row;
					pGubun = "viewPopup";

					var authPgTemp="${authPg}";
					openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+"R"+"&uploadType=ccr", param, "740","620");
				}
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	
	//파일 신청 끝
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "viewPopup"){
			if(rv != null){
				if(rv["fileCheck"] == "exist"){
					sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
					sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
				}else{
					sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
					sheet1.SetCellValue(gPRow, "fileSeq", "");
				}
			}
	    }
	}
	
</script>
</head>
<body class="hidden">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span><tit:txt mid='' mdef='평가년도'/></span>
							<!-- select name="searchYear" id="searchYear" onChange="javaScript:doAction1('Search');doAction2('Search');"></select -->
							<input type="text"   id="searchYear"  name="searchYear" value="${curSysYear}" class="text required" style="ime-mode:disabled" maxLength=4/>
						</td>
						<td> <span>기준일자</span> 
							<!-- value="${curSysYyyyMMddHyphen}" -->
							<input type="text" class="text date2" id="searchYmd" name="searchYmd" />
						</td>
						<td><span><tit:txt mid='' mdef='성명/사번'/></span> 
							<input id="searchSabunName" name ="searchSabunName" type="text" class="text" /> 
						</td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
						
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">임원다면평가결과</li>
							<!-- 
							<li class="btn">
								<a href="javascript:doAction1('LoadExcel')" 	class="basic authR">업로드</a>
								<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
								<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
							</li>
							 -->
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>