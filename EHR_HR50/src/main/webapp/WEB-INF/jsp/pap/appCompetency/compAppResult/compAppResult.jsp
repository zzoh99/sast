<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head><title>리더십 다면진단 결과 전체 경향</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

    var appSeqCdList ="";
    $(function() {
        var initdata = {};
        initdata.Cfg = {FrozenCol:1,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"No|No",                 Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            
            {Header:"역량명|역량명",			 Type:"Text",	Hidden:0,					Width:150,	Align:"Center",	ColMerge:0,	SaveName:"ldsCompetencyNm",  	Edit:0},
   			{Header:"진단결과|진단결과",				 Type:"Text",	Hidden:0,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"avgAppResult",  		Edit:0},
   			{Header:"전사평균|전사평균",				 Type:"Text",	Hidden:0,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"avgAppResultAll", 	Edit:0},
   			{Header:"본인평균|본인평균",				 Type:"Text",	Hidden:0,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"avgAppResult0", 		Edit:0},
   			{Header:"GAP(진단결과기준)|전사 대비",	 Type:"Text",	Hidden:0,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appResultAllComp", 	Edit:0},
   			{Header:"GAP(진단결과기준)|본인평가 대비", Type:"Text",	Hidden:0,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appResult0Comp", 	    Edit:0},
   			{Header:"rk",            	Type:"Text",      	Hidden:1,  					Width:0,   	Align:"Center", ColMerge:0, SaveName:"rk",           	Edit:0}
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
        //sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
        
        var initdata2 = {};
        initdata2.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly + msPrevColumnMerge};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata2.Cols = [
			{Header:"리더십역량",		 Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"ldsCompetencyCd"},
			{Header:"역량명",		 Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"ldsCompetencyNm",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000, Wrap : 1, MultiLineText:1  },
			{Header:"No",			 Type:"${sNoTy}",	Hidden:0,	Width:30,	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"문항",		 	 Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"ldsCompBenm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000, Wrap : 1, MultiLineText:1 },
			{Header:"진단결과",	 Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"avgAppResult",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"전사평균",	 Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"avgAppResultAll",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"GAP",			 Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"gap",				KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetCountPosition(4); sheet2.SetUnicodeByte(3);sheet2.SetEditableColorDiff(0);

		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly+msPrevColumnMerge};
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata3.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"강점",		 	 Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"aComment",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000, Wrap : 1, MultiLineText:1 },
			{Header:"개선점",		 	 Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"cComment",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000, Wrap : 1, MultiLineText:1 },
		]; IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable("${editable}");sheet3.SetCountPosition(4); sheet3.SetUnicodeByte(3);sheet3.SetEditableColorDiff(0);

        $(window).smartresize(sheetResize); sheetInit();
    });


    $(function() {
    	//초기세팅
    	$('#searchSabun').val('${ssnSabun}');
		$("#searchKeyword").val("${sessionScope.ssnName}");
		$("#span_searchName").html("${sessionScope.ssnName}");

    	// 조회조건 이벤트 등록
        $("#searchAppraisalCd").bind("change",function(event){
            doAction1("Search");
        });

        $("#searchNameSabun").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });
		//평가명
		var compAppraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getCompAppraisalCdList",false).codeList, "");
		$("#searchAppraisalCd").html(compAppraisalCdList[2]);
		
        $("#searchAppraisalCd").change();
        //getConfirmYn();

    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":      sheet1.DoSearch( "${ctx}/CompAppResult.do?cmd=getCompAppResultList", $("#empForm").serialize() ); break;
        
        case "Clear":       sheet1.RemoveAll(); break;
        
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param = {DownCols:downcol, SheetDesign:1, Merge:1};
            sheet1.Down2Excel(param);
        	break;
        	
		case "Print":
			if(sheet1.RowCount() == 0) {
				alert('데이터가 존재하지 않습니다.'); 
				break;
			}
			showRd();
			break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try{
            if (Msg != ""){
                alert(Msg);
            }
            
			if ( sheet1.RowCount() > 0 ){
				var appResultAllComp = "";
				var appResult0Comp = "";
				var appResultComp = "";
				for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++){
					appResultAllComp = sheet1.GetCellValue(i, "appResultAllComp");
					appResult0Comp = sheet1.GetCellValue(i, "appResult0Comp");
					appResultComp = sheet1.GetCellValue(i, "appResultComp");
					if( appResultAllComp < 0) sheet1.SetCellFontColor(i, "appResultAllComp", "red");
					if( appResult0Comp < 0) sheet1.SetCellFontColor(i, "appResult0Comp", "red");
					if( appResultComp < 0) sheet1.SetCellFontColor(i, "appResultComp", "red");
				}
			}
			//minMaxColorSet();
			doAction2('Search');
            sheetResize();
        }catch(ex){
            alert("OnSearchEnd Event Error : " + ex);
        }
    }
    
    function minMaxColorSet(){
    	var arr = [[], [], []];
    	var maxArr = [];
    	var minArr = [];
		if ( sheet1.RowCount() > 0 ){
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++){
				arr[0].push(Number(sheet1.GetCellValue(i, "appResultAllComp")));
				arr[1].push(Number(sheet1.GetCellValue(i, "appResult0Comp")));
				arr[2].push(Number(sheet1.GetCellValue(i, "appResultComp")));
			}
			
			for(var i=1; i<4; i++){
				maxArr.push(Math.max.apply(null, arr[i-1]));
				minArr.push(Math.min.apply(null, arr[i-1]));
			}
			
			var appResultAllComp = "";
			var appResult0Comp = "";
			var appResultComp = "";
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++){
				appResultAllComp = sheet1.GetCellValue(i, "appResultAllComp");
				appResult0Comp = sheet1.GetCellValue(i, "appResult0Comp");
				appResultComp = sheet1.GetCellValue(i, "appResultComp");
				if( appResultAllComp == maxArr[0]) sheet1.SetCellBackColor(i, "appResultAllComp", "#C6EFCE");
				if( appResultAllComp == minArr[0]) sheet1.SetCellBackColor(i, "appResultAllComp", "#FFC7CE");
				if( appResult0Comp == maxArr[1]) sheet1.SetCellBackColor(i, "appResult0Comp", "#C6EFCE");
				if( appResult0Comp == minArr[1]) sheet1.SetCellBackColor(i, "appResult0Comp", "#FFC7CE");
				if( appResultComp == maxArr[2]) sheet1.SetCellBackColor(i, "appResultComp", "#C6EFCE");
				if( appResultComp == minArr[2]) sheet1.SetCellBackColor(i, "appResultComp", "#FFC7CE");
			}
			
		}
    }

    function showPopup() {
        try{
        	if(!isPopup()) {return;}
        	
        	CompAppResultDtlPopup();
            
        }catch(ex){alert("OpenPopup Error : " + ex);}
    }
    
	// 임직원조회 자동완성 결과 세팅 처리
	function setEmpPage(){
		$("#searchName").val($("#searchKeyword").val());
		$("#searchSabun").val($("#searchUserId").val());
		doAction1('Search');
		//getConfirmYn();
	}
    
    //Sheet2 Action
    function doAction2(sAction) {
        switch (sAction) {
        case "Search":      sheet2.DoSearch( "${ctx}/CompAppResult.do?cmd=getCompAppResultList2", $("#empForm").serialize() ); break;
        }
    }

    // 조회 후 에러 메시지
    function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try{
            if (Msg != ""){
                alert(Msg);
            }
            doAction3('Search');
            sheetResize();
        }catch(ex){
            alert("OnSearchEnd Event Error : " + ex);
        }
    }
    
    //Sheet2 Action
    function doAction3(sAction) {
        switch (sAction) {
        case "Search":      sheet3.DoSearch( "${ctx}/CompAppResult.do?cmd=getCompAppResultList3", $("#empForm").serialize() ); break;
        }
    }

    // 조회 후 에러 메시지
    function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try{
            if (Msg != ""){
                alert(Msg);
            }
            sheetResize();
        }catch(ex){
            alert("OnSearchEnd Event Error : " + ex);
        }
    }
	
	var CompAppResultDtlPopup = function() {

		var args = {};
		
		gPRow = "";
		pGubun = "CompAppResultDtlPopupView";

		args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
     	args["searchSabun"] = $("#searchSabun").val();

		var layer = new window.top.document.LayerModal({
			id : 'CompAppResultDtlPopupLayer'
			, url : "${ctx}/CompAppResult.do?cmd=viewCompAppResultDtlPopup"
			, parameters: args
			, width : 1000
			, height : 700
			, title : "차수별 비교"
		});
		layer.show();
	};
	
	function showRd() {

		var rk = "";
		for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++){
			rk = sheet1.GetCellValue(i, 'rk');
			break;
		}
		//암호화 데이터
		const data = {
				  rk : rk
	            , searchAppraisalCd : $("#searchAppraisalCd").val()
	            , searchSabun : $("#searchSabun").val()
	            , rdMrd	: "pap/appCompetency/compAppResult.mrd"
		};
		
		
		window.top.showRdLayer('/CompAppResult.do?cmd=getEncryptRd', data, null, '다면진단결과 개인별 보고서');
	}
	
	function showRd_all() {

		var enterCd = "[${ssnEnterCd}]";//회사코드
		var rk = "";
		for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++){
			rk = sheet1.GetCellValue(i, 'rk');
			break;
		}
		//암호화 데이터
		const data = {
				  rk : rk
	            , searchAppraisalCd : $("#searchAppraisalCd").val()
	            , baseURL : "${baseURL}"
	            , rdMrd	: "pap/appCompetency/compAppResultAdmin.mrd"
		};
		
		window.top.showRdLayer('/CompAppResult.do?cmd=getEncryptRd2', data, null, '전사보고서');
	}
	
</script>
</head>
<body class="hidden">
<div class="wrapper">
    <form id="empForm" name="empForm" >
    	<!-- 조회영역 > 성명 자동완성 관련 추가 -->
		<input type="hidden" id="searchEmpType"  name="searchEmpType" value="I"/>
		<input type="hidden" id="searchUserId"   name="searchUserId" value="" />
		<input type="hidden" id="searchUserEnterCd"  name="searchUserEnterCd" value="" />
		<!-- 조회영역 > 성명 자동완성 관련 추가 -->
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                        <td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd"></select>
						</td>
						<td>
							<span>대상자(피평가자)</span>
							<input id="searchSabun" name ="searchSabun" type="hidden" />
							<input id="searchName" name ="searchName" type="hidden" />
							<c:choose>
								<c:when test="${ sessionScope.ssnGrpCd == '10'||sessionScope.ssnGrpCd == '20' }">
									<input type="text"   id="searchKeyword"  name="searchKeyword" class="text w100" style="ime-mode:active"/>
								</c:when>
								<c:otherwise>
									<input type="hidden" id="searchKeyword" name="searchKeyword" />
									<span id="span_searchName" class="txt pap_span f_normal"></span>
								</c:otherwise>
							</c:choose>
						</td>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark" >조회</a>
						</td>
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
                            <li id="txt" class="txt">전체 경향</li>
                            <li class="btn">
                                <a href="javascript:doAction1('Down2Excel');"    class="btn outline_gray authR">다운로드</a>
                                <a href="javascript:showPopup();"    			 class="btn outline_gray authR">평가차수별 항목통계</a>
								<a href="javascript:doAction1('Print');" 		 class="btn outline_gray authR">개인별출력</a>
                                <a href="javascript:showRd_all();" 		 class="btn filled authA">전사보고서</a>
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript">createIBSheet("sheet1", "100%", "40%","kr"); </script>
            </td>
        </tr>
    </table>
    	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="50%" />
			<col width="15px" />
			<col width="%" />
		</colgroup>
        <tr>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">문항별 비교</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "60%", "${ssnLocaleCd}"); </script>
			</td>
			<td></td>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">종합의견</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet3", "100%", "60%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table> 
</div>
</body>
</html>