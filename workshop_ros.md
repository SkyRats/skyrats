# ROS - Robot Operating System

## Antes de tudo...

#### Digamos que a gente quer construir um software para um drone

Queremos um drone **autônomo** com software **robusto**, algorítmos de estimação de posição, visão computacional, máquinas de estados e softwares de segurança...

### Quem aqui já implementou um algorítmo de Calibração de Câmera??

### Isso requer um conhecimento muito específico 

Um projeto complexo como esse é **muito** difícil para ser implementado "do zero" por qualquer indivíduo sozinho, ou até mesmo um laboratório ou instituição

> Palavras da organização ROS

Pra um projeto como esse, é necessário **trabalho colaborativo para o desenvolvimento de softwares de robótica**, e é **exatamente** pra isso que o ROS existe.

> ROS was designed specifically for groups [ ... ] to collaborate and build upon each other's work

### Robot Operating System

> ROS is an open-source, meta-operating system for your robot, a flexible framework for writing robot software. It is a collection of tools, libraries, and conventions that aim to simplify the task of creating complex and robust robot behavior across a wide variety of robotic platforms.

Mas pera, o que é um _framework_?

> Conjunto de ferramentas (softwares), para abstrair códigos comuns, de funcionalidade "genérica" em um projeto.



[Dá uma olhada no que esse bb(ROS) pode te oferecer](<https://index.ros.org/packages/page/1/time/>)



![https://docs.google.com/drawings/d/1N3skvSyzZj_dWzCqwEfsNd3gtwTNGFDwpm_TM__Vk2s/edit](https://docs.google.com/drawings/d/1N3skvSyzZj_dWzCqwEfsNd3gtwTNGFDwpm_TM__Vk2s/pub?w=2312&h=1050)



### @Bixo2019 - "Nossa, @Veteranos, vcs usam tudo isso??"

### @Veteranos - "Nem fo dendo"

Usamos o ROS conforme as necessidades do projeto em que estamos trabalhando

## Skyrats <-- ROS - alguns ROS _packages_ que usamos:

* MAVROS
* CvBridge
* Gazebo
* bebop_driver, bebop_autonomy, bebop_msgs, bebop tools, _et cetera_
* Whatever framework we  eventually need

## Onde conseguir o tal ROS??

> [É só clicar aqui](http://wiki.ros.org/ROS/Installation)

E, para ter acesso a todos os packages ROS, [Clique aqui](<https://index.ros.org/packages/>)

A partir disso, cada _package_ (exceto os padrões) tem sua documentação e instalação separadas do ROS, em suas próprias plataformas.

# Como usar o tal ROS??

## Grafos de Comunicação

### Nodes

> Processos computacionais - Programas que escrevemos.
>
> Desenvolvidos usando uma biblioteca ros (roscpp em C++, e rospy em python)
>
> Programas que compartilham a informações por meio **mensagens** em **tópicos**

### ROS messages

> Uma estrutura de dados (uma classe) composta de tipos primitivos, que será usada para a comunicação nos tópicos.

* Ex: `mavros_msgs/OpticalFlowRad`:

  Composta por:

  `std_msgs/Header header
    uint32 seq
    time stamp
    string frame_id
  uint32* integration_time_us
  float32 integrated_x
  float32 integrated_y
  float32 integrated_xgyro
  float32 integrated_ygyro
  float32 integrated_zgyro
  int16 temperature
  uint8 quality
  uint32 time_delta_distance_us
  float32 distance`

  

### Topics

>ROS ≈ Fórum
>
>Topicos são um **nome** para identificar o conteúdo da mensagem
>
>Os **Nodes** podem obter os dados de um tópico se inscrevendo nele - **Nodes Subscriber** - ou mudar os dados desse tópico publicando nele - **Nodes Publishers**.

#### 	Como obter as informações:

* `rostopic list` - lista todos os tópicos ativos 
* `rostopic info [nome do tópico]` -  te diz
  * O tipo de mensagem publicada
  * Os publisher e subscribers
* `rosmsg show [tipo de mensagem]` - passa todos os parametros da mensagem

### Services

> Modelo mais apropriado pra "request/reply interactions" - comunicação direta entre 2 nodes - que não são possiveis com a comunicação unilateral dos tópicos. Definido por **duas** estruturas de mensagens ( uma pro _request e outra pro reply_).

* Ex: /mavros/cmd/arming

  #### Como obter as informações:

* `rosservice list` - lista todos os servers ativos 

* `rosserver info [nome do tópico]` -  te diz

  - O node que **recebe** o _request_
  - O tipo de mensagem de _request_
  - Os argumentos da mensagem

### ![http://ros.org/images/wiki/ROS_basic_concepts.png](http://ros.org/images/wiki/ROS_basic_concepts.png)

### Packages
> Estrutura de organização dos nodes - 1 package pode ter diversos nodes 
> Pense em um pacote de nodes
#### Packages são compostos de
* um arquivo `CMakeLIsts.txt`
* um arquivo `package.xml`
* uma pasta `src` - para códigos (principalmente em C) que serão compilados 
#### Eventualmente, podem ter:
* uma pasta `include` para definir headers (que devem ser especificados no CMakeLists.txt)
* uma pasta `msg`  para definir e criar mensagens específicas do _package_
* uma pasta `srv` para definir Services específicos do _package_
* uma pasta  `scripts` para executáveis
Na dúvida, `rospack help` 
- Na pratica
	-catkin


* Ponte ROS-Drone

**Frameworks do ROS...**