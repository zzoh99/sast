<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>원천징수영수증</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">

	$(function() {

		/* 현재년도 */
		$("#searchYear").val("<%=yjungsan.util.DateUtil.getDateTime("yyyy")%>") ;

		var searchYM = <%=curSysYear%>;
		
		/* 상반기 (2~7월) */
		if(<%=curSysMon%> > 1 && <%=curSysMon%> < 8){
			searchYM = searchYM +"06";
		}
		/* 하반기 (8~1월)*/
		else{
			if(<%=curSysMon%> == 1) {
				searchYM = searchYM - 1;
			}
			searchYM = searchYM + "12";
		}
		/* 소득구분 */
		var includeGbList	= stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+searchYM,"YEA003"), "");
		$("#includeGb").html(includeGbList[2]);

		$('#includeGb option:eq(0)').prop('selected', true);


		/* 상/하반기 */
		var halfTypeList = {ComboText:"상반기|하반기", ComboCode:"1|2"};

		/* default 현재달에 맞게 */
		var today = new Date();
		var mm = today.getMonth()+1;

		/* 상반기 (2~7월) */
		if(mm > 1 && mm < 8){
			$("#searchHalfType01").prop("selected", true);
		}
		/* 하반기 (8~1월)*/
		else{
			if(mm == 1) {
				$("#searchYear").val($("#searchYear").val()-1);
			}
			$("#searchHalfType02").prop("selected", true);
		}

		/* 사업장 */

		// 사업장(권한 구분)
		var ssnSearchType = "<%=removeXSS(ssnSearchType, '1')%>";

		if(ssnSearchType == "A"){
		var	businessPlaceList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBusinessPlaceList","",false).codeList, "");
		}else{
			businessPlaceList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}
		$("#searchBusinessPlace").html(businessPlaceList[2]);

		$('#searchBusinessPlace option:eq(0)').prop('selected', true);

		$("#searchWorkYy").val("<%=yeaYear%>") ;

		//조회건수가 너무 많을 수 있으므로 초기 조회조건에 세팅
		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
 			{Header:"No",			Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"성명",			Type:"Popup",      	Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"name",       			KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,	EditLen:100 },
			{Header:"사번",      	  	Type:"Text",      	Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"sabun",      			KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,	EditLen:100 },

			{Header:"대상년도",      	Type:"Text",      	Hidden:0,  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"work_yy",  			KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,	EditLen:100 },
			{Header:"반기구분",      	Type:"Combo",		Hidden:0,  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"half_type",   			KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,	EditLen:100 },
			{Header:"소득구분",      	Type:"Combo",      	Hidden:0,  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"income_type",  		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,	EditLen:100 },
			{Header:"사업장",      	Type:"Combo",		Hidden:0,  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"business_place_cd",  	KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,	EditLen:100 },

			{Header:"출력순서",      	Type:"Text",		Hidden:0,  Width:70,	Align:"Center",  ColMerge:0,   SaveName:"rn",    				KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,	EditLen:100 },
			{Header:"전체",      	  	Type:"CheckBox",  	Hidden:0,  Width:70,	Align:"Center",  ColMerge:0,   SaveName:"checked",    			KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },


		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);


		/* 반기구분 */
		sheet1.SetColProperty("half_type", halfTypeList);
		/* 사업장 */
		sheet1.SetColProperty("business_place_cd", 	{ComboText:"|"+businessPlaceList[0], ComboCode:"|"+businessPlaceList[1]} );
		/* 소득구분 */
		sheet1.SetColProperty("income_type", 		{ComboText:"|"+includeGbList[0], ComboCode:"|"+includeGbList[1]} );

		/* 엔터키 검색 */
		$("#searchYear").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){ doAction1("Search");  $(this).focus(); }
		});

		$("#searchSabunNameAlias").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search");  $(this).focus(); }
		});



		$(window).smartresize(sheetResize); sheetInit();

		//2021.07.12
		workPartSet();

		doAction1('Search');

	});


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/simplePymtPrtMgr/simplePymtPrtMgrRst.jsp?cmd=selectSimplePymtPrtMgrList", $("#sheetForm").serialize() );
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			//전체 체크
			sheet1.SetHeaderCheck(0, 8, 1);
			for(i=1; i<=sheet1.LastRow(); i++) {
            	sheet1.SetCellValue(i, "checked", 1) ;
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}


	//출력
	function print() {

		var hpCnt;

		/* 핸드폰 관련 테이블 체크 (근로소득만)*/
		//if($("#includeGb").val() == "77" || $("#includeGb").val() == "50" ){
		if($("#includeGb").val() == "77"){
			var data = ajaxCall("<%=jspPath%>/simplePymtPrtMgr/simplePymtPrtMgrRst.jsp?cmd=getHpChk", "",false);
			hpCnt = data.Data.hptb_cnt;
		}

		if ($("#searchPurposeCd").val() == "") {
			alert("용도를 선택해 주십시오.");
			$("#searchPurposeCd").focus();
			return;
		}
		var sabuns = "";
		var sortSabuns = "";
		var sortNos = "";
		var stamps = "";
		var checked = "";
		var searchAllCheck = "";
		var sabunCnt = 0;

	    if(sheet1.RowCount() != 0) {
	        for(i=1; i<=sheet1.LastRow(); i++) {

	            checked = sheet1.GetCellValue(i, "checked");

	            if (checked == "1" || checked == "Y") {
	                sabuns += "'"+sheet1.GetCellValue( i, "sabun" ) + "',";
	                sortSabuns += sheet1.GetCellValue( i, "sabun" ) + ",";
	                sortNos += sheet1.GetCellValue( i, "sort_no" ) + ",";

                    if("1" == sheet1.GetCellValue( i, "stamp_chk" )) {
                    	stamps += sheet1.GetCellValue( i, "stamp_chk" ) + ",";
                    } else {
                    	stamps += ",";
                    }
	            }
	        }

	        if (sabuns.length > 1) {
				sabuns = sabuns.substr(0,sabuns.length-1);
				sortSabuns = sortSabuns.substr(0,sortSabuns.length-1);
				sortNos = sortNos.substr(0,sortNos.length-1);
				stamps = stamps.substr(0,stamps.length-1);
	        }

	        if (sabuns.length < 1) {
	            alert("선택된 사원이 없습니다.");
	            return;
	        }
			//call RD!
	        withHoldRcptStaPopup(sabuns, sortSabuns, sortNos, stamps, hpCnt) ;
	    } else {

	        alert("선택된 사원이 없습니다.");
	        return;

	    }

	}

	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function withHoldRcptStaPopup(sabuns, sortSabuns, sortNos, stamps, hpCnt){

		// args의 Y/N 구분자는 없으면 N과 같음
		var rdFileNm ;
		/* rd title */
		var popupTitle;

		/* 근로소득 */
		if($("#includeGb").val() == '77'){

		    if($("#searchYear").val() < "2021" || ($("#searchYear").val() == "2021" && $("#searchHalfType").val() == "1")){
		    	//2021년 상반기까지
                rdFileNm        = "simplePymtReport01.mrd";
                ppupTitle = "근로소득" ;//rd Popup제목
		    }else{
		    	//2021년 하반기부터
                rdFileNm        = "simplePymtReport01_2021.mrd";
                ppupTitle = "근로소득" ;//rd Popup제목
		    }
		}
		/* 사업소득 */
		else if($("#includeGb").val() == '50'){

			if($("#searchYear").val() < "2021" || ($("#searchYear").val() == "2021" && $("#searchHalfType").val() == "1")){
                //2021년 상반기까지           
                rdFileNm        = "simplePymtReport02.mrd";
                popupTitle = "사업소득" ;                     
            }
            else if($("#searchYear").val() < "2023" || ($("#searchYear").val() == "2023" && $("#searchHalfType").val() < "03")) {
            	//2021년 하반기부터
                rdFileNm        = "simplePymtReport02_2021.mrd";
                ppupTitle = "사업소득" ;//rd Popup제목
            }
            else{
            	
            	if($("#searchYear").val() > "2023" && $("#searchHalfType").val() >= "01" ) {
            		//2024년 2월부터
                    rdFileNm        = "simplePymtReport02_2024.mrd";
                    ppupTitle = "사업소득" ;//rd Popup제목
            	} else {
            		//2023년 3월부터
                    rdFileNm        = "simplePymtReport02_2023.mrd";
                    ppupTitle = "사업소득" ;//rd Popup제목	
            	}
            }
		}
		/* 비거주자 사업기타 */
		else if($("#includeGb").val() == '49'){
			rdFileNm		= "simplePymtReport04.mrd";
			popupTitle = "비거주자 사업기타" ;
		}
		/* 연말정산_사업소득 */
		else if($("#includeGb").val() == '61'){
			rdFileNm		= "simplePymtReport03.mrd";
			popupTitle = "연말정산_사업소득" ;
		}

		var imgPath = "<%=rdStempImgUrl%>";
		var imgFile = "<%=rdStempImgFile%>";

		/* 현재년도 */
		var year = "<%=yjungsan.util.DateUtil.getDateTime("yyyy")%>";
		var mon =  "<%=yjungsan.util.DateUtil.getDateTime("MM")%>";
		var day =  "<%=yjungsan.util.DateUtil.getDateTime("dd")%>";

		var w 		= 800;
		var h 		= 600;
		var url 	= "<%=jspPath%>/common/rdPopup.jsp";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음
		var baseDate = "<%=curSysYyyyMMdd%>";

		args["rdTitle"] = popupTitle ;//rd Popup제목
		args["rdMrd"] = "cpn/taxRate/" + rdFileNm;
		//rd파라매터               //회사 구분
		args["rdParam"]  = "['<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>']"
						 //대상년도
				         +"['"+$("#searchYear").val()+"']"
				         //소득구분
				         +"['"+$("#includeGb").val()+"']"
				         //선택한 사번
				         +"["+sabuns+"]"
				         //반기구분
				         +"['"+$("#searchHalfType").val()+"']"
				         //사업장
				         +"['"+$("#searchBusinessPlace").val()+"']"
				         //용도구분
				         +"['"+$("#searchPurposeCd").val()+"']"
				         //서명이미지 경로
						 +"["+imgPath+"]"
						 //년
						 +"['"+year+"']"
						 //월
						 +"['"+mon+"']"
						 //일
						 +"['"+day+"']"
				         //핸드폰
						 if(hpCnt != null){
							 if(hpCnt > 0){
					        	 args["rdParam"] +="[(SELECT CONT_ADDRESS FROM THRM124 WHERE CONT_TYPE = 'HP' AND ENTER_CD = A.ENTER_CD  AND SABUN = A.SABUN)]";
					         }else{
					        	 args["rdParam"] +="[(SELECT HAND_PHONE FROM THRM124 WHERE ENTER_CD = A.ENTER_CD AND SABUN = A.SABUN)]";
					         }
						 }
		args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;//툴바여부
		args["rdZoomRatio"] = "100" ;//확대축소비율

		args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "Y" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF

		if(!isPopup()) {return;}
		openPopup(url,args,w,h);//알디출력을 위한 팝업창

		//return (rv != null) ? true : false;


	}
	function workPartSet(){
        if($("#searchYear").val() == "2021"){
            /*
                77 근로소득
                50  사업소득
                49  비거주자사업기타
            */
              if($("#includeGb").val() == "50"){
                  //사업소득
                  $('#searchHalfType').empty();
                  $('#searchHalfType').append("<option value='1'>상반기</option>");
                  $('#searchHalfType').append("<option value='07'>7월</option>");
                  $('#searchHalfType').append("<option value='08'>8월</option>");
                  $('#searchHalfType').append("<option value='09'>9월</option>");
                  $('#searchHalfType').append("<option value='10'>10월</option>");
                  $('#searchHalfType').append("<option value='11'>11월</option>");
                  $('#searchHalfType').append("<option value='12'>12월</option>");
              }else{
                  //근로소득,비거주자사업기타
                  $('#searchHalfType').empty();
                  $('#searchHalfType').append("<option value='1'>상반기</option>");
                  $('#searchHalfType').append("<option value='2'>하반기</option>");
              }
         }else if($("#searchYear").val() > "2021"){

             if($("#includeGb").val() == "50"){
                 //사업소득
                 $('#searchHalfType').empty();
                 $('#searchHalfType').append("<option value='01'>1월</option>");
                 $('#searchHalfType').append("<option value='02'>2월</option>");
                 $('#searchHalfType').append("<option value='03'>3월</option>");
                 $('#searchHalfType').append("<option value='04'>4월</option>");
                 $('#searchHalfType').append("<option value='05'>5월</option>");
                 $('#searchHalfType').append("<option value='06'>6월</option>");
                 $('#searchHalfType').append("<option value='07'>7월</option>");
                 $('#searchHalfType').append("<option value='08'>8월</option>");
                 $('#searchHalfType').append("<option value='09'>9월</option>");
                 $('#searchHalfType').append("<option value='10'>10월</option>");
                 $('#searchHalfType').append("<option value='11'>11월</option>");
                 $('#searchHalfType').append("<option value='12'>12월</option>");
             }else{
                 //근로소득,비거주자사업기타
                 $('#searchHalfType').empty();
                 $('#searchHalfType').append("<option value='1'>상반기</option>");
                 $('#searchHalfType').append("<option value='2'>하반기</option>");
             }
         }else{
             $('#searchHalfType').empty();
             $('#searchHalfType').append("<option value='1'>상반기</option>");
             $('#searchHalfType').append("<option value='2'>하반기</option>");
         }
 }

</script>
</head>
<body class="hidden">
<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
<div class="wrapper">
	<%-- <%@ include file="/WEB-INF/jsp/common/include/employeeHeaderYtax.jsp"%> --%>

    <div class="sheet_search outer">
	    <form id="sheetForm" name="sheetForm" >
	    <input type="hidden" id="searchSabun" 		name="searchSabun" 		value ="" />
	    <input type="hidden" id="workPartGubun"     name="workPartGubun"    value ="" />
	        <div>
		        <table>
			        <tr>
			            <td><span>대상년도</span>
						<input id="searchYear" name ="searchYear" type="text" class="text" maxlength="4" style= "width:71px; padding-left: 45px;" onchange="workPartSet();"/> </td>
						<td><span>신고기간</span>
							<select id="searchHalfType" name="searchHalfType" onChange="javascript:doAction1('Search')" style="width: 119px;">
				            </select>
						</td>
						<td><span>사번/성명</span>
							<input id="searchSabunNameAlias" name="searchSabunNameAlias" type="text" class="text"  style= "width:113px;"/>
						</td>
			        </tr>
			        <tr>
						<td><span>소득구분</span>
				            <select id="includeGb" name ="includeGb" class="box" onChange="javascript:workPartSet();doAction1('Search')" style="width: 118px;">
						</td>
						<td><span style="padding-left: 11px;">사업장</span>
							<select id="searchBusinessPlace" name ="searchBusinessPlace" onChange="javascript:doAction1('Search')" class="box" style= "width:119px;"></select>
						</td>
						<td>
							<span style="padding-left: 26px; margin-left: 1px;">용도</span>
							<select id="searchPurposeCd" name="searchPurposeCd" style="width: 115px;">
				                <option selected="selected" value="">출력시 선택</option>
				                <option value="1">지급자 보관용</option>
				                <option value="2">지급자 제출용</option>
				            </select>
						</td>
			            <td><a href="javascript:doAction1('Search');" class="button">조회</a></td>
			        </tr>
		        </table>
	        </div>
	    </form>
    </div>
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">간이지급명세 출력</li>
            <li class="btn">
              <a href="javascript:print()" class="pink authA">출력</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>



</div>
</body>
</html>