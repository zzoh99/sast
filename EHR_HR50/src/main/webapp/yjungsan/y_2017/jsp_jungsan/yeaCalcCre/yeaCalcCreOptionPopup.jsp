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
		
		var arg = p.window.dialogArguments;
		
		if( arg != undefined ) {
			$("#searchWorkYy").val(arg["searchWorkYy"]);   		
			$("#searchAdjustType").val(arg["searchAdjustType"]);
			$("#searchPayActionCd").val(arg["searchPayActionCd"]);   		
			$("#searchPayActionNm").val(arg["searchPayActionNm"]);   
		}else{
			var searchWorkYy 	  = "";
			var searchPayActionNm = "";
			var searchPayActionCd = "";
			var searchAdjustType  = "";
			
			searchWorkYy 	  = p.popDialogArgument("searchWorkYy");
			searchPayActionNm = p.popDialogArgument("searchPayActionNm");
			searchPayActionCd = p.popDialogArgument("searchPayActionCd");
			searchAdjustType  = p.popDialogArgument("searchAdjustType");
			
			$("#searchWorkYy").val(searchWorkYy);   		
			$("#searchAdjustType").val(searchAdjustType);
			$("#searchPayActionCd").val(searchPayActionCd);   		
			$("#searchPayActionNm").val(searchPayActionNm);
		}
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};                                                                                                                                                                                              
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};                                                                                                                                                                          
		initdata1.Cols = [                                                                                                                                                                                                                            
  			{Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
   			{Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},    
   			{Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},    
            {Header:"stdCd", 		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",		ColMerge:0,   SaveName:"std_cd",  		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"stdNm", 		Type:"Text",      Hidden:0,  Width:100,  Align:"Left",		ColMerge:0,   SaveName:"std_nm",  		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"stdCdValue", 	Type:"Text",      Hidden:0,  Width:100,  Align:"Left",		ColMerge:0,   SaveName:"std_cd_value",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
        ]; IBS_InitSheet(sheet1, initdata1);  sheet1.SetEditable(false); sheet1.SetCountPosition(4);
        
		var payPeopleStatusList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00125"), "");
		var foreignTaxTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00170"), "");
        
		sheet1.SetColProperty("payPeopleStatus",    {ComboText:"|"+payPeopleStatusList[0], ComboCode:"|"+payPeopleStatusList[1]} );
		sheet1.SetColProperty("foreignTaxType",    {ComboText:"|"+foreignTaxTypeList[0], ComboCode:"|"+foreignTaxTypeList[1]} );
		
		
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
			sheet1.DoSearch( "<%=jspPath%>/yeaCalcCre/yeaCalcCreOptionPopupRst.jsp?cmd=selectYeaCalcCreOptionPopupList", $("#sheetForm").serialize() );
			break;
		case "Save"://저장
			sheet1.DoSave( "<%=jspPath%>/yeaCalcCre/yeaCalcCreOptionPopupRst.jsp?cmd=saveYeaCalcCreOptionPopup", "", "-1", 0); 
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
					$("input:radio[name='cpn_monpay_return_yn']:input[value='"+stdValue+"']").attr("checked",true);						
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_FAMILY"){   //연말정산가족사항추출
					$("input:radio[name='cpn_family_yn']:input[value='"+stdValue+"']").attr("checked",true);						
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_RETRO_YN"){   //연말정산 총급여 합산시 소급포함 여부
					$("input:radio[name='cpn_yea_retro_yn']:input[value='"+stdValue+"']").attr("checked",true);						
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_SIM_YN"){  //연말정산 개인 시뮬레이션 기능사용여부
					$("input:radio[name='cpn_yea_sim_yn']:input[value='"+stdValue+"']").attr("checked",true);						
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_MON_SHOW_YN"){  //연말정산 총급여 확인 버튼 보여주기 유무
					$("input:radio[name='cpn_yea_mon_show_yn']:input[value='"+stdValue+"']").attr("checked",true);						
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_WORK_INCOME_PRINT_BUTTON"){   //개인 원천징수영수증 출력버튼 표시여부
					$("input:radio[name='cpn_income_print_button']:input[value='"+stdValue+"']").attr("checked",true);						
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_TAX_CUTVAL"){   //연말정산결정세액절사구분
					$("input:radio[name='cpn_tax_cutval_button']:input[value='"+stdValue+"']").attr("checked",true);						
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_FEEDBACK_YN"){   //연말정산 피드백 버튼 보여주기 유무
					$("input:radio[name='cpn_yea_feedback_yn']:input[value='"+stdValue+"']").attr("checked",true);						
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_PDF_YN"){   //PDF 업로드 사용 유무
					$("input:radio[name='cpn_yea_pdf_yn']:input[value='"+stdValue+"']").attr("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_DED_PRINT_YN"){   //연말정산 소득공제서 작성방법 출력여부
					$("input:radio[name='cpn_yea_ded_print_yn']:input[value='"+stdValue+"']").attr("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_DOJANG_TYPE"){   //원천징수영수증 도장 종류
					$("input:radio[name='cpn_yea_dojang_type']:input[value='"+stdValue+"']").attr("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_JINGSUJA_TYPE"){   //원천징수영수증 징수의무자 구분
					$("input:radio[name='cpn_yea_jingsuja_type']:input[value='"+stdValue+"']").attr("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_PAYTOT_YN"){   //연간소득 탭 사용 여부
					$("input:radio[name='cpn_yea_paytot_yn']:input[value='"+stdValue+"']").attr("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_PREWORK_YN"){   //종전근무지 탭 사용 여부
					$("input:radio[name='cpn_yea_prework_yn']:input[value='"+stdValue+"']").attr("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_PAYTAX_YN"){   //원천징수세액등 분납 신청사용 여부
					$("input:radio[name='cpn_yea_paytax_yn']:input[value='"+stdValue+"']").attr("checked",true);
				} else if(sheet1.GetCellValue(i,"std_cd")=="CPN_YEA_PAYTAX_INS_YN"){   //원천징수세액등 조정 신청 사용 여부
					$("input:radio[name='cpn_yea_paytax_ins_yn']:input[value='"+stdValue+"']").attr("checked",true);
				} 
			}			
		}		 
	}
	
	//연말정산 계산 옵션을 저장 시 , 시트에 해당 정보를 담는다.
	function setValue(){
		if(sheet1.RowCount() > 0){
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
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_income_print_button']:checked").val());
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
</form>
	
	<div class="wrapper">
		<div class="popup_title">
		<ul>
			<li id="strTitle">연말정산 옵션</li>
			<!-- <li class="close"></li> -->
		</ul>
		</div>
	
		<div class="popup_main">
		<div>
			<table border="0" cellpadding="0" cellspacing="0" class="default outer">
				<colgroup>
					<col width="90%" />
					<col width="" />
				</colgroup>
				<tr>
					<th class="left" colspan="2"> [연말정산 옵션 1] </th>
				</tr>
				<tr>
					<td class="left">
						<b>[대상자 생성시 부양가족 정보 전년도 자료 활용 여부]</b><br>
			            &nbsp;연말정산 대상자 생성시 부양가족 정보를 생성할 때 전년도 연말정산 데이터를 활용할 지 여부를 결정합니다. <br>
						&nbsp;관리자에게만 영향을 미치는 기능입니다.<br>
						&nbsp;YES : 전년 연말정산 부양가족 정보를 바탕으로 부양가족 정보를 생성합니다.<br>
						&nbsp;NO : 가족사항에 등록된 가족사항을 바탕으로 연말정산 부양가족 정보를 생성합니다.
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_family_yn" value = "-1" >YES&nbsp;&nbsp;&nbsp;<br> 
						<input type="radio" class="radio" name="cpn_family_yn" value = "0" >NO	            
					</td>		
				</tr>
				<tr>
					<th class="left" colspan="2"> [연말정산 옵션 2] </th>
				</tr>
				<tr>
					<td class="left">
						<b>[연간급여 집계시  총급여 재생성 여부]</b><br>
			           	&nbsp;연간급여 집계시 기존 생성된 총급여를 삭제한 후 재성성할지 여부를 선택합니다. <br>
						&nbsp;관리자에게만 영향을 미치는 기능입니다.<br>
						&nbsp;YES : 기존 집계 및 수정한 연간소득관리 데이터가 삭제된 후 급여가 재집계됩니다.<br>
						&nbsp;NO : 연간소득관리_개인별에 데이터가 없는 인원만 집계됩니다.	
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_monpay_return_yn" value = "Y" >YES&nbsp;&nbsp;&nbsp;<br>    
						<input type="radio" class="radio" name="cpn_monpay_return_yn" value = "N" >NO      
					</td>		
				</tr>
				<tr>
					<th class="left" colspan="2"> [연말정산 옵션 3] </th>
				</tr>
				<tr>
					<td class="left">
						<b>[연말정산 총급여 합산시 소급포함 여부]</b><br>
			            &nbsp;연간급여 집계시 소급분을 급여에 포함할지 여부를 결정합니다.  <br>
						&nbsp;소급 계산을 진행하는 회사에 한해 사용합니다.<br>
						&nbsp;YES : 소급을 e-HR 시스템에서 계산한 후, 급여에 포함하지 않고 별도로 개인들에게 지급했을 경우 선택합니다.<br>
						&nbsp;NO : 소급을 e-HR 시스템에서 계산한 후, 해당 금액을 급여에 포함시켰을 경우 선택합니다.			
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_retro_yn" value = "Y" >YES&nbsp;&nbsp;&nbsp;<br>    
						<input type="radio" class="radio" name="cpn_yea_retro_yn" value = "N" >NO	       
					</td>		
				</tr>
				<tr>
					<th class="left" colspan="2"> [연말정산 옵션 4] </th>
				</tr>
				<tr>
					<td class="left">
						<b>[세금계산 개인시뮬레이션 기능 활성화 여부]</b><br>
			            &nbsp;자료등록 메뉴에서 세액계산 버튼 및 결과보기 버튼의 활성화를 선택할 수 있습니다.  <br>
						&nbsp;세액계산 / 결과보기는 임직원이 공제금액을 입력한 후 미리 세액을 계산해 볼 수 있는 기능으로, 최종 계산 결과와<br>
						&nbsp;그 값이 상이할 수 있습니다.<br>
						&nbsp;YES : 세액계산 및 결과보기 버튼이 활성화되어 미리 세액계산을 할 수 있습니다.<br>
						&nbsp;NO : 세액계산 및 결과보기 버튼이 비활성화되어 미리 세액계산을 할 수 없습니다.<br>
						&nbsp;관리자만 : 세액계산 및 결과보기 버튼이 (관리자) 화면에서만 활성화되어 미리 세액계산을 할 수 있습니다.	
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_sim_yn" value = "Y" >YES&nbsp;&nbsp;&nbsp;<br>    
						<input type="radio" class="radio" name="cpn_yea_sim_yn" value = "N" >NO&nbsp;&nbsp;&nbsp;<br>
						<input type="radio" class="radio" name="cpn_yea_sim_yn" value = "A" >관리자만
					</td>		
				</tr>
				<tr>
					<th class="left" colspan="2"> [연말정산 옵션 5] </th>
				</tr>
				<tr>
					<td class="left">
						<b>[총급여 확인하는 버튼 존재 유무]</b><br>
			            &nbsp;자료등록 메뉴에서 공제자료 등록시, 임직원 본인의 총급여 공제한도 금액을 미리 확인할 수 있는<br>
			            &nbsp;버튼 활성화를 선택할 수 있습니다.<br>
			            &nbsp;본인이 아닌 자가 대신 데이터 입력시, 임직원의 총급여를 오픈하고 싶지 않으실 때 활용할 수 있습니다. <br>
						&nbsp;YES : 총급여 확인버튼을 통해 임직원 개인의 총급여를 확인할 수 있습니다.<br>
						&nbsp;NO  : 총급여 확인버튼이 비활성화 됩니다.<br>
						&nbsp;관리자만  : 총급여 확인버튼이 (관리자) 화면에서만 활성화되어  임직원 개인의 총급여를 확인할 수 있습니다.
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_mon_show_yn" value = "Y" >YES&nbsp;&nbsp;&nbsp;<br>   
						<input type="radio" class="radio" name="cpn_yea_mon_show_yn" value = "N" >NO&nbsp;&nbsp;&nbsp;<br>
						<input type="radio" class="radio" name="cpn_yea_mon_show_yn" value = "A" >관리자만
					</td>		
				</tr>
				<tr>
					<th class="left" colspan="2"> [연말정산 옵션 6] </th>
				</tr>
				<tr>
					<td class="left">
						<b>[원천징수영수증 개인 출력 가능 유무]</b><br>
			            &nbsp;정산이 마감된 후 정산계산내역 화면의 원천징수영수증 출력 버튼의 활성화 여부를 선택할 수 있습니다.   <br>
						&nbsp;관리자 화면에는 영향을 미치지 않습니다.<br>
						&nbsp;YES : 원천징수영수증 출력버튼이 활성화되어 임직원이 원천징수영수증을 출력할 수 있습니다.<br>
						&nbsp;NO : 원천징수영수증 출력버튼이 비활성화되어 임직원이 원천징수영수증을 출력할 수 없습니다.
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_income_print_button" value = "1" >YES&nbsp;&nbsp;&nbsp;<br>    
						<input type="radio" class="radio" name="cpn_income_print_button" value = "0" >NO
					</td>		
				</tr>
				<tr>
					<th class="left" colspan="2"> [연말정산 옵션 7] </th>
				</tr>
				<tr>
					<td class="left">
						<b>[연말정산결정세액절사구분]</b><br>
			            &nbsp;연말정산의 결정세액을 구할 때, 1원단위 절사 및 10원단위 절사 여부를 결정할 수 있습니다.   <br>
						&nbsp;1원 : 1원 단위 절사<br>
						&nbsp;10원 : 10원 단위 절사
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_tax_cutval_button" value = "0" >  1원&nbsp;&nbsp;&nbsp;<br>      
						<input type="radio" class="radio" name="cpn_tax_cutval_button" value = "-1" >10원
					</td>		
				</tr>
				<tr>
					<th class="left" colspan="2"> [연말정산 옵션 8] </th>
				</tr>
				<tr>
					<td class="left">
						<b>[담당자 - 임직원 FeedBack 여부]</b><br>
						&nbsp;자료등록(관리자) 메뉴에서 담당자는 서류미비 사항 등에 대한 안내사항(FeedBack)을 입력할 수 있습니다.<br>
						&nbsp;이 안내사항(FeedBack)을 개인들에게 오픈할지 여부를 결정할 수 있습니다.<br>
						&nbsp;YES : 담당자가 입력한 안내사항(FeedBack)이 임직원에게 오픈됩니다.<br>
						&nbsp;NO  : 임직원이 담당자가 입력한 안내사항(FeedBack)을 볼 수 없습니다.<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_feedback_yn" value = "Y" >YES&nbsp;&nbsp;&nbsp;<br>   
						<input type="radio" class="radio" name="cpn_yea_feedback_yn" value = "N" >NO
					</td>		
				</tr>
				<tr>
					<th class="left" colspan="2"> [연말정산 옵션 9] </th>
				</tr>
				<tr>
					<td class="left">
						<b>[PDF 업로드 사용 유무]</b><br>
						&nbsp;자료등록 메뉴에서 PDF 업로드 탭 사용 유무를 선택할 수 있습니다.(자료등록(관리자)에는 영향을 미치지 않습니다.)<br>
						&nbsp;YES : PDF 업로드 탭을 오픈하여 사용합니다.<br>
						&nbsp;NO : PDF 업로드 탭을 숨깁니다.<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_pdf_yn" value = "Y" >YES&nbsp;&nbsp;&nbsp;<br>   
						<input type="radio" class="radio" name="cpn_yea_pdf_yn" value = "N" >NO
					</td>		
				</tr>
				<tr>
					<th class="left" colspan="2"> [연말정산 옵션 10] </th>
				</tr>
				<tr>
					<td class="left">
						<b>[연말정산 소득공제서 작성방법 출력여부]</b><br>
						&nbsp;소득/세액공제신고서에서 작성방법 페이지 출력 여부를 선택할 수 있습니다.<br>
						&nbsp;YES : 작성방법 페이지를 출력합니다.<br>
						&nbsp;NO : 작성방법 페이지를 출력하지 않습니다.<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_ded_print_yn" value = "Y" >YES&nbsp;&nbsp;&nbsp;<br>   
						<input type="radio" class="radio" name="cpn_yea_ded_print_yn" value = "N" >NO
					</td>		
				</tr>
				<tr>
					<th class="left" colspan="2"> [연말정산 옵션 11] </th>
				</tr>
				<tr>
					<td class="left">
						<b>[원천징수영수증 도장 종류]</b><br>
						&nbsp;원천징수영수증에 찍히는 도장의 종류를 선택할 수 있습니다.(도장은 조직관리의 법인이미지관리 메뉴에서 확인하시기 바랍니다.)<br>
						&nbsp;2 : 증명서 담당<br>
						&nbsp;5 : 회사 인장<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_dojang_type" value = "2" >2&nbsp;&nbsp;&nbsp;<br>   
						<input type="radio" class="radio" name="cpn_yea_dojang_type" value = "5" >5
					</td>		
				</tr>
				<tr>
					<th class="left" colspan="2"> [연말정산 옵션 12] </th>
				</tr>
				<tr>
					<td class="left">
						<b>[원천징수영수증 징수의무자 구분]</b><br>
						&nbsp;원천징수영수증에 표기되는 징수(보고)의무자를 선택할 수 있습니다.<br>
						&nbsp;C : 회사명<br>
						&nbsp;P : 대표자명<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_jingsuja_type" value = "C" >C&nbsp;&nbsp;&nbsp;<br>   
						<input type="radio" class="radio" name="cpn_yea_jingsuja_type" value = "P" >P
					</td>		
				</tr>
				<tr>
					<th class="left" colspan="2"> [연말정산 옵션 13] </th>
				</tr>
				<tr>
					<td class="left">
						<b>[연간소득 탭 사용 여부]</b><br>
						&nbsp;자료등록 메뉴에서 연간소득 탭 사용 유무를 선택할 수 있습니다.(자료등록(관리자)에는 영향을 미치지 않습니다.)<br>
						&nbsp;YES : 연간소득 탭을 오픈하여 사용합니다.<br>
						&nbsp;NO : 연간소득 탭을 숨깁니다.<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_paytot_yn" value = "Y" >YES&nbsp;&nbsp;&nbsp;<br>   
						<input type="radio" class="radio" name="cpn_yea_paytot_yn" value = "N" >NO
					</td>		
				</tr>
				
				<tr>
					<th class="left" colspan="2"> [연말정산 옵션 14] </th>
				</tr>
				<tr>
					<td class="left">
						<b>[종전근무지 탭 사용 여부]</b><br>
						&nbsp;자료등록 메뉴에서 종전근무지 탭 사용 유무를 선택할 수 있습니다.(자료등록(관리자)에는 영향을 미치지 않습니다.)<br>
						&nbsp;YES : 종전근무지 탭을 오픈하여 사용합니다.<br>
						&nbsp;NO : 종전근무지 탭을 숨깁니다.<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_prework_yn" value = "Y" >YES&nbsp;&nbsp;&nbsp;<br>   
						<input type="radio" class="radio" name="cpn_yea_prework_yn" value = "N" >NO
					</td>		
				</tr>
				
				<tr>
					<th class="left" colspan="2"> [연말정산 옵션 15] </th>
				</tr>
				<tr>
					<td class="left">
						<b>[원천징수세액등 분납 신청 사용 여부]</b><br>
						&nbsp;자료등록 기본_주소사항 탭에서 원천징수세액등 분납 신청 사용 유무를 선택할 수 있습니다.(자료등록(관리자)에는 영향을 미치지 않습니다.)<br>
						&nbsp;YES : 원천징수세액등 분납 신청을 오픈하여 사용합니다.<br>
						&nbsp;NO : 원천징수세액등 분납 신청을 숨깁니다.<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_paytax_yn" value = "Y" >YES&nbsp;&nbsp;&nbsp;<br>   
						<input type="radio" class="radio" name="cpn_yea_paytax_yn" value = "N" >NO
					</td>		
				</tr>
				
				<tr>
					<th class="left" colspan="2"> [연말정산 옵션 16] </th>
				</tr>
				<tr>
					<td class="left">
						<b>[원천징수세액등 조정 신청 사용 여부]</b><br>
						&nbsp;자료등록 기본_주소사항 탭에서 원천징수세액등 조정 신청 사용 유무를 선택할 수 있습니다.(자료등록(관리자)에는 영향을 미치지 않습니다.)<br>
						&nbsp;YES : 원천징수세액등 조정 신청을 오픈하여 사용합니다.<br>
						&nbsp;NO : 원천징수세액등 조정 신청을 숨깁니다.<br>
					</td>
					<td align="left">
						<input type="radio" class="radio" name="cpn_yea_paytax_ins_yn" value = "Y" >YES&nbsp;&nbsp;&nbsp;<br>   
						<input type="radio" class="radio" name="cpn_yea_paytax_ins_yn" value = "N" >NO
					</td>		
				</tr>
			</table>
		</div>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:setValue();" class="pink large">저장</a>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
		</div>
		<div class="hide">
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100px"); </script>
		</div>
		</div>
	</div>		
</body>
</html>



