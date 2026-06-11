for((i=2;i<=7;i++)); do scp -r 192.168.1.$i:~/ebpf-probe/scripts/*.log . ; done
