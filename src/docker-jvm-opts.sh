#!/bin/bash

# Return reasonable JVM options to run inside a Docker container where memory and
# CPU can be limited with cgroups.
# https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/parallel.html
#
# The script can be used in a custom CMD or ENTRYPOINT
#
# export _JAVA_OPTIONS=$(/usr/local/bin/docker-jvm-opts.sh)

# Options:
#   JVM_HEAP_RATIO=0.5 Ratio of heap size to available memory

# If Xmx is not set the JVM will use by default 1/4th (in most cases) of the host memory
# This can cause the Kernel to kill the container if the JVM memory grows over the cgroups limit
# because the JVM is not aware of that limit and doesn't invoke the GC
# Setting it by default to 0.8 times the memory limited by cgroups, customizable with JVM_HEAP_RATIO
CGROUPS_MEM=$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes)
MEMINFO_MEM=$(($(awk '/MemTotal/ {print $2}' /proc/meminfo)*1024))
MEM=$(($MEMINFO_MEM>$CGROUPS_MEM?$CGROUPS_MEM:$MEMINFO_MEM))
JVM_HEAP_RATIO=${JVM_HEAP_RATIO:-0.66}
JVM_XMX=$(awk '{printf("%d",$1*$2/1024^2)}' <<<" ${MEM} ${JVM_HEAP_RATIO} ")
JVM_XMS=$(awk '{printf("%d",$1*$2/1024^2/8)}' <<<" ${MEM} ${JVM_HEAP_RATIO} ")
JVM_XMN=$(awk '{printf("%d",$1*$2/1024^2/3)}' <<<" ${MEM} ${JVM_HEAP_RATIO} ")
JVM_XSS=1
