# Building Docker image: Rocky Linux 9 with LAMP Stack

### Build your own image
`$ cd /the_directory_containing_Dockerfile/`\
`$ docker build -t rockylinux_lamp .`

or\
**Pull image from dockerhub**\
`$ docker pull hiepdng/rockylinux_lamp:latest`  


### Run the Containers
- **Apache container**
```
bash

docker run -d \
  --name rocky_lamp_web
  -p 8080:80
  rockylinux_lamp
```

- **MySQL container**
```
bash

docker run -d \
  --name rocky_lamp_db \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=your_root_password \
  -e MYSQL_USER=your_custom_username \
  -e MYSQL_PASSWORD=your_custom_password \
   rockylinux_lamp
```



### Basic docker commands:
```
$ docker pull <image_name>       – Pulls an image from dockerhub
$ docker image ls                – Lists all locally stored Docker images on your host system
$ docker run -d <image_name>     – Creates & starts a new Docker container from animage and runs it in the background
  docker run -it -d --name image_name <image_name>
$ docker ps                      – Lists all currently running Docker container IDs on your system
$ docker ps -a                   – lists all Docker container IDs on your system, regardless of their current status. 
$ docker stop <containerID>      – Gracefully shuts down a running Docker container
$ docker start <containerID>     – Resumes and boots up stopped Docker container

$ docker exec -it <containerID> bash – Opens an interactive command-line terminal (Bash) inside a Docker
                                       container that is already running.
```

<br><br>
### Build Rocky Linux 9 with systemd and pre-installed utilies:
You can build images with provided Dockerfile files:

- **Dockerfile_Networking_Tools** - Rocky Linux with networking Tools installed\
```
$ docker build -f Dockerfile_Networking_Tools -t rockylinux_networkingtools
$ docker run -d \
  --cgroupns=private \
  --privileged \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  rockylinux_networkingtools
```

- **Dockerfile_Development_Tools** - Rocky Linux with Development Tools installed\
```
$ docker build -f Dockerfile_Developement_Tools -t rockylinux_developementtools
$ docker run -d \
  --cgroupns=private \
  --privileged \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  rockylinux_developementtools
```

- **Dockerfile_System_Tools** - Rocky Linux with System Tools installed\
```
$ docker build -f Dockerfile_System_Tools -t rockylinux_systemtools
$ docker run -d \
  --cgroupns=private \
  --privileged \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  rockylinux_systemtools
```



