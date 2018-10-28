#!/bin/sh
# Run using expect from path \
exec expect -f "$0" "$@"
# Above line is only executed by sh
set i 0; foreach n $argv {set [incr i] $n}
set pid [ spawn -noecho ssh $1@$3 ]
set timeout 30
expect {
    "(yes/no)" {
        sleep 1
        send "yes\n"
        exp_continue
    }
    "(y/n)" {
        sleep 1
        send "y\n"
        exp_continue
    }
    " password" {
        sleep 1
        send "$2\n"
        exp_continue
    }
    Password {
        sleep 1
        send "$2\n"
        exp_continue
    }
    "PRODUCTION" {
        send "sudo -v\n"
            expect {
                "password" {
                    sleep 1
                    send "$2\n"
                    puts "\n######### You have sudo access to host: $3 #########\n\n\n"
                    exp_continue
               }
               "Sorry" {
                    sleep 1
                    puts "\n######### You have non_sudo access to host: $3 #########\n\n\n"
                    exp_continue
               }
            }
        send "exit"
        exit 0
    }
    denied {
        puts "\n######### You gon't have ssh access to host: $3 #########\n\n\n"
        exit 1
    }
    timeout {
        puts "Timeout expired, aborting..."
        exit 1
    }
}