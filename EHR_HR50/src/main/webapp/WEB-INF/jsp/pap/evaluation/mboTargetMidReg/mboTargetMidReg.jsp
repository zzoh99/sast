<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var saveFlag;
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,			Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"순서",					Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sort",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가ID코드(TPAP101)",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"사원번호",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"SEQ",					Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"목표측정지표(KPI)",		Type:"Combo",	Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"targetIndexKpi",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"지표구분",				Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appIndexGubunCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"가중치\n(%)",			Type:"AutoSum",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appBasisPoint",	KeyField:1,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:3 },
			{Header:"최종가중치\n(%)",		Type:"AutoSum",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appFinalPoint",	KeyField:1,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:3 },
			{Header:"목표",					Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"target",				KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1330 },
			{Header:"목표세부내용",			Type:"Text",	Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"targetDetail",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1330 , MultiLineText:1,Wrap:1  },
			{Header:"측정방법/기준",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appIndexMethod",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:330 },
			{Header:"현수준\n(前실적)",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"curState",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:330 },
			{Header:"의견",					Type:"Text",	Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"chkMemo1",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:330, MultiLineText:1,Wrap:1   },
			{Header:"항목(P10009)",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"targetType",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"추진계획/추진방안",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"targetDetailMemo",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"목표(직전반기)",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"targetResultBefore",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"목표(이번반기)",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"targetResultAfter",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"면담1",					Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"chkMemo2",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		  sheet1.SetEditEnterBehavior("newline");

		var coboCodeList1 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdListMobOrgTargetReg&searchAppTypeCd=F&searchAppStepCd=4&searchAppraisalSeq=0",false).codeList, "");	//평가명
		var coboCodeList2 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppIndexGubunCdList",false).codeList, "");	//지표구분

		$("#searchAppraisalCd").html(coboCodeList1[2]);
		sheet1.SetColProperty("appIndexGubunCd", 			{ComboText:coboCodeList2[0], ComboCode:coboCodeList2[1]} );

		//평가자 정보
        var data = ajaxCall("/MboOrgTargetReg.do?cmd=getMboOrgTargetRegAppMap","searchAppraisalCd="
        		+$("#searchAppraisalCd").val()+"&searchSabun="+$("#searchSabun").val()+"&searchappStepCd=4",false);

     	if(data != null && data.map != null) {
     		$("#searchAppName").val(data.map.appName);
     		$("#searchStatusNm").val(data.map.statusNm);
     		$("#searchStatusCd").val(data.map.statusCd);
     		$("#searchAppSabun").val(data.map.appSabun);

     		if($("#searchStatusCd").val() == "25" || $("#searchStatusCd").val() == "29") {
            	$(".group1").show();
     		}else{
     			$(".group1").hide();
     		}

     	}

     	//평가기간 체크 하여 버튼 보임 안보임 처리
        var data2 = ajaxCall("/MboOrgTargetReg.do?cmd=getTargetButtonVislYnMap","searchAppraisalCd="
        		+$("#searchAppraisalCd").val()+"&searchappStepCd=4",false);
        if(data2 != null && data2.map != null) {
        	if(data2.map.vislYn == "N"){
     			$(".group2").hide();
     		}
        }

     	var papAdmin = ajaxCall("/MboOrgTargetReg.do?cmd=getMboOrgTargetRegPapAdminMap","&searchSabun="+$("#searchSabun").val(),false); //admin 여부
     	if(papAdmin != null && papAdmin.map != null) {
     		if(papAdmin.map.papAdminYn == 'N'){
     			$(".button6").hide();
     			$(".button7").hide();
     		}
     	}


		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/MboOrgTargetMidReg.do?cmd=getMboOrgTargetMidRegList", $("#srchFrm").serialize() ); break;
		case "Save":
							var sumValue = sheet1.GetSumValue("appIndexMethod");
							if(saveFlag == "F"){
								saveFlag = "T";
								break;
							}
							if(sumValue > 100){
								alert("가중치 합계가 100을 넘을 수  없습니다.");
								break;
							}
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/MboOrgTargetMidReg.do?cmd=saveMboOrgTargetMidReg", $("#srchFrm").serialize()); break;
		case "Insert":
							var Row = sheet1.DataInsert(0);
							sheet1.SetCellValue(Row, "sabun", $("#searchSabun").val());
							sheet1.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd").val());

							break;
		case "Copy":		var row = sheet1.DataCopy();
							sheet1.SetCellValue(row, "seq", "");
							break;
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

			 var coboCodeList3 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTargetIndexKpiCdList&searchAppSabun="+$("#searchAppSabun").val()+"&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, "");
             sheet1.SetColProperty("targetIndexKpi", 			{ComboText:coboCodeList3[0], ComboCode:coboCodeList3[1]} );

             //합계 행 다듬기
 			 var lr = sheet1.LastRow();
 			 sheet1.SetSumValue("sNo","합계");
			 sheet1.SetMergeCell(lr, 0, 1,3);

			 if(sheet1.RowCount() == 0){
				 $("#searchStatusNm").val("");
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


  //사원 팝입
    function employeePopup(){
        try{

         var args    = new Array();
         var rv = openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
            if(rv!=null){


	            $("#searchName").val(rv["name"]);
	            $("#searchSabun").val(rv["sabun"]);
	      		//평가자 정보
	            var data = ajaxCall("/MboOrgTargetReg.do?cmd=getMboOrgTargetRegAppMap","searchAppraisalCd="
	            		+$("#searchAppraisalCd").val()+"&searchSabun="+$("#searchSabun").val(),false);

	         	if(data != null && data.map != null) {
	         		$("#searchAppName").val(data.map.appName);
	         		$("#searchStatusNm").val(data.map.statusNm);
	         		$("#searchStatusCd").val(data.map.statusCd);
	         		$("#searchAppSabun").val(data.map.appSabun);
	         		if($("#searchStatusCd").val() == "25" || $("#searchStatusCd").val() == "29") {
	                	$(".group1").show();
	         		}else{
	         			$(".group1").hide();
	         		}
	         	}
	         	doAction1("Search");
            }
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }

  	//승인요청
  	function goRequest(){
  		if($("#searchAppraisalCd").val() == ""){
  			alert("평가명이 존재하지 않습니다.");
  			return;
  		}

  		if($("#searchStatusCd").val() == ""){
  			alert("목표합의서 등록 대상자가 아닙니다.");
  			return;
  		}

  		if(sheet1.RowCount("R") == 0){
  			alert("승인요청 할 데이터가 존재하지 않습니다.\n저장 후 승인요청 해주시기 바랍니다.");
            return;
  		}
  		var chkCount = 0;
  		chkCount = sheet1.RowCount("U") + sheet1.RowCount("I") + sheet1.RowCount("D");
  		if(chkCount > 0){
  			alert("저장 후 승인요청 하시기 바랍니다.");
			return;
  		}


  		if($("#searchStatusCd").val() == "27"){
 			alert("현재 승인요청된 상태 입니다.");
 			return;
 		}else if($("#searchStatusCd").val() == "99"){
 	        alert("현재 승인된 상태 입니다.");
 	        return;
 		}

  		var totalPoint = sheet1.GetSumValue("appFinalPoint");
  		if(totalPoint != 100){
  			alert("최종가중치의 합은 100%이(가) 되어야 합니다.");
			return;
  		}

  		if(!confirm("승인요청을 하시겠습니까?")){
 	       return;
 		}

  		 // 화면단
       var data = 	ajaxCall("/MboOrgTargetMidReg.do?cmd=prcMboOrgTargetMidRegAppReq",$("#srchFrm").serialize(),false);

  		 if(data.Result.Code == null) {
   			alert("처리되었습니다.");

   		//평가자 정보
            var data = ajaxCall("/MboOrgTargetReg.do?cmd=getMboOrgTargetRegAppMap","searchAppraisalCd="
            		+$("#searchAppraisalCd").val()+"&searchSabun="+$("#searchSabun").val(),false);

         	if(data != null && data.map != null) {
         		$("#searchAppName").val(data.map.appName);
         		$("#searchStatusNm").val(data.map.statusNm);
         		$("#searchStatusCd").val(data.map.statusCd);

         		if($("#searchStatusCd").val() == "25" || $("#searchStatusCd").val() == "29") {
                	$(".group1").show();
         		}else{
         			$(".group1").hide();
         		}
         	}
         	doAction1("Search");

    	} else {
	    	alert(data.Result.Message);
    	}

  	}


	function goRequestCancel(){

		if($("#searchStatusCd").val() == ""){
  			alert("목표합의서 등록 대상자가 아닙니다.");
  			return;
  		}

		if($("#searchStatusCd").val() != "21"){
			alert("현재 승인요청 상태가 아닙니다.");
			return;
		}

		if(!confirm("승인요청을 취소 하시겠습니까?")){
		       return;
		}

		// 화면단
        var data = 	ajaxCall("/MboOrgTargetReg.do?cmd=prcMboOrgTargetRegMidAppCancel",$("#srchFrm").serialize()+"&searchGubun=1",false);

  		if(data.Result.Code == null) {
   			alert("처리되었습니다.");

   		//평가자 정보
            var data = ajaxCall("/MboOrgTargetReg.do?cmd=getMboOrgTargetRegAppMap","searchAppraisalCd="
            		+$("#searchAppraisalCd").val()+"&searchSabun="+$("#searchSabun").val(),false);

         	if(data != null && data.map != null) {
         		$("#searchAppName").val(data.map.appName);
         		$("#searchStatusNm").val(data.map.statusNm);
         		$("#searchStatusCd").val(data.map.statusCd);

         		if($("#searchStatusCd").val() == "25" || $("#searchStatusCd").val() == "29") {
                	$(".group1").show();
         		}else{
         			$(".group1").hide();
         		}


             	//평가기간 체크 하여 버튼 보임 안보임 처리
                var data2 = ajaxCall("/MboOrgTargetReg.do?cmd=getTargetButtonVislYnMap","searchAppraisalCd="
                		+$("#searchAppraisalCd").val()+"&searchappStepCd=4",false);
                if(data2 != null && data2.map != null) {
                	if(data2.map.vislYn == "N"){
             			$(".group2").hide();
             		}
                }
         	}
         	doAction1("Search");

    	} else {
	    	alert(data.Result.Message);
    	}


	}

	 function sheet1_OnAfterEdit(Row, Col){
	        try{
	        	var colName = sheet1.ColSaveName(Col);
	        	if(colName == "appBasisPoint"){
	        		if(sheet1.GetCellValue(Row,colName) > 100){
	        			alert("가중치는 100을 넘을 수 없습니다.");
	        			sheet1.SetCellValue(Row,colName,"");
	        			sheet1.SelectCell(Row, "appBasisPoint");
	        			saveFlag = "F";
	        		}else{
	        			saveFlag = "T";
	        		}
	        	}
	        }catch(ex){alert("OnAfterEdit Event Error : " + ex);}
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
						<td colspan="2"> <span>평가명 </span> <select id="searchAppraisalCd" name="searchAppraisalCd"></select> </td>
						<td> <span>평가자 </span> <input id="searchAppName" name ="searchAppName" type="text" class="text readonly" readonly/>
						<input id="searchAppSabun" name ="searchAppSabun" type="hidden"/>
						</td>
						<td> <span>진행상태 </span> <input id="searchStatusNm" name ="searchStatusNm" type="text" class="text readonly" readonly />
													<input id="searchStatusCd" name ="searchStatusCd" type="hidden" class="text readonly" readonly />
						 </td>
						<td></td>
					</tr>
					<tr>
						<td><span>성명 </span>
							<input id="searchName" name ="searchName" value="${sessionScope.ssnName}" type="text" class="text readonly " readOnly />
							<input id="searchSabun" name ="searchSabun" value="${sessionScope.ssnSabun}" type="hidden" class="text"  />
							<a onclick="javascript:employeePopup();" class="button6"><img src="/common/images/common/btn_search2.gif"/></a>
							<a onclick="$('#searchSabun,#searchName').val('');" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
						 </td>
						<td> <span>소속 </span> <input id="searchOrgNm" 	    name ="searchOrgNm" type="text" class="text readonly w150" value="${sessionScope.ssnOrgNm}" readOnly /> </td>
						<td> <span>직위 </span> <input id="searchJikweeNm"   name ="searchJikweeNm" type="text" class="text readonly" value="${sessionScope.ssnJikweeNm}" readOnly /> </td>
						<td> <span>직책 </span> <input id="searchJikchakNm"  name ="searchJikchakNm" type="text" class="text readonly"  value="${sessionScope.ssnJikchakNm}"  readOnly /> </td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button" >조회</a> </td>
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
							<li id="txt" class="txt">중간점검(조직)</li>
							<li class="btn">
								<a href="javascript:goRequest();" 		 class="basic authA group2">승인요청</a>
								<a href="javascript:goRequestCancel();"  class="basic authA group2">승인취소</a>
								<a href="javascript:doAction1('Insert')" class="basic authA group1 group2">입력</a>
								<a href="javascript:doAction1('Copy')" 	 class="basic authA group1 group2">복사</a>
								<a href="javascript:doAction1('Save')" 	 class="basic authA group1 group2">저장</a>
								<!-- <a href="javascript:doAction1('Insert')" class="basic authA">출력</a> -->

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