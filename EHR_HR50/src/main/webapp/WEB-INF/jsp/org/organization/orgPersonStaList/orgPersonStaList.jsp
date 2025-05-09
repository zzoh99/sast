<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:7,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [

			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",   Hidden:1,                   Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",   Hidden:1,                   Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='detail_V4398' mdef='인사카드'/>",	Type:"Image",     	Hidden:0,  Width:40,   Align:"Center",  	ColMerge:0,   SaveName:"detail", 			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10,	Cursor:"Pointer" },
			{Header:"<sht:txt mid='photoV1' mdef='사진'/>",		Type:"Image",   Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"photo",       UpdateEdit:0, ImgWidth:50, ImgHeight:60 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",    Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"sabun",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",    Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"name",        KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",	Type:"Text",    Hidden:Number("${aliasHdn}"),   Width:70,   Align:"Center", ColMerge:0, SaveName:"alias",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",		Type:"Text",    Hidden:0,   Width:140,  Align:"Center", ColMerge:0, SaveName:"orgNm",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",    Hidden:0,   Width:90,   Align:"Center", ColMerge:0, SaveName:"jikchakNm",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",    Hidden:Number("${jwHdn}"),   Width:80,   Align:"Center", ColMerge:0, SaveName:"jikweeNm",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",		Type:"Text",    Hidden:Number("${jgHdn}"),   Width:80,   Align:"Center", ColMerge:0, SaveName:"jikgubNm",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='officeTelV1' mdef='사내전화'/>",	Type:"Text",    Hidden:0,   Width:90,   Align:"Center", ColMerge:0, SaveName:"officeTel",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='handPhoneV2' mdef='핸드폰'/>",		Type:"Text",    Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"handPhone",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='connectTel' mdef='비상연락망'/>",	Type:"Text",    Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"connectTel",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='mailIdV2' mdef='E-MAIL'/>",	Type:"Text",    Hidden:0,   Width:200,  Align:"Center", ColMerge:0, SaveName:"mailId",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='fileYnV1' mdef='등록여부'/>",	Type:"Text",    Hidden:1,   Width:100,  Align:"Center", ColMerge:0, SaveName:"fileYn",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, Cursor:"Pointer" },
			{Header:"<sht:txt mid='photoIndex' mdef='사진인덱스'/>",	Type:"Text",    Hidden:1,   Width:170,  Align:"Center", ColMerge:0, SaveName:"photoIndex",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
			{Header:"<sht:txt mid='enterCd_V6917' mdef='회사코드'/>",	Type:"Text",    Hidden:1,   Width:170,  Align:"Center", ColMerge:0, SaveName:"enterCd",		  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
			{Header:"<sht:txt mid='photoSrc' mdef='사진파일'/>",	Type:"Text",    Hidden:1,   Width:170,  Align:"Center", ColMerge:0, SaveName:"photoSrc",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
			{Header:"rk",			Type:"Text",	Hidden:1,	 	SaveName:"rk",		}
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}"); sheet1.SetEditableColorDiff(0); //편집불가 상관없이 기본색상 출력
		sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");


		$("#searchRetSYmd").datepicker2({startdate:"searchRetEYmd"});
		$("#searchRetEYmd").datepicker2({enddate:"searchRetSYmd"});

		$("input[id='statusCd']").click(function(){
			if($(this).val() == "RA") {
				$(".hdnYmd").hide();
			} else {
				$(".hdnYmd").show();
			}
		});

		$("#searchJikchakChb").click(function() {
			doAction1("Search");
		});

		$("#searchPhotoYn").click(function() {
			doAction1("Search");
		});

		$("#searchPhotoYn").attr('checked', 'checked');

		$("#searchOrgNm,#searchName,#searchJikchakYn").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		/* 다운로드시 페이지 랜더링(화면에 올림)을 하기 위하여 자동 Row높이설정을 false로 준다. */
		sheet1.SetAutoRowHeight(0);
		sheet1.SetDataRowHeight(60);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}
			$("#searchJikchakChb").is(":checked") == true ? $("#searchJikchakYn").val("Y")  : $("#searchJikchakYn").val("N") ;

			sheet1.DoSearch( "${ctx}/OrgPersonStaList.do?cmd=getOrgPersonStaListList", $("#srchFrm").serialize() ); break;

		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
		break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") {
				alert(Msg);
			}

			if($("#searchPhotoYn").is(":checked") == true){
				sheet1.SetDataRowHeight(60);
				sheet1.SetColHidden("photo", 0);

			}else{
				sheet1.SetDataRowHeight(24);
				sheet1.SetColHidden("photo", 1);
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			   if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
				   rdPopLayer(Row) ;
		    	}
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}


	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function rdPopup(Row){
		if(!isPopup()) {return;}

		var enterCdSabun = "";
		var searchSabun = "''";

		enterCdSabun += ",('" + sheet1.GetCellValue(Row,"enterCd") +"','" + sheet1.GetCellValue(Row,"sabun") + "')";

		var viewYn1 = "";
		var viewYn2 = "";
		var viewYn3 = "";
		var viewYn4 = "";
		//var viewYn5 = "";

		var rdMrd = "";
		var rdTitle = "";
		var rdParam = "";

		var ssnEnter_cd = '${ssnEnterCd}';
		//rdMrd   = "hrm/empcard/PersonInfoCard_HR.mrd";
		rdMrd   = "hrm/empcard/PersonInfoCardType2_HR.mrd";

		rdTitle = "인사카드";

		if(viewYn4 == "Y"){//전체발령 체크시는 일반체크시+전체발령
			viewYn2 = "Y";
		}

		/*
		rdParam  += "["+ enterCdSabun +"]"; //회사코드, 사번
		rdParam  += "[${baseURL}]";//이미지위치---3
		rdParam  += "["+ viewYn1 +"]"; //타사발령체크여부
		rdParam  += "["+ viewYn2 +"]"; //일반체크
		rdParam  += "["+ viewYn3 +"]"; //연봉체크
		rdParam  += "["+ viewYn4 +"]"; //전체발령체크
		rdParam  += "[]"; //출력옵션
		rdParam  += "[${ssnEnterCd}]";
		rdParam  += "[ '${ssnSabun}' ]";//rdParam  += "["+searchSabun+"]"; // 사번list->세션사번으로 변경(2016.04.14)
		*/
		
        rdParam += "[,('${ssnEnterCd}','" + sheet1.GetCellValue(Row,"sabun") + "')]";  // 1.회사코드 및 사번
        rdParam += "[${baseURL}]";  // 2.이미지 url---3
		rdParam += "[Y]"; //개인정보 마스킹
		rdParam += "[Y]"; //인사기본1
		rdParam += "[Y]"; //인사기본2
		rdParam += "[Y]"; //발령사항
		rdParam += "[Y]"; //교육사항
		rdParam += "[Y]"; // 전체발령체크
        rdParam += "[${ssnEnterCd}]";  // 8.회사코드
        rdParam += "['${ssnSabun}']";  // 9.출력자 사번 어레이
        rdParam += "[${ssnLocaleCd}] ";	// 10.다국어코드
        rdParam += "['${ssnSabun}'] "; //사번
		rdParam += "[Y] "; //평가
		rdParam += "[Y] "; //타부서발령포함
		//신규 화면 제어 파라미터들
		rdParam += "[Y] "; //연락처
		rdParam += "[Y] "; //병역
		rdParam += "[Y] "; //학력
		rdParam += "[Y] "; //경력
		rdParam += "[Y] "; //포상
		rdParam += "[Y] "; //징계
		rdParam += "[Y] "; //자격
		rdParam += "[Y] "; //어학
		rdParam += "[Y] "; //가족
		rdParam += "[Y] "; //발령
		rdParam += "[Y] "; //직무
		
		var w 		= 900;
		var h 		= 1250;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();

		args["rdTitle"] = rdTitle ;	//rd Popup제목
		args["rdMrd"] =  rdMrd;		//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = rdParam;	//rd파라매터
		args["rdParamGubun"] = "rp";//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;	//툴바여부
		args["rdZoomRatio"] = "110";//확대축소비율

		args["rdSaveYn"] 	= "N" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "N" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "N" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "N" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "N" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "N" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "N" ;//기능컨트롤_PDF
		args["rdPrintPdfYn"]= "N" ;//기능컨트롤_PDF인쇄


		pGubun = "rdPopup";
		var win = openPopup(url,args,w,h);//알디출력을 위한 팝업창

	}

	function rdPopLayer(Row) {
		const data = {
			rk : sheet1.GetCellValue(Row,"rk")
		};
		window.top.showRdLayer('/OrgPersonStaList.do?cmd=getEncryptRd', data, null, '인사카드');
	}

	function chkInVal() {
		if( $("#searchRetSYmd").val() != "" && $("#searchRetEYmd").val() != "" ){
			var _chk = checkFromToDate($("#searchRetSYmd"), $("#searchRetEYmd"), "퇴직일자", "퇴직일자", "YYYYMMDD");
			return _chk;
		}
		return true;
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<div class="sheet_search outer">
		<div>
		<table>
			<tr>
				<th><tit:txt mid='104279' mdef='소속'/>  </th>
				<td>   <input id="searchOrgNm" name="searchOrgNm" type="text" class="text" /> </td>
				<th><tit:txt mid='103880' mdef='성명'/>  </th>
				<td>   <input id="searchName" name="searchName" type="text" class="text" /> </td>
				<th><tit:txt mid='112988' mdef='사진포함여부'/>  </th>
				<td>  <input id="searchPhotoYn" name="searchPhotoYn" type="checkbox"  class="checkbox" /></td>
				<th class="hide"><tit:txt mid='113553' mdef='직책자'/>  </th>
				<td class="hide">  <input id="searchJikchakChb" name="searchJikchakChb" type="checkbox"  class="checkbox" />
					<input id="searchJikchakYn" name="searchJikchakYn" type="hidden" value="" />
				</td>
				<td>
					<input id="statusCd" name="statusCd" type="radio" value="RA" checked><tit:txt mid='113521' mdef='퇴직자 제외'/>
					<input id="statusCd" name="statusCd"  type="radio" value="" ><tit:txt mid='114221' mdef='퇴직자 포함'/>
				</td>
				<th class="hdnYmd" style="display:none;"><tit:txt mid='113397' mdef='퇴직일자'/></th>
				<td class="hdnYmd" style="display:none;">
					<input id="searchRetSYmd" name="searchRetSYmd" type="text" class="date2" style="width:60px"> ~
					<input id="searchRetEYmd" name="searchRetEYmd" type="text" class="date2" style="width:60px">
				</td>
			 	<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='113565' mdef='조직원정보(조직장)'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
