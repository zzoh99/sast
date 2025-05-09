<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>월근무시간신청 세부내역</title>
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

	$(function() {

		parent.iframeOnLoad(350);

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
		//-----------------------------------------------------------------
		
		init_sheet();
		
		//-----------------------------------------------------------------
		// 신청, 임시저장
		if(authPg == "A") {
			
			//근무월
			$("#ym").datepicker2({
				ymonly:true,
				onReturn:function(date){
					if( date <= "${curSysYyyyMMHyphen}"){
						alert("전월, 당월은 신청 할 수 없습니다.");
						$("#ym").val("");
						return;
					}else{
						sheet1.RemoveAll();	
						initOrgCdCombo();
					}
				}
			}).val(addDate("m", 1, "${curSysYyyyMMddHyphen}", "-").substr(0, 7));  
			 
			
			initOrgCdCombo();
			
			$("#orgCd").bind("change", function(){
				
				$("#searchWorkOrgCd").val($("#orgCd option:selected").attr("workOrgCd"));
				initTimeCdCombo();

				doAction("SearchList");
			});

			sheet1.SetEditable(1);
			
	    }else{

			sheet1.SetEditable(0); sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
	    }

		doAction("Search");

	});
	
	//조직 콤보
	function initOrgCdCombo(){
		if( $("#ym").val() == "" ) return;
			
		var orgCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getWorkTimeAppDetOrgCdList&"+ $("#searchForm").serialize(), false).codeList
				      , "workOrgCd"
				      , "선택");
		$("#orgCd").html(orgCdList[2]);

	}
	//근무조 , 근무시간 콤보
	function initTimeCdCombo(){
		if( $("#searchWorkOrgCd").val() == "" ) return;

		//근무시간 콤보
		//var timeList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getWorkTimeAppDetTimeCombo&"+ $("#searchForm").serialize(), false).codeList, "");
		//sheet1.SetColProperty("afTimeCd",  	{ComboText:"|"+timeList[0], ComboCode:"|"+timeList[1]} );
		

		//근무조 콤보
		var workOrgList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getWorkTimeAppDetWorkOrgCombo&"+ $("#searchForm").serialize(), false).codeList
				         , "timeCd,timeNm"
				         , "전체");
		sheet1.SetColProperty("afWorkOrgCd",  	{ComboText:"|"+workOrgList[0], ComboCode:"|"+workOrgList[1]} );
		
		$("#hdnWorkOrg").html(workOrgList[2]);

	}

	function init_sheet(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"사번",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"tgSabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"성명",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"직급",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"직책",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"전월근무조",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"bfWorkOrgNm", KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"전월근무시간",	Type:"Text",		Hidden:0,	Width:110,	Align:"Center",	ColMerge:0,	SaveName:"bfTimeNm",    KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"당월근무조",	Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"afWorkOrgCd", KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1, BackColor:"#fdf0f5"},
			{Header:"당월근무시간",	Type:"Text",		Hidden:0,	Width:110,	Align:"Center",	ColMerge:0,	SaveName:"afTimeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"비고",		Type:"Text",		Hidden:0,	Width:130,	Align:"Left",	ColMerge:0,	SaveName:"note2",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1},

  			//Hidden
  			{Header:"Hidden", Type:"Text",  Hidden:1, SaveName:"bfWorkOrgCd"},
  			{Header:"Hidden", Type:"Text",  Hidden:1, SaveName:"bfTimeCd"},
  			{Header:"Hidden", Type:"Text",  Hidden:1, SaveName:"afTimeCd"}
			
  		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
  		

		$(window).smartresize(sheetResize); sheetInit();

	}

	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/WorkTimeAppDet.do?cmd=getWorkTimeAppDet", $("#searchForm").serialize(),false);

			if ( data != null && data.DATA != null ){ 

				$("#ym").val( formatDate(data.DATA.ym, "-") );
				$("#note").val( data.DATA.note );
				$("#searchWorkOrgCd").val( data.DATA.workOrgCd );

				if(authPg == "R") {
					$("#orgCd").html("<option value='"+data.DATA.orgCd+"'>"+data.DATA.orgNm+"</option>");
				}else{
					$("#orgCd").val( data.DATA.orgCd );
				}
				initTimeCdCombo();
				
				doAction("SearchList");
			}


			break;
		case "SearchList":
			if( $("#orgCd").val() == ""){
				sheet1.RemoveAll();	
				return;
			}
			sheet1.DoSearch( "${ctx}/WorkTimeAppDet.do?cmd=getWorkTimeAppDetList", $("#searchForm").serialize() );

			break;
		}
	}

	//--------------------------------------------------------------------------------
	//  sheet1 Events
	//--------------------------------------------------------------------------------
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	// 값 변경시 발생
	function sheet1_OnChange(Row, Col, Value) {
		if ( sheet1.ColSaveName(Col) == "afWorkOrgCd"){
			$("#hdnWorkOrg").val(Value);
			sheet1.SetCellValue(Row, "afTimeNm", $("#hdnWorkOrg option:selected").attr("timeNm"));
			sheet1.SetCellValue(Row, "afTimeCd", $("#hdnWorkOrg option:selected").attr("timeCd"));
			
		}

	}
	//--------------------------------------------------------------------------------
	//  저장 시 필수 입력 및 조건 체크
	//--------------------------------------------------------------------------------
	function checkList(status) {
		var ch = true;

		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prev().text()+"<msg:txt mid='required2' mdef='은(는) 필수값입니다.' />");
				$(this).focus();
				ch =  false;
				return false;
			}
		});

		if( ch == true ){
		//기 신청건 체크 
		var data = ajaxCall("${ctx}/WorkTimeAppDet.do?cmd=getWorkTimeAppDetDupCnt", $("#searchForm").serialize(),false);
	
			if(data.DATA != null && data.DATA.dupCnt != "null" && data.DATA.dupCnt != "0"){
				alert("동일한 근무월에 신청내역이 있습니다.");
				return false;
			}
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

            //전체 삭제 후 다시 저장 하기 때문에 입력으로 변경
            for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
            	sheet1.SetCellValue(i, "sStatus", "I", 0);
            }
            


            //필수입력 항목 체크
	        var saveStr1 = sheet1.GetSaveString(0);
            if(saveStr1.match("KeyFieldError")) { return false; }
            
            IBS_SaveName(document.searchForm, sheet1);
            var params = $("#searchForm").serialize()+"&"+saveStr1;
            var rtn = eval("("+sheet1.GetSaveData("${ctx}/WorkTimeAppDet.do?cmd=saveWorkTimeAppDet", params )+")");
            
            
            if(rtn.Result.Code < 1) {
                alert(rtn.Result.Message);
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
	
	//Web 인쇄 시 호출
	function setPrintHeight(){
		var ih = ( sheet1.RowCount() ) * 28;
		sheet1.SetSheetHeight(80 + ih); 
		
		sheetResize();
		parent.iframeOnLoad(parent.$("#authorFrame").contents().height());
		
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
	
	<input type="hidden" id="searchWorkOrgCd"	name="searchWorkOrgCd"	 value=""/>
	
	<select id="hdnWorkOrg" class="hide"></select>
	
	<div class="sheet_title">
		<ul>
			<li class="txt">신청내용</li>
		</ul>
	</div>
	<table class="table">
		<colgroup>
			<col width="120px" />
			<col width="200px" />
			<col width="120px" />
			<col width="" />
		</colgroup> 
	
		<tr>
			<th>근무년월</th>
			<td>
				<input id="ym" name="ym" type="text" class="${dateCss} ${required} w70 spacingN" readonly maxlength="7" />
			</td>
			<th>대상부서</th>
			<td>
				<select id="orgCd" name="orgCd" class="${selectCss} ${required} spacingN" ${disabled}> </select>
			</td>
		</tr>
		<tr>
			<th>비고</th>
			<td colspan="3" >
				<textarea rows="3" id="note" name="note" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea>
			</td>
		</tr>
	</table>
	</form>
	
	<div class="sheet_title">
		<ul>
			<li id="empTitle" class="txt">대상자</li> 
			<li class="btn"> &nbsp; </li>
		</ul>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "200px", "${ssnLocaleCd}"); </script>
	
	<div class="hide">
		<script type="text/javascript"> createIBSheet("saveSheet", "100%", "100px"); </script>
	</div>	
		
</div>
		
</body>
</html>