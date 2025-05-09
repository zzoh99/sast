<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> 
<title><tit:txt mid='104496' mdef='인재비교'/></title> <!-- All NEW(4.0) EIS MODULE by JSG -->
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<!-- Bootstrap -->
<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript" src="/common/js/cookie.js"></script>
	<script src="/assets/js/utility-script.js?ver=7"></script>
<!--
 * 맞춤인재검색
 * @author JSG
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var order ="";


var jobLst1 = null;
var jobLst2 =  null;
var jobLst3 =  null;
var jobLstMax = 0;

// 사외경력
var careerLst1 =  null;
var careerLst2 =  null;
var careerLst3 =  null;
var careerLstMax = 0;

//사내경력
var experienceLst1 =  null;
var experienceLst2 =  null;
var experienceLst3 =  null;
var experienceLstMax = 0;

// 평가
var appraisalLst1 = null;
var appraisalLst2 = null;
var appraisalLst3 = null;
var appraisalLstMax = 0;

$(function() {

	//조직원 조회에서 비교대상 버튼 클릭시 여기로 이동됨
	//쿠기 정보 확인 하여 있으면 자동으로 데이터 조회
	if(getCookie("CompareEmpN1") != null || getCookie("CompareEmpN1") != "" ){
		$("#sabun1").val(getCookie("CompareEmpS1"));
        $("#name1").val(getCookie("CompareEmpN1"));
        $("#tNmae1").html(getCookie("CompareEmpN1"));
        order = "1";
        searchData(getCookie("CompareEmpS1"));

	}
	if(getCookie("CompareEmpN2") != null || getCookie("CompareEmpN2") != "" ){
		$("#sabun2").val(getCookie("CompareEmpS2"));
        $("#name2").val(getCookie("CompareEmpN2"));
        $("#tNmae2").html(getCookie("CompareEmpN2"));
        order = "2";
        searchData(getCookie("CompareEmpS2"));

	}
	if(getCookie("CompareEmpN3") != null || getCookie("CompareEmpN3") != ""  ){
		$("#sabun3").val(getCookie("CompareEmpS3"));
        $("#name3").val(getCookie("CompareEmpN3"));
        $("#tNmae3").html(getCookie("CompareEmpN3"));
        order = "3";
        searchData(getCookie("CompareEmpS3"));
	}

	 //쿠기정보 초기화
	 setCookie("CompareEmpN1","",1000);
     setCookie("CompareEmpS1","",1000);
     setCookie("CompareEmpN2","",1000);
     setCookie("CompareEmpS2","",1000);
     setCookie("CompareEmpN3","",1000);
     setCookie("CompareEmpS3","",1000);

});

function searchData(sabun){
    // 데이터 조회
    var data = ajaxCall("${ctx}/CompareEmp.do?cmd=getCompareEmpPeopleMap","&sabun="+sabun,false);
    if(data.DATA == null){
        return;
    }
    $("#orgNm"+order).html(data.DATA.orgNm);
    $("#jobNm"+order).html(data.DATA.jobNm);
    $("#jikweeNm"+order).html(data.DATA.jikweeNm);
    $("#jikchakNm"+order).html(data.DATA.jikchakNm);
    $("#jikgubNm"+order).html(data.DATA.jikgubNm);
    $("#empYmd"+order).html(data.DATA.empYmd);
  // $("#gempYmd"+order).html(data.DATA.gempYmd);
    $("#birYmd"+order).html(data.DATA.birYmd);
    $("#acaNm"+order).html(data.DATA.acaNm);
    $("#acaSchNm"+order).html(data.DATA.acaSchNm);
    $("#acamajNm"+order).html(data.DATA.acamajNm);
    $("#appResult"+order).html(data.DATA.appResult);
    $("#achievePoint"+order).html(data.DATA.achievePoint);
    $("#lang"+order).html(data.DATA.lang);
    $("#prize"+order).html(data.DATA.prize);
    $("#punish"+order).html(data.DATA.punish);

    //이미지 세팅
    setImgFile(sabun, order);

    //학력
    var jobLst = ajaxCall("${ctx}/CompareEmp.do?cmd=getCompareEmpJobList","&sabun="+sabun,false);
    
    if(jobLst.DATA.length == 0){
    	//$('#acaTb'+order).append('<tr> <td style="min-height:13px; display:block;">'+''+'</td> <td>'+''+'</td> <td>'+''+'</td> <td>'+''+'</td> <td>'+''+'</td> <td>'+''+'</td> <td>'+''+'</td> </tr>');
    }else{
        for(var jobMap in jobLst.DATA){
            var tmpData = jobLst.DATA[jobMap]
            $('#acaTb'+order).append(tmpData.acaSYm+' ~ '+tmpData.acaEYm+'&nbsp;&nbsp;'+tmpData.acaSchNm+'&nbsp;&nbsp;'+tmpData.acamajNm+'<dl></dl>');
            
            if(jobLst.DATA.length != jobMap){
            	$('#acaTb'+order).append('</br>');
            }               
        }
    }
    
    //자격사항
    var experienceLst = ajaxCall("${ctx}/CompareEmp.do?cmd=getExperienceList","&sabun="+sabun,false);
    
    if(experienceLst.DATA.length == 0){
    	//$('#lcsTb'+order).append('<tr> <td style="min-height:13px; display:block;">'+''+'</td> <td>'+''+'</td> <td>'+''+'</td> <td>'+''+'</td> </tr>');
    }else{
        for(var experienceMap in experienceLst.DATA){
            var tmpData = experienceLst.DATA[experienceMap]
            $('#lcsTb'+order).append(tmpData.licSYmd+'&nbsp;&nbsp;'+tmpData.licenseNm+'<dl></dl>');
            
            if(experienceLst.DATA.length != experienceMap){
            	$('#lcsTb'+order).append('</br>');
            }            
        }
    }
    
    //어학사항
    var careerLst = ajaxCall("${ctx}/CompareEmp.do?cmd=getCompareEmpCareerList","&sabun="+sabun,false);
    
    if(careerLst.DATA.length == 0){
    	//$('#frgTb'+order).append('<tr> <td style="min-height:13px; display:block;">'+''+'</td> <td>'+''+'</td> <td>'+''+'</td> <td>'+''+'</td> <td>'+''+'</td> </tr>');
    }else{
        for(var careerMap in careerLst.DATA){
            var tmpData = careerLst.DATA[careerMap]
            $('#frgTb'+order).append(tmpData.applyYmd+'&nbsp;&nbsp;'+tmpData.foreignCd+'&nbsp;&nbsp;'+tmpData.fTestCd+'&nbsp;&nbsp;'+tmpData.testPoint+'&nbsp;&nbsp;'+tmpData.passScores+'<dl></dl>');
            
            if(careerLst.DATA.length != careerMap){
            	$('#frgTb'+order).append('</br>');
            }
        }
    }
    
    //평가사항
    var papLst = ajaxCall("${ctx}/CompareEmp.do?cmd=getPapList","&sabun="+sabun,false);
    
    if(papLst.DATA.length == 0){
    	//$('#frgTb'+order).append('<tr> <td style="min-height:13px; display:block;">'+''+'</td> <td>'+''+'</td> <td>'+''+'</td> <td>'+''+'</td> <td>'+''+'</td> </tr>');
    }else{
        for(var papMap in papLst.DATA){
            var tmpData = papLst.DATA[papMap]
            $('#papTb'+order).append(tmpData.papNm+'&nbsp;&nbsp;'+tmpData.finalGrade+'<dl></dl>');
            
            if(papLst.DATA.length != papMap){
            	$('#papTb'+order).append('</br>');
            }
        }
    }
    
    
    //포상사항
    var appraisalLst = ajaxCall("${ctx}/CompareEmp.do?cmd=getAppraisalList","&sabun="+sabun,false);
    
    if(appraisalLst.DATA.length == 0){
    	//$('#przTb'+order).append('<tr> <td style="min-height:13px; display:block;">'+''+'</td> <td>'+''+'</td> <td>'+''+'</td> </tr>');
    }else{
        for(var appraisalMap in appraisalLst.DATA){
            var tmpData = appraisalLst.DATA[appraisalMap]
            $('#przTb'+order).append(tmpData.prizeYmd+'&nbsp;&nbsp;'+tmpData.prizeNm+'&nbsp;&nbsp;'+tmpData.prizeMemo+'<dl></dl>');
            
            if(appraisalLst.DATA.length != appraisalMap){
            	$('#przTb'+order).append('</br>');
            }             
        }
    }

}

// 사원 팝업
function showEmpPopup(i) {

    if(!isPopup()) {return;}
    gPRow = "";
    pGubun = "empPopup"+i;
    order  = i;

    //openPopup("/Popup.do?cmd=employeePopup&authPg=R", "", "840","520");
    let layerModal = new window.top.document.LayerModal({
        id : 'employeeLayer'
        , url : '/Popup.do?cmd=viewEmployeeLayer&authPg=R'
        , parameters : {}
        , width : 840
        , height : 520
        , title : '사원조회'
        , trigger :[
            {
                name : 'employeeTrigger'
                , callback : function(result){
                    if(pGubun == "empPopup1"){
                        dataClear("1");
                        $("#sabun1").val(result.sabun);
                        $("#name1").val(result.name);
                        $("#tNmae1").html(result.name);
                        $("#rk1").val(result.rk);
                        
                    } else if(pGubun == "empPopup2"){
                        dataClear(2);
                         $("#sabun2").val(result.sabun);
                         $("#name2").val(result.name);
                         $("#tNmae2").html(result.name);
                         $("#rk2").val(result.rk); 
                         
                    } else if(pGubun == "empPopup3"){
                        dataClear(3);
                         $("#sabun3").val(result.sabun);
                         $("#name3").val(result.name);
                         $("#tNmae3").html(result.name);
                         $("#rk3").val(result.rk);
                         
                    }

                    //데이터 조회
                    searchData(result.sabun);

                }
            }
        ]
    });
    layerModal.show();


}

function getReturnValue(returnValue) {
    var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "empPopup1"){
    	dataClear("1");
        $("#sabun1").val(rv["sabun"]);
        $("#name1").val(rv["name"]);
        $("#tNmae1").html(rv["name"]);
        
        
        //데이터 조회
        searchData(rv["sabun"]);
    } else if(pGubun == "empPopup2"){
    	dataClear(2);
         $("#sabun2").val(rv["sabun"]);
         $("#name2").val(rv["name"]);
         $("#tNmae2").html(rv["name"]);
         
       //데이터 조회
         searchData(rv["sabun"]);
    } else if(pGubun == "empPopup3"){
    	dataClear(3);
         $("#sabun3").val(rv["sabun"]);
         $("#name3").val(rv["name"]);
         $("#tNmae3").html(rv["name"]);
         
       //데이터 조회
         searchData(rv["sabun"]);
    }
}



function valChk(value) {
    if(value == null || value == "") return false ;
    else return true ;
}


function nullChk(value) {
    if(value == null){
    	return 0;
    } else{
    	return value.length ;
    }
}

// 초기화
function clearCode(num) {
    switch(num) {
    case "name1" :

    	//뿌려지값 초기화
    	dataClear("1");
        break ;
    case "name2" :
    	//뿌려지값 초기화
        dataClear("2");
        break ;
    case "name3" :
    	//뿌려지값 초기화
        dataClear("3");
        break ;
    }
}
//사진파일 적용 by
function setImgFile(sabun, i){
    $("#image"+i).attr("src", "${ctx}/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword="+sabun);
}

function dataClear(order){
	
	
	  
	$("#acaTb"+order).html("") ;
	$("#lcsTb"+order).html("") ;
	$("#frgTb"+order).html("") ;
	$("#przTb"+order).html("") ;
	$("#papTb"+order).html("") ;
	  

	   
   $("#tNmae"+order).html("");
	   
   $('#name'+order).val("");
   $('#sabun'+order).val("");
   $("#orgNm"+order).html("소속");
   $("#jobNm"+order).html("");
   $("#jikweeNm"+order).html("");
   $("#jikchakNm"+order).html("");
   $("#jikgubNm"+order).html("");
   $("#empYmd"+order).html("");
  // $("#gempYmd"+order).html("");
   $("#birYmd"+order).html("");
   $("#acaNm"+order).html("");
   $("#acaSchNm"+order).html("");
   $("#acamajNm"+order).html("");
   $("#appResult"+order).html("");
   $("#achievePoint"+order).html("");
   $("#lang"+order).html("");
   $("#prize"+order).html("");
   $("#punish"+order).html("");

   $("#image"+order).attr("src", "/common/images/common/img_photo.gif");


}



function rdPopup(){

	if(!isPopup()) {return;}
	gPRow = "";
	pGubun = "rdPopup";

	var w 		= 800;
	var h 		= 600;
	var url 	= "${ctx}/RdPopup.do";
	var args 	= new Array();

	var rdMrd = "eis/compareEmp.mrd";
	var rdTitle = "임직원비교";
	var rdParam = "";
	var rdZoomRatio = 100;

	var sabun1 = "";
	var sabun2 = "";
	var sabun3 = "";

	if($("#sabun1").val() != ""){ sabun1 = $("#sabun1").val()};
	if($("#sabun2").val() != ""){ sabun2 = $("#sabun2").val()};
	if($("#sabun3").val() != ""){ sabun3 = $("#sabun3").val()};

	rdParam = "['${ssnEnterCd}']"
			+ "['"+sabun1+"']"
			+ "['"+sabun2+"']"
			+ "['"+sabun3+"']"
			+ "['${baseURL}']";

	var imgPath = " " ;
	args["rdTitle"] = rdTitle ;	//rd Popup제목
	args["rdMrd"] =  rdMrd;		//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
	args["rdParam"] = rdParam;	//rd파라매터
	args["rdParamGubun"] = "rp";//파라매터구분(rp/rv)
	args["rdToolBarYn"] = "Y" ;	//툴바여부
	args["rdZoomRatio"] = "110";//확대축소비율

	args["rdSaveYn"] 	= "N" ;//기능컨트롤_저장
	args["rdPrintYn"] 	= "N" ;//기능컨트롤_인쇄
	args["rdExcelYn"] 	= "N" ;//기능컨트롤_엑셀
	args["rdWordYn"] 	= "N" ;//기능컨트롤_워드
	args["rdPptYn"] 	= "N" ;//기능컨트롤_파워포인트
	args["rdHwpYn"] 	= "N" ;//기능컨트롤_한글
	args["rdPdfYn"] 	= "N" ;//기능컨트롤_PDF
	args["rdPrintPdfYn"]= "N" ;//기능컨트롤_PDF인쇄

	openPopup(url,args,w,h);//알디출력을 위한 팝업창
/*	//사진파일 적용 by
		function setImgFile(sabun, i){
		    $("#image"+i).attr("src", "${ctx}/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword="+sabun);
		}
	*/

}

function showRd(){

	var sabun1 = "";
	var sabun2 = "";
	var sabun3 = "";

	if($("#sabun1").val() !== ""){ sabun1 = $("#sabun1").val()};
	if($("#sabun2").val() !== ""){ sabun2 = $("#sabun2").val()};
	if($("#sabun3").val() !== ""){ sabun3 = $("#sabun3").val()};

	let parameters = Utils.encase('${ssnEnterCd}');
	parameters += Utils.encase('\'' + sabun1 + '\'');
	parameters += Utils.encase('\'' + sabun2 + '\'');
	parameters += Utils.encase('\'' + sabun3 + '\'');
	parameters += Utils.encase('${imageBaseUrl}');
   
	const data2 = {
		  rdMRd : '/eis/compareEmp.mrd'
		, parameterType : 'rp'//rp 또는 rv
		, parameters : parameters
	};
	//window.top.showRdLayer(data2);
	
	   
    var rk1 = "";
    var rk2 = "";
    var rk3 = "";
    if($("#rk1").val() !== ""){ 
        rk1= $("#rk1").val() ;
    };
    if($("#rk2").val() !== ""){ 
        rk2= $("#rk2").val();
    };
    if($("#rk3").val() !== ""){ 
        rk3 = $("#rk3").val();
    };
      
	
	//암호화 할 데이터 생성
    const data = {
              rk1 : rk1
           ,  rk2 : rk2
           ,  rk3 : rk3
    };    

	window.top.showRdLayer('/CompareEmp.do?cmd=getEncryptRd', data);
	
}

function searchKeyword(){
    if(!isPopup()) {return;}
    gPRow = "";
    pGubun = "keywordPopup";

	var layer = new window.top.document.LayerModal({
		id : 'keywordLayer'
		, url : '/Popup.do?cmd=keywordLayer&authPg=R'
		, width : 1300
		, height : 900
		, title : '사원조회'
	});
	layer.show();

}

function showProfile(num) {
	pGubun = "rdPopup";

	if(!isPopup()) {return;}

	var enterCdSabun = "";
	var searchSabun = "";
	enterCdSabun += ",('${ssnEnterCd}','" + $("#sabun"+num).val() + "')";
	searchSabun  += "," + $("#sabun"+num).val();

	if( enterCdSabun == "" ){
		alert("<msg:txt mid='109876' mdef='대상자를 선택하세요'/>");
		return;
	}

	var rdParam = "";
	rdParam += "["+ enterCdSabun +"] "; //회사코드, 사번
	rdParam += "[${baseURL}] ";//이미지위치---3
	rdParam += "[Y] "; //개인정보 마스킹
	rdParam += "[${ssnEnterCd}] ";
	rdParam += "[ '${ssnSabun}' ] ";//rdParam  += "["+searchSabun+"]"; // 사번list->세션사번으로 변경(2016.04.14)
	rdParam += "[${ssnLocaleCd}] ";	// 10.다국어코드
	rdParam += "['"+ searchSabun +"'] "; //사번

	const data = {
		parameters : rdParam
	};
	window.top.showRdLayer('/CompareEmp.do?cmd=getProfileEncryptRd', data, null, '프로필 상세보기');

}
</script>
<style type="text/css">
#infoWidgetMain div.content {position:relative; border:1px solid #d6d9dd; box-shadow:3px 3px 5px #dfe0e3; background-color:#FFF; border-radius:16px; width:100%; height:calc(100vh - 120px); padding:0; }
#infoWidgetMain ul.info_group { padding: 20px;}
#infoWidgetMain ul.info_group li.info_txt {}
#infoWidgetMain ul.info_group li.info_txt p.affiliation { display:inline-block; border:1px solid #e3e3e3; border-radius:20px; font-size:12px; line-height:15px; padding:8px 16px; color:#333333; font-weight:600; }
#infoWidgetMain ul.info_group li.info_txt .btn span {color:#ffffff;}
#infoWidgetMain ul.info_group li.info_txt p.info_name { color:#5a5e61; font-weight:600; font-size:28px; letter-spacing:-2px; margin-bottom:10px; margin-top:12px;}
#infoWidgetMain ul.info_group li.info_txt .info_txt_point { overflow:hidden; font-size:13px; line-height:13px; margin:7px 0; }
#infoWidgetMain ul.info_group li.info_txt .info_txt_point:first-child {margin-top:20px; }
#infoWidgetMain ul.info_group li.info_txt .info_txt_point>dt { float:left; color:#9f9f9f; font-weight:500; font-size: inherit; }
#infoWidgetMain ul.info_group li.info_txt .info_txt_point>dd { float:left; margin-left:5px; letter-spacing:0; font-size: inherit;}

#infoWidgetMain ul.info_group li.info_photo { position:relative; float:left; width:85px; height:85px; border-radius:100%; border:1px solid #e1e3e6; overflow:hidden; margin-right:16px;}
#infoWidgetMain ul.info_group li.info_photo img {position: absolute;top: 50%; left: 50%; width: 100%; transform: translate(-50%, -50%);}
#infoWidgetMain h4.info_title {font-size: 14px; padding: 8px 20px; background-color: #f2f2f2; font-weight: 700; color: #323232;}
#infoWidgetMain .info_scroll { margin-top:14px; height:440px; overflow-y:auto; overflow-x:hidden; scrollbar-face-color:#DDD; scrollbar-track-color:#F7F7F7; scrollbar-arrow-color:none; scrollbar-highlight-color:#F7F7F7; scrollbar-3dlight-color:none; scrollbar-shadow-color:#F7F7F7; scrollbar-darkshadow-color:none; }
#infoWidgetMain .info_gray { width:100%; padding: 12px 20px; font-size:13px; line-height:13px;  }
#infoWidgetMain .button { text-align:center; padding:10px 0 15px; margin-top:10px; }
#infoWidgetMain .button>a { display:inline-block; padding:6px 13px; background-image:none !important; color:#6d6e71; text-align:center; border:1px solid #d6d9dd; border-radius:4px; font-weight:500; line-height:13px; }
</style>

</head>
<body class="hidden" onload="">
<div class="wrapper" style="overflow:hidden;">
<form id="searchFrm" name="searchFrm">
<input type="hidden" id="srchSeq" name="srchSeq" value="" />
	<div class="sheet_title">
      <ul>
      	<li class="txt">인재비교</li>
        <li class="btn">
        	<btn:a href="javascript:searchKeyword()"	css="btn outline_gray authA" mid='123123123' mdef="키워드검색 "/>
        	<%--<btn:a href="javascript:rdPopup()"	css="basic authA" mid='printV1' mdef="출력"/>--%>
        	<btn:a href="javascript:showRd()"	css="btn filled authA" mid='printV1' mdef="출력"/>
        </li>
      </ul>
    </div>

		<div class="sheet_search outer">
			<div>
				<table>
					<colgroup>
						<col width="10%">
						<col width="25%">
						<col width="36%">
						<col width="30%">
						<col width="50px">
					</colgroup>
					<tr>
						<th>비교대상</th>
						<td>
						    <input id="name1" name="name1" type="text" class="text  readonly" readonly/>
                            <input id="sabun1" name="sabun1" type="hidden" class="text"/>
                            <input id="rk1" name="rk1" type="hidden" class="text"/>
                            <a href="javascript:showEmpPopup('1');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
                            <a href="javascript:clearCode('name1')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</td>
						<td>
                            <input id="name2" name="name2" type="text" class="text  readonly" readonly/>
                            <input id="sabun2" name="sabun2" type="hidden" class="text"/>
                            <input id="rk2" name="rk2" type="hidden" class="text"/>
                            <a href="javascript:showEmpPopup('2');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
                            <a href="javascript:clearCode('name2')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
                        </td>
                        <td>
                            <input id="name3" name="name3" type="text" class="text  readonly" readonly/>
                            <input id="sabun3" name="sabun3" type="hidden" class="text"/>
                            <input id="rk3" name="rk3" type="hidden" class="text"/>
                            <a href="javascript:showEmpPopup('3');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
                            <a href="javascript:clearCode('name3')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
                        </td>
					</tr>
				</table>
			</div>
		</div>

<div id="main_container">
	<div class="main_wrap">
		<!-- 인사정보_pop -->
		<div id="infoWidgetMain">
			<div class="row">
				<div class="col-4">
					<!-- 첫번쨰직원 -->
					<div class="content info_scroll">
						<!-- 이름,사진 -->
						<ul class="info_group">
						
							<li class="info_photo">
								<img src="/common/images/common/img_photo.gif" id="image1" alt="직원사진">
							</li>				
						
							<li class="info_txt">
								<p class="affiliation"><span id="orgNm1">소속</span></p>
								<a class="btn filled" style="float: right" onclick="showProfile('1')"><span id="profile1">프로필 상세보기</span></a>
								<p class="info_name" ><span id="tNmae1"></span>&nbsp;
								                      <span class="f_400" id="tJikGub" style="font-size: 60%;"></span></p>
							</li>
							<li class="info_txt">
								<dl class="info_txt_point">
									<dt>직위</dt>
		                            <dd id="jikweeNm1"></dd>
								</dl>
								<dl class="info_txt_point">
									<dt>입사일</dt>
									<dd id="empYmd1">&nbsp;&nbsp;</dd>
								</dl>	
								<dl class="info_txt_point">
									<dt>생년월일</dt>
									<dd id="birYmd1"></dd>
								</dl>
							</li>
						</ul>
						<div>
		                    <!-- 02.학력사항 -->
		                    <h4 class="info_title">학력사항</h4>
		                    <div class="table_top_gray">
		                        <div class="info_gray" id="acaTb1">
		                        </div>
		                    </div>
		                    <!-- //02.학력사항 end -->
		                    
							
							<!-- 04.자격증 -->
							<h4 class="info_title">자격증</h4>
							<div class="table_top_gray">
								<div class="info_gray" id="lcsTb1">
								</div>
							</div>
							<!-- 04.외국어 -->
							<h4 class="info_title">외국어</h4>
		                    <div class="table_top_gray">
		                        <div class="info_gray" id="frgTb1">
		                        </div>
		                    </div>
							<!-- //04.외국어end -->
							
							
							<!-- 05.상벌사항 -->
							<h4 class="info_title">평가사항</h4>
							<div class="table_top_gray">
							
								<div class="info_gray" id="papTb1">
								</div>
							</div>						
							
							<!-- 05.상벌사항 -->
							<h4 class="info_title">포상사항</h4>
							<div class="table_top_gray">
								<div class="info_gray" id="przTb1">
								</div>
							</div>			
						</div>
					</div>
				</div>
				<div class="col-4">
					<!-- 두번쨰직원 -->
					<div class="content info_scroll">
						<!-- 이름,사진 -->
						<ul class="info_group">
							
							<li class="info_photo">
								<img src="/common/images/common/img_photo.gif" id="image2" alt="직원사진">
							</li>					
							<li class="info_txt">
								<p class="affiliation"><span id="orgNm2">소속</span></p>
								<a class="btn filled" style="float: right" onclick="showProfile('2')"><span id="profile2">프로필 상세보기</span></a>
								<p class="info_name" ><span id="tNmae2"></span>&nbsp;
								                      <span class="f_400" id="tJikGub" style="font-size: 60%;"></span></p>
							</li>
							<li class="info_txt">
								<dl class="info_txt_point">
									<dt>직위</dt>
		                            <dd id="jikweeNm2"></dd>
								</dl>
								<dl class="info_txt_point">
									<dt>입사일</dt>
									<dd id="empYmd2">&nbsp;&nbsp;</dd>
								</dl>
								<dl class="info_txt_point">
									<dt>생년월일</dt>
									<dd id="birYmd2"></dd>
								</dl>
							</li>
						</ul>
						
						<div >
		                 
		                    <!-- 02.학력사항 -->
		                    <h4 class="info_title">학력사항</h4>
		                    <div class="table_top_gray">
		                        <div class="info_gray" id="acaTb2" >
		                        </div>
		                    </div>
		                    <!-- //02.학력사항 end -->
		                    
							
							<!-- 04.자격증 -->
							<h4 class="info_title">자격증</h4>
							<div class="table_top_gray">
								<div class="info_gray" id="lcsTb2" >
								</div>
							</div>
							<!-- 04.외국어 -->
							<h4 class="info_title">외국어</h4>
		                    <div class="table_top_gray">
		                        <div class="info_gray" id="frgTb2" >
		                        </div>
		                    </div>
							<!-- //04.외국어end -->
							
							<h4 class="info_title">평가사항</h4>
							<div class="table_top_gray">
								<div class="info_gray" id="papTb2" >
								</div>
							</div>	
							
							<!-- 05.상벌사항 -->
							<h4 class="info_title">포상사항</h4>
							<div class="table_top_gray">
								<div class="info_gray" id="przTb2" >
								</div>
							</div>			
						</div>				
					</div>
				</div>
				<div class="col-4">
					<!-- 세번쨰직원 -->
					<div class="content info_scroll">
						<!-- 이름,사진 -->
						<ul class="info_group">
							
							<li class="info_photo">
								<img src="/common/images/common/img_photo.gif" id="image3" alt="직원사진">
							</li>					
							<li class="info_txt">
								<p class="affiliation"><span id="orgNm3">소속</span></p>
								<a class="btn filled" style="float: right" onclick="showProfile('3')"><span id="profile3">프로필 상세보기</span></a>
								<p class="info_name" ><span id="tNmae3"></span>&nbsp;
								                      <span class="f_400" id="tJikGub" style="font-size: 60%;"></span></p>
							</li>
							<li class="info_txt">	
								<dl class="info_txt_point">
									<dt>직위</dt>
		                            <dd id="jikweeNm3"></dd>
								</dl>
								<dl class="info_txt_point">
									<dt>입사일</dt>
									<dd id="empYmd3">&nbsp;&nbsp;</dd>
								</dl>
								<dl class="info_txt_point">
									<dt>생년월일</dt>
									<dd id="birYmd3"></dd>
								</dl>
							</li>
						</ul>
					
						<div >
		                 
		                    <!-- 02.학력사항 -->
		                    <h4 class="info_title">학력사항</h4>
		                    <div class="table_top_gray">
		                        <div class="info_gray" id="acaTb3" >
		                        </div>
		                    </div>
		                    <!-- //02.학력사항 end -->
		                    
							
							<!-- 04.자격증 -->
							<h4 class="info_title">자격증</h4>
							<div class="table_top_gray">
								<div class="info_gray" id="lcsTb3" >
								</div>
							</div>
							<!-- 04.외국어 -->
							<h4 class="info_title">외국어</h4>
		                    <div class="table_top_gray">
		                        <div class="info_gray" id="frgTb3" >
		                        </div>
		                    </div>
							<!-- //04.외국어end -->
							
							<h4 class="info_title">평가사항</h4>
							<div class="table_top_gray">
								<div class="info_gray" id="papTb3" >
								</div>
							</div>						
							
							<!-- 05.상벌사항 -->
							<h4 class="info_title">포상사항</h4>
							<div class="table_top_gray">
								<div class="info_gray" id="przTb3" >
								</div>
							</div>			
						</div>				
					</div>
				</div>
			</div>
		
		</div>
		<!-- //인사정보_pop -->
	</div>
</div>


    </form>

</div>
</body>
</html>
