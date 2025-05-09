<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>기부금조정명세(관리자)</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
	var helpText;
	$(function() {
		
		$("#searchYear").val("<%=Integer.parseInt(yeaYear) - 1 %>") ;
		
		// 2번 그리드
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata1.Cols = [
			{Header:"No|No",						Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
  			{Header:"삭제|삭제",						Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},    
  			{Header:"상태|상태",						Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},    
            {Header:"대상연도|대상연도",					Type:"Text",    Hidden:0,  Width:70,Align:"Center",    ColMerge:1,   SaveName:"work_yy",			KeyField:1,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"정산구분|정산구분",					Type:"Combo",    Hidden:0,  Width:70,Align:"Center",    ColMerge:1,   SaveName:"adjust_type",		KeyField:1,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
            {Header:"성명|성명",                          Type:"Popup",     Hidden:0,  Width:70,  Align:"Center",  ColMerge:1,   SaveName:"name",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"사번|사번",                      Type:"Text",    Hidden:0,  Width:80,Align:"Center",    ColMerge:1,   SaveName:"sabun",              KeyField:1,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
            {Header:"기부금종류|기부금종류",				Type:"Combo",   Hidden:0,  Width:80,Align:"Center",    ColMerge:1,   SaveName:"contribution_cd",	KeyField:1,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
            {Header:"기부연도|기부연도",					Type:"Text",	Hidden:0,  Width:80,Align:"Center",    ColMerge:1,   SaveName:"donation_yy",		KeyField:1,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
            {Header:"기부금액|기부금액",					Type:"Int",		Hidden:0,  Width:80,Align:"Right",     ColMerge:1,   SaveName:"donation_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"전년까지\n공제된금액|전년까지\n공제된금액",	Type:"Int",		Hidden:0,  Width:80,Align:"Right",     ColMerge:1,   SaveName:"prev_ded_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"공제대상\n금액|공제대상\n금액",			Type:"Int",		Hidden:0,  Width:80,Align:"Right",     ColMerge:1,   SaveName:"cur_ded_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"해당연도\n금액|해당연도\n금액",			Type:"Int",		Hidden:0,  Width:80,Align:"Right",     ColMerge:1,   SaveName:"ded_mon",			KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"해당연도에 공제받지 못한금액|소멸금액",		Type:"Int",		Hidden:0,  Width:80,Align:"Right",     ColMerge:1,   SaveName:"extinction_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"해당연도에 공제받지 못한금액|이월금액",		Type:"Int",		Hidden:0,  Width:80,Align:"Right",     ColMerge:1,   SaveName:"carried_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"금액값 에디트 여부|금액값 에디트 여부",		Type:"Text",	Hidden:1,  Width:80,Align:"Right",     ColMerge:1,   SaveName:"chg_yn",				KeyField:0,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
            {Header:"본인주민번호",                        Type:"Text",    Hidden:1,  Width:70,  Align:"Center",  ColMerge:1,   SaveName:"res_no",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:160 }
            
		];IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//작업구분
        var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "C00303"), "전체" );		
        var contributionCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "C00307"), "" );		

        sheet1.SetColProperty("adjust_type",    {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]} );
        sheet1.SetColProperty("contribution_cd",    {ComboText:"|"+contributionCdList[0], ComboCode:"|"+contributionCdList[1]} );
		
        $("#searchAdjustType").html(adjustTypeList[2]).val("1");
        
        // 사업장
        var bizPlaceCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getBizPlaceCdList") , "전체");
        
        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);
        
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
		$("input[name=searchMon]").change(function(){
			doAction1("Search");
		});
	});

    //Sheet Action Second
    function doAction1(sAction) {

		switch (sAction) {
		case "Search":
            if($("#searchYear").val() == "") {
                alert("대상연도를 입력하여 주십시오.");
                return;
            }
            
            if($("#searchYear").val() >= "<%=yeaYear %>"){
                alert("대상연도는 전년도까지만 조회 가능합니다.");
                $("#searchYear").val("<%=Integer.parseInt(yeaYear)-1%>");
                $("#searchYear").focus();
                return;
            }
            
            sheet1.DoSearch( "<%=jspPath%>/donationAdj/donationAdjUploadRst.jsp?cmd=selectDonationAdjAdminList", $("#sheetForm").serialize(), 1 ); 
            break;
		case "Save": 
			for(var i=2; i < sheet1.LastRow()+2; i++){
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
			sheet1.DoSave( "<%=jspPath%>/donationAdj/donationAdjUploadRst.jsp?cmd=saveDonationAdjAdminDetail"); 
			break;
		case "Insert":
			var newRow = sheet1.DataInsert(0);
			sheet1.SetCellValue(newRow, "work_yy", $("#searchYear").val() ) ;
			sheet1.SetCellValue(newRow, "adjust_type", "" ) ;
			break;
		case "Copy": 
			var newRow = sheet1.DataCopy();
			var flag = 1;
			                                       
            sheet1.SetCellEditable(newRow, "donation_mon",   flag);              
            sheet1.SetCellEditable(newRow, "prev_ded_mon",   flag);              
            sheet1.SetCellEditable(newRow, "cur_ded_mon",    flag);              
            sheet1.SetCellEditable(newRow, "ded_mon",        flag);              
            sheet1.SetCellEditable(newRow, "extinction_mon", flag);              
            sheet1.SetCellEditable(newRow, "carried_mon",    flag);
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); break;
		case "Down2Template":
			var param  = {DownCols:"3|4|6|7|8|9|10|11|12|13|14",SheetDesign:1,Merge:1,DownRows:'0|1',ExcelFontSize:"9"
				,TitleText:templeteTitle1,UserMerge :"0,0,1,11"};
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
        	
			/*
        	if (Code == 1) {
				var flag = 0 ;
				for(var i = 2; i < sheet1.RowCount()+2; i++ ) {
					if( sheet1.GetCellValue("chg_yn", i) == "Y" ) {
						flag = 1 ;//true
					} else {
						flag = 0 ;//false
					}
					flag = 1;
					
					sheet1.SetCellEditable(i, "donation_mon", 	flag);				
					sheet1.SetCellEditable(i, "prev_ded_mon", 	flag);				
					sheet1.SetCellEditable(i, "cur_ded_mon", 	flag);				
					sheet1.SetCellEditable(i, "ded_mon", 		flag);				
					sheet1.SetCellEditable(i, "extinction_mon", flag);				
					sheet1.SetCellEditable(i, "carried_mon", 	flag);		
				}
        	}
			*/
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

	function yeaDataExpPopup(title, helpText, height, width){
        var url     = "<%=jspPath%>/common/yeaDataExpPopup.jsp";

            helpText = "<b>※ 기부금조정명세 입력 안내</b><br>" +
                       "<span style='padding-left:10px;'>* 대상연도 : 연말정산 귀속 대상연도를 나타냅니다.</span><br>" +
                       "<span style='padding-left:10px;'>* 기부연도 : 실제 기부한 연도를 나타냅니다.</span><br>" +
                       "<span style='padding-left:20px;'>안내 : 기부연도 및 대상연도는 당해 귀속연도 이전이어야합니다.(예: 2017귀속 연말정산 => 2016 이하)</span><br>" +
                       "<span style='padding-left:30px;'>2017년의 이월금액은 올해 기부한 금액과 함께 공제금액 정산 후 만들어지므로 입력하실 필요 없습니다.</span><br>";
        
        openYeaDataExpPopup(url, width, height, title, helpText);
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
	   
    //사원 조회
    function openEmployeePopup(Row){
        try{
            
            if(!isPopup()) {return;}
            gPRow = Row;
            pGubun = "employeePopup";
             
            var args    = new Array();
            var rv = openPopup("<%=jspPath%>/common/employeePopup.jsp?authPg=<%=authPg%>", args, "740","520");
         /*
            if(rv!=null){
                sheet1.SetCellValue(Row, "name",        rv["name"] );
                sheet1.SetCellValue(Row, "sabun",       rv["sabun"] );
                sheet1.SetCellValue(Row, "org_nm",      rv["org_nm"] );
                sheet1.SetCellValue(Row, "res_no",      rv["res_no"] );
            }
         */
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
            //sheet1.SetCellValue(gPRow, "org_nm",    rv["org_nm"] );
            sheet1.SetCellValue(gPRow, "res_no",    rv["res_no"] );
        }
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <div class="sheet_search outer">
    <form id="sheetForm" name="sheetForm" >
    <!-- Second Grid 조회 조건 -->
        <div>
        <table>
        <tr>
            <td>
            	<span>연도</span>
				<input id="searchYear" name ="searchYear" type="text" class="text" maxlength="4" style="width:35px"/>
			</td>
			<td>
				<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select> 
			</td>			
			<td>
				<input type="radio" id="searchMon" name="searchMon" class="radio" value="1" checked /> <span>전체</span>
				<input type="radio" id="searchMon" name="searchMon" class="radio" value="2"  /> <span>이월금액 발생자</span>
			</td>
            <td>
                <span>사업장</span>
                <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box"></select>
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
            <li class="txt">기부금이월자료 업로드</li>
            <li class="btn">
<!--               <a href="javascript:yeaDataExpPopup('기부금조정명세 입력 안내', helpText, 200, 700)" class="cute_gray authA">입력 안내</a> &nbsp; -->
              <a href="javascript:doAction1('Down2Template')"	class="basic authA">양식 다운로드</a>
              <a href="javascript:doAction1('LoadExcel')"   	class="basic authA">업로드</a>
              <a href="javascript:doAction1('Insert')" 			class="basic authA">입력</a>
              <a href="javascript:doAction1('Copy')"   			class="basic authA">복사</a>
              <a href="javascript:doAction1('Save')"   			class="basic authA">저장</a>
              <a href="javascript:doAction1('Down2Excel')"   	class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>

</div>
</body>
</html>