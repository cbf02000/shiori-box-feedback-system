var vars = [], hash;
var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
for(var i = 0; i < hashes.length; i++) { 
	hash = hashes[i].split('='); 
	vars.push(hash[0]);
	vars[hash[0]] = hash[1];
}

var uid = vars.uid;
var currentStatus = 2;

// currentStatus;
// 0 -> show most recent message
// 1 -> new message received
// 2 -> page loaded for the first time

console.log(uid);
getMessageStatus();

function getMessageStatus() {

	var statusURL = "get-message-status.rb?uid=" + uid;
	var contentURL = "get-content.rb?uid=" + uid;
	var newMessageURL = "new-message.html";

	$.getJSON(statusURL, function(data) {
		if (data.code == "0") {
			if (currentStatus != 0) {
        		$("#container").load(contentURL);
				currentStatus = 0;
			}

			setTimeout( function() {
				getMessageStatus();
			}, 1000);
		} else if (data.code == "1") {
			if (currentStatus != 1) {
				$("#container").load(newMessageURL);
				currentStatus = 1;
			}
		}
	});
}

function readNewMessage() {

	var readMessageURL = "read-new-message.rb?uid=" + uid;

	$.getJSON(statusURL, function(data) {
		if (data.code == "0") {
			getMessageStatus();
		}
	});
}

function reloadPage() {
	window.location.reload();
}
