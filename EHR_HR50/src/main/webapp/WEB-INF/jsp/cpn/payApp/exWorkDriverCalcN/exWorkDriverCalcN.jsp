<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
    $(function() {

        var initdata = {};
        //initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata.Cfg = {FrozenCol:7,SearchMode:smLazyLoad,Page:100};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"No", 		            Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"삭제",     		 	Type:"${sDelTy}",	 Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",             	Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
			{Header:"성명",					Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",		PointCount:0,			UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
			{Header:"사번",					Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:1,	Format:"",		PointCount:0,			UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"소속",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",				KeyField:0,	Format:"",			PointCount:0,		UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"직위",					Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",		KeyField:0,	Format:"",			PointCount:0,		UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
//            {Header:"재직상태",     Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"statusCd",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"근무일자",			Type:"Date",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sdate",					KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
            {Header:"아침시작\n시간",	Type:"Date",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"morningSHm",							Format:"Hm",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
            {Header:"근무시작\n시간",	Type:"Date",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"reqSHm",				KeyField:1,	Format:"Hm",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
            {Header:"근무종료\n시간",	Type:"Date",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"reqEHm",				KeyField:1,	Format:"Hm",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },            
            {Header:"연장근로\n시간",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"otOverTime",								Format:"",	Edit:0 },
            {Header:"야간근로\n시간",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"otNightTime",							Format:"",	Edit:0 },
            {Header:"가산시수",			Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"gasan",				KeyField:0,	Format:"",			PointCount:0,		UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
            {Header:"시급",					Type:"Int",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"sigub",				KeyField:0,	Format:"",			PointCount:0,		UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
            {Header:"야근수당",			Type:"Int",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"payMon",			KeyField:0,	Format:"",			PointCount:0,		UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
            {Header:"근무내용",			Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"reason",				KeyField:0,	Format:"",			PointCount:0,		UpdateEdit:1,	InsertEdit:1,	EditLen:4000 },
            {Header:"수정시간",			Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"chkdate",			        			    Format:"",		PointCount:0,			UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"수정자",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkid",					KeyField:0,	Format:"",			PointCount:0,		UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            // Hidden
            {Header:"회사구분(TORG900)",     Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"enterCd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
            ];
        IBS_InitSheet(sheet1, initdata);
        sheet1.SetEditable("${editable}"); 
		sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        // 직위
        var jikweeCdList    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "");
        sheet1.SetColProperty("jikweeCd",           {ComboText:"|"+jikweeCdList[0], ComboCode:"|"+jikweeCdList[1]} );

        // 재직상태
        var statusCdList    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), "");
        //sheet1.SetColProperty("statusCd",           {ComboText:"|"+statusCdList[0], ComboCode:"|"+statusCdList[1]} );
        
        // 근무일자 조회
		$("#searchFromYmd").datepicker2({startdate:"searchToYmd"});
        $("#searchToYmd").datepicker2({enddate:"searchFromYmd"});

		//searchFrom : 현재년월의 -1개월의 1일
		//searchTo 	  : 현재년월의 -1개월의 마지막일
		var currentDate = "${curSysYyyyMMdd}";		

		var addDate1 = addDate("m", -1,currentDate, "-");
		var yearMonthParse = replaceAll(addDate1,"-","").substring(0,6);			
		var lastDay = ( new Date( yearMonthParse.substring(0,4), yearMonthParse.substring(4), 0) ).getDate();
		
     	// 전월1일
		$("#searchFromYmd").val(addDate1.substring(0,7) + "-01");
		// 전월말일
        $("#searchToYmd").val(addDate1.substring(0,7) + "-" +lastDay);
        

        $("#searchToYmd, #searchFromYmd").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

        // 재직상태
        $("#searchStatusCd").html(statusCdList[2]);
		$("#searchStatusCd").select2({
			placeholder: "선택"
		});
        
		// 키업 조회
        $("#searchSabunName").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });
        $("#searchOrgNm").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });
        
        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");
        
        setSheetAutocompleteEmp( "sheet1", "name"); 
    });

    function getMonthEndDate(year, month) {
		var dt = new Date(year, month, 0);
		return dt.getDate();
	}

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
        	
			$("#searchStatusCdHidden").val(getMultiSelectValue($("#searchStatusCd").val()));						
            sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getExWorkDriverCalcNList", $("#srchFrm").serialize() ); break;
        case "Save":
        	if(!dupChk(sheet1,"sabun|enterCd|workGubun|sdate", false, true)){break;}
            // 미처리 상태의 건에 대한 update
            IBS_SaveName(document.srchFrm,sheet1);
            sheet1.DoSave( "${ctx}/SaveData.do?cmd=saveExWorkDriverCalcN", $("#srchFrm").serialize()); break;
		case "Insert":
        var newRow = sheet1.DataInsert(0);
        sheet1.SetCellValue(newRow, "enterCd", "${ssnEnterCd}");
        break;
        case "Copy":        sheet1.DataCopy(); break;
        case "Clear":       sheet1.RemoveAll(); break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"4|7|8|9|10|14|15|16"});		
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

        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		
		doAction1("Search");
	}    
    
    function sheet1_OnClick(Row, Col, Value) {
        try{
        }catch(ex){alert("OnClick Event Error : " + ex);}
    }

    function getMultiSelectValue( value ) {
    	if( value == null || value == "" ) return "";
    	if (value.indexOf("m") == -1) return value+","; // 선택된 값이 한개일 경우 Dao에서 배열로 바뀌지 않아서 오류남 콤마 추가
        //return "'"+String(value).split(",").join("','")+"'";
		return value;
    }
	
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "sheetAutocompleteEmp"){
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow, "name", rv["name"]);
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			//sheet1.SetCellValue(gPRow, "statusCd", rv["statusCd"]);
			sheet1.SetCellValue(gPRow, "jikweeCd", rv["jikweeCd"]);
	    }
    }
    
	// 프로시져 호출
	function doCallPrc(step) {

        var param = "step="+step
                +"&searchFromYmd="+$("#searchFromYmd").val().replace(/-/gi, "") 
                +"&searchToYmd="+$("#searchToYmd").val().replace(/-/gi, "");
	    var data = ajaxCall("${ctx}/ExecPrc.do?cmd=prcExWorkDriverCalcN", param, false);
	    if(data.Result.Code == null) {
	        alert("처리되었습니다.");
		    
	    } else {
	        alert(data.Result.Message);
	    }
	    
	    doAction1("Search");
	}    

    
</script>
</head>
<body class="hidden">
<div class="wrapper">
    <form id="srchFrm" name="srchFrm" >
    <!-- 조회조건 -->
    <input type="hidden" id="searchStatusCdHidden" name="searchStatusCdHidden" value="" />
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                    	<th>근무일자 </th>
                        <td>
                            <input type="text" id="searchFromYmd" name="searchFromYmd" class="date2" value="" /> ~
                            <input type="text" id="searchToYmd" name="searchToYmd" class="date2" value="" />
                        </td>
                        <th>사번/성명 </th>
                        <td>
	                        <input id="searchSabunName" name ="searchSabunName" type="text" class="text" />
	                    </td>
	                    <th>소속</th>
                     	<td>
	                        <input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" />
	                    </td>
	                    <th>재직상태</th>
                        <td>
                        	<select id="searchStatusCd" name ="searchStatusCd" class="box"  multiple=""></select>
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
                            <li id="txt" class="txt">야근수당(기원)계산</li>
                            <li class="btn">
                                <a href="javascript:doCallPrc('1')" 	class="button authR">1.기원신청내역반영</a>
                                <a href="javascript:doCallPrc('2')" 	class="button authR">2.시수계산</a>
                                <a href="javascript:doCallPrc('3')" 	class="button authR">3.시급불러오기</a>
                                <a href="javascript:doCallPrc('4')" 	class="button authR">4.수당계산</a>
                            	<a href="javascript:doAction1('DownTemplate')" 	class="basic authA">양식다운로드</a>
								<a href="javascript:doAction1('LoadExcel')" 	class="basic authA">업로드</a>
                            	<a href="javascript:doAction1('Insert')"   class="basic authA">입력</a>
                            	<a href="javascript:doAction1('Copy')"   class="basic authA">복사</a>
                                <a href="javascript:doAction1('Save')"  class="basic authA">저장</a>                            
                                <a href="javascript:doAction1('Down2Excel')" class="basic authR">다운로드</a>                                
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