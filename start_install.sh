#!/bin/bash

fun_start()
{
apt-get update
apt-get upgrade
apt-get install -y mc nano curl wget tree zip htop 
}

#******************************************************************************
fun_time()
{
apt-get install -y ntp
systemctl start ntp
systemctl enable ntp
timedatectl set-timezone Europe/Moscow
}

#*******************************************************************************
fun_lang()
{
apt-get install -y language-pack-ru
update-locale LANG=ru_RU.UTF-8
}

#*******************************************************************************
fun_add_user()
{
read -p "Dobavit novogo polzovatelja [y/n]" ans_add_user
if [ $ans_add_user = "y" -o $ans_add_user = "Y" -o $ans_add_user = "yes" -o $ans_add_user = "Yes" -o $ans_add_user = "YES" -o $ans_add_user = "ye" -o $ans_add_user = "Ye" -o $ans_add_user = "YE" ]
  then 
    read -p "Vvedite imja polzovatelja  " name
    adduser $name
      read -p "Dat' polzovatelju prava administratora (SUDO)? [y/n] " ans_sudo
        if [ $ans_sudo = "y" -o $ans_sudo = "Y" -o $ans_sudo = "yes" -o $ans_sudo = "Yes" -o $ans_sudo = "YES" -o $ans_sudo = "ye" -o $ans_sudo = "Ye" -o $ans_sudo = "YE" ] 
           then 
             usermod -a -G sudo $name
        fi
fi
}
#************************************************************************************
fun_fail2ban()
{
apt-get install -y fail2ban
systemctl start fail2ban
systemctl enable fail2ban
}

#************************************************************************************
fun_ssh()
{
read -p "Izmenit' nomer SSH porta? [y/n] " ans_ssh_port

if [ $ans_ssh_port = "y" -o $ans_ssh_port = "Y" -o $ans_ssh_port = "yes" -o $ans_ssh_port = "Yes" -o $ans_ssh_port = "YES" -o $ans_ssh_port = "ye" -o $ans_ssh_port = "Ye" -o $ans_ssh_port = "YE" ]
  then
   read -p "Vvedite nomer porta  " nom_port
   sed -i 's/Port 22/Port '$nom_port'/g' /etc/ssh/sshd_config
fi

read -p "Zapretit' administratoru vhod po SSH? [y/n] " ans_admin_ssh

if [ $ans_admin_ssh = "y" -o $ans_admin_ssh = "Y" -o $ans_admin_ssh = "yes" -o $ans_admin_ssh = "Yes" -o $ans_admin_ssh = "YES" -o $ans_admin_ssh = "ye" -o $ans_admin_ssh = "Ye" -o $ans_admin_ssh = "YE" ]
 then
  sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config 
 fi

read -p "Zapretit' vhod po SSH s pustym porolem? [y/n] " ans_ssh_null_parol
 
if [ $ans_ssh_null_parol = "y" -o $ans_ssh_null_parol = "Y" -o $ans_ssh_null_parol = "yes" -o $ans_ssh_null_parol = "Yes" -o $ans_ssh_null_parol = "YES" -o $ans_ssh_null_parol = "ye" -o $ans_ssh_null_parol = "Ye" -o $ans_ssh_null_parol = "YE" ]
 then
   sed -i 's/PermitEmptyPasswords yes/PermitEmptyPasswords no/g' /etc/ssh/sshd_config 
 fi
systemctl restart sshd
}

#**************************************************************************************
fun_reboot()
{
read  -p " Perezagruzit' server dlja vstuplenija izmenenij ? [y/n]"   ans_restart
  if [ $ans_restart = "y" -o $ans_restart = "Y" -o $ans_restart = "yes" -o $ans_restart = "Yes" -o $ans_restart = "YES" -o $ans_restart = "ye" -o $ans_restart = "Ye" -o $ans_restart = "YE" ]
    then
      reboot 
    else
       exit
  fi
}

#****************************************************************************************

fun_start
fun_time
fun_lang
fun_fail2ban
fun_add_user
fun_ssh
fun_reboot

