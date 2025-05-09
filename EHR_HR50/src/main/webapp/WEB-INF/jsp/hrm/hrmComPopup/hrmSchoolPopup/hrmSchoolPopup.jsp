<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='schSchool' mdef='학교검색'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	var p = eval("${popUpStatus}");
	var arg = p.popDialogArgumentAll();
	var gubun = arg['gubun'];

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='authScopeCd' mdef='코드'/>",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"code",		KeyField:1,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='codeNm' mdef='코드명'/>",		Type:"Text",		Hidden:0,	Width:70,	Align:"Left",	ColMerge:0,	SaveName:"codeNm",		KeyField:1,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='addr' mdef='주소'/>",		Type:"Text",		Hidden:0,	Width:130,	Align:"Left",	ColMerge:0,	SaveName:"memo",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		$('#gubun').val(gubun);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {
        $("#codeNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

        $(".close").click(function() {
	    	p.self.close();
	    });
	});

	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
		    sheet1.DoSearch( "${ctx}/HrmSchoolPopup.do?cmd=getHrmSchoolPopupList", $("#sheet1Form").serialize());
            break;
        case "Save":
        	// 중복체크

			if (!dupChk(sheet1, "code", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/HrmSchoolPopup.do?cmd=saveHrmSchoolPopup", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);

			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row,"code","");
			break;
        case "Clear":        //Clear
            sheet1.RemoveAll();
            break;
        case "Down2Excel":  //엑셀내려받기
            sheet1.Down2Excel();
            break;
		}
    }

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	// 더블클릭시 발생
	function sheet1_OnDblClick(Row, Col){
		try{
			returnFindUser(Row,Col);
		}catch(ex){
			alert("OnDblClick Event Error : " + ex);
		}
	}
	
	// 키 입력시 발생
	function sheet1_OnKeyUp(Row, Col, KeyCode, Shift) {
		try {
			if(KeyCode == 13) {
				returnFindUser(Row, Col);
			}
		} catch(ex) {
			alert("OnKeyUp Event Error : " + ex);
		}
	}

	function returnFindUser(Row,Col){

    	var returnValue = new Array(1);
 		returnValue["code"] = sheet1.GetCellValue(Row,"code");
 		returnValue["codeNm"] = sheet1.GetCellValue(Row,"codeNm");

 		p.popReturnValue(returnValue);
 		p.window.close();
	}
</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li><tit:txt mid='schSchool' mdef='학교검색'/></li>
                <li class="close"></li>
            </ul>
        </div>

        <div class="popup_main">
            <form id="sheet1Form" name="sheet1Form" onsubmit="return false;">
				<input id="gubun" name="gubun" type="hidden" value="">
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
						<th><tit:txt mid='103929' mdef='학교명'/></th>
                        <td>
                        	<input id="codeNm" name ="codeNm" type="text" class="text" style="ime-mode:active;"/>
                        </td>
                        <td>
                            <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
                        </td>
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
	                        <li id="txt" class="txt"><tit:txt mid='112143' mdef='학교조회'/></li>
	                        <li class="btn _thrm115">
	                        <c:if test="${authPg == 'A'}">
								<btn:a href="javascript:doAction1('Insert');" css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy');" css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Save');" css="basic authA" mid='110708' mdef="저장"/>
							</c:if>
							</li>
	                    </ul>
	                    </div>
	                </div>
	                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
	                </td>
	            </tr>
	        </table>
	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>



