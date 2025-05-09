<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>인력예산인원요청승인</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No|No",            Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo", Sort:0},
			{Header:"삭제|삭제",        Type:"${sDelTy}",   Hidden:1,                   Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },

			{Header:"세부\n내역|세부\n내역",	Type:"Image",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"신청일|신청일",  Type:"Text",   Hidden:0, Width:80,  Align:"Center", ColMerge:0,  SaveName:"applYmd",        Format:"Ymd", Edit:0},
			{Header:"결재상태|결재상태",Type:"Combo",  Hidden:0, Width:80,  Align:"Center", ColMerge:0,  SaveName:"applStatusCd",   Edit:0 },

			{Header:"신청자|직번",       Type:"Text",   Hidden:0, Width:80,  Align:"Center", ColMerge:0,  SaveName:"sabun",          Edit:0},
			{Header:"신청자|성명",       Type:"Text",   Hidden:0, Width:80,  Align:"Center", ColMerge:0,  SaveName:"name",           Edit:0},
			{Header:"신청자|부서",       Type:"Text",   Hidden:0, Width:120, Align:"Left",   ColMerge:0,  SaveName:"appOrgNm",       Edit:0},
			{Header:"신청자|직위",       Type:"Text",   Hidden:0, Width:80,  Align:"Center", ColMerge:0,  SaveName:"jikweeNm",       Edit:0},
			{Header:"신청자|직책",       Type:"Text",   Hidden:0, Width:80,  Align:"Center", ColMerge:0,  SaveName:"jikchakNm",      Edit:0},
			{Header:"신청자|직급",       Type:"Text",   Hidden:0, Width:80,  Align:"Center", ColMerge:0,  SaveName:"jikgubNm",       Edit:0},

			{Header:"요청인원|요청인원",Type:"Int",    Hidden:0, Width:80,  Align:"Center", ColMerge:0,  SaveName:"reqCnt",         Edit:0 },

			//Hidden
			{Header:"applInSabun",  Type:"Text",   Hidden:1, Width:80 , Align:"Center", ColMerge:0,  SaveName:"applInSabun"},
			{Header:"applSeq",      Type:"Text",   Hidden:1, Width:80 , Align:"Center", ColMerge:0,  SaveName:"applSeq"}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("ibsImage", 1);

		// 처리상태
		var applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getApplStatusCdList&applStatusNotCd=11,"), "전체");
		sheet1.SetColProperty("applStatusCd", 	{ComboText:applStatusCd[0], ComboCode:applStatusCd[1]} );

		$("#applStatusCd").html(applStatusCd[2]);
		
		$("#sYmd").datepicker2({startdate:"eYmd"});
		$("#eYmd").datepicker2({enddate:"sYmd"});
		
		$("#orgNm,#name,#sYmd,#eYmd").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});

		$("#applStatusCd").bind("change",function(event){
			doAction1("Search");
			$(this).focus();
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});


	function chkInVal() {
		if ($("#sYmd").val() != "" && $("#eYmd").val() != "") {
			if (!checkFromToDate($("#sYmd"),$("#eYmd"),"신청일자","신청일자","YYYYMMDD")) {
				return false;
			}
		}

		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal()) {break;}
			if($("#sYmd").val() == "") {
				alert("시작일자를 입력하여 주십시오.");
				$("#sYmd").focus();
				return;
			}
			if($("#eYmd").val() == "") {
				alert("종료일자를 입력하여 주십시오.");
				$("#eYmd").focus();
				return;
			}

			var param = "sYmd="+$("#sYmd").val().replace(/-/gi,"")
						+"&eYmd="+$("#eYmd").val().replace(/-/gi,"")
						+"&orgNm="+encodeURIComponent($("#orgNm").val())
						+"&applStatusCd="+$("#applStatusCd").val()
						+"&name="+encodeURIComponent($("#name").val());

			sheet1.DoSearch( "${ctx}/OrgCapaPlanApr.do?cmd=getOrgCapaPlanAprList",param );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
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

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}


	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
		    if( sheet1.ColSaveName(Col) == "ibsImage" 	&& Row >= sheet1.HeaderRows() ) {

		    	var applSabun = sheet1.GetCellValue(Row,"applSabun");
	    		var applSeq = sheet1.GetCellValue(Row,"applSeq");
	    		var applInSabun = sheet1.GetCellValue(Row,"applInSabun");
	    		var applYmd = sheet1.GetCellValue(Row,"applYmd");

	    		showApplPopup("R",applSeq,applSabun,applInSabun,applYmd);
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	//신청 팝업
	function showApplPopup(auth,seq,applSabun,applInSabun,applYmd) {
		if(!isPopup()) {return;}

		if(auth == "") {
			alert("권한을 입력하여 주십시오.");
			return;
		}

		var p = {
				searchApplCd: '141'
			  , searchApplSeq: seq
			  , adminYn: 'Y'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: applSabun
			  , searchApplYmd: applYmd
			  , etc01: "1"
			};
		var url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
		var initFunc = 'initResultLayer';
		pGubun = "viewApprovalMgrResult";
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '인력충원요청',
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {
						doAction1("Search");
					}
				}
			]
		});
		approvalMgrLayer.show();
	}

	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function rdPopup(){
		if(!isPopup()) {return;}

  		var w 		= 800;
		var h 		= 700;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음

		if(sheet1.CheckedRows("ibsCheck") == 0) {
			alert("출력할 데이터를 선택하여 주십시오.");
			return;
		}


		 var sRow = sheet1.FindCheckedRow("ibsCheck");
			var arrRow = [];

			$(sRow.split("|")).each(function(index,value){
				arrRow[index] = sheet1.GetCellValue(value,"applSeq");
			});
			var searchSabun = "(";
			for(var i=0; i<arrRow.length; i++) {
		        if(i != 0) searchSabun += ",";
		        searchSabun += "'"+arrRow[i]+"'";
		    }
			searchSabun += ")";

		var rdMrd   = "org/capacity/orgCapaPlanApr/orgCapaPlanReport.mrd";
		var rdTitle = "인력충원요청서";
		var rdParam = "";

		rdParam  = rdParam +"[${ssnEnterCd}] "; //회사코드
        rdParam  = rdParam +"["+searchSabun+"] "; //사번
        rdParam  = rdParam +"[${baseURL}]";//이미지위치---3

        var imgPath = " " ;
		args["rdTitle"] = rdTitle ;	//rd Popup제목
		args["rdMrd"] =  rdMrd;		//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = rdParam;	//rd파라매터
		args["rdParamGubun"] = "rp";//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;	//툴바여부
		args["rdZoomRatio"] = "100";//확대축소비율

		args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "Y" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF

		pGubun == "rdPopup";

		openPopup(url,args,w,h);//알디출력을 위한 팝업창
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th>신청일자</th>
				<td>
					<input id="sYmd" name="sYmd" type="text" size="10" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-7)%>"/> ~
					<input id="eYmd" name="eYmd" type="text" size="10" class="date2 required" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
				</td>
				<th>결제상태</th>
				<td >
					<select id="applStatusCd" name="applStatusCd">
					</select>
				</td>
			</tr>
			<tr>
				<th>소속</th>
				<td >
					<input id="orgNm" name="orgNm" type="text" class="text" />
				</td>
				<th>성명/사번</th>
				<td>
					<input id="name" name="name" type="text" class="text"/>
				</td>
				<td>
					<%-- <btn:a href="javascript:doAction1('Search')" 	css="basic authR" mid='search' mdef="조회"/> --%>
					<!-- 조회 버튼 css 스타일에 맞게 수정. 2023.10.27 snow2  -->
					<btn:a href="javascript:doAction1('Search')" 	css="btn dark" mid='search' mdef="조회"/>
				</td>
			</tr>
			</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">인력충원계획승인</li>
			<li class="btn">
			<%--
				<a href="javascript:rdPopup();" class="basic authA">출력</a>
				--%>
				<a href="javascript:doAction1('Down2Excel');" class="btn outline-gray authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "kr"); </script>
</div>
</body>
</html>
