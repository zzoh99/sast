<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="hidden">
<head>
    <title>종전근무지일괄등록</title>
    <%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
    <%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
    var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";

    $(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
        let now = new Date();
        $("#searchWorkYy").val(now.getFullYear() - 1);

        var initdata = {};
        initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata.Cols = [
            {Header:"No",                    Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"삭제",                  Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태",                  Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"년도",                  Type:"Text",      Hidden:0,  Width:40,    Align:"Left",   ColMerge:0, SaveName:"workYy",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"정산구분",              Type:"Combo",     Hidden:0,  Width:60,    Align:"Left",   ColMerge:0, SaveName:"adjustType",         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"사번",                  Type:"Text",      Hidden:0,  Width:80,    Align:"Center", ColMerge:1, SaveName:"sabun",               KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"성명",                  Type:"Popup",     Hidden:0,  Width:70,    Align:"Center", ColMerge:1, SaveName:"name",                KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"소속",                  Type:"Text",      Hidden:0,  Width:90,    Align:"Center", ColMerge:1, SaveName:"orgNm",              KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },

            {Header:"순서",                  Type:"Text",      Hidden:1,  Width:245,   Align:"Left",   ColMerge:0, SaveName:"seq",                 KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"근무처명(1)",           Type:"Text",      Hidden:0,  Width:80,    Align:"Left",   ColMerge:0, SaveName:"enterNm",            KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"납세\n조합구분",        Type:"CheckBox",  Hidden:0,  Width:70,    Align:"Center", ColMerge:0, SaveName:"napseYn",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,    EditLen:100, TrueValue:"Y", FalseValue:"N" },

            {Header:"사업자등록번호(3)",                    Type:"Text",    Hidden:0,  Width:120,   Align:"Center", ColMerge:0, SaveName:"enterNo",            KeyField:1,   CalcLogic:"",   Format:"SaupNo",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"근무기간\n시작일(11)",                 Type:"Date",    Hidden:0,  Width:90,    Align:"Center", ColMerge:0, SaveName:"workSYmd",          KeyField:1,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"근무기간\n종료일(11)",                 Type:"Date",    Hidden:0,  Width:90,    Align:"Center", ColMerge:0, SaveName:"workEYmd",          KeyField:1,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"감면기간\n시작일(12)",                 Type:"Date",    Hidden:0,  Width:90,    Align:"Center", ColMerge:0, SaveName:"reduceSYmd",        KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"감면기간\n종료일(12)",                 Type:"Date",    Hidden:0,  Width:90,    Align:"Center", ColMerge:0, SaveName:"reduceEYmd",        KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"급여액(13)",                           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"payMon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"상여액(14)",                           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"bonusMon",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"인정상여(15)",                         Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"etcBonusMon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"주식매수선택권\n행사이익(15-1)",       Type:"AutoSum", Hidden:0,  Width:100,   Align:"Right",  ColMerge:0, SaveName:"stockBuyMon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"우리사주조합\n인출금(15-2)",           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"stockUnionMon",     KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"임원퇴직소득금액\n한도초과액(15-3)",   Type:"AutoSum", Hidden:0,  Width:100,   Align:"Right",  ColMerge:0, SaveName:"imwonRetOverMon",  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"소득세(73-79)",                           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"incomeTaxMon",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"지방소득세(73-80)",                       Type:"AutoSum", Hidden:0,  Width:100,    Align:"Right",  ColMerge:0, SaveName:"inhbtTaxMon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"농특세(73-81)",                           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"ruralTaxMon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"국민연금",                             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"penMon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"사립학교\n교직원연금",                 Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"etcMon1",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"공무원연금",                           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"etcMon2",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"군인연금",                             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"etcMon3",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"별정우체국연금",                       Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"etcMon4",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"건강보험",                             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"helMon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"고용보험",                             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"empMon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"국외비과세(18)",                       Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notaxAbroadMon",    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"식대비과세",                       Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notaxFoodMon",    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"생산직비과세(18-1)",                   Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notaxWorkMon",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"출산보육\n비과세(18-2)",               Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notaxBabyMon",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"연구보조\n비과세(18-4)",               Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notaxResearchMon",  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"외국인\n비과세",                       Type:"AutoSum", Hidden:1,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notaxFornMon",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"취재수당\n비과세(18-6)",                     Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notaxReporterMon",  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"수련보조수당\n비과세(19)",             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notaxTrainMon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"기타\n비과세",             Type:"AutoSum", Hidden:1,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notaxEtcMon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"결정세액(72)",             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"finTotTaxMon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        var params = "searchWorkYy="+$("#searchWorkYy").val();

        //정산구분
        var adjustTypeList = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd=C00303",false).codeList, "전체");
        $("#searchAdjustType").html(adjustTypeList["C00303"][2]).val("1");

        sheet1.SetColProperty("adjustType",    {ComboText:adjustTypeList["C00303"][0], ComboCode:adjustTypeList["C00303"][1]} );

    	// 사업장(권한 구분)
    	var ssnSearchType = "${ssnSearchType}";
    	var bizPlaceCdList = "";

        if(ssnSearchType == "A"){
            bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getBizPlaceCdList",false).codeList, "전체");
        }else{
            bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getBizPlaceCdAuthList",false).codeList, "");
        }

        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);

        $(window).smartresize(sheetResize); sheetInit();

        templeteTitle1 += "납세 조합구분 : Y/N \n";

    });

    $(function() {
        $("#searchSbNm").bind("keyup",function(event){
            if( event.keyCode == 13){
                doAction1("Search");
                $(this).focus();
            }
        });
    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
            sheet1.DoSearch( "/BefComUpld.do?cmd=getBefComUpldList", $("#sheetForm").serialize() );
            break;
        case "Save":
        	if(!reduceDateCheck()) {return;}
            IBS_SaveName(document.sheetForm, sheet1);
            sheet1.DoSave( "/BefComUpld.do?cmd=saveBefComUpld", $("#sheetForm").serialize() );
            break;
        case "Insert":

            if(chkRqr()){
                 break;
            }
            var Row = sheet1.DataInsert(0) ;

            sheet1.SetCellValue( Row, "workYy", $("#searchWorkYy").val());
            sheet1.SetCellValue( Row, "adjustType", $("#searchAdjustType").val());


            break;
        case "Copy":
            sheet1.DataCopy();
            break;
        case "Clear":
            sheet1.RemoveAll();
            break;
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N",menuNm:$(document).find("title").text()};
            sheet1.Down2Excel(param);
            break;
        case "Down2Template":
            var param  = {DownCols:"sabun|enterNm|napseYn|enterNo|workSYmd|workEYmd|reduceSYmd|reduceEYmd|payMon|bonusMon|etcBonusMon|stockBuyMon|stockUnionMon|imwonRetOverMon|incomeTaxMon|inhbtTaxMon|ruralTaxMon|penMon|etcMon1|etcMon2|etcMon3|etcMon4|helMon|empMon|notaxAbroadMon|notaxFoodMon|notaxWorkMon|notaxBabyMon|notaxResearchMon|notaxReporterMon|notaxTrainMon|finTotTaxMon",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
                ,TitleText:templeteTitle1,UserMerge :"0,0,1,10",menuNm:$(document).find("title").text()
            };
            sheet1.Down2Excel(param);
            break;
        case "LoadExcel":

            if(chkRqr()){
                break;
            }

            var params = {Mode:"HeaderMatch", WorkSheetNo:1};
            sheet1.LoadExcel(params);
            break;
        }
    }

    function chkRqr(){

        var chkSearchAdjustType    = $("#searchAdjustType").val();

        var chkValue = false;

        if(chkSearchAdjustType == ''){
            alert("정산구분을 선택 후 입력 할 수 있습니다.");
            chkValue = true;
        }

        return chkValue;
    }

    //조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") {
                alert(Msg);
            }
            sheetResize();
        } catch(ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    //저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") {
                alert(Msg);
            }

            if(Code > 0) {
                doAction1("Search");
            }

        } catch(ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }
	// 감면기간 시작,종료일 체크
	function reduceDateCheck(){

		var workSYmd = ""; //근무기간시작일
		var workEYmd = ""; //근무기간종료일

		var reSYmd = ""; //감면기간시작일
		var reEYmd = ""; //감면기간종료일
		var resSYy = "";	//감면기간시작년도
		var resEYy = "";	//감면기간종료년도

		var flagMsg = "";
		var redSFlag = true;
		var redEFlag = true;

		for (i = 1; i < sheet1.RowCount()+1; i++){

			workSYmd =  sheet1.GetCellValue(i, "workSYmd"); //근무기간시작일
			workEYmd =  sheet1.GetCellValue(i, "workEYmd"); //근무기간종료일
	    	reSYmd =  sheet1.GetCellValue(i, "reduceSYmd"); //감면기간시작일
	    	reEYmd =  sheet1.GetCellValue(i, "reduceEYmd"); //감면기간종료일

	    	resSYy = reSYmd.substring(0,4);
	    	resEYy = reEYmd.substring(0,4);
	    	
	    	//감면기간 시작일 체크
	    	if(reSYmd != ""){
	    		if($("#searchWorkYy").val() != resSYy){
		    		flagMsg = "감면기간시작, 종료일은 귀속연도에 포함되어야 합니다.";
		    		redSFlag = false;
		    	}else{
		    		if(!(reSYmd >= workSYmd && reSYmd <= workEYmd)){
			    		flagMsg = "감면기간시작, 종료일은 근무기간에 포함되어야 합니다.";
			    		redSFlag = false;
		    		}else{
		    			if(reEYmd != "" && !(reSYmd <= reEYmd)){
		    				flagMsg = "감면기간 시작일은 감면기간 종료일자보다 작아야합니다.";
				    		redSFlag = false;
		    			}
		    		}
		    	}
	    	}

	    	//감면기간 종료일 체크
	    	if(reEYmd != ""){
		    	if($("#searchWorkYy").val() != resEYy){
		    		flagMsg = "감면기간시작, 종료일은 귀속연도에 포함되어야 합니다.";
		    		redEFlag = false;
		    	}else{
		    		if(!(reEYmd >= workSYmd && reEYmd <= workEYmd)){
		    			flagMsg = "감면기간시작, 종료일은 근무기간에 포함되어야 합니다.";
			    		redEFlag = false;
		    		}else{
		    			if(reEYmd != "" && !(reSYmd <= reEYmd)){
		    				flagMsg = "감면기간 시작일은 감면기간 종료일자보다 작아야합니다.";
				    		redEFlag = false;
		    			}
		    		}
		    	}
	    	}
		}

		if(!redSFlag && flagMsg != ""){
			alert(flagMsg);
			return;
		}else{
			if(!redEFlag && flagMsg != "") {
				alert(flagMsg);
				return;
			}
		}
		return redEFlag;
	}
    var gPRow  = "";
    var pGubun = "";

    //팝업 클릭시 발생
    function sheet1_OnPopupClick(Row,Col) {
        try {
            if(sheet1.ColSaveName(Col) == "name") {
                openEmployeePopup(Row) ;
            }
        } catch(ex) {
            alert("OnPopupClick Event Error : " + ex);
        }
    }



    //값이 바뀔때 발생
    function sheet1_OnChange(Row, Col, Value, OldValue) {
        try{

        } catch(ex) {
            alert("OnChange Event Error : " + ex);
        }
    }



    //사원 조회
    function openEmployeePopup(Row){
        try{

            if(!isPopup()) {return;}
            gPRow = Row;
            pGubun = "employeePopup";

            let layerModal = new window.top.document.LayerModal({
                id : 'employeeLayer'
                , url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
                , parameters : {}
                , width : 740
                , height : 520
                , title : '사원조회'
                , trigger :[
                    {
                        name : 'employeeTrigger'
                        , callback : function(result){
                            sheet1.SetCellValue(Row, "sabun",   result.sabun);
                            sheet1.SetCellValue(Row, "name",   result.name);
                            sheet1.SetCellValue(Row, "orgNm",   result.orgNm);
                        }
                    }
                ]
            });
            layerModal.show();

        } catch(ex) {
            alert("Open Popup Event Error : " + ex);
        }
    }

  //업로드 완료후 호출
    function sheet1_OnLoadExcel(result) {
        try {
            for(var i = 1; i < sheet1.RowCount()+1; i++) {
                sheet1.SetCellValue( i, "workYy", $("#searchWorkYy").val());
                sheet1.SetCellValue( i, "adjustType", $("#searchAdjustType").val());
            }
        } catch(ex) {
            alert("OnLoadExcel Event Error " + ex);
        }
    }


</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="menuNm" name="menuNm" value="" />
    <div class="sheet_search outer">
        <div>
        <table>
            <tr>
                <td><span>년도</span>
				<%
				if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
				%>
					<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text center readonly" maxlength="4" style="width:20%" readonly/>
				<%}else{%>
					<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text center readonly" maxlength="4" style="width:20%" readonly/>
				<%}%>
				</td>
                <td><span>정산구분</span>
                    <select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
                </td>
                <td>
                    <span>사업장</span>
                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')"></select>
                </td>
                <td><span>사번/성명</span>
                <input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> </td>
                <td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
            </tr>
        </table>
        </div>
    </div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">종전근무지 일괄등록</li>
            <li class="btn">
                <a href="javascript:doAction1('Down2Template')" class="basic btn-download authA">양식다운로드</a>
                <a href="javascript:doAction1('LoadExcel')"     class="basic btn-upload authA">업로드</a>
                <a href="javascript:doAction1('Insert')"        class="basic authA">입력</a>
                <a href="javascript:doAction1('Copy')"          class="basic authA">복사</a>
                <a href="javascript:doAction1('Save')"          class="basic btn-save authA">저장</a>
                <a href="javascript:doAction1('Down2Excel')"    class="basic btn-download authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>