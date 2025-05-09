<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		$("#searchSdate").datepicker2({startdate:"searchEdate"});
		$("#searchEdate").datepicker2({enddate:"searchSdate"});

		$("#searchApplCd").bind("change",function(e){
			doAction("Search");
		});

		$("#searchSdate, #searchEdate, #searchSabunNm").bind("keyup",function(e){
			if( e.keyCode == 13) doAction1("Search");
		});

		doAction1("Search");
		
		init_sheet();

		// 이름 입력 시 자동완성
		$(sheet2).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "agreeName",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet2.SetCellValue(gPRow, "agreeSabun",		rv["sabun"]);
						sheet2.SetCellValue(gPRow, "agreeName",			rv["name"]);
						sheet2.SetCellValue(gPRow, "agreeOrgNm",		rv["orgNm"]);
						sheet2.SetCellValue(gPRow, "agreeJikchakNm",	rv["jikchakNm"]);
					}
				}
			]
		});	
		
	});
	
	
	function init_sheet(){

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:3, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1'          mdef='No|No'/>",							Type:"${sNoTy}",  	Hidden:0,  Width:"${sNoWdt}",  Align:"Center",  SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V1'     mdef='삭제|삭제'/>",						Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus V4'     mdef='상태|상태'/>",						Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  SaveName:"sStatus" },
			{Header:"<sht:txt mid='detail'         mdef='세부\n내역|세부\n내역'/>",				Type:"Image",     	Hidden:0,  Width:40,   	Align:"Center",  SaveName:"detail",       	Cursor:"Pointer"},
			
			{Header:"<sht:txt mid='applSeq'        mdef='결재신청서순번|결재신청서순번'/>",			Type:"Text",     	Hidden:1,  Width:80,   	Align:"Center",  SaveName:"applSeq",       	KeyField:0,	Format:"",	UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='applNmV2'       mdef='신청서종류|신청서종류'/>",				Type:"Combo",      	Hidden:0,  Width:80,   	Align:"Center",  SaveName:"applCd", 		KeyField:0,	Format:"",	UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='applYmdV2'      mdef='신청일자|신청일자'/>",					Type:"Text",      	Hidden:0,  Width:80,  	Align:"Center",  SaveName:"applYmd",      	KeyField:0,	Format:"",	UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='applSabunV2'    mdef='신청대상자|사번'/>",					Type:"Text",      	Hidden:0,  Width:80,  	Align:"Center",  SaveName:"applSabun",     	KeyField:0,	Format:"",	UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='applNameV2'     mdef='신청대상자|성명'/>",					Type:"Text",      	Hidden:0,  Width:80,  	Align:"Center",  SaveName:"applName",     	KeyField:0,	Format:"",	UpdateEdit:0,   InsertEdit:0 },
			{Header:"신청대상자|직급",															Type:"Text",      	Hidden:Number("${jgHdn}"),  Width:80,  	Align:"Center",  SaveName:"applJikgubNm",     	KeyField:0,	Format:"",	UpdateEdit:0,   InsertEdit:0 },
			{Header:"신청대상자|직위",															Type:"Text",      	Hidden:Number("${jwHdn}"),  Width:80,  	Align:"Center",  SaveName:"applJikweeNm",     	KeyField:0,	Format:"",	UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='applInSabun'    mdef='신청입력자|사번'/>",					Type:"Text",     	Hidden:0,  Width:80,  	Align:"Center",  SaveName:"applInSabun",	KeyField:0,	Format:"", 	UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='applInName'     mdef='신청입력자|성명'/>",					Type:"Text",     	Hidden:0,  Width:80,  	Align:"Center",  SaveName:"applInName",		KeyField:0,	Format:"",	UpdateEdit:0,   InsertEdit:0 },
			{Header:"신청입력자|직급",															Type:"Text",     	Hidden:Number("${jgHdn}"),  Width:80,  	Align:"Center",  SaveName:"applInJikgubNm",		KeyField:0,	Format:"",	UpdateEdit:0,   InsertEdit:0 },
			{Header:"신청입력자|직위",															Type:"Text",     	Hidden:Number("${jwHdn}"),  Width:80,  	Align:"Center",  SaveName:"applInJikweeNm",		KeyField:0,	Format:"",	UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='applStatusCdNm' mdef='신청서상태|신청서상태'/>",				Type:"Combo",     	Hidden:0,  Width:80,  	Align:"Center",  SaveName:"applStatusCd",	KeyField:0,	Format:"",	UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='finishYn'       mdef='프로세스\n완료여부|프로세스\n완료여부'/>",	Type:"Text",     	Hidden:0,  Width:40,  	Align:"Center",  SaveName:"finishYn",		KeyField:0,	Format:"",	UpdateEdit:0,   InsertEdit:0 },
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable(true);sheet1.SetCountPosition(4);sheet1.SetVisible(true);
		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");

		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:3, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'             mdef='No'/>",		Type:"${sNoTy}",  	Hidden:1,  Width:"${sNoWdt}",  Align:"Center",  SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5'      mdef='삭제'/>",		Type:"${sDelTy}", 	Hidden:0,  Width:"${sDelWdt}", Align:"Center",  SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus'         mdef='상태'/>",		Type:"${sSttTy}", 	Hidden:0,  Width:"${sSttWdt}", Align:"Center",  SaveName:"sStatus" },
			
			{Header:"<sht:txt mid='agreeSeqV1'      mdef='결재순번'/>",	Type:"Text",     	Hidden:0,  Width:60,   	Align:"Center",  SaveName:"agreeSeq",       KeyField:1,	Format:"",	UpdateEdit:1,   InsertEdit:1 },
			{Header:"<sht:txt mid='applTypeCd'      mdef='결재구분'/>",	Type:"Combo",      	Hidden:0,  Width:70,   	Align:"Center",  SaveName:"applTypeCd",		KeyField:1,	Format:"",	UpdateEdit:1,   InsertEdit:1 },
			{Header:"<sht:txt mid='agreeStatusCd'   mdef='결재상태'/>",	Type:"Combo",      	Hidden:0,  Width:80,  	Align:"Center",  SaveName:"agreeStatusCd",	KeyField:0,	Format:"",	UpdateEdit:1,   InsertEdit:1 },
			{Header:"<sht:txt mid='gubunNm'         mdef='수신자여부'/>",	Type:"Combo",      	Hidden:0,  Width:80,  	Align:"Center",  SaveName:"gubun",     		KeyField:0,	Format:"",	UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='agreeSabunV1'    mdef='결재자사번'/>",	Type:"Text",      	Hidden:0,  Width:80,  	Align:"Center",  SaveName:"agreeSabun",     KeyField:0,	Format:"",	UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='agreeName'       mdef='결재자성명'/>",	Type:"Text",     	Hidden:0,  Width:80,  	Align:"Center",  SaveName:"agreeName",		KeyField:1,	Format:"", 	UpdateEdit:1,   InsertEdit:1 },
			{Header:"<sht:txt mid='agreeOrgNm'      mdef='결재자부서'/>",	Type:"Text",     	Hidden:0,  Width:80,  	Align:"Center",  SaveName:"agreeOrgNm",		KeyField:0,	Format:"", 	UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='agreeJikchakNm'  mdef='결재자직책'/>",	Type:"Text",     	Hidden:0,  Width:80,  	Align:"Center",  SaveName:"agreeJikchakNm",	KeyField:0,	Format:"", 	UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='agreeJikweeNm'   mdef='결재자직위'/>",	Type:"Text",     	Hidden:Number("${jwHdn}"),  Width:80,  	Align:"Center",  SaveName:"agreeJikweeNm",	KeyField:0,	Format:"", 	UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='applYmdV3'       mdef='결재일시'/>",	Type:"Text",     	Hidden:0,  Width:100,  	Align:"Center",  SaveName:"agreeYmd",		KeyField:0,	Format:"",	UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='memoV15'         mdef='결재의견'/>",	Type:"Text",     	Hidden:0,  Width:200,  	Align:"Left",    SaveName:"memo",			KeyField:0,	Format:"",	UpdateEdit:1,   InsertEdit:1 },
			
			{Header:"Hidden", Hidden:1, SaveName:"applSeq"}, 	  //신청서순번
			{Header:"Hidden", Hidden:1, SaveName:"pathSeq"},  	  //결재경로번호
			{Header:"Hidden", Hidden:1, SaveName:"agreeTime"}, 	  //결재일시
			{Header:"Hidden", Hidden:1, SaveName:"orgAppYn"}, 	   //부서결재여부
			{Header:"Hidden", Hidden:1, SaveName:"deputyYn"},     //대결자생성여부
			{Header:"Hidden", Hidden:1, SaveName:"deputySabun"},   //대결자사번 
			{Header:"Hidden", Hidden:1, SaveName:"deputyOrg"},    //대결자조직명
			{Header:"Hidden", Hidden:1, SaveName:"deputyJikchak"}, //대결자직책명
			{Header:"Hidden", Hidden:1, SaveName:"deputyJikwee"},  //대결자직위명
			{Header:"Hidden", Hidden:1, SaveName:"deputyAdminYn"}  //대결관리자여부
		]; IBS_InitSheet(sheet2, initdata); sheet2.SetEditable(true);sheet2.SetCountPosition(4);sheet2.SetVisible(true);
		
		var applCdList 			= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppMasterMgrApplCdList&useYn=Y",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("applCd", 		{ComboText:applCdList[0],	ComboCode:applCdList[1]} );
		sheet2.SetColProperty("gubun", 			{ComboText:'<tit:txt mid="103900" mdef="기타" />|<tit:txt mid="113919" mdef="본인" />|<tit:txt mid="113201" mdef="결재" />|<tit:txt mid="L1706070000006" mdef="수신" />',		ComboCode:"|0|1|3"} );
		$("#searchApplCd").html(applCdList[2]);

		getCommonCodeList();
		$(window).smartresize(sheetResize); sheetInit();
	}

	function getCommonCodeList() {
		let baseSYmd = $("#searchSdate").val();
		let baseEYmd = $("#searchEdate").val();

		const applTypeCdList 		= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10052", baseSYmd, baseEYmd), "",-1);
		const agreeStatusCdList 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10050", baseSYmd, baseEYmd), "",-1);
		const applStatusCdList 		= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010", baseSYmd, baseEYmd), "",-1);
		sheet1.SetColProperty("applStatusCd", 	{ComboText:"|"+applStatusCdList[0]+"|<tit:txt mid='112938' mdef='승인요청' />",ComboCode:"|"+applStatusCdList[1]+"|98"} );
		sheet2.SetColProperty("applTypeCd", 	{ComboText:applTypeCdList[0],	ComboCode:applTypeCdList[1]} );
		sheet2.SetColProperty("agreeStatusCd", 	{ComboText:"|"+agreeStatusCdList[0],ComboCode:"|"+agreeStatusCdList[1]} );
	}

	function chkInVal() {

		if ($("#searchSdate").val() == "") {
			alert("<msg:txt mid='110391' mdef='신청일자 시작일을 입력하여 주십시오.'/>")
			return false;
		}

		if ($("#searchEdate").val() == "") {
			alert("<msg:txt mid='110256' mdef='신청일자 종료일을 입력하여 주십시오.'/>")
			return false;
		}

		if ($("#searchSdate").val() != "" && $("#searchEdate").val() != "") {
			if (!checkFromToDate($("#searchSdate"),$("#searchEdate"),"신청일자","신청일자","YYYYMMDD")) {
				return false;
			}
		}
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!chkInVal()){break;}
			getCommonCodeList();
			sheet1.DoSearch( "${ctx}/AppMasterMgr.do?cmd=getAppMasterMgrList", $("#sheet1Form").serialize());
			break;
		}
    }

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var sXml = sheet2.GetSearchData("${ctx}/AppMasterMgr.do?cmd=getAppMasterMgrDetailList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet2.LoadSearchData(sXml );
			//sheet2.DoSearch( "${ctx}/AppMasterMgr.do?cmd=getAppMasterMgrDetailList", $("#sheet1Form").serialize());
			break;
		case "Save":
			
			if( $("#searchApplSeq").val() == "" ){
				return;
			}
			if( sheet2.RowCount("I") + sheet2.RowCount("U") +sheet2.RowCount("D") == 0 ){
				return;
			}

        	if(!dupChk(sheet2,"agreeSeq", true, true)){break;}
        	
			var saveStr = sheet2.GetSaveString(0);
            if(saveStr.match("KeyFieldError")) { return; }

			sheet2.ColumnSort("agreeSeq");
			break;
		case "Save2":	
			var idx = 1;
			for(var i = sheet2.HeaderRows(); i < sheet2.RowCount()+sheet2.HeaderRows() ; i++) {
				if( sheet2.GetCellValue(i,"sStatus") != "D" ){
					sheet2.SetCellValue(i,"sStatus", "I");
					sheet2.SetCellValue(i,"agreeSeq", idx++);
				}
			}
			$("#searchPathSeq").val(sheet2.GetCellValue(1,"pathSeq"));
			IBS_SaveName(document.sheet1Form,sheet2);
			sheet2.DoSave( "${ctx}/AppMasterMgr.do?cmd=saveAppMasterMgrDtl", $("#sheet1Form").serialize());
		
			break;
		case "Insert":	 	
			sheet2.SelectCell(sheet2.DataInsert(sheet2.LastRow()+1), 3); 
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet2.Down2Excel(param);
			break;
		}
    }
	
	

	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			if(Msg != "") alert(Msg);
			sheet2.RemoveAll();
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			} 
			if( Code > -1 ) doAction1("Search"); 
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value) {
		try{
			if( Row < sheet1.HeaderRows() ) return;
			
		    if(sheet1.ColSaveName(Col)=="detail" ){
		    	if(!isPopup()) {return;}
	    		var args = new Array(5);
	    		args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
	    		var url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
	    		var initFunc = 'initResultLayer'
	    		var p = {
	    				searchApplCd: sheet1.GetCellValue(Row, "applCd")
	    			  , searchApplSeq: sheet1.GetCellValue(Row, "applSeq")
	    			  , adminYn: 'Y'
	    			  , authPg: 'R'
	    			  , searchSabun: sheet1.GetCellValue(Row,"applInSabun")
	    			  , searchApplSabun: sheet1.GetCellValue(Row, "applSabun")
	    			  , searchApplYmd: sheet1.GetCellValue(Row,"applYmd") 
	    			};
	    		var approvalMgrLayer = new window.top.document.LayerModal({
	    			id: 'approvalMgrLayer',
	    			url: url,
	    			parameters: p,
	    			width: 800,
	    			height: 815,
	    			title: '근태신청',
	    			trigger: [
	    				{
	    					name: 'approvalMgrLayerTrigger',
	    					callback: function(rv) {
	    						getReturnValue(rv);
	    					}
	    				}
	    			]
	    		});
	    		approvalMgrLayer.show();
	    		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	
	// 셀 선택시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if( OldRow != NewRow ) {
				$("#searchApplSeq").val(sheet1.GetCellValue(sheet1.GetSelectRow(),"applSeq"));
				doAction2("Search");
			}
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}

	
	
	//---------------------------------------------------------------------------------------------------------------
	// sheet2 Event
	//---------------------------------------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if(Msg != "") alert(Msg);
			
			if( Code > -1 ) doAction2("Search");
		
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	function sheet2_OnPopupClick(Row, Col){
		try{
			if(!isPopup()) {return;}
			gPRow = Row;
			pGubun = "employeePopup";

			if(Row ==0) return;
			var w 		= 840;
			var h 		= 520;
			var url 	= "${ctx}/Popup.do?cmd=employeePopup";
			var args 	= new Array();

			args["name"] = "";
			args["sabun"] = "";
			var result = openPopup(url,args,w,h);
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	function sheet2_OnSort(Col, SortArrow) {
		try { 
			doAction2("Save2");
		} catch (ex) { alert("OnSort Event Error : " + ex); }
	}
	
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "employeePopup"){
			sheet2.SetCellValue(gPRow, "agreeSabun",    	rv["sabun"] );
			sheet2.SetCellValue(gPRow, "agreeName",     	rv["name"] );
			sheet2.SetCellValue(gPRow, "agreeJikchakNm",	rv["jikchakNm"] );
			sheet2.SetCellValue(gPRow, "agreeJikgubNm",		rv["jikgubNm"] );
			sheet2.SetCellValue(gPRow, "agreeJikweeNm",		rv["jikweeNm"] );
			sheet2.SetCellValue(gPRow, "agreeOrgNm",     	rv["orgNm"] );
	    }
	}
</script>
</head>
<body class="bodywrap">

	<div class="wrapper">
		<form id="sheet1Form" name="sheet1Form">
			<input type="hidden" id="searchApplSeq" name="searchApplSeq" />
			<input type="hidden" id="searchPathSeq"	name="searchPathSeq" />
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th><tit:txt mid='112125' mdef='신청서종류'/></th>
							<td>
								<select id="searchApplCd" name="searchApplCd"> </select>
							</td>
							<th>신청일자</th>
							<td>
								<input type="text" id="searchSdate" name="searchSdate" class="text date2" value="<%=(DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-7)).replaceAll("-","") %>" />
								~
								<input type="text" id="searchEdate" name="searchEdate" class="text date2" value="<%=DateUtil.getCurrentTime("yyyyMMdd") %>" />
							</td>
							<th><tit:txt mid='112947' mdef='성명/사번'/></th>
							<td>
								<input id="searchSabunNm" name="searchSabunNm" type="text" class="text">
							</td>
							<td>
								<btn:a href="javascript:doAction1('Search')" css="btn dark" mid="110697" mdef="조회"/>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</form>
		<div class="outer">
			<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='applMaster' mdef='결재마스터내역'/></li>
				</ul>
			</div>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%","${ssnLocaleCd}"); </script>
		<div class="outer">
			<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='applProgress' mdef='결재진행내역'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction2('Down2Excel');" 	css="btn outline-gray" mid="110698" mdef="다운로드"/>
						<btn:a href="javascript:doAction2('Search');" 		css="btn outline-gray" mid="111506" mdef="리셋"/>
						<btn:a href="javascript:doAction2('Insert');" 		css="btn outline-gray" mid="110700" mdef="입력"/>
						<btn:a href="javascript:doAction2('Save');" 		css="btn filled" mid="110708" mdef="저장"/>
					</li>
				</ul>
			</div>
		</div>
		<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>

	</div>
</body>
</html>



