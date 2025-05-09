<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>업무개선도출력</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {

		$("input[type='text']").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});

//=========================================================================================================================================

		var searchAppraisalCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdList",false).codeList, "");
		//var searchGradeCd     = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00002"), "전체");//등급(P00002)
		//var searchSChk        = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S90005"), "전체");//Y/N(S90005)

		$("#searchAppraisalCd").html(searchAppraisalCd[2]);
		//$("#searchOrgGradeCd").html(searchGradeCd[2]);
		//$("#searchSChk").html(searchSChk[2]);

//=========================================================================================================================================



		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"평가ID코드(TPAP101)",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"평가단계(P00005)",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appStepCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"선택",					Type:"DummyCheck",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"chk",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:13 },
			{Header:"사번",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"성명",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:50 },
			{Header:"평가소속",					Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"appOrgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"직위",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"직급",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"직책",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"조직코드(TORG101)",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"직위(H20030)",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"직무코드(TORG201)",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"직무명",					Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jobNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:500 },
			{Header:"직군코드(H10050)",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"직종명",					Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"직책(H20020)",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"직급(H20010)",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"평가Sheet유형((P20005)",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appSheetType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"평가방법코드(P10006)",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appMethodCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"평가포함여부",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
			{Header:"주부서여부(YN)",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mainOrgYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
			{Header:"평가제외사유(P00018)",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appExCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"비고",					Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가대상자확정여부",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appConfirmYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
			{Header:"평가그룹(TPAP133)(사용안함)",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appGroupCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"1차종료여부",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"app1stYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
			{Header:"이동평가반영비율",			Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appMRate",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"임시대상자여부",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"tmpYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
			{Header:"MBO마감여부",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mboCloseYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
			{Header:"역량마감여부",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"compCloseYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
			{Header:"MBO평가대상자여부",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mboTargetYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
			{Header:"업무개선도",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workTargetYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
			{Header:"개수",					Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"cnt",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

		$("#searchNm, #searchAppOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

						if(!checkList()) return ;
						sheet1.DoSearch( "${ctx}/AppSelfWorkTarget.do?cmd=getAppSelfWorkTargetList", $("#sendForm").serialize() );
						break;
		case "Save":
						if(!dupChk(sheet1,"appraisalCd|appStepCd|sabun|appOrgCd", true, true)){break;}
						IBS_SaveName(document.sendForm,sheet1);
						sheet1.DoSave( "${ctx}/AppSelfWorkTarget.do?cmd=saveAppSelfWorkTarget", $("#sendForm").serialize());
						break;
		case "Insert":
						var row = sheet1.DataInsert(0);
						break;
		case "Copy":
						var row = sheet1.DataCopy();
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet1);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1, ExcelFontSize:"9", ExcelRowHeight:"20"};
						sheet1.Down2Excel(param);

						break;
		case "LoadExcel":
						var params = {Mode:"HeaderMatch", WorkSheetNo:1};
						sheet1.LoadExcel(params);
						break;
		case "DownTemplate":
						sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"", ExcelFontSize:"9", ExcelRowHeight:"20"});
						break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){


				var cnt = sheet1.GetCellValue( i, "cnt" );
				if ( cnt > 0 ) {
					sheet1.SetCellEditable( i, "chk", 1);
				}else{
					sheet1.SetCellEditable( i, "chk", 0);
				}

				//sheet1.SetRangeValue
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

    function rdPopup(){


		if(!isPopup()) {return;}

		var enterCdSabun = "";
		var sRow = sheet1.FindCheckedRow("chk");

		if(sRow == ""){
			alert("<msg:txt mid='109876' mdef='대상자를 선택하세요'/>");
			return;
		}

		$(sRow.split("|")).each(function(index,value){
			if ( index == 0 ){
				enterCdSabun += "'" + sheet1.GetCellValue(value,"appraisalCd") +"_" + sheet1.GetCellValue(value,"sabun") +"_" + sheet1.GetCellValue(value,"appOrgCd") + "'";
			}else{
				enterCdSabun += ",'" + sheet1.GetCellValue(value,"appraisalCd") +"_" + sheet1.GetCellValue(value,"sabun") +"_" + sheet1.GetCellValue(value,"appOrgCd") + "'";
			}
		});

		var viewYn1 = "Y";
		var viewYn2 = "Y";
		var viewYn3 = "Y";
		var viewYn4 = "Y";
		var fullApp = "Y";

		var rdMrd = "pap/progress/appSelfWorkTarget.mrd";
		var rdTitle = "";
		var rdParam = "";

		rdTitle = "업무개선도 출력";
		rdParam  += "["+ enterCdSabun +"] "; //회사코드, 사번
		rdParam  += "["+ viewYn1 +"] "; //인사기본1
		rdParam  += "["+ viewYn2 +"] "; //인사기본2
		rdParam  += "["+ viewYn3 +"] "; //발령사항
		rdParam  += "["+ viewYn4 +"] "; //교육사항
		rdParam  += "["+ fullApp +"] "; // 전체발령체크
		rdParam  += "[${ssnEnterCd}] ";
        rdParam  += "[${ssnLocaleCd}] ";	// 10.다국어코드
        var w 		= 900;
		var h 		= 1100;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();

		args["rdTitle"] = rdTitle ;	//rd Popup제목
		args["rdMrd"] =  rdMrd;		//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = rdParam;	//rd파라매터
		args["rdParamGubun"] = "rp";//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;	//툴바여부
		args["rdZoomRatio"] = "100";//확대축소비율

		args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "Y" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF

		pGubun = "rdPopup";
		var win = openPopup(url,args,w,h);//알디출력을 위한 팝업창
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

	function getMonthEndDate(year, month) {
		var dt = new Date(year, month, 0);
		return dt.getDate();
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sendForm" id="sendForm" method="post">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<td>
				<span>평가명</span>
				<select id="searchAppraisalCd" name="searchAppraisalCd" class="box" onchange="javascript:doAction1('Search');"></select>
			</td>
			<td>
				<span>피평가자/성명</span>
				<input id="searchNm" name="searchNm" type="text" class="text" style="ime-mode:active;" />
			</td>
			<td>
				<span>평가소속</span>
				<input id="searchAppOrgNm" name="searchAppOrgNm" type="text" class="text" style="ime-mode:active;" />
			</td>
			<td>
				<a href="javascript:doAction1('Search');" class="button">조회</a>
			</td>
		</tr>
		</table>
		</div>
	</div>
</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">업무개선도출력</li>
			<li class="btn">
				<a href="javascript:rdPopup();" 				class="button authA">출력</a>
				<a href="javascript:doAction1('Down2Excel');" 	class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "kr"); </script>
</div>
</body>
</html>
