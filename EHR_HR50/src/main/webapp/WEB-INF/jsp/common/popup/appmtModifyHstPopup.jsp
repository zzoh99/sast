<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>[발령내역수정] 이력</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	
	$(function() {
		var arg = p.window.dialogArguments;
		var sabun 		= "";
		var ordYmd  	= "";
		var applySeq  	= "";
		var ordTypeCd  	= "";
		var ordDetailCd = "";
	/*Sheet 기본 설정 */
	    if( arg != undefined ) {
	    	sabun 	    = arg["sabun"];
	    	ordYmd      = arg["ordYmd"];
	    	applySeq    = arg["applySeq"];
	    	ordTypeCd   = arg["ordTypeCd"];
	    	ordDetailCd = arg["ordDetailCd"];
	    }else{
			if ( p.popDialogArgument("sabun") != null ) { sabun = p.popDialogArgument("sabun"); }
			if ( p.popDialogArgument("ordYmd") != null ) { ordYmd = p.popDialogArgument("ordYmd"); }
			if ( p.popDialogArgument("applySeq") != null ) { applySeq = p.popDialogArgument("applySeq"); }
			if ( p.popDialogArgument("ordTypeCd") != null ) { ordTypeCd = p.popDialogArgument("ordTypeCd"); }
			if ( p.popDialogArgument("ordDetailCd") != null ) { ordDetailCd = p.popDialogArgument("ordDetailCd"); }
	    }

		$("#sabun").val(sabun);
		$("#ordYmd").val(ordYmd);
		$("#applySeq").val(applySeq);
		$("#ordTypeCd").val(ordTypeCd);
		$("#ordDetailCd").val(ordDetailCd);
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:7,MergeSheet:msHeaderOnly+msPrevColumnMerge};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"20",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"변경정보|일시",		Type:"Text",	Hidden:0,	Width:130,	Align:"Center",	ColMerge:1,	SaveName:"modifyDate",			KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"변경정보|작업자",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"modifySabun",			KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			{Header:"변경정보|내용",		Type:"Text",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:1,	SaveName:"modifyMode",			KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			{Header:"변경정보|사유",		Type:"Text",	Hidden:0,	Width:170,	Align:"Center",	ColMerge:1,	SaveName:"modifyCmt",			KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			{Header:"백업정보|항목명",		Type:"Text",	Hidden:0,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"postItemNm",			KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			{Header:"백업정보|항목코드",		Type:"Text",	Hidden:0,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"postItem",			KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			{Header:"백업정보|항목값",		Type:"Text",	Hidden:0,	Width:80,	Align:"Left",	ColMerge:1,	SaveName:"postItemValue",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			{Header:"백업정보|CHKDATE",	Type:"Text",	Hidden:0,	Width:130,	Align:"Center",	ColMerge:1,	SaveName:"chkdate",				KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
			{Header:"백업정보|CHKID",	    Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"chkid",				KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.FocusAfterProcess = false;
		
		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");
	
        $(".close").click(function() {
	    	p.self.close();
	    });
	});

	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
			sheet1.DoSearch( "${ctx}/ExecAppmt.do?cmd=getExecAppmtMdHstListPop",$("#sheet1Form").serialize());   
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

</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>[발령내역수정] 이력</li>
                <li class="close"></li>
            </ul>
            
        </div>

        <div class="popup_main">
            <form id="sheet1Form" name="sheet1Form" onsubmit="return false;" style="display:none;">
            	<input type="hidden" id="sabun" name="sabun"/>
            	<input type="hidden" id="ordYmd" name="ordYmd"/>
            	<input type="hidden" id="applySeq" name="applySeq"/>
            	<input type="hidden" id="ordTypeCd" name="ordTypeCd"/>
            	<input type="hidden" id="ordDetailCd" name="ordDetailCd"/>                
	        </form>

	        <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	            <tr>
	                <td>	    
	                <div class=inner>
	                    <div class="sheet_title">
	                    <ul>
	                        <li class="btn" style="padding-top:0px;">
								<a href="javascript:doAction1('Down2Excel');" class="basic authR">다운로드</a>
							</li>
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
