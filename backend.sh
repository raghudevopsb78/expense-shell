mysql_root_password=$1

Print_Task_Heading() {
  echo $1
  echo "############### $1 ###############" &>>/tmp/expense.log
}

Print_Task_Heading "Disable default NodeJS Version Module"
dnf module disable nodejs -y &>>/tmp/expense.log
echo $?

Print_Task_Heading "Enable NodeJS module for V20"
dnf module enable nodejs:20 -y &>>/tmp/expense.log
echo $?

Print_Task_Heading "Install NodeJS"
dnf install nodejs -y &>>/tmp/expense.log
echo $?

Print_Task_Heading "Adding Application User"
useradd expense &>>/tmp/expense.log
echo $?

Print_Task_Heading "Copy Backend Service file"
cp backend.service /etc/systemd/system/backend.service &>>/tmp/expense.log
echo $?

Print_Task_Heading "Clean the Old Content"
rm -rf /app &>>/tmp/expense.log
echo $?

Print_Task_Heading "Create App Directory"
mkdir /app &>>/tmp/expense.log
echo $?

Print_Task_Heading "Download App Content"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/expense-backend-v2.zip &>>/tmp/expense.log
echo $?

Print_Task_Heading "Extract App Content"
cd /app &>>/tmp/expense.log
unzip /tmp/backend.zip &>>/tmp/expense.log
echo $?


Print_Task_Heading "Download NodeJS Dependencies"
cd /app &>>/tmp/expense.log
npm install &>>/tmp/expense.log
echo $?

Print_Task_Heading "Start Backend Service"
systemctl daemon-reload &>>/tmp/expense.log
systemctl enable backend &>>/tmp/expense.log
systemctl start backend &>>/tmp/expense.log
echo $?

Print_Task_Heading "Install MySQL Client"
dnf install mysql -y &>>/tmp/expense.log
echo $?

Print_Task_Heading "Load Schema"
mysql -h 172.31.13.27 -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>/tmp/expense.log
echo $?
