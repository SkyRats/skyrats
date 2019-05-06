import rospy
import turtlesim
from turtlesim.msg import Pose
from geometry_msgs.msg import Twist
from turtlesim.srv import Spawn
from turtle_actionlib.msg import Velocity

goal_pose = Pose()
velocity = Twist()
teleport = rospy.ServiceProxy('/turtle1/teleport_absolute', turtlesim.srv.TeleportAbsolute)
spawn = rospy.ServiceProxy('/spawn', turtlesim.srv.Spawn)
velocity.linear.x = 0
velocity.linear.y = 0
velocity.linear.z = 0
velocity.angular.z = 1
velocity.angular.x = 0
velocity.angular.y = 0
publisher = rospy.Publisher('/turtle1/cmd_vel', Twist, queue_size=10)

rospy.init_node('turtle_controller')
rate = rospy.Rate(10)
teleport(1, 1, 0)
#spawn(5,5,0, 'joelma')
#spawn(3,3,1, 'binchinha')
while not rospy.is_shutdown():
    publisher.publish(velocity)
