<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>TimeCard 업로드</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var popGubun = "";
var gPRow = "";
var sabunList = "";

	$(function() {

		$("#searchYmd").datepicker2({
            onReturn:function(date){
                doAction1("Search");
            }
        }).val("${curSysYyyyMMddHyphen}");
		

        $("#searchYmd").on("keyup", function(event) {
            if( event.keyCode == 13) {
                doAction1("Search");
            }
        });

        $("#ymdBtn1, #ymdBtn2").bind("click", function() {
            var day = 1;
            if( $(this).attr("id") == "ymdBtn1" ) day = -1; 
            var searchYmd = addDate("d", day, $("#searchYmd").val(), "-"); //전날 
            $("#searchYmd").val(searchYmd);
            doAction1("Search");
        });
        
        init_sheet2();
        init_sheet1();
		
	});


	function init_sheet1(){

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:10,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
            {Header:"사번|사번",         Type:"Text",       Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"sabun",      KeyField:1, Format:"",      UpdateEdit:0,   InsertEdit:0 },
		    {Header:"출근|근무일",        Type:"Date",       Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"ymd1",   KeyField:0, Format:"Ymd",   UpdateEdit:0,   InsertEdit:1 },
            {Header:"출근|출근일자",	   Type:"Date",		  Hidden:0,	  Width:100,	Align:"Center",	ColMerge:0,	SaveName:"inYmd",	 KeyField:0,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:1 },
			{Header:"출근|출근시간",	   Type:"Text",	  	  Hidden:0,	  Width:100,  Align:"Center",	ColMerge:0,	SaveName:"inHm",	 KeyField:0,	Format:"Hm",	UpdateEdit:0,	InsertEdit:1 },
            {Header:"퇴근|근무일",        Type:"Date",       Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"ymd2",   KeyField:0, Format:"Ymd",   UpdateEdit:0,   InsertEdit:1 },
			{Header:"퇴근|퇴근일자",      Type:"Date",       Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"outYmd",     KeyField:0, Format:"Ymd",   UpdateEdit:0,   InsertEdit:1 },
            {Header:"퇴근|퇴근시간",      Type:"Text",       Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"outHm",      KeyField:0, Format:"Hm",    UpdateEdit:0,   InsertEdit:1 },
            {Header:"\n삭제|\n삭제",       Type:"${sDelTy}",  Hidden:0,   Width:55,  Align:"Center", ColMerge:0, SaveName:"sDelete",     Sort:0 },
            {Header:"상태|상태",         Type:"${sSttTy}",  Hidden:1,   Width:45,  Align:"Center", ColMerge:0, SaveName:"sStatus",     Sort:0 },
		];IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetColProperty("gubun", {ComboText:"|출근|퇴근", ComboCode:"|01|02"});

		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함

		$(window).smartresize(sheetResize); sheetInit();
		
	}
    function init_sheet2(){
        var initdata = {};
        initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
        initdata.HeaderMode = {Sort:0,ColMove:0,ColResize:0,HeaderCheck:0};
        initdata.Cols = [
            {Header:"사번",        Type:"Text",       Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"sabun"},
            {Header:"출퇴근구분",    Type:"Text",      Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"gubun"},
            {Header:"일자",        Type:"Text",       Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"ymd"},
            {Header:"시간",        Type:"Text",       Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"hm"},
        ];IBS_InitSheet(sheet2, initdata);
    }

    function checkDate(sAction){
        if ( $("#searchYmd").val().length < 10 ){
            alert("근무일자를 입력 해주세요.");
            return false;
        }

		if(sAction === 'Save') {
			for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++) {
				let ymd1 = sheet1.GetCellValue(i, 'ymd1');
				let inYmd = sheet1.GetCellValue(i, 'inYmd');
				let ymd2 = sheet1.GetCellValue(i, 'ymd2');
				let outYmd = sheet1.GetCellValue(i, 'outYmd');

				if(ymd1 !== inYmd || ymd2 !== outYmd) {
					alert("근무일과 출근일자 또는 퇴근일자가 일치하지 않는 데이터가 있습니다.");
					return true; // 일치하지 않는 데이터가 있더라도 저장 가능해야 함. 단순 알림용도
				}

			}
		}

        return true;
    }

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if( !checkDate() ){ return; }
            $("#noti").html("");
            sheet1.DoSearch( "${ctx}/TimeCardUpload.do?cmd=getTimeCardUploadList", $("#sheet1Form").serialize());
			break;
		case "Save":

            if( !checkDate('Save') ){ return; }
            
            sabunList = IBS_GetColValue(sheet1, "sabun"); //전체 사번(삭제사번포함)
            
			if(!dupChk(sheet1,"sabun|ymd1", false, true)){break;}
            if(!dupChk(sheet1,"sabun|ymd2", false, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
            sheet1.DoSave( "${ctx}/TimeCardUpload.do?cmd=saveTimeCardUpload", $("#sheet1Form").serialize());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); break;
			
			case "LoadText":
            if( !checkDate() ){ return; }
            $("#noti").html("");
            sheet1.RemoveAll();
		    var params = { Mode : "NoHeader ", ColSeparator: $("#deli").val()} ;
			sheet2.LoadText(params);
			break;
        case "DownTemplate":
            // 양식다운로드
            sheet2.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"sabun|gubun|ymd|hm"});
            break;
        case "LoadExcel":
            if( !checkDate() ){ return; }
            sheet1.RemoveAll();
            $("#noti").html("");
            var params = {Mode:"HeaderMatch", WorkSheetNo:1}; 
            sheet2.LoadExcel(params);
            break;

		}
	}

	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); }
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);

		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
            if( Code > -1 ) {
                $("#searchYmd2").val( addDate("d", -1, $("#searchYmd").val(), "-") ); //전날
                
                //일근무갱신 (비동기)
                $.ajax({
                    url: "${ctx}/TimeCardUpload.do?cmd=prcTimeCardUpload",
                    type: "post",
                    dataType: "json",
                    async: true,
                    data: $("#sheet1Form").serialize()+sabunList
                });
                
                doAction1("Search"); 
            }
			if (Msg != "") {
				alert(Msg);
			}

		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	// LoadText 처리가 완료된 후
	//여기 안타네.. 시트 버그 인듯..
    function sheet2_OnLoadText(result) {
        try { 
            if(!result) {  
                alert("텍스트 파일 로딩중 오류가 발생하였습니다."); 
            }else{
				sheet2.ColumnSort("sabun|gubun")
                $("#noti").html("텍스트 파일 로드 완료! [저장] 해주세요");

				sheetResize();

				if( $("#autoSave").is(':checked') ){
					doAction1("Save");
				}
            }
            sheetResize();
        } catch (ex) {
            alert("OnLoadText Event Error : " + ex);

        }
    }
	

    // LoadExcel 처리가 완료된 후
    function sheet2_OnLoadExcel(result) {
        try { 
            if(!result) {  
                alert("파일 로딩중 오류가 발생하였습니다."); 
            }else{

                sheet2.ColumnSort("sabun|gubun")
                
                $("#noti").html("파일 로드 완료! [저장] 해주세요");

                sheetResize();

                if( $("#autoSave").is(':checked') ){
                    doAction1("Save");
                }
            }
        } catch (ex) {
            alert("OnLoadExcel Event Error : " + ex);

        }
    }

    // Sort 처리가 완료된 후
    function sheet2_OnSort(Col, SortArrow) {
        try { 
            var row = -1, sabun = "";
            var workYmd = $("#searchYmd").val();
            var workYmd2 = addDate("d", -1, workYmd, "-"); //전날 
            for(var i = sheet2.HeaderRows(); i < sheet2.RowCount()+sheet2.HeaderRows() ; i++) {
                if( sheet2.GetCellValue( i, "gubun" ) == "01" ){  //출근
                    sabun = sheet2.GetCellValue( i, "sabun" );
                    row = sheet1.DataInsert(-1) ;
                    sheet1.SetCellValue(row, "ymd1", workYmd, 0 );
                    sheet1.SetCellValue(row, "sabun", sabun, 0 );
                    sheet1.SetCellValue(row, "inYmd", sheet2.GetCellValue( i, "ymd" ), 0 );
                    sheet1.SetCellValue(row, "inHm",  sheet2.GetCellValue( i, "hm" ), 0 );

                    //2300 출근인데 12시를 넘겨서 출근한경우... 
                    if( sheet1.GetCellValue(row, "inHm") != "" && sheet1.GetCellValue(row, "inHm") > "0000" && sheet1.GetCellValue(row, "inHm") < "0200" ){
                        sheet1.SetCellValue(row, "ymd2", workYmd2, 0 );
                        sheet1.SetCellBackColor(row, "ymd2", "#FFF5C8");       
                    }
                            
                    
                }else if( sheet2.GetCellValue( i, "gubun" ) == "02" && sabun == sheet2.GetCellValue( i, "sabun" )){  //퇴근

                    sheet1.SetCellValue(row, "ymd2", workYmd, 0 );
                    sheet1.SetCellValue(row, "outYmd", sheet2.GetCellValue( i, "ymd" ), 0 );
                    sheet1.SetCellValue(row, "outHm",  sheet2.GetCellValue( i, "hm" ), 0 );
                    
                    if( sheet1.GetCellValue(row, "inHm") != "" && sheet1.GetCellValue(row, "outHm") != ""
                        && sheet1.GetCellValue(row, "outHm") < sheet1.GetCellValue(row, "inHm") ){
                        sheet1.SetCellValue(row, "ymd2", workYmd2, 0 );
                        sheet1.SetCellBackColor(row, "ymd2", "#FFF5C8");    
                    }  
                }else{ //출근없이 퇴근만 있는경우
                    row = sheet1.DataInsert(-1) ;
                    sheet1.SetCellValue(row, "ymd2", workYmd2, 0 );
                    sheet1.SetCellValue(row, "sabun", sheet2.GetCellValue( i, "sabun" ), 0 );
                    sheet1.SetCellValue(row, "outYmd", sheet2.GetCellValue( i, "ymd" ), 0 );
                    sheet1.SetCellValue(row, "outHm",  sheet2.GetCellValue( i, "hm" ), 0 );
                    sheet1.SetCellBackColor(row, "ymd2", "#FFF5C8");  
                }
            }

            sheet1.ColumnSort("inHm")
            sheet1.SetSelectRow(2);
	    } catch (ex) {
	        alert("OnLoadExcel Event Error : " + ex);
	
	    }
	        
    }
</script>
<style type="text/css">
#noti {color:red; font-weight: bold; font-size:1.2em; margin-right:10px;}
#ymdBtn1, #ymdBtn2 {border:1px solid #e0e2e5; color:#3f4145; padding:5px 3px; cursor:pointer; vertical-align:middle; }
</style>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="outer">
		<form id="sheet1Form" name="sheet1Form" >
        <input type="hidden" id="searchYmd2" name="searchYmd2" />
		
		<div class="sheet_search">
			<table>
				<tr>
					<th><tit:txt mid='104060' mdef='근무일'/> </th>
					<td>
						<input type="text" id="searchYmd" name="searchYmd"  class="date2 required " value="" />
                        <a id="ymdBtn1">◀</a>
						<a id="ymdBtn2">▶</a>
					</td>
					<td>
						<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/>
					</td>
				</tr>
			</table>
			</div>
		</form>
		
	    <table class="table mat10" >
	    <colgroup>
	        <col width="100px"/>
	        <col width="350px"/>
	        <col width="100px"/>
	        <col width="250px"/>
	        <col width=""/>
	    </colgroup>
	    <tr>
	        <th>Text파일</th>
	        <td>
                <span><b>txt 구분자 : </b></span>
                <select id="deli" class="w80">
                    <option value=" ">공백</option>
                    <option value="">탭</option>
                </select>
                &nbsp;&nbsp;&nbsp;
                <a href="javascript:doAction1('LoadText');"    class="btn soft authA">TXT업로드</a>
	        </td>
	        <th>엑셀파일</th>
	        <td>
	            <a href="javascript:doAction1('DownTemplate');" class="btn outline_gray authR">엑셀양식다운로드</a>
	            <a href="javascript:doAction1('LoadExcel');"   class="btn soft authA">엑셀업로드</a>
	        </td>
	        <td>
	           <b>출퇴근구분</b> - 01:출근, 02:퇴근
	        </td>
	    </tr>
	    <tr>
           <th>주의사항</th>
	       <td colspan="4">
	           출근시간보다 퇴근시간이 빠른 경우 근무일자가 이전날로 자동 변경 됩니다. 확인 후 저장 해주세요.
	       </td>
	    </tr>
	    </table>
	    
	</div>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">TimeCard 업로드</li>
				<li class="btn">
				    <span id="noti"></span>
                    &nbsp;&nbsp;&nbsp;
                    <a href="javascript:doAction1('Down2Excel');"  class="btn outline-gray authR">다운로드</a>
                    <a href="javascript:doAction1('Save');"        class="btn filled authA">저장</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
	<div class="hide">
        <script type="text/javascript">createIBSheet("sheet2", "100%", "0"); </script>
    </div>

</div>
</body>
</html>