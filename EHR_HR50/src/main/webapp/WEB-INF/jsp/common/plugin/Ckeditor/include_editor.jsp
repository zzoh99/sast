﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link href="${ctx}/common/css/ckeditor.css?v=2" rel="stylesheet">
<link href="${ctx}/common/css/ckeditor5.css?v=2" rel="stylesheet">
<style>
	/*CkEditor Setting Style*/
	.ck-sticky-panel__content_sticky {
	    position: relative !important;
	    top: auto !important;
	    width: 100% !important;
	}
	.ck-editor__main {
	    min-height: 500px;  /* Define minimum height for the entire editor */
	}
	.ck-focused,
	.ck-blurred{
	    min-height: 500px!important;
	    overflow-y: auto;
	}
</style>
<div class="ck-body-wrapper">
    <div class="main-container">
        <div class="editor-container editor-container_classic-editor editor-container_include-style" id="editor-container">
            <div class="editor-container__editor"><div id="ckEditor"></div></div>
        </div>
    </div>
</div>
<script>
    window.instanceEditor = null;
    window.modifyData = null;

    function convertPxToPt(html) {
        return html.replace(/font-size:(\d+)px;/g, (match, pxValue) => {
            const ptValue = (pxValue * 0.75).toFixed(2); // 1px -> 0.75pt
            return `font-size:${'${ptValue}'}pt;`;
        });
    }

    $(document).ready(function(){
        const ckEditor = window.top.CKEDITOR;
        //간헐적 중복 오류 - 기존 인스턴스 삭제
        if(window.instanceEditor){
            window.instanceEditor.destroy()
                .then(() => {
                    window.instanceEditor = null;
                })
                .catch(error => {
                    console.error(error);
                });
        }

        ckEditor.ClassicEditor.create(document.getElementById("ckEditor"), {
            // https://ckeditor.com/docs/ckeditor5/latest/getting-started/setup/toolbar/toolbar.html#extended-toolbar-configuration-format
            toolbar: {
                items: [
                    // 'exportPDF','exportWord', '|',
                    // 'findAndReplace', 'selectAll', '|',
                    'heading', '|',
                    'bold', 'italic', 'strikethrough', 'underline', 'code', 'subscript', 'superscript', 'removeFormat', '|',
                    'bulletedList', 'numberedList', '|',
                    'outdent', 'indent', '|',
                    'undo', 'redo',
                    '-',
                    'fontSize', 'fontFamily', 'fontColor', 'fontBackgroundColor', 'highlight', '|',
                    'alignment', '|',
                    'link', 'uploadImage', 'blockQuote', 'insertTable',
                    // 'mediaEmbed',
                    'codeBlock', 'htmlEmbed', '|',
                    'specialCharacters', 'horizontalLine', 'pageBreak', '|',
                    // 'textPartLanguage', '|',
                    'sourceEditing'
                ],
                shouldNotGroupWhenFull: true
            },
            ui:{
            	viewportOffset: {
                    top: 0  // This adjusts how sticky the toolbar is when scrolling
                }
            },
            // Changing the language of the interface requires loading the language file using the <script> tag.
            language: 'ko',
            list: {
                properties: {
                    styles: true,
                    startIndex: true,
                    reversed: true
                }
            },
            // https://ckeditor.com/docs/ckeditor5/latest/features/headings.html#configuration
            heading: {
                options: [
                    {model: 'paragraph', title: 'Paragraph', class: 'ck-heading_paragraph'},
                    {model: 'heading1', view: 'h1', title: 'Heading 1', class: 'ck-heading_heading1'},
                    {model: 'heading2', view: 'h2', title: 'Heading 2', class: 'ck-heading_heading2'},
                    {model: 'heading3', view: 'h3', title: 'Heading 3', class: 'ck-heading_heading3'},
                    {model: 'heading4', view: 'h4', title: 'Heading 4', class: 'ck-heading_heading4'},
                    {model: 'heading5', view: 'h5', title: 'Heading 5', class: 'ck-heading_heading5'},
                    {model: 'heading6', view: 'h6', title: 'Heading 6', class: 'ck-heading_heading6'}
                ]
            },
            // https://ckeditor.com/docs/ckeditor5/latest/features/editor-placeholder.html#using-the-editor-configuration
            placeholder: '',
            // https://ckeditor.com/docs/ckeditor5/latest/features/font.html#configuring-the-font-family-feature
            fontFamily: {
                options: [
                    'default',
                    'Arial, Helvetica, sans-serif',
                    'Courier New, Courier, monospace',
                    'Georgia, serif',
                    'Lucida Sans Unicode, Lucida Grande, sans-serif',
                    'Tahoma, Geneva, sans-serif',
                    'Times New Roman, Times, serif',
                    'Trebuchet MS, Helvetica, sans-serif',
                    'Verdana, Geneva, sans-serif',
                    '맑은 고딕', '돋움', '굴림', '궁서', '바탕'
                ],
                supportAllValues: true
            },
            // https://ckeditor.com/docs/ckeditor5/latest/features/font.html#configuring-the-font-size-feature
            fontSize: {
                options: [10, 12, 14, 'default', 18, 20, 22],
                supportAllValues: true
            },
            // Be careful with the setting below. It instructs CKEditor to accept ALL HTML markup.
            // https://ckeditor.com/docs/ckeditor5/latest/features/general-html-support.html#enabling-all-html-features
            htmlSupport: {
                allow: [
                    {
                        name: /.*/,
                        attributes: true,
                        classes: true,
                        styles: true
                    }
                ]
            },
            // Be careful with enabling previews
            // https://ckeditor.com/docs/ckeditor5/latest/features/html-embed.html#content-previews
            htmlEmbed: {
                showPreviews: false
            },
            // https://ckeditor.com/docs/ckeditor5/latest/features/link.html#custom-link-attributes-decorators
            link: {
                addTargetToExternalLinks: {
                    mode: 'automatic',
                    callback: url => /^(https?:)?\/\//.test( url ),
                    attributes: {
                        target: '_blank',
                        rel: 'noopener noreferrer'
                    }
                }
                // decorators: {
                //     // addTargetToExternalLinks: true,
                //     defaultProtocol: 'https://',
                //     toggleDownloadable: {
                //         mode: 'manual',
                //         label: 'Downloadable',
                //         attributes: {
                //             download: 'file'
                //         }
                //     },
                //     openInNewTab: {
                //         mode: 'manual',
                //         label: 'Open in a new tab',
                //         attributes: {
                //             target: '_blank',
                //             rel: 'noopener noreferrer'
                //         }
                //     }
                // }
            },
            // https://ckeditor.com/docs/ckeditor5/latest/features/mentions.html#configuration
            mention: {
                feeds: [
                    {
                        marker: '@',
                        feed: [
                            '@apple', '@bears', '@brownie', '@cake', '@cake', '@candy', '@canes', '@chocolate', '@cookie', '@cotton', '@cream',
                            '@cupcake', '@danish', '@donut', '@dragée', '@fruitcake', '@gingerbread', '@gummi', '@ice', '@jelly-o',
                            '@liquorice', '@macaroon', '@marzipan', '@oat', '@pie', '@plum', '@pudding', '@sesame', '@snaps', '@soufflé',
                            '@sugar', '@sweet', '@topping', '@wafer'
                        ],
                        minimumCharacters: 1
                    }
                ]
            },
            // The "superbuild" contains more premium features that require additional configuration, disable them below.
            // Do not turn them on unless you read the documentation and know how to configure them and setup the editor.
            removePlugins: [
                // These two are commercial, but you can try them out without registering to a trial.
                // 'ExportPdf',
                // 'ExportWord',
                'AIAssistant',
                'CKBox',
                'CKFinder',
                'EasyImage',
                // This sample uses the Base64UploadAdapter to handle image uploads as it requires no configuration.
                // https://ckeditor.com/docs/ckeditor5/latest/features/images/image-upload/base64-upload-adapter.html
                // Storing images as Base64 is usually a very bad idea.
                // Replace it on production website with other solutions:
                // https://ckeditor.com/docs/ckeditor5/latest/features/images/image-upload/image-upload.html
                // 'Base64UploadAdapter',
                'MultiLevelList',
                'RealTimeCollaborativeComments',
                'RealTimeCollaborativeTrackChanges',
                'RealTimeCollaborativeRevisionHistory',
                'RealTimeCollaborativeEditing',
                'PresenceList',
                'Comments',
                'TrackChanges',
                'TrackChangesData',
                'RevisionHistory',
                'Pagination',
                'WProofreader',
                // Careful, with the Mathtype plugin CKEditor will not load when loading this sample
                // from a local file system (file://) - load this site via HTTP server if you enable MathType.
                'MathType',
                // The following features are part of the Productivity Pack and require additional license.
                'SlashCommand',
                'Template',
                'DocumentOutline',
                'FormatPainter',
                'TableOfContents',
                'PasteFromOfficeEnhanced',
                'CaseChange'
            ]
        }).then(editor => {
            // editor = editor;

            window.instanceEditor = editor;
            editor.customMethods = {
                save(frm) {
                    $("#ckEditorContentArea").val(convertPxToPt(editor.getData()));
                    frm.submit();
                },
            };
            if(window.modifyData){
                editor.setData(window.modifyData);
            }
        });
    })
</script>