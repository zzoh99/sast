$(function($) {

	function Fileupload() {
		var _elements = {}, _defaultOptions = {
			btn : {
				browse : {
					title : '\ud30c\uc77c\uc120\ud0dd',
					class : "browse-btn"
				}
			},
			event : {
				submit : function(options) {
					var _form = options.el.find("form"), _params = function(params) {
						var rtn = "";
						$.each(params, function(key, value) {
							var val = typeof(value) === 'function' ? value.apply(null, null) : value;
							
							rtn += "&" + key + "=" + encodeURIComponent(val);
						});
						return rtn;
					}(options.params), ajaxOptions = {
						async : true,
						type : 'POST',
						url : options.context + "/fileuploadJFileUpload.do?cmd=upload" + _params,
						success : function(data) {
							var dataObj = $.parseJSON(data.replace(/<[^{}]*>/g, ""));
							_form.get(0).reset();
							options.el.show();
							
							if(dataObj != null) {
								if(dataObj.code === "success") {
									options.curFileCount = (options.curFileCount || 0) + dataObj.data.length;
									options.event.success.apply(null, [ dataObj ]);
								} else if(dataObj.code === "error") {
									options.event.error.apply(null, [ dataObj ]);
								}
							}
							
						},
						error : function(jqXHR, textStatus, errorThrown) {
							_form.get(0).reset();
							ajaxJsonErrorAlert(jqXHR, textStatus, errorThrown);
						}
					};
					
					if(options.event.beforeSubmit.apply(null, [ options ])) {
						_form.ajaxSubmit(ajaxOptions);
					}
				},
				beforeSubmit : function(options) {
					options.el.hide();
					return true;
				},
				success : function(jsonObj) {
				},
				error : function(jsonObj) {
				}
			},
			context : "/",
			curFileCount : 0,
			el : null
		}, _addEvent = function(options) {
			var _el = options.el;
			_el.on("click.fileupload", function(e) {
				e.preventDefault();
				e.isPropagationStopped();
				e.stopImmediatePropagation();

				_el.find("input[type='file']").click(function(ee) {
					ee.isPropagationStopped();
					ee.stopImmediatePropagation();
				}).click();
			}).on("change.fileupload", "input[type='file']", function(evt) {
				_fileChangeHandler.apply(null, [ options, evt ]);
			});
		}, _fileChangeHandler = function(options, evt) {
			var _files = evt.target.files, _el = options.el, _extRegExp = null, _mimeRegExp = null, _form = _el.find("form");
			
			if ((_files.length + (options.curFileCount || 0)) > options.fileCount) {
				alert("첨부파일은 최대 " + options.fileCount + "개 입니다.");
				_form.get(0).reset();
				return false;
			}

			if (options.extExtension !== undefined && options.extExtension !== null && options.extExtension !== "") {
				_extRegExp = new RegExp(options.extExtension.split(",").join("|"), "i");
			}

			if (options.mimeExtension !== undefined && options.mimeExtension !== null && options.mimeExtension !== "") {
				var extension = options.mimeExtension;
//				extension = extension.split("/").join("//");
				_mimeRegExp = new RegExp(extension.split(",").join("|"), "i");
			}
			
			var isValid = true;

			$.each(_files, function(idx, file) {
				var type = file.type, size = file.size, fileExt = function(name) {
					var tmp = name.split(".");
					return tmp[tmp.length - 1];
				}(file.name);
				
				if (options.fileSize < size) {
					alert("size 초과");
					_form.get(0).reset();
					return isValid = false;
				}
				
				if ((_extRegExp != null && !_extRegExp.test(fileExt)) || (_mimeRegExp != null && !_mimeRegExp.test(type))) {
					alert(fileExt + " : [" + _extRegExp + "] 지원하지 않는 확장자(타입) 입니다.");
					_form.get(0).reset();
					return isValid = false;
				}
			});

			if(isValid) {
				options.event.submit.apply(null, [ options ]);
			}
		}, _hasFileupload = function(id) {
			return _elements[id] ? true : false;
		};

		this.init = function(el, options, params) {
			var _el = $(el), _index = _elements.length;
			_el.attr("id", _el.attr("id") ? _el.attr("id") : "fileuploader" + _index + "o");

			if (!_hasFileupload(_el.attr("id"))) {
				var _curOptions = _elements[_el.attr("id")] = $.extend(true, {}, _defaultOptions, options, {
					'el' : _el,
					'params' : params
				});
				_el
					.append("<div class = 'file-upload'></div>")
					.find(".file-upload")
						.append("<div class='file-browse-bar'></div>")
						.append("<div class='file-list' style='display:none'></div>")
						.find(".file-browse-bar")
							.append("<span class='" + _curOptions.btn.browse.class + "'>" + _curOptions.btn.browse.title + "</span>")
						.parent()
							.append("<form>")
							.find("form")
								.attr({
									id : 'vform'+_index,
									name : 'vform',
									method : 'post',
									enctype : 'multipart/form-data'
								})
								.append("<input type='file'>")
								.find("input")
									.attr({
										name : 'vfile',
										accept : _curOptions.mimeType
									}).css({
										display : "none"
									});
				
				if(_curOptions.multiple !== undefined && _curOptions.multiple !== null && _curOptions.multiple !== "") {
					_el
						.find("input[type='file']")
							.attr({
								multiple : "multiple"
							});
				}

				//$(".reset-btn, .upload-btn, .browse-btn").button();
				_addEvent(_curOptions);
			}
		};

		this.remove = function(el) {
			$(el).off(".fileupload");
			delete _elements[$(el).attr("id")];
		};

		this.setCount = function(el, cnt) {
			_elements[$(el).attr("id")] ? _elements[$(el).attr("id")].curFileCount = cnt : null;
		};
	}

	$.fn.fileupload = function(options) {
		var args = arguments;

		return this.each(function() {
			if ($.fileupload[options] === undefined) {
				alert(options + " is undefined...");
				return false;
			} else {
				$.fileupload[options].apply($.fileupload, [ this ].concat(Array.prototype.slice.call(args, 1)));
			}
		});
	};
	$.fileupload = new Fileupload();
	
	$.filedownload = function(uploadType, sendData) {
		try {
			if ($('#filedownform').length > 0) {
				$("#filedownform").remove();
			}
			var myIF = null;
			if (!document.getElementById("myIFrame")) {
				myIF = $('<iframe>', {
					'id' : "myIFrame",
					'name' : "myIFrame",
					'style' : 'width:0px;overflow: hidden; height: 0px; display:none;'
				});
				$(document.body).append(myIF);
			}
			if (document.getElementById("filedownform")) {
				document.body.removeChild(document.getElementById("filedownform"));
			}
			var newForm = $('<form>', {
				'id' : "filedownform",
				'method' : "POST",
				'action' : "/fileuploadJFileUpload.do?cmd=download",
				'target' : 'myIFrame'
			});
			
			$("<input>")
			.attr({
				"name": "uploadType",
				"value": uploadType,
				"type": "hidden"
			}).appendTo(newForm);

			if($.isArray(sendData)) {
				$.each(sendData, function(idx, obj) {
					$.each(obj, function(key, value) {
						$("<input>")
						.attr({
							"name": key,
							"value": value,
							"type": "hidden"
						}).appendTo(newForm);
					});
				});
			} else {
				$.each(sendData, function(key, value) {
					$("<input>")
					.attr({
						"name": key,
						"value": value,
						"type": "hidden"
					}).appendTo(newForm);
				});
			}
			
			$(document.body).append(newForm);
			newForm.submit();
		} catch (e) {
			alert(e.message);
		}
	};
	
	$.filedelete = function(uploadType, sendData, callback) {
		var params = function(u, p) {
			var rtn = "&uploadType=" + u;
			
			if($.isArray(p)) {
				$.each(p, function(idx, obj) {
					$.each(obj, function(key, value) {
						rtn += "&" + key + "=" + encodeURIComponent(value);
					});
				});
			} else {
				$.each(p, function(key, value) {
					rtn += "&" + key + "=" + encodeURIComponent(value);
				});
			}
			return rtn;
		}(uploadType, sendData);
		 $.ajax({
		        url: "/fileuploadJFileUpload.do?cmd=delete",
		        type: "post",
		        dataType: "json",
		        async: true,
		        data: params,
		        success: function(data) {
	            	callback.apply(null, [ data.result.code, data.result.message ]);
		        },
		        error: function(jqXHR, ajaxSettings, thrownError) {
		            ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		        }
		    });
	};
}(jQuery));