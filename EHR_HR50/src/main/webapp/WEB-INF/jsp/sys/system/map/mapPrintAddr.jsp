<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<spring:eval var="svrUrl" expression="@environment.getProperty('svr.url')"/>
<!DOCTYPE html> <html class="hidden"><head> <title>주소지도검색</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=2c3bdd43a6bf27f673d86e42d1f8348e&libraries=services"></script>
<style>
.customoverlay {position:relative;bottom:60px;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd;float:left;}
.customoverlay .title {display:block;text-align:center;background:#fff;padding:10px 15px;font-size:14px;font-weight:bold;}
</style>
<script type="text/javascript">
	var confirmYn = true;
	var popupGubun = "";
	var gPRow = "";
	var pGubun = "";

	var minX = null;
	var maxX = null;
	var minY = null;
	var maxY = null;

	var map = null;
	var markers = [];
	var geocoder = new kakao.maps.services.Geocoder();

	var _pre_animated_marker = null;

	var cnt = 0;

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck: 1 };
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",      Hidden:1,  Width:50,  	Align:"Left",	ColMerge:0,   SaveName:"sabun",       	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='sortSeq' mdef='정렬\n순서'/>",	Type:"Int",       Hidden:0,  Width:30,  	Align:"Right",  ColMerge:0,   SaveName:"seq",       	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:5 },
			{Header:"<sht:txt mid='departmentV1' mdef='부서'/>",		Type:"Text",      Hidden:0,  Width:70,  	Align:"Left",   ColMerge:0,   SaveName:"orgNm",       	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='title' mdef='제목'/>",		Type:"Text",      Hidden:1,  Width:50,  	Align:"Left",   ColMerge:0,   SaveName:"title",       	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",      Hidden:0,  Width:50,  	Align:"Center", ColMerge:0,   SaveName:"name",       	KeyField:1,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"마커유형",	Type:"Combo",     Hidden:0,  Width:60,  	Align:"Center", ColMerge:0,   SaveName:"markerType",	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='addr' mdef='주소'/>",		Type:"Text",      Hidden:0,  Width:150,  	Align:"Left",   ColMerge:0,   SaveName:"addr1",       	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:200 }
		];

		IBS_InitSheet(sheet1, initdata);
		sheet1.SetEditable("${editable}");

		sheet1.SetColProperty( "markerType" , {ComboText: "유형1|유형2|유형3", ComboCode: "1|2|3"} );

		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);

		$(window).resize(function(){

			var height1 = $(".wrapper").height();
			var width1 = $(".sheet_right").width();

			$("#map").height( height1);
			$("#map").width( width1 - 20);

			$("#btn_div1").height( height1 );

			//$("#map").height( height1 - 200);
		}).resize();

		reDrawCombo();

		$("#searchTitle").change(function(e){

			doAction1("Search2");
		});

		$("#name , #orgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Find");
				$(this).focus();
			}
		});

		$(window).smartresize(sheetResize);
		sheetInit();
		
		drawMap();

		$("#close_btn").click(function(e){
			$(this).hide();
			$("#open_btn").show();
			$(".sheet_left").width("0%");
			$(".sheet_left").hide();
			$(".sheet_right").width("100%");
			$(window).resize();
			doAction1("Draw");
		});

		$("#open_btn").click(function(e){
			
			$(this).hide();
			$("#close_btn").show();
			$(".sheet_left").width("40%");
			$(".sheet_left").show();
			$(".sheet_right").width("60%");
			$(window).resize();
			doAction1("Draw");
		});

		//doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": 	 	// 인사정보 조회
				if(!isPopup()) {return;}

				let modalLayer = new window.top.document.LayerModal({
					id: 'mapPrintAddrLayer',
					url: '/MapPrintAddr.do?cmd=viewMapPrintAddrLayer',
					parameters: {},
					width: 780,
					height: 280,
					title: '주소 가져오기',
					trigger: [
						{
							name: 'mapPrintAddrLayerTrigger',
							callback: function(rv) {
								var title = rv["title"];
								$("#preFindTitle").val( title );
								reDrawCombo();
								doAction1("Search2");
							}
						}
					]
				});
				modalLayer.show();

				break;
			case "Search2":		// 기저장된 내역 조회
				var searchTitle = $("#searchTitle").val();

				$("#title1").val(searchTitle);

				sheet1.DoSearch( "${ctx}/MapPrintAddr.do?cmd=getMapPrintAddr2", $("#srchFrm").serialize() );
				break;
			case "Delete":

				var searchTitle = $("#searchTitle").val();
				if(confirm( "[" +  searchTitle + "] 삭제하시겠습니까?")){
					var data = ajaxCall("${ctx}/MapPrintAddr.do?cmd=deleteMapPrintCombo", "title=" + searchTitle, false);

					if ( data.Result["Code"] == "1" ) {

						alert("삭제 되었습니다.");
						doAction1("Clear");
						reDrawCombo();
					}else{
						alert("<msg:txt mid='errorDelete2' mdef='삭제에 실패하였습니다.'/>");
					}
				}

				break;
			case "Find":		// 문자열 검색

				var name = $("#name").val();
				var orgNm = $("#orgNm").val();

				if ( name != "" ){
					var row = sheet1.FindText( "name" , name , 0 , 2 , 0 );
					sheet1.SetSelectRow( row );
				}else if ( orgNm != "" ){

					var row = sheet1.FindText( "orgNm" ,  orgNm , 0 , 2  , 0 );
					sheet1.SetSelectRow( row );
				}

				break;
			case "Draw":

				drawMap();

				markers = new Array( sheet1.RowCount()); 

				 var j = null;

				for( j = sheet1.HeaderRows(); j <= sheet1.LastRow(); j++){

					var addr1 = sheet1.GetCellValue( j , "addr1" );
					var name = sheet1.GetCellValue( j , "name" );
					var markerType 	= sheet1.GetCellValue( j , "markerType" );

					var isLast = false;

					if( sheet1.LastRow() == j ){
						isLast = true;
					}
					
					
					var vsX ="";
					var vsY ="";

					if ( addr1 != "" ){
						
						
						searchAddressToCoordinate( addr1 , name , j  , markerType , isLast );
					}
					
					
					
				}

				break;
			case "Insert":
				var Row = sheet1.DataInsert(0);
				break;
			case "Save":

				var title = $("#searchTitle").val();

				if ( title == null || title == "" ){

					doAction1("SaveNew");
				}else{

					for( var j = sheet1.HeaderRows(); j <= sheet1.LastRow(); j++){

						sheet1.SetCellValue( j , "title" , title , false );
					}

					doAction1("SaveAct");
				}

				break;
			case "SaveNew":

				var title = prompt("제목을 입력하세요.");

				if ( title != "" ){

					for( var j = sheet1.HeaderRows(); j <= sheet1.LastRow(); j++){

						sheet1.SetCellValue( j , "title" , title , false );
					}

					doAction1("SaveAct");
				}

				break;
			case "SaveAct":

				for( var j = sheet1.HeaderRows(); j <= sheet1.LastRow(); j++){

					sheet1.SetCellValue( j , "sStatus" , "I" , false );
				}

				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/MapPrintAddr.do?cmd=saveMapPrintAddr", $("#srchFrm").serialize());
				break;
			case "Clear":
				sheet1.RemoveAll();
				break;
			case "DownTemplate":
				sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0" , DownCols:"4|5|7|8|9"});
				break;
			case "Down2Excel":
				sheet1.Down2Excel();
				break;
			case "LoadExcel":
				doAction1("Clear");

				$("#searchTitle").val("");
				var params = {Mode:"HeaderMatch", WorkSheetNo:1};
				sheet1.LoadExcel(params);
				break;
		}
	}

	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			minX = null;
			maxX = null;
			minY = null;
			maxY = null;

			sheetResize();
			
			drawMap();

			markers = new Array( sheet1.RowCount() );

			var j = null;

			for( j = sheet1.HeaderRows(); j <= sheet1.LastRow(); j++){

				var addr1 		= sheet1.GetCellValue( j , "addr1" );
				var name 		= sheet1.GetCellValue( j , "name" );
				var markerType 	= sheet1.GetCellValue( j , "markerType" );

				if ( markerType == "1" ){
					sheet1.SetRowBackColor( j , "#A5FA7D");
				} else if ( markerType == "2"){
					sheet1.SetRowBackColor( j , "#50B4FF");
				} else if ( markerType == "3"){
					sheet1.SetRowBackColor( j , "#FF8C8C");
				} else {
					sheet1.SetRowBackColor( j , "");
				}

				var isLast = false;

				if( sheet1.LastRow() == j ){
					isLast = true;
				}

				if ( addr1 != "" ){
					searchAddressToCoordinate( addr1 , name , j , markerType , isLast );
				} 
			}

			pGubun = "";

		} catch (ex) {
			//alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);

				var searchTitle = $("#searchTitle").val();

				$("#preFindTitle").val( searchTitle );

				reDrawCombo();
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex1);
		}
	}

	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {

		if( sheet1.ColSaveName(Col) == "markerType" ) {

			var markerType 	= sheet1.GetCellValue( Row , "markerType" );

			if ( markerType == "1" ){
				sheet1.SetRowBackColor( Row , "#A5FA7D");
			} else if ( markerType == "2"){
				sheet1.SetRowBackColor( Row , "#50B4FF");
			} else if ( markerType == "3"){
				sheet1.SetRowBackColor( Row , "#FF8C8C");
			} else {
				sheet1.SetRowBackColor( Row , "");
			}
		} else if( sheet1.ColSaveName(Col) == "sDelete" ) {

			if ( Value == "1" ){

				sheet1.RowDelete( Row );
			}

		}
	}

	function sheet1_OnLoadExcel(result) {

		doAction1("Draw");
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{

			if (OldRow == NewRow ){
				return;
			}

			if ( markers[NewRow] != null ){
				naver.maps.Event.trigger(markers[NewRow] , "click");
			}

	  	}catch(ex){
	  		//alert("OnSelectCell Event Error : " + ex);
	  	}
	}

	/*
	* 콤보박스를 그린다.
	*/
	function reDrawCombo(){
		var data = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getMapPrintCombo",false).codeList, "");

		var comboHtml = '';
		comboHtml += '<option value="">선택</option>' + data[2];

/* 		for ( var i = 0 ; i < data.DATA.length; i++ ){

			var code = data.DATA[i]["code"];
			var codeNm = data.DATA[i]["codeNm"];

			comboHtml += '<option value="' + code + '">' + codeNm + '</option>';
		} */

		$("#searchTitle").html( comboHtml );

		var preFindTitle = $("#preFindTitle").val( );
		$("#searchTitle").val( preFindTitle );

		if ( preFindTitle != "" ){
			doAction1("Search2");
		}
	}

	/*
	* 지도를 그린다.
	*/
	
	function drawMap(){
		var container = document.getElementById('map');
		var options = {
			center: new kakao.maps.LatLng(37.49806156372358, 126.99384808362652),
			level: 5
		};

		map = new kakao.maps.Map(container, options);
		
		
	    // 마커 이미지의 이미지 주소입니다
		var imageSrc = "/common/images/common/deficon.png"; 
			
	    var imageSrc = imageSrc, // 마커이미지의 주소입니다    
	        imageSize = new kakao.maps.Size(30, 35); // 마커이미지의 크기입니다
	     
	
	   var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize),
	       markerPosition = new kakao.maps.LatLng(37.49806156372358, 126.99384808362652); // 마커가 표시될 위치입니다
	
		// 마커를 생성합니다
		var marker = new kakao.maps.Marker({
		    position: markerPosition,
		    image: markerImage // 마커이미지 설정 
		});
	
		// 마커가 지도 위에 표시되도록 설정합니다
		marker.setMap(map);  
	
		// 커스텀 오버레이에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다
		var content = '<div class="customoverlay">' +
		              '    <span class="title">본사</span>' +
		              '</div>';
	
		// 커스텀 오버레이가 표시될 위치입니다 
		var position = new kakao.maps.LatLng(37.49806156372358, 126.99384808362652);  
	
		// 커스텀 오버레이를 생성합니다
		var customOverlay = new kakao.maps.CustomOverlay({
		    map: map,
		    position: position,
		    content: content
		}); 
		
	}
	
	
	function searchAddressToCoordinate( address , name , j , markerType , isLast ) {
		
		
		geocoder.addressSearch(address, function(result, status) {

		    // 정상적으로 검색이 완료됐으면 
		     if (status === kakao.maps.services.Status.OK) {

		        coords = new kakao.maps.LatLng(result[0].y, result[0].x); 

		        
		    //-----------------------------------------    
		    var markerImg ="";
		    
			if ( markerType == "1" ){
        		markerImg = "marker_01.png";
        	}else if ( markerType == "2" ){
        		markerImg = "marker_02.png";
        	}else if ( markerType == "3" ){
        		markerImg = "marker_03.png";
        	}
	       
			var imageSrc = "/common/images/common/"+markerImg, // 마커이미지의 주소입니다    
			     imageSize = new kakao.maps.Size(24, 35); // 마커이미지의 크기입니다
			     
			
		    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize),
		    markerPosition = coords; // 마커가 표시될 위치입니다

			// 마커를 생성합니다
			var marker = new kakao.maps.Marker({
			  position: markerPosition,
			  image: markerImage // 마커이미지 설정 
			});

			// 마커가 지도 위에 표시되도록 설정합니다
			marker.setMap(map);  

			// 커스텀 오버레이에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다
			var content = '<div class="customoverlay">' +
			    '    <span class="title">'+name+'</span>' +
			    '</div>';

			// 커스텀 오버레이가 표시될 위치입니다 
			var position = coords;  

			// 커스텀 오버레이를 생성합니다
			var customOverlay = new kakao.maps.CustomOverlay({
			    map: map,
			    position: position,
			    content: content
			    
			});    
			    
	   	   } 
		    
		}); 
	    
	}

	/*
	* 지도에 마커를 표시한다.
	*/
	/* function searchAddressToCoordinate( address , name , j , markerType , isLast ) {

	    naver.maps.Service.geocode({
	        address: address
	    }, function( status , response ) {
	        if (status === naver.maps.Service.Status.ERROR) {
	            return ;
	        }

	        var item = response.result.items[0];
	            point = new naver.maps.Point(item.point.x, item.point.y);

	        var marker = null;

	        // 마커유형에 따라 마커 이미지를 변경한다.
	        if ( markerType == "" ){

	        	markerImg = "deficon.png";

		        marker = new naver.maps.Marker({
		            position: new naver.maps.LatLng(point),
		            map: map,
		            icon : {
		            	content: '<img src="${svrUrl}/common/images/common/' + markerImg + '" alt="" ' +
                        'style="margin: 0px; padding: 0px; border: 0px solid transparent; display: block; max-width: none; max-height: none; ' +
                        '-webkit-user-select: none; position: absolute; width: 35px; height: 35px; left: 0px; top: 15px;">'
                        + '<p style="top : 0px; font-weight:bold; color : black">' + name + "</p>" ,
		               size: new naver.maps.Size(50, 50),
		               anchor: new naver.maps.Point(25, 50)
		            }
		        });
	        } else {

	        	var markerImg = "";

	        	if ( markerType == "1" ){
	        		markerImg = "marker_01.png";
	        	}else if ( markerType == "2" ){
	        		markerImg = "marker_02.png";
	        	}else if ( markerType == "3" ){
	        		markerImg = "marker_03.png";
	        	}

	        	marker = new naver.maps.Marker({
		            position: new naver.maps.LatLng(point),
		            map: map,
		            icon: {
		                content: '<img src="${svrUrl}/common/images/common/' + markerImg + '" alt="" ' +
		                         'style="margin: 0px; padding: 0px; border: 0px solid transparent; display: block; max-width: none; max-height: none; ' +
		                         '-webkit-user-select: none; position: absolute; width: 22px; height: 35px; left: 0px; top: 15px;">'
		                         + '<p style="top : 0px; font-weight:bold; color : black">' + name + "</p>" ,
		                size: new naver.maps.Size(22, 50),
		                anchor: new naver.maps.Point(11, 50)
		            }
		        });
	        }

	        var contentString = [
	            '<div class="iw_inner">',
	            '   <h3>' + name + '</h3>',
	            '   <p>' + address + '',
	            '   </p>',
	            '</div>'
	        ].join('');

		    var infowindow = new naver.maps.InfoWindow({
		        content: contentString
		    });

		    markers[j] = marker;

		    // 클릭 이벤트를 추가한다.
		    naver.maps.Event.addListener( marker , "click", function(e) {

		        if (infowindow.getMap()) {
		            infowindow.close();
		        } else {
		            infowindow.open( map , marker);
		        }

		        if (marker.getAnimation() !== null) {

		        	marker.setAnimation(null);
		        } else {
		        	try{

			        	_pre_animated_marker.setAnimation(null);
			        }catch(e){}

		        	marker.setAnimation(naver.maps.Animation.BOUNCE);
		        	_pre_animated_marker = marker;
		        }
		    });

	        //map.setCenter(point);
	    });
	} */

</script>
</head>
<body class="hidden">
	<input type="hidden" id="preFindTitle" name="preFindTitle" value="" />
	<div class="wrapper">
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main" style="height: 100%;">
			<tr>
				<td class="sheet_left" style="width:40%" >
					<div class="">
						<div class="sheet_search outer">
							<div>
								<form id="srchFrm" name="srchFrm" >
									<table>
										<tr>
											<th><tit:txt mid='104279' mdef='소속'/></th>
											<td>
												<input type="hidden" id="title1" name="title1" value="" />
												<input id="orgNm" name="orgNm" type="text" class="text" />
											</td>
											<th><tit:txt mid='103880' mdef='성명'/></th>
											<td>
												<input id="name" name="name" type="text" class="text" />
											</td>
											<td>
												<a href="javascript:doAction1('Find')" 	class="btn dark authR"><tit:txt mid='104081' mdef='조회'/></a>
											</td>
										</tr>
										<tr>
											<th>주소록</th>
											<td colspan="2">
												<select id="searchTitle" name="searchTitle">
													<option value="">선택</option>
												</select>&nbsp;&nbsp;&nbsp;
												<a href="javascript:doAction1('Delete')" 	class="btn outline_gray authR">주소록 삭제</a>
											</td>
										</tr>
									</table>
								</form>
							</div>
						</div>

						<div class="sheet_title inner">
							<ul>
								<li id="txt" class="txt">주소내역
								</li>
								<li class="btn">
									<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray thinner authR"><tit:txt mid='download' mdef='다운로드'/></a>
									<a href="javascript:doAction1('DownTemplate')" 	class="btn outline_gray thinner authR"><tit:txt mid='113684' mdef='양식다운로드'/></a>
									<a href="javascript:doAction1('LoadExcel')" class="btn outline_gray thinner authA"><tit:txt mid='104242' mdef='업로드'/></a>
									<a href="javascript:doAction1('Insert')" class="btn outline_gray thinner authA"><tit:txt mid='104267' mdef='입력'/></a>
									<a href="javascript:doAction1('Search')" 	class="btn soft thinner authR">주소록 생성</a>
									<a href="javascript:doAction1('Save')" class="btn filled thinner authA"><tit:txt mid='104476' mdef='저장'/></a>
								</li>
							</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
				</td>
				<td class="sheet_right" style="width:60%">
					<div id="btn_div1" style="width: 15px; height: 100%; float: left; ">
						<table style="width:100%; height: 100%;">
							<tr>
								<td style="vertical-align: middle;text-align: center;" align="center">
									<img id="close_btn" src="/common/images/common/btn_calendar_prev.gif" style="cursor: pointer;"/>
									<img id="open_btn" src="/common/images/common/btn_calendar_next.gif" style="display:none;cursor: pointer;"/>
								</td>
							</tr>
						</table>
					</div>
					<div id="map" style="width:100%;height:400px; float: left"></div>
					<!--
					<div style="width:100%; height:150px; ">
						<table style="width:100%;">
							<tr>
							<td class="bottom">
							<div class="explain">
								<div class="title"><tit:txt mid='appAddingControl2' mdef='작업내용'/></div>
								<div class="txt">
								<ul>
									<li>1. 주소내역을 조회 또는 업로드 합니다.</li>
									<li>2. [저장] 버튼을 클릭하여 주소목록을 저장합니다.</li>
									<li>3. "저장주소목록"을 선택하여 작업내역을 재사용할 수 있습니다.</li>
								</ul>
								</div>
							</div>
							</td>
						</tr>
						</table>
					</div>
					-->

				</td>
			</tr>
		</table>

	</div>
</body>
</html>
