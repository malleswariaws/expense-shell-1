#!/bin/bash

source ./common.sh

check_root

echo "please enter DB password:"
read -s mysql_root_password

dnf install mysql-server -y &>>$LOGFILE
#VALIDATE $? "Installing MYSQL Server"

systemctl enable mysqld &>>$LOGFILE
#VALIDATE $? "Enabling MYSQL Server"

systemctl start mysqld &>>$LOGFILE
#VALIDATE $? "Starting MYSQL Server"

# mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
# VALIDATE $? "Setting up root password"

#Below code will be useful for idempotent nature
mysql -h db.malleswariaws.online -uroot -p${mysql_root_password} -e 'SHOW DATABASES;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "MYSQL Root password Setup"
else
    echo -e "MYSQL Root password is already setup...$Y SKIPPING $N"
fi