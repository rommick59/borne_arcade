import MG2D.geometrie.Point;
import MG2D.geometrie.Rectangle;
import MG2D.geometrie.Texture;
import java.io.File;


public class BoiteImage extends Boite{

    Texture image;

    // Try a few relative paths to find the game's cover image.
    private static String resolveCoverPath(String base){
        String candidate = base+"/photo_small.png";
        File f = new File(candidate);
        if(f.exists()) return candidate;
        String[] prefixes = {"./", "../", "../../"};
        for(String p : prefixes){
            f = new File(p+candidate);
            if(f.exists()) return p+candidate;
        }
        // If the path was truncated (e.g. "rojet/..."), try to restore leading 'p'.
        if(base.startsWith("rojet/")){
            candidate = "p"+base+"/photo_small.png";
            f = new File(candidate);
            if(f.exists()) return candidate;
        }
        return base+"/photo_small.png"; // fallback, even if missing
    }

    BoiteImage(Rectangle rectangle, String image) {
	super(rectangle);
	this.image = new Texture(resolveCoverPath(image), new Point(760, 648));
    this.image.setTaille(400, 320);
    }

    public Texture getImage() {
	return this.image;
    }

    public void setImage(String chemin) {
	this.image.setImg(resolveCoverPath(chemin));
    this.image.setTaille(400, 320);
    }

}
