<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		$( "#tabs" ).tabs();
		$("#sdate").datepicker2({startdate:"sdate"});
		$("#edate").datepicker2({enddate:"edate"});
		$("#searchBasicDate").datepicker2();

		//조직도 select box
		var searchSdate = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgSchemeSdate",false).codeList, "");	//조직도
		$("#searchSdate").html(searchSdate[2]);

		//조직원을 가져올 때 과거 / 미래 조직도에 따라 Sdate를 넣을지 Sysdate를 넣을지 구분하기 위하여 Edate도 불러온다. by JSG
		var searchEdate = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgSchemeEdate",false).codeList, "");	//조직도종료일
		$("#searchEdate").html(searchEdate[2]);


		/*var result = ajaxCall("${ctx}/OrgPersonSta.do?cmd=getOrgPersonStaMemoTORG103",queryId="getOrgPersonStaMemoTORG103",false);
		for(var i = 0; i < result["DATA"].length; i++) {
			if( $("#searchSdate").val() == result["DATA"][i]["code"] ) {
				var memo = result["DATA"][i]["codeNm"] ;
				if(memo != "")	$("#memoText").html("( "+memo+" )") ;
				break ;
			}
		}*/

		// 트리레벨 정의
		$("#btnPlus").toggleClass("minus");

		// 트리레벨 정의
		$("#btnStep1").click(function()	{
			$("#btnPlus").removeClass("minus");
			sheet1.ShowTreeLevel(0, 1);
		});
		$("#btnStep2").click(function()	{
			$("#btnPlus").removeClass("minus");
			sheet1.ShowTreeLevel(1,2);
		});
		$("#btnStep3").click(function()	{
			if(!$("#btnPlus").hasClass("minus")){
				$("#btnPlus").toggleClass("minus");
				sheet1.ShowTreeLevel(-1);
			}
		});
		$("#btnPlus").click(function() {
			$("#btnPlus").toggleClass("minus");
			$("#btnPlus").hasClass("minus")?sheet1.ShowTreeLevel(-1):sheet1.ShowTreeLevel(0, 1);
		});

	    $("#searchSdate").bind("change",function(event){
	    	//현재선택된 Sdate값으로 Edate를 불러오기위해 사용
		 	$("#searchEdate").val( $.trim( $("#searchSdate option:selected").val()) ) ;
	    	/*
			//메모
	    	for(var i = 0; i < result["DATA"].length; i++) {
				if( $("#searchSdate").val() == result["DATA"][i]["code"] ) {
					var memo = result["DATA"][i]["codeNm"] ;
					if(memo != "")	$("#memoText").html("( "+memo+" )") ;
					else if(memo == "") $("#memoText").html("") ;
					break ;
				}
			}
	    	*/
	    	doAction1("Search");
	    });
	    $("#findText").bind("keyup",function(event){
	    	if( event.keyCode == 13){ findOrgNm() ; }
	    });
	});

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, ChildPage:5};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='priorOrgCdV1' mdef='상위조직코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"priorOrgCd",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='grpIdV1' mdef='조직코드'/>",			Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"orgCd",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='grpNmV2' mdef='조직명'/>",			Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100,	Cursor:"Pointer",    TreeCol:1,  LevelSaveName:"sLevel" },
			{Header:"<sht:txt mid='chiefSabun' mdef='조직장사번'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"chiefSabun",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='chiefName' mdef='조직장성명'/>",		Type:"Text",      Hidden:0,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"chiefName",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='orgType' mdef='조직유형'/>",			Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"orgType",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='inoutTypeV2' mdef='조직구분'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"inoutType",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",				Type:"Date",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"sdate",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",				Type:"Date",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"edate",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='locationCd' mdef='근무지'/>",			Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"locationCd",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",					Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"memo",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			]; IBS_InitSheet(sheet1, initdata);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var orgType = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W20010"), ("${ssnLocaleCd}" != "en_US" ? "<tit:txt mid='103895' mdef='전체'/>" : "All"));
		var locationCd 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList",false).codeList, "");	//LOCATION
		$("#orgType").html(orgType[2]);
		$("#locationCd").html(locationCd[2]);

		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:1000};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='detailV1' mdef='프로필'/>",		Type:"Image",     	Hidden:0,  Width:40,   Align:"Center",  	ColMerge:0,   SaveName:"detail", 			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10,	Cursor:"Pointer" },
			{Header:"<sht:txt mid='photoV1' mdef='사진'/>",			Type:"Image",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"photo", 		UpdateEdit:0, ImgWidth:50, ImgHeight:60 },
			{Header:"<sht:txt mid='grpNmV2' mdef='조직명'/>",	Type:"Text",		Hidden:0,	Width:150,			Align:"Left",	ColMerge:0,	SaveName:"orgNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun", UpdateEdit:0 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name", UpdateEdit:0 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",		Type:"Text",		Hidden:Number("${aliasHdn}"),	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"alias", UpdateEdit:0 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Text",		Hidden:Number("${jwHdn}"),	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",			Type:"Text",		Hidden:Number("${jgHdn}"),	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikgubNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",		Hidden:0,	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikchakNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='handPhoneV1' mdef='휴대폰'/>",	Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"handPhone", UpdateEdit:0 },
			{Header:"<sht:txt mid='mailAddr' mdef='이메일'/>",		Type:"Text",		Hidden:0,	Width:150,			Align:"Center",	ColMerge:0,	SaveName:"mailId", UpdateEdit:0 },
			{Header:"<sht:txt mid='officeTel' mdef='사무실전화'/>",	Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"officeTel", UpdateEdit:0 },
			{Header:"<sht:txt mid='photoIndex' mdef='사진인덱스'/>",	Type:"Text",	Hidden:1,	Width:170,	Align:"Center",	ColMerge:0,	SaveName:"photoIndex",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:200 }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4); sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		sheet2.SetFocusAfterProcess(0);
		sheet2.SetAutoRowHeight(0);
		sheet2.SetDataRowHeight(60);

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/OrgPersonSta.do?cmd=getOrgPersonStaList", $("#srchFrm").serialize() ); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			//if ($("#searchType").is(":checked")) {
			//조직의 시작~종료일 사이에 현재일자가 들어가는지 아닌지를 구분하여 구분파라매터를 던짐
			if( parseInt("${curSysYyyyMMdd}") >= parseInt( $("#searchSdate").val() ) &&  parseInt("${curSysYyyyMMdd}") <= parseInt( $("#searchEdate option:selected").text() ) ) {
				$("#searchSht2Gbn").val("1") ;//시작~종료일 사이에 오늘이 들어감
			} else {
				$("#searchSht2Gbn").val("0") ;//시작~종료일 사이에 오늘이 들어가지 않음
			}

			/* 사원리스트 조회 전 사진정보부터 이미지 리스트에 셋팅한다. */
			//searchEmpImgList() ; // 2016.11.29 막음

			if(document.getElementById("searchType").checked == false){
				sheet2.DoSearch( "${ctx}/OrgPersonSta.do?cmd=getOrgPersonStaMeberList1", $("#srchFrm").serialize() );
			} else {
				sheet2.DoSearch( "${ctx}/OrgPersonSta.do?cmd=getOrgPersonStaMeberList2", $("#srchFrm").serialize() );
			}
			break;
		case "Down2Excel":	sheet2.Down2Excel(); break;
		}
	}



	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			$('#searchOrgCd').val(sheet1.GetCellValue(1,"orgCd")); getSheetData();   sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
				$('#searchOrgCd').val(sheet1.GetCellValue(NewRow,"orgCd"));
			    getSheetData();
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();

			if( sheet2.RowCount() > 0){

				//for(var r = sheet2.HeaderRows(); r<sheet2.LastRow()+sheet2.HeaderRows(); r++){
					//sheet2.SetCellValue(r, "photo", '<img src="${ctx}/EmpPhotoOut.do?searchKeyword='+sheet2.GetCellValue(r,"sabun")+'" id="photo" width="100" height="121">');
				//}
			}
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			   if(Row > 0 && sheet2.ColSaveName(Col) == "detail"){
			    	profilePopup(Row) ;
		    	}
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}



	// 시트에서 폼으로 세팅.
	function getSheetData() {
		var row = sheet1.GetSelectRow();
		if(row == 0) {
			return;
		}

		$(window).smartresize(sheetResize); sheetInit();

		doAction2("Search");
	}

	/**
	 * 조직원 프로필 window open event
	 */
	function profilePopup(Row){
		if(!isPopup()) {return;}

  		var w 		= 610;
		var h 		= 350;
		var url 	= "${ctx}/EmpProfilePopup.do?cmd=viewEmpProfile&authPg=${authPg}";
		var args 	= new Array();
		args["sabun"] 		= sheet2.GetCellValue(Row, "sabun");
		EmpProfilePopup(Row);
		//openPopup(url,args,w,h);
	}

    // 근무지역 팝입
    function EmpProfilePopup(Row) {
        var authPgTemp="${authPg}";
        let layerModal = new window.top.document.LayerModal({
              id : 'EmpProfileLayer'
            , url : '${ctx}/EmpProfilePopup.do?cmd=viewEmpProfileLayer&authPg=${authPg}'
            , parameters : {
                sabun : sheet2.GetCellValue(Row, "sabun")
              }
            , width : 610
            , height : 400
            , title : 'Profile'
            , trigger :[
                {
                      name : 'EmpProfileTrigger'
                    , callback : function(result){
                    }
                }
            ]
        });
        layerModal.show();
    }
    
	/*엔터검색 by JSG*/
	function findOrgNm() {
		var startRow = sheet1.GetSelectRow()+1 ;
		startRow = (startRow >= sheet1.LastRow() ? 1 : startRow ) ;
		var selectPosition = sheet1.FindText("orgNm", $("#findText").val(), startRow, 2) ;
		if(selectPosition == -1) {
			sheet1.SetSelectRow(1) ;
			alert("<msg:txt mid='alertOrgTotalMgrV2' mdef='마지막에 도달하여 최상단으로 올라갑니다.'/>") ;
		} else {
			sheet1.SetSelectRow(selectPosition) ;
		}
		$('#searchOrgCd').val(sheet1.GetCellValue(selectPosition,"orgCd"));
		getSheetData();
	}

	/*탭을 여는 경우 시트 리사이징 안되는 문제 해결 by JSG*/
	function onTabResize() {
		$(window).smartresize(sheetResize); sheetInit();
	}

	function startView() {
		//바디 로딩 완료후 화면 보여줌(로딩과정에서 화면 이상하게 보이는 현상 해결 by JSG)
		$("#tabs").removeClass("hide");
	}

  	function searchEmpImgList() {

  		var empImgList = null ;
  		if(document.getElementById("searchType").checked == false){
			empImgList = ajaxCall("${ctx}/OrgPersonSta.do?cmd=getOrgPersonStaMeberList1", $("#srchFrm").serialize(), false);
  		} else {
			empImgList = ajaxCall("${ctx}/OrgPersonSta.do?cmd=getOrgPersonStaMeberList2", $("#srchFrm").serialize(), false);
  		}
		if (empImgList != null && empImgList.DATA != null) {
			/* picSeq는 Sheet1의 photo와 같은 값을 가진다. by JSG in JejuAir */
			for(var i = 0; i<empImgList.DATA.length; i++) {
				//sheet2.SetImageList(empImgList.DATA[i].picSeq,"/hrfile/${ssnEnterCd}/picture/Thum/"+empImgList.DATA[i].photo);
				//sheet2.SetImageList(empImgList.DATA[i].picSeq,empImgList.DATA[i].photo);
				sheet2.SetImageList(empImgList.DATA[i].photoIndex,"/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword="+empImgList.DATA[i].sabun);
			}
			/* 12003번째에는 다른 값이 안들어올것으로 확인. 거기에 사진없을 경우의 이미지를 뿌린다. */
			sheet2.SetImageList(12003,"/common/images/common/img_photo.gif");
		}
	}

</script>
</head>
<body class="bodywrap" onload="startView()" >
<div class="wrapper" >
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchOrgCd" name="searchOrgCd">
		<input type="hidden" id="searchSht2Gbn" name="searchSht2Gbn">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='orgSchemeMgr' mdef='조직도'/></th>
						<td>
							<select id="searchSdate" name ="searchSdate" class="w250"></select>
							<span class="hide"><select id="searchEdate" name ="searchEdate"></select></span>
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/>
							&nbsp;&nbsp;&nbsp;<span class="hide" id="memoText"></span>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="32%" />
			<col width="68%" />
		</colgroup>
		<tr>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='112713' mdef='조직도'/>&nbsp;
								<div class="util">
								<ul>
									<li	id="btnPlus"></li>
									<li	id="btnStep1"></li>
									<li	id="btnStep2"></li>
									<li	id="btnStep3"></li>
								</ul>
								</div>
							</li>
							<li class="btn">
								<tit:txt mid='201705020000185' mdef='명칭검색'/>
								<input id="findText" name="findText" type="text" class="text" class="text" >
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "30%", "100%", "${ssnLocaleCd}"); </script>

			</td>

			<td class="sheet_right">


<!-- 						<form id="orgInfoFrm" name="orgInfoFrm" > -->
<!-- 						<div class="inner"> -->
<!-- 							<div class="sheet_title"> -->
<!-- 							<ul> -->
<!-- 								<li class="txt">기본정보 : <span id="orgNmTxt" name="orgNmTxt"></span></li> -->
<!-- 							</ul> -->
<!-- 							</div> -->

<!-- 						</div> -->
<!-- 						<table class="default inner fixed">  -->
<!-- 							<colgroup> -->
<!-- 								<col width='105px' />  -->

<!-- 								<col width='80%' /> -->
<!-- 							</colgroup>  -->
<!-- 							<tr> -->
<!-- 							<td class='center'> -->
<!-- 								<img src='/common/images/common/img_photo.gif' id='photo' width='100' height='121'> -->
<!-- 							</td>  -->

<!-- 							<td> -->
<!-- 							<table class='table' style='height:10%'>  -->
<!-- 								<colgroup> -->
<!-- 									<col width='20%' />  -->
<!-- 									<col width='20%' />  -->
<!-- 									<col width='25%' />  -->
<!-- 									<col width='35%' />  -->
<!-- 								</colgroup>  -->
<!-- 								<tr> -->
<!-- 									<th><tit:txt mid='103880' mdef='성명'/></th>  -->
<!-- 									<td id='tdName'>				 -->
<!-- 									</td>  -->
<!-- 									<th><tit:txt mid='103975' mdef='사번'/></th>  -->
<!-- 									<td id='tdSabun'> -->
<!-- 									</td>  -->
<!-- 								</tr>  -->
<!-- 								<tr> -->
<!-- 									<th><tit:txt mid='104279' mdef='소속'/></th>  -->
<!-- 									<td id='tdOrgNm' colspan='3'> -->
<!-- 									</td>  -->
<!-- 								</tr>  -->
<!-- 								<tr> -->
<!-- 									<th><tit:txt mid='103785' mdef='직책'/></th>  -->
<!-- 									<td id='tdJikchakNm'> -->
<!-- 									</td>  -->
<!-- 									<th><tit:txt mid='103881' mdef='입사일'/></th>  -->
<!-- 									<td id='tdEmpYmd'>  -->
<!-- 									</td>  -->
<!-- 								</tr>	 -->
<!-- 								<tr> -->
<!-- 									<th><tit:txt mid='104104' mdef='직위'/></th>  -->
<!-- 									<td id='tdJikweeNm'>  -->
<!-- 									</td>  -->
<!-- 									<th><tit:txt mid='104294' mdef='생년월일'/></th>  -->
<!-- 									<td id='tdBirYmd'>  -->
<!-- 									</td>  -->
<!-- 								</tr>	 -->
<!-- 								<tr> -->
<!-- 									<th><tit:txt mid='104471' mdef='직급'/></th>  -->
<!-- 									<td id='tdJikgubNm'>  -->
<!-- 									</td>  -->
<!-- 									<th><tit:txt mid='114229' mdef='최종학교'/></th>  -->
<!-- 									<td id='tdLastSchNm'> -->
<!-- 									</td>  -->
<!-- 								</tr>	 -->
<!-- 							</table> -->
<!-- 							</td>		 -->
<!-- 							</tr>  -->
<!-- 							</table> -->
<!-- 						</form> -->



					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='orgEmpNm' mdef='조직원'/></li>
							<li class="btn">
							    <input type="checkbox" class="checkbox" id="searchType" name="searchType" onclick="doAction2('Search');" style="vertical-align:middle;"/><b><tit:txt mid='104304' mdef='하위조직포함'/></b>
								<a href="javascript:doAction2('Down2Excel')" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
								<btn:a href="javascript:doAction2('Search')" 	css="btn dark authR" mid='110697' mdef="조회"/>
							</li>
						</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>


			</td>
		</tr>
		</table>
</div>
</body>
</html>
