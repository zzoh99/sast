<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head><title>사내공모신청자(부서장)</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		$("#searchApplStaYmd").datepicker2({startdate:"searchApplEndYmd"});
		$("#searchApplEndYmd").datepicker2({enddate:"searchApplStaYmd"});
	
		$("#searchPubcStatCd").on("change", function(e) {
			doAction1("Search");
		})
		
		var initdata = {};
		initdata.Cfg = { SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly };
		initdata.HeaderMode = { Sort:1, ColMove:1, ColResize:1, HeaderCheck:0 };
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			//신청내용
			{Header:"공모구분",		Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"pubcDivCd",		KeyField:0,	Format:"",		Edit:0 },
			{Header:"공모상태",		Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"pubcStatCd",		KeyField:0,	Format:"",		Edit:0 },
			{Header:"공모명",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"pubcNm",			KeyField:0,	Format:"",		Edit:0 },
			{Header:"신청시작일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStaYmd",		KeyField:0,	Format:"Ymd",	Edit:0 },
			{Header:"신청종료일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applEndYmd",		KeyField:0,	Format:"Ymd",	Edit:0 },
			{Header:"신청인원",		Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"applCnt",			KeyField:0,	Format:"",		Edit:0 },
			{Header:"선정인원",		Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"selCnt",			KeyField:0,	Format:"",		Edit:0 },
			
			//Hidden
			{Header:"공모ID",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"pubcId" },
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable(false); sheet1.SetVisible(true); sheet1.SetCountPosition(4);
		
		var applStatusCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAprStatusList",false).codeList, "전체");	// 처리상태
		var pubcDivCd 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","CD1026"), "");	//공모구분
		var pubcStatCd 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","CD1027"), "전체");	//공모상태
		
		sheet1.SetColProperty("applStatusCd",  {ComboText:"|"+applStatusCdList[0], ComboCode:"|"+applStatusCdList[1]} );
		sheet1.SetColProperty("pubcDivCd",		{ComboText:"|"+pubcDivCd[0], ComboCode:"|"+pubcDivCd[1]} );
		sheet1.SetColProperty("pubcStatCd",		{ComboText:"|"+pubcStatCd[0], ComboCode:"|"+pubcStatCd[1]} );
		
		$("#searchPubcStatCd").html(pubcStatCd[2]);
		
		//Detail Sheet(sheet2)
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"세부\n내역",		Type:"Image",		Hidden:0,  Width:50,   	Align:"Center",  	ColMerge:0,   SaveName:"detail",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,    },
			{Header:"신청일",			Type:"Date",		Hidden:0,  Width:70,  	Align:"Center",  	ColMerge:0,   SaveName:"applYmd",       KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,    },
			{Header:"결재상태",			Type:"Combo",		Hidden:1,  Width:70,   	Align:"Center",  	ColMerge:0,   SaveName:"applStatusCd",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,    },
			{Header:"프로필",			Type:"Image",     	Hidden:0,  Width:40,   	Align:"Center",  	ColMerge:0,   SaveName:"detail2", 			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10,	Cursor:"Pointer" },
			{Header:"사진",				Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0, SaveName:"photo",		UpdateEdit:0,	ImgWidth:50,	ImgHeight:60 },
			{Header:"사번",				Type:"Text",		Hidden:0,  Width:60,   	Align:"Center",  	ColMerge:0,   SaveName:"sabun",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,    },
			{Header:"성명",				Type:"Text",		Hidden:0,  Width:50,   	Align:"Center",  	ColMerge:0,   SaveName:"name",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,    },
			{Header:"부서",				Type:"Text",		Hidden:0,  Width:80,   	Align:"Left",  		ColMerge:0,   SaveName:"orgNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,    },
			{Header:"직급",				Type:"Text",		Hidden:0,  Width:50,   	Align:"Center",  	ColMerge:0,   SaveName:"jikgubNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,    },
			{Header:"지원동기",			Type:"Text",		Hidden:0,  Width:70,   	Align:"Left",	  	ColMerge:0,   SaveName:"applRsn",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,    },
			{Header:"직무수행계획",			Type:"Text",		Hidden:0,  Width:70,   	Align:"Left",  		ColMerge:0,   SaveName:"planTxt",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,    },
			{Header:"선정여부",			Type:"CheckBox",	Hidden:1,  Width:60,   	Align:"Center",  	ColMerge:0,   SaveName:"choiceYn",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   TrueValue:"Y", FalseValue:"N" },
			{Header:"선정사유",			Type:"Text",		Hidden:1,  Width:80,   	Align:"Left",	  	ColMerge:0,   SaveName:"choiceRsn",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:100 },
			
			{Header:"신청자사번",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applInSabun" },
			{Header:"신청서코드",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applSeq" },
		]; 
		IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet2.SetDataLinkMouse("detail", 1);
		
		// 헤더 배경색
		var bcc = "#fdf0f5";
		sheet2.SetCellBackColor(0, "choiceYn", bcc);  sheet2.SetCellBackColor(1, "choiceYn", bcc);
		sheet2.SetCellBackColor(0, "choiceRsn", bcc);  sheet2.SetCellBackColor(1, "choiceRsn", bcc);
		
		sheet2.SetColProperty("applStatusCd",  {ComboText:"|"+applStatusCdList[0], ComboCode:"|"+applStatusCdList[1]} );
		
		$(window).smartresize(sheetResize); 
		sheetInit();
		doAction1("Search");
	
	});	
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch("${ctx}/PubcMgrChief.do?cmd=getPubcMgrChiefList", $("#sheet1Form").serialize() );
			break;
			
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); 
			break;
			
		}
	}
	
	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); 
			$("#sheet1PubcId").val( sheet1.GetCellValue(1,"pubcId") ) ;
			doAction2('Search') ;
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
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if(sheet1.GetCellValue(Row,"sStatus") != "I" && sheet1.ColSaveName(Col) != "sDelete" ){
	            $("#sheet1PubcId").val( sheet1.GetCellValue(Row,"pubcId") ) ;
                doAction2("Search");
            }
		} catch(ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var sXml = sheet2.GetSearchData("${ctx}/PubcMgrChief.do?cmd=getPubcMgrChiefList2", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet2.LoadSearchData(sXml );
			break;
		case "Save": 		
			if(sheet1.LastRow() < 1) { alert("사내공모 데이터를 선택하여 주십시오.") ; return ;}
			IBS_SaveName(document.sheet1Form,sheet2);
			sheet2.DoSave( "${ctx}/PubcMgrChief.do?cmd=savePubcMgrChief2", $("#sheet1Form").serialize()); 
			break;
		case "Down2Excel":	sheet2.Down2Excel(); break;
		}
	}
	
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			} 
			if( Code > -1 ) doAction2("Search"); 
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	// 셀 클릭시 발생
	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet2.HeaderRows() ) return;
			if( sheet2.ColSaveName(Col) == "detail" ) {
				showApplPopup(Row);
			} else if (sheet2.ColSaveName(Col) == "detail2") {
				profilePopup(Row) ;
			}
		} catch(ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	// 신청서 세부내역 팝업
	function showApplPopup(Row) {
		if(!isPopup()) {return;}

		const p = {
			searchApplCd : '200',
			searchApplSeq : sheet2.GetCellValue(Row,"applSeq"),
			adminYn : 'N',
			authPg : 'R',
			searchSabun : sheet2.GetCellValue(Row,"applInSabun"),
			searchApplSabun : sheet2.GetCellValue(Row, "sabun"),
			searchApplYmd : sheet2.GetCellValue(Row,"applYmd"),
		};

		var url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer&";

		var args = new Array();

		gPRow = "";
		pGubun = "viewApprovalMgr";

		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 950,
			height: 800,
			title: '사내공모신청',
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {
					}
				}
			]
		});
		approvalMgrLayer.show();
	}

	/**
	 * 조직원 프로필 window open event
	 */
	function profilePopup(Row){
		if(!isPopup()) {return;}

		var w 		= 610;
		var h 		= 350;
		var url 	= "${ctx}/EmpProfilePopup.do?cmd=viewEmpProfile&authPg=${authPg}";
		var args 	= new Array();
		args["sabun"] 		= sheet2.GetCellValue(Row, "sabun");
		EmpProfilePopup(Row);
		//openPopup(url,args,w,h);
	}

	// 근무지역 팝입
	function EmpProfilePopup(Row) {
		var authPgTemp="${authPg}";
		let layerModal = new window.top.document.LayerModal({
			id : 'EmpProfileLayer'
			, url : '${ctx}/EmpProfilePopup.do?cmd=viewEmpProfileLayer&authPg=${authPg}'
			, parameters : {
				sabun : sheet2.GetCellValue(Row, "sabun")
			}
			, width : 610
			, height : 400
			, title : 'Profile'
			, trigger :[
				{
					name : 'EmpProfileTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
	}

	//신청 후 리턴
	function getReturnValue(returnValue) {
		doAction2("Search");
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<input id="sheet1PubcId" name="sheet1PubcId" type="hidden" class=""/> 
		<!-- 조회조건 -->
		<div class="sheet_search outer">
			<table>
				<tr>
					<td colspan="2">
						<span>신청기간</span>
						<input type="text" id="searchApplStaYmd" name="searchApplStaYmd" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>">&nbsp;~&nbsp;
						<input type="text" id="searchApplEndYmd" name="searchApplEndYmd" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>">
					</td>
					<td>
						<span>공모상태</span>
						<select id="searchPubcStatCd" name="searchPubcStatCd"></select>
					</td>
					<td>
						<a href="javascript:doAction1('Search')" class="button">조회</a>
					</td>
				</tr>
			</table>
		</div>
	</form>
	<div class="outer">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">사내공모</li>
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel');" 	class="basic authR">다운로드</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
	<div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">신청자</li>
            <li class="btn">
            	<a href="javascript:doAction2('Search')" id="btnSearch" class="button">조회</a>
				<%--<a href="javascript:doAction2('Save')" 	class="basic authA">저장</a>--%>
				<a href="javascript:doAction2('Down2Excel')" 	class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet2", "100%", "50%"); </script>
</div>
</body>
</html>
