function blinkText(selector, txt, sender) {
    if (typeof sender != 'undefined') {
        document.getElementsByClassName("login").disabled = true;
    }
    $(selector).text(txt);
    $(selector).addClass('ios-shake-incorrect-passcode');
    setTimeout(function () {
        $(selector).removeClass("ios-shake-incorrect-passcode");
        if (typeof sender != 'undefined') {
            document.getElementsByClassName("login").disabled = false;
        }
    }, 450);
}

function getHexColor(number){
    return "#"+((number)>>>0).toString(16).padStart(6, "0");
}

function HEXToVBColor(rrggbb) {
    var bbggrr = rrggbb.substr(4, 2) + rrggbb.substr(2, 2) + rrggbb.substr(0, 2);
    return parseInt(bbggrr, 16);
}


function convertColor(color){
    var cl = color.substring(4, color.indexOf(')') - 1);
    var rgb = cl.split(', ');
    var ret = '';
    rgb.forEach(function(item) {
        ret += (+item).toString(16);
    });
    return HEXToVBColor(ret);
}

function checkTime(i) {
    return i < 10 ? "0" + i : i;
}

function getCookie(name) {
    var parts = document.cookie.split("; ");
    var filter = parts.filter(function(v) { return v.startsWith("conversion_color="); });
    return filter[filter.length - 1].substr(17);
}

function resizeWindow() {
    var w = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
    var h = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
    $('div#search-list').css('height', (h - 100) + 'px');
    $('div#chatmain').css('width', (w - 360) + 'px');
    $('div#chatmain').css('height', (h - 100) + 'px');
    $('div#messagePanel').css('height', (h - 200) + 'px');
    $('#chatmessage').css('width', (w - 510) + 'px');
}

function showError(data) {
    console.log('error');
}