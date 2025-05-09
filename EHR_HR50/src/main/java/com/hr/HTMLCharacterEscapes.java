package com.hr;

import org.apache.commons.text.StringEscapeUtils;

import com.fasterxml.jackson.core.SerializableString;
import com.fasterxml.jackson.core.io.CharacterEscapes;
import com.fasterxml.jackson.core.io.SerializedString;

public class HTMLCharacterEscapes extends CharacterEscapes {

	private static final long serialVersionUID = 1L;
	private final int[] asciiEscapes;

    //private final CharSequenceTranslator translator;

    public HTMLCharacterEscapes() {

        // 1. XSS 방지 처리할 특수 문자 지정
        asciiEscapes = CharacterEscapes.standardAsciiEscapesForJSON();
        asciiEscapes['<'] = CharacterEscapes.ESCAPE_CUSTOM;
        asciiEscapes['>'] = CharacterEscapes.ESCAPE_CUSTOM;
        asciiEscapes['&'] = CharacterEscapes.ESCAPE_CUSTOM;
        asciiEscapes['\"'] = CharacterEscapes.ESCAPE_CUSTOM;
        asciiEscapes['('] = CharacterEscapes.ESCAPE_CUSTOM;
        asciiEscapes[')'] = CharacterEscapes.ESCAPE_CUSTOM;
        asciiEscapes['#'] = CharacterEscapes.ESCAPE_CUSTOM;
        asciiEscapes['\''] = CharacterEscapes.ESCAPE_CUSTOM;

        // 2. XSS 방지 처리 특수 문자 인코딩 값 지정
//        translator = new AggregateTranslator(
//                new LookupTranslator(EntityArrays.BASIC_ESCAPE()),  // <, >, &, " 는 여기에 포함됨
//                new LookupTranslator(EntityArrays.ISO8859_1_ESCAPE()),
//                new LookupTranslator(EntityArrays.HTML40_EXTENDED_ESCAPE()),
//                // 여기에서 커스터마이징 가능
//                new LookupTranslator(
//                        new String[][]{
//                                {"(",  "&#40;"},
//                                {")",  "&#41;"},
//                                {"#",  "&#35;"},
//                                {"\'", "&#39;"}
//                        }
//                )
//        );

    }

    @Override
    public int[] getEscapeCodesForAscii() {
        return asciiEscapes.clone();
    }

//    @Override
//    public SerializableString getEscapeSequence(int ch) {
//        return new SerializedString(StringEscapeUtils.escapeHtml4(Character.toString((char) ch)));
//    }

    @Override
    public SerializableString getEscapeSequence(int ch) {
        SerializedString serializedString;
        char charAt = (char) ch;
        if (Character.isHighSurrogate(charAt) || Character.isLowSurrogate(charAt)) {
            StringBuilder sb = new StringBuilder();
            sb.append("\\u");
            sb.append(String.format("%04x", ch));
            serializedString = new SerializedString(sb.toString());
        } else {
            //serializedString =  new SerializedString(translator.translate(Character.toString((char) ch)));
            serializedString = new SerializedString(StringEscapeUtils.escapeHtml4(Character.toString(charAt)));
        }
        return serializedString;
    }

}
