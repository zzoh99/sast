<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>부양가족정보관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		$("#searchWorkYy").val("<%=curSysYear%>"-1) ;
	
		$("#searchWorkYy").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction("Search"); 
			}
		});
		
		$("#searchYMD").datepicker2();
		$("#searchYMD").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction("Search"); 
			}
		});		
		
	});

    $(function() {
        var initdata = {};
        initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:6};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,FrozenCol:6,HeaderCheck:1};
        initdata.Cols = [
            {Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"소속",			Type:"Text",	      Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"org_nm",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"성명",          Type:"PopupEdit",     Hidden:0,  Width:60,    Align:"Center",  ColMerge:0,   SaveName:"name",           KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"사번",          Type:"Text",          Hidden:0,  Width:70,    Align:"Center",  ColMerge:0,   SaveName:"sabun",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"재직상태",       Type:"Combo",         Hidden:0,  Width:80,    Align:"Center",  ColMerge:0,   SaveName:"status_cd",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"시작일자",		Type:"Date",		  Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"sdate",		KeyField:1,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 },
            {Header:"종료일자",		Type:"Date",		  Hidden:0,  Width:100,   Align:"Center",	ColMerge:0, SaveName:"edate",		KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"외국인\n단일세율", Type:"Combo",         Hidden:0,  Width:100,    Align:"Center",  ColMerge:0,   SaveName:"foreign_yn",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"국외근로\n비과세", Type:"Combo",         Hidden:0,  Width:60,    Align:"Center",  ColMerge:0,   SaveName:"abroad_yn",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"장애인\n근로자",   Type:"Combo",        Hidden:0,  Width:50,    Align:"Center",  ColMerge:0,   SaveName:"handicap_yn",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"부녀자\n공제",    Type:"Combo",         Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"woman_yn",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"배우자\n공제",    Type:"Combo",         Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"spouse_yn",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"부양자\n(만60세이상)",  Type:"Int",      Hidden:0,  Width:85,   Align:"Right",   ColMerge:0,   SaveName:"family_cnt_1",     KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2 },
            {Header:"부양자\n(20세미만)",    Type:"Int",     Hidden:0,  Width:70,   Align:"Right",   ColMerge:0,   SaveName:"family_cnt_2",     KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2 },
            {Header:"경로우대\n(65세이상)",  Type:"Int",      Hidden:1,  Width:70,   Align:"Right",   ColMerge:0,   SaveName:"old_cnt_1",        KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2 },
            {Header:"경로우대\n(만70세이상)", Type:"Int",      Hidden:0,  Width:70,   Align:"Right",   ColMerge:0,   SaveName:"old_cnt_2",        KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2 },
            {Header:"장애인",              Type:"Int",      Hidden:0,  Width:50,   Align:"Right",   ColMerge:0,   SaveName:"handicap_cnt",    KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2 },
            {Header:"자녀양육비\n공제자",     Type:"Int",      Hidden:1,  Width:70,   Align:"Right",   ColMerge:0,   SaveName:"child_cnt",       KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2 },
            {Header:"자녀수",              Type:"Int",      Hidden:0,  Width:70,   Align:"Right",   ColMerge:0,   SaveName:"add_child_cnt",    KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2 },
            {Header:"총부양가족수\n(본인포함)", Type:"Int",      Hidden:0,  Width:70,   Align:"Right",   ColMerge:0,   SaveName:"tot_cnt",    KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
        ];
        
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		var foreignYnList  = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear="+$("#searchWorkYy").val(), "C00170"), "" );
        var statusCdList  = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear="+$("#searchWorkYy").val(), "H10010"), "전체" );
        var statusCdGridList  = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear="+$("#searchWorkYy").val(), "H10010"), "" );

        sheet1.SetColProperty("status_cd", {ComboText:statusCdGridList[0], ComboCode:statusCdGridList[1]} );

        sheet1.SetColProperty("foreign_yn", {ComboText:"|"+foreignYnList[0], ComboCode:"|"+foreignYnList[1]} );
        sheet1.SetColProperty("abroad_yn", {ComboText:"N|Y", ComboCode:"N|Y"} );
        sheet1.SetColProperty("handicap_yn", {ComboText:"N|Y", ComboCode:"N|Y"} );
        sheet1.SetColProperty("woman_yn", {ComboText:"N|Y", ComboCode:"N|Y"} );
        sheet1.SetColProperty("spouse_yn", {ComboText:"N|Y", ComboCode:"N|Y"} );
        
        sheet1.SetColBackColor("spouse_yn", "#FFFFEF");
        sheet1.SetColBackColor("family_cnt_1", "#FFFFEF");
        sheet1.SetColBackColor("family_cnt_2", "#FFFFEF");
        sheet1.SetColBackColor("add_child_cnt", "#FFFFEF");
        sheet1.SetColBackColor("tot_cnt", "#FAD5E6");
		
		// 재직상태
		$("#searchStatusCd").html(statusCdList[2]);

        // 숫자만 입력 받기
        $("#searchWorkYy").bind("keyup",function(event){
        	makeNumber(this,"A");
            if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
        });

        $("#searchWorkYy").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
        });
        $(window).smartresize(sheetResize); sheetInit();

        doAction("Search");
    });


	//Sheet1 Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/sptFamInfo/sptFamInfoRst.jsp?cmd=selectSptFamInfoList", $("#sheetForm").serialize() );
			break;
        case "Insert":    
        	sheet1.DataInsert(0) ;
        	break;
        case "Copy":        
        	sheet1.DataCopy();
        	break;			
		case "Save":
			sheet1.DoSave( "<%=jspPath%>/sptFamInfo/sptFamInfoRst.jsp?cmd=saveSptFamInfo", $("#sheetForm").serialize() ); 			
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				doAction("Search");
			}
		} catch(ex) {
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	
	var gPRow  = "";
	var pGubun = "";
	
	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
				openEmployeePopup(Row) ;
			}			
		} catch(ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}	
	
	// 사원 조회
	function openEmployeePopup(Row){
	    try{
	    	
	    	 if(!isPopup()) {return;}
	    	 gPRow  = Row;
			 pGubun = "employeePopup";
				
		     var args    = new Array();
		     var rv = openPopup("<%=jspPath%>/common/employeePopup.jsp?authPg=<%=authPg%>", args, "740","520");

	    } catch(ex) {
	    	alert("Open Popup Event Error : " + ex);
	    }
	}
	
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "employeePopup" ){
			//사원조회
			sheet1.SetCellValue(gPRow, "name", 		rv["name"] );
			sheet1.SetCellValue(gPRow, "sabun", 	rv["sabun"] );
			sheet1.SetCellValue(gPRow, "org_nm", 	rv["org_nm"] );
		}
	}

    function familyInfoCreate(){

        if($("#searchWorkYy").val() == "")
        {
            alert("연말정산년도를 입력하세요.");
            return;
        }
        else{
            if(parseInt($("#searchWorkYy").val(),10) < 2016)
            {
                alert("2016년도 이후 연말정산 자료로만 생성가능합니다.");
                return;
            }
            
        	var befWorkYy = parseInt($("#searchWorkYy").val(),10);
	        if (confirm($("#searchWorkYy").val() + "년도 연말정산 부양가족정보를 기준으로\n개인별 부양가족정보를 생성합니다.\n\n"
	        		   +"시작일자는 기준일자(" + $("#searchYMD").val()+")로 일괄 지정됩니다.\n계속 진행하시겠습니까?")) {

                ajaxCall("<%=jspPath%>/sptFamInfo/sptFamInfoRst.jsp?cmd=prcFamilyInfoCreate",$("#sheetForm").serialize()
			   	    			,true
			   	    			,function(){
									waitFlag = true;
									$("#progressCover").show();
			   	    			}
			   	    			,function(){
									waitFlag = false;
									$("#progressCover").hide();
									doAction('Search');
			   	    			}
			   	    	);
	        }
        }
    }
    
</script>
</head>
<body class="bodywrap">
<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    <div class="sheet_search outer">
        <div>
        <table>
		        <tr>
                    <td>
                        <span>기준일자 </span>
                        <input id="searchYMD" name ="searchYMD" type="text" class="text" value="<%=curSysYyyyMMddHyphen%>" align="center"/>
                    </td>
		            <td>
		                <span>재직상태</span>
		                <select id="searchStatusCd" name ="searchStatusCd" onChange="javascript:doAction('Search')" class="box"></select>
		            </td>
		        </tr>
		        <tr>
		            <td>
		                <span>소속</span>
		                <input id="searchWorkOrgNm" name="searchWorkOrgNm" type="text" class="text" readOnly />
		                <a onclick="javascript:openOrgSchemePopup();" href="#" class="button6"><img src="/common/images/common/btn_search2.gif"/></a>
						<a onclick="$('#searchWorkOrgNm').val('');" href="#" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
		            </td>
		            <td>
		                <span>사번/성명</span>
		                <input id="searchSabunName" name="searchSabunName" type="text" class="text" />
		            </td>
		            <td>
		                <a href="#" class="button" onclick="javascript:doAction('Search');">조회</a>
		            </td>
		        </tr>
        </table>
        </div>
    </div>

    <div class="outer">
        <div class="sheet_title">
        <ul>
                            <li id="txt" class="txt">부양가족정보관리</li>
                            <li class="btn">
                            <span>연말정산년도</span>
		                    <input id="searchWorkYy" name="searchWorkYy" maxlength="4" type="text" class="text date" />
                                <a href="javascript:familyInfoCreate()" class="button">부양가족정보 재생성</a>
                                <a href="javascript:doAction('Insert')" class="basic authA">입력</a>
                                <a href="javascript:doAction('Copy')"   class="basic authA">복사</a>
                                <a href="javascript:doAction('Save')"   class="basic authA">저장</a>
                                <a href="javascript:doAction('Down2Excel')"   class="basic authR">다운로드</a>
                            </li>
        </ul>
        </div>
    </div>
    </form>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>