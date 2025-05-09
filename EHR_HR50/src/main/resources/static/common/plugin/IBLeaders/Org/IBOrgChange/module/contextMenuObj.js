/*
 * contextMenu 적용 샘플
 * jquery.contextMenu.js 사용
 *
 * IBOrgJS 의 onMouseDown, onMouseUp을 활용하여 인터페이스를 구현한다.
 *
 * jquery.contextMenu는 컨텍스트 메뉴를 팝업할때 팝업용 레이어를 기본 사용하는데
 * 해당 레이어에 대한 이벤트 버블링 캔슬 처리 코드때문에 IBOrgJS 이벤트가 발생되지않아
 * 쉽게 연동처리가 되지 않아 jquery.contextMenu의 버블링 캔슬 처리를 임시로 주석처리함.
 */
var menu = {
    node : {
        "appendChild": {
            name: "하위추가",
            icon: "",
            callback: function(evt){

            	// 상위부서 기본값을 설정
            	$("#priorOrgCd").val( evt.node.fields("deptcd").value());
            	$("#priorOrgNm").val( evt.node.fields("deptnm").value());

            	$("#dialog_append_child").dialog({
            		modal: true
            	  , buttons: {
            		  "하위추가": function(){

            			  appendChild( evt );
            			  $("#dialog_append_child").dialog( "close" );
            		  },
            		  Cancel: function(){
            			  $("#dialog_append_child").dialog( "close" );
            	      }
            		}
            	});
            }
        },
        "moveNode": {
            name: "이동",
            icon: "",
            callback: function(evt){

            	// 팝업이 열리고 부서를 선택하여 이동

                //evt.org.nodes.viewSubTree(evt.node);
            }
        },
        "closeNode": {
            name: "폐쇄",
            icon: "",
            callback: function(evt){

            	// 팝업이 열리고 폐쇄일자를 입력한 후 색상 변경
            	var orgNm = evt.node.fields("deptnm").value();
            	var orgCd = evt.node.fields("deptcd").value();

            	if(confirm( orgNm + " 를 폐쇄합니다.\n진행하시겠습니까?")){

            		for(var i = mySheet.HeaderRows(); i <= mySheet.LastRow(); i++){

            			var deptcd = mySheet.GetCellValue( i  , "orgCd" );

            			if ( deptcd == orgCd ){

            				mySheet.SetCellValue( i , "changeGubun" 	, "4" );
            			}
            		}

            		var template1 = evt.node.template();

            		if ( template1.indexOf("_Close") == -1 ){

	            		template1 = template1 + "_Close";

	            		evt.node.template(template1);
	            	}
            	}

                //evt.org.nodes.viewSubTree(evt.node);
            }
        },
        "seperator1": "---------",
        "detailInfo": {
            name: "상세정보",
            icon: "",
            callback: function(evt){

            	// 팝업
            	var orgCd = evt.node.fields("deptcd").value();

            	sheetObj.setDetailInfo( orgCd );

            	$("#dialog_detail_info").dialog({
            		modal: true
            	  , buttons: btnDef()
            	  , width : "600px"
            	  , resizable : false
            	});

                //evt.org.nodes.viewSubTree(evt.node);
            }
        }
    },
    background : {
    	"zoomIn": {
            name: "확대",
            icon: "",
            callback: function(evt){
            	myOrg.zoomIn();
            }
        },
        "zoomOut": {
            name: "축소",
            icon: "",
            callback: function(evt){
            	myOrg.zoomOut();
            }
        },
        "seperator1": "---------",
        "savePhoto": {
            name: "사진저장",
            icon: "",
            callback: function(evt){
            	myOrg.saveAsImage( { filename : "orgChart", backgroundColor : "white" } );
            }
        },
        "saveExcel": {
            name: "엑셀저장",
            icon: "",
            callback: function(evt){
            	myOrg.saveAsExcel({});
            }
        }
    }
};

var contextMenu = {
    version: "0.0.1",
    orgEvt: null,
    _ORI_CALLBACK_NAME: "_oriCallback",
    _CALLBACK_NAME: "callback",
    _CHILDS_NAME: "items",
    proc: function(evt) {
        var
            gap = 3,
            offset,
            pos,
            selector = "#" + evt.org.id;

        if (evt.which === 1) {
            contextMenu["hide"]();
            return;
        }

        offset = {
                x: $(selector).offset().left,
                y: $(selector).offset().top
            },
            pos = {
                pageX: gap + offset.x + evt.offsetX,
                pageY: gap + offset.y + evt.offsetY
            };
        contextMenu.orgEvt = evt;
        contextMenu["show"](pos, evt);
    },
    getItems: function(evt){
        var
            items = {}
            ;
        if(evt.isNode || evt.isField){
            items = menu["node"];
        }else if (evt.isOrg){
            items = menu["background"];
        }
        return contextMenu._eventHook(items, evt);
    },
    /*
     * jquery.contextMenu의 callback을 hooking하여
     * iborgjs의 이벤트 value를 활용하여 callback의 arguments를 조작하여 전달한다.
     * key:
     */
    _eventHook: function(items, evt){
        var
            key,
            callback,
            origin,
            item;
        for ( key in items){
            item  = items[key];

            if(callback = item[contextMenu._CALLBACK_NAME]){
                if(!(origin = item[contextMenu._ORI_CALLBACK_NAME])){
                    origin = item[contextMenu._ORI_CALLBACK_NAME] = item[contextMenu._CALLBACK_NAME];
                }

                item[contextMenu._CALLBACK_NAME] = (function(opt){
                    return function(){
                        opt.origin.call(this, {
                            key : opt.key,
                            node : opt.evt.node,
                            field : opt.evt.field,
                            org : opt.evt.org
                        });
                    };
                })({origin:origin, key: key, evt: evt});
            }else{
                (item.hasOwnProperty(contextMenu._CHILDS_NAME)) && (contextMenu._eventHook(item.items, evt));
            }
        }

        return items;
    },
    show: function(pos, evt) {
        setTimeout(function(){

            var
            items = {};

            // 구성된 contextMenu clear
            $.contextMenu("destroy");
            $.contextMenu({
                selector: "#myContextMenu",
                zIndex: 3,
                trigger: "none",
                animation: {
                    duration: 0
                },
                items: contextMenu.getItems(evt)
            });

            $('#myContextMenu').contextMenu(pos);
        }, 50);
    },
    hide: function() {
        if ($(".context-menu-root").is(":visible")){
            $('#myContextMenu').contextMenu("hide");
            contextMenu.orgEvt = null;
        }
    }
};
