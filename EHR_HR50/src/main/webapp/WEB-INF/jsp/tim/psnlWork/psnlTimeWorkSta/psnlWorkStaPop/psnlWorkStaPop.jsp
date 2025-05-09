<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>근무상세내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");

	$(function() {
		var searchSabun = "";
		var searchSYm   = "";
		var searchEYm   = "";
		var sdate = "";
		var edate = "";
		var payType = "";
		var arg = p.window.dialogArguments;

		if( arg != undefined ) {
			searchSabun = arg["searchSabun"];
			searchSYm	= arg["searchSYm"];
			searchEYm	= arg["searchEYm"];
			sdate		= arg["sdate"];
			edate		= arg["edate"];
			payType		= arg["payType"];
		}else{
	    	if(p.popDialogArgument("searchSabun")!=null)		searchSabun  	= p.popDialogArgument("searchSabun");
	    	if(p.popDialogArgument("searchSYm")!=null)			searchSYm		= p.popDialogArgument("searchSYm");
	    	if(p.popDialogArgument("searchEYm")!=null)			searchEYm		= p.popDialogArgument("searchEYm");
	    	if(p.popDialogArgument("sdate")!=null)				sdate  			= p.popDialogArgument("sdate");
	    	if(p.popDialogArgument("edate")!=null)				edate  			= p.popDialogArgument("edate");
	    	if(p.popDialogArgument("payType")!=null)			payType  		= p.popDialogArgument("payType");
	    }

		$("#searchSabun").val(searchSabun);
		$("#searchSYm").val(searchSYm);
		$("#searchEYm").val(searchEYm);
		$("#searchSYmd").val(sdate);
		$("#searchEYmd").val(edate);
		$("#payType").val(payType);

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 }
/*
			{Header:"근무일자",			Type:"Date",      	Hidden:0,  	Width:70,  Align:"Center",	ColMerge:0,   	SaveName:"ymd",			KeyField:0,	Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"작업장",				Type:"Text",      	Hidden:0,  	Width:100,  Align:"Center",	ColMerge:0,   	SaveName:"processNm",			KeyField:0,	Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='workOrgCd' mdef='근무조'/>",				Type:"Text",      	Hidden:0,  	Width:70,   Align:"Center",	ColMerge:0,   	SaveName:"workteamNm",			KeyField:0,	Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"근무\n시작시간",		Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,		SaveName:"inputInHm",			KeyField:0,	Format:"Hm",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"근무\n종료시간",		Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,		SaveName:"inputOutHm",			KeyField:0,	Format:"Hm",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"무급근무\n시간1",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,		SaveName:"addHour1",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"무급근무\n시간2",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,		SaveName:"addHour2",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"기본",				Type:"AutoSum",		Hidden:0,  	Width:50,	Align:"Center",	ColMerge:0,   	SaveName:"wkInputHour1",	KeyField:0, Format:"Integer",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"연장",				Type:"AutoSum",     Hidden:0,  	Width:50,	Align:"Center",	ColMerge:0,   	SaveName:"wkInputHour2",	KeyField:0, Format:"Integer",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"휴일",				Type:"AutoSum",     Hidden:0,  	Width:50,	Align:"Center",	ColMerge:0,   	SaveName:"wkInputHour3",	KeyField:0, Format:"Integer",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"휴일\n연장",			Type:"AutoSum",     Hidden:0,  	Width:50,	Align:"Center",	ColMerge:0,   	SaveName:"wkInputHour4",	KeyField:0, Format:"Integer",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"야간",				Type:"AutoSum",     Hidden:0,  	Width:50,	Align:"Center",	ColMerge:0,   	SaveName:"wkInputHour5",	KeyField:0, Format:"Integer",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"야간\n보조",			Type:"AutoSum",     Hidden:0,  	Width:50,	Align:"Center",	ColMerge:0,   	SaveName:"wkInputHour6",	KeyField:0, Format:"Integer",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
*/
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);

// 		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

	$(function() {
		$("#searchSYm").mask("1111-11");
		$("#searchEYm").mask("1111-11");
		$("#searchSYm").datepicker2({ymonly:true});
		$("#searchEYm").datepicker2({ymonly:true});

        $(".close").click(function() {
	    	p.self.close();
	    });
	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if($("#searchSYm").val() == "" || $("#searchEYm").val() == "") {
				alert("<msg:txt mid='109965' mdef='대상년월은 필수값 입니다.'/>") ;
				$("#searchSYm").focus() ;
				return ;
			}

			searchTitleList();


			/*근무기준 시작~종료일 받음*/
			/*2016.11.17 막음
			var data = ajaxCall("${ctx}/PsnlTimeWorkSta.do?cmd=getPsnlTimeWorkStaYmd","searchSYm="+$("#searchSYm").val()+"&searchEYm="+$("#searchEYm").val() ,false);
			if(data != null && data.DATA != null) {
				$("#searchSYmd").val( data.DATA.stdwSDd ) ;
				$("#searchEYmd").val( data.DATA.stdwEDd ) ;
			} else {
				alert("근무기준일을 가져오지 못하여 조회할 수 없습니다.") ;
				return ;
			}
			*/

			/*근무기준 시작~종료일 받음*/
			/*
			var stdw 	= ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getStdwDdFromTTIM004&payType="+$("#payType").val(),false) ;
			if(stdw != null && stdw.codeList[0] != null ) {
				$("#searchSYmd").val( $("#searchYm").val().replace(/-/gi, "") + stdw.codeList[0].stdwSDd ) ;
				$("#searchEYmd").val( $("#searchYm").val().replace(/-/gi, "") + stdw.codeList[0].stdwEDd ) ;
			} else {
				alert("근무기준일을 가져오지 못하여 조회할 수 없습니다.(FROM TTIM004)") ;
				return ;
			}*/

			sheet1.DoSearch( "${ctx}/PsnlTimeWorkSta.do?cmd=getPsnlWorkStaPopList", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);

			sheet1.SetCellValue(row,"sabun",sabun);
			sheet1.SetCellValue(row,"reqYmd",reqYmd);
			sheet1.SetCellValue(row,"reqGb",reqGb);

			break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/SaveData.do?cmd=savePsnalInfoUpdLicPop", $("#sheet1Form").serialize());
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	/*SETTING HEADER LIST*/
	function searchTitleList() {

		var titleList = ajaxCall("${ctx}/PsnlTimeWorkSta.do?cmd=getPsnlWorkStaPopHeaderList", $("#sheet1Form").serialize(), false);
		if (titleList != null && titleList.DATA != null) {
			sheet1.Reset();

			var fixedCnt = 0 ;

			var initdata1 = {};
			initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly};
			initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};

			initdata1.Cols = [];
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",			Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" };
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>",       	Type:"${sDelTy}",   Hidden:1,  Width:Number("${sDelWdt}"), Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0};
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>",       	Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:Number("${sSttWdt}"), Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0};
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='ymdV7' mdef='근무일|근무일'/>",		Type:"Date",		Hidden:0,  Width:75,   Align:"Center",  ColMerge:1,   SaveName:"ymd",	   		KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='dayNm' mdef='요일|요일'/>",			Type:"Text",		Hidden:0,  Width:30,   Align:"Center",  ColMerge:1,   SaveName:"dayNm",	   		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='gubunV7' mdef='구분|구분'/>",			Type:"Text",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:1,   SaveName:"dayType",	   	KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='timNm' mdef='근무시간명|근무시간명'/>",Type:"Text",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:1,   SaveName:"timNm",	   		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='inYmd' mdef='출근|일'/>",			Type:"Date",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:1,   SaveName:"inYmd",	   		KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='inHm' mdef='출근|시간'/>",			Type:"Text",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:1,   SaveName:"inHm",	   		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='outYmd' mdef='퇴근|일'/>",			Type:"Date",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:1,   SaveName:"outYmd",	   	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[fixedCnt++]  = {Header:"<sht:txt mid='outHm' mdef='퇴근|시간'/>",			Type:"Text",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:1,   SaveName:"outHm",	   		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };

			//값 매핑시 앞쪽 고정컬럼 이후부터 매핑하기위해 사용
			FIXED_HEAD_CNT = fixedCnt ;

			var i = 0 ;
			for(; i<titleList.DATA.length; i++) {
				//alert("i : " + i);
				initdata1.Cols[i+fixedCnt] = {Header:titleList.DATA[i].mReportNm + "|" + titleList.DATA[i].reportNm,	Type:"AutoSum",	Hidden:0,	Width:0,	Align:"Center",	ColMerge:1,	SaveName:"hour"+(i+1),	KeyField:0,	Format:"",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
			}
			IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

			$(window).smartresize(sheetResize); sheetInit();

			/* 콤보값 설정
 			var workCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getWorkCdListWithWorkSNm"), "");
 			for(var k = 0; k < i; k++) {
 				sheet1.SetColProperty(titleList.DATA[k].saveName, 		{ComboText:"|"+workCdList[0], ComboCode:"|"+workCdList[1]} );
 			}


			$("#searchSbNm, #searchYm").bind("keyup",function(event) {
				if (event.keyCode == 13) {
					doAction1("Search");
				}
			});*/
		}
	}


</script>
</head>

<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="searchSabun" name="searchSabun"  />
		<input type="hidden" id="sdate" name="sdate" />
		<input type="hidden" id="edate" name="edate" />
		<input type="hidden" id="payType" name="payType" />
		<input type="hidden" id="searchSYmd" name="searchSYmd" />
		<input type="hidden" id="searchEYmd" name="searchEYmd" />
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='psnlWorkStaPop' mdef='근무상세내역'/></li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='114444' mdef='대상년월'/> </th>
						<td> 
						 	<input id="searchSYm" name ="searchSYm" type="text" class="date2 required"  value="${curSysYyyyMMHyphen}" maxlength="7" size="7" /> ~
						 	<input id="searchEYm" name ="searchEYm" type="text" class="date2 required"  value="${curSysYyyyMMHyphen}" maxlength="7" size="7" />
						 </td>
						<td> <btn:a href="javascript:doAction1('Search');" id="btnSearch" css="button" mid="search" mdef="조회"/> </td>
					</tr>
				</table>
			</div>
		</div>
		<div class="sheet_title outer">
		<ul>
			<li id="txt" class="txt"><tit:txt mid='psnlWorkStaPop' mdef='근무상세내역'/></li>
		</ul>
		</div>

		<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

		<div class="popup_button outer">
		<ul>
			<li>
				<btn:a href="javascript:p.self.close();" css="gray large" mid="close" mdef="닫기"/>
			</li>
		</ul>
		</div>
	</div>

</form>
</div>
</body>
</html>