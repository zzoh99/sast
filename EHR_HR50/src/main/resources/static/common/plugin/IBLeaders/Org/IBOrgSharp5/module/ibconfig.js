var ibconfig =
{
    "model": {
        "pkey": "pkey",
        "rkey": "rkey",
        "mkey": "mkey",
        "useKey": "deptcd",
		"usePKey": "updeptcd",
        "order": [
            "seq"
        ],
        "fields": [
            {
                "code": "deptcd",
                "type": "string",
                "name": "부서코드",
                "alias": {
					"hidden": true
				}
            },
            {
                "code": "updeptcd",
                "type": "string",
                "name": "상위부서코드",
                "alias": {
    				"hidden": true
    			}
            },
            {
                "code": "deptnm",
                "type": "string",
                "name": "부서명",
                "alias": {
    				"hidden": false
    			}
            },
            {
                "code": "empcd",
                "type": "string",
                "name": "사번",
                "alias": {
    				"hidden": false
    			}
            },
            {
                "code": "empnm",
                "type": "string",
                "name": "성명",
                "alias": {
    				"hidden": false
    			}
            },
            {
                "code": "position",
                "type": "string",
                "name": "직위",
                "alias": {
    				"hidden": false
    			}
            },
            {
                "code": "title",
                "type": "string",
                "name": "직책",
                "alias": {
    				"hidden": false
    			}
            },
            {
                "code": "inline",
                "type": "string",
                "name": "내선",
                "alias": {
    				"hidden": true
    			}
            },
            {
                "code": "hp",
                "type": "string",
                "name": "핸드폰",
                "alias": {
    				"hidden": false
    			}
            },
            {
                "code": "email",
                "type": "string",
                "name": "이메일",
                "alias": {
    				"hidden": false
    			}
            },
            {
                "code": "photo",
                "type": "picture" ,
                "name": "사진",
                "alias": {
    				"hidden": false
    			}
            },
            {
                "code": "seq",
                "type": "string",
                "name": "순서",
                "alias": {
    				"hidden": true
    			}
            }
        ]
    },
    "template": {
        "nodes": {
        	"Org": {
	            "style": {
	                "backgroundColor": "#5b5b5b",
	                "borderWidth": "0",
	                "selectionBorderWidth": 2,
	                "borderColor": "#8998A4",
	                "borderRadius": "3",
	                "width": 100,
	                "height": 40
	            },
	            "units": [
	                {
	                    "type": "text",
	                    "binding": "deptnmcnt",
	                    "verticalAlign": "center",
	                    "style": {
                            "backgroundColor": "#5b5b5b",
	                        "borderRadius": "3",
	                        "width": 100,
	                        "height": 40,
	                        "fontFamily": "Dotum",
                            "fontWeight": "bold",
	                        "fontColor": "#fff",
	                        "fontSize": 12,
	                        "cursor": "pointer",
	                        "position": "0 0"
	                    }
	                }
	            ]
	        },
            "OrgV": {
                "style": {
                    "backgroundColor": "#5b5b5b",
                    "borderWidth": "0",
                    "selectionBorderWidth": 2,
                    "borderColor": "#8998A4",
                    "borderRadius": "1",
                    "width": 40,
                    "height": 100
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "forceWrap": true,
                        "style": {
                            "backgroundColor": "#5b5b5b, #5b5b5b",
                            "borderRadius": "1",
                            "width": 40,
                            "height": 80,
                            "fontFamily": "Dotum",
                            "fontWeight": "bold",
                            "fontColor": "#fff",
                            "fontSize": 12,
                            "cursor": "pointer",
                            "cursor": "pointer",
                            "position": "0 0"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "cnt",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderRadius": "0",
                            "width": 40,
                            "height": 20,
                            "fontFamily": "Dotum",
                            "fontWeight": "bold",
                            "fontColor": "#fff",
                            "fontSize": 12,
                            "cursor": "pointer",
                            "position": "0 120"
                        }
                    }
                ]
            },
            "OrgLdr": {
                "style": {
                    "backgroundColor": "#ffffff",
                    "borderWidth": "1",
                    "selectionBorderWidth": 2,
                    "borderColor": "#000000",
                    "borderRadius": "2",
                    "width": 120,
                    "height": 50
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#5b5b5b",
                            "borderWidth": "0",
                            "width": 119,
                            "height": 24,
                            "fontFamily": "Dotum",
                            "fontWeight": "bold",
                            "fontColor": "#ffffff",
                            "fontSize": 11,
                            "cursor": "pointer",
                            "position": "1 1"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "empnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#ffffff",
                            "borderWidth": "0",
                            "width": 119,
                            "height": 24,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 10,
                            "position": "1 26"
                        }
                    }
                ]
            },
            "DualPhotoBox": {
                "style": {
                    "backgroundColor": "#F0F0F0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "15",
                    "selectionBorderWidth" : 2,
                    "width": 180,
                    "height": 145,
                    "boxShadow": "2 2 2 2 gray"
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnmcnt",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#5b5b5b, #5b5b5b",
                            "borderRadius": "13 13 0 0",
                            "width": 179,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 10,
                            "cursor": "pointer",
                            "position": "1 1"
                        }
                    },
                    {
                        "type": "picture",
                        "binding": "photo",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "borderColor": "Gray",
                            "borderRadius": "70",
                            "width": 68,
                            "height": 85,
                            "position": "11 35"
                        }
                    },
                    {
                        "type": "picture",
                        "binding": "photo2",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "borderColor": "Gray",
                            "borderRadius": "70",
                            "width": 68,
                            "height": 85,
                            "position": "101 35"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "empnmpos",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 74,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 10,
                            "position": "1 120"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "empnmpos2",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 74,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 10,
                            "position": "101 120"
                        }
                    }/*,
                    {
                        "type": "text",
                        "binding": "position",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 88,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 10,
                            "position": "1 120"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "position2",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 88,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 10,
                            "position": "91 120"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "empnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 88,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 10,
                            "cursor": "pointer",
                            "position": "1 145"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "empnm2",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 88,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 10,
                            "cursor": "pointer",
                            "position": "91 145"
                        }
                    }*/
                ]
            },
            "PhotoBox": {
                "style": {
                    "backgroundColor": "#F0F0F0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "15",
                    "selectionBorderWidth" : 2,
                    "width": 75,
                    "height": 145,
                    "boxShadow": "2 2 2 2 gray"
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#5b5b5b, #5b5b5b",
                            "borderRadius": "13 13 0 0",
                            "width": 74,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontWeight": "bold",
                            "fontColor": "#ffffff",
                            "fontSize": 10,
                            "cursor": "pointer",
                            "position": "1 1"
                        }
                    },
                    {
                        "type": "picture",
                        "binding": "photo",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "borderColor": "Gray",
                            "borderRadius": "70",
                            "width": 68,
                            "height": 85,
                            "position": "26 35",
                            "objectFit": "fill"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "empnmpos",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 74,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 10,
                            "position": "1 120"
                        }
                    }
                ]
            },
            "PhotoBoxVTwoV_": {
                "style": {
                    "backgroundColor": "#5b5b5b",
                    "borderWidth": "0",
                    "selectionBorderWidth": 2,
                    "borderColor": "#8998A4",
                    "borderRadius": "5",
                    "width": 28,
                    "height": 100
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "forceWrap": true,
                        "style": {
                            "backgroundColor": "#5b5b5b, #5b5b5b",
                            "borderRadius": "5 5 0 0",
                            "width": 28,
                            "height": 80,
                            "fontFamily": "Dotum",
                            "fontWeight": "bold",
                            "fontColor": "#fff",
                            "fontSize": 12,
                            "cursor": "pointer",
                            "cursor": "pointer",
                            "position": "0 0"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "cnt",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderRadius": "0 0 5 5",
                            "width": 28,
                            "height": 20,
                            "fontFamily": "Dotum",
                            "fontWeight": "bold",
                            "fontColor": "#fff",
                            "fontSize": 12,
                            "cursor": "pointer",
                            "position": "0 120"
                        }
                    }
                ]
            },
            "DualOrgChief": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "selectionBorderWidth" : 2,
                    "width": 180,
                    "height": 185
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnmcnt",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#e6e6e6, #b1b1b1",
                            "borderRadius": "4 4 0 0",
                            "width": 179,
                            "height": 35,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 11,
                            "cursor": "pointer",
                            "position": "1 1"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "position",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 88,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "position": "1 25"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "position2",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 88,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "position": "91 25"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "empnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 88,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "cursor": "pointer",
                            "position": "1 50"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "empnm2",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 88,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "cursor": "pointer",
                            "position": "91 50"
                        }
                    }
                ]
            },
            "OrgChief": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "selectionBorderWidth" : 2,
                    "width": 120,
                    "height": 85
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnmcnt",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#e6e6e6, #b1b1b1",
                            "borderRadius": "4 4 0 0",
                            "width": 119,
                            "height": 35,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 11,
                            "cursor": "pointer",
                            "position": "1 1"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "position",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 119,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "position": "1 35"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "empnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 119,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "cursor": "pointer",
                            "position": "1 60"
                        }
                    }
                ]
            },
            "DualPhotoBoxPhoto": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "selectionBorderWidth" : 2,
                    "width": 180,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnmcnt",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#e6e6e6, #b1b1b1",
                            "borderRadius": "4 4 0 0",
                            "width": 179,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 11,
                            "cursor": "pointer",
                            "position": "1 1"
                        }
                    },
                    {
                        "type": "picture",
                        "binding": "photo",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "borderColor": "Gray",
                            "borderRadius": "0",
                            "width": 67,
                            "height": 100,
                            "position": "11 26"
                        }
                    },
                    {
                        "type": "picture",
                        "binding": "photo2",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "borderColor": "Gray",
                            "borderRadius": "0",
                            "width": 67,
                            "height": 100,
                            "position": "101 26"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "position",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 45,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "position": "1 123"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "position2",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 45,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "position": "91 123"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "empnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 45,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "cursor": "pointer",
                            "position": "40 123"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "empnm2",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 45,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "cursor": "pointer",
                            "position": "132 123"
                        }
                    }
                ]
            },
            "DualPhotoBoxList": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "selectionBorderWidth" : 2,
                    "width": 180,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnmcnt",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#e6e6e6, #b1b1b1",
                            "borderRadius": "4 4 0 0",
                            "width": 179,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 11,
                            "cursor": "pointer",
                            "position": "1 1"
                        }
                    },
                    {
                        "type": "picture",
                        "binding": "photo",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "borderColor": "Gray",
                            "borderRadius": "0",
                            "width": 67,
                            "height": 100,
                            "position": "11 26"
                        }
                    },
                    {
                        "type": "picture",
                        "binding": "photo2",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "borderColor": "Gray",
                            "borderRadius": "0",
                            "width": 67,
                            "height": 100,
                            "position": "101 26"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "position",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 45,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "position": "1 123"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "position2",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 45,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "position": "91 123"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "empnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 45,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "cursor": "pointer",
                            "position": "40 123"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "empnm2",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 45,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "cursor": "pointer",
                            "position": "132 123"
                        }
                    }
                ]
            },
            "PhotoBoxList": {
                "style": {
                    "backgroundColor": "#F0F0F0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "0",
                    "selectionBorderWidth" : 2,
                    "width": 90,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnmcnt",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#5b5b5b, #5b5b5b",
                            "borderRadius": "0 0 0 0",
                            "width": 88,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontWeight": "bold",
                            "fontColor": "#ffffff",
                            "fontSize": 12,
                            "cursor": "pointer",
                            "position": "1 1"
                        }
                    },
                    {
                        "type": "picture",
                        "binding": "photo",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "borderColor": "Gray",
                            "borderRadius": "0",
                            "width": 67,
                            "height": 100,
                            "position": "11 26"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "position",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 45,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#000000",
                            "fontSize": 12,
                            "position": "1 123"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "empnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 45,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#000000",
                            "fontSize": 12,
                            "cursor": "pointer",
                            "position": "46 123"
                        }
                    }
                ]
            },"GridList": {
              "type": "table",
              "style": {
                  "backgroundColor": "#f0f0f0",
                  "borderWidth": 1,
                  "borderColor": "#b1b1b1",
                  "borderRadius": "0 0 0 0",
                  "selectionBorderWidth" : 2,
                  "width": 125
              },
              "units": [
                  {
                      "type": "text",
                      "binding": "deptnmcnt",
                      "horizontalAlign": "center",
                      "style": {
                          "backgroundColor": "#5b5b5b, #5b5b5b",
                          "borderRadius": "0 0 0 0",
                          "width": 125,
                          "height": 35,
                          "fontFamily": "Dotum",
                          "fontWeight": "bold",
                          "fontColor": "#fff",
                          "fontSize": 12,
                          "cursor": "pointer",
                          "column": 0,
                          "row": 0
                      }
                  },
                  
                  
                  {
                      "type": "table",
                      "style": {
                          "backgroundColor": "transparent",
                          "borderWidth": null,
                          "borderColor": "Gray",
                          "width": 125,
                          "column": 0,
                          "row": 2
                      },
                      "units": [
                          {
                              "type": "text",
                              "value" : "직위",
                              "horizontalAlign": "center",
                              "style": {
                                  "backgroundColor": "#E6E6E6",
                                  "borderWidth": 0,
                                  "borderColor": "PowderBlue",
                                  "width": 60,
                                  "height": 25,
                                  "fontColor": "Black",
                                  "fontSize": 12,
                                  "column": 0,
                                  "row": 0
                              }
                          },
                          {
                              "type": "text",
                              "value" : "성명",
                              "horizontalAlign": "center",
                              "style": {
                                  "backgroundColor": "#E6E6E6",
                                  "borderWidth": 0,
                                  "borderColor": "PowderBlue",
                                  "width": 65,
                                  "height": 25,
                                  "fontColor": "Black",
                                  "fontSize": 11,
                                  "column": 1,
                                  "row": 0
                              }
                          }
                      ]
                  },
                  
                  
                  {
                      "type": "table",
                      "style": {
                          "backgroundColor": "transparent",
                          "borderWidth": null,
                          "borderColor": "Gray",
                          "width": 125,
                          "column": 0,
                          "row": 3
                      },
                      "units": [
                          {
                              "type": "text",
                              "binding": "position",
                              "horizontalAlign": "center",
                              "style": {
                                  "backgroundColor": "#ddeeff",
                                  "borderWidth": 0,
                                  "borderColor": "PowderBlue",
                                  "width": 60,
                                  "height": 25,
                                  "fontColor": "Black",
                                  "fontSize": 12,
                                  "column": 0,
                                  "row": 0
                              }
                          },
                          {
                              "type": "text",
                              "binding": "empnm",
                              "horizontalAlign": "center",
                              "style": {
                                  "backgroundColor": "#ddeeff",
                                  "borderWidth": 0,
                                  "borderColor": "PowderBlue",
                                  "width": 65,
                                  "height": 25,
                                  "fontColor": "Black",
                                  "fontSize": 11,
                                  "column": 1,
                                  "row": 0
                              }
                          }
                      ]
                  },
                  {
                      "type": "list",
                      "style": {
                          "backgroundColor": "transparent",
                          "borderWidth": 0,
                          "borderColor": "Red",
                          "width": 125,
                          "column": 0,
                          "row": 4
                      },
                      "units": [
                          {
                              "type": "table",
                              "style": {
                                  "backgroundColor": "transparent",
                                  "borderWidth": "0.5",
                                  "borderColor": "#b1b1b1",
                                  "width": 125
                              },
                              "units": [
                                  {
                                      "type": "text",
                                      "binding": "position",
                                      "horizontalAlign": "center",
                                      "style": {
                                          "backgroundColor": "WhiteSmoke",
                                          "borderWidth": 0,
                                          "borderColor": "PowderBlue",
                                          "width": 60,
                                          "height": 22,
                                          "fontColor": "Black",
                                          "fontSize": 11,
                                          "column": 0,
                                          "row": 0
                                      }
                                  },
                                  {
                                      "type": "text",
                                      "binding": "empnm",
                                      "horizontalAlign": "center",
                                      "style": {
                                          "backgroundColor": "WhiteSmoke",
                                          "borderWidth": 0,
                                          "borderColor": "PowderBlue",
                                          "width": 65,
                                          "height": 22,
                                          "fontColor": "Black",
                                          "fontSize": 11,
                                          "column": 1,
                                          "row": 0
                                      }
                                  }
                              ]
                          }
                      ]
                  },
                  {
                      "type": "table",
                      "style": {
                          "backgroundColor": "transparent",
                          "borderWidth": null,
                          "borderColor": "Gray",
                          "width": 125,
                          "column": 0,
                          "row": 5
                      },
                      "units": [
                          {
                              "type": "text",
                              "binding": "listcount",
                              "horizontalAlign": "center",
                              "style": {
                                  "backgroundColor": "#ffeef7",
                                  "borderWidth": 0,
                                  "borderColor": "#3C5A91",
                                  "width": 125,
                                  "height": 20,
                                  "fontColor": "#000",
                                  "fontSize": 11,
                                  "column": 1,
                                  "row": 0
                              }
                          }
                      ]
                  }
              ]
          },"DualGridList": {
                "type": "table",
                "style": {
                    "backgroundColor": "#f0f0f0",
                    "borderWidth": 1,
                    "borderColor": "#b1b1b1",
                    "borderRadius": "0 0 0 0",
                    "selectionBorderWidth" : 2,
                    "width": 125
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnmcnt",
                        "horizontalAlign": "center",
                        "style": {
                            "backgroundColor": "#5b5b5b, #5b5b5b",
                            "borderRadius": "0 0 0 0",
                            "width": 125,
                            "height": 35,
                            "fontFamily": "Dotum",
                            "fontWeight": "bold",
                            "fontColor": "#fff",
                            "fontSize": 12,
                            "cursor": "pointer",
                            "column": 0,
                            "row": 0
                        }
                    },
                    {
                        "type": "table",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": null,
                            "borderColor": "Gray",
                            "width": 125,
                            "column": 0,
                            "row": 2
                        },
                        "units": [
                            {
                                "type": "text",
                                "value" : "직위",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#E6E6E6",
                                    "borderWidth": 0,
                                    "borderColor": "PowderBlue",
                                    "width": 60,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 12,
                                    "column": 0,
                                    "row": 0
                                }
                            },
                            {
                                "type": "text",
                                "value" : "성명",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#E6E6E6",
                                    "borderWidth": 0,
                                    "borderColor": "PowderBlue",
                                    "width": 65,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 11,
                                    "column": 1,
                                    "row": 0
                                }
                            }
                        ]
                    },
                    {
                        "type": "table",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": null,
                            "borderColor": "Gray",
                            "width": 125,
                            "column": 0,
                            "row": 3
                     	},
                        "units": [
                            {
                                "type": "text",
                                "binding": "position",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ddeeff",
                                    "borderWidth": 0,
                                    "borderColor": "PowderBlue",
                                    "width": 60,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 12,
                                    "column": 0,
                                    "row": 0
                                }
                            },
                            {
                                "type": "text",
                                "binding": "empnm",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ddeeff",
                                    "borderWidth": 0,
                                    "borderColor": "PowderBlue",
                                    "width": 65,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 11,
                                    "column": 1,
                                    "row": 0
                                }
                            },
                        ]
                    },
                    {
                        "type": "table",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": null,
                            "borderColor": "Gray",
                            "width": 125,
                            "column": 0,
                            "row": 4
                        },
                        "units": [
                            {
                                "type": "text",
                                "binding": "position2",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ddeeff",
                                    "borderWidth": 0,
                                    "borderColor": "PowderBlue",
                                    "width": 60,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 12,
                                    "column": 0,
                                    "row": 0
                                }
                            },
                            {
                                "type": "text",
                                "binding": "empnm2",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ddeeff",
                                    "borderWidth": 0,
                                    "borderColor": "PowderBlue",
                                    "width": 65,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 11,
                                    "column": 1,
                                    "row": 0
                                }
                            }
                        ]
                    },
                    {
                        "type": "list",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": 0,
                            "borderColor": "Red",
                            "width": 125,
                            "column": 0,
                            "row": 5
                        },
                        "units": [
                            {
                                "type": "table",
                                "style": {
                                    "backgroundColor": "transparent",
                                    "borderWidth": "0.5",
                                    "borderColor": "#b1b1b1",
                                    "width": 125
                                },
                                "units": [
                                    {
                                        "type": "text",
                                        "binding": "position",
                                        "horizontalAlign": "center",
                                        "style": {
                                            "backgroundColor": "WhiteSmoke",
                                            "borderWidth": 0,
                                            "borderColor": "PowderBlue",
                                            "width": 60,
                                            "height": 22,
                                            "fontColor": "Black",
                                            "fontSize": 11,
                                            "column": 0,
                                            "row": 0
                                        }
                                    },
                                    {
                                        "type": "text",
                                        "binding": "empnm",
                                        "horizontalAlign": "center",
                                        "style": {
                                            "backgroundColor": "WhiteSmoke",
                                            "borderWidth": 0,
                                            "borderColor": "PowderBlue",
                                            "width": 65,
                                            "height": 22,
                                            "fontColor": "Black",
                                            "fontSize": 11,
                                            "column": 1,
                                            "row": 0
                                        }
                                    }
                                ]
                            }
                        ]
                    },
                    {
                        "type": "table",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": null,
                            "borderColor": "Gray",
                            "width": 125,
                            "column": 0,
                            "row": 6
                        },
                        "units": [
                            {
                                "type": "text",
                                "binding": "listcount",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ffeef7",
                                    "borderWidth": 0,
                                    "borderColor": "#3C5A91",
                                    "width": 125,
                                    "height": 20,
                                    "fontColor": "#000",
                                    "fontSize": 11,
                                    "column": 1,
                                    "row": 0
                                }
                            }
                        ]
                    }
                ]
            },
            "DualOrgBox": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": 1,
                    "borderColor": "#b1b1b1",
                    "borderRadius": 5,
                    "selectionBorderWidth" : 2,
                    "width": 140,
                    "height": 75
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnmcnt",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#e6e6e6, #b1b1b1",
                            "borderRadius": null,
                            "width": 138,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 11,
                            "cursor": "pointer",
                            "position": "1 1"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "position",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": 0,
                            "width": 65,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "position": "8 25"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "empnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": 0,
                            "width": 65,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "cursor": "pointer",
                            "position": "70 25"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "position2",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": 0,
                            "width": 65,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "position": "8 50"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "empnm2",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": 0,
                            "width": 65,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "cursor": "pointer",
                            "position": "70 50"
                        }
                    }
                ]
            },
            "OrgBox": {
                "style": {
                    "backgroundColor": "#F0F0F0, #F0F0F0",
                    "borderWidth": 1,
                    "borderColor": "#b1b1b1",
                    "borderRadius": 0,
                    "selectionBorderWidth" : 2,
                    "width": 140,
                    "height": 60
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnmcnt",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#5b5b5b, #5b5b5b",
                            "borderRadius": null,
                            "width": 139,
                            "height": 35,
                            "fontFamily": "Dotum",
                            "fontWeight": "bold",
                            "fontColor": "#ffffff",
                            "fontSize": 12,
                            "cursor": "pointer",
                            "position": "1 1"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "position",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": 0,
                            "width": 65,
                            "height": 35,
                            "fontFamily": "Dotum",
                            "fontColor": "#000000",
                            "fontSize": 11,
                            "position": "8 25"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "empnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": 0,
                            "width": 65,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#000000",
                            "fontSize": 11,
                            "cursor": "pointer",
                            "position": "70 25"
                        }
                    }
                ]
            },
            "PhotoBoxPhoto": {
                "style": {
                    "backgroundColor": "#F0F0F0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "0",
                    "selectionBorderWidth" : 2,
                    "width": 120,
                    "height": 175
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnmcnt",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#5b5b5b, #5b5b5b",
                            "borderRadius": "0 0 0 0",
                            "width": 119,
                            "height": 35,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 11,
                            "cursor": "pointer",
                            "position": "1 1"
                        }
                    },
                    {
                        "type": "picture",
                        "binding": "photo",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "borderColor": "Gray",
                            "borderRadius": "0",
                            "width": 87,
                            "height": 100,
                            "position": "18 42"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "position",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 55,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "position": "1 148"
                        }
                    },
                    {
                        "type": "text",
                        "binding": "empnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0",
                            "width": 55,
                            "height": 25,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "cursor": "pointer",
                            "position": "57 148"
                        }
                    }
                ]
            },
            "DualGridPhoto": {
                "type": "table",
                "style": {
                    "backgroundColor": "#f0f0f0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "0 0 0 0",
                    "selectionBorderWidth": 2,
                    "width": 200
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnmcnt",
                        "horizontalAlign": "center",
                        "style": {
                            "backgroundColor": "#5b5b5b, #5b5b5b",
                            "borderRadius": "0 0 0 0",
                            "width": 200,
                            "height": 35,
                            "fontColor": "#fff",
                            "fontSize": 12,
                            "cursor": "pointer",
                            "position":"0 0",
                            "column": 0,
                            "row": 0
                        }
                    },

                    {
	                    "type": "table",
	                    "style": {
	                        "backgroundColor": "white",
	                        "borderWidth": "1",
	                        "borderColor": "#b1b1b1",
	                        "width": 200,
	                        "row": 1
	                    },
	                    "units": [
	                        {
                                "type": "table",
                                "style": {
                                    "backgroundColor": "white",
                                    "borderWidth": "0",
                                    "borderColor": "#b1b1b1",
                                    "width": 100,
                                    "column": 0,
                                    "row": 0
                                },
                                "units": [
                                    {
        	                            "type": "picture",
        	                            "binding": "photo",
        	                            "style": {
        	                                "backgroundColor": "transparent",
        	                                "borderWidth": "0",
        	                                "borderColor": "PowderBlue",
        	                                "width": 67,
        	                                "height": 100,
        	                                "column": 0,
        	                                "row": 0
        	                            }
                                    }
                                ]
	                        },
	                        {
                                "type": "table",
                                "style": {
                                    "backgroundColor": "white",
                                    "borderWidth": "0",
                                    "borderColor": "#b1b1b1",
                                    "width": 100,
                                    "column": 1,
                                    "row": 0
                                },
                                "units": [
                                    {
        	                            "type": "picture",
        	                            "binding": "photo2",
        	                            "style": {
        	                                "backgroundColor": "transparent",
        	                                "borderWidth": "0",
        	                                "borderColor": "PowderBlue",
        	                                "width": 67,
        	                                "height": 100,
        	                                "column": 0,
        	                                "row": 0
        	                            }
                                    }
                                ]
	                        }
	                    ]
                    },
					{
                        "type": "table",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "1",
                            "borderColor": "#b1b1b1",
                            "width": 200,
                            "column": 0,
                            "row": 2
                        },
                        "units": [
      	                        {
                                    "type": "table",
                                    "style": {
                                        "backgroundColor": "transparent",
                                        "borderWidth": "0.5",
                                        "borderColor": "#b1b1b1",
                                        "width": 99,
                                        "column": 1,
                                        "row": 0
                                    },
                                    "units": [
                                           {
                                               "type": "text",
                                               "binding": "position",
                                               "horizontalAlign": "center",
                                               "style": {
                                                   "backgroundColor": "#ddeeff",
                                                   "borderWidth": "0",
                                                   "borderColor": "PowderBlue",
                                                   "width": 99,
                                                   "height": 25,
                                                   "fontColor": "Black",
                                                   "fontSize": 11,
                                                   "column": 0,
                                                   "row": 0
                                               }
                                           },
                                           {
                                               "type": "text",
                                               "binding": "empnm",
                                               "horizontalAlign": "center",
                                               "style": {
                                                   "backgroundColor": "#ddeeff",
                                                   "borderWidth": "0",
                                                   "borderColor": "PowderBlue",
                                                   "width": 99,
                                                   "height": 25,
                                                   "fontColor": "Black",
                                                   "fontSize": 11,
                                                   "column": 0,
                                                   "row": 1
                                               }
                                           }
                                    ]
    	                        },
      	                        {
                                    "type": "table",
                                    "style": {
                                        "backgroundColor": "transparent",
                                        "borderWidth": "0.5",
                                        "borderColor": "#b1b1b1",
                                        "width": 99,
                                        "column": 2,
                                        "row": 0
                                    },
                                    "units": [
                                           {
                                               "type": "text",
                                               "binding": "position2",
                                               "horizontalAlign": "center",
                                               "style": {
                                                   "backgroundColor": "#ddeeff",
                                                   "borderWidth": "0",
                                                   "borderColor": "PowderBlue",
                                                   "width": 99,
                                                   "height": 25,
                                                   "fontColor": "Black",
                                                   "fontSize": 11,
                                                   "column": 0,
                                                   "row": 0
                                               }
                                           },
                                           {
                                               "type": "text",
                                               "binding": "empnm2",
                                               "horizontalAlign": "center",
                                               "style": {
                                                   "backgroundColor": "#ddeeff",
                                                   "borderWidth": "0",
                                                   "borderColor": "PowderBlue",
                                                   "width": 99,
                                                   "height": 25,
                                                   "fontColor": "Black",
                                                   "fontSize": 11,
                                                   "column": 0,
                                                   "row": 1
                                               }
                                           }
                                    ]
    	                        }
                        ]
                    },

                    {
                        "type": "list",
                        "style": {
                            "backgroundColor": "white",
                            "borderWidth": "0",
                            "borderColor": "Red",
                            "width": 200,
                            "column": 0,
                            "row": 5
                        },
                        "units": [
                            {
                                "type": "table",
                                "style": {
                                    "backgroundColor": "transparent",
                                    "borderColor": "#b1b1b1",
                                    "width": 200
                                },
                                "units": [
                                     {
                                         "type": "table",
                                         "style": {
                                             "backgroundColor": "transparent",
                                             "borderWidth": "0.5",
                                             "borderColor": "#b1b1b1",
                                             "width": 31,
                                             "height" : 44.5,
                                             "column" : 0,
                                             "row" : 0
                                         },
                                         "units": [
                                             {
                                                 "type": "picture",
                                                 "binding": "photo",
                                                 "style": {
                                                     "backgroundColor": "transparent",
                                                     "borderWidth": "0",
                                                     "borderColor": "PowderBlue",
                                                     "width": 29,
                                                     "height": 36,
                                                     "column": 0,
                                                     "row": 0
                                                 }
                                             }
                                          ]
                                     },
                                    {
                                        "type": "table",
                                        "style": {
                                            "backgroundColor": "transparent",
                                            "borderWidth": "0.5",
                                            "borderColor": "#b1b1b1",
                                            "width": 169,
                                            "column": 1,
                                            "row": 0
                                        },
                                        "units": [
                                            {
                                                "type": "text",
                                                "binding": "position",
                                                "horizontalAlign": "center",
                                                "style": {
                                                    "backgroundColor": "WhiteSmoke",
                                                    "borderWidth": "0",
                                                    "borderColor": "PowderBlue",
                                                    "width": 169,
                                                    "height": 22,
                                                    "fontColor": "Black",
                                                    "fontSize": 9,
                                                    "column": 0,
                                                    "row": 0
                                                }
                                            },
                                            {
                                                "type": "text",
                                                "binding": "empnm",
                                                "horizontalAlign": "center",
                                                "style": {
                                                    "backgroundColor": "WhiteSmoke",
                                                    "borderWidth": "0",
                                                    "borderColor": "PowderBlue",
                                                    "width": 169,
                                                    "height": 22,
                                                    "fontColor": "Black",
                                                    "fontSize": 9,
                                                    "column": 0,
                                                    "row": 1
                                                }
                                            }
                                        ]
                                    }
                                ]
                            }
                        ]
                    },
                    {
                        "type": "table",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0 0 0 0.5",
                            "borderColor": "Gray",
                            "width": 200,
                            "column": 0,
                            "row": 6
                        },
                        "units": [
                            {
                                "type": "text",
                                "binding": "listcount",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#c5e0dc",
                                    "borderWidth": "0",
                                    "borderColor": "#3C5A91",
                                    "width": 200,
                                    "height": 20,
                                    "fontColor": "#000",
                                    "fontSize": 11,
                                    "column": 1,
                                    "row": 0
                                }
                            }
                        ]
                    }
                ]
            },
            "GridPhoto": {
                           "type": "table",
                           "style": {
                               "backgroundColor": "#f0f0f0",
                               "borderWidth": "1",
                               "borderColor": "#b1b1b1",
                               "borderRadius": "0 0 0 0",
                               "selectionBorderWidth": 2,
                               "width": 140
                           },
                           "units": [
                               {
                                   "type": "text",
                                   "binding": "deptnmcnt",
                                   "horizontalAlign": "center",
                                   "style": {
                                       "backgroundColor": "#5b5b5b, #5b5b5b",
                                       "borderRadius": "0 0 0 0",
                                       "width": 140,
                                       "height": 35,
                                       "fontColor": "#fff",
                                       "fontWeight": "bold",
                                       "fontSize": 12,
                                       "cursor": "pointer",
                                       "column": 0,
                                       "row": 0
                                   }
                               },
                               {
                                   "type": "table",
                                   "style": {
                                       "backgroundColor": "white",
                                       "borderWidth": "1",
                                       "borderColor": "#b1b1b1",
                                       "width": 140,
                                       "column": 0,
                                       "row": 1
                                   },
                                   "units": [
                                       {
           	                            "type": "picture",
           	                            "binding": "photo",
           	                            "style": {
           	                                "backgroundColor": "transparent",
           	                                "borderWidth": "0",
           	                                "borderColor": "PowderBlue",
           	                                "width": 67,
           	                                "height": 100,
           	                                "column": 0,
           	                                "row": 0
           	                            }
                                       }
                                   ]
                               },
                               {
                                   "type": "table",
                                   "style": {
                                       "backgroundColor": "#ddeeff",
                                       "borderWidth": "1",
                                       "borderColor": "#b1b1b1",
                                       "width": 140,
                                       "column": 0,
                                       "row": 2
                                   },
                                   "units": [
                                       {
                                           "type": "text",
                                           "binding": "position",
                                           "horizontalAlign": "center",
                                           "style": {
                                               "backgroundColor": "#ddeeff",
                                               "borderWidth": "0",
                                               "borderColor": "PowderBlue",
                                               "width": 75,
                                               "height": 25,
                                               "fontColor": "Black",
                                               "fontSize": 11,
                                               "column": 0,
                                               "row": 0
                                           }
                                       },
                                       {
                                           "type": "text",
                                           "binding": "empnm",
                                           "horizontalAlign": "center",
                                           "style": {
                                               "backgroundColor": "#ddeeff",
                                               "borderWidth": "0",
                                               "borderColor": "PowderBlue",
                                               "width": 65,
                                               "height": 25,
                                               "fontColor": "Black",
                                               "fontSize": 11,
                                               "column": 1,
                                               "row": 0
                                           }
                                       }
                                   ]
                               },
                               {
                                   "type": "list",
                                   "style": {
                                       "backgroundColor": "white",
                                       "borderWidth": "0",
                                       "borderColor": "#b1b1b1",
                                       "width": 140,
                                       "column": 0,
                                       "row": 4
                                   },
                                   "units": [
                                       {
                                           "type": "table",
                                           "style": {
                                               "backgroundColor": "white",
                                               "borderColor": "#b1b1b1",
                                               "width": 140
                                           },
                                           "units": [
                                               {
           	                                   "type": "table",
           	                                   "style": {
           	                                       "backgroundColor": "white",
           	                                       "borderWidth": "0.5",
           	                                       "borderColor": "#b1b1b1",
           	                                       "width": 41,
           	                                       "height": 45,
           	                                       "column": 0,
           	                                       "row": 0
           	                                   },
           	                                   "units": [
           	                                       {
           		       	                            "type": "picture",
           		       	                            "binding": "photo",
           		       	                            "style": {
           		       	                                "backgroundColor": "transparent",
           		       	                                "borderWidth": "0",
           		       	                                "borderColor": "#b1b1b1",
           		       	                                "width": 29,
           		       	                                "height": 36,
           		       	                                "column": 0,
           		       	                                "row": 0
           	      	                            		}
                                                		}
           	                                   ]
                                               },
                                               {
                                                   "type": "table",
                                                   "style": {
                                                       "backgroundColor": "transparent",
                                                       "borderWidth": "0.5",
                                                       "borderColor": "#b1b1b1",
                                                       "width": 99,
                                                       "column": 1,
                                                       "row": 0
                                                   },
                                                   "units": [
                                                       {
                                                           "type": "text",
                                                           "binding": "position",
                                                           "horizontalAlign": "center",
                                                           "style": {
                                                               "backgroundColor": "WhiteSmoke",
                                                               "borderWidth": "0",
                                                               "borderColor": "#b1b1b1",
                                                               "width": 99,
                                                               "height": 22.5,
                                                               "fontColor": "Black",
                                                               "fontSize": 9,
                                                               "column": 0,
                                                               "row": 0
                                                           }
                                                       },
                                                       {
                                                           "type": "text",
                                                           "binding": "empnm",
                                                           "horizontalAlign": "center",
                                                           "style": {
                                                               "backgroundColor": "WhiteSmoke",
                                                               "borderWidth": "0",
                                                               "borderColor": "#b1b1b1",
                                                               "width": 99,
                                                               "height": 22.5,
                                                               "fontColor": "Black",
                                                               "fontSize": 9,
                                                               "column": 0,
                                                               "row": 1
                                                           }
                                                       }
                                                   ]
                                               }
                                           ]
                                       }
                                   ]
                               },
                               {
                                   "type": "table",
                                   "style": {
                                       "backgroundColor": "transparent",
                                       "borderWidth": "1",
                                       "borderColor": "#b1b1b1",
                                       "width": 140,
                                       "column": 0,
                                       "row": 5
                                   },
                                   "units": [
                                       {
                                           "type": "text",
                                           "binding": "listcount",
                                           "horizontalAlign": "center",
                                           "style": {
                                               "backgroundColor": "#c5e0dc",
                                               "borderWidth": "0",
                                               "borderColor": "#3C5A91",
                                               "width": 140,
                                               "height": 20,
                                               "fontColor": "#000",
                                               "fontSize": 11,
                                               "column": 1,
                                               "row": 0
                                           }
                                       }
                                   ]
                               }
                           ]
                       },  
            "Member": {
                "style": {
                    "backgroundColor": "#B5BECC",
                    "borderWidth": "0",
                    "borderColor": "#8998A4",
                    "borderRadius": "10",
                    "width": 80,
                    "height": 40
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "empnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#46649B",
                            "borderWidth": "0",
                            "borderRadius": "10",
                            "width": 78,
                            "height": 35,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 11,
                            "cursor": "pointer",
                            "position": "1 1"
                        }
                    }
                ]
            }
        }
    },
    "orgData": []
}