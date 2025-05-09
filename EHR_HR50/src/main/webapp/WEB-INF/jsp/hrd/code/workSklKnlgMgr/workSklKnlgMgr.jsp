<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
    
    <script type="text/javascript">
//         var confirmYn = true;
//         var popupGubun = "";
        var gPRow = "";
        var pGubun = "";

        $(function() {
            var initdata = {};
//             initdata.Cfg = {SearchMode:smGeneral,MergeSheet:msHeaderOnly};
//             initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
            
            initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22,MergeSheet:msAll};
            initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
            initdata.Cols = [
                {Header:"<sht:txt mid='sNo'     mdef='No'           />", Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
                {Header:"<sht:txt mid='sDelete' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:30,	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
                {Header:"<sht:txt mid='sStatus'     mdef='상태'        />",				Type:"${sSttTy}" , Hidden:Number("${sSttHdn}"), Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
                {Header:"<sht:txt mid='BLANK'   mdef='직무코드'     />", Type:"Text"  , Hidden:1, Width:50  ,  Align:"Center"      , ColMerge:0, SaveName:"workAssignCd"          ,    KeyField:1, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1000      },
                {Header:"<sht:txt mid='BLANK'   mdef='직무명'     />", Type:"Popup"  , Hidden:0, Width:200  ,  Align:"Center"      , ColMerge:0, SaveName:"workAssignNm"          ,    KeyField:1, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1000      },
                {Header:"<sht:txt mid='BLANK'   mdef='지식타입'     />", Type:"Text"  , Hidden:1, Width:0  ,  Align:"Center"      , ColMerge:0, SaveName:"techBizType"          ,    KeyField:1, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1000      },
                {Header:"<sht:txt mid='BLANK'   mdef='스킬'     />", Type:"Combo"  , Hidden:0, Width:200,  Align:"Center"      , ColMerge:0, SaveName:"skilCd"            ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1000 },
                {Header:"<sht:txt mid='BLANK'   mdef='지식'     />", Type:"Combo"  , Hidden:1, Width:200,  Align:"Center"      , ColMerge:0, SaveName:"knowledgeCd"            ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1000 },
                {Header:"<sht:txt mid='BLANK'   mdef='직무노트코드'     />", Type:"Text"  , Hidden:1, Width:50  ,  Align:"Center"      , ColMerge:0, SaveName:"workAssignNoteCd"          ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1000      },
                {Header:"<sht:txt mid='BLANK'   mdef='레벨'     />", Type:"Combo"  , Hidden:0, Width:50,  Align:"Center"      , ColMerge:0, SaveName:"holdLevel"          ,    KeyField:0, CalcLogic:"", Format:""           ,  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1000   },
            ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
            
            
            sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_x.png");
            sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
//             sheet1.SetDataLinkMouse("trmCd" , 1);
            
            //TRM코드 라디오버튼
    		var html_trmCd = "";
    		var trmCdList = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTrmCdList",false).codeList;
    	    for (i = 0; i < trmCdList.length; i++) {
    	    	html_trmCd += "<input type='radio' id='searchTechBizType"+trmCdList[i].code+"' name='searchTechBizType' value='"+trmCdList[i].code+"' onClick=setMode('"+trmCdList[i].code+"'); " + (i == 0 ? "checked='checked'" : "") + ">"
    	     	                         +"<label for='searchTechBizType"+trmCdList[i].code+"'>"+trmCdList[i].codeNm+"</label>";

    	    }
    		$("#DIV_trmCd").html(html_trmCd);
    		
    		if(trmCdList.length > 0){
    			$("#searchTechBizType1").attr("checked","checked");
    		}
    		
    		SetSheetColumnLookup(sheet1, "holdLevel"   , convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00008"), "") );
    		
    		SetSheetColumnLookup(sheet1, "skilCd"   , convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWorkMgrSklList",false).codeList, "") );
            SetSheetColumnLookup(sheet1, "knowledgeCd"   , convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWorkMgrKnlgList",false).codeList, "") );
    		
            $(window).smartresize(sheetResize); sheetInit();
        });

        $(function() {
            setMode("S");
        });
        
        function doAction1(sAction) {
            switch (sAction) {
                case "Search":

                    var sMode = $("#searchBizType").val();

                    if (sMode == "S") {
                    	sheet1.SetColProperty("skilCd" ,{KeyField:true});
                    	sheet1.SetColProperty("knowledgeCd" ,{KeyField:false});
                    	sheet1.SetColHidden("knowledgeCd", 1);
                        sheet1.SetColHidden("skilCd", 0);
						sheet1.SetCellText(0,"skilCd",$("label[for ='searchTechBizType"+sMode+"']").text());
                        sheet1.DoSearch( "${ctx}/WorkSklKnlgMgr.do?cmd=getWorkSklMgrList"    , $("#srchFrm").serialize());
                    }else{
                    	sheet1.SetColProperty("skilCd" ,{KeyField:false});
                    	sheet1.SetColProperty("knowledgeCd" ,{KeyField:true});
                    	sheet1.SetColHidden("knowledgeCd", 0);
                        sheet1.SetColHidden("skilCd", 1);
                        sheet1.SetCellText(0,"knowledgeCd",$("label[for ='searchTechBizType"+sMode+"']").text());
                        sheet1.DoSearch( "${ctx}/WorkSklKnlgMgr.do?cmd=getWorkKnlgMgrList", $("#srchFrm").serialize());
                    }
                    
                    sheet1.SetCellText(0,"sStatus","상태");
                    
                    break;
                case "Down2Excel":
                    var downcol = makeHiddenSkipCol(sheet1);
                    var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
                    sheet1.Down2Excel(param);
                    break;
                case "Insert":
                	
//                 	if(sheet1.GetRowLevel(sheet1.GetSelectRow()) > 0){
//                 		return;
//                 	}
                	
                	var Row = sheet1.DataInsert();
                	
                	if($("#searchBizType").val() == "S"){
//                			sheet1.SetCellValue(Row,"codeType","S");
                	}else if($("#searchBizType").val() == "T"){
                		sheet1.SetCellValue(Row,"techBizType","T");
//                			sheet1.SetCellValue(Row,"codeType","K");
                	}else if($("#searchBizType").val() == "B"){
                		sheet1.SetCellValue(Row,"techBizType","B");
//                			sheet1.SetCellValue(Row,"codeType","K");
                	}
                	
//         			sheet1.SelectCell(Row, "codeNm");	
        			
//         			sheet1.SetRowEditable(Row, 1) ;
        			
                	break;
                case "Save":
                	var sMode = $("#searchBizType").val();

                    if (sMode == "S") {
                    	if(!dupChk(sheet1,"workAssignCd|skilCd", true, true)){break;}
                    }else{
                    	if(!dupChk(sheet1,"workAssignCd|knowledgeCd", true, true)){break;}
                    }

                    isNotSaveMsg = false;
                    IBS_SaveName(document.srchFrm,sheet1);
        			sheet1.DoSave( "${ctx}/WorkSklKnlgMgr.do?cmd=saveWorkSklKnlgMgrList", $("#srchFrm").serialize() );
        			
        			break;
                	
            }
        }

        function setMode(str) {
            $("#searchBizType").val(str);
            doAction1("Search");
        }


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

        function sheet1_OnClick(Row, Col, Value) {
            try{
                if(sheet1.ColSaveName(Col)=="workAssignNm" && sheet1.GetCellValue(Row,"sStatus") == "I") {
                	workAssignPopup(Row);
                }
            }catch(ex){alert("OnClick Event Error : " + ex);}
        }

        function workAssignPopup(Row) {
            if (!isPopup()) {
                return;
            }
            var w = 840;
            var h = 520;
            <%--var url = "${ctx}/WorkSklKnlgMgr.do?cmd=viewWorkAssignPopup&authPg=${authPg}";--%>
            var url = "${ctx}/WorkSklKnlgMgr.do?cmd=viewWorkAssignLayer&authPg=${authPg}";

            gPRow = Row;
            pGubun = "workAssignMgrPopup";

            // openPopup(url, args, w, h);

            var workAssignLayer = new window.top.document.LayerModal({
                id: 'workAssignLayer',
                url: url,
                parameters: {},
                width: w,
                height: h,
                title: '단위업무체계조회',
                trigger: [
                    {
                        name: 'workAssignLayerTrigger',
                        callback: function(rv) {
                            getReturnValue(rv);
                        }
                    }
                ]
            });
            workAssignLayer.show();
        }


        //팝업 콜백 함수.
        function getReturnValue(rv) {

            if(pGubun == "workAssignMgrPopup"){
           		sheet1.SetCellValue(gPRow,"workAssignCd",(rv.workAssignCd));
           		sheet1.SetCellValue(gPRow,"workAssignNm",(rv.workAssignNm));
            }
        }
        
        // 저장 후 메시지
    	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
    		try {
    			if( !isNotSaveMsg  ){
    				if (Msg != "") {
    					alert(Msg);
    				}
    				doAction1("Search");
    			}
    		} catch (ex) {
    			alert("OnSaveEnd Event Error " + ex);
    		}
    	}
        
    	
    	var SetSheetColumnLookup = function(sheet, columnName, lookupList){
    		sheet.SetColProperty(columnName, 	{ComboText:"|"+ lookupList[0], ComboCode:"|"+lookupList[1]} );
    	}

    </script>
</head>
<body class="hidden">
<div class="wrapper">
    <form id="srchFrm" name="srchFrm" >

        <input type="hidden" id="searchBizType" name="searchBizType" value="" />

        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                        <td>
                        	<div id="DIV_trmCd">
                        	</div>
                        </td>
                        <td>
                            <a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
    <div class="inner">
        <div class="sheet_title">
            <ul>
                <li id="txt" class="txt">직무별스킬/지식관리</li>
                <li class="btn">
	                <a href="javascript:doAction1('Insert')" class="basic authA"><tit:txt mid='104267' mdef='입력'/></a>
					<a href="javascript:doAction1('Save')" 	class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
                    <a href="javascript:doAction1('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
                </li>
            </ul>
        </div>
    </div>
    <script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
