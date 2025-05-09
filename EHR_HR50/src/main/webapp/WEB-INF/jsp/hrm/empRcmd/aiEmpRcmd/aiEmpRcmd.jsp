
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<link rel="stylesheet" type="text/css" href="/assets/css/talent_AI.css?2024090204"/>
<script type="text/javascript" src="/common/js/cookie.js"></script>
<script type="text/javascript">
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:5};
		initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>", Type:"${sNoTy}", Hidden:Number("${sNoHdn}"),	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			<%--{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0},--%>
			<%--{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0},--%>
			{Header:"<sht:txt mid='orgNm' mdef='부서명'/>",			Type:"Text",		Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, },
			{Header:"<sht:txt mid='sabun' mdef='사번'/>",			Type:"Text",		Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, },
			{Header:"<sht:txt mid='name' mdef='성명'/>",				Type:"Text",		Hidden:0,					Width:30,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, },
			{Header:"<sht:txt mid='jobNm' mdef='직무명'/>",			Type:"Text",		Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"jobNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, },
			{Header:"<sht:txt mid='jobCd' mdef='NCS직무코드'/>",		Type:"Text",		Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"rGubun",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, },
			{Header:"<sht:txt mid='check' mdef='선택'/>",			Type:"DummyCheck",  Hidden:0,   				Width:30,           Align:"Center", ColMerge:0, SaveName:"checkYn",       KeyField:0, Format:"",  	PointCount:0,   			UpdateEdit:1,   InsertEdit:0,   EditLen:100, },
			{Header:"<sht:txt mid='scoreHtml' mdef='점수'/>",		Type:"Html",		Hidden:0,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"scoreHtml",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, },
			{Header:"<sht:txt mid='score' mdef='점수'/>",			Type:"Text",		Hidden:1,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"score",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, },
			{Header:"<sht:txt mid='res' mdef='결과'/>",				Type:"Text",		Hidden:0,					Width:30,			Align:"Center",	ColMerge:0,	SaveName:"res",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,		UpdateEdit:0,	InsertEdit:0,	EditLen:1,	EditLen:100 },

			{Header:"<sht:txt mid='des' mdef='DESC'/>",				Type:"Text",		Hidden:1,					Width:200,			Align:"Center",	ColMerge:0,	SaveName:"des",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1,	EditLen:1000 },
			{Header:"<sht:txt mid='strengths' mdef='상세내용'/>",	Type:"Text",		Hidden:1,					Width:200,			Align:"Center",	ColMerge:0,	SaveName:"strengths",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1,	EditLen:1000 },
			{Header:"<sht:txt mid='weaknesses' mdef='상세내용'/>",	Type:"Text",		Hidden:1,					Width:200,			Align:"Center",	ColMerge:0,	SaveName:"weaknesses",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1,	EditLen:1000 },
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",	Type:"Image",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"detail",	KeyField:0, CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='part' mdef='part'/>",			Type:"Text",		Hidden:1,					Width:30,			Align:"Center",	ColMerge:0,	SaveName:"part",	KeyField:0, CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:5000 },
			{Header:"<sht:txt mid='rGubun' mdef='인재추천구분'/>",	Type:"Text",		Hidden:1,					Width:0,			Align:"Center",	ColMerge:0,	SaveName:"rGubun",	KeyField:0, CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='rType' mdef='직무'/>",			Type:"Text",		Hidden:1,					Width:0,			Align:"Center",	ColMerge:0,	SaveName:"rType",	KeyField:0, CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		];
		IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);
		sheetInit();
		$(window).smartresize(sheetResize);
		//콤보박스
		var result = convCode( codeList("/AiEmpRcmd.do?cmd=getAiEmpRcmdGubunList"), "<tit:txt mid='111914' mdef='선택'/>");
		$("#empRcmdType").html(result[2]);
		$("#rGubun").html(result[2]);

		$("#searchNm").on("keyup",function(event){
			if(event.keyCode == 13) {
				doAction1("Search");
			}
		});

		$('#activeRcmdBtn').hide();
		$('#rcmdBtn').show();

		//쿠키 데이터 적용 및 쿠키 삭제
		if(getCookie('empRcmdType')){
			//쿠키 적용 조회
			const empRcmdType = getCookie('empRcmdType');
			const jobCd = getCookie('jobCd');
			const jobNm = getCookie('jobNm');
			$('#empRcmdType option[value="'+empRcmdType+'"]').attr('selected', true);
			$('#jobCd').val(jobCd);
			$('#jobNm').val(jobNm);
			doAction1("Search");

			//쿠키 삭제
			setCookie('empRcmdType', '');
			setCookie('jobCd', '');
			setCookie('jobNm', '');
		}
	});

	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				if($('#empRcmdType :selected').val() == ''){
					alert('인재추천구분을 선택해주세요.');
					return;
				}
				if($('#jobCd').val()== ''){
					alert('직무 선택해주세요.');
					return;
				}

				$('#activeRcmdBtn').show();
				$('#rcmdBtn').hide();
				sheet1.DoSearch( "${ctx}/AiEmpRcmd.do?cmd=getEmpListList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave("${ctx}/AiEmpRcmd.do?cmd=saveAiEmpRcmdMgrType", $("#sheet1Form").serialize() );
				break;
			case "Insert":      sheet1.SelectCell(sheet1.DataInsert(0), 2); break;
			case "Copy":		sheet1.DataCopy();break;
		}
	}

	// LEFT 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			//도넛 차트 태그 입력
			for(var r = sheet1.HeaderRows(); r<sheet1.RowCount()+sheet1.HeaderRows(); r++) {
				let html = '';
				const score = sheet1.GetCellValue(r, "score");

				if(score >= 0){
					html += '<div class="chart-wrap">';
					html += '	<span class="cnt" id="score">' + score + '</span>';
					html += '	<div id="area_chart"><div class="donut-chart" style="background: conic-gradient(#2570f9 0% ' + score + '%, #d6d6d6 ' + score + '% 100%);"><div class="donut-hole"></div></div></div>';
					html += '</div>';
					sheet1.SetCellValue(r, "scoreHtml", html);
				}
			}
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// RIGHT 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		if(sheet1.ColSaveName(NewCol) == "checkYn"){
			sheet1.SelectCell(OldRow, OldCol)
		}
		if( OldRow != NewRow && sheet1.ColSaveName(OldCol) != "checkYn" && sheet1.ColSaveName(NewCol) != "checkYn") {
			var score = sheet1.GetCellValue(NewRow, "score");
			$('#rGubun').val(sheet1.GetCellValue(NewRow, "rGubun"));
			$('#rType').val(sheet1.GetCellValue(NewRow, "rType"));
			$('#sabun').val(sheet1.GetCellValue(NewRow, "sabun"));
			$('#des').html(sheet1.GetCellValue(NewRow, "des"));
			$('#det').html(sheet1.GetCellValue(NewRow, "det"));
			$('#name').html(sheet1.GetCellValue(NewRow, "name"));
			$('#orgNm').html(sheet1.GetCellValue(NewRow, "orgNm"));
			$('#team').html(sheet1.GetCellValue(NewRow, "jobNm"));
			$('#res').html(sheet1.GetCellValue(NewRow, "res"));
			$('.talent-box #score').html(score+"%");

			//적합도
			let html = '';
			html += '<span class="label">적합도</span>';
			html += '<span class="cnt">'+score+'점</span>';
			html += '<div id="area_chart">';
			html += '	<div class="donut-chart big" style="background: conic-gradient(#2570f9 0% '+score+'%, #d6d6d6 '+score+'% 100%);">';
			html += '		<div class="donut-hole"></div>';
			html += '	</div>';
			html += '</div>';
			$('.talent-box .chart-wrap').html(html);

			//전체 내용
			let totDetHtml = '';
			totDetHtml += '<div class="title">전체 내용</div>';
			totDetHtml += '<div class="desc">' + sheet1.GetCellValue(NewRow, "des") + '</div>';
			$('#totDet').html(totDetHtml);

			let desHtml = '';
			desHtml += '<div class="des">';
			desHtml += '	<div class="desc-wrap streng">';
			desHtml += '		<span class="chip"><i class="mdi-ico">thumb_up</i>강점</span>';
			desHtml += '		<p class="desc">'+sheet1.GetCellValue(NewRow, "strengths")+'</p>';
			desHtml += '	</div>';
			desHtml += '</div>';
			desHtml += '<div class="det divider">';
			desHtml += '	<div class="desc-wrap weak">';
			desHtml += '		<span class="chip"><i class="mdi-ico">sentiment_very_dissatisfied</i>약점</span>';
			desHtml += '		<p class="desc">'+sheet1.GetCellValue(NewRow, "weaknesses")+'</p>';
			desHtml += '	</div>';
			desHtml += '</div>';
			// desc-wrap
			$('.desc-wrap').html(desHtml);

			//part data
			getAiEmpRcmdPart();

			$('.sheet_right').show();
		}
	}

	function sheet1_OnClick(Row, Col, Value) {

	}

	function sheet1_OnPopupClick(Row, Col){
		try{
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	function sheet1_OnChange(Row, Col, Value){
		try {
		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function getAiEmpRcmdPart(){
		var partList = ajaxCall( "${ctx}/AiEmpRcmd.do?cmd=getAiEmpRcmdPart",$("#sheet1Form").serialize(),false);

		console.log(partList);
		// <!-- score-item 반복 단위 시작 -->
		let html = '';
		$.each(partList.DATA, function(idx, part) {
			html += '<div class="score-item">';
			html += '	<div class="item-header">';
			console.log(part)
			console.log(part.icon)
			console.log(part.type)
			console.log(part.preview)
			if(part.icon){
				html += part.preview;
			}else{
				if(part.type == '평가') html += '<i class="mdi-ico">assignment_ind</i>';
				if(part.type == '자격증') html += '<i class="mdi-ico">badge</i>';
				if(part.type == '경력') html += '<i class="mdi-ico">business_center</i>';
				if(part.type == '학력') html += '<i class="mdi-ico">school</i>';
				if(part.type == '징계') html += '<i class="mdi-ico">supervised_user_circle</i>';
				if(part.type == '교육') html += '<i class="mdi-ico">history_edu</i>';
				if(part.type == '해외') html += '<i class="mdi-ico">flight</i>';
				if(part.type == '언어') html += '<i class="mdi-ico">language</i>';
			}
			html += '		<span class="score-title">' + part.type + '</span>';
			// html += '		<a href="#" class="btn-more">더보기<i class="mdi-ico">chevron_right</i></a>';
			html += '	</div>';
			html += '	<div class="score-desc">';
			html += '		<div>';
			html += '			<span class="score">' + part.score + '</span>';
			html += '			<span class="unit">점</span>';
			html += '		</div>';
			html += '		<div class="cnt-wrap">';
			html += '			<span class="cnt">/ ' + part.weight + '</span>';
			// html += '			<span class="desc">반영</span>';
			html += '		</div>';
			html += '	</div>';
			html += '	<ul class="desc-list">';
			html += '		<li>';
			html += '			<span class="score-label">DESC</span>';
			html += '			<p class="score-desc">' + part.description + '</p>';
			html += '		</li>';
			html += '		<li>';
			html += '			<span class="score-label">강점</span>';
			html += '			<p class="score-desc">' + part.strengths + '</p>';
			html += '		</li>';
			html += '		<li>';
			html += '			<span class="score-label">약점</span>';
			html += '			<p class="score-desc">' + part.weaknesses + '</p>';
			html += '		</li>';
			html += '	</ul>';
			html += '</div>';
		})
		// <!-- score-item 반복 단위 끝 -->
		$('.score-box').html(html);
	}

	function requestApi(){
		var sRow = sheet1.FindCheckedRow("checkYn");
		if( sRow == "" ){
			alert("대상을 선택 해주세요.");
			return;
		}
		if( $('#rGubun').val() == "" ){
			alert("인재추천구분을 선택 해주세요.");
			return;
		}
		if( $('#jobCd').val() == "" ){
			alert("직무를 선택 해주세요.");
			return;
		}

		var arrRows = sRow.split("|");
		var sabuns = [];
		for( var i = 0; i < arrRows.length ; i++ ) {
			var row = arrRows[i];
			sabuns.push(sheet1.GetCellValue(row, "sabun"));
		}
		$('#sabuns').val(sabuns);

		//prompt 안내 layer
		var args 	= new Array();
		args['rGubun'] = $('#empRcmdType :selected').val();
		args['jobCd'] = $('#jobCd').val();
		args['jobNm'] = $('#jobNm').val();
		let layerModal = new window.top.document.LayerModal({
			id : 'aiEmpRcmdPromptLayer'
			, url : '/AiEmpRcmd.do?cmd=viewAiEmpRcmdPromptLayer'
			, parameters : args
			, width : 600
			, height : 400
			, title : '요청 프롬프트'
			, trigger :[
				{
					name : 'aiEmpRcmdPromptLayerTrigger'
					, callback : function(result){
						console.log(result)
						//action!!!
						$('#prompt').val(result)
						var dataList = ajaxCall("${ctx}/AiEmpRcmd.do?cmd=getAiEmpRcmd", $("#sheet1Form").serialize(), false);
						alert('AI추천 요청 되었습니다.');
					}
				}
			]
		});
		layerModal.show();

	}

	function deleteAiEmpRcmd(){
		var sRow = sheet1.FindCheckedRow("checkYn");
		if( sRow == "" ){
			alert("대상을 선택 해주세요.");
			return;
		}
		if( $('#rGubun').val() == "" ){
			alert("인재추천구분을 선택 해주세요.");
			return;
		}
		if( $('#jobCd').val() == "" ){
			alert("직무를 선택 해주세요.");
			return;
		}

		var arrRows = sRow.split("|");
		var sabuns = [];
		for( var i = 0; i < arrRows.length ; i++ ) {
			var row = arrRows[i];
			sabuns.push(sheet1.GetCellValue(row, "sabun"));
		}
		$('#sabuns').val(sabuns);

		//action!!!
		var dataList = ajaxCall("${ctx}/AiEmpRcmd.do?cmd=deleteAiEmpRcmd", $("#sheet1Form").serialize(), false);
		doAction1('Search')
	}

	function showApplPopup(Row) {
		var args 	= new Array();
		let layerModal = new window.top.document.LayerModal({
			id : 'aiEmpRcmdLayer'
			, url : '/AiEmpRcmd.do?cmd=viewAiEmpRcmdLayer'
			, width : 600
			, height : 800
			, title : '직무 검색'
			, trigger :[
				{
					name : 'aiEmpRcmdLayerTrigger'
					, callback : function(result){
						$('#jobNm').val(result.jobNm);
						$('#jobCd').val(result.jobCd);
					}
				}
			]
		});
		layerModal.show();
	}

	function showEmpRcmdSelPopup(){
		if($('#empRcmdType :selected').val() == ''){
			alert('인재추천구분을 선택해주세요.');
			return;
		}
		if($('#jobCd').val()== ''){
			alert('직무 선택해주세요.');
			return;
		}
		var args 	= new Array();
		args['rGubun'] = $('#empRcmdType :selected').val();
		args['rType'] = $('#jobCd').val();
		let layerModal = new window.top.document.LayerModal({
			id : 'aiEmpRcmdSelLayer'
			, url : '/AiEmpRcmd.do?cmd=viewAiEmpRcmdSelLayer'
			, parameters : args
			, width : 1600
			, height :1000
			, title : '대상자 선택',
			trigger: [
				{
					name: 'aiEmpRcmdSelLayerTrigger',
					callback: function(rv) {
						doAction1("Search");
					}
				}
			]
		});
		layerModal.show();
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="sabuns" name="sabuns" value="" />
		<input type="hidden" id="rGubun" name="rGubun" value="" />
		<input type="hidden" id="rType" name="rType" value="" />
		<input type="hidden" id="sabun" name="sabun" value="" />
		<input type="hidden" id="prompt" name="prompt" value="" />
		<div class="sheet_title">
			<ul>
				<li id="txt2" class="txt"><sch:txt mid='aiEmpRcmd' mdef='AI인재추천'/></li>
			</ul>
		</div>
		<div class="sheet_search">
			<table>
				<colgroup>
<%--					<col width="9%">--%>
<%--					<col width="27%">--%>
<%--					<col width="9%">--%>
<%--					<col width="30%">--%>
					<col width="116px">
					<col width="290px">
					<col width="84px">
					<col width="314px">
					<col width="*">
				</colgroup>
				<tr>
					<th><sch:txt mid='empRcmdType' mdef='인재추천구분'/></th>
					<td>
						<select id="empRcmdType" name="empRcmdType" class="custom_select" style="width: 160px;">
							<%--									<option ><sch:txt mid='all' mdef='전체'/> </option>--%>
						</select>
					</td>
					<th><sch:txt mid='empRcmdType' mdef='직무'/></th>
					<td>
						<input id="jobNm" name="jobNm" type="text" class="text w70p readonly" readonly/>
						<input id="jobCd" name="jobCd" type="hidden" class="text"/>
						<a href="javascript:showApplPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						<btn:a href="javascript:doAction1('Search');" id="srchBtn" mid="110697" mdef="조회" css="button"/>
					</td>
					<td></td>
				</tr>
			</table>
		</div>
	</form>

	<table class="sheet_main">
		<colgroup>
			<col width="36%"/>
			<col width="64%"/>
		</colgroup>
		<tr>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="btn">
								<btn:a href="javascript:deleteAiEmpRcmd();" mid="110763" mdef="삭제" css="btn outline-gray authA"/>
								<btn:a id="empSel" href="javascript:showEmpRcmdSelPopup();"    mid='mepSel'  mdef="대상자 선택" css="btn outline_gray authA" />
								<btn:a id="activeRcmdBtn" href="javascript:requestApi();"    mid='aiRcmd'  mdef="AI추천" css="btn filled authA" />
								<btn:a id="rcmdBtn" href="javascript:alert('인재 추천 검색 후 활성화됩니다.');"    mid='aiRcmd'  mdef="AI추천" css="btn outline_gray authA" />
							</li>
						</ul>
					</div>
				</div>
				<!-- 시트 들어갈 자리 -->
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>

			<td class="sheet_right" style="display: none">
				<div class="talent-box">
					<div class="header">
						<div>
							<span class="name"id="name"></span>
							<span class="position"id="team"></span>
							<span class="divider team" id="orgNm"></span>
							<span class="rec-chip" id="res"></span>
						</div>
						<div class="chart-wrap"></div>
					</div>
					<div class="body">

						<div class="score-wrap" id="totDet">
						</div>
						<div class="desc-wrap">
<%--							<div class="des"">--%>
<%--							</div>--%>
<%--							<div class="det divider">--%>
<%--							</div>--%>
						</div>
						<div class="score-wrap">
							<div class="title">전체 평가 점수</div>
							<p class="desc">지원자의 전체 평가 점수 내용입니다. 상세내용을 확인해주세요.</p>
							<div class="score-box"></div>
						</div>
					</div>
				</div>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
