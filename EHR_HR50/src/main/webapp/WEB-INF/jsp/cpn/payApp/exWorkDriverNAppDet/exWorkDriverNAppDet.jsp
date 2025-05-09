<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>야근수당(기원)종합신청 세부내역</title>
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
		//if(applStatusCd != "11" && applStatusCd != null && applStatusCd != "") {
		if(applStatusCd != null && applStatusCd != "") {
			$("#workYm").attr("readonly", true).addClass("transparent");
		} else {
			$("#workYm").datepicker2({ymonly:true, 
				onReturn: function(date) {
					var cnt = sheet1.RowCount();					
					if(cnt > 0 ) { 
						if (confirm("근무년월 변경시 상세내역이 초기화 됩니다. 변경 하시겠습니까?")) {
							sheet1.RemoveAll();
							// 야근수당 총액 
							$("#totMon").val("");
							
						} else {							
							$(this).val(sheet1.GetCellValue(1,"workYm"));
							return false;
						}
					}
                }
			});
		}
		
		/*근태신청 상세 데이타*/
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:0,ColResize:0,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제", 		Type:"${sDelTy}",	Hidden:0,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태", 		Type:"${sSttTy}",	Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"성명",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }, 
   			{Header:"사번",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 }, 
   			{Header:"소속",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			   //{Header:"직급",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },   
			{Header:"금액",			Type:"AutoSum",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"payMon",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"비고(상세)",	Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"detailBigo",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"근무년월", 	Type:"Text",			Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"workYm",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata1);
		sheet1.SetEditable("${editable}"); 
		sheet1.SetVisible(true);
		
		$(window).smartresize(sheetResize);sheetInit(); 
		
		setSheetAutocompleteEmp( "sheet1", "name");

		// data 조회 
		if(searchApplSeq != null && searchApplSeq != "") { 
			var data = ajaxCall( "${ctx}/GetDataMap.do?cmd=getExWorkDriverNAppDet", $("#sheetForm").serialize(), false);
			setDataForm(data);

			doAction1("Search");
		}
		
		// 처리완료인 경우 비활성화
		// 2020.02.05 임시저장이 아닌경우 비활성화로 변경
		if(applStatusCd != "11"  || applStatusCd == "") {
			//$("#bigo").hide();
			//$("#span_bigo").show();
		} else {
			//$("#span_bigo").hide();
			//sheet1_OnChangeSum();
		}
		
		
	});

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "sheetAutocompleteEmp"){
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow, "name", rv["name"]);
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
		}
	}
	

	function setDataForm(data) {

		if(data.DATA != null) {
			// 합산년월
			$("#workYm").val(data.DATA.workYm);
			$("#span_workYm").text(data.DATA.workYm);

			// 야근수당 총액 
			$("#totMon").val(data.DATA.totMon);

			// 비고 (Master)
			$("#bigo").text(data.DATA.bigo);
			//$("#span_bigo").text(data.DATA.bigo);
		}
	}


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
			var applSeq = searchApplSeq;
			var param = "applSeq="+ applSeq ;
			sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getExWorkDriverNAppDetailList",param );
			break;
			case "SearchCalc":
			// 계산금액불러오기
			var param = "workYm="+ $("#workYm").val();
			sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getExWorkDriverNAppDetCalc",param );
			break;			
			case "Insert":
			var newRow = sheet1.DataInsert(0);
			sheet1.SetCellValue(newRow, "enterCd", "${ssnEnterCd}");
			sheet1.SetCellValue(newRow,  "workYm", $("#workYm").val());
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
				sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"4|7|8"});		
			break;				
		}
	}
	
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
				
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			// 총합
			$("#totMon").val(sheet1.GetSumText("payMon"));

			/*
			var rowCnt = sheet1.RowCount();			
			var workYm = $("#workYm").val();
			//trWorkYm
			$("#trWorkYm").html('<input id="workYm" name ="workYm" class="required readonly center" type="text" value="'+ workYm+' " />');
			*/			
			
			sheetResize();			
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
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
				alert(txt+"은 필수값입니다.");
				$(this).focus();
				ch =  false;
				return false;
			}
		});

 		// 시트입력 체크
		var row = "";
		if(sheet1.RowCount() == 0) {
			row = sheet1.DataInsert();
			alert("상세내역을 입력해 주세요.");
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
				
				var data = ajaxCall("${ctx}/GetDataMap.do?cmd=getExWorkDriverNAppDetCnt",$("#sheetForm").serialize(),false);
				if( parseInt( data.DATA.cnt ) > 0) {
					alert("해당월에 대해 처리완료 및 결재처리중인 기 신청내역이 존재합니다. 재신청을 원하면 기존 결재의 결재상태를 변경하여 주시기 바랍니다.");
					return false;
				}
				
				// 입력체크
				if(!checkList()) return ;
				
				//신청내역 저장
				IBS_SaveName(document.sheetForm, sheet1);
				//alert(" call saveExWorkDriverNAppDet, sheet1.GetSaveString => " + sheet1.GetSaveString());
				
				if ( sheet1.GetSaveString() == "" ) { 
					rtn = ajaxCall("${ctx}/ExWorkDriverNAppDet.do?cmd=saveExWorkDriverNAppDet",$("#sheetForm").serialize(),false);
					
					if(rtn.Result.Code < 1) {
						alert(rtn.Result.Message);
						return  false;
					}
				} else {					
					sheet1.DoSave("${ctx}/ExWorkDriverNAppDet.do?cmd=saveExWorkDriverNAppDet",$("#sheetForm").serialize());
				}

			}
		} catch (ex){
			alert("저장중 스크립트 오류발생." + ex);
			return false;
		}
		return true;
	}

	// 합계행에 값이 바뀌었을 때 이벤트가 발생한다.
	function sheet1_OnChangeSum(Row,  Col) {
		try{
			$("#totMon").val(sheet1.GetSumText("payMon"));
		}catch(ex){
			alert("OnChangeSum Event Error " + ex);
		}
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
			<li class="txt">신청항목</li>
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
		<th>근무년월</th>
		<td id="trWorkYm">
			<input id="workYm" name ="workYm" class="required ${dateCss} ${readonly} center" type="text" value="${curSysYyyyMMHyphen} " />
		</td>
		<th>야근수당 총액</th>
		<td>
			<input type="text" id="totMon" name="totMon" class="${textCss}  readonly number required" value="" readonly /> 원
		</td>
	</tr>
	<tr>
		<th>비고</th>
		<td colspan="4">
			<textarea id="bigo" name="bigo" rows="3" cols="30" class="${textCss} w100p required" ${readonly}></textarea>
			<!-- <span id="span_bigo"></span> -->
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
                            <li id="txt" class="txt">상세내역</li>
                            <li class="btn">
								<!--<a href="javascript:doCallPrc()" 	class="button authR">계산금액불러오기</a> -->
								<a href="javascript:doAction1('SearchCalc')" 	class="button authA">계산금액불러오기</a>
                            	<a href="javascript:doAction1('DownTemplate')" 	class="basic authA">양식다운로드</a>
								<a href="javascript:doAction1('LoadExcel')" 	class="basic authA">업로드</a>
                            	<a href="javascript:doAction1('Insert')"   class="basic authA">입력</a>
                            	<a href="javascript:doAction1('Copy')"   class="basic authA">복사</a>
                                <a href="javascript:doAction1('Down2Excel')" class="basic authR">다운로드</a>
                            </li>
                        </ul>
                    </div>
                </div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
				<div class="inner">
					화면높이조절 : 
					<a href="javascript:doAction1('Down');" class="basic">▼</a>
					<a href="javascript:doAction1('Up');" class="basic">▲</a>
				</div>
            </td>
        </tr>
    </table>
	
</div>

</html>

