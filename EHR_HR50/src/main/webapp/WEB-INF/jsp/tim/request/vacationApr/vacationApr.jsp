<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>근태승인관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {

		$("#searchSYmd").datepicker2({startdate:"searchEYmd"});
		$("#searchEYmd").datepicker2({enddate:"searchSYmd"});
		$("#searchFrom").datepicker2({startdate:"searchTo", onReturn: getStatusCd});
		$("#searchTo").datepicker2({enddate:"searchFrom", onReturn: getStatusCd});


		$("#searchSYmd, #searchEYmd, #searchFrom, #searchTo, #searchSabunName, #searchOrgNm").on("keyup", function(event) {
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
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, FrozenCol:7};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		var t1 = "<sht:txt mid='L19080500020' mdef='신청자' />";
		var t2 = "<sht:txt mid='L19080600016' mdef='신청내용' />";
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNoV1' 		      mdef='No|No' />",	Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
   			{Header:"<sht:txt mid='sDelete V1'        mdef='삭제|삭제' />",	Type:"${sDelTy}", Hidden:1,						Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus V4'        mdef='상태|상태' />",	Type:"${sSttTy}", Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			//기본항목
			{Header:"<sht:txt mid='checkV1' 		  mdef='선택|선택'/>",			   Type:"DummyCheck",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ibsCheck",	KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
   			{Header:"<sht:txt mid='detail' 			  mdef='세부\n내역|세부\n내역' />",   Type:"Image",  Hidden:0, Width:45,  Align:"Center", ColMerge:0,  SaveName:"ibsImage",     	Edit:0 },
   			{Header:"<sht:txt mid='applYmdV10' 		  mdef='신청일|신청일' />",			Type:"Text",   Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"applYmd", 		Format:"Ymd", Edit:0},
   			{Header:"<sht:txt mid='applStatusCdV6' 	  mdef='결재상태|결재상태' />",		Type:"Combo",  Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"applStatusCd",	UpdateEdit:1,	InsertEdit:0 },
			//신청자정보
   			{Header:t1+"|<sht:txt mid='sabun' 		  mdef='사번' />",	Type:"Text",   Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			Edit:0},
   			{Header:t1+"|<sht:txt mid='name' 		  mdef='성명' />",	Type:"Text",   Hidden:0, Width:80,	Align:"Center", ColMerge:0,  SaveName:"name", 			Edit:0},
   			{Header:t1+"|<sht:txt mid='orgNmV8' 	  mdef='부서' />",	Type:"Text",   Hidden:0, Width:120, Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			Edit:0},
   			{Header:t1+"|<sht:txt mid='jikgubNm'   	  mdef='직급' />",	Type:"Text",   Hidden:Number("${jgHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikgubNm", 		Edit:0},
   			{Header:t1+"|<sht:txt mid='jikchakNm'     mdef='직책' />",	Type:"Text",   Hidden:1, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikchakNm", 		Edit:0},
   			
   			//신청내용
			{Header:t2+"|<sht:txt mid='gntNmV3'       mdef='근태명'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gntNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:t2+"|<sht:txt mid='L191002000001' mdef='경조구분' />",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"occNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:t2+"|<sht:txt mid='sdate'         mdef='시작일'/>",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:t2+"|<sht:txt mid='edate'         mdef='종료일'/>",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:t2+"|<sht:txt mid='reqSHm'        mdef='시작시간'/>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"reqSHm",		KeyField:0,	Format:"Hm",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:t2+"|<sht:txt mid='reqEHm'        mdef='종료시간'/>",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"reqEHm",		KeyField:0,	Format:"Hm",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:t2+"|<sht:txt mid='holDayV3'      mdef='적용\n일수'/>",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"closeDay",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:t2+"|<sht:txt mid='L190820000025' mdef='취소여부' />",	Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"updateYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, FontColor:"#ff0000" },
			{Header:t2+"|<sht:txt mid='note'          mdef='비고'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"gntReqReson",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },

			{Header:"결재정보|결재일시",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"agreeYmd",		KeyField:0,	Format:"YmdHms",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"결재정보|결재자",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"agreeName",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"결재정보|결재라인",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStep",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"결재정보|다음결재자",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"nextAgreeName",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"결재정보|반려사유",		Type:"Text",	Hidden:0,	Width:130,	Align:"Left",	ColMerge:0,	SaveName:"returnMemo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

			//Hidden
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"gntCd"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeq"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"oldApplStatusCd"}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);
		sheet1.SetCountPosition(0);
		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("ibsImage", 1);
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함


		sheet1.SetColProperty("updateYn", 		{ComboText:'||<tit:txt mid="112396" mdef="취소" />', ComboCode:"|N|Y"} );

		// 처리상태
        //var applStatusCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAprStatusList",false).codeList, "<tit:txt mid='103895' mdef='전체' />");
		var applStatusCdList  = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getApplStatusCdList"), "선택");//신청서상태(R10010)
		sheet1.SetColProperty("applStatusCd",  {ComboText:"|"+applStatusCdList[0], ComboCode:"|"+applStatusCdList[1]} );
		$("#searchApplStatusCd").html(applStatusCdList[2]);
		$("#searchApplStatusCdUpdate").html(applStatusCdList[2]);
		
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
			sheet1.DoSearch( "${ctx}/VacationApr.do?cmd=getVacationAprList",$("#sheet1Form").serialize() );
			break;
		case "Save":

			//if(!dupChk(sheet1,"sabun|gntCd|sYmd", true, true)){break;}

			IBS_SaveName(document.sheet1Form,sheet1);

			sheet1.DoSave( "${ctx}/VacationApr.do?cmd=saveVacationApr" ,$("#sheet1Form").serialize());
			break;
		case "Change":

			var sFindRow = sheet1.FindCheckedRow("ibsCheck");
			var searchApplStatusCdUpdate = $("#searchApplStatusCdUpdate option:selected").val();

			if ( searchApplStatusCdUpdate == "" ){
				alert("상태변경을 선택하지않았습니다.");
				break;
			}

			if ( sFindRow == "" ){
				alert("선택된 행이 없습니다.");
				break;
			}

			$(sFindRow.split("|")).each(function(index,value){
				// 취소된 건은 제외..
				if( sheet1.GetCellValue( value, "updateYn" ) != "Y" ) {
					sheet1.SetCellValue( value, "applStatusCd", searchApplStatusCdUpdate);
				}
			});

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

	    		showApplPopup(applSeq,applSabun,applInSabun,applYmd);
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	function getReturnValue(returnValue) {
		var rv = returnValue;

	    pGubun = "";
	    doAction1("Search") ;
	}

	//신청 팝업
	function showApplPopup(seq,applSabun,applInSabun,applYmd) {
		if(!isPopup()) {return;}

		var adminYn = 'Y';
		if ('${ssnGrpCd}' == '32') {
			adminYn = 'N';
		}

		var p = {
				searchApplCd: '22'
			  , searchApplSeq: seq
			  , adminYn: adminYn
			  , authPg: 'R'
			  , searchSabun: applInSabun
			  , searchApplSabun: applSabun
			  , searchApplYmd: applYmd
			};
		var url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
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
			<td colspan="2">
				<input type="text" id="searchFrom" name="searchFrom" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>">&nbsp;~&nbsp;
				<input type="text" id="searchTo" name="searchTo" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>">
			</td>
			<th><tit:txt mid="112999" mdef="결재상태" /></th>
			<td>
				<select id="searchApplStatusCd" name="searchApplStatusCd"></select>
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
			<th><tit:txt mid='113464' mdef='시작일자'/></th>
			<td colspan="2">
				<input id="searchSYmd" name="searchSYmd" type="text" size="10" class="date2" value=""/> ~
				<input id="searchEYmd" name="searchEYmd" type="text" size="10" class="date2" value=""/>
			</td>
			<th><tit:txt mid="104279" mdef="소속" /> </th>
			<td>
				<input type="text" id="searchOrgNm" name="searchOrgNm" class="text w150" />
			</td>
			<th><tit:txt mid="104330" mdef="사번/성명" /></th>
			<td>
				<input type="text" id="searchSabunName" name="searchSabunName" class="text" />
			</td>
			<td colspan="2">
				<btn:a href="javascript:doAction1('Search')" mid="search" mdef="조회" css="btn dark"/>
			</td>
		</tr>
		</table>
	</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">휴가승인관리</li>
			<li class="btn">
				상태변경:	<select id="searchApplStatusCdUpdate" name="searchApplStatusCdUpdate" class="box" ></select>
			 	<a href="javascript:doAction1('Change');" 		class="btn filled authA">상태변경</a>
			 	<a href="javascript:doAction1('Save');" 		class="btn outline_gray authA">저장</a>
			 	<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline_gray authR" mid='download' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>