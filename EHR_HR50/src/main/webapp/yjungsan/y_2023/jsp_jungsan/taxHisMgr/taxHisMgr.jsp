<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>원천징수세액조회/분납확인</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
	var isProc = true; //계산버튼을 클릭했을때 이벤트 실행 플래그

	$(function() {
		//엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		$("#searchYear").val("<%=Integer.parseInt(yeaYear) %>") ;

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No|No",			Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
            {Header:"상태|상태|상태",           Type:"<%=sSttTy%>", Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sSttWdt%>",   Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },

			{Header:"대상년도|대상년도|대상년도",		Type:"Text",	Hwwwwidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"work_yy",			KeyField:0,		CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"정산구분|정산구분|정산구분",		Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"adjust_type",		KeyField:0,		CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"부서명|부서명|부서명",		Type:"Text",	Hidden:0,	Width:90,	Align:"Left",	ColMerge:1,	SaveName:"org_nm",			KeyField:0,		CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"성명|성명|성명",			Type:"Popup",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"name",			KeyField:0,		CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"사번|사번|사번",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"sabun",			KeyField:0,		CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },

			{Header:"원천징수\n세액선택|원천징수\n세액선택|원천징수\n세액선택",        Type:"Combo",       Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"tax_rate",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },

			{Header:"분납신청|신청여부|신청여부",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1, SaveName:"tax_ins_yn",	KeyField:0, Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"분납신청|확정금액|소득세",         Type:"Int",       Hidden:0,   Width:60,   Align:"Right", ColMerge:1, SaveName:"tot_mon_s",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"분납신청|확정금액|주민세",         Type:"Int",       Hidden:0,   Width:60,   Align:"Right", ColMerge:1, SaveName:"tot_mon_j",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"분납신청|개월수|개월수",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1, SaveName:"tax_ins_yn_month",	KeyField:0, Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"분납신청|1회차|소득세",			Type:"Int",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:1, SaveName:"tax_ins_mon_1",	KeyField:0, Format:"Float",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"분납신청|1회차|주민세",			Type:"Int",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:1, SaveName:"tax_ins_mon_11",	KeyField:0, Format:"Float",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"분납신청|2회차|소득세",			Type:"Int",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:1, SaveName:"tax_ins_mon_2",	KeyField:0, Format:"Float",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"분납신청|2회차|주민세",			Type:"Int",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:1, SaveName:"tax_ins_mon_22",	KeyField:0, Format:"Float",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"분납신청|3회차|소득세",			Type:"Int",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:1, SaveName:"tax_ins_mon_3",	KeyField:0, Format:"Float",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"분납신청|3회차|주민세",			Type:"Int",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:1, SaveName:"tax_ins_mon_33",	KeyField:0, Format:"Float",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "C00303"), "전체" );

		sheet1.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});
		sheet1.SetColProperty("tax_ins_yn",	{ComboText:"미신청|신청", ComboCode:"N|Y"} );
		sheet1.SetColProperty("tax_rate",	{ComboText:"|120|100|80", ComboCode:"|120|100|80"} );

		sheet1.SetColProperty("tax_ins_yn_month", {ComboText:"|2개월|3개월", ComboCode:"|2|3"} );

		$("#searchAdjustType").html(adjustTypeList[2]).val("1");

		// 사업장(권한 구분)
		var ssnSearchType  = "<%=removeXSS(ssnSearchType, '1')%>";
		var bizPlaceCdList = "";

		if(ssnSearchType == "A"){
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
		}else{
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}

        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

	$(function() {
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/taxHisMgr/taxHisMgrRst.jsp?cmd=selectTaxHisMgrList", $("#sheetForm").serialize() );
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param   = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N",menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
		case "Save":
			if($("#searchPayActionCd").val() == "") {
                alert($("#searchWorkYy").val()+"년 연말정산항목이 존재하지 않습니다.");
            }
			for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++){
				var saveRow = sheet1.GetCellValue(i,"sStatus");
				var taxIns1 = sheet1.GetCellValue(i, "tax_ins_mon_1");
				var taxIns2 = sheet1.GetCellValue(i, "tax_ins_mon_2");
				var taxIns3 = sheet1.GetCellValue(i, "tax_ins_mon_3");
				var taxIns11 = sheet1.GetCellValue(i, "tax_ins_mon_11");
				var taxIns22 = sheet1.GetCellValue(i, "tax_ins_mon_22");
				var taxIns33 = sheet1.GetCellValue(i, "tax_ins_mon_33");
				var taxInsYnMonth = sheet1.GetCellValue(i, "tax_ins_yn_month");

				//10자리 소수 자릿수로 반올림
				taxIns1 = Math.round(taxIns1 * 0.1) * 10;
				taxIns2 = Math.round(taxIns2 * 0.1) * 10;
				taxIns3 = Math.round(taxIns3 * 0.1) * 10;
				taxIns11 = Math.round(taxIns11 * 0.1) * 10;
				taxIns22 = Math.round(taxIns22 * 0.1) * 10;
				taxIns33 = Math.round(taxIns33 * 0.1) * 10;

				if(saveRow == "U"){
					/* 23.12.06 소득세 추가 납부세액이 10만원 이하일 경우에 분납 신청여부 비활성화 */
					if(sheet1.GetCellValue(i, "tot_mon_s") > 100000) {						
						if(taxInsYnMonth == "2") {
							if(taxIns1 == "0" || taxIns2 == "0"){
								alert("0은 입력하실 수 없습니다.");
								return ;
							}
						}else if(taxInsYnMonth == "3"){
							if(taxIns1 == "0" || taxIns2 == "0" || taxIns3 == "0" || taxIns11 == "0" || taxIns22 == "0" || taxIns33 == "0"){
								alert("0은 입력하실 수 없습니다.");
								return ;
							}
						}
					}
				}
			}
            sheet1.DoSave( "<%=jspPath%>/taxHisMgr/taxHisMgrRst.jsp?cmd=saveTaxHisMgrList", $("#sheetForm").serialize() );
            break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			if(Code == 1){

				for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++) {

					if(sheet1.GetCellValue(i, "tax_ins_yn") == "Y") {

		                sheet1.SetCellEditable(i, "tax_ins_yn_month", "1");

						if( sheet1.GetCellValue(i, "tax_ins_yn_month") == "2" ) {

			                sheet1.SetCellEditable(i, "tax_ins_mon_2", "1");
			                sheet1.SetCellEditable(i, "tax_ins_mon_22", "1");
						} else if(  sheet1.GetCellValue(i, "tax_ins_yn_month") == "3" ) {

							sheet1.SetCellEditable(i, "tax_ins_mon_2", "1");
			                sheet1.SetCellEditable(i, "tax_ins_mon_22", "1");
			                sheet1.SetCellEditable(i, "tax_ins_mon_3", "1");
			                sheet1.SetCellEditable(i, "tax_ins_mon_33", "1");
						}
					}
					
					/* 23.03.08 추가 납부세액이 10만원 이하일 경우에 분납 신청여부 비활성화 */
					else if(sheet1.GetCellValue(i, "tot_mon_s") <= 100000) {
						sheet1.SetCellEditable(i, "tax_ins_yn", "0");
						sheet1.SetCellEditable(i, "tax_ins_yn_month", "0");
					}

				}
				//퇴직정산일 경우 분납신청 2,3회차 비활성화
				if($("#searchAdjustType").val() == "3"){
					sheet1.SetColHidden("tax_ins_mon_2" ,1);
					sheet1.SetColHidden("tax_ins_mon_22",1);
					sheet1.SetColHidden("tax_ins_mon_3" ,1);
					sheet1.SetColHidden("tax_ins_mon_33",1);
				}else{
					sheet1.SetColHidden("tax_ins_mon_2" ,0);
					sheet1.SetColHidden("tax_ins_mon_22",0);
					sheet1.SetColHidden("tax_ins_mon_3" ,0);
					sheet1.SetColHidden("tax_ins_mon_33",0);
				}
			}

			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnChange(Row, Col, Value, oldValue) {
	    try {
	    	if(isProc) {
	    		setTaxInsMon(Row,Col,oldValue)
	    	}
	    } catch (ex) {
	    	alert("OnChange Event Error : " + ex);
	    }
	}

	function sheet1_OnValidation(Row, Col, Value) {
		try {
            var taxInsYn      = sheet1.GetCellValue(Row, "tax_ins_yn");
            var taxInsYnMonth = sheet1.GetCellValue(Row, "tax_ins_yn_month");
            var totMonS        = sheet1.GetCellValue(Row, "tot_mon_s");
            var totMonJ        = sheet1.GetCellValue(Row, "tot_mon_j");

            if(sheet1.ColSaveName(Col) == "tax_ins_yn") {
                /*if(totMonS <= 0 && taxInsYn != "N"){
                    alert("분납신청 대상자가 아닙니다.");
                    sheet1.SetCellValue(Row, "tax_ins_yn", "N");
                }*/
            } else if(sheet1.ColSaveName(Col) == "tax_ins_yn_month") {
                if(taxInsYn == "Y" && taxInsYnMonth == ""){
                    alert("분납신청 개월수를 확인하시기 바랍니다.");
                    //sheet1.SetCellValue(Row, "tax_ins_yn_month", oldValue);
                    sheet1.SetRowBackColor(Row, "#de6f8b");
                }
            } else if(sheet1.ColSaveName(Col) == "tax_ins_mon_2" || sheet1.ColSaveName(Col) == "tax_ins_mon_3") {
                var tax1 = sheet1.GetCellValue(Row, "tax_ins_mon_1");
                var tax2 = sheet1.GetCellValue(Row, "tax_ins_mon_2");
                var tax3 = sheet1.GetCellValue(Row, "tax_ins_mon_3");
                var tax11 = sheet1.GetCellValue(Row, "tax_ins_mon_11");
                var tax22 = sheet1.GetCellValue(Row, "tax_ins_mon_22");
                var tax33 = sheet1.GetCellValue(Row, "tax_ins_mon_33");
                var totTax = tax1 + tax2 + tax3;
                var totTax2 = tax11 + tax22 + tax33;

                //10자리 소수 자릿수로 반올림
                tax1 = Math.round(tax1 * 0.1) * 10;
                tax2 = Math.round(tax2 * 0.1) * 10;
                tax3 = Math.round(tax3 * 0.1) * 10;
                tax11 = Math.round(tax11 * 0.1) * 10;
                tax22 = Math.round(tax22 * 0.1) * 10;
                tax33 = Math.round(tax33 * 0.1) * 10;

                totTax = Math.round(totTax * 0.1) * 10;
                totTax2 = Math.round(totTax2 * 0.1) * 10;

                if(taxInsYnMonth == "2") {
                	if(tax2 == "0"){

                		tax1 = totMonS/taxInsYnMonth;
                		tax1 = totMonS/taxInsYnMonth;
                		tax22 = totMonJ/taxInsYnMonth;
                		tax22 = totMonJ/taxInsYnMonth;

                	}else{
                		tax1 = totMonS - tax2;
                		tax11 = totMonJ - tax22;
                	}

                } else if(taxInsYnMonth == "3") {
                	if(tax2 == "0" && tax3 == "0"){
                		tax1 = totMonS/taxInsYnMonth;
                		tax2 = totMonS/taxInsYnMonth;
                		tax3 = totMonS/taxInsYnMonth;

                		tax11 = totMonJ/taxInsYnMonth;
                		tax22 = totMonJ/taxInsYnMonth;
                		tax33 = totMonJ/taxInsYnMonth;
                	}else if(tax2 == "0" && tax3 != "0"){
                		tax1 = (totMonS-tax3)/2;
                		tax2 = (totMonS-tax3)/2;

                		tax11 = (totMonJ-tax33)/2;
                		tax22 = (totMonJ-tax33)/2;
                	}else if(tax2 != "0" && tax3 =="0"){
                		tax1 = (totMonS-tax3)/2;
                		tax3 = (totMonS-tax3)/2;

                		tax11 = (totMonJ-tax33)/2;
                		tax32 = (totMonJ-tax33)/2;
                	}else{
                		tax1 = totMonS - (tax2 + tax3);
                		tax11 = totMonJ - (tax22 + tax33);
                	}

                }

                if(tax1 < 0){
                    //alert("분납 금액을 확인하시기 바랍니다.");
                    sheet1.SetCellValue(Row, "tax_ins_mon_1", totMonS);
                    sheet1.SetCellValue(Row, "tax_ins_mon_11", totMonJ);
                    if(sheet1.ColSaveName(Col) == "tax_ins_mon_2") {
                        sheet1.SetCellValue(Row, "tax_ins_mon_2", 0);
                        sheet1.SetCellValue(Row, "tax_ins_mon_22", 0);
                    } else if (sheet1.ColSaveName(Col) == "tax_ins_mon_2") {
                        sheet1.SetCellValue(Row, "tax_ins_mon_3", 0);
                        sheet1.SetCellValue(Row, "tax_ins_mon_33", 0);
                    }
                }
            }
        } catch (ex) {
            alert("OnChange Event Error : " + ex);
        }
    }

	//저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
            if(Code == 1) {
                doAction1("Search");
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }

	//사원 조회
	function openEmployeePopup(Row){
		try{
			var args	= new Array();

			if(!isPopup()) {return;}
			gPRow = Row;
			pGubun = "employeePopup";

			var rv = openPopup("<%=jspPath%>/common/employeePopup.jsp?authPg=<%=authPg%>", args, "740","520");
		/*
			if(rv!=null){
				sheet1.SetCellValue(Row, "name",		rv["name"] );
				sheet1.SetCellValue(Row, "sabun",		rv["sabun"] );
				sheet1.SetCellValue(Row, "org_nm",		rv["org_nm"] );
			}
		*/
		} catch(ex) {
			alert("Open Popup Event Error : " + ex);
		}
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "employeePopup" ){
			//사원조회
			sheet1.SetCellValue(gPRow, "name",		rv["name"] );
			sheet1.SetCellValue(gPRow, "sabun",	rv["sabun"] );
			sheet1.SetCellValue(gPRow, "org_nm",	rv["org_nm"] );
		}
	}

	function runTaxInsMonBtn() {

		for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++){
			/*if( sheet1.GetCellValue(i, "tax_ins_yn") == "Y"
			 && sheet1.GetCellValue(i, "tot_mon_s") > 0
			 && sheet1.GetCellValue(i, "tot_mon_j") > 0
			 && (sheet1.GetCellValue(i, "tot_mon_s")+sheet1.GetCellValue(i, "tot_mon_j")) > 100000 ) { // 23.03.10 10만원 초과라 하여 >= 에서 >으로 수정

				//값을 초기화하고 다시 계산한다.
				isProc = false;
				sheet1.SetCellValue(i, "tax_ins_mon_2", "0");
				sheet1.SetCellValue(i, "tax_ins_mon_22", "0");
				sheet1.SetCellValue(i, "tax_ins_mon_3", "0");
				sheet1.SetCellValue(i, "tax_ins_mon_33", "0");
				setTaxInsMon(i,11,sheet1.GetCellValue(i, "tax_ins_yn_month") ) ; //개월수 바꾼것처럼 돌림 alert(sheet1.ColSaveName(11)) ;
			}*/
			
			//값을 초기화하고 다시 계산한다.
			isProc = false;
			sheet1.SetCellValue(i, "tax_ins_mon_2", "0");
			sheet1.SetCellValue(i, "tax_ins_mon_22", "0");
			sheet1.SetCellValue(i, "tax_ins_mon_3", "0");
			sheet1.SetCellValue(i, "tax_ins_mon_33", "0");
			setTaxInsMon(i,11,sheet1.GetCellValue(i, "tax_ins_yn_month") ) ; //개월수 바꾼것처럼 돌림 alert(sheet1.ColSaveName(11)) ;
		}
		alert("분납신청이 완료된 대상자에 대하여\n분납 개월수에 따른 계산이 완료되었습니다.\n\n확인 후 '저장' 하시기 바랍니다.") ;

	}


	function setTaxInsMon(Row,Col,oldValue) {
    	var taxInsYn      = sheet1.GetCellValue(Row, "tax_ins_yn");
    	var taxInsYnMonth = sheet1.GetCellValue(Row, "tax_ins_yn_month");
    	var totMonS       = sheet1.GetCellValue(Row, "tot_mon_s");
    	var totMonJ       = sheet1.GetCellValue(Row, "tot_mon_j");

    	if(sheet1.ColSaveName(Col) == "tax_ins_yn") {

    		//var flag = taxInsYn == "Y" && totMonS > 0 ? 1 : 0 && totMonJ > 0 ? 1 : 0;
    		var flag = taxInsYn == "Y" && totMonS > 100000 ? 1 : 0;

    		if(taxInsYn == "N"){
    			sheet1.SetCellValue(Row, "tax_ins_yn_month", "");
    			sheet1.SetCellEditable(Row, "tax_ins_yn_month", flag);
                sheet1.SetCellValue(Row, "tax_ins_mon_1", totMonS);
                sheet1.SetCellValue(Row, "tax_ins_mon_11", totMonJ);
                sheet1.SetCellValue(Row, "tax_ins_mon_2", "0");
                sheet1.SetCellValue(Row, "tax_ins_mon_22", "0");
                sheet1.SetCellValue(Row, "tax_ins_mon_3", "0");
                sheet1.SetCellValue(Row, "tax_ins_mon_33", "0");
                sheet1.SetCellEditable(Row, "tax_ins_mon_2", flag);
                sheet1.SetCellEditable(Row, "tax_ins_mon_22", flag);
                sheet1.SetCellEditable(Row, "tax_ins_mon_3", flag);
                sheet1.SetCellEditable(Row, "tax_ins_mon_33", flag);
    			return;
    		}


    		// totMonS > 0 && totMonJ > 0 ====> totMonS > 100000 조건으로 변경
    		if(totMonS > 100000) {
	    		sheet1.SetCellValue(Row, "tax_ins_yn_month", "2");

	    		sheet1.SetCellEditable(Row, "tax_ins_yn_month", flag);
	    		sheet1.SetCellEditable(Row, "tax_ins_mon_2", flag);
	    		sheet1.SetCellEditable(Row, "tax_ins_mon_22", flag);
    		}else if(totMonS <= 100000 && taxInsYn != "N"){ // 확정 금액이 10만원 이하일 경우로 조건 변경
    			alert("분납신청 대상자가 아닙니다.");
    			sheet1.SetCellValue(Row, "tax_ins_yn", "N");
    		}
    	} else if(sheet1.ColSaveName(Col) == "tax_ins_yn_month") {
    		if(taxInsYn == "Y" && taxInsYnMonth == ""){
    		    alert("분납신청 개월수를 확인하시기 바랍니다.");
    		    sheet1.SetCellValue(Row, "tax_ins_yn_month", oldValue);
    		    sheet1.SetRowBackColor(Row, "#de6f8b");
    		}
    		
    		if(totMonS > 100000) {
	    	    if(taxInsYnMonth == "2") {
	    	    	sheet1.SetCellEditable(Row, "tax_ins_mon_2", 1);
	    	    	sheet1.SetCellEditable(Row, "tax_ins_mon_22", 1);
	                sheet1.SetCellEditable(Row, "tax_ins_mon_3", 0);
	                sheet1.SetCellEditable(Row, "tax_ins_mon_33", 0);
	    	    		var tax1 = Math.floor(totMonS/taxInsYnMonth);
	    	    		var tax2 = Math.floor(totMonS/taxInsYnMonth);
	    	    		var tax11 = Math.floor(totMonJ/taxInsYnMonth);
	    	    		var tax22 = Math.floor(totMonJ/taxInsYnMonth);
	
	    	    		tax1 = Math.round(tax1 * 0.1) * 10;
	    	    		tax2 = Math.round(tax2 * 0.1) * 10;
	    	    		tax11 = Math.round(tax11 * 0.1) * 10;
	    	    		tax22 = Math.round(tax22 * 0.1) * 10;
	
	    	    		//각각 계산을 하면 차액이 발생한다. 발생하는 차액은 1차로 적용 - 2020.02.19
	    	    		//sheet1.SetCellValue(Row, "tax_ins_mon_1", tax1);
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_1", totMonS - tax2);
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_2", tax2);
		                sheet1.SetCellValue(Row, "tax_ins_mon_3", "0");
	    	    		//sheet1.SetCellValue(Row, "tax_ins_mon_11", tax11);
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_11", totMonJ - tax22);
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_22", tax22);
		                sheet1.SetCellValue(Row, "tax_ins_mon_33", "0");
	    	    } else if(taxInsYnMonth == "3") {
	    	    	sheet1.SetCellEditable(Row, "tax_ins_mon_2", 1);
	                sheet1.SetCellEditable(Row, "tax_ins_mon_3", 1);
	                sheet1.SetCellEditable(Row, "tax_ins_mon_22", 1);
	                sheet1.SetCellEditable(Row, "tax_ins_mon_33", 1);
	    	    	if(sheet1.GetCellValue(Row, "tax_ins_mon_2") == "0" && sheet1.GetCellValue(Row, "tax_ins_mon_3") == "0" ){
	    	    		var tax1 = Math.floor(totMonS/taxInsYnMonth);
	    	    		var tax2 = Math.floor(totMonS/taxInsYnMonth);
	    	    		var tax3 = Math.floor(totMonS/taxInsYnMonth);
	    	    		var tax11 = Math.floor(totMonJ/taxInsYnMonth);
	    	    		var tax22 = Math.floor(totMonJ/taxInsYnMonth);
	    	    		var tax33 = Math.floor(totMonJ/taxInsYnMonth);
	
	    	    		tax1 = Math.round(tax1 * 0.1) * 10;
	    	    		tax2 = Math.round(tax2 * 0.1) * 10;
	    	    		tax3 = Math.round(tax3 * 0.1) * 10;
	    	    		tax11 = Math.round(tax11 * 0.1) * 10;
	    	    		tax22 = Math.round(tax22 * 0.1) * 10;
	    	    		tax33 = Math.round(tax33 * 0.1) * 10;
	
	    	    		//각각 계산을 하면 차액이 발생한다. 발생하는 차액은 1차로 적용 - 2020.02.19
	    	    		//sheet1.SetCellValue(Row, "tax_ins_mon_1", tax1);
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_1", totMonS - (tax2 + tax3));
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_2", tax2);
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_3", tax3);
	    	    		//sheet1.SetCellValue(Row, "tax_ins_mon_11", tax11);
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_11", totMonJ - (tax22 + tax33));
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_22", tax22);
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_33", tax33);
	    	    	}else if(sheet1.GetCellValue(Row, "tax_ins_mon_2") != "0" && sheet1.GetCellValue(Row, "tax_ins_mon_3") == "0" ){
	    	    		var tax1 = Math.floor(totMonS/taxInsYnMonth);
	    	    		var tax2 = Math.floor(totMonS/taxInsYnMonth);
	    	    		var tax3 = Math.floor(totMonS/taxInsYnMonth);
	    	    		var tax11 = Math.floor(totMonJ/taxInsYnMonth);
	    	    		var tax22 = Math.floor(totMonJ/taxInsYnMonth);
	    	    		var tax33 = Math.floor(totMonJ/taxInsYnMonth);
	
	    	    		tax1 = Math.round(tax1 * 0.1) * 10;
	    	    		tax2 = Math.round(tax2 * 0.1) * 10;
	    	    		tax3 = Math.round(tax3 * 0.1) * 10;
	    	    		tax11 = Math.round(tax11 * 0.1) * 10;
	    	    		tax22 = Math.round(tax22 * 0.1) * 10;
	    	    		tax33 = Math.round(tax33 * 0.1) * 10;
	
	    	    		//각각 계산을 하면 차액이 발생한다. 발생하는 차액은 1차로 적용 - 2020.02.19
	    	    		//sheet1.SetCellValue(Row, "tax_ins_mon_1", tax1);
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_1", totMonS - (tax2 + tax3));
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_2", tax2);
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_3", tax3);
	    	    		//sheet1.SetCellValue(Row, "tax_ins_mon_11", tax11);
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_11", totMonJ - (tax22 + tax33));
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_22", tax22);
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_33", tax33);
	    	    	}else if(sheet1.GetCellValue(Row, "tax_ins_mon_2") == "0" && sheet1.GetCellValue(Row, "tax_ins_mon_3") != "0" ){
	    	    		var tax1 = Math.floor(totMonS/taxInsYnMonth);
	    	    		var tax2 = Math.floor(totMonS/taxInsYnMonth);
	    	    		var tax3 = Math.floor(totMonS/taxInsYnMonth);
	    	    		var tax11 = Math.floor(totMonJ/taxInsYnMonth);
	    	    		var tax22 = Math.floor(totMonJ/taxInsYnMonth);
	    	    		var tax33 = Math.floor(totMonJ/taxInsYnMonth);
	
	    	    		tax1 = Math.round(tax1 * 0.1) * 10;
	    	    		tax2 = Math.round(tax2 * 0.1) * 10;
	    	    		tax3 = Math.round(tax3 * 0.1) * 10;
	    	    		tax11 = Math.round(tax11 * 0.1) * 10;
	    	    		tax22 = Math.round(tax22 * 0.1) * 10;
	    	    		tax33 = Math.round(tax33 * 0.1) * 10;
	
	    	    		//각각 계산을 하면 차액이 발생한다. 발생하는 차액은 1차로 적용 - 2020.02.19
	    	    		//sheet1.SetCellValue(Row, "tax_ins_mon_1", tax1);
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_1", totMonS - (tax2 + tax3));
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_2", tax2);
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_3", tax3);
	    	    		//sheet1.SetCellValue(Row, "tax_ins_mon_11", tax11);
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_11", totMonJ - (tax22 + tax33));
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_22", tax22);
	    	    		sheet1.SetCellValue(Row, "tax_ins_mon_33", tax33);
	    	    	}
	
	    	    }
    		}
    		else {
    			sheet1.SetCellValue(Row, "tax_ins_mon_1", totMonS);
	    		sheet1.SetCellValue(Row, "tax_ins_mon_11", totMonJ);
    		}
    		
        } else if(sheet1.ColSaveName(Col) == "tax_ins_mon_2" || sheet1.ColSaveName(Col) == "tax_ins_mon_3"||sheet1.ColSaveName(Col) == "tax_ins_mon_22" || sheet1.ColSaveName(Col) == "tax_ins_mon_33") {
        	var tax1 = sheet1.GetCellValue(Row, "tax_ins_mon_1");
            var tax2 = sheet1.GetCellValue(Row, "tax_ins_mon_2");
            var tax3 = sheet1.GetCellValue(Row, "tax_ins_mon_3");
        	var tax11 = sheet1.GetCellValue(Row, "tax_ins_mon_11");
            var tax22 = sheet1.GetCellValue(Row, "tax_ins_mon_22");
            var tax33 = sheet1.GetCellValue(Row, "tax_ins_mon_33");
            var totTax = tax1 + tax2 + tax3;
            var totTax2 = tax11 + tax22 + tax33;

            tax1 = Math.round(tax1 * 0.1) * 10;
            tax2 = Math.round(tax2 * 0.1) * 10;
            tax3 = Math.round(tax3 * 0.1) * 10;
            tax11 = Math.round(tax11 * 0.1) * 10;
            tax22 = Math.round(tax22 * 0.1) * 10;
            tax33 = Math.round(tax33 * 0.1) * 10;

            totTax = Math.round(totTax * 0.1) * 10;
            totTax2 = Math.round(totTax2 * 0.1) * 10;

            if(taxInsYnMonth == "2") {
            	if(tax2 == "0"){

            		tax1 = Math.floor(totMonS/taxInsYnMonth);
            		tax2 = Math.floor(totMonS/taxInsYnMonth);
            		tax11 = Math.floor(totMonJ/taxInsYnMonth);
            		tax22 = Math.floor(totMonJ/taxInsYnMonth);
            	}else{

            		tax1 = totMonS - tax2;
            		tax11 = totMonJ - tax22;
            	}

            } else if(taxInsYnMonth == "3") {
            	if(tax2 == "0" && tax3 == "0"){
            		tax1 = Math.floor(totMonS/taxInsYnMonth);
            		tax2 = Math.floor(totMonS/taxInsYnMonth);
            		tax3 = Math.floor(totMonS/taxInsYnMonth);
            		tax11 = Math.floor(totMonJ/taxInsYnMonth);
            		tax22 = Math.floor(totMonJ/taxInsYnMonth);
            		tax33 = Math.floor(totMonJ/taxInsYnMonth);
            	}else if(tax2 == "0" && tax3 != "0"){
            		tax1 = Math.floor((totMonS-tax3)/2);
            		tax2 = Math.floor((totMonS-tax3)/2);
            		tax11 = Math.floor((totMonJ-tax33)/2);
            		tax22 = Math.floor((totMonJ-tax33)/2);
            	}else if(tax2 != "0" && tax3 =="0"){
            		tax1 = Math.floor((totMonS-tax2)/2);
            		tax3 = Math.floor((totMonS-tax2)/2);
            		tax11 = Math.floor((totMonJ-tax22)/2);
            		tax33 = Math.floor((totMonJ-tax22)/2);
            	}else{
            		tax1 = totMonS - (tax2 + tax3);
            		tax11 = totMonJ - (tax22 + tax33);
            	}

            }

            if(totMonS <= 100000){
            	//alert("분납 금액을 확인하시기 바랍니다.");
            	sheet1.SetCellValue(Row, "tax_ins_mon_1", totMonS);
            	sheet1.SetCellValue(Row, "tax_ins_mon_11", totMonJ);
            	if(sheet1.ColSaveName(Col) == "tax_ins_mon_2") {
            	    sheet1.SetCellValue(Row, "tax_ins_mon_2", 0);
            	    sheet1.SetCellValue(Row, "tax_ins_mon_22", 0);
                } else if (sheet1.ColSaveName(Col) == "tax_ins_mon_3"||sheet1.ColSaveName(Col) == "tax_ins_mon_33") {
                	sheet1.SetCellValue(Row, "tax_ins_mon_3", 0);
                	sheet1.SetCellValue(Row, "tax_ins_mon_33", 0);
                }
            }else{
            	sheet1.SetCellValue(Row, "tax_ins_mon_1", tax1);
            	sheet1.SetCellValue(Row, "tax_ins_mon_2", tax2);
            	sheet1.SetCellValue(Row, "tax_ins_mon_3", tax3);
            	sheet1.SetCellValue(Row, "tax_ins_mon_11", tax11);
            	sheet1.SetCellValue(Row, "tax_ins_mon_22", tax22);
            	sheet1.SetCellValue(Row, "tax_ins_mon_33", tax33);
            }
        }

    	//계산 버튼을 눌러서 재계산을 하면서 플래그가 변경되어 있으면 다시 원복
    	if(!isProc) isProc = true;

	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="menuNm" name="menuNm" value="" />
	<div class="sheet_search outer">
		<div>
		<table>
			<tr>
				<td><span>년도</span>
				<%
				if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
				%>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				<%}else{%>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				<%}%>
				</td>
				<td><span>작업구분</span>
					<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
				</td>
                <td>
                    <span>사업장</span>
                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" onChange="javascript:doAction1('Search')" class="box"></select>
                </td>
			</tr>
			<tr>
                <td>
                    <span>원천징수세액</span>
                    <select id="searchTaxRate" name ="searchTaxRate" onChange="javascript:doAction1('Search')" class="box">
						<option value="" selected="selected">전체</option>
                    	<option value="80">80</option>
                    	<option value="100">100</option>
                    	<option value="120">120</option>
                    </select>
                </td>
                <td>
                    <span>신청여부</span>
                    <select id="searchTaxInsYn" name ="searchTaxInsYn" onChange="javascript:doAction1('Search')" class="box">
                    	<option value="" selected="selected">전체</option>
                    	<option value="Y">신청</option>
                    	<option value="N">미신청</option>
                    </select>
                </td>
                <td>
                    <span>개월수</span>
                    <select id="searchTaxInsYnMonth" name ="searchTaxInsYnMonth" onChange="javascript:doAction1('Search')" class="box">
                    	<option value="" selected="selected">전체</option>
                    	<option value="1">당월</option>
                    	<option value="2">2개월</option>
                    	<option value="3">3개월</option>
                    </select>
                </td>
				<td><span>사번/성명</span>
				<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> </td>
				<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
			</tr>
		</table>
		</div>
	</div>
	</form>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">원천징수세액/분납확인</li>
			<li class="btn">
				<font class='blue'>[요율 변경 신청자들은 별도 예외처리화면(ex.세율예외관리,맞춤형원천징수조정승인등)에 등록해야 합니다.]</font>
			    <a href="javascript:runTaxInsMonBtn()" class="basic btn-red ico-calc authR">계산</a>
			    <a href="javascript:doAction1('Save')" class="basic btn-save authR">저장</a>
				<a href="javascript:doAction1('Down2Excel')"	class="basic btn-download authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>