 
 
 
package turtle.targetJS;
import js.Browser;
import turtle.targetJS.SetupCanvas;
import js.html.Element;
import js.html.ImageElement;
import js.html.CanvasRenderingContext2D;
class BasicJs {
    public var surface: CanvasRenderingContext2D;
    public function new() {
        var setup = new SetupCanvas();
        surface = setup.surface;
        var body = Browser.document.body;
        body.appendChild( setup.dom );
    }
}