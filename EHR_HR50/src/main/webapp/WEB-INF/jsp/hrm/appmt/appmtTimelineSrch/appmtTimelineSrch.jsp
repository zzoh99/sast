<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='114628' mdef='인사기본(발령내역수정)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->

<!-- Custom Theme Style -->
<link href="${ ctx }/common/css/cmpEmp/custom.min.css" rel="stylesheet">
<link href="${ ctx }/common/css/cmpEmp/isu_dashboard.css" rel="stylesheet">	

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<link rel="stylesheet" type="text/css" href="${ ctx }/common/plugin/Blueprints/css/component.css" />

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var enterCd = "${ssnEnterCd}";
	
	$(function() {

		$("#searchFrom").datepicker2({startdate:"searchTo"});
		$("#searchTo").datepicker2({enddate:"searchFrom"});

		//종료일 2개월 더하기
		$("#searchFrom").val(addDate("m", -12,"${curSysYyyyMMdd}", "-"));

		$("#searchFrom, #searchTo").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:7,DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"일자",		Type:"Text",	Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"ordYear",		KeyField:1,	Format:"",	PointCount:0,	Edit:0 },
			{Header:"일자",		Type:"Text",	Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"ordYmd",		KeyField:1,	Format:"",	PointCount:0,	Edit:0 },
			{Header:"일자",		Type:"Text",	Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"ordMd",		KeyField:1,	Format:"",	PointCount:0,	Edit:0 },
			{Header:"발령총건수",	Type:"Int",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"totalCnt",	KeyField:1,	Format:"",	PointCount:0,	Edit:0 },
			{Header:"발령제목",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"title",		KeyField:1,	Format:"",	PointCount:0,	Edit:0 },
			{Header:"발령요약",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordSummary",	KeyField:1,	Format:"",	PointCount:0,	Edit:0 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var userCd1 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdList",false).codeList, ("${ssnLocaleCd}" != "en_US" ? "<tit:txt mid='103895' mdef='전체'/>" : "All"));	//발령종류

		$('#ordDetailCd').html(userCd1[2]);
		
		$(window).smartresize(boxResize);
		boxResize();
		
		doAction1("Search");
	});
	
	// 박스 리사이즈
	function boxResize() {
		var outer_height = getOuterHeight();
		var inner_height = 0;
		var value = 0;
		var box = $("#timelineBox, #timelineBox .list_box");
		
		inner_height = getInnerHeight(box);
		value = ($(window).height() - outer_height) - inner_height- 60;
		if (value < 100) value = 100;
		box.height(value);
		box.css({
			"max-height" : value + "px"
		})
		//alert("window : " + $(window).height() + ", inner_height : " + inner_height + " , outer_height : " + outer_height + ", value : " + value);
		
		clearTimeout(timeout);
		timeout = setTimeout(addTimeOut, 50);
	}

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			progressBar(true);
			
			var param = "searchFrom="+$("#searchFrom").val()
			+"&searchTo="+$("#searchTo").val()
			+"&ordDetailCd="+$("#ordDetailCd").val()
			+"&mainYn="+($("#mainYn").is(":checked")==true?"Y":"");
			
			sheet1.DoSearch( "${ctx}/AppmtTimelineSrch.do?cmd=getAppmtTimelineSrchList", param );
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		$("#timelineBox ul.cbp_tmtimeline").html("");
		progressBar(false);

		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			var html = "";
			if( sheet1.RowCount() > 0 ) {
				for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
					html += "<li>";
					html += "<time class=\"cbp_tmtime\" datetime=\"" + sheet1.GetCellValue(i, "ordMd") + "\"><span>" + sheet1.GetCellValue(i, "ordYear") + "</span> <span>" + sheet1.GetCellValue(i, "ordMd") + "</span></time>";
					html += "<div class=\"cbp_tmicon\"></div>";
					html += "<div class=\"cbp_tmlabel\" onclick=\"javascript:showOrdDetail('" + sheet1.GetCellValue(i, "ordYmd") + "');\">";
					html += "<h2>" + sheet1.GetCellValue(i, "title") + "</h2>";
					html += "<p class=\"mat15 f_s12\">";
					html += sheet1.GetCellValue(i, "ordSummary");
					if( Number(sheet1.GetCellValue(i, "totalCnt")) > 10 ) {
						html += "...외 " + (Number(sheet1.GetCellValue(i, "totalCnt")) - 10) + "건";
					}
					html += "</p>";
					html += "</div>";
					html += "</li>";
				}
			}
			
			if( html != "" ) {
				$("#timelineBox ul.cbp_tmtimeline").html(html);
			}
			
			// 상세내역이 없는 경우 첫번째 행 클릭 이벤트 실행.
			if( $("#detailList .card-profile").length == 0 ) {
				$(".cbp_tmlabel").eq(0).trigger("click");
			} 
			
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 발령내역 자세히 보기
	function showOrdDetail(ordYmd) {
		progressBar(true);
		
		try {
			var html = "";
			var data = ajaxCall("${ctx}/AppmtTimelineSrch.do?cmd=getAppmtTimelineSrchDetailList", $("#empForm").serialize() + "&ordYmd=" + ordYmd, false);
			//console.log('data', data);
			
			var item = null;
			if( data != null && data != undefined && data.DATA != null && data.DATA != undefined ) {
				for( var i = 0; i < data.DATA.length; i++) {
					item = data.DATA[i];
					
					html += "<div class=\'tile-stats card-profile\'>";
					html += "  <div class=\'profile_img \'>";
					html += "    <img src=\'/common/images/common/img_photo.gif\'  id='photo"+i+"\' alt=\'Avatar\' title=\'Change the avatar\'>";
					html += "  </div>";
					html += "  <div class=\'profile_info\'>";
					html += "    <p class=\'name\' id=\'tdName"+i+"\'>";
					html += "      <span class=\'gender\'>(<i class=\'fa fa-male\'></i> 남성)</span>";
					html += "    </p>";
					html += "   <ul class=\'profile_desc\'>";
					html += "      <li id=\'tdSabun"+i+"\'></li>";
					html += "      <li id=\'tdOrdDetailNm"+i+"\'></li>";
					html += "      <li id=\'tdJikweeNm"+i+"\'></li>";
					html += "      <li id=\'tdJikchakNm"+i+"\'></li>";
					html += "      <li id=\'tdOrgNm"+i+"\' class=\'full\'></li>";
					html += "    </ul>";
					html += "  </div>";
					html += "</div>";
				}
			}
			
			$("#detailList").html(html);
			
			/* 데이터 세팅 */
			if( data != null && data != undefined && data.DATA != null && data.DATA != undefined ) {
				for( var i = 0; i < data.DATA.length; i++) {
					item = data.DATA[i];
					
					setImgFile(item.sabun, i) ;
				 	$("#tdSabun"+i).html("사번 : " + item.sabun) ;
				 	$("#tdName"+i).html(item.name) ;
				 	$("#tdOrgNm"+i).html("소속 : " + item.orgNm) ;
				 	$("#tdOrdDetailNm"+i).html("발령 : " + item.ordDetailNm) ;
				 	$("#tdJikweeNm"+i).html("직위 : " + item.jikweeNm) ;
				 	$("#tdJikgubNm"+i).html(item.jikgubNm) ;
				 	$("#tdJikjongNm"+i).html("직종 : " + item.jikjongNm) ;
				 	$("#tdJikchakNm"+i).html("직책 : " + item.jikchakNm) ;
				}
			}
			
			progressBar(false);
		} catch (e) {
			progressBar(false);
			alert("showOrdDetail Event Error : " + ex);
		}
	}

	//사진파일 적용 by
	function setImgFile(sabun, i){
		$("#photo"+i).attr("src", "${ctx}/EmpPhotoOut.do?searchKeyword="+sabun);
	}
</script>
<style type="text/css">
	.sheet_search, .cbp_tmtimeline * {
		box-sizing:initial;
	}
	
	#detailList {
		background-color:#f7f7f7;
		padding:10px;
		border:1px solid #ebeef3;
		overflow-x:hidden;
		overflow-y:auto;
	}
</style>
</head>
<body class="bodywrap" style="background-color:#fff;">
<div class="wrapper">

	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
		<form id="empForm" name="empForm" >
		<!--
			<td>
				<span>기간</span>
				<input type="text" id="searchFrom" name="searchFrom" class="date2" value="">&nbsp;~&nbsp;
				<input type="text" id="searchTo" name="searchTo" class="date2" value="${curSysYyyyMMddHyphen}">
				<span><tit:txt mid='ordDetail' mdef='발령'/>
				
					<select id="ordDetailCd" name="ordDetailCd">
					</select>
				</span>
				<span>
					<tit:txt mid='mainYn' mdef='주요발령'/>
					<input id="mainYn" name="mainYn" type="checkbox" style="vertical-align:middle;" checked >
				</span>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search');" css="button" mid='110697' mdef="조회"/>
			</td>
	  	-->
			<th>기간</th>
			<td>
				<input type="text" id="searchFrom" name="searchFrom" class="date2" value="">&nbsp;~&nbsp;
				<input type="text" id="searchTo" name="searchTo" class="date2" value="${curSysYyyyMMddHyphen}">
			</td>
			<th><tit:txt mid='ordDetail' mdef='발령'/></th>
			<td><select id="ordDetailCd" name="ordDetailCd"></select></td>
			<th><tit:txt mid='mainYn' mdef='주요발령'/></th>
			<td><input id="mainYn" name="mainYn" type="checkbox" style="vertical-align:middle;" checked ></td>
			<td>
				<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='110697' mdef="조회"/>
			</td>
		</form>
		</tr>
		</table>
		</div>
	</div>
	
	<table id="timelineBox" border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="65%"/>
			<col width="35%"/>
		</colgroup>
		<tr>
			<td>
				<div class="sheet_title">
				<ul>
					<li class="txt">발령 Timeline</li>
					<li class="btn"></li>
				</ul>
				</div>
				<div class="list_box" style="border:1px solid #ebeef3; overflow-y:auto;">
					<ul class="cbp_tmtimeline"></ul>
				</div>
			</td>
			<td>
				<div class="sheet_title mal10">
				<ul>
					<li class="txt">상세내역</li>
					<li class="btn"></li>
				</ul>
				</div>
				<div id="detailList" class="list_box mal10">
				</div>
			</td>
		</tr>
	</table>
	
	<div class="hide">
		<script type="text/javascript"> createIBSheet("sheet1", "0", "0", "${ssnLocaleCd}"); </script>
	</div>
</div>
</body>
</html>
