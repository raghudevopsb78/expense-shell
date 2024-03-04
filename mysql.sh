source common.sh

Print_Task_Heading "Install Nginx"
dnf install mysql-server -y &>>$LOG
Check_Status $?

Print_Task_Heading "Install Nginx"
systemctl enable mysqld &>>$LOG
systemctl start mysqld &>>$LOG
Check_Status $?

Print_Task_Heading "Install Nginx"
mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG
Check_Status $?
