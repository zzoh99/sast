<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='recAppmtReg' mdef='채용발령내용등록'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:7};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='receiveNo' mdef='일련\n번호'/>",		Type:"Text",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"receiveNo",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='ordDetailCd' mdef='발령'/>",			Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='201706270000008' mdef='입력일'/>",			Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"regYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='accResNoV1' mdef='주민번호'/>",		Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"resNo",		KeyField:1,	Format:"IdNo",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='birYmd' mdef='생년월일'/>",		Type:"Date",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"birYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='appOrgCdV5' mdef='소속코드'/>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",			Type:"Popup",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",			Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",			Type:"Combo",	Hidden:Number("${jgHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='applJobJikgunNmV1' mdef='직군'/>",			Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='manageCd' mdef='사원구분'/>",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"manageCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='payType' mdef='급여유형'/>",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"payType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='salClass' mdef='급여호봉'/>",		Type:"Combo",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"salClass",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
            {Header:"<sht:txt mid='locationNm_V2989' mdef='사업장\n(Location)코드'/>",   Type:"Text",    Hidden:1,   Width:80,   Align:"Center", ColMerge:0, SaveName:"locationCd",  KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='locationCd_V2988' mdef='사업장\n(Location)'/>",       Type:"Popup",   Hidden:1,   Width:80,   Align:"Center", ColMerge:0, SaveName:"locationNm",  KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='workAreaCd' mdef='근무지역코드'/>",   Type:"Text",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"workAreaCd",  KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='workAreaNm' mdef='근무지역'/>",       Type:"Popup",   Hidden:1,   Width:100,  Align:"Center", ColMerge:0, SaveName:"workAreaNm",  KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='jobCdV1' mdef='직무코드'/>",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"<sht:txt mid='jobCd' mdef='직무'/>",			Type:"Popup",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jobNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"직종코드",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikjongCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"<sht:txt mid='workType' mdef='직종'/>",			Type:"Popup",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikjongNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='traYmd' mdef='면수습일'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"traYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='contractSymd' mdef='발령기간\n시작일'/>",	Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"contractSymd",KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='contractEymd' mdef='발령기간\n종료일'/>",	Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"contractEymd",KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='ibsImage1V1' mdef='가발령'/>",			Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"prePostYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='ibsImage2V1' mdef='발령확정'/>",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='ibsImage1V1' mdef='가발령'/>",			Type:"Image",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage1",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='ibsImage2V1' mdef='발령확정'/>",		Type:"Image",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage2",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },

			//사용안함
			{Header:"<sht:txt mid='ctitleChgYmd' mdef='직위변경일'/>",		Type:"Date",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"ctitleChgYmd",KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='fpromYmd' mdef='직급변경일'/>",		Type:"Date",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"fpromYmd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='enterPay' mdef='입사시연봉\n(만원)'/>",	Type:"Int",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"enterPay",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='payGroupCd' mdef='pay그룹'/>",		Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"payGroupCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"/common/images/icon/icon_x.png");
		sheet1.SetImageList(1,"/common/images/icon/icon_x.png");
		sheet1.SetImageList(2,"/common/images/icon/icon_o.png");

		var manageCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10030"), "");
		var locationCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList",false).codeList, "");	//LOCATION
		var jikchakCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"), "");
		var workType = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050"), "");
		var jikweeCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "");
		var payType = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10110"), "");
		var jikgubCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), "");
		var payGroupCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20060"), "");
		var salClass = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C10000"), "");
		var ordDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdList&inOrdType=10,",false).codeList, "");	//발령종류

		sheet1.SetColProperty("ordDetailCd", 		{ComboText:"|"+ordDetailCd[0], ComboCode:"|"+ordDetailCd[1]} );
		sheet1.SetColProperty("manageCd", 			{ComboText:"|"+manageCd[0], ComboCode:"|"+manageCd[1]} );
		sheet1.SetColProperty("locationCd", 		{ComboText:"|"+locationCd[0], ComboCode:"|"+locationCd[1]} );
		sheet1.SetColProperty("jikchakCd", 			{ComboText:"|"+jikchakCd[0], ComboCode:"|"+jikchakCd[1]} );
		sheet1.SetColProperty("workType", 			{ComboText:"|"+workType[0], ComboCode:"|"+workType[1]} );
		sheet1.SetColProperty("jikweeCd", 			{ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]} );
		sheet1.SetColProperty("payType", 			{ComboText:"|"+payType[0], ComboCode:"|"+payType[1]} );
		sheet1.SetColProperty("jikgubCd", 			{ComboText:"|"+jikgubCd[0], ComboCode:"|"+jikgubCd[1]} );
		sheet1.SetColProperty("payGroupCd", 		{ComboText:"|"+payGroupCd[0], ComboCode:"|"+payGroupCd[1]} );
		sheet1.SetColProperty("salClass", 			{ComboText:"|"+salClass[0], ComboCode:"|"+salClass[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {

        $("#name").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#regYmdFrom").datepicker2({startdate:"regYmdTo"});
		$("#regYmdTo").datepicker2({enddate:"regYmdFrom"});

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			if($("#regYmdFrom").val() == "") {
				alert("<msg:txt mid='110186' mdef='입력일을 입력하여 주십시오.'/>");
				$("#regYmdFrom").focus();
				return;
			}
			if($("#regYmdTo").val() == "") {
				alert("<msg:txt mid='110186' mdef='입력일을 입력하여 주십시오.'/>");
				$("#regYmdTo").focus();
				return;
			}

			sheet1.DoSearch( "${ctx}/RecAppmtInfoReg.do?cmd=getRecAppmtInfoRegList", $("#sendForm").serialize() );
			break;
		case "Save":
			IBS_SaveName(document.sendForm,sheet1);
			sheet1.DoSave( "${ctx}/RecAppmtInfoReg.do?cmd=saveRecAppmtInfoReg", $("#sendForm").serialize());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		case "UploadData":
			sheet1.RemoveAll();
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
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

				if(sheet1.RowCount() > 0) {
					for(var i = 1; i < sheet1.RowCount()+1; i++) {
						if(sheet1.GetCellValue(i, "prePostYn") != "0" || sheet1.GetCellValue(i, "ordYn") != "0") {
							sheet1.SetRowEditable(i,false);
						} else {
							sheet1.SetRowEditable(i,true);
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
			//doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	//키를 눌렀을때 발생.
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			if(sheet1.GetCellEditable(Row,Col) == true) {
				if(sheet1.ColSaveName(Col) == "orgNm" && KeyCode == 46) {
					sheet1.SetCellValue(Row,"orgCd","");
				} else if(sheet1.ColSaveName(Col) == "jobNm" && KeyCode == 46) {
					sheet1.SetCellValue(Row,"jobCd","");
				} else if(sheet1.ColSaveName(Col) == "locationNm" && KeyCode == 46) {
					sheet1.SetCellValue(Row,"locationCd","");
				}else if(sheet1.ColSaveName(Col) == "jikjongNm" && KeyCode == 46) {
					sheet1.SetCellValue(Row,"jikjongCd","");
				}
			}
		} catch (ex) {
			alert("OnKeyDown Event Error " + ex);
		}
	}

	//키를 눌렀을때 발생.
	function sheet1_OnLoadExcel() {
		try {
			// 조회 후 다운로드한 엑셀의 내용을 업로드 하기 때문에 일련번호가 동일한 데이터를 수정처리 한다.
			for(i=1;i<=sheet1.LastRow();i++) {
				sheet1.SetCellValue(i,"sStatus","U");
			}
		} catch (ex) {
			alert("OnLoadExcel Event Error " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "orgNm") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "orgTreePopup";

		        var win = openPopup("/Popup.do?cmd=orgTreePopup&authPg=R", "", "740","700");
			} else if(sheet1.ColSaveName(Col) == "jobNm") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "jobSchemePopup";

		        var win = openPopup("/Popup.do?cmd=jobSchemePopup&authPg=R&searchJobType2=10030", "", "830","750");
			} else if(sheet1.ColSaveName(Col) == "locationNm") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "locationCodePopup";

				var win = openPopup("/LocationCodePopup.do?cmd=viewLocationCodePopup&authPg=R", "", "740","700");
			} else if(sheet1.ColSaveName(Col) == "workAreaNm"){
            	var args    = new Array();

            	args["grpCd"]   = "H90202";
  			  	gPRow = Row;
			  	pGubun = "workAreaPop";

            	var win = openPopup("/Popup.do?cmd=commonCodePopup&authPg=${authPg}", args, "740","520");
            }else if(sheet1.ColSaveName(Col) == "jikjongNm") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "jikjongSchemePopup";

		        var win = openPopup("/Popup.do?cmd=jobSchemePopup&authPg=R&searchJobType2=10010", "", "830","750");
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "orgTreePopup"){
            sheet1.SetCellValue(gPRow, "orgCd", rv["orgCd"] );
            sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"] );
        } else if(pGubun == "jobSchemePopup") {
            sheet1.SetCellValue(gPRow, "jobCd", rv["jobCd"] );
            sheet1.SetCellValue(gPRow, "jobNm", rv["jobNm"] );
        } else if(pGubun == "locationCodePopup") {
            sheet1.SetCellValue(gPRow, "locationCd", rv["code"] );
            sheet1.SetCellValue(gPRow, "locationNm", rv["codeNm"] );
        } else if(pGubun == "workAreaPop") {
            sheet1.SetCellValue(gPRow, "workAreaCd", rv["code"] );
            sheet1.SetCellValue(gPRow, "workAreaNm", rv["codeNm"] );
        }else if(pGubun == "jikjongSchemePopup") {
            sheet1.SetCellValue(gPRow, "jikjongCd", rv["jobCd"] );
            sheet1.SetCellValue(gPRow, "jikjongNm", rv["jobNm"] );
        }
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form id=sendForm name="sendForm" method="post">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='112113' mdef='입력일'/></th>
			<td>
				<input id="regYmdFrom" name="regYmdFrom" type="text" size="10" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>"/> ~
				<input id="regYmdTo" name="regYmdTo" type="text" size="10" class="date2 required" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
			</td>
			<th><tit:txt mid='103880' mdef='성명'/></th>
			<td>
				<input id="name" name="name" type="text" class="text"/>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search');" css="button" mid='110697' mdef="조회"/>
			</td>
		</tr>
		</table>
		</div>
	</div>
</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='recAppmtReg' mdef='채용발령내용등록'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('UploadData');" css="basic authA" mid='110703' mdef="업로드"/>
				<btn:a href="javascript:doAction1('Save');" css="basic authA" mid='110708' mdef="저장"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
