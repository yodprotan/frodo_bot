require("es6-shim");
var esrever = require("esrever");

module.exports = function flip(aString) {
    var reversed = Array.from(esrever.reverse(aString))
    var result = new Array(reversed.length)
    for (var i = 0; i < reversed.length; i++) {
        var c = reversed[i]
        var r = flipTable[c]
        result[i] = r != undefined ? r : c
    }
    return result.join('')
}

var flipTable = {
    '\u0021': '\u00A1',
    '\u0022': '\u201E',
    '\u0026': '\u214B',
    '\u0027': '\u002C',
    '\u0028': '\u0029',
    '\u002E': '\u02D9',
    '\u0033': '\u0190',
    '\u0034': '\u152D',
    '\u0036': '\u0039',
    '\u0037': '\u2C62',
    '\u003B': '\u061B',
    '\u003C': '\u003E',
    '\u003F': '\u00BF',
    '\u0041': '\u2200',
    '\u0042': '\uD801\uDC12',
    '\u0043': '\u2183',
    '\u0044': '\u15E1',
    '\u0045': '\u018E',
    '\u0046': '\u2132',
    '\u0047': '\u2141',
    '\u004A': '\u017F',
    '\u004B': '\u22CA',
    '\u004C': '\u2142',
    '\u004D': '\u0057',
    '\u004E': '\u1D0E',
    '\u0050': '\u0500',
    '\u0051': '\u038C',
    '\u0052': '\u1D1A',
    '\u0054': '\u22A5',
    '\u0055': '\u2229',
    '\u0056': '\u1D27',
    '\u0059': '\u2144',
    '\u005B': '\u005D',
    '\u005F': '\u203E',
    '\u0061': '\u0250',
    '\u0062': '\u0071',
    '\u0063': '\u0254',
    '\u0064': '\u0070',
    '\u0065': '\u01DD',
    '\u0066': '\u025F',
    '\u0067': '\u0183',
    '\u0068': '\u0265',
    '\u0069': '\u0131',
    '\u006A': '\u027E',
    '\u006B': '\u029E',
    '\u006C': '\u006C',
    '\u006D': '\u026F',
    '\u006E': '\u0075',
    '\u0072': '\u0279',
    '\u0074': '\u0287',
    '\u0076': '\u028C',
    '\u0077': '\u028D',
    '\u0079': '\u028E',
    '\u007B': '\u007D',
    '\u203F': '\u2040',
    '\u2045': '\u2046',
    '\u2234': '\u2235',
    '\u4EBA': '\uFF39',
    '\uD83D\uDC4D': '\uD83D\uDC4E',
    '\uD83D\uDE43': '\uD83D\uDE42'
}

for (i in flipTable) {
    flipTable[flipTable[i]] = i
}
