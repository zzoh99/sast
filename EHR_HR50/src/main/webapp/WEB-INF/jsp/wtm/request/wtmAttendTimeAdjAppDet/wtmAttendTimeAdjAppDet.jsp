<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>출퇴근시간변경신청 세부내역</title>
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
var applYn	         = "";
var bfYmd	         = "${etc01}";


	$(function() {
	
		parent.iframeOnLoad(220);
	
		//----------------------------------------------------------------
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchSabun").val(searchApplSabun);
		$("#searchApplSabun").val(searchApplSabun);
		$("#searchApplYmd").val(searchApplYmd);
	
		applStatusCd = parent.$("#applStatusCd").val();  //신청서상태
		applYn = parent.$("#applYn").val(); //결재자 여부
	
		if(applStatusCd == "") {
			applStatusCd = "11";
		}
	
		//----------------------------------------------------------------
		// 기본 입력 사항
		if(authPg === "A"){
			// 근태캘린더에서 근무일자가 넘어올 경우 해당 데이터로 초기화
			if (bfYmd) {
				$("#tdYmd").val(bfYmd);
			}

			// 근무일
		    $("#tdYmd").datepicker2({
		    	onReturn: function(){
		    		dateCheck();
					doAction("Search");
		    	}
		    });
	    }

		init_sheet();
		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");
	});

	//Sheet 초기화
	function init_sheet(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"변경구분|변경구분",	Type:"Combo",		Hidden:0, 	Width:50,	Align:"Center", SaveName:"chgType",	Edit:0 },

			{Header:"변경전|이석\n여부",	Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	SaveName:"bfAwayYn",	Edit:0 , 	Format:"",		TrueValue:"Y",	FalseValue:"N" },
			{Header:"변경전|출근일",		Type:"Date",		Hidden:0, 	Width:70,	Align:"Center", SaveName:"bfInYmd",		Edit:0 ,	Format:"Ymd"},
			{Header:"변경전|출근시간",		Type:"Text",		Hidden:0, 	Width:50,	Align:"Center", SaveName:"bfInHm",		Edit:0 ,	Format:"Hm"},
			{Header:"변경전|퇴근일",		Type:"Date",		Hidden:0, 	Width:70,	Align:"Center", SaveName:"bfOutYmd",	Edit:0 ,	Format:"Ymd"},
			{Header:"변경전|퇴근시간",		Type:"Text",		Hidden:0, 	Width:50,	Align:"Center", SaveName:"bfOutHm",		Edit:0 ,	Format:"Hm"},

			{Header:"변경후|삭제\n여부",	Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	SaveName:"delCheck",	Edit:1 , 	Format:"",		TrueValue:"Y",	FalseValue:"N" },
			{Header:"변경후|이석\n여부",	Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	SaveName:"afAwayYn",	Edit:1 , 	Format:"",		TrueValue:"Y",	FalseValue:"N" },
			{Header:"변경후|출근일",		Type:"Date",		Hidden:0, 	Width:100,	Align:"Center", SaveName:"afInYmd",		Edit:1 ,	Format:"Ymd"},
			{Header:"변경후|출근시간",		Type:"Text",		Hidden:0, 	Width:60,	Align:"Center", SaveName:"afInHm",		Edit:1 ,	Format:"Hm"},
			{Header:"변경후|퇴근일",		Type:"Date",		Hidden:0, 	Width:100,	Align:"Center", SaveName:"afOutYmd",	Edit:1 ,	Format:"Ymd"},
			{Header:"변경후|퇴근시간",		Type:"Text",		Hidden:0, 	Width:60,	Align:"Center", SaveName:"afOutHm",		Edit:1 ,	Format:"Hm"},

			//Hidden
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"ymd"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"seq"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"sabun"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSabun"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applInSabun"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeq"}

		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음
		sheet1.SetEditableColorDiff(1);
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게

		if(authPg === "A"){
			sheet1.SetEditable(true);
		}

		//==============================================================================================================================
		sheet1.SetColProperty("chgType",  		{ComboText:"|입력|수정|삭제", ComboCode:"K|I|U|D"} );
		//==============================================================================================================================
	}

	// Action
	function doAction(sAction) {
		switch (sAction) {
			case "Search":
				sheet1.DoSearch( "${ctx}/WtmAttendTimeAdjApp.do?cmd=getWtmAttendTimeAdjAppDetList", $("#searchForm").serialize() );
				break;
			case "Insert":
				var Row = sheet1.DataInsert(0);
				sheet1.SetCellValue(Row, "chgType", "I");
				sheet1.SetCellValue(Row, "applSeq", searchApplSeq);
				sheet1.SetCellValue(Row, "sabun", searchApplSabun);
				sheet1.SetCellValue(Row, "ymd", $("#tdYmd").val());
				sheet1.SetCellValue(Row, "afInYmd", $("#tdYmd").val());
				sheet1.SetCellValue(Row, "afOutYmd", $("#tdYmd").val());
				break;
		}
	}

	// 셀 변경 시
	function sheet1_OnChange(Row, Col, Value) {
		try {
			if(sheet1.ColSaveName(Col) !== "chgType" && sheet1.ColSaveName(Col) !== "sStatus") {
				if(sheet1.ColSaveName(Col) === "delCheck" ) {
					if(Value === "Y" && sheet1.GetCellValue(Row, "chgType") === "I") {
						sheet1.RowDelete(Row, 0)
					} else if (Value === "Y") {
						sheet1.SetCellValue(Row, "chgType", "D");
						sheet1.SetRowEditable(Row, 0);
						sheet1.SetCellEditable(Row, "delCheck", 1);
					} else {
						sheet1.SetCellValue(Row, "chgType", "U");
						sheet1.SetRowEditable(Row, 1);
					}
				} else if (sheet1.GetCellValue(Row, "chgType") !== "I") {
					sheet1.SetCellValue(Row, "chgType", "U");
				}
			}
		} catch (ex) {
			alert("OnChange Event Error : " + ex);
		}
	}

	//근무일 변경 시 
	function dateCheck(){
		// TODO 월마감 체크 로직 추가 되어야 함.
		<%--var data = ajaxCall("${ctx}/WtmAttendTimeAdjApp.do?cmd=getWtmAttendTimeAdjAppDetEndYn","&searchApplSabun="+searchApplSabun+"&tdYmd="+$("#tdYmd").val(),false);--%>
		<%--if(data.DATA != null && data.DATA.endYn == "Y"){--%>
		<%--	alert("<msg:txt mid='2018081700021' mdef='해당월의 근무가 마감되었습니다. 관리자에게 문의바랍니다.'/>");--%>
		<%--	$("#tdYmd").val("");--%>
		<%--	return;--%>
		<%--}--%>

		if(authPg === "A") {
			const tdYmd = $("#tdYmd").val().replace(/-/g, '');
			if ( tdYmd === "${curSysYyyyMMdd}" ){
				// 전일 데이터는 12시 이후 입력 가능
				var currHour = "";
				var currDateTime = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCurrDateTime",false).codeList;
				if ( currDateTime != null && currDateTime[0] != null && currDateTime[0].currHour != null){
					currHour = currDateTime[0].currHour;
				}

				if (currHour < "12"){
					alert("<msg:txt mid='2018081700029' mdef='전일데이터는 12시 이후 부터 입력 가능합니다.'/>");
					$("#tdYmd").val("")
					return false;
				}
			}

			if ( tdYmd > "${curSysYyyyMMdd}"){
				// 당일 데이터 입력불가
				alert("<msg:txt mid='2018081700028' mdef='당일 포함. 당일 이후 근무일은 신청하실 수 없습니다.'/>");
				$("#tdYmd").val("")
				return false;
			}
		}

		return true;
	}
	
	//--------------------------------------------------------------------------------
	//  저장 시 필수 입력 및 조건 체크
	//--------------------------------------------------------------------------------
	function checkList(status) {
		var ch = true;

		if (!dateCheck()){
			return false;
		}

		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prev().text()+"<msg:txt mid='required2' mdef='은(는) 필수값입니다.' />");
				$(this).focus();
				ch =  false;
				return false;
			}
		});
		
		if( !ch  ) return;

		$(".requireLen").each(function(index){
			if($(this).val().length == 0){
				alert("<msg:txt mid='2018081700030' mdef='"+$(this).parent().prev().text()+"은 필수값입니다.'/>");
				$(this).focus();
				ch =  false;
				return ch;
			}
			if($(this).val().length < 5){
				alert("<msg:txt mid='2018081700031' mdef='"+$(this).parent().prev().text()+"은 4자리 모두 입력하셔야 합니다.'/>");
				$(this).focus();
				ch =  false;
				return ch;
			}
		});

		if( !ch  ) return;

		//기 신청 건 체크
		var data = ajaxCall("${ctx}/WtmAttendTimeAdjApp.do?cmd=getWtmAttendTimeAdjAppDetDupCheck", $("#searchForm").serialize(),false);

		if(data.DATA != null && data.DATA.dupCnt != "0"){
			alert("동일한 일자에 신청내역이 있습니다.");
			return false;
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

	      	//저장
			for (var i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++) {
				sheet1.SetCellValue(i, "sStatus", "U");
			}
			const saveStr = sheet1.GetSaveString(0);
			if(saveStr.match("KeyFieldError")) {
				return;
			}
			IBS_SaveName(document.searchForm, sheet1);
			const data = JSON.parse(sheet1.GetSaveData("${ctx}/WtmAttendTimeAdjApp.do?cmd=saveWtmAttendTimeAdjAppDet", saveStr + "&"+ $("#searchForm").serialize()));

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
</head>
<body class="bodywrap">
<div class="wrapper">

	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchSabun"		name="searchSabun"	 	 value=""/>
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>

	<div class="sheet_title">
		<ul>
			<li class="txt">신청내용</li>
		</ul>
	</div>

	<table class="table">
		<colgroup>
			<col width="100px" />
			<col width="100px" />
			<col width="120px" />
			<col width="100px" />
			<col width="" />
		</colgroup>
		<tr>
			<th>근무일</th>
			<td colspan="4">
				<input type="text" id="tdYmd" name="tdYmd" class="${dateCss} ${required} w70" readonly maxlength="10" />
			</td>
		</tr>
			<td colspan="5">
				<a href="javascript:doAction('Insert')" class="btn outline_gray authA">추가</a>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "200px"); </script>
			</td>
		<tr>
			<th>사유</th>
			<td colspan="4">
				<textarea id="reason" name="reason" rows="4" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea>
			</td>
		</tr>
	</table>
	</form>
	
</div>
</body>
</html>