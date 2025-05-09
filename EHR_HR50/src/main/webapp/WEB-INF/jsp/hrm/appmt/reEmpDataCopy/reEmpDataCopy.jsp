<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",						Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>",					Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>",					Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0,	SaveName:"sStatus", Sort:0 },
			
			{Header:"<sht:txt mid='proBtn' mdef='작업|작업'/>",						Type:"Html",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"proBtn",	 		KeyField:0, Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='name' mdef='성명|성명'/>",						Type:"Popup",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:1, Format:"",			PointCount:0,	UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='resNo' mdef='주민등록번호|주민등록번호'/>",			Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"resNo",			KeyField:0,	Format:"IdNo",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"재입사|전출(퇴직)회사",											Type:"Combo",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"ordEnterCd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='ordEnterSabun' mdef='재입사|전출(퇴직)사번'/>",		Type:"Text",		Hidden:0,	Width:100,  Align:"Center",	ColMerge:0,	SaveName:"ordEnterSabun",	KeyField:1, Format:"",			PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='sabun' mdef='현재사번|현재사번'/>",					Type:"Text",		Hidden:0,	Width:100,  Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1, Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='chkid' mdef='작업자정보|성명'/>",					Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"chkid",			KeyField:0, Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='workDate' mdef='작업자정보|작업일'/>",				Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"workDate",		KeyField:0, Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='completeYn' mdef='이관완료\n여부|이관완료\n여부'/>",	Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"completeYn",		KeyField:0, Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='workStTime' mdef='작업내역|시작시간'/>",			Type:"Text",		Hidden:1,	Width:130,  Align:"Center",	ColMerge:0,	SaveName:"workStTime",		KeyField:0, Format:"YmdHms",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='workEdTime' mdef='작업내역|종료시간'/>",			Type:"Text",		Hidden:1,	Width:130,  Align:"Center",	ColMerge:0,	SaveName:"workEdTime",		KeyField:0, Format:"YmdHms",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='noteV1' mdef='비고|비고'/>",						Type:"Text",		Hidden:0,	Width:200,  Align:"Left",	ColMerge:0,	SaveName:"bigo",			KeyField:0, Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1333 },
			{Header:"<sht:txt mid='errMsg' mdef='에러내역|에러내역'/>",				Type:"Text",		Hidden:0,	Width:200,  Align:"Left",	ColMerge:0,	SaveName:"errMsg",			KeyField:0, Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1333, Wrap:1 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		var ordEnterCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W90000"), "");	//전출회사
		
		sheet1.SetColProperty("ordEnterCd", 	{ComboText:"|"+ordEnterCd[0], ComboCode:"|"+ordEnterCd[1]} );
		
		$("#searchCompleteYn").html("<option value=''><tit:txt mid='103895' mdef='전체'/></option> <option value='Y'>Y</option> <option value='N'>N</option>");
		$("#searchCompleteYn").change(function(){
			doAction1("Search");	
		}); 
		
		$("#regYmdFrom").datepicker2({startdate:"regYmdTo"});
		$("#regYmdTo").datepicker2({enddate:"regYmdFrom"});
		
		$("#searchSabun, #searchOrdEnterSabun, #searchName").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/ReEmpDataCopy.do?cmd=getReEmpDataCopyList", $("#srchFrm").serialize() ); 
			break;
		case "Save":
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/ReEmpDataCopy.do?cmd=saveReEmpDataCopy", $("#srchFrm").serialize()); 
			break;
		case "Insert":
			var lRow = sheet1.DataInsert(0);
			sheet1.SelectCell(lRow, "name"); 
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":  
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param); 
		break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{ 
			if (Msg != ""){ 
				alert(Msg); 
			} 
			
			for(var r = sheet1.HeaderRows(); r<sheet1.RowCount()+sheet1.HeaderRows(); r++){
				if(sheet1.GetCellValue(r,"completeYn") == 'N'){
					sheet1.SetCellValue(r, "proBtn", '<a class="basic" href="javascript:fn_change_sabun(\''+r+'\')"><tit:txt mid='112620' mdef='이관'/></a>');
					sheet1.SetCellValue(r, "sStatus","R");
				}else if(sheet1.GetCellValue(r,"completeYn") == 'Y'){
					sheet1.SetRowEditable(r,0);
				}
			}
			sheetResize(); 
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{ 
			if(Msg != ""){ 
				alert(Msg); 
			} 
			doAction1("Search");
		}catch(ex){ 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}

	function fn_change_sabun(f_row){
		$("#sabun").val(sheet1.GetCellValue(f_row,"sabun"));
		$("#ordEnterCd").val(sheet1.GetCellValue(f_row,"ordEnterCd"));	
	   	$("#ordEnterSabun").val(sheet1.GetCellValue(f_row,"ordEnterSabun"));

	   	if(confirm("이관 작업을 실행 하시겠습니까?")) {
		   progressBar(true) ;

			// 프로그래스바 적용을 위해 타이머 실행 
			setTimeout(function(){
				var result = ajaxCall("${ctx}/ReEmpDataCopy.do?cmd=prcP_HRM_POST_REEMP_DATA_COPY", $("#srchFrm").serialize(), false);
					if ( result.Result.Code == "YES" )  {
							progressBar(false) ;
							alert("<msg:txt mid='110073' mdef='이관 작업을 완료 하였습니다.'/>");
							doAction1("Search");
						} else {
							progressBar(false) ;
							alert("<msg:txt mid='109624' mdef='작업 중 오류가 발생 했습니다.'/>");
							doAction1("Search");
						}
				}
			, 500);
			
			//doAction1("Search");
		}
	   
	}
	
	// Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
	function sheet1_OnPopupClick(Row, Col){
		try{
			if(sheet1.ColSaveName(Col) == "name") {
				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "reEmpDataCopyEmpLayer";

				var reEmpDataCopyEmpLayer = new window.top.document.LayerModal({
					id: 'reEmpDataCopyEmpLayer',
					url: '/ReEmpDataCopy.do?cmd=viewReEmpDataCopyEmpLayer&authPg=R',
					parameters: {},
					width: 1024,
					height: 700,
					title: '재입사자검색',
					trigger: [
						{
							name: 'reEmpDataCopyEmpTrigger',
							callback: function(rv) {
								getReturnValue(rv);
							}
						}
					]
				});
				reEmpDataCopyEmpLayer.show();
			}					
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	

	// 셀 값이 바뀔때 발생
	function sheet1_OnChange(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "completeYn") {
				//확정여부에 따라 입력가능하게 변경
				if(sheet1.GetCellValue(Row,"completeYn") == "Y"){
					sheet1.SetRowEditable(Row,1);
				}else{
					sheet1.SetRowEditable(Row,0);
				}
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	
	//팝업 콜백 함수.
	function getReturnValue(rv) {
		if(pGubun == "reEmpDataCopyEmpLayer"){
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"] );
			sheet1.SetCellValue(gPRow, "ordEnterCd", rv["ordEnterCd"] );
			sheet1.SetCellValue(gPRow, "ordEnterSabun", rv["ordEnterSabun"] );
			sheet1.SetCellValue(gPRow, "name", rv["name"] );
			sheet1.SetCellValue(gPRow, "resNo", rv["resNo"]);
		}		
	}
	
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >	
		<input type="hidden" id="sabun" name="sabun" />
		<input type="hidden" id="ordEnterCd" name="ordEnterCd" />
		<input type="hidden" id="ordEnterSabun" name="ordEnterSabun" />
		
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='' mdef='작업기간'/></th>
						<td>
							<input id="regYmdFrom" name="regYmdFrom" type="text" size="10" class="date2" value="<%//= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>"/> ~
							<input id="regYmdTo" name="regYmdTo" type="text" size="10" class="date2" value="<%//=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
						</td>
						<th><tit:txt mid='' mdef='성명'/></th>
						<td>
							<input id="searchName" name ="searchName" type="text" class="text" />
						</td>
						<th><tit:txt mid='' mdef='현재사번'/></th>
						<td>
							<input id="searchSabun" name ="searchSabun" type="text" class="text" />
						</td>
						<th><tit:txt mid='' mdef='전출(퇴직)사번'/></th>
						<td>
							<input id="searchOrdEnterSabun" name ="searchOrdEnterSabun" type="text" class="text" />
						</td>
						<th><tit:txt mid='112410' mdef='이관완료여부 '/></th>
						<td colspan="3">
							 <select id="searchCompleteYn"  name="searchCompleteYn"/>
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='search' mdef="조회"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="explain">
						<div class="title">※ 도움말</div>
						<div class="txt">
							<ul>
								<li><font color="red"><b>※ [사간전입/재입사] 발령 시 입사 발령 처리 후 전출(퇴직)회사 사번의 정보를 입사 발령 된 현재 사번의 정보로 이관 합니다.</b></font></li>
								<li><font color="red"><b>※ 인사자료 삭제 처리 후 복사되므로 참고 바랍니다. (필수 : 사간전입, 재입사 발령 처리 후 사용)</b></font></li>
								<li>▶ [이관 대상] : 기본, 연락처, 주소, 가족, 학력, 자격, 경력, 상벌, 보증, 병역, 보훈, 장애, 기록사항, 교육이력 등 <font color="blue"> &nbsp; > 시스템 > 변경관리 > 인사정보복사기준관리 셋업 항목 </font></li>
								<li>▶  [이관 제외] : 개인조직사항, 개인발령사항</li>
							</ul>

						</div>
					</div>				
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='112542' mdef='재입사자정보이관'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Insert')"		css="basic authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')"		  css="basic authA" mid='save' mdef="저장"/>
								<a href="javascript:doAction1('Down2Excel')"	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
