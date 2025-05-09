<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>수습1차,2차평가PopUp</title>

<script type="text/javascript">
	var authPg	= "";
	var modal = "";
	$(function(){
		modal = window.top.document.LayerModalUtility.getModal('internApp1st2ndPopLayer');
		createIBSheet3(document.getElementById('mysheet2-wrap'), "internApp1st2ndSheet", "100%", "100%", "${ssnLocaleCd}");

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No"	,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제"	,Type:"${sDelTy}",	Hidden:1					,Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
			{Header:"상태"	,Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },

			{Header:"평가요소"	,Type:"Text",	Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"appItemNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"평가기준"	,Type:"Text",	Hidden:0,  Width:250,  Align:"Left",  ColMerge:0,   SaveName:"appItemDetail",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000 },
			{Header:"1차고과"		,Type:"Combo",	Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"app1stPointCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:10 },
			{Header:"2차고과"		,Type:"Combo",	Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"app2ndPointCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:10 },

			//{Header:"1차점수"		,Type:"AutoSum",	Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"app1stPoint",	KeyField:0,   CalcLogic:"|app1stPointCd|",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			//{Header:"2차점수"		,Type:"AutoSum",	Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"app2ndPoint",	KeyField:0,   CalcLogic:"|app2ndPointCd|",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },

			{Header:"사번"		,Type:"Text",	Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"sabun",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:13 },
			{Header:"평가시작일"	,Type:"Text",	Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"appAsYmd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 },
			{Header:"수습평가항목"	,Type:"Text",	Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"appItemSeq",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"척도구분코드"	,Type:"Text",	Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"appCodeType",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 }
		]; IBS_InitSheet(internApp1st2ndSheet, initdata); internApp1st2ndSheet.SetEditable("${editable}"); internApp1st2ndSheet.SetCountPosition(4); internApp1st2ndSheet.SetUnicodeByte(3);

		internApp1st2ndSheet.SetAutoSumPosition(1);
		//internApp1st2ndSheet.SetSumValue("sNo", "합계") ;

		$(window).smartresize(sheetResize); sheetInit();
		internApp1st2ndSheet.SetSheetHeight($(".modal_body").height());
	});

	$(function(){
		$(".close").click(function() 	{ closeCommonLayer('internApp1st2ndPopLayer'); });

		$("#app1stMemo").maxbyte(4000);
		$("#app2ndMemo").maxbyte(4000);

		if( modal != "undefined" ) {
			authPg = modal.parameters.authPg;
			$("#searchAppSeqCd").val(modal.parameters.appSeqCd);
			$("#searchEvaSabun").val(modal.parameters.sabun);
			$("#searchTraYmd").val(modal.parameters.traYmd);

			doAction1("Search");
		}

		if (authPg == "R"){
			$(".closeYn").addClass("hide");
		} else {
			if ( $("#searchAppSeqCd").val() == "1" ) {
				internApp1st2ndSheet.SetColEditable("app1stPointCd", 1);
				internApp1st2ndSheet.SetColEditable("app2ndPointCd", 0);

				$("#app1stMemo").removeClass("readonly");
				$("#app1stMemo").removeAttr("readonly");

			} else if ( $("#searchAppSeqCd").val() == "2" ) {
				internApp1st2ndSheet.SetColEditable("app1stPointCd", 0);
				internApp1st2ndSheet.SetColEditable("app2ndPointCd", 1);

				$("#app2ndMemo").removeClass("readonly");
				$("#app2ndMemo").removeAttr("readonly");
			}
		}
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var data = ajaxCall("${ctx}/InternApp1st2nd.do?cmd=getInternApp1st2ndPopMap",$("#srchFrm").serialize(),false);

			if(data != null && data.map != null) {
				$("#tdAppYmd").html(data.map.appAsYmd +" ~ "+ data.map.appAeYmd);
				$("#tdLocationNm").html(data.map.locationNm);
				$("#tdOrgNm").html(data.map.orgNm);
				$("#tdName").html(data.map.name);
				$("#tdEmpYmd").html(data.map.empYmd);
				$("#tdJikgub").html(data.map.jikgubNm);
				$("#tdJikwee").html(data.map.jikweeNm);

				$("#app1stMemo").val(data.map.app1stMemo);

				if ( $("#searchAppSeqCd").val() == "2" ) {
					$("#app2ndMemo").val(data.map.app2ndMemo);
					//$("#finalAppPoint").val(data.map.finalAppPoint);
					//$("#totalAppPoint").val(data.map.totalAppPoint);
					//$("#totalAppClassNm").val(data.map.totalAppClassNm);
				}
			}

			internApp1st2ndSheet.DoSearch( "${ctx}/InternApp1st2nd.do?cmd=getInternApp1st2ndPopList", $("#srchFrm").serialize() ); break;
		case "Save":
			if ( internApp1st2ndSheet.RowCount("U") == 0 ) {
				saveMemo(true);
			} else {
				IBS_SaveName(document.srchFrm,internApp1st2ndSheet);
				internApp1st2ndSheet.DoSave( "${ctx}/InternApp1st2nd.do?cmd=saveInternApp1st2ndPop", $("#srchFrm").serialize());
			}
			break;
		case "Clear":		internApp1st2ndSheet.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(internApp1st2ndSheet);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			internApp1st2ndSheet.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function internApp1st2ndSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}

			if ( Code != "-1" ){
				for ( var i = internApp1st2ndSheet.HeaderRows(); i <= internApp1st2ndSheet.LastRow(); i++) {
					var sComoText, sComoCode;

					if ( internApp1st2ndSheet.GetCellValue(i, "appCodeType") == "5" ) {
						sComoText = "|S|A|B|C|D"; sComoCode = "|5|4|3|2|1";
					}
					/*
					else if ( internApp1st2ndSheet.GetCellValue(i, "appCodeType") == "10" ) {
						sComoText = "|2|4|6|8|10"; sComoCode = "|2|4|6|8|10";
					} else if ( internApp1st2ndSheet.GetCellValue(i, "appCodeType") == "15" ) {
						sComoText = "|3|6|9|12|15"; sComoCode = "|3|6|9|12|15";
					}
					*/
					internApp1st2ndSheet.CellComboItem(i, "app1stPointCd", {ComboText:sComoText, ComboCode:sComoCode} );
					internApp1st2ndSheet.CellComboItem(i, "app2ndPointCd", {ComboText:sComoText, ComboCode:sComoCode} );
				}
			}

			internApp1st2ndSheet_OnChangeSum(0,0);

			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function internApp1st2ndSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			if ( Code != "-1" ) {
				/*
		        var data = ajaxCall("${ctx}/InternApp1st2nd.do?cmd=prcInternApp1st2ndPopTotal",$("#srchFrm").serialize(),false);
				if(data.Result.Code == null) {
					;
		    	} else {
			    	alert(data.Result.Message);
		    	}
				*/
				saveMemo(false);
				doAction1("Search");
			}
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 합계행에 값이 바뀌었을 때 이벤트가 발생한다.
	function internApp1st2ndSheet_OnChangeSum(Row,  Col) {
		try{
			//internApp1st2ndSheet.SetSumText("app1stPointCd", internApp1st2ndSheet.GetSumText("app1stPoint"));
			//internApp1st2ndSheet.SetSumText("app2ndPointCd", internApp1st2ndSheet.GetSumText("app2ndPoint"));
		}catch(ex){
			alert("OnChangeSum Event Error " + ex);
		}
	}

	// 의견저장
	function saveMemo(bMessage){
        var data = ajaxCall("${ctx}/InternApp1st2nd.do?cmd=saveInternApp1st2ndPopMemo",$("#srchFrm").serialize(),false);
		if( data.Result.Message != null && data.Result.Message != "") {
			if ( bMessage ) 
			alert(data.Result.Message);
		}
	}

	// 평가완료
	function saveAppYn(){
		if( internApp1st2ndSheet.RowCount() == 0 ){
			alert("평가할 항목이 없습니다. ");
			return;
	    }

		if ( 0 < internApp1st2ndSheet.RowCount("U") ) {
			alert("저장 후 평가완료 해주세요.");
			return;
		}

        var data = ajaxCall("${ctx}/InternApp1st2nd.do?cmd=saveInternApp1st2ndPopAppYn",$("#srchFrm").serialize(),false);
		if( data.Result.Message != null && data.Result.Message != "") {
			alert(data.Result.Message);
    	}

		if( data.Result.Code != null && data.Result.Code != "-1") {
			var rtnModal = window.top.document.LayerModalUtility.getModal('internApp1st2ndPopLayer');
			rtnModal.fire("internApp1st2ndPopTrigger", {"Code":"1"}).hide();
		}
	}
</script>


</head>
<body class="bodywrap">

	<div class="wrapper modal_layer">
		<div class="modal_body">
		<form id="srchFrm" name="srchFrm">
		<input id="authPg" name="authPg" type="hidden" value="" />
		<input id="searchAppSeqCd" name="searchAppSeqCd" type="hidden" value="" />
		<input id="searchEvaSabun" name="searchEvaSabun" type="hidden" value="" />
		<input id="searchTraYmd" name="searchTraYmd" type="hidden" value="" />

		<table border="0" cellpadding="0" cellspacing="0" class="default outer">
		<tr>
			<th>평정기간</th>
			<td id="tdAppYmd" colspan="9"></td>
		</tr>
		<tr>
			<th>근무지</th>
			<td id="tdLocationNm"></td>
			<th>성명</th>
			<td id="tdName"></td>
	<c:if test="${ssnJikweeUseYn == 'Y'}">
			<th>직위</th>
			<td id="tdJikwee"></td>
	</c:if>
	<c:if test="${ssnJikgubUseYn == 'Y'}">
			<th>직급</th>
			<td id="tdJikgub"></td>
	</c:if>
			<th>소속</th>
			<td id="tdOrgNm"></td>
			<th>입사일자</th>
			<td id="tdEmpYmd"></td>
		</tr>
		</table>

		<div id="mysheet2-wrap"></div>

		<table border="0" cellpadding="0" cellspacing="0" class="outer" style="width:100%;">
		<colgroup>
			<col width="50%" />
			<col width="" />
		</colgroup>
		<tr>
			<td>
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">1차의견</li>
					</ul>
				</div>
				<table class="table w100p">
					<tr>
						<td >
							<textarea id="app1stMemo" name="app1stMemo" class="w100p readonly" rows="3" readonly ></textarea>
						</td>
					</tr>
				</table>
			</td>
			<td>
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">2차의견</li>
					</ul>
				</div>
				<table class="table w100p">
					<tr>
						<td >
							<textarea id="app2ndMemo" name="app2ndMemo" class="w100p readonly" rows="3" readonly ></textarea>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr><td colspan=2>&nbsp;</td></tr>
		</table>
		<%--
		<table border="0" cellpadding="0" cellspacing="0" class="default outer">
		<colgroup>
			<col width="16%" />
			<col width="16%" />
			<col width="16%" />
			<col width="16%" />
			<col width="16%" />
			<col width="" />
		</colgroup>
		<tr>
			<th>최종점수</th>
			<td colspan=5><input type="text" id="finalAppPoint" name="finalAppPoint" class="text w100p readonly" readonly /></td>
		</tr>
		<tr>
			<th>종합점수</th>
			<td colspan=2><input type="text" id="totalAppPoint" name="totalAppPoint" class="text w100p readonly" readonly /></td>
			<th>종합등급</th>
			<td colspan=2><input type="text" id="totalAppClassNm" name="totalAppClassNm" class="text w100p readonly" readonly /></td>
		</tr>
		<tr>
			<th>종합평가등급</th>
			<th class="center">A(탁월)</th>
			<th class="center">B(우수)</th>
			<th class="center">C(보통)</th>
			<th class="center">D(부족)</th>
			<th class="center">E(매우부족)</th>
		</tr>
		<tr>
			<th>종합평가점수</th>
			<th class="center">90점 이상</th>
			<th class="center">80점 이상<br/>
				90점 미만
			</th>
			<th class="center">60점 이상<br/>
				80점 미만
			</th>
			<th class="center">40점 이상<br/>
				60점 미만
			</th>
			<th class="center">40점 미만</th>
		</tr>
		</table>
		--%>
		<table  class="default outer">
		<colgroup>
			<col width="100%" />
			<col width="" />
		</colgroup>
		<tr>
			<th>
			1. 평가등급은 5단계(A,B,C,D,E)로 구분한다. 참고) C:보통<br/>
			2. 팀장평가는 해당 부장 평가를 기초로 하여 부사장이 최종 결정한다.<br/>
			3. 팀원평가는 해당 팀장, 부장 평가를 기초로 하여 관리부장이 최종 결정한다.<br/>
			4. D등급이 4개 이상 시에는 채용이 자동 취소된다.<br/>

			</th>
			<%--
			<td colspan=5><input type="text" id="finalAppPoint" name="finalAppPoint" class="text w100p readonly" readonly /></td>
			--%>
		</tr>
		</table>

		</form>

	</div>
	<div class="modal_footer">
		<a href="javascript:saveAppYn();"			class="btn filled closeYn">평가완료</a>
		<a href="javascript:doAction1('Save');"		class="btn filled closeYn">저장</a>
		<a href="javascript:closeCommonLayer('internApp1st2ndPopLayer');" class="btn outline_gray">닫기</a>
	</div>
</div>
</body>
</html>