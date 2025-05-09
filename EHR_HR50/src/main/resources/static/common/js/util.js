var ajaxUtil = {
	ajax : function(opts){
		var defaultOption = {
			method : "GET",
			contentType : "application/x-www-form-urlencoded; charset=UTF-8", //application/json; charset=UTF-8
			url : "/",
			data : "",
			async : true,
			cache : false,
			scriptCharset : "utf-8",
			mimeType : false,
			processData : false
		};

		$.extend(defaultOption, opts);

		if(defaultOption["method"] != "GET" && defaultOption["mimeType"] != "multipart/form-data"){
			defaultOption["contentType"] = "application/json; charset=UTF-8";
		}

		$.ajax({
			method : defaultOption["method"],
			url: defaultOption["url"],
			contentType : defaultOption["contentType"],
			data : defaultOption["data"],
			async : defaultOption["async"],
			cache : defaultOption["cache"],
			scriptCharset : defaultOption["scriptCharset"],
			mimeType : defaultOption["mimeType"],
			processData : defaultOption["processData"],
//			  beforeSend : function(xmlHttpRequest){
//					xmlHttpRequest.setRequestHeader("AJAX","true");
//			  },
//			  statusCode: {
//			  		905: function() {
//				      	top.location.reload();
//			  	    }
//			  },
			success: function(response, status, obj) {
				if(defaultOption["success"] != null){
					defaultOption.success(response, status, obj);
				}else{
					result = response;
				}
			},
			error: function(response, status, obj) {
				var etcObj = {
					"defaultOpts" : defaultOption
				};

				ajaxJsonErrorAlert(response, status, obj, etcObj);
				
				try{overlay.hide();}catch(e){}
				if(defaultOption["error"] != null){
					defaultOption.error(response, status, obj);
				}else{
					return null;
				}
			}
		});
	}
}

var modalUtil = {

	modalStackHandler : [],
	zIndex : 1100,

	/**
	 modal 을 stack 에 추가 한다.
	 */
	addModalStack : function(obj){
		this.modalStackHandler.push(obj);
	},

	/**
	 modal 을 오픈한다.

	 options
	 id(param) : 현재 모달의 uniqe ID
	 autoOpen : modal 자동 open 여부
	 autoClose : modal 자동 close 여부
	 title : modal 의 title
	 type : modal 의 type (html / url)
	 scriptVariable : modal div 안의 script 객체 변수명
	 ibsheetIds : modal에서 사용한 ibsheetId
	 params : modal 에 전달할 params > init의 obj["params"] 로 사용가능.
	 callback :

	 target : modal Div


	 */
	openOptionStack:[],
	open :function(opts){
		try{
			this.clean();

			var defaultOpts = {
				"id" : "",
				"autoOpen" : true,
				"autoClose" : true,
				"title" : "Modal",
				"type" : "html", //url , html
				"scriptVariable" : null,
				"ibsheetIds" : [],
				"params" : null,
				"callback" : null,
				"useDimAutoClose" : true,
				"html" : "",
				"target" : "",
			};

			$.extend(defaultOpts, opts);

			let filterResult = this.openOptionStack.filter(e => {
				return e.type == defaultOpts.type && e.url == defaultOpts.url && e.html == defaultOpts.html;
			});

			if(filterResult.length > 0) {
				return
			} else {
				this.openOptionStack.push(this.cloneObject(defaultOpts));
			}

			if(defaultOpts.type == "html"){
				this.openHtml(defaultOpts);
			}else if (defaultOpts.type == "url"){
				this.openUrl(defaultOpts);
			}
		}catch(err){
			debugger;
			console.error(`[Function open]`,err.stack);
		}
	},
	cloneObject: function(obj) {
		var clone = {};
		try{
			for (var key in obj) {
				if (typeof obj[key] == "object" && obj[key] != null) {
					clone[key] = this.cloneObject(obj[key]);
				} else {
					clone[key] = obj[key];
				}
			}
		}catch(err){
			debugger;
			console.error(`[Function cloneObject]`,err.stack);
		}

		return clone;
	},

	/**
	 close modal
	 */

	close : function(){
		this.removeModal();
	},

	/**
	 autoClose == true 일때
	 opener의 callback에 param을 전달한다.
	 */
	sendParam : function(obj){
		this.removeModal(obj);
	},

	/**
	 html type 으로 modal 을 open 한다.
	 */
	openHtml : function(opts){
		try{
			var idx = this.zIndex+2;
			var modal = $("<div class='modal_outer' id='modalOuter_"+idx+"'>"+opts.html+"</div>");
			var modalId = modal.find(".modal_background").closest("div.modal_outer").attr("id");

			//body에 추가.
			$("body").append(modal);
			$("#"+modalId).css("z-index", idx);
			$("#"+modalId).find(".modal_header span").text(opts.title);

			opts["id"] = modalId;
			opts["target"] = modal
			opts["outer"] = opts["target"];

			opts["scriptVariable"] = eval(opts.scriptVariableNm);

			opts["scriptVariable"].init(opts);

//			opts["target"].find(".task-modal").slimScroll({ height: "200px" });

			if(opts["autoOpen"] == true){
				opts["target"].find(".modal, .modal_background").addClass("fade-in")
			}

			this.zIndex = this.zIndex + 2;
			this.addModalStack(opts);
			this.evnetHandler(opts);
		}catch(err){
			debugger;
			console.error(`[Function openHtml]`,err.stack);
		}
	},

	/**
	 url type 으로 modal 을 open 한다.
	 */
	openUrl : function(opts){
		try{
			//modal_title
			var that = this;

			//		var recursiveEncoded = $.param( opts.params );

			//		var method = "GET";

			// POST 일때 추가.
			//		if(opts.method != null && opts.method == "POST"){
			//			method = "POST";
			//			recursiveEncoded = JSON.stringify(opts.params);
			//		}

		var ajaxOpts = {
				"method" : "POST",
				"url" : opts["url"],
				"data" : JSON.stringify(opts.params),
				"success" : function(response, status, obj){
					opts["html"] = response; 

					that.openHtml(opts); 

				},

				"error" :  function(response, status, obj){
					console.log(response);
					console.log(status);
					console.log(obj);
				}
			};

			ajaxUtil.ajax(ajaxOpts);
//			ajaxCall3(opts["url"], "post", JSON.stringify(opts.params), true, null, function(response, status, obj){
//					opts["html"] = response;
//					that.openHtml(opts);
//				});
		}catch(err){
			debugger;
			console.error(`[Function openUrl]`,err.stack);
		}
	},

	/**
	 modal 을 삭제한다.

	 autoClose 가 ture 이면 callback을 자동으로 호출해준다.
	 */
	removeModal : function(obj){
//		try{
		var opts = this.modalStackHandler.pop();

		this.openOptionStack.pop();

		var outer = opts["outer"];

		outer.off(); // 제거될때는 모든 이벤트를 제거하고 해당라인 이후 이벤트만 적용한다.'
		//		outer.children("div.modal").on('hidden.bs.modal', function () {
		setTimeout(function(){
			if(opts["autoClose"] == true && opts.callback != null
				&& ((obj != null && obj != undefined) || (opts.rtnValue != null && opts.rtnValue != undefined))) {

				opts.callback(Object.assign(obj||{}, opts.rtnValue||{}));
			}else{
				if(opts["modalClose"] != null){
					opts.modalClose();
				}
			}
		}, 200);

		//		});
		outer.find(".modal, .modal_background").removeClass("fade-in")

		outer.remove();
//		}catch(err){
//			debugger;
//			console.error(`[Function removeModal]`,err.stack);			
//		}
	},

	/**
	 iframe modal 을 삭제한다.
	 */
	// removeIframeModal : function(obj){
	// 	var opts = this.modalStackHandler.pop();
	// 	this.openOptionStack.pop();
	// 	var outer = opts["outer"];
	// 	console.log('opts ::  ',opts)
	//
	// 	outer.children("div.modal").off(); // 제거될때는 모든 이벤트를 제거하고 해당라인 이후 이벤트만 적용한다.'
	// 	outer.children("div.modal").modal('hide');
	//
	// 	outer.remove();
	// },

	/**
	 event 정의
	 */
	evnetHandler : function(opts){
		var that = this;
		opts["target"].find(".modal_close_btn").click(function(){
			that.removeModal();
		});

		// iframe 모달 닫기 - header
		// opts["target"].find("div.modal-header button.iframeModalClose").click(function(){
		// 	console.log('iframeModalClose!!')
		// 	that.removeIframeModal();
		// });
		// // iframe 모달 닫기 - footer
		// opts["target"].find("div.modal-footer button.iframeModalClose").click(function(){
		// 	that.removeIframeModal();
		// });

		// modal 창 이외의 영역을 클릭해서 hide시 모달의 html,script도 제거해준다.
		// 2021.08.30 : children > find 로 변경
		
		opts["target"].find(".modal_background").on('click', function () {
			that.removeModal();
		});

		if(opts["useDimAutoClose"] == false){
			opts["target"].find(".modal_background").off('click');
		}
		

	},
	/**
	 최근 modal opts를 가져온다.
	 */
	getCurrentModal : function(idx){
		try{
			if(idx != null){
				return this.modalStackHandler[this.modalStackHandler.length+(idx-1)];
			}else{
				return this.modalStackHandler[this.modalStackHandler.length-1];
			}
		}catch(err){
			debugger;
			console.error(`[Function getCurrentModal]`,err.stack);
		}
	},

	clean : function(){

	}

};

var processMapLinkBarUtil = {
	open: function(procNm, prgPath, location, surl, murl, menuId, procMapLinkBarInfo){
		window.top.openContent(
			procNm,
			prgPath,
			location,
			surl,
			murl,
			menuId,
			procMapLinkBarInfo
		)
	},
	///WEB-INF/jsp/common/include/processMapChecker.jsp 에서 사용
	addLinkBar:function(linkBarProcMapSeq, linkBarProcSeq, openIframeBody){
		try{
			var processMapLinkBar = $(
				"<div class='process_map_link_bar' id='process_map_link_bar'>"+
				"<link rel='stylesheet' href='/assets/plugins/swiper-10.2.0/swiper-bundle.min.css' />"+
				"<script src='/assets/plugins/swiper-10.2.0/swiper-bundle.min.js'></script>"+
				"<script>"+
      			"const mySwiper = new Swiper('.swiper', "+
      				"{slidesPerView: 'auto',"+
      				"watchSlidesVisibility: true,"+
      				"spaceBetween: 0,navigation: {"+
      					"nextEl: '.arrow_right_btn',"+
      					"prevEl: '.arrow_left_btn',},"+
      				"noSwipingSelector: null,slidesPerGroupAuto: true,});"+
      			"</script>"+
				"<div class='icon_area'>"+
					"<i class='mdi-ico filled'>keyboard_arrow_left</i>"+
				"</div>"+
    			"<div class='bar_content'>"+
    				"<div class='title_area'><span></span></div>"+
      				"<div class='swiper'>"+
        				"<div class='swiper-wrapper btn_wrap'></div>"+
      				"</div>"+

      				"<div class='arrow_wrap'>"+
        				"<span class='arrow_left_btn swiper-button-prev'>"+
         				"<i class='mdi-ico'>arrow_back_ios</i>"+
        				"</span>"+
        				"<span class='arrow_right_btn swiper-button-next'>"+
         				"<i class='mdi-ico'>arrow_forward_ios</i>"+
        				"</span>"+
      				"</div>"+
    			"</div>"+
				"</div>"
			);
			
			//body에 추가.
			$(openIframeBody).append(processMapLinkBar);
						
			this.fetchProcList(linkBarProcMapSeq,linkBarProcSeq,openIframeBody);
						
		}catch(err){
			console.error(`[Function processMapLinkBarUtil.open]`,err.stack);
			debugger;
		}
	},
	drawProcBtn : function(data,linkBarProcSeq,openIframeBody){
		let procMapNm=data.procMapNm;
		let procList=data.procList;
		$(openIframeBody).find("#process_map_link_bar .title_area span").text(procMapNm);
		let procIdx=0;
		for(procIdx=0;procIdx<procList.length;procIdx++){
			let isActiveProcSeq=procList[procIdx].procSeq==linkBarProcSeq?" active":" "
			$(openIframeBody).find("#process_map_link_bar .swiper-wrapper").append(
				"<div class='swiper-slide btn_area'>"+
				"<div class='map_btn"+isActiveProcSeq+"'>"+
    			"<button class='btn outline_gray left'>"+
      			"<span class='number'>"+procList[procIdx].seq+"</span>"+
      			procList[procIdx].procNm+
    			"</button>"+
    			"<button class='btn outline_gray right'>"+
      			"<i class='mdi-ico filled'>library_books</i>"+
    			"</button>"+    			
  				"</div>"+
    			"<div class='speech_bubble'>"+procList[procIdx].memo+"</div>"+
				"<form id=" + procList[procIdx].procSeq + " onsubmit='return false'>" +
				"<input type='hidden' name='procMapSeq' value='" + procList[procIdx].procMapSeq + "' />" +
				"<input type='hidden' name='location' value='" + procList[procIdx].location + "' />" +
				"<input type='hidden' name='procNm' value='" + procList[procIdx].procNm + "' />" +
				"<input type='hidden' name='surl' value='" + procList[procIdx].surl + "' />" +
				"<input type='hidden' name='murl' value='" + procList[procIdx].murl + "' />" +
				"<input type='hidden' name='menuId' value='" + procList[procIdx].menuId + "' />" +
				"<input type='hidden' name='prgPath' value='" + procList[procIdx].prgPath + "' />" +
				"<input type='hidden' name='helpTxtTitle' />" +
				"<textarea style='display:none' name='helpTxtContent' form='" + procList[procIdx].procSeq + "'></textarea>" +
				"<input type='hidden' name='fileSeq' value='"+ procList[procIdx].fileSeq + "' />" +
				"</from>"+
  				"</div>"
  			);
			// jQuery append 시 helpTxtContent 의 원문이 변형되는 케이스가 발견되어 append 이후 value 지정하는 것으로 변경.
			$(openIframeBody).find("form#"+procList[procIdx].procSeq).find("input[name=helpTxtTitle]").val(procList[procIdx].helpTxtTitle);
			$(openIframeBody).find("form#"+procList[procIdx].procSeq).find("textarea[name=helpTxtContent]").val(procList[procIdx].helpTxtContent);

  			if (procList[procIdx].memo == "") {
				$(openIframeBody).find("#process_map_link_bar .speech_bubble").last().remove();
			}
			
			if (procList[procIdx].helpTxtTitle == "") {
				$(openIframeBody).find("#process_map_link_bar .btn.outline_gray.right").last().remove();
			}
  		}
		
		this.evnetHandler(openIframeBody);
	},
	fetchProcList:function(procMapSeq,linkBarProcSeq,openIframeBody){
		var that = this;
		var ajaxOpts = {
			"method" : "GET",
			"url" : "/ProcessMapMgr.do?cmd=getProcessList&procMapSeq="+procMapSeq,
			"success" : function(response, status, obj){
				if(response.status.indexOf('SUCCESS')>-1){
					that.drawProcBtn(response,linkBarProcSeq,openIframeBody)
				}
			},
			"error" :  function(response, status, obj){
				console.log(response);
				console.log(status);
				console.log(obj);
			}
		};
		ajaxUtil.ajax(ajaxOpts);
	},
	openHelpModal:function(procSeq,helpTxtTitle,helpTxtContent,fileSeq){
		let option = {
			scriptVariableNm: "modalScript",
			type: "url",
			url: "/ProcessMapMgr.do?cmd=viewProcessMapHelpPop",
			title: "도움말",
			params: {
				procViewMode: "viewer",
				procSeq: procSeq,
				fileSeq: fileSeq,
				authPg:'R',
				helpTxtTitle: helpTxtTitle,
				helpTxtContent: helpTxtContent
			}
		};

		window.top.modalUtil.open(option);
	},
	evnetHandler : function(openIframeBody){
		var that = this;
		document.querySelector("iframe").contentWindow.document.querySelectorAll("#process_map_link_bar .btn_area button").forEach((button) => {
			button.addEventListener("mousedown", (e) => {
				e.preventDefault();
			});
		});

		$(openIframeBody).find("#process_map_link_bar .icon_area").on("click", function() {
			$(openIframeBody).find("#process_map_link_bar .bar_content").toggleClass("hidden");
			var icon = $(this).find("i");
    		if (icon.text() === "keyboard_arrow_left") {
      			icon.text("explore");
      			$(".bar_content").addClass("hidden");
    		} else {
      			icon.text("keyboard_arrow_left");
      			$(".bar_content").removeClass("hidden");
    		}
		});
		
		$(openIframeBody).find("#process_map_link_bar .btn.left").on("click", function() {
			$(openIframeBody).find("#process_map_link_bar .btn").removeClass("active");
			var btnArea = $(this).closest(".btn_area");
			btnArea.find(".btn").addClass("active");
		});
		
		$(openIframeBody).find("#process_map_link_bar .btn.outline_gray.left").on("click", function() {
			let procMapForm=$(this).closest(".swiper-slide.btn_area").find("form")
			let procSeq=$(procMapForm).attr("id");
			let procMapSeq=$(procMapForm).find("input[name=procMapSeq]").val();
			let prgPath=$(procMapForm).find("input[name=prgPath]").val();
			let procNm=$(procMapForm).find("input[name=procNm]").val();
			let location=$(procMapForm).find("input[name=location]").val();
			let surl=$(procMapForm).find("input[name=surl]").val();
			let murl=$(procMapForm).find("input[name=murl]").val();
			let menuId=$(procMapForm).find("input[name=menuId]").val();
			let procMapLinkBarInfo={procMapSeq:procMapSeq,procSeq:procSeq}
			that.open(
//			window.top.openContent(
				procNm,
				prgPath,
				location,
				surl,
				murl,
				menuId,
				procMapLinkBarInfo
			)
		});
		
		$(openIframeBody).find("#process_map_link_bar .btn.outline_gray.right").click(function() {
			let procSeq=$(this).closest(".swiper-slide.btn_area").find("form").attr("id");
			let tempProc = $(openIframeBody).find("form#"+procSeq);
			let helpTxtTitle = $(tempProc).find("input[name=helpTxtTitle]").val();
			let helpTxtContent = $(tempProc).find("textarea[name=helpTxtContent]").val();
			let fileSeq = $(tempProc).find("input[name=fileSeq]").val();
			that.openHelpModal(procSeq,helpTxtTitle,helpTxtContent,fileSeq);
		});
	}
}
var loadingUtil = {
	on:function(){
		//body에 추가.
		$("body").append('<img id="loading_circle" src="/common/plugin/IBLeaders/Sheet/js/Main/process.png" class="loading">');
	},
	off:function(){
		$("#loading_circle").remove();
	}
}