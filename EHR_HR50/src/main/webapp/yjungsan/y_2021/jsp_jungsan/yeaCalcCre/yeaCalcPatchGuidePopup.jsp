<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산 패치현황</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
    var p = eval("<%=popUpStatus%>");
    var patchSeq = "";

    $(function() {
    	$("#menuNm").val($(document).find("title").text());

        var searchWorkYy        = "";
        var searchAdjustType    = "";

		if(!p.window.opener) {
			searchWorkYy = $("#searchWorkYy", parent.document).val();
			searchAdjustType = $("#searchAdjustType", parent.document).val();

			$("#popup_title").hide();
		}
		else {

	        var arg = p.window.dialogArguments;

	        if( arg != undefined ) {
	            searchWorkYy        = arg["searchWorkYy"];
	            searchAdjustType    = arg["searchAdjustType"];
	        }else{
	            searchWorkYy      = p.popDialogArgument("searchWorkYy");
	            searchAdjustType  = p.popDialogArgument("searchAdjustType");
	        }
		}
        $("#searchWorkYy").val(searchWorkYy);
        $("#searchAdjustType").val(searchAdjustType);

        //작업구분
        //var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","YEA005"), "전체");
        //$("#inputCdType").html(adjustTypeList[2]).val("1");

        doAction1("Search");

    });

    $(function(){
    	var initdata1 = {};
    	initdata1.Cfg = {SearchMode:smLazyLoad,Page:1000,MergeSheet:msAll};
    	initdata1.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
    	initdata1.Cols = [
                        {Header:"No",       	Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
                        {Header:"대상년도", 	    Type:"Text",            Hidden:1,  Width:20,     Align:"Center",    ColMerge:0,   SaveName:"work_yy",   	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"정산구분",    	Type:"Text",            Hidden:1,  Width:20,     Align:"Center",    ColMerge:0,   SaveName:"adjust_type",   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"패치차수",    	Type:"Text",            Hidden:1,  Width:20,     Align:"Center",    ColMerge:0,   SaveName:"patch_seq",   	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"차수",    		Type:"Text",            Hidden:0,  Width:30,     Align:"Center",    ColMerge:1,   SaveName:"patch_seq_nm",  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"패치일자",    	Type:"Text",            Hidden:0,  Width:60,     Align:"Center",    ColMerge:1,   SaveName:"patch_ymd",  	KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"업무명",     	Type:"Text",            Hidden:0,  Width:80,     Align:"Center",    ColMerge:1,   SaveName:"biz_nm",   		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"패치내역",    	Type:"Text",            Hidden:0,  Width:250,    Align:"Left",    	ColMerge:0,   SaveName:"patch_desc",   	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, ToolTip:1 }
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(0);

        sheet1.SetFocusAfterProcess(0);
        $(window).smartresize(sheetResize); sheetInit();

    });

    $(function() {
		$("#searchPatchDesc").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});

    function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/yeaCalcCre/yeaCalcPatchGuidePopupRst.jsp?cmd=selectYeaCalcPatchGuidePopupInfo", $("#sheetForm").serialize() );
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N",menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
		}
	}

    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			//alertMessage(Code, Msg, StCode, StMsg);
			/* if (Code == 1) {
				if(patchSeq == "") {
					var loop = sheet1.LastRow();
	                for(loop = 1 ; loop <= sheet1.LastRow() ; loop++){
	                	if(loop == 1) {
	                		patchSeq = sheet1.GetCellValue(loop,"patch_seq");
	                	} else {
	                		if(patchSeq < sheet1.GetCellValue(loop,"patch_seq")) {
	                			patchSeq = sheet1.GetCellValue(loop,"patch_seq");
	                		}
	                	}
	                }

	                if(patchSeq > 0) {
	                	for(var i = patchSeq; i>0; i--) {
	                		$("#searchPatchSeq").append("<option value='"+i+"'>"+i+"차</option>");
	                	}
	                }

				}
			} */
			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

    function patchGuidePopupClose() {
    	var chk = $("#popupChk:checked").val();

    	/*
    	if(chk != null && chk != undefined && chk == 'Y'){
    		setCookie( "patchGuidePopupInfo", "Y|"+patchSeq , 1);
    	}*/
    	p.self.close();
    }

    function setCookie(cname, value, expire) {
   	   var todayValue = new Date();
   	   todayValue.setDate(todayValue.getDate() + expire);
   	   document.cookie = cname + "=" + encodeURI(value) + "; expires=" + todayValue.toGMTString() + "; path=/;";
   	}

</script>

</head>
<body class="bodywrap" style="overflow:auto;">
<form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="searchWorkYy" name="searchWorkYy" value=""/>
    <input type="hidden" id="searchAdjustType" name="searchAdjustType" value=""/>
    <input type="hidden" id="menuNm" name="menuNm" value="" />

    <div class="wrapper">
        <div class="popup_title" id="popup_title" style="display:none;">
	        <ul>
	            <li id="strTitle">연말정산 패치현황</li>
	        </ul>
        </div>
        <div class="outer popup_main" style="margin:0; padding:10px">
        	<div class="sheet_search outer">
		        <div>
			        <table>
						<tr>
							<!-- <td>
								<span>패치차수</span>
								<select id="searchPatchSeq" name ="searchPatchSeq" onChange="javascript:doAction1('Search')" class="box">
									<option value="" selected="selected">전체</option>
								</select>
							</td>
							<td>
								<span>업무구분</span>
								<select id="inputCdType" name ="inputCdType" onChange="javascript:doAction1('Search')" class="box">
									<option value="" selected="selected">전체</option>
								</select>
							</td> -->
							<td>
								<span>패치내역</span>
								<input id="searchPatchDesc" name ="searchPatchDesc" type="text" class="text" style="width:100px"/>
							</td>
							<td>
		                        <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
		                    </td>
						</tr>
			        </table>
		        </div>
		    </div>
		    <div class="outer">
				<div class="sheet_title">
				<ul>
					<li class="txt">패치내역</li>
					<li class="btn">
						<a href="javascript:doAction1('Down2Excel')"	class="basic btn-download authR">다운로드</a>
					</li>
				</ul>
				</div>
			</div>
        	<script type="text/javascript">createIBSheet("sheet1", "100%", "400px"); </script>

        	<!-- <div class="popup_button"  style="clear: both;">
	            <ul>
	            	<li>
	                	<a href="javascript:patchGuidePopupClose();" class="gray large">닫기</a>
	                </li>
	            </ul>
	        </div> -->
        </div>


    </div>
</form>
</body>
</html>



