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
    return ((number)>>>0).toString(16).padStart(6, "0");
}

function convertColor(color){
    var cl = color.substring(4, color.indexOf(')'));
    var rgb = cl.split(', ');
    var ret = 0;
	var mul = 65536;
    rgb.forEach(function(item) {
        ret += (+item) * mul;
		mul /= 256;
    });
    return ret;
}

function checkTime(i) {
    return i < 10 ? "0" + i : i;
}

function getCookie(name) {
    var parts = decodeURIComponent(document.cookie).split("; ");
    var filter = parts.filter(function(v) { return v.startsWith("conversion_color="); });
    return filter.length > 0 ? filter[filter.length - 1].substr(17) : '#0084ff';
}

function resizeWindow() {
    var w = Math.max(document.documentElement.clientWidth, window.innerWidth || 0);
    var h = Math.max(document.documentElement.clientHeight, window.innerHeight || 0);
    $('div#search-list').css('height', (h - 100) + 'px');
    $('div#search-content').css('height', (h - 128) + 'px');
    $('div#chatmain').css('width', (w - 360) + 'px');
    $('div#chatmain').css('height', (h - 100) + 'px');
    $('div#messagePanel').css('height', (h - 210) + 'px');
    $('#chatmessage').css('width', (w - 510) + 'px');
}

function showError(data) {
    console.log(data.responseText);
}

function changeConversionObjectsColor() {
	$('svg').css('stroke', '#' + conversion_color);
	$('polygon').css('fill', '#' + conversion_color);
	$('circle').css('fill', '#' + conversion_color);
	$('path').css('stroke', '#' + conversion_color);
}

function showDropDown() {
    document.getElementById("myDropdown").classList.toggle("show");
	// $('.dropdown-row:hover').attr('style', 'background-color: #' + conversion_color);
}

window.onclick = function(e) {
	if ($(e.target).parents('._30yy').length == 0) {
		var dropdowns = document.getElementsByClassName("dropdown-content");
		var i;
		for (i = 0; i < dropdowns.length; i++) {
			var openDropdown = dropdowns[i];
			if (openDropdown.classList.contains('show')) {
				openDropdown.classList.remove('show');
			}
		}
	}
}

String.prototype.replaceAll = function(search, replacement) {
    var target = this;
    return target.replace(new RegExp(search, 'g'), replacement);
};
