/*
	Play with namespaces - Angelo Poerio <angelo.poerio@gmail.com>
	This launches a "containerized" version of a shell bash.
	Cgroupss missing!
	Set permissions: setcap CAP_SYS_ADMIN+ep poor_man_container
	Usefulm command to check if your are containerized: ip a, ps aux
        Improvement: add support for mount namespace (CLONE_NEWNS)
*/

#define _GNU_SOURCE
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/mount.h>
#include <stdio.h>
#include <sched.h>
#include <signal.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>

#define STACK_SIZE (1024 * 1024 * 1024)

static char child_stack[STACK_SIZE];
char* const child_args[] = {
  "/bin/bash",
  NULL
};

int child_main(void* arg)
{
  mount("proc", "/proc", "proc", 0, NULL);
  sethostname("Container!", 10);
  execv(child_args[0], child_args);
  return 1;
}

int main()
{
  int child_pid = clone(child_main, child_stack+STACK_SIZE,
     CLONE_NEWUTS | CLONE_NEWIPC | CLONE_NEWPID | CLONE_NEWNET |SIGCHLD, NULL);
  
  if(child_pid == -1) {
  	printf("%s\n",strerror(errno));
  	return 1;
  }
  
  waitpid(child_pid, NULL, 0);
  return 0;
}
