<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>기타소득감면기간관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";

	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",		Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",		Type:"<%=sSttTy%>",	Hidden:1,  Width:20,	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
	        {Header:"년도",		Type:"Text",      	Hidden:0,  Width:50,    Align:"Center", ColMerge:1,   SaveName:"work_yy",			KeyField:1,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 },
	        {Header:"정산구분",	Type:"Combo",      	Hidden:0,  Width:50,    Align:"Center", ColMerge:1,   SaveName:"adjust_type",		KeyField:1,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	        {Header:"성명",		Type:"Popup",      	Hidden:0,  Width:50,    Align:"Center", ColMerge:1,   SaveName:"name",				KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	        {Header:"사번",		Type:"Text",      	Hidden:0,  Width:50,    Align:"Center", ColMerge:1,   SaveName:"sabun",				KeyField:1,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
	        {Header:"사업장",	    Type:"Combo",      	Hidden:0,  Width:50,   Align:"Center",	ColMerge:1,   SaveName:"business_place_cd",	KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	        {Header:"감면기간\n필요여부",Type:"CheckBox",   Hidden:0,  Width:50,   Align:"Center", ColMerge:1,   SaveName:"adj_element_yn",      KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8, TrueValue:"Y", FalseValue:"N"},
	        {Header:"감면기간\n시작일",	Type:"Date",    Hidden:0,  Width:100,   Align:"Center",	ColMerge:1,   SaveName:"reduce_s_ymd",		KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
	        {Header:"감면기간\n종료일", Type:"Date",    Hidden:0,  Width:100,   Align:"Center", ColMerge:1,   SaveName:"reduce_e_ymd",      KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 }
	    ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);
        sheet1.SetCountPosition(4);

    	// 사업장(권한 구분)
    	var ssnSearchType = "<%=ssnSearchType%>";
    	var bizPlaceCdList = "";

    	if(ssnSearchType == "A"){
    		bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
    	}else{
    		bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
    	}

        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);
        sheet1.SetColProperty("business_place_cd",    {ComboText:"|"+bizPlaceCdList[0], ComboCode:"|"+bizPlaceCdList[1]});

		$(window).smartresize(sheetResize); sheetInit();
		getCprBtnChk();	
		doAction1("Search");
			
		//양식다운로드용 sheet 정의
		templeteTitle1 += "감면기간 시작/종료일 : YYYY-MM-DD   예)"+$("#srchYear").val()+"-01-01 \n";

	});

	$(function() {
		$("#srchYear").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

        $("#srchSbNm").bind("keyup",function(event){
            if( event.keyCode == 13){
                doAction1("Search");
            }
        });
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "cmd=selectYearEtcReduceYmdMgr&"+$("#srchFrm").serialize();
			sheet1.DoSearch( "<%=jspPath%>/yearEtcReduceYmdMgr/yearEtcReduceYmdMgrRst.jsp", param );
			break;
		case "Save":
			if (!dupChk(sheet1, "work_yy|adjust_type|sabun", true, true)) {break;}
			if (!reduceChk()) {break;}
			sheet1.DoSave( "<%=jspPath%>/yearEtcReduceYmdMgr/yearEtcReduceYmdMgrRst.jsp?cmd=saveYearEtcReduceYmdMgr",$("#srchFrm").serialize());
			break;
		case "Insert":
			if ($("#srchAdjustType").val() == "") {
				alert("정산구분을 먼저 지정하십시오.");
				break;
			}
			
			var Row = sheet1.DataInsert(0) ;
			sheet1.SetCellValue(Row, "work_yy", $("#srchYear").val() ) ;
			sheet1.SetCellValue(Row, "adjust_type", $("#srchAdjustType").val() ) ;
			sheet1.SetCellValue(Row, "business_place_cd", $("#searchBizPlaceCd").val() ) ;
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
       case "Down2Template":
			var param  = {DownCols:"sabun|reduce_s_ymd|reduce_e_ymd",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
						  ,TitleText:templeteTitle1,UserMerge :"0,0,1,3",menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
        case "LoadExcel":
			if ($("#srchAdjustType").val() == "") {
				alert("정산구분을 먼저 지정하십시오.");
				break;
			}
			
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
			if(sheet1.RowCount() > 0){
				var alertflag = false;
				for(var i = 1; i < sheet1.RowCount()+1; i++) {
					var adjElYn = sheet1.GetCellValue(i, "adj_element_yn");
					var redSymd = sheet1.GetCellValue(i, "reduce_s_ymd");
					var redEymd = sheet1.GetCellValue(i, "reduce_e_ymd");

					if(adjElYn == "Y"){
						if(redSymd == "" || redEymd == ""){
							if(redSymd == "") sheet1.SetCellBackColor(i, "reduce_s_ymd", "#F4A460") ;
							if(redEymd == "") sheet1.SetCellBackColor(i, "reduce_e_ymd", "#F4A460") ;
	                        alertflag = true;	
						}
					}
				}
				/*if(alertflag){
					alert("감면기간을 입력해주세요.");
					return;
				}*/
			}
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	  //업로드 완료후 호출
  function sheet1_OnLoadExcel(result) {
      try {
      	for(var i = 1; i < sheet1.RowCount()+1; i++) {
      		sheet1.SetCellValue( i, "work_yy", $("#srchYear").val());
            sheet1.SetCellValue( i, "adjust_type", $("#srchAdjustType").val());
      	}
      } catch(ex) {
          alert("OnLoadExcel Event Error " + ex);
      }
  }
	  
	// 저장 후 메시지
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
            sheet1.SetCellValue(gPRow, "name",      rv["name"] );
            sheet1.SetCellValue(gPRow, "sabun",     rv["sabun"] );
            sheet1.SetCellValue(gPRow, "org_nm",    rv["org_nm"] );
        }
    }

    function reduceChk(){
    	var reFlag = true;
        var reSymd = "";
        var reEymd = "";
		var subSymd = "";
		var subEymd = "";
	    var repSymd = "";
		var repEymd = "";

	    var chkCnt1 = 0;
	    var chkCnt2 = 0;

        for(var i = 1; i < sheet1.RowCount()+1; i++) {
        	if(sheet1.GetCellValue(i,"sStatus") != "" && sheet1.GetCellValue(i,"sStatus") != "R"){
        		reSymd = sheet1.GetCellValue(i,"reduce_s_ymd");
                reEymd = sheet1.GetCellValue(i,"reduce_e_ymd");

                subSymd = reSymd.substr(0,4);
                subEymd = reEymd.substr(0,4);

                repSymd = reSymd.replace(/-/gi, '');
                repEymd = reEymd.replace(/-/gi, '');

                if(subSymd != "" && subSymd != $("#srchYear").val()){
                    chkCnt1++;
                    sheet1.SetCellBackColor(i,"reduce_s_ymd","#F4A460");
                }
                if(subEymd != "" && subEymd != $("#srchYear").val()){
                    chkCnt1++;
                    sheet1.SetCellBackColor(i,"reduce_e_ymd","#F4A460");
                }
                if(reSymd != "" && repEymd != ""){
                    if(repSymd > repEymd){
                        chkCnt2++;
                    }
                }	
        	}
		}
        if(chkCnt1 > 0){
            alert("감면기간시작, 종료일은 귀속연도에 포함되어야 합니다.\n Ex) "+$("#srchYear").val()+"-01-01 ~ "+$("#srchYear").val()+"-12-31");
            reFlag = false;
            return;
        }else if(chkCnt2 > 0){
            alert("감면기간 시작일자는 감면기간 종료일자보다 작아야합니다.");
            reFlag = false;
            return;
        }
        return reFlag;
    }
    
  //수정(이력) 관련 세팅
	function getCprBtnChk(){
        var params = "&cmbMode=all"
                   + "&searchWorkYy=" + $("#srchYear").val() 
                   + "&searchAdjustType="
                   + "&searchSabun=" ;
        
        //재계산 차수 값 조회
		var strUrl = "<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getReCalcSeq884" + params ;
		var searchReCalcSeq = stfConvCode( codeList(strUrl,"") , "");
		//console.log(searchReCalcSeq)
		if(searchReCalcSeq == null || searchReCalcSeq == "" || searchReCalcSeq[0] == "") {
			$("#srchAdjustType").html("");
		} else {   			
  			$("#srchAdjustType").html("<option value=''>전체</option>" + searchReCalcSeq[2].replace(/<option value='1'>/g, "<option value='1' selected>"));
  			$("#srchAdjustType").append("<option value='9'>원천징수부</option>");
 			sheet1.SetColProperty("adjust_type", {ComboText:"|"+searchReCalcSeq[0]+"|원천징수부", ComboCode:"|"+searchReCalcSeq[1]+"|9"});
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="srchOrgCd" name="srchOrgCd" value =""/>
		<input type="hidden" id="menuNm"    name="menuNm"    value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
					    <td>
					    	<span>년도</span>
							<%-- 무의미한 분기문 주석 처리 20240919
							if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
							--%>
								<input id="srchYear" name ="srchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" value="<%=yeaYear%>" readonly="readonly" />
							<%-- 무의미한 분기문 주석 처리 20240919}else{%>
							    <input id="srchYear" name ="srchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" value="<%=yeaYear%>" readonly="readonly" />
							<%}--%>
						</td>
						<td>
							<span>정산구분</span>
							<select id="srchAdjustType" name ="srchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
						</td>
                        <td>
                            <span>사업장</span>
                            <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')"></select>
                        </td>
						<td>
							<span>사번/성명</span>
							<input id="srchSbNm" name ="srchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
    <div class="outer">
        <div class="sheet_title">
        <ul>
			<li id="txt" class="txt">기타소득감면기간관리</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Template')" class="basic btn-download authA">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel')" 	class="basic btn-upload authA">업로드</a>
				<a href="javascript:doAction1('Save')" 			class="basic btn-save authA">저장</a>
				<a href="javascript:doAction1('Down2Excel')" 	class="basic btn-download authA">다운로드</a>
			</li>
        </ul>
        </div>
    </div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>