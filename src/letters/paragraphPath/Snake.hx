package letters.paragraphPath;

import letters.pathway.Sides;
import turtle.Turtle;
#if js 
import turtle.targetJS.ColorJS; 
import turtle.targetJS.AlphaColorJS; 
#end

class Snake{
    
    public function new( sidePoints: Array<SidePoint>, numSection: Int ){
        #if js
        var col: ColorJS;
        var string: String;
        #end
        var sidePoints2 = [].concat(sidePoints);
        var spX = sidePoints[ 0 ].x + sidePoints[ 0 ].dx;
        var spY = sidePoints[ 0 ].y + sidePoints[ 0 ].dy;
        
        var phi: Float = 0;
        var mag: Float = 3;
        var g       = Turtle.surface;
        var magArr: Array<Float> = [];
        var count = 0;
        
        #if flash 
        g.beginFill( 0xff00ff, 0.7 ); #end
        
        #if js
        var alphaColor: AlphaColorJS;
        g.fillStyle = "rgba("+ 0xff +"," + 0x00 +","+0xff+","+0.7 +")";
        g.beginPath(); #end
        
        g.moveTo( spX, spY );
        
        
        
        //mag = 2 + 3*( phi-Math.floor(phi) );
        //2 + 3*Math.abs( Math.sin( phi ));
        
        #if flash
        g.lineStyle( 0, 0xff0000, 1); #end
        #if js
        g.strokeStyle = "rgba(0,0,0,0)";
        g.lineWidth = 1; #end
        
        for( sp in sidePoints ) {
            phi+=0.5;
            mag = 2+3*( phi-Math.floor(phi) );//Math.abs( Math.sin( phi ))
            magArr.push( mag );
            g.lineTo( sp.x + mag*sp.dx, sp.y + mag*sp.dy ); 
        }
        sidePoints.reverse();
        magArr.reverse();
        
        #if flash
        g.lineStyle( 0, 0x0000ff, 1); #end
        #if js
        g.strokeStyle = "rgba(0,0,0,0)";
        g.lineWidth = 1; #end
        
        for( sp in sidePoints ) {
            mag = 3;
            phi+=1;
            mag = magArr[ count++ ];
            g.lineTo( sp.x - mag*sp.dx, sp.y - mag*sp.dy ); 
        }
        
        #if flash
        g.endFill(); #end
        
        #if js 
        g.stroke();
        g.closePath();
        g.fill(); #end
        
        // ______________________________________________________
        // Do again for js so you can have the two sides ( have to have stroke split midway)
        #if js
        count = 0;
        // NO Fill
        g.fillStyle = "rgba("+ 0xff +"," + 0x00 +","+0xff+","+0.0 +")";
        g.beginPath();
        g.moveTo( spX, spY );
        magArr = [];
        //mag = 2 + 3*( phi-Math.floor(phi) );
        //2 + 3*Math.abs( Math.sin( phi ));
        
        g.strokeStyle = string = col = 0xff0000;
        g.lineWidth = 1; 
        for( sp in sidePoints ) {
            phi+=0.5;
            mag = 2+3*( phi-Math.floor(phi) );//Math.abs( Math.sin( phi ))
            magArr.push( mag );
            g.lineTo( sp.x + mag*sp.dx, sp.y + mag*sp.dy ); 
        }
        
        // required so left and right are different
        g.stroke();
        g.closePath();
        g.fill();
        g.beginPath();
        sidePoints2.reverse();
        magArr.reverse();
        count = 0;
        
        g.strokeStyle = string = col = 0x0000ff;
        g.lineWidth = 1;
            
        for( sp in sidePoints2 ) {
            mag = 3;
            phi+=1;
            mag = magArr[ count++ ];
            g.lineTo( sp.x - mag*sp.dx, sp.y - mag*sp.dy ); 
        }
        
        g.stroke();
        g.closePath();
        g.fill(); #end
        
    }
    
}