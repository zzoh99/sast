<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var compAprList = "";
var closeYn = "Y"
var papAdminYn = "${sessionScope.ssnPapAdminYn}";
	$(function() {
		
		//평가담당자 체크
		//var papAdminYn = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getPapAdminYn",false);
		if(papAdminYn == 'Y') {
 			$("#searchAdminYn").val("Y");
 			$('.searchTr1').show();
 			$('#sendMail').show();
		}
		else{
 			$("#searchAdminYn").val("N");
 			$("#searchAppNm").val("${ssnName}");
 			$("#searchAppNm").attr("readonly",true).addClass("readonly");
 			$('#sendMail').show();
 			$('.searchTr1').show();
 			//$("#btnSearch").hide();
		}
		
		//관리자로 들어온경우
		if(papAdminYn == "Y"){
			sheet1.SetColHidden([{Col:"chkbox", Hidden:0}, {Col:"appName", Hidden:0}])
		}
		
		// 공통코드 조회
		var list = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&sysdateYn=Y","queryId=getCompAppraisalCdList",false).codeList;
		compAprList = list;
		var CompAppraisalCdList = convCode( list, "");
		// 조회조건 값 setting
		$("#searchCompAppraisalCd").html(CompAppraisalCdList[2]);
		// 조회조건 이벤트
		$("#searchCompAppraisalCd").bind("change", function(){
			var searchCompAppraisalCd = $("#searchCompAppraisalCd").val()
			for(var i=0; i<compAprList.length; i++){
				if(searchCompAppraisalCd == compAprList[i]['code']) closeYn = compAprList[i]['closeYn'];
			}
			
			if(closeYn == "N"){
				if(papAdminYn == "Y"){
					$('#sendMail').show();
					sheet1.SetColHidden([{Col:"chkbox", Hidden:0}])
				}
			}else{
				$('#sendMail').hide();
				sheet1.SetColHidden([{Col:"chkbox", Hidden:1}])
			}
			
			doAction1("Search");
		});
		
		//차수
		var appSeqCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00004"), "전체");
		$('#searchAppSeqCd').html(appSeqCdList[2]);

		// sheet init
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			//{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",												Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"선택",												Type:"CheckBox", Hidden:1, 	Width:30,   Align:"Center", ColMerge:0,	SaveName:"chkbox",       	Cursor:"Pointer" , Sort:0, BackColor:"#ffffb9"},
			{Header:"<sht:txt mid='pop' mdef='평가'/>",					Type:"Image",	 Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"result",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='CompAppraisalCdV5' mdef='역량진단ID'/>",Type:"Text",	 Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"compAppraisalCd",	KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='appSeqCd' mdef='차수'/>",				Type:"Combo",	 Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='wEnterCdV4' mdef='W_ENTER_CD'/>",	Type:"Text",	 Hidden:1,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"wEnterCd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='wEnterNmV1' mdef='W_ENTER_NM'/>",	Type:"Text",	 Hidden:1,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"wEnterNm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"대상자",												Type:"Text",	 Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가자",												Type:"Text",	 Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appName",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",	 Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"영문약자",											Type:"Text",	 Hidden:Number("${aliasHdn}"),	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"alias",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"<sht:txt mid='grpNmV2' mdef='조직명'/>",				Type:"Text",	 Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"sabunOrgNm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",	 Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabunJikchakNm",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",				Type:"Text",	 Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabunJikgubNm",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Text",	 Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabunJikweeNm",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='completionV1' mdef='완료여부'/>",		Type:"Combo",	 Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ldsAppStatusCd",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appEnterCdV3' mdef='APP_ENTER_CD'/>",Type:"Text",	 Hidden:1,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"appEnterCd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='appSabunV3' mdef='평가자사번'/>",		Type:"Text",	 Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"appSabun",		KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"<sht:txt mid='orgCdV12' mdef='평가자조직'/>",			Type:"Text",	 Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"orgCd",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='orgCdV12' mdef='평가자조직'/>",			Type:"Text",	 Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikchakCdV3' mdef='평가자직책'/>",		Type:"Text",	 Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikchakCd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='jikchakCdV3' mdef='평가자직책'/>",		Type:"Text",	 Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='qOrgCdV1' mdef='본부코드'/>",			Type:"Text",	 Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"qOrgCd",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='qOrgNmV2' mdef='본부명'/>",			Type:"Text",	 Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"qOrgNm",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Text",	 Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikweeCd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='jikweeNmV1' mdef='직위명'/>",			Type:"Text",	 Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",				Type:"Text",	 Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikgubCd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='jikgubNmV1' mdef='직급명'/>",			Type:"Text",	 Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",				Type:"Text",	 Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='aComment' mdef='장점의견'/>",			Type:"Text",	 Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"aComment",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 },
			{Header:"<sht:txt mid='cComment' mdef='개선점의견'/>",			Type:"Text",	 Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"cComment",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='jindanCnt' mdef='JINDAN_CNT'/>",		Type:"Text",	 Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jindanCnt",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"hidden",Type:"Text", Hidden:1,SaveName:"appSeqNm"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		sheet1.SetColProperty("appSeqCd",		{ComboText:appSeqCdList[0], ComboCode:appSeqCdList[1]} );
		sheet1.SetColProperty("ldsAppStatusCd",	{ComboText:"|완료|미완료", ComboCode:"|Y|N"} );

		sheet1.SetDataLinkMouse("result", 1);
		
		//임직원공통으로 들어온경우
		if(papAdminYn != 'Y'){
			sheet1.SetColHidden([{Col:"sabunJikgubNm", Hidden:1}, {Col:"sabunJikweeNm", Hidden:1}])
		}

		$(window).smartresize(sheetResize); sheetInit();
		
		$("#searchAppNm, #searchOrgNm, #searchNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});

		$("#searchCompAppraisalCd").change();
	});

	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction){
		switch(sAction){
			case "Search":
				
				sheet1.DoSearch( "${ctx}/CompAppraisal.do?cmd=getTeamCompAppraisalList", $("#empForm").serialize() );
				break;

			case "Save":		//저장
				IBS_SaveName(document.empForm,sheet1);
				sheet1.DoSave( "${ctx}/CompAppraisal.do?cmd=saveCompAppraisal", $("#empForm").serialize() );
				break;

			case "Insert":		//입력
				var Row = sheet1.DataInsert(0);
				break;

			case "Copy":		//행복사
				var Row = sheet1.DataCopy();
				sheet1.SetCellValue(Row, "CompAppraisalCd", "");
				break;

			case "Clear":		//Clear
				sheet1.RemoveAll();
				break;

			case "Down2Excel":	//엑셀내려받기
				sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
				break;

			case "LoadExcel":	//엑셀업로드
				var params = {Mode:"HeaderMatch", WorkSheetNo:1};
				sheet1.LoadExcel(params);
				break;
	        case "SendMail":

				var chkCnt = 0;
				var rowCnt = sheet1.RowCount();
				for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
					if (sheet1.GetCellValue(i, "chkbox") == "1") {
						chkCnt++;
					}
				}
				if (chkCnt <= 0) {
					alert("선택한 평가자가 없습니다.");
					break;
				}

				var alertMsg = "선택한 평가자들에대한 알림메일전송을 진행합니다. \n계속하시겠습니까?";
				
                if (confirm(alertMsg)) {
                	IBS_SaveName(document.empForm,sheet1);
        			sheet1.DoSave( "${ctx}/CompAppraisal2.do?cmd=sendMailCompAppraisal", $("#empForm").serialize() );
                }
				break;
		}
	}

	//<!-- 조회 후 에러 메시지 -->
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg);
			}
		setCheckStatus();
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}
	
	//완료인경우 체크박스 잠금
	function setCheckStatus(){
		for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
			if (sheet1.GetCellValue(i, "ldsAppStatusCd") == "Y") {
				var info = {Type: "Text", Edit: 0};
				sheet1.InitCellProperty(i, "chkbox", info);
				sheet1.SetCellValue(i, "chkbox", '');
				sheet1.SetCellValue(i, "sStatus", 'R');
			}
		}
	}

	//<!-- 저장 후 에러 메시지 -->
	function sheet1_OnSaveEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg) ;
			}

			if ( Code != "-1" ) doAction1("Search") ;

		}catch(ex){alert("OnSaveEnd Event Error : " + ex);}
	}

	//<!--셀에서 키보드가 눌렀을때 발생하는 이벤트-->
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift){
		try{
			// Insert KEY
			if(Shift == 1 && KeyCode == 45){
				doAction1("Insert");
			}

			//Delete KEY
			if(Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row,"sStatus") == "I"){
				sheet1.SetCellValue(Row,"sStatus","D");
			}
		}catch(ex){alert("OnKeyDown Event Error : " + ex);}
	}

	// Click 시
	function sheet1_OnClick(Row, Col, Value){
		try{
		    if (Row > 0 && sheet1.ColSaveName(Col) == "result") {
		    	if(!isPopup()) {return;}
		    	gPRow = "";
		    	pGubun = "viewCompAppraisalPop";

				if(sheet1.GetCellValue(Row,"jindanCnt") == 0){
					alert("다면평가항목이 설정되지 않았습니다.\n먼저 다면평가항목을 설정해 주십시오.");
					return;
				}

				var authPg = "${authPg}";
				if ( closeYn == "Y" ) {
					authPg = "R";
				}
				else{
					authPg = "A";
				}

				var args = new Array();
				args["CompAppraisalCd"] = sheet1.GetCellValue(Row,"compAppraisalCd");
				args["wEnterNm"] = sheet1.GetCellValue(Row,"wEnterNm");
				args["wEnterCd"] = sheet1.GetCellValue(Row,"wEnterCd");
				args["empId"] = sheet1.GetCellValue(Row,"sabun");
				args["name"] = sheet1.GetCellValue(Row,"name");
				args["sabunOrgNm"] = sheet1.GetCellValue(Row,"sabunOrgNm");
				args["sabunJikweeNm"] = sheet1.GetCellValue(Row,"sabunJikweeNm");
				args["sabunJikchakNm"] = sheet1.GetCellValue(Row,"sabunJikchakNm");
				args["appEmpId"] = sheet1.GetCellValue(Row,"appSabun");
				args["appEnterCd"] = sheet1.GetCellValue(Row,"appEnterCd");
				args["ldsAppStatusCd"] = sheet1.GetCellValue(Row,"ldsAppStatusCd");
				args["appSeqCd"] = sheet1.GetCellValue(Row,"appSeqCd");

				openPopup("${ctx}/CompAppraisal.do?cmd=viewCompAppraisalPop&authPg="+ authPg,args,"960","800");

			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "viewCompAppraisalPop"){
	    	if ( rv["ldsAppStatusCd"] == "Y" ) doAction1("Search");
	    }
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="empForm" name="empForm" >
		<input type="hidden" id="searchAdminYn" name="searchAdminYn" value="" />

		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select id="searchCompAppraisalCd" name="searchCompAppraisalCd" class="box"></select>
						</td>
						<td>
							<span>평가자</span>
							<input type="text" id="searchAppNm"  name="searchAppNm" class="text w100" style="ime-mode:active"/>
						</td>
					</tr>
					<tr class="searchTr1" style="display:none">
						<td>
							<span>조직</span>
							<input type="text"   id="searchOrgNm"  name="searchOrgNm" class="text w100" style="ime-mode:active"/>
						</td>
						<td>
							<span>대상자</span>
							<input type="text"   id="searchNm"  name="searchNm" class="text w100" style="ime-mode:active"/>
						</td>
						<td>
							<span>차수</span>
							<SELECT id="searchAppSeqCd" name="searchAppSeqCd" class="box"></SELECT>
						</td>
						<td>
							<span>완료여부</span>
							<select id="searchAppStatusCd" name="searchAppStatusCd" class="box">
								<option value="">전체</option>
								<option value="N">미완료</option>
								<option value="Y">완료</option>
							</select>
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
						</td>
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
							<li id="txt" class="txt">다면평가</li>
							<li class="btn">
								<a href="javascript:doAction1('SendMail')" 		class="button" id="sendMail" style="display:none"><span>알림메일</span></a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
