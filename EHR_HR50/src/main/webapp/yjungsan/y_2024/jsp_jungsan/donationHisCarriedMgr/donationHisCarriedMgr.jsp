<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>기부금조정명세(관리자)</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";

	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		$("#searchYear").val("<%=yeaYear%>") ;

        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata1.Cols = [
			{Header:"No|No",						Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
  			{Header:"삭제|삭제",						Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
  			{Header:"상태|상태",						Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"사원번호|사원번호",					Type:"Text",    Hidden:0,  Width:90,	Align:"Center",    ColMerge:1,   SaveName:"sabun",				KeyField:1,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
            {Header:"성명|성명",		    			Type:"PopupEdit",Hidden:0, Width:80,	Align:"Center",    ColMerge:1,   SaveName:"name",				KeyField:1,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
            {Header:"정산구분|정산구분",					Type:"Combo",   Hidden:0,  Width:70,	Align:"Center",    ColMerge:1,   SaveName:"adjust_type",		KeyField:1,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
            {Header:"정산년도|정산년도",					Type:"Text",    Hidden:0,  Width:70,	Align:"Center",    ColMerge:1,   SaveName:"work_yy",			KeyField:1,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
            {Header:"기부금종류|기부금종류",				Type:"Combo",   Hidden:0,  Width:80,	Align:"Center",    ColMerge:1,   SaveName:"contribution_cd",	KeyField:1,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
            {Header:"기부년도|기부년도",					Type:"Text",	Hidden:0,  Width:80,	Align:"Center",    ColMerge:1,   SaveName:"donation_yy",		KeyField:1,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
            {Header:"기부금액|기부금액",					Type:"Int",		Hidden:0,  Width:80,	Align:"Right",     ColMerge:1,   SaveName:"donation_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"전년까지\n공제된금액|전년까지\n공제된금액",	Type:"Int",		Hidden:0,  Width:80,	Align:"Right",     ColMerge:1,   SaveName:"prev_ded_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"공제대상\n금액|공제대상\n금액",			Type:"Int",		Hidden:0,  Width:80,	Align:"Right",     ColMerge:1,   SaveName:"cur_ded_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"해당연도\n금액|해당연도\n금액",			Type:"Int",		Hidden:0,  Width:80,	Align:"Right",     ColMerge:1,   SaveName:"ded_mon",			KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"해당연도에 공제받지 못한금액|소멸금액",		Type:"Int",		Hidden:0,  Width:80,	Align:"Right",     ColMerge:1,   SaveName:"extinction_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"해당연도에 공제받지 못한금액|이월금액",		Type:"Int",		Hidden:0,  Width:80,	Align:"Right",     ColMerge:1,   SaveName:"carried_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"금액값 에디트 여부|금액값 에디트 여부",		Type:"Text",	Hidden:1,  Width:80,	Align:"Right",     ColMerge:1,   SaveName:"chg_yn",				KeyField:0,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 }
		];IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//작업구분
        var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00303"), "" );
        var contributionCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00307"), "" );

		sheet1.SetColProperty("adjust_type", 		{ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]} );
        sheet1.SetColProperty("contribution_cd",    {ComboText:"|"+contributionCdList[0], ComboCode:"|"+contributionCdList[1]} );

        $("#searchAdjustType").html(adjustTypeList[2]);
        $(window).smartresize(sheetResize);
        sheetInit();

        doAction1("Search");

		//양식다운로드 title 정의
		var codeCdNm = "", codeCd = "", codeNm = "";

		codeCdNm = "";
		codeNm = adjustTypeList[0].split("|"); codeCd = adjustTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "정산구분 : " + codeCdNm + "\n";

		codeCdNm = "";
		codeNm = contributionCdList[0].split("|"); codeCd = contributionCdList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "기부금종류 : " + codeCdNm + "\n";
	});

	$(function(){
		$("#searchYear").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

	});

    //Sheet Action Second
    function doAction1(sAction) {

		switch (sAction) {
		case "Search":
			if($("#searchYear").val() == "") {
        		alert("정산년도를 입력하여 주십시오.");
        		return;
        	}
			sheet1.DoSearch( "<%=jspPath%>/donationHisCarriedMgr/donationHisCarriedMgrRst.jsp?cmd=selectDonationHisCarriedMgrLst", $("#sheetForm").serialize() );
       	   	break;
		case "Save":
			// 중복체크
			if (!dupChk(sheet1, "work_yy|adjust_type|sabun|contribution_cd|donation_yy", false, true)) {return;}
			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
				if(sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U"){
					if(sheet1.GetCellValue(i, "work_yy")*1 > "<%=yeaYear%>"*1) {
						alert("<%=yeaYear%>년 이후 기부금내역은 입력할 수 없습니다.");
						return;
					}
					if(sheet1.GetCellValue(i, "work_yy") == "<%=yeaYear%>"){
						alert('<%=yeaYear%>년 기부금내역은 기부금관리에서 등록하시기 바랍니다.');
						return;
					}
				}
			}
			sheet1.DoSave( "<%=jspPath%>/donationHisCarriedMgr/donationHisCarriedMgrRst.jsp?cmd=saveDonationHisCarriedMgr");
			break;
		case "Insert":
			var newRow = sheet1.DataInsert(0);
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param); break;
		case "Down2Template":
			var param  = {DownCols:"sabun|name|adjust_type|work_yy|contribution_cd|donation_yy|donation_mon|prev_ded_mon|cur_ded_mon|ded_mon|extinction_mon|carried_mon",SheetDesign:1,Merge:1,DownRows:'0|1',ExcelFontSize:"9"
				,TitleText:templeteTitle1,UserMerge :"0,0,1,11",menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":
       	    var params = {Mode:"HeaderMatch", WorkSheetNo:1};
       	 	sheet1.LoadExcel(params);
       	    break;
         }
    }

	// 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();

        	if (Code == 1) {
				var flag = 0 ;
				for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
					if( sheet1.GetCellValue(i, "chg_yn") == "Y" ) {
						flag = 1 ;//true
					} else {
						flag = 0 ;//false
					}

					sheet1.SetCellEditable(i, "donation_mon", 	flag);
					sheet1.SetCellEditable(i, "prev_ded_mon", 	flag);
					sheet1.SetCellEditable(i, "cur_ded_mon", 	flag);
					sheet1.SetCellEditable(i, "ded_mon", 		flag);
					sheet1.SetCellEditable(i, "extinction_mon", flag);
					sheet1.SetCellEditable(i, "carried_mon", 	flag);
				}
        	}
        } catch (ex) {
        	alert("OnSearchEnd Event Error : " + ex);
        }
    }

    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
        		doAction1("Search");
			}
        } catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
        }
    }

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

    var gPRow  = "";
    var pGubun = "";

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
        }
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <div class="sheet_search outer">
    <form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="menuNm" name="menuNm" value="" />
    <!-- Second Grid 조회 조건 -->
        <div>
        <table>
        <tr>
            <td>
            	<span>년도</span>
				<input id="searchYear" name ="searchYear" type="text" class="text" maxlength="4" style="width:35px"/>
			</td>
			<td>
				<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
			</td>
			<td>
				<span>사번/성명</span>
				<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
			</td>
            <td>
            	<a href="javascript:doAction1('Search')" class="button">조회</a>
            </td>
        </tr>
        </table>
        </div>
    </form>
    </div>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">기부금이월관리</li>
            <li class="btn">
              <a href="javascript:doAction1('Down2Template')"	class="basic btn-download authA">양식 다운로드</a>
              <a href="javascript:doAction1('LoadExcel')"   	class="basic btn-upload authA">업로드</a>
              <a href="javascript:doAction1('Insert')" 			class="basic authA">입력</a>
              <a href="javascript:doAction1('Copy')"   			class="basic authA">복사</a>
              <a href="javascript:doAction1('Save')"   			class="basic btn-save authA">저장</a>
              <a href="javascript:doAction1('Down2Excel')"   	class="basic btn-download authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>

</div>
</body>
</html>