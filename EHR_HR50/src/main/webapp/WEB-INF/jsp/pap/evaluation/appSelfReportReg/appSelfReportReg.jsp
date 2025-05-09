<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var coboCodeList1 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdListMobOrgTargetReg&searchAppTypeCd=E&searchAppraisalSeq=0",false).codeList, "");	//평가명
		$("#searchAppraisalCd").html(coboCodeList1[2]);

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"평가ID코드",			Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사원번호",			Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"조직코드",			Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"비고",				Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"항목코드",			Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"itemCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"VALUE_CD",			Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"valueCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"전환배치희망(YN)",	Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item8",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"희망부문(부서)1코드",	Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item9",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"희망부문(부서)1명",	Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item9Nm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"희망부문(부서)2코드",	Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item12",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"희망부문(부서)2명",	Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item12Nm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"전환시기",			Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item10",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"전환사유",			Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"item11",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"상태",				Type:"Text",	Hidden:0,	Width:100,	Align:"Cneter",	ColMerge:0,	SaveName:"appStatus",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//평가 Admin 여부에 따라 버튼 체크
		 var papAdmin = ajaxCall("/MboOrgTargetReg.do?cmd=getMboOrgTargetRegPapAdminMap","&searchSabun="+$("#searchSabun").val(),false); //admin 여부
	     	if(papAdmin != null && papAdmin.map != null) {
	     		if(papAdmin.map.papAdminYn == 'N'){
	     			$(".btnGroup1").hide();

	     		}
	     	}


     	//평가기간 체크 하여 버튼 보임 안보임 처리
        var data2 = ajaxCall("/MboOrgTargetReg.do?cmd=getTargetButtonVislYnMap","searchAppraisalCd="
        		+$("#searchAppraisalCd").val()+"&searchappStepCd=1",false);
        if(data2 != null && data2.map != null) {
        	if(data2.map.vislYn == "N"){
     			$(".btnGroup3").hide();
     		}
        }




		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
		searchData();
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppSelfReportReg.do?cmd=getAppSelfReportRegList2", $("#srchFrm").serialize() ); break;
		case "Save1":
							if(setSheetData("temSave")){
								IBS_SaveName(document.srchFrm,sheet1);
								sheet1.DoSave( "${ctx}/AppSelfReportReg.do?cmd=saveAppSelfReportReg2", $("#srchFrm").serialize());
							}
							break;
		case "Save2":
							if(setSheetData("request")){
								IBS_SaveName(document.srchFrm,sheet1);
								sheet1.DoSave( "${ctx}/AppSelfReportReg.do?cmd=saveAppSelfReportReg2", $("#srchFrm").serialize());
							}
							break;
		case "Save3":
							if(setSheetData("cancel")){
								IBS_SaveName(document.srchFrm,sheet1);
								sheet1.DoSave( "${ctx}/AppSelfReportReg.do?cmd=saveAppSelfReportReg2", $("#srchFrm").serialize());
							}
							break;
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


	function searchData(){
		var searchList = ajaxCall("/AppSelfReportReg.do?cmd=getAppSelfReportRegList",$("#srchFrm").serialize(),false);
		var cnt = 0;
		var htmlData = "";
		$("#jobDescription").html("");

		if(searchList.DATA != null && typeof searchList.DATA[0] != "undefined") {
			cnt = searchList.DATA.length;
			var searchListData = searchList.DATA;
			var oldItemCd = "";
			for (var row = 0; row < cnt; row++) {

				var newItemCd = searchListData[row].itemCd;

				if(oldItemCd != newItemCd){

					htmlData = htmlData + "<colgroup>";
					htmlData = htmlData + "<col width='30%' />";
					htmlData = htmlData + "<col width='70%' />";
					htmlData = htmlData + "</colgroup>";

					htmlData = htmlData + "<tr>";
					htmlData = htmlData + "<th>";
					htmlData = htmlData + "<input type='hidden' name='itemCd' value='"+searchListData[row].itemCd+"'/>";
					htmlData = htmlData + searchListData[row].itemNm+"</th>";
					htmlData = htmlData + "<td>";
					for(var valueRow = 0; valueRow < cnt; valueRow++){
						if(newItemCd == searchListData[valueRow].itemCd){
						htmlData = htmlData + "<input type='radio'  name='valueCd"+searchListData[valueRow].itemCd+"' value='"+searchListData[valueRow].valueCd+"'"+searchListData[valueRow].checked+" />"
						htmlData = htmlData + "<span>"+searchListData[valueRow].valueNm+"</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
						}
					}
					htmlData = htmlData + "</td>";
					htmlData = htmlData + "</tr>";

					oldItemCd = newItemCd;
				}

			}
			$("#jobDescription").append(htmlData);

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
	         	searchData();
            }
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }

    //직무기술 저장
    function goSave(){
        try{

        	var result = ajaxCall("/AppSelfReportReg.do?cmd=saveAppSelfReportReg",$("#srchFrm").serialize(),false);

        	if(result != null && result.Result.Code != null){
        		doAction1("Search");
        		searchData();
        		alert(result.Result.Message);

        	}else{

        	}

        }catch(ex){alert("goSave Event Error : " + ex);}
    }


    // 시트에서 폼으로 세팅.
	function getSheetData() {

		var chkCnt = sheet1.RowCount();
		var row = sheet1.LastRow();

		if(chkCnt == 0) {
// 			$('#searchAppMemo').val("");
			return;
		}


		$('input:radio[name="item8"]:input[value="'+sheet1.GetCellValue(row,"item8")+'"]').attr("checked", true);
		$('#item9Nm').val(sheet1.GetCellValue(row,"item9Nm"));
		$('#item9').val(sheet1.GetCellValue(row,"item9"));

		$('#item12Nm').val(sheet1.GetCellValue(row,"item12Nm"));
		$('#item12').val(sheet1.GetCellValue(row,"item12"));

		$('input:radio[name="item10"]:input[value="'+sheet1.GetCellValue(row,"item10")+'"]').attr("checked", true);
		$('#item11').val(sheet1.GetCellValue(row,"item11"));
	}

	// 폼에서 시트로 세팅.
	function setSheetData(type) {

		var chkCnt = sheet1.RowCount();
		var row;

		if(chkCnt  == 0){

			row = sheet1.DataInsert(0);
		}else{
			row = sheet1.LastRow();
		}

		var tmp_appStatus;
		if(type == "temSave"){
			tmp_appStatus = 1;
			if($("#appStatus").val() == "2"){
				alert("확인요청 상태에서는 임시저장 할 수 없습니다.");
				return false;
			}

			if($("#appStatus").val() == "3"){
				alert("이미 확인 처리되었습니다.");
				return false;
			}
		}else if(type == "request"){
			tmp_appStatus = 2;
			if($("#appStatus").val() == "3"){
				alert("이미 확인 처리되었습니다.");
				return false;
			}
		}else if(type == "cancel"){
			tmp_appStatus = 1;
			if($("#appStatus").val() != "2"){
				alert("확인요청 건만 확인취소 처리  할 수 있습니다.");
				return false;
			}
		}
		sheet1.SetCellValue(row,"sStatus","U");
		sheet1.SetCellValue(row,"appraisalCd",$("#searchAppraisalCd").val());
		sheet1.SetCellValue(row,"appStatus",tmp_appStatus);
		sheet1.SetCellValue(row,"orgCd",$("#searchOrgCd").val());

		sheet1.SetCellValue(row,"sabun",$("#searchSabun").val());

		sheet1.SetCellValue(row,"item8",$("input[name=item8]:checked").val());
		sheet1.SetCellValue(row,"item9",$("#item9").val());
		sheet1.SetCellValue(row,"item12",$("#item12").val());

		sheet1.SetCellValue(row,"item10",$("input[name=item10]:checked").val());
		sheet1.SetCellValue(row,"item11",$("#item11").val());
		return true;
	}


	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}

			getSheetData();
			sheetResize();
			disableData();

			//진행상태
	        var process = ajaxCall("/AppSelfReportReg.do?cmd=getAppSelfReportRegMap",$("#srchFrm").serialize(),false);
	        if(process != null && process.map != null) {
	        	if(process.map.appStatus == "9"){
	     			$("#appStatusNm").val("미대상");
	     			$("#appStatus").val(process.map.appStatus);
	     			alert("대상자가 아닙니다.");
	     		}else if(process.map.appStatus == "0"){
	     			$("#appStatusNm").val("미작성");
	     			$("#appStatus").val(process.map.appStatus);

	     		}else if(process.map.appStatus == "1"){
	     			$("#appStatusNm").val("작성중");
	     			$("#appStatus").val(process.map.appStatus);
	     		}else if(process.map.appStatus == "2"){
	     			$("#appStatusNm").val("확인요청");
	     			$("#appStatus").val(process.map.appStatus);
	     		}else if(process.map.appStatus == "3"){
	     			$("#appStatusNm").val("확인");
	     			$("#appStatus").val(process.map.appStatus);
	     		}
	        }
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//소속 팝입
	function orgSearchPopup(gubun) {
		var w		= 680;
		var h		= 520;
		var url		= "/Popup.do?cmd=orgBasicPopup";
		var args	= new Array();

		var result = openPopup(url+"&authPg=R", args, w, h);
		if (result) {
			var orgCd	= result["orgCd"];
			var orgNm	= result["orgNm"];
			if(gubun == "primary"){
				$("#item9").val(orgCd);
				$("#item9Nm").val(orgNm);
			}
			if(gubun == "secondary"){
				$("#item12").val(orgCd);
				$("#item12Nm").val(orgNm);
			}

		}
	}


	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{

			if(Code < 0){
				if(Msg != ""){
					alert(Msg);
				}
			}else{
				goSave();
			}

		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}


	function disableData(){

		if($("input[name=item8]:checked").val() == "Y"){
			$(".btnGroup2").show();
			$("input[name=item10]").attr("disabled",false);

		}else{
			$(".btnGroup2").hide();
			$("input[name=item10]").attr("disabled",true);
			$("#item9").val("");
			$("#item9Nm").val("");
			$("#item12").val("");
			$("#item12Nm").val("");
			$('input:radio[name="item10"]:input[value="5"]').attr("checked", true);
			$("#item11").attr("disabled",true);

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
						<td> <span>평가명 </span> <select id="searchAppraisalCd" name="searchAppraisalCd"> </select> </td>
						<td aling="left" colspan="3"><span>성명 </span>
							<input id="searchName" name ="searchName" value="${sessionScope.ssnName}" type="text" class="text readonly " readOnly />
							<input id="searchSabun" name ="searchSabun" value="${sessionScope.ssnSabun}" type="hidden" class="text"  />
							<a onclick="javascript:employeePopup();" class="button6 btnGroup1"><img src="/common/images/common/btn_search2.gif"/></a>
							<a onclick="$('#searchSabun,#searchName').val('');" class="button7 btnGroup1"><img src="/common/images/icon/icon_undo.png"/></a>
						 </td>
					</tr>
					<tr>
						<td> <span>소속 </span> <input id="searchOrgNm" name ="searchOrgNm" type="text" class="text readonly w150" value="${sessionScope.ssnOrgNm}"/>
						<input id="searchOrgCd" name ="searchOrgCd" type="hidden" class="text" value="${sessionScope.ssnOrgCd}"/></td>
						<td> <span>직위 </span> <input id="searchJikweeNm" name ="searchJikweeNm" type="text" class="text readonly" value="${sessionScope.ssnJikweeNm}" /> </td>
						<td> <span>진행상태 </span> <input id="appStatusNm" name ="appStatusNm" type="text" class="text readonly" />
							<input id="appStatus" name ="appStatus" type="hidden" class="text readonly" />
						</td>
						<td> <a href="javascript:searchData()" id="btnSearch" class="button">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">직무기술</li>
							<li class="btn">
								<a href="javascript:doAction1('Save1');"    class="basic authA btnGroup3">임시저장</a>
								<a href="javascript:doAction1('Save2')" 	class="basic authA btnGroup3">확인요청</a>
								<a href="javascript:doAction1('Save3')" 	class="basic authA btnGroup3">확인취소</a>
							</li>
						</ul>
					</div>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="table" id="jobDescription">
					<colgroup>
						<col width="30%" />
						<col width="70%" />
					</colgroup>
					<tr>

					</tr>
				</table>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">전환희망</li>
							<li class="btn">

							</li>
						</ul>
					</div>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="table">
					<colgroup>
						<col width="30%" />
						<col width="70%" />
					</colgroup>
					<tr>
						<th>전환배치 희망</th>
						<td><input type="radio" class="radio" name="item8" onClick="disableData();" value="N" checked>
						현 부서(팀) 유지를 원함
						<input type="radio" class="radio" name="item8" onClick="disableData();" value="Y" >
	        			타 부서(팀)으로 전환배치를 원함
						</td>
					</tr>
					<tr>
						<th>희망 부서(팀) </th>
						<td>
							<span>1차</span>
							<input id="item9Nm" name ="item9Nm" type="text" class="text readonly w150" readOnly />
							<input id="item9" name ="item9" type="hidden" class="text"  />
							<a onclick="javascript:orgSearchPopup('primary');" class="button6 btnGroup2"><img src="/common/images/common/btn_search2.gif"/></a>
							<a onclick="$('#item9,#item9Nm').val('');" class="button7 btnGroup2"><img src="/common/images/icon/icon_undo.png"/></a>
							<span>2차</span>
							<input id="item12Nm" name ="item12Nm" type="text" class="text readonly w150" readOnly />
							<input id="item12"   name ="item12" type="hidden" class="text"  />
							<a onclick="javascript:orgSearchPopup('secondary');" class="button6 btnGroup2"><img src="/common/images/common/btn_search2.gif"/></a>
							<a onclick="$('#item12,#item12Nm').val('');" class="button7 btnGroup2"><img src="/common/images/icon/icon_undo.png"/></a>
						</td>
					</tr>
					<tr>
						<th>전환 시기</th>
						<td>
							<input type="radio" class="radio" name="item10" value="1" />빠른시일내
				        	<input type="radio" class="radio" name="item10" value="2" />6개월 이내
				        	<input type="radio" class="radio" name="item10" value="3" />1년 이내
				        	<input type="radio" class="radio" name="item10" value="4" />적당한 시기에
				        	<input type="radio" class="radio" name="item10" value="5" checked />해당 없음
						</td>
					</tr>
					<tr>
						<th>전환 사유</th>
						<td>
							<input id="item11" name="item11" type="text" style="ime-mode:active;width:100%" size="80%" maxlength="50" />
						</td>
					</tr>

					<div class="hide" >
						<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
					</div>

				</table>
			</td>
		</tr>
	</table>
	</form>
</div>
</body>
</html>