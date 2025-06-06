using Toybox.Time.Gregorian;
using Toybox.System;
using Toybox.System;
using Toybox.Graphics;
using Toybox.Activity;
using Toybox.Lang;

// To have the string in the midle, desiredPosition is 50
function getStringPosition (stringWidth, desiredPosition, watchWidth){
    var stringPosition = (desiredPosition * watchWidth / 100) - (stringWidth / 2);
    return stringPosition;
}

// Size is either height or width
function getPosFromPercent(percent, size){
    return percent * size / 100;
}

// Returns duration time in seconds between 2 times
function getTimeDiff(time1, time2){
    var options1 = {
        :year   => time1.year,
        :month  => time1.month, // 3.x devices can also use :month => Gregorian.MONTH_MAY
        :day    => time1.day,
        :hour   => time1.hour,
        :minute => time1.min,
        :second => time1.sec
    };
    var date1 = Gregorian.moment(options1); 

    var options2 = {
        :year   => time2.year,
        :month  => time2.month, // 3.x devices can also use :month => Gregorian.MONTH_MAY
        :day    => time2.day,
        :hour   => time2.hour,
        :minute => time2.min,
        :second => time2.sec
    };
    var date2 = Gregorian.moment(options2); 

    var result = date1.subtract(date2);

    return result;

}

// Converts WakeTime and SleepTime to hour, minutes, seconds
// Returns array of integers [hours, minutes, seconds]
function processSleepTime(inputTime) {
	var hours = 0;
	var minutes = 0;

	var timeValue = inputTime.value();
	hours = inputTime.divide(Gregorian.SECONDS_PER_HOUR).value();
	minutes = (timeValue - (hours * Gregorian.SECONDS_PER_HOUR)) / Gregorian.SECONDS_PER_MINUTE;
	//seconds = timeValue - (hours * Gregorian.SECONDS_PER_HOUR) - (minutes * Gregorian.SECONDS_PER_MINUTE);

	return [hours, minutes];
}


// Old function that draws the envelope message
// without using the font icons
/*
function drawMessagesIcon(dc, x, y, color){
	dc.setColor(color, Graphics.COLOR_BLACK);
	dc.setPenWidth(2);

	dc.drawRectangle(x-4, y-6, 16, 12);

	dc.drawLine(x-3, y-5, x+3, y);
	dc.drawLine(x+10, y-5, x+4, y);
	
	dc.setPenWidth(1);
}
*/


// Draws the bluetooth icon without using the icon fonts
function drawBluetoothIcon(dc, x, y, color, bgColor){
	dc.setColor(color, bgColor);
	dc.setPenWidth(2);

	// Vertical line
	var x1 = x + 5;
	var x2 = x + 5;
	var y1 = y - 10;
	var y2 = y + 10;
	
	dc.drawLine(x1, y1, x2, y2);

	// Lower long diag
	x1 = x;
	x2 = x + 10;
	y1 = y - 5;
	y2 = y + 5;
	dc.drawLine(x1, y1, x2, y2);

	// Upper long diag
	x1 = x;
	x2 = x + 10;
	y1 = y + 5;
	y2 = y - 5;
	dc.drawLine(x1, y1, x2, y2);

	// Upper short diag
	x1 = x + 5;
	x2 = x + 10;
	y1 = y - 10;
	y2 = y - 5;
	dc.drawLine(x1, y1, x2, y2);

	// Lower short diag
	x1 = x + 5;
	x2 = x + 10;
	y1 = y + 10;
	y2 = y + 5;
	dc.drawLine(x1, y1, x2, y2);

	dc.setPenWidth(1);
}

function convertMsToSpeed(mps, isMetric) {
	// 1 m/s = 3.6 km/h
	// 1 m/s = 2.237 mph
	var speed = isMetric ? mps*3.6 : mps*2.237;
	return speed;
}

function celciusToFarenheit(celcius){
	return (celcius * 1.8) + 32;
}

function drawStatusIcon(dc, x, y, color, bgColor, dimension, iconsFont){
	var settings = System.getDeviceSettings();

	if (settings.phoneConnected){
		$.phoneConnected = true;
		if (settings.notificationCount > 0){
			//drawMessagesIcon(dc, x, y, color);
			drawStr(dc, x+5, y+5, iconsFont, color, I_NOTIFICATIONS, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
		}
		else{
			drawBluetoothIcon(dc, x, y, Graphics.COLOR_BLUE, bgColor);
		}
	}
}

 // Draws string with all parameters in 1 call. 
function drawStr(dc, x, y, font, color, str, alignment) {
	dc.setColor(color, Graphics.COLOR_TRANSPARENT);
	dc.drawText(x, y, font, str, alignment);
}

function getColorCode(color, themeColor) as Lang.Number{
	/*
	<listEntry value="0">@Strings.ColorBabyPoo</listEntry>
		<listEntry value="1">@Strings.ColorWhite</listEntry>
		<listEntry value="2">@Strings.ColorLightGray</listEntry>
		<listEntry value="3">@Strings.ColorYellow</listEntry>
		<listEntry value="4">@Strings.ColorRed</listEntry>
		<listEntry value="5">@Strings.ColorBlue</listEntry>
		<listEntry value="6">@Strings.ColorGreen</listEntry>
		<listEntry value="7">@Strings.ColorOrange</listEntry>
		<listEntry value="8">@Strings.ColorPink</listEntry>
		<listEntry value="9">@Strings.ColorPurple</listEntry>
		<listEntry value="11">@Strings.ColorLightGreen</listEntry>
		<listEntry value="12">@Strings.ColorDarkGreen</listEntry>
		<listEntry value="13">@Strings.ColorLightBlue</listEntry>
		<listEntry value="14">@Strings.ColorDarkBlue</listEntry>
		<listEntry value="15">@Strings.ColorLightRed</listEntry>
		<listEntry value="16">@Strings.ColorDarkRed</listEntry>
		<listEntry value="30">@Strings.ColorBlack</listEntry>
		<listEntry value="99">@Strings.ColorTheme</listEntry>
	*/
	var colorCode = Graphics.COLOR_WHITE;
	switch (color){
		case 0:
			colorCode = COLOR_BABY_POO;
			break;
		case 1:
			colorCode = Graphics.COLOR_WHITE;
			break;
		case 2:
			colorCode = Graphics.COLOR_LT_GRAY;
			break;
		case 3:
			colorCode = Graphics.COLOR_YELLOW;
			break;
		case 4:
			colorCode = Graphics.COLOR_RED;
			break;
		case 5:
			colorCode = Graphics.COLOR_BLUE;
			break;
		case 6:
			colorCode = Graphics.COLOR_GREEN;
			break;
		case 7:
			colorCode = Graphics.COLOR_ORANGE;
			break;
		case 8:
			colorCode = COLOR_PINK;
			break;
		case 9:
			colorCode = Graphics.COLOR_PURPLE;
			break;
		case 10:
			colorCode = Graphics.COLOR_DK_GRAY;
			break;
		case 11:
			colorCode =  COLOR_LIGHT_GREEN;
			break;
		case 12:
			colorCode = Graphics.COLOR_DK_GREEN;
			break;
		case 13:
			colorCode =  COLOR_LIGHT_BLUE;
			break;
		case 14:
			colorCode = Graphics.COLOR_DK_BLUE;
			break;
		case 15:
			colorCode = 0xFF0055; // Light Red
			break;
		case 16:
			colorCode = Graphics.COLOR_DK_RED;
			break;
		case 20:
			colorCode = COLOR_TURQUOISE;
			break;
		case 21:
			colorCode = COLOR_AQUA;
			break;
		case 30:
			colorCode = Graphics.COLOR_BLACK;
			break;
		case 99:
			colorCode = getColorCode(themeColor, themeColor);
			break;
		default:
			colorCode = Graphics.COLOR_WHITE;
			break; 
	}

	return colorCode;
}

function getHeartRate() {
	var hr = 0;
	var temp = Activity.getActivityInfo().currentHeartRate;
	if (temp != null) {
		hr = temp;
	}
	return hr;
}

function drawHeartRate (hrClipCoordinates, hrCoordinates, iconsFont, iconsColor, isEconomyMode, bgColor, dc) {

    var heartRate = getHeartRate();
    var hrString = heartRate.format("%.0f");

    //var hrClipCoordinates; //clipXPosition, clipYPosition, clipXSize, clipYSize
    //var hrCoordinates; // iconXPosition, strXPosition, YPosition, strFont, strColor
    if (isEconomyMode) {
        dc.setClip(hrClipCoordinates[0], hrClipCoordinates[1], hrClipCoordinates[2], hrClipCoordinates[3]);
        dc.setColor(bgColor,bgColor);
        //dc.setColor(Graphics.COLOR_BLUE,Graphics.COLOR_BLUE);
        dc.clear();  
    }
    drawStr(dc, hrCoordinates[0], hrCoordinates[2], iconsFont, iconsColor, I_HEARTRATE, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    drawStr(dc, hrCoordinates[1], hrCoordinates[2], hrCoordinates[3], hrCoordinates[4], hrString, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
}

