<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid="202005150000134" mdef="수당지급신청 세부내역" /></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>

<script type="text/javascript">
	var searchApplSeq = "${searchApplSeq}";
	var searchApplSabun = "${searchApplSabun}"; //신청대상자사번
	var searchSabun = "${searchSabun}"; // 신청자사번
	var searchApplYmd = "${searchApplYmd}";
	var adminYn = "${adminYn}";
	var authPg = "${authPg}";
	var applStatusCd = parent.$("#applStatusCd").val(); //신청서상태
	var reqUseType ="";

	var chooseGntAllowYn = null;

	var iframeHeight = 400;  /* 신청상세 iframe 높이 */

	$(function() {
		/* 신청상세 iframe 높이 */
		parent.iframeOnLoad(iframeHeight+"px");
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);

		// 세션 사번
		$("#searchSabun").val(searchSabun);
		$("#applYmd").val(searchApplYmd);



		// 2020.02.05 임시저장이 아닌경우 비활성화로 변경
		if(applStatusCd != "11" && applStatusCd != null && applStatusCd != "") {
			$("#payYm").attr("readonly", true).addClass("transparent");
		} else {
			$("#payYm").datepicker2({ymonly:true});
		}

		/*근태신청 상세 데이타*/
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:0,ColResize:0,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No' />",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제' />", 			Type:"${sDelTy}",	Hidden:0,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태' />", 			Type:"${sSttTy}",	Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"<sht:txt mid='name' mdef='성명' />",				Type:"PopupEdit",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='sabun' mdef='사번' />",				Type:"Text",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
   			{Header:"<sht:txt mid='orgNm' mdef='소속' />",				Type:"Text",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='jikgubNm' mdef='직급' />",			Type:"Text",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='seq' mdef='순번' />",				Type:"Text",			Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='monV3' mdef='금액' />",				Type:"AutoSum",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"payMon",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='detailBigo' mdef='비고(상세)' />",	Type:"Text",			Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"detailBigo",		KeyField:0,		Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);
		sheet1.SetEditable("${editable}");
		sheet1.SetVisible(true);

		var selectText = "<sch:txt mid='select' mdef='선택' />";
  		// 수당코드 리스트
		var benefitBizCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getDeptPartPayAppBnCdList", false).codeList, selectText);
		$("#benefitBizCd").html(benefitBizCdList[2]);

		$(window).smartresize(sheetResize);sheetInit();

		//setSheetAutocompleteEmp( "sheet1", "name");

		// data 조회
		if(searchApplSeq != null && searchApplSeq != "") {
			var data = ajaxCall( "${ctx}/GetDataMap.do?cmd=getDeptPartPayAppDetList", $("#sheetForm").serialize(), false);
			setDataForm(data);

			doAction1("Search");
		}

		// 처리완료인 경우 비활성화
		// 2020.02.05 임시저장이 아닌경우 비활성화로 변경
		if(applStatusCd != "11") {
			$("#benefitBizCd").attr("disabled", true).removeClass("transparent");

			$("#bigo").hide();
			$("#span_bigo").show();
			$("#payYm").hide();
			$("#span_payYm").show();
		} else {
			$("#span_bigo").hide();
			$("#span_payYm").hide();
		}


	});
	
	function employeePopup(Row){
		if(!isPopup()) {return;}
		gPRow = Row;
		pGubun = "employeePopup";
		
		var url = "${ctx}/Popup.do?cmd=employeePopup&sType=T";
		var rv = openPopup(url,"",740,520);

	}
	
	function sheet1_OnPopupClick(Row, Col){
		try{
		    if(sheet1.ColSaveName(Col)=="name"){
		    		employeePopup(Row);
			}
		}catch(ex){
			alert("sheet1_OnPopupClick Event Error: " + ex);
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "sheetAutocompleteEmp"){
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow, "name", rv["name"]);
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
		} else if(pGubun == "employeePopup"){
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"] );
			sheet1.SetCellValue(gPRow, "name", rv["name"])
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
	    } 
	}


	function setDataForm(data) {

		if(data != null) {
			// 합산년월
			$("#payYm").val(data.DATA.payYm);
			$("#span_payYm").text(data.DATA.payYm);

			// 수당명
			if(data.DATA.benefitBizCd != null || data.DATA.benefitBizCd != ""){
				$("#benefitBizCd").bind("option:selected").val(data.DATA.benefitBizCd).change();
			}

			// 비고 (Master)
			$("#bigo").text(data.DATA.bigo);
			$("#span_bigo").text(data.DATA.bigo);
		}
	}


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
			var applSeq = searchApplSeq;
			var param = "applSeq="+ applSeq ;
			sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getDeptPartPayAppDetailList",param );
			break;
			case "Insert":
			var newRow = sheet1.DataInsert(0);
			sheet1.SetCellValue(newRow, "enterCd", "${ssnEnterCd}");
			break;
			case "Copy":        sheet1.DataCopy(); break;
			case "Clear":       sheet1.RemoveAll(); break;
			case "Down":
				iframeHeight += 40;
				parent.iframeOnLoad(iframeHeight+"px");
				sheet1.SetSheetHeight(sheet1.GetSheetHeight()+40);
				break;
			case "Up":
				iframeHeight -= 40;
				parent.iframeOnLoad(iframeHeight+"px");
				sheet1.SetSheetHeight(sheet1.GetSheetHeight()-40);
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet1.Down2Excel(param);
				break;
			case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
			case "DownTemplate":
				// 양식다운로드
				sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"4|8|9"});
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
			if(sheet1.SearchRows() > 0) {
				$("#sumPayMon").text(sheet1.GetSumValue("payMon")).mask("000,000,000,000,000", {reverse: true});
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnChange(row,col,VALUE){

		if(sheet1.ColSaveName(col) =="payMon"){
			$("#sumPayMon").text(sheet1.GetSumValue("payMon")).mask("000,000,000,000,000", {reverse: true});
		}
	}

	// 입력시 조건 체크
	function checkList(){
		var ch = true;

 		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				var txt = $(this).parent().prev().text();
				if( txt ==  "" ){
					txt = $(this).parent().parent().prev().text();
				}
				alert(txt+" <msg:txt mid='required2' mdef='은 필수값입니다.' />");
				$(this).focus();
				ch =  false;
				return false;
			}
		});

 		// 시트입력 체크
		var row = "";
		if(sheet1.RowCount() == 0) {
			row = sheet1.DataInsert();
			alert(<msg:txt mid='109454' mdef='"그리드에 데이터를 입력해주세요."' />);
			return false;
		} else {
			// 시트 필수항목 체크
			var saveStr = sheet1.GetSaveString(0);
			if (saveStr.match("KeyFieldError")) {
				return false;
			}
		}

		return ch;
	}


	/*----------------------------------------------------------------------------------
		신청서 공통 팝업에서 신청 또는 임시저장 클릭 시 호출 됨.
	----------------------------------------------------------------------------------*/
	function setValue(){
		var saveStr;
		var rtn;
		try{
			//쓰기권한에 임시서장일때만 저장
			if(authPg == "A" && ( applStatusCd == "" || applStatusCd == "11" )) {

				// 입력체크
				if(!checkList()) return ;

				//신청내역 저장
				IBS_SaveName(document.sheetForm, sheet1);
				//alert(" call saveDeptPartPayAppDet, sheet1.GetSaveString => " + sheet1.GetSaveString());

				var rtn;
				if ( sheet1.GetSaveString() == "" ) {
					rtn = ajaxCall("${ctx}/DeptPartPayAppDet.do?cmd=saveDeptPartPayAppDet",$("#sheetForm").serialize(),false);

					if(rtn.Result.Code < 1) {
						alert(rtn.Result.Message);
						return  false;
					}
				} else {
					sheet1.DoSave("${ctx}/DeptPartPayAppDet.do?cmd=saveDeptPartPayAppDet",$("#sheetForm").serialize());
				}

			}
		} catch (ex){
			alert(<msg:txt mid='109829' mdef='"저장중 스크립트 오류발생."+ex' />);
			return false;
		}
		return true;
	}


</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="searchSabun"		name="searchSabun" 		value=""/>
	<input type="hidden" id="searchApplSabun" 	name="searchApplSabun" 	value=""/>
	<input type="hidden" id="searchApplSeq" 	name="searchApplSeq" 	value=""/>
	<input type="hidden" id="subFile" 			name="subFile" 			value=""/>
	<input type="hidden" id="applYmd" name="applYmd" />

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid="202005150000134" mdef="수당지급신청 세부내역" /></li>
			<li class="btn">
			</li>
		</ul>
		</div>
	</div>

	<table class="table outer">
	<colgroup>
		<col width="25%" />
		<col width="25%" />
		<col width="25%" />
		<col width="25%" />
		<!-- <col width="" /> -->
	</colgroup>
	<tr>
		<th><tit:txt mid="202005150000092" mdef="합산년월" /></th>
		<td>
			<input id="payYm" name ="payYm" class="date2 required" type="text" value="<%=DateUtil.getCurrentDate()%>" />
			<span id="span_payYm"></span>
		</td>
		<th><tit:txt mid="etcPayAppBnCd" mdef="수당명" /></th>
		<td>
			<select id="benefitBizCd" name="benefitBizCd" class="required transparent"> </select>
		</td>
	</tr>
	<tr>
		<th><tit:txt mid="103984" mdef="지급총액" /></th>
		<td colspan="3">
			<span id="sumPayMon" name="sumPayMon"></span>
		</td>
	</tr>
	<tr>
		<th><tit:txt mid="103783" mdef="비고" /></th>
		<td colspan="3">
			<textarea id="bigo" name="bigo" rows="3" cols="30" class="${textCss} w100p" ${readonly}></textarea>
			<span id="span_bigo"></span>
		</td>
	</tr>
	<!--
	<tr>
		<th>신청사유</th>
		<td colspan="4">
			<textarea id="gntReqReson" name="gntReqReson" rows="3" cols="30" class="${textCss} w100p" ${readonly}></textarea>
			<span id="span_gntReqReson"></span>
		</td>
	</tr>
	<tr>
		<th>증빙서류</th>
		<td colspan="4">
			<span id="span_subFile"></span>
		</td>
	</tr>
	 -->
	</table>
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
        <tr>
            <td>
                <div class="inner">
                    <div class="sheet_title">
                        <ul>
                            <li id="txt" class="txt"><tit:txt mid="2017083001015" mdef="상세내역" /></li>
                            <li class="btn">
								<btn:a mid="down2ExcelV1" mdef="양식다운로드" href="javascript:doAction1('DownTemplate');"  css="basic authA" />
								<btn:a mid="upload" mdef="업로드" href="javascript:doAction1('LoadExcel');"  css="basic authA" />
								<btn:a mid="insert" mdef="입력" href="javascript:doAction1('Insert');"  css="basic authA" />
								<btn:a mid="copy" mdef="복사" href="javascript:doAction1('Copy');"  css="basic authA" />
								<btn:a mid="download" mdef="다운로드" href="javascript:doAction1('Down2Excel');"  css="basic authR" />
                            </li>
                        </ul>
                    </div>
                </div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
				<div class="inner">
					<tit:txt mid="202005150000120" mdef="화면높이조절 :" />
					<a href="javascript:doAction1('Down');" class="basic">▼</a>
					<a href="javascript:doAction1('Up');" class="basic">▲</a>
				</div>
            </td>
        </tr>
    </table>

</div>

</html>

