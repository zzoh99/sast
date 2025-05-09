<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>급여일자조회</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var p = eval("${popUpStatus}");

	$(function() {
//====================================================================================================================================================================================

	var searchSalDayPopupPayCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getSalDayPopupPayCdList" + "&" + $("#sendForm").serialize(),false).codeList,"<tit:txt mid='103895' mdef='전체'/>" );
	$("#searchPayCd").html(searchSalDayPopupPayCdList[2]);

//====================================================================================================================================================================================

		$("input[type='text']").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});

		$(".close").click(function() {
			p.self.close();
		});

		$("#searchMonthFrom").datepicker2({ymonly:true});
		$("#searchMonthTo").datepicker2({ymonly:true});

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"급여계산코드(TCPN201)",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"payActionCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='payActionNm' mdef='급여계산명'/>",				Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"payActionNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='payYmV3' mdef='대상년월'/>",				Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"payYm",		KeyField:0,	Format:"Ym",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:7 },
			{Header:"<sht:txt mid='payCd' mdef='급여구분'/>",				Type:"Combo",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"payCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='runType' mdef='RUN_TYPE'/>",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"runType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
			{Header:"<sht:txt mid='incomeAnnualPaymentYmd' mdef='지급일자'/>",				Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"paymentYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='closeYnV3' mdef='마감\n여부'/>",				Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"closeYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
			{Header:"<sht:txt mid='payNm' mdef='급여구분코드명'/>",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"payNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='incomeAnnualPaymentYmd' mdef='지급일자'/>",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"paymentYmdHyphen",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },

			{Header:"<sht:txt mid='ordSymd' mdef='발령기준시작일'/>",			Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordSymd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='ordEymd' mdef='발령기준종료일'/>",			Type:"Date",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordEymd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",					Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"bigo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 },
			{Header:"<sht:txt mid='day' mdef='지급일'/>",					Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"day",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 }

		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetColProperty("payCd", {ComboText:"|"+searchSalDayPopupPayCdList[0], ComboCode:"|"+searchSalDayPopupPayCdList[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

		$("#searchMonthFrom, #searchMonthTo").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#searchPayCd").bind("change",function(event){
			doAction1("Search");
		});

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
						if(!checkList()) return ;
						sheet1.RemoveAll();

						var searchType = $("#searchType").val();

						if (searchType == "A") {
							// 개인별급여세부내역(관리자)용 쿼리호출
							sheet1.DoSearch( "${ctx}/SalDayPopup.do?cmd=getSalDayAdminPopupList", $("#sendForm").serialize() );
						} else if (searchType == "B") {
							// 개인별급여세부내역용 쿼리호출
							sheet1.DoSearch( "${ctx}/SalDayPopup.do?cmd=getSalDayUserPopupList", $("#sendForm").serialize() );
						} else {
							sheet1.DoSearch( "${ctx}/SalDayPopup.do?cmd=getSalDayPopupList", $("#sendForm").serialize() );
						}
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

	function sheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

		var rv = new Array();
		rv["payActionCd"] 		= sheet1.GetCellValue(Row, "payActionCd");
		rv["payActionNm"]		= sheet1.GetCellValue(Row, "payActionNm");
		rv["payCd"] 			= sheet1.GetCellValue(Row, "payCd");
		rv["payYm"] 			= sheet1.GetCellValue(Row, "payYm");
		rv["paymentYmd"] 		= sheet1.GetCellValue(Row, "paymentYmd");
		rv["paymentYmdHyphen"] 	= sheet1.GetCellValue(Row, "paymentYmdHyphen");
		rv["payNm"] 			= sheet1.GetCellValue(Row, "payNm");
		rv["ordSymd"] 			= sheet1.GetCellValue(Row, "ordSymd");
		rv["ordEymd"] 			= sheet1.GetCellValue(Row, "ordEymd");
		rv["closeYn"] 			= sheet1.GetCellValue(Row, "closeYn");

		p.popReturnValue(rv);
		p.window.close();
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

	}


//===========================================================================================================================================복사해서 부모창에서사용start

// 1번 2번 3번 4번 수정 후 사용  5번은 sheet 사용할경우 salDaySHEETPopup 안쓰면 삭제

	/* 포함될 payCd, runType 또는 포함되지않는 payCd, runType  start */
	/* 형식
		ex ) '','','','',
	*/
//1. 수정 start
	var payCdIn       = "";
	var payCdNotIn    = "";
	var runTypeIn     = "00001,00002,ETC,J0001,R0001";
	var runTypeNotIn  = "";
//1. 수정 end
	/* 포함될 payCd, runType 또는 포함되지않는 payCd, runType  end */

	function searchDoAction(){
//2. 수정 start
		/* 업무 doAction Search 적는부분 start */
		doAction1("SearchBasic");
		doAction1("SearchPeople");
		doAction1("Search");
		/* 업무 doAction 적는부분 end */
//2. 수정 end
	}

	function getSalDayLastestPaymentInfoMap(){

		var sendParam =             "&payCdIn="      + payCdIn      ;
			sendParam = sendParam + "&payCdNotIn="   + payCdNotIn   ;
			sendParam = sendParam + "&runTypeIn="    + runTypeIn    ;
			sendParam = sendParam + "&runTypeNotIn=" + runTypeNotIn ;

		var paymentInfo = ajaxCall("${ctx}/SalDayPopup.do?cmd=getSalDayLastestPaymentInfoMap", sendParam, false);

		if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA != "undefined") {

			/* 받아쓸 값 start*/
			/* payAction, payActionNm, payCd, payNm, paymentYmd 5개 가능 필요없는것 삭제*/
//3. 수정 start
			$("#payActionCd"	).val(paymentInfo.DATA.payActionCd		);
			$("#payActionNm"	).val(paymentInfo.DATA.payActionNm		);
			$("#payCd"			).val(paymentInfo.DATA.payCd			);
			$("#payNm"			).val(paymentInfo.DATA.payNm			);
			$("#paymentYmd"		).val(paymentInfo.DATA.paymentYmd		);
//3. 수정 end
			/* 받아쓸 값 end*/

			if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
				searchDoAction();
			}
		} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
			/* 조회에 실패하였을경우 message 를 보여줌 */
			alert(paymentInfo.Message);
		}
	}

	function salDayPopup(){

		if(!isPopup()) {return;}
		gPRow = "";
		pGubun = "SalDayPopup";
		var w 		= 850;
		var h 		= 520;
		var url 	= "/SalDayPopup.do?cmd=viewSalDayPopup";
		var args 	= new Array();

		var sendParam =             "&payCdIn="      + payCdIn      ;
			sendParam = sendParam + "&payCdNotIn="   + payCdNotIn   ;
			sendParam = sendParam + "&runTypeIn="    + runTypeIn    ;
			sendParam = sendParam + "&runTypeNotIn=" + runTypeNotIn ;

		openPopup(url + sendParam + "&authPg=R", args, w, h, function (rv){

			/* 받아쓸 값 start*/
			/* payAction, payActionNm, payCd, payNm, paymentYmd, payYm, paymentYmdHyphen, ordSymd, ordEymd, closeYn 가능 필요없는것 삭제*/
//4. 수정 start
			$("#payActionCd"		).val(rv["payActionCd"]		);
			$("#payActionNm"		).val(rv["payActionNm"]		);
			$("#payCd"				).val(rv["payCd"]			);
			$("#payNm"				).val(rv["payNm"]			);
			$("#paymentYmd"			).val(rv["paymentYmd"]		);
			$("#payYm"				).val(rv["payYm"]			);
			$("#paymentYmdHyphen"	).val(rv["paymentYmdHyphen"]);
			$("#ordSymd"			).val(rv["ordSymd"]			);
			$("#ordEymd"			).val(rv["ordEymd"]			);
			$("#closeYn"			).val(rv["closeYn"]			);
//4. 수정 end

			if (rv["payActionCd"] != null && rv["payActionCd"] != "") {
				searchDoAction();
			}
		});
	}

	function salDaySHEETPopup(Row){

		if(!isPopup()) {return;}
		gPRow = Row;
		pGubun = "salDaySHEETPopup";
		var w 		= 850;
		var h 		= 520;
		var url 	= "/SalDayPopup.do?cmd=viewSalDayPopup";
		var args 	= new Array();

		var sendParam =             "&payCdIn="      + payCdIn      ;
			sendParam = sendParam + "&payCdNotIn="   + payCdNotIn   ;
			sendParam = sendParam + "&runTypeIn="    + runTypeIn    ;
			sendParam = sendParam + "&runTypeNotIn=" + runTypeNotIn ;

		openPopup(url + sendParam + "&authPg=R", args, w, h, function (rv){

			/* 받아쓸 값 start*/
			/* payAction, payActionNm, payCd, payNm, paymentYmd, payYm, paymentYmdHyphen, ordSymd, ordEymd, closeYn 가능 필요없는것 삭제*/
//5. 수정 start
			sheet1.SetCellValue( Row, "payActionCd", 		rv["payActionCd"]		);
			sheet1.SetCellValue( Row, "payActionNm", 		rv["payActionNm"]		);
			sheet1.SetCellValue( Row, "payCd", 				rv["payCd"]				);
			sheet1.SetCellValue( Row, "payNm", 				rv["payNm"]				);
			sheet1.SetCellValue( Row, "paymentYmd", 		rv["paymentYmd"]		);
			sheet1.SetCellValue( Row, "payYm", 				rv["payYm"]				);
			sheet1.SetCellValue( Row, "paymentYmdHyphen", 	rv["paymentYmdHyphen"]	);
			sheet1.SetCellValue( Row, "ordSymd", 			rv["ordSymd"]			);
			sheet1.SetCellValue( Row, "ordEymd", 			rv["ordEymd"]			);
			sheet1.SetCellValue( Row, "closeYn", 			rv["closeYn"]			);
//5. 수정 end
		});
	}
//===========================================================================================================================================복사해서 부모창에서사용end
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='payDayPop' mdef='급여일자 조회'/></li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
<form name="sendForm" id="sendForm" method="post">

<input type="hidden" id="payCdIn"      name="payCdIn"      value="${payCdIn}"      />
<input type="hidden" id="payCdNotIn"   name="payCdNotIn"   value="${payCdNotIn}"   />
<input type="hidden" id="runTypeIn"    name="runTypeIn"    value="${runTypeIn}"    />
<input type="hidden" id="runTypeNotIn" name="runTypeNotIn" value="${runTypeNotIn}" />
<input type="hidden" id="searchType"   name="searchType"   value="${searchType}" />

		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th>급여구분  </th>
				<td>  <select id="searchPayCd" name="searchPayCd"> </select></td>
				<th>대상년월  </th>
				<td> 
					<input type="text" id="searchMonthFrom" name ="searchMonthFrom" class="date2" value="<%= DateUtil.addMonths(DateUtil.getCurrentTime("yyyy-MM-dd"),-11)%>"/>
					~
					<input type="text" id="searchMonthTo" name ="searchMonthTo" class="date2" value="<%=DateUtil.addMonths(DateUtil.getCurrentTime("yyyy-MM-dd"),+1)%>"/>
				</td>
				<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/> </td>
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
							<li class="txt">급여일자조회</li>
							<li class="btn">
<!-- 								<a href="javascript:doAction1('Insert');" 			class="basic authA"><tit:txt mid='104267' mdef='입력'/></a>
								<a href="javascript:doAction1('Copy');" 			class="basic authA"><tit:txt mid='104335' mdef='복사'/></a>
								<a href="javascript:doAction1('Save');" 			class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
								<a href="javascript:doAction1('Down2Excel');" 		class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
								<a href="javascript:doAction1('LoadExcel');" 		class="basic authA"><tit:txt mid='104242' mdef='업로드'/></a>
								<a href="javascript:doAction1('DownTemplate');" 	class="basic authA"><tit:txt mid='113684' mdef='양식다운로드'/></a> -->
							</li>
						</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>
		<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>
