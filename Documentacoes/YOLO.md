# How to use YOLO annotation tool

## Prepare Dataset

1. Git clone <https://github.com/ManivannanMurugavel/YOLO-Annotation-Tool> and open it

2. Git clone  [Darknet](https://github.com/AlexeyAB/darknet.gitand), `cd darknet` and `make`

3. Setup all images into the Image directory, with one directory for each class

4. Run main.py (it is ran on the Image directory already)

5. Input the Image directory. Example "001" (and not "Image/001")

6. Convert all images to `.jpg`

7. Label images bounding boxes

   At this point, for each image you label, a `.txt` file will be saved on the `Labels` directory, containing the bounding boxes in the YOLOv1 format. To format it to the YOLOv2 format, use `convert.py`(you will need to change the directory on the code for that)

## Prepare Training

1.  create `.data` file, containing

   ```
   classes= 1  
   train  = <train.txt repository>  
   valid  = <test.txt  repository>
   names = <obj.names filename>  
   backup = backup/
   ```

2. create `.names` file, containing all the class names

   ```
   Drone
   ```

3. Configure the `yolo.cfg` file:

   1. in line 114, set `filters=(classes + 5)*5`
   2. in line 120, set `classes` for the number of classes you want
4.  Download, if you want, a pre-trained net on [this link](https://pjreddie.com/media/files/darknet19_448.conv.23)

### Finally, let's TRAIN!!!

```
./darknet detector train cfg/obj.data cfg/tiny-yolo.cfg (yolo-obj1000.weights - optional)
```
or
```
./darknet detector train cfg/obj.data cfg/tiny-yolo.cfg yolo-obj1000.weights
```
to train the pre-trained network

### Testing...

```
./darknet detector test cfg/obj.data cfg/yolo-obj.cfg yolo-obj1000.weights <nome da imagem de teste>
```

The prediction image will show up in the darknet directory



### Erros...

Tive que:

* Mudar o endereço do CUDA no Makefile do Darknet para compilá-lo com GPU=1
* Mudar o ARCH no Makefile do Darknet
* Diminuir o batch para **1** no arquivo .data, pq minha RAM n aguentou mais
* Aumentar o subdivisions (no arquivo .data) 