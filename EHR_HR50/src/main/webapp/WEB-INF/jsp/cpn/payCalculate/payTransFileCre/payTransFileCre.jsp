<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>은행이체자료다운</title>
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

		$("#searchPayYm").datepicker2({ymonly:true});
		$("#searchPaymentYmd").datepicker2();

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='payNmV1' mdef='급여명'/>",     	Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:1,   SaveName:"payActionNm",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='payActionCdV4' mdef='급여코드'/>",     	Type:"Text",      Hidden:1,  Width:180,  Align:"Left",    ColMerge:1,   SaveName:"payActionCd",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:01,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='payYmV2' mdef='급여년월'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"payYm",			KeyField:0,	Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:7 },
			{Header:"<sht:txt mid='incomeAnnualPaymentYmd' mdef='지급일자'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"paymentYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"이체건수",		Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"cnt",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"이체금액",		Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"mon",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",			Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata2.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='bankCd_V4296' mdef='은행코드'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"bankCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header:"<sht:txt mid='bankCd' mdef='은행명'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"bankNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header:"<sht:txt mid='accountNo' mdef='계좌번호'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"accountNo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header:"이체금액",		Type:"AutoSum",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"mon",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");

		$("#searchPayYm,#searchPaymentYmd").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#searchAccountNo").bind("change",function(event){
			if($("#searchAccountNo").is(":checked")){
				$("#searchAccountNo").val("Y");
			}else{
				$("#searchAccountNo").val("N");
			}
			doAction2("Search");
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			
						$("#payYm").val("");
						$("#paymentYmd").val("");
						$("#payActionCd").val("");
						sheet2.RemoveAll();
						sheet1.DoSearch( "${ctx}/PayTransFileCre.do?cmd=getPayTransFileCreList", $("#sendForm").serialize() );
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet1);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
						sheet1.Down2Excel(param);
						break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
						var searchAccountNo = $("#searchAccountNo").is(":checked")?"&searchAccountNo=Y":"&searchAccountNo=N"
					    var searchPayActionCd = $("#payActionCd").val();

						sheet2.DoSearch( "${ctx}/PayTransFileCre.do?cmd=getPayTransFileCreListDetail","&searchPayActionCd="+searchPayActionCd+searchAccountNo);
						sheet2.SetCellValue(sheet2.LastRow(), 3, "합계 : ");
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet2);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
						sheet2.Down2Excel(param);
						break;
/* 		case "fileCreate":

						var payYm = $("#payYm").val();
						var paymentYmd = $("#paymentYmd").val();

						if ( payYm == "" || paymentYmd == "" ){
							alert("선택된 내용이없습니다.");
							break;
						}

						var cnt = 0;

						for(var r = sheet2.HeaderRows(); r<sheet2.LastRow()+sheet2.HeaderRows()-1; r++){

							if ( sheet2.GetCellValue(r, "bankCd") == "" ){
								cnt++
							}
							if ( sheet2.GetCellValue(r, "accountNo")== "" ){
								cnt++
							}
						}

						if ( cnt > 0 ){
// 							if (!confirm("은행코드 또는 계좌번호가 없는 사람이 존재합니다. \r\n다운로드 하시겠습니까?")) {
//								break;
//							}
							alert("은행코드 또는 계좌번호 정보 누락자가 존재합니다.\r\n확인하시기 바랍니다.");
							break;
						}

						$("#payYmFile").val(payYm);
						$("#paymentYmdFile").val(paymentYmd);

						$("#pfrm").submit();
						break; */
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

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			if(OldRow != NewRow){
				$("#payYm").val(sheet1.GetCellValue(NewRow,"payYm"));
				$("#paymentYmd").val(sheet1.GetCellValue(NewRow,"paymentYmd"));
				$("#payActionCd").val(sheet1.GetCellValue(NewRow,"payActionCd"));
				doAction2("Search");
			}
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
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

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{'+ returnValue+'}');
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sendForm" id="sendForm" method="post">
<input id="payYm" name="payYm" type="hidden" value="" />
<input id="paymentYmd" name="paymentYmd" type="hidden" value="" />
<input id="payActionCd" name="payActionCd" type="hidden" />
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='113327' mdef='급여년월'/></th>
			<td>
				<input id="searchPayYm" name="searchPayYm" type="text" size="10" class="date2" value="" />
			</td>
			<th><tit:txt mid='112700' mdef='지급일자'/></th>
			<td>
				<input id="searchPaymentYmd" name="searchPaymentYmd" type="text" size="10" class="date2" value="" />
			</td>
			<td>
				<a href="javascript:doAction1('Search');" class="button"><tit:txt mid='104081' mdef='조회'/></a>
			</td>
		</tr>
		</table>
		</div>
	</div>
</form>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='bankTransferData' mdef='은행이체자료'/></li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
			</li>
		</ul>
		</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "200px", "${ssnLocaleCd}"); </script>
	</div>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='112871' mdef='상세내용'/></li>
			<li class="btn">
				<input type="checkbox" class="checkbox" style="vertical-align:middle;" id="searchAccountNo" name="searchAccountNo" value="N" /> 은행코드 또는 계좌번호누락자 조회
				<!-- <a href="javascript:doAction2('fileCreate')" 	class="basic authR">이체파일다운로드</a> -->
				<a href="javascript:doAction2('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>

</div>
<!-- <iframe name="hiddenIframe" id="hiddenIframe" style="display:none;"></iframe>
<form id="pfrm" name="pfrm" target="hiddenIframe" action="/PayTransFileCre.do?cmd=fileCreate" method="post" >
<input id="payYmFile" name="payYmFile" type="hidden" value="" />
<input id="paymentYmdFile" name="paymentYmdFile" type="hidden" value="" />
</form> -->
</body>
</html>
