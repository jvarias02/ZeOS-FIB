/*
 * sys.c - Syscalls implementation
 */
#include <devices.h>

#include <utils.h>

#include <io.h>

#include <mm.h>

#include <mm_address.h>

#include <sched.h>

//#include <errno.h>

#define LECTURA 0
#define ESCRIPTURA 1

extern int zeos_ticks;

int check_fd(int fd, int permissions)
{
  if (fd!=1) return -9; /*EBADF*/
  if (permissions!=ESCRIPTURA) return -13; /*EACCES*/
  return 0;
}

int sys_ni_syscall()
{
	return -38; /*ENOSYS*/
}

int sys_getpid()
{
	return current()->PID;
}

int sys_fork()
{
  int PID=-1;

  // creates the child process
  
  return PID;
}

void sys_exit()
{  
}

char dest_buffer[512];


int sys_write(int fd, char * buffer, int size)
{
	int error_fd = check_fd(fd,ESCRIPTURA);
	if (error_fd < 0) return error_fd;

	if (buffer == NULL) return -14;
	if (size < 0) return -22;

	int bytes = size;
	int mida = 0;

	//Llegim de 512 en 512 bytes.
	while (bytes > 0) {
		//Si son menys de 512 bytes, ajustem la mida.
		if (bytes >= 512) mida = 512;
		else mida = bytes;

		copy_from_user(buffer, dest_buffer, mida);
		//Retorna num de bytes escrits
		int nbytes = sys_write_console(dest_buffer, mida);

		//bytes < 0 quan hagi acabat
		bytes -= 512;
		//Anem accedint a la direccio de memoria + els bytes llegits.
		buffer = buffer + nbytes;
	}

	return size;
}


int sys_gettime()
{
	return zeos_ticks;
}
