import rospy
from geometry_msgs.msg import Twist
from turtlesim.msg import Pose
from turtlesim.srv import Spawn

pose_x = 0
pose_y = 0
def pose_callback(ros_pose):
    global pose_x, pose_y
    pose_x = ros_pose.x
    pose_y = ros_pose.y

velocity = Twist()

velocity.linear.x = 1

rospy.init_node('turtle_control')

rate = rospy.Rate(10) #Hz

velocity_publisher = rospy.Publisher('/Giocconda/cmd_vel', Twist, queue_size=10)
pose_subscriber = rospy.Subscriber('/turtle1/pose', Pose, pose_callback)
spawn = rospy.ServiceProxy('/spawn', Spawn)

#spawn(5,5,1,"Giocconda")
while not rospy.is_shutdown():
    velocidadex = float(input("Digite a velocidade"))
    velocity.linear.x = velocidadex
    velocity_publisher.publish(velocity)
    rospy.loginfo(str(pose_x) + ", " + str(pose_y))
    rate.sleep()
rospy.spin()
