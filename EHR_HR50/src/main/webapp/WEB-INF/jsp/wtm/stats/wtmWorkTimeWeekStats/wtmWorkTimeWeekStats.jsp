<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>주단위근무시간현황</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<!-- <link rel="stylesheet" href="/common/css/contents.css" /> -->

<style type="text/css">

div.progressbar {height:6px;background:#fff;border:1px solid #b8c6cc;}
div.progressbar div {/* background:#337ab7; */width:0;height:6px;}

div.progressbar2 {height:6px;background:#fff;border:1px solid #b8c6cc;}
div.progressbar2 div {/* background:#f379b2; */width:0;height:6px;}


.tableRow:hover {
    background: silver;
  }
  
  
  .border1{
 　border-style:solid;
 　border-width:10px;
 　border-color:#F00;} /*상하좌우*/
 .border2{
 　border-style:solid;
 　border-width:10px;
 　border-color:#F00 0C0;} /*상하・좌우*/
 .border3{
 　border-style:solid;
 　border-width:10px;
 　border-color:#F00 #0C0 red;} /*상・좌우・하*/
 .border4{
 　border-style:solid;
 　border-width:10px;
 　border-color:#F00 #0C0 red #3300ff;} /*상・우・하・좌*/

</style>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		var myWorkGrpCd = "";
<c:if test="${ssnSearchType == 'O'}">		
		//권한범위일 경우 사용자 권한 그룹 조회
		var user = ajaxCall("${ctx}/WtmWorkTimeWeekStats.do?cmd=getWorkTimeWeekStatsMyWorkGrp","" ,false);
		if ( user != null && user.DATA != null ){
			myWorkGrpCd = user.DATA.workGrpCd;
		}
</c:if>		 


		$("#searchYear").val("${curSysYear}");

		$("#searchYear").bind("keyup",function(event){
			if( $("#searchYear").val().length == 4 ) { 
				 
			}
		});

		$("#searchYear").change(function (){
			getCommonCodeList();
		});

		$("#searchWorkTerm").bind("change",function(event){

			$("#searchSYmd").val( $("#searchWorkTerm option:selected").attr("sYmd") );
			$("#searchEYmd").val( $("#searchWorkTerm option:selected").attr("eYmd") );	

			//조직콤보 
			var param = "queryId=getWorkTimeWeekStatsOrg"+ "&"+$("#sheet1Form").serialize();
			var orgCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",param, false).codeList, "");
			$("#searchOrgCd").html(orgCdList[2]);
			
	    	doAction1("Search");
		});
		
		//근무그룹
		$("#searchWorkGrpCd").bind("change", function(){

			$("#searchIntervalCd").val($("#searchWorkGrpCd option:selected").attr("intervalCd"));
			$("#searchSdate").val($("#searchWorkGrpCd option:selected").attr("sdate"));
			$("#searchTermGubun").val($("#searchWorkGrpCd option:selected").attr("termGubun"));

			
			var param = "&searchYear="+$("#searchYear").val()
			          + "&searchWorkGrpCd="+$("#searchWorkGrpCd").val();
			//근무조
			var workOrgCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWorkTimeWeekStatsWorkOrg"+param, false).codeList, "전체");
			$("#searchWorkOrgCd").html(workOrgCdList[2]);
			
			//조회단위
			var gubunList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWorkTimeWeekStatsGubun"+param, false).codeList, "");
			$("#searchGubun").html(gubunList[2]); 
			
			$("#searchGubun").change();
			
		});
		
		
		
		//조회단위 
		$("#searchGubun").bind("change", function(){
			//근무기간 콤보
			initWorkTermCombo();
			
		});

		//근무그룹
		var workGrpCdList = convCodeCols( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWorkTimeWeekStatsWorkGrp", false).codeList
				           , "intervalCd,sdate,termGubun"
				           , "");
		$("#searchWorkGrpCd").html(workGrpCdList[2]);
		if( myWorkGrpCd != "" ){
			$("#searchWorkGrpCd").val(myWorkGrpCd);
		}
		$("#searchWorkGrpCd").change();

		getCommonCodeList();
		
		$("#searchOrgCd, #searchWorkOrgCd, #searchJikgubCd, #searchManageCd").bind("change", function(){
	    	doAction1("Search");
		});

		$("#searchSabunName").keyup(function() {
			if (event.keyCode == 13) {
				doAction1("Search");
			}
		}) ;
		$("#searchOrgType").change(function() {
			doAction1("Search");
		}) ;
		
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck: 1 };
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"사번",		Type:"Text",      Hidden:1,  Width:50,  	Align:"Left",	ColMerge:0,   SaveName:"sabun",       	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"근무일",	Type:"Text",       Hidden:0,  Width:30,  	Align:"Center",  ColMerge:0,   SaveName:"ymd",       	KeyField:0,   CalcLogic:"",   Format:"Ymd",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"출근시간",		Type:"Text",      Hidden:0,  Width:70,  	Align:"Center",   ColMerge:0,   SaveName:"st",       	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"퇴근시간",		Type:"Text",      Hidden:0,  Width:50,  	Align:"Center",   ColMerge:0,   SaveName:"et",       	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"근무시간(소정)",		Type:"Text",      Hidden:0,  Width:50,  	Align:"Center", ColMerge:0,   SaveName:"wtHh",       	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"근무시간(연장)",		Type:"Text",      Hidden:0,  Width:50,  	Align:"Center", ColMerge:0,   SaveName:"otHh",       	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		];

		IBS_InitSheet(sheet2, initdata);
		sheet2.SetEditable("${editable}");

		sheet2.SetColProperty( "markerType" , {ComboText: "유형1|유형2|유형3", ComboCode: "1|2|3"} );

		sheet2.SetVisible(true);
		sheet2.SetCountPosition(4); 
		

	});

	function getCommonCodeList() {
		//공통코드 한번에 조회
		let searchYear = $("#searchYear").val();

		let baseSYmd = "";
		let baseEYmd = "";
		if (searchYear !== "") {
			baseSYmd = searchYear + "-01-01";
			baseEYmd = searchYear + "-12-31";
		}


		let grpCds = "H20010,H10030";  // 직급, 사원구분, 근무그룹
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;

		let codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists", params, false).codeList, "전체");

		$("#searchJikgubCd").html(codeLists["H20010"][2]);
		$("#searchManageCd").html(codeLists["H10030"][2]);
	}

	//근무기간콤보
	function initWorkTermCombo(){
		if( $("#searchYear").val() == "" || $("#searchYear").val().length != 4 || $("#searchWorkGrpCd").val() == "" ){
			$("#searchWorkTerm").html("");
			sheet1.RemoveAll();
			return;
		}

		var param = "";
		if( $("#searchTermGubun").val() == "W" ){ //주단위
			param = "queryId=getWorkTimeWeekStatsWeekList"
		              + "&searchSdate="+$("#searchSdate").val() //단위기간 시작일자
			          + "&searchSYmd="+$("#searchYear").val()+"0101"
			          + "&searchEYmd="+$("#searchYear").val()+"1231"
			          + "&searchIntervalCd="+$("#searchIntervalCd").val() //단위기간
			          + "&searchCnt=" + (parseInt($("#searchIntervalCd").val()) / 7 * parseInt($("#searchGubun").val()));
		}else{
			param = "queryId=getWorkTimeWeekStatsMonthList"
	              + "&searchSdate="+$("#searchSdate").val() //단위기간 시작일자
		          + "&searchSYmd="+$("#searchYear").val()+"0101"
		          + "&searchEYmd="+$("#searchYear").val()+"1231"
		          + "&searchIntervalCd="+$("#searchIntervalCd").val() //단위기간
		          + "&searchCnt=" + $("#searchGubun").val();
		}
		
		var workTermCdList = convCodeCols( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",param, false).codeList
				           , "sYmd,eYmd,selYn"
				           , "");
		$("#searchWorkTerm").html(workTermCdList[2]);
		
		$("#searchWorkTerm").find("option").each(function() {
			 if( $(this).attr("selYn") == "Y"){
				 $(this).attr("selected", "selected");
			 }
		});
		$("#searchWorkTerm").change();
	}
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Title" :
			var param = "", cmd="", interval = 1;

			if( $("#searchTermGubun").val() == "W" ){ //주단위
				cmd = "getWorkTimeWeekStatsWeekList";
				param = "searchSdate="+$("#searchSdate").val() //단위기간 시작일자 
				      + "&searchSYmd="+$("#searchSYmd").val()
				      + "&searchEYmd="+$("#searchEYmd").val()
					  + "&searchIntervalCd="+$("#searchIntervalCd").val() //단위기간
				      + "&searchCnt=1";
				
				interval = parseInt($("#searchIntervalCd").val() ) / 7;
	                       
		    }else{ //월단위
		    	cmd = "getWorkTimeWeekStatsMonthWeekList";
				param = "searchSYmd="+$("#searchSYmd").val()
		              + "&searchEYmd="+$("#searchEYmd").val();
				
				interval = parseInt($("#searchIntervalCd").val() ) / 30;
			}
			 
			var titleList = ajaxCall("${ctx}/WtmWorkTimeWeekStats.do?cmd="+cmd, param, false);
			if (titleList != null && titleList.DATA != null) {
				sheet1.Reset();
				var initdata = {};
				initdata.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly, FrozenCol:3};
				initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:1, HeaderCheck:0};
				initdata.Cols = [];
				var v = 0 ;

				initdata.Cols[v++] = {Header:"No|No|No",			Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", SaveName:"sNo" };
				initdata.Cols[v++] = {Header:"소속|소속|소속",			Type:"Text",		Hidden:0,  Width:140,   Align:"Left",  		SaveName:"orgNm",			Edit:0},
				initdata.Cols[v++] = {Header:"사번|사번|사번",			Type:"Text",		Hidden:0,  Width:60,   	Align:"Center",  	SaveName:"sabun",		   	Edit:0};
				initdata.Cols[v++] = {Header:"성명|성명|성명",			Type:"Popup",		Hidden:0,  Width:70,   	Align:"Center",  	SaveName:"name",		   	Edit:0};
				initdata.Cols[v++] = {Header:"직위|직위|직위",			Type:"Text",		Hidden:1,  Width:60,   	Align:"Center",  	SaveName:"jikweeNm",		Edit:0};
				initdata.Cols[v++] = {Header:"직급|직급|직급",			Type:"Text",		Hidden:0,  Width:60,   	Align:"Center",  	SaveName:"jikgubNm",		Edit:0};
				initdata.Cols[v++] = {Header:"직책|직책|직책",			Type:"Text",		Hidden:0,  Width:60,   	Align:"Center",  	SaveName:"jikchakNm",		Edit:0};
				initdata.Cols[v++] = {Header:"사원구분|사원구분|사원구분",	Type:"Text",		Hidden:0,  Width:60,   	Align:"Center",  	SaveName:"manageNm",		Edit:0};
				initdata.Cols[v++] = {Header:"근무조|근무조|근무조",		Type:"Text",		Hidden:0,  Width:80,    Align:"Center",  	SaveName:"workOrgNm",		Edit:0};
				initdata.Cols[v++] = {Header:"사진|사진|사진",		Type:"Text",		Hidden:1,  Width:80,    Align:"Center",  	SaveName:"photo",		Edit:0};
				initdata.Cols[v++] = {Header:"근무시간|근무시간|근무시간",		Type:"Text",		Hidden:1,  Width:80,    Align:"Center",  	SaveName:"wtHour",		Edit:0};
				initdata.Cols[v++] = {Header:"OT시간|OT시간|OT시간",		Type:"Text",		Hidden:1,  Width:80,    Align:"Center",  	SaveName:"otHour",		Edit:0};
				initdata.Cols[v++] = {Header:"OT시간|OT시간|OT시간",		Type:"Text",		Hidden:1,  Width:80,    Align:"Center",  	SaveName:"weekStart",		Edit:0};
				initdata.Cols[v++] = {Header:"OT시간|OT시간|OT시간",		Type:"Text",		Hidden:1,  Width:80,    Align:"Center",  	SaveName:"weekEnd",		Edit:0};
				initdata.Cols[v++] = {Header:"합계|합계|합계",			Type:"AutoSum",		Hidden:1,  Width:80,    Align:"Center",  	SaveName:"total",			Edit:0};
				initdata.Cols[v++] = {Header:"시작일자|시작일자|시작일자",		Type:"Text",		Hidden:1,  Width:80,    Align:"Center",  	SaveName:"weekStart",		Edit:0};
				initdata.Cols[v++] = {Header:"종료일자|종료일자|종료일자",		Type:"Text",		Hidden:1,  Width:80,    Align:"Center",  	SaveName:"weekEnd",		Edit:0};

				var cnt = 1, idx = 1;
				var tmpDate = "-1";
				for(i = 0 ; i<titleList.DATA.length; i++) {
					
					var title = titleList.DATA[i].codeNm + "|"+titleList.DATA[i].seq +"주차" ;
					initdata.Cols[v++] = {Header:title+"|기본", 	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"wt"+cnt, Edit:0};
					initdata.Cols[v++] = {Header:title+"|연장", 	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"ot"+cnt, Edit:0};
					initdata.Cols[v++] = {Header:title+"|계",   	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"tt"+cnt, Edit:0};
					
					if( tmpDate == "-1"){ tmpDate = titleList.DATA[i].code; }//단위기간 시작일자
					
					//단위기간 근무시간
					if( $("#searchTermGubun").val() == "W" ){ //주단위
						if( cnt % interval == 0 && $("#searchIntervalCd").val() != "7" ){
							var title2 = tmpDate+" ~ "+formatDate(titleList.DATA[i].eYmd, "-")+"|단위기간 합계";
							initdata.Cols[v++] = {Header:title2+"|기본", 	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"tmWt"+idx, Edit:0, BackColor:"#f6f6f6"};
							initdata.Cols[v++] = {Header:title2+"|연장",	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"tmOt"+idx, Edit:0, BackColor:"#f6f6f6"};
							initdata.Cols[v++] = {Header:title2+"|계",	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"tmTt"+idx, Edit:0, BackColor:"#f6f6f6"};
							
							title2 = tmpDate+" ~ "+formatDate(titleList.DATA[i].eYmd, "-")+"|단위기간 일 평균";
							initdata.Cols[v++] = {Header:title2+"|기본", 	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"avgDayWt"+idx, Edit:0, BackColor:"#f6f6f6"};
							initdata.Cols[v++] = {Header:title2+"|연장",	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"avgDayOt"+idx, Edit:0, BackColor:"#f6f6f6"};
							initdata.Cols[v++] = {Header:title2+"|계",	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"avgDayTt"+idx, Edit:0, BackColor:"#f6f6f6"};

							title2 = tmpDate+" ~ "+formatDate(titleList.DATA[i].eYmd, "-")+"|단위기간 주 평균";
							initdata.Cols[v++] = {Header:title2+"|기본", 	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"avgWeekWt"+idx, Edit:0, BackColor:"#f6f6f6"};
							initdata.Cols[v++] = {Header:title2+"|연장",	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"avgWeekOt"+idx, Edit:0, BackColor:"#f6f6f6"};
							initdata.Cols[v++] = {Header:title2+"|계",	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"avgWeekTt"+idx, Edit:0, BackColor:"#f6f6f6"};
							
							idx++;
							tmpDate ="-1";
						}
					}
					cnt++;
				}
				//단위기간 근무시간   $("#searchSYmd").val()
				if( $("#searchTermGubun").val() == "M" ){ //월단위
					var title2 = formatDate( $("#searchSYmd").val(), "-")+" ~ "+formatDate( $("#searchEYmd").val(), "-")+"|단위기간 합계";
					initdata.Cols[v++] = {Header:title2+"|기본", 	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"tmWt"+idx, Edit:0, BackColor:"#f6f6f6"};
					initdata.Cols[v++] = {Header:title2+"|연장",	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"tmOt"+idx, Edit:0, BackColor:"#f6f6f6"};
					initdata.Cols[v++] = {Header:title2+"|계",	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"tmTt"+idx, Edit:0, BackColor:"#f6f6f6"};

					title2 = formatDate( $("#searchSYmd").val(), "-")+" ~ "+formatDate( $("#searchEYmd").val(), "-")+"|단위기간 일 평균";
					initdata.Cols[v++] = {Header:title2+"|기본", 	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"avgDayWt"+idx, Edit:0, BackColor:"#f6f6f6"};
					initdata.Cols[v++] = {Header:title2+"|연장",	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"avgDayOt"+idx, Edit:0, BackColor:"#f6f6f6"};
					initdata.Cols[v++] = {Header:title2+"|계",	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"avgDayTt"+idx, Edit:0, BackColor:"#f6f6f6"};

					title2 = formatDate( $("#searchSYmd").val(), "-")+" ~ "+formatDate( $("#searchEYmd").val(), "-")+"|단위기간 주 평균";
					initdata.Cols[v++] = {Header:title2+"|기본", 	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"avgWeekWt"+idx, Edit:0, BackColor:"#f6f6f6"};
					initdata.Cols[v++] = {Header:title2+"|연장",	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"avgWeekOt"+idx, Edit:0, BackColor:"#f6f6f6"};
					initdata.Cols[v++] = {Header:title2+"|계",	Type:"Text", Hidden:0, Width:60, Align:"Center", SaveName:"avgWeekTt"+idx, Edit:0, BackColor:"#f6f6f6"};
				}
				
				$("#headerCnt").val(cnt--); //컬럼 갯수

				IBS_InitSheet(sheet1, initdata); sheet1.SetEditable(0);sheet1.SetCountPosition(4);
		  		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		  		sheet1.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음
		  		//sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor());

				//근태취소신청 헤더 색상
				for( var i=0 ; i< idx ; i++){
					sheet1.SetRangeBackColor(0,sheet1.SaveNameCol("termWtHour"+i),2,sheet1.SaveNameCol("termTTHour"+i), "#fdf0f5");  //분홍이
				}
				

				$(window).smartresize(sheetResize);
		  		clearSheetSize(sheet1);sheetInit();
			}
			
			break;
		case "Search":
			//sheet1 헤더 생성
			doAction1("Title");
			sheet1.DoSearch( "${ctx}/WtmWorkTimeWeekStats.do?cmd=getWorkTimeWeekStatsList", $("#sheet1Form").serialize());
        	break;	
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); 
			break;
		}
	}
	
	
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				//sheet1 헤더 생성
				
				sheet2.DoSearch( "${ctx}/WtmWorkTimeWeekStats.do?cmd=getWorkTimeWeekPerList", $("#sheet1Form").serialize());
	        	break;	
	        case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param); 
				break;
			}
	}
	
	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			var vsDrawTable = "";
			
			var vnWtPer = 0;
			var vnOtPer = 0;
			
			$(".newTableM").children().remove();
			
			if( sheet1.RowCount() == 0 ){
				
				
				vsDrawTable ="<tr class='tableRow' ><td colspan='3'> 조회된 내역이 없습니다.</td></tr>";
				
			} else{
				
				vsDrawTable +="<colgroup>"+
							  "<col width='10%' />"+
					          "<col width='20%' />"+
					          "<col width='70%' />"+
					    	  "</colgroup>";
			    var vsCssColor = "";
			    var vsCssColor2 = "";
				
				for(var i=0; i < sheet1.RowCount()-1; i++){
					
					
					
					vnWtPer = Math.round((sheet1.GetCellValue( i+3 , "wtHour" ) / 40) * 100);
					vnOtPer = Math.round((sheet1.GetCellValue( i+3 , "otHour" ) / 12) * 100);
					
					
					if(vnWtPer < 100){
						
						vsCssColor = "#5183af";
						
					}else{
						vsCssColor = "#49637a";
						
					}
					
					if(vnOtPer <= 50){
						
						vsCssColor2 = "#ffc107";
						
					}else{
						vsCssColor2 = "#ff5722";
						
					}
							
					
					vsDrawTable += "<tr class='tableRow' rowIndex='"+(i+3)+"'>"+
								  "<td> <img src="+sheet1.GetCellValue( i+3 , "photo" )+" style='height: 90px;'>"+
							      "</td>"+
							      "<td> <strong>"+sheet1.GetCellValue( i+3 , "name" )+"</strong><br/>"+
							      "- 사번 : "+sheet1.GetCellValue( i+3 , "sabun" )+"<br/>"+
							      "- 소속 : "+sheet1.GetCellValue(i+3 , "orgNm" )+"<br/>"+
							      "- 직급 : "+sheet1.GetCellValue( i+3 , "jikgubNm" )+"</td>"+
							      "<td>"+
							      "소정근로시간 : "+sheet1.GetCellValue( i+3 , "wtHour" )+ " / 40"+
							      "<div class='progressbar'><div class='progressWt' id='progressBar' style='width:"+vnWtPer+"%; background:"+vsCssColor+";'></div></div><br/>"+
							      "연간근로시간 : "+sheet1.GetCellValue( i+3 , "otHour" )+ " / 12"+
							      "<div class='progressbar2'><div class='progressOt' id='progressBar2' style='width:"+vnOtPer+"%; background:"+vsCssColor2+";'></div></div>"+
							      "</td></tr>"
							    ; 
				}
				
				$(".newTableM").append(vsDrawTable);
				
				$(".tableRow").click(function(){
					
					$(".tableRow").css("border", "none");
					
					$(this).css("border","solid 2px");
					
					$("#searchSabun").val(sheet1.GetCellValue( $(this).attr("rowIndex") , "sabun" ));
					$("#searchWeekSYmd").val(sheet1.GetCellValue( $(this).attr("rowIndex") , "weekStart" ));
					$("#searchWeekEYmd").val(sheet1.GetCellValue( $(this).attr("rowIndex") , "weekEnd" ));

					var searchWeekSYmd = $("#searchWeekSYmd").val().replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
					var searchWeekEYmd = $("#searchWeekEYmd").val().replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
					$("#sheet2-title").text(' [' + searchWeekSYmd + " ~ " + searchWeekEYmd + ']')
					doAction2("Search");
				});
				
				$(".tableRow[rowIndex=3]").css("border","solid 2px");
				
				$("#searchSabun").val(sheet1.GetCellValue( 3 , "sabun" ));
				$("#searchWeekSYmd").val(sheet1.GetCellValue( 3 , "weekStart" ));
				$("#searchWeekEYmd").val(sheet1.GetCellValue( 3 , "weekEnd" ));
				var searchWeekSYmd = $("#searchWeekSYmd").val().replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
				var searchWeekEYmd = $("#searchWeekEYmd").val().replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
				$("#sheet2-title").text(' [' + searchWeekSYmd + " ~ " + searchWeekEYmd + ']')
				doAction2("Search");
				
				
			}
			
			
			
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	} 

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			
		    if( sheet1.ColSaveName(Col) == "detail" ) {
		    	showApplPopup( Row );
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	
</script>

</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="searchSYmd" name="searchSYmd" value=""/>
	<input type="hidden" id="searchEYmd" name="searchEYmd" value=""/>
	<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
	
	<input type="hidden" id="searchIntervalCd" name="searchIntervalCd" value=""/>
	<input type="hidden" id="searchSdate"      name="searchSdate"      value=""/>
	<input type="hidden" id="searchTermGubun"  name="searchTermGubun"  value=""/>
	<input type="hidden" id="headerCnt"  	   name="headerCnt"  	   value=""/>

	<input type="hidden" id="searchWeekSYmd" name="searchWeekSYmd" value=""/>
	<input type="hidden" id="searchWeekEYmd" name="searchWeekEYmd" value=""/>
	<!-- 조회조건 -->
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>기준년도</th>
			<td>
				<input type="text" id="searchYear" name="searchYear" class="date2 required w50 line" numberOnly maxLength="4"/>
			</td>
			<th>근무그룹</th>
			<td>
				<select id="searchWorkGrpCd" name="searchWorkGrpCd"></select>
			</td>
			<th>조회단위</th>
			<td>
				<select id="searchGubun" name="searchGubun"></select>
			</td>
			<th>근무기간</th>
			<td>
				<select id="searchWorkTerm" name="searchWorkTerm"></select>
			</td>
		</tr>
		<tr>
			<th>근무조</th>
			<td>
				<select id="searchWorkOrgCd" name="searchWorkOrgCd"></select>
			</td>
			<th>소속</th>
			<td>
				<select id="searchOrgCd" name="searchOrgCd"></select>
				&nbsp;&nbsp;
				<input id="searchOrgType" name="searchOrgType" type="checkbox" class="checkbox" value="Y" checked"/>
				<label for="searchOrgType">&nbsp;<tit:txt mid='112471' mdef='하위포함'/>&nbsp;</label>
			</td>
			<th>직급</th>
			<td>
				<select id="searchJikgubCd" name="searchJikgubCd" > </select>
			</td>
			<th>사원구분</th>
			<td>
				<select id="searchManageCd" name="searchManageCd" > </select>
			</td>
			<th>사번/성명</th>
			<td>
				<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;" />
			</td>
			<td>
				<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
	</div>
	</form>
	
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li class="txt">주단위근무현황</li>
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel')" class="btn outline-gray" >다운로드</a>
				</li>
			</ul>
		</div>
	</div>
	
	
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
        <tr>
            <td>
                <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			    <colgroup>
			        <col width="60%" />
			        <col width="40%" />
			    </colgroup>
			    <tr>
			        <td class="sheet_right">
			            <div class="inner">
			                <div class="sheet_title">
			                </div>
			            </div>
			            <div style="height:700px; overflow: scroll;">
							<table class="table newTableM">
							    
							
							</table>
						
						</div>
			        </td>
			        <td class="sheet_right">
			            <div class="inner">
			                <div class="sheet_title">
			                <ul>
			                    <li class="txt">근무내역</li> <span id="sheet2-title" style="margin-left: 10px;"></span>
			                </ul>
			                </div>
			            </div>
			            <script type="text/javascript" >createIBSheet("sheet2", "100%", "100%"); </script>
			        </td>
			    </tr>
			    </table>
            </td>
        </tr>
    </table>
    <div class="hide"><script type="text/javascript" >createIBSheet("sheet1", "100%", "100%"); </script></div>
    

</body>
</html>
