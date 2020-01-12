# server.py 
import socket                                         
import time
import latex2binary
# create a socket object
serversocket = socket.socket(
	        socket.AF_INET, socket.SOCK_STREAM) 


# get local machine name
host = socket.gethostname()                           

port = 8989                                      

# bind to the port
serversocket.bind((host, port))                                  

# queue up to 5 requests
serversocket.listen(5)                                           

l2b = latex2binary.Latex2binary()


while True:
    # establish a connection
    clientsocket,addr = serversocket.accept()      
    message = clientsocket.recv(1024) 
    message = message.decode('utf-8')
    print(message)
    binary = l2b.l2b(message)
    print("Got a connection from %s" % str(addr))
    # currentTime = time.ctime(time.time()) + "\r\n"
    clientsocket.send(binary.encode('ascii'))
    clientsocket.close()