<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>기타지급승인관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

var getWorkCdSelectBox;

var searchWorkCdDayType = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getWorkCdList",false);

	$(function() {
		
		$("#searchSabunName, #searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		$("#searchSabunName2").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction2("Search"); $(this).focus(); }
		});

//========================================================================================================================
	
		$("#searchApplYmdFrom").datepicker2({startdate:"searchApplYmdTo", ymonly:true });
        $("#searchApplYmdTo").datepicker2({enddate:"searchApplYmdFrom", ymonly:true});
        
		$("#searchApplYmdFrom, #searchApplYmdTo").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		// 결재상태
		var applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getApplStatusCdList&applStatusNotCd=11,"), "전체");
		
		
		$("#searchApplStatusCd").html(applStatusCd[2]);
		
		// 최근급여일자 조회
		//getCpnLatestPaymentInfo();

//========================================================================================================================
		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:7,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No|No",						Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제", 		Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태", 		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"세부\n내역|세부\n내역",		Type:"Image",			Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"detail",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"신청일자|신청일자",			Type:"Date",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"성명|성명",					Type:"Text",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"사번|사번",					Type:"Text",			Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"직위|직위",					Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속|소속",					Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"결재상태|결재상태",			Type:"Combo",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"결재일|결재일",				Type:"Date",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"agreeYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"결재자|결재자",				Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"agreeName",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"결재라인|결재라인",			Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStep",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"다음결재자|다음결재자",		Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"nextAgreeName",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"반려사유|반려사유",			Type:"Text",			Hidden:0,	Width:130,	Align:"Left",	ColMerge:0,	SaveName:"returnMemo",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"근무년월|근무년월",			Type:"Date",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workYm",			KeyField:0,	Format:"Ym",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"수당명|수당명",				Type:"Text",			Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"workGubun",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"수당명|수당명",				Type:"Text",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"workGubunNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"지급총액|지급총액",			Type:"AutoSum",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"totMon",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"비고|비고",					Type:"Text",			Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"bigo",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },			
			{Header:"신청서순번|신청서순번",		Type:"Int",				Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"확인|확인",					Type:"CheckBox",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"magamYn",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"급여일자|급여일자",			Type:"Text",			Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"payActionNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"급여코드|급여코드",			Type:"Text",			Hidden:1,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"payActionCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(false);sheet1.SetCountPosition(4);

		//var applStatusCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), "");		//구분
		var applStatusCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getApplStatusCdList&applStatusNotCd=11,"), "");
		sheet1.SetColProperty("applStatusCd", 			{ComboText:applStatusCdList[0], ComboCode:applStatusCdList[1]} );
		
		//세부내역 버튼 이미지
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail",true);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata2.Cols = [
		{Header:"No|No",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"성명|성명",				Type:"Text",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"사번|사번",				Type:"Text",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"직위|직위",				Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"소속|소속",				Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		//{Header:"순번|순번",				Type:"Text",			Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"seq",					KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		//{Header:"수당명|수당명",			Type:"Text",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"benefitBizNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		//{Header:"합산년월|합산년월",	Type:"Date",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",	KeyField:1,	Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"금액|금액",				Type:"AutoSum",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"payMon",		KeyField:0,	Format:"Integer",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
	 	{Header:"상세비고|상세비고",	Type:"Text",			Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"detailBigo",		KeyField:0,		Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(false);sheet2.SetCountPosition(4);

		sheet1.SetEditArrowBehavior(3);
		sheet2.SetEditArrowBehavior(3);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});
	

	// 최근급여일자 조회
	function getCpnLatestPaymentInfo() {
		var procNm = "최근급여일자";
		// 급여구분(C00001-00001.급여)
		var paymentInfo = ajaxCall("${ctx}/CpnQuery.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00001", false);

		if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
			$("#payActionCd").val(paymentInfo.DATA[0].payActionCd);
			$("#payActionNm").val(paymentInfo.DATA[0].payActionNm);

			if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
				doAction1("Search");
			}
		} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
			alert(paymentInfo.Message);
		}
	}

	// 급여일자 검색 팝입
	function payActionSearchPopup() {
		if(!isPopup()) {return;}
		gPRow = "";
		pGubun = "payDayPopup";

		var w		= 850;
		var h		= 520;
		var url		= "/PayDayPopup.do?cmd=payDayPopup";
		var args	= new Array();

		args["runType"] = "00001"; // 급여구분(C00001-00001.급여)

		var result = openPopup(url+"&authPg=R", args, w, h);
		/*
		if (result) {
			var payActionCd	= result["payActionCd"];
			var payActionNm	= result["payActionNm"];

			$("#payActionCd").val(payActionCd);
			$("#payActionNm").val(payActionNm);
		}
		*/
	}

	//신청 팝업
	function showApplPopup(auth,seq,applSabun,applInSabun,applYmd, applCd) {
		if(!isPopup()) {return;}

		if(auth == "") {
			alert("권한을 입력하여 주십시오.");
			return;
		}

		var p = {
				searchApplCd: applCd
			  , searchApplSeq: seq
			  , adminYn: 'N'
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
						sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getExWorkDriverAppMgrList",$("#sheetForm").serialize() );
						
						break;
		case "Save":
						IBS_SaveName(document.sheetForm,sheet1);
						sheet1.DoSave( "${ctx}/ExWorkDriverAppMgr.do?cmd=saveExWorkDriverAppMgr", $("#sheetForm").serialize());						
						
						break;

		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet1);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
						sheet1.Down2Excel(param);

		}
	}

	//sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
						var applSeq = sheet1.GetCellValue( sheet1.GetSelectRow(), "applSeq");
						var param = "applSeq="+ applSeq 
										 +"&searchSabunName="+$("#searchSabunName2").val();
						
						sheet2.DoSearch( "${ctx}/GetDataList.do?cmd=getExWorkDriverAppMgrDetailList",param );
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet2);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
						sheet2.Down2Excel(param);

						break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
            // 급여일자 존재시 수정 불가
			for(var i=2 ; i<sheet1.RowCount()+2; i++){
				if( sheet1.GetCellValue(i,"payActionCd") != null && sheet1.GetCellValue(i,"payActionCd") != "" ){
					sheet1.SetRowEditable(i, 0);
				} 
			}
	
			doAction2("Search");
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

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}


	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			var saveName = sheet1.ColSaveName(NewCol);

			if(OldRow != NewRow){				
				if ( saveName != "sDelete" ){
					$("#searchSYmd").val(sheet1.GetCellValue(NewRow,"sYmd"));
					$("#searchSabun").val(sheet1.GetCellValue(NewRow,"sabun"));
					$("#searchSeq").val(sheet1.GetCellValue(NewRow,"seq"));
					sheet2.FocusAfterProcess = false;
					doAction2("Search");
				}				 
			} 

			if (saveName == "detail" ) { 
					
				var applSabun = sheet1.GetCellValue(NewRow,"sabun");
				var applSeq = sheet1.GetCellValue(NewRow,"applSeq");
				var applInSabun = sheet1.GetCellValue(NewRow,"applInSabun");
				var applYmd = sheet1.GetCellValue(NewRow,"applYmd");
				var applCd = "";
					
				if(sheet1.GetCellValue(NewRow,"workGubun") == "S") {
					applCd = "370";
				} else if(sheet1.GetCellValue(NewRow,"workGubun") == "N"){
					applCd = "360";
				}

				showApplPopup("R",applSeq,applSabun,applInSabun,applYmd, applCd);
			}
			
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	
	// 셀 클릭시 발생
	/*
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
    	
		try {
			if( Row < sheet1.HeaderRows() ) return;

		    if( sheet1.ColSaveName(Col) == "detail" ) {
		    	var auth = "R";
		    	if(sheet1.GetCellValue(Row, "applStatusCd") == "11") {
		    		//신청 팝업
		    		auth = "A";
		    	} else {
		    		//결재팝업
		    		auth = "R";
		    	}
		    	showApplPopup(auth //,"310"
		    			     ,sheet1.GetCellValue(Row,"applSeq")
	    				     ,sheet1.GetCellValue(Row,"applInSabun")
	    				     ,sheet1.GetCellValue(Row,"applYmd")
							 ,sheet1.GetCellValue(Row,"applStatusCd")
							);
		    //} else {
		    }
		    // 상세내역 조회
		    doAction2("Search");
		    //}
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}	
*/

	// 초기화
	function clearCode(num) {

		if(num == 1) {
		} else {
			//급여일자
			//$('#name').val("");
			$('#searchPayActionCd').val("");
			$('#searchPayActionNm').val("");
		}
	}

	// 입력시 조건 체크
	function checkList(){
		var ch = true;
		var exit = false;
		if(exit){return false;}
			// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prepend().find("span:first-child").text()+"은(는) 필수값입니다.");
				$(this).focus();
				ch =  false;
				return false;
			}
		});
		return ch;
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if(pGubun == "payDayPopup"){
			$("#searchPayActionCd").val(rv["payActionCd"]);
			$("#searchPayActionNm").val(rv["payActionNm"]);
	    }
		
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sheetForm" id="sheetForm" method="post">

<input id="searchSYmd" 		name="searchSYmd" 		type="hidden"/>
<input id="searchSabun" 	name="searchSabun" 		type="hidden"/>
<input id="searchSeq" 		name="searchSeq" 		type="hidden"/>
<input id="ssnGrpCd" 		name="ssnGrpCd" 		type="hidden" value ="${ssnGrpCd}"/>

	<div class="sheet_search outer">
		<div>
		<table>
			<tr>
				<th>근무년월 </th>
                <td>
                <!-- 
                    <input type="text" id="searchFrom" name="searchFrom" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>" /> ~
                    <input type="text" id="searchTo" name="searchTo" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>" />
 				-->
 					<input type="text" id="searchApplYmdFrom" name="searchApplYmdFrom" class="date2" value="<%=DateUtil.addMonths(DateUtil.getCurrentDate(),-1)%>"/> ~
                    <input type="text" id="searchApplYmdTo" name="searchApplYmdTo" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM")%>" />
                </td>
				<th>수당구분</th>
				<td>
					<select id="etcPayAppBnCd" name="etcPayAppBnCd" onchange="javascript:doAction1('Search');">
						<option value="">전체</option>
						<option value="N">야근수당</option>
						<option value="S">특근수당</option>
					</select>
				</td>
				<th><tit:txt mid='112999' mdef='결재상태'/></th>
				<td>
					<select id="searchApplStatusCd" name="searchApplStatusCd" onchange="javascript:doAction1('Search');" />
				</td>
			</tr>
			<tr>
				<th>사번/성명</th>
				<td>
					<input id="searchSabunName" name="searchSabunName" type="text" class="text" style="ime-mode:active;" />
				</td>
				<th>소속</th>
				<td>
					<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" />
				</td>
				<th>확인여부</th>
				<td>
					<select id="searchMagamYn" name="searchMagamYn" class="box" onchange="javascript:doAction1('Search');" >
						<option value="">전체</option>
						<option value="Y">확인</option>
						<option value="N">미확인</option>
					</select>
				</td>
				<th>급여일자</th>
				<td>  
					<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="" />
					<input type="text" id="searchPayActionNm" name="searchPayActionNm" class="text required readonly" value="" readonly style="width:180px" />
					<a href="javascript:payActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a> 
					<a href="javascript:clearCode(2)" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
					<a href="javascript:doAction1('Search');"  class="button">조회</a>
				</td>
			</tr>
		</table>
		</div>
	</div>
</form>

<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<tr>
		<td class="sheet_top">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt">시간외수당(기원)종합승인관리</li>
						<li class="btn">
							<a href="javascript:doAction1('Save');" 					class="basic authA">저장</a>
							<a href="javascript:doAction1('Down2Excel');" 				class="basic authR">다운로드</a>
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%"); </script>
		</td>
	</tr>
	<tr>
		<td class="sheet_bottom">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<!-- <li class="txt">기타지급승인관리상세</li>  -->
						<li>&nbsp;</li>
						<li class="btn">
										사번/성명 <input id="searchSabunName2" name="searchSabunName2" type="text"   class="text" />
							<a href="javascript:doAction2('Search');" class="button">조회</a>
							<a href="javascript:doAction2('Down2Excel');" 				class="basic authR">다운로드</a>
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%"); </script>
		</td>
	</tr>
	</table>
</div>
</body>
</html>