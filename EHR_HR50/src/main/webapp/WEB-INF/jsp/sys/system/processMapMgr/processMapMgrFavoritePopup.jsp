<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

 <div id="bookmark_modal" class="bookmark_modal">
      <div class="modal_background"> </div>
      <div class="modal">
        <div class="modal_header"><span>즐겨찾기</span><i class="mdi-ico modal_close_btn">close</i></div>
        <div class="modal_sub_header">
          <div class="sub_title">권한선택</div>
			<select id="favModal_authGrp_select" class="custom_select" style="color: #323232;">
                <c:forEach	var="item" items="${authGrpList}" varStatus="status">
                	<option name="${item.grpNm}" value="${item.grpCd}">${item.grpNm}</option>			
				</c:forEach>
            </select>
            <span class="modal_desc"><i class="mdi-ico">error</i>임시저장된 프로세스맵은 즐겨찾기 할 수 없습니다.</span>
        </div>
        <div class="modal_body">
          <div class="left_area">
          </div>

          <div class="right_area">
          </div>


        </div>
        <div class="modal_footer">
          <button id="modal_cancel_btn" class="btn outline_gray modal_close_btn">취소</button>
          <button id="modal_submit_btn" class="btn filled modal_close_btn" onclick="modalScript.saveFavoriteList()">저장</button>
        </div>
      </div>
    </div>
    
<script type="text/javascript">
  var modalScript = {	
   selectedFavAuthGrp:{ grpNm: "${authGrpList[0].grpNm}", grpCd: "${authGrpList[0].grpCd}" },
    processMapList:[],
    favoriteList:[],
    modalOpts: null, // 전달받은 modalOpts (생성시 전달한 값 + target 등 추가된 opts 이다.)
    modal: null,
    updatedFav:false,
    init: function (obj) {
      this.modalOpts = obj;
      this.modal = this.modalOpts.target;
      this.fetchFavoriteList();
      // 권한 셀렉트 박스
      $("#favModal_authGrp_select").change(function(){
    	  if(modalScript.updatedFav){
    		  if(confirm("변경사항이 있습니다. 저장하시겠습니까?")){
    			  modalScript.saveFavoriteList();
    		  }
    	  }

    	  modalScript.updatedFav=false;
    	  	modalScript.selectedFavAuthGrp={ grpNm: $(this).find('option[value="'+$(this).val()+'"]').attr("name"), grpCd: $(this).val() };
		  	modalScript.fetchFavoriteList();
	  });
  	
    },
    fetchFavoriteList:function () {
    	let params={"grpCd":modalScript.selectedFavAuthGrp.grpCd!=""?modalScript.selectedFavAuthGrp.grpCd:null}
    	ajaxCall3("/ProcessMapMgr.do?cmd=getFavoriteList","get", params, false, null, modalScript.drawFavoriteList);
    },
    drawFavoriteList:function (data){
    	modalScript.processMapList=data.processMapList;
    	modalScript.favoriteList=data.favoriteList;
    	$("#bookmark_modal .modal_body .left_area").empty();	
    	$("#bookmark_modal .modal_body .right_area").empty();
    	//프로세스 맵 생성을 하나도 안했을 경우
    	if(modalScript.processMapList.length<1){
    		$("#bookmark_modal .modal_body .left_area").append(
    			'<div class="no_data">'+
    				'<i class="mdi-ico">star</i><span>작성한 프로세스맵이<br />없습니다.</span>'+
    			'</div>');
    		$("#bookmark_modal .modal_body .right_area").append(
    			'<div class="no_data">'+
    				'<i class="mdi-ico">star</i><span>작성한 프로세스맵이<br />없습니다.</span>'+
    			'</div>');
    		return;
    	}
    	
    	//즐겨찾기가 유무에 따라 우측 분기
    	if(modalScript.favoriteList.length<1){
    		$("#bookmark_modal .modal_body .right_area").append(
    			'<div class="no_data">'+
    				'<i class="mdi-ico">star</i><span>즐겨찾기 할 프로세스맵을<br />선택해주세요.</span>'+
    			'</div>');
    	}else{
    		let favoriteListIdx=0;
    		for(favoriteListIdx=0;favoriteListIdx<modalScript.favoriteList.length;favoriteListIdx++){
    			let procNameText = modalScript.makeProcNameText(modalScript.favoriteList[favoriteListIdx].procList);
    			$("#bookmark_modal .modal_body .right_area").append(
    				'<div class="bookmark" value="'+modalScript.favoriteList[favoriteListIdx].procMapSeq+'">'+
    					'<div><i class="mdi-ico">star</i>'+
                  		'<span>'+modalScript.favoriteList[favoriteListIdx].procMapNm+'</span>'+
                  		'<span class="desc">'+procNameText+'</span></div>'+
                		'</div>');
    			}
    	}
    	
    	//프로세스 생성된 프로세스 맵이 존재할 경우 좌측
    	let processMapListIdx = 0;
    	for(processMapListIdx=0;processMapListIdx<modalScript.processMapList.length;processMapListIdx++){
    		$("#bookmark_modal .left_area").append('<div class="toggle_wrap"></div>')
    			let lastToggleWrap=$("#bookmark_modal .toggle_wrap").last()
    			$(lastToggleWrap).append(
    				'<div class="toggle_menu">'+
    					'<div class="title">'+
    						'<span>'+modalScript.processMapList[processMapListIdx].mainMenuNm+'</span>'+
    					'</div>'+
    					'<i class="mdi-ico">keyboard_arrow_down</i>'+
    				'</div>');
    		$(lastToggleWrap).append('<div class="toggle_content"></div>');
    		let lastToggleContent=$("#bookmark_modal .toggle_wrap .toggle_content").last()
    		let childrenIdx=0;
    		for(childrenIdx=0;childrenIdx<modalScript.processMapList[processMapListIdx].children.length;childrenIdx++){
    			let tempProcessMapp=modalScript.processMapList[processMapListIdx].children[childrenIdx];
    			$(lastToggleContent).append(
    				'<div class="check_list">'+
    				'<label for="'+tempProcessMapp.procMapSeq+'">'+
                      '<input '+
                        'type="checkbox" '+
                        'class="form-checkbox type2" '+
                        'id="'+tempProcessMapp.procMapSeq+'">'+tempProcessMapp.procMapNm+'</input>'+
                      '</label>'+
                    '</div>');
                    $("input:checkbox[id='"+tempProcessMapp.procMapSeq+"']").prop("checked", tempProcessMapp.favoriteYn=="Y");  
    		}

    	}
    	$("#bookmark_modal .toggle_menu").click(function () {
        		var content = $(this).next(".toggle_content");
        		var icon = $(this).children("i");
            
        		$("#bookmark_modal .toggle_menu").not(this).removeClass("active");

        		if (content.is(":visible")) {
          			$(this).removeClass("active");
          			content.slideUp(100);
          			icon.text("keyboard_arrow_down");
        		} else {
          			$(this).addClass("active");
          			content.slideDown(100);
          			icon.text("keyboard_arrow_up");
        		}
      		});
      		$("#bookmark_modal .check_list input").click(function () {
      			modalScript.updatedFav=true;
    			  let processMapListIdx=0;
    			  let childrenIdx=0;
    			  let clicked=null;
    			  for(processMapListIdx=0;processMapListIdx<modalScript.processMapList.length;processMapListIdx++){
    				for(childrenIdx=0;childrenIdx<modalScript.processMapList[processMapListIdx].children.length;childrenIdx++){
    					if(modalScript.processMapList[processMapListIdx].children[childrenIdx].procMapSeq==$(this).prop("id")){
    						clicked=modalScript.processMapList[processMapListIdx].children[childrenIdx];
    					}
    				}
    			  }
    			if(clicked){
    				if($(this).prop("checked")==true){
    				//즐겨찾기가 유무에 따라 우측 분기
    					if($("#bookmark_modal .modal_body .right_area .bookmark").length<1){
    						$("#bookmark_modal .modal_body .right_area").empty();
    					}
    	    			let procNameText = modalScript.makeProcNameText(clicked.procList);
    					$("#bookmark_modal .modal_body .right_area").append(
    						'<div class="bookmark" value="'+clicked.procMapSeq+'">'+
    							'<div><i class="mdi-ico">star</i>'+
                  				'<span>'+clicked.procMapNm+'</span>'+
                  				'<span class="desc">'+procNameText+'</span></div>'+
                			'</div>');
    				}else{
    					$("#bookmark_modal .modal_body .right_area .bookmark").each(function (index, item) {
    						if($(item).attr("value")==clicked.procMapSeq){
    							$(item).remove();
    							if($("#bookmark_modal .modal_body .right_area .bookmark").length<1){
    								$("#bookmark_modal .modal_body .right_area").append(
    									'<div class="no_data">'+
    										'<i class="mdi-ico">star</i><span>즐겨찾기 할 프로세스맵을<br />선택해주세요.</span>'+
    									'</div>');
    							}
    						}
    					});	
    				}
    			}
    		});
    },
    makeProcNameText:function(procList){
		let procListIdx = 0;
		let procNameText = ""
		for(procListIdx=0;procListIdx<procList.length;procListIdx++){
			if(procListIdx==0){
				procNameText+=procList[procListIdx].procNm;
				continue;
			}
			procNameText+= " - " + procList[procListIdx].procNm
		}
		return procNameText;
    },
    saveFavoriteList:function(){
		this.modalOpts.rtnValue = {callback:true}
    	let newFavList=[];
    	$("#bookmark_modal .modal_body .right_area .bookmark").each(function (index, item) {
    						newFavList.push($(item).attr("value"));
    					});
    	let params={"favoriteProcMapSeqList":newFavList,"grpCd" : modalScript.selectedFavAuthGrp.grpCd}
    	ajaxCall3("/ProcessMapMgr.do?cmd=saveFavorite","post", JSON.stringify(params), false, null,function (){
    	alert("저장되었습니다.");
    });
    }
  };
</script></>