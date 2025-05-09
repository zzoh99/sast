<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		$("#searchYn").change(function(){
			doAction1("Search");
		});

		$("#searchEleSeq").change(function(){
			$("#searchYn").attr("disabled", false);
			$("#searchYn").removeClass("readonly");

			if ($(this).val() == "") {
				$("#searchYn").val("");
				//$("#searchYn").attr("disabled", true);
				//$("#searchYn").addClass("readonly");
			}
			$("#searchYn").change();
		});

		$("#searchInfoSeq").change(function(){
			var eleSeqList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getEleSeqList&"+$("#srchFrm").serialize(),false).codeList, "전체");
			$("#searchEleSeq").html(eleSeqList[2]);

			sheet1_init();
			$("#searchEleSeq").change();
		});

		$("#searchOrgNm, #searchName").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		var infoSeq = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getInfoSeqList",false).codeList, "");
		$("#searchInfoSeq").html(infoSeq[2]);
		$("#searchInfoSeq").change();
	});

	function sheet1_init() {
		sheet1.Reset();

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

			{Header:"<sht:txt mid='temp2' mdef='세부n내역'/>",			Type:"Image",    Hidden:1,  Width:50,   Align:"Center", ColMerge:0,   SaveName:"detail", 		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	Cursor:"Pointer" },
            {Header:"<sht:txt mid='teacherNm' mdef='성명'/>",				Type:"Text",     Hidden:0,  Width:50,	Align:"Center", ColMerge:0,   SaveName:"name",   		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='chargeSabun' mdef='사번'/>",				Type:"Text",     Hidden:0,  Width:60,   Align:"Center", ColMerge:0,   SaveName:"sabun", 		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='orgYn' mdef='소속'/>",				Type:"Text",     Hidden:0,  Width:100, 	Align:"Left",  	ColMerge:0,   SaveName:"orgNm",   		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='jikgubYn' mdef='직급'/>",				Type:"Text",     Hidden:0,  Width:50, 	Align:"Center", ColMerge:0,   SaveName:"jikweeNm",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='jikchakYn' mdef='직책'/>",				Type:"Text",     Hidden:0,  Width:50,   Align:"Center", ColMerge:0,   SaveName:"jikchakNm", 	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='jikgubYn' mdef='직급'/>",				Type:"Text",     Hidden:1,  Width:50,   Align:"Center", ColMerge:0,   SaveName:"jikgubNm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='infoSeq' mdef='순번'/>",				Type:"Int",      Hidden:1,  Width:50,   Align:"Center", ColMerge:0,   SaveName:"infoSeq",       KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"동의일시",        Type:"Date",        Hidden:0,   Width:120,  Align:"Center",  ColMerge:0,    SaveName:"chkdate", KeyField:0,   CalcLogic:"",   Format:"YmdHm",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20},
            {Header:"동의자",	        Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	 ColMerge:1,	SaveName:"names",	   KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            //{Header:"<sht:txt mid='regYn' mdef='개인정보n수집여부'/>",	Type:"Image",    Hidden:0,  Width:50,   Align:"Center", ColMerge:0,   SaveName:"regYn", 		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1},
            //{Header:"<sht:txt mid='agreeYn_V595' mdef='개인정보n동의여부'/>",	Type:"Image",    Hidden:0,  Width:50,   Align:"Center", ColMerge:0,   SaveName:"agreeYn", 		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1}
		];

		for( var i=0; i < $("#searchEleSeq option").length; i++ ) {
			var code = $("#searchEleSeq option:eq("+i+")").val();
			var codeNm = $("#searchEleSeq option:eq("+i+")").text();
			if ( code == "" ) continue;

			initdata.Cols[initdata.Cols.length] = {Header: codeNm
					,	Type:"Text"
					,	Hidden:0
					,	Width:100
					,	Align:"Center"
					,	ColMerge:0
					,	SaveName:"eleYn" + code
					,	KeyField:0, CalcLogic:"", Format:"", PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1 };

			$("#searchEleYnSeq"+i).val( code );
			$("#searchEleYnNm"+i).val( "ELE_YN_" + code );
		}

		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(3,"${ctx}/common/images/icon/icon_popup.png");

		$(window).smartresize(sheetResize); sheetInit();
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/PrivacyActSta.do?cmd=getPrivacyActStaList", $("#srchFrm").serialize() ); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { alert(Msg); } sheetResize();
		
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
		    if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
		    	privacyActStaPopup(Row);
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	/**
	 * 상세내역 window open event
	 */
	function privacyActStaPopup(Row){
  		var w 		= 640;
		var h 		= 430;
		var url 	= "${ctx}/PrivacyActSta.do?cmd=privacyActStaPopup&authPg=${authPg}";
		var args 	= new Array();
		args["stdCd"] 	= sheet1.GetCellValue(Row, "stdCd");
		args["stdNm"] 	= sheet1.GetCellValue(Row, "stdNm");
		args["stdCdDesc"] = sheet1.GetCellValue(Row, "stdCdDesc");
		args["dataType"] 	= sheet1.GetCellValue(Row, "dataType");
		args["stdCdValue"] 	= sheet1.GetCellValue(Row, "stdCdValue");
		args["bizCd"] 		= sheet1.GetCellValue(Row, "bizCd");
		args["sysYn"] 		= sheet1.GetCellValue(Row, "sysYn");

		var rv = openPopup(url,args,w,h);
		if(rv!=null){
			sheet1.SetCellValue(Row, "stdCd", 	rv["stdCd"] );
			sheet1.SetCellValue(Row, "stdNm", 	rv["stdNm"] );
			sheet1.SetCellValue(Row, "stdCdDesc", rv["stdCdDesc"] );
			sheet1.SetCellValue(Row, "dataType", 	rv["dataType"] );
			sheet1.SetCellValue(Row, "stdCdValue", 	rv["stdCdValue"] );
			sheet1.SetCellValue(Row, "bizCd", 		rv["bizCd"] );
			sheet1.SetCellValue(Row, "sysYn", 		rv["sysYn"] );
		}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchEleYnSeq1" name="searchEleYnSeq1" /><input type="hidden" id="searchEleYnNm1" name="searchEleYnNm1" />
		<input type="hidden" id="searchEleYnSeq2" name="searchEleYnSeq2" /><input type="hidden" id="searchEleYnNm2" name="searchEleYnNm2" />
		<input type="hidden" id="searchEleYnSeq3" name="searchEleYnSeq3" /><input type="hidden" id="searchEleYnNm3" name="searchEleYnNm3" />
		<input type="hidden" id="searchEleYnSeq4" name="searchEleYnSeq4" /><input type="hidden" id="searchEleYnNm4" name="searchEleYnNm4" />
		<input type="hidden" id="searchEleYnSeq5" name="searchEleYnSeq5" /><input type="hidden" id="searchEleYnNm5" name="searchEleYnNm5" />

		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='114749' mdef='개인정보보호법 '/></th>
						<td>  <select id="searchInfoSeq" name="searchInfoSeq"> </select> </td>
						<th class="hide"><tit:txt mid='111950' mdef='항목 '/></th>
						<td class="hide">  <select id="searchEleSeq" name="searchEleSeq" class="w100"></select></td>
						<th><tit:txt mid='114750' mdef='동의여부 '/></th>
						<td> 
							<select id="searchYn" name="searchYn">
								<option value="" selected><tit:txt mid='103895' mdef='전체'/></option>
								<option value="1">동의</option>
								<option value="0">비동의</option>
							</select>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='104279' mdef='소속'/></th>
						<td>  <input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" /> </td>
						<th><tit:txt mid='103880' mdef='성명'/></th>
						<td>  <input id="searchName" name ="searchName" type="text" class="text" /> </td>
						<td>
							<input id="searchStatusCd" name="searchStatusCd" type="radio" value="RA" checked>퇴직자 제외
							<input id="searchStatusCd" name="searchStatusCd" type="radio" value="" >퇴직자 포함
						</td>
						<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='search' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='privacyActSta' mdef='개인정보보호법현황'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
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
