<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>시간외근무(기원)승인관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {
		
		$("#searchSabunName, #searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});		

//========================================================================================================================
	
		$("#searchFromYmd").datepicker2({startdate:"searchToYmd"});
        $("#searchToYmd").datepicker2({enddate:"searchFromYmd"});

		// 결재상태
		var applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getApplStatusCdList&applStatusNotCd=11,"), "전체");
				
		$("#searchApplStatusCd").html(applStatusCd[2]);
		

//========================================================================================================================

		var initdata = {};
		initdata.Cfg = {FrozenCol:1,SearchMode:smLazyLoad,Page:22,MergeSheet:msBaseColumnMerge+msHeaderOnly,PrevColumnMergeMode:1}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",						Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"상태",						Type:"${sSttTy}",	Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			//{Header:"삭제",					Type:"${sDelTy}",	Hidden:0,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Edit:0 },
			{Header:"세부\n내역",				Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"detail",		Format:"",		Edit:0 },
			{Header:"신청일자",					Type:"Date",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",			Format:"Ymd",	Edit:0 },
			{Header:"성명",						Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"사번",						Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"소속",						Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위",						Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"결재상태",					Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"결재라인",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStep",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"최종결재자",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"agreeName",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"결재일",					Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"agreeYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"다음결재자",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"nextAgreeName",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"수당구분",						Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workGubun",		Format:"",		Edit:0 },
			{Header:"근무일자",						Type:"Date",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sdate",			Format:"Ymd",	Edit:0 },
			{Header:"아침시작시간\n(야근수당)",		Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"morningSHm",			Format:"##:##",	Edit:0 },
			{Header:"근무시작시간",					Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"reqSHm",			Format:"##:##",	Edit:0 },
			{Header:"근무종료시간",					Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"reqEHm",			Format:"##:##",	Edit:0 },
			{Header:"총 시간\n(특근수당)",			Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workHour",			Format:"##:##",	Edit:0 },
			{Header:"골프장여부\n(특근수당)",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"golfYn",		Edit:0,	FontColor:"#FF0000" },
			{Header:"근무내용",						Type:"Text",	Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"reason",		Format:"",		Edit:0 },
			//Hidden
			{Header:"신청순번",						Type:"Text",	Hidden:1,	Width:90, 	Align:"Center",	ColMerge:0,	SaveName:"applSeq"},
			{Header:"신청입력자",					Type:"Text",   	Hidden:1, 	Width:80 , 	Align:"Center", ColMerge:0, SaveName:"applInSabun"},
			{Header:"신청자사번",					Type:"Text",   	Hidden:1, 	Width:80 , 	Align:"Center", ColMerge:0, SaveName:"applSabun"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		//var applStatusCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), "");		//구분
		var applStatusCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getApplStatusCdList&applStatusNotCd=11,"), "");
		sheet1.SetColProperty("applStatusCd", 			{ComboText:applStatusCdList[0], ComboCode:applStatusCdList[1]} );
		
		//세부내역 버튼 이미지
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail",true);

		sheet1.SetEditArrowBehavior(3);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});
	

	//신청 팝업
	function showApplPopup(auth,seq,applSabun,applInSabun,applYmd) {
		if(!isPopup()) {return;}

		if(auth == "") {
			alert("권한을 입력하여 주십시오.");
			return;
		}
		var p = {
				searchApplCd: '340'
			  , searchApplSeq: seq
			  , adminYn: 'Y'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: applSabun
			  , searchApplYmd: applYmd 
			};
		var url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
		var initFunc = 'initResultLayer';
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
	
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
						// 필수값/유효성 체크
						if (!chkInVal(sAction)) {
							break;
						}
						
						sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getExWorkDriverMgrList", $("#sendForm").serialize());
						
						break;
		case "Save":
						IBS_SaveName(document.sendForm,sheet1);
						sheet1.DoSave( "${ctx}/SaveData.do?cmd=updateExWorkDriverMgrThri", $("#sendForm").serialize());
						
						break;

		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet1);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
						sheet1.Down2Excel(param);
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
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

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			var saveName = sheet1.ColSaveName(NewCol);

			if (saveName == "detail" ) { 
					
				var applSabun = sheet1.GetCellValue(NewRow,"sabun");
				var applSeq = sheet1.GetCellValue(NewRow,"applSeq");
				var applInSabun = sheet1.GetCellValue(NewRow,"applInSabun");
				var applYmd = sheet1.GetCellValue(NewRow,"applYmd");

				showApplPopup("R",applSeq,applSabun,applInSabun,applYmd);
			}
			
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	function chkInVal(sAction) {
		if($("#searchFromYmd").val() == "") {
			alert("근무일자 검색기간을 입력하십시오.");
			$("#searchFromYmd").focus();
			return false;
		}

		if($("#searchToYmd").val() == "") {
			alert("근무일자 검색기간을 입력하십시오.");
			$("#searchToYmd").focus();
			return false;
		}		
	
		return true;
	}
	
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		doAction1("Search");
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sendForm" id="sendForm" method="post">
<input id="searchSabun" 	name="searchSabun" 		type="hidden"/>
<input id="searchSeq" 		name="searchSeq" 		type="hidden"/>
<input id="ssnGrpCd" 		name="ssnGrpCd" 		type="hidden" value ="${ssnGrpCd}"/>
	<div class="sheet_search outer">
		<div>
		<table>
			<tr>
				<th>근무일자 </th>
                <td>
                    <input type="text" id="searchFromYmd" name="searchFromYmd" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>" /> ~
                    <input type="text" id="searchToYmd" name="searchToYmd" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>" />
				</td>
				<th><tit:txt mid='112999' mdef='결재상태'/></th>
				<td>
					<select id="searchApplStatusCd" name="searchApplStatusCd" onchange="javascript:doAction1('Search');" />
				</td>
				<th>수당구분</th>
				<td>
					<select id="searchWorkGubun" name="searchWorkGubun" onchange="javascript:doAction1('Search');">
			    		<option value="">전체</option>				
						<option value="N">야근수당</option>
						<option value="S">특근수당</option>
					</select>
				</td>
			</tr>
			<tr>
				<th>신청자 사번/성명</th>
				<td>
					<input id="searchSabunName" name="searchSabunName" type="text" class="text" style="ime-mode:active;" />
				</td>
				<th>신청자 소속</th>
				<td>
					<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" />
				</td>
				<td><a href="javascript:doAction1('Search');"  class="button">조회</a></td>
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
						<li class="txt">시간외근무(기원)승인관리</li>
						<li class="btn">
							<a href="javascript:doAction1('Save');" 					class="basic authA">저장</a>
							<a href="javascript:doAction1('Down2Excel');" 				class="basic authR">다운로드</a>
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
		</td
	</tr>
	</table>
</div>
</body>
</html>