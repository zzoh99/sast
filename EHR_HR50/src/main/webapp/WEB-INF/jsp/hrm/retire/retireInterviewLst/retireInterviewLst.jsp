<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
    $(function() {

	//========================================================================================================================
        // 조회조건
        
        //  퇴직희망일
        $("#sYmd").datepicker2({startdate:"eYmd"});
		$("#eYmd").datepicker2({enddate:"sYmd"});
        
        // 결재상태
        var applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getApplStatusCdList&applStatusNotCd=11,"), "전체");
		$("#searchApplStatusCd").html(applStatusCd[2]);
		
		$("#searchSabunName, #sYmd, #eYmd, #searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });
		
		$("#searchPhotoYn").click(function() {
			doAction1("Search");
		});

		//$("#searchPhotoYn").attr('checked', 'checked');

//========================================================================================================================

        var initdata = {};
        initdata.Cfg = {FrozenCol:5,SearchMode:smLazyLoad,Page:22,MergeSheet:msAll};        
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"No",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), 	Width:"${sNoWdt}",  Align:"Center", 	ColMerge:1, 	SaveName:"sNo" },
            {Header:"퇴직신청|사진",                   	Type:"Image",		Hidden:0,  	MinWidth:55, 		Align:"Center", 	ColMerge:1,		SaveName:"photo",			UpdateEdit:0, ImgMinWidth:50, ImgHeight:60 },
            {Header:"퇴직신청|사번",                   	Type:"Text",      	Hidden:0,  	Width:60,   		Align:"Center",  	ColMerge:1,   	SaveName:"sabun",         	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"퇴직신청|성명",                   	Type:"Text",    	Hidden:0,  	Width:60,    		Align:"Center",  	ColMerge:1,   	SaveName:"name",          	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"퇴직신청|소속",                   	Type:"Text",      	Hidden:0,  	Width:150,   		Align:"Center",  	ColMerge:1,   	SaveName:"orgNm",         	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"퇴직신청|직책",                   	Type:"Text",     	Hidden:0,  	Width:100,   		Align:"Center",  	ColMerge:1,   	SaveName:"jikchakNm",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"퇴직신청|직위",                   	Type:"Text",     	Hidden:0,  	Width:100,   		Align:"Center",  	ColMerge:1,   	SaveName:"jikweeNm",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"퇴직신청|직급",                   	Type:"Text",     	Hidden:1,  	Width:100,   		Align:"Center",  	ColMerge:1,   	SaveName:"jikgubNm",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"퇴직신청|직종",					Type:"Text",     	Hidden:1,  	Width:100,   		Align:"Center",  	ColMerge:1,   	SaveName:"jikjongNm",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"퇴직신청|신청일",		            Type:"Date",    	Hidden:0, 	Width:100 ,   		Align:"Center",   	ColMerge:1,  	SaveName:"reqDate",			KeyField:0,   CalcLogic:"",   Format:"Ymd",			PointCount:0, 	UpdateEdit:0, 	InsertEdit:0, 	EditLen:50 },	
            {Header:"퇴직신청|결재상태",                	Type:"Text",     	Hidden:0,  	Width:100,   		Align:"Center",  	ColMerge:1,   	SaveName:"applStatusNm",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"퇴직신청|퇴직희망일",		        Type:"Date",    	Hidden:0, 	Width:100 ,   		Align:"Center", 	ColMerge:1,  	SaveName:"retSchYmd",		KeyField:0,   CalcLogic:"",   Format:"Ymd",			PointCount:0, 	UpdateEdit:0, 	InsertEdit:0, 	EditLen:50 },
            {Header:"퇴직신청|퇴직일",		            Type:"Date",    	Hidden:0, 	Width:100 ,    		Align:"Center", 	ColMerge:1,  	SaveName:"retYmd",			KeyField:0,   CalcLogic:"",   Format:"Ymd",			PointCount:0, 	UpdateEdit:0, 	InsertEdit:0, 	EditLen:50, },
            {Header:"퇴직신청|퇴직사유",                	Type:"Text",     	Hidden:0,  	Width:300,   		Align:"Left",  		ColMerge:1,   	SaveName:"note",      		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000, MultiLineText:1, ToolTip:1},
            {Header:"면담내용|면담일",              	Type:"Date",     	Hidden:0,  	Width:100,   		Align:"Center",  	ColMerge:0,   	SaveName:"ccrYmd",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100},
            {Header:"면담내용|면담자",              	Type:"Text",     	Hidden:0,  	Width:60,   		Align:"Center",  	ColMerge:0,   	SaveName:"adviserName",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100},
            {Header:"면담내용|면담내용",              	Type:"Text",     	Hidden:0,  	Width:300,   		Align:"Left",  		ColMerge:0,   	SaveName:"memo",      		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000, MultiLineText:1, ToolTip:1}
            ];
        IBS_InitSheet(sheet1, initdata);
        sheet1.SetEditable("${editable}"); sheet1.SetEditableColorDiff(0); //편집불가 상관없이 기본색상 출력
		sheet1.SetVisible(true);sheet1.SetCountPosition(4);
        
        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");
 
    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search": 	
            var param = "sYmd="+$("#sYmd").val().replace(/-/gi,"")
            +"&eYmd="+$("#eYmd").val().replace(/-/gi,"")
            +"&searchOrgNm="+$("#searchOrgNm").val()
            +"&searchApplStatusCd="+$("#searchApplStatusCd").val()
            +"&searchSabunName="+$("#searchSabunName").val();
			
            sheet1.DoSearch( "${ctx}/RetireInterviewLst.do?cmd=getRetireInterviewLstList", param);
            break;
        case "Clear":       sheet1.RemoveAll(); break;
        case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;

		break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {    	
        try {
            if (Msg != "") {
                alert(Msg);
            }

			if($("#searchPhotoYn").is(":checked") == true){
				sheet1.SetDataRowHeight(60);
				sheet1.SetColHidden("photo", 0);
			}else{
				sheet1.SetAutoRowHeight(0);
				sheet1.SetDataRowHeight(24);
				sheet1.SetColHidden("photo", 1);
			}
			
            sheetResize();
        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }
   

    
</script>
</head>
<body class="hidden">
<div class="wrapper">
    <form id="sheet1Form" name="sheet1Form" >
    <!-- 조회조건 -->
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                    	<th>퇴직희망일</th>
						<td>
                            <input id="sYmd" name="sYmd" type="text" size="10" class="date2 required" value="${curSysYear}-01-01"/> ~
                            <input id="eYmd" name="eYmd" type="text" size="10" class="date2 required" value="${curSysYear}-12-31"/>
                        </td>
                        <th>소속</th>
                        <td>
	                        <input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" />
	                    </td>
						<th>사번/성명 </th>
                        <td>
	                        <input id="searchSabunName" name ="searchSabunName" type="text" class="text" />
                        </td>
                        <th><tit:txt mid='112999' mdef='결재상태'/></th>
                        <td>
                            <select id="searchApplStatusCd" name="searchApplStatusCd" onchange="javascript:doAction1('Search');">
                            </select> 
                        </td>
                        <th><tit:txt mid='112988' mdef='사진포함여부 '/></th>
                        <td>
                            <input id="searchPhotoYn" name="searchPhotoYn" type="checkbox"  class="checkbox" />
                        </td>
                        <td>
                            <a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a>
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
                            <li id="txt" class="txt">퇴직면담내역</li>
                            <li class="btn">
                                <a href="javascript:doAction1('Down2Excel')" class="btn outline-gray authR">다운로드</a>
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
            </td>
        </tr>
    </table>
</div>
</body>
</html>