<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/plugin/IBLeaders/Chart/js/ibchart.js" type="text/javascript"></script>
<script src="${ctx}/common/plugin/IBLeaders/Chart/js/ibchartinfo.js" type="text/javascript"></script>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	var tdCnt = 3;

	var detailDesc = null;
	var selectSheet = null;
	var srchSeq 	= "${result.srchSeq}";
	var skk = "";
	var stdCol = "";
	var stdPos = "";
	var sumCols = "";
	var avgCols = "";
	//차트 변수
	var chartResult1 = null;
	var myChart1Data = null;

	$(function() {
		var tdCntData = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchStdCd=HRI_SEARCH_TD_CNT", "queryId=getSystemStdData",false).codeList, "");
		if(tdCntData[0] !== "") {
			tdCnt = tdCntData[0];
		}

		// 전달 받은 값
		if(srchSeq == "FALSE"){
			var tmpOpener = parent.opener.mySheet;
			srchSeq = tmpOpener.GetCellValue(tmpOpener.SelectRow, "searchSeq") ;
            $("#srchDesc").html( tmpOpener.GetCellValue(tmpOpener.SelectRow, "srchDesc") );
		}else{
			$("#srchSeq").val(srchSeq);
			detailDesc = ajaxCall("${ctx}/PwrSrchAdminUser.do?cmd=getPwrSrchAdminUserDetailDescMap",$("#sheetForm").serialize(),false );
			if(detailDesc.DATA == null || detailDesc.DATA == "undefine") return alert("잘못된 Seq를 가지고 있습니다.");
			$("#srchDesc").html(detailDesc.DATA.conditionDescConv );
			
			// 조건검색결과 -> searchDesc 로 변경
			var titleHtml = "";
			if( detailDesc.DATA.searchDesc && detailDesc.DATA.searchDesc != null && detailDesc.DATA.searchDesc != "" ) {
				titleHtml = detailDesc.DATA.searchDesc;
			} else {
				titleHtml = "조건검색결과";
			}
			$("#btnMore").html('<btn:a id="toggleBtn" href="javascript:toggleSheet();" css="btn outline_gray" mid="111875" mdef="▼ 설명보기" />');
			$("#liTitle").html(titleHtml);
			
			// 인사기본일경우 추가헤더부분 삭제
			if(detailDesc.DATA.viewCd != null && detailDesc.DATA.viewCd != "") {
				$("#divEmpHeader").remove();
			} else {
				// 개인별 여부가 'Y' 일시 헤더 화면 출력, 이외에는 outer 클래스 제거
				if( detailDesc.DATA.individualYn && detailDesc.DATA.individualYn == "Y" ) {
					$("#divEmpHeader").removeClass("hide");
					setEmpPage();
				} else {
					$("#area_employee_header").removeClass("outer");
					sheetResize();
				}
			}
		}

		var inqTypeCd 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R20020"), "전체",-1);

		var initdata = {};
		initdata.Cfg = {SearchMode:smServerPaging,Page:100,MergeSheet:msAll};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata.Cols = [];

		var typeArr = {};
		typeArr["Ymd"] 		= {Type:"Date",	Align:"Center",	Format:"Ymd"	};
		typeArr["Ym"] 		= {Type:"Date",	Align:"Center",	Format:"Ym"		};
		typeArr["Number"] 	= {Type:"Int",	Align:"Right",	Format:"Integer"};
		typeArr["Float"] 	= {Type:"Float",Align:"Right",	Format:"Float"	};
		typeArr["Integer"] 	= {Type:"Int",	Align:"Right",	Format:"Integer"};
		typeArr["IdNo"] 	= {Type:"Text",	Align:"Center",	Format:"IdNo"	};
		typeArr["dfNone"] 	= {Type:"Text",	Align:"Center",	Format:"\"\""	};
		typeArr[""] 		= {Type:"Text",	Align:"Center",	Format:"\"\""	};

		var rtn = ajaxCall("${ctx}/PwrSrchResultPopup.do?cmd=getPwrSrchResultPopupIBSheetColsList",$("#sheetForm").serialize(),false ).data;
		var tv="";
		var str="";
		if (rtn.length > 0) {
			// 퇴직추계액계산결과 검색결과 팝업
			if ($.trim(rtn[0].searchSeq) == "750") {
				typeArr["Number"] = {Type:"AutoSum",	Align:"Right",	Format:"Integer"};
			}
		}

		var hdn = "";

		for(var i=0; i<rtn.length; i++){
			
			tv = $.trim(rtn[i].inqType);
			if( rtn[i].columnNm == "주민등록번호" && tv == "dfNone" ) {
				tv = "IdNo";
			} 
			else if( rtn[i].columnNm == "그룹입사일" && tv == "dfNone" ) {
				tv = "Ymd";
			}
			else if( rtn[i].columnNm == "입사일" && tv == "dfNone" ) {
				tv = "Ymd";
			}
			else if( rtn[i].columnNm == "적용시작일" && tv == "dfNone" ) {
				tv = "Ymd";
			}
			else if( rtn[i].columnNm == "적용종료일" && tv == "dfNone" ) {
				tv = "Ymd";
			}

			if(rtn[i].columnNm == "호칭"){
				hdn = Number("${aliasHdn}");
			}else if(rtn[i].columnNm == "직급"){
				hdn = Number("${jgHdn}");
			}else if(rtn[i].columnNm == "직위"){
				hdn = Number("${jwHdn}");
			}else {
				hdn = 0;
			}

			str+=rtn[i].columnNm+"_"+tv+"\n";
			initdata.Cols[i] = { Header:rtn[i].columnNm, Type:typeArr[tv].Type, Hidden:hdn, Width:rtn[i].widthRate, Align:rtn[i].align, ColMerge:under2camel(rtn[i].mergeYn), SaveName:under2camel(rtn[i].columnNm), KeyField:0, Format:typeArr[tv].Format, UpdateEdit:0};
			skk = skk + "{ Header:"+rtn[i].columnNm+", Type:"+typeArr[tv].Type+", Hidden:0, Width:"+rtn[i].widthRate+", Align:"+rtn[i].align+", ColMerge:0, SaveName:under2camel("+rtn[i].columnNm+"), KeyField:0, Format:"+typeArr[tv].Format+" UpdateEdit:0}";

			if(rtn[i].subSumType == "STD") {
				stdCol = under2camel(rtn[i].columnNm);
				stdPos = i;
			}
			if(rtn[i].subSumType == "SUM") {
				if(sumCols == "") {
					sumCols = sumCols + i;
				} else {
					sumCols =  sumCols + "|" + i;
				}
			} else if(rtn[i].subSumType == "AVG"){
				if(avgCols == "") {
					avgCols = avgCols + i;
				} else {
					avgCols = avgCols + "|" +  i;
				}
			}
		}

		/*
		var info =[{StdCol:"priorOrgNm", SumCols:sumColsInfo, ShowCumulate:0, CaptionCol:3}];
		sheet1.ShowSubSum(info) ;
		*/

 		//alert(skk);
		IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff (0);
		$(window).smartresize(sheetResize); sheetInit();sheetResize();



		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:100};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" , Sort:0},
			{Header:"검색순번",			Type:"Text",		Hidden:1,  Width:0,		Align:"Left",	ColMerge:0,	SaveName:"searchSeq",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"항목명",		Type:"Text",		Hidden:0,  Width:80,	Align:"Left",	ColMerge:0,	SaveName:"columnNm", 	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"항목맵핑구분",		Type:"Text",		Hidden:1,  Width:0,    	Align:"Left",   ColMerge:0,	SaveName:"itemMapType",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"프로그램URL",			Type:"Text",		Hidden:1,  Width:0,    	Align:"Left",   ColMerge:0,	SaveName:"prgUrl",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"연산자",				Type:"Combo",		Hidden:1,  Width:0,    	Align:"Center", ColMerge:0,	SaveName:"operator",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"조건입력방법",			Type:"Combo",		Hidden:1,  Width:0,    	Align:"Center", ColMerge:0,	SaveName:"valueType",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"코드항목CD",	Type:"Text",		Hidden:1,  Width:0,    	Align:"Left",   ColMerge:0,	SaveName:"searchItemCd",KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"코드항목",		Type:"Text",		Hidden:1,  Width:0,    	Align:"Left",   ColMerge:0,	SaveName:"searchItemNm",KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"조건값",		Type:"Text",		Hidden:1,  Width:0,    	Align:"Left",   ColMerge:0,	SaveName:"inputValue",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
            {Header:"조건값",		Type:"Popup",		Hidden:0,  Width:200,  	Align:"Left",   ColMerge:0,	SaveName:"inputValueDesc", KeyField:0,CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
            {Header:"AND\nOR",			Type:"Combo",		Hidden:1,  Width:0,    	Align:"Center", ColMerge:0,	SaveName:"andOr",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"표시여부",		Type:"CheckBox",	Hidden:0, Width:55,	Align:"Center",	ColMerge:0,	SaveName:"viewYn",	KeyField:0,	Format:"", UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },
            {Header:"순서",					Type:"Text",		Hidden:1,  Width:0,    	Align:"Center", ColMerge:0,	SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"조건항목구분", 			Type:"Text",		Hidden:1,  Width:0,    	Align:"Left",   ColMerge:0,	SaveName:"condType",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		];IBS_InitSheet(sheet2, initdata); sheet2.SetVisible(true);
		sheet2.SetColProperty("andOr", 	{ComboText:"AND|OR", ComboCode:"AND|OR"} );

		// 		var authGrp 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&queryId=getAthGrpMenuMgrGrpCdList","",false).codeList, "");
		$(window).smartresize(sheetResize);
		sheetInit();
		doAction1("Search");
		doAction2("Search");
		
		// 차트
		ChartDesign1();
	});

	function getCommonCodeList() {
		var valueTypeCd	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R20030"), "전체",-1); // grpCd -> R20020 정상
		var operTypeCd 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S50020"), "전체",-1);

		sheet2.SetColProperty("operator", {ComboText:operTypeCd[0], ComboCode:operTypeCd[1]} );
		sheet2.SetColProperty("valueType",{ComboText:valueTypeCd[0], ComboCode:valueTypeCd[1]} );
	}

    function openResult(){
    	if(!isPopup()) {return;}

        if(sheet2.FindStatusRow("I|S|D|U") != ""){
            doAction3('Save');
        }
		var args =  new Array();
		var url	= "${ctx}/PwrSrchResultPopup.do?cmd=pwrSrchResultPopup";
		openPopup(url, args ,"940","580");
    }
    function doAction1(sAction){
		switch (sAction) {	//만건단위로 변경  by JSG=> 스크롤 내렸을때 서버 다운됨(2013.8.28일) ic => ServerPaging
		case "Search":
			var page = sheet1.GetSheetPageLength();
			$("#defaultRow").val(page);
			var param = {"Param":"cmd=getPwrSrchResultPopupList&"+$("#sheetForm").serialize()};
			if(stdCol != "") {
				var info =[{StdCol:stdCol, SumCols:sumCols, AvgCols:avgCols, ShowCumulate:0, CaptionCol:stdPos}];
				sheet1.ShowSubSum(info) ;
			}			
			sheet1.DoSearchPaging( "${ctx}/PwrSrchResultPopup.do", param );
			//차트 타입이 있으면 차트 불러오기
			if (detailDesc.DATA.chartType) {
				chartResult1 = ajaxCall("${ctx}/PwrSrchResultPopup.do?cmd=getPwrSrchResultPopupList",$("#sheetForm").serialize(),false);
				//if(chartResult1.["DATA"].[0].[under2camel(detailDesc.DATA.chartPer)]){
				if(chartResult1["DATA"][0][under2camel(detailDesc.DATA.chartKey)]){
					$("#chart_table").removeClass("hide");
					$("#chartbodywrap").css("overflow-y","auto");
					CallChart1(detailDesc.DATA.chartType);
				};
			}
			break;
		//case "Down2Excel":	sheet1.Down2Excel(); break;
		case "Down2Excel":
/* 			var param = {
				URL:"${ctx}/PwrSrchResultPopup.do"
			    ,ExtendParam:"&cmd=getPwrSrchResultPopupDown&" + $("#sheetForm").serialize()
			    ,FileName:"PersonList${curSysYyyyMMdd}.xlsx"
			    , Merge:1 //속도 문제가 있지만 크게 문제 없으므로 추가함
			};
			sheet1.DirectDown2Excel(param); */

			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
    }

	function doAction2(sAction){
        switch(sAction){
    	case "Search":
    		$("#srchCondType").val("U");
    		sheet2.DoSearch( "${ctx}/PwrSrchAdminUser.do?cmd=getPwrSrchAdminUserSht2List", $("#sheetForm").serialize() );
    		break;
    	case "Save":        //저장
           	if(sheet2.FindStatusRow("I|S|D|U") != ""){
           		IBS_SaveName(document.sheetForm,sheet2);
               	sheet2.DoSave("${ctx}/PwrSrchAdminUser.do?cmd=savePwrSrchAdminUser", $("#sheetForm").serialize(),-1,false);
               	//sheet2.SetColHidden(1,0);
           	}
//            	var param = "";
//            	param = "&srchSeq="+srchSeq;
//            	param += "&adminSqlSyntax="+detailDesc.DATA.adminSqlSyntax;
//            	param += "&conditionDesc="+detailDesc.DATA.conditionDesc;

//            	var rtnMes = ajaxCall("${ctx}/PwrSrchAdminUser.do?cmd=updatePwrSrchAdminUserSyntax",param);
           	break;
        }
    }
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize();
			var searchTableHtml = "<tr>";
			var trCnt = 4;
			var idx = 0;
			var datepickersYmd = "";
			var datepickersYm = "";
			var codeListParam = "";
			var textValue = "";
			var read = "";
			for(var row = 1 ; row <= sheet2.LastRow() ; row++) {
		        if(    sheet2.GetCellValue(row, "valueType") == "dfCompany"
		            || sheet2.GetCellValue(row, "valueType") == "dfSabun"
		            || sheet2.GetCellValue(row, "valueType") == "dfBaseDate"
		            || sheet2.GetCellValue(row, "valueType") == "dfSearchTy"
		            || sheet2.GetCellValue(row, "valueType") == "dfGrpCd" ){
		            sheet2.SetCellEditable(row, "inputValueDesc",0);
		        }
		        if( sheet2.GetCellValue(row, "valueType") != "dfCompany"
		            && sheet2.GetCellValue(row, "valueType") != "dfSabun"
		            && sheet2.GetCellValue(row, "valueType") != "dfBaseDate"
			        && sheet2.GetCellValue(row, "valueType") != "dfSearchTy"
				    && sheet2.GetCellValue(row, "valueType") != "dfGrpCd"
		        	&& sheet2.GetCellValue(row, "viewYn") == "Y" ) {

		        	searchTableHtml +=
							`<th>\${sheet2.GetCellValue(row, "columnNm")}</th>
							 <td>`;

		        	if(sheet2.GetCellValue(row, "valueType") == "dfDateYmd") {
		        		searchTableHtml += "<input id='inputVal"+row+"' name='inputVal"+row+"' onblur='javascript:cellChangeAction("+row+", value);' type='text' size=10 class='date' value='"+sheet2.GetCellValue(row, "inputValueDesc")+"'/>";
		        		if(datepickersYmd == "") {
		        			datepickersYmd = "inputVal"+row;
		        		} else {
		        			datepickersYmd = datepickersYmd + ",inputVal"+row;
		        		}
		        	} else if(sheet2.GetCellValue(row, "valueType") == "dfDateYm") {
		        		searchTableHtml += "<input id='inputVal"+row+"' name='inputVal"+row+"' onblur='javascript:cellChangeAction("+row+", value);' type='text' size=10 class='date' value='"+sheet2.GetCellValue(row, "inputValueDesc")+"'/>";
		        		if(datepickersYm == "") {
		        			datepickersYm = "inputVal"+row;
		        		} else {
		        			datepickersYm = datepickersYm + ",inputVal"+row;
		        		}
		        	} else if(sheet2.GetCellValue(row, "valueType") == "dfText") {
		        		searchTableHtml += "<input id='inputVal"+row+"' name='inputVal"+row+"' type='text' size=10 class='text' value='"+sheet2.GetCellValue(row, "inputValueDesc")+"'/>";
		        		if(textValue == "") {
		        			textValue = "inputVal"+row;
		        		} else {
		        			textValue = textValue + ",inputVal"+row;
		        		}
		        	/*코드이면서 연산자가 "=" 이면 콤보박스로 구성함*/
		        	} else if(sheet2.GetCellValue(row, "valueType") == "dfCode" && sheet2.GetCellValue(row, "operator") == "10050") {
		        		searchTableHtml += "<select id='inputVal"+row+"' name='inputVal"+row+"' onchange='javascript:cellChangeAction("+row+", value);'></select>";
		        		if(codeListParam == "") {
		        			codeListParam = row;
		        		} else {
		        			codeListParam = codeListParam + ","+row;
		        		}
		        	} else {
		        		searchTableHtml += "<input id='inputVal"+row+"' name='inputVal"+row+"' type='text' class='text readonly' value='"+sheet2.GetCellValue(row, "inputValueDesc")+"' readonly style='width:150px'/>&nbsp;";
			        	searchTableHtml += "<a onclick='javascript:sheet2.SetSelectRow("+row+");sheet2_OnPopupClick("+row+", 11);' class='button6'><img src='/common/${theme}/images/btn_search2.gif'/></a>";
		        	}
		        	searchTableHtml += "</td>";
		        	idx++;
					if(row === sheet2.LastRow()) searchTableHtml += "</tr>";
		        	else if(row > 1 && idx%tdCnt === 0) searchTableHtml += "</tr><tr>";
		        }
			}
			if(idx > 0) {
				$("#searchTable").html(searchTableHtml);
				setSearchDatepickerYmd(datepickersYmd);
				setSearchDatepickerYm(datepickersYm);
				setSearchSelectBox(codeListParam);
				setSearchTextValue(textValue);
			} else {
				$("#searchTableDiv").hide();
			}

			getCommonCodeList();

		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	/*조회조건 항목 설정후 Hidden된 Sheet에 데이타 setting함으로써 셀이벤트 실행시닠다.sheet2의 onChange Event*/
	function cellChangeAction(rowNo, value) {
		sheet2.SetSelectRow(rowNo);
		//sheet2.SetCellValue(rowNo, 12, value, 0);
		var cellText = "";
		cellText = sheet2.GetCellText(rowNo, 12);
		//sheet2.SetCellValue(rowNo, 11, cellText);

        if(sheet2.GetCellValue(rowNo, "valueType") == "dfDateYmd"){
            sheet2.SetCellValue(rowNo, "inputValue","'"+value.split("-").join("")+"'",0);
            sheet2.SetCellValue(rowNo, "inputValueDesc",value);
        }else if(sheet2.GetCellValue(rowNo, "valueType") == "dfDateYm"){
            sheet2.SetCellValue(rowNo, "inputValue","'"+value.split("-").join("")+"'",0);
            sheet2.SetCellValue(rowNo, "inputValueDesc",value);
        }else if(sheet2.GetCellValue(rowNo, "valueType") == "dfCode" && sheet2.GetCellValue(rowNo, "operator") == "10050"){
            sheet2.SetCellValue(rowNo, "inputValue","'"+value+"'", 0);
            sheet2.SetCellValue(rowNo, "inputValueDesc",$("#inputVal"+rowNo+" option:selected").html());
        }else if(sheet2.GetCellValue(rowNo, "valueType") == "dfText"){
        	if(sheet2.GetCellValue(rowNo, "operator") == "10190") {
            	sheet2.SetCellValue(rowNo, "inputValue","'%"+value+"%'", 0);
        	} else {
            	sheet2.SetCellValue(rowNo, "inputValue","'"+value+"'", 0);
        	}
            sheet2.SetCellValue(rowNo, "inputValueDesc",value);
        }else{
           sheet2.SetCellValue(rowNo, "inputValue", value,0);
           sheet2.SetCellValue(rowNo, "inputValueDesc", cellText);
        }
	}
	/*조죄조건 InputBox의 type이 Date Ymd 일경우 스크립트 삽입*/
	function setSearchDatepickerYmd(datepickerTxt){
		if(datepickerTxt != "") {
			var ary = datepickerTxt.split(",");
			for(var i = 0 ; i < ary.length; i++) {
				$("#"+ary[i]).datepicker2({
					onReturn:function(date) {
						var namePreFix = "inputVal";
						var nameTxt = this.name;
						var rowNum = nameTxt.substr(namePreFix.length);
						cellChangeAction(rowNum, date);
					}
				});
			}
		}
	}

	/*조죄조건 InputBox의 type이 Date Ym 일경우 스크립트 삽입*/
	function setSearchDatepickerYm(datepickerTxt){
		if(datepickerTxt != "") {
			var ary = datepickerTxt.split(",");
			for(var i = 0 ; i < ary.length; i++) {
				$("#"+ary[i]).datepicker2({
					ymonly:true,
					onReturn:function(date) {
						var namePreFix = "inputVal";
						var nameTxt = this.name;
						var rowNum = nameTxt.substr(namePreFix.length);
						cellChangeAction(rowNum, date);
						}
					});
			}
		}
	}
	/*조죄조건 SelectBox에 Item 삽입*/
	function setSearchSelectBox(rowsTxt){
		rowsTxt = "" + rowsTxt;
		if(rowsTxt != "") {
			if(rowsTxt.indexOf(",") > 0) {
				var ary = rowsTxt.split(",");
				for(var i = 0 ; i < ary.length; i++) {
					var searchItemCd = sheet2.GetCellValue(ary[i], "searchItemCd");
					$("#searchItemCd").val(searchItemCd);
					var codeComboList = convCodeIdx( ajaxCall("${ctx}/PwrSrchInputValuePopup.do?cmd=getPwrSrchInputValueTmpList", $("#sheetForm").serialize(),false).data, "",-1);
					$("#inputVal"+ ary[i]).html(codeComboList[2]);
					$("#inputVal"+ ary[i]).val((sheet2.GetCellValue(ary[i], 10)).replace(/'/gi,""));
				}
			} else {
				var searchItemCd = sheet2.GetCellValue(rowsTxt, "searchItemCd");
				$("#searchItemCd").val(searchItemCd);
				var codeComboList = convCodeIdx( ajaxCall("${ctx}/PwrSrchInputValuePopup.do?cmd=getPwrSrchInputValueTmpList", $("#sheetForm").serialize(),false).data, "",-1);
				$("#inputVal"+ rowsTxt).html(codeComboList[2]);
				$("#inputVal"+ rowsTxt).val((sheet2.GetCellValue(rowsTxt, 10)).replace(/'/gi,""));
			}
		}
	}

	function setSearchTextValue(textValue){
		if(textValue != "") {
			var ary = textValue.split(",");
			for(var i = 0 ; i < ary.length; i++) {
				$("#"+ary[i]).bind("change", function(e) {
					var namePreFix = "inputVal";
					var nameTxt = this.name;
					var rowNum = nameTxt.substr(namePreFix.length);
					cellChangeAction(rowNum, $(this).val());
				});
				$("#"+ary[i]).bind("keyup", function(e){
					if( e.keyCode == 13){
						var namePreFix = "inputVal";
						var nameTxt = this.name;
						var rowNum = nameTxt.substr(namePreFix.length);
						cellChangeAction(rowNum, $(this).val())
					}
				});
			}
		}
	}

	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { //alert(Msg);
				doAction2('Search');
				doAction1('Search');
			  }
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	function sheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
		    selectSheet = sheet2;
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	function sheet2_OnPopupClick(Row, Col){
		try {
			if(Row > 0 && sheet2.ColSaveName(Col) == "inputValueDesc"){
				if(!isPopup()) {return;}

				var args 	= new Array();
				//args["sheet"] 	= "sheet2";
				args["operator"] = sheet2.GetCellText(Row, "operator").toUpperCase();
				args["valueType"]    = sheet2.GetCellValue(Row, "valueType");
				args["searchItemCd"]  = sheet2.GetCellValue(Row, "searchItemCd");
				args["inputValue"]  = sheet2.GetCellValue(Row, "inputValue");
				args["inputValueDesc"]  = sheet2.GetCellValue(Row, "inputValueDesc");
				args["adminFlag"] 	= "yes";  //=> 어디에 사용하는지 의문 ic
				
				//var url	= "${ctx}/PwrSrchInputValuePopup.do?cmd=pwrSrchInputValuePopup&authPg=${authPg}";
				//openPopup(url, args, "840","680");
				//재직상태 팝업
		        let layerModal = new window.top.document.LayerModal({
		              id : 'pwrSrchInputValueLayer'
		            , url : '${ctx}/PwrSrchInputValuePopup.do?cmd=viewPwrSrchInputValueLayer&authPg=${authPg}'
		            , parameters : args
		            , width : 840
		            , height : 680
		            , title : '조회업무 조회'
		            , trigger :[
		                {
		                      name : 'pwrSrchInputValueTrigger'
		                    , callback : function(result){
		                    	getReturnValue(result, args, Row);
		                    }
		                }
		            ]
		        });
		        layerModal.show();
				
		    }
		} catch (ex) { alert("OnPopupClick Event Error " + ex); }
	}
	
    function checkLike(str,opt, operator){
        
        // var selectRow = sheet.GetSelectRow();
         if(operator == "LIKE"|| operator == "NOT LIKE" ){
             if(opt == "front"){
                 str = "'"+str+"%'";
             }else if(opt == "rear"){
                 str = "'%"+str+"'";
             }else{
                 str = "'%"+str+"%'";
             }
         }else if(operator == "IN"|| operator == "NOT IN" ){
             if(str.substring(0,1).indexOf("(") == -1 && str.substring(str.length-1).indexOf(")") == -1){
                 str = "'"+str+"'";
             }else{
                 str = str;
             }
         }else{// LIKE, NOT LIKE, IN, NOT IN이 아닐 시
             str = "'"+str+"'";
         }
         return str;
     }
    
    function checkDateCtl( message, sData, eData){
        if ( sData.split("-").join("") > eData.split("-").join("") ) {
            return false;
        }

        return true;
    }
    
  //팝업 콜백 함수.
    function getReturnValue(result, args, Row) {
        
        var operator = args["operator"];
        var valueType = args["valueType"];
        var searchItemCd = args["searchItemCd"];
        var valueType = args["valueType"];
        console.log(args);
        
        if(operator  == "BETWEEN"){
        	
            if(valueType== "dfDateYmd"){
                if(result.sYmd != "" && result.eYmd != ""){
                    if(checkDateCtl("",result.sYmd, result.eYmd)){
                        sheet2.SetCellValue(Row, "inputValue","'"+result.sYmd.split("-").join("")+"'" + " AND " + "'"+resulteYmd.split("-").join("")+"'");
                        sheet2.SetCellValue(Row, "inputValueDesc",result.sYmd + "일에서 " + result.eYmd+"일까지");
                    }else{
                        return;
                    }
                }else if(result.sYmd == "" && result.eYmd == ""){
                    sheet2.SetCellValue(Row, "inputValue",checkLike('','all',operator));
                    sheet2.SetCellValue(Row, "inputValueDesc","");
                }else{
                    alert("<msg:txt mid='alertInputSdateEdate' mdef='시작일과 종료일을 입력하세요.'/>");
                    $("#eYmd").focus();
                    return;
                }
            }else if(valueType == "dfDateYm"){
                if(result.sYm != "" && result.eYm != ""){
                    if(checkDateCtl("",result.sYm, result.eYm)){
                        sheet2.SetCellValue(Row, "inputValue","'"+result.sYm.split("-").join("")+"'" + " AND " + "'"+result.eYm.split("-").join("")+"'");
                        sheet2.SetCellValue(Row, "inputValueDesc",result.sYm + "월에서 " + result.eYm+"월까지");
                    }else{
                        return;
                    }
                }else if(result.sYm == "" && result.eYm == ""){
                    sheet2.SetCellValue(Row, "inputValue",checkLike('','all'));
                    sheet2.SetCellValue(Row, "inputValueDesc","");
                }else{
                    alert("<msg:txt mid='alertInputSdateEdate' mdef='시작일과 종료일을 입력하세요.'/>");
                    document.all.eDateYm.focus();
                    return;
                }
            }else{
                sheet2.SetCellValue(Row, "inputValue","'"+result.sVal+"'" + " AND " + "'"+result.eVal+"'");
                sheet2.SetCellValue(Row, "inputValueDesc",result.sVal + "에서 " + result.eVal+"까지");
            }
        }else{
        	
             if(searchItemCd != ""){
                sheet2.SetCellValue(Row, "inputValue",checkLike(result.vall, result.likeOpt, operator ));
                sheet2.SetCellValue(Row, "inputValueDesc",result.valDesc);
            }else{
                if(valueType == "dfDateYmd"){
                    sheet2.SetCellValue(Row, "inputValue","'"+result.ymd.split("-").join("")+"'");
                    sheet2.SetCellValue(Row, "inputValueDesc",result.ymd);
                }else if(valueType  == "dfDateYm"){
                    sheet2.SetCellValue(Row, "inputValue","'"+result.ym.split("-").join("")+"'");
                    sheet2.SetCellValue(Row, "inputValueDesc",result.ym);
                }else if(valueType == "dfIdNo"){
                    sheet2.SetCellValue(Row, "inputValue","'"+result.resNo+"'");
                    sheet2.SetCellValue(Row, "inputValueDesc",result.resNo);
                }else if(valueType == "dfNumber"){
                    sheet2.SetCellValue(Row, "inputValue",result.etcData);
                    sheet2.SetCellValue(Row, "inputValueDesc",result.etcData);
                }else{
                    if(operator  == "IN"|| operator == "NOT IN"){
                        sheet2.SetCellValue(Row, "inputValue","("+result.etcData+")");
                    }else{
                        sheet2.SetCellValue(Row, "inputValue",checkLike(result.etcData,  result.likeOpt, operator));
                    }
                    sheet2.SetCellValue(Row, "inputValueDesc",result.etcData);
                }
            }
        }
     
    }
  
	function sheet2_OnChange(Row,Col,Value){
		try{
			if(Row > 0 && sheet2.ColSaveName(Col) == "operator"){
		        sheet2.SetCellValue(Row, "inputValue",checkLike(''));
		        sheet2.SetCellValue(Row, "inputValueDesc","");
		        checkIsNull(sheet2, Row, Col);
		    }else if(Row > 0 && sheet2.ColSaveName(Col) == "valueType"){
		        if(Value == "dfCode"){
		            sheet2.SetCellEditable(Row,"searchItemNm",1);
		        }else{
		            sheet2.SetCellEditable(Row,"searchItemNm",0);
		            sheet2.SetCellValue(Row,"searchItemCd","");
		            sheet2.SetCellValue(Row,"searchItemNm","");
		        }
		        if(Value == "dfCompany"){
		            sheet2.SetCellValue(Row, "inputValue","dfCompany");
		            sheet2.SetCellValue(Row, "inputValueDesc","해당 회사");
		            sheet2.SetCellEditable(Row,"searchItemNm",0);
		            sheet2.SetCellEditable(Row,"inputValue",0);
		            sheet2.SetCellEditable(Row,"inputValueDesc",0);
		        }else if(Value == "dfSabun"){
		            sheet2.SetCellValue(Row, "inputValue","dfSabun");
		            sheet2.SetCellValue(Row, "inputValueDesc","해당 담당자");
		            sheet2.SetCellEditable(Row,"searchItemNm",0);
		            sheet2.SetCellEditable(Row,"inputValue",0);
		            sheet2.SetCellEditable(Row,"inputValueDesc",0);
		        }else if(Value == "dfBaseDate"){
		            sheet2.SetCellValue(Row, "inputValue","dfBaseDate");
		            sheet2.SetCellValue(Row, "inputValueDesc","적용일자");
		            sheet2.SetCellEditable(Row,"searchItemNm",0);
		            sheet2.SetCellEditable(Row,"inputValue",0);
		            sheet2.SetCellEditable(Row,"inputValueDesc",0);
		        }else if(Value == "dfSearchTy"){
		            sheet2.SetCellValue(Row, "inputValue","dfSearchTy");
		            sheet2.SetCellValue(Row, "inputValueDesc","조회타입");
		            sheet2.SetCellEditable(Row,"searchItemNm",0);
		            sheet2.SetCellEditable(Row,"inputValue",0);
		            sheet2.SetCellEditable(Row,"inputValueDesc",0);
		        }else if(Value == "dfGrpCd"){
		            sheet2.SetCellValue(Row, "inputValue","dfGrpCd");
		            sheet2.SetCellValue(Row, "inputValueDesc","권한코드");
		            sheet2.SetCellEditable(Row,"searchItemNm",0);
		            sheet2.SetCellEditable(Row,"inputValue",0);
		            sheet2.SetCellEditable(Row,"inputValueDesc",0);
		        }else{
		            sheet2.SetCellValue(Row, "inputValue",checkLike(""));
		            sheet2.SetCellValue(Row, "inputValueDesc","");
		        }
		    }else if(Row > 0 && sheet2.ColSaveName(Col) == "searchItemCd"){
		        sheet2.SetCellValue(Row, "inputValue",checkLike(""));
		        sheet2.SetCellValue(Row, "inputValueDesc","");
		    }
		    if(sheet2.GetCellText(Row, "operator").indexOf("NULL") != -1){
		        sheet2.SetCellValue(Row, "inputValue","");
		        sheet2.SetCellValue(Row, "inputValueDesc","");
		    }

		    if(Row > 0 && sheet2.ColSaveName(Col) == "inputValueDesc"){
		    	$("#inputVal"+Row).val(Value);
		    	doAction2('Save');
		    }

		}catch(ex){alert("OnChange Event Error : " + ex);}
	}

	function toggleSheet() {
		if( $("#toggleBtn").text() == "▲ "+"설명닫기" ) hideSheet();
		else showSheet();
	}
	function showSheet() {
		$("#toggleBtn").text("▲ "+"설명닫기");
		$("#hiddenTd").show(500);
		sheetResize();
	}
	function hideSheet() {
		$("#toggleBtn").text("▼ "+"설명보기");
		$("#hiddenTd").hide();
		sheetResize();
	}
	
	//차트 관련
	function ChartDesign1() {
		myChart1.SetCopyright({enabled:0});
		myChart1.SetPlotBackgroundColor("#F7FAFB");
		myChart1.SetPlotBorderColor("#A9AEB1");
		myChart1.SetPlotBorderWidth(0.5);
		myChart1.SetZoomType(IBZoomType.X_AND_Y);
		
		var color = new Color();
		color.SetLinearGradient(0, 0, 100, 500);
		color.AddColorStop(0, "#FFFFFF");
		color.AddColorStop(1, "#D3D9E5");
		myChart1.SetBackgroundColor(color);
		myChart1.SetMainTitle({Enabled:false, Text:"", FontWeight:"bold", Color:"#15498B"});

		var Yaxis = myChart1.GetYAxis(0);
		Yaxis.SetGridLineDashStyle(IBDashStyle.SOLID);
		Yaxis.SetGridLineColor("#C4C9CD");
		Yaxis.SetGridLineWidth(0.5);
		Yaxis.SetLineColor("#9BA3A5");
		Yaxis.SetMinorGridLineWidth(0);
		Yaxis.SetMinorTickInterval(25);
		Yaxis.SetMinorTickLength(2);
		Yaxis.SetMinorTickWidth(1);
		Yaxis.SetMinorTickColor("#7C7C7E");
		Yaxis.SetTickColor("#7C7C7E");
		Yaxis.SetTickInterval(50);
		//Yaxis.SetMax(900);
		Yaxis.SetAxisTitle({Enabled:false, Text:""});

		var Xaxis = myChart1.GetXAxis(0);
		Xaxis.SetGridLineWidth(0.5);
		Xaxis.SetGridLineColor("#C4C9CD");
		Xaxis.SetGridLineDashStyle(IBDashStyle.SOLID);
		Xaxis.SetLineColor("#9BA3A5");
		Xaxis.SetMinorTickColor("#7C7C7E");
		Xaxis.SetTickColor("#7C7C7E");
		
		var plotPie = new PiePlotOptions();
		// 파이와 라벨의 거리, 두께, 색, padding, 부드러운 처리
		plotPie.SetDataLabelsConnector(10,1,'',0,true);
		myChart1.SetPiePlotOptions(plotPie);
		
		//누적x, 막대상단 value 표시
		var plot = new ColumnPlotOptions();
		plot.SetStacking(null);
		plot.SetDataLabels(true,IBAlign.CENTER,0,-3,'#333333');
		myChart1.SetColumnPlotOptions(plot);
		
		myChart1.SetLegend({Align:IBAlign.CENTER, Valign:IBVerticalAlign.BOTTOM, Layout:IBLayout.HORIZONTAL});
		var tooltip = new ToolTip();
		myChart1.SetToolTip({Enabled:true, Shadow:true, Formatter:ToolTipFormatter, Color:'#000000', FontSize:'13px',FontWeight:'bold'});
	}
	function ToolTipFormatter(){
		return '<span style="color:#040087;">' + replaceAll(this.point.name,'<br>', '') + '</span><br />' + this.series.name + ' : <b>' + this.y + '</b>' ;
	}
	function CallChart1(chartType)
	{
		myChart1.RemoveAll();
		//차트 타입 지정
		myChart1.SetDefaultSeriesType(chartType);
		myChart1.SetLegend(false) ;
		//차트 데이터 지정
		//chartResult1 = ajaxCall("${ctx}/SexAgeGrpSta.do?cmd=getSexGrpStaList",$("#srchFrm").serialize(),false);
        var interval = -1;
		var $timer = $("#timer");
		interval = setInterval(function() {
			drawChartForAnime1(chartResult1) ;
			clearInterval(interval);
		},400);
	}
	function drawChartForAnime1(chartResult1) {
		var pieChartTitle ="" ;
		var data = "{";
		data += 		"IBCHART: {";
		data += 		"BACKCOLOR: '#FFFFFF',";
		data += 		"BORDERWIDTH: '1',";
		data += 		"TITLE: '"+pieChartTitle+"',";
		//data += 		"SUBTITLE: '통계',";
		data += 		"ETCDATA: [ {KEY:'sname', VALUE:'홍길동'},";
		data += 		"			{KEY:'age',   VALUE:'20'}";
		data += 		"		  ],";
		data += 		"DATA: {" ;
		data += 		"		POINTSET:[" ;
		myChart1Data = new Array();
		for(var i = 0; i < chartResult1["DATA"].length; i++) {
			if(chartResult1["DATA"][i][under2camel(detailDesc.DATA.chartValue)] == "0") continue ;
			myChart1Data.push(chartResult1["DATA"][i]);
			data += 		"				  {AXISLABEL:'"+chartResult1["DATA"][i][under2camel(detailDesc.DATA.chartKey)]+"', " ;
			data += 		"					  SERIES:[{ LEGENDLABEL:'"+(detailDesc.DATA.chartDisValue ? detailDesc.DATA.chartDisValue : detailDesc.DATA.chartKey)+"'";
			if (chartResult1["DATA"][i][under2camel(detailDesc.DATA.chartPer)]) {
				data +=			"						, POINTLABEL:'"+chartResult1["DATA"][i][under2camel(detailDesc.DATA.chartKey)]+"<br>("+chartResult1["DATA"][i][under2camel(detailDesc.DATA.chartPer)]+"%)'";
			} else {
				data +=			"						, POINTLABEL:'"+chartResult1["DATA"][i][under2camel(detailDesc.DATA.chartKey)]+"'";
			}
			data +=			"						, VALUE:"+chartResult1["DATA"][i][under2camel(detailDesc.DATA.chartValue)]+"}";
			data += 		"				 			 ] ";
			if(i == chartResult1["DATA"].length-1 || ( i+1 <= chartResult1["DATA"].length && chartResult1["DATA"][i+1][under2camel(detailDesc.DATA.chartValue)] == "0" ) ) {
				data += 		"	   		   }";
			} else {
				data += 		"	   		   },";
			}
		}
		data += 		"				 ] ";
		data += 		"	  }";
		data += 		"}";
		data += 	"}";

		// JSON 문자열을 읽어서 차트의 기본틀을 생성
		myChart1.GetDataJsonString(data);
	}
	function downChart(){
 		myChart1.Down2Image({FileName:"ChartImage", Type:IBExportType.JPEG, Width:800, Url:"/common/plugin/IBLeaders/Sheet/jsp/Down2Image.jsp"});
	}
	//카멜표기법으로 전환
	function under2camel(str){
		return str.toLowerCase().replace(/(\_[\w])/g, function(arg){
			return arg.toUpperCase().replace('_','');
		});
	}
	
	// employee header 검색 시
	function setEmpPage() {
		$("#dfIdvSabun").val($("#searchUserId").val());
		doAction1("Search");
	}
</script>
</head>
<body class="bodywrap" id="chartbodywrap">
	<div class="wrapper">
	
		<div id="divEmpHeader" class="hide">
			<%-- include Employee Header --%>
			<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp" %>
		</div>
	
		<form id="sheetForm" name="sheetForm">
				<input id="srchSeq" name="srchSeq" type="hidden" />
				<input id="searchItemCd" name="searchItemCd" type="hidden" />
				<input id="srchCondType" name="srchCondType" type="hidden" />
				<input id="adminSqlSyntax" name="adminSqlSyntax" type="hidden" />
				<input id="defaultRow" name="defaultRow" type="hidden" >
				<input id="dfIdvSabun" name="dfIdvSabun" type="hidden" >
		</form>
		<div class="sheet_search outer"  id="searchTableDiv" name="searchTableDiv">
			<div>
				<table id="searchTable" name="searchTable">

				</table>
			</div>
		</div>
		<!-- 차트 그리기  -->
		<table border="0" cellspacing="0" cellpadding="0" id="chart_table" class="sheet_main hide">
			<colgroup><col width="50%" /><col width="" /></colgroup>
			<tr>
				<td colspan="2">
					<div class="sheet_title">
						<ul>
							<li class="txt">차트</li>
							<li class="btn">
								<a href="javascript:downChart();" id="btnDown" class="basic authR"><tit:txt mid='113874' mdef='이미지다운'/></a>
							</li>
						</ul>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="height: 320px;"><script type="text/javascript"> createIBChart("myChart1", "100%", "100%"); </script></td>
			</tr>
		</table>
		<!-- 차트 그리기 End -->
		<table class="sheet_main">
			<tr>
				<td>
					<div id="resultSheet" name="resultSheet">
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li id="liTitle" class="txt">조건검색결과</li>
									<li class="txt" id="btnMore" style="margin-left: 8px;"><btn:a id="toggleBtn" onclick="javascript:toggleSheet();" css="btn outline_gray" mid="111875" mdef="▼ 설명보기"/></li>
									<li class="btn">
										<a class="btn outline_gray authR" onclick="javascritp:doAction1('Down2Excel');"><tit:txt mid="download" mdef="다운로드"/></a>
										<btn:a css="btn dark authR"	onclick="javascritp:doAction1('Search');" mid='search' mdef="조회"/>
									</li>
								</ul>
							</div>
						</div>
						<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
					</div>
				</td>
			</tr>
			<tr>
				<td  id="hiddenTd" name="hiddenTd" class="outer" style="display:none;height:200px;">
					<div class="explain">
						<div class="title">조회조건설명</div>
						<div class="txt">
							<ul>
								<li><div id="srchDesc" class="scroll"></div></li>
							</ul>
						</div>
					</div>
				</td>
			</tr>
		</table>
		<div id="tmpRow1" style="display: none">
			<script type="text/javascript">createIBSheet("sheet2", "100%", "0px", "${ssnLocaleCd}"); </script>
			<script type="text/javascript">createIBSheet("sheet3", "100%", "100%", "${ssnLocaleCd}");</script>
		</div>
	</div>
</body>
</html>

