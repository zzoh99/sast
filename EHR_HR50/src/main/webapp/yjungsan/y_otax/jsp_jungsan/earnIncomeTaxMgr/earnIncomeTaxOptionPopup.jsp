<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>원천세 옵션</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");

	$(function() {
		
		$("#searchWorkYy").mask("1111");
		
		$("#searchWorkYy").bind("keyup",function(event) {
			console.log('key code', event.keyCode)
			if (event.keyCode == 13) {
				searchDataByYear();
			}
		});
		
		var arg = p.window.dialogArguments;
		var searchWorkYy 	  = "";
		
		if( arg != undefined ) {
			searchWorkYy 	  = arg["searchWorkYy"];
		}else{
			searchWorkYy 	  = p.popDialogArgument("searchWorkYy");
		}
		$("#searchWorkYy").val(searchWorkYy);
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },	
			{Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},	
			{Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},	
			{Header:"workYY", 		Type:"Text",	  Hidden:0,  Width:100,  Align:"Left",		ColMerge:0,   SaveName:"work_yy",  		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"stdCd", 		Type:"Text",	  Hidden:0,  Width:100,  Align:"Left",		ColMerge:0,   SaveName:"std_cd",  		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"stdNm", 		Type:"Text",	  Hidden:0,  Width:100,  Align:"Left",		ColMerge:0,   SaveName:"std_nm",  		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"stdCdDesc", 	Type:"Text",	  Hidden:0,  Width:100,  Align:"Left",		ColMerge:0,   SaveName:"std_cd_desc",  	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"stdCdValue", 	Type:"Text",	  Hidden:0,  Width:100,  Align:"Left",		ColMerge:0,   SaveName:"std_cd_value",	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);  sheet1.SetEditable(false); sheet1.SetCountPosition(4);
		
		/*-----------------------------------------------------------------------------------------
			조회된 데이터가 존재할 경우 화면내 커서가 시트에 종속됨에 따라
			조회영역의 input, textarea 엘레멘트에서의 키입력이 정상 작동되지 않는 현상이 있어 시트 비활성화 처리함.
		  -----------------------------------------------------------------------------------------*/
		sheet1.SetEnable(0);

		$(window).smartresize(sheetResize); sheetInit();
		
		// 원천세 옵션 등록 연도 목록 조회
		//var workYearList = stfConvCode( codeList("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxOptionPopupRst.jsp?cmd=selectEarnIncomeTaxOptionYeaList",""), "-복사기준년도-");
		//$("#sourceWorkYy").html(workYearList[2]);
		
		searchDataByYear();
		
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
			sheet1.DoSearch( "<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxOptionPopupRst.jsp?cmd=selectEarnIncomeTaxOptionPopupList", $("#sheetForm").serialize() );
			break;
		case "Save"://저장
			sheet1.DoSave( "<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxOptionPopupRst.jsp?cmd=saveEarnIncomeTaxOptionPopup", "", "-1", 0); 
			break;
		case "SearchByYear"://지정연도기준데이터조회
			sheet1.DoSearch( "<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxOptionPopupRst.jsp?cmd=selectEarnIncomeTaxOptionPopupListByYea", $("#sheetForm").serialize() );
			break;
		}
	} 
	//조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			
			if(Code == 1) {
				shtToCtl();
				if(copyProcFlag) {
					alert("[" + $("#sourceWorkYy").val() + "] 년도 기준으로 복사되었습니다.\n[저장] 버튼을 클릭하여 저장을 완료해주십시오.\n");
					copyProcFlag = false;
				}
				if(searchDataByYearFlag) {
					searchDataByYearFlag = false;
					if(sheet1.RowCount() == 0) {
						//alert("기준년도" + $("#searchWorkYy").val() + "에 해당하는 데이터가 존재하지 않습니다.");
			        	//데이터 존재하지 않는 경우 강제 행 삽입하여 merge쿼리 날릴 수 있도록 함.
						var Row = sheet1.DataInsert(0) ;
						sheet1.SetCellValue(Row, "work_yy", $("#searchWorkYy").val()) ;
						sheet1.SetCellValue(Row, "std_cd", "CPN_OTAX_FINALCLOSE_CHK_YN") ;
						sheet1.SetCellValue(Row, "std_nm", "원천세 자료생성 마감체크 여부") ;
						sheet1.SetCellValue(Row, "std_cd_desc", "원천세 자료생성시 마감된 자료만 가져올것인지 여부 Y:마감된 자료만 불러옵니다. N:마감여부와 관계 없이 모든 자료를 불러 옵니다.") ;
						sheet1.SetCellValue(Row, "std_cd_value", $("input:radio[name='cpn_otax_finalclose_chk_yn']:checked").val());
						
						var Row2 = sheet1.DataInsert(0) ;
						sheet1.SetCellValue(Row2, "work_yy", $("#searchWorkYy").val()) ;
						sheet1.SetCellValue(Row2, "std_cd", "CPN_OTAX_R_ADJ_TYPE") ;
						sheet1.SetCellValue(Row2, "std_nm", "원천세 - 지방소득세에 퇴직정산 생성 기준(R:환급액 C:근로소득)") ;
						sheet1.SetCellValue(Row2, "std_cd_desc", "") ;
						sheet1.SetCellValue(Row2, "std_cd_value", $("input:radio[name='cpn_otax_r_adj_type']:checked").val());
						
					}
				}
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
			}
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	//원천세옵션 시트를 각 항목에 입력 :TSYS955
	function shtToCtl(){		 
		if(sheet1.RowCount() > 0){
			for (i = 1; i < sheet1.RowCount()+1; i++){
				var stdValue = sheet1.GetCellValue(i, "std_cd_value");
				if(sheet1.GetCellValue(i,"std_cd")=="CPN_OTAX_FINALCLOSE_CHK_YN"){   //원천세 자료생성 마감체크 여부
					$("input:radio[name='cpn_otax_finalclose_chk_yn']:input[value='"+stdValue+"']").attr("checked",true);
				}else if(sheet1.GetCellValue(i,"std_cd")=="CPN_OTAX_R_ADJ_TYPE"){   //지방소득세-퇴직정산 생성 기준
					$("input:radio[name='cpn_otax_r_adj_type']:input[value='"+stdValue+"']").attr("checked",true);
				}
				// 기준년도 데이터 삽입
				sheet1.SetCellValue(i, "work_yy", $("#searchWorkYy").val());
			}
		}
	}
	
	//원천세 옵션을 저장 시 , 시트에 해당 정보를 담는다.
	function setValue(){
		if(sheet1.RowCount() > 0){
			if(confirm("원천세 옵션 내역을 저장하시겠습니까?")){
				for (i = 1; i < sheet1.RowCount()+1; i++){
					
					if(sheet1.GetCellValue(i,"std_cd")=="CPN_OTAX_FINALCLOSE_CHK_YN"){   //원천세 자료생성 마감체크 여부
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_otax_finalclose_chk_yn']:checked").val());
					}else if(sheet1.GetCellValue(i,"std_cd")=="CPN_OTAX_R_ADJ_TYPE"){      //지방소득세-퇴직정산 생성 기준
						sheet1.SetCellValue(i, "std_cd_value", $("input:radio[name='cpn_otax_r_adj_type']:checked").val());
					}
				}
				
				doAction1("Save");   //옵션 저장 수행
			}	
		}
	}
	
	var copyProcFlag = false;
	var searchDataByYearFlag = false;
	
	/*
	// 과거 데이터 복사
	function copyOldData() {
		if($("#sourceWorkYy").val() != "") {
			copyProcFlag = true;
			doAction1("SearchByYear");
		} else {
			alert("복사기준년도를 선택해주십시오.");
		}
	}
	*/
	
	// 기준년도 데이터 조회
	function searchDataByYear() {
		searchDataByYearFlag = true;
		doAction1("SearchByYear");
	}
</script>
</head>
<body class="bodywrap" style="overflow:scroll;">
	<div class="wrapper">
		<div class="popup_title">
		<ul>
			<li id="strTitle">원천세 옵션</li>
			<!-- <li class="close"></li> -->
		</ul>
		</div>
	
		<div class="popup_main">
			<div>
				<form id="sheetForm" name="sheetForm" >
					<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
						<tr>
							<td>
								<div class="sheet_title outer">
								<ul>
									<li id="txt" class="txt">
										기준년도
										<input type="text" id="searchWorkYy" name="searchWorkYy" class="text center" value="" />
										<a href="javascript:searchDataByYear();" class="basic authA">조회</a>
									</li>
									<!-- 
									<li class="btn">
										<select id="sourceWorkYy" name="sourceWorkYy"></select>
										<a href="javascript:copyOldData();" class="basic authA">과거 데이터 복사</a>
									</li>
									 -->
								</ul>
								</div>
							</td>
						</tr>
					</table>
				</form>

				<table border="0" cellpadding="0" cellspacing="0" class="default outer">
					<colgroup>
						<col width="90%" />
						<col width="" />
					</colgroup>
					<tr>
						<th class="left" colspan="2"> [원천세 옵션 1] </th>
					</tr>
					<tr>
						<td class="left">
							<b>자료 생성시 각 일자별 마감이 되어있는 자료만 불러올지 여부를 결정합니다.(급여 퇴직금 퇴직정산 등)</b><br>
							&nbsp;YES : 마감된 자료만 불러옵니다.<br>
							&nbsp;NO : 마감여부와 관계 없이 모든 자료를 불러 옵니다.
						</td>
						<td align="left" style="line-height:20px;">
							<label><input type="radio" class="radio" name="cpn_otax_finalclose_chk_yn" value = "Y" > YES&nbsp;&nbsp;&nbsp;</label><br> 
							<label><input type="radio" class="radio" name="cpn_otax_finalclose_chk_yn" value = "N" > NO</label>
						</td>		
					</tr>
					<tr>
						<th class="left" colspan="2"> [원천세 옵션 2] </th>
					</tr>
					<tr>
						<td class="left">
							<b>지방소득세 - 자료생성시 퇴직정산을 중도퇴사자환급액에 포함할지 근로소득에 포함할지를 결정합니다.</b><br>
							&nbsp;환급액 : 중도퇴사자환급액에 생성합니다.<br>
							&nbsp;근로소득 : 근로소득에 생성합니다.<br>
						</td>
						<td align="left" style="line-height:20px;">
							<label><input type="radio" class="radio" name="cpn_otax_r_adj_type" value = "R" > 환급액</label><br>
							<label><input type="radio" class="radio" name="cpn_otax_r_adj_type" value = "C" > 근로소득&nbsp;&nbsp;&nbsp;</label><br>
						</td>		
					</tr>
										
					<!-- 
					<tr>
						<th class="left" colspan="2"> [원천세 옵션 2] </th>
					</tr>
					<tr>
						<td class="left">
							<b>자료 생성시 지급년월/귀속년월 기준을 정합니다.</b><br>
							&nbsp;A : 지급년월 기준으로 생성 합니다.<br>
							&nbsp;B : 귀속년월 기준으로 생성 합니다.<br>
							&nbsp;C : 지급년월과 귀속년월을 함께 기준으로 두고 생성합니다.<br>
							&nbsp;D : 현재 커스터마이징 된 로직 변경하지 않음.	
						</td>
						<td align="left" style="line-height:20px;">
							<label><input type="radio" class="radio" name="cpn_otax_cre_std" value = "A" > A&nbsp;&nbsp;&nbsp;</label><br>
							<label><input type="radio" class="radio" name="cpn_otax_cre_std" value = "B" > B&nbsp;&nbsp;&nbsp;</label><br>
							<label><input type="radio" class="radio" name="cpn_otax_cre_std" value = "C" > C&nbsp;&nbsp;&nbsp;</label><br>
							<label><input type="radio" class="radio" name="cpn_otax_cre_std" value = "D" > D</label>
						</td>		
					</tr>
					 -->
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
				<script type="text/javascript">createIBSheet("sheet1", "100%", "300px"); </script>
			</div>
		</div>
	</div>
</body>
</html>