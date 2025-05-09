<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='114687' mdef='퇴직자 check List'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	$(function() {

		$("#searchFrom").datepicker2({startdate:"searchTo", onReturn: getCommonCodeList});
		$("#searchTo").datepicker2({enddate:"searchFrom", onReturn: getCommonCodeList});
		
		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata1.Cols = [		
			{Header:"<sht:txt mid='sNoV1' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
//			{Header:"<sht:txt mid='sDeleteV1' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sDeleteV1' mdef='삭제'/>",			Type:"Html",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"btnDel",	Sort:0 },
   			
			{Header:"<sht:txt mid='sStatusV1' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"<sht:txt mid='temp2' mdef='세부내역'/>",			Type:"Image",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"detail",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			
   			{Header:"<sht:txt mid='gubun' mdef='구분'/>",				Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gubun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:2000 },
   			{Header:"<sht:txt mid='sabun' mdef='사번'/>",				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
   			{Header:"<sht:txt mid='name' mdef='성명'/>",				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },
   			{Header:"<sht:txt mid='orgNm' mdef='조직'/>",				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikweeNm' mdef='직위'/>",			Type:"Text",		Hidden:Number("${jwHdn}") ,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
			{Header:"<sht:txt mid='rdate' mdef='퇴사일'/>",			Type:"Date",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"rdate",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='applYmd' mdef='신청일자'/>",		Type:"Date",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='applStatusCd' mdef='신청상태'/>",	Type:"Combo",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			
			{Header:"<sht:txt mid='applSeq' mdef='applSeq'/>",		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='applSabun' mdef='applSabun'/>",	Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"applSabun",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='applInSabun' mdef='applInSabun'/>",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"applInSabun",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
			
//			{Header:"<sht:txt mid='chkResult' mdef='chkResult'/>",	Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"chkResult",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000 },
//			{Header:"<sht:txt mid='rmk' mdef='rmk'/>",				Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"rmk",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000 },
//			{Header:"<sht:txt mid='chkSabun' mdef='chkSabun'/>",	Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"chkSabun",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000 },
//			{Header:"<sht:txt mid='seq' mdef='seq'/>",				Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000 }
			
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4); 
		
		sheet1.SetCountPosition(0);
		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);
		
		sheet1.SetColProperty("gubun", 	{ComboText:"|퇴직자신청|관리자입력", ComboCode:"|10|20"} );

		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "name", rv["name"]);
						sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
					}
				}
			]
		}); 	
		
		$(window).smartresize(sheetResize); sheetInit();

		getCommonCodeList();

		$("#searchFrom,#searchTo,#searchNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		doAction1("Search");
	});

	function getCommonCodeList() {
		let baseSYmd = $("#searchFrom").val();
		let baseEYmd = $("#searchTo").val();

		const applStatusCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010", baseSYmd, baseEYmd), "");
		sheet1.SetColProperty("applStatusCd", 	{ComboText:applStatusCd[0], ComboCode:applStatusCd[1]} );
	}
	
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			
			var param = "searchFrom="+$("#searchFrom").val().replace(/-/gi,"")
			+"&searchTo="+$("#searchTo").val().replace(/-/gi,"")						
			+"&searchNm="+$("#searchNm").val();
			sheet1.DoSearch( "${ctx}/RetireCheckListMgr.do?cmd=getRetireCheckListMgrList", param);
			break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1); 
			sheet1.DoSave( "${ctx}/RetireCheckListMgr.do?cmd=saveRetireCheckListMgr", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row,"gubun","20");
			
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row,"applSeq","");
			sheet1.SetCellValue(row,"gubun","20");
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "Proc":
			if(sheet1.RowCount() < 1) {
				return;
			}
			
			var sabunStr = "";
			var dtStr = "";	
			
			for(var i = 1; i< sheet1.RowCount()+1; i++){
				if(sheet1.GetCellValue(i, "sStatus") == "I"){	
					
					if(sheet1.GetCellValue(i, "sabun")==""|| sheet1.GetCellValue(i, "rdate")==""){
						alert("사번, 퇴사일은 필수 입력 값 입니다.");
						return;
					}
					
					if(i == 1){
						sabunStr = sheet1.GetCellValue(i, "sabun");
						dtStr = sheet1.GetCellValue(i, "rdate");					
					}else{
						sabunStr += ","+sheet1.GetCellValue(i, "sabun");
						dtStr += ","+sheet1.GetCellValue(i, "rdate");	
					}
				}
			}
			if(sabunStr ==""){
				alert("등록한 데이터가 없어 CHECK LIST 생성 할 수 없습니다. ");
				return;
			}
			var param = "sabunStr="+sabunStr+"&dtStr="+dtStr;
			var data = ajaxCall("/RetireCheckListMgr.do?cmd=prcPHrmRetireCheckList",param,false);

			if(data.Result.Code == "1") {
	    		alert("<msg:txt mid='110120' mdef='처리되었습니다.'/>");
	    		doAction1("Search");
	    	} else {
		    	alert(data.Result.Message);
	    	}
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			}
			
			for(var i = 1; i < sheet1.RowCount()+1; i++) {
				if(sheet1.GetCellValue(i, "applStatusCd") != "99") {
					sheet1.SetCellValue(i, "btnDel", '<btn:a css="basic" mid='btnDel' mdef="삭제"/>');
					sheet1.SetCellValue(i, "sStatus", 'R');
				}
			}
			
			sheetResize();
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	 
	
	//팝업 콜백 함수.
	function getReturnValue(rv) {
		if(pGubun == "sheetAutocomplete"){
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"] );
			sheet1.SetCellValue(gPRow, "name", rv["name"] );
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"] );
			sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"] );
		}
	}
	
	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {

			if( sheet1.ColSaveName(Col) == "detail" && Row >= sheet1.HeaderRows() && sheet1.GetCellValue(Row, "sStatus") != "I" ) {

				var auth = "R";
				if(sheet1.GetCellValue(Row, "applStatusCd") == "11") {
					//신청 팝업
					auth = "A";
				} else {
					//결재팝업
					auth = "R";
				}

				showApplPopup(auth, sheet1.GetCellValue(Row, "applSeq"), sheet1.GetCellValue(Row, "applInSabun"), sheet1.GetCellValue(Row, "applYmd"), Row);

			}else if (sheet1.ColSaveName(Col) == "btnDel"){
				
				if(sheet1.GetCellValue(Row, "applStatusCd") != "99") {
					if( sheet1.GetCellValue(Row, "applStatusCd") == "11" && sheet1.GetCellValue(Row, "sStatus") == "I" ) {
						sheet1.RowDelete(Row);
					} else {
						sheet1.SetCellValue(Row,"sStatus" ,"D");
						doAction1("Save");
					}
				}
				
			}
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	//신청 팝업
	function showApplPopup(auth,seq,searchSabun,applYmd, Row) {

		if(!isPopup()) {return;}

		if(auth == "") {
			alert("<msg:txt mid='alertInputAuth' mdef='권한을 입력하여 주십시오.'/>");
			return;
		}
		
		var p = {
				searchApplCd: '118'
			  , searchApplSeq: seq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: searchSabun
			  , searchApplSabun: searchSabun
			  , searchApplYmd: applYmd 
			  , etc01: sheet1.GetCellValue(Row,"gubun")
			};
		
		var url = "";
		var initFunc = '';
		if(auth == "A") {
			url = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
			initFunc = 'initLayer';
		} else {
			url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			initFunc = 'initResultLayer';
		}

		var args = new Array();

		if(Row != ""){
			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
		}else{
			args["applStatusCd"] = "11";
		}

		gPRow = "";
		pGubun = "viewApprovalMgr";
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
	
</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">

<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th><tit:txt mid='104084' mdef='신청일자'/></th>
				<td >
					<input id="searchFrom" name="searchFrom" type="text" size="10" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-7)%>"/> ~
					<input id="searchTo" name="searchTo" type="text" size="10" class="date2 required" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
				</td>
				<th><tit:txt mid='112947' mdef='성명'/></th>
				<td>
					<input id="searchNm" name="searchNm" type="text" class="text" style=""/>
				</td>
				<td>
					<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/>
				</td>
			</tr>
			</table>
			</div>
		</div>
		
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='113617' mdef='퇴직자 Check List 관리'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
				<btn:a href="javascript:doAction1('Insert');" css="btn outline-gray authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction1('Proc');" css="btn filled authA" mid='CHECKlIST생성' mdef="CHECKlIST생성"/>
			</li>
		</ul>
		</div>
	</div>
	
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
