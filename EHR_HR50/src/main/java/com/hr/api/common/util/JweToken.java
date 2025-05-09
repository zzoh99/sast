package com.hr.api.common.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.hr.api.common.filter.Api50Filter;
import com.nimbusds.jose.*;
import com.nimbusds.jose.crypto.*;
import com.nimbusds.jose.jwk.RSAKey;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import org.springframework.stereotype.Component;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.security.SecureRandom;
import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Component
public class JweToken {

    private static String signKey = "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";
    private static String encKey = "Fyg+OtkxCI1xz3RBjwU0n3airLF3EHb7av5FvglRzI0sI3/65YWZbYCP1TvMjPd5/8wS5VIvt7ViaFdUtFstVOq1bpbNXeSmfFwWHaL9Dszp6BIKdYiR8aJXsPS+JZetGP05U/9/SSS8Nh+4eT51jT9QYUQk894zHHPBqq50/YmhOIGRzED3RWQw2aPj6zLwF1EeiilLJKLiLEYiR1xAwCVaLErPeFiQXGwvYrao/mcghP60Pp2WfLsoiUpFp0ONZtkbq99oCthGmZ8fcS22GZf7a06DfhLyWNGgOXdUYVsxGdhVtaJOBfzuRtUMNVCW1BtUIeBG1Nj+VKEgx0vBHAXVhsZ1llkbjSkEbu+K7xl2tsppCA2/LQk6PyPKRmfqaOwWw6iySG7kMUSglH4yLsVJWBTMTuQYDhTv7uwWvk3HVWX7g/8IoXlviABN6OhnE5/wwNbjhqVBTq0d3H1oCmBRpratwBDD41PWDWhgoBaQbcLyQfzmc/zXPN9whqRnaEtKhlpFa+WRBZPUNV8l2eLndnell3Yp/0/IiH9t0+LgIwDM/s2KqvOMG0S4krM9YB5v+vXCXatQFsrsRCJied/qyM39rKMaXpUApLk8a1zH9lsYn89stkmnY0rpzZGAd4zg2GRxMmQkWKP+TZDviJVtd045iL1B4B4o2ml9Trge5Q0gQRwPfh5Hm05jLkX7RIMylLrA/yDix+gELpGqMfEPjD/dN5kwDQ+lv/7obFwhsizscFOHau/ijFpJIrlFMQjLY1XKDNevrVJCWrDXzaXLJGanXSPgs3+WcnwIb6fJChVgrwRPc5f5mHn0+4ZrhMKcTarkU75FGgYgIsREMx8m9sOnWJA3zxeu3kZaX8ZY8cJRrswAx1+jAYDSWct8ZLbZ8jLr7PpnchTbEhoZwIIm46ZR/7L5DzBXnwvcdbAk4vuIKmGKOgBBUtqXLoRMBQTuAAnzUsj/3OHMzAYcji74CxsuXFm8V0aqMtbGRefAuxnJOayWprFORtGMj2d5YW0GDICk0rHL/tMmirkZQi6Td1ODG0sF2qyW9i05yvuFvAQ0h60Ij1RULF8wXwThe14lcbvb1p4JwT+Zg8SckpwwW2zvmLWGWAbwUnFbJ4gQj+cLYqrskWHR4AEOCAJviZn8Bca67dNr+hSAPuGMWArtVuhsTKe+JiZZLtSw/jG1FEbffayVVw1vPER+gMlAxAMJvXtIyseh0vron04iueP1HqvJVyPnvgaPuoTNKUWwc7YYdHi3TWn6Nr6wkJR2XbViuP+Mrr546Z8poKkFI+zU3GCibMQdKKG1Xt98R7qDRNscsh3IgjJVAe8+y/w1I3RRMNw6zNGgj18Cb2E85YAyPqwz6jXjES0q7Nk5CTTY8FSr9V3vV6/ZEx9vIIdUDITcizBz1IktDnjC3BbaqVV4nl+BxgFj8utp23s0paJn4Mdgcmukniu7YQizvOvIJfC0KZMHmzjNlh7oxXZrZ8GFYfInIg7qCnh+c24CuC7vIxCDMy+/kwbRIN7ITuixlfITaVThULS4uQT1+E43ICJ9cxH/ILtzukRpiLxo7LHTSZvbodfkJbShdFOvbVsqumCmD2MQKZ/5uQanMmGWtovjzdoBEGne/omejfWAPI9QMXAqRZVC4IngNNV4PbAlsHAqx1W3vC46jDt/bmYQN0gCz+okCMZJ4jWBhPA+Fv4ypj0kSBKZkUQ3lmaDP+vz9HoCy0o8McTnwaODLVHV99XEPYWPkjhl6UHRAgmbnD5CuVVFZxABsqXKuU8BYXXvGCZTi6gL3R+EA5mefkXOERSVcx3jW+m7Yv3acX+lCKY5tvIaehKjZHz3EASs8bJAY0x07i4heDRjDa+m4Gyr2ZrHsQ1UXZmG2fbi3wQG2Dm2hw6inktmn0cZ/tskxJ7yJTy2QikLb0s2diMV/5EPGio58Y1mRMu3fM9Lsa/Co9NqYPMMuD2o085l/4kyWjHMRm53BxSgC0IqZY4865xvl/DoXOETdCz3YKmu+qq33XeMftrUMe3IQ7uUDzGw+XzBRoOedorNetBujorHwa3AnxQvqk6VOLRsgVVkt1V1BtRQk/y6DwPs8vnfGrXuy+RcLx2HV35DxdnRcNzULRN6HwWHgSrsAtmHYuN7P+KS2xw/257GFRQGGugA5k2klNJAxFiZ17NJwoyq7z7CQK47efvfBewRZvrkK6JX0BSs0cEKVAItM7aoYVJHWqMFDK8B";
    static RSAKey SignJWK;
    static RSAKey EncJWK;




    public JweToken() throws JOSEException {
//        SignJWK = new RSAKeyGenerator(2048)
//                .keyID(UUID.randomUUID().toString())
//                .keyUse(KeyUse.SIGNATURE)
//                .generate();
//
//        EncJWK = new RSAKeyGenerator(2048)
//                .keyID(UUID.randomUUID().toString())
//                .keyUse(KeyUse.ENCRYPTION)
//                .generate();

    }


    private static void setJWK() throws ParseException, JsonProcessingException, UnsupportedEncodingException, GeneralSecurityException {

        if(SignJWK == null || EncJWK == null) {

            AES256 priAes = new AES256(Api50Filter.PriKEY);

            ObjectMapper mapper = new ObjectMapper();
            Map<String, Object> s = mapper.readValue(priAes.decrypt(signKey), new HashMap<String, Object>().getClass());
            Map<String, Object> e = mapper.readValue(priAes.decrypt(encKey), new HashMap<String, Object>().getClass());
            SignJWK = RSAKey.parse(s);
            EncJWK = RSAKey.parse(e);
        }

    }
    public static String createJWT(Map<String, Object> claimMap, int expMinute) throws JOSEException, ParseException, GeneralSecurityException, UnsupportedEncodingException, JsonProcessingException {
        return createJWT("HRTONG", claimMap, "ISU", expMinute);

    }
    public static String createJWT(String sub, Map<String, Object> claimMap, String issuer, int expMinute) throws JOSEException, ParseException, GeneralSecurityException, UnsupportedEncodingException, JsonProcessingException {
        setJWK();
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.add(Calendar.MINUTE, expMinute);
        //SignJWK = {"p":"z59F6GTMs3LRoaIHcC_V9PaNGYMIbl94qgrvf-R5c_tzPyljUj05NpOw6JwNrC7l2rziBOwWhKSUWJ-3JER3UZx98PdKI8bcOVk-0bA401cpVN0k47kqj8o_067FXb64x1viJrlYJDBjSpIFwRZnSPYvMFZqy7XZfJt3pwL8KiE","kty":"RSA","q":"xWZPBWndKZHCItfMv73W-B5sBRkJxZo1AfZNUoAmZph7D7EWTmQuLgCE9ccxcsR2sxhm_8laKPpmqR1kCOM3J3SevRMhMVNczmuT9QM-ayraEMJz1qPM_kYejai7GB_DmFZRkQ869P2FKtycgjcX47CstE2qawJUcVElgoiiVZk","d":"IAIoDtHV6NcHQHp9sfJLCocQGf6ql4mmr4M5IAJvW8JqbM2MgIoJDuM9QrETrDdawxbwKUHo6Fq_bYzYgsLk4LzstaoUhWphN3FYfa6rONvviz9JJfKzPVVXUoqihmgd_UUxnME6xAuypSf2NgNscKfxk6pelpqWbQibt4LD-ZsANaCTrXz04BQFdL6cnpD9U8ab2FW9bOX1KPh45Sg2TphUQVAkojZE36tRfzXWbB7db9oZK4EAetbzADpC01vAw4uGkn2ty7VtXG2321-KiIuz3ChEBN60P3O1O7F7DBUTZ8MN5YqMLHHKMj1kgLwW3LUfg322VSwshfQhWJDtAQ","e":"AQAB","use":"sig","kid":"26dac6fb-cd5b-4748-b809-5de910d10ba5","qi":"zv205WjOy-RssQmerWgEXsee7UgKLyxaxOJHEbtHSgdnGmbAXxd3p7SXFMol9AJCj6DiN3nNwouY7ZiMRVoR7cnYv-XUUzV87k5pv5wXH78j-eecqK67q6VoyN1d_3nixp4QL9oKsy41T45nUzQENpo3Owgj4-AS0JyD4LBJn04","dp":"zyTPcJ8xBFCoCiVIWou_YdmiyTNMdCJYlv62GNlwu2DCiN_YMjLXJDaSKGGZ2pInzebpcZPCm7BAOXOQG2UbzpbdqE5w7-T1z1nVLQwuhdzOZdcFeRZC-pcEu0QBshgY7v4jUhNVdzW3uqyZhR2_CrJkPkvZ3UifpozOAhkeUUE","dq":"kq1PwE0GahIFeBBz8nGkX19zkmIlcbAA_UE_-TKB1jAtGN7UHVGxQrteEKZ_ZrD3JmLWfe_mz5YoXDcbksMKw4WTQhkJy_YOes9S9HcBlW4U9OkYXAAAnVwK7eXXh7hqhTJ2j1wKyenrXorovJUlailoWt1u6O6lQkIypgjS3tk","n":"oBiKWDq0di5iQ5hCW6F1LrdaL6_AWcyU5ghp4Nk-qRy-R7PARTZdckfcosEJqEHwTO7P2AcTZ-nNF1BH4-64x1Fc6ZEb1ML1JzkHWL4UHUoxGfFGxPlmZZE8MVnVs7z0ev4BP9hyW8HYWwSANGR4gkibHsVBczxVGRY6k2aA1m4M_pBI83cNqr3hmgwrVzCgWoGA5tpDMB4Ng-CzKjWZLpotM-z00xX7VESVbOeV7umgMWA_uUrab91JgOCLnIbzb6Pht73OTRpRmSiXKwYKwTPCnoZEuv7iQQ4nL7zEhMCgu7nMEzdxPBdwfWBqnVuvuZhbNOE4ksFkf_qEs5QiuQ"};

        SignedJWT signedJWT = new SignedJWT(
                new JWSHeader.Builder(JWSAlgorithm.RS256).keyID(SignJWK.getKeyID()).build(),
                new JWTClaimsSet.Builder(JWTClaimsSet.parse(claimMap))
                        .subject(sub)
                        .issueTime(new Date())
                        .issuer(issuer)
                        .expirationTime(calendar.getTime())
                        .build()
        );

        // Sign the JWT
        signedJWT.sign(new RSASSASigner(SignJWK));

        // Create JWE object with signed JWT as payload
        JWEObject jweObject = new JWEObject(
                new JWEHeader.Builder(JWEAlgorithm.RSA_OAEP_256, EncryptionMethod.A256GCM)
                        .contentType("JWT") // required to indicate nested JWT
                        .build(),
                new Payload(signedJWT));

        // Encrypt with the recipient's public key
        jweObject.encrypt(new RSAEncrypter(EncJWK.toPublicJWK()));

        // Serialise to JWE compact form
        String jweString = jweObject.serialize();
        return jweString;
    }

    public static boolean verifyToken(JWEObject jweObject) throws  JOSEException {
        SignedJWT signedJWT = jweObject.getPayload().toSignedJWT();

        return signedJWT.verify(new RSASSAVerifier(SignJWK.toPublicJWK()));
    }

    public static SignedJWT decodeJWT(String jwt) throws ParseException, JOSEException, GeneralSecurityException, UnsupportedEncodingException, JsonProcessingException {
        setJWK();
        JWEObject jweObject = JWEObject.parse(jwt);
        jweObject.decrypt(new RSADecrypter(EncJWK));

        if(verifyToken(jweObject)) {
            // Decrypt with private key
            // Extract payload
            SignedJWT signedJWT = jweObject.getPayload().toSignedJWT();
            return signedJWT;
        }
        return null;
    }

  /*  public static void main(String[] args) throws Exception {
        Map<String, Object> cMap = new HashMap<>();
        cMap.put("ts","hr50");
        cMap.put("ek","www@www");
        //JweToken jwe = new JweToken();

        ObjectMapper mapper = new ObjectMapper();
        Map<String,Object> s = mapper.readValue("{\"p\":\"_XfeaRDwFUczhAXyZVBN6fovTYDBGVRIpnkj0tNAkYEdLwWOd4ZPASeF-sFI_aT64LoxYOIEMhLhh827jZk-pAVCtgem5beXzDxGzJyxqta0s2MIzhfxsjN2lnPAXzb9L7FwCpHbr31FyHBF2ZQ20UQWWslWuWSH8tmn-6p5Les\",\"kty\":\"RSA\",\"q\":\"1vT2-33CzsYdGPAem9LhrcO3_FA_lezsFkFRBgJ5NZOGeLSHh4teEMEw3ousZxbQ6MyQYo3DCysxWF0udF57CKYE05bViC1XuQVjktR_o5ebPpgdl6pTrCN0Q_wdNjacXJW7ZpXD8U9qiXV5GUcGC1tqjP1j7es8463LfiL8wD8\",\"d\":\"bO1tpi0psJx6nLj92jBacs2LeevY11G56OQTEN1IHdhXUZrG6LP2HHQS-JpBlmrECMF9ijiCA2kH1x8zGN8oVwk0awIkZEKtbJO3N83JSdSgeGqBUvM_TF5qSBcPEP6TA9jpAizi8hOPggVaVpNjFVkzky3hYoo8EnF0QebEnD7AryK02WS1AWOSxrAowd0MIj3ZWaHnZdOG6RZNuy-eUCf6ni5pIhlDVI4dyNpWO_fo-YUC6YrkTf-5p3HBnzlTwAcLZPohVICkr6WIB4lydix3QuJnFA6XpBI5unIgB6W3-VmCa_RIhJNro0F6rN-VQ8-3sqqj516NEJykoey8CQ\",\"e\":\"AQAB\",\"use\":\"sig\",\"kid\":\"689dad71-37fd-470b-9262-c1d162cdf42b\",\"qi\":\"8_QJkpZ77YOby5q0QqfaqatxNGBjh5L6HK14vGzyGxVzTRUuhvzFxjrjMfoQy3toDCCTxrgsFf5a9N95y_UkTQZHOfFbBv3caJzIfi21san-zsnLzeDKA6lkRSFJa6NF8hcECTCm5_baD7Fiuz0DLl0VizHwU5Vyz3kyT7asKDM\",\"dp\":\"vPYSL03bTmGofDJaxUEa9OX5QdRNIO7-wmzpUhD_v_n7ocSIs37Dg17NuWVDXyURi1wD1_BnpFUDIdU0j5nBY1Iwq7gEqpk2Z6JAPeZLZctvJ5UbSVn8bBeFvyBIODOsiVPE7XxTxP6leYqJ6G1geJ5D9CbJqqjR2TB-1VX_xUU\",\"dq\":\"meNJpgYEnw-J6T6OSzQPyNyjLQkuXGD_K3ebT9gZelehH2zu0gTeVNRZ7hjEVhEpgmBgxY2Dos1LSF19UmYJYsmoDuqe-Byt_pFzFbz3m-B_jbJNDTUtLcE8DSfCqfsyub2gKfLyEiGuvbXR-ly0YRETGNiW389XChBz7FuT4vU\",\"n\":\"1NS-tgERRxKSJqWESmpttuIdRevXa7XS_WepF2cuC9Fzy7CBtpmU8DfNazYo4iFTYtGBuvWTf-yMIPbAXPJ4PVBVJY4H9LJ8GCBju_VyAdiqc2QxntyG_u3mvb9Nh00hnZMEtbEfNTc5PQyQvKazTUFqSgstiXvkEjzF6fNhVXfJBZCgWVietNTR2sANiEfkypKk1ZdxsO77_Sfzc8Dm_zHpE0Dec-vJhg5REqY5oQ3IWL_vW06iOTwxoKy-jVbgC1RTI_Ro_80ERi957yKywt5-3e5oQB-xjRMapPRFMkumjmeok20q3357rm-iUum3qci0oMjHC-QxyfDWP5aM1Q\"}",new HashMap<String,Object>().getClass());
        Map<String,Object> e = mapper.readValue("{\"p\":\"2TVhOXHQVjQFVC73LLUrDJVxwv2HuCwUFKCYl7Sw-bDqFje8D4_47BDCCzLZOq6Jz1X-YEIoM2zEVWrku0nTp9u4yAoc7XpGGtIfofU_lZVleBqWvRNt41HY_xLJraeArdwDh1bRwoybWH5AdiGahWbFXrP4wMxgWcrrSQWNchM\",\"kty\":\"RSA\",\"q\":\"ufcThdrgXtwaYxJZ9OuqEfW7zWdpoSVi7HztAgkFezbaYBkHHakwlJQ8_TlfvBu_19XV5Xhv5a5AafI00NnA3GZREKcldi3tGnycyngZItoKSzUMOcE61qIUy8fvi04MfGQK4hT2tu5erneMsmq0e6Bwz1eACaLwYyNouBhjGvs\",\"d\":\"kf0izBDdv6babs4SYIZMZw4oQTqqTNjPX1fzQKZphtZJbFzXZs9ddEqJN2ay7cYJrkTMGst7fymIElv1SMxtzpFR5iQNqtxRTxUXIjUt1BFNzU_6r6K-XS_VdkMl1LVvQIzFCmkGGhDp69t83T7WBO4ZTc2UPWfWYvRQJYn2H5ezixXs6lO8oSspyq7PyTunce0WjWkWGRTsntREshIzRzIqUiH0nsa1fa9SqvCEfXqrdL0DxDqt9zFzE03d9vtHiC8a9NhbYr7vhjpM7IXncPBcIJZKcBaXthlzx1kpehFyGnsoOnzLT-54jOl-hMaomz-uw6uy7n7Mxrlzn9okxQ\",\"e\":\"AQAB\",\"use\":\"enc\",\"kid\":\"f643b9d1-a66b-4d48-bb08-2737ffee967c\",\"qi\":\"k8AsEIGB4V0IBpif4m1Tt52t2Hp-bRjlFy0UBy6nZuh9OOWQF5AMPibM4qz11AgepsGCByfHGqRhjtPLW98E89-fxki0oN9ncZOyaJEianqtGCw_m4jiyfiow_t75WAD6OOPEB1fak8TGeBVCyzEMD6lxNUOH0aqh3xgh5NwPmw\",\"dp\":\"xoCvEqV95VnzSMUHJTeIWR62caHrh5fY3iUKbxI17msM8zMKThqgPXTvMPbOaX-a9_251FSBksWjBAEFelf082GtFDuRxkHJkbdYK1YLPvPiYInEGpWIBogFTM7puybqRXldTDE-z5JaYdw3ov4Azktmsq689c2RfF4i-n_1jTs\",\"dq\":\"KYN0gj8YM1TjNxaTqk8pihTXNcVOGUElUjGZHwkwhg76tNUhd4ebZq-o5cZ3DqELNH1x4GYAZL9_dacyDyVtHkZg9ly5yiX6dh03SyOASP1vqtZOwl3Waq-IAO3DFc_4jZQvscSIRtHzpPLfH70eSTLJvB-GX6BWFWuEJwSaqx0\",\"n\":\"nck2U9pU-JWy0r-If70uOOVciTjnfXlD1UFTvinDY1XCahrBznj5TpKdOKK8ky12dkf-ErfJXRVWk7BOlIX2MVDfFHrfK6qePZtaJWX-5i4EfqEL5lZUCizsVLFaBZQDdBI-vdkix6nsyzqJ9uv5AfSI0jWZyOwRWul0rbISXyHL7VDsx0HkYYqSEHOc9yVP2DdbRMq5sw2KmlYFx42rv6_mVb7Par_DaRIRA-scXVXR8cbOjBenSuIjUavH1Lz8NO2YLrM6Pb03nhsg7ERkYcYaqkB10A6yHJCYO88OoLI831oQ54IyZWGKWHhnBz7JCaUHVyZ-Hx_hNzk1tJ3GoQ\"}",new HashMap<String,Object>().getClass());
        RSAKey SignJWK = RSAKey.parse(s);
        RSAKey EncJWK = RSAKey.parse(e);

        AES256 aes256 = new AES256(Api50Filter.PriKEY);

        System.out.println(aes256.encrypt("{\"p\":\"_XfeaRDwFUczhAXyZVBN6fovTYDBGVRIpnkj0tNAkYEdLwWOd4ZPASeF-sFI_aT64LoxYOIEMhLhh827jZk-pAVCtgem5beXzDxGzJyxqta0s2MIzhfxsjN2lnPAXzb9L7FwCpHbr31FyHBF2ZQ20UQWWslWuWSH8tmn-6p5Les\",\"kty\":\"RSA\",\"q\":\"1vT2-33CzsYdGPAem9LhrcO3_FA_lezsFkFRBgJ5NZOGeLSHh4teEMEw3ousZxbQ6MyQYo3DCysxWF0udF57CKYE05bViC1XuQVjktR_o5ebPpgdl6pTrCN0Q_wdNjacXJW7ZpXD8U9qiXV5GUcGC1tqjP1j7es8463LfiL8wD8\",\"d\":\"bO1tpi0psJx6nLj92jBacs2LeevY11G56OQTEN1IHdhXUZrG6LP2HHQS-JpBlmrECMF9ijiCA2kH1x8zGN8oVwk0awIkZEKtbJO3N83JSdSgeGqBUvM_TF5qSBcPEP6TA9jpAizi8hOPggVaVpNjFVkzky3hYoo8EnF0QebEnD7AryK02WS1AWOSxrAowd0MIj3ZWaHnZdOG6RZNuy-eUCf6ni5pIhlDVI4dyNpWO_fo-YUC6YrkTf-5p3HBnzlTwAcLZPohVICkr6WIB4lydix3QuJnFA6XpBI5unIgB6W3-VmCa_RIhJNro0F6rN-VQ8-3sqqj516NEJykoey8CQ\",\"e\":\"AQAB\",\"use\":\"sig\",\"kid\":\"689dad71-37fd-470b-9262-c1d162cdf42b\",\"qi\":\"8_QJkpZ77YOby5q0QqfaqatxNGBjh5L6HK14vGzyGxVzTRUuhvzFxjrjMfoQy3toDCCTxrgsFf5a9N95y_UkTQZHOfFbBv3caJzIfi21san-zsnLzeDKA6lkRSFJa6NF8hcECTCm5_baD7Fiuz0DLl0VizHwU5Vyz3kyT7asKDM\",\"dp\":\"vPYSL03bTmGofDJaxUEa9OX5QdRNIO7-wmzpUhD_v_n7ocSIs37Dg17NuWVDXyURi1wD1_BnpFUDIdU0j5nBY1Iwq7gEqpk2Z6JAPeZLZctvJ5UbSVn8bBeFvyBIODOsiVPE7XxTxP6leYqJ6G1geJ5D9CbJqqjR2TB-1VX_xUU\",\"dq\":\"meNJpgYEnw-J6T6OSzQPyNyjLQkuXGD_K3ebT9gZelehH2zu0gTeVNRZ7hjEVhEpgmBgxY2Dos1LSF19UmYJYsmoDuqe-Byt_pFzFbz3m-B_jbJNDTUtLcE8DSfCqfsyub2gKfLyEiGuvbXR-ly0YRETGNiW389XChBz7FuT4vU\",\"n\":\"1NS-tgERRxKSJqWESmpttuIdRevXa7XS_WepF2cuC9Fzy7CBtpmU8DfNazYo4iFTYtGBuvWTf-yMIPbAXPJ4PVBVJY4H9LJ8GCBju_VyAdiqc2QxntyG_u3mvb9Nh00hnZMEtbEfNTc5PQyQvKazTUFqSgstiXvkEjzF6fNhVXfJBZCgWVietNTR2sANiEfkypKk1ZdxsO77_Sfzc8Dm_zHpE0Dec-vJhg5REqY5oQ3IWL_vW06iOTwxoKy-jVbgC1RTI_Ro_80ERi957yKywt5-3e5oQB-xjRMapPRFMkumjmeok20q3357rm-iUum3qci0oMjHC-QxyfDWP5aM1Q\"}"));
        System.out.println(aes256.encrypt("{\"p\":\"2TVhOXHQVjQFVC73LLUrDJVxwv2HuCwUFKCYl7Sw-bDqFje8D4_47BDCCzLZOq6Jz1X-YEIoM2zEVWrku0nTp9u4yAoc7XpGGtIfofU_lZVleBqWvRNt41HY_xLJraeArdwDh1bRwoybWH5AdiGahWbFXrP4wMxgWcrrSQWNchM\",\"kty\":\"RSA\",\"q\":\"ufcThdrgXtwaYxJZ9OuqEfW7zWdpoSVi7HztAgkFezbaYBkHHakwlJQ8_TlfvBu_19XV5Xhv5a5AafI00NnA3GZREKcldi3tGnycyngZItoKSzUMOcE61qIUy8fvi04MfGQK4hT2tu5erneMsmq0e6Bwz1eACaLwYyNouBhjGvs\",\"d\":\"kf0izBDdv6babs4SYIZMZw4oQTqqTNjPX1fzQKZphtZJbFzXZs9ddEqJN2ay7cYJrkTMGst7fymIElv1SMxtzpFR5iQNqtxRTxUXIjUt1BFNzU_6r6K-XS_VdkMl1LVvQIzFCmkGGhDp69t83T7WBO4ZTc2UPWfWYvRQJYn2H5ezixXs6lO8oSspyq7PyTunce0WjWkWGRTsntREshIzRzIqUiH0nsa1fa9SqvCEfXqrdL0DxDqt9zFzE03d9vtHiC8a9NhbYr7vhjpM7IXncPBcIJZKcBaXthlzx1kpehFyGnsoOnzLT-54jOl-hMaomz-uw6uy7n7Mxrlzn9okxQ\",\"e\":\"AQAB\",\"use\":\"enc\",\"kid\":\"f643b9d1-a66b-4d48-bb08-2737ffee967c\",\"qi\":\"k8AsEIGB4V0IBpif4m1Tt52t2Hp-bRjlFy0UBy6nZuh9OOWQF5AMPibM4qz11AgepsGCByfHGqRhjtPLW98E89-fxki0oN9ncZOyaJEianqtGCw_m4jiyfiow_t75WAD6OOPEB1fak8TGeBVCyzEMD6lxNUOH0aqh3xgh5NwPmw\",\"dp\":\"xoCvEqV95VnzSMUHJTeIWR62caHrh5fY3iUKbxI17msM8zMKThqgPXTvMPbOaX-a9_251FSBksWjBAEFelf082GtFDuRxkHJkbdYK1YLPvPiYInEGpWIBogFTM7puybqRXldTDE-z5JaYdw3ov4Azktmsq689c2RfF4i-n_1jTs\",\"dq\":\"KYN0gj8YM1TjNxaTqk8pihTXNcVOGUElUjGZHwkwhg76tNUhd4ebZq-o5cZ3DqELNH1x4GYAZL9_dacyDyVtHkZg9ly5yiX6dh03SyOASP1vqtZOwl3Waq-IAO3DFc_4jZQvscSIRtHzpPLfH70eSTLJvB-GX6BWFWuEJwSaqx0\",\"n\":\"nck2U9pU-JWy0r-If70uOOVciTjnfXlD1UFTvinDY1XCahrBznj5TpKdOKK8ky12dkf-ErfJXRVWk7BOlIX2MVDfFHrfK6qePZtaJWX-5i4EfqEL5lZUCizsVLFaBZQDdBI-vdkix6nsyzqJ9uv5AfSI0jWZyOwRWul0rbISXyHL7VDsx0HkYYqSEHOc9yVP2DdbRMq5sw2KmlYFx42rv6_mVb7Par_DaRIRA-scXVXR8cbOjBenSuIjUavH1Lz8NO2YLrM6Pb03nhsg7ERkYcYaqkB10A6yHJCYO88OoLI831oQ54IyZWGKWHhnBz7JCaUHVyZ-Hx_hNzk1tJ3GoQ\"}"));

        System.out.println(aes256.encrypt("com.isu.hrAdapter"));
        String jwt = JweToken.createJWT(cMap,60000);

        System.out.println(jwt);

        SignedJWT sToken = JweToken.decodeJWT(jwt);
        System.out.println(sToken.getPayload().toJSONObject().get("ts"));
        System.out.println(sToken.getPayload().toJSONObject().get("ek"));







//
//        System.out.println(jwe.SignJWK.getModulus());
//        System.out.println(jwe.SignJWK.getPublicExponent());
//        System.out.println(jwe.SignJWK.getPrivateExponent());
//

        //JSONObject o = (JSONObject) JSONObject.stringToValue({p=4VKY2PSzPn-OtnzKuvcvha3nAOUtCAzBdIqQuuuiR059QwLZN4WbjBPno64so8SyHWBjqXVtcngVHrf84esGjqQGmqY0-bsR_jh9VeUt5ryEu7-d-q2DnX6lDkBQYLxP6aZfZXBN4lomBMIdOVXn3CrOtOheYeTUY8yW9JaOCXM, kty=RSA, q=nlEary2bzBS9vRwLH6OG9Wqp9tg26Xg8v7IkCMe_nORoQML4_TCHEfndrQNgXpln1AVSHyimegXQxG8YrWBi8s0D1SrW2G9FQXbZBI8mw3SkIQEpw8q3h7O7Q3mYrFho1DnC1cUz5kgVouP_OhVEIzXDeuyBSTyw-lmaNXWzVeU, d=Krr5Hne0TMEooud9N2zy2pmB0dYrK0VTSwZOC-ek4OzmIZM7dROxb2fdyPvplJIO-Jcf0s7eEP2jlwub84PR8szuAMkIrkH05NxcbEXgfJPwQBqebD7GP99KNodxmG067yHG2L6xJ8m_0u3yp3ZqSXNC3m5pKGNKP4FYHo4iETVORuQahx4DuHnh2EFtf5EmuKw_fIG_MhBX20tNYnJCIjAlQerEXkwCYL-eB8XPWITt_raWmn7QsVKisORKzLd9UfiSeYIwhtRou0iMLmNdoE1AJZX_N0SKlOuFQzV6zV9hv9rbTBsLXWhGCx3hbsXp9gL6gHDrxY0wYBn23AV3iQ, e=AQAB, use=enc, kid=d5e76161-e5e0-4b31-9d34-a5b64952e777, qi=lt8R17TTh82sa2ZJbuF5c0fgyfXnxLvylcyArtK6r9ab-D7yFjIMWiqkVt2olsrhBQE4e4XtxhQZIBc2RUhDe_3bwBUE0LfL1L0Bivp3W7cITG2mefNt9iefjB3j7a4apvOYgu7vlMm83rSfItkXMchCSxLjBiYYpDiQhpVIUuE, dp=OOyyGtWvVxHIz0e1vAho5B_sJWjAuLDoSvYa3G5dYCBvOvfEQuepRXld4xdExdcSnKNWamB1Vx8JTupyo-zJik3cMUPeTF07jXteBs5Qi2ODMR-W3NbrUmXFc1VCOT45_jB_F1SJCK93vWoBEhQm8JOMB15RQfAazF_Kn15N4gs, dq=KEWbUxp3-jcAeP2MOtUfPIiQibFAbq1eTqkjD3S4YlGbz3WJXuacRU9ZO2yTdBzz03QzCqgNiRa3n3BfR6MwKHFMW0pVcqMDa_6uf8Fma-vc4GRqWlrTytpGdYiV9KlcqTe0Pyq15AtMLa5vuzezqH1Bp6BH1vhwUI7Acn7pSp0, n=i1hc9NbNN_O88mJqwgfZrXyFfPl6ZPgsVV3OHqtw4XAsaVZDfbPiBzn2GbozpZrgz_cjtFF8G06W59nS0bGToZHtMduc4zuD0BG_eevbmZcStoY3cp76skc7s6SKigq3qg0yT1PnxyxwTwzsio3zl1zNT4p_V2cSsnUPOIxVCDBES2rkG1XKX0bwoxsYgxQ2W7jG1awjzr3McQYlFMl5Jwpy0ae9hVB_DwGdeMZII5XhMJLcCBczLYyrQ5rZOjGZGjCyAWIpOzsavXr0xvHuWZoV1_p3EAQ93SVoRPhgFNArOTG_lYgycXDoCGX1FtysXH55gIOMYwu-CJE5AJqi3w}");
    //    "{\"p\":\"7WgdjKinMjFZKOICgoFEqIkuD-_11e9iln40nGMYM_zTyCmE1hF3ruKspTYebapPS8Sa8Ql9G_6oMhGgrrFtc9zCktIVgyPRnKmtV7hDCeVRt1PRA5B4cCWDjCvKzSA__KJ2pTbnEtpZqFSTNQS54gQvXXJetklOeO0P3hibXZ0\",\"kty\":\"RSA\",\"q\":\"orykArGpQ-xuwKNDKOwhVE8i6viOOQIv4E_1U4VGx9Ea-hiEOYK25rN1eRGirxrBFifxIirqnlLwWMmredkOriBBPxpv2HElNlOyRcfUPrwkUyV8WGeCjQ340nWu2sH1u9MG-ZHViWYi2gckrwR5kNRFp-XK6Z5evzgYWwUmNMk\",\"d\":\"WuqCdC0ZLgQk80DsnsbIn9hiv6qb3I-vQBA5orimEPeuYvUBktImBKK8zGSBbD85ZzsDfGZccoS2vRcOzrKrA8Tjw8VOJFvuLLV7SMoZoLwFgH24WLG6ls9-ZQy1xZdKSpCw1KksiZbcrhyQETDAk_fQP2isUxQzVAwNDMzOskkjrN654zgPcHkXRd3Du4n4ROLJ2DDFh-ufmcvzrQ8TEEkcd_CbabFTtpKmqLXTAHlj8yHyso1l_RdMgJffERollRg8PnuBdfkFeaGfiEW4WjZFzbn18C1JilF6k4XCxTQCBhskpG_DMDGfrlg3RvHbPpfI0hkn8CWYmpCXi7p64Q\",\"e\":\"AQAB\",\"use\":\"enc\",\"kid\":\"8735eeba-67b4-40df-97f9-588d9e9bbec9\",\"qi\":\"kv68GMyJf4317z8i-FG9e2F0TG1dbz3cgbT6lCQ5ctHEQAtzOJXcUWFIETRYWejEhu2ryuSHpUympEvSoc3Up_H0xL-5dAdEaS3fzlwsAdUIyvFFOgaWh7cbFkjQa75FbN1rN0ep39tJ_uI7o8AYapPOC-qQSabzMIEwafNnwnI\",\"dp\":\"QHC7XJvGzmQAvI0ke0IVXd3mh-LtisVwsELPiweG4U2mOrWyXdzd7LWQgUPAXKoW3g0etYCK2hd0liqcv-5fNEze77Vgq3kEg463A5F7eOsrFCUHHf2QA3jbTSfx4132oF-E7vGJJV_paDyUvJZs0kGqjaXmuXoKd955KSLqwS0\",\"dq\":\"m6_xEIq7LrpA8pa-p6XP9QKIm1cTaULIXsbgIvk8T-mi72UJCqQdKvTBDARtKSxlUTcBH_kC4Fjki2zUWgvoWXmOMjquidklCqZjxRJ54VLJRap1HXZZlWyqgV4I3Ev3Naub3qNAMOS_rupqk-2qB36s7QWQbJQQfMvDsUBp3tE\",\"n\":\"lurTQeiF9NfJArqgHgEzwQG43pH0aflEq_tRBn4R0N8nV-bEZzm_I0j5qMwApz4v4bwaUl-YNS1qoVmNOrKLkTl3QQKmxQpOhugXzGvVdN_Le1sF74fiH-cH66-W0P2OAg4rnvwFIJ4mU9kOtf0r4f51SvtjV35pKUfK_cMVtaHOHnTETu8vKffQt_B8KPTZ7vjl3fuuq_dKCqbA1T3A07yxeIqfYR4kqH4BpGjDpA5Kd8LEf0CMNpdhDYAEKIfPAzFwJdociIY0RoCOQWds1nDE-G2011CY45hPIJD-fEchxLpWBeDVs3Y2WeBMI8RvXdEB6DNxHGi4JkET105kRQ\"}"

        //System.out.println(jwe.SignJWK.toString());
        //System.out.println(jwe.EncJWK.toString());
        //{"p":"_XfeaRDwFUczhAXyZVBN6fovTYDBGVRIpnkj0tNAkYEdLwWOd4ZPASeF-sFI_aT64LoxYOIEMhLhh827jZk-pAVCtgem5beXzDxGzJyxqta0s2MIzhfxsjN2lnPAXzb9L7FwCpHbr31FyHBF2ZQ20UQWWslWuWSH8tmn-6p5Les","kty":"RSA","q":"1vT2-33CzsYdGPAem9LhrcO3_FA_lezsFkFRBgJ5NZOGeLSHh4teEMEw3ousZxbQ6MyQYo3DCysxWF0udF57CKYE05bViC1XuQVjktR_o5ebPpgdl6pTrCN0Q_wdNjacXJW7ZpXD8U9qiXV5GUcGC1tqjP1j7es8463LfiL8wD8","d":"bO1tpi0psJx6nLj92jBacs2LeevY11G56OQTEN1IHdhXUZrG6LP2HHQS-JpBlmrECMF9ijiCA2kH1x8zGN8oVwk0awIkZEKtbJO3N83JSdSgeGqBUvM_TF5qSBcPEP6TA9jpAizi8hOPggVaVpNjFVkzky3hYoo8EnF0QebEnD7AryK02WS1AWOSxrAowd0MIj3ZWaHnZdOG6RZNuy-eUCf6ni5pIhlDVI4dyNpWO_fo-YUC6YrkTf-5p3HBnzlTwAcLZPohVICkr6WIB4lydix3QuJnFA6XpBI5unIgB6W3-VmCa_RIhJNro0F6rN-VQ8-3sqqj516NEJykoey8CQ","e":"AQAB","use":"sig","kid":"689dad71-37fd-470b-9262-c1d162cdf42b","qi":"8_QJkpZ77YOby5q0QqfaqatxNGBjh5L6HK14vGzyGxVzTRUuhvzFxjrjMfoQy3toDCCTxrgsFf5a9N95y_UkTQZHOfFbBv3caJzIfi21san-zsnLzeDKA6lkRSFJa6NF8hcECTCm5_baD7Fiuz0DLl0VizHwU5Vyz3kyT7asKDM","dp":"vPYSL03bTmGofDJaxUEa9OX5QdRNIO7-wmzpUhD_v_n7ocSIs37Dg17NuWVDXyURi1wD1_BnpFUDIdU0j5nBY1Iwq7gEqpk2Z6JAPeZLZctvJ5UbSVn8bBeFvyBIODOsiVPE7XxTxP6leYqJ6G1geJ5D9CbJqqjR2TB-1VX_xUU","dq":"meNJpgYEnw-J6T6OSzQPyNyjLQkuXGD_K3ebT9gZelehH2zu0gTeVNRZ7hjEVhEpgmBgxY2Dos1LSF19UmYJYsmoDuqe-Byt_pFzFbz3m-B_jbJNDTUtLcE8DSfCqfsyub2gKfLyEiGuvbXR-ly0YRETGNiW389XChBz7FuT4vU","n":"1NS-tgERRxKSJqWESmpttuIdRevXa7XS_WepF2cuC9Fzy7CBtpmU8DfNazYo4iFTYtGBuvWTf-yMIPbAXPJ4PVBVJY4H9LJ8GCBju_VyAdiqc2QxntyG_u3mvb9Nh00hnZMEtbEfNTc5PQyQvKazTUFqSgstiXvkEjzF6fNhVXfJBZCgWVietNTR2sANiEfkypKk1ZdxsO77_Sfzc8Dm_zHpE0Dec-vJhg5REqY5oQ3IWL_vW06iOTwxoKy-jVbgC1RTI_Ro_80ERi957yKywt5-3e5oQB-xjRMapPRFMkumjmeok20q3357rm-iUum3qci0oMjHC-QxyfDWP5aM1Q"}
        //{"p":"2TVhOXHQVjQFVC73LLUrDJVxwv2HuCwUFKCYl7Sw-bDqFje8D4_47BDCCzLZOq6Jz1X-YEIoM2zEVWrku0nTp9u4yAoc7XpGGtIfofU_lZVleBqWvRNt41HY_xLJraeArdwDh1bRwoybWH5AdiGahWbFXrP4wMxgWcrrSQWNchM","kty":"RSA","q":"ufcThdrgXtwaYxJZ9OuqEfW7zWdpoSVi7HztAgkFezbaYBkHHakwlJQ8_TlfvBu_19XV5Xhv5a5AafI00NnA3GZREKcldi3tGnycyngZItoKSzUMOcE61qIUy8fvi04MfGQK4hT2tu5erneMsmq0e6Bwz1eACaLwYyNouBhjGvs","d":"kf0izBDdv6babs4SYIZMZw4oQTqqTNjPX1fzQKZphtZJbFzXZs9ddEqJN2ay7cYJrkTMGst7fymIElv1SMxtzpFR5iQNqtxRTxUXIjUt1BFNzU_6r6K-XS_VdkMl1LVvQIzFCmkGGhDp69t83T7WBO4ZTc2UPWfWYvRQJYn2H5ezixXs6lO8oSspyq7PyTunce0WjWkWGRTsntREshIzRzIqUiH0nsa1fa9SqvCEfXqrdL0DxDqt9zFzE03d9vtHiC8a9NhbYr7vhjpM7IXncPBcIJZKcBaXthlzx1kpehFyGnsoOnzLT-54jOl-hMaomz-uw6uy7n7Mxrlzn9okxQ","e":"AQAB","use":"enc","kid":"f643b9d1-a66b-4d48-bb08-2737ffee967c","qi":"k8AsEIGB4V0IBpif4m1Tt52t2Hp-bRjlFy0UBy6nZuh9OOWQF5AMPibM4qz11AgepsGCByfHGqRhjtPLW98E89-fxki0oN9ncZOyaJEianqtGCw_m4jiyfiow_t75WAD6OOPEB1fak8TGeBVCyzEMD6lxNUOH0aqh3xgh5NwPmw","dp":"xoCvEqV95VnzSMUHJTeIWR62caHrh5fY3iUKbxI17msM8zMKThqgPXTvMPbOaX-a9_251FSBksWjBAEFelf082GtFDuRxkHJkbdYK1YLPvPiYInEGpWIBogFTM7puybqRXldTDE-z5JaYdw3ov4Azktmsq689c2RfF4i-n_1jTs","dq":"KYN0gj8YM1TjNxaTqk8pihTXNcVOGUElUjGZHwkwhg76tNUhd4ebZq-o5cZ3DqELNH1x4GYAZL9_dacyDyVtHkZg9ly5yiX6dh03SyOASP1vqtZOwl3Waq-IAO3DFc_4jZQvscSIRtHzpPLfH70eSTLJvB-GX6BWFWuEJwSaqx0","n":"nck2U9pU-JWy0r-If70uOOVciTjnfXlD1UFTvinDY1XCahrBznj5TpKdOKK8ky12dkf-ErfJXRVWk7BOlIX2MVDfFHrfK6qePZtaJWX-5i4EfqEL5lZUCizsVLFaBZQDdBI-vdkix6nsyzqJ9uv5AfSI0jWZyOwRWul0rbISXyHL7VDsx0HkYYqSEHOc9yVP2DdbRMq5sw2KmlYFx42rv6_mVb7Par_DaRIRA-scXVXR8cbOjBenSuIjUavH1Lz8NO2YLrM6Pb03nhsg7ERkYcYaqkB10A6yHJCYO88OoLI831oQ54IyZWGKWHhnBz7JCaUHVyZ-Hx_hNzk1tJ3GoQ"}
//        System.out.println(new String(jwe.EncJWK.toString()));

        //System.out.println(SignJWK);
        //System.out.println(EncJWK);
//      RSA
        //String j = jwe.createJWT("test",cMap,"tester", 60);
//        System.out.println(j);
//        SignedJWT sj = jwe.decodeJWT(j);
//        System.out.println(sj.getPayload().toString());

    }*/

    public void createEncryptionKey() throws Exception {
//        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
////        byte[] bytePrivateKey = Base64.getDecoder().decode("assss".getBytes());
////        PKCS8EncodedKeySpec privateKeySpec = new PKCS8EncodedKeySpec(bytePrivateKey);
////
////
////        RSAPrivateKeySpec privateKeySpec = keyFactory.getKeySpec(keyFactory.generatePrivate(privateKeySpec)), RSAPrivateKeySpec.class);
////        RSAPrivateKey privateRsaKey  = (RSAPrivateKey) keyFactory.generatePrivate(privateKeySpec);
////        RSADecrypter decrypter = new RSADecrypter(privateRsaKey);
////
////        EncryptedJWT jwt = EncryptedJWT.parse('토큰문자열');
////        jwt.decrypt(decrypter);
////
////// 클레임 객체 조회
////        jwt.getJWTClaimsSet().getClaims();

        JWSObject jwsObject = new JWSObject(new JWSHeader(JWSAlgorithm.HS256),
                new Payload("Hello, world!"));

// We need a 256-bit key for HS256 which must be pre-shared
        byte[] sharedKey = new byte[32];
        new SecureRandom().nextBytes(sharedKey);

// Apply the HMAC to the JWS object
        jwsObject.sign(new MACSigner(sharedKey));

// Output in URL-safe format
        System.out.println(jwsObject.serialize());

    }
}
