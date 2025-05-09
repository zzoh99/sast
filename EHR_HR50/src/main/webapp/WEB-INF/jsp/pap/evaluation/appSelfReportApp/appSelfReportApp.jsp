<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {

		//평가명
		var coboCodeList1 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdListMobOrgTargetReg&searchAppTypeCd=E&searchAppraisalSeq=0",false).codeList, "");	//평가명
		$("#searchAppraisalCd").html(coboCodeList1[2]);

		var tmpHeaderInfo = ajaxCall("${ctx}/AppSelfReportApp.do?cmd=getAppSelfReportAppColList",$("#srchFrm").serialize(), false);
		var headerInfo = tmpHeaderInfo.DATA;

		if (headerInfo == 'undefine' || headerInfo == null){
			return false;
		}

		var tempCols = [
						{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
						{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
						{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
						{Header:"평가ID코드",			Type:"Text",	Hidden:1,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
						{Header:"소속",				Type:"Text",	Hidden:0,	Width:150,	Align:"Cneter",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
						{Header:"사번",				Type:"Text",	Hidden:0,	Width:70,	Align:"Cneter",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
						{Header:"성명",				Type:"Text",	Hidden:0,	Width:70,	Align:"Cneter",	ColMerge:0,	SaveName:"name",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
						{Header:"비고",				Type:"Text",	Hidden:1,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
						{Header:"진행상태",			Type:"Combo",	Hidden:0,	Width:70,	Align:"Cneter",	ColMerge:0,	SaveName:"appStatus",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
					   ];


		for(var i = 0; i<headerInfo.length; i++ ){

			tempCols.push({Header:headerInfo[i].headerNm,	Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:headerInfo[i].saveNm,	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 });
		}




		tempCols.push({Header:"전환배치희망",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item8",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 });
		tempCols.push({Header:"희망부문(부서)1코드",	Type:"Text",	Hidden:1,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item9",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 });
		tempCols.push({Header:"희망부문(부서)1명",		Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item9Nm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 });
		tempCols.push({Header:"희망부문(부서)2코드",	Type:"Text",	Hidden:1,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item12",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 });
		tempCols.push({Header:"희망부문(부서)2명",		Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item12Nm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 });
		tempCols.push({Header:"전환시기",				Type:"Combo",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item10",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 });
		tempCols.push({Header:"전환사유",				Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item11",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 });

		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:9,SearchMode:smLazyLoad,Page:100,MergeSheet:msAll};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = tempCols;
		IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//진행상태
		$("#searchAppStatus").html("<option value=''>전체</option> <option value='0'>미작성</option> <option value='1'>작성중</option> <option value='2'>확인요청</option> <option value='3'>확인</option>");
		sheet1.SetColProperty("appStatus", 			{ComboText:"미작성|작성중|확인요청|확인", ComboCode:"0|1|2|3"} );

		//전환시기
		sheet1.SetColProperty("item10", 			{ComboText:"|빠른시일내|6개월 이내|1년 이내|적당한 시기에|해당없음", ComboCode:"|1|2|3|4|5"} );

		//전환배치희망
		sheet1.SetColProperty("item8", 			{ComboText:"|현 부서(팀) 유지를 원함|타 부서(팀)으로 전환배치를 원함", ComboCode:"|N|Y"} );


		//변경 이벤트 연결
		$("#searchAppraisalCd").change(function(){
			doAction1("Search");
		});

		$("#searchAppStatus").change(function(){
			doAction1("Search");
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppSelfReportApp.do?cmd=getAppSelfReportAppList", $("#srchFrm").serialize() ); break;
		case "Save": 		
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/AppSelfReportApp.do?cmd=saveAppSelfReportApp", $("#srchFrm").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "col2"); break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
		break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}


	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
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

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value) {
		try{

			var rv = null;
			var args    = new Array();

			args["elementType"] = sheet1.GetCellValue(Row, "elementType");
			args["elementCd"]   = sheet1.GetCellValue(Row, "elementCd");
			args["elementNm"]   = sheet1.GetCellValue(Row, "elementNm");
			args["sdate"]       = sheet1.GetCellValue(Row, "sdate");

			if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
				var rv = openPopup("/PayAllowanceElementPropertyPopup.do?cmd=payAllowanceElementPropertyPopup", args, "1000","520");
				if(rv!=null){
				}
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

//  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet1_OnPopupClick(Row, Col){
        try{

          var colName = sheet1.ColSaveName(Col);
          var args    = new Array();

          args["name"]   = sheet1.GetCellValue(Row, "name");
          args["sabun"]  = sheet1.GetCellValue(Row, "sabun");

          var rv = null;

          if(colName == "name") {

              var rv = openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
              if(rv!=null){
                  sheet1.SetCellValue(Row, "name",   rv["name"] );
                  sheet1.SetCellValue(Row, "sabun",  rv["sabun"] );

                  sheet1.SetCellValue(Row, "resNo",  rv["resNo"].replace(/\//g,'') );
              }
          }

        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }

	function changeCols(){

		var rtnValue = true;
		var grcode = "";
		if($("#schType").val() == "1"){
			grcode = "H20030";
		}else if($("#schType").val() == "2"){
			grcode = "H10050";
		}else if($("#schType").val() == "3"){
			grcode = "H10030";
		}

		var tmpHeaderInfo = ajaxCall("${ctx}/AppSelfReportApp.do?cmd=getAppSelfReportAppColList","grpCd="+grcode+"&useYn=Y", false);
		var headerInfo = tmpHeaderInfo.DATA;

		if (headerInfo == 'undefine' || headerInfo == null){
			return false;
		}

		var tempCols = [
						{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
						{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
						{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
						{Header:"평가ID코드",			Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
						{Header:"사원번호",			Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
						{Header:"성명",				Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"name",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
						{Header:"소속",				Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
						{Header:"비고",				Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
						{Header:"진행상태",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"appStatus",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
					   ];


		for(var i = 0; i<headerInfo.length; i++ ){
			tempCols.push({Header:headerInfo[i].headerNm,	Type:"Text",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:headerInfo[i].saveNm,	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 });
		}




		tempCols.push({Header:"전환배치희망",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item8",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 });
		tempCols.push({Header:"희망부문(부서)1코드",	Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item9",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 });
		tempCols.push({Header:"희망부문(부서)1명",		Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item9Nm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 });
		tempCols.push({Header:"희망부문(부서)2코드",	Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item12",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 });
		tempCols.push({Header:"희망부문(부서)2명",		Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item12Nm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 });
		tempCols.push({Header:"전환시기",				Type:"Combo",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item10",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 });
		tempCols.push({Header:"전환사유",				Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item11",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 });



		sheet1.Reset();

		// 2번 그리드
		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:100,MergeSheet:msAll};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = tempCols;
		IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);


		return headerInfo.length;
	}

	function changeState(){

		for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
			var chk = sheet1.GetCellValue(i, "selectChk");
			sheet1.SetCellValue(i,"appStatus",'3');
		}
	}
	
	
	// 소속 팝입
	function orgSearchPopup() {
		var w		= 680;
		var h		= 520;
		var url		= "/Popup.do?cmd=orgBasicPopup";
		var args	= new Array();

		var result = openPopup(url+"&authPg=R", args, w, h);

		if (result) {
			var orgCd	= result["orgCd"];
			var orgNm	= result["orgNm"];

			$("#searchOrgCd").val(orgCd);
			$("#searchOrgNm").val(orgNm);
		}
	}

	
//  사원 팝입
	function employeePopup(){
	    try{

	     var args    = new Array();
	     var rv = openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
	        if(rv!=null){


	         $("#searchName").val(rv["name"]);
	         $("#searchSabun").val(rv["sabun"]);

	        }
	    }catch(ex){alert("Open Popup Event Error : " + ex);}
	}


</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명 </span> <select id="searchAppraisalCd" name="searchAppraisalCd"> </select>
						</td>
						<td>
							<span>소속</span>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text readonly w150" readOnly />
							<input id="searchOrgCd" name ="searchOrgCd" type="hidden" class="text"  />
							<a onclick="javascript:orgSearchPopup('primary');" class="button6 btnGroup2"><img src="/common/images/common/btn_search2.gif"/></a>
							<a onclick="$('#item9,#item9Nm').val('');" class="button7 btnGroup2"><img src="/common/images/icon/icon_undo.png"/></a>
						</td>
						<td>
							<span>성명 </span>
							<input id="searchName" name ="searchName" value="" type="text" class="text readonly " readOnly />
							<input id="searchSabun" name ="searchSabun" value="" type="hidden" class="text"  />
							<a onclick="javascript:employeePopup();" class="button6 btnGroup1"><img src="/common/images/common/btn_search2.gif"/></a>
							<a onclick="$('#searchSabun,#searchName').val('');" class="button7 btnGroup1"><img src="/common/images/icon/icon_undo.png"/></a>
						</td>
						<td> <span>진행상태 </span> <select id="searchAppStatus" name="searchAppStatus"> </select> </td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">자기신고서 승인</li>
							<li class="btn">
								<a href="javascript:changeState();" 			class="basic authA">전체확인</a>
								<a href="javascript:doAction1('Save');" 		class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel');" 	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>