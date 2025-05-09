<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head><title>사내강사료신청승인</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	var pGubun =""
	$(function() {
		$("#btnPr1, #btnPr1Del, #btnPr2, #btnPr2Del").hide();
	
		$("#searchFrom").datepicker2({startdate:"searchTo"});
		$("#searchTo").datepicker2({enddate:"searchFrom"});
		$("#searchPayYm").datepicker2({ymonly:true, onReturn:function(){doAction1("Search");}});
				
		
		$("#searchFrom, #searchTo, #searchSabunName, #searchOrgNm, #searchPayYm").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
	
		$("#searchApplStatusCd").on("change", function(e) {
			doAction1("Search");
		})
		
		
		init_sheet();
		
		
		doAction1("Search");
	});

	

	function init_sheet(){ 
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:4,FrozenColRight:4};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"삭제|삭제",			Type:"${sDelTy}", Hidden:1,						Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",			Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			//기본항목
			{Header:"세부\n내역|세부\n내역", Type:"Image",  	Hidden:0, Width:45,  	Align:"Center", ColMerge:0,  SaveName:"detail",     	Edit:0 },
			{Header:"신청일|신청일",		Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"applYmd", 		Format:"Ymd", Edit:0},
			{Header:"결재상태|결재상태",	Type:"Combo",  	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"applStatusCd",	Edit:0 },
			//신청자정보
			{Header:"신청자|사번",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			Edit:0},
			{Header:"신청자|성명",			Type:"Text",   	Hidden:0, Width:80,		Align:"Center", ColMerge:0,  SaveName:"name", 			Edit:0},
			{Header:"신청자|부서",			Type:"Text",   	Hidden:0, Width:120, 	Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			Edit:0},
			{Header:"신청자|직책",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikchakNm", 		Edit:0},
			{Header:"신청자|직위",			Type:"Text",   	Hidden:Number("${jwHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikweeNm", 		Edit:0},
			{Header:"신청자|직급",			Type:"Text",   	Hidden:Number("${jgHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikgubNm", 		Edit:0},
			{Header:"신청자|직군",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"worktypeNm", 		Edit:0},
			
			//신청내용
			{Header:"신청내용|과정명",		Type:"Text",	Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"eduCourseNm",		KeyField:0,	Format:"",		Edit:0},
			{Header:"신청내용|교육시작일",	Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"eduSYmd",			KeyField:0,	Format:"Ymd",	Edit:0},	
			{Header:"신청내용|교육종료일",	Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"eduEYmd",			KeyField:0,	Format:"Ymd",	Edit:0},	
			{Header:"신청내용|강의과목",  	Type:"Text",    Hidden:0, 	Width:250, 	Align:"Left",   ColMerge:1, SaveName:"subjectLecture",  KeyField:0, Format:"",      Edit:0},
			{Header:"신청내용|강사료", 		Type:"Int",     Hidden:0, 	Width:70, 	Align:"Right", ColMerge:1, SaveName:"lectureFee", 		KeyField:0,	Format:"", 		Edit:0},

			//Hidden
			{Header:"eduSeq",		Hidden:1, SaveName:"eduSeq"},
  			{Header:"eduEventSeq",	Hidden:1, SaveName:"eduEventSeq"},
  			{Header:"Hidden",		Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",		Hidden:1, SaveName:"applSeq"},
			//지급정보
			{Header:"지급정보|지급금액",		Type:"Int",		Hidden:0,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"payMon",		KeyField:0,	Format:"",		UpdateEdit:1},
			{Header:"지급정보|급여년월",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"payYm",		KeyField:0,	Format:"Ym",	UpdateEdit:1},
			{Header:"지급정보|마감\n여부",	Type:"CheckBox",Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"closeYn",		KeyField:0,	Format:"",		Edit:0, 	TrueValue:"Y",	FalseValue:"N" },
			{Header:"지급정보|비고",		Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"payNote",		KeyField:0,	Format:"",		UpdateEdit:1},
			
  		];
  		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);
		
		//지급정보 헤더 배경색
		var bcc = "#fdf0f5";
		sheet1.SetCellBackColor(0, "payMon", bcc);  sheet1.SetCellBackColor(1, "payMon", bcc);  
		sheet1.SetCellBackColor(0, "closeYn", bcc);  sheet1.SetCellBackColor(1, "closeYn", bcc);  
		sheet1.SetCellBackColor(0, "payYm", bcc);  sheet1.SetCellBackColor(1, "payYm", bcc);  
		sheet1.SetCellBackColor(0, "payNote", bcc);  sheet1.SetCellBackColor(1, "payNote", bcc); 
		
		// 처리상태
        var applStatusCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAprStatusList",false).codeList, "전체");
		sheet1.SetColProperty("applStatusCd",  {ComboText:"|"+applStatusCdList[0], ComboCode:"|"+applStatusCdList[1]} );
		$("#searchApplStatusCd").html(applStatusCdList[2]);
		
		$(window).smartresize(sheetResize); sheetInit();
		
	}


	function chkInVal() {

		if ($("#searchFrom").val() == "" && $("#searchTo").val() != "") {
			alert('신청기간 시작일을 입력하세요.');
			return false;
		}

		if ($("#searchFrom").val() != "" && $("#searchTo").val() == "") {
			alert('신청기간 종료일을 입력하세요.');
			return false;
		}

		if ($("#searchFrom").val() != "" && $("#searchTo").val() != "") {
			if (!checkFromToDate($("#searchFrom"),$("#searchTo"),"신청일자","신청일자","YYYYMMDD")) {
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
			var sXml = sheet1.GetSearchData("${ctx}/LectureFeeApr.do?cmd=getLectureFeeAprList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet1.LoadSearchData(sXml );
			break;
        case "Save":   
       		IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/LectureFeeApr.do?cmd=saveLectureFeeApr", $("#sheet1Form").serialize()); 
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
		try {
			if (Msg != "") {
				alert(Msg);
			}
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
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			
		    if( sheet1.ColSaveName(Col) == "detail" ) {
		    	showApplPopup(Row);
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	

	//세부내역 팝업
	function showApplPopup(Row) {
		var args = new Array(5);
		
		args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
		var url = '/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer';
		var initFunc = 'initResultLayer';
		var p = {
				searchApplCd: '503'
			  , searchApplSeq: sheet1.GetCellValue(Row,"applSeq")
			  , adminYn: 'Y'
			  , authPg: 'R'
			  , searchSabun: sheet1.GetCellValue(Row,"applInSabun")
			  , searchApplSabun: sheet1.GetCellValue(Row, "sabun")
			  , searchApplYmd: sheet1.GetCellValue(Row,"applYmd")
			  , etc01: sheet1.GetCellValue(Row,"eduSeq")
			  , etc02: sheet1.GetCellValue(Row,"eduEventSeq")
			};

		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '신청서',
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {
						doAction1('Search');
					}
				}
			]
		});
		approvalMgrLayer.show();
		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
	}

	//급여일자 검색 팝업
	function payActionSearchPopup() {
		var w 		= 840;
		var h 		= 520;
		var url 	= "/PayDayPopup.do?cmd=payDayPopup";

		gPRow = "";
		pGubun = "searchPayDayPopup";

		let layerModal = new window.top.document.LayerModal({
			id : 'payDayLayer'
			, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
			, parameters : {
				runType : '00001' // 급여구분(C00001-00001.급여)
			}
			, width : 840
			, height : 520
			, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
			, trigger :[
				{
					name : 'payDayTrigger'
					, callback : function(rv){
						$("#searchPayActionCd").val(rv["payActionCd"]);
						$("#searchPayActionNm").val(rv["payActionNm"]);
						chkPayClose();
					}
				}
			]
		});
		layerModal.show();
	}

	// 급여마감여부 확인
	function chkPayClose(){
		$("#status_msg").html("");
		$("#btnPr1, #btnPr1Del, #btnPr2, #btnPr2Del").hide();
		//급여마감정보
		var data = ajaxCall( "${ctx}/LectureFeeApr.do?cmd=getLectureFeeAprPayClose", $("#sheet1Form").serialize(),false);
		if ( data != null && data.DATA != null ){

			if( data.DATA.payCloseYn == "Y" ){
				$("#status_msg").html("해당 급여일자의 급여가 마감되었습니다."); 
				return;
			}
			
			if( data.DATA.closeSt == "10001" ){ //작업전
				$("#btnPr1").show(); //작업
			}else if( data.DATA.closeSt == "10003" ){ //작업 
				$("#btnPr1Del, #btnPr2").show(); //작업취소, 마감
			}else if( data.DATA.closeSt == "10005" ){ //마감
				$("#btnPr2Del").show(); //마감취소
			}
		}
	}
	
	//복리후생작업
	function callProcPerRow(procName){

		var params = "&searchPayActionCd="+ $("#searchPayActionCd").val() +
					 "&searchBusinessPlaceCd="+
					 "&searchBenefitBizCd=300";

		var ajaxCallCmd = "call"+procName ;

		var data = ajaxCall("/WelfarePayDataMgr.do?cmd="+ajaxCallCmd,params,false);

		if(data.Result.Code == null || data.Result.Code == "OK") {
    		chkPayClose();
    		doAction1("Search");
    		alert("정상 처리되었습니다.");
    	} else {
	    	alert("처리중 오류가 발생했습니다.\n"+data.Result.Message);
    	}
		
	}
	
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<!-- 조회조건 -->
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>신청기간</th>
			<td>
				<input type="text" id="searchFrom" name="searchFrom" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>">&nbsp;~&nbsp;
				<input type="text" id="searchTo" name="searchTo" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>">
			</td>
			<th>결재상태</th>
			<td colspan="2">
				<select id="searchApplStatusCd" name="searchApplStatusCd"></select>
			</td>
		</tr>
		<tr>
			<th>소속</th>
			<td>
				<input type="text" id="searchOrgNm" name="searchOrgNm" class="text w150" style="ime-mode:active;"/>
			</td>
			<th>사번/성명</th>
			<td>
				<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;" />
			</td>
			<th>급여년월</th>
			<td>
				<input type="text" id="searchPayYm" name="searchPayYm" class="date2" value="">
			</td>
			<td>
				<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
	</div>
<%--	<table class="table mat10 outer" >--%>
<%--	<colgroup>--%>
<%--		<col width="100px"/>--%>
<%--		<col width="300px"/>--%>
<%--		<col width=""/>--%>
<%--	</colgroup>--%>
<%--	<tr>--%>
<%--		<th>급여일자</th>--%>
<%--		<td>--%>
<%--			<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="" />--%>
<%--			<input type="text" id="searchPayActionNm" name="searchPayActionNm" class="text required readonly" value="" readonly style="width:180px" />--%>
<%--			<a onclick="javascript:payActionSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>--%>
<%--		</td>--%>
<%--		<td>--%>
<%--			<span id="status_msg" style="color:red;"></span>--%>
<%--			<a href="javascript:callProcPerRow('Prc1')"		class="btn filled authA" id="btnPr1"><tit:txt mid='112940' mdef='작업'/></a>--%>
<%--			<a href="javascript:callProcPerRow('Prc1Del')"	class="btn filled authA" id="btnPr1Del"><tit:txt mid='113338' mdef='작업취소'/></a>--%>
<%--			<a href="javascript:callProcPerRow('Prc2')"		class="btn filled authA" id="btnPr2"><tit:txt mid='114369' mdef='마감'/></a>--%>
<%--			<a href="javascript:callProcPerRow('Prc2Del')"	class="btn filled authA" id="btnPr2Del"><tit:txt mid='114020' mdef='마감취소'/></a>--%>
<%--		</td>--%>
<%--	</tr>--%>
<%--	</table>--%>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">사내강사료승인</li> 
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
					<a href="javascript:doAction1('Save');" 		class="btn filled authA">저장</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
