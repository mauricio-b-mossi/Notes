- Images are recepies for runnning a container, think of them as a snapshot in terms of a VM. They determine 
how the container is constructed and which commands are run when you use the `docker run <image>`.

- Containers are the group of processes that run based on images.

`docker image ls`: Shows all images.
`docker ps`: Shows all running containers.
`docker ps -a`: Shows all containers, even stopped ones.

Summary: Images specify how a container is built and configured. When you run `docker run <image>`, you are spinning
up a container with the build specified in the image.

`docker stop <image-name/id>`: To stop a container.

Every container has a container ID which you can use to "ssh into the container", quotes indicate analogy. In reality, the 
ID lets you go into the container.

`docker run <image> -p <host-port>:<container-port>`: Maps the port from a container to a port on the host. This is to say
every container has its own ports, therefore it follows that the ports of the container are issolated from the host's ports.

`docker run <image> -d`: Runs image in detatched mode, meaning the terminal is free after execution, else you are stuck in 
docker logs.

`docker run <image> --name`: Specify another way to identify the container other than the default and automatic ID.

By default all the containers you run are not deleted even when stopped. To delete stopped containers use:
`docker container prune`: This will remove all stopped containers. Returns the IDs of the deleted containers.
`docker run <image> --rm`: This will remove the container when exited.

When you pull or run and image, it is a good idea to specify a tag or a digest, think of it as your package-lock.json, it 
specifies the specific version of the image you want to use. However, prefer digests over tags. Tags are symbolic links while
digests are unique sha hashes pointing to an image. 

To use tags just append a colon followed by the tag after the image name: `<image-name>:tag`.
To use digests just append an @ followed by the digest after the image name: `<<image-name>@digest`

To start a process in one container use `docker exec -it <container-id/name> <process>`, the process could be anything,
like `/bin/bash`, it must be an executable:
- `-it` means interative and tty. Interative means `stdin` stays open and TTy enambles stdout for the container into the host and other terminal features like autocomplete.

### Volumnes and Mounts
Each time a container is run, it runs fresh, this is to say by default it runs according to the `Dockerfile`. Therefore,
data is not persisted. To persist data you can use *volumes* or *bind mounts*. Volumes are stored by the container, while
*bind mounts* are stored in the host os. Therefore *volumnes* directly alter the container while *bind-mounts* alter only 
the user system leaving the container intact. Therefore with bind-mounts every user can pass their own data to be written or 
retrieved from.

To use a volume use `docker run -v <volume-name>:/path/in/cointainer`. This will store everything writen to the `/path/in/container` in 
the container. It will persist between runs.

To use a volume use `docker run -v ./<local-folder>:/path/in/cointainer`. This will store everything written to `/path/in/container` into
the `<local-folder>` in your system.
