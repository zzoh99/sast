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
					"hidden": false
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
                "name": "사원번호",
                "alias": {
    				"hidden": false
    			}
            },
            {
                "code": "empnm",
                "type": "string",
                "name": "이름",
                "alias": {
    				"hidden": false
    			}
            },
            {
                "code": "position",
                "type": "string",
                "name": "직급",
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
    				"hidden": true
    			}
            },
            {
                "code": "email",
                "type": "string",
                "name": "이메일",
                "alias": {
    				"hidden": true
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
                    "backgroundColor": "#B5BECC",
                    "borderWidth": "1",
                    "borderColor": "#8998A4",
                    "borderRadius": "5",
                    "width": 120,
                    "height": 63
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": "#64b9F0, #4d8fbb",
                            "borderRadius": "5 5 0 0",
                            "width": 119,
                            "height": 30,
                            "fontColor": "#fff",
                            "fontWeight": "bold",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "0 0"
                        }
                    }
                    ,
                    {
                        "type": "text",
                        "binding": "position_name",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "white",
                            "borderRadius": "0 0 5 5",
                            "width": 119,
                            "height": 30,
                            "fontColor": "#000",
                            "fontWeight": "bold",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "0 31"
                        }
                    }
                ]
            },
            "DualOrg": {
                "style": {
                    "backgroundColor": "#B5BECC",
                    "borderWidth": "1",
                    "borderColor": "#8998A4",
                    "borderRadius": "5",
                    "width": 120,
                    "height": 93
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": "#64b9F0, #4d8fbb",
                            "borderRadius": "5 5 0 0",
                            "width": 119,
                            "height": 30,
                            "fontColor": "#fff",
                            "fontWeight": "bold",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "0 0"
                        }
                    }
                    ,
                    {
                        "type": "text",
                        "binding": "position_name",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "white",
                            "borderRadius": "0 0 0 0",
                            "width": 119,
                            "height": 30,
                            "fontColor": "#000",
                            "fontWeight": "bold",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "0 31"
                        }
                    }
                    ,
                    {
                        "type": "text",
                        "binding": "position_name2",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "white",
                            "borderRadius": "0 0 5 5",
                            "width": 119,
                            "height": 30,
                            "fontColor": "#000",
                            "fontWeight": "bold",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "0 61"
                        }
                    }
                ]
            },
            "Org2": {
                "style": {
                    "backgroundColor": "#B5BECC",
                    "borderWidth": "1",
                    "borderColor": "#8998A4",
                    "borderRadius": "5",
                    "width": 120,
                    "height": 36
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": "#64b9F0, #4d8fbb",
                            "borderRadius": "5",
                            "width": 119,
                            "height": 35,
                            "fontColor": "#fff",
                            "fontWeight": "bold",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "0 0"
                        }
                    }
                ]
            },
            "DualOrg2": {
                "style": {
                    "backgroundColor": "#B5BECC",
                    "borderWidth": "1",
                    "borderColor": "#8998A4",
                    "borderRadius": "5",
                    "width": 120,
                    "height": 36
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": "#64b9F0, #4d8fbb",
                            "borderRadius": "5",
                            "width": 119,
                            "height": 35,
                            "fontColor": "#fff",
                            "fontWeight": "bold",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "0 0"
                        }
                    }
                ]
            },
            "VertLeader": {
              "units": [
                {
                  "binding": "deptnm",
                  "forceWrap": "true",
                  "maxLines": 10,
                  "style": {
                	"backgroundColor": "#64b9F0, #4d8fbb",
                    "borderColor": "transparent",
                    "borderRadius": "6 6 0 0",
                    "borderWidth": "1",
                    "fontColor": "#FFFFFF",
                    "fontWeight": "bold",
                    "fontSize": 13,
                    "height": 149,
                    "position": "1 1",
                    "width": 28
                  },
                  "type": "text",
                  "verticalAlign": "center"
                },
                {
                  "binding": "position_name",
                  "forceWrap": "true",
                  "style": {
                    "backgroundColor": "transparent",
                    "borderColor": "#3A3A3A",
                    "fontWeight": "bold",
                    "borderRadius": "0",
                    "borderWidth": "0",
                    "fontSize": 13,
                    "height": 149,
                    "position": "1 149",
                    "width": 28
                  },
                  "type": "text"
                }
              ],
              "style": {
                "backgroundColor": "white",
                "borderColor": "#b1b1b1",
                "borderRadius": 8,
                "borderWidth": 1,
                "height": 300,
                "width": 30
              }
            },
            "DualVertLeader": {
                "units": [
                  {
                    "binding": "deptnm",
                    "forceWrap": "true",
                    "maxLines": 10,
                    "style": {
                  	"backgroundColor": "#64b9F0, #4d8fbb",
                      "borderColor": "transparent",
                      "borderRadius": "6 6 0 0",
                      "borderWidth": "1",
                      "fontColor": "#FFFFFF",
                      "fontWeight": "bold",
                      "fontSize": 13,
                      "height": 149,
                      "position": "1 1",
                      "width": 58
                    },
                    "type": "text",
                    "verticalAlign": "center"
                  },
                  {
                    "binding": "position_name",
                    "forceWrap": "true",
                    "style": {
                      "backgroundColor": "transparent",
                      "borderColor": "#3A3A3A",
                      "fontWeight": "bold",
                      "borderRadius": "0",
                      "borderWidth": "0",
                      "fontSize": 13,
                      "height": 149,
                      "position": "1 149",
                      "width": 28
                    },
                    "type": "text"
                  },
                  {
                      "binding": "position_name2",
                      "forceWrap": "true",
                      "style": {
                        "backgroundColor": "transparent",
                        "borderColor": "#3A3A3A",
                        "fontWeight": "bold",
                        "borderRadius": "0",
                        "borderWidth": "0",
                        "fontSize": 13,
                        "height": 149,
                        "position": "30 149",
                        "width": 28
                      },
                      "type": "text"
                    }
                ],
                "style": {
                  "backgroundColor": "white",
                  "borderColor": "#b1b1b1",
                  "borderRadius": 8,
                  "borderWidth": 1,
                  "height": 300,
                  "width": 60
                }
              },

            "VertOrg": {
                "style": {
                    "backgroundColor": "#B5BECC , #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#8998A4",
                    "borderRadius": "5",
                    "width": 30,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "forceWrap": "true",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": "#64b9F0, #4d8fbb",
                            "borderRadius": "5",
                            "width": 28,
                            "height": 148,
                            "fontWeight": "bold",
                            "fontColor": "#fff",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "1 1"
                        }
                    }
                ]
            },
            "DualVertOrg": {
                "style": {
                    "backgroundColor": "#B5BECC , #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#8998A4",
                    "borderRadius": "5",
                    "width": 30,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "forceWrap": "true",
                        "maxLines": 10,
                        "style": {
                        	"backgroundColor": "#64b9F0, #4d8fbb",
                            "borderRadius": "5",
                            "width": 28,
                            "height": 148,
                            "fontWeight": "bold",
                            "fontColor": "#fff",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "1 1"
                        }
                    }
                ]
            },
            "DualPhotoBox": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 180,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                        	"backgroundColor": "#64b9F0, #4d8fbb",
                            "borderRadius": "4 4 0 0",
                            "width": 179,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "132 123"
                        }
                    }
                ]
            },

            "DualPhotoBox1": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 180,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#65dbb4, #4EA98B",
                            "borderRadius": "4 4 0 0",
                            "width": 179,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "132 123"
                        }
                    }
                ]
            },
            "DualPhotoBox2": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 180,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#59c125, #45951D",
                            "borderRadius": "4 4 0 0",
                            "width": 179,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "132 123"
                        }
                    }
                ]
            },
            "DualPhotoBox3": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 180,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#0082bc, #006491",
                            "borderRadius": "4 4 0 0",
                            "width": 179,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "132 123"
                        }
                    }
                ]
            },
            "DualPhotoBox4": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 180,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#F07f3f, #D46231",
                            "borderRadius": "4 4 0 0",
                            "width": 179,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "132 123"
                        }
                    }
                ]
            },
            "DualPhotoBox5": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 180,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#765c7f, #5B4762",
                            "borderRadius": "4 4 0 0",
                            "width": 179,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "132 123"
                        }
                    }
                ]
            },
            "DualPhotoBox6": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 180,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#64b9F0, #4D8FBB",
                            "borderRadius": "4 4 0 0",
                            "width": 179,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "132 123"
                        }
                    }
                ]
            },
            "DualPhotoBox7": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 180,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#d63636, #A52A2A",
                            "borderRadius": "4 4 0 0",
                            "width": 179,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "132 123"
                        }
                    }
                ]
            },
            "DualPhotoBox8": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 180,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#F0da3e, #F0A830",
                            "borderRadius": "4 4 0 0",
                            "width": 179,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "132 123"
                        }
                    }
                ]
            },
            "DualPhotoBox9": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 180,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#ab7f5b, #846246",
                            "borderRadius": "4 4 0 0",
                            "width": 179,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "132 123"
                        }
                    }
                ]
            },
            "DualPhotoBox10": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 180,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#e6e6e6, #b1b1b1",
                            "borderRadius": "4 4 0 0",
                            "width": 179,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "132 123"
                        }
                    }
                ]
            },
            "PhotoBox": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 90,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                        	"backgroundColor": "#64b9F0, #4d8fbb",
                            "borderRadius": "4 4 0 0",
                            "width": 89,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "46 123"
                        }
                    }
                ]
            },
            "PhotoBox2": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 90,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#59c125, #45951D",
                            "borderRadius": "4 4 0 0",
                            "width": 89,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "46 123"
                        }
                    }
                ]
            },
            "PhotoBox3": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 90,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#0082bc, #006491",
                            "borderRadius": "4 4 0 0",
                            "width": 89,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "46 123"
                        }
                    }
                ]
            },
            "PhotoBox4": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 90,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#F07f3f, #D46231",
                            "borderRadius": "4 4 0 0",
                            "width": 89,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "46 123"
                        }
                    }
                ]
            },
            "PhotoBox5": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 90,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#765c7f, #5B4762",
                            "borderRadius": "4 4 0 0",
                            "width": 89,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "46 123"
                        }
                    }
                ]
            },
            "PhotoBox6": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 90,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#64b9F0, #4D8FBB",
                            "borderRadius": "4 4 0 0",
                            "width": 89,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "46 123"
                        }
                    }
                ]
            },
            "PhotoBox7": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 90,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#d63636, #A52A2A",
                            "borderRadius": "4 4 0 0",
                            "width": 89,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "46 123"
                        }
                    }
                ]
            },
            "PhotoBox8": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 90,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#F0da3e, #F0A830",
                            "borderRadius": "4 4 0 0",
                            "width": 89,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "46 123"
                        }
                    }
                ]
            },
            "PhotoBox9": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 90,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#ab7f5b, #846246",
                            "borderRadius": "4 4 0 0",
                            "width": 89,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "46 123"
                        }
                    }
                ]
            },
            "PhotoBox10": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 90,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#e6e6e6, #b1b1b1",
                            "borderRadius": "4 4 0 0",
                            "width": 89,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "46 123"
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
                    "width": 180,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#e6e6e6, #b1b1b1",
                            "borderRadius": "4 4 0 0",
                            "width": 179,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                    "width": 180,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#e6e6e6, #b1b1b1",
                            "borderRadius": "4 4 0 0",
                            "width": 179,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "132 123"
                        }
                    }
                ]
            },
            "PhotoBoxList": {
                "style": {
                    "backgroundColor": "#E0E0E0, #F0F0F0",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5",
                    "width": 90,
                    "height": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#e6e6e6, #b1b1b1",
                            "borderRadius": "4 4 0 0",
                            "width": 88,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
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
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "46 123"
                        }
                    }
                ]
            },
            "GridList": {
                "type": "table",
                "style": {
                    "backgroundColor": "white",
                    "borderWidth": 1,
                    "borderColor": "#b1b1b1",
                    "borderRadius": null,
                    "width": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "horizontalAlign": "center",
                        "style": {
                            "backgroundColor": "#64b9F0, #4d8fbb",
                            "borderRadius": null,
                            "width": 150,
                            "height": 25,
                            "fontColor": "#fff",
                            "fontSize": 13,
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
                            "width": 150,
                            "column": 0,
                            "row": 2
                        },
                        "units": [
                            {
                                "type": "text",
                                "binding": "position",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ece5cd",
                                    "borderWidth": 0.5,
                                    "borderColor": "PowderBlue",
                                    "width": 75,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 13,
                                    "column": 0,
                                    "row": 0
                                }
                            },
                            {
                                "type": "text",
                                "binding": "empnm",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ece5cd",
                                    "borderWidth": 0.5,
                                    "borderColor": "PowderBlue",
                                    "width": 75,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 13,
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
                            "width": 150,
                            "column": 0,
                            "row": 4
                        },
                        "units": [
                            {
                                "type": "text",
                                "binding": "listcount",
                                "horizontalAlign": "right",
                                "style": {
                                    "backgroundColor": "#c5e0dc",
                                    "borderWidth": 0,
                                    "borderColor": "#3C5A91",
                                    "width": 75,
                                    "height": 20,
                                    "fontColor": "#000",
                                    "fontSize": 13,
                                    "column": 0,
                                    "row": 0
                                }
                            },
                            {
                                "type": "text",
                                "value": "명",
                                "horizontalAlign": "left",
                                "style": {
                                    "backgroundColor": "#c5e0dc",
                                    "borderWidth": 0,
                                    "borderColor": "#3C5A91",
                                    "width": 75,
                                    "height": 20,
                                    "fontColor": "#000",
                                    "fontSize": 13,
                                    "column": 1,
                                    "row": 0
                                }
                            }
                        ]
                    }
                ]
            },
            "DualGridList": {
                "type": "table",
                "style": {
                    "backgroundColor": "white",
                    "borderWidth": 1,
                    "borderColor": "#b1b1b1",
                    "borderRadius": null,
                    "width": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "horizontalAlign": "center",
                        "style": {
                            "backgroundColor": "#64b9F0, #4d8fbb",
                            "borderRadius": null,
                            "width": 150,
                            "height": 25,
                            "fontColor": "#fff",
                            "fontSize": 13,
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
                            "width": 150,
                            "column": 0,
                            "row": 2
                        },
                        "units": [
                            {
                                "type": "text",
                                "binding": "position",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ece5cd",
                                    "borderWidth": 0.5,
                                    "borderColor": "PowderBlue",
                                    "width": 75,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 13,
                                    "column": 0,
                                    "row": 0
                                }
                            },
                            {
                                "type": "text",
                                "binding": "position2",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ece5cd",
                                    "borderWidth": 0.5,
                                    "borderColor": "PowderBlue",
                                    "width": 75,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 13,
                                    "column": 0,
                                    "row": 1
                                }
                            },
                            {
                                "type": "text",
                                "binding": "empnm",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ece5cd",
                                    "borderWidth": 0.5,
                                    "borderColor": "PowderBlue",
                                    "width": 75,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 13,
                                    "column": 1,
                                    "row": 0
                                }
                            },
			    {
                                "type": "text",
                                "binding": "empnm2",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ece5cd",
                                    "borderWidth": 0.5,
                                    "borderColor": "PowderBlue",
                                    "width": 75,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 13,
                                    "column": 1,
                                    "row": 1
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
                            "width": 150,
                            "column": 0,
                            "row": 3
                        },
                        "units": [
                            {
                                "type": "table",
                                "style": {
                                    "backgroundColor": "transparent",
                                    "borderWidth": null,
                                    "borderColor": "#b1b1b1",
                                    "width": 150
                                },
                                "units": [
                                    {
                                        "type": "text",
                                        "binding": "position",
                                        "horizontalAlign": "center",
                                        "style": {
                                            "backgroundColor": "WhiteSmoke",
                                            "borderWidth": 0.5,
                                            "borderColor": "PowderBlue",
                                            "width": 75,
                                            "height": 20,
                                            "fontColor": "Black",
                                            "fontSize": 13,
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
                                            "borderWidth": 0.5,
                                            "borderColor": "PowderBlue",
                                            "width": 75,
                                            "height": 20,
                                            "fontColor": "Black",
                                            "fontSize": 13,
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
                            "width": 150,
                            "column": 0,
                            "row": 4
                        },
                        "units": [
                            {
                                "type": "text",
                                "binding": "listcount",
                                "horizontalAlign": "right",
                                "style": {
                                    "backgroundColor": "#c5e0dc",
                                    "borderWidth": 0,
                                    "borderColor": "#3C5A91",
                                    "width": 75,
                                    "height": 20,
                                    "fontColor": "#000",
                                    "fontSize": 13,
                                    "column": 0,
                                    "row": 0
                                }
                            },
                            {
                                "type": "text",
                                "value": "명",
                                "horizontalAlign": "left",
                                "style": {
                                    "backgroundColor": "#c5e0dc",
                                    "borderWidth": 0,
                                    "borderColor": "#3C5A91",
                                    "width": 75,
                                    "height": 20,
                                    "fontColor": "#000",
                                    "fontSize": 13,
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
                    "width": 140,
                    "height": 75
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "verticalAlign": "center",
                        "style": {
                            "backgroundColor": "#e6e6e6, #b1b1b1",
                            "borderRadius": null,
                            "width": 138,
                            "height": 26,
                            "fontFamily": "Dotum",
                            "fontColor": "#ffffff",
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
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
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position": "70 50"
                        }
                    }
                ]
            },
            "OrgBox": {
            	"type": "table",
                "style": {
                    "backgroundColor": "white",
                    "borderWidth": 1,
                    "borderColor": "#b1b1b1",
                    "borderRadius": null,
                    "width": 150
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "horizontalAlign": "center",
                        "style": {
                            "backgroundColor": "#64b9F0, #4d8fbb",
                            "borderRadius": null,
                            "width": 150,
                            "height": 25,
                            "fontColor": "#fff",
                            "fontSize": 13,
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
                            "width": 150,
                            "column": 0,
                            "row": 2
                        },
                        "units": [
                            {
                                "type": "text",
                                "binding": "position",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ece5cd",
                                    "borderWidth": 0.5,
                                    "borderColor": "PowderBlue",
                                    "width": 75,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 13,
                                    "column": 0,
                                    "row": 0
                                }
                            },
                            {
                                "type": "text",
                                "binding": "empnm",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ece5cd",
                                    "borderWidth": 0.5,
                                    "borderColor": "PowderBlue",
                                    "width": 75,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 13,
                                    "column": 1,
                                    "row": 0
                                }
                            }
                        ]
                    }
                ]
            },
            "PhotoBoxPhoto": {
            	 "type": "table",
                 "style": {
                     "backgroundColor": "white",
                     "borderWidth": "1",
                     "borderColor": "#b1b1b1",
                     "borderRadius": "5 5 0 0",
                     "selectionBorderWidth": 2,
                     "width": 100
                 },
                 "units": [
                     {
                         "type": "text",
                         "binding": "deptnm",
                         "horizontalAlign": "center",
                         "style": {
                             "backgroundColor": "#64b9F0, #4d8fbb",
                             "borderRadius": "5 5 0 0",
                             "width": 100,
                             "height": 25,
                             "fontColor": "#fff",
                             "fontSize": 13,
                             "cursor": "pointer",
                             "column": 0,
                             "row": 0
                         }
                     },
                     {
                         "type": "picture",
                         "binding": "photo",
                         "style": {
                             "backgroundColor": "transparent",
                             "borderWidth": "0.5",
                             "borderColor": "PowderBlue",
                             "width": 100,
                             "height": 100,
                             "column": 0,
                             "row": 1
                         }
                     },
                     {
                         "type": "table",
                         "style": {
                             "backgroundColor": "transparent",
                             "borderWidth": "0 0.5 0 0.5",
                             "borderColor": "Gray",
                             "width": 100,
                             "column": 0,
                             "row": 2
                         },
                         "units": [
                             {
                                 "type": "text",
                                 "binding": "position",
                                 "horizontalAlign": "center",
                                 "style": {
                                     "backgroundColor": "#ece5cd",
                                     "borderWidth": "0.5",
                                     "borderColor": "PowderBlue",
                                     "width": 50,
                                     "height": 25,
                                     "fontColor": "Black",
                                     "fontSize": 13,
                                     "column": 0,
                                     "row": 0
                                 }
                             },
                             {
                                 "type": "text",
                                 "binding": "empnm",
                                 "horizontalAlign": "center",
                                 "style": {
                                     "backgroundColor": "#ece5cd",
                                     "borderWidth": "0.5",
                                     "borderColor": "PowderBlue",
                                     "width": 50,
                                     "height": 25,
                                     "fontColor": "Black",
                                     "fontSize": 13,
                                     "column": 1,
                                     "row": 0
                                 }
                             }
                         ]
                     }]
            },

            "DualGridPhoto": {
                "type": "table",
                "style": {
                    "backgroundColor": "white",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5 5 0 0",
                    "selectionBorderWidth": 2,
                    "width": 200
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "horizontalAlign": "center",
                        "style": {
                            "backgroundColor": "#64b9F0, #4d8fbb",
                            "borderRadius": "5 5 0 0",
                            "width": 200,
                            "height": 25,
                            "fontColor": "#fff",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "position":"0 0",
                            "column": 0,
                            "row": 0
                        }
                    },

                    {
	                    "type": "table",
	                    "style": {
	                        "backgroundColor": "transparent",
	                        "borderWidth": "0 0 0 1",
	                        "borderColor": "#b1b1b1",
	                        "width": 200,
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
	                                "width": 100,
	                                "height": 100,
	                                "column": 0,
	                                //"row": 1
	                            }
	                        },
	                        {
	                            "type": "picture",
	                            "binding": "photo2",
	                            "style": {
	                                "backgroundColor": "transparent",
	                                "borderWidth": "0",
	                                "borderColor": "PowderBlue",
	                                "width": 100,
	                                "height": 100,
	                                "column": 1,
	                                //"row": 1
	                            }
	                        }
	                    ]
                    },


					{
                        "type": "table",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0 0.5 0 0.5",
                            "borderColor": "Gray",
                            "width": 200,
                            "column": 0,
                            "row": 2
                        },
                        "units": [
                            {
                                "type": "text",
                                "binding": "position",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ece5cd",
                                    "borderWidth": "0.5",
                                    "borderColor": "PowderBlue",
                                    "width": 50,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 13,
                                    "column": 0,
                                    //"row": 0
                                }
                            },
                            {
                                "type": "text",
                                "binding": "empnm",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ece5cd",
                                    "borderWidth": "0.5",
                                    "borderColor": "PowderBlue",
                                    "width": 50,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 13,
                                    "column": 1,
                                    //"row": 0
                                }
                            },
                            {
                                "type": "text",
                                "binding": "position2",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ece5cd",
                                    "borderWidth": "0.5",
                                    "borderColor": "PowderBlue",
                                    "width": 50,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 13,
                                    "column": 2,
                                    //"row": 0
                                }
                            },
                            {
                                "type": "text",
                                "binding": "empnm2",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ece5cd",
                                    "borderWidth": "0.5",
                                    "borderColor": "PowderBlue",
                                    "width": 50,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 13,
                                    "column": 3,
                                    //"row": 0
                                }
                            }

                        ]
                    },

                    {
                        "type": "list",
                        "style": {
                            "backgroundColor": "transparent",
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
                                    "borderWidth": "0 0 0 1",
                                    "borderColor": "#b1b1b1",
                                    "width": 200
                                },
                                "units": [
                                    {
                                        "type": "picture",
                                        "binding": "photo",
                                        "style": {
                                            "backgroundColor": "transparent",
                                            "borderWidth": "0",
                                            "borderColor": "PowderBlue",
                                            "width": 50,
                                            "height": 38,
                                            "column": 0,
                                            "row": 0
                                        }
                                    },
                                    {
                                        "type": "table",
                                        "style": {
                                            "backgroundColor": "transparent",
                                            "borderWidth": "0",
                                            "borderColor": "Gray",
                                            "width": 150,
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
                                                    "borderWidth": "0.5",
                                                    "borderColor": "PowderBlue",
                                                    "width": 150,
                                                    "height": 20,
                                                    "fontColor": "Black",
                                                    "fontSize": 13,
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
                                                    "borderWidth": "0.5",
                                                    "borderColor": "PowderBlue",
                                                    "width": 150,
                                                    "height": 20,
                                                    "fontColor": "Black",
                                                    "fontSize": 13,
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
                                "horizontalAlign": "right",
                                "style": {
                                    "backgroundColor": "#c5e0dc",
                                    "borderWidth": "0",
                                    "borderColor": "#3C5A91",
                                    "width": 100,
                                    "height": 20,
                                    "fontColor": "#000",
                                    "fontSize": 13,
                                    "column": 0,
                                    "row": 0
                                }
                            },
                            {
                                "type": "text",
                                "value": "명",
                                "horizontalAlign": "left",
                                "style": {
                                    "backgroundColor": "#c5e0dc",
                                    "borderWidth": "0",
                                    "borderColor": "#3C5A91",
                                    "width": 100,
                                    "height": 20,
                                    "fontColor": "#000",
                                    "fontSize": 13,
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
                    "backgroundColor": "white",
                    "borderWidth": "1",
                    "borderColor": "#b1b1b1",
                    "borderRadius": "5 5 0 0",
                    "selectionBorderWidth": 2,
                    "width": 100
                },
                "units": [
                    {
                        "type": "text",
                        "binding": "deptnm",
                        "horizontalAlign": "center",
                        "style": {
                            "backgroundColor": "#64b9F0, #4d8fbb",
                            "borderRadius": "5 5 0 0",
                            "width": 100,
                            "height": 25,
                            "fontColor": "#fff",
                            "fontSize": 13,
                            "cursor": "pointer",
                            "column": 0,
                            "row": 0
                        }
                    },
                    {
                        "type": "picture",
                        "binding": "photo",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0.5",
                            "borderColor": "PowderBlue",
                            "width": 100,
                            "height": 100,
                            "column": 0,
                            "row": 1
                        }
                    },
                    {
                        "type": "table",
                        "style": {
                            "backgroundColor": "transparent",
                            "borderWidth": "0 0.5 0 0.5",
                            "borderColor": "Gray",
                            "width": 100,
                            "column": 0,
                            "row": 2
                        },
                        "units": [
                            {
                                "type": "text",
                                "binding": "position",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ece5cd",
                                    "borderWidth": "0.5",
                                    "borderColor": "PowderBlue",
                                    "width": 50,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 13,
                                    "column": 0,
                                    "row": 0
                                }
                            },
                            {
                                "type": "text",
                                "binding": "empnm",
                                "horizontalAlign": "center",
                                "style": {
                                    "backgroundColor": "#ece5cd",
                                    "borderWidth": "0.5",
                                    "borderColor": "PowderBlue",
                                    "width": 50,
                                    "height": 25,
                                    "fontColor": "Black",
                                    "fontSize": 13,
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
                            "borderWidth": "0",
                            "borderColor": "Red",
                            "width": 100,
                            "column": 0,
                            "row": 3
                        },
                        "units": [
                            {
                                "type": "table",
                                "style": {
                                    "backgroundColor": "transparent",
                                    "borderWidth": 1,
                                    "borderColor": "#999999",
                                    "width": 99
                                },
                                "units": [
                                    {
                                        "type": "picture",
                                        "binding": "photo",
                                        "style": {
                                            "backgroundColor": "transparent",
                                            "borderWidth": "0",
                                            "borderColor": "PowderBlue",
                                            "width": 50,
                                            "height": 38,
                                            "column": 0,
                                            "row": 0
                                        }
                                    },
                                    {
                                        "type": "table",
                                        "style": {
                                            "backgroundColor": "transparent",
                                            "borderWidth": "0",
                                            "borderColor": "Gray",
                                            "width": 50,
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
                                                    "borderWidth": "0.5",
                                                    "borderColor": "PowderBlue",
                                                    "width": 50,
                                                    "height": 20,
                                                    "fontColor": "Black",
                                                    "fontSize": 13,
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
                                                    "borderWidth": "0.5",
                                                    "borderColor": "PowderBlue",
                                                    "width": 50,
                                                    "height": 20,
                                                    "fontColor": "Black",
                                                    "fontSize": 13,
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
                            "width": 100,
                            "column": 0,
                            "row": 4
                        },
                        "units": [
                            {
                                "type": "text",
                                "binding": "listcount",
                                "horizontalAlign": "right",
                                "style": {
                                    "backgroundColor": "#c5e0dc",
                                    "borderWidth": "0",
                                    "borderColor": "#3C5A91",
                                    "width": 50,
                                    "height": 20,
                                    "fontColor": "#000",
                                    "fontSize": 13,
                                    "column": 0,
                                    "row": 0
                                }
                            },
                            {
                                "type": "text",
                                "value": "명",
                                "horizontalAlign": "left",
                                "style": {
                                    "backgroundColor": "#c5e0dc",
                                    "borderWidth": "0",
                                    "borderColor": "#3C5A91",
                                    "width": 50,
                                    "height": 20,
                                    "fontColor": "#000",
                                    "fontSize": 13,
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
                            "width": 79,
                            "height": 35,
                            "fontFamily": "Dotum",
                            "fontColor": "#3A3A3A",
                            "fontSize": 13,
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