import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_belvpn/core/repository/servers_repository.dart';



class SelectedServerBloc extends Cubit<ServerInfo>{

  // todo ask client about default server
  static const ServerInfo initial = ServerInfo(
    country: 'Netherlands',
    config: 'client\ndev tun\nproto udp\nresolv-retry infinite\nnobind\npersist-key\npersist-tun\ncipher AES-256-GCM\nauth SHA512\nverb 3\ntls-client\ntls-version-min 1.2\nkey-direction 1\nremote-cert-tls server\n;remote localhost 1194\n;ca ca.crt\n;cert client.crt\n;key client.key\nremote 159.89.125.145 1194\n<ca>\n-----BEGIN CERTIFICATE-----\nMIIDSzCCAjOgAwIBAgIUaOXxqVyNKLY4sXzrxjT/8AFcIBwwDQYJKoZIhvcNAQEL\nBQAwFjEUMBIGA1UEAwwLRWFzeS1SU0EgQ0EwHhcNMjAxMjI5MTQwMjQ4WhcNMzAx\nMjI3MTQwMjQ4WjAWMRQwEgYDVQQDDAtFYXN5LVJTQSBDQTCCASIwDQYJKoZIhvcN\nAQEBBQADggEPADCCAQoCggEBANCKbpt+PfsWzWDZjWR9mbtkmSc4AsWx5sm++GrN\nYw/+FefFJBW/r3n+XxLUwPGThjobkJtBXggXLJTL6L7diBRfELuoR1OlEcxtMPDH\nzwmwgYk+HvgPvla50eDfw0ntsiwR+5EpCewpiWvCC4TeQ6EfUO/q2fTuphm8TywQ\n8zXwpFaTYKy4GE/Zn5Gc7h5/tyeH5uMlEgxd03RPmdCLGHpV2eqrc4uLxbjZZOy+\n3dFHiJ1kF0/CRWe36Aa1ZJtqwdgXdfsBHtSk0Wp1NWJvc2jwVrezjkZOPh97QmT9\nQQY6GWrbFPk3F1yBCzfuJw1hh6btRsRpGeubxc6iy+9cYLcCAwEAAaOBkDCBjTAd\nBgNVHQ4EFgQUBtASXnDLRhZaU4nIb+JPyxeOyd0wUQYDVR0jBEowSIAUBtASXnDL\nRhZaU4nIb+JPyxeOyd2hGqQYMBYxFDASBgNVBAMMC0Vhc3ktUlNBIENBghRo5fGp\nXI0otjixfOvGNP/wAVwgHDAMBgNVHRMEBTADAQH/MAsGA1UdDwQEAwIBBjANBgkq\nhkiG9w0BAQsFAAOCAQEAFRToUTDkMz3KLErawVmteBr1AfiuBrB2AImjQRCgkUs6\nUmCBctEjbOC2WOuJG7qpUzZhhi8Zfw6LFbP8VDiqxsyWdozXkVinavVd7SD7EBfP\nFQLKlzu7rTOGc0mmpFw7HfzY4enAT0ULGDOmK9r4OFu05UGEXcs/ZQ+Rxc9ig3kD\nE+8zf/gHUfEKISYAwaQUIBxgxrbs8LjZ0Yf1/h9R5VP5OkcFQ8phPD6RbyOrSx17\nLzgLGit4xP3/Kc4xo1cfsvcQFI1YKlxC/ufz1cmhY0NUd4uN00bDuIdZH6psmE6o\nsrpJRn6v6i4PIbCY7xjLX93plwPRwiH0rS/SHQTKaw==\n-----END CERTIFICATE-----\n</ca>\n<cert>\nCertificate:\n    Data:\n        Version: 3 (0x2)\n        Serial Number:\n            33:56:2a:9a:b7:bb:75:0a:d5:c4:8d:70:21:5b:94:56\n        Signature Algorithm: sha256WithRSAEncryption\n        Issuer: CN=Easy-RSA CA\n        Validity\n            Not Before: Dec 29 14:02:51 2020 GMT\n            Not After : Dec 14 14:02:51 2023 GMT\n        Subject: CN=ovpn_user\n        Subject Public Key Info:\n            Public Key Algorithm: rsaEncryption\n                RSA Public-Key: (2048 bit)\n                Modulus:\n                    00:d5:1e:a7:b4:21:60:c1:70:74:fd:ae:14:68:d9:\n                    1b:d2:55:39:2c:34:73:1e:c8:60:9a:2d:39:8a:41:\n                    9a:fe:b8:c7:c4:2e:9c:d1:21:dc:61:33:80:12:09:\n                    0d:f7:7c:c9:38:8f:11:ba:43:6f:27:4e:dc:36:74:\n                    ce:c2:c4:75:d6:59:7d:ba:a7:42:95:0a:ea:36:bd:\n                    cc:f3:9f:e1:32:0a:4b:d3:32:38:ad:50:7d:e5:a6:\n                    cb:39:32:25:4f:02:3b:69:79:bb:b5:a2:d3:e5:6f:\n                    be:d7:39:9d:b6:6b:54:6c:d9:4d:93:27:29:62:6e:\n                    a1:70:6c:a1:1d:9b:91:16:18:72:67:ad:fa:0d:e1:\n                    d9:69:ed:5a:90:9d:63:94:9f:1b:b1:9b:95:1b:0f:\n                    30:f4:01:fd:e7:bf:88:44:44:5c:2f:4a:e6:79:d6:\n                    7d:b9:1f:e7:01:ea:e3:d6:c1:cf:98:eb:b3:8c:c5:\n                    48:8a:f4:c4:90:87:2f:93:ab:da:f7:1a:97:a0:ac:\n                    35:70:24:99:e5:a2:3f:4f:f8:d4:70:e5:4b:a5:c9:\n                    a9:c9:7e:71:3f:02:e5:51:61:c4:23:6c:34:1d:de:\n                    52:32:1c:d0:e6:35:5b:c4:77:a1:91:90:a0:f2:48:\n                    b7:0c:b8:ce:a7:79:3c:11:3e:fd:9b:b2:6a:ac:da:\n                    3e:5d\n                Exponent: 65537 (0x10001)\n        X509v3 extensions:\n            X509v3 Basic Constraints: \n                CA:FALSE\n            X509v3 Subject Key Identifier: \n                BB:B1:B1:CF:02:D6:26:AB:AD:DA:24:14:22:DB:EF:DA:40:DE:12:32\n            X509v3 Authority Key Identifier: \n                keyid:06:D0:12:5E:70:CB:46:16:5A:53:89:C8:6F:E2:4F:CB:17:8E:C9:DD\n                DirName:/CN=Easy-RSA CA\n                serial:68:E5:F1:A9:5C:8D:28:B6:38:B1:7C:EB:C6:34:FF:F0:01:5C:20:1C\n            X509v3 Extended Key Usage: \n                TLS Web Client Authentication\n            X509v3 Key Usage: \n                Digital Signature\n    Signature Algorithm: sha256WithRSAEncryption\n         78:7a:32:13:fd:69:8d:42:13:4f:46:d5:97:28:77:70:13:60:\n         e7:b3:bf:0b:16:0f:b9:f9:e0:95:c1:36:d9:5c:32:7f:fd:22:\n         bf:dc:a3:7d:02:60:60:59:0b:9f:d1:b1:ef:d2:94:2c:56:5d:\n         3d:32:85:be:fe:d7:3d:df:00:f4:01:0d:31:a5:46:10:92:c7:\n         2f:c4:19:03:0d:e8:a9:d0:0d:01:9c:bc:a7:63:e4:09:4a:15:\n         01:15:9b:9b:9a:67:ea:d6:c3:7e:08:58:97:05:43:37:93:80:\n         7c:ca:b6:25:fb:19:1d:8b:b1:51:d1:9c:c9:4a:01:b3:ad:a7:\n         7c:ef:38:b0:38:da:dd:e6:63:c2:57:d1:d2:2c:40:2f:a7:d4:\n         1d:6b:d0:ec:c1:45:cc:3b:56:21:88:1d:5f:0c:0d:28:1e:9a:\n         d0:91:c6:d7:07:81:81:55:ca:15:0d:5c:f9:f2:64:e4:b2:be:\n         b9:a5:ac:46:63:a8:9b:c6:46:13:7c:e8:6d:51:e4:08:40:2d:\n         2b:49:eb:5d:b3:b5:8e:6e:1c:6d:17:2e:8c:7a:c6:d6:7e:0f:\n         1d:d7:37:89:30:f9:10:2d:a7:3d:ec:c1:21:a5:08:4d:d9:15:\n         54:73:cd:87:59:68:bd:77:62:d6:c2:ed:cc:b9:be:fb:d9:04:\n         57:39:71:9d\n-----BEGIN CERTIFICATE-----\nMIIDVzCCAj+gAwIBAgIQM1Yqmre7dQrVxI1wIVuUVjANBgkqhkiG9w0BAQsFADAW\nMRQwEgYDVQQDDAtFYXN5LVJTQSBDQTAeFw0yMDEyMjkxNDAyNTFaFw0yMzEyMTQx\nNDAyNTFaMBQxEjAQBgNVBAMMCW92cG5fdXNlcjCCASIwDQYJKoZIhvcNAQEBBQAD\nggEPADCCAQoCggEBANUep7QhYMFwdP2uFGjZG9JVOSw0cx7IYJotOYpBmv64x8Qu\nnNEh3GEzgBIJDfd8yTiPEbpDbydO3DZ0zsLEddZZfbqnQpUK6ja9zPOf4TIKS9My\nOK1QfeWmyzkyJU8CO2l5u7Wi0+Vvvtc5nbZrVGzZTZMnKWJuoXBsoR2bkRYYcmet\n+g3h2WntWpCdY5SfG7GblRsPMPQB/ee/iEREXC9K5nnWfbkf5wHq49bBz5jrs4zF\nSIr0xJCHL5Or2vcal6CsNXAkmeWiP0/41HDlS6XJqcl+cT8C5VFhxCNsNB3eUjIc\n0OY1W8R3oZGQoPJItwy4zqd5PBE+/ZuyaqzaPl0CAwEAAaOBojCBnzAJBgNVHRME\nAjAAMB0GA1UdDgQWBBS7sbHPAtYmq63aJBQi2+/aQN4SMjBRBgNVHSMESjBIgBQG\n0BJecMtGFlpTichv4k/LF47J3aEapBgwFjEUMBIGA1UEAwwLRWFzeS1SU0EgQ0GC\nFGjl8alcjSi2OLF868Y0//ABXCAcMBMGA1UdJQQMMAoGCCsGAQUFBwMCMAsGA1Ud\nDwQEAwIHgDANBgkqhkiG9w0BAQsFAAOCAQEAeHoyE/1pjUITT0bVlyh3cBNg57O/\nCxYPufnglcE22Vwyf/0iv9yjfQJgYFkLn9Gx79KULFZdPTKFvv7XPd8A9AENMaVG\nEJLHL8QZAw3oqdANAZy8p2PkCUoVARWbm5pn6tbDfghYlwVDN5OAfMq2JfsZHYux\nUdGcyUoBs62nfO84sDja3eZjwlfR0ixAL6fUHWvQ7MFFzDtWIYgdXwwNKB6a0JHG\n1weBgVXKFQ1c+fJk5LK+uaWsRmOom8ZGE3zobVHkCEAtK0nrXbO1jm4cbRcujHrG\n1n4PHdc3iTD5EC2nPezBIaUITdkVVHPNh1lovXdi1sLtzLm++9kEVzlxnQ==\n-----END CERTIFICATE-----\n</cert>\n<key>\n-----BEGIN PRIVATE KEY-----\nMIIEuwIBADANBgkqhkiG9w0BAQEFAASCBKUwggShAgEAAoIBAQDVHqe0IWDBcHT9\nrhRo2RvSVTksNHMeyGCaLTmKQZr+uMfELpzRIdxhM4ASCQ33fMk4jxG6Q28nTtw2\ndM7CxHXWWX26p0KVCuo2vczzn+EyCkvTMjitUH3lpss5MiVPAjtpebu1otPlb77X\nOZ22a1Rs2U2TJylibqFwbKEdm5EWGHJnrfoN4dlp7VqQnWOUnxuxm5UbDzD0Af3n\nv4hERFwvSuZ51n25H+cB6uPWwc+Y67OMxUiK9MSQhy+Tq9r3GpegrDVwJJnloj9P\n+NRw5UulyanJfnE/AuVRYcQjbDQd3lIyHNDmNVvEd6GRkKDySLcMuM6neTwRPv2b\nsmqs2j5dAgMBAAECggEAC96TNIMPYnai7WX+mQBOfl5kusOJDdPXHX8bT0nsGfes\nmI6ICVW7cmZt4ZNDhd8bTd0Z/ae3zxajSR0kTtCmR3Pgfr7GBIsBFF9pxL/IyQKt\nymtnoK90849gjiTu0wGq0WsIO0uARaz9kfsRf5FmuFE58tIhievjbeF+76k0YWiN\nCgaaTg8Dt/D0hzQGhsLGSRfr9o6RdB7tRPsZWI45VPjeTBPh2X3R0G2YaRX+Pv83\nxe8lMv+ep65S6fTJPedsWr0hTfnJorpi6hfCM10+/33bP/VbNH6Yj+QWdhf4PsoE\n9mmOW1L51GN76/CihEe40NTjxk+PlYOywQUCeRCCgQKBgQD+QGCdUgefdJizvVB9\nf+1p4idgny1eS+vtQRNglDBiRD14KsVYagkoYZaAdCEZBi7hhHH5GtS0drfQ0upt\n4vdgMGhokaP2Dx3FCY8cQ8yiLogPl79GQGLwRK7Ibjuz08ALmdB+w9WfOfxuw96B\nCRAMTIHdqgDuqq+9qlRm/YuE8QKBgQDWldz6xrOGwuzQ5X9GrKjsmCvjyvWZzBwj\nvBvKSiEHlMUZzC3ESITojQNkLdtBGCz8UICKD/rqIrgK/V/97usWvksXatcTdboW\nXcqgz9pa3FV4HuhTrz5kiIP3fKD6Imb0gR3WEgI7rHnGIa5OIyNEu5sx2k7J43Qo\nd3xZYxHgLQJ/czS4kpCY46fxiYA++J7+9PuE3ENES3YbcWYLYbfENMK3F7xJr8Zc\nX+/YQlxcovoqRAW/nyCJQTyKDhWEJEaz0OIebUORB+3Rj3bFYglWsCZlgKtCAJMs\nQbLdf/RzGQjZ/Ge2EbqrEXs05vvZ1p5Ep04Dim19/qdY+pgzpnc8wQKBgQC1L0Su\n2iermdqrZ5vX6OGZI8OrSyuk+Jqp8aLlY0IQTKU/6w6ZtUHDuY0rgSyoAem6AZ8G\n9AdAup/7Z4UtvBXz1ilBVIzVeYnuaLM2pUoRfgkMq8wvHMDp0frbdPfXPEUCHiM7\nJWmNSUxo5vduMm0NE/suVM5B2TOzF3B/aQ8m4QKBgCNdXArzUPsDJz8DkTU19M9L\nwcNwX0pdVBqNoFfMshrkOhTaIw4spHqeC5o2Aac7gtHNbtVU5hwH4bL6OJ47LRCl\nIcpFNK5pfqS5BwpJ7JLe+y+y5TvwPYUmYlgvkqF0toAb4WMVa71MVTeQejI3h0cv\n3jPHVfCtwVw1a5mt4N1z\n-----END PRIVATE KEY-----\n</key>\n<tls-auth>\n#\n# 2048 bit OpenVPN static key\n#\n-----BEGIN OpenVPN Static key V1-----\n2127cd0ba585af03a6507addcd43d127\n3cb30320eadfc2181170e1bb4304047a\n495114796bbef9131b46c868dd999e43\n54786d3b3c5192ac6098cf24e4957bae\n84819241591432238fb997d6b7aacaa4\n1a944787735a7c9674932139cfd381cb\n73fe2ca2259142e799970003018cd700\n1e622591778812a6f3b8077de9c1b12a\n647c6ea61ea444138061b30bdf3959d1\nf01ed721dfa6de03d246d5d204b218a1\ndcba0ce9a89dddb90f34eb5663c5b708\n4360e473aa17e80ad978bdba2dc806da\n3101ed1d8241f8f42481d7e07a3231b1\nf68963a73b00324ee90ceb033840a4bd\ndf47dec37f1a6194ffac58defd0800d1\n75922477edbf1c11bcb8a6839383e51f\n-----END OpenVPN Static key V1-----\n</tls-auth>',
    flag: 'https://firebasestorage.googleapis.com/v0/b/ovpn-319209.appspot.com/o/nl.png?alt=media&token=4f63397e-d56a-4166-8a4a-68398fc00e50',
  );


  SelectedServerBloc() : super(initial);

  select(ServerInfo server) => emit(server);

}