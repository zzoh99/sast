<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112121' mdef='인재검색 조건선택 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var openerCodeList = "" ;
	var p = eval("${popUpStatus}");
	/*Sheet 기본 설정 */
	$(function() {
		var sTitle = "";
		var sShtTitle = "";
		var sHeader = "";
		var sGrpCd = "";
		var codeList = "";

		var arg = p.window.dialogArguments;
		if( arg != undefined ) {
			sTitle		= arg["sTitle"];
			sShtTitle 	= arg["sShtTitle"];
			sHeader 	= arg["sHeader"];
			sGrpCd 		= arg["sGrpCd"];
			codeList 	= arg["codeList"];
		}else{
	    	if(p.popDialogArgument("sTitle")!=null)		sTitle  	= p.popDialogArgument("sTitle");
	    	if(p.popDialogArgument("sShtTitle")!=null)	sShtTitle  	= p.popDialogArgument("sShtTitle");
	    	if(p.popDialogArgument("sHeader")!=null)	sHeader  	= p.popDialogArgument("sHeader");
	    	if(p.popDialogArgument("sGrpCd")!=null)		sGrpCd  	= p.popDialogArgument("sGrpCd");
	    	if(p.popDialogArgument("codeList")!=null)	codeList  	= p.popDialogArgument("codeList");
	    }
		
		$("#popTitle").html(sTitle) ;
		$("#sheetTitle").html(sShtTitle) ;
		$("#searchGrpCd").val(sGrpCd) ;
		
		/*코드리스트 세팅*/
		openerCodeList = codeList.replace(/'/g, "") ;

		// 직무일때만 트리형태
		var treeCol = 0;
		if ( sGrpCd == "H10060" ) {
			treeCol = 1;
			
			// 트리레벨 정의
			$("#btnPlus").click(function() {
				sheet1.ShowTreeLevel(-1);
			});
			$("#btnStep1").click(function()	{
				sheet1.ShowTreeLevel(0, 1);
			});
			$("#btnStep2").click(function()	{
				sheet1.ShowTreeLevel(1,2);
			});
			$("#btnStep3").click(function()	{
				sheet1.ShowTreeLevel(2, 3);
			});
		} else {
			treeCol = 0;
			$(".util").hide();
		}
		
		//배열 선언				
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='check' mdef='선택'/>",			Type:"DummyCheck",	Hidden:0,	Width:10,			Align:"Center",	ColMerge:0,	SaveName:"dummyCheck" },
 			{Header:sHeader,		Type:"Text",		Hidden:0,	Width:50,			Align:"Left",	ColMerge:0,	SaveName:"codeNm", UpdateEdit:0 ,	TreeCol:treeCol,  LevelSaveName:"sLevel" },
			{Header:"code",			Type:"Text",		Hidden:1,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"code", UpdateEdit:0 }
		];                  
		IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff (0);

		$(window).smartresize(sheetResize);
		sheetInit();
		
		//검색어 있을경우 검색 
		if($("#searchGrpCd").val() != ""){
			doAction("Search");
		}

        $(".close").click(function() {
	    	p.self.close();
	    });
	});
	
	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
			case "Search": //조회
			    sheet1.DoSearch( "${ctx}/SpecificEmpSrch.do?cmd=getSpecificEmpListPop", $("#mySheetForm").serialize() );
	            break;
		}
    } 
	
	// 	조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try{
			sheet1.ShowTreeLevel(-1);
			
			setSheetSize(sheet1);
			setCodeList( openerCodeList ) ;
	  	}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	function sheet1_OnResize(lWidth, lHeight) {
		try {
		} catch (ex) {
			alert("OnResize Event Error : " + ex);
		}
	}
	function sheet1_OnDblClick(Row, Col){
		try{
			sheet1.GetCellValue(Row, "dummyCheck") == "1" ? sheet1.SetCellValue(Row, "dummyCheck", "0") : sheet1.SetCellValue(Row, "dummyCheck", "1");
		}catch(ex){alert("OnDblClick Event Error : " + ex);}
	}
	
	function setValue(){
    	var returnValue = new Array(26);
		var codeStr = "" ;
		var codeNmStr = "" ;
    	for(var i = 1; i < sheet1.LastRow()+1; i++) {
    		if( sheet1.GetCellValue(i, "dummyCheck") == "1" ) {
	   			codeNmStr = codeNmStr + sheet1.GetCellValue(i, "codeNm") + ",";
	   			codeStr = codeStr + sheet1.GetCellValue(i, "code") + ",";
    		}
    	}
    	codeNmStr = codeNmStr.substr(0, codeNmStr.length-1)  ;
    	
    	codeStr = codeStr.substr(0, codeStr.length-1)  ;
    	returnValue["code"]	= codeStr ;
    	returnValue["codeNm"]	= codeNmStr ;
    	
 		//p.window.returnValue = returnValue;
 		if(p.popReturnValue) p.popReturnValue(returnValue);
 		p.window.close();
	}
	
	function setCodeList(codeList) {
		codeList = codeList.split(",") ;
		for(var i = 0; i < codeList.length; i++) {
			sheet1.SetCellValue(sheet1.FindText("code", codeList[i]), "dummyCheck", 1) ;
		}
	}
</script>

</head>
<body class="bodywrap">

    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li><span id="popTitle"></span></li>
                <li class="close"></li>
            </ul>
        </div>
        
        <div class="popup_main">
            <form id="mySheetForm" name="mySheetForm">
                <input type="hidden" id="searchGrpCd" name="searchGrpCd" value=""/> 
	        </form>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt"><span id="sheetTitle"></span>
						<div class="util">
						<ul>
							<li	id="btnPlus"></li>
							<li	id="btnStep1"></li>
							<li	id="btnStep2"></li>
							<li	id="btnStep3"></li>
						</ul>
						</div>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>

	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <a href="javascript:setValue();" class="pink large"><tit:txt mid='104435' mdef='확인'/></a>
	                    <a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>
