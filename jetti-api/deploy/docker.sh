
git remote add origin https://github.com/TishchenkoAlex/jettiClick.git

sudo docker run -e 'ACCEPT_EULA=Y' -e 'MSSQL_SA_PASSWORD=<YourStrong!Passw0rd>' \
   --name 'sql1' -p 1433:1433 \
   -v sql1data:/Users/at/Documents/sql \
   -d mcr.microsoft.com/mssql/server:2017-latest

sudo docker exec -it sql1 mkdir /var/opt/mssql/backup
sudo docker cp sm.bak sql1:/var/opt/mssql/backup

sudo docker exec -it sql1 /opt/mssql-tools/bin/sqlcmd -S localhost \
   -U SA -P '<YourStrong!Passw0rd>' \
   -Q 'RESTORE FILELISTONLY FROM DISK = "/var/opt/mssql/backup/sm.bak"' \
   | tr -s ' ' | cut -d ' ' -f 1-2

sudo docker exec -it sql1 /opt/mssql-tools/bin/sqlcmd \
   -S localhost -U SA -P '<YourStrong!Passw0rd>' \
   -Q 'RESTORE DATABASE [sm] FROM DISK = "/var/opt/mssql/backup/sm.bak" WITH FILE = 1,  MOVE "sm_Data" TO "/var/opt/mssql/data/sm.mdf",  MOVE "sm_Log" TO "/var/opt/mssql/data/sm.ldf"'
