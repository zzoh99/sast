<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!-- 날짜 콤보 박스 생성을 위함 -->
<%@ page import="java.util.GregorianCalendar" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!-- 날짜 콤보 박스 생성을 위함 -->

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	var gPRow  = "";
	var pGubun = "";

	$(function() {

		$("#tmpPayYmFrom").datepicker2({ymonly:true});
		$("#tmpPayYmTo").datepicker2({ymonly:true});
		$("#tmpPayYmTo, #tmpPayYmFrom").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$("input[name$='chkGigan']").click(function() {
	        var selectBtn = $(this).val();
			var str = "${curSysYear}"+"-"+"${curSysMon}"+"-"+"${curSysDay}";
			// 한달
	        if(selectBtn == "1"){
	        	$("#tmpPayYmFrom").val("${curSysYear}"+"-"+"${curSysMon}");
	    		$("#tmpPayYmTo").val("${curSysYear}"+"-"+"${curSysMon}");
            }
	        // 3개월
	        else if(selectBtn == "3"){

	        	$("#tmpPayYmFrom").val(addDate("m", -2,"${curSysYyyyMMdd}", "-"));
	        	$("#tmpPayYmTo").val("${curSysYear}"+"-"+"${curSysMon}");
            }
	        // 6개월
	        else if(selectBtn == "6"){

	        	$("#tmpPayYmFrom").val(addDate("m", -5,"${curSysYyyyMMdd}", "-"));
	        	$("#tmpPayYmTo").val("${curSysYear}"+"-"+"${curSysMon}");
            }
	        // 9개월
	        else if(selectBtn == "9"){

	        	$("#tmpPayYmFrom").val(addDate("m", -8,"${curSysYyyyMMdd}", "-"));
	        	$("#tmpPayYmTo").val("${curSysYear}"+"-"+"${curSysMon}");
            }
	        // 12개월
	        else if(selectBtn == "12"){

	        	$("#tmpPayYmFrom").val(addDate("m", -11,"${curSysYyyyMMdd}", "-"));
	        	$("#tmpPayYmTo").val("${curSysYear}"+"-"+"${curSysMon}");
            }
	    });

		// 초기 설정 값
		$("#tmpPayYmFrom").val(addDate("m", -11,"${curSysYyyyMMdd}", "-"));
    	$("#tmpPayYmTo").val("${curSysYear}"+"-"+"${curSysMon}");

		sheet1.SetDataLinkMouse("detail", 1);

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
   			{Header:"<sht:txt mid='sNo' 			mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
//   		{Header:"<sht:txt mid='sDelete V5' 		mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
//   		{Header:"<sht:txt mid='sStatus' 		mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
  			{Header:"<sht:txt mid='dbItemDesc' 		mdef='세부\n내역'/>",    		Type:"Image",     	Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"detail" ,  		   KeyField:0,   CalcLogic:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0},
  			{Header:"<sht:txt mid='paymentYmdV4' 	mdef='PAYMENT_YMD'/>",   	Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"paymentYmd",       KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100},
  			{Header:"<sht:txt mid='payActionCdV2' 	mdef='pay_action_cd'/>",	Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"payActionCd",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
  			{Header:"<sht:txt mid='payActionCd' 	mdef='급여일자'/>",      		Type:"Text",      	Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"payActionNm",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100},
  			{Header:"<sht:txt mid='agreeSabun' 		mdef='사번'/>",          		Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"sabun",            KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
  			{Header:"<sht:txt mid='totEarningMonV2' mdef='급여총액'/>",      		Type:"AutoSum",		Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"totEarningMon",    KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			{Header:"<sht:txt mid='element15' 		mdef='공제총액'/>",      		Type:"AutoSum",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"totDedMon",        KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			{Header:"<sht:txt mid='element16' 		mdef='실지급액'/>",      		Type:"AutoSum",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"paymentMon",       KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			{Header:"<sht:txt mid='element1070' 	mdef='소득세'/>",        		Type:"AutoSum",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"itaxMon",          KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			{Header:"<sht:txt mid='finInbitTaxMon'	mdef='주민세'/>",        		Type:"AutoSum",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"rtaxMon",          KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			{Header:"<sht:txt mid='gubun3' 			mdef='국민연금'/>",      		Type:"AutoSum",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"npEeMon",          KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			{Header:"<sht:txt mid='gubun4' 			mdef='건강보험'/>",      		Type:"AutoSum",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"hiEeMon",          KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			{Header:"<sht:txt mid='eiEeMonV1' 		mdef='고용보험'/>",      		Type:"AutoSum",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"eiEeMon",          KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			{Header:"<sht:txt mid='mon1V5' 			mdef='제세공과금외공제'/>",   	Type:"AutoSum",     Hidden:1,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"mon1",             KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			{Header:"<sht:txt mid='element12' 		mdef='과세총액'/>",      		Type:"AutoSum",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"taxibleEarnMon",   UpdateEdit:0 },
  			{Header:"<sht:txt mid='bMon' 			mdef='비과세총액'/>",      	Type:"AutoSum",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"notaxTotMon",      UpdateEdit:0 }
  		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(0);

        // 조회조건 급여구분(C00001-00001.급여 00002.상여 00003.연월차 RETRO.소급)
        var searchPayCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList&searchRunType=00001,00002,00003,RETRO,ETC,J0001",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchPayCd").html(searchPayCdList[2]);

 		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
 		sheet1.SetDataLinkMouse("detail",1);

 		$("#searchNm,#searchKeyword").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		//alert(sheet1.Version());
		switch (sAction) {
		case "Search":
			// 시작일 종료일 체크

			var sd = $("#tmpPayYmFrom").val().replace(/\-/g,'').replace(/\//g,'');
			var ed = $("#tmpPayYmTo").val().replace(/\-/g,'').replace(/\//g,'');

			if(sd > ed) {
				alert("<msg:txt mid='110440' mdef='시작 일자를 확인해 주세요.'/>");
				$("#tmpPayYmFrom").focus();
				return;
			}
			// 조회 대상 사원 번호 셋팅
			setEmpPage();

			// 기간별급여세부내역(관리자) 항목리스트 조회
			searchTitleList();

			sheet1.DoSearch( "${ctx}/PerPayPartiTermASta.do?cmd=getPerPayPartiTermAStaList", $("#sheet1Form").serialize() ); break;
		case "Insert":
			var newRow = sheet1.DataInsert(0);
			sheet1.SetCellValue(newRow, "sabun", $("#searchSabun").val());
			break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "skipDown2Excel":  //특정컬럼만 제외하고 엑셀내려받기
			var skip = ("1,2,3,5").split(",").join("|");
			var downcols = makeSkipCol(sheet1,skip);

			var param  = {DownCols:downcols,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	function searchTitleList() {
		// 기간별급여세부내역(관리자) 항목리스트 조회
		var titleList = ajaxCall("${ctx}/PerPayPartiTermASta.do?cmd=getPerPayPartiTermAStaTitleList", $("#sheet1Form").serialize(), false);

		if (titleList != null && titleList.DATA != null) {

			// IBSheet에 설정된 모든 기본 속성을 제거하고 초기상태로 변경한다.
			sheet1.Reset();

			var v         = 0;
			var initdata1 = {};
			initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:8, MergeSheet:msHeaderOnly};
			initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};

			initdata1.Cols 	    = [];
			initdata1.Cols[v++] = {Header:"<sht:txt mid='sNo' 				mdef='No|No'/>",						Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			initdata1.Cols[v++] = {Header:"<sht:txt mid='dbItemDesc' 		mdef='세부\n내역|세부\n내역'/>",    			Type:"Image",     	Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"detail" ,  		   KeyField:0,   CalcLogic:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0};
			initdata1.Cols[v++] = {Header:"<sht:txt mid='paymentYmdV4' 		mdef='PAYMENT_YMD|PAYMENT_YMD'/>",   	Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"paymentYmd",       KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100};
			initdata1.Cols[v++] = {Header:"<sht:txt mid='payActionCdV2' 	mdef='pay_action_cd|pay_action_cd'/>",	Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"payActionCd",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 };
			initdata1.Cols[v++] = {Header:"<sht:txt mid='payActionCd' 		mdef='급여일자|급여일자'/>",      			Type:"Text",      	Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"payActionNm",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100};
			initdata1.Cols[v++] = {Header:"<sht:txt mid='agreeSabun' 		mdef='사번|사번'/>",          				Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"sabun",            KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 };
			initdata1.Cols[v++] = {Header:"<sht:txt mid='totEarningMonV2'	mdef='급여총액|급여총액'/>",      			Type:"AutoSum",		Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"totEarningMon",    KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[v++] = {Header:"<sht:txt mid='element15' 		mdef='공제총액|공제총액'/>",      			Type:"AutoSum",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"totDedMon",        KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[v++] = {Header:"<sht:txt mid='element16' 		mdef='실지급액|실지급액'/>",      			Type:"AutoSum",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"paymentMon",       KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };

			var elementCd = "";
			for(var i=0; i<titleList.DATA.length; i++) {
				elementCd = convCamel(titleList.DATA[i].elementCd);
				initdata1.Cols[v++] = {Header:titleList.DATA[i].elementNm, Type:"AutoSum", Hidden:0, Width:150, Align:"Right", ColMerge:0,	SaveName:elementCd,	KeyField:0,	Format:"Integer", PointCount:0,	UpdateEdit:0, InsertEdit:0,	EditLen:100 };
			}

			initdata1.Cols[v++] = {Header:"<sht:txt mid='element1070' 		mdef='소득세|소득세'/>",        			Type:"AutoSum",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"itaxMon",          KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[v++] = {Header:"<sht:txt mid='finInbitTaxMon'	mdef='주민세|주민세'/>",        			Type:"AutoSum",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"rtaxMon",          KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[v++] = {Header:"<sht:txt mid='gubun3' 			mdef='국민연금|국민연금'/>",      			Type:"AutoSum",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"npEeMon",          KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[v++] = {Header:"<sht:txt mid='gubun4' 			mdef='건강보험|건강보험'/>",      			Type:"AutoSum",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"hiEeMon",          KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[v++] = {Header:"<sht:txt mid='eiEeMonV1' 		mdef='고용보험|고용보험'/>",      			Type:"AutoSum",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"eiEeMon",          KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[v++] = {Header:"<sht:txt mid='mon1V5' 			mdef='제세공과금외공제|제세공과금외공제'/>",   	Type:"AutoSum",     Hidden:1,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"mon1",             KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 };
			initdata1.Cols[v++] = {Header:"<sht:txt mid='element12' 		mdef='과세총액|과세총액'/>",      			Type:"AutoSum",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"taxibleEarnMon",   UpdateEdit:0 };
			initdata1.Cols[v++] = {Header:"<sht:txt mid='bMon' 				mdef='비과세총액|비과세총액'/>",      				Type:"AutoSum",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"notaxTotMon",      UpdateEdit:0 };

			IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	 		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
	 		sheet1.SetDataLinkMouse("detail",1);
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			else {
				if (sheet1.RowCount() > 0 ) {
// 					alert(126634);
// 					var info = {StdCol:"sabun", SumCols:"totEarningMon|totDedMon|paymentMon|itaxMon|rtaxMon|npEeMon|hiEeMon|eiEeMon", Sort:false, ShowCumulate:false, CaptionCol:0};
// 					sheet1.ShowSubSum(info);
				}
			}

			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
	          var colName = sheet1.ColSaveName(Col);

	          if(colName == "detail" && Row >= sheet1.HeaderRows()) {
	        	  // 팝업 호출
	        	  openRegPopup(sheet1.GetCellValue(Row, "sabun"),sheet1.GetCellValue(Row, "payActionCd"));
	          }
	        } catch(ex){alert("OnClick Event Error : " + ex);}
	}


	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

    function addDate(pInterval, pAddVal, pYyyymmdd, pDelimiter){
		var yyyy;
		var mm;
		var dd;
		var cDate;
		var oDate;
		var cYear, cMonth, cDay;

		if (pDelimiter != "") {
		 pYyyymmdd = pYyyymmdd.replace(eval("/\\" + pDelimiter + "/g"), "");
		}

		yyyy = pYyyymmdd.substr(0, 4);
		mm  = pYyyymmdd.substr(4, 2);
		dd  = pYyyymmdd.substr(6, 2);

		if (pInterval == "yyyy") {
		 yyyy = (yyyy * 1) + (pAddVal * 1);
		} else if (pInterval == "m") {
		 mm  = (mm * 1) + (pAddVal * 1);
		} else if (pInterval == "d") {
		 dd  = (dd * 1) + (pAddVal * 1);
		}

		cDate = new Date(yyyy, mm - 1, dd) // 12월, 31일을 초과하는 입력값에 대해 자동으로 계산된 날짜가 만들어짐.
		cYear = cDate.getFullYear();
		cMonth = cDate.getMonth() + 1;
		cDay = cDate.getDate();

		cMonth = cMonth < 10 ? "0" + cMonth : cMonth;
		cDay = cDay < 10 ? "0" + cDay : cDay;

		if (pDelimiter != "") {
		 return cYear + pDelimiter + cMonth;// + pDelimiter + cDay;
		} else {
		 return cYear + cMonth + cDay;
		}
    }

    function setEmpPage() {
    	$("#searchSabun").val($("#searchUserId").val());
    }

    // 입력 버튼 작동 팝업 (사원증 입력)
	function openRegPopup(sabun, payActionCd){

		let layerModal = new window.top.document.LayerModal({
			id : 'payPartiTermLayer'
			, url : '${ctx}/PerPayPartiTermUSta.do?cmd=viewPerPayPartiTermAStaLayer&authPg=A'
			, parameters : {
				sabun : sabun
				, payActionCd : payActionCd
			}
			, width : 950
			, height : 550
			, title : '<tit:txt mid='perPayPartiTermAStaPop' mdef='개인별 급여 세부내역'/>'
		});
		layerModal.show();

		<%--if(!isPopup()) {return;}--%>
		<%--gPRow = "";--%>
		<%--pGubun = "viewPerPayPartiTermAStaPopup";--%>
		<%--var url = "";--%>
		<%--var args= new Array();--%>

		<%--args["sabun"]		= sabun;--%>
		<%--args["payActionCd"]	= payActionCd;--%>

		<%--url = "${ctx}/PerPayPartiTermASta.do?cmd=viewPerPayPartiTermAStaPopup";--%>

		<%--var rv = openPopup(url+"&authPg=A", args, "950","550");--%>
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='112099' mdef='조회기간 '/></th>
						<td>
							<input type="text" id="tmpPayYmFrom" name ="tmpPayYmFrom" class="date2" />
							~
							<input type="text" id="tmpPayYmTo" name ="tmpPayYmTo" class="date2" />
						</td>
						<td>
							<input name ="chkGigan" type="radio" class="radio" value="1" id="month_1"/><label class="txt" for="month_1"><tit:txt mid='113861' mdef='최근한달'/></label>
							<input name ="chkGigan" type="radio" class="radio" value="3" id="month_3"/><label class="txt" for="month_3"><tit:txt mid='112794' mdef='최근3개월'/></label>
							<input name ="chkGigan" type="radio" class="radio" value="6" id="month_6"/><label class="txt" for="month_6"><tit:txt mid='112448' mdef='최근6개월'/></label>
							<input name ="chkGigan" type="radio" class="radio" value="9" id="month_9"/><label class="txt" for="month_9"><tit:txt mid='112795' mdef='최근9개월'/></label>
							<input name ="chkGigan" type="radio" class="radio" value="12" id="year_1" checked="checked"/><label class="txt" for="year_1"><tit:txt mid='114596' mdef='최근1년'/></label>
						</td>
						<th><tit:txt mid='114519' mdef='급여구분 '/></th>
						<td><select id="searchPayCd" name="searchPayCd"></select></td>
						<td><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/></td>
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
							<li id="txt" class="txt"><tit:txt mid='perPayPartiTermASta' mdef='기간별급여세부내역(관리자)'/></li>
							<li class="btn">
								<a href="javascript:doAction1('skipDown2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
