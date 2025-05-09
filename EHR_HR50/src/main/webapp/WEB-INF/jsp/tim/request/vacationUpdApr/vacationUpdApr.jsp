<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>근태취소승인관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {

		$("#searchFrom").datepicker2({startdate:"searchTo", onReturn: getStatusCd});
		$("#searchTo").datepicker2({enddate:"searchFrom", onReturn: getStatusCd});

		$("#searchFrom, #searchTo, #searchSabunName, #searchOrgNm").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});

		$("#searchApplStatusCd, #searchGntCd").on("change", function(e) {
			doAction1("Search");
		})

		
		init_sheet();
		
		//근태종류  콤보
		var gntGubunCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getVacationAppDetGntGubunList", false).codeList, "전체");
		$("#searchGntGubunCd").html(gntGubunCdList[2]);
		
		$("#searchGntGubunCd").change(function(){
			var gntCd        = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getVacationAppDetGntCdList&searchGntGubunCd="+$("#searchGntGubunCd").val(), false).codeList, "전체");
			$("#searchGntCd").html(gntCd[2]);
			doAction1("Search");
		}).change();
        
	});
	
	function init_sheet(){ 
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22, FrozenCol:6};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		var t1 = "<sht:txt mid='L19080500020' mdef='신청자' />";
		var t2 = "<sht:txt mid='L19080600016' mdef='신청내용' />";
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNoV1' 		      mdef='No|No' />",	Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
   			{Header:"<sht:txt mid='sDelete V1'        mdef='삭제|삭제' />",	Type:"${sDelTy}", Hidden:1,						Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus V4'        mdef='상태|상태' />",	Type:"${sSttTy}", Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			//기본항목
   			{Header:"<sht:txt mid='detail' 			  mdef='세부\n내역|세부\n내역' />",   	Type:"Image",  Hidden:0, Width:45,  Align:"Center", ColMerge:0,  SaveName:"ibsImage",     	Edit:0 },
   			{Header:"<sht:txt mid='applYmdV10' 		  mdef='신청일|신청일' />",			Type:"Text",   Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"applYmd", 		Format:"Ymd", Edit:0},
   			{Header:"<sht:txt mid='applStatusCdV6' 	  mdef='결재상태|결재상태' />",			Type:"Combo",  Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"applStatusCd",	Edit:0 },
			//신청자정보
   			{Header:t1+"|<sht:txt mid='sabun' 		  mdef='사번' />",	Type:"Text",   Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			Edit:0},
   			{Header:t1+"|<sht:txt mid='name' 		  mdef='성명' />",	Type:"Text",   Hidden:0, Width:80,	Align:"Center", ColMerge:0,  SaveName:"name", 			Edit:0},
   			{Header:t1+"|<sht:txt mid='orgNmV8' 	  mdef='부서' />",	Type:"Text",   Hidden:0, Width:120, Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			Edit:0},
   			{Header:t1+"|<sht:txt mid='jikgubNm'   	  mdef='직급' />",	Type:"Text",   Hidden:Number("${jgHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikgubNm", 		Edit:0},
   			{Header:t1+"|<sht:txt mid='jikchakNm'     mdef='직책' />",	Type:"Text",   Hidden:1, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikchakNm", 		Edit:0},
   			{Header:t1+"|<sht:txt mid='manageNm'      mdef='사원구분' />",Type:"Text",   Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"manageNm", 		Edit:0},
   			
   			//신청내용
			{Header:t2+"|<sht:txt mid='gntNmV3'       mdef='근태명'/>",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gntCd",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:t2+"|<sht:txt mid='L191002000001' mdef='경조구분' />",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"occNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:t2+"|<sht:txt mid='sdate'         mdef='시작일'/>",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sYmd",		KeyField:0,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:t2+"|<sht:txt mid='edate'         mdef='종료일'/>",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eYmd",		KeyField:0,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:t2+"|<sht:txt mid='holDayV3'      mdef='적용\n일수'/>",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"closeDay",	KeyField:0,	Format:"Number",	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:t2+"|<sht:txt mid='reason'        mdef='사유' />",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"gntReqReason",KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	EditLen:2000 },
			//Hidden
			{Header:"applSabun",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applSabun"},
			{Header:"applInSabun",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applInSabun"},
			{Header:"applSeq",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"applSeq"},
			{Header:"applCd",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"applCd"},
			{Header:"bApplSeq",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"bApplSeq"}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetCountPosition(0);
		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("ibsImage", 1);

		// 처리상태
        var applStatusCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAprStatusList",false).codeList, "<tit:txt mid='103895' mdef='전체' />");
		sheet1.SetColProperty("applStatusCd",  {ComboText:"|"+applStatusCdList[0], ComboCode:"|"+applStatusCdList[1]} );
		$("#searchApplStatusCd").html(applStatusCdList[2]);
		
		//근태코드
		var gntCd        = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getVacationAppDetGntCdList"), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("gntCd", 			{ComboText:gntCd[0], ComboCode:gntCd[1]} );
		
		//재직상태
		getStatusCd();
		
		$(window).smartresize(sheetResize); sheetInit();
	}

	function getStatusCd() {
		let baseSYmd = $("#searchFrom").val();
		let baseEYmd = $("#searchTo").val();

		const statusCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010", baseSYmd, baseEYmd), "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchGStatusCd").html(statusCd[2]);
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if($("#searchFrom").val() == "") {
				alert("<msg:txt mid='alertSYmd' mdef='시작일자를 입력하여 주십시오.'/>");
				$("#searchFrom").focus();
				return;
			}
			if($("#searchTo").val() == "") {
				alert("<msg:txt mid='alertEYmd' mdef='종료일자를 입력하여 주십시오.' />");
				$("#searchTo").focus();
				return;
			}
			sheet1.DoSearch( "${ctx}/VacationUpdApr.do?cmd=getVacationUpdAprList", $("#sheet1Form").serialize() );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
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

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
		    if( sheet1.ColSaveName(Col) == "ibsImage" ) { 
	    		
	    		var applSabun = sheet1.GetCellValue(Row,"applSabun");
	    		var applSeq = sheet1.GetCellValue(Row,"applSeq");
	    		var applInSabun = sheet1.GetCellValue(Row,"applInSabun");
	    		var applYmd = sheet1.GetCellValue(Row,"applYmd");
	    		var applCd = sheet1.GetCellValue(Row,"applCd"); // 변경 신청서 추가로 인한 PARAM

	    		showApplPopup("R",applSeq,applSabun,applInSabun,applYmd, applCd);

		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	function getReturnValue(returnValue) {
		var rv = returnValue;
		doAction1("Search");
	}


	//신청 팝업
	function showApplPopup(auth,seq,applSabun,applInSabun,applYmd,applCd) {
		if(!isPopup()) {return;}
		if(auth == "") {
			alert("<msg:txt mid='alertInputAuth' mdef='권한을 입력하여 주십시오.'/>");
			return;
		}

		var adminYn = 'Y'
		if ('${ssnGrpCd}' == '32') {
			adminYn = 'N';
		}

		var p = {
				searchApplCd: applCd
			  , searchApplSeq: seq
			  , adminYn: adminYn
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: applSabun
			  , searchApplYmd: applYmd
			};

		var url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
		var initFunc = 'initResultLayer';
		
		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
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
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<!-- 조회조건 -->
	<div class="sheet_search outer">
		<table>
		<tr>
			<th><tit:txt mid="104102" mdef="신청기간" /></th>
			<td>
				<input type="text" id="searchFrom" name="searchFrom" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>">&nbsp;~&nbsp;
				<input type="text" id="searchTo" name="searchTo" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>">
			</td>
			<th>근태종류</th>
			<td>
				<select id="searchGntGubunCd" name="searchGntGubunCd"></select>
			</td>
			<th>근태명</th>
			<td>
				<select id="searchGntCd" name="searchGntCd"></select>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid="104279" mdef="소속" /> </th>
			<td>
				<input type="text" id="searchOrgNm" name="searchOrgNm" class="text w150" />
			</td>
			<th><tit:txt mid="104330" mdef="사번/성명" /></th>
			<td>
				<input type="text" id="searchSabunName" name="searchSabunName" class="text" />
			</td>
			<th><tit:txt mid="112999" mdef="결재상태" /></th>
			<td>
				<select id="searchApplStatusCd" name="searchApplStatusCd"></select>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search')" mid="search" mdef="조회" css="btn dark"/>
			</td>
		</tr>
		</table>
	</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">휴가취소승인관리</li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline_gray authR" mid='download' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>