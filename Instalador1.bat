echo  Instalador de la base de datos Universidad
echo  Autor:Frenssen Wolfran Delgado
echo 9 de agosto del 2022
sqlcmd -Slocalhost\SQLEXPRESS -E -i BDGeneral.sql
echo Se ejecuto correctamente
pause