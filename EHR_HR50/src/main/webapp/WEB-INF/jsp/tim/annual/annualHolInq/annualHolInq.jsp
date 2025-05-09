<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>휴가확정</title>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {
		
		//휴가생성 관련 조건
		$( "#selectYm" ).datepicker2({ymonly:true});
		$( "#selectYmd" ).datepicker2();
		
		// 숫자만 입력가능
		$("#selectYear").keyup(function() {
			makeNumber(this,'A');
		});

		//기준월
		var yearMmList = "";
		for( var i=1; i<=12 ; i++){
			yearMmList += "<option value='"+(i<10?"0":"")+i+"'>"+i+"월</option>";
		}
		$("#selectYearMm").html(yearMmList);
		
		
		var gntCdList1     = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnAnnualGntCdList",false).codeList, ""); //근태코드
		var gntTypeCdList1 = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getComTypeListTTIM010", false).codeList
	                      , "gntCd,searchSeq,mm", "");
		
		$("#selectGntCd").html(gntCdList1[2]);
		$("#selectGntTypeCd").html(gntTypeCdList1[2]);

		$("#selectGntTypeCd").bind("change", function(){
			$("#selectYearMm").val($("#selectGntTypeCd option:selected").attr("mm"));
			$("#selectGntCd").val($("#selectGntTypeCd option:selected").attr("gntCd"));
			$(".td01, .td03, .td07, .th01, .th03, .th07").hide();
			// $(".td0"+$("#selectGntTypeCd").val()).show();
			// $(".th0"+$("#selectGntTypeCd").val()).show();
			$(".td0"+$("#selectGntTypeCd").val()).css("display", "flex");
			$(".th0"+$("#selectGntTypeCd").val()).show();
		}).change();
		
		
		$( "#searchYm" ).datepicker2({
			ymonly:true,
			onReturn:function(date){
				doAction1("Search");
			}
		});

		$("#searchSabunName, #searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});
		$("#searchYear").bind("change",function(event){
			doAction1("Search");
		});


		$("#searchGntCd").bind("change",function(event){

			var comType = $("#searchGntCd option:selected").attr("comType");
			$("#searchComType").val(comType);

			// $("#tr1, #tr2").hide();

			// if( comType == "1") {
			//	 $("#tr1").show();
			// }else{
			//	$("#tr2").show();
			// }
			
			$(".tr1, .tr2").hide();

			if( comType == "1") {
				$(".tr1").show();
			}else{
				$(".tr2").show();
			}

			//기준년월 콤보
			var yearList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getAnnualHolInqYear&searchComType="+comType+"&searchGntCd="+$(this).val(), false).codeList, "");

		 	// cjg 데이터가 없어서 기준연월을 못불러올때
			if(yearList[1] == ''){
			  
				alert("데이터가 존재하지 않습니다.");
				yearList[2] = "<option value=' '> </option>";
			}
		 
		
		
			$("#searchYear").html(yearList[2]);

			doAction1("Search");
		});

		var gntCdList = convCodeCols( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getAnnualHolInqGntCd")
				, "comType"
				, "");
		$("#searchGntCd").html(gntCdList[2]);
		
		
		init_sheet1();
		
		$("#searchGntCd").change();

	});
	
	


	//Sheet 초기화
	function init_sheet1(){


		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenCol:0, MergeSheet:msHeaderOnly, DataRowMerge:0,FrozenColRight:2};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"소속",			Type:"Text",		Hidden:0,	Width:100, Align:"Left",	ColMerge:0,	SaveName:"orgNm",    	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"성명",			Type:"Text",		Hidden:0,	Width:70,  Align:"Center",	ColMerge:0,	SaveName:"name",     	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번",			Type:"Text",		Hidden:0,	Width:70,  Align:"Center",	ColMerge:0,	SaveName:"sabun",    	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위",			Type:"Text",		Hidden:0,	Width:70,  Align:"Center",	ColMerge:0,	SaveName:"jikweeNm", 	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직급",			Type:"Text",		Hidden:0,	Width:60,  Align:"Center",	ColMerge:0,	SaveName:"jikgubNm", 	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직군",			Type:"Text",		Hidden:0,	Width:70,  Align:"Center",	ColMerge:0,	SaveName:"workTypeNm", 	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사원구분",		Type:"Text",		Hidden:0,	Width:70,  Align:"Center",	ColMerge:0,	SaveName:"manageNm", 	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"입사일자",		Type:"Date",		Hidden:0,	Width:100, Align:"Center",	ColMerge:0,	SaveName:"empYmd",   	KeyField:0,		Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"연차기산일",		Type:"Date",		Hidden:0,	Width:100, Align:"Center",	ColMerge:0,	SaveName:"yearYmd",  	KeyField:0,		Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"근속년수",		Type:"Text",		Hidden:0,	Width:50,  Align:"Center",	ColMerge:0,	SaveName:"wkpCnt",   	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"발생년차\n(A)",	Type:"Text",		Hidden:0,	Width:60,  Align:"Center",	ColMerge:0,	SaveName:"creYeaCnt",	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"근속년차\n(B)",	Type:"Text",		Hidden:0,	Width:60,  Align:"Center",	ColMerge:0,	SaveName:"wkpYeaCnt",	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"1년미만\n(C)",Type:"Text",		Hidden:0,	Width:60,  Align:"Center",	ColMerge:0,	SaveName:"yearCnt",   	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"기준발생일\n(A+B+C)\n(D)",		
									Type:"Text",		Hidden:0,	Width:60,  Align:"Center",	ColMerge:0,	SaveName:"gntCnt",   	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"이월일수\n(E)",		Type:"Text",		Hidden:0,	Width:60,  Align:"Center",	ColMerge:0,	SaveName:"chgCnt",   	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"하계휴가\n차감일수\n(F)",Type:"Text",		Hidden:1,	Width:60,  Align:"Center",	ColMerge:0,	SaveName:"modCnt",   	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"사용가능일\n(D+E)",		Type:"Text",		Hidden:0,	Width:90,  Align:"Center",	ColMerge:0,	SaveName:"useCnt",   	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, CalcLogic:"|gntCnt|+|chgCnt|-|modCnt|" },
			{Header:"근무시작일",		Type:"Date",		Hidden:0,	Width:80,  Align:"Center",	ColMerge:0,	SaveName:"gntSYmd",  	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"근무종료일",		Type:"Date",		Hidden:0,	Width:80,  Align:"Center",	ColMerge:0,	SaveName:"gntEYmd",  	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사용시작일",		Type:"Date",		Hidden:0,	Width:80,  Align:"Center",	ColMerge:0,	SaveName:"useSYmd",  	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사용종료일",		Type:"Date",		Hidden:0,	Width:80,  Align:"Center",	ColMerge:0,	SaveName:"useEYmd",  	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			
			{Header:"endYn",		Type:"Text",		Hidden:1,	SaveName:"endYn"},
			{Header:"실발생일",		Type:"Text",		Hidden:1,	Width:60,  Align:"Center",	ColMerge:0,	SaveName:"calcCnt",  	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"근로기준일수",		Type:"Text",		Hidden:1,	Width:60,  Align:"Center",	ColMerge:0,	SaveName:"wkpStdCnt",	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"근무율",			Type:"Text",		Hidden:1,	Width:60,  Align:"Center",	ColMerge:0,	SaveName:"wkpRate",  	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"이월일",			Type:"Text",		Hidden:1,	Width:80,  Align:"Center",	ColMerge:0,	SaveName:"basCnt",   	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"YM",			Type:"Text",		Hidden:1,	Width:0,   Align:"Center",	ColMerge:0,	SaveName:"ym",       	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"gntCd",		Type:"Text",		Hidden:1,	Width:0,   Align:"Center",	ColMerge:0,	SaveName:"gntCd",    	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			{Header:"\n승인",			Type:"CheckBox",	Hidden:0,	Width:55,  Align:"Center",	ColMerge:0,	SaveName:"check",    	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"반영여부",		Type:"Image",		Hidden:0,	Width:60,  Align:"Center",	ColMerge:0,	SaveName:"endImg",    	KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

		];IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetHeaderRowHeight(50);
 		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_x.png");
 		sheet1.SetImageList(2,"${ctx}/common/images/icon/icon_o.png");

		sheet1.SetColProperty("endYn", 		{ComboText:"미승인|승인", ComboCode:"N|Y"} );


		$(window).smartresize(sheetResize); sheetInit();
		
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var msg = "";
			var comType = $("#searchGntCd option:selected").attr("comType");
			if( comType == "1") {
				msg = "대상년도를 ";
				$("#searchDate").val($("#searchYear").val());
			} else {
				msg = "입사월을 ";
				$("#searchDate").val($("#searchYm").val());
			}
			
			
			if($("#searchDate").val() == "") {
				alert(msg + "입력하여주십시오.");
				return;
			}
  
			sheet1.DoSearch( "${ctx}/AnnualHolInq.do?cmd=getAnnualHolInqList", $("#srchFrm").serialize() );
			break;

		case "Save":
			if(!dupChk(sheet1,"ym|sabun|gntCd", true, true)){break;}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/AnnualHolInq.do?cmd=saveAnnualHolInq", $("#srchFrm").serialize());
			break ;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "DeleteAll":
			if(confirm("항목을 전체삭제 하시겠습니까?")){		
			var data = ajaxCall( "${ctx}/AnnualHolInq.do?cmd=deleteAnnualHolInqAll", $("#srchFrm").serialize(), false);
			if (data != null) {
				alert(data.Result["Message"]);
				
				if (data.Result["Code"] > 0) {
					doAction1("Search");
					}
				}	
			}
			break ;	
		}
	}

	function sheet1_OnChange(Row, Col, Value) {
		try{

			var sName = sheet1.ColSaveName(Col);
		    //선택시 승인 체크
		    if(sName == "check"){
		        if(sheet1.GetCellValue(Row,"check") == "1"){
		        	sheet1.SetCellValue(Row,"endYn", "Y") ;
		        }
		        else {
		        	sheet1.SetCellValue(Row,"endYn", "N") ;
		        }
			}
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			for(var i = 1; i < sheet1.RowCount()+1; i++) {
				if( sheet1.GetCellValue(i, "endYn") == "Y" ) {
					sheet1.SetRowEditable(i,0);
				}
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try{
            if(Msg != ""){
                alert(Msg);
            }
            doAction1("Search");
        }catch(ex){
            alert("OnSaveEnd Event Error " + ex);
        }
    }




	var popGubun = "";
	// 소속 팝업
	function showOrgPopup() {
		if(!isPopup()) {return;}

		popGubun = "O";
        var rst = openPopup("/Popup.do?cmd=orgBasicPopup&authPg=R", "", "740","520");
	}

	// 사원 팝업
	function showEmployeePopup() {
		if(!isPopup()) {return;}

		popGubun = "E";
        var rst = openPopup("/Popup.do?cmd=employeePopup&authPg=R", "", "740","520");
	}

	function clearCode(num) {

		if(num == 1) {
			$("#searchOrgCd").val("");
			$("#searchOrgNm").val("");
			doAction1("Search");
		} else {
			$('#nameText').val("");
		}
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if( popGubun == "O"){
			$("#searchOrgCd").val(rv["orgCd"]);
			$("#searchOrgNm").val(rv["orgNm"]);
        }else if( popGubun == "E"){
   			$('#nameText').val(rv["name"]);
   			$('#name').val(rv["sabun"]);
        }
		doAction1("Search");
	}


	//휴가생성
    function annualCreate(){
    	if( $("#selectGntTypeCd").val() == "1" ){
    		if($( "#selectYear" ).val() == "" ){
    			alert("기준년월을 입력하세요.");
    			$( "#selectYear" ).focus();
            	return;
    		}
    		if($( "#selectYear" ).val().length != 4 ){
    			alert("기준년월을 정확히 입력하세요.");
    			$( "#selectYear" ).focus();
            	return;
    		}
    	}

    	if( $("#selectGntTypeCd").val() == "3" && $( "#selectYm" ).val() == "" ){
    		alert("입사년월을 입력하세요.");
    		$( "#selectYm" ).focus();
            return;
    	}
    	
    	if( $("#selectGntTypeCd").val() == "7" && $( "#selectYmd" ).val() == "" ){
    		alert("기준일자를 입력하세요.");
    		$( "#selectYmd" ).focus();
            return;
    	}
        if (!confirm("휴가를 생성 하시겠습니까?")) return;
        
		progressBar(true) ;
		
		setTimeout(
			function(){
				var param = "";
				if( $("#selectGntTypeCd").val() == "1" ){
			    	param = "searchDate="+$("#selectYear").val()+$("#selectGntTypeCd option:selected").attr("mm");
					
				}else if( $("#selectGntTypeCd").val() == "3" ){
					param = "searchDate="+$("#selectYm").val().replace(/-/g, '');
					
				}else if( $("#selectGntTypeCd").val() == "7" ){
					param = "searchDate="+$("#selectYmd").val().replace(/-/g, '');
				}
						
		    	$("#selectGntCd").removeAttr("disabled");
		    	param +=  "&searchSeq="+$("#selectGntTypeCd option:selected").attr("searchSeq");
		    	param +=  "&searchGntCd="+$("#selectGntCd").val();
		    	$("#selectGntCd").attr("disabled", true);
		    	
				var data = ajaxCall("${ctx}/AnnualHolInq.do?cmd=prcAnnualCreateCall", param,false);

				if(data.Result.Code == null || data.Result.Code == "") {
					$("#searchGntCd").change();
		    		alert("정상 처리되었습니다.");
			    	progressBar(false) ;
		    	} else {
			    	alert("처리중 오류가 발생했습니다.\n"+data.Result.Message);
			    	progressBar(false) ;
		    	}
			}
		, 100);
    	
    }
    
</script>
<style type="text/css">
.td01, .td03, .td07, .th01, .th03, .th07 {display:none; }
</style>
</head>
<body class="bodywrap">
<div class="wrapper">
	<table class="sheet_main">
		<tr>
			<td class="bottom outer" style="padding-bottom:12px;">
				<div class="explain">
					<div class="title">입력시 주의사항</div>
					<div class="txt">
					<ul>
						<li>
						- 생성된 휴가의 발생일과 사용가능일을 확인한후 승인버튼을 클릭하고, 저장버튼을 클릭하면 개인별 확정적용됩니다.<br>
						- 이미 승인이 완료된 자료는 수정할 수 없습니다.
						</li>
					</ul>
					</div>
				</div>
			</td>
		</tr>
	</table>
	<div class="sheet_search outer">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchDate" name="searchDate" />
		<input type="hidden" id="searchComType" name="searchComType" />
		<table>
			<colgroup>
				<col width="10%">
				<col width="20%">
				<col width="10%">
				<col width="16%">
				<col width="10%">
				<col width="28%">
			</colgroup>
			<tr>
				<th>휴가구분</th>
				<td>
					<select id="searchGntCd" name="searchGntCd"></select>
				</td>

				<!--<td id="tr1" style="display:none;">
					<span>기준년월</span>
					<select id="searchYear" name="searchYear"></select>
				</td>
				<td id="tr2" style="display:none;">
					<span>입사월</span>
					<input type="text" id="searchYm" name="searchYm" class="date2 required"  value="${curSysYyyyMMHyphen}"/>
				</td>-->

				<th class="tr1" style="display:none;">기준년월</th>
				<td class="tr1" style="display:none;">
					<select id="searchYear" name="searchYear"></select>
				</td>
				<th class="tr2" style="display:none;">입사월</th>
				<td class="tr2" style="display:none;">
					<input type="text" id="searchYm" name="searchYm" class="date2 required"  value="${curSysYyyyMMHyphen}"/>
				</td>
				<th>승인구분</th>
				<td>
					<label for="searchType1">승인</label> <input type="radio" class="radio" name="searchType" id="searchType1" value="Y" onClick="doAction1('Search')">
					<label for="searchType2">미승인</label><input type="radio" class="radio" name="searchType" id="searchType2" value="N" onClick="doAction1('Search')">
					<label for="searchType3">전체</label> <input type="radio" class="radio" name="searchType" id="searchType3" value="A" checked onClick="doAction1('Search')">
				</td>
			</tr>
			<tr>
				<th>소속</th>
				<td>
					<input type="text" id="searchOrgNm" name="searchOrgNm" class="text w150" style="ime-mode:active;"/>
				</td>
				<th>사번/성명</th>
				<td>
					<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;" />
				</td>
				<td colspan="2">
					<a href="javascript:doAction1('Search');" class="btn dark">조회</a>
				</td>
			</tr>
		</table>
	</form>
	</div>

	<div class="sheet_title outer">
		<ul>
			<li class="txt">휴가생성</li>
			<li class="btn"></li>
		</ul>
	</div>
	
	<table class="table outer">
		<colgroup>
			<col width="10%">
			<col width="22%">
			<col width="10%">
			<col width="16%">
			<col width="10%">
			<col width="18%">
			<col width="*%">
		</colgroup>
	<tr>
		<th>대상자</th>
		<td><select id="selectGntTypeCd" name="searchGntTypeCd"></select></td>
		<th >휴가구분</th>
		<td><select id="selectGntCd" name="searchGntCd" disabled class="transparent hideSelectButton "></select></td>
		<th>
			<span class="th01">기준년월</span><span class="th03">입사월</span><span class="th07">기준일자</span>
		</th>	
		<td>
			<div class="td01"><input type="text" id="selectYear" 	name="searchYear" 	class="text required center w50 line"  value="" maxlength="4"/>
				&nbsp;<select id="selectYearMm" name="selectYearMm" disabled class="hideSelectButton" style="margin-left:4px;"></select></div>
			<div class="td03"><input type="text" id="selectYm" 		name="searchYm" 	class="date2 required left"  value=""/></div>
			<div class="td07"><input type="text" id="selectYmd" 	name="searchYmd" 	class="date2 required left"  value=""/></div>
		<td class="right">
			<a href="javascript:annualCreate()" class="btn filled authA">휴가생성</a>
		</td>
	</tr>
	</table>
	
	<table class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt">휴가생성내역 및 승인</li>
							<li class="btn">
								<a href="javascript:doAction1('Save');" class="btn filled authA">저장</a>
								<a href="javascript:doAction1('Down2Excel');" class="btn outline_gray authR">다운로드</a>
								<a href="javascript:doAction1('DeleteAll');" class="btn outline_gray authA">전체삭제</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>

</div>
</body>
</html>