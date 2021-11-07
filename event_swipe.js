// By Tschallacka, https://github.com/tschallacka/npm_jquery_event_swipe, MIT license

const UP = 'up',
      DOWN = 'down',
      LEFT = 'left',
      RIGHT = 'right',
      NONE = 'none';

let $document = $(document),
	swipedir = null,
	startX = null,
	startY = null,
	distX = null,
	distY = null,
	threshold = 50,
	restraint = 200,
	allowedTime = 300,
	elapsedTime = null,
	startTime = null;

let handleswipe = function(direction, distance, elapsedTime, deviation, event) 
{    
    let data = {
		direction: direction,
		distance: distance,
		duration: elapsedTime,
		deviation: deviation,
	},
	$source = $(event.srcElement),
	e = $.Event('swipe.' + direction, data);
	
    $source.trigger(e);	
	e = $.Event('swipe.all', data);
    $source.trigger(e);
}

let touchstart = function(event) 
{
	let e = event.originalEvent;
	let touchobj = e.changedTouches[0];
    swipedir = NONE;
    startX = touchobj.pageX;
    startY = touchobj.pageY;
    startTime = new Date().getTime(); // record time when finger first makes contact with surface
}


let touchend = function(event) 
{	
	let e = event.originalEvent;
	let touchobj = e.changedTouches[0];
    distX = touchobj.pageX - startX; // get horizontal dist traveled by finger while in contact with surface
    distY = touchobj.pageY - startY; // get vertical dist traveled by finger while in contact with surface
    elapsedTime = new Date().getTime() - startTime; // get time elapsed
	let absX = Math.abs(distX);
	let absY = Math.abs(distY);
    if (elapsedTime <= allowedTime){ // first condition for awipe met
        if (absX >= threshold && absY <= restraint) { // 2nd condition for horizontal swipe met
            swipedir = (distX < 0)? LEFT : RIGHT; // if dist traveled is negative, it indicates left swipe
        }
        else if (absY >= threshold && absX <= restraint){ // 2nd condition for vertical swipe met
            swipedir = (distY < 0)? UP : DOWN; // if dist traveled is negative, it indicates up swipe
        }
		let axis = swipedir === UP || swipedir === DOWN,
		    distance =  axis ? absY : absX,
		    deviation = axis ? distX : distY;
		if(distance > threshold) {
			handleswipe(swipedir, distance, elapsedTime, deviation, e);
		}
    }	
}

$document.ready(() => {
	$document.on('touchstart', touchstart);
	$document.on('touchend', touchend);
});

module.exports = function(settings) 
{
	if(settings) {
		if(settings.threshold) {
			threshold = settings.threshold;
		}
		if(settings.restraint) {
			restraint = settings.restraint
		}
		if(settings.allowedTime) {
			allowedTime = allowedTime;
		}
	}
}



