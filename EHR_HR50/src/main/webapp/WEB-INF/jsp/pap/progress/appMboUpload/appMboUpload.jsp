<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:8,SearchMode:smLazyLoad,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"평가코드|평가코드",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"피평가자|소속",		Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"피평가자|사번",		Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"피평가자|성명",		Type:"Popup",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|직책",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"피평가자|직위",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"피평가자|직급",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"피평가자|직종",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"피평가자|직무",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jobNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"피평가자|평가그룹",	Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appGroupCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			{Header:"업적평가|본인",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mboSelfPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"업적평가|등급",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mboSelfClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"업적평가|1차",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mbo1stPoint",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"업적평가|등급",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mbo1stClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"업적평가|2차",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mbo2ndPoint",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"업적평가|등급",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mbo2ndClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"업적평가|평가점수",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mboPoint",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"업적평가|평가등급",	Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"mboClassCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"비고|비고",			Type:"Text",	Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		// 헤더 머지
		sheet1.SetMergeSheet( msHeaderOnly);
		
		//평가코드
		var comboCdList1 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListAppType&searchAppTypeCd=A,",false).codeList, "");
		$("#searchAppraisalCd").html(comboCdList1[2]);
		
		
		
		//최종등급
		var comboCdList2 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00001"), "");
		sheet1.SetColProperty("mboClassCd", 			{ComboText:comboCdList2[0], ComboCode:comboCdList2[1]} );
		
		
		//직위
		var comboCdList3 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "전체");
		$("#searchJikwee").html(comboCdList3[2]);
		
		//직책
		var comboCdList4 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"), "전체");
		$("#searchJikchak").html(comboCdList4[2]);
		
		//직종
		var comboCdList5 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050"), "전체");
		$("#searchWorkType").html(comboCdList5[2]);
		
		
		
		$("#searchAppraisalCd,#searchJikwee,#searchJikchak,#searchWorkType").change(function(){
			doAction1("Search");	
		});		
		
		$("#searchOrgNm,#searchName").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppMboUpload.do?cmd=getAppMboUploadList", $("#srchFrm").serialize() ); break;
		case "Save": 		
							if (!dupChk(sheet1, "appraisalCd|sabun", false, true)) {break;}
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/AppMboUpload.do?cmd=saveAppMboUpload", $("#srchFrm").serialize()); 
							break;
		case "Insert":		
							var row = sheet1.DataInsert(0);
							sheet1.SetCellValue(row,"appraisalCd",$("#searchAppraisalCd").val());
							sheet1.SelectCell(row, "name"); 
							break;
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
			
			var comboCdList6 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppGroupCdList1&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, "");
			sheet1.SetColProperty("appGroupCd", 			{ComboText:comboCdList6[0], ComboCode:comboCdList6[1]} );
			
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

// 			var rv = null;
// 			var args    = new Array();

// 			args["elementType"] = sheet1.GetCellValue(Row, "elementType");
// 			args["elementCd"]   = sheet1.GetCellValue(Row, "elementCd");
// 			args["elementNm"]   = sheet1.GetCellValue(Row, "elementNm");
// 			args["sdate"]       = sheet1.GetCellValue(Row, "sdate");

// 			if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
// 				var rv = openPopup("/PayAllowanceElementPropertyPopup.do?cmd=payAllowanceElementPropertyPopup", args, "1000","520");   
// 				if(rv!=null){
// 				}
// 			}
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

                  sheet1.SetCellValue(Row, "orgNm",  rv["orgNm"] );
                  sheet1.SetCellValue(Row, "jikweeNm",  rv["jikweeNm"] );
                  sheet1.SetCellValue(Row, "jikchakNm",  rv["jikchakNm"] );
                  sheet1.SetCellValue(Row, "workTypeNm",  rv["workTypeNm"] );
                  sheet1.SetCellValue(Row, "jobNm",  rv["jobNm"] );
              }
          }    
        
        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
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
	
	
	function sheet1_OnLoadExcel() {

		for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){ 
			sheet1.SetCellValue(i,"appraisalCd",$("#searchAppraisalCd").val());
		}

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
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd" onChange="javascript:doAction1('Search');">
							</select>
						</td>
						<td>
							<span>소속</span>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text w150"/>
							<input id="searchOrgCd" name ="searchOrgCd" type="hidden" class="text"  />
							<a onclick="javascript:orgSearchPopup('primary');" class="button6 btnGroup2"><img src="/common/images/common/btn_search2.gif"/></a>
							
						</td>
						<td>
							<span>성명 </span>
							<input id="searchName" name ="searchName" value="" type="text" class="text" />
							<input id="searchSabun" name ="searchSabun" value="" type="hidden" class="text"  />
							<a onclick="javascript:employeePopup();" class="button6 btnGroup1"><img src="/common/images/common/btn_search2.gif"/></a>
							
						</td>		
						<td></td>
					</tr>
					<tr>
						<td> <span>직위 </span> <select id="searchJikwee" 	name="searchJikwee"> </select> </td>
						<td> <span>직책 </span> <select id="searchJikchak" 	name="searchJikchak"> </select> </td>
						<td> <span>직종 </span> <select id="searchWorkType" 	name="searchWorkType"> </select> </td>
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
							<li id="txt" class="txt">업적평가업로드</li>
							<li class="btn">
								<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
								<a href="javascript:doAction1('LoadExcel')" 	class="basic authA">업로드</a>
								<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
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