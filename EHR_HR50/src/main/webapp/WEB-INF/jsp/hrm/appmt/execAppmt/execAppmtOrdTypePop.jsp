<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>코드검색</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");

	//var arrParam = window.dialogArguments;
	//var grpCd = arrParam['grpCd']||"";
	//var codeNm = arrParam['codeNm']||"";
	//var note1 = arrParam['note1']||"";
	//var note2 = arrParam['note2']||"";
	//var note3 = arrParam['note3']||"";

	$(function() {
		var type  = "";
		var allYn = "";
		var useYn = "";
		var ordTypeCd = "";

		var arg = p.window.dialogArguments;
	    if( arg != undefined ) {
	    	type  = arg['type'];
	    	allYn = arg['allYn'];
	    	useYn = arg['useYn'];
	    	ordTypeCd = arg['ordTypeCd'];
	    }else{
	    	if(p.popDialogArgument("type")!=null)		type  	= p.popDialogArgument("type");
	    	if(p.popDialogArgument("allYn")!=null)		allYn  	= p.popDialogArgument("allYn");
	    	if(p.popDialogArgument("useYn")!=null)		useYn 	= p.popDialogArgument("useYn");
	    	if(p.popDialogArgument("ordTypeCd")!=null)	ordTypeCd= p.popDialogArgument("ordTypeCd");
	    }

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"코드",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"code",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"코드명",		Type:"Text",		Hidden:0,	Width:70,	Align:"Left",	ColMerge:0,	SaveName:"codeNm",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(false);sheet1.SetCountPosition(4);

		//sheet1.FocusAfterProcess = false;

		$("#type").val(type);
		$("#allYn").val(allYn);
		$("#useYn").val(useYn);
		$("#ordTypeCd").val(ordTypeCd);


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
		    sheet1.DoSearch( "${ctx}/ExecAppmt.do?cmd=getExecAppmtOrdTypePopList", $("#sheet1Form").serialize());
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

	// 더블클릭시 발생
	function sheet1_OnDblClick(Row, Col){
		try{
			returnFindUser(Row,Col);
		}catch(ex){
			alert("OnDblClick Event Error : " + ex);
		}
	}

    function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
        try {
            // Insert KEY

            if (KeyCode == 13) {

                if(Row >= sheet1.HeaderRows()){
                	var returnValue = new Array(1);
             		returnValue["code"] = sheet1.GetCellValue(Row,"code");
             		returnValue["codeNm"] = sheet1.GetCellValue(Row,"codeNm");

                    if(p.popReturnValue) p.popReturnValue(returnValue);
                    p.window.close();
                }
            }

        } catch (ex) {
            alert("OnKeyDown Event Error : " + ex);
        }
    }

	function returnFindUser(Row,Col){

    	var returnValue = new Array(1);
 		returnValue["code"] = sheet1.GetCellValue(Row,"code");
 		returnValue["codeNm"] = sheet1.GetCellValue(Row,"codeNm");

 		p.popReturnValue(returnValue);

 		//p.window.returnValue = returnValue;
 		//if(p.popReturnValue) p.popReturnValue(returnValue);
 		p.window.close();
	}
</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>코드검색</li>
                <li class="close"></li>
            </ul>
        </div>

        <div class="popup_main">
            <form id="sheet1Form" name="sheet1Form" onsubmit="return false;">
				<input id="type" name="type" type="hidden" value="">
				<input id="allYn" name="allYn" type="hidden" value="">
				<input id="useYn" name="useYn" type="hidden" value="">
				<input id="ordTypeCd" name="ordTypeCd" type="hidden" value="">

                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
						<th>코드명</th>
                        <td>
                        	<input id="codeNm" name ="codeNm" type="text" class="text" style="ime-mode:active;"/>
                        </td>
                        <td>
                            <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
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
	                        <li id="txt" class="txt">코드조회</li>
	                    </ul>
	                    </div>
	                </div>
	                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
	                </td>
	            </tr>
	        </table>
	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <a href="javascript:p.self.close();" class="gray large">닫기</a>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>



