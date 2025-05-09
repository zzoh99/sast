<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>급여계산_급여대상자관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 급여계산
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var p = eval("${popUpStatus}");
$(function() {
	var payActionCd		= "";
	var payActionNm		= "";
	var businessPlaceCd	= "";
	var businessPlaceNm	= "";
	var closeYn			= "";

	var arg = p.window.dialogArguments;
	if( arg != undefined ) {
		payActionCd 	= arg["payActionCd"];
		payActionNm 	= arg["payActionNm"];
		businessPlaceCd = arg["businessPlaceCd"];
		businessPlaceNm = arg["businessPlaceNm"];
		closeYn 		= arg["closeYn"];
	}else{
	    if(p.popDialogArgument("payActionCd")!=null)		payActionCd  	= p.popDialogArgument("payActionCd");
	    if(p.popDialogArgument("payActionNm")!=null)		payActionNm  	= p.popDialogArgument("payActionNm");
	    if(p.popDialogArgument("businessPlaceCd")!=null)	businessPlaceCd  = p.popDialogArgument("businessPlaceCd");
	    if(p.popDialogArgument("businessPlaceNm")!=null)	businessPlaceNm  	= p.popDialogArgument("businessPlaceNm");
	    if(p.popDialogArgument("closeYn")!=null)			closeYn  	= p.popDialogArgument("closeYn");
    }

	$("#payActionCd").val(payActionCd);
	$("#payActionNm").val(payActionNm);
	$("#businessPlaceCd").val(businessPlaceCd);
	$("#businessPlaceNm").val(businessPlaceNm);
	$("#closeYn").val(closeYn);

	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata1.Cols = [
		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",		Type:"${sDelTy}",	Hidden:0,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태",		Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"급여계산코드",	Type:"Text",		Hidden:1,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"payActionCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"작업\n대상",	Type:"CheckBox",	Hidden:1,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"payPeopleStatus",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"작업",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payPeopleStatusText",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"계산/취소",		Type:"Html",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"btnPrt",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"급여사업장",	Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"businessPlaceCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"코스트센터",	Type:"Combo",		Hidden:1,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"ccCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"사번",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"성명",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"주민번호",		Type:"Text",		Hidden:1,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"resNo",				KeyField:0,	Format:"IdNo",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"소속",		Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직위",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"직책",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"직급",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"직무",		Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jobNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직구분",		Type:"Combo",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"계약유형",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"manageCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"재직상태",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"statusCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"입사일",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"그룹입사일",	Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"퇴사일",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"retYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"변경전급여대상자상태",	Type:"Text",	Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"oldPayPeopleStatus",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"계산상태",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"status",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(4);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 직구분코드(H10050)
	var workType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10050"), "");
	sheet1.SetColProperty("workType", {ComboText:"|"+workType[0], ComboCode:"|"+workType[1]});

	// 직책코드(H20020)
	var jikchakCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20020"), "");
	sheet1.SetColProperty("jikchakCd", {ComboText:"|"+jikchakCd[0], ComboCode:"|"+jikchakCd[1]});
	
	// 직급코드(H20010)
	var jikgubCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20010"), "");
	sheet1.SetColProperty("jikgubCd", {ComboText:"|"+jikgubCd[0], ComboCode:"|"+jikgubCd[1]});

	// 직위코드(H20030)
	var jikweeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030"), "");
	sheet1.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]});

	// 계약유형코드(H10030)
	var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030"), "");
	sheet1.SetColProperty("manageCd", {ComboText:"|"+manageCd[0], ComboCode:"|"+manageCd[1]});

	// 재직상태코드(H10010)
	var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010"), "");
	sheet1.SetColProperty("statusCd", {ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]});

	// 사업장(TCPN121)
	var tcpn121Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "");
	sheet1.SetColProperty("businessPlaceCd", {ComboText:"|"+tcpn121Cd[0], ComboCode:"|"+tcpn121Cd[1]});

	// 코스트센터(TORG109)
	var torg109Cd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&mapTypeCd=300", "queryId=getTorg109List", false).codeList, "");
	sheet1.SetColProperty("ccCd", {ComboText:"|"+torg109Cd[0], ComboCode:"|"+torg109Cd[1]});

	$(window).smartresize(sheetResize);
	sheetInit();

	$(".close").click(function() {
		p.self.close();
	});

	$("#sabunName").bind("keyup",function(event){
		if (event.keyCode == 13) {
			doAction1("Search");
		}
	});

	doAction1("SearchBasic");

	//setSheetAutocompleteEmp( "sheet1", "name" , null , returnFunc );

	//Autocomplete	
	$(sheet1).sheetAutocomplete({
		Columns: [
			{
				ColSaveName  : "name",
				CallbackFunc : function(returnValue) {
					var rv = $.parseJSON('{' + returnValue+ '}');
					sheet1.SetCellValue(gPRow, "name",		rv["name"] );
					sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"] );
					sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"] );
					sheet1.SetCellValue(gPRow, "workType",	rv["workType"] );
					sheet1.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"] );
					sheet1.SetCellValue(gPRow, "jikweeCd",	rv["jikweeCd"] );
					sheet1.SetCellValue(gPRow, "jikgubCd",	rv["jikgubCd"] );

					sheet1.SetCellValue(gPRow, "manageCd",	rv["manageCd"] );
					sheet1.SetCellValue(gPRow, "statusCd",	rv["statusCd"] );
					sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"] );
					sheet1.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"] );
					sheet1.SetCellValue(gPRow, "resNo",	rv["resNo"] );
					sheet1.SetCellValue(gPRow, "businessPlaceCd",	rv["businessPlaceCd"] );
					sheet1.SetCellValue(gPRow, "ccCd",	rv["ccCd"] );
					sheet1.SetCellValue(gPRow, "jobNm",	rv["jobNm"] );
				}
			}
		]
	});
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if ($("#payActionCd").val() == "") {
		alert("급여일자를 확인하십시오.");
		return false;
	}

	return true;
}

// 마감여부 확인
function chkClose() {
	if ($("#closeYn").val() == "Y") {
		alert("이미 마감되었습니다.");
		return false;
	}

	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "SearchBasic":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			// 기본사항조회
			var basicInfo = ajaxCall("${ctx}/PayCalcCre.do?cmd=getPayCalcCreBasicMap", $("#sheet1Form").serialize(), false);

			$("#payYm"		).html("");
			$("#payNm"		).html("");
			$("#ordYmd"		).html("");
			$("#paymentYmd"	).html("");
			$("#timeYm"		).html("");
//			$("#empStatus"	).html("");
			$("#empStatus"	).val("");
			$("#closeYn"	).val("");

			if (basicInfo.DATA != null) {
				basicInfo = basicInfo.DATA;
				$("#payYm"		).html(basicInfo.payYm		);
				$("#payNm"		).html(basicInfo.payNm		);
				$("#ordYmd"		).html(basicInfo.ordYmd		);
				$("#paymentYmd"	).html(basicInfo.paymentYmd	);
				$("#timeYm"		).html(basicInfo.timeYm		);
//				$("#empStatus"	).html(basicInfo.empStatus	);
				$("#empStatus"	).val(basicInfo.empStatus	);
				$("#closeYn"	).val(basicInfo.closeYn		);

				doAction1("Search");
			}
			break;

		case "PrcP_CPN_CAL_EMP_INS":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}
			// 마감여부 확인
			if (!chkClose()) {
				break;
			}

			if ($("#empStatus").val() != "10005") {
				var rowCnt = sheet1.RowCount();
				if (rowCnt > 0) {
					if (!confirm("이미 대상자가 존재합니다. 덮어쓰시겠습니까?"))
						return;
				}

				if (confirm("[작업]을 실행하시겠습니까?")) {

					var payActionCd = $("#payActionCd").val();
					var businessPlaceCd = $("#businessPlaceCd").val();
					// 급여대상자 생성
					var result = ajaxCall("${ctx}/PayCalcCre.do?cmd=prcP_CPN_CAL_EMP_INS", "sabun=&payActionCd="+payActionCd+"&businessPlaceCd="+businessPlaceCd, false);

					if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
						if (result["Result"]["Code"] == "0") {
							alert("급여대상자 생성 되었습니다.");
							doAction1("Search");
							peopleCnt();
						} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
							alert(result["Result"]["Message"]);
						}
					} else {
						alert("급여대상자 생성 오류입니다.");
					}

				}
			} else {
				alert("이미 마감되었습니다.\n마감취소 후 작업이 가능합니다.");
			}
			break;

		case "Search":
			sheet1.ClearHeaderCheck();

			sheet1.DoSearch("/PayCalcCre.do?cmd=getPayCalcCrePeopleSetList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 마감여부 확인
			if (!chkClose()) {
				break;
			}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/PayCalcCre.do?cmd=savePayCalcCrePeopleSet", $("#sheet1Form").serialize());
			break;

		case "Insert":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}
			// 마감여부 확인
			if (!chkClose()) {
				break;
			}

			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "payActionCd", $("#payActionCd").val());
			sheet1.SelectCell(Row, 2);
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
	}
}

function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
    try {
            if (Msg != "") {
                alert(Msg);
            }
            if($("#closeYn").val() == "Y"){
                sheet1.SetEditable(0);
            }else if($("#closeYn").val() == "N"){
                for ( var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++){
                    if(sheet1.GetCellValue(i, "status") == "J"){
                        sheet1.SetCellEditable(i,"sDelete",0);
                        //sheet1.SetCellValue(i, "btnPrt", '<a class="basic" onClick="calcCancel('+sheet1.GetCellValue(i,"sabun")+')">계산취소</a>');
                        //sheet1.SetCellValue(i, "sStatus", 'R');
                    }else if(sheet1.GetCellValue(i, "status") == "P"){
                        //sheet1.SetCellValue(i, "btnPrt", '<a class="basic" onClick="calc('+sheet1.GetCellValue(i,"sabun")+')">계산</a>');
                        //sheet1.SetCellValue(i, "sStatus", 'R');
                    }
                    if(sheet1.GetCellValue(i, "status") == "J"){
                        sheet1.SetCellEditable(i,"sDelete",0);
                        //sheet1.SetCellValue(i, "btnPrt", '<a class="basic" onClick="calcCancel('+sheet1.GetCellValue(i,"sabun")+')">계산취소</a>');
                        sheet1.SetCellValue(i, "btnPrt", '<a class="basic">계산취소</a>');
                        sheet1.SetCellValue(i, "sStatus", 'R');
                    }else if(sheet1.GetCellValue(i, "status") == "P"){
                        //sheet1.SetCellValue(i, "btnPrt", '<a class="basic" onClick="calc('+sheet1.GetCellValue(i,"sabun")+')">계산</a>');
                        sheet1.SetCellValue(i, "btnPrt", '<a class="basic">계산</a>');
                        sheet1.SetCellValue(i, "sStatus", 'R');
                    }
                }
            }
            sheetResize();
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
}

function sheet1_OnClick(Row, Col, Value) {
	try{
		if(sheet1.ColSaveName(Col) == "btnPrt" && Row != 0){
		if(sheet1.GetCellValue(Row, "status") == "J" && $("#closeYn").val() != "Y" ){
			var sabun = sheet1.GetCellValue( Row, "sabun");
			calcCancel(sabun);
		}else if(sheet1.GetCellValue(Row, "status") == "P" && $("#closeYn").val() != "Y" ){
			var sabun = sheet1.GetCellValue( Row, "sabun");
			calc(sabun);
		}
		}
	}catch(ex){alert("OnClick Event Error : " + ex);}
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}

		peopleCnt();

	} catch (ex) {
		alert("OnSaveEnd Event Error " + ex);
	}
}

function returnFunc(returnValue) {

	var rv = $.parseJSON('{' + returnValue+ '}');

	sheet1.SetCellValue(gPRow, "name",		rv["name"] );
	sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"] );
	sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"] );
	sheet1.SetCellValue(gPRow, "workType",	rv["workType"] );
	sheet1.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"] );
	sheet1.SetCellValue(gPRow, "jikweeCd",	rv["jikweeCd"] );
	sheet1.SetCellValue(gPRow, "jikgubCd",	rv["jikgubCd"] );

	sheet1.SetCellValue(gPRow, "manageCd",	rv["manageCd"] );
	sheet1.SetCellValue(gPRow, "statusCd",	rv["statusCd"] );
	sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"] );
	sheet1.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"] );
	sheet1.SetCellValue(gPRow, "resNo",	rv["resNo"] );
	sheet1.SetCellValue(gPRow, "businessPlaceCd",	rv["businessPlaceCd"] );
	sheet1.SetCellValue(gPRow, "ccCd",	rv["ccCd"] );
	sheet1.SetCellValue(gPRow, "jobNm",	rv["jobNm"] );

}

function calcCancel(sabun){

	if (confirm("[급여계산] 작업취소를 수행하시겠습니까?")) {

		var payActionCd = $("#payActionCd").val();
		var businessPlaceCd = $("#businessPlaceCd").val();
		// 작업취소
			var result = ajaxCall("${ctx}/PayCalcCre.do?cmd=prcP_CPN_CAL_PAY_CANCEL2", "payActionCd="+payActionCd+"&businessPlaceCd="+businessPlaceCd+"&sabun="+sabun, false);

		if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
			if (result["Result"]["Code"] == "0") {
				alert("급여계산취소 되었습니다.");
				peopleCnt();
				doAction1("Search");
			} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
				alert(result["Result"]["Message"]);
			}
		} else {
			alert("급여계산취소 오류입니다.");
		}

	}
}

function calc(sabun){

	if (confirm("[급여계산] 작업을 수행하시겠습니까?")) {

		//작업중인 급여 로그가 있는지 확인
		var ingYn = ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList&searchBizCd=CPN&searchPrgCd=P_CPN_CAL_PAY_MAIN&searchPayActionCd="+$("#payActionCd").val(), "queryId=getPayCalcMsgYn", false) ;
		if( ingYn.codeList[0].code != null && ingYn.codeList[0].code == "N" ) {
			if( confirm("이미 실행중입니다.\nClear 후 진행하시겠습니까?") ) {
				//작업중이던 급여 로그를 강제 삭제 후 실행
				ajaxCall("/PayCalcCre.do?cmd=deleteTSYS904ForPayCalcCre&searchBizCd=CPN&searchPrgCd=P_CPN_CAL_PAY_MAIN&searchPayActionCd="+$("#payActionCd").val(), "queryId=deleteTSYS904ForPayCalcCre", false) ;
			} else {
				return ;
			}
		}

		var payActionCd = $("#payActionCd").val();
		var businessPlaceCd = $("#businessPlaceCd").val();

		$.ajax({
			url : "${ctx}/PayCalcCreProc.do?cmd=prcP_CPN_CAL_PAY_MAIN2",
			type : "post",
			dataType : "json",
			async : true,
			data : "payActionCd="+payActionCd+"&businessPlaceCd="+businessPlaceCd+"&sabun="+sabun,
			success : function(result) {

				if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
					if (result["Result"]["Code"] == "0") {
						alert("급여계산 되었습니다.");
						peopleCnt();
						doAction1("Search");
					} else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
						alert(result["Result"]["Message"]);
					}
				} else {
					alert("급여계산 오류입니다.");
				}

			},
			error : function(jqXHR, ajaxSettings, thrownError) {
				ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
			}
		});

	}
}


function peopleCnt(){

	var payActionCd = $("#payActionCd").val();
	var businessPlaceCd = $("#businessPlaceCd").val();
	var peopleInfo = ajaxCall("${ctx}/PayCalcCre.do?cmd=getPayCalcCrePeopleMap", "payActionCd="+payActionCd+"&businessPlaceCd="+businessPlaceCd, false).DATA;

	if (peopleInfo != null) {
		var rv = new Array(5);
		rv["peopleTotCnt"] = peopleInfo.peopleTotCnt;
		rv["peopleSubCnt"] = peopleInfo.peopleSubCnt;
		rv["peopleJCnt"]   = peopleInfo.peopleJCnt;
		if(p.popReturnValue) p.popReturnValue(rv);
	}
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } peopleCnt(); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function sheet1_OnPopupClick(Row, Col) {
	try{
		var colName = sheet1.ColSaveName(Col);
		if (Row > 0) {
			if (colName == "name") {
				// 사원검색 팝업
				empSearchPopup(Row, Col);
			}
		}
	} catch(ex) {alert("OnPopupClick Event Error : " + ex);}
}

// 사원검색 팝업
function empSearchPopup(Row, Col) {

	if(!isPopup()) {return;}
	gPRow = Row;
	pGubun = "employeePopup";

	var w		= 840;
	var h		= 520;
	var url		= "/Popup.do?cmd=employeePopup";
	var args	= new Array();

	var result = openPopup(url+"&authPg=R", args, w, h);

}

function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "employeePopup"){

		var sabun			= rv["sabun"];
		var name			= rv["name"];
		var orgNm			= rv["orgNm"];
		var workType		= rv["workType"];
		var jikchakCd		= rv["jikchakCd"];
		var jikweeCd		= rv["jikweeCd"];
		var jikgubCd		= rv["jikgubCd"];
		var manageCd		= rv["manageCd"];
		var statusCd		= rv["statusCd"];
		var empYmd			= rv["empYmd"];
		var gempYmd			= rv["gempYmd"];
		var resNo			= rv["resNo"];
		var businessPlaceCd	= rv["businessPlaceCd"];
		var ccCd			= rv["ccCd"];

		sheet1.SetCellValue(gPRow, "sabun", sabun);
		sheet1.SetCellValue(gPRow, "name", name);
		sheet1.SetCellValue(gPRow, "orgNm", orgNm);
		sheet1.SetCellValue(gPRow, "workType", workType);
		sheet1.SetCellValue(gPRow, "jikchakCd", jikchakCd);
		sheet1.SetCellValue(gPRow, "jikweeCd", jikweeCd);
		sheet1.SetCellValue(gPRow, "jikgubCd", jikgubCd);
		sheet1.SetCellValue(gPRow, "manageCd", manageCd);
		sheet1.SetCellValue(gPRow, "statusCd", statusCd);
		sheet1.SetCellValue(gPRow, "empYmd", empYmd);
		sheet1.SetCellValue(gPRow, "gempYmd", gempYmd);
		sheet1.SetCellValue(gPRow, "resNo", resNo);
		sheet1.SetCellValue(gPRow, "businessPlaceCd", businessPlaceCd);
		sheet1.SetCellValue(gPRow, "ccCd", ccCd);
    }
}
/*
// 검색한 이름을 sheet에서 선택
function checkEnter() {
	if (event.keyCode==13) findName();
}

// 검색한 이름을 sheet에서 선택
function findName() {
	if ($("#name").val() == "") return;

	var Row = 0;
	if (sheet1.GetSelectRow() < sheet1.LastRow()) {
		Row = sheet1.FindText("name", $("#name").val(), sheet1.GetSelectRow()+1, 2);
	}else{
		Row = -1;
	}

	if (Row > 0) {
		sheet1.SetCellEditable(Row,"name",true);
		sheet1.SelectCell(Row,"name");
		sheet1.SetCellEditable(Row,"name",false);
	}else if (Row == -1) {
		if (sheet1.SelectRow > 1) {
			Row = sheet1.FindText("name", $("#name").val(), 1, 2);
			if (Row > 0) {
				sheet1.SetCellEditable(Row,"name",true);
				sheet1.SelectCell(Row,"name");
				sheet1.SetCellEditable(Row,"name",false);
			}
		}
	}
	$("#name").focus();
}
*/
</script>
</head>
<body class="hidden bodywrap">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>급여대상자관리</li>
				<li class="close"></li>
			</ul>
		</div>
		<form id="sheet1Form" name="sheet1Form">
		<div class="popup_main">
			<input type="hidden" name="empStatus" value="" />
			<table border="0" cellpadding="0" cellspacing="0" class="default outer">
				<colgroup>
					<col width="13%" />
					<col width="20%" />
					<col width="13%" />
					<col width="20%" />
					<col width="13%" />
					<col width="20%" />
				</colgroup>
				<tr>
					<th>급여일자</th>
					<td colspan="5"><input type="text" id="payActionNm" name="payActionNm" class="text readonly" value="" readonly style="width:300px" />
									<input type="hidden" id="payActionCd" name="payActionCd" value="" /><input type="hidden" id="closeYn" name="closeYn" value="" /></td>
				</tr>
				<tr>
					<th>대상년월</th>
					<td id="payYm"> </td>
					<th>급여구분</th>
					<td id="payNm"> </td>
					<th>지급일자</th>
					<td id="paymentYmd"> </td>
				</tr>
				<tr>
					<th>급여계산기준일</th>
					<td id="ordYmd"> </td>
					<th>근태기준년월</th>
					<td id="timeYm" colspan="3"> </td>
					<!-- th>대상자선정상태</th>
					<td id="empStatus"></td -->
				</tr>
				<tr>
					<th>사업장</th>
					<td colspan="3"><input type="text" id="businessPlaceNm" name="businessPlaceNm" class="text readonly" value="" readonly style="width:300px" />
									<input type="hidden" id="businessPlaceCd" name="businessPlaceCd" value="" /> </td>
					<th>대상자선정</th>
					<td><a href="javascript:doAction1('PrcP_CPN_CAL_EMP_INS')"	class="basic authA">작업</a></td>
				</tr>
			</table>
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">급여대상자관리</li>
							<li class="btn">
								<!-- <span>대상자명</span> <input type="text" id="name" name="name" class="text" value="" size="20" style="ime-mode:active" onKeyUp="checkEnter();" />
								<a onclick="javascript:findName();" href="#" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a> -->
								<span>사번/성명</span> <input type="text" id="sabunName" name="sabunName" class="text" value="" style="ime-mode:active" />
								<a href="javascript:doAction1('Search')"		class="button authR">조회</a>
								<a href="javascript:doAction1('Insert')"		class="basic authA">입력</a>
								<a href="javascript:doAction1('Save')"			class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')"	class="basic authR">다운로드</a>
							</li>
						</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "kr"); </script>
					</td>
				</tr>
			</table>
			<div class="popup_button outer">
				<ul>
					<li>
						<a href="javascript:p.self.close();" class="gray large">닫기</a>
					</li>
				</ul>
			</div>
		</div>
		</form>
	</div>
</body>
</html>
