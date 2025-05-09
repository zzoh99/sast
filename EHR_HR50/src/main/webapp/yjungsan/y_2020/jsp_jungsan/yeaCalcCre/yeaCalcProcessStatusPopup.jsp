<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>대상자기준</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
    var p = eval("<%=popUpStatus%>");
    var cursor = "";
    var queryId = "";

    $(function() {

        var arg = p.window.dialogArguments;

        var searchWorkYy        = "";
        var searchAdjustType    = "";
        var searchPayActionCd   = "";
        var searchBusinessCd    = "";

        if( arg != undefined ) {
            searchWorkYy        = arg["searchWorkYy"];
            searchAdjustType    = arg["searchAdjustType"];
            searchPayActionCd   = arg["searchPayActionCd"];
            searchBusinessCd    = arg["searchBizPlaceCd"];

        }else{
            searchWorkYy      = p.popDialogArgument("searchWorkYy");
            searchAdjustType  = p.popDialogArgument("searchAdjustType");
            searchPayActionCd = p.popDialogArgument("searchPayActionCd");
            searchBusinessCd  = p.popDialogArgument("searchBizPlaceCd");
        }

        $("#searchWorkYy").val(searchWorkYy);
        $("#searchAdjustType").val(searchAdjustType);
        $("#searchPayActionCd").val(searchPayActionCd);
        $("#searchBusinessCd").val(searchBusinessCd);

        getProcessStatus();

    });

    $(function(){
    	var initdata1 = {};
    	initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
    	initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
    	initdata1.Cols = [
                        {Header:"No",       Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
                        {Header:"사번",    	Type:"Text",            Hidden:0,  Width:40,     Align:"Center",    ColMerge:0,   SaveName:"sabun",   	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"성명",		Type:"Text",            Hidden:0,  Width:60,    Align:"Left",      ColMerge:0,   SaveName:"name",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"금액",		Type:"Text",            Hidden:1,  Width:60,    Align:"Left",      ColMerge:0,   SaveName:"mon",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        var initdata2 = {};
    	initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
    	initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
    	initdata2.Cols = [
                        {Header:"No",       Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
                        {Header:"옵션명",    	Type:"Text",            Hidden:0,  Width:110,     Align:"Left",    ColMerge:0,   SaveName:"opt_nm",   	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"작년",    	Type:"Text",            Hidden:0,  Width:35,     Align:"Center",    ColMerge:0,   SaveName:"bf_opt_val",   	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"올해",		Type:"Text",            Hidden:0,  Width:35,    Align:"Center",      ColMerge:0,   SaveName:"opt_val",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
        ]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable(false);sheet2.SetVisible(true);sheet2.SetCountPosition(4);

        $(window).smartresize(sheetResize); sheetInit();

    });

    $(function() {
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});

  	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Code < 0) {
				cursor = "";
				queryId = "";
				$(".explain").removeClass("viewHide");
				$(".view_help").addClass("viewHide");
				$(".sheet_search").addClass("viewHide");
				$("#sheetView_1").addClass("viewHide");
				$("#sheetView_2").addClass("viewHide");
			}
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Code < 0) {
				cursor = "";
				queryId = "";
				$(".explain").removeClass("viewHide");
				$(".view_help").addClass("viewHide");
				$(".sheet_search").addClass("viewHide");
				$("#sheetView_1").addClass("viewHide");
				$("#sheetView_2").addClass("viewHide");
			}

			for(var i=sheet2.HeaderRows(); i<=sheet2.LastRow(); i++) {
				if ( sheet2.GetCellValue(i, "bf_opt_val") != sheet2.GetCellValue(i, "opt_val") ){
					sheet2.SetRowBackColor(i,"#FFCBCB");
				}
			}

			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(queryId != "") {
				goSearch('sheet1', queryId);
			}
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	function doAction2(sAction) {
		switch (sAction) {
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N"};
			sheet2.Down2Excel(param);
			break;
		}
	}


	//특정자리 반올림
	function Round(n, pos) {
    	var digits = Math.pow(10, pos);

    	var sign = 1;
    	if (n < 0) {
    	sign = -1;
    	}

    	// 음수이면 양수처리후 반올림 한 후 다시 음수처리
    	n = n * sign;
    	var num = Math.round(n * digits) / digits;
    	num = num * sign;

    	return num.toFixed(pos);
    }

	//작업내역 가져오기
	function getProcessStatus(){

		//초기화
	    $(".searchSpan").html("");
	    $(".viewCompleteImg").removeClass("viewCompleteImg_o viewCompleteImg_x");

	    //마이너스, 소숫점 금액 노출 제어
	    var rowspan = 2; //연급여 생성 대상자 제어
	    $("#searchMonpayView TH").attr("rowspan", rowspan);
	    $("#searchMinusView,#searchPointView").addClass("viewHide");

		var processStatusData = ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcProcessStatusPopupRst.jsp?cmd=selectYeaCalcProcessStatusPopupInfo",  $("#sheetForm").serialize(), false);

		//1.급여일자관리
		$("#searchPayActionNm").html(nvl(processStatusData.Data.pay_action_nm,""));
		if(processStatusData.Data.pay_action_nm != "미생성" && processStatusData.Data.pay_action_nm != "중복") {
			$("#searchPayActionNm").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_o");
		} else {
			$("#searchPayActionNm").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_x");
		}

		//2.연말정산대상자
		var manCnt = nvl(processStatusData.Data.man_cnt,"");
		$("#searchManCnt").html(comma(manCnt));
		if(manCnt != "" && manCnt > 0) {
			$("#searchManCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_o");
		} else {
			$("#searchManCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_x");
		}

		//3.전년대비 변경 옵션
		var difOpCnt = nvl(processStatusData.Data.dif_opt_cnt,"");
		$("#searchDifOptCnt").html(comma(difOpCnt));
		if(difOpCnt != "" && difOpCnt > 0) {
			$("#searchDifOptCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_o");
		} else {
			$("#searchDifOptCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_x");
		}

		//4.종전근무지
		var bfComCnt = nvl(processStatusData.Data.bf_com_cnt,"");
		$("#searchBfComCnt").html(comma(nvl(processStatusData.Data.bf_com_cnt,"")));

		//5.연급여 생성 대상자 - 인원
		var monpay1Cnt = nvl(processStatusData.Data.monpay1_cnt,"");
		var monpay3Cnt = nvl(processStatusData.Data.monpay3_cnt,"");

		var monpayRate = ""
		if(manCnt == "" || manCnt == "0" ){
			monpayRate = 0;
		}else{
			monpayRate = Round(nvl(replaceAll(processStatusData.Data.monpay1_cnt,",",""),"0")/nvl(replaceAll(manCnt,",",""),1)*100,1);
		}
   	 	$("#searchMonpayCnt").html("연말정산 : "+nvl(processStatusData.Data.monpay1_cnt,"0")+"/"+manCnt+" ("+monpayRate+"%)<br>퇴직정산 : "+nvl(processStatusData.Data.monpay3_cnt,"0"));

		if(monpay1Cnt == manCnt && manCnt > 0) {
			$("#searchMonpayCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_o");
		} else {
			$("#searchMonpayCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_x");
		}

		//5.연급여 생성 대상자 - 총금액
		var monpay1Mon = nvl(processStatusData.Data.monpay1_mon,"");
		var monpay3Mon = nvl(processStatusData.Data.monpay3_mon,"");
		$("#searchMonpayMon").html("연말정산 : "+comma(monpay1Mon)+"<br>퇴직정산 : "+comma(monpay3Mon));

		if(monpay1Cnt == manCnt && manCnt > 0) {
			$("#searchMonpayMon").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_o");
		} else {
			$("#searchMonpayMon").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_x");
		}

		//5.연급여 생성 대상자 - 마이너스 금액 발생
		var minusCnt = nvl(processStatusData.Data.minus_cnt,"");
		$("#searchMinusCnt").html(comma(minusCnt));
		if(minusCnt != "" && minusCnt > 0) {
			$("#searchMinusCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_x");

			//화면에 노출 제어(마이너스, 소숫점 금액)
			rowspan++;
	    	$("#searchMonpayView TH").attr("rowspan", rowspan);
	    	$("#searchMinusView").removeClass("viewHide");
		} else {
			$("#searchMinusCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_o");
		}


		//5.연급여 생성 대상자 - 소숫점 금액 발생
		var pointCnt = nvl(processStatusData.Data.point_cnt,"");
		$("#searchPointCnt").html(comma(pointCnt));
		if(pointCnt != "" && pointCnt > 0) {
			$("#searchPointCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_x");

			//화면에 노출 제어(마이너스, 소숫점 금액)
			rowspan++;
			$("#searchMonpayView TH").attr("rowspan", rowspan);
	    	$("#searchPointView").removeClass("viewHide");
		} else {
			$("#searchPointCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_o");
		}

		//6-1.[공제]주소사항
	    var addrRate = "";
		if(manCnt == "" || manCnt == "0" ){
			addrRate = 0;
		}else{
			addrRate = Round(nvl(replaceAll(processStatusData.Data.addr_y_cnt,",",""),"0")/nvl(replaceAll(manCnt,",",""),1)*100,1);
		}
	    $("#searchAddrCnt").html(nvl(processStatusData.Data.addr_y_cnt,"0")+"/"+manCnt+" ("+addrRate+"%)");
	    if(addrRate < 100) {
			$("#searchAddrCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_x");
		} else {
			$("#searchAddrCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_o");
		}

	    //6-2.[공제]인적공제
	    var perRate = "";
		if(manCnt == "" || manCnt == "0" ){
			perRate = 0;
		}else{
			perRate = Round(nvl(replaceAll(processStatusData.Data.per_y_cnt,",",""),"0")/nvl(replaceAll(manCnt,",",""),1)*100,1);
		}
	    $("#searchPerCnt").html(nvl(processStatusData.Data.per_y_cnt,"0")+"/"+manCnt+" ("+perRate+"%)");
	    if(perRate < 100) {
			$("#searchPerCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_x");
		} else {
			$("#searchPerCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_o");
		}

	  	//6-3.[공제]PDF등록사항
	    var pdfRate = "";
		if(manCnt == "" || manCnt == "0" ){
			pdfRate = 0;
		}else{
			pdfRate = Round(nvl(replaceAll(processStatusData.Data.pdf_y_cnt,",",""),"0")/nvl(replaceAll(manCnt,",",""),1)*100,1);
		}
	    $("#searchPdfCnt").html(nvl(processStatusData.Data.pdf_y_cnt,"0")+"/"+manCnt+" ("+pdfRate+"%)");
	    if(pdfRate < 100) {
			$("#searchPdfCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_x");
		} else {
			$("#searchPdfCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_o");
		}

	  	//6-4.[공제]신용카드
	  	var cardRate = "";
		if(manCnt == "" || manCnt == "0" ){
			cardRate = 0;
		}else{
			cardRate = Round(nvl(replaceAll(processStatusData.Data.card_y_cnt,",",""),"0")/nvl(replaceAll(manCnt,",",""),1)*100,1);
		}
	    $("#searchCardCnt").html(nvl(processStatusData.Data.card_y_cnt,"0")+"/"+manCnt+" ("+cardRate+"%)");
	    if(cardRate < 100) {
			$("#searchCardCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_x");
		} else {
			$("#searchCardCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_o");
		}

	  	//7.본인 마감
	    var inputCloseRate = "";
		if(manCnt == "" || manCnt == "0" ){
			inputCloseRate = 0;
		}else{
			inputCloseRate = Round(nvl(replaceAll(processStatusData.Data.input_close_y_cnt,",",""),"0")/nvl(replaceAll(manCnt,",",""),1)*100,1);
		}
	    $("#searchInputCloseCnt").html(nvl(processStatusData.Data.input_close_y_cnt,"0")+"/"+manCnt+" ("+inputCloseRate+"%)");
	    if(inputCloseRate < 100) {
			$("#searchInputCloseCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_x");
		} else {
			$("#searchInputCloseCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_o");
		}

	  	//8.담당자 마감 - 마감
	    var apprvRate = "";
		if(manCnt == "" || manCnt == "0" ){
			apprvRate = 0;
		}else{
			apprvRate = Round(nvl(replaceAll(processStatusData.Data.apprv_y_cnt,",",""),"0")/nvl(replaceAll(manCnt,",",""),1)*100,1);
		}
	    $("#searchApprvCnt").html(nvl(processStatusData.Data.apprv_y_cnt,"0")+"/"+manCnt+" ("+apprvRate+"%)");
	    if(apprvRate < 100) {
			$("#searchApprvCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_x");
		} else {
			$("#searchApprvCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_o");
		}

	  	//9.계산내역 본인 확인 - 확인
	    var confirmRate = "";
		if(manCnt == "" || manCnt == "0" ){
			confirmRate = 0;
		}else{
			confirmRate = Round(nvl(replaceAll(processStatusData.Data.confirm_y_cnt,",",""),"0")/nvl(replaceAll(manCnt,",",""),1)*100,1);
		}
	    $("#searchConfirmCnt").html(nvl(processStatusData.Data.confirm_y_cnt,"0")+"/"+manCnt+" ("+confirmRate+"%)");
	    if(confirmRate < 100) {
			$("#searchConfirmCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_x");
		} else {
			$("#searchConfirmCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_o");
		}

	  	//10.연말정산 마감
	    var resultCloseYn = nvl(processStatusData.Data.close_yn,"");
	    var finalCloseRate = "";
		if(manCnt == "" || manCnt == "0" ){
			finalCloseRate = 0;
		}else{
			finalCloseRate = Round(nvl(replaceAll(processStatusData.Data.final_close_y_cnt,",",""),"0")/nvl(replaceAll(manCnt,",",""),1)*100,1);
		}
	    $("#searchFinalCloseCnt").html(nvl(processStatusData.Data.final_close_y_cnt,"0")+"/"+manCnt+" ("+finalCloseRate+"%)");
	    if(resultCloseYn != "" && resultCloseYn == "마감") {
	    	$("#searchFinalCloseCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_o");
	    } else {
	    	$("#searchFinalCloseCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_x");
	    }


	    //11.세금계산 인원 현황 - 작업
	    var raxRate = "";
		if(manCnt == "" || manCnt == "0" ){
			raxRate = 0;
		}else{
			raxRate = Round(nvl(replaceAll(processStatusData.Data.tax_y_cnt,",",""),"0")/nvl(replaceAll(manCnt,",",""),1)*100,1);
		}
	    $("#searchTaxCnt").html(nvl(processStatusData.Data.tax_y_cnt,"0")+"/"+manCnt+" ("+raxRate+"%)");
	    if(raxRate < 100) {
			$("#searchTaxCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_x");
		} else {
			$("#searchTaxCnt").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_o");
		}

	  	//12.급여 반영 여부
	    var resultApplyYn = nvl(processStatusData.Data.apply_yn,"");
	    $("#searchApplyYn").html(resultApplyYn);
	    if(resultApplyYn != "" && resultApplyYn == "급여반영") {
	    	$("#searchApplyYn").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_o");
	    } else {
	    	$("#searchApplyYn").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_x");
	    }

		//13.[근로소득]국세청 신고파일
	    var nts1Chk = processStatusData.Data.nts1_name;
	    if(nts1Chk != "") {
	    	$("#searchNts1").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_o");
	    	$("#searchNts1").html("생성일자 : "+nvl(processStatusData.Data.nts1_name,"")+"<br>제출일자 : "+nvl(processStatusData.Data.nts1_send_ymd,""));
	    } else {
	    	$("#searchNts1").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_x");
	    	$("#searchNts1").html("");
	    }

		//13.[퇴직소득]국세청 신고파일
	    var nts3Chk = processStatusData.Data.nts3_name;
	    if(nts3Chk != "") {
	    	$("#searchNts3").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_o");
	    	$("#searchNts3").html("생성일자 : "+nvl(processStatusData.Data.nts3_name,"")+"<br>제출일자 : "+nvl(processStatusData.Data.nts3_send_ymd,""));
	    } else {
	    	$("#searchNts3").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_x");
	    	$("#searchNts3").html("");
	    }

		//13.[의료비]국세청 신고파일
	    var medChk = processStatusData.Data.med_name;
	    if(medChk != "") {
	    	$("#searchMed").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_o");
	    	$("#searchMed").html("생성일자 : "+nvl(processStatusData.Data.med_name,"")+"<br>제출일자 : "+nvl(processStatusData.Data.med_send_ymd,""));
	    } else {
	    	$("#searchMed").parents("TR").find(".viewCompleteImg").addClass("viewCompleteImg_x");
	    	$("#searchMed").html("");
	    }

	    //내역 재조회
	    if(cursor != "") {
	    	clickBtnView(cursor);
	    }

	}

    //콤마찍기
	function comma(str) {
        str = String(str);
        return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
    }

	//특정자리 반올림
	function Round(n, pos) {
    	var digits = Math.pow(10, pos);

    	var sign = 1;
    	if (n < 0) {
    	sign = -1;
    	}

    	// 음수이면 양수처리후 반올림 한 후 다시 음수처리
    	n = n * sign;
    	var num = Math.round(n * digits) / digits;
    	num = num * sign;

    	return num.toFixed(pos);
    }

  	//확인 버튼 클릭
	function clickBtnView(id) {

		cursor = id;

		/* 도움말 및 조회ID 처리 */
		sheet1.SetColHidden("mon",1);

		var title = "";   //타이틀
		var menu = "";    //메뉴경로
		var message = ""; //메세지

		if(id == "clickBtn_payActionNm") {
			//1.급여일자관리
			title = "급여일자관리";
			menu = "월급여관리 > 월급여관리 > 급여일자관리";
			message = " 급여년월을 귀속년도 12월, 급여코드는 연말정산으로 생성합니다.<br>급여일자가 없는 상태에서는 아래 프로세스를 진행 할 수 없습니다.";
		} else if(id == "clickBtn_man") {
			//2.연말정산 대상자
			queryId = "selectManTargetList";
			title = "연말정산 대상자";
			menu = "연말정산 > 정산계산/결과 > 연말정산 > 대상자정보";
			message = " 입력 혹은 대상자 생성으로 생성된 인원입니다.";
		} else if(id == "clickBtn_difOpt") {
			//3.전년대비 변경 옵션 조회
			queryId = "selectDifOptList";
			title = "전년대비 변경 옵션";
			menu = "연말정산 > 정산계산/결과 > 연말정산 > 연말정산옵션";
			message = "연말정산옵션을 확인합니다.<br>전체 연말정산 옵션을 확인 하고, 전년도 대비 변경된 옵션을 비교 할 수 있습니다.";
		} else if(id == "clickBtn_bfCom") {
			//4.종전근무지 대상자
			queryId = "selectBfComTargetList";
			title = "종전근무지";
			menu = "연말정산 > 종(전)근무지 > 종전근무지관리<br>연말정산 > 종(전)근무지 > 종전근무지현황<br>연말정산 > 종(전)근무지 > 비과세소득현황<br>연말정산 > 종(전)근무지 > 종전근무지일괄등록";
			message = "종전근무지를 등록한 인원입니다.";
		} else if(id == "clickBtn_monpayMan") {
			//5.연급여생성 대상자
			queryId = "selectMonpayManTargetList";
			title = "연급여생성";
			menu = "연말정산 > 정산계산/결과 > 연말정산계산<br>연말정산 > 정산계산/결과 > 퇴직자정산계산<br>연말정산 > 정산계산/결과 > 퇴직정산계산";
			message = "연급여생성을 체크 후 작업버튼을 누릅니다. <br>연말정산 옵션 2번을 꼭 참조하시어 생성 하시기 바랍니다.<br><br>아래는 미작업한 인원입니다.";
		} else if(id == "clickBtn_monpayMon") {
			//5.연급여생성 대상자
			title = "연급여생성 금액";
			menu = "연말정산 > 정산계산/결과 > 연말정산계산<br>연말정산 > 정산계산/결과 > 퇴직자정산계산<br>연말정산 > 정산계산/결과 > 퇴직정산계산";
			message = "연급여생성을 체크 한 후 작업한 금액입니다.<br>[기타소득(급여,상여,인정상여)포함]";
		} else if(id == "clickBtn_minus") {
			//5.연급여 생성 대상자 - 마이너스 금액 발생
			queryId = "selectMinusTargetList";
			sheet1.SetColHidden("mon",0);
			title = "연급여 생성 대상자 (마이너스 금액 발생)";
			menu = "연말정산 > 연간소득관리 > 연간소득_전체<br>연말정산 > 연간소득관리 > 연간소득_개별<br>연말정산 > 연간소득관리 > 연간소득_월별<br>연말정산 > 연간소득관리 > 기타소득";
			message = "연급여 생성시 (-)금액이 발생한 인원입니다.<br>총액에 마이너스가 발생하는 경우 신고가 불가 합니다.";
		} else if(id == "clickBtn_point") {
			//5.연급여 생성 대상자 - 소숫점 금액 발생
			queryId = "selectPointTargetList";
			sheet1.SetColHidden("mon",0);
			title = "연급여 생성 대상자 (소숫점 금액 발생)";
			menu = "연말정산 > 연간소득관리 > 연간소득_전체<br>연말정산 > 연간소득관리 > 연간소득_개별<br>연말정산 > 연간소득관리 > 연간소득_월별<br>연말정산 > 연간소득관리 > 기타소득";
			message = "	연급여 생성시 소숫점 금액이 발생한 인원입니다.<br>총액에 소숫점이 발생하는 경우 신고가 불가 합니다.";
		} else if(id == "clickBtn_addr") {
			//6-1.[공제]주소사항
			queryId = "selectAddrNTargetList";
			title = "[공제]주소사항";
			menu = "연말정산 > 소득공제자료관리 > 자료등록 > 기본_주소사항";
			message = "임직원들의 자료등록 -> 주소사항 [확정] 현황을 확인 합니다.<br>아래는 미확정 인원입니다.";
		} else if(id == "clickBtn_per") {
			//6-2.[공제]인적공제
			queryId = "selectPerNTargetList";
			title = "[공제]인적공제";
			menu = "연말정산 > 소득공제자료관리 > 자료등록 > 인적공제<br>연말정산 > 정산계산/결과 > 가족별입력공제현황";
			message = "임직원들의 자료등록 -> 인적공제 [확정] 현황을 확인 합니다.<br> 아래는 미확정 인원입니다.";
		} else if(id == "clickBtn_pdf") {
			//6-3.[공제]PDF등록
			queryId = "selectPdfNTargetList";
			title = "[공제]PDF등록";
			menu = "연말정산 > 소득공제자료관리 > 자료등록 > PDF등록<br>연말정산 > 소득공제자료관리 > 자료등록 > PDF등록현황";
			message = "임직원들의 자료등록 -> PDF등록 현황을 확인 합니다.<br> 아래는 미등록 인원입니다.";
		} else if(id == "clickBtn_inputClose") {
			//7.본인 마감
			queryId = "selectInputCloseNTargetList";
			title = "본인 마감";
			menu = "연말정산 > 소득공제자료관리 > 자료등록<br>연말정산 > 소득공제자료관리 > 자료입력/마감현황";
			message = "직원 본인의 입력 마감 현황을 확인 합니다.<br> 아래는 미마감 인원입니다.";
		} else if(id == "clickBtn_apprv") {
			//8.담당자 마감
			queryId = "selectApprvNTargetList";
			title = "담당자 마감";
			menu = "연말정산 > 소득공제자료관리 > 자료등록(관리자)<br>연말정산 > 소득공제자료관리 > 자료입력/마감현황";
			message = "담당자 마감 확인 합니다.<br> 아래는 미마감 인원입니다.";
		} else if(id == "clickBtn_confirm") {
			//9.계산내역 본인 확인
			queryId = "selectConfirmNTargetList";
			title = "계산내역 본인 확인";
			menu = "연말정산 > 정산계산/결과 > 계산내역";
			message = "임직원 본인이 계산내역을 확인합니다.<br>연말정산6,15,16 옵션이 해당화면에 영향을 미칩니다.<br> 아래는 미확인 인원입니다.";
		} else if(id == "clickBtn_finalClose") {
			//10.연말정산 마감
			queryId = "selectFinalCloseNTargetList";
			title = "연말정산 마감";
			menu = "연말정산 > 정산계산/결과 > 연말정산계산<br>연말정산 > 소득공제자료관리 > 자료입력/마감현황";
			message = " 연말정산 마감 정보입니다.<br>작업이 완료되면 연말정산 마감버튼을 누르거나,<br> 자료입력/마감현황에서 개인별/전체 마감합니다.<br> 아래는 미마감 인원입니다.";
		} else if(id == "clickBtn_tax") {
			//11.세금계산 인원 현황
			queryId = "selectTaxNTargetList";
			title = "세금계산 인원 현황";
			menu = "연말정산 > 정산계산/결과 > 연말정산";
			message = "세금계산을 체크 후 작업버튼을 누릅니다.<br> 아래는 미작업한 인원입니다.";
		} else if(id == "clickBtn_apply") {
			//12.급여반영
			title = "급여반영";
			menu = "연말정산 > 정산계산/결과 > 정산결과 급여반영<br>연말정산 > 소득공제자료관리 > 원천징수세액/분납확인";
			message = "결과를 급여반영일자를 선택하여 반영합니다.<br>(해당 메뉴 사용안할경우 완료여부X)";
		} else if(id == "clickBtn_nts1") {
			//13.근로소득 국세청 신고파일
			title = "[근로소득] 국세청 신고파일";
			menu = "연말정산 > 명세서/국세청신고 > 국세청신고파일";
			message = "대상년도, 구분, 제출일자등을 등록하여 지급조서 파일을 생성합니다.<br>현황판에 나오는 정보는 마지막으로 생성한 정보 입니다.";
		} else if(id == "clickBtn_nts3") {
			//13.퇴직소득 국세청 신고파일
			title = "[퇴직소득] 국세청 신고파일";
			menu = "연말정산 > 명세서/국세청신고 > 국세청신고파일";
			message = "대상년도, 구분, 제출일자등을 등록하여 지급조서 파일을 생성합니다.<br>현황판에 나오는 정보는 마지막으로 생성한 정보 입니다.";
		} else if(id == "clickBtn_med") {
			//13.의료비 국세청 신고파일
			title = "[의료비] 국세청 신고파일";
			menu = "연말정산 > 명세서/국세청신고 > 국세청신고파일";
			message = "대상년도, 구분, 제출일자등을 등록하여 지급조서 파일을 생성합니다.<br>현황판에 나오는 정보는 마지막으로 생성한 정보 입니다.";
		} else { return; }
		$(".view_help .title").html(title);
		$("#view_menu").html(menu);
		$("#view_message").html(message);
		/*//도움말 및 조회ID 처리 */


		/* 화면노출 및 조회 처리 */
		$(".explain").addClass("viewHide");			//작업설명
		$(".sheet_search").addClass("viewHide");	//검색
		$("#sheetView_1").addClass("viewHide");		//인원현황
		$("#sheetView_2").addClass("viewHide");		//옵션현황
		$(".view_help").removeClass("viewHide");	//도움말

		if(id == "clickBtn_payActionNm" || id == "clickBtn_monpayMon" || id == "clickBtn_apply" ||
				id == "clickBtn_nts1" || id == "clickBtn_nts3" || id == "clickBtn_med"){
			$("#sheetView_1").addClass("viewHide");
			$("#sheetView_2").addClass("viewHide");
		} else if(id == "clickBtn_difOpt") {
			$("#sheetView_2").removeClass("viewHide");
			goSearch('sheet2', queryId);

		} else {
			$(".sheet_search").removeClass("viewHide");
			$("#sheetView_1").removeClass("viewHide");
			$("#searchSbNm").val("");
			goSearch('sheet1', queryId);
		}
		/*//화면노출 및 조회 처리 */

	}


  	function goSearch(target, queryId) {
  		if(target == 'sheet1') {
  			sheet1.DoSearch( "<%=jspPath%>/yeaCalcCre/yeaCalcProcessStatusPopupRst.jsp?cmd=selectYeaCalcProcessStatusPopupDetail&queryId="+queryId, $("#sheetForm").serialize() );
  		} else if(target == 'sheet2') {
  			sheet2.DoSearch( "<%=jspPath%>/yeaCalcCre/yeaCalcProcessStatusPopupRst.jsp?cmd=selectYeaCalcProcessStatusPopupDetail&queryId="+queryId, $("#sheetForm").serialize() );
  		} else { return; }
  	}


</script>

<style type="text/css">
    div.explain {margin: 0px !important;}

	.popup_main {margin: 10px 0px 10px 10px !important; padding: 0px !important; display: block; min-width: 1000px !important;}
	.popup_main TABLE,TH,TD {margin: 0px; padding: 0px; border: 0px; font-size: 12px;}
	.popup_main .popup_table {width: 58%; min-height:450px; float: left;}
	.popup_main .clickBtnView {margin-top: 0px; margin-left: 10px; width: 40%; min-height: 450px; float: left; word-break:break-all; white-space: normal;}
	.popup_main .clickBtnView .view_help {margin-bottom: 10px !important;}
	.popup_main .clickBtnView .view_help .menu_path {font-size: 12px; color: #FF0000;}
	.viewHide {display: none;}

	.viewCompleteImg {background-position: center !important; background-repeat: no-repeat !important;}
	.viewCompleteImg_o {background-image: url('../../../common_jungsan/images/icon/icon_o.png') !important;}
	.viewCompleteImg_x {background-image: url('../../../common_jungsan/images/icon/icon_x.png') !important;}

</style>

</head>
<body class="bodywrap" style="overflow:scroll;">
<form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="searchWorkYy" name="searchWorkYy" value=""/>
    <input type="hidden" id="searchAdjustType" name="searchAdjustType" value=""/>
    <input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value=""/>
    <input type="hidden" id="searchBusinessCd" name="searchBusinessCd" value=""/>
    <div class="wrapper">
        <div class="popup_title">
	        <ul>
	            <li id="strTitle">연말정산 작업현황</li>
	        </ul>
        </div>
        <div class="outer popup_main">
        	<div class="popup_table">
	        	<table class="default">
					<colgroup>
						<col width="5%;" />
						<col width="20%;" />
						<col width="*;" />
						<col width="5%;" />
						<col width="10%" />
					</colgroup>
					<tr>
						<th class="center">NO</th>
						<th class="center">업무</th>
						<th class="center">작업내역</th>
						<th class="center">완료여부</th>
						<th class="center">도움말</th>
					</tr>
					<tr>
						<th class="center">1</th>
						<th class="left">급여일자관리</th>
						<td class="left"><span id="searchPayActionNm" class="searchSpan"></span></td>
						<td class="center viewCompleteImg"></td>
						<td class="center"><a href="javascript:clickBtnView('clickBtn_payActionNm');" class="basic" id="clickBtn_payActionNm">도움말</a></td>
					</tr>
					<tr>
						<th class="center">2</th>
						<th class="left">연말정산 대상자</th>
						<td class="left"><span id="searchManCnt" class="searchSpan"></span></td>
						<td class="center viewCompleteImg"></td>
						<td class="center"><a href="javascript:clickBtnView('clickBtn_man');" class="basic" id="clickBtn_man">대상자 확인</a></td>
					</tr>
					<tr>
						<th class="center">3</th>
						<th class="left">전년대비 변경옵션</th>
						<td class="left" colspan="2"><span id="searchDifOptCnt" class="searchSpan"></span></td>
						<td class="center"><a href="javascript:clickBtnView('clickBtn_difOpt');" class="basic" id="clickBtn_difOpt">옵션 확인</a></td>
					</tr>
					<tr>
						<th class="center">4</th>
						<th class="left">종전근무지</th>
						<td class="left" colspan="2"><span id="searchBfComCnt" class="searchSpan"></span></td>
						<td class="center"><a href="javascript:clickBtnView('clickBtn_bfCom');" class="basic" id="clickBtn_bfCom">대상자 확인</a></td>
					</tr>
					<tr id="searchMonpayView">
						<th class="center" rowspan="2">5</th>
						<th class="left" rowspan="2">연급여 생성 대상자</th>
						<td class="left"><span id="searchMonpayCnt" class="searchSpan"></span></td>
						<td class="center viewCompleteImg"></td>
						<td class="center"><a href="javascript:clickBtnView('clickBtn_monpayMan');" class="basic" id="clickBtn_monpayMan">대상자 확인</a></td>
					</tr>
					<tr>
						<td class="left"><span id="searchMonpayMon" class="searchSpan"></span></td>
						<td class="center viewCompleteImg"></td>
						<td class="center"><a href="javascript:clickBtnView('clickBtn_monpayMon');" class="basic" id="clickBtn_monpayMon">도움말</a></td>
					</tr>
					<tr id="searchMinusView" class="viewHide">
						<td class="left">(-) 금액 발생 : <span id="searchMinusCnt" class="searchSpan"></span></td>
						<td class="center viewCompleteImg"></td>
						<td class="center"><a href="javascript:clickBtnView('clickBtn_minus');" class="basic" id="clickBtn_minus">대상자 확인</a></td>
					</tr>
					<tr id="searchPointView" class="viewHide">
						<td class="left">소숫점 금액 발생  : <span id="searchPointCnt" class="searchSpan"></span></td>
						<td class="center viewCompleteImg"></td>
						<td class="center"><a href="javascript:clickBtnView('clickBtn_point');" class="basic" id="clickBtn_point">대상자 확인</a></td>
					</tr>
					<tr>
						<th class="center">6-1</th>
						<th class="left">[공제]주소사항</th>
						<td class="left">확정  : <span id="searchAddrCnt" class="searchSpan"></span></td>
						<td class="center viewCompleteImg"></td>
						<td class="center"><a href="javascript:clickBtnView('clickBtn_addr');" class="basic" id="clickBtn_addr">대상자 확인</a></td>
					</tr>
					<tr>
						<th class="center">6-2</th>
						<th class="left">[공제]인적공제</th>
						<td class="left">확정  : <span id="searchPerCnt" class="searchSpan"></span></td>
						<td class="center viewCompleteImg"></td>
						<td class="center"><a href="javascript:clickBtnView('clickBtn_per');" class="basic" id="clickBtn_per">대상자 확인</a></td>
					</tr>
					<tr>
						<th class="center">6-3</th>
						<th class="left">[공제]PDF등록</th>
						<td class="left">등록  : <span id="searchPdfCnt" class="searchSpan"></span></td>
						<td class="center viewCompleteImg"></td>
						<td class="center"><a href="javascript:clickBtnView('clickBtn_pdf');" class="basic" id="clickBtn_pdf">대상자 확인</a></td>
					</tr>
					<tr>
						<th class="center">7</th>
						<th class="left">본인 마감</th>
						<td class="left">마감  : <span id="searchInputCloseCnt" class="searchSpan"></span></td>
						<td class="center viewCompleteImg"></td>
						<td class="center"><a href="javascript:clickBtnView('clickBtn_inputClose');" class="basic" id="clickBtn_inputClose">대상자 확인</a></td>
					</tr>
					<tr>
						<th class="center">8</th>
						<th class="left">담당자 마감</th>
						<td class="left">마감  : <span id="searchApprvCnt" class="searchSpan"></span></td>
						<td class="center viewCompleteImg"></td>
						<td class="center"><a href="javascript:clickBtnView('clickBtn_apprv');" class="basic" id="clickBtn_apprv">대상자 확인</a></td>
					</tr>
					<tr>
						<th class="center">9</th>
						<th class="left">계산내역 본인 확인</th>
						<td class="left">확인 : <span id="searchConfirmCnt" class="searchSpan"></span></td>
						<td class="center viewCompleteImg"></td>
						<td class="center"><a href="javascript:clickBtnView('clickBtn_confirm');" class="basic" id="clickBtn_confirm">대상자 확인</a></td>
					</tr>
					<tr>
						<th class="center">10</th>
						<th class="left">연말정산 마감</th>
						<td class="left">마감 : <span id="searchFinalCloseCnt" class="searchSpan"></span></td>
						<td class="center viewCompleteImg"></td>
						<td class="center"><a href="javascript:clickBtnView('clickBtn_finalClose');" class="basic" id="clickBtn_finalClose">대상자 확인</a></td>
					</tr>
					<tr>
						<th class="center">11</th>
						<th class="left">세금계산 인원 현황</th>
						<td class="left">작업 : <span id="searchTaxCnt" class="searchSpan"></span></td>
						<td class="center viewCompleteImg"></td>
						<td class="center"><a href="javascript:clickBtnView('clickBtn_tax');" class="basic" id="clickBtn_tax">대상자 확인</a></td>
					</tr>
					<tr>
						<th class="center">12</th>
						<th class="left">급여 반영 여부</th>
						<td class="left"><span id="searchApplyYn" class="searchSpan"></span></td>
						<td class="center viewCompleteImg"></td>
						<td class="center"><a href="javascript:clickBtnView('clickBtn_apply');" class="basic" id="clickBtn_apply">도움말</a></td>
					</tr>
					<tr>
						<th class="center" rowspan="3" >13</th>
						<th class="left">[근로소득] 국세청 신고파일</th>
						<td class="left"><span id="searchNts1" class="searchSpan"></span></td>
						<td class="center viewCompleteImg"></td>
						<td class="center"><a href="javascript:clickBtnView('clickBtn_nts1');" class="basic" id="clickBtn_nts1">도움말</a></td>
					</tr>
					<tr>
						<th class="left">[퇴직소득] 국세청 신고파일</th>
						<td class="left"><span id="searchNts3" class="searchSpan"></span></td>
						<td class="center viewCompleteImg"></td>
						<td class="center"><a href="javascript:clickBtnView('clickBtn_nts3');" class="basic" id="clickBtn_nts3">도움말</a></td>
					</tr>
					<tr>
						<th class="left">[의료비] 국세청 신고파일</th>
						<td class="left"><span id="searchMed" class="searchSpan"></span></td>
						<td class="center viewCompleteImg"></td>
						<td class="center"><a href="javascript:clickBtnView('clickBtn_med');" class="basic" id="clickBtn_med">도움말</a></td>
					</tr>
				</table>
			</div>
			<div class="clickBtnView">
				<div class="explain">
					<div class="title">작업설명</div>
					<div class="txt">
						<ul>
							<li>1. 업무 프로세스별 진행현황입니다.</li>
					        <li>2. 도움말을 클릭하여 작업할 메뉴 경로 및 대상자를 확인합니다.</li>
					        <li>3. 단계별 업무가 끝난 후 새로고침을 통해 확인해 주십시오.</li>
						</ul>
					</div>
				</div>

				<div class="explain view_help viewHide" style="margin-bottom: 10px;">
					<div class="title">도움말</div>
					<div class="txt">
						<ul>
							<li class="menu_path">* 관련 매뉴<br> <span id="view_menu">소득공제자료관리 > 자료등록</span></li>
					        <li><span id="view_message">해당년도로 급여코드 연말정산을 등록한 일자 입니다.</span></li>
						</ul>
					</div>
				</div>

				<div class="sheet_search outer viewHide">
			        <div>
			        <table>
						<tr>
							<td><span>사번/성명</span>
							<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> </td>
							<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
						</tr>
			        </table>
			        </div>
			    </div>

				<div id="sheetView_1" class="viewHide" style="height: 400px;">
					<div class="sheet_title">
				        <ul>
				            <li class="txt">인원내역</li>
				            <li class="btn">
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
				            </li>
				        </ul>
			        </div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "450px"); </script></div>
				<div id="sheetView_2" class="viewHide" style="height: 400px;">
					<div class="sheet_title">
				        <ul>
				            <li class="txt">옵션내역</li>
				            <li class="btn">
								<a href="javascript:doAction2('Down2Excel')" 	class="basic authR">다운로드</a>
				            </li>
				        </ul>
			        </div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "450px"); </script></div>
			</div>
        </div>

        <div class="outer popup_button"  style="clear: both;">
            <ul>
                <li>
                	<a href="javascript:getProcessStatus();" class="blue large">새로고침</a>
                    <a href="javascript:p.self.close();" class="gray large">닫기</a>
                </li>
            </ul>
        </div>
    </div>
</form>
</body>
</html>



