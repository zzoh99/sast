<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head><title>연차촉진관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		
		$("#searchSYmd").datepicker2({startdate:"searchEYmd"});
		$("#searchEYmd").datepicker2({enddate:"searchSYmd"});

		
		$("#searchSabunName, #searchOrgNm").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});

		$("#searchSort, #searchPlanCd,#searchMailYn1, #searchAppYn1,#searchMailYn2, #searchTargetYn, #searchDocYn").on("change", function(e) {
			doAction1("Search");
		})
		
		init_sheet();

		doAction1("Search");
	});
	
	function init_sheet(){ 
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly,FrozenCol:5,FrozenColRight:1};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		
		initdata1.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"삭제|삭제",			Type:"${sDelTy}", Hidden:1,						Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",			Type:"${sSttTy}", Hidden:1,						Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			//신청자정보
			{Header:"사번|사번",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			Edit:0},
			{Header:"성명|성명",			Type:"Text",   	Hidden:0, Width:80,		Align:"Center", ColMerge:0,  SaveName:"name", 			Edit:0},
			{Header:"부서|부서",			Type:"Text",   	Hidden:0, Width:120, 	Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			Edit:0},
			{Header:"직책|직책",			Type:"Text",   	Hidden:1, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikchakNm", 		Edit:0},
			{Header:"직급|직급",			Type:"Text",   	Hidden:Number("${jgHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikgubNm", 		Edit:0},
			{Header:"재직상태|재직상태",		Type:"Combo",   Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"statusCd", 		Edit:0},
			{Header:"입사일자|입사일자", 		Type:"Date",    	Hidden:0,	 Width:80,  Align:"Center", ColMerge:0, SaveName:"empYmd", 		Format:"Ymd", 	Edit:0 },
			{Header:"연차기산일|연차기산일", 		Type:"Date",    	Hidden:0,	 Width:80,  Align:"Center", ColMerge:0, SaveName:"YearYmd", 	Format:"Ymd", 	Edit:0 },
			
			{Header:"사용시작일|사용시작일", 		Type:"Date",    	Hidden:0,	 Width:80,  Align:"Center", ColMerge:0, SaveName:"useSYmd", 	Format:"Ymd", 	Edit:0 },
			{Header:"사용종료일|사용종료일", 		Type:"Date",    	Hidden:0,	 Width:80,  Align:"Center", ColMerge:0, SaveName:"useEYmd", 	Format:"Ymd", 	Edit:0 },
			{Header:"사용가능일수|사용가능일수",	Type:"Float",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"useCnt",		Format:"Float",	PointCount:1,	Edit:0},
			{Header:"사용일수|사용일수",			Type:"Float",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"usedCnt",		Format:"Float",	PointCount:1,	Edit:0},
			{Header:"잔여일수|잔여일수",			Type:"Float",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"restCnt",		Format:"Float",	PointCount:1,	Edit:0},

			{Header:"신청처리중\n일수|신청처리중\n일수",
				                            Type:"Float",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"appCnt",		Format:"Float",	PointCount:1,	Edit:0},
            {Header:"미신청\n일수|미신청\n일수",  Type:"Float",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"appRestCnt",	Format:"Float",	PointCount:1,	Edit:0},

			{Header:"1년미만\n여부|1년미만\n여부",Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"oneyearUnderYn",	Edit:0},

			{Header:"계획구분|계획구분",			Type:"Combo",   Hidden:0, Width:100, 	Align:"Center", ColMerge:0, SaveName:"planCd", 		Edit:0},
			
			
			{Header:"1차 촉진|기준일자", 		Type:"Date",    Hidden:0, Width:80,     Align:"Center", ColMerge:0, SaveName:"stdYmd1", 	Format:"Ymd", 	Edit:0 },
			{Header:"1차 촉진|메일\n발송",		Type:"Image",   Hidden:0, Width:45, 	Align:"Center", ColMerge:0, SaveName:"mailYn1", 	Edit:0},
			{Header:"1차 촉진|세부\n내역", 		Type:"Image",  	Hidden:0, Width:45,  	Align:"Center", ColMerge:0, SaveName:"detail1",     Edit:0 },
			{Header:"1차 촉진|신청일",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0, SaveName:"applYmd1", 	Format:"Ymd", Edit:0},
			{Header:"1차 촉진|신청상태",			Type:"Combo",   Hidden:0, Width:80, 	Align:"Center", ColMerge:0, SaveName:"applStatusCd1", 	Format:"", Edit:0},
			{Header:"1차 촉진|동의일시",			Type:"Text",   	Hidden:0, Width:120, 	Align:"Center", ColMerge:0, SaveName:"agreeTime1", 	Format:"", Edit:0},
			{Header:"1차 촉진|계획양식\n생성여부",	Type:"Image",	Hidden:0, Width:60,		Align:"Center",	ColMerge:0,	SaveName:"docYn1",		Edit:0},
			{Header:"1차 촉진|계획양식",			Type:"Html",	Hidden:0, Width:60,		Align:"Center",	ColMerge:0,	SaveName:"docBtn1",		Edit:0},
			{Header:"1차 촉진|촉진메일",			Type:"Html",	Hidden:0, Width:70,		Align:"Center",	ColMerge:0,	SaveName:"mailBtn1",	Edit:0},
			{Header:"1차 촉진|대상",			Type:"CheckBox",Hidden:1, Width:60,		Align:"Center",	ColMerge:0,	SaveName:"docChk1",		Edit:0},

			{Header:"2차 촉진|기준일자", 		Type:"Date",    Hidden:0, Width:80,     Align:"Center", ColMerge:0, SaveName:"stdYmd2", 	Format:"Ymd", 	Edit:0 },
			{Header:"2차 촉진|메일\n발송",		Type:"Image",   Hidden:0, Width:45, 	Align:"Center", ColMerge:0, SaveName:"mailYn2", 	Edit:0},
			{Header:"2차 촉진|메일양식\n생성여부",	Type:"Image",	Hidden:0, Width:60,		Align:"Center",	ColMerge:0,	SaveName:"docYn2",		Edit:0},
			{Header:"2차 촉진|메일양식",			Type:"Html",	Hidden:0, Width:60,		Align:"Center",	ColMerge:0,	SaveName:"docBtn2",		Edit:0},
			{Header:"2차 촉진|촉진메일",			Type:"Html",	Hidden:0, Width:70,		Align:"Center",	ColMerge:0,	SaveName:"mailBtn2",	Edit:0},
			{Header:"2차 촉진|대상",			Type:"CheckBox",Hidden:1, Width:60,		Align:"Center",	ColMerge:0,	SaveName:"docChk2",		Edit:0},
			
			//Hidden
  			{Header:"Hidden",	Type:"Text", Hidden:1, SaveName:"mailId"},
  			{Header:"Hidden",	Type:"Text", Hidden:1, SaveName:"applInSabun1"},
  			{Header:"Hidden",	Type:"Text", Hidden:1, SaveName:"applSeq1"},
  			
  			{Header:"\n선택|\n선택",			Type:"DummyCheck", Hidden:0, Width:50,  Align:"Center", ColMerge:0, SaveName:"chk", 		UpdateEdit:1, InsertEdit:0,	TrueValue:"Y",	FalseValue:"N" },
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");sheet1.SetDataLinkMouse("detail", 1);sheet1.SetDataLinkMouse("detail2", 1);
		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_o.png");
		sheet1.SetImageList(2,"${ctx}/common/images/icon/icon_x.png");

 		//공통코드 한번에 조회
 		var grpCds = "T56120,H10010,R10010";
 		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "전체");
 		sheet1.SetColProperty("planCd",  	{ComboText:codeLists["T56120"][0], ComboCode:codeLists["T56120"][1]} ); //구분
 		sheet1.SetColProperty("statusCd",  	{ComboText:codeLists["H10010"][0], ComboCode:codeLists["H10010"][1]} ); //재직상태
 		sheet1.SetColProperty("applStatusCd1", {ComboText:codeLists["R10010"][0], ComboCode:codeLists["R10010"][1]} ); //신청상태
 		sheet1.SetColProperty("applStatusCd2", {ComboText:codeLists["R10010"][0], ComboCode:codeLists["R10010"][1]} ); //신청상태
		$("#searchPlanCd").html(codeLists["T56120"][2]);		

		$(window).smartresize(sheetResize); sheetInit();
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			//var sXml = sheet1.GetSearchData("${ctx}/GetDataList.do?cmd=getAnnualPlanAgrMgrList", $("#sheet1Form").serialize() );
			//sheet1.LoadSearchData(sXml );
			
			sheet1.DoSearch( "${ctx}/AnnualPlanAgrMgr.do?cmd=getAnnualPlanAgrMgrList", $("#sheet1Form").serialize());
			break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/AnnualPlanAgrMgr.do?cmd=saveAnnualPlanAgrMgr", $("#sheet1Form").serialize(), "docChk"+$("#planSeq").val(), 0);
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); 
			break;
		}
	}

	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
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
				alert("처리되었습니다.");
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
			
		    if( sheet1.ColSaveName(Col) == "detail1" && sheet1.GetCellValue(Row, "applSeq1") !=""  ) {
		    	showApplPopup(Row,"1");
		    	
		    }else if( ( sheet1.ColSaveName(Col) == "docBtn1" ||  sheet1.ColSaveName(Col) == "docBtn2" ) && Value !="" ) {
		    	var seq = 1;
		    	if( sheet1.ColSaveName(Col) == "docBtn2" ) seq = 2;
		    		
		    	$("#planSeq").val(seq);
		    	
		    	//sheet1.CheckAll("docChk1", 0); sheet1.CheckAll("docChk2", 0);
		    	//sheet1.SetCellValue(Row, "docChk"+seq, 1); 
		    	var str = "생성";
		    	if( Value.indexOf("삭제") > -1 ){
		    		sheet1.SetCellValue(Row, "sStatus", "D");
		    		str = "삭제";
		    	}else{
		    		sheet1.SetCellValue(Row, "sStatus", "U");
		    	}

				IBS_SaveName(document.sheet1Form, sheet1);
		    	var param = $("#sheet1Form").serialize()+"&"+sheet1.RowSaveStr(Row); 

			    if( !confirm(str+"하시겠습니까?") ) return;

		    	progressBar(true) ;
				setTimeout(
					function(){
						var data = ajaxCall("${ctx}/AnnualPlanAgrMgr.do?cmd=saveAnnualPlanAgrMgr", param,false);
				    	if(data.Result.Code > -1) {
				    		alert(str+"되었습니다.");
					    	progressBar(false) ;
				    		doAction1("Search");
				    	} else if(data.Result.Code > -1) {
				    		alert(str+"된 내용이 없습니다.");
					    	progressBar(false) ;
				    	} else {
					    	alert("처리중 오류가 발생했습니다.\n"+data.Result.Message);
					    	progressBar(false) ;
				    	}
					}
				, 100);
			    
		    	
		    	
		    }else if( ( sheet1.ColSaveName(Col) == "mailBtn1" ||  sheet1.ColSaveName(Col) == "mailBtn2" ) && Value !="" ) {
		    	var seq = 1;
		    	if( sheet1.ColSaveName(Col) == "mailBtn2" ) seq = 2;
		    	
		    	if( !confirm(seq+"차 촉진 메일을 발송 하시겠습니까?") ) return;
		    	
		    	var param = "planSeq="+seq
		    	          + "&sabun="+sheet1.GetCellValue(Row, "sabun")
  	          			  + "&planCd="+sheet1.GetCellValue(Row, "planCd");

		    	progressBar(true) ;
				setTimeout(
					function(){
						var data = ajaxCall("${ctx}/AnnualPlanAgrMgr.do?cmd=prcAnnualPlanAgrMgrMail", param,false);
				    	if(data.Result.Code == null) {
				    		alert("정상적으로 처리되었습니다.");
					    	progressBar(false) ;
				    		doAction1("Search");
				    	} else {
					    	alert("처리중 오류가 발생했습니다.\n"+data.Result.Message);
					    	progressBar(false) ;
				    	}
					}
				, 100);
		    	
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	//세부내역 팝업
	function showApplPopup(Row, seq) {
		
		var args = new Array(5);
		var url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
		var initFunc = 'initResultLayer';
		var p = {
				searchApplCd: '27'
			  , searchApplSeq: sheet1.GetCellValue(Row,"applSeq"+seq)
			  , adminYn: 'Y'
			  , authPg: 'R'
			  , searchSabun: sheet1.GetCellValue(Row,"applInSabun"+seq)
			  , searchApplSabun: sheet1.GetCellValue(Row, "sabun")
			  , searchApplYmd: sheet1.GetCellValue(Row,"applYmd"+seq) 
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

	/**
	* 메일발송
	*/
	function sendMail(){
		var frm = document.form;
		var sabuns = "";
		
		var sRow = sheet1.FindCheckedRow("chk");
		
		if( sRow == "" ){
			alert("대상를 선택 해주세요.");
			return;
		}


		var names = "";
		var mailIds = "";
		var arrRow = sRow.split("|");
		for(var i=0; i<arrRow.length ; i++){
			
			names    += sheet1.GetCellValue(arrRow[i], "name") + "|";
			mailIds  += sheet1.GetCellValue(arrRow[i], "mailId") + "|";
		}
		names    = names.substr(0, names.length - 1);
		mailIds  = mailIds.substr(0, mailIds.length - 1);

		fnSendMailPop(names, mailIds);
		
		return;
	}

	/**
	 * Mail 발송 팝업 창 호출
	 */
	function fnSendMailPop(names, mailIds){
		if(!isPopup()) {return;}

		var args 	= new Array();

		args["saveType"] = "insert";
		args["names"] = names;
		args["mailIds"] = mailIds;
		args["sender"] = "${ssnName}";
		args["bizCd"] = "99999"; 
		args["authPg"] = "${authPg}";

		var url = "${ctx}/SendPopup.do?cmd=viewMailMgrPopup";
		var rv = openPopup(url, args, "900","700");
	}
	
	

	//팝업 리턴
	function getReturnValue(returnValue) {
		doAction1("Search");
	}
	

</script>
</head>
<body class="bodywrap">
<div class="wrapper">	
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="planSeq" name="planSeq" />
	<!-- 조회조건 -->
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>기준일자</th>
			<td colspan="2">
				<input type="text" id="searchSYmd" name="searchSYmd" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>"/> &nbsp;~&nbsp; 
				<input type="text" id="searchEYmd" name="searchEYmd" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),30)%>"/>
			</td>
			<th>계획구분</th>
			<td>
				<select id="searchPlanCd" name="searchPlanCd"></select>
			</td>
			<th>미신청일수</th>
			<td>
				<select id="searchTargetYn" name="searchTargetYn">
					<option value="">전체</option>
					<option value="Y" selected>1개이상</option>
				</select>
			</td>
			<th>연차계획 신청여부</th>
			<td>
				<select id="searchAppYn1" name="searchAppYn1">
					<option value="">전체</option>
					<option value="Y">Y</option>
					<option value="N">N</option>
				</select>
			</td>
			<th>메일양식생성</th>
			<td>
				<select id="searchDocYn" name="searchDocYn">
					<option value="">전체</option>
					<option value="Y">Y</option>
					<option value="N">N</option>
				</select>
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
			<th>정렬</th>
			<td>
				<select id="searchSort" name="searchSort">
					<option value="A">직제</option> 
					<option value="B">기준일자</option>
				</select>
			</td>
			<th>1차 메일발송</th>
			<td>
				<select id="searchMailYn1" name="searchMailYn1">
					<option value="">전체</option>
					<option value="Y">Y</option>
					<option value="N">N</option>
				</select>
			</td>
			<th>2차 메일발송</th>
			<td>
				<select id="searchMailYn2" name="searchMailYn2">
					<option value="">전체</option>
					<option value="Y">Y</option>
					<option value="N">N</option>
				</select>
			</td>
			<td>
				<a href="javascript:doAction1('Search')" class="button">조회</a>
			</td>
		</tr>
		<tr>
		</tr>
		</table>
	</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">연차촉진관리</li> 
				<li class="btn">
					<a href="javascript:sendMail();" 			class="basic pink authA">메일발송</a>
					<a href="javascript:doAction1('Down2Excel');" 	class="basic authR">다운로드</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>
