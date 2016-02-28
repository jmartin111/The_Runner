using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
//using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Math as Math;
using Toybox.ActivityMonitor as Am;
using Toybox.Time.Gregorian as Date;
using Toybox.Activity as A;

class The_RunnerView extends Ui.WatchFace {

	hidden var iBadge = null;

    function initialize() {
        WatchFace.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
        iBadge = Ui.loadResource(Rez.Drawables.BadgeIcon);
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {    	
    	var fgClr = App.getApp().getProperty("FgColor");
    	
    	//! get some basic screen dimensions and coords
		var wid = dc.getWidth();
		var hgt	= dc.getHeight();
		var cX 	= wid/2;
		var cY	= hgt/2;
		
        // Get the current time and format it correctly
        //get and format time info
		var timeFormat 	= "$1$:$2$";
    	var clock 		= Sys.getClockTime();
		var hour		= clock.hour; //define this for use below
    	
    	if (!Sys.getDeviceSettings().is24Hour) {
            if (hour > 12) {
                hour = hour - 12;
            }
            if (hour == 0) {
            	hour = 12;
            }
        } else {
        	timeFormat = "$1$$2$";
            hour = hour.format("%02d");
        }
        
        var timeString = Lang.format(timeFormat, [hour, clock.min.format("%02d")]);
		
		//!
        // Draw the time
		//!
        var vTime = View.findDrawableById("TimeLabel");
        vTime.setColor(fgClr);
        vTime.setText(timeString);
        vTime.setLocation(cX, cY-65);
        
        //!
        //! Get the date
		//!
    	var now 		= Time.now();
		var info 		= Date.info(now, Time.FORMAT_MEDIUM);		
		var sDayOfWeek 	= info.day_of_week.toString().toUpper();
    	var sDay 		= info.day.toString();
    	//var sMonth		= info.month.toString().toUpper();
    	var sDate 		= sDayOfWeek + " " + sDay;
    	var vDate		= View.findDrawableById("DateLabel");
    	
    	//!
    	//! Draw the date
		//!
    	vDate.setText(sDate);
    	vDate.setLocation(cX, 20);
    	vDate.setColor(fgClr); 
    	
    	//!
    	//! Step data
		//!
    	var actvInfo	= Am.getInfo();
    	var curSteps	= actvInfo.steps;
    	var stepGoal	= actvInfo.stepGoal;
    	var pctCmplt	= curSteps.toFloat() / stepGoal.toFloat();
    	
    	var vCurSteps	= View.findDrawableById("CurStps");
    	
    	vCurSteps.setText(curSteps.toString());
    	vCurSteps.setColor(fgClr);
    	vCurSteps.setLocation(cX+45, cY+34);
    	
    	//!
    	//! Battery data
		//!
        var stats = Sys.getSystemStats();
    	var batt  = stats.battery.toNumber();
    	var vBatt = View.findDrawableById("Battery");
    	vBatt.setText(batt.toString()+"%");
    	vBatt.setColor(fgClr);
    	vBatt.setLocation(cX-45, cY+34);   	

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
        dc.drawBitmap(cX - iBadge.getWidth()/2, cY+70, iBadge);
        
        //!
        //! Battery indicator
		//!    	
    	var arcStart 	= 90;
    	var arcEnd	 	= 90-(batt*3.6);
    	var x		 	= cX-45;
    	var y			= cY+45;
    	var radius		= 30;
    	
    	var battClr = Gfx.COLOR_RED;
    	if (batt <= 50) { battClr = Gfx.COLOR_GREEN; }
    	if (batt <= 30) { battClr = Gfx.COLOR_YELLOW; }
    	if (batt <= 15) { battClr = Gfx.COLOR_RED; }
    	dc.setPenWidth(1);
		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_DK_GRAY);
		dc.drawCircle(x, y, radius);
    	dc.setPenWidth(2);
    	dc.setColor(battClr, Gfx.COLOR_DK_GRAY);
    	dc.drawArc(x, y, radius, 1, arcStart, arcEnd);
    	if (batt == 100) {
    		dc.drawArc(x, y, radius, 1, 90, 90);
    	}
    	drawPoint(dc, arcEnd, x, y, radius, fgClr);
        
        //!
        //! Step indicator
		//!    	
    	arcStart 	= 90;
    	arcEnd	 	= 90-(360*pctCmplt);
    	x		 	= cX+45;
    	y			= cY+45;
    	radius		= 30;
    	
    	dc.setPenWidth(1);
		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_DK_GRAY);
		dc.drawCircle(x, y, radius);
    	dc.setPenWidth(2);
    	dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_DK_GRAY);
    	dc.drawArc(x, y, radius, 1, arcStart, arcEnd);
    	if (pctCmplt >= 1) {
    		dc.drawArc(x, y, radius, 1, 90, 90);
    	}
    	drawPoint(dc, arcEnd, x, y, radius, fgClr);

    	//drawDist(dc, arcEnd, x, y, radius+20, fgClr);
		
    	//!
    	//! The thin blue line
		//! Gold - 0xFFD700
    	dc.setColor(Gfx.COLOR_DK_BLUE, Gfx.COLOR_DK_GRAY);
    	dc.fillRectangle(-5, cY-3.5, wid+5, 7);
    	dc.setPenWidth(2);
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_DK_GRAY);
        dc.drawRectangle(-5, cY-4, wid+7, 8);
    
    	//! Move bar
		/*var mvLevel	  = actvInfo.moveBarLevel;
		var mvBarTop  = cY - 72;
		var mvBarHght = 142;
		dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_DK_GRAY);
		dc.setPenWidth(1);
        dc.drawRectangle(cX - 3.5, mvBarTop, 7, mvBarHght);
        dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_DK_GRAY);
        dc.fillRectangle(cX-2.5, 
        				(cY + 69) - (28 * mvLevel),
        				 5,
        				(28 * mvLevel));*/
        
        //ARC_COUNTER_CLOCKWISE = 0
		//ARC_CLOCKWISE = 1
		/*dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_DK_GRAY);
		for(var i = 15; i < 360; i += 60) {
        	dc.drawArc(cX, cY, cX, 0, i, (i + 30));
        }*/
    }
    
    function drawDist(dc, arcEnd, x, y, radius, fgClr) {
    	var rads 	= dToR(-arcEnd);
		var coords 	= calcCircumCoords(x, y, rads, radius);
		var vDist 	= View.findDrawableById("Dist");
		var distKm	= Am.getInfo().distance.toFloat() / 100000;
		var distMi	= distKm * 0.6213;
		vDist.setText(distMi.format("%.02f"));
		vDist.setLocation(coords[0], coords[1]);
		vDist.setColor(fgClr, Gfx.COLOR_DK_GRAY);
	}
    
    //! Draw point at leading edge of arc
		//! reverse polarity since the circle is drawn in a way
		//! that takes the degrees to a negative value
	function drawPoint(dc, arcEnd, x, y, radius, fgClr) {
		var rads 	= dToR(-arcEnd);
		var coords 	= calcCircumCoords(x, y, rads, radius);
		dc.setColor(fgClr, Gfx.COLOR_DK_GRAY);
		dc.fillCircle(coords[0], coords[1], 3.5);
	}
    
    //! calculate circumference coordinates
    function calcCircumCoords(x, y, rads, radius) {
    	//! x = cx + r * cos(a)
		//! y = cy + r * sin(a)
    	var coords = new[2];
    	coords[0] = x + radius * Math.cos(rads);
    	coords[1] = y + radius * Math.sin(rads);
    	return coords;    	
    }
    
    //! Convert degreees to radians
	function dToR(deg) {
		return deg*Math.PI/180;
	}

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
