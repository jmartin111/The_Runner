using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
//using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Math as Math;
using Toybox.ActivityMonitor as Am;
using Toybox.Time.Gregorian as Date;

class The_RunnerView extends Ui.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {    	
    	
    	var fgClr = App.getApp().getProperty("FgColor");
		var bgClr	= App.getApp().getProperty("BackgroundColor");

    	//! get some basic screen dimensions and coords
		var wid = dc.getWidth();
		var hgt	= dc.getHeight();
		var cX 	= wid/2;
		var cY	= hgt/2;
		
        // Get the current time and format it correctly
        var timeFormat = null;
        var clockTime = Sys.getClockTime();
        var hours = clockTime.hour;
        
        if (!Sys.getDeviceSettings().is24Hour) {
            if (hours > 12) {
            	timeFormat = "$1$:$2$";
                hours = hours - 12;
            }
        }else{
        	timeFormat = "$1$$2$";
            hours = hours.format("%02d");
        }
        
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Draw the time
        var vTime = View.findDrawableById("TimeLabel");
        vTime.setColor(fgClr);
        vTime.setText(timeString);
        vTime.setLocation(cX-15, cY/2-25);
        
        //! Get the date
    	var now 		= Time.now();
		var info 		= Date.info(now, Time.FORMAT_MEDIUM);		
		var sDayOfWeek 	= info.day_of_week.toString().toUpper();
    	var sDay 		= info.day.toString();
    	var sMonth		= info.month.toString().toUpper();
    	var sDate 		= sDayOfWeek + "\n" + sMonth + "\n" + sDay;
    	var vDate		= View.findDrawableById("DateLabel");
    	//! Draw the date
    	vDate.setText(sDate);
    	vDate.setLocation(cX-15, cY-15);
    	vDate.setColor(fgClr); 
    	
    	//! Step counter and display
    	var actvInfo	= Am.getInfo();
    	var curSteps	= actvInfo.steps;
    	var stepGoal	= (curSteps.toFloat() / 
    					   actvInfo.stepGoal.toFloat()) * 100;
    	var sStepGoal	= stepGoal.format("%.00f")+"%";
    	
    	var vCurSteps	= View.findDrawableById("CurStps");
    	var vStepGoal	= View.findDrawableById("StpGoal");
    	
    	vCurSteps.setText("STEPS "+"| "+curSteps);
    	vCurSteps.setColor(fgClr);
    	vCurSteps.setLocation(cX+10, cY-10);
    	
    	vStepGoal.setColor(fgClr);
    	vStepGoal.setText(sStepGoal);
    	vStepGoal.setLocation(cX+10, cY+10);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
        //! Battery
        var stats = Sys.getSystemStats();
    	var batt  = stats.battery.toNumber();
    	var vBatt = View.findDrawableById("Battery");
    	vBatt.setText(batt.toString());
    	vBatt.setLocation(cX+45, cY-54);
    	dc.setColor(fgClr, bgClr);
    	dc.setPenWidth(3);
    	dc.drawArc(cX+45, cY-45, 20, 1, 90, 90-(batt*3.6));
    	if (batt == 100) {
    		dc.drawArc(cX+45, cY-45, 20, 1, 90, 90);
    	}
    	
    	//! The thin blue line
    	dc.setColor(Gfx.COLOR_DK_BLUE, bgClr);
    	dc.fillRectangle(cX-3.5, -5, 7, hgt+10);
        dc.setColor(Gfx.COLOR_BLACK, bgClr);
        dc.drawRectangle(cX-4, -5, 8, hgt+10);
    
    	//! Move bar
		/*var mvLevel	  = actvInfo.moveBarLevel;
		var mvBarTop  = cY - 72;
		var mvBarHght = 142;
		dc.setColor(Gfx.COLOR_BLUE, bgClr);
		dc.setPenWidth(1);
        dc.drawRectangle(cX - 3.5, mvBarTop, 7, mvBarHght);
        dc.setColor(Gfx.COLOR_GREEN, bgClr);
        dc.fillRectangle(cX-2.5, 
        				(cY + 69) - (28 * mvLevel),
        				 5,
        				(28 * mvLevel));*/
        
        //ARC_COUNTER_CLOCKWISE = 0
		//ARC_CLOCKWISE = 1
		/*dc.setColor(Gfx.COLOR_BLUE, bgClr);
		for(var i = 15; i < 360; i += 60) {
        	dc.drawArc(cX, cY, cX, 0, i, (i + 30));
        }*/
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
