<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>[연차촉진]휴가계획신청 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

var searchApplSeq    = "${searchApplSeq}";
var adminYn          = "${adminYn}";
var authPg           = "${authPg}";
var searchApplSabun  = "${searchApplSabun}";
var searchApplInSabun= "${searchApplInSabun}";
var searchApplYmd    = "${searchApplYmd}";
var applStatusCd	 = "";
var pGubun           = "";
var gPRow = "";
var hdn = 1, kfd = 0;

	$(function() {

		parent.iframeOnLoad(220);

		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);
		$("#searchAuthPg").val(authPg);

		applStatusCd = parent.$("#applStatusCd").val();

		if(applStatusCd == "") {
			applStatusCd = "11";
		}

		if(applStatusCd == "11") {
			hdn = 0, kfd = 1;
		}

		//----------------------------------------------------------------
		init_sheet1();
		//----------------------------------------------------------------

		doAction("Search");
	});

	// 휴가계획상세
	function init_sheet1(){

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:hdn,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

  			{Header:"시작일자", 	Type:"Date",  		Hidden:0, Width:100, Align:"Center", SaveName:"sYmd",    	KeyField:kfd, Format:"Ymd",   Edit:1 },
  			{Header:"종료일자", 	Type:"Date",  		Hidden:0, Width:100, Align:"Center", SaveName:"eYmd",     	KeyField:kfd, Format:"Ymd",   Edit:1 },
  			{Header:"총일수", 	Type:"Int",  		Hidden:0, Width:80,  Align:"Center", SaveName:"holDay", 	KeyField:0,   Format:"",      Edit:0 },
  			{Header:"적용일수", 	Type:"AutoSum", 	Hidden:0, Width:80,  Align:"Center", SaveName:"closeDay",  	KeyField:0,   Format:"",      Edit:0 },
  			{Header:"비고", 		Type:"Text",  		Hidden:0, Width:150, Align:"Left",   SaveName:"note",   	KeyField:0,   Format:"",      Edit:1 },

  			{Header:"applSeq",	Type:"Text",  		Hidden:1, Width:150, Align:"Left",   SaveName:"applSeq",   	KeyField:0,   Format:"",      Edit:1 }
  		];
  		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);
		$(window).smartresize(sheetResize); sheetInit();

	}



	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/AnnualPlanAgrApp.do?cmd=getAnnualPlanAgrAppDetMap", $("#searchForm").serialize(),false);

			if ( data != null && data.DATA != null ){
				$("#useSYmd").val(data.DATA.useSYmd);
				$("#useEYmd").val(data.DATA.useEYmd);
				$("#useCnt").val(data.DATA.useCnt);
				$("#usedCnt").val(data.DATA.usedCnt);
				$("#restCnt").val(data.DATA.restCnt);

				$("#span_planNm").html(data.DATA.planNm);
				$("#span_useYmd").html(data.DATA.useYmd);
				$("#span_useCnt").html(data.DATA.useCnt);
				$("#span_usedCnt").html(data.DATA.usedCnt);
				$("#span_restCnt").html(data.DATA.restCnt);
				$("#span_agreeYmd").html(data.DATA.agreeYmd);

	        	if(data.DATA.agreeYn == "Y") {
	        		$("#agreeYn").attr("checked",true);
	        	} else {
	        		$("#agreeYn").attr("checked",false);
	        	}


				sheet1.DoSearch( "${ctx}/AnnualPlanAgrApp.do?cmd=getAnnualPlanAgrAppDetList", $("#searchForm").serialize() );
				
			
			}

			break;

		case "Insert":
			var Row = sheet1.DataInsert(0);
	        sheet1.SetCellValue(Row, "applSeq", $("#searchApplSeq").val());
			break;

		}
	}

	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
		try{
			if(sheet1.ColSaveName(Col) == "sYmd" || sheet1.ColSaveName(Col) == "eYmd" ) {
				dateCheck(Row, Col);
			} else if(sheet1.ColSaveName(Col) == "sDelete" ) {
				if (Value == 1){
					sheet1.RowDelete(Row);
				}
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}


	//--------------------------------------------------------------------------------
	//  총일수, 적용일수 계산
	//--------------------------------------------------------------------------------
	function dateCheck(Row, Col){
		try{
			sheet1.SetCellValue(Row, "holDay",   "", 0);
			sheet1.SetCellValue(Row, "closeDay", "", 0);

			// 사용가능기간
			var useSYmd = $("#useSYmd").val();
			var useEYmd = $("#useEYmd").val();

			// 입력데이터
			var sYmd = sheet1.GetCellValue(Row, "sYmd");
			var eYmd = sheet1.GetCellValue(Row, "eYmd");

			if( useSYmd > sYmd  ) {
				alert("시작일은 사용기간 내의 날짜를 입력하셔야 합니다.");
				sheet1.SetCellValue(Row, Col, "", 0);
				sheet1.SelectCell(Row, Col);
				return;
			}
			if( useEYmd < eYmd  ) {
				alert("종료일은 사용기간 내의 날짜를 입력하셔야 합니다.");
				sheet1.SetCellValue(Row, Col, "", 0);
				sheet1.SelectCell(Row, Col);
				return;
			}


			if(sYmd == "" || eYmd == "") return;

			if( eYmd < sYmd  ) {
				alert("시작일과 종료일을 정확히 입력하세요.");
				sheet1.SetCellValue(Row, Col, "", 0);
				sheet1.SelectCell(Row, Col);
				return;
			}

			//총일수 적용일수를 구한다.
			var param	= "&sabun="+searchApplSabun
						+ "&sYmd="+sYmd
						+ "&eYmd="+eYmd;

			// 휴일 체크
			var map = ajaxCall("/AnnualPlanAgrApp.do?cmd=getAnnualPlanAgrAppDetHolidayCnt",param ,false);

			var dayBetween = getDaysBetween(sYmd , eYmd ) ;

			sheet1.SetCellValue(Row, "holDay",   dayBetween, 0);
			sheet1.SetCellValue(Row, "closeDay", dayBetween - map.DATA.holidayCnt, 0);

		}catch(e){

		}

	}

	//--------------------------------------------------------------------------------
	//  저장 시 필수 입력 및 조건 체크
	//--------------------------------------------------------------------------------
	function checkList(status) {
		var ch = true;

		// 잔여일수 체크
		var restCnt = Number( $("#restCnt").val());

		if (sheet1.RowCount() <1){
			alert("휴가계획 정보를 입력하십시오.");
			ch = false;
			return ch;
		}

		if (!dupChk(sheet1, "sYmd", false, true)) {
			ch = false;
			return ch;
		}

		// 입력한 적용일수 마지막 row가 합계행임.
		var closeDay = sheet1.GetCellValue(sheet1.LastRow(), "closeDay");
		if (restCnt > closeDay){
			alert("적용일수의 합은 잔여일수보다 커야 합니다.");
			ch = false;
			return ch;
		}

		if($("#agreeYn").is(":checked")==false) {
			alert("동의하여 주십시오.");
			ch = false;
			return ch;
		}

		return ch;
	}

	//--------------------------------------------------------------------------------
	//  임시저장 및 신청 시 호출
	//--------------------------------------------------------------------------------
	function setValue(status) {
		var returnValue = false;
		try {
			if ( authPg == "R" )  {
				return true;
			}

	        // 항목 체크 리스트
	        if ( !checkList() ) {
	            return false;
	        }

			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
				sheet1.SetCellValue(i, "sStatus", "U");
			}

	        IBS_SaveName(document.searchForm,sheet1);
			var saveStr = sheet1.GetSaveString(0);
			if(saveStr=="KeyFieldError"){
				return false;
			}
			var data = eval("("+sheet1.GetSaveData("${ctx}/AnnualPlanAgrApp.do?cmd=saveAnnualPlanAgrAppDet", saveStr+"&"+$("#searchForm").serialize())+")");

            if(data.Result.Code < 1) {
                alert(data.Result.Message);
				returnValue = false;
            }else{
				returnValue = true;
            }

		} catch (ex){
			alert("Error!" + ex);
			returnValue = false;
		}

		return returnValue;
	}

</script>

<style type="text/css">

/*---- checkbox ----*/
input[type="checkbox"]  {
	display:inline-block; width:20px; height:20px; cursor:pointer; appearance:none;
 	-moz-appearance:checkbox; -webkit-appearance:checkbox; margin-top:2px;background:none;
    border: 5px solid red;
}
label {
	vertical-align:-2px;padding-right:10px;
}
</style>
</head>
<body class="bodywrap">
<div class="wrapper">

	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	<input type="hidden" id="searchAuthPg"		name="searchAuthPg"	     value=""/>

	<input type="hidden" id="useSYmd"			name="useSYmd"	 	 value=""/>
	<input type="hidden" id="useEYmd"			name="useEYmd"	     value=""/>
	<input type="hidden" id="useCnt"			name="useCnt"	     value=""/>
	<input type="hidden" id="usedCnt"			name="usedCnt"	     value=""/>
	<input type="hidden" id="restCnt"			name="restCnt"	     value=""/>

	<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='114682' mdef='신청내용'/></li>
		</ul>
	</div>
	<table class="table">
		<colgroup>
			<col width="110px" />
			<col width="150px" />
			<col width="110px" />
			<col width="150px" />
			<col width="110px" />
			<col width="" />
		</colgroup>
		<tr>
			<th><tit:txt mid='planType' mdef='계획구분'/></th>
			<td>
				<span id="span_planNm">&nbsp;</span>
			</td>
			<th><tit:txt mid='usePeriod' mdef='사용기간'/></th>
			<td colspan="3">
				<span id="span_useYmd">&nbsp;</span>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='2017083001029' mdef='사용가능일수'/></th>
			<td>
				<span id="span_useCnt">&nbsp;</span>
			</td>
			<th><tit:txt mid='2017083001030' mdef='사용일수'/></th>
			<td>
				<span id="span_usedCnt">&nbsp;</span>
			</td>
			<th><tit:txt mid='2017083001031' mdef='잔여일수'/></th>
			<td>
				<span id="span_restCnt">&nbsp;</span>
			</td>
		</tr>
		</table>

		<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='annlLvsPlan' mdef='휴가계획'/></li>
				<li class="btn">
					<a href="javascript:doAction('Insert');" class="btn filled authA"><tit:txt mid='104267' mdef='입력'/></a>
				</li>
			</ul>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "200px", "${ssnLocaleCd}"); </script>

		<div class="h10"></div>
		<div style="width:100%; text-align:center; letter-spacing:0; font-size:1.1em;font-weight:600;padding:10px;">
			<msg:txt mid="infoAnnualPlanAgrAppDet" mdef="남은 연차휴가에 대하여 위와 같이 사용시기를 지정하여 통보합니다."/>
			<div class="h20"></div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<span id="span_agreeYmd"></span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			(&nbsp;<label for="agreeYn" style="vertical-align: middle;"><tit:txt mid='201706200000027' mdef='동의'/></label>&nbsp;<input id="agreeYn" name="agreeYn" type="checkbox" value="Y" ${disabled} required /> &nbsp; )
		</div>

	</form>
</div>

</body>
</html>