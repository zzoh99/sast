<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>기타공제</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ include file="yeaDataCommon.jsp"%>

<%String orgAuthPg = request.getParameter("orgAuthPg");%>

<script type="text/javascript">
	var orgAuthPg = "<%=removeXSS(orgAuthPg, '1')%>";
	//도움말
	var helpText;
	//기준년도
	var systemYY;
	//총급여
    var paytotMonStr;
	//총급여 확인 버튼 보여주기 유무 정보에 따라 컨트롤
    var yeaMonShowYn;

	$(function() {

        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		/*필수 기본 세팅*/
		$("#searchWorkYy").val( 	$("#searchWorkYy", parent.document).val() 		) ;
		$("#searchAdjustType").val( $("#searchAdjustType", parent.document).val() 	) ;
		$("#searchSabun").val( 		$("#searchSabun", parent.document).val() 		) ;
		systemYY = $("#searchWorkYy", parent.document).val();

		$("#A100_30").mask('000,000,000,000,000', {reverse: true});
		$("#A100_11").mask('000,000,000,000,000', {reverse: true});
		$("#A100_21").mask('000,000,000,000,000', {reverse: true});
		$("#A100_37").mask('000,000,000,000,000', {reverse: true});
		$("#A100_38").mask('000,000,000,000,000', {reverse: true});

        <%//2016년 추가 start %>
		//$("#A100_59").mask('000,000,000,000,000', {reverse: true});
		//$("#A100_60").mask('000,000,000,000,000', {reverse: true});
        <%//2016년 추가 end %>

        <%//2017년 추가 start %>
        //$("#A100_71").mask('000,000,000,000,000', {reverse: true});
        //$("#A100_72").mask('000,000,000,000,000', {reverse: true});
        <%//2017년 추가 end %>

        <%//2018년 추가 start %>
        //$("#A100_73").mask('000,000,000,000,000', {reverse: true});
        //$("#A100_74").mask('000,000,000,000,000', {reverse: true});
        <%//2018년 추가 end %>

        <%//2019년 추가 start %>
        //$("#A100_75").mask('000,000,000,000,00ㄴ', {reverse: true});
        //$("#A100_79").mask('000,000,000,000,000', {reverse: true});
        //$("#A100_76").mask('000,000,000,000,000', {reverse: true});
        <%//2019년 추가 end %>

        <%//2020년 추가 start %>
        //$("#A100_77").mask('000,000,000,000,000', {reverse: true});
        //$("#A100_80").mask('000,000,000,000,000', {reverse: true});
        //$("#A100_78").mask('000,000,000,000,000', {reverse: true});
        <%//2020년 추가 end %>

        <%//2021년 추가 start %>
        $("#A100_81").mask('000,000,000,000,000', {reverse: true});
        $("#A100_82").mask('000,000,000,000,000', {reverse: true});
        $("#A100_83").mask('000,000,000,000,000', {reverse: true});
        <%//2021년 추가 end %>
        
        <%//2022년 추가 start %>
        $("#A100_84").mask('000,000,000,000,000', {reverse: true});
        $("#A100_85").mask('000,000,000,000,000', {reverse: true});
        $("#A100_86").mask('000,000,000,000,000', {reverse: true});
        <%//2022년 추가 end %>
        
        <%//2023년 추가 start %>
        $("#A100_87").mask('000,000,000,000,000', {reverse: true});
        $("#A100_88").mask('000,000,000,000,000', {reverse: true});
        $("#A100_89").mask('000,000,000,000,000', {reverse: true});
        <%//2023년 추가 end %>

		//기본정보 조회(도움말 등등).
		initDefaultData() ;

		//2020-12-23. 담당자 마감일때 수정 불가 처리
		var empStatus = $("#tdStatusView>font:first", parent.document).attr("class");
		if(orgAuthPg == "A" && (empStatus == "close_3" || empStatus == "close_4")) {
			$("#btnDisplayYn01").hide() ;
		}

		//기본자료 조회
		parent.doSearchCommonSheet();


		if( yeaMonShowYn == "Y"){
            $("#paytotMonViewYn1").show() ;
            $("#paytotMonViewYn2").show() ;
        }else if(yeaMonShowYn == "A"){
            if(orgAuthPg == "A") {
                $("#paytotMonViewYn1").show() ;
                $("#paytotMonViewYn2").show() ;
            }else{
                $("#paytotMonViewYn1").hide() ;
                $("#paytotMonViewYn2").hide() ;
            }
        }else{
            $("#paytotMonViewYn1").hide() ;
            $("#paytotMonViewYn2").hide() ;
        }
	});

	//기본데이터 조회
	function initDefaultData() {
		//도움말 조회
		var param1 = "searchWorkYy="+$("#searchWorkYy").val();
		param1 += "&queryId=getYeaDataHelpText";

        var param2 = "searchWorkYy="+$("#searchWorkYy").val();
        param2 += "&searchAdjustType="+$("#searchAdjustType").val();
        param2 += "&searchSabun="+$("#searchSabun").val();
        param2 += "&queryId=getYeaDataPayTotMon";

		var result1 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param1+"&adjProcessCd=A100",false);
		helpText = nvl(result1.Data.help_text1,"") + nvl(result1.Data.help_text2,"") + nvl(result1.Data.help_text3,"");

        var result2 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param2+"&searchNumber=1",false);
        paytotMonStr = nvl(result2.Data.paytot_mon,"");

		//총급여 확인 버튼 유무
        var result4 = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_MON_SHOW_YN", "queryId=getSystemStdData",false).codeList;
        yeaMonShowYn = nvl(result4[0].code_nm,"");

      	//안내메세지 1
        $("#infoLayer").html(helpText).hide();
      	//안내메세지 2
        $("#infoLayer2").html(helpText).hide();
      	//안내메세지 3
        $("#infoLayer3").html(helpText).hide();
      	//안내메세지 4
        $("#infoLayer4").html(helpText).hide();
	}

	//기본자료 설정.
	function sheetSet(){
		var comSheet = parent.commonSheet;

		if(comSheet.RowCount() > 0){

			$("#A100_30").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_30") > 0 ? comSheet.FindText("adj_element_cd", "A100_30") : "","input_mon"));
			$("#A100_11").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_11") > 0 ? comSheet.FindText("adj_element_cd", "A100_11") : "","input_mon"));
			$("#A100_21").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_21") > 0 ? comSheet.FindText("adj_element_cd", "A100_21") : "","input_mon"));
			$("#A100_37").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_37") > 0 ? comSheet.FindText("adj_element_cd", "A100_37") : "","input_mon"));
			$("#A100_38").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_38") > 0 ? comSheet.FindText("adj_element_cd", "A100_38") : "","input_mon"));

            <%//2016년 추가 start %>
			//$("#A100_59").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_59"),"input_mon"));
			//$("#A100_60").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_60"),"input_mon"));
            <%//2016년 추가 end %>

            <%//2017년 추가 start %>
            //$("#A100_71").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_71"),"input_mon"));
            //$("#A100_72").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_72"),"input_mon"));
            <%//2017년 추가 end %>

            <%//2018년 추가 start %>
            //$("#A100_73").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_73") > 0 ? comSheet.FindText("adj_element_cd", "A100_73") : "","input_mon"));
            //$("#A100_74").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_74") > 0 ? comSheet.FindText("adj_element_cd", "A100_74") : "","input_mon"));
            <%//2018년 추가 end %>

            <%//2019년 추가 start %>
            //$("#A100_75").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_75") > 0 ? comSheet.FindText("adj_element_cd", "A100_75") : "","input_mon"));
            //$("#A100_79").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_79") > 0 ? comSheet.FindText("adj_element_cd", "A100_79") : "","input_mon"));
            //$("#A100_76").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_76") > 0 ? comSheet.FindText("adj_element_cd", "A100_76") : "","input_mon"));
            <%//2019년 추가 end %>

            <%//2020년 추가 start %>
            //$("#A100_77").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_77") > 0 ? comSheet.FindText("adj_element_cd", "A100_77") : "","input_mon"));
            //$("#A100_80").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_80") > 0 ? comSheet.FindText("adj_element_cd", "A100_80") : "","input_mon"));
            //$("#A100_78").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_78") > 0 ? comSheet.FindText("adj_element_cd", "A100_78") : "","input_mon"));
            <%//2020년 추가 end %>

            <%//2021년 추가 start %>
            $("#A100_81").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_81") > 0 ? comSheet.FindText("adj_element_cd", "A100_81") : "","input_mon"));
            $("#A100_82").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_82") > 0 ? comSheet.FindText("adj_element_cd", "A100_82") : "","input_mon"));
            $("#A100_83").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_83") > 0 ? comSheet.FindText("adj_element_cd", "A100_83") : "","input_mon"));
            <%//2021년 추가 end %>
            
            <%//2022년 추가 start %>
            $("#A100_84").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_84") > 0 ? comSheet.FindText("adj_element_cd", "A100_84") : "","input_mon"));
            $("#A100_85").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_85") > 0 ? comSheet.FindText("adj_element_cd", "A100_85") : "","input_mon"));
            $("#A100_86").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_86") > 0 ? comSheet.FindText("adj_element_cd", "A100_86") : "","input_mon"));
            <%//2022년 추가 end %>
            
            <%//2023년 추가 start %>
            $("#A100_87").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_87") > 0 ? comSheet.FindText("adj_element_cd", "A100_87") : "","input_mon"));
            $("#A100_88").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_88") > 0 ? comSheet.FindText("adj_element_cd", "A100_88") : "","input_mon"));
            $("#A100_89").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_89") > 0 ? comSheet.FindText("adj_element_cd", "A100_89") : "","input_mon"));
            <%//2023년 추가 end %>

		} else {
			$("#A100_30").val("");
			$("#A100_11").val("");
			$("#A100_21").val("");
			$("#A100_37").val("");
			$("#A100_38").val("");

            <%//2016년 추가 start %>
            //$("#A100_59").val("");
			//$("#A100_60").val("");
            <%//2016년 추가 end %>

            <%//2017년 추가 start %>
			//$("#A100_71").val("");
			//$("#A100_72").val("");
            <%//2017년 추가 end %>

            <%//2018년 추가 start %>
			//$("#A100_73").val("");
			//$("#A100_74").val("");
            <%//2018년 추가 end %>

            <%//2019년 추가 start %>
			//$("#A100_75").val("");
			//$("#A100_79").val("");
			//$("#A100_76").val("");
            <%//2019년 추가 end %>

            <%//2020년 추가 start %>
			//$("#A100_77").val("");
			//$("#A100_80").val("");
			//$("#A100_78").val("");
            <%//2020년 추가 end %>

            <%//2021년 추가 start %>
			$("#A100_81").val("");
			$("#A100_82").val("");
			$("#A100_83").val("");
            <%//2021년 추가 end %>

            <%//2022년 추가 start %>
			$("#A100_84").val("");
			$("#A100_85").val("");
			$("#A100_86").val("");
            <%//2022년 추가 end %>
            
            <%//2023년 추가 start %>
			$("#A100_87").val("");
			$("#A100_88").val("");
			$("#A100_89").val("");
            <%//2023년 추가 end %>
		}
	}

	//연말정산 안내
	function yeaDataExpPopup(title, helpText, height, width){
		var url 	= "<%=jspPath%>/common/yeaDataExpPopup.jsp";
		openYeaDataExpPopup(url, width, height, title, helpText);
	}

	//데이터 저장.
	function saveCommonData(){
		var comSheet = parent.commonSheet;

		if(comSheet.RowCount() == 0) {
			return;
		} else {
			parent.doInsertCommonSheet("A100_11",$("#A100_11").val());
			parent.doInsertCommonSheet("A100_21",$("#A100_21").val());
			parent.doInsertCommonSheet("A100_30",$("#A100_30").val());
			parent.doInsertCommonSheet("A100_37",$("#A100_37").val());
			parent.doInsertCommonSheet("A100_38",$("#A100_38").val());
			<%//2016년 추가 start %>
			//parent.doInsertCommonSheet("A100_59",$("#A100_59").val());
			//parent.doInsertCommonSheet("A100_60",$("#A100_60").val());
			<%//2016년 추가 end %>
			<%//2017년 추가 start %>
			//parent.doInsertCommonSheet("A100_71",$("#A100_71").val());
			//parent.doInsertCommonSheet("A100_72",$("#A100_72").val());
			<%//2017년 추가 end %>
			<%//2018년 추가 start %>
			//parent.doInsertCommonSheet("A100_73",$("#A100_73").val());
			//parent.doInsertCommonSheet("A100_74",$("#A100_74").val());
			<%//2018년 추가 end %>
			<%//2019년 추가 start %>
			//parent.doInsertCommonSheet("A100_75",$("#A100_75").val());
			//parent.doInsertCommonSheet("A100_79",$("#A100_79").val());
			//parent.doInsertCommonSheet("A100_76",$("#A100_76").val());
			<%//2019년 추가 end %>
			<%//2020년 추가 start %>
			//parent.doInsertCommonSheet("A100_77",$("#A100_77").val());
			//parent.doInsertCommonSheet("A100_80",$("#A100_80").val());
			//parent.doInsertCommonSheet("A100_78",$("#A100_78").val());
			<%//2020년 추가 end %>
			<%//2021년 추가 start %>
			parent.doInsertCommonSheet("A100_81",$("#A100_81").val());
			parent.doInsertCommonSheet("A100_82",$("#A100_82").val());
			parent.doInsertCommonSheet("A100_83",$("#A100_83").val());
			<%//2021년 추가 end %>
			<%//2022년 추가 start %>
			parent.doInsertCommonSheet("A100_84",$("#A100_84").val());
			parent.doInsertCommonSheet("A100_85",$("#A100_85").val());
			parent.doInsertCommonSheet("A100_86",$("#A100_86").val());
			<%//2022년 추가 end %>
			
			<%//2022년 추가 start %>
			parent.doInsertCommonSheet("A100_87",$("#A100_87").val());
			parent.doInsertCommonSheet("A100_88",$("#A100_88").val());
			parent.doInsertCommonSheet("A100_89",$("#A100_89").val());
			<%//2022년 추가 end %>
			parent.doSaveCommonSheet();
		}
		//parent.getYearDefaultInfoObj();
	}

	function sheetChangeCheck() {
		return false;
	}

	//[총급여] 보이기
    function paytotMonView(){
        if(paytotMonStr != ""){

            if( ( paytotMonStr.replace(/,/gi, "") *1 ) > 70000000 ) {
                $("#span_paytotMonView2").html("<B>YES</B>&nbsp;<a class='under-line bold' href='javascript:paytotMonViewClose()'>닫기</a>");
            }else{
                $("#span_paytotMonView2").html("<B>NO</B>&nbsp;<a class='under-line bold' href='javascript:paytotMonViewClose()'>닫기</a>");
            }
        } else {
            alert("총급여 내역이 없습니다. 관리자에게 문의해 주십시요.");
        }
    }

    //[총급여] 닫기
    function paytotMonViewClose(){
       $("#span_paytotMonView2").html("");
    }

$(document).ready(function(){

    	/* 1번 버튼 */
    	//안내+ 버튼 선택시 안내- 버튼 호출
    	$("#InfoPlus1").live("click",function(){
	    		var btnId = $(this).attr('id');
	    		if(btnId == "InfoPlus1"){
	    			$("#InfoMinus1").show();
	    			$("#InfoPlus1").hide();
	    		}
    	});

    	//안내- 버튼 선택시 안내+ 버튼 호출
    	$("#InfoMinus1").live("click",function(){
    			var btnId = $(this).attr('id');
	    		if(btnId == "InfoMinus1"){
	    			$("#InfoPlus1").show();
	    			$("#InfoMinus1").hide();
	    		}
		});

    	//안내+ 선택시 화면 호출
    	$("#InfoPlus1").click(function(){
    		$("#infoLayer").show("fast");
    		$("#infoLayerMain").show("fast");
        });

    	//안내- 선택시 화면 숨김
    	$("#InfoMinus1").click(function(){
    		$("#infoLayer").hide("fast");
    		$("#infoLayerMain").hide("fast");
        });


    	/* 2번 버튼 */
    	//안내+ 버튼 선택시 안내- 버튼 호출
    	$("#InfoPlus2").live("click",function(){
	    		var btnId = $(this).attr('id');
	    		if(btnId == "InfoPlus2"){
	    			$("#InfoMinus2").show();
	    			$("#InfoPlus2").hide();
	    		}
    	});

    	//안내- 버튼 선택시 안내+ 버튼 호출
    	$("#InfoMinus2").live("click",function(){
    			var btnId = $(this).attr('id');
	    		if(btnId == "InfoMinus2"){
	    			$("#InfoPlus2").show();
	    			$("#InfoMinus2").hide();
	    		}
		});

    	//안내+ 선택시 화면 호출
    	$("#InfoPlus2").click(function(){
    		$("#infoLayer2").show("fast");
    		$("#infoLayerMain2").show("fast");
        });

    	//안내- 선택시 화면 숨김
    	$("#InfoMinus2").click(function(){
    		$("#infoLaye2").hide("fast");
    		$("#infoLayerMain2").hide("fast");
        });


    	/* 3번 버튼 */
    	//안내+ 버튼 선택시 안내- 버튼 호출
    	$("#InfoPlus3").live("click",function(){
	    		var btnId = $(this).attr('id');
	    		if(btnId == "InfoPlus3"){
	    			$("#InfoMinus3").show();
	    			$("#InfoPlus3").hide();
	    		}
    	});

    	//안내- 버튼 선택시 안내+ 버튼 호출
    	$("#InfoMinus3").live("click",function(){
    			var btnId = $(this).attr('id');
	    		if(btnId == "InfoMinus3"){
	    			$("#InfoPlus3").show();
	    			$("#InfoMinus3").hide();
	    		}
		});

    	//안내+ 선택시 화면 호출
    	$("#InfoPlus3").click(function(){
    		$("#infoLayer3").show("fast");
    		$("#infoLayerMain3").show("fast");
        });

    	//안내- 선택시 화면 숨김
    	$("#InfoMinus3").click(function(){
    		$("#infoLaye3").hide("fast");
    		$("#infoLayerMain3").hide("fast");
        });

    	/* 4번 버튼 */
    	//안내+ 버튼 선택시 안내- 버튼 호출
    	$("#InfoPlus4").live("click",function(){
	    		var btnId = $(this).attr('id');
	    		if(btnId == "InfoPlus4"){
	    			$("#InfoMinus4").show();
	    			$("#InfoPlus4").hide();
	    		}
    	});

    	//안내- 버튼 선택시 안내+ 버튼 호출
    	$("#InfoMinus4").live("click",function(){
    			var btnId = $(this).attr('id');
	    		if(btnId == "InfoMinus4"){
	    			$("#InfoPlus4").show();
	    			$("#InfoMinus4").hide();
	    		}
		});

    	//안내+ 선택시 화면 호출
    	$("#InfoPlus4").click(function(){
    		$("#infoLayer4").show("fast");
    		$("#infoLayerMain4").show("fast");
        });

    	//안내- 선택시 화면 숨김
    	$("#InfoMinus4").click(function(){
    		$("#infoLayer4").hide("fast");
    		$("#infoLayerMain4").hide("fast");
        });

    });

	//안내1 안내 팝업 실행후 클릭시 창 닫음
	$(document).mouseup(function(e){
		if(!$("#infoLayer div").is(e.target)&&$("#infoLayer div").has(e.target).length==0){
			$("#infoLayer").fadeOut();
			$("#infoLayerMain").fadeOut();
			$("#InfoMinus1").hide();
			$("#InfoPlus1").show();
			$("#InfoMinus2").hide();
			$("#InfoPlus2").show();
			$("#InfoMinus3").hide();
			$("#InfoPlus3").show();
			$("#InfoMinus4").hide();
			$("#InfoPlus4").show();
		}
	});

	//안내2 안내 팝업 실행후 클릭시 창 닫음
	$(document).mouseup(function(e){
		if(!$("#infoLayer2 div").is(e.target)&&$("#infoLayer2 div").has(e.target).length==0){
			$("#infoLayer2").fadeOut();
			$("#infoLayerMain2").fadeOut();
			$("#InfoMinus1").hide();
			$("#InfoPlus1").show();
			$("#InfoMinus2").hide();
			$("#InfoPlus2").show();
			$("#InfoMinus3").hide();
			$("#InfoPlus3").show();
			$("#InfoMinus4").hide();
			$("#InfoPlus4").show();
		}
	});

	//안내3 안내 팝업 실행후 클릭시 창 닫음
	$(document).mouseup(function(e){
		if(!$("#infoLayer3 div").is(e.target)&&$("#infoLayer3 div").has(e.target).length==0){
			$("#infoLayer3").fadeOut();
			$("#infoLayerMain3").fadeOut();
			$("#InfoMinus1").hide();
			$("#InfoPlus1").show();
			$("#InfoMinus2").hide();
			$("#InfoPlus2").show();
			$("#InfoMinus3").hide();
			$("#InfoPlus3").show();
			$("#InfoMinus4").hide();
			$("#InfoPlus4").show();
		}
	});

	//안내4 안내 팝업 실행후 클릭시 창 닫음
	$(document).mouseup(function(e){
		if(!$("#infoLayer4 div").is(e.target)&&$("#infoLayer4 div").has(e.target).length==0){
			$("#infoLayer4").fadeOut();
			$("#infoLayerMain4").fadeOut();
			$("#InfoMinus1").hide();
			$("#InfoPlus1").show();
			$("#InfoMinus2").hide();
			$("#InfoPlus2").show();
			$("#InfoMinus3").hide();
			$("#InfoPlus3").show();
			$("#InfoMinus4").hide();
			$("#InfoPlus4").show();
		}
	});

	//기본공제안내 안내 팝업 실행후 클릭시 창 닫음
	$(document).mouseup(function(e){
		if(!$("#infoLayer div").is(e.target)&&$("#infoLayer div").has(e.target).length==0){
			$("#infoLayer").fadeOut();
			$("#infoLayerMain").fadeOut();
			$("#InfoMinus1").hide();
			$("#InfoPlus1").show();
			$("#InfoMinus2").hide();
			$("#InfoPlus2").show();
			$("#InfoMinus3").hide();
			$("#InfoPlus3").show();
			$("#InfoMinus4").hide();
			$("#InfoPlus4").show();
		}
	});

</script>
</head>
<body  style="overflow-x:hidden;overflow-y:auto;">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
	<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />
	<input type="hidden" id="menuNm" name="menuNm" value="" />
	</form>
	<div class="outer">
    <div class="sheet_title">
        <ul>
            <li class="txt"> 소기업·소상공인 공제부금(노란우산공제)
            	<span id="paytotMonViewYn2">
                	<a href="javascript:paytotMonView();" class="basic btn-red-outline authA">총급여 7천만원 초과여부</a>
                </span>
                <span id="span_paytotMonView2" ></span>
            	<!-- <a href="javascript:yeaDataExpPopup('소기업·소상공인 공제부금', helpText, 520);" class="cute_gray authR">소기업·소상공인 공제부금</a> -->
            	<!-- <a href = "#" class="cute_gray" id="cute_gray_authR" >소기업·소상공인 공제부금 안내</a> -->
            	<a href="#layerPopup" class="basic btn-white ico-question" id="InfoPlus1"><b>소기업·소상공인 공제부금 안내+</b></a>
	            <a href="#layerPopup" class="basic btn-white ico-question" id="InfoMinus1" style="display:none"><b>소기업·소상공인 공제부금 안내-</b></a>
            </li>
            <li class="btn">
            	<span id="btnDisplayYn01">
		        	<a href="javascript:saveCommonData();"	class="basic btn-save authA">저장</a>
		        </span>
    		</li>
        </ul>
    </div>
    </div>

	<div id="infoLayer" class="new" style="display:none"></div>

	<div id="infoLayer2" class="new" style="display:none"></div>

	<div id="infoLayer3" class="new" style="display:none"></div>

	<div id="infoLayer4" class="new" style="display:none"></div>

	<!-- Sample Ex&Image End -->
    <table border="0" cellpadding="0" cellspacing="0" class="default outer">
	<colgroup>
		<col width="20%" />
		<col width="20%" />
		<col width="" />
	</colgroup>
	<tr>
		<th class="left">납입금액</th>
		<td class="right">
			<input id="A100_30" <%=readonly%> name="A100_30" type="text" class="text w90 right" /> 원
		</td>
		<td class="left">
			&nbsp;거주자가 중소기업협동조합법 제115조에 따른 소기업ㆍ소상공인 공제에 가입하여 해당 과세기간에 납부하는 공제부금 <br>
			&nbsp;2016년 이후 가입한 경우에는 법인대표자로서 총급여 7천만원 이하인 경우에만 공제 가능<br>
			&nbsp;공제금액 : 공제한도 내의 부금 납부액 X (1 - 부동산임대업 소득금액/사업소득금액)
		</td>
	</tr>
	</table>
	<div class="outer">
    <div class="sheet_title">
        <ul>
            <li class="txt">창업투자조합 출자 등 소득공제
            	<!-- <a href="javascript:yeaDataExpPopup('창업투자조합 출자 등 소득공제', helpText, 520);" class="cute_gray authR">창업투자조합 출자 등 소득공제 안내</a> -->
            	<!-- <a href = "#" class="cute_gray" id="cute_gray_authR" >창업투자조합 출자 등 소득공제 안내</a> -->
            	<a href="#layerPopup" class="basic btn-white ico-question" id="InfoPlus2"><b>창업투자조합 출자 등 소득공제 안내+</b></a>
	            <a href="#layerPopup" class="basic btn-white ico-question" id="InfoMinus2" style="display:none"><b>창업투자조합 출자 등 소득공제 안내-</b></a>
            </li>
            <li class="btn">
    		</li>
        </ul>
    </div>
    </div>
    <table border="0" cellpadding="0" cellspacing="0" class="default line outer">
	<colgroup>
		<col width="10%" />
		<col width="10%" />
		<col width="10%" />
		<col width="20%" />
		<col width="" />
	</colgroup>
	<!-- tr>
		<th class="center" rowspan=2>2012.1.1 ~ 2012.12.31</th>
		<th class="left">간접출자</th>
		<td class="right">
			<input id="A100_08" name="A100_08" type="text" class="text w90 right" /> 원
		</td>
		<td class="left" rowspan="8">
			&nbsp;거주자가 중소기업창업투자조합 등에 2015년 12월 31일까지 출자 또는 투자한 금액<br>
			&nbsp;그 출자일 또는 투자일이 속하는 과세연도부터 2년이 되는 날이 속하는<br>
            &nbsp;과세연도까지 거주자가 선택하는 1과세연도의 종합소득금액에서 공제<br>
			&nbsp;<b>공제한도 : Min(ㄱ,ㄴ)</b><br>
			&nbsp;ㄱ.출자 또는 투자한 금액 10% <br>
			&nbsp;&nbsp;2013년도 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 30%<br>
			&nbsp;&nbsp;2014년도 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 <br>
			&nbsp;&nbsp;&nbsp;&nbsp;5천만원 이하분은 50%, 5천만원 초과분은 30% <br>
			&nbsp;&nbsp;2015년도 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 <br>
			&nbsp;&nbsp;&nbsp;&nbsp;1천5백만원 이하분은 100%, 5천만원 이하분은 50%, 5천만원 초과분은 30% <br>
			&nbsp;ㄴ.해당년도 종합소득금액 50% <br>
			&nbsp;&nbsp;(단, 2013년도 이전은 40%) <br>
		</td>
	</tr>
	<tr>
		<th class="left">직접출자</th>
		<td class="right">
			<input id="A100_10" name="A100_10" type="text" class="text w90 right" /> 원
		</td>
	</tr -->
	<!--
	<tr>
		<th class="center" rowspan=2>2014.1.1 ~ 2014.12.31</th>
		<th class="left">간접출자</th>
		<td class="right">
			<input id="A100_55" name="A100_55" type="text" class="text w90 right" /> 원
		</td>
		<td class="left" rowspan="6">
			&nbsp;거주자가 중소기업창업투자조합 등에 2017년 12월 31일까지 출자 또는 투자한 금액<br>
			&nbsp;그 출자일 또는 투자일이 속하는 과세연도부터 2년이 되는 날이 속하는<br>
            &nbsp;과세연도까지 거주자가 선택하는 1과세연도의 종합소득금액에서 공제<br>
			&nbsp;공제한도 : Min(ㄱ,ㄴ)<br>
			&nbsp;ㄱ.출자 또는 투자한 금액 10% <br>
			<!-- &nbsp;&nbsp;&nbsp;&nbsp;2013년도 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 30%<br>  --
			&nbsp;&nbsp;&nbsp;&nbsp;2014년 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 <br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5천만원 이하분은 50%, 5천만원 초과분은 30% <br>
			&nbsp;&nbsp;&nbsp;&nbsp;2015년 이후분 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 <br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1천5백만원 이하분은 100%, 5천만원 이하분은 50%, 5천만원 초과분은 30% <br>
			&nbsp;ㄴ.해당년도 종합소득금액 50% <br>
			<!-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(단, 2013년도 이전은 40%) <br> --
		</td>
	</tr>
	 -->
	<%-- <%// 2015년 추가 Start %>
    <tr>
        <th class="center" rowspan=2>2015.1.1 ~ 2015.12.31</th>
        <th class="left">간접출자</th>
        <td class="right">
            <input id="A100_57" name="A100_57" type="text" class="text w90 right" /> 원
        </td>
        <td class="left" rowspan="6" style="vertical-align: top;">
            &nbsp;거주자가 중소기업창업투자조합 등에 2017년 12월 31일까지 출자 또는 투자한 금액<br>
            &nbsp;그 출자일 또는 투자일이 속하는 과세연도부터 2년이 되는 날이 속하는<br>
            &nbsp;과세연도까지 거주자가 선택하는 1과세연도의 종합소득금액에서 공제<br>
            &nbsp;공제한도 : Min(ㄱ,ㄴ)<br>
            &nbsp;ㄱ.출자 또는 투자한 금액 10% <br>
            <!-- &nbsp;&nbsp;&nbsp;&nbsp;2013년도 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 30%<br>  -->
<!--             &nbsp;&nbsp;&nbsp;&nbsp;2014년 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 <br> -->
<!--             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5천만원 이하분은 50%, 5천만원 초과분은 30% <br> -->
            &nbsp;&nbsp;&nbsp;&nbsp;2015년 이후분 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 <br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1천5백만원 이하분은 100%, 5천만원 이하분은 50%, 5천만원 초과분은 30% <br>
            &nbsp;ㄴ.해당년도 종합소득금액 50% <br>
            <!-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(단, 2013년도 이전은 40%) <br> -->
        </td>
    </tr>
	<tr>
		<th class="left">직접출자</th>
		<td class="right">
			<input id="A100_58" name="A100_58" type="text" class="text w90 right" /> 원
		</td>
	</tr>
	<%// 2015년 추가 End %> --%>
	<%// 2016년 추가 Start %>
	<%--
    <tr>
        <th class="center" rowspan=2>2016.1.1 ~ 2016.12.31</th>
        <th class="left">간접출자</th>
        <td class="right">
            <input id="A100_59" name="A100_59" type="text" class="text w90 right" readonly disabled/> 원
        </td>
        <td class="left" rowspan="6" style="vertical-align: top;">
            &nbsp;거주자가 중소기업창업투자조합 등에 2018년 12월 31일까지 출자 또는 투자한 금액<br>
            &nbsp;그 출자일 또는 투자일이 속하는 과세연도부터 2년이 되는 날이 속하는<br>
            &nbsp;과세연도까지 거주자가 선택하는 1과세연도의 종합소득금액에서 공제<br>
            &nbsp;공제한도 : Min(ㄱ,ㄴ)<br>
            &nbsp;ㄱ.출자 또는 투자한 금액 10% <br>
            <!-- &nbsp;&nbsp;&nbsp;&nbsp;2013년도 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 30%<br>  -->
<!--             &nbsp;&nbsp;&nbsp;&nbsp;2014년 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 <br> -->
<!--             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5천만원 이하분은 50%, 5천만원 초과분은 30% <br> -->
            &nbsp;&nbsp;&nbsp;&nbsp;2016년 이후분 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 <br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1천5백만원 이하분은 100%, 5천만원 이하분은 50%, 5천만원 초과분은 30% <br>
            &nbsp;&nbsp;&nbsp;&nbsp;2018년 이후분 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 <br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3천만원 이하분은 100%, 5천만원 이하분은 70%, 5천만원 초과분은 30% <br>
            &nbsp;ㄴ.해당년도 종합소득금액 50% <br>
            <!-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(단, 2013년도 이전은 40%) <br> -->
        </td>
    </tr>
	<tr>
		<th class="left">직접출자</th>
		<td class="right">
			<input id="A100_60" name="A100_60" type="text" class="text w90 right" readonly disabled/> 원
		</td>
	</tr>
	 --%>
	<%// 2016년 추가 End %>
	<%--
	<%// 2017년 추가 Start %>
	<tr>
		<th class="center" rowspan=2>2017.1.1 ~ 2017.12.31</th>
		<th class="left">간접출자</th>
		<td class="right">
			<input id="A100_71" name="A100_71" type="text" class="text w90 right" readonly disabled/> 원
		</td>
		<td class="left" rowspan="6" style="vertical-align: top;">
            &nbsp;<font class='blue'>[자료등록>저축 탭] 에서 등록 (벤처등:직접,조합등:간접)</font><br>
            &nbsp;거주자가 중소기업창업투자조합 등에 2019년 12월 31일까지 출자 또는 투자한 금액<br>
            &nbsp;그 출자일 또는 투자일이 속하는 과세연도부터 2년이 되는 날이 속하는<br>
            &nbsp;과세연도까지 거주자가 선택하는 1과세연도의 종합소득금액에서 공제<br>
            &nbsp;공제한도 : Min(ㄱ,ㄴ)<br>
            &nbsp;ㄱ.출자 또는 투자한 금액 10% <br>
            &nbsp;&nbsp;&nbsp;&nbsp;2017년 이후분 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 <br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1천5백만원 이하분은 100%, 5천만원 이하분은 50%, 5천만원 초과분은 30% <br>
            &nbsp;&nbsp;&nbsp;&nbsp;2018년 이후분 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 <br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3천만원 이하분은 100%, 5천만원 이하분은 70%, 5천만원 초과분은 30% <br>
            &nbsp;ㄴ.해당년도 종합소득금액 50% <br>
        </td>
	</tr>
	<tr>
		<th class="left">직접출자</th>
		<td class="right">
			<input id="A100_72" name="A100_72" type="text" class="text w90 right" readonly disabled/> 원
		</td>
	</tr>
	<%// 2017년 추가 End %>
	--%>
	<%// 2018년 추가 Start --%><%--
	<tr>
        <th class="center" rowspan=2>2018.1.1 ~ 2018.12.31</th>
        <th class="left">간접출자</th>
        <td class="right">
            <input id="A100_73" name="A100_73" type="text" class="text w90 right" readonly disabled/> 원
        </td>
		<td class="left" rowspan="6" style="vertical-align: top;">
            &nbsp;<font class='blue'>[자료등록>저축 탭] 에서 등록 (벤처등:직접,조합등:간접)</font><br>
            &nbsp;거주자가 중소기업창업투자조합 등에 2020년 12월 31일까지 출자 또는 투자한 금액<br>
            &nbsp;그 출자일 또는 투자일이 속하는 과세연도부터 2년이 되는 날이 속하는<br>
            &nbsp;과세연도까지 거주자가 선택하는 1과세연도의 종합소득금액에서 공제<br>
            &nbsp;공제한도 : Min(ㄱ,ㄴ)<br>
            &nbsp;ㄱ.출자 또는 투자한 금액 10% <br>
            &nbsp;&nbsp;&nbsp;&nbsp;2018년 이후분 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 <br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1천5백만원 이하분은 100%, 5천만원 이하분은 70%, 5천만원 초과분은 30% <br>
            &nbsp;&nbsp;&nbsp;&nbsp;2019년 이후분 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 <br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3천만원 이하분은 100%, 5천만원 이하분은 70%, 5천만원 초과분은 30% <br>
            &nbsp;ㄴ.해당년도 종합소득금액 50% <br>
        </td>
    </tr>
    <tr>
        <th class="left">직접출자</th>
        <td class="right">
            <input id="A100_74" name="A100_74" type="text" class="text w90 right" readonly disabled/> 원
        </td>
    </tr>
    <%// 2018년 추가 End %>--%>
    <%// 2019년 추가 Start %><%--
	<tr>
        <th class="center" rowspan=3>2019.1.1 ~ 2019.12.31</th>
        <th class="center" rowspan=2>간접출자</th>
        <th class="left">조합1</th>
        <td class="right">
            <input id="A100_75" name="A100_75" type="text" class="text w90 right" readonly disabled/> 원
        </td>
		<td class="left" rowspan="9" style="vertical-align: top;">
            &nbsp;<font class='blue'>[자료등록>저축 탭] 에서 등록 (벤처등:직접, 조합1/조합2:간접)</font><br>
            &nbsp;거주자가 중소기업창업투자조합 등에 2022년 12월 31일까지 출자 또는 투자한 금액<br>
            &nbsp;그 출자일 또는 투자일이 속하는 과세연도부터 2년이 되는 날이 속하는<br>
            &nbsp;과세연도까지 거주자가 선택하는 1과세연도의 종합소득금액에서 공제<br>
            &nbsp;공제한도 : Min[ㄱ+ㄴ+ㄷ, ㄹ]<br>
            &nbsp;ㄱ. 조합1 출자 또는 투자한 금액 * 10% <br>
            &nbsp;ㄴ. Min[조합2 출자 또는 투자한 금액, 3000만원] * 10% <br>
            &nbsp;ㄷ. 벤처등 출자 또는 투자한 금액 <br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2019년 이후분 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 <br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3천만원 이하분은 100%, 5천만원 이하분은 70%, 5천만원 초과분은 30% <br>
            &nbsp;ㄹ. 해당년도 종합소득금액 * 50% <br>
        </td>
    </tr>
    <tr>
        <th class="left">조합2</th>
        <td class="right">
            <input id="A100_79" name="A100_79" type="text" class="text w90 right" readonly disabled/> 원
        </td>
    </tr>
    <tr>
        <th class="center">직접출자</th>
        <th class="left">벤처등</th>
        <td class="right">
            <input id="A100_76" name="A100_76" type="text" class="text w90 right" readonly disabled/> 원
        </td>
    </tr>
    <%// 2019년 추가 End %>--%>
    <%// 2020년 추가 Start %><%--
	<tr>
        <th class="center" rowspan=3>2020.1.1 ~ 2020.12.31</th>
        <th class="center" rowspan=2>간접출자</th>
        <th class="left">조합1</th>
        <td class="right">
            <input id="A100_77" name="A100_77" type="text" class="text w90 right" readonly disabled/> 원
        </td>
		<td class="left" rowspan="9" style="vertical-align: top;">
            &nbsp;<font class='blue'>[자료등록>저축 탭] 에서 등록 (벤처등:직접, 조합1/조합2:간접)</font><br>
            &nbsp;거주자가 중소기업창업투자조합 등에 2022년 12월 31일까지 출자 또는 투자한 금액<br>
            &nbsp;그 출자일 또는 투자일이 속하는 과세연도부터 2년이 되는 날이 속하는<br>
            &nbsp;과세연도까지 거주자가 선택하는 1과세연도의 종합소득금액에서 공제<br>
            &nbsp;공제한도 : Min[ㄱ+ㄴ+ㄷ, ㄹ]<br>
            &nbsp;ㄱ. 조합1 출자 또는 투자한 금액 * 10% <br>
            &nbsp;ㄴ. Min[조합2 출자 또는 투자한 금액, 3000만원] * 10% <br>
            &nbsp;ㄷ. 벤처등 출자 또는 투자한 금액 <br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2020년 이후분 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 <br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3천만원 이하분은 100%, 5천만원 이하분은 70%, 5천만원 초과분은 30% <br>
            &nbsp;ㄹ. 해당년도 종합소득금액 * 50% <br>
        </td>
    </tr>
    <tr>
        <th class="left">조합2</th>
        <td class="right">
            <input id="A100_80" name="A100_80" type="text" class="text w90 right" readonly disabled/> 원
        </td>
    </tr>
    <tr>
        <th class="center">직접출자</th>
        <th class="left">벤처등</th>
        <td class="right">
            <input id="A100_78" name="A100_78" type="text" class="text w90 right" readonly disabled/> 원
        </td>
    </tr>
    <%// 2020년 추가 End %>--%>
    <%// 2021년 추가 Start %>
	<tr>
        <th class="center" rowspan=3>2021.1.1 ~ 2021.12.31</th>
        <th class="center" rowspan=2>간접출자</th>
        <th class="left">조합1</th>
        <td class="right">
            <input id="A100_81" name="A100_81" type="text" class="text w90 right" readonly disabled/> 원
        </td>
        <td class="left" rowspan="9" style="vertical-align: top;">
            &nbsp;<font class='blue'>[자료등록>저축 탭] 에서 등록 (벤처등:직접, 조합1/조합2:간접)</font><br>
            &nbsp;거주자가 중소기업창업투자조합 등에 2023년 12월 31일까지 출자 또는 투자한 금액<br>
            &nbsp;그 출자일 또는 투자일이 속하는 과세연도부터 2년이 되는 날이 속하는<br>
            &nbsp;과세연도까지 거주자가 선택하는 1과세연도의 종합소득금액에서 공제<br>
            &nbsp;공제한도 : Min[ㄱ+ㄴ+ㄷ, ㄹ]<br>
            &nbsp;ㄱ. 조합1 출자 또는 투자한 금액 * 10% <br>
            &nbsp;ㄴ. Min[조합2 출자 또는 투자한 금액, 3000만원] * 10% <br>
            &nbsp;ㄷ. 벤처등 출자 또는 투자한 금액 <br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2021년 이후분 ： 개인이 직접 또는 개인투자조합을 통해 벤처기업에 투자하는 경우 <br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3천만원 이하분은 100%, 5천만원 이하분은 70%, 5천만원 초과분은 30% <br>
            &nbsp;ㄹ. 해당년도 종합소득금액 * 50% <br>
        </td>
    </tr>
    <tr>
        <th class="left">조합2</th>
        <td class="right">
            <input id="A100_82" name="A100_82" type="text" class="text w90 right" readonly disabled/> 원
        </td>
    </tr>
    <tr>
        <th class="center">직접출자</th>
        <th class="left">벤처등</th>
        <td class="right">
            <input id="A100_83" name="A100_83" type="text" class="text w90 right" readonly disabled/> 원
        </td>
    </tr>
    <%// 2021년 추가 End %>
    <%// 2022년 추가 Start %>
	<tr>
        <th class="center" rowspan=3>2022.1.1 ~ 2022.12.31</th>
        <th class="center" rowspan=2>간접출자</th>
        <th class="left">조합1</th>
        <td class="right">
            <input id="A100_84" name="A100_84" type="text" class="text w90 right" readonly disabled/> 원
        </td>
    </tr>
    <tr>
        <th class="left">조합2</th>
        <td class="right">
            <input id="A100_85" name="A100_85" type="text" class="text w90 right" readonly disabled/> 원
        </td>
    </tr>
    <tr>
        <th class="center">직접출자</th>
        <th class="left">벤처등</th>
        <td class="right">
            <input id="A100_86" name="A100_86" type="text" class="text w90 right" readonly disabled/> 원
        </td>
    </tr>
    <%// 2022년 추가 End %>
    <%// 2023년 추가 Start %>
	<tr>
        <th class="center" rowspan=3>2023.1.1 ~ 2023.12.31</th>
        <th class="center" rowspan=2>간접출자</th>
        <th class="left">조합1</th>
        <td class="right">
            <input id="A100_87" name="A100_87" type="text" class="text w90 right" readonly disabled/> 원
        </td>
    </tr>
    <tr>
        <th class="left">조합2</th>
        <td class="right">
            <input id="A100_88" name="A100_88" type="text" class="text w90 right" readonly disabled/> 원
        </td>
    </tr>
    <tr>
        <th class="center">직접출자</th>
        <th class="left">벤처등</th>
        <td class="right">
            <input id="A100_89" name="A100_89" type="text" class="text w90 right" readonly disabled/> 원
        </td>
    </tr>
    <%// 2023년 추가 End %>
	</table>
	<div class="outer">
    <div class="sheet_title">
        <ul>
            <li class="txt">우리사주조합출연금
            	<!-- <a href="javascript:yeaDataExpPopup('우리사주조합출연금', helpText, 520);" class="cute_gray authR">우리사주조합출연금 안내</a> -->
            	<!-- <a href = "#" class="cute_gray" id="cute_gray_authR" >우리사주조합출연금 안내</a> -->
            	<a href="#layerPopup" class="basic btn-white ico-question" id="InfoPlus3"><b>우리사주조합출연금 안내+</b></a>
	            <a href="#layerPopup" class="basic btn-white ico-question" id="InfoMinus3" style="display:none"><b>우리사주조합출연금 안내-</b></a>
            </li>
            <li class="btn">
    		</li>
        </ul>
    </div>
    </div>
    <table border="0" cellpadding="0" cellspacing="0" class="default outer">
	<colgroup>
		<col width="20%" />
		<col width="20%" />
		<col width="" />
	</colgroup>
	<tr>
		<th class="left">우리사주 출연금</th>
		<td class="right">
			<input id="A100_21" <%=readonly%> name="A100_21" type="text" class="text w90 right" /> 원
		</td>
		<td class="left" rowspan="3">
			&nbsp;우리사주조합원이 자사주를 취득하기 위하여 우리사주조합에 출자하는 경우 해당 연도의 출자금액과 <br>
			&nbsp;400만원(벤처기업은 1,500만원) 중 적은 금액을 공제
		</td>
	</tr>
	</table>
	<div class="outer">
    <div class="sheet_title">
        <ul>
            <li class="txt">고용유지중소기업근로자
            	<!-- <a href="javascript:yeaDataExpPopup('고용유지중소기업근로자', helpText, 520);" class="cute_gray authR">고용유지중소기업근로자 안내</a> -->
            	<!-- <a href = "#" class="cute_gray" id="cute_gray_authR" >고용유지중소기업근로자 안내</a> -->
            	<a href="#layerPopup" class="basic btn-white ico-question" id="InfoPlus4"><b>고용유지중소기업근로자 안내+</b></a>
	            <a href="#layerPopup" class="basic btn-white ico-question" id="InfoMinus4" style="display:none"><b>고용유지중소기업근로자 안내-</b></a>
            </li>
            <li class="btn">
    		</li>
        </ul>
    </div>
    </div>
    <table border="0" cellpadding="0" cellspacing="0" class="default outer">
	<colgroup>
		<col width="20%" />
		<col width="20%" />
		<col width="" />
	</colgroup>
	<tr>
		<th class="left">임금감소액</th>
		<td class="right">
			<input id="A100_37" <%=readonly%> name="A100_37" type="text" class="text w90 right" /> 원
		</td>
		<td class="left" rowspan="3">
			&nbsp;임금감소액 : 직전 과세연도의 해당 근로자 연간 임금총액 - 해당 과세연도의 해당 근로자<br>
			&nbsp;연간 임금총액 고용유지중소기업에 근로를 제공하는 상시근로자에 대하여 2023년 12월 31일이<br>
			&nbsp;속하는 과세연도까지 다음 산식에 따라 계산한 금액을 해당 과세연도의 근로소득금액에서 공제
		</td>
	</tr>
	</table>
	<div class="outer hide">
		<div class="sheet_title">
			<ul>
				<li class="txt">목돈안드는전세이자상환액
					<!-- <a href="javascript:yeaDataExpPopup('목돈안드는전세이자상환액', helpText, 520);" class="cute_gray authR">목돈안드는전세이자상환액 안내</a> -->
					<a href="#layerPopup" class="basic btn-white ico-question" id="InfoPlus5"><b>목돈안드는전세이자상환액 안내+</b></a>
	            	<a href="#layerPopup" class="basic btn-white ico-question" id="InfoMinus5" style="display:none"><b>목돈안드는전세이자상환액 안내-</b></a>
				</li>
				<li class="btn">
				</li>
			</ul>
		</div>
	</div>
	<table border="0" cellpadding="0" cellspacing="0" class="default outer hide">
	<colgroup>
		<col width="20%" />
		<col width="20%" />
		<col width="" />
	</colgroup>
	<tr>
		<th class="left">이자상환액</th>
		<td class="right">
			<input id="A100_38" name="A100_38" type="text" class="text w90 right" /> 원
		</td>
		<td class="left" rowspan="3">
			임차인이 불입한 당해년도 이자상환액 전액을 입력하여 주십시오.(요건은 다음과 같습니다.)<br>
			 - (임대인) 보유주택을 담보로 금융기관으로부터 전세보증금을 차입<br>
			 - (임차인) 부부합산 연소득 6천만원 이하인 무주택자<br>
			 - (대출한도) 3천만원 (수도권 5천만원)<br>
			 - (대출이자) 주택 임차인이 상환<br>
			 - 공제금액 : 임대인이 이자상환액의 40% 공제(연 300만원 한도)<br>
		</td>
	</tr>
	</table>

</div>
</body>
</html>