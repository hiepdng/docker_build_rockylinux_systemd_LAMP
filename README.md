## Building Docker image: Rocky Linux 9 with LAMP Stack

### Build your own image:
`$ cd /the_directory_containing_Dockerfile/`\
`$ docker build -t rockylinux_lamp .`  

or
### Pull image from dockerhub:
`$ docker pull hiepdng/rockylinux_lamp:latest`

<br/>

### Run the Containers:
- **Pre-configuration on host machine**
```
bash

mkdir -p  /home/app/apache/html
mkdir -p  /home/app/apache/log
chmod -R 777 mkdir -p  /home/app/apache
mkdir -p /home/app/mysql/data
mkdir -p /home/app/mysql/log 
```

- **Run both Apache and MySQL in one container**
```
bash

# Creating container:
docker run -d \
  --name rocky_lamp \
  --privileged \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  --cap-add=SYS_NICE \
  -p 8080:80 \
  -v /home/app/apache/html:/var/www/html \
  -v /home/app/apache/log:/var/log/httpd \
  -p 3306:3306 \
  -v /home/app/mysql/data:/var/lib/mysql \
  -v /home/app/mysql/log:/var/log/mysql \
  -e MYSQL_ROOT_PASSWORD="secretpassword" \
  -e MYSQL_USER="mysql" \
  -e MYSQL_PASSWORD="secretpassword" \
   rockylinux_lamp

# Running php-fpm, mysqld and httpd services:
docker exec -it <containerID> ./entrypoint.sh
```
- **Testing**  
Open a web browser and enter http://localhost:8080/index.php at the URL

<br/>

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

<br/>



