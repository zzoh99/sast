<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head> <title><tit:txt mid='schLic' mdef='자격증검색'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var gPRow = "";
	var pGubun = "";
	var planSeq = "";
	var resortSeq = "";
	var companyCd = "";
	var resortNm = "";

	
	$(function() {
        const modal = window.top.document.LayerModalUtility.getModal('resortSeasonMgrLayer');
        var arg = modal.parameters;
        
		//var arg = p.popDialogArgumentAll();
		// 부모 창에서 받은 값 세팅
		planSeq   =  arg.planSeq;
		resortSeq = arg.resortSeq;
		companyCd = arg.companyCd;
		resortNm = arg.resortNm;
		$("#planSeq").val(planSeq);
		
	      //Sheet 초기화
        init_resortSeasonMgrLayerSheet();

		$('.money').mask('000,000,000,000,000', { reverse : true });
		
		var companyCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B49530"), "");
		$("#companyCd").html(companyCdList[2]);
		$("#companyCd").val(companyCd);
		
		//리조트 선택시
		$('#resortSeasonMgrLayerSheetForm').on('change', 'select[name="companyCd"]',function() {
			//리조트 회사 > 이름 콤보
			var param = "";
			param = "&companyCd="+$("#companyCd").val();
			param += "&planSeq="+$("#planSeq").val();
			var resortList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getResortSeasonMgrPopRsNmCombo"+param, false).codeList, "선택");
			$("#resortNm").html(resortList[2]);
			formClean();
			doAction1('Search');
		});
		
		//지점 선택시
		$('#resortSeasonMgrLayerSheetForm').on('change', 'select[name="resortNm"]',function() {
			var param = "";
			param = "&resortNm="+$("#resortNm").val();
			param += "&planSeq="+$("#planSeq").val();
			var resortList2 = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getResortSeasonMgrPopRsDaysCombo"+param, false).codeList, "선택");
			$("#resortSeq").html(resortList2[2]);
			if( !$("#resortNm").val() ){ $("#resortSeq").val(""); };
			formClean();
			doAction1('Search');
		});
		
		//사용기간 선택시
		$('#resortSeasonMgrLayerSheetForm').on('change', 'select[name="resortSeq"]',function() {
			getResortSeasonMgrPopRs();
			formClean();
		});
		
		$("#companyCd").change();
		$("#resortNm").val(resortNm);
		$("#resortNm").change();
		$("#resortSeq").val(resortSeq);
		$("#resortSeq").change();
	

		//close 버튼 처리
		$(".close").click(function(){
			//p.self.close();
			closeLayerModal();
		});

	});

	//Sheet 초기화
    function init_resortSeasonMgrLayerSheet(){
//resortSeasonMgrLayerSheet-wrap
        createIBSheet3(document.getElementById('resortSeasonMgrLayerSheet-wrap'), "resortSeasonMgrLayerSheet", "100%", "100%", "${ssnLocaleCd}");
        
        var initdata1 = {};
        //MergeSheet:msHeaderOnly => 헤더만 머지
        //HeaderCheck => 헤더에 전체 체크 표시 여부
        initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, AutoFitColWidth:'init|search|resize|rowtransaction'};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        
        initdata1.Cols = [
            {Header:"No",           Type:"${sNoTy}",    Hidden:0,       Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"상태",           Type:"${sSttTy}",   Hidden:0,   Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
            {Header:"신청일시",     Type:"Text",        Hidden:0,       Width:60,           Align:"Center", ColMerge:0, SaveName:"applAgreeTime",   Sort:0, UpdateEdit:0, InsertEdit:0 },
            {Header:"사번",       Type:"Text",        Hidden:0,       Width:40,           Align:"Center", ColMerge:0, SaveName:"sabun",   KeyField:0, Format:"", PointCount:0,    UpdateEdit:0, InsertEdit:0 },
            {Header:"성명",       Type:"Text",        Hidden:0,       Width:35,           Align:"Center",   ColMerge:0,   SaveName:"name",    KeyField:0, Format:"", PointCount:0,    UpdateEdit:0, InsertEdit:0 },
            {Header:"부서",       Type:"Text",        Hidden:0,       Width:60,           Align:"left",   ColMerge:0, SaveName:"orgNm",   KeyField:0, Format:"", PointCount:0,    UpdateEdit:0, InsertEdit:0 },
            {Header:"직위",       Type:"Text",        Hidden:0,       Width:40,           Align:"Center",   ColMerge:0,   SaveName:"jikweeNm",    KeyField:0, Format:"", PointCount:0,    UpdateEdit:0, InsertEdit:0 },
            {Header:"연락처",      Type:"Text",        Hidden:0,       Width:50,           Align:"Center",   ColMerge:0,   SaveName:"phoneNo",     KeyField:0, Format:"", PointCount:0,    UpdateEdit:0, InsertEdit:0 },
            {Header:"메일주소",         Type:"Text",        Hidden:0,       Width:60,           Align:"left",   ColMerge:0, SaveName:"mailId",  KeyField:0, Format:"", PointCount:0,    UpdateEdit:0, InsertEdit:0 },
            {Header:"희망순번",         Type:"Text",        Hidden:0,       Width:35,           Align:"Center",   ColMerge:0,   SaveName:"hopeCd",  KeyField:0, Format:"", PointCount:0,    UpdateEdit:0, InsertEdit:0 },
            {Header:"성수기\n신청건수",    Type:"Text",        Hidden:0,       Width:35,           Align:"Center",   ColMerge:0,   SaveName:"applCnt",     KeyField:0, Format:"", PointCount:0,    UpdateEdit:0, InsertEdit:0 },
            {Header:"성수기\n예약건수",    Type:"Text",        Hidden:0,       Width:35,           Align:"Center",   ColMerge:0,   SaveName:"applCmpCnt",  KeyField:0, Format:"", PointCount:0,    UpdateEdit:0, InsertEdit:0 },
            {Header:"예약상태",         Type:"Combo",       Hidden:0,       Width:50,           Align:"Center",   ColMerge:0,   SaveName:"statusCd",    KeyField:0, Format:"", PointCount:0,    UpdateEdit:1, InsertEdit:0 },
            
            {Header:"Hidden",   Type:"Text",   Hidden:1, SaveName:"resortSeq"},
            {Header:"Hidden",   Type:"Text",   Hidden:1, SaveName:"applSeq"},
            
            
        ]; IBS_InitSheet(resortSeasonMgrLayerSheet, initdata1);resortSeasonMgrLayerSheet.SetEditable(true);resortSeasonMgrLayerSheet.SetVisible(true);resortSeasonMgrLayerSheet.SetCountPosition(4);
        
        resortSeasonMgrLayerSheet.SetEditableColorDiff(0); //편집불가 배경색 적용안함
        resortSeasonMgrLayerSheet.SetDataAlternateBackColor(resortSeasonMgrLayerSheet.GetDataBackColor()); //홀짝 배경색 같게
        
        var statusCdList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B49520"), "");
        resortSeasonMgrLayerSheet.SetColProperty("statusCd", {ComboText:"|예약완료", ComboCode:"|Y"} ); //리조트명
        
        var sheetHeight = $(".modal_body").height() - $(".sheet_title").height() ;
        $(window).smartresize(sheetResize); sheetInit();
        resortSeasonMgrLayerSheet.SetSheetHeight(sheetHeight);
    }

    //resortSeasonMgrLayerSheet Action
    function doAction1(sAction) {
        switch (sAction) {
            case "Search":
                resortSeasonMgrLayerSheet.DoSearch( "${ctx}/ResortSeasonMgr.do?cmd=getResortSeasonMgrPopAprList", $("#resortSeasonMgrLayerSheetForm").serialize() );
                break;
            case "Save":
                
                if (confirm("예약상태를 변경 하시겠습니까?")) {
                    //아이비시트에서 예약완료 값 가져오기
                    for(var forRow=1; forRow <= resortSeasonMgrLayerSheet.LastRow(); forRow++){
                        if (resortSeasonMgrLayerSheet.GetCellValue(forRow, "statusCd") == 'Y') {
                            $("#applSeq").val(resortSeasonMgrLayerSheet.GetCellValue(forRow, "applSeq"));
                            break; 
                        }
                    }
                    IBS_SaveName(document.resortSeasonMgrLayerSheetForm,resortSeasonMgrLayerSheet);
                    resortSeasonMgrLayerSheet.DoSave( "${ctx}/ResortSeasonMgr.do?cmd=saveResortSeasonMgrPop", $("#resortSeasonMgrLayerSheetForm").serialize());
                    
                    //var rtn = ajaxCall( "${ctx}/ResortSeasonMgr.do?cmd=saveResortSeasonMgrPop", $("#resortSeasonMgrLayerSheetForm").serialize(),false);
                    
                    //alert(rtn.Result.Message);
                    doAction1('Search');
                    
                    //p.popReturnValue([]);
                }
                
                break;
            case "Down2Excel":
                var downcol = makeHiddenSkipCol(resortSeasonMgrLayerSheet);
                var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
                resortSeasonMgrLayerSheet.Down2Excel(param);
                break;
        }
    }
    
    //---------------------------------------------------------------------------------------------------------------
    // resortSeasonMgrLayerSheet Event
    //---------------------------------------------------------------------------------------------------------------

    // 조회 후 에러 메시지
    function resortSeasonMgrLayerSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") {
                alert(Msg);
            }
            sheetResize();
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    // 저장 후 메시지
    function resortSeasonMgrLayerSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") {
                alert(Msg);
            }
            if( Code > -1 ) doAction1("Search");
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }
    // 시트 선택 이벤트
    function resortSeasonMgrLayerSheet_OnChange(Row, Col, Value) {
         try{
            // resortSeasonMgrLayerSheet.GetSelectRow() => 최초 이벤트 발생 Row
            if ( Row > 0 && resortSeasonMgrLayerSheet.ColSaveName(Col) == "statusCd" && resortSeasonMgrLayerSheet.GetCellValue(Row, "statusCd") == 'Y' && Row == resortSeasonMgrLayerSheet.GetSelectRow() ) {
                for(var forRow=1; forRow <= resortSeasonMgrLayerSheet.LastRow(); forRow++){
                    if (forRow == Row) { continue; }
                    resortSeasonMgrLayerSheet.SetCellValue(forRow, "statusCd", "");
                }
            }
        }catch(ex){alert("OnChange Event Error : " + ex);}
    }

    //객실정보 불러오기
    function getResortSeasonMgrPopRs() {
    
        var rvData = ajaxCall( "${ctx}/ResortSeasonMgr.do?cmd=getResortSeasonMgrPopRs", $("#resortSeasonMgrLayerSheetForm").serialize(),false);
        if ( rvData != null && rvData.DATA != null){
            var data = rvData.DATA;
            $("#roomType").val(data.roomType);
            $("#resortMon").val(data.resortMon).focusout();
            $("#comMon").val(data.comMon).focusout();
            $("#psnalMon").val(data.psnalMon).focusout();
            $("#planSeq").val(data.planSeq);
            $("#rsvNo1").val(data.rsvNo1);
            $("#rsvNo2").val(data.rsvNo2);
            doAction1('Search');
        }   
    }
    
    //폼 값 지우기
    function formClean() {
        if( !$("#resortNm").val() || !$("#companyCd").val() || !$("#resortSeq").val()){
            $(".formClean").val("");
        }
    }

    /**
     * Mail 발송 팝업 창 호출
     */
    function fnSendMailPop(names, mailIds){
        if(!isPopup()) {return;}

        var args    = new Array();

        args["saveType"] = "insert";
        args["names"] = names;
        args["mailIds"] = mailIds;
        args["sender"] = "${ssnName}";
        args["bizCd"] = "99999"; 
        args["authPg"] = "${authPg}";

        var url = "${ctx}/SendPopup.do?cmd=viewMailMgrPopup";
        var rv = openPopup(url, args, "900","700");
    }
    
    function closeLayerModal(){
        const modal = window.top.document.LayerModalUtility.getModal('resortSeasonMgrLayer');
        modal.hide();
    }
</script>

</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
	<!-- 
		<div class="popup_title">
			<ul>
				<li>신청리조트관리</li>
				<li class="close"></li>
			</ul>
		</div>
	 -->	
		<div class="modal_body"> 
			<form name="resortSeasonMgrLayerSheetForm" id="resortSeasonMgrLayerSheetForm" method="post">
			
			<input type="hidden" id="planSeq" name="planSeq"/>
			<%-- 예약상태 예약완료인 신청서 저장 input --%>
			<input type="hidden" id="applSeq" name="applSeq"/>
			
			<div class="sheet_title">
				<ul>
					<li class="txt">성수기 리조트 객실정보</li>
				</ul>
			</div>
			
			<table class="table">
				<colgroup>
					<col width="120px" />
					<col width="30%" />
					<col width="120px" />
					<col width="" />
				</colgroup>
				<tr>
					<th>리조트명</th>
					<td>
						<select id="companyCd" name="companyCd" class="${selectCss} ${required} w100" ></select>
						<!-- <input type="text" id="companyCdNm" name="companyCdNm" class="text transparent w150" readonly/> -->
					</td>
					<th>지점명</th>
					<td>
						<select id="resortNm" name="resortNm" class="${selectCss} ${required} w200" ></select>
					</td>
				</tr>
				<tr>
					<th>사용기간</th>
					<td colspan="3">
						<select id="resortSeq" name="resortSeq" class="${selectCss} ${required} w200" ></select>
					</td>
				</tr>
				<tr>
					<th>객실타입</th>
					<td>
						<input type="text" id="roomType" name="roomType" class="text transparent w150 formClean" readonly/>
					</td>
					<th>이용금액</th>
					<td>
						<input type="text" id="resortMon" name="resortMon" class="text transparent w120 money formClean" readonly/>
					</td>
				</tr>
				<tr>
					<th>지원금액</th>
					<td>
						<input type="text" id="comMon" name="comMon" class="text transparent w120 money formClean" readonly/>
					</td>
					<th>개인부담금</th>
					<td>
						<input type="text" id="psnalMon" name="psnalMon" class="text transparent w120 money formClean" readonly/>
					</td>
				</tr>
				<tr>
					<th>예약번호1</th>
					<td>
						<input type="text" id="rsvNo1" name="rsvNo1" class="${textCss} transparent w250 formClean" readonly/>
					</td>
					<th>예약번호2</th>
					<td>
						<input type="text" id="rsvNo2" name="rsvNo2" class="${textCss} transparent w250 formClean" readonly/>
					</td>
				</tr>
			</table>
			
			<div class="sheet_title">
				<ul>
					<li class="txt">신청리스트</li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Save');" 		css="basic" mid="save" mdef="저장"/>
						<btn:a href="javascript:doAction1('Down2Excel');" 	css="basic" mid="download" mdef="다운로드"/>
					</li>
				</ul>
			</div>
			<div id="resortSeasonMgrLayerSheet-wrap"></div>
			</form>
			<!--  <script type="text/javascript">createIBSheet("sheet2-wrap", "100%", "350px"); </script> -->
			
		</div>
	    <div class="modal_footer outer">
	        <a href="javascript:closeLayerModal();" class="btn outline_gray">닫기</a>
	    </div>       
	</div>
</body>
</html>