<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gradeInfo = ajaxCall("/CompAppSelfReg.do?cmd=getPapGradeInfoList","searchAppTypeCd=B,",false);
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msAll};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"역량종류",		Type:"Combo",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"comGubunCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"역량코드",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"competencyCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"역량항목",		Type:"Text",	Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"competencyNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"역량정의",		Type:"Text",	Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"competencyMemo",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"가중치(%)",		Type:"AutoSum",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appBasisPoint",	KeyField:0,	Format:"Float",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"본인평가",		Type:"Combo",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"평가코드",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"사번",			Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"SUNBUN",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"sunbun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"자기평가확정여부",Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appraisalYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"평가점수",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appPoint",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"자기평가의견",	Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appAppMemo",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetDataRowMerge(1);

		var comboCodeList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00001"), "");		//평가등급코드
		var comboCodeList2 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007"), "");		//역량종류
		var comboCodeList3  = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdListAppType&searchAppTypeCd=B,",false).codeList, "");	//평가명

		sheet1.SetColProperty("appClassCd", 			{ComboText:comboCodeList1[0], ComboCode:comboCodeList1[1]} );
		sheet1.SetColProperty("comGubunCd", 			{ComboText:comboCodeList2[0], ComboCode:comboCodeList2[1]} );

		$("#searchAppraisalCd").html(comboCodeList3[2]);


		$("#searchAppraisalCd").change(function(){
			doAction1("Search");
		});

		//평가진행상태
		 var v_status = ajaxCall("/CompAppSelfReg.do?cmd=getCompAppSelfRegStatusMap",$("#srchFrm").serialize(),false);
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
		case "Search": 	 	sheet1.DoSearch( "${ctx}/CompAppSelfReg.do?cmd=getCompAppSelfRegList", $("#srchFrm").serialize() ); break;
		case "Save": 		
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/CompAppSelfReg.do?cmd=saveCompAppSelfReg", $("#srchFrm").serialize()); break;
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

			 var v_status = ajaxCall("/CompAppSelfReg.do?cmd=getCompAppSelfRegStatusMap",$("#srchFrm").serialize(),false);
			 if(v_status != null && v_status.map != null){
				$("#searchStatus").val(v_status.map.status);
				$("#searchStatusCd").val(v_status.map.statusCd);
			 }

			calTotalPoint();

			if($("#searchStatusCd").val() == "5"){
				sheet1.SetColEditable("appClassCd",0);
			}else{
				sheet1.SetColEditable("appClassCd",1);
			}

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


    function calTotalPoint(){

    	     gradeInfo = ajaxCall("/CompAppSelfReg.do?cmd=getPapGradeInfoList","searchAppTypeCd=B,",false);
    	 var totalPoint = 0;
    	 var totalGrade = "";
    	 var totalGradeCd = "";
    	 if(gradeInfo.DATA != null){
    		 for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
    				var appClassCd = sheet1.GetCellValue(i, "appClassCd");

    				if(appClassCd != ""){
    					for(j=0; j < gradeInfo.DATA.length; j++){
    						if(appClassCd == gradeInfo.DATA[j].appClassCd){
    							totalPoint += gradeInfo.DATA[j].performancePoint*sheet1.GetCellValue(i, "appBasisPoint")/100;
    						}
    					}
    				}
   			 }
    	 }

    	for(j=0; j < gradeInfo.DATA.length; j++){

    		if(gradeInfo.DATA[j].toPoint <= totalPoint && totalPoint <= gradeInfo.DATA[j].fromPoint ){
					totalGrade = gradeInfo.DATA[j].codeNm;
					totalGradeCd = gradeInfo.DATA[j].appClassCd;
					break;
				}
		}


    	totalPoint = Round(totalPoint,2);

    	var lr = sheet1.LastRow();
		sheet1.SetCellValue(lr,"appClassCd",totalPoint+"/"+totalGrade);
		sheet1.SetCellValue(lr,"competencyMemo","점수/등급");
		sheet1.SetCellAlign(lr,"competencyMemo","Right");
		$("#searchAppPoint").val(totalPoint);
		$("#searchAppClasscd").val(totalGradeCd);
    }

    function Round(n, pos) {
    	var digits = Math.pow(10, pos);

    	var sign = 1;
    	if (n < 0) {
    	sign = -1;
    	}

    	// 음수이면 양수처리후 반올림 한 후 다시 음수처리
    	n = n * sign;
    	var num = Math.round(n * digits) / digits;
    	num = num * sign;

    	return num.toFixed(pos);
    }





    function sheet1_OnChange(Row, Col, Value){
    	var colName = sheet1.ColSaveName(Col);
    	if(colName == "appClassCd"){
    		calTotalPoint();
    	}
    }

    function goRequest(){


    	if($("#searchStatusCd").val()  == "5"){
    		alert("이미 평가완료 처리 하셨습니다." );
    		return;
    	}

    	for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
    		if(sheet1.GetCellValue(i, "appClassCd") == ""){
    			alert("미평가 항목이 존재합니다." );
    			return;
    		}
    	}

    	if (confirm("평가확정 후에는 평가내용을 수정 할 수 없습니다.\n평가확정을 취소 하시려면 평가담당자에게 문의 하세요.\n평가확정을 하시겠습니까?")){
    		var Request = ajaxCall("/CompAppSelfReg.do?cmd=saevCompAppSelfRegRequest",$("#srchFrm").serialize(),false);
    		if(Request.Result != null){
    			alert(Request.Result.Message);
    			doAction1("Search");
    		}
    	}


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

	         	doAction1("Search");
            }
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }


  	//실적확인
  	function pfmcChk(){
        try{

         var args    = new Array();
         args["searchSabun"]         = $("#searchSabun").val();
         args["searchAppraisalCd"]   = $("#searchAppraisalCd").val();
         var rv = openPopup("/CompAppSelfReg.do?cmd=viewCompAppSelfRegPop", args, "740","520");

        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input id="searchAppPoint" name="searchAppPoint" type="hidden" value=""/>
		<input id="searchAppClasscd" name="searchAppClasscd" type="hidden" value=""/>
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
							<li id="txt" class="txt">본인평가</li>
							<li class="btn">
								<a href="javascript:pfmcChk();" class="basic authA">실적확인</a>
								<a href="javascript:goRequest();" class="basic authA group2">평가확정</a>
								<a href="javascript:doAction1('Save')" 	class="basic authA group2">저장</a>
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