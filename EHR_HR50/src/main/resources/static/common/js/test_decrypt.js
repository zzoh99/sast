// 16진수 문자열을 ArrayBuffer로 변환하는 함수
function hexToArrayBuffer(hex) {
    if (hex.length % 2 !== 0) {
        throw new Error("Invalid hexString");
    }
    var arrayBuffer = new Uint8Array(hex.length / 2);
    for (var i = 0; i < hex.length; i += 2) {
        var byteValue = parseInt(hex.substring(i, i + 2), 16);
        arrayBuffer[i / 2] = byteValue;
    }
    return arrayBuffer;
}

async function decrypt(encryptedHex, keyHex, ivHex) {
    const encryptedData = hexToArrayBuffer(encryptedHex);
    const key = hexToArrayBuffer(keyHex);
    const iv = key.substring(0,16);//hexToArrayBuffer(ivHex);

    try {
        const cryptoKey = await window.crypto.subtle.importKey(
            "raw", // Raw format of the key
            key,
            {   // Algorithm details
                name: "AES-CBC"
            },
            false, // Whether the key is extractable
            ["decrypt"] // Key usages
        );

        const decryptedData = await window.crypto.subtle.decrypt(
            {
                name: "AES-CBC",
                iv: iv
            },
            cryptoKey,
            encryptedData
        );

        // Assuming the decrypted data is a UTF-8 encoded string
        const decoder = new TextDecoder();
        return decoder.decode(decryptedData);
    } catch (e) {
        console.error("Decryption failed:", e);
        return null;
    }
}

const encrypt = ajaxCall("/getMainMajorMenuEncryptList.do", "", false).result;
console.log("Encrypted:", encrypt);

if(encrypt != null && encrypt != 'undefined') {
    decrypt(encrypt.encryptMsg, encrypt.encryptKey, encrypt.encryptIv).then(decryptedText => {
        console.log("Decrypted text:", decryptedText);
    });
}