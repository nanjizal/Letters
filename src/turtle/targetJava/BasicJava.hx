 
 
 
package turtle.targetJava;

import java.javax.swing.JFrame;
import java.javax.swing.JPanel;
import java.awt.Color;
import java.awt.Cursor;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.event.MouseEvent;
import java.lang.System;
import java.awt.Graphics2D;
import haxe.macro.Compiler;

class BasicJava
extends JFrame
implements KeyListener
implements MouseListener
implements MouseMotionListener
{
    
    public var surface: Surface;
    @static inline function parseInt( e: String ): Int return Std.parseInt( e );
    public function new()
    {
        super(  );
        System.setProperty( "sun.java2d.opengl", "True" );
        setSize( 700, 500 );
        setDefaultCloseOperation( JFrame.EXIT_ON_CLOSE );
        setBackground( Color.black );
        
        surface = new Surface();
        getContentPane().add( surface );
        surface.addKeyListener( this );
        surface.setFocusable( true );
        surface.requestFocusInWindow();
        addMouseListener( this );
        addMouseMotionListener( this );
        //surface.repaint();
        
        setVisible( true );
    }
    
    // Mouse and keyboard events ready to be used...
    public function mousePressed( e: MouseEvent ) {}
    public function mouseDragged( e: MouseEvent ) {}
    public function mouseExited( e: MouseEvent ) {}
    public function mouseMoved( e: MouseEvent ) {}
    public function mouseEntered( e: MouseEvent ) {}
    public function mouseClicked( e: MouseEvent ) {}
    public function mouseReleased( e: MouseEvent ){}
    public function keyTyped( e: KeyEvent ) {}
    public function keyReleased(e: KeyEvent ) {}
    public function keyPressed( e: KeyEvent ) {};

}