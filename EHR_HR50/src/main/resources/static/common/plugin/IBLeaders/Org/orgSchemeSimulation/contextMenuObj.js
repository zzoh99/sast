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
            icon: "add",
            callback: function(evt){
            	
            	dialogObj.openNewOrgRegDialog( evt );
            	
            }
        },
        "changeName": {	// 신규 추가된 조직인 경우..
            name: "조직명변경",
            icon: "",
            callback: function(evt){
            	
            	dialogObj.openNameChangeDialog( evt );
            	
            }
        },
        "changePrior": {
            name: "상위조직변경",
            icon: "",
            callback: function(evt){
            	
            	dialogObj.openPriorChangeDialog( evt );
            	
            }
        },
        "changeChief": {
            name: "조직장변경",
            icon: "",
            callback: function(evt){
            	
            	dialogObj.openChiefChangeDialog( evt );
            	
            }
        },
        "changeOrder": {
            name: "하위조직순서변경",
            icon: "",
            callback: function(evt){
            	
            	dialogObj.openOrderChangeDialog( evt );
            	
            }
        },
        "closeNode": {
            name: "폐쇄",
            icon: "quit",
            callback: function(evt){

            	// 팝업이 열리고 폐쇄일자를 입력한 후 색상 변경
            	var orgNm = evt.node.fields("deptnm").value();
            	var orgCd = evt.node.fields("deptcd").value();
            	
            	var childrens = evt.node.children();
            		
            	// 하위 노드가 존재하지 않는 경우 진행
            	if(childrens == null || childrens == undefined || childrens.length == 0) {
            		
            		// GET Sheet idx
            		var sheetIdx = sheetObj.GetNodeSheetIdx(evt.node.pkey());
            		
            		if(confirm( "\"" + orgNm + "\"를(을) [ 폐쇄 ] 처리 합니다.\n진행하시겠습니까?")){
            			
            			// sheet의 상태구분값 변경
            			mySheet.SetCellValue(sheetIdx, "changeGubun", "4");
            			
            			var template1 = orgObj.GetNodeTemplateBase(evt.node.pkey()) + "_Close";
            			
            			evt.node.template(template1);
            			
            		}
            		
            		// 시트 변경 여부 출력
            		printModifySheet()
            		
            		//evt.org.nodes.viewSubTree(evt.node);
            	} else {
            		alert("하위 조직이 존재합니다.\n선택하신 조직의 [폐쇠] 처리는 하위 조직의 상위소속 변경 혹은 폐쇠 조치 후 가능합니다.");
            	}
            	
            }
        },
        "closeCancelNode": {
            name: "폐쇄해제",
            icon: "",
            callback: function(evt){

            	// 팝업이 열리고 폐쇄일자를 입력한 후 색상 변경
            	var orgNm = evt.node.fields("deptnm").value();
            	var orgCd = evt.node.fields("deptcd").value();
            	
            	// GET Sheet idx
            	var sheetIdx = sheetObj.GetNodeSheetIdx(evt.node.pkey());
            	
            	if(confirm( "\"" + orgNm + "\"를(을) [ 폐쇄해제 ] 처리 합니다.\n진행하시겠습니까?")){
            		
            		// sheet의 상태구분값 변경
            		sheetObj.SetCellValue(sheetIdx, "changeGubun", "");
            		
            		var sStatus   = sheetObj.GetCellValue( sheetIdx , "sStatus" );
            		var template1 = orgObj.GetNodeTemplateBase(evt.node.pkey());
            		if(sheetObj.IsChange(sheetIdx, orgCd)) {
            			template1 = template1 + "_Move";
            		}
            		
            		evt.node.template(template1);

            	}
            	
            	// 시트 변경 여부 출력
            	printModifySheet()
            	
                //evt.org.nodes.viewSubTree(evt.node);
            }
        },
        "removeNode": {
            name: "삭제",
            icon: "delete",
            callback: function(evt){

            	if(confirm("선택하신 조직을 삭제 하시겠습니까?")) {
            		
            		// 팝업이 열리고 폐쇄일자를 입력한 후 색상 변경
            		var sheetIdx = sheetObj.GetNodeSheetIdx(evt.node.pkey());
            		
            		/**
            		 * 삭제가능조건
            		 * 	※ 삭제 조직이 신규 조직인 경우 하위에 기존에 존재하던 조직이 존재하는 경우에 삭제 처리할 경우 기존에 존재하던 조직의 정보가 유실됨에 따라 삭제 제한함.
            		 * 	1. 신설인 경우에만 삭제 가능함.
            		 * 	2. 하위부서 미존재
            		 */
            		if(mySheet.GetCellValue( sheetIdx , "changeGubun" ) == "1") {
            			
            			var orgNm = evt.node.fields("deptnm").value();
            			var orgCd = evt.node.fields("deptcd").value();
            			
            			// 하위부서 존재 체크
            			var isExistSub = false;
            			var childrens = evt.node.children();
            			
            			// 하위 노드가 존재하는 경우
            			if(childrens != null && childrens != undefined && childrens.length > 0) {
            				isExistSub = true;
            			}
            			
            			// 하위부서가 존재하지 않는 경우
            			if(isExistSub == false) {
            				if(mySheet.GetCellValue( sheetIdx , "sStatus" ) == "I") {
            					mySheet.SetCellValue( sheetIdx , "sDelete", 1 );
            				} else {
            					// sheet에서 삭제 상태로 처리.
            					mySheet.SetCellValue( sheetIdx , "sStatus", "D" );
            				}
            				// 노드 제거
            				evt.node.remove();
            				// 시트 변경 여부 출력
            				printModifySheet()
            			} else {
            				alert("하위 부서가 존재합니다.\n선택하신 조직의 [삭제] 처리는 하위 조직의 상위소속 변경 혹은 폐쇠, 삭제 조치 후 가능합니다.");
            			}
            			
            		} else {
            			alert("신설 부서인 경우에만 삭제 가능합니다.");
            		}
            		
            	}
            	
            }
        },
        "seperator": "---------",
        "detailInfo": {
            name: "상세정보",
            icon: "",
            callback: function(evt){
            	
            	dialogObj.openDetailInfoDialog( evt );
            	
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
        "seperator": "---------",
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
        var items = {};
        if(evt.isNode || evt.isField){
        	if(orgObj.config.isConfirmed == "N") {
        		var sheetIdx    = sheetObj.GetNodeSheetIdx(evt.node.pkey());
        		var existChild  = orgObj.HasChildren(evt.node.pkey());
        		var changeGugun = mySheet.GetCellValue(sheetIdx, "changeGubun");
        		var customMenus = {};
        		
        		// 신규 추가 조직인 경우
        		if(changeGugun == "1") {
        			customMenus[ "appendChild" ] = menu.node.appendChild;
        			customMenus[ "changeName"  ] = menu.node.changeName;
        			customMenus[ "changePrior" ] = menu.node.changePrior;
        			customMenus[ "changeChief" ] = menu.node.changeChief;
        			if(existChild) {
            			customMenus[ "changeOrder" ] = menu.node.changeOrder;
        			}
        			customMenus[ "seperator0"  ] = menu.node.seperator;
        			customMenus[ "removeNode"  ] = menu.node.removeNode;
        		
        		// 폐쇄 조직인 경우
        		} else if(changeGugun == "4") {
        			customMenus[ "closeCancelNode" ] = menu.node.closeCancelNode;
        			
        		// 기존 조직인 경우
        		} else {
        			
        			// 최상위 조직인 경우 "상위조직변경" 미출력 처리
        			if(evt.node.level() == "1") {
        				
        				customMenus[ "appendChild" ] = menu.node.appendChild;
        				customMenus[ "changeChief" ] = menu.node.changeChief;
        				if(existChild) {
        					customMenus[ "changeOrder" ] = menu.node.changeOrder;
        				}
        				customMenus[ "seperator0"  ] = menu.node.seperator;
        				customMenus[ "closeNode"   ] = menu.node.closeNode;
        				customMenus[ "seperator1"  ] = menu.node.seperator;
        				customMenus[ "detailInfo"  ] = menu.node.detailInfo; 
        				
        			} else {
        				
        				customMenus[ "appendChild" ] = menu.node.appendChild;
        				customMenus[ "changePrior" ] = menu.node.changePrior;
        				customMenus[ "changeChief" ] = menu.node.changeChief;
        				if(existChild) {
        					customMenus[ "changeOrder" ] = menu.node.changeOrder;
        				}
        				customMenus[ "seperator0"  ] = menu.node.seperator;
        				customMenus[ "closeNode"   ] = menu.node.closeNode;
        				customMenus[ "seperator1"  ] = menu.node.seperator;
        				customMenus[ "detailInfo"  ] = menu.node.detailInfo; 
        				
        			}
        		}
        		items = customMenus;
        	} else {
        		items = menu["background"];
        	}
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
            /* orgObj.js에서 세팅
            var
            items = {};

            // 구성된 contextMenu clear
            $.contextMenu("destroy");
            $.contextMenu({
                selector: "canvas",
                zIndex: 3,
                trigger: "none",
                animation: {
                    duration: 0
                },
                items: contextMenu.getItems(evt)
            });
            debugger
            $('#myContextMenu').contextMenu(evt);
            */

        }, 50);
    },
    hide: function() {
        if ($(".context-menu-root").is(":visible")){
            $('#myContextMenu').contextMenu("hide");
            contextMenu.orgEvt = null;
        }
    }
};
