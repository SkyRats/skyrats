export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:$HOME/catkin_ws_bebop/src/simulation/models
sudo systemctl start firmwared.service
gnome-terminal -x sudo firmwared & disown
sleep 3
gnome-terminal -x sphinx  ~/catkin_ws_bebop/src/simulation/worlds/imav_2019.world /opt/parrot-sphinx/usr/share/sphinx/drones/bebop2.drone & disown
sleep 65 #delay to connect with bebop driver
gnome-terminal -x roslaunch bebop_driver bebop_node.launch ip:=10.202.0.1 & disown
sleep 15
gnome-terminal -x rosrun bebopcontrol sm.py
#roslaunch bebop_driver bebop_node.launch ip:=10.202.0.1
# NOW FUNCTIONAL!
