<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산 옵션</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");

	$(function() {
		$("#menuNm").val($(document).find("title").text());
		var arg = p.window.dialogArguments;
		var searchWorkYy 	  = "";
		var searchPayActionNm = "";
		var searchPayActionCd = "";
		var searchAdjustType  = "";
		var searchBizPlaceCd  = "";

		if( arg != undefined ) {
			$("#searchWorkYy").val(arg["searchWorkYy"]);
			$("#searchAdjustType").val(arg["searchAdjustType"]);
			$("#searchPayActionCd").val(arg["searchPayActionCd"]);
			$("#searchPayActionNm").val(arg["searchPayActionNm"]);
			$("#searchBizPlaceCd").val(arg["searchBizPlaceCd"]);
		}else{
			searchWorkYy 	  = p.popDialogArgument("searchWorkYy");
			searchPayActionNm = p.popDialogArgument("searchPayActionNm");
			searchPayActionCd = p.popDialogArgument("searchPayActionCd");
			searchAdjustType  = p.popDialogArgument("searchAdjustType");
			searchBizPlaceCd  = p.popDialogArgument("searchBizPlaceCd");

			$("#searchWorkYy").val(searchWorkYy);
			$("#searchAdjustType").val(searchAdjustType);
			$("#searchPayActionCd").val(searchPayActionCd);
			$("#searchPayActionNm").val(searchPayActionNm);
			$("#searchBizPlaceCd").val(searchBizPlaceCd);
		}

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
  			{Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
   			{Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
   			{Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
   			{Header:"workYy", 		Type:"Text",      Hidden:1,  Width:100,  Align:"Left",		ColMerge:0,   SaveName:"work_yy",  		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
   			{Header:"stdCd", 		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",		ColMerge:0,   SaveName:"std_cd",  		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"stdNm", 		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",		ColMerge:0,   SaveName:"std_nm",  		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"stdCdValue", 	Type:"Text",      Hidden:0,  Width:100,  Align:"Left",		ColMerge:0,   SaveName:"std_cd_value",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
        ]; IBS_InitSheet(sheet1, initdata1);  sheet1.SetEditable(false); sheet1.SetCountPosition(4);

		var payPeopleStatusList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00125"), "");
		var foreignTaxTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00170"), "");

		sheet1.SetColProperty("payPeopleStatus",    {ComboText:"|"+payPeopleStatusList[0], ComboCode:"|"+payPeopleStatusList[1]} );
		sheet1.SetColProperty("foreignTaxType",    {ComboText:"|"+foreignTaxTypeList[0], ComboCode:"|"+foreignTaxTypeList[1]} );

		$("#searchStdWorkYy").mask("1111");
		$("#searchStdWorkYy").val($("#searchWorkYy").val());

		$("#searchStdWorkYy").bind("keyup",function(event) {
			if (event.keyCode == 13) {
				doAction1("Search");
			}
		});


	    $(window).smartresize(sheetResize); sheetInit();

	    doAction1("Search");

	});

	$(function(){
	    $(".close").click(function() {
	    	p.self.close();
	    });
	});

	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search"://조회
			if($("#searchStdWorkYy").val() != $("#searchWorkYy").val()){
				sheet1.DoSearch( "<%=jspPath%>/yeaCalcCre/yeaCalcCreOptionPopupRst.jsp?cmd=selectYeaCalcCreOptionPopupBfList", $("#sheetForm").serialize() );
			}else{
				sheet1.DoSearch( "<%=jspPath%>/yeaCalcCre/yeaCalcCreOptionPopupRst.jsp?cmd=selectYeaCalcCreOptionPopupList", $("#sheetForm").serialize() );
			}

			break;
		case "Save"://저장
			sheet1.DoSave( "<%=jspPath%>/yeaCalcCre/yeaCalcCreOptionPopupRst.jsp?cmd=saveYeaCalcCreOptionPopup", $("#sheetForm").serialize(), "-1", 0);
			break;
		}
    }
	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			if(Code == 1) {
				shtToCtl() ;
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	//저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			if(Code == 1) {
			    doAction1("Search");
			    //return
		    	if(p.popReturnValue) p.popReturnValue("");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	//연말정산계산옵션 시트를 각 항목에 입력 :TSYS955
	function shtToCtl(){
		if(sheet1.RowCount() > 0){
			for (i = 1; i < sheet1.RowCount()+1; i++){
				var stdValue = sheet1.GetCellValue(i, "std_cd_value");
				if(sheet1.GetCellValue(i,"std_cd")=="CPN_MONPAY_RETRY_YN"){   //연간급여재생성 여부
					$("input:radio[name='cpn_monpay_return_yn']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_FAMILY"){   //연말정산가족사항추출
					$("input:radio[name='cpn_family_yn']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_RETRO_YN"){   //연말정산 총급여 합산시 소급포함 여부
					$("input:radio[name='cpn_yea_retro_yn']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_SIM_YN"){  //연말정산 개인 시뮬레이션 기능사용여부
					$("input:radio[name='cpn_yea_sim_yn']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_MON_SHOW_YN"){  //연말정산 총급여 확인 버튼 보여주기 유무
					$("input:radio[name='cpn_yea_mon_show_yn']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_WORK_INCOME_PRINT_BUTTON"){   //개인 원천징수영수증 출력버튼 표시여부
					$("input:radio[name='cpn_work_income_print_button']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_TAX_CUTVAL"){   //연말정산결정세액절사구분
					$("input:radio[name='cpn_tax_cutval_button']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_FEEDBACK_YN"){   //연말정산 피드백 버튼 보여주기 유무
					$("input:radio[name='cpn_yea_feedback_yn']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_PDF_YN"){   //PDF 업로드 사용 유무
					$("input:radio[name='cpn_yea_pdf_yn']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_DED_PRINT_YN"){   //연말정산 소득공제서 작성방법 출력여부
					$("input:radio[name='cpn_yea_ded_print_yn']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_DOJANG_TYPE"){   //원천징수영수증 도장 종류
					$("input:radio[name='cpn_yea_dojang_type']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_JINGSUJA_TYPE"){   //원천징수영수증 징수의무자 구분
					$("input:radio[name='cpn_yea_jingsuja_type']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_PAYTOT_YN"){   //연간소득 탭 사용 여부
					$("input:radio[name='cpn_yea_paytot_yn']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_PREWORK_YN"){   //종전근무지 탭 사용 여부
					$("input:radio[name='cpn_yea_prework_yn']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_PAYTAX_YN"){   //원천징수세액등 분납 신청사용 여부
					$("input:radio[name='cpn_yea_paytax_yn']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_PAYTAX_INS_YN"){   //원천징수세액등 조정 신청 사용 여부
					$("input:radio[name='cpn_yea_paytax_ins_yn']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_HOU_INFO_YN"){   //1주택 추가정보 사용 여부
					$("input:radio[name='cpn_yea_hou_info_yn']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_ADD_FILE_YN"){   //파일첨부탭 사용 여부
					$("input:radio[name='cpn_yea_add_file_yn']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="YEACALCLST_STAMP_YN"){   //파일첨부탭 사용 여부
					$("input:radio[name='yeacalclst_stamp_yn']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_PAY_STD_TYPE"){   // 연말정산 대상자 귀속일 기준
					$("input:radio[name='yeacalclst_emp_ymd_yn']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_SIGN_YN"){   // 소득공제서 전자서명 사용여부
					$("input:radio[name='cpn_yea_sign_yn']:input[value='"+stdValue+"']").prop("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_PDF_TYPE"){   // PDF 업로드 적용 방식
					$("input:radio[name='cpn_yea_pdf_type']:input[value='"+stdValue+"']").prop("checked",true);
				}
			}
			
			//당해년도 옵션만 저장 가능 20231201
			var isDisabled = ($("#searchStdWorkYy").val() == $("#searchWorkYy").val()) ? false: true;
			$("input:radio").prop("disabled",isDisabled);
		}
	}

	//연말정산 계산 옵션을 저장 시 , 시트에 해당 정보를 담는다.
	function setValue(){

		if($("#searchBizPlaceCd").val().length > 0){
			alert("옵션은 사업장별 선택 사항이 아닙니다.\n변경은 관리자만 할 수 있습니다.");
			return;
		}

		if(sheet1.RowCount() > 0){
			if($("#searchStdWorkYy").val() != $("#searchWorkYy").val()){
				alert("당해년도 옵션만 저장할 수 있습니다.\n기준년도를 확인해 주십시오.");
				return;
			}

			if(confirm("연말정산 옵션 내역을 저장하시겠습니까?")){
				for (i = 1; i < sheet1.RowCount()+1; i++){

					if(sheet1.GetCellValue(i,"std_cd")=="CPN_MONPAY_RETRY_YN"){   //연간급여재생성 여부
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_monpay_return_yn']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_FAMILY"){   //연말정산가족사항추출
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_family_yn']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_RETRO_YN"){   //연말정산 총급여 합산시 소급포함 여부
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_yea_retro_yn']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_SIM_YN"){   //연말정산 개인 시뮬레이션 기능사용여부
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_yea_sim_yn']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_MON_SHOW_YN"){   //연말정산 총급여 확인 버튼 보여주기 유무
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_yea_mon_show_yn']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_WORK_INCOME_PRINT_BUTTON"){   //개인 원천징수영수증 출력버튼 표시여부
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_work_income_print_button']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_TAX_CUTVAL"){   //연말정산결정세액절사구분
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_tax_cutval_button']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_FEEDBACK_YN"){   //연말정산 피드백 버튼 보여주기 유무
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_yea_feedback_yn']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_PDF_YN"){   //pdf 업로드 탭 보여주기 유무
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_yea_pdf_yn']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_DED_PRINT_YN"){   //연말정산 소득공제서 작성방법 출력여부
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_yea_ded_print_yn']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_DOJANG_TYPE"){   //원천징수영수증 도장 종류
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_yea_dojang_type']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_JINGSUJA_TYPE"){   //원천징수영수증 징수의무자 구분
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_yea_jingsuja_type']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_PAYTOT_YN"){   //연간소득 탭 사용 여부
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_yea_paytot_yn']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_PREWORK_YN"){   //종전근무지 탭 사용 여부
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_yea_prework_yn']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_PAYTAX_YN"){   //원천징수세액등 분납 신청사용 여부
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_yea_paytax_yn']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_PAYTAX_INS_YN"){   //원천징수세액등 조정 신청 사용 여부
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_yea_paytax_ins_yn']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_HOU_INFO_YN"){   //1주택 추가정보 사용 여부
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_yea_hou_info_yn']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_ADD_FILE_YN"){   //파일첨부탭 사용 여부
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_yea_add_file_yn']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="YEACALCLST_STAMP_YN"){   //계산내역 도장 출력 여부
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='yeacalclst_stamp_yn']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_PAY_STD_TYPE"){   // 연말정산 대상자 귀속일 기준
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='yeacalclst_emp_ymd_yn']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_SIGN_YN"){   // 소득공제서 전자서명 사용여부
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_yea_sign_yn']:checked").val());
					} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_PDF_TYPE"){   // PDF 업로드 적용 방식
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_yea_pdf_type']:checked").val());
					}
				}

				doAction1("Save");   //옵션 저장 수행
			}
		}
	}
</script>
</head>
<body class="bodywrap" style="overflow:scroll;">
<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
	<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
	<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="">
	<input type="hidden" id="searchBizPlaceCd" name="searchBizPlaceCd" value="">
	<input type="hidden" id="menuNm" name="menuNm" value="" />
	<div class="wrapper">
		<div class="popup_title">
		<ul>
			<li id="strTitle">연말정산 옵션</li>
			<!-- <li class="close"></li> -->
		</ul>
		</div>

		<div class="popup_main">
		<div>

			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
						<div class="sheet_title outer clearfix">
							<ul class="float-left">
								<li id="txt" class="txt">기준년도
									<input type="text" id="searchStdWorkYy" name="searchStdWorkYy" class="text center" value="" />
									<a href="javascript:doAction1('Search')" class="basic authA">조회</a>&nbsp;&nbsp;&nbsp;
									<font class="red">* 연말정산 옵션은 사업장별 관리가 아닌 공통 사항입니다.</font>
								</li>
							</ul>
							<ul class="float-right">
								<li class="txt"><a href="javascript:setValue();" class="basic btn-save">저장</a></li>
							</ul>
						</div>
					</td>
					</tr>
			</table>
			<table border="0" cellpadding="0" cellspacing="0" class="default outer line">
				<colgroup>
					<col width="90%" />
					<col width="" />
				</colgroup>
				<tr>
					<th class="left" colspan="2">연말정산 옵션 1</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">대상자 생성시 부양가족 정보 전년도 자료 활용 여부</b><br>
			            연말정산 대상자 생성시 부양가족 정보를 생성할 때 전년도 연말정산 데이터를 활용할 지 여부를 결정합니다. <br>
						관리자에게만 영향을 미치는 기능입니다.<br>
						YES : 전년 연말정산 부양가족 정보를 바탕으로 부양가족 정보를 생성합니다.<br>
						NO : 가족사항에 등록된 가족사항을 바탕으로 연말정산 부양가족 정보를 생성합니다.
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_family_yn" id="cpn_family_yn1" value = "-1" > <label for="cpn_family_yn1">YES</label><br>
						<input type="radio" class="radio" name="cpn_family_yn" id="cpn_family_yn2" value = "0" > <label for="cpn_family_yn2">NO</label>
					</td>
				</tr>
				<tr>
					<th class="left" colspan="2">연말정산 옵션 2</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">연간급여 집계시  총급여 재생성 여부</b><br>
			           	연간급여 집계시 기존 생성된 총급여를 삭제한 후 재성성할지 여부를 선택합니다. <br>
						관리자에게만 영향을 미치는 기능입니다.<br>
						YES : 기존 집계 및 수정한 연간소득관리 데이터가 삭제된 후 급여가 재집계됩니다.<br>
						NO : 연간소득관리_개인별에 데이터가 없는 인원만 집계됩니다.
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_monpay_return_yn" id="cpn_monpay_return_yn1" value = "Y" > <label for="cpn_monpay_return_yn1">YES</label><br>
						<input type="radio" class="radio" name="cpn_monpay_return_yn" id="cpn_monpay_return_yn2" value = "N" > <label for="cpn_monpay_return_yn2">NO</label>
					</td>
				</tr>
				<tr>
					<th class="left" colspan="2">연말정산 옵션 3</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">연말정산 총급여 합산시 소급포함 여부</b><br>
			            연간급여 집계시 소급분을 급여에 포함할지 여부를 결정합니다.  <br>
						소급 계산을 진행하는 회사에 한해 사용합니다.<br>
						YES : 소급을 e-HR 시스템에서 계산한 후, 급여에 포함하지 않고 별도로 개인들에게 지급했을 경우 선택합니다.<br>
						NO : 소급을 e-HR 시스템에서 계산한 후, 해당 금액을 급여에 포함시켰을 경우 선택합니다.
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_retro_yn" id="cpn_yea_retro_yn1" value = "Y" > <label for="cpn_yea_retro_yn1">YES</label><br>
						<input type="radio" class="radio" name="cpn_yea_retro_yn" id="cpn_yea_retro_yn2" value = "N" > <label for="cpn_yea_retro_yn2">NO</label>
					</td>
				</tr>
				<tr>
					<th class="left" colspan="2">연말정산 옵션 4</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">세금계산 개인시뮬레이션 기능 활성화 여부</b><br>
			            자료등록 메뉴에서 세금모의계산 탭의 활성화를 선택할 수 있습니다.  <br>
						세금모의계산은 임직원이 공제금액을 입력한 후 미리 세액을 계산해 볼 수 있는 기능으로, 최종 계산 결과와<br>
						그 값이 상이할 수 있습니다.<br>
						YES : 세금모의계산 탭이 활성화되어 미리 세액계산을 할 수 있습니다.<br>
						NO : 세금모의계산 탭이 비활성화되어 미리 세액계산을 할 수 없습니다.<br>
						관리자만 : 세금모의계산 탭이 (관리자) 화면에서만 활성화되어 미리 세액계산을 할 수 있습니다.
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_sim_yn" id="cpn_yea_sim_yn1" value = "Y" > <label for="cpn_yea_sim_yn1">YES</label><br>
						<input type="radio" class="radio" name="cpn_yea_sim_yn" id="cpn_yea_sim_yn2" value = "N" > <label for="cpn_yea_sim_yn2">NO</label><br>
						<input type="radio" class="radio" name="cpn_yea_sim_yn" id="cpn_yea_sim_yn3" value = "A" > <label for="cpn_yea_sim_yn3">관리자만</label>
					</td>
				</tr>
				<tr>
					<th class="left" colspan="2">연말정산 옵션 5</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">총급여 확인하는 버튼 존재 유무</b><br>
			            자료등록 메뉴에서 공제자료 등록시, 임직원 본인의 총급여 공제한도 금액을 미리 확인할 수 있는<br>
			            버튼 활성화를 선택할 수 있습니다.<br>
			            본인이 아닌 자가 대신 데이터 입력시, 임직원의 총급여를 오픈하고 싶지 않으실 때 활용할 수 있습니다. <br>
						YES : 총급여 확인버튼을 통해 임직원 개인의 총급여를 확인할 수 있습니다.<br>
						NO : 총급여 확인버튼이 비활성화 됩니다.<br>
						관리자만 : 총급여 확인버튼이 (관리자) 화면에서만 활성화되어 임직원 개인의 총급여를 확인할 수 있습니다.
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_mon_show_yn" id="cpn_yea_mon_show_yn1" value = "Y" > <label for="cpn_yea_mon_show_yn1">YES</label><br>
						<input type="radio" class="radio" name="cpn_yea_mon_show_yn" id="cpn_yea_mon_show_yn2" value = "N" > <label for="cpn_yea_mon_show_yn2">NO</label><br>
						<input type="radio" class="radio" name="cpn_yea_mon_show_yn" id="cpn_yea_mon_show_yn3" value = "A" > <label for="cpn_yea_mon_show_yn3">관리자만</label>
					</td>
				</tr>
				<tr>
					<th class="left" colspan="2">연말정산 옵션 6</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">원천징수영수증 개인 출력 가능 유무</b><br>
			            정산이 마감된 후 정산계산내역 화면의 원천징수영수증 출력 버튼의 활성화 여부를 선택할 수 있습니다.   <br>
						관리자 화면에는 영향을 미치지 않습니다.<br>
						YES : 원천징수영수증 출력버튼이 활성화되어 임직원이 원천징수영수증을 출력할 수 있습니다.<br>
						NO : 원천징수영수증 출력버튼이 비활성화되어 임직원이 원천징수영수증을 출력할 수 없습니다.
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_work_income_print_button" id="cpn_work_income_print_button1" value = "1" > <label for="cpn_work_income_print_button1">YES</label><br>
						<input type="radio" class="radio" name="cpn_work_income_print_button" id="cpn_work_income_print_button2" value = "0" > <label for="cpn_work_income_print_button2">NO</label>
					</td>
				</tr>
				<tr>
					<th class="left" colspan="2">연말정산 옵션 7</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">연말정산결정세액절사구분</b><br>
			            연말정산의 결정세액을 구할 때, 1원단위 절사 및 10원단위 절사 여부를 결정할 수 있습니다.   <br>
						1원 : 1원 단위 절사<br>
						10원 : 10원 단위 절사
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_tax_cutval_button" id="cpn_tax_cutval_button1" value = "0" > <label for="cpn_tax_cutval_button1">1원</label><br>
						<input type="radio" class="radio" name="cpn_tax_cutval_button" id="cpn_tax_cutval_button2" value = "-1" > <label for="cpn_tax_cutval_button2">10원</label>
					</td>
				</tr>
				<tr>
					<th class="left" colspan="2">연말정산 옵션 8</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">담당자 - 임직원 FeedBack 여부</b><br>
						자료등록(관리자) 메뉴에서 담당자는 서류미비 사항 등에 대한 안내사항(FeedBack)을 입력할 수 있습니다.<br>
						이 안내사항(FeedBack)을 개인들에게 오픈할지 여부를 결정할 수 있습니다.<br>
						YES : 담당자가 입력한 안내사항(FeedBack)이 임직원에게 오픈됩니다.<br>
						NO  : 임직원이 담당자가 입력한 안내사항(FeedBack)을 볼 수 없습니다.<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_feedback_yn" id="cpn_yea_feedback_yn1" value = "Y" > <label for="cpn_yea_feedback_yn1">YES</label><br>
						<input type="radio" class="radio" name="cpn_yea_feedback_yn" id="cpn_yea_feedback_yn2" value = "N" > <label for="cpn_yea_feedback_yn2">NO</label>
					</td>
				</tr>
				<tr>
					<th class="left" colspan="2">연말정산 옵션 9</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">PDF 업로드 사용 유무</b><br>
						자료등록 메뉴에서 PDF 업로드 탭 사용 유무를 선택할 수 있습니다.(자료등록(관리자)에는 영향을 미치지 않습니다.)<br>
						YES : PDF 업로드 탭을 오픈하여 사용합니다.<br>
						NO : PDF 업로드 탭을 숨깁니다.<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_pdf_yn" id="cpn_yea_pdf_yn1" value = "Y" > <label for="cpn_yea_pdf_yn1">YES</label><br>
						<input type="radio" class="radio" name="cpn_yea_pdf_yn" id="cpn_yea_pdf_yn2" value = "N" > <label for="cpn_yea_pdf_yn2">NO</label>
					</td>
				</tr>
				<tr>
					<th class="left" colspan="2">연말정산 옵션 10</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">연말정산 소득공제서 작성방법 출력여부</b><br>
						소득/세액공제신고서에서 작성방법 페이지 출력 여부를 선택할 수 있습니다.<br>
						YES : 작성방법 페이지를 출력합니다.<br>
						NO : 작성방법 페이지를 출력하지 않습니다.<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_ded_print_yn" id="cpn_yea_ded_print_yn1" value = "Y" > <label for="cpn_yea_ded_print_yn1">YES</label><br>
						<input type="radio" class="radio" name="cpn_yea_ded_print_yn" id="cpn_yea_ded_print_yn2" value = "N" > <label for="cpn_yea_ded_print_yn2">NO</label>
					</td>
				</tr>
				<tr>
					<th class="left" colspan="2">연말정산 옵션 11</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">원천징수영수증 도장 종류</b><br>
						원천징수영수증에 찍히는 도장의 종류를 선택할 수 있습니다.(도장은 조직관리의 법인이미지관리 메뉴에서 확인하시기 바랍니다.)<br>
						2 : 증명서 담당<br>
						5 : 회사 인장<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_dojang_type" id="cpn_yea_dojang_type1" value = "2" > <label for="cpn_yea_dojang_type1">2</label><br>
						<input type="radio" class="radio" name="cpn_yea_dojang_type" id="cpn_yea_dojang_type2" value = "5" > <label for="cpn_yea_dojang_type2">5</label>
					</td>
				</tr>
				<tr>
					<th class="left" colspan="2">연말정산 옵션 12</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">원천징수영수증 징수의무자 구분</b><br>
						원천징수영수증에 표기되는 징수(보고)의무자를 선택할 수 있습니다.<br>
						C : 회사명<br>
						P : 대표자명<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_jingsuja_type" id="cpn_yea_jingsuja_type1" value = "C" > <label for="cpn_yea_jingsuja_type1">C</label><br>
						<input type="radio" class="radio" name="cpn_yea_jingsuja_type" id="cpn_yea_jingsuja_type2" value = "P" > <label for="cpn_yea_jingsuja_type2">P</label>
					</td>
				</tr>
				<tr>
					<th class="left" colspan="2">연말정산 옵션 13</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">연간소득 탭 사용 여부</b><br>
						자료등록 메뉴에서 연간소득 탭 사용 유무를 선택할 수 있습니다.(자료등록(관리자)에는 영향을 미치지 않습니다.)<br>
						YES : 연간소득 탭을 오픈하여 사용합니다.<br>
						NO : 연간소득 탭을 숨깁니다.<br>
						관리자만 : 연간소득 탭이 (관리자) 화면에서만 활성화되어 임직원 개인의 연간소득을 확인할 수 있습니다.
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_paytot_yn" id="cpn_yea_paytot_yn1" value = "Y" > <label for="cpn_yea_paytot_yn1">YES</label><br>
						<input type="radio" class="radio" name="cpn_yea_paytot_yn" id="cpn_yea_paytot_yn2" value = "N" > <label for="cpn_yea_paytot_yn2">NO</label><br/>
						<input type="radio" class="radio" name="cpn_yea_paytot_yn" id="cpn_yea_paytot_yn3" value = "A" > <label for="cpn_yea_paytot_yn3">관리자만</label>
					</td>
				</tr>

				<tr>
					<th class="left" colspan="2">연말정산 옵션 14</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">종전근무지 탭 사용 여부</b><br>
						자료등록 메뉴에서 종전근무지 탭 사용 유무를 선택할 수 있습니다.(자료등록(관리자)에는 영향을 미치지 않습니다.)<br>
						YES : 종전근무지 탭을 오픈하여 사용합니다.<br>
						NO : 종전근무지 탭을 숨깁니다.<br>
						관리자만 : 종전근무지 탭이 (관리자) 화면에서만 활성화되어  임직원 개인의 종전근무지 내역을 확인할 수 있습니다.
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_prework_yn" id="cpn_yea_prework_yn1" value = "Y" > <label for="cpn_yea_prework_yn1">YES</label><br>
						<input type="radio" class="radio" name="cpn_yea_prework_yn" id="cpn_yea_prework_yn2" value = "N" > <label for="cpn_yea_prework_yn2">NO</label><br/>
						<input type="radio" class="radio" name="cpn_yea_prework_yn" id="cpn_yea_prework_yn3" value = "A" > <label for="cpn_yea_prework_yn3">관리자만</label>
					</td>
				</tr>

				<tr>
					<th class="left" colspan="2">연말정산 옵션 15</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">원천징수세액등 분납 신청 사용 여부</b><br>
						자료등록 기본_주소사항 탭에서 원천징수세액등 분납 신청 사용 유무를 선택할 수 있습니다.(자료등록(관리자)에는 영향을 미치지 않습니다.)<br>
						YES : 원천징수세액등 분납 신청을 오픈하여 사용합니다.<br>
						NO : 원천징수세액등 분납 신청을 숨깁니다.<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_paytax_yn" id="cpn_yea_paytax_yn1" value = "Y" > <label for="cpn_yea_paytax_yn1">YES</label><br>
						<input type="radio" class="radio" name="cpn_yea_paytax_yn" id="cpn_yea_paytax_yn2" value = "N" > <label for="cpn_yea_paytax_yn2">NO</label>
					</td>
				</tr>

				<tr>
					<th class="left" colspan="2">연말정산 옵션 16</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">원천징수세액등 조정 신청 사용 여부</b><br>
						자료등록 기본_주소사항 탭에서 원천징수세액등 조정 신청 사용 유무를 선택할 수 있습니다.(자료등록(관리자)에는 영향을 미치지 않습니다.)<br>
						YES : 원천징수세액등 조정 신청을 오픈하여 사용합니다.<br>
						NO : 원천징수세액등 조정 신청을 숨깁니다.<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_paytax_ins_yn" id="cpn_yea_paytax_ins_yn1" value = "Y" > <label for="cpn_yea_paytax_ins_yn1">YES</label><br>
						<input type="radio" class="radio" name="cpn_yea_paytax_ins_yn" id="cpn_yea_paytax_ins_yn2" value = "N" > <label for="cpn_yea_paytax_ins_yn2">NO</label>
					</td>
				</tr>
				<tr>
					<th class="left" colspan="2">연말정산 옵션 17</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">1주택 추가정보 사용 여부</b><br>
						자료등록 기본_주소사항 탭에서 1주택 선택시 추가 정보 입력 옵션을 사용할 수 있습니다.<br/>
						YES : 1주택 선택시 주택취득일자, 주택전용면적, 주택공시지가 정보를 입력할 수 있습니다.<br>
						NO : 1주택 선택시 추가 입력 필드를 숨깁니다.<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_hou_info_yn" id="cpn_yea_hou_info_yn1" value = "Y" > <label for="cpn_yea_hou_info_yn1">YES</label><br>
						<input type="radio" class="radio" name="cpn_yea_hou_info_yn" id="cpn_yea_hou_info_yn2" value = "N" > <label for="cpn_yea_hou_info_yn2">NO</label>
					</td>
				</tr>
				<tr>
					<th class="left" colspan="2">연말정산 옵션 18</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">증빙자료탭 기능 사용 여부</b><br>
						자료등록 증빙자료 탭에서 별도 파일등록 기능을 사용할 수 있습니다.(자료등록(관리자)에는 영향을 미치지 않습니다.)<br/>
						YES : 증빙자료 탭을 오픈하여 사용합니다.<br>
						NO : 증빙자료 탭을 숨깁니다.<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_add_file_yn" id="cpn_yea_add_file_yn1" value = "Y" > <label for="cpn_yea_add_file_yn1">YES</label><br>
						<input type="radio" class="radio" name="cpn_yea_add_file_yn" id="cpn_yea_add_file_yn2" value = "N" > <label for="cpn_yea_add_file_yn2">NO</label>
					</td>
				</tr>
				<tr>
					<th class="left" colspan="2">연말정산 옵션 19</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">계산내역 도장 출력 여부</b><br>
						계산내역 출력 화면에서 도장 출력 여부를 선택할 수 있습니다.(계산내역(관리자)에는 영향을 미치지 않습니다.)<br/>
						YES : 도장을 출력합니다.<br>
						NO : 도장을 출력하지 않습니다.<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="yeacalclst_stamp_yn" id="yeacalclst_stamp_yn1" value = "Y" > <label for="yeacalclst_stamp_yn1">YES</label><br>
						<input type="radio" class="radio" name="yeacalclst_stamp_yn" id="yeacalclst_stamp_yn2" value = "N" > <label for="yeacalclst_stamp_yn2">NO</label>
					</td>
				</tr>
				
				<tr>
					<th class="left" colspan="2">연말정산 옵션 20</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">연말정산 대상자 귀속일 기준</b><br>
						연말정산 귀속일 기준을 선택할 수 있습니다.(연말정산계산 화면 내 대상자 관리 영역에서 입사일 기준 선택항목과 동일합니다.)<br/>
						입사일 또는 그룹입사일 기준 변경 시 대상자 전체 삭제 후 대상자 생성 또는 대상자 관리 팝업에서 변경 바랍니다.<br>
						E : 입사일 기준<br>
						G : 그룹입사일 기준<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="yeacalclst_emp_ymd_yn" id="yeacalclst_emp_ymd_yn1" value = "E" > <label for="yeacalclst_emp_ymd_yn1">E</label><br>
						<input type="radio" class="radio" name="yeacalclst_emp_ymd_yn" id="yeacalclst_emp_ymd_yn2" value = "G" > <label for="yeacalclst_emp_ymd_yn2">G</label>
					</td>
				</tr>
				<tr>
					<th class="left" colspan="2">연말정산 옵션 21</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">연말정산 소득공제서 전자 서명 사용 여부</b><br>
						자료등록 출력 화면에서 전자 서명 사용 여부를 선택할 수 있습니다.<br/>
						YES : 전자 서명을 사용합니다.<br>
						NO : 전자 서명을 사용하지 않습니다.<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_sign_yn" id="cpn_yea_sign_yn1" value = "Y" > <label for="cpn_yea_sign_yn1">YES</label><br>
						<input type="radio" class="radio" name="cpn_yea_sign_yn" id="cpn_yea_sign_yn2" value = "N" > <label for="cpn_yea_sign_yn2">NO</label>
					</td>
				</tr>
				<tr>
					<th class="left" colspan="2">연말정산 옵션 22</th>
				</tr>
				<tr>
					<td class="left">
						<b class="table-title">PDF 파일 업로드 적용 방식</b><br>
						PDF 파일 기 업로드 후 재업로드 할때 파일 적용방식을 선택할 수 있습니다.<br/>
						D : PDF파일 업로드시 기존 자료 전체를 삭제 후 새로 적용(수기 입력 데이터 제외) <br>
						M : PDF파일 업로드시 파일 내에 포함된 대상자의 기존 자료 전체를 삭제 후 새로 적용(수기 입력 데이터 제외)
						  , 그 외 대상자의 자료는 보존<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_pdf_type" id="cpn_yea_pdf_type_yn1" value = "D" > <label for="cpn_yea_pdf_type_yn1">D</label><br>
						<input type="radio" class="radio" name="cpn_yea_pdf_type" id="cpn_yea_pdf_type_yn2" value = "M" > <label for="cpn_yea_pdf_type_yn2">M</label>
					</td>
				</tr>
			</table>
		</div>
		<!-- <div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:setValue();" class="pink large">저장</a>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
		</div> -->
		<div class="hide">
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100px"); </script>
		</div>
		</div>
	</div>
</form>
</body>
</html>



