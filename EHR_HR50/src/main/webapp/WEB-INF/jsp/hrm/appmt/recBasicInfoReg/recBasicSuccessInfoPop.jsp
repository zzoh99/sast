<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='basicInfoIf' mdef='합격자정보I/F'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var arg = p.popDialogArgumentAll();

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
    		{Header:"No",			Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
    		{Header:"성명",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"nameKor",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:22 },
    		{Header:"성명(한자)",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"nameChe",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:22 },
    		{Header:"성명(영문)",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"nameEng",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:22 },
    		{Header:"성별",			Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sex",				KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:22 },
    		{Header:"생년월일",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"birthday",		KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:22 },
    		{Header:"양력여부",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"lunarYn",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:22 },
    		{Header:"결혼여부",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"marriedYn",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:22 },
    		
			{Header:"이동전화",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"phoneTel",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:22 },
    		{Header:"이메일",			Type:"Text",	Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"email",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:22 },
    		{Header:"취미",			Type:"Text",	Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"habby",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:22 },
    		{Header:"특기",			Type:"Text",	Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"specical",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:22 }
			

		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(false);sheet1.SetCountPosition(4);

		$("#searchBirYmd").datepicker2({});
		
		var lunType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H00030"));	//음양구분
		var sexType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H00010"));	//성별

		sheet1.SetColProperty("lunarYn", 		{ComboText:"|"+lunType[0], ComboCode:"|"+lunType[1]} );
		sheet1.SetColProperty("sex", 		{ComboText:"|"+sexType[0], ComboCode:"|"+sexType[1]} );

		// 채용공고명 코드
		var searchRecInfo 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=searchRecInfo",false).codeList, ""); //채용공고
		$("#searchRecruitTitle").html(searchRecInfo[2]);
		
		$(window).smartresize(sheetResize); sheetInit();
	});

	$(function() {
        $(".close").click(function() {
	    	p.self.close();
	    });
	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=recBasicSuccessInfoPopList", $("#sheet1Form").serialize() );
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
 			sheetResize();

		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

		var rv = new Array();

		rv["nameKor"	]	=	sheet1.GetCellValue(Row,"nameKor"	);
		rv["nameChe"	]	=	sheet1.GetCellValue(Row,"nameChe"	);
		rv["nameEng"	]	=	sheet1.GetCellValue(Row,"nameEng"	);
		rv["sex"	]		=	sheet1.GetCellValue(Row,"sex"	);
		rv["birthday"	]	=	sheet1.GetCellValue(Row,"birthday"	);
		rv["lunarYn"	]	=	sheet1.GetCellValue(Row,"lunarYn"	);
		
		rv["marriedYn"	]	=	sheet1.GetCellValue(Row,"marriedYn"	);
		rv["phoneTel"	]	=	sheet1.GetCellValue(Row,"phoneTel"	);
		
		rv["email"	]		=	sheet1.GetCellValue(Row,"email");
		rv["habby"	]		=	sheet1.GetCellValue(Row,"habby"	);
		rv["specical"	]	=	sheet1.GetCellValue(Row,"specical"	);
		
		p.popReturnValue(rv);
		p.window.close();
	}

</script>
</head>
<body class="bodywrap">

    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li><tit:txt mid='basicInfoIf' mdef='합격자정보'/></li>
                <li class="close"></li>
            </ul>
        </div>

        <div class="popup_main">
            <form id="sheet1Form" name="sheet1Form" onsubmit="return false;">
            	<input id="searchStaffingYn" name="searchStaffingYn" type="hidden" value="Y"/>
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
                    	<th><tit:txt mid='104228' mdef='채용공고 '/></th>
						<td>  <select id="searchRecruitTitle" 	name="searchRecruitTitle" onChange="javascript:doAction1('Search');"> </select> </td>
						<th><tit:txt mid='114216' mdef='휴대폰'/></th>
                        <td>
                        	<input id="searchPhon" name="searchPhon" type="text" class="text"/>
                        </td>
                        <th><tit:txt mid='114216' mdef='생일'/></th>
                        <td>
                        	<input id="searchBirthday" name="searchBirthday" type="text" class="date2" style="width:60px;"/>
                        </td>
					</tr>
					<tr>
						<th><tit:txt mid='114216' mdef='이메일'/></th>
						<td>
                        	<input id="searchMail" name="searchMail" type="text" class="text"/>
                        </td>
                        <th><tit:txt mid='114216' mdef='지원자명'/></th>
                        <td>
                        	<input id="searchName" name="searchName" type="text" class="text"/>
                        </td>
                        <td>
                            <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='search' mdef="조회"/>
                        </td>
					</tr>
                    </table>
                    </div>
                </div>
	        </form>

	        <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	            <tr>
	                <td>
	               		<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
	                </td>
	            </tr>
	        </table>

	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <btn:a href="javascript:p.self.close();" css="gray large" mid='close' mdef="닫기"/>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>
