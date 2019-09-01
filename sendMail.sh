#for opening python in shell script
#python<<!
#print "hello"
#!




#this is to sent mail through python


# Python code to illustrate Sending mail from 
# your Gmail account 
#import smtplib
 
# creates SMTP session
#s = smtplib.SMTP('smtp.gmail.com', 587)
 
# start TLS for security
#s.starttls()
 
# Authentication
#s.login("sender_email_id", "sender_email_id_password")
 
# message to be sent
#message = "Message_you_need_to_send"
 
# sending the mail
#s.sendmail("sender_email_id", "receiver_email_id", message)
 
# terminating the session
#s.quit()


#print(mesaage)


python<<!
import smtplib
s = smtplib.SMTP('smtp.gmail.com',587)
s.starttls()
s.login("Enter Email ID", "Enter Password")
f = open('sent.txt','r')
message = f.read()
f.close()
s.sendmail("Enter Email ID", "breq_fast@iris.washington.edu",message)
s.quit
!

