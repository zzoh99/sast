<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>과거 인적공제 현황</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");

	$(function() {
		$("#searchWorkYy").bind("keyup",function(event){
            makeNumber(this,"A");
            if( event.keyCode == 13){
                doAction1("Search");
                $(this).focus();
            }
        });

		var arg = p.window.dialogArguments;

		if( arg != undefined ) {
			$("#searchWorkYy").val(arg["searchWorkYy"]);
			$("#searchAdjustType").val(arg["searchAdjustType"]);
			$("#searchSabun").val(arg["searchSabun"]);
		}else{
			var searchWorkYy     = "";
			var searchAdjustType = "";
			var searchSabun      = "";

			searchWorkYy 	  = p.popDialogArgument("searchWorkYy");
			searchAdjustType  = p.popDialogArgument("searchAdjustType");
			searchSabun       = p.popDialogArgument("searchSabun");

			$("#searchWorkYy").val(searchWorkYy);
			$("#searchAdjustType").val(searchAdjustType);
			$("#searchSabun").val(searchSabun);
		}

		//쉬트 초기화.
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata1.Cols = [
            {Header:"No",             Type:"<%=sNoTy%>",  Hidden:<%=sNoHdn%>, Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"삭제",           Type:"<%=sDelTy%>", Hidden:1,Width:"<%=sDelWdt%>",   Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
            {Header:"상태",           Type:"<%=sSttTy%>", Hidden:1,Width:"<%=sSttWdt%>",   Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
            {Header:"귀속년도",            Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"work_yy",             KeyField:1, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 },
            {Header:"정산구분",            Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"adjust_type",         KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"사번",                Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"sabun",               KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13 },
            {Header:"관계",                Type:"Combo",       Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"fam_cd",              KeyField:1, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"성명",                Type:"Text",        Hidden:0,   Width:60,   Align:"Left",   ColMerge:0, SaveName:"fam_nm",              KeyField:1, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"주민등록번호",        Type:"Text",        Hidden:0,   Width:90,   Align:"Center", ColMerge:0, SaveName:"famres",              KeyField:1, Format:"IdNo",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:200, FullInput:1 },
            {Header:"주민등록번호\n체크",   Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"famresChk",              KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"나이",                Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"age",                 KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"연령대",              Type:"Combo",       Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"age_type",             KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"학력",                Type:"Combo",       Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"aca_cd",              KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"기본\n공제",          Type:"CheckBox",    Hidden:0,   Width:40,   Align:"Center", ColMerge:0, SaveName:"dpndnt_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"배우자\n공제",        Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"spouse_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"경로\n우대",          Type:"CheckBox",    Hidden:0,   Width:40,   Align:"Center", ColMerge:0, SaveName:"senior_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"장애인\n공제",        Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"hndcp_yn",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"장애\n구분",          Type:"Combo",       Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"hndcp_type",          KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"부녀자\n공제",        Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"woman_yn",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"사업장",              Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"business_place_cd",   KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"보험료",              Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"insurance_yn",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"의료비",              Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"medical_yn",          KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"교육비",              Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"education_yn",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"신용\n카드등",        Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"credit_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"우편번호",            Type:"Popup",       Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"zip",                 KeyField:0, Format:"PostNo",PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:6 },
            {Header:"주소",                Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"addr1",               KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"상세주소",            Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"addr2",               KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"다른곳에 등록된 수",  Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"incnt",               KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
            {Header:"6세이하\n자녀양육",   Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"child_yn",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"출산입양\n공제",      Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"adopt_born_yn",       KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"한부모\n공제",        Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"one_parent_yn",       KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"전년도\n대상여부",    Type:"Text",    Hidden:1,   Width:50,   Align:"Center", ColMerge:0, SaveName:"pre_equals_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" }
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        var famCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00309"), "");
        var acaCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","H20130"), "");

        sheet1.SetColProperty("fam_cd", {ComboText:"|"+famCdList[0], ComboCode:"|"+famCdList[1]} );
        sheet1.SetColProperty("aca_cd", {ComboText:"|"+acaCdList[0], ComboCode:"|"+acaCdList[1]} );
        sheet1.SetColProperty("hndcp_type", {ComboText:"|장애인복지법에 따른 장애인|국가유공자 등 예우 및 지원에 관한 법률에 따른 자|그 외 중증환자", ComboCode:"|1|2|3"} );
        sheet1.SetColProperty("age_type", {ComboText:"|만18세미만|만20세미만|만60세이상", ComboCode:"|18-|20-|60+"} );

	    $(window).smartresize(sheetResize); sheetInit();
	    doAction1("Search");

	    $(".close").click(function() {
	    	p.self.close();
	    });
	});

	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			if($("#searchWorkYy").val() == "") {
                alert("대상년도를 입력하여 주십시오.");
                return;
            }

			//인적공제 조회
            sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataPerRst.jsp?cmd=selectYeaDataPerList", $("#sheetForm").serialize() );
            break;
		case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
            sheet1.Down2Excel(param);
            break;
		}
    }

	//조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);

            if (Code == 1) {
            	var systemYY = parseInt($("#searchWorkYy").val(), 10);

                //sheetSet() ;
                var loop = sheet1.LastRow();
                for(loop = 1 ; loop <= sheet1.LastRow() ; loop++){

                    //본인이면은
                    if(sheet1.GetCellValue(loop, "famres") == $("#searchRegNo", parent.document).val()){
                        if(sheet1.GetCellValue(loop,"famres").substring(6,7) == "3" || sheet1.GetCellValue(loop,"famres").substring(6,7) == "4"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "7" || sheet1.GetCellValue(loop,"famres").substring(6,7) == "8") {
                            age = systemYY - parseInt("20"+sheet1.GetCellValue(loop, "famres").substring(0,2), 10);
                        } else {
                            age = systemYY - parseInt("19"+sheet1.GetCellValue(loop, "famres").substring(0,2), 10);
                        }
                        //경로우대 체크
                        if( sheet1.GetCellValue(loop,"famres").substring(6,7) == "1"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "3"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "5"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "7" ){
                            if( age >= 70){
                                sheet1.SetCellValue(loop,"senior_yn", "Y") ;
                            } else{
                                sheet1.SetCellValue(loop,"senior_yn", "N") ;
                            }
                        } else if( sheet1.GetCellValue(loop,"famres").substring(6,7) == "2"
                                || sheet1.GetCellValue(loop,"famres").substring(6,7) == "4"
                                || sheet1.GetCellValue(loop,"famres").substring(6,7) == "6"
                                || sheet1.GetCellValue(loop,"famres").substring(6,7) == "8" ){
                            if( age >= 70){
                                sheet1.SetCellValue(loop,"senior_yn", "Y") ;
                            } else{
                                sheet1.SetCellValue(loop,"senior_yn", "N") ;
                            }
                        }
                    } else{
                    }

                    //주민번호 체크
                    var rResNo = sheet1.GetCellValue(loop,"famres");

                    //외국인 주민번호 체크
                    if(sheet1.GetCellValue(loop,"famres").substring(6,7) == "5"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "6"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "7"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "8"){

                        if(fgn_no_chksum(rResNo) != true){
                        	sheet1.SetCellValue(loop,"famresChk", "부적합");
                        	sheet1.SetCellValue(loop,"sStatus", "R");
                        }
                    } else {
                        if(checkRegNo(rResNo.substring(0,6), rResNo.substring(6,13)) != true){
                        	sheet1.SetCellValue(loop,"famresChk", "부적합");
                        	sheet1.SetCellValue(loop,"sStatus", "R");
                        }
                    }

                    //나이, 연령대
                    var age = 0;
                    if(sheet1.GetCellValue(loop,"famres").substring(6,7) == "3"
					        || sheet1.GetCellValue(loop,"famres").substring(6,7) == "4"
					        || sheet1.GetCellValue(loop,"famres").substring(6,7) == "7"
					        || sheet1.GetCellValue(loop,"famres").substring(6,7) == "8") {
					    age = systemYY - parseInt("20"+sheet1.GetCellValue(loop, "famres").substring(0,2), 10);
					} else {
					    age = systemYY - parseInt("19"+sheet1.GetCellValue(loop, "famres").substring(0,2), 10);
					}
                    sheet1.SetCellValue(loop, "age", age);
                    if ( age < 18 ) sheet1.SetCellValue(loop, "age_type", "18-");
                    else if ( age < 20 ) sheet1.SetCellValue(loop, "age_type", "20-");
                    else if ( 60 < age ) sheet1.SetCellValue(loop, "age_type", "60+");
                    else sheet1.SetCellValue(loop, "age_type", "");

                    sheet1.SetCellValue(loop,"sStatus", "R");
                }

            }
            sheetResize();
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }
</script>

</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>과거 인적공제 현황</li>
				<!--<li class="close"></li>-->
			</ul>
		</div>
        <div class="popup_main">
			<div class="sheet_search outer">
		    <form id="sheetForm" name="sheetForm" >
				<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
				<input type="hidden" id="searchSabun" name="searchSabun" value="" />
		        <div>
		        <table>
		        <tr>
		            <td>
		                <span>대상년도</span>
		                <input id="searchWorkYy" name ="searchWorkYy" type="text" class="text" maxlength="4" style="width:35px" value="<%=yeaYear%>"/>
		            </td>
		            <td>
		                <a href="javascript:doAction1('Search')" class="button">조회</a>
		            </td>
		        </tr>
		        </table>
		        </div>
		    </form>
		    </div>
			<div class="outer">
				<div class="sheet_title">
		        <ul>
		            <li class="txt">인적공제</li>
		            <li class="btn">
		              <a href="javascript:doAction1('Down2Excel')"   class="basic authR">다운로드</a>
		            </li>
		        </ul>
		        </div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
        </div>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
		</div>
	</div>
</body>
</html>