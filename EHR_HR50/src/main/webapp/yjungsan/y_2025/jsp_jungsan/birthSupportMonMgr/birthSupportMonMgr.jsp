<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>출산지원금 내역관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
    var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
    var adjustTypeList = null;

    $(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
        $("#searchWorkYy").val("<%=yeaYear%>") ;
        
        var initdata = {};
        initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata.Cols = [
            {Header:"No|No",                   Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"삭제|삭제",                  Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태|상태",                  Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
          <%// 20250502. 시트 7.0.0.0-20131223-17 버전에서는 SetColProperty 로 DefaultValue가 지원되지 않음. => initdata 세팅으로 조정
            // 20250418. OnLoadExcel 이벤트에서 RowCount 반복 수행으로 인한 성능저하. case "LoadExcel"의 디폴트 값 세팅으로 개선.%>
            {Header:"대상년도|대상년도",             Type:"Text",      Hidden:0,  Width:60,    Align:"Center",   ColMerge:0, SaveName:"work_yy",             KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, DefaultValue:"<%=yeaYear%>" },
            {Header:"정산구분|정산구분",             Type:"Combo",     Hidden:0,  Width:150,    Align:"Center",   ColMerge:0, SaveName:"adjust_type",         KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"사번|사번",                  Type:"Text",      Hidden:0,  Width:50,    Align:"Center", ColMerge:1, SaveName:"sabun",               KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"성명|성명",                  Type:"Popup",     Hidden:0,  Width:70,    Align:"Center", ColMerge:1, SaveName:"name",                KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"소속|소속",                  Type:"Text",      Hidden:0,  Width:90,    Align:"Center", ColMerge:1, SaveName:"org_nm",              KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"자녀성명|자녀성명",             Type:"Text",      Hidden:0,  Width:70,   Align:"Center",   ColMerge:0, SaveName:"fam_nm",                 KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"주민등록번호|주민등록번호",        Type:"Text",      Hidden:0, Width:100,   Align:"Center", ColMerge:0, SaveName:"famres",              KeyField:1, Format:"IdNo",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:200, FullInput:1 },
            {Header:"출산지원금|지급받은날",           Type:"Date",     Hidden:0,  Width:70,    Align:"Center", ColMerge:0, SaveName:"sup_ymd",          KeyField:1,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"출산지원금|지급받은금액",          Type:"Int",      Hidden:0,  Width:100,   Align:"Right", ColMerge:0, SaveName:"sup_mon",            KeyField:1,   CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"출산지원금|지급회차\n(1또는2)",    Type:"Combo",    Hidden:0,  Width:70,    Align:"Center", ColMerge:0, SaveName:"sup_cnt",          KeyField:1,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 },
            {Header:"지급처\n(사업자등록번호)|지급처\n(사업자등록번호)", Type:"Text",    Hidden:0,  Width:110,    Align:"Center", ColMerge:0, SaveName:"regino",          KeyField:1,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"현 근무지\n여부|현 근무지\n여부",              Type:"CheckBox",    Hidden:1,  Width:70,    Align:"Center", ColMerge:0, SaveName:"work_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:0, TrueValue:"Y", FalseValue:"N" },
            {Header:"사업주/지배주주와\n특수관계자(친족관계)\n해당여부|사업주/지배주주와\n특수관계자(친족관계)\n해당여부", Type:"CheckBox",    Hidden:1,  Width:120,    Align:"Center", ColMerge:0, SaveName:"special_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:0, TrueValue:"Y", FalseValue:"N" },
            {Header:"비고|비고",                    Type:"Text", Hidden:0,  Width:100,    Align:"Left",  ColMerge:0, SaveName:"memo",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        //20250414 대량데이터 저장 시, 50건 단위로 분할 처리하도록 사이즈 지정
        try { IBS_setChunkedOnSave("sheet1", { chunkSize : 50 });  } catch(e) { console.info("info", e + ". chunkSize 기능은 [ibsheetinfo.js]의 DoSave 오버라이딩이 필요합니다." ); }     try { sheet1.SetLoadExcelConfig({ "MaxFileSize": 1 /* 1MB */ }); } catch(e) { console.info("info", e + ". MaxFileSize 옵션은 7.0.13.27 버전부터 제공됩니다." ); }
        
        var params = "searchWorkYy="+$("#searchWorkYy").val();

        //정산구분
        adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00303"), "전체" );

    	// 사업장(권한 구분)
    	var ssnSearchType = "<%=ssnSearchType%>";
    	var bizPlaceCdList = "";

    	if(ssnSearchType == "A"){
    		bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
    	}else{
    		bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
    	}
    	
    	sheet1.SetColProperty("sup_cnt",	{ComboText:"1회차|2회차", ComboCode:"1|2"} );
        
    	$("#searchBizPlaceCd").html(bizPlaceCdList[2]);

        $(window).smartresize(sheetResize); sheetInit();
        
        getCprBtnChk();	
			
		//양식다운로드용 sheet 정의		
		templeteTitle1 += "지급받은날 : YYYY-MM-DD의 형식으로 기재합니다.\n\n";
		//templeteTitle1 += "현 근무지 여부 : Y/N \n\n";
		//templeteTitle1 += "사업주/지배주주와 특수관계자(친족관계) 해당여부 : Y/N \n";

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
            sheet1.DoSearch( "<%=jspPath%>/birthSupportMonMgr/birthSupportMonMgrRst.jsp?cmd=selectBirthSupportMonMgr", $("#sheetForm").serialize() );
            break;
        case "Save":
        	if(!dupChk(sheet1, "work_yy|adjust_type|sabun|famres|sup_cnt", true, true)) {break;}
        	//유효성 체크
			if ( validate_chk() ) {
            	sheet1.DoSave( "<%=jspPath%>/birthSupportMonMgr/birthSupportMonMgrRst.jsp?cmd=saveBirthSupportMonMgr", $("#sheetForm").serialize() );
			}
            break;
        case "Insert":

            if(chkRqr()){
                 break;
            }
            var Row = sheet1.DataInsert(0) ;

            sheet1.SetCellValue( Row, "work_yy", $("#searchWorkYy").val());
            sheet1.SetCellValue( Row, "adjust_type", $("#searchAdjustType").val());


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
            var param  = {DownCols:"adjust_type"
                                    +"|sabun|fam_nm|famres|sup_ymd|sup_mon|sup_cnt|regino|memo",SheetDesign:1,Merge:1,DownRows:'0|1',ExcelFontSize:"9"
				,TitleText:templeteTitle1
				,UserMerge :"0,0,1,8"
				,menuNm:$(document).find("title").text()
                ,HiddenColumn:1 //  열숨김 반영 여부 (Default: 0)
                };
            sheet1.Down2Excel(param);
            break;
        case "LoadExcel":
            if(chkRqr()){
                break;
           }

            // 20250418. OnLoadExcel 이벤트에서 RowCount 반복 수행으로 인한 성능저하. case "LoadExcel"의 디폴트 값 세팅으로 개선.
            
            // 20250502. 패키지 4.x(시트 7.0.0.0-20131223-17 버전)에서는 SetColProperty 로 DefaultValue가 지원되지 않음. 
            //              work_yy     => initdata 세팅으로 조정 
            //              adjust_type => 엑셀 양식에서 key-in으로 조정
            //sheet1.SetColProperty(0, "work_yy", { DefaultValue: $("#searchWorkYy").val() } );
            //sheet1.SetColProperty(0, "adjust_type", { DefaultValue: $("#searchAdjustType").val() } );

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
            alertMessage(Code, Msg, StCode, StMsg);

            sheetResize();
        } catch(ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    //저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
            if(Code == 1) {
                doAction1('Search');
            }
        } catch(ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
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
            sheet1.SetCellValue(gPRow, "name",      rv["name"] );
            sheet1.SetCellValue(gPRow, "sabun",     rv["sabun"] );
            sheet1.SetCellValue(gPRow, "org_nm",    rv["org_nm"] );
        }
    }

  //수정(이력) 관련 세팅
	function getCprBtnChk(){
        var params = "&cmbMode=all"
                   + "&searchWorkYy=" + $("#searchWorkYy").val() 
                   + "&searchAdjustType="
                   + "&searchSabun=" ;
        
        //재계산 차수 값 조회
		var strUrl = "<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getReCalcSeq884" + params ;
		var searchReCalcSeq = stfConvCode( codeList(strUrl,"") , "");
		
		if(searchReCalcSeq == null || searchReCalcSeq == "" || searchReCalcSeq[0] == "") {
			$("#searchAdjustType").html("");
		} else {
  			$("#searchAdjustType").html("<option value=''>전체</option>" + searchReCalcSeq[2].replace(/<option value='1'>/g, "<option value='1' selected>"));
  			sheet1.SetColProperty("adjust_type", {ComboText:"|"+searchReCalcSeq[0], ComboCode:"|"+searchReCalcSeq[1]});
		}
	}

	function validate_chk() {
		try{
		    var numericRegex = /^\d+$/;
            var flag = true;
            var msg = "";

			for ( var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++ ) {
				if ( sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U" ) {
				    var inRegino = sheet1.GetCellValue(i, "regino") ;
				    
					// 출산지원금 지급받은금액은 0 이상이어야
					if( 0 >= parseInt(sheet1.GetCellValue(i, "sup_mon")) ) {
						msg = "지급받은금액이 0원 이하입니다. 금액을 정확히 입력하십시오.";
						//sheet1.SetSelectCell(i, "sup_mon");
                        sheet1.SetCellBackColor(i, "sup_mon", "#f79eba");
						sheet1.SetCellValue(i, "sup_mon", "");
						flag = false;
					}  else if( !numericRegex.test(inRegino) || 10 != inRegino.length ) {
						msg = "사업자등록번호는 숫자로 10자리를 입력하십시오.";
						//sheet1.SetSelectCell(i, "regino");
                        sheet1.SetCellBackColor(i, "regino", "#f79eba");
						sheet1.SetCellValue(i, "regino", "");
						flag = false;
					}  else if(sheet1.GetCellValue(i, "sup_ymd") != ""
                        && sheet1.GetCellValue(i, "sup_ymd").length >= 4
                        && sheet1.GetCellValue(i, "sup_ymd").substring(0, 4) != "<%=yeaYear%>") {
                        msg = "<%=yeaYear%>" + "년도에 지급한 출산지원금만 입력이 가능합니다.";
                        sheet1.SetCellBackColor(i, "sup_ymd", "#f79eba");
                        flag = false;
                    }
				}
			}

            if(! flag)
                alert(msg);

            return flag;

		} catch(ex){
			alert("validate_chk Event Error : " + ex);
			return false;
		}

		return true;
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
					<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				</td>
                <td><span>정산구분</span>
                    <select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
                </td>
                <td>
                    <span>사업장</span>
                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')"></select>
                </td>
                <td><span>사번/성명</span>
                <input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> 
                </td>
                <td>
                    <span>지급회차</span>
                    <select id="searchSupCnt" name ="searchSupCnt" class="box" onChange="javascript:doAction1('Search')">
                        <option value="">전체</option>
                    	<option value="1">1회차</option>
                    	<option value="2">2회차</option>
                    </select>
                </td>
                <td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
            </tr>
        </table>
        </div>
    </div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">출산지원금 내역관리</li>
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