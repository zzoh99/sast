<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='113886' mdef='발령처리담당자관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"발령",		    Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeNm",	KeyField:0,	Format:"",			CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"발령",		    Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",	KeyField:0,	Format:"",			CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령상세",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailNm",	KeyField:0,	Format:"",			CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"발령상세",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",	KeyField:0,	Format:"",			CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사원구분",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"manageCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"직급",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"순번",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applySeq",	KeyField:0,	Format:"",			CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"회사코드",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"enterCd",		KeyField:0,	Format:"",			CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"회사",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"enterNm",		KeyField:0,	Format:"",			CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사번",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"발령일",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"ordYmd",		KeyField:0,	Format:"Ymd",		CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령\n확정",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ordYn",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35, TrueValue : "Y" , FalseValue : "N" },
			{Header:"사번\n확인",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ordCheckYn",	KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:35, TrueValue : "Y" , FalseValue : "N" }

		]; IBS_InitSheet(sheet1, initdata1);

		sheet1.SetEditable("${editable}");
		sheet1.SetCountPosition(4);

		var ordTypeCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getRecCheckOrgTypeCd",false).codeList, "선택하세요");	//발령형태
		var enterCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getRecCheckCompanyList",false).codeList, "선택하세요");	//회사

		$("#ordTypeCd").html(ordTypeCd[2]).bind("change" , function(e){

			var ordTypeCd = $("#ordTypeCd").val();

			if ( ordTypeCd != "" ){

				var ordDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getRecCheckOrgDetailCd&ordTypeCd=" + ordTypeCd,false).codeList, "선택하세요");	//발령종류
				$("#ordDetailCd").html(ordDetailCd[2]);
			}else {

				$("#ordDetailCd").html("<option>선택하세요</option>");
			}
		});
		$("#enterCd").html(enterCd[2]);

		$(window).smartresize(sheetResize);
		sheetInit();

		$("#name").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		
		$("#ordSYmd").datepicker2({startdate:"ordEYmd"});
		$("#ordEYmd").datepicker2({enddate:"ordSYmd"});

		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":

				sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getRecCheckList", $("#sendForm").serialize() );
				break;
			case "Save":

				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/SaveData.do?cmd=saveRecCheckList", $("#sheet1Form").serialize());
				break;
			case "Down2Excel":

				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet1.Down2Excel(param);
				break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();

			for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++){

				// 발령형태 : 채용
				// 발령형태:  전환,   발령종류 : 정규직 전환
				if ( "${ssnEnterCd}" != "ISU_CM" && sheet1.GetCellValue( i ,"ordCheckYn") == "N" && sheet1.GetCellValue( i ,"ordYn") == "N" ){

					var ordTypeCd 	= sheet1.GetCellValue( i , "ordTypeCd");
					var ordDetailCd = sheet1.GetCellValue( i , "ordDetailCd");
					var manageCd 	= sheet1.GetCellValue( i , "manageCd");
					var jikgubCd	= sheet1.GetCellValue( i , "jikgubCd");

					if ( ordTypeCd == "110" || ( ordTypeCd == "330" && ordDetailCd == "1201" ) ){

						if ( manageCd == "10010" ){

							if ( jikgubCd == "A310" 	//1급갑
							  || jikgubCd == "A315"		//1급을
							  || jikgubCd == "A320"		//2급
							  || jikgubCd == "A325"		//3급
							  || jikgubCd == "A330"		//4급
							  || jikgubCd == "C510"		//B1
							  || jikgubCd == "C520"		//B2
							  || jikgubCd == "C530"		//B3
							  || jikgubCd == "C540"		//B4
							){
								sheet1.SetRowFontColor( i , "red" );
							}
						}
					}
				}
			}

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {

				alert(Msg);
			}

			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form"></form>

	<div class="wrapper">
	<form id="sendForm" name="sendForm" >
		<div class="sheet_search outer">
			<div>
			<table>
				<tr>
					<th>발령일자</th>
					<td>
						<input id="ordSYmd" name="ordSYmd" type="text" size="10" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>"/> ~
						<input id="ordEYmd" name="ordEYmd" type="text" size="10" class="date2" value=""/>
					</td>
					<th>회사</th>
					<td>
						<select id="enterCd" name="enterCd">
							<option>선택하세요</option>
						</select>
					</td>
					<th>발령확정여부</th>
					<td>
						<select id="ordYn" name="ordYn">
							<option value="">전체</option>
							<option value="Y">확정</option>
							<option value="N">미확정</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>발령형태</th>
					<td>
						<select id="ordTypeCd" name="ordTypeCd">
							<option value="">선택하세요</option>
						</select>
					</td>
					<th>발령종류</th>
					<td>
						<select id="ordDetailCd" name="ordDetailCd">
							<option value="">선택하세요</option>
						</select>
					</td>
					<th><tit:txt mid='104330' mdef='성명'/></th>
					<td>
						<input id="name" name="name" type="text" class="text"/>
					</td>
					<td>
						<btn:a href="javascript:doAction1('Search');" css="button" mid='search' mdef="조회"/>
					</td>
				</tr>
			</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">채용확인</li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Save');" css="basic authA" mid='save' mdef="저장"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='down2excel' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
