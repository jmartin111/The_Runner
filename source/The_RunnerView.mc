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
    
    	var actvInfo = Am.getInfo();
    	//! The move bar levels trigger at 60/75/90/105/120 minutes.
    	
    	var fgClr = App.getApp().getProperty("FgColor");
		var bgClr	= App.getApp().getProperty("BackgroundColor");

    	//! get some basic screen dimensions and coords
		var wid = dc.getWidth();
		var hgt	= dc.getHeight();
		var cX 	= wid/2;
		var cY	= hgt/2;
		
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = Sys.getClockTime();
        var hours = clockTime.hour;
        if (!Sys.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (App.getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Draw the time
        var vTime = View.findDrawableById("TimeLabel");
        vTime.setColor(fgClr);
        vTime.setText(timeString);
        vTime.setLocation(cX/2+40, cY/2);
        
        //! Get the date
    	var now 		= Time.now();
		var info 		= Date.info(now, Time.FORMAT_MEDIUM);		
		var sDayOfWeek 	= info.day_of_week.toString().toUpper();
    	var sDay 		= info.day.toString();
    	var sDate 		= sDayOfWeek + " " + sDay;
    	var vDate		= View.findDrawableById("DateLabel");
    	vDate.setText(sDate);
    	vDate.setLocation(cX/2+40, cY/2+30);
    	vDate.setColor(fgClr); 

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
        //dc.setPenWidth(2);
		var mvBarHght = 140;
        dc.drawRectangle(cX-5, cY-70, 10, mvBarHght);
        //dc.fillRectangle(cX-5, cY-70, 10, (28*actvInfo.moveBarLevel));
        
        //dc.setPenWidth(10);        
        
        //ARC_COUNTER_CLOCKWISE = 0
		//ARC_CLOCKWISE = 1
		/*for(var i = 15; i < 360; i += 60) {
        	dc.drawArc(cX, cY, cX-5, 0, (i), (i + 30));
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
