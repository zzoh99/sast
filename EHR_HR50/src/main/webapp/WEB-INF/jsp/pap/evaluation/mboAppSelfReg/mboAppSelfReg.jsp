<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"목표측정지표(KPI)",	Type:"Combo",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"mboIndexKpi",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:300 },
			{Header:"지표구분",			Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appIndexGubunCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"가중치(%)",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appBasisPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:3 },
			{Header:"목표",				Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"mboTarget",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:300 },
			{Header:"측정방법",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appIndexMethod",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:300 },
			{Header:"본인실적",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSelfResult",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:30 },
			{Header:"본인평가",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"SEQ",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가id",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"사번",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"자기평가확정여부",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가점수",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appPoint",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"첨부파일",			Type:"Html",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"첨부번호",			Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		
		
		var initdata2 = {};
		initdata2.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22}; 
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"평가id",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"사번",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"본인의견",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appMemo",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		
		
		
		//평가명
		var comboCodeList1 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdListMobOrgTargetReg&searchAppTypeCd=A&searchAppraisalSeq=0&searchAppStepCd=5",false).codeList, "");
		$("#searchAppraisalCd").html(comboCodeList1[2]);
		
		$("#searchAppraisalCd").change(function(){
			doAction1("Search");	
		});	
		
		//지표구분
		var comboCodeList2 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00011"), "");
		sheet1.SetColProperty("appIndexGubunCd", 			{ComboText:comboCodeList2[0], ComboCode:comboCodeList2[1]} );
		
		//평가진행상태
		 var v_status = ajaxCall("/MboAppSelfReg.do?cmd=getMboAppSelfRegStatusMap",$("#srchFrm").serialize(),false);
		 if(v_status != null && v_status.map != null){
			$("#searchStatus").val(v_status.map.status);
			$("#searchStatusCd").val(v_status.map.statusCd);
		 } 
		 
		//평가 Admin 여부에 따라 버튼 체크 
		 var papAdmin = ajaxCall("/MboOrgTargetReg.do?cmd=getMboOrgTargetRegPapAdminMap","&searchSabun="+$("#searchSabun").val(),false); //admin 여부
	     	if(papAdmin != null && papAdmin.map != null) {
	     		if(papAdmin.map.papAdminYn == 'N'){
	     			$(".button6").hide();
	     			$(".button7").hide();
	     		}
	     	}
		 
		 
     	//평가기간 체크 하여 버튼 보임 안보임 처리        
        var data2 = ajaxCall("/MboOrgTargetReg.do?cmd=getTargetButtonVislYnMap","searchAppraisalCd="
        		+$("#searchAppraisalCd").val()+"&searchappStepCd=5",false);
        if(data2 != null && data2.map != null) {
        	if(data2.map.vislYn == "N"){
     			$(".group2").hide();
     		}
        }
			
		
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/MboAppSelfReg.do?cmd=getMboAppSelfRegList", $("#srchFrm").serialize() ); break;
		case "Save": 		
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/MboAppSelfReg.do?cmd=saveMboAppSelfReg", $("#srchFrm").serialize()); break;
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
	//Example Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet2.DoSearch( "${ctx}/MboAppSelfReg.do?cmd=getMboAppSelfRegList2", $("#srchFrm").serialize() ); break;
		case "Save": 		setSheetData();
							if($("#searchStatusCd").val() == "5"){
								alert("평가완료 상태에서는 저장할 수 없습니다.");
								 break;
							}
							IBS_SaveName(document.srchFrm,sheet2);
							sheet2.DoSave( "${ctx}/MboAppSelfReg.do?cmd=saveMboAppSelfReg2", $("#srchFrm").serialize()); break;
		case "Insert":		sheet2.SelectCell(sheet1.DataInsert(0), "col2"); break;
		case "Copy":		sheet2.DataCopy(); break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":	sheet2.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{ 
			if (Msg != ""){ 
				alert(Msg); 
			} 
			//평가진행상태
			 var v_status = ajaxCall("/MboAppSelfReg.do?cmd=getMboAppSelfRegStatusMap",$("#srchFrm").serialize(),false);
			 if(v_status != null && v_status.map != null){
				$("#searchStatus").val(v_status.map.status);
				$("#searchStatusCd").val(v_status.map.statusCd);
			 } 
			 
			//목표측정KIP ComboBox
			 var coboCodeList3 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTargetIndexKpiCdListSabun&searchSabun="+$("#searchSabun").val()+"&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, "");
             sheet1.SetColProperty("mboIndexKpi", 			{ComboText:coboCodeList3[0], ComboCode:coboCodeList3[1]} );
            
			 
			 
			 if($("#searchStatusCd").val() == "5"){
				sheet1.SetColEditable("appSelfResult",0);
			 }else{
				sheet1.SetColEditable("appSelfResult",1);
			 }
			 
			//파일 첨부 시작
				for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){

						if(sheet1.GetCellValue(i,"fileSeq") == ''){
							sheet1.SetCellValue(i, "btnFile", '<a class="basic">첨부</a>');
							sheet1.SetCellValue(i, "sStatus", 'R');
						}else{
							sheet1.SetCellValue(i, "btnFile", '<a class="basic">다운로드</a>');
							sheet1.SetCellValue(i, "sStatus", 'R');
						}
				}
			
			doAction2("Search");
			sheetResize(); 
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{ 
			if (Msg != ""){ 
				alert(Msg); 
			} 
			getSheetData();
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
	
	
	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{ 
			if(Msg != ""){ 
				alert(Msg); 
			} 
			doAction2("Search");
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
			
			if(sheet1.ColSaveName(Col) == "btnFile"){
				var param = [];
				param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");
				if(sheet1.GetCellValue(Row,"btnFile") != ""){
					var authPgTemp="${authPg}";
					var rv = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp, param, "740","620");
					if(rv != null){
						if(rv["fileCheck"] == "exist"){
							sheet1.SetCellValue(Row, "btnFile", '<a class="basic">다운로드</a>');
							sheet1.SetCellValue(Row, "fileSeq", rv["fileSeq"]);
						}else{
							sheet1.SetCellValue(Row, "btnFile", '<a class="basic">첨부</a>');
							sheet1.SetCellValue(Row, "fileSeq", "");
						}
					}
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
    
    function goRequest() {
        
    	var chkCount = 0;
  		chkCount = sheet1.RowCount("U") + sheet1.RowCount("I") + sheet1.RowCount("D");
  		if(chkCount > 0){
  			alert("저장 후 승인요청 하시기 바랍니다.");
			return;
  		}
  		
  		for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){ 
    		if(sheet1.GetCellValue(i, "appSelfResult") == ""){
    			alert("실적을 입력 하지 않은 항목이 존재합니다. \n 실적 입력 후 평가확정 해 주시기 바랍니다." );
    			return;
    		}
    	}
         
         if ($("#searchAppMemo").val() == "" ) 
         {
             alert("본인의견을 작성하세요.");
             $("#searchAppMemo").focus();
             return;
         }else if($("#searchAppMemo").val() != "" && sheet2.GetCellValue(sheet2.LastRow(),"appMemo") == ""){
        	 alert("본인의견을 저장후 평가확정 해 주세요.");
        	 return;
         }
     

        if(sheet1.RowCount(0) > 0){
           
            
    	    if (confirm("평가확정 후에는 평가내용을 수정 할 수 없습니다.\n평가확정을 취소 하시려면 평가담당자에게 문의 하세요.\n평가확정을 하시겠습니까?")){
    	    	var Request = ajaxCall("/MboAppSelfReg.do?cmd=saveMboAppSelfRegRequest",$("#srchFrm").serialize(),false);
    	    												  
        		if(Request.Result != null){
        			alert(Request.Result.Message);
        			doAction1("Search");
        		}
            }
        }
        else {
            alert("조회된 데이타가 없습니다.");
            return;    
        }
    }
    
    
    
 // 시트에서 폼으로 세팅.
	function getSheetData() {

		var chkCnt = sheet2.RowCount();
		var row = sheet2.LastRow();

		if(chkCnt == 0) {
			$('#searchAppMemo').val("");
			return;
		}
		
		$('#searchAppMemo').val(sheet2.GetCellValue(row,"appMemo"));
	}
	
	// 폼에서 시트로 세팅.
	function setSheetData() {
		var chkCnt = sheet2.RowCount();
		var row;
		if(chkCnt  == 0){
			row = sheet2.DataInsert(0);
		}else{
			row = sheet2.LastRow();
		}
		sheet2.SetCellValue(row,"appraisalCd",$("#searchAppraisalCd").val());
		sheet2.SetCellValue(row,"sabun",$("#searchSabun").val());
		sheet2.SetCellValue(row,"appMemo",$("#searchAppMemo").val());
	}
	
	//사원 팝입
    function employeePopup(){
        try{
         
         var args    = new Array();
         var rv = openPopup("/Popup.do?cmd=employeePopup", args, "740","520");   
            if(rv!=null){
	            $("#searchName").val(rv["name"]);
	            $("#searchSabun").val(rv["sabun"]);
	            $("#searchOrgNm").val(rv["orgNm"]);
	            $("#searchJikweeNm").val(rv["jikweeNm"]);
	            $("#searchJikchakNm").val(rv["jikchakNm"]);
	            
	         	doAction1("Search");
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
						<td> <span>평가명 </span> <select id="searchAppraisalCd" name="searchAppraisalCd"> </select> </td>
						<td> <span>평가진행상태 </span> <input id="searchStatus" name ="searchStatus" type="text" class="text readonly"  readonly/> 
						<input id="searchStatusCd" name ="searchStatusCd" type="hidden"/> 
						</td>
						<td> <span>성명 </span>
							<input id="searchName" name ="searchName" type="text" class="text readonly" readOnly value="${sessionScope.ssnName}"/>
							<input id="searchSabun" name ="searchSabun" type="hidden" class="text" value="${sessionScope.ssnSabun}"  />
							<a onclick="javascript:employeePopup();" class="button6"><img src="/common/images/common/btn_search2.gif"/></a>
							<a onclick="$('#searchSabun,#searchName').val('');" class="button7"><img src="/common/images/icon/icon_undo.png"/></a> 
						
						</td>
						<td> <span>소속 </span> <input id="searchOrgNm"    name ="searchOrgNm" type="text" class="text readonly w150" value="${sessionScope.ssnOrgNm}" readonly/> </td>
						<td> <span>직위 </span> <input id="searchJikweeNm" name ="searchJikweeNm" type="text" class="text readonly w40" value="${sessionScope.ssnJikweeNm}" readonly/> </td>
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
							<li id="txt" class="txt">실적등록</li>
							<li class="btn">
								<a href="javascript:goRequest();" class="basic authA group2">평가확정</a>
								<a href="javascript:doAction1('Save')" 	class="basic authA group2">저장</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "80%","kr"); </script>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">본인의견</li>
							<li class="btn">
								<a href="javascript:doAction2('Save')" 	class="basic authA group2">저장</a>
							</li>
						</ul>
					</div>
					<table class="table w100p" id="htmlTable">
						<tr>
							<td >				
								<textarea id="searchAppMemo" name="searchAppMemo" class="w100p" rows="3"></textarea>
							</td>
						</tr>
					</table>	
				</div>
				<div style="display:none">
				<script type="text/javascript">createIBSheet("sheet2", "100%", "80%","kr"); </script>
				</div>
			</td>
		</tr>
	</table>
</div>
</body>
</html>