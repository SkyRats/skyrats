# Simulação entre dois computadores
Este passo a passo serve para rodar a simulação da PX4 (SITL) através do Gazebo em um computador, enquanto outro computador conectado na mesma rede Wi-Fi realiza o controle desse drone simulado através da mavros (ou QGC). Isso tenta replicar situações em que um computador de bordo se comunica com um computador embarcado, ou a comunicação entre drones.
Um problema da simulação é que a conexão entre a mavros e o drone se faz por Wi-Fi, em vez de ser por uma conexão via cabo como seria caso o computador estivesse embarcado, o que não é tão rápido.

## Materiais necessários
* Computador 1
    - Firmware PX4
    - Gazebo
    - [mavlink-router](https://github.com/intel/mavlink-router)
* Computador 2
    - ROS/QGC
    - mavros

## Passo a passo
1. Inicializar a simulação no **computador 1**:
```
cd ~/src/Firmware
make px4_sitl gazebo
```
2. Em um outro terminal no **computador 1**, usar o mavlink-router para rotear pacotes do computador 1 para o computador 2:
```
mavlink-routerd -e <ip-computador-2>:14540 127.0.0.1:14540
```
    *Obs.: se você quiser usar a QGC no computador 2, troque a porta de 14540 para 14550*
3. Em um terminal do **computador 2**, execute a mavros/QGC:
```
roslaunch mavros px4.launch fcu_url:="udp://:14540@<ip-computador-2>:14557"
```
## O que está acontecendo?

![](http://dev.px4.io/master/assets/simulation/px4_sitl_overview.png)
Quando iniciamos a simulação da PX4, ela abre 3 canais de comunicação e controle, usando pacotes MAVLink para a comunicação:

- **API/Offboard:** Para se comunicar com sistemas como a mavros. Usa a porta UDP **14540**.
- **GCS:** Para se comunicar com uma Ground Control Station como o QGroundControl. Usa a porta UDP **14550** (automaticamente detectada pela QGC).
- **Simulator:** Para se comunicar com o simulador propriamente dito, que nesse caso é o Gazebo (mas poderia ser outro, como o jMAVSim). Usa a porta TCP **4560**.

No entanto, essas vias de comunicação são através do localhost (IP 127.0.0.1), ou seja, são transmitidas apenas dentro da máquina local, de forma que não há como acessá-las externamente.
Para isso, usamos o mavlink-router, um programa que transmite os pacotes MAVLink para um endereço na mesma rede Wi-FI. No nosso caso, ligamos a porta 14540 ou 14550 do localhost (127.0.0.1:14540 ou 127.0.0.1:14550) com a porta correspondente no computador 2 (usando o seu endereço IP na rede). Note que para isso ambos precisam estar conectados à mesma rede. Assim, ao conectar a mavros/QGC do computador em uma dessas portas, isso é equivalente a conectar na porta do localhost do computador 1, pois todos os pacotes são transmitidos pelo mavlink-router.  
