# client.py  
import socket

# create a socket object
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM) 

# get local machine name
host = socket.gethostname()                           

port = 8989
 
def convert_latex_to_binary(latex_string):
	                           
	s.connect((host, port))   
	# send info 
	s.send(latex_string.rstrip().encode('utf-8'))

	# Receive no more than 1024 bytes
	message = s.recv(1024)                                     

	s.close()
	print(message.decode("utf-8"))


if __name__ == "__main__":
	message = input("Your latex string here:\n")
	convert_latex_to_binary(message)
