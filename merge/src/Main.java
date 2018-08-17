import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.util.*;

public class Main {
    public Main() {
    }

    public static void main(String[] args) {
        String m = "h-mate";
        File file = new File("" + m);
        //System.out.println(file.getAbsolutePath());
        File[] fs = file.listFiles();
        for (int i = 0; i < fs.length; i++) {
            File f = fs[i];
            Vector<String> fs1 = new Vector<>();
            List<File> mmm = getSortedFiles(f.listFiles());


            for (int j = 0; j < mmm.size(); j++) {
                File img = mmm.get(j);
//                System.out.println(img.getAbsolutePath());
                fs1.add(img.getAbsolutePath());
            }
            ArrayList<ArrayList<BufferedImage>> fsss = getFiles(fs1);
            for (int j = 0; j < fsss.size(); j++) {

                mergeImage(fsss.get(j), 2, (i + 1) + "_" + (j + 1) + ".jpg");

            }
        }
    }

    private static List<File> getSortedFiles(File[] fs) {


        List<File> fileList = new ArrayList<File>();
        for (File f : fs) {
            fileList.add(f);
        }
        Collections.sort(fileList, new Comparator<File>() {
            @Override
            public int compare(File o1, File o2) {
                if (o1.isDirectory() && o2.isFile())
                    return -1;
                if (o1.isFile() && o2.isDirectory())
                    return 1;
                return Integer.valueOf(o1.getName().split("\\.")[0]) < Integer.valueOf(o2.getName().split("\\.")[0]) ? -1 : 1;
            }
        });
        for (int i = 0; i < fileList.size(); i++) {
            File file1 = fileList.get(i);
//            System.out.println(file1.getAbsolutePath());
        }
        return fileList;
    }

    public static void mergeImage(ArrayList<BufferedImage> files, int type, String targetFile) {
        int len = files.size();
        if (len < 1) {
            throw new RuntimeException("图片数量小于1");
        }
        BufferedImage[] images = new BufferedImage[len];
        int[][] ImageArrays = new int[len][];
        for (int i = 0; i < len; i++) {
            images[i] = (files.get(i));
            int width = images[i].getWidth();
            int height = images[i].getHeight();
            ImageArrays[i] = new int[width * height];
            ImageArrays[i] = images[i].getRGB(0, 0, width, height, ImageArrays[i], 0, width);
        }
        int newHeight = 0;
        int newWidth = 0;
        for (int i = 0; i < images.length; i++) {
            // 横向
            if (type == 1) {
                newHeight = newHeight > images[i].getHeight() ? newHeight : images[i].getHeight();
                newWidth += images[i].getWidth();
            } else if (type == 2) {// 纵向
                newWidth = newWidth > images[i].getWidth() ? newWidth : images[i].getWidth();
                newHeight += images[i].getHeight();
            }
        }
        if (type == 1 && newWidth < 1) {
            return;
        }
        if (type == 2 && newHeight < 1) {
            return;
        }

        // 生成新图片
        try {
            BufferedImage ImageNew = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_INT_RGB);
            int height_i = 0;
            int width_i = 0;
            for (int i = 0; i < images.length; i++) {
                if (type == 1) {
                    ImageNew.setRGB(width_i, 0, images[i].getWidth(), newHeight, ImageArrays[i], 0,
                            images[i].getWidth());
                    width_i += images[i].getWidth();
                } else if (type == 2) {
                    ImageNew.setRGB(0, height_i, images[i].getWidth(), images[i].getHeight(), ImageArrays[i], 0, images[i].getWidth());
                    height_i += images[i].getHeight();
                }
            }
            //输出想要的图片
            ImageIO.write(ImageNew, targetFile.split("\\.")[1], new File(targetFile));
            System.out.println(new File(targetFile).getAbsolutePath());

        } catch (Exception e) {
            System.out.println(e);
        }
    }

    private static ArrayList<ArrayList<BufferedImage>> getFiles(Vector<String> files) {

        ArrayList<ArrayList<BufferedImage>> ret = new ArrayList<>();
        ArrayList<BufferedImage> cur = new ArrayList<>();
        BufferedImage img1;
        int totalHeight = 0;
        for (int i = 0; i < files.size(); i++) {
            try {
                File img = new File(files.get(i));
                img1 = ImageIO.read(img);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            if(img1==null){
                continue;
            }
            totalHeight += img1.getHeight();
            cur.add(img1);
            if (totalHeight > 20000) {
                ret.add(cur);
                cur = new ArrayList<>();
                totalHeight = 0;
            }
        }
        return ret;
    }
}
