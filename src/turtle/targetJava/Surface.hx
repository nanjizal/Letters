 
 
 
package turtle.targetJava;

import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;

import java.javax.swing.JPanel;


class Surface extends JPanel
{
    
    public var g: Graphics2D;
    public var paintFunction: Graphics2D -> Void;
    
    public function new(){ super( true ); }
    
    @:overload override public function paintComponent( g: Graphics )
    {
        
        super.paintComponent( g );
        var g2D: Graphics2D = cast g;
        g2D.setRenderingHint(RenderingHints.KEY_ANTIALIASING,
                                RenderingHints.VALUE_ANTIALIAS_ON );
        g2D.setRenderingHint(RenderingHints.KEY_RENDERING,
                                RenderingHints.VALUE_RENDER_QUALITY );
        paintFunction( g2D );
        g2D.dispose();
        
    }
  
}